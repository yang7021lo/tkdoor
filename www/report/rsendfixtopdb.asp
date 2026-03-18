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

ridx=Request("ridx")
added=Request("added")
SearchWord=Request("SearchWord")
clickacfidx=Request("clickacfidx")
clickaacfidx=Request("clickaacfidx")

'response.write snsidx
'response.end

if added = 1 then
SQL=" Update tk_report set rfixtop='1' Where ridx="&ridx&" "
else
SQL=" Update tk_report set rfixtop='0' Where ridx="&ridx&" "
end if
Dbcon.Execute (SQL)


response.write "<script>location.replace('remainlistorg2.asp?ridx="&ridx&"&clickaacfidx="&clickaacfidx&"&clickacfidx="&clickacfidx&"');</script>"


set Rs=Nothing
call dbClose()

%>


