
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
Set uploadform = Server.CreateObject("DEXT.FileUpload") 

uploadform.AutoMakeFolder = True

uploadform.DefaultPath=DefaultPath_advice    'cookies.asp에 설정해 놓은 파일저장 경로



afidx=Request("afidx")
cidx=Request("cidx")
aidx=Request("aidx")

response.write afidx&"<br>"
response.write cidx&"<br>"
response.write aidx&"<br>"


SQL="select afname from tk_advicefile where afidx='"&afidx&"' "
Rs.open sql,dbcon    
if not (Rs.bof or rs.eof) then   
    afname=Rs(00)
end if
Rs.Close


fileurl=DefaultPath_advice&"\"&afname

REsponse.write fileurl&"<br>"
uploadform.DeleteFile fileurl 


SQL="Delete From tk_advicefile where afidx='"&afidx&"' "
Response.Write SQL&"<br>"
 
Dbcon.Execute(SQL)



response.write "<script>location.replace('adviceudt.asp?cidx='"&cidx&"'&aidx="&aidx&"');</script>"
set Rs=Nothing
call dbClose()
%>
