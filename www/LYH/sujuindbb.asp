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
sjbpummyoung=encodestr(Request("sjbpummyoung"))
sjbkukyuk=encodestr(Request("sjbkukyuk"))
sjbjaejil=encodestr(Request("sjbjaejil"))
sjbqty=encodestr(Request("sjbqty"))
sjbwide=encodestr(Request("sjbwide"))
sjbhigh=encodestr(Request("sjbhigh"))


Response.write cidx&"<br>"
Response.write sjbpummyoung&"<br>"
Response.write sjbkukyuk&"<br>"
Response.write sjbjaejil&"<br>"
Response.write sjbqty&"<br>"
Response.write sjbwide&"<br>"
Response.write sjbhigh&"<br>"



SQL="Insert into tk_sujub (sjbidx, sjbpummyoung, sjbkukyuk, sjbjaejil, sjbqty, sjbwide, sjbhigh, sjbbanghyang, sjbwitch, sjbbigo, sjbglass, sjbpaint,sjbkey1,sjbkey2,sjbkey3,sjbkey4,sjbtagong1,sjbtagong2,sjbtagong3,sjbtagong4,sjbhingeup,sjbhingeup1,sjbhingedown,sjbhingedown1,sjbkyukja1,sjbkyukja2,sjbkyukja3,sjbkyukja4,sjaidx ) "
SQL=SQL&" Values ( '"&sjbidx&"', '"&sjbpummyoung&"', '"&sjbkukyuk&"', '"&sjbjaejil&"', '"&sjbqty&"','"&sjbwide&"', "
SQL=SQL&" '"&sjbhigh&"','"&sjbbanghyang&"','"&sjbwitch&"','"&sjbbigo&"','"&sjbglass&"','"&sjbpaint&"', "
SQL=SQL&" '"&sjbkey1&"','"&sjbkey2&"','"&sjbkey3&"','"&sjbkey4&"','"&sjbtagong1&"','"&sjbtagong2&"', '"&sjbtagong3&"','"&sjbtagong4&"', "
SQL=SQL&" '"&sjbhingeup&"','"&sjbhingeup1&"','"&sjbhingedown&"','"&sjbhingedown1&"','"&sjbkyukja1&"','"&sjbkyukja2&"', '"&sjbkyukja3&"','"&sjbkyukja4&"','"&sjaidx&"' ) "

Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)


SQL="select sjbidx from tk_sujub "
Rs.open SQL,Dbcon
sjbidx=Rs(0)
Rs.Close




response.write "<script>alert('입력이 완료되었습니다.');location.replace('sujuin.asp?cidx="&rcidx&"&sjaidx="&sjaidx&"&sjbidx="&sjbidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>