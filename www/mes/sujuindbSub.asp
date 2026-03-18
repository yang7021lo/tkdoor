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
rsjbSubidx=Request("sjbSubidx")
rsjbidx=Request("sjbidx")
gubunkey=Request("gubunkey")
busokkey=encodestr(Request("busokkey"))
sjbSubstatus=encodestr(Request("sjbSubstatus"))
sjbSubqty=encodestr(Request("sjbSubqty"))
pummokGubun=encodestr(Request("pummokGubun"))
sjbSubmidx=encodestr(Request("sjbSubmidx"))
sjbSubemidx=encodestr(Request("sjbSubemidx"))
rsjaidx=encodestr(Request("sjaidx"))
rsujuinmoneyidx=encodestr(Request("sujuinmoneyidx"))

Response.write rsjbSubidx&"<br>"
Response.write rsjbidx&"<br>"
Response.write gubunkey&"<br>"
Response.write busokkey&"<br>"
Response.write sjbSubstatus&"<br>"
Response.write sjbSubqty&"<br>"
Response.write pummokGubun&"<br>"



SQL="Insert into tk_sujubSub (sjbSubidx, sjbidx, gubunkey, busokkey, sjbSubstatus, sjbSubqty, pummokGubun, sjbSubmidx, sjbSubwdate, sjbSubemidx, sjbSubewdate, sjaidx , sujuinmoneyidx) "
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