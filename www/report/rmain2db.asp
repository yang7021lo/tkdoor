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


ridx=encodestr(uploadform("ridx"))
ron=encodestr(uploadform("ron"))
rname=encodestr(uploadform("rname"))
ruse=encodestr(uploadform("ruse"))
rtype=encodestr(uploadform("rtype"))
rtdate=encodestr(uploadform("rtdate"))
rstatus=encodestr(uploadform("rstatus"))
rwtype=encodestr(uploadform("rwtype"))
kname=encodestr(uploadform("kname"))
rwidth=encodestr(uploadform("rwidth"))
rinsp=encodestr(uploadform("rinsp"))
rherp=encodestr(uploadform("rherp"))
rwatp=encodestr(uploadform("rwatp"))
rpa=encodestr(uploadform("rpa"))
roc=encodestr(uploadform("roc"))
rsizelabel=encodestr(uploadform("rsizelabel"))
rverticalw=encodestr(uploadform("rverticalw"))
rtorsion=encodestr(uploadform("rtorsion"))
rimpactr=encodestr(uploadform("rimpactr"))
rsafe=encodestr(uploadform("rsafe"))
reportnote=encodestr(uploadform("reportnote"))
sjb_type_no=encodestr(uploadform("sjb_type_no"))
file1=uploadform("file1")
file2=uploadform("file2")
clickacfidx=uploadform("clickacfidx")
clickaacfidx=uploadform("clickaacfidx")

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_report

file1 = uploadform("file1").Save( ,false) '실질적인 파일 저장
board_file_name1 = uploadform("file1").LastSavedFileName '파일저장 경로에서 파일명과 확장자만 board_file_name1변수에 저장한다.

'file2 = uploadform("file2").Save( ,false)
'board_file_name2 = uploadform("file2").LastSavedFileName
'Response.write ridx&"<br>"
'Response.write ron&"<br>"
'Response.write rname&"<br>"
'Response.write ruse&"<br>"
'Response.write sjb_type_no&"<br>"
'Response.write rtdate&"<br>"
'Response.write rstatus&"<br>"
'Response.write rwtype&"<br>"
'Response.write rwidth&"<br>"
'Response.write rinsp&"<br>"
'Response.write rherp&"<br>"
'Response.write rwatp&"<br>"
'Response.write rpa&"<br>"
'Response.write roc&"<br>"
'Response.write kname&"<br>"
'Response.write board_file_name1&"<br>"
'Response.write gotopage&"<br>"
'Response.end

if board_file_name1<>"" then
    if board_file_name2<>"" then
        SQL="Update tk_report set ron='"&ron&"', rname='"&rname&"', ruse='"&ruse&"', rtdate='"&rtdate&"', rwtype='"&rwtype&"', rwidth='"&rwidth&"'" 
        SQL=SQL&", rinsp='"&rinsp&"', rherp='"&rherp&"', rwatp='"&rwatp&"', rpa='"&rpa&"', roc='"&roc&"' "
        SQL=SQL&", rsizelabel='"&rsizelabel&"', rverticalw='"&rverticalw&"', rtorsion='"&rtorsion&"', rimpactr='"&rimpactr&"', rsafe='"&rsafe&"' "
        SQL=SQL&", remidx='"&c_midx&"', rewdate=getdate(), rstatus='"&rstatus&"', kname='"&kname&"', rfile='"&board_file_name1&"', nfile='"&board_file_name2&"', reportnote='"&reportnote&"', sjb_type_no='"&sjb_type_no&"' " 
        SQL=SQL&" Where ridx='"&ridx&"' "
    else
        SQL="Update tk_report set ron='"&ron&"', rname='"&rname&"', ruse='"&ruse&"', rtdate='"&rtdate&"', rwtype='"&rwtype&"', rwidth='"&rwidth&"'" 
        SQL=SQL&", rinsp='"&rinsp&"', rherp='"&rherp&"', rwatp='"&rwatp&"', rpa='"&rpa&"', roc='"&roc&"' "
        SQL=SQL&", rsizelabel='"&rsizelabel&"', rverticalw='"&rverticalw&"', rtorsion='"&rtorsion&"', rimpactr='"&rimpactr&"', rsafe='"&rsafe&"' "
        SQL=SQL&", remidx='"&c_midx&"', rewdate=getdate(), rstatus='"&rstatus&"', kname='"&kname&"', rfile='"&board_file_name1&"', reportnote='"&reportnote&"', sjb_type_no='"&sjb_type_no&"' " 
        SQL=SQL&" Where ridx='"&ridx&"' "
    End if

else
    if board_file_name2<>"" then
        SQL="Update tk_report set ron='"&ron&"', rname='"&rname&"', ruse='"&ruse&"', rtdate='"&rtdate&"', rwtype='"&rwtype&"', rwidth='"&rwidth&"'" 
        SQL=SQL&", rinsp='"&rinsp&"', rherp='"&rherp&"', rwatp='"&rwatp&"', rpa='"&rpa&"', roc='"&roc&"' "
        SQL=SQL&", rsizelabel='"&rsizelabel&"', rverticalw='"&rverticalw&"', rtorsion='"&rtorsion&"', rimpactr='"&rimpactr&"', rsafe='"&rsafe&"' "
        SQL=SQL&", remidx='"&c_midx&"', rewdate=getdate(), rstatus='"&rstatus&"', kname='"&kname&"', nfile='"&board_file_name2&"', reportnote='"&reportnote&"', sjb_type_no='"&sjb_type_no&"' " 
        SQL=SQL&" Where ridx='"&ridx&"' "
    else
        SQL="Update tk_report set ron='"&ron&"', rname='"&rname&"', ruse='"&ruse&"', rtdate='"&rtdate&"', rwtype='"&rwtype&"', rwidth='"&rwidth&"'" 
        SQL=SQL&", rinsp='"&rinsp&"', rherp='"&rherp&"', rwatp='"&rwatp&"', rpa='"&rpa&"', roc='"&roc&"' "
        SQL=SQL&", rsizelabel='"&rsizelabel&"', rverticalw='"&rverticalw&"', rtorsion='"&rtorsion&"', rimpactr='"&rimpactr&"', rsafe='"&rsafe&"' "
        SQL=SQL&", remidx='"&c_midx&"', rewdate=getdate(), rstatus='"&rstatus&"', kname='"&kname&"', reportnote='"&reportnote&"', sjb_type_no='"&sjb_type_no&"' " 
        SQL=SQL&" Where ridx='"&ridx&"' "
    End if    
End if   

'Response.write(SQL)
'Response.end
Dbcon.Execute (SQL)

'Response.write gotopage&"<br>"
'Response.end

response.write "<script>alert('저장 되었습니다');location.replace('remainlistorg2.asp?clickaacfidx="&clickaacfidx&"&clickacfidx="&clickacfidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>