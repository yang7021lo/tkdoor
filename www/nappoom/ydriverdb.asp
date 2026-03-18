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

SQL="Select * From tk_ydriver Where dname='"&dname&"' and dnum='"&dnum&"' "

Set Rs=dbcon.execute (SQL)

    If not (Rs.BOF or Rs.EOF) then
        response.write "<script>alert('같은 이름의 운전자가 있습니다.');history.back();</script>"
    else
        SQL="insert into tk_ydriver ( dname, dstatus, dnum, dtel, dloc, dcod, ddate, dmem) "
        SQL=SQL&" Values ('"&dname&"', '"&dstatus&"', '"&dnum&"', '"&dtel&"', '"&dloc&"', '"&dcod&"', getdate(), '"&c_midx&"' ) "
        Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
        response.write "<script>alert('운전기사 정보 등록이 완료되었습니다');location.replace('ydriverlist.asp');</script>"
    end if
Rs.close

%>

<%
set Rs=Nothing
call dbClose()
%>

