
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

pidx=Request("pidx")
pname=Request("pname")
pstatus=Request("pstatus")

response.write pidx&"<br>"
response.write pname&"<br>"
response.write pstatus&"<br>"

oes="update tk_paint set pname='"&pname&"', pstatus='"&pstatus&"', pemidx='"&C_midx&"', pewdate=getdate()  Where pidx='"&pidx&"' "
response.write oes
dbcon. execute (oes)
response.write "<script>alert('수정되었습니다.');location.replace('paintmgntlist.asp');</script>"

set Rs=Nothing
call dbClose()
%>
