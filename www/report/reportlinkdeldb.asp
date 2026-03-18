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
rlisx=Request("rlisx")
sjbidx=Request("sjbidx")
gotopage=Request("gotopage")

'response.end


SQL=" Delete reportlink where rlisx='"&rlisx&"' "
Dbcon.Execute (SQL)

response.write "<script>opener.location.replace('remain2.asp?gotopage="&gotopage&"&ridx="&ridx&"');location.replace('reportlink.asp?gotopage="&gotopage&"&ridx="&ridx&"');</script>"

set Rs=Nothing
call dbClose()

%>
