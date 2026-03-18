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

fname = encodesTR(uploadform("fname"))
fstatus = uploadform("fstatus")
ftype = uploadform("ftype")
'DEXT.FileUpload가 선언되었을 때는 넘겨받은 파라미터값을 uploadform을 선언해서 받아줍시다.

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report

'Response.write fname&"<br>"
'Response.write fstatus&"<br>"
'Response.write ftype&"<br>"
'Response.end

SQL="Select * From tk_reportm Where fname='"&fname&"' and ftype='"&ftype&"' "

Set Rs=dbcon.execute (SQL)

    If not (Rs.BOF or Rs.EOF) then
        response.write "<script>alert('같은 이름의 품목이 있습니다.');history.back();</script>"
    else
        SQL="insert into tk_reportm ( fname, fstatus, ftype, fmidx, fdate) "
        SQL=SQL&" values ('"&fname&"', '"&fstatus&"', '"&ftype&"', '"&c_midx&"', getdate() ) "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
        response.write "<script>alert('품목이 등록되었습니다');location.replace('reglist.asp');</script>"
    end if
Rs.close

'초기파일 삭제 코드
'uploadform.DeleteFile file1

%>

<%
set Rs=Nothing
call dbClose()
%>

