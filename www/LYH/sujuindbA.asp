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



SQL="Insert into tk_sujua (cidx, sjaddress, sjnumber, sjtatus, sjqty, sujudate, sjchulgo, sjchulgodate, sjamidx, sjamdate, sjameidx, sjamedate ) "
SQL=SQL&" Values ( '"&rcidx&"', '"&sjaddress&"', '"&sjnumber&"', '"&sjtatus&"', '"&sjqty&"',getdate(), "
SQL=SQL&" '"&sjchulgo&"',getdate(),'"&C_midx&"',getdate(),'"&C_midx&"',getdate() ) "
Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)


SQL="select max(sjaidx) from tk_sujua "
Rs.open SQL,Dbcon
    sjaidx=Rs(0)
Rs.Close




response.write "<script>alert('입력이 완료되었습니다.');location.replace('sujuin.asp?cidx="&rcidx&"&sjaidx="&sjaidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>