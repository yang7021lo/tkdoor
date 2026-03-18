
<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")




afidx=Request("afidx")
cidx=Request("cidx")
aidx=Request("aidx")

response.write afidx&"<br>"
response.write cidx&"<br>"
response.write aidx&"<br>"



SQL="update tk_advice set astatus=0 where aidx='"&aidx&"'"
Response.Write SQL&"<br>"
 
Dbcon.Execute(SQL)



response.write "<script>opener.location.reload(); window.close();</script>"
set Rs=Nothing
call dbClose()
%>
