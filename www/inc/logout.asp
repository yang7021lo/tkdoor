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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")


%>
<HTML>
<HEAD>
<TITLE>LogOut</TITLE>


 </HEAD>

<BODY background="/img/basic_bg01.gif">
<!--#include virtual="/inc/cookies.asp"-->
<!--
<iframe src="https://www.google.com/accounts/Logout" name="main" width="0" height="0" marginwidth="0"  marginheight="0"  scrolling="no" align="left" frameborder="0" border="1" allowtransparency="true"></iframe> 
-->
<%

response.cookies("tk")("c_midx") = ""
response.cookies("tk")("c_cidx") = ""
response.cookies("tk")("c_midx") = ""
response.cookies("tk")("c_cname") = ""
response.cookies("tk").Expires = dateadd("d",-1,Date())
Response.write "<script>location.replace('/index.asp');</script>"



%>
</BODY>
</HTML>
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>