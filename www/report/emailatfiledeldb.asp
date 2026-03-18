<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
    call dbOpen()
    Set Rs = Server.CreateObject ("ADODB.Recordset")
%>
<%
efidx=request("efidx")
snidx=request("snidx")
'Response.write rgidx&"<br>"
'Response.end

Sql="Delete From tk_emailatfile where efidx="&efidx&" "
Dbcon.Execute (Sql)

Response.write "<script>location.replace('rsend.asp?snidx="&snidx&"');</script>"
Response.end
%>

<%
set Rs=Nothing
call dbClose()
%>