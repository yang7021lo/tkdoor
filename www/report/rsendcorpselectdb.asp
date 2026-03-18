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
cname=Request("cname")
udt=request("udt")
SearchWord=Request("SearchWord")

'response.write cidx
'response.end


SQL=" Insert into tk_reportsendcorpSub (snidx, cidx, cname) "
SQL=SQL&" Values ('"&snidx&"', '"&cidx&"', '"&cname&"' ) "

Dbcon.Execute (SQL)

if udt<>"" then
response.write "<script>opener.location.replace('sendmailre.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');location.replace('rsendcorpselect.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');</script>"
else
response.write "<script>opener.location.replace('sendmail.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');location.replace('rsendcorpselect.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');</script>"
end if

set Rs=Nothing
call dbClose()

%>


