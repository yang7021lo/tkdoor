
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

mname=encodestr(Request("mname"))
mpos=encodestr(Request("mpos"))
mtel=encodestr(Request("mtel"))
mhp=encodestr(Request("mhp"))
mfax=encodestr(Request("mfax"))
memail=encodestr(Request("memail"))
cidx=encodestr(Request("cidx"))

splmhp=split(mhp,"-")
mhp1=splmhp(0)
mhp2=splmhp(1)
mhp3=splmhp(2)

mpw=md5(mhp3)

Response.write mname&"<br>"
Response.write mpos&"<br>"
Response.write mtel&"<br>"
Response.write mhp&"<br>"
Response.write mfax&"<br>"
Response.write memail&"<br>"

Response.write cidx&"<br>"
Response.write mhp1&"<br>"
Response.write mhp2&"<br>"
Response.write mhp3&"<br>"
Response.write mpw&"<br>"

'response.end

'데이터베이스에 레코드 입력하는 형식 : Insert into 테이블명 (컬럼명1, 컬럼명2, ----) values (변수명1, 변수명2,----)
'데이터베이스에 입력된 레코드를 불러오는 형식 : Select 컬럼명 From 테이블명 Where 조건 Order by 컬럼명 asc/desc

oSQL="Insert into tk_member  (mname, mpos, mtel, mhp, mfax, memail, mpw, cidx , umidx, udate) "
oSQL=oSQL&" Values ('"&mname&"', '"&mpos&"', '"&mtel&"', '"&mhp&"', '"&mfax&"', '"&memail&"', '"&mpw&"', '"&cidx&"', '"&c_midx&"', getdate()) "
Response.Write oSQL
'response.end

Dbcon.Execute(oSQL)

%>
<script>location.replace('memlist.asp?cidx=<%=cidx%>');</script>
  
set Rs=Nothing
call dbClose()

<%
set Rs=Nothing
call dbClose()
%>
