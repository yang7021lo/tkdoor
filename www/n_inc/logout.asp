<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/sbyc/n_inc/dbcon1.asp"-->
<!--#include virtual="/sbyc/n_inc/cookies.asp"-->
<!--#include virtual="/sbyc/n_inc/md5.asp"-->
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
<!--#include virtual="/sbyc/n_inc/cookies.asp"-->
<!--
<iframe src="https://www.google.com/accounts/Logout" name="main" width="0" height="0" marginwidth="0"  marginheight="0"  scrolling="no" align="left" frameborder="0" border="1" allowtransparency="true"></iframe> 
-->
<%

			response.cookies("ay")("C_br_idx") = ""
			response.cookies("ay")("C_br_name") = ""
		    response.cookies("ay").Expires = dateadd("d",-1,Date())
 

Response.write "<script>location.replace('/sbyc/dongne/login.asp');</script>"
'	C_mem_MbrId = request.cookies("js")("C_mem_MbrId")							'아이디
 


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