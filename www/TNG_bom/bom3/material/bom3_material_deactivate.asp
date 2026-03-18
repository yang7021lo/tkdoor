<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Response.ContentType = "text/plain"
Call DbOpen()

' ===== 공통 응답 함수 (텍스트만) =====
Sub ReturnText(txt)
    Response.Write txt
    Call DbClose()
    Response.End
End Sub

' ===== 파라미터 체크 =====
Dim material_id
If IsNumeric(Request("material_id")) Then
    material_id = CLng(Request("material_id"))
Else
    ReturnText "ERROR|INVALID_ID"
End If

Dim sql1, sql2, rows1, rows2
rows1 = 0 : rows2 = 0

sql1 = "UPDATE bom3_material " & _
       "SET is_active = 0, udate = GETDATE() " & _
       "WHERE material_id = " & material_id & " AND is_active = 1"

sql2 = "UPDATE bom3_table_value " & _
       "SET is_active = 0, udate = GETDATE() " & _
       "WHERE material_id = " & material_id & " AND is_active = 1"

On Error Resume Next
Err.Clear

' ===== 트랜잭션 시작 =====
Dbcon.BeginTrans
If Err.Number <> 0 Then
    On Error GoTo 0
    ReturnText "ERROR|BEGINTRANS_ERROR"
End If

' 1) material
Dbcon.Execute sql1, rows1
If Err.Number <> 0 Then
    Dbcon.RollbackTrans
    On Error GoTo 0
    ReturnText "ERROR|SQL1_ERROR"
End If

' 2) table_value
Dbcon.Execute sql2, rows2
If Err.Number <> 0 Then
    Dbcon.RollbackTrans
    On Error GoTo 0
    ReturnText "ERROR|SQL2_ERROR"
End If

' ===== 커밋 =====
Dbcon.CommitTrans
If Err.Number <> 0 Then
    Dbcon.RollbackTrans
    On Error GoTo 0
    ReturnText "ERROR|COMMIT_ERROR"
End If

On Error GoTo 0

' (선택) rows1=0 이면 이미 비활성/없는 데이터일 수도 있음
' 원하면 여기서 NOT_FOUND 처리 가능:
' If rows1 = 0 Then ReturnText "ERROR|NOT_FOUND"

ReturnText "OK"
%>
