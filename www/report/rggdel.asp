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
rgidx=request("rgidx")
'Response.write rgidx&"<br>"
'Response.end

Sql="Delete From tk_reportg where rgidx='"&rgidx&"' "
Dbcon.Execute (Sql)

Response.write "<script>location.replace('remaingroup.asp');</script>"
Response.end
%>

<%
set Rs=Nothing
call dbClose()
%>