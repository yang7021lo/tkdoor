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
sujudate=encodestr(Request("sujudate"))
sjnumber=encodestr(Request("sjnumber"))
sjaddress=encodestr(Request("sjaddress"))
sjchulgo=encodestr(Request("sjchulgo"))
sjchulgodate=encodestr(Request("sjchulgodate"))
sjqty=encodestr(Request("sjqty"))
sjtatus="0"

Response.write cidx&"<br>"
Response.write sujudate&"<br>"
Response.write sjnumber&"<br>"
Response.write sjaddress&"<br>"
Response.write sjchulgo&"<br>"
Response.write sjchulgodate&"<br>"
Response.write sjqty&"<br>"



SQL="update tk_sujua set cidx='"&rcidx&"', sjaddress='"&sjaddress&"', sjnumber='"&sjnumber&"', sjtatus='"&sjtatus&"', sjqty='"&sjqty&"', sujudate=getdate(), sjchulgo='"&sjchulgo&"', sjchulgodate=getdate(), sjamidx='"&C_midx&"', sjamdate=getdate(), sjameidx='"&C_midx&"', sjamedate=getdate() "
SQL=SQL&"where sjaidx='"&sjaidx&"' "
Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)


SQL="select sjaidx from tk_sujua "
Rs.open SQL,Dbcon
    sjaidx=Rs(0)
Rs.Close




response.write "<script>alert('입력이 완료되었습니다.');location.replace('sujuin.asp?cidx="&rcidx&"&sjaidx="&sjaidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>