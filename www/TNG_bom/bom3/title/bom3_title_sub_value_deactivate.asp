<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Response.Buffer = True
Call DbOpen()

' ===============================
' 유틸
' ===============================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = CStr(v)
End Function

Function ToLng(v, def)
  If IsNumeric(v) Then ToLng = CLng(v) Else ToLng = def
End Function

Function JsonEsc(s)
  Dim t
  t = Nz(s)
  t = Replace(t, "\", "\\")
  t = Replace(t, """", "\""")
  t = Replace(t, vbCrLf, "\n")
  t = Replace(t, vbCr, "\n")
  t = Replace(t, vbLf, "\n")
  JsonEsc = t
End Function

Function HtmlEsc(s)
  Dim t
  t = Nz(s)
  t = Replace(t, "&", "&amp;")
  t = Replace(t, "<", "&lt;")
  t = Replace(t, ">", "&gt;")
  t = Replace(t, """", "&quot;")
  HtmlEsc = t
End Function

Sub AddLog(ByRef logText, s)
  If Len(logText) > 0 Then logText = logText & vbCrLf
  logText = logText & s
End Sub

' ===============================
' 응답 모드 (JSON / HTML)
' view=html 이면 브라우저에서 로그 바로 확인 가능
' ===============================
Dim isHtmlView
isHtmlView = (LCase(Trim(Request("view"))) = "html")

Sub OutFail(msg, logText)
  If isHtmlView Then
    Response.ContentType = "text/html"
    Response.Status = "400 Bad Request"
    Response.Write "<meta charset='utf-8'>"
    Response.Write "<div style='font-family:consolas,monospace;font-size:14px;line-height:1.5'>"
    Response.Write "<b style='color:#c00'>ERROR:</b> " & HtmlEsc(msg) & "<hr>"
    Response.Write "<pre style='white-space:pre-wrap'>" & HtmlEsc(logText) & "</pre>"
    Response.Write "</div>"
    Call DbClose()
    Response.End
  Else
    Response.ContentType = "application/json"
    Response.Status = "400 Bad Request"
    Response.Write "{""ok"":false,""message"":""" & JsonEsc(msg) & """,""log"":""" & JsonEsc(logText) & """}"
    Call DbClose()
    Response.End
  End If
End Sub

Sub OutOk(msg, logText, isRollback, rows1, rows2)
  If isHtmlView Then
    Response.ContentType = "text/html"
    Response.Write "<meta charset='utf-8'>"
    Response.Write "<div style='font-family:consolas,monospace;font-size:14px;line-height:1.5'>"
    Response.Write "<b style='color:green'>OK</b> : " & HtmlEsc(msg) & "<br>"
    Response.Write "<b>rollback</b> : " & LCase(CStr(isRollback)) & "<br>"
    Response.Write "<b>rows1</b> : " & CLng(rows1) & ", <b>rows2</b> : " & CLng(rows2) & "<hr>"
    Response.Write "<pre style='white-space:pre-wrap'>" & HtmlEsc(logText) & "</pre>"
    Response.Write "</div>"
    Call DbClose()
    Response.End
  Else
    Response.ContentType = "application/json"
    Response.Write "{""ok"":true,""message"":""" & JsonEsc(msg) & """,""rollback"":" & LCase(CStr(isRollback)) & _
                   ",""rows1"":" & CLng(rows1) & ",""rows2"":" & CLng(rows2) & _
                   ",""log"":""" & JsonEsc(logText) & """}"
    Call DbClose()
    Response.End
  End If
End Sub

' ===============================
' UPDATE 실행 + @@ROWCOUNT로 영향 행 수 확정
' (recordsAffected(-1) 문제 방지)
' ===============================
Function ExecUpdateGetRowCount(sqlUpdate, ByRef logText, label)
  Dim rs, sqlBatch, cnt
  cnt = 0
  sqlBatch = "SET NOCOUNT ON; " & sqlUpdate & "; SELECT @@ROWCOUNT AS cnt;"

  Err.Clear
  Set rs = Dbcon.Execute(sqlBatch)
  Call AddLog(logText, label & " SQL: " & sqlUpdate)

  If Err.Number <> 0 Then
    Call AddLog(logText, label & " ERROR: " & Err.Description)
    ExecUpdateGetRowCount = -1
    Exit Function
  End If

  If Not rs Is Nothing Then
    If Not rs.EOF Then cnt = ToLng(rs("cnt"), 0)
    rs.Close
    Set rs = Nothing
  End If

  Call AddLog(logText, label & " rowcount: " & cnt)
  ExecUpdateGetRowCount = cnt
End Function

' ===============================
' 파라미터 (row_id / sub_value_id 둘 다 지원)
' ===============================
Dim row_id, sub_value_id, master_id, isDebug, logText
row_id       = ToLng(Trim(Request("row_id")), 0)
sub_value_id = ToLng(Trim(Request("sub_value_id")), 0)
master_id    = ToLng(Trim(Request("master_id")), 0)
isDebug      = (Trim(Request("debug")) = "1")
logText      = ""

Dim isRowMode
isRowMode = (row_id > 0)

Dim viewText
If isHtmlView Then viewText = "html" Else viewText = "json"

Call AddLog(logText, "PARAM row_id=" & row_id & ", sub_value_id=" & sub_value_id & ", master_id=" & master_id & ", debug=" & CStr(isDebug) & ", view=" & viewText)

' ✅ IIf 대신 If 문으로 MODE 로그 출력
If isRowMode Then
  Call AddLog(logText, "MODE: ROW_MODE")
Else
  Call AddLog(logText, "MODE: SUBVALUE_MODE")
End If

If (Not isRowMode) And sub_value_id <= 0 Then
  Call OutFail("INVALID_PARAM (need row_id or sub_value_id)", logText)
End If

' master_id 조건: 조회팝업과 동일하게 NULL(공통)도 허용
Dim whereMasterNoAlias, whereMasterV
whereMasterNoAlias = ""
whereMasterV = ""
If master_id > 0 Then
  whereMasterNoAlias = " AND (master_id IS NULL OR master_id = " & master_id & ")"
  whereMasterV       = " AND (v.master_id IS NULL OR v.master_id = " & master_id & ")"
End If

' ===============================
' 트랜잭션 시작
' ===============================
On Error Resume Next
Err.Clear
Dbcon.BeginTrans
If Err.Number <> 0 Then
  Call OutFail("BEGINTRANS_FAIL: " & Err.Description, logText)
End If
Call AddLog(logText, "BeginTrans OK")

' ===============================
' 0) 대상 확인 로그
' ===============================
Dim rsChk, sqlChk
If isRowMode Then
  sqlChk = "SELECT COUNT(*) AS cnt " & _
           "FROM dbo.bom3_title_sub_value v " & _
           "WHERE v.row_id = " & row_id & " AND v.is_active = 1" & whereMasterV
  Err.Clear
  Set rsChk = Dbcon.Execute(sqlChk)
  If Err.Number = 0 Then
    If Not rsChk.EOF Then
      Call AddLog(logText, "TARGET_ROW: active_sub_values=" & ToLng(rsChk("cnt"), 0))
    End If
    rsChk.Close
  End If
  Set rsChk = Nothing
Else
  sqlChk = "SELECT sub_value_id, master_id, title_sub_id, sub_value, is_active " & _
           "FROM dbo.bom3_title_sub_value WHERE sub_value_id = " & sub_value_id
  Err.Clear
  Set rsChk = Dbcon.Execute(sqlChk)
  If Err.Number = 0 Then
    If Not rsChk.EOF Then
      Call AddLog(logText, "TARGET: sub_value_id=" & rsChk("sub_value_id") & _
                          ", master_id=" & rsChk("master_id") & _
                          ", title_sub_id=" & rsChk("title_sub_id") & _
                          ", sub_value=" & Nz(rsChk("sub_value")) & _
                          ", is_active=" & rsChk("is_active"))
    Else
      Call AddLog(logText, "TARGET: not found in bom3_title_sub_value (before update)")
    End If
    rsChk.Close
  End If
  Set rsChk = Nothing
End If

' ===============================
' 1) bom3_title_sub_value 소프트 삭제
' ===============================
Dim sql1, rows1
rows1 = 0

If isRowMode Then
  sql1 = "UPDATE dbo.bom3_title_sub_value " & _
         "SET is_active = 0, udate = GETDATE() " & _
         "WHERE row_id = " & row_id & " AND is_active = 1" & whereMasterNoAlias
Else
  sql1 = "UPDATE dbo.bom3_title_sub_value " & _
         "SET is_active = 0, udate = GETDATE() " & _
         "WHERE sub_value_id = " & sub_value_id & " AND is_active = 1" & whereMasterNoAlias
End If

rows1 = ExecUpdateGetRowCount(sql1, logText, "SQL1")
If rows1 < 0 Then
  Dbcon.RollbackTrans
  Call AddLog(logText, "ROLLBACK (SQL1 ERROR)")
  Call OutFail("DELETE_FAIL: " & Err.Description, logText)
End If

If CLng(rows1) = 0 Then
  Dbcon.RollbackTrans
  Call AddLog(logText, "ROLLBACK (NOT_FOUND_OR_ALREADY_INACTIVE OR MASTER_MISMATCH)")
  Call OutFail("NOT_FOUND_OR_ALREADY_INACTIVE", logText)
End If

' ===============================
' 2) 참조 테이블 소프트 삭제 (bom3_table_value)
' - row_mode면 v.is_active 조건 걸면 안 됨(방금 0으로 바꿨으니까)
' ===============================
Dim sql2, rows2
rows2 = 0

If isRowMode Then
  sql2 = "UPDATE tv " & _
         "SET tv.is_active = 0, tv.udate = GETDATE() " & _
         "FROM dbo.bom3_table_value tv " & _
         "JOIN dbo.bom3_title_sub_value v ON v.sub_value_id = tv.title_sub_value_id " & _
         "WHERE v.row_id = " & row_id & " AND tv.is_active = 1" & whereMasterV
Else
  sql2 = "UPDATE dbo.bom3_table_value " & _
         "SET is_active = 0, udate = GETDATE() " & _
         "WHERE title_sub_value_id = " & sub_value_id & " AND is_active = 1"
End If

rows2 = ExecUpdateGetRowCount(sql2, logText, "SQL2")
If rows2 < 0 Then
  Dbcon.RollbackTrans
  Call AddLog(logText, "ROLLBACK (SQL2 ERROR)")
  Call OutFail("CASCADE_FAIL: " & Err.Description, logText)
End If

' ===============================
' debug=1 이면 롤백 / 아니면 커밋
' ===============================
If isDebug Then
  Err.Clear
  Dbcon.RollbackTrans
  Call AddLog(logText, "DEBUG=1 -> ROLLBACK DONE (DB 반영 안됨)")
  If Err.Number <> 0 Then
    Call OutFail("ROLLBACK_FAIL: " & Err.Description, logText)
  End If
  Call OutOk("DELETED (ROLLED BACK)", logText, True, rows1, rows2)
Else
  Err.Clear
  Dbcon.CommitTrans
  Call AddLog(logText, "COMMIT DONE (DB 반영됨)")
  If Err.Number <> 0 Then
    Dbcon.RollbackTrans
    Call AddLog(logText, "ROLLBACK (COMMIT ERROR)")
    Call OutFail("COMMIT_FAIL: " & Err.Description, logText)
  End If
  Call OutOk("DELETED", logText, False, rows1, rows2)
End If
%>
