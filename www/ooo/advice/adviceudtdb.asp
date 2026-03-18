
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
%>

<%
aidx=Request("aidx")
acheorigubun=encodestr(Request("acheorigubun"))
aform=encodestr(Request("aform"))
agubun=encodestr(Request("agubun"))
aclaim=encodestr(Request("aclaim"))
aname=encodestr(Request("aname"))
acidx=encodestr(Request("acidx"))
adetails=encodestr(Request("adetails"))
acheoriname=c_midx

acheorimemo=encodestr(Request("acheorimemo"))



'Response.write acheorigubun&"<br>"
'Response.write aform&"<br>"
'Response.write agubun&"<br>"
'Response.write aclaim&"<br>"
'Response.write aname&"<br>"
'Response.write adate&"<br>"
'Response.write adetails&"<br>"
'Response.write acheoriname&"<br>"
'Response.write acheoridate&"<br>"
'Response.write acheorimemo&"<br>"
'Response.end

SQL="update TK_advice set acheorigubun='"&acheorigubun&"', aform='"&aform&"', agubun='"&agubun&"',aclaim='"&aclaim&"'"
SQL=SQL&" ,acheoriname='"&acheoriname&"', acheoridate=getdate(), acheorimemo='"&acheorimemo&"'"
SQL=SQL&" where aidx='"&aidx&"' "



Response.Write SQL&"<br>"
'Response.end
Dbcon.Execute(SQL)

Response.Write acidx&"<br>"
if acidx<>"" then
response.write "<script>opener.location.replace('advicelist.asp?cidx="&acidx&"&aidx="&aidx&"');window.close();</script>"
else
response.write "<script>opener.location.replace('advicem.asp');window.close();</script>"
end if


set Rs=Nothing
call dbClose()
%>
