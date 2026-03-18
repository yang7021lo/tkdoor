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
column = Request("column")
value = Request("value")

If id <> "" AND id_1 <> "" AND column <> "" AND value <> "" Then
    sql = "UPDATE TNG_SJst2 SET " & column & " = '" & value & "' WHERE id = '" & id & "' AND id_1 = " & id_1
    Dbcon.Execute sql
End If

call dbClose()
%>
