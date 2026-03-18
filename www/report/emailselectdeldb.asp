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
esidx=Request("esidx")
SearchWord=Request("SearchWord")
udt=Request("udt")

'response.write udt

'response.write cidx
'response.end


SQL=" Delete from tk_emailselect "
SQL=SQL&" Where esidx='"&esidx&"' "
Dbcon.Execute (SQL)

if udt<>"" then 
response.write "<script>opener.location.replace('sendmailre.asp?snidx="&snidx&" ');location.replace('emailselectre.asp?SearchWord="&SearchWord&"&snidx="&snidx&" ');</script>"
else
response.write "<script>opener.location.replace('sendmail.asp?SearchWord="&SearchWord&"&snidx="&snidx&" ');location.replace('emailselect.asp?SearchWord="&SearchWord&"&snidx="&snidx&" ');</script>"
end if


set Rs=Nothing
call dbClose()

%>
