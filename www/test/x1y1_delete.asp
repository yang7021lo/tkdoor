<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

id = Request("id")
id_1 = Request("id_1")

If id <> "" AND id_1 <> "" Then
    sql = "DELETE FROM TNG_SJst2 WHERE id = '" & id & "' AND id_1 = " & id_1
    Dbcon.Execute sql
End If

Response.Redirect "x1y1.asp?id=" & id
call dbClose()
%>
