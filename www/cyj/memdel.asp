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
midx=Request("midx")

SQL="Delete From tk_member Where midx='"&midx&"'"
Dbcon.Execute(SQL)

Response.write "<script>alert('삭제되었습니다.');location.replace('memlist.asp');</script>"
%>


<%
set Rs=Nothing
call dbClose()
%>