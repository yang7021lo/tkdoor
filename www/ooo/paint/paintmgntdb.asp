
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
if c_midx="" then 
response.write "<script>alert('접속 권한이 없습니다.');location.replace('/index.asp');</script>"
response.end
end if


pname=Request("pname")

'pname : 품목이름
'pstatus : 품목의 상태 0:사용안함 1: 사용함
'pmidx : 등록자의 키값
'pwdate ; 등록일
'pemidx : 마지막 수정한 사람의 키값
'pewdate : 마지막 수정한 날짜

oes="Insert into tk_paint (pname, pstatus, pmidx, pwdate, pemidx, pewdate) "
oes=oes&" values ('"&pname&"',1, '"&C_midx&"', getdate(), '"&C_midx&"', getdate()) "
'response.write (oes)
dbcon.execute (oes)
response.write "<script>alert('등록되었습니다.');location.replace('paintmgntlist.asp');</script>"


set Rs=Nothing
call dbClose()
%>
