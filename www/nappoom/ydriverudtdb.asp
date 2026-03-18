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

didx= encodesTR(uploadform("didx"))
dname = encodesTR(uploadform("dname"))
dnum = encodesTR(uploadform("dnum"))
dtel = encodesTR(uploadform("dtel"))
dloc = encodesTR(uploadform("dloc"))
dcod = encodesTR(uploadform("dcod"))
dstatus = uploadform("dstatus")

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report

'Response.write dname&"<br>"
'Response.write dnum&"<br>"
'Response.write dtek&"<br>"
'Response.write dloc&"<br>"
'Response.write dcod&"<br>"
'Response.write dstatus&"<br>"
'Response.end


SQL="Update tk_ydriver set dname='"&dname&"', dstatus='"&dstatus&"', dnum='"&dnum&"', dmem='"&c_midx&"', ddate=getdate(), dtel='"&dtel&"', dloc='"&dloc&"', dcod='"&dcod&"' "
SQL=SQL&" Where didx='"&didx&"' "

        Response.write (SQL)&"<br>"
        'Response.end
        Dbcon.Execute (SQL)


        response.write "<script>alert('운전기사 정보 수정이 완료되었습니다');location.replace('ydriverlist.asp');</script>"

%>

<%
set Rs=Nothing
call dbClose()
%>

