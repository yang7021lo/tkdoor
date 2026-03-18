
<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

ksidx=Request("ksidx")

SQL="Delete From tk_korderSub where ksidx='"&ksidx&"' "
Dbcon.Execute (SQL)

Response.write "<script>alert('삭제 되었습니다.');location.replace('odrlist.asp');</script>"

set Rs=Nothing
call dbClose()
%>
