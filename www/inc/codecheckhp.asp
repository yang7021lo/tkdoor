<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%

	call dbOpen()		
	
	set Rs=Server.CreateObject ("ADODB.Recordset")

	mhp=Request("mhp")

        SQL="select count(*) from tk_member where mhp='"&mhp&"'  "
		'response.write SQL
		rs.open Sql,dbcon,1,1,1
		    count=rs(0)
		rs.close

		if count>0 then 
		Response.write "<script>alert('중복된 휴대폰번호입니다.');parent.frmMain.mhp.value='';</script>"
		else
		Response.write "<script>alert('등록 가능한 휴대폰 번호입니다.');parent.frmMain.ep_check.value='OK';</script>"		
		end if


	set rs=nothing

	call dbClose()

%>