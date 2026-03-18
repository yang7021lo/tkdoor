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
fname = request("fname")
fstatus = encodesTR(request("fstatus"))
ftype=encodestr(Request("ftype"))
gotopage = request("gotopage")

'Response.write fidx&"<br>"
'Response.write fname&"<br>"
'Response.write fstatus&"<br>"
'Response.write ftype&"<br>"
'Response.end

SQL="Update tk_reportm set fname='"&fname&"', fstatus='"&fstatus&"', ftype='"&ftype&"', fmidx='"&c_midx&"', fdate=getdate() "
SQL=SQL&" Where fidx='"&fidx&"' "

'Response.write (SQL)&"<br>"
'Response.end
Dbcon.Execute (SQL)

response.write "<script>alert('수정완료');location.replace('reglist.asp?gotopage="&gotopage&"');</script>"

%>

<%
set Rs=Nothing
call dbClose()
%>

