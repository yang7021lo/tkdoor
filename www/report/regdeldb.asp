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
    Set Rs = Server.CreateObject ("ADODB.Recordset")
%>
<%
fidx=request("fidx")
'Response.write fidx&"<br>"
'Response.end

Sql="Delete From tk_reportm where fidx='"&fidx&"' "
Dbcon.Execute (Sql)

Response.write "<script>alert('삭제완료');location.replace('reglist.asp');</script>"
Response.end
%>

<%
set Rs=Nothing
call dbClose()
%>