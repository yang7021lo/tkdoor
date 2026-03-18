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
ron=encodestr(Request("ron"))
rname=encodestr(Request("rname"))
ruse=encodestr(Request("ruse"))
rtdate=encodestr(Request("rtdate"))
rwtype=encodestr(Request("rwtype"))
rwidth=encodestr(Request("rwidth"))
rinsp=encodestr(Request("rinsp"))
rherp=encodestr(Request("rherp"))
rwatp=encodestr(Request("rwatp"))
rpa=encodestr(Request("rpa"))
roc=encodestr(Request("roc"))


'Response.write ron&"<br>"
'Response.write rname&"<br>"
'Response.write ruse&"<br>"
'Response.write rtdate&"<br>"
'Response.write rwtype&"<br>"
'Response.write rwidth&"<br>"
'Response.write rinsp&"<br>"
'Response.write rherp&"<br>"
'Response.write rwatp&"<br>"
'Response.write rpa&"<br>"
'Response.write roc&"<br>"
'Response.end

if midx<>"" then

    SQL="Update tk_member "
    SQL=SQL&" set midx='"&ridx&"', ron='"&ron&"', rname='"&rname&"', ruse='"&ruse&"', rtdate='"&rtdate&"', rwtype='"&rwtype&"', rwidth='"&rwidth&"' "
    SQL=SQL&" rinsp='"&rinsp&"', rherps='"&rherp&"', rwatp='"&rwatp&"', rpa='"&rpa&"', roc='"&roc&"' " 
    SQL=SQL&" where ridx='"&ridx&"' "
End if
    
    'Respose.write(SQL)&"<br>
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('remainlist.asp');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>