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
glcode=encodestr(Request("glcode"))
glsort=encodestr(Request("glsort"))
glvariety=Request("glvariety")
gldepth=encodestr(Request("gldepth"))
glprice=Request("glprice")


'Response.write glcode&"<br>"
'Response.write glsort&"<br>"
'Response.write glvariety&"<br>"
'Response.write gldepth&"<br>"
'Response.write glprice&"<br>"


SQL="Insert into tk_glass (glcode, glsort, glvariety, gldepth, glprice, glwdate, glstatus) "
SQL=SQL&" Values ('"&glcode&"', '"&glsort&"', '"&glvariety&"', '"&gldepth&"', '"&glprice&"', getdate(), 1 ) "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('glass_itemin.asp');</script>"

%>


<%
set Rs=Nothing
call dbClose()
%>