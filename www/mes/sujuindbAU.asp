<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<% 
rcidx=Request("cidx")
rsjaidx=Request("sjaidx")
sujudate=encodestr(Request("sujudate"))
sjnumber=encodestr(Request("sjnumber"))
sjaddress=encodestr(Request("sjaddress"))
sjchulgo=encodestr(Request("sjchulgo"))
sjchulgodate=encodestr(Request("sjchulgodate"))
sjqty=encodestr(Request("sjqty"))

Response.write "cidx;"&rcidx&"<br>"
Response.write "sjaidx;"&rsjaidx&"<br>"
Response.write "sujudate;"&sujudate&"<br>"
Response.write "sjnumber;"&sjnumber&"<br>"
Response.write "sjaddress;"&sjaddress&"<br>"
Response.write "sjchulgo;"&sjchulgo&"<br>"
Response.write "sjchulgodate;"&sjchulgodate&"<br>"
Response.write "sjqty;"&sjqty&"<br>"
'response.end

SQL=" update tk_sujua set sjaddress='"&sjaddress&"', sjnumber='"&sjnumber&"' "
SQL=SQL&" , sjqty='"&sjqty&"', sujudate='"&sujudate&"', sjchulgo='"&sjchulgo&"', sjchulgodate='"&sjchulgodate&"', sjameidx='"&C_midx&"', sjamedate=getdate() "
SQL=SQL&" where sjaidx='"&rsjaidx&"' "
Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)

response.write "<script>location.replace('sujuin.asp?cidx="&rcidx&"&sjaidx="&rsjaidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>