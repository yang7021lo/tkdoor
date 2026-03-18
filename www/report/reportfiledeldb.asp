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
ridx=request("ridx")
'Response.write ridx&"<br>"
'Response.end

SQL="Update tk_report set rfile=NULL where ridx='"&ridx&"' "
Dbcon.Execute (SQL)

response.write "<script>location.replace('remain2.asp?ridx="&ridx&"');</script>"

'Response.end
%>

<%
set Rs=Nothing
call dbClose()
%>