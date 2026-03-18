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

ron = encodesTR(uploadform("ron"))
rname = uploadform("rname")
ruse = uploadform("ruse")
rtdate = uploadform("rtdate")
kname = uploadform("kname")

'Response.write ron&"<br>"
'Response.write rname&"<br>"
'Response.write ruse&"<br>"
'Response.write rtdate&"<br>"
'Response.end

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report


SQL=" Insert into tk_report (ron, rname, ruse, rtdate, rmidx, rwdate, remidx, rewdate, kname) "
SQL=SQL&" Values ('"&ron&"', '"&rname&"', '"&ruse&"', '"&rtdate&"', '"&c_midx&"', getdate(), '"&c_midx&"', getdate(), '"&kname&"') "
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

SQL="Select Max(ridx) from tk_report "
Rs.Open SQL,Dbcon
    ridx=Rs(0)
Rs.Close

response.write "<script>location.replace('remain2.asp?ridx="&ridx&"');</script>"

%>

<%
set Rs=Nothing
call dbClose()
%>

