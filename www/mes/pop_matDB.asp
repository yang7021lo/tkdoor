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
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")

rgoidx=Request("goidx")
rsidx=Request("rsidx")
rbuidx=Request("rbuidx")
smidx=Request("smidx")
%>

<%
SQL=" Insert into tk_material (sidx, buidx, smtype, smproc, smal, smalqu, smst, smstqu, smglass, smgrid, tagongfok, tagonghigh, smnote, smcomb "
SQL=SQL&" , smmidx, smwdate, smemidx, smewdate) "
SQL=SQL&" values('"&sidx&"','"&buidx&"','"&smtype&"', '"&smproc&"','"&smal&"','"&smalqu&"','"&smst&"','"&smstqu&"','"&smglass&"','"&smgrid&"','"&tagongfok&"','"&tagonghigh&"','"&smnote&"','"&smcomb&"' "
SQL=SQL&" ,'"&smmidx&"',getdate(),'"&smemidx&"',  getdate() ) "
'Response.write (SQL)	
DbCon.Execute (SQL)
response.write "<script>alert('입력이 완료되었습니다.');location.replace('pop_mat.asp?rgoidx="&rgoidx&"&rsidx="&rsidx&"&rbuidx="&rbuidx&"&smidx="&smidx&"');</script>"
'Response.write "<script>window.parent.location.replace('pop_mat.asp?rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>&rbuidx=<%=rbuidx%>&smidx=<%=smidx%>');</script>"
response.end
%>
