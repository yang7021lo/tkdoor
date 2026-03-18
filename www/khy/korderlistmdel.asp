
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

kidx=Request("kidx")

SQL="Delete From tk_korder where kidx='"&kidx&"' "
Dbcon.Execute (SQL)

Response.write "<script>alert('삭제 되었습니다.');location.replace('korderlistm.asp');</script>"

set Rs=Nothing
call dbClose()
%>