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
kycode=encodestr(Request("kycode"))
kyshorten=encodestr(Request("kyshorten"))
kyname=Request("kyname")
kyprice=encodestr(Request("kyprice"))
kymidx=Request("kymidx")
kyemidx=Request("kyemidx")


'Response.write kycode&"<br>"
'Response.write kyshorten&"<br>"
'Response.write kyname&"<br>"
'Response.write kyprice&"<br>"
'Response.write kymidx&"<br>"


SQL="Insert into tk_key (kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate, kystatus,kywitch) "
SQL=SQL&" Values ('"&kycode&"', '"&kyshorten&"', '"&kyname&"', '"&kyprice&"', '"&kymidx&"', getdate(), '"&kyemidx&"', getdate(), 1, '"&kywitch&"' ) "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('key_item.asp');</script>"

%>


<%
set Rs=Nothing
call dbClose()
%>