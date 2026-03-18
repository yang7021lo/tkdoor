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
ridx=Request("ridx")
cidx=Request("cidx")
SearchWord=Request("SearchWord")
desc=Request("desc")
udt=request("udt")
clickacfidx=Request("clickacfidx")
clickaacfidx=Request("clickaacfidx")


'response.write cidx
'response.end


SQL=" Insert into tk_reportsendsub (snidx, ridx) "
SQL=SQL&" Values ('"&snidx&"', '"&ridx&"') "
Dbcon.Execute (SQL)

if udt<>"" then
response.write "<script>opener.location.replace('sendmailre.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');location.replace('rsendselect.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"&desc="&desc&"&clickacfidx="&clickacfidx&"&clickaacfidx="&clickaacfidx&"');</script>"
else
response.write "<script>opener.location.replace('sendmail.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"');location.replace('rsendselect.asp?SearchWord="&SearchWord&"&snidx="&snidx&"&cidx="&cidx&"&desc="&desc&"&clickacfidx="&clickacfidx&"&clickaacfidx="&clickaacfidx&"');</script>"
end if


set Rs=Nothing
call dbClose()

%>


