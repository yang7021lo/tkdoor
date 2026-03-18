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
udt=Request("udt")
temp=Request("temp")
gotopage=Request("gotopage")

'response.write snsidx
'response.end


SQL=" Update tk_reportsend set snsendstatus='0' where snidx='"&snidx&"' "
Dbcon.Execute (SQL)

if temp<>"" then
response.write "<script>location.replace('mailtemplist.asp?gotopage="&gotopage&" ');</script>"
else
    if udt<>"" then
    response.write "<script>location.replace('totalreport.asp?cidx="&cidx&"');</script>"
    else
    response.write "<script>window.close();opener.location.replace('totalreport.asp?cidx="&cidx&"');</script>"
    end if
end if


set Rs=Nothing
call dbClose()

%>


