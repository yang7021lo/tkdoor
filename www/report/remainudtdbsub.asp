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
%>

<%
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload")

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report

ridx = encodesTR(uploadform("ridx"))
ron = encodesTR(uploadform("ron"))
rname = encodesTR(uploadform("rname"))
ruse = encodesTR(uploadform("ruse"))
rtdate = encodesTR(uploadform("rtdate"))

'Response.write ridx&"<br>"
'Response.write ron&"<br>"
'Response.write rname&"<br>"
'Response.write ruse&"<br>"
'Response.write rtdate&"<br>"
'Response.end

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report


    SQL="Update tk_report set ron='"&ron&"', rname='"&rname&"', ruse='"&ruse&"', rtdate='"&rtdate&"' Where ridx='"&ridx&"' "
    'Respose.write(SQL)&"<br>
    Dbcon.Execute (SQL)

response.write "<script>alert('품목이 등록되었습니다');location.replace('remain.asp?ridx="&ridx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>