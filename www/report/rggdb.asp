
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

' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report

rgtype = encodesTR(uploadform("rgtype"))
rgname = encodesTR(uploadform("rgname"))
gstatus = encodesTR(uploadform("gstatus"))
file1 = uploadform("file1")

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report

file1 = uploadform("file1").Save( ,false)   '실질적인 파일 저장

board_file_name1 = uploadform("file1").LastSavedFileName '파일저장 경로에서 파일명과 확장자만 board_file_name1변수에 저장한다.



Response.write rgtype&"<br>"
Response.write rgname&"<br>"
Response.write board_file_name1&"<br>"
SQL="Insert into tk_reportg (rgname, rgmidx, rgdate, rgemidx, rgedate, rgtype, rgfile, gstatus) "
SQL=SQL&" Values ('"&rgname&"','"&c_midx&"',getdate(),'"&c_midx&"',getdate(),'"&rgtype&"','"&board_file_name1&"', '"&gstatus&"') "
Response.write (SQL)&"<br>"
'Response.end

Dbcon.Execute (SQL)


response.write "<script>alert('등록 되었습니다');opener.location.replace('remaingroup.asp');window.close();</script>"


set Rs=Nothing
call dbClose()
%>
