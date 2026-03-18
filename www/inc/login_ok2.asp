<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"

%>
<!--#include virtual="/inc/dbcon1.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")
Set objCmd =  Server.CreateObject("ADODB.COMMAND")
Set objCmd1 = Server.CreateObject("ADODB.COMMAND")
Set objCmd2 = Server.CreateObject("ADODB.COMMAND")
Set objCmd3 = Server.CreateObject("ADODB.COMMAND")
Set objCmd4 = Server.CreateObject("ADODB.COMMAND")
 

	'출입체크에서 진입시 처리 시작
	mem_mbrname=Request("mem_mbrname")
	scode=Request("scode")
    mdscode=md5(scode)
	'response.write mem_mbrname&"<br>"
	'response.write scode&"<br>"
	'response.end
	If mdscode="58d799b15664b2ebdc2b94ef5a44de3e"  Then
		R_mbr_id=mem_mbrname
	else

		if mem_mbrname<>"" and mdscode<>"" then 
			SQL="select br_idx from ay_bridge where br_name='"&mem_mbrname&"' and br_pass='"&mdscode&"' "
			'response.write(SQL)&"<br>"
			'response.end
			Rs.open Sql,Dbcon,1,1,1
			If not (Rs.EOF or Rs.BOF ) then
				br_idx = Rs(0)
			else
				Response.write "<script>alert('해당하는 관리자 정보가 없습니다.');history.back('-1');</script>"
				response.End
			end if
			Rs.close
		else
			Response.write "<script>alert('이름 또는 인증번호가 없습니다.');history.back('-1');</script>"
			response.End
		end if
	end if
 
 


'로그인 처리 시작

		SQL="SELECT A.br_idx, A.br_name "
        SQL=SQL&" FROM ay_bridge A "
        SQL=SQL&" WHERE A.br_idx = '"&br_idx&"' "
        Rs.open Sql,Dbcon,1,1,1
		'response.write(SQL)&"<br>"
        'response.end
		If (Rs.EOF Or Rs.BOF) Then
			Response.write "<script>alert('3이름 또는 인증번호가 정확하지 않습니다.');history.back('-1');</script>"
			response.End
		Else
            C_br_idx = Rs(0)
			C_br_name = Rs(1)

            ipaddress = Request.Servervariables("REMOTE_ADDR")
            SQL="INSERT INTO ay_log (br_idx, br_name, ipaddr, wdate) VALUES ('"&C_br_idx&"','"&C_br_name&"','"&ipaddress&"',getdate()) "
            Dbcon.Execute (SQL)

            response.cookies("ay")("C_br_idx") = C_br_idx
            response.cookies("ay")("C_br_name") = C_br_name	
            response.cookies("ay").Expires = dateadd("d",100,Date())

			Response.write "<script>"
            Response.write "location.replace('/sbyc/dongne/main.asp');"						
			Response.write "</script>"

		End If 
		Rs.close
      
%>
 

<!DOCTYPE html>
<html lang="en">
  <head>

    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=progectname%></title>
    <!-- Favicon-->
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <!-- 나의 스타일 추가 -->
    <link rel="stylesheet" href="/css/login.css?v=1234">

  </head>
  <body class="text-center">
    안녕


    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

  </body>
</html>
<%
Set Rs = Nothing
Set Rs1 = Nothing
Set objCmd =   Nothing
Set objCmd1 =  Nothing
Set objCmd2 =  Nothing
Set objCmd3 =  Nothing
Set objCmd4 =  Nothing
call dbClose()
%>