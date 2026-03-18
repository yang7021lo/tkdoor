<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<% 
rgoidx=Request("rgoidx")
rsidx=Request("rsidx")
rbuidx=Request("rbuidx")
smidx=Request("smidx")
smtype=Request("smtype")
smproc=Request("smproc")
smal=Request("smal")
smal=Request("smal")
smalqu=Request("smalqu")
smst=Request("smst")
smstqu=Request("smstqu")
smglass=Request("smglass")
smgrid=Request("smgrid")
tagongfok=Request("tagongfok")
tagonghigh=Request("tagonghigh")
smnote=Request("smnote")
smcomb=Request("smcomb")
smmidx=Request("smmidx")
smemidx=Request("smemidx")
baridx=Request("baridx")
barNAME=Request("barNAME")
goname=Request("goname")


Response.write rgoidx&"<br>"
Response.write rsidx&"<br>"
Response.write rbuidx&"<br>"
Response.write smidx&"<br>"

SQL="update tk_material set sidx='"&rsidx&"', smtype='"&smtype&"', smproc='"&smproc&"', smal='"&smal&"', smalqu='"&smalqu&"' "
SQL=SQL&" , smst='"&smst&"', smstqu='"&smstqu&"', smglass='"&smglass&"', smgrid='"&smgrid&"', tagongfok='"&tagongfok&"', tagonghigh='"&tagonghigh&"' "
SQL=SQL&" , smnote='"&smnote&"', smcomb='"&smcomb&"' "
SQL=SQL&" , smemidx='"&c_midx&"', smewdate=getdate() "
SQL=SQL&" where smidx='"&smidx&"' "
Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');opener.location.replace('pummok_door.asp?rgoidx="&rgoidx&"&rsidx="&rsidx&"');window.close();</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>