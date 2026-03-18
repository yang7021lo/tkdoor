
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
If c_midx="" then 
Response.write "<script>alert('로그인 하세요.');location.replace('/index.asp');</script>"
End If
%>

<%
midx=encodestr(Request("midx"))
mname=encodestr(Request("mname"))
mpos=encodestr(Request("mpos"))
mtel=encodestr(Request("mtel"))
mhp=encodestr(Request("mhp"))
mfax=encodestr(Request("mfax"))
memail=encodestr(Request("memail"))
cidx=encodestr(Request("cidx"))

'Response.write mname&"<br>"
'Response.write mpos&"<br>"
'Response.write mtel&"<br>"
'Response.write mhp&"<br>"
'Response.write mfax&"<br>"
'Response.write memail&"<br>"

'Response.write cidx&"<br>"
'Response.write mhp1&"<br>"
'Response.write mhp2&"<br>"
'Response.write mhp3&"<br>"
'Response.write mpw&"<br>"

'response.end


SQL=" update tk_member set mname='"&mname&"', mpos='"&mpos&"', mtel='"&mtel&"'"
SQL=SQL&", mhp='"&mhp&"', mfax='"&mfax&"', memail='"&memail&"', cidx='"&cidx&"', umidx='"&c_midx&"', udate=getdate() "
SQL=SQL&" Where midx='"&midx&"' "

 Response.Write (SQL)
'response.end
Dbcon.Execute(SQL)

Response.Write "<script>alert(' 수정 되었습니다.');location.replace('memlist.asp');</script>"
Response.Write "<script>alert(' 삭제하시겠습니까?');location.replace('memdel.asp');</script>"
  



set Rs=Nothing
call dbClose()
%>
