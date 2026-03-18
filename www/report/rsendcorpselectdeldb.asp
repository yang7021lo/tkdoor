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

snsidx=Request("snsidx")
snidx=Request("snidx")
cidx=Request("cidx")
udt=Request("udt")

'response.write snsidx
'response.end


SQL=" Delete from tk_reportsendcorpSub where snsidx='"&snsidx&"' "
Dbcon.Execute (SQL)


if udt<>"" then
response.write "<script>location.replace('sendmailre.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');</script>"
else
response.write "<script>location.replace('sendmail.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');</script>"
end if

set Rs=Nothing
call dbClose()

%>


