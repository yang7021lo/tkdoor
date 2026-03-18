
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
 jemok=encodestr(Request("jemok"))
 jeansahang=encodestr(Request("jeansahang"))
 uploadFile1=Request("uploadFile1")

 'Response.write corp_name&"<br>"
 'Response.write duty_name&"<br>"
 'Response.write tel_number&"<br>"
 'Response.write qtype&"<br>"
 'Response.write qcontents&"<br>"
 

 SQL="Insert into yang (jemok, jeansahang, uploadFile1, email, qtype, qcontents, wdate, status) "
 SQL=SQL&" Values ('"&jemok&"', '"&jeansahang&"', '"&uploadFile1&"', '"&email&"', '"&qtype&"', '"&qcontents&"', getdate(), 0 ) "
 Response.write (SQL)&"<br>"
 Dbcon.Execute (SQL)

 response.write "<script>alert('공지사항 입력이 완료되었습니다.');location.replace('nboardlist.asp');</script>"

 %>
 
 
 <%
  set Rs=Nothing
call dbClose()
  %>