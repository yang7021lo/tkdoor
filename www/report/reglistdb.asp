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
    Set Rs = Server.CreateObject ("ADODB.Recordset")
%>

<%
mname = encodesTR(request("mname"))
mpw = encodesTR(request("mpw"))
mpw = md5(mpw)
mpos = encodesTR(request("mpos"))
mhp = encodesTR(request("mhp"))
memail = encodesTR(request("memail"))


'Response.write mname&"<br>"
'Response.write mpw&"<br>"
'Response.write mpos&"<br>"
'Response.write mhp&"<br>"
'Response.write memail&"<br>"
'Response.end

if midx<>"" then

    SQL="Update tk_member "
    SQL=SQL&" set midx='"&midx&"', '"&mname&"', '"&mpw&"', '"&mpos&"', '"&mhp&"', '"&memail&"' where midx='"&midx&"' "
    'Respose.write(SQL)&"<br>
    Dbcon.Execute (SQL)

    Response.write "<script>location.replace('signlist.asp');</script>"

%>

<%
set Rs=Nothing
call dbClose()
%>