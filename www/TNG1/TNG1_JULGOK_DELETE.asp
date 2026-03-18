<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

Dim baidx
baidx = Request("baidx")

If baidx = "" Then
    Response.Write "{""success"": false, ""error"": ""baidx is required""}"
    Response.End
End If

On Error Resume Next

' tk_barasisub 먼저 삭제 (자식 테이블)
Dbcon.Execute "DELETE FROM tk_barasisub WHERE baidx = '" & Replace(baidx, "'", "''") & "'"

' tk_barasi 삭제 (부모 테이블)
Dbcon.Execute "DELETE FROM tk_barasi WHERE baidx = '" & Replace(baidx, "'", "''") & "'"

If Err.Number = 0 Then
    Response.Write "{""success"": true, ""baidx"": " & baidx & "}"
Else
    Response.Write "{""success"": false, ""error"": """ & Replace(Err.Description, """", "\""") & """}"
End If

On Error Goto 0

call dbClose()
%>
