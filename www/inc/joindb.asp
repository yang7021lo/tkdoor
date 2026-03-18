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
%>
<% 

cidx="1"
mname=encodestr(Request("mname"))
mhp=request("mhp")

Randomize
scode=Int(Rnd() * 9999) + 1
 
if Len(scode)="1" then
    scode="000"&scode
elseif Len(scode)="2" then
    scode="00"&scode
elseif Len(scode)="3" then
    scode="0"&scode
end if



ascode=md5(scode)


response.write mname&"<br>"
response.write scode&"<br>"
response.write ascode&"<br>"
response.write mhp&"<br>"
'response.end

SQL="Insert into tk_member (mname, mhp, mwdate, cidx, mpw, mkakao) "
SQL=SQL&" values ('"&mname&"','"&mhp&"',getdate(),'"&cidx&"', '"&ascode&"', '0')"
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)
'response.end

SQL="Select midx From tk_member Where mhp='"&mhp&"' "
rs.open sql,dbcon,1,1,1
    midx=rs(0)
rs.close

 response.write "<script>alert('카카오톡으로 전송된 인증번호를 입력해 주세요."&scode&"');location.replace('/etc/s1/mkakao.asp?midx="&midx&"');</script>"

 %>
 
 
 <%
  set Rs=Nothing
  call dbClose()
  %>