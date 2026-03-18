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

		
		Sql="select count(*) from tk_customer where cnumber='"&request("cnumber")&"'"
		'response.write SQL
		rs.open Sql,dbcon,1,1,1
		count=rs(0)
		rs.close

		if count>0 then 
		Response.write "<script>alert('중복된 사업자번호 입니다.');parent.ABC.cnumber.value='';</script>"
		else
		Response.write "<script>alert('중복된 사업자번호가 없습니다.');parent.ABC.ep_check.value='OK';</script>"		
		end if
''

	set rs=nothing

	call dbClose()

%>