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

snidx=Request("snidx")
cidx=Request("cidx")

'response.write snidx
'response.end


SQL=" Update tk_reportsend set sndate=getdate() Where snidx='"&snidx&"' "
Dbcon.Execute (SQL)


response.write "<script>window.close();opener.location.replace('sendemail.asp?snidx="&snidx&"&cidx="&cidx&"');</script>"

set Rs=Nothing
call dbClose()

%>


