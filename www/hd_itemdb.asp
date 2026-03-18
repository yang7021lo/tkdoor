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
tagongcode=encodestr(Request("tagongcode"))
tagongshorten=encodestr(Request("tagongshorten"))
tagongname=Request("tagongname")
tagongpunch=Request("tagongpunch")
tagongprice=encodestr(Request("tagongprice"))
tagongmidx=Request("tagongmidx")
tagongemidx=Request("tagongemidx")


'Response.write tagongcode&"<br>"
'Response.write tagongshorten&"<br>"
'Response.write tagongname&"<br>"
'Response.write tagongprice&"<br>"
'Response.write tagongmidx&"<br>"


SQL="Insert into tk_hd (tagongcode, tagongshorten, tagongname, tagongpunch, tagongprice, tagongmidx, tagongwdate ,tagongemidx, tagongewdate, tagongstatus) "
SQL=SQL&" Values ( '"&tagongcode&"' , '"&tagongshorten&"' , '"&tagongname&"' , '"&tagongpunch&"' , '"&tagongprice&"' , '"&tagongmidx&"' , getdate(), '"&tagongemidx&"' , getdate(), 1 ) "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('tagong_item.asp');</script>"

%>


<%
set Rs=Nothing
call dbClose()
%>