<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
Call DbOpen()

' -------------------------------
' 유틸
' -------------------------------
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = CStr(v)
End Function

Function ToLng(v, def)
  If IsNumeric(v) Then ToLng = CLng(v) Else ToLng = def
End Function

Function SqlStr(s)
  SqlStr = Replace(Nz(s), "'", "''")
End Function

' 배열이 1개만 넘어와도 안전하게 꺼내기
Function FormAt(key, idx)
  Dim v
  On Error Resume Next
  v = Request.Form(key)(idx)
  If Err.Number <> 0 Then
    Err.Clear
    If idx = 1 Then v = Request.Form(key)
  End If
  On Error GoTo 0
  FormAt = Nz(v)
End Function

Function FormCount(key)
  Dim n, one
  n = 0
  On Error Resume Next
  n = Request.Form(key).Count
  If Err.Number <> 0 Then
    Err.Clear
    one = Trim(Nz(Request.Form(key)))
    If one <> "" Then n = 1 Else n = 0
  End If
  On Error GoTo 0
  FormCount = n
End Function

Sub JsonDie(msg)
  Response.Write "{""ok"":false,""msg"":""" & Replace(msg, """", "\""") & """}"
  On Error Resume Next
  Call DbClose()
  Response.End
End Sub

' -------------------------------
' 필수 파라미터
' -------------------------------
Dim list_title_id, master_id, row_id_param, row_id, isUpdate
list_title_id = ToLng(Request("list_title_id"), 0)
master_id     = ToLng(Request("master_id"), 0)
row_id_param  = ToLng(Request("row_id"), 0)

If list_title_id <= 0 Then Call JsonDie("INVALID_LIST_TITLE")
If master_id <= 0 Then Call JsonDie("INVALID_MASTER")

Dim n
n = FormCount("title_sub_id[]")
If n = 0 Then Call JsonDie("EMPTY_VALUE")

isUpdate = (row_id_param > 0)

' -------------------------------
' list_title_id에 속한 title_sub_id들 미리 로딩(검증용)
' -------------------------------
Dim validSub
Set validSub = Server.CreateObject("Scripting.Dictionary")

Dim rsSub, sqlSub
Set rsSub = Server.CreateObject("ADODB.Recordset")
sqlSub = "SELECT title_sub_id FROM bom3_list_title_sub WHERE list_title_id=" & list_title_id & " AND is_active=1"
rsSub.Open sqlSub, Dbcon

Do While Not rsSub.EOF
  validSub(CStr(CLng(rsSub("title_sub_id")))) = True
  rsSub.MoveNext
Loop

rsSub.Close : Set rsSub = Nothing

If validSub.Count = 0 Then Call JsonDie("NO_ACTIVE_TITLE_SUB")

' -------------------------------
' 트랜잭션 시작
' -------------------------------
On Error Resume Next
Dbcon.BeginTrans
Err.Clear

' -------------------------------
' row_id 결정
' - 수정: 넘어온 row_id 사용
' - 신규: MAX(row_id)+1 생성(락으로 동시성 방지)
' -------------------------------
If isUpdate Then
  row_id = row_id_param
Else
  Dim RsRow
  Set RsRow = Server.CreateObject("ADODB.Recordset")

  RsRow.Open _
    "SELECT ISNULL(MAX(row_id),0)+1 AS next_id " & _
    "FROM bom3_title_sub_value WITH (UPDLOCK, HOLDLOCK)", Dbcon

  If Err.Number <> 0 Then
    Dbcon.RollbackTrans
    Call JsonDie("ROW_ID_FAIL: " & Err.Description)
  End If

  row_id = CLng(RsRow("next_id"))
  RsRow.Close
  Set RsRow = Nothing
End If

' -------------------------------
' UPSERT 루프
' row_id + title_sub_id 기준으로
'  - 있으면 UPDATE
'  - 없으면 INSERT
'  - 값이 ""면 UPDATE로 is_active=0 (삭제 느낌)
' -------------------------------
Dim idsMap
Set idsMap = Server.CreateObject("Scripting.Dictionary")

Dim i, title_sub_id, sub_value
Dim rsExist, sqlExist, existId

For i = 1 To n

  title_sub_id = ToLng(FormAt("title_sub_id[]", i), 0)
  sub_value    = Trim(FormAt("sub_value[]", i))

  If title_sub_id <= 0 Then
    Dbcon.RollbackTrans
    Call JsonDie("INVALID_TITLE_SUB_ID")
  End If

  ' list_title_id 소속 검증
  If Not validSub.Exists(CStr(title_sub_id)) Then
    Dbcon.RollbackTrans
    Call JsonDie("TITLE_SUB_NOT_IN_LIST")
  End If

  existId = 0

  ' 기존 레코드 존재 확인(활성/비활성 모두 포함해서 1개 잡기)
  Set rsExist = Server.CreateObject("ADODB.Recordset")
  sqlExist = _
    "SELECT TOP 1 sub_value_id " & _
    "FROM bom3_title_sub_value WITH (UPDLOCK, HOLDLOCK) " & _
    "WHERE row_id=" & row_id & " AND title_sub_id=" & title_sub_id & " " & _
    "ORDER BY sub_value_id DESC"

  rsExist.Open sqlExist, Dbcon
  If Not rsExist.EOF Then
    existId = CLng(rsExist("sub_value_id"))
  End If
  rsExist.Close : Set rsExist = Nothing

' 값이 비어있으면 -> 있으면 비활성화, 없으면 스킵
  If sub_value = "" Then
    If existId > 0 Then
      Err.Clear
      Dbcon.Execute _
        "UPDATE bom3_title_sub_value " & _
        "SET sub_value = NULL, " & _
        "    is_active = 0, " & _
        "    master_id = " & master_id & ", " & _
        "    udate = GETDATE() " & _
        "WHERE sub_value_id = " & existId

      If Err.Number <> 0 Then
        Dbcon.RollbackTrans
        Call JsonDie("UPDATE_FAIL: " & Err.Description)
      End If

      idsMap(CStr(title_sub_id)) = existId
    Else
      idsMap(CStr(title_sub_id)) = 0
    End If

  Else
    ' 값이 있으면 -> 있으면 UPDATE, 없으면 INSERT
    If existId > 0 Then
      Err.Clear
      Dbcon.Execute _
        "UPDATE bom3_title_sub_value " & _
        "SET sub_value = N'" & SqlStr(sub_value) & "', " & _
        "    is_active = 1, " & _
        "    master_id = " & master_id & ", " & _
        "    udate = GETDATE() " & _
        "WHERE sub_value_id = " & existId

      If Err.Number <> 0 Then
        Dbcon.RollbackTrans
        Call JsonDie("UPDATE_FAIL: " & Err.Description)
      End If

      idsMap(CStr(title_sub_id)) = existId

    Else
      Dim rsNew, sqlIns
      Set rsNew = Server.CreateObject("ADODB.Recordset")

      sqlIns = _
        "INSERT INTO bom3_title_sub_value " & _
        "(row_id, title_sub_id, master_id, sub_value, is_active, cdate ) " & _
        "OUTPUT INSERTED.sub_value_id " & _
        "VALUES (" & _
          row_id & ", " & _
          title_sub_id & ", " & _
          master_id & ", N'" & SqlStr(sub_value) & "', 1, GETDATE()" & _
        ");"

      rsNew.Open sqlIns, Dbcon
      If Err.Number <> 0 Then
        Dbcon.RollbackTrans
        Call JsonDie("INSERT_FAIL: " & Err.Description)
      End If

      idsMap(CStr(title_sub_id)) = CLng(rsNew("sub_value_id"))

      rsNew.Close : Set rsNew = Nothing
    End If
  End If

Next

If Err.Number <> 0 Then
  Dbcon.RollbackTrans
  Call JsonDie("UNKNOWN_FAIL: " & Err.Description)
End If

Dbcon.CommitTrans
On Error GoTo 0

' -------------------------------
' JSON 응답
' -------------------------------
Dim jsonIds, k, first
jsonIds = "{"
first = True
For Each k In idsMap.Keys
  If Not first Then jsonIds = jsonIds & ","
  first = False
  jsonIds = jsonIds & """" & k & """:" & CLng(idsMap(k))
Next
jsonIds = jsonIds & "}"

Response.Write "{""ok"":true,""mode"":""" & IIf(isUpdate,"update","insert") & """,""row_id"":" & row_id & ",""ids"":" & jsonIds & "}"

Call DbClose()

' VBScript IIf 없으면 필요(네가 이미 쓰고 있으면 삭제해도 됨)
Function IIf(expr, a, b)
  If expr Then IIf = a Else IIf = b
End Function
%>
