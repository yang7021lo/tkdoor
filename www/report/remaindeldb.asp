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
ridx=request("ridx")
'response.write ridx&"<br>"
'response.end

SQL="Delete From tk_report where ridx='"&ridx&"' "
Dbcon.Execute (SQL)

response.write "<script>alert('삭제완료');location.replace('remainlist.asp');</script>"
'Response.end
%>

<%
set Rs=Nothing
call dbClose()
%>

