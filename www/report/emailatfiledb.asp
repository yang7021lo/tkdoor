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
uploadform.DefaultPath=DefaultPath_add


snidx=encodestr(uploadform("snidx"))
file3=encodestr(uploadform("file3"))
udt=encodestr(uploadform("udt"))


uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_add


file3 = uploadform("file3").Save( ,false)
board_file_name3 = uploadform("file3").LastSavedFileName

'Response.write snidx&"<br>"
'Response.write file3&"<br>"
'Response.end

SQL=" Insert into tk_emailatfile (snidx, efname) Values ('"&snidx&"', '"&board_file_name3&"') "  

'Respose.write(SQL)&"<br>
'Response.end
Dbcon.Execute (SQL)

if udt<>"" then
response.write "<script>location.replace('sendmailre.asp?snidx="&snidx&" ');</script>"
else
response.write "<script>location.replace('sendmail.asp?snidx="&snidx&" ');</script>"
end if
%>

<%
set Rs=Nothing
call dbClose()
%>