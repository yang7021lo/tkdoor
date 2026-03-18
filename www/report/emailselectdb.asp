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
midx=Request("midx")
memail=Request("memail")
mname=Request("mname")
SearchWord=Request("SearchWord")
udt=Request("udt")

'response.write udt

'response.write cidx
'response.end


SQL=" Insert into tk_emailselect (snidx, cidx, memail, midx, mname) "
SQL=SQL&" Values ('"&snidx&"', '"&cidx&"', '"&memail&"', '"&midx&"', '"&mname&"') "
Dbcon.Execute (SQL)

if udt<> "" then
response.write "<script>opener.location.replace('sendmailre.asp?snidx="&snidx&"&cidx="&cidx&"');location.replace('emailselectre.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');</script>"
else
response.write "<script>opener.location.replace('sendemail.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');location.replace('emailselect.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');</script>"
end if

set Rs=Nothing
call dbClose()

%>
