<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_board
'' 
cname=encodestr(uploadform("cname"))
caddr1=encodestr(uploadform("caddr1"))
caddr2=encodestr(uploadform("caddr2"))
cpost=uploadform("cpost")
cnumber=uploadform("cnumber")
cnick=encodestr(uploadform("cnick"))
ctkidx=uploadform("ctkidx")
cstatus=uploadform("cstatus")
cbuy=uploadform("cbuy")
csales=uploadform("csales")
cceo=encodestr(uploadform("cceo"))
ctype=encodestr(uploadform("ctype"))
citem=encodestr(uploadform("citem"))
cemail1=encodestr(uploadform("cemail1"))
cgubun=encodestr(uploadform("cgubun"))
cmove=encodestr(uploadform("cmove"))
cbran=encodestr(uploadform("cbran"))
cdlevel=encodestr(uploadform("cdlevel"))
cflevel=encodestr(uploadform("cflevel"))
calevel=encodestr(uploadform("calevel"))
cslevel=encodestr(uploadform("cslevel"))
csylevel=encodestr(uploadform("csylevel"))
cmemo=encodestr(uploadform("cmemo"))
ctel=uploadform("ctel")
ctel2=uploadform("ctel2")
cfax=uploadform("cfax")


cfile = uploadform("cfile")
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_board


cfile = uploadform("cfile").Save( ,false)   
'cfile="F:\HOME\tkdr002\www\cfile\aaaa.pdf"
'파일의 이름을 새롭게 정하고 새롭게 정한 파일이름으로 다시 저장한다.

filename = uploadform("cfile").LastSavedFileName 
'filename="aaaa.pdf" '

if cfile<>"" then 

    splcyj=split(filename,".")

    afilename=splcyj(0) 'aaaa'
    bfilename=splcyj(1) 'pdf/jpg/hwp'

    board_file_name1=cnumber&"."&bfilename
    board_file_name0 = uploadform.SaveAs(board_file_name1, False)        
    
end if 

Response.write "cname : "&cname&"<br>"
Response.write "caddr1 : "&caddr1&"<br>"
Response.write "caddr2 : "&caddr2&"<br>"
Response.write "cpost : "&cpost&"<br>"
Response.write "cnumber : "&cnumber&"<br>"
Response.write "cnick : "&cnick&"<br>"
Response.write "ctkidx : "&ctkidx&"<br>"
Response.write "cstatus : "&cstatus&"<br>"
Response.write "cbuy : "&cbuy&"<br>"
Response.write "csales : "&csales&"<br>"
Response.write "cceo : "&cceo&"<br>"
Response.write "ctype : "&ctype&"<br>"
Response.write "citem : "&citem&"<br>"
Response.write "cemail1 : "&cemail1&"<br>"
Response.write "cgubun : "&cgubun&"<br>"
Response.write "cmove : "&cmove&"<br>"
Response.write "cbran : "&cbran&"<br>"
Response.write "cdlevel : "&cdlevel&"<br>"
Response.write "cflevel : "&cflevel&"<br>"
Response.write "calevel : "&calevel&"<br>"
Response.write "cslevel : "&cslevel&"<br>"
Response.write "cmemo : "&cmemo&"<br>"
Response.write "ctel : "&ctel&"<br>"
Response.write "ctel2 : "&ctel2&"<br>"
Response.write "cfax : "&cfax&"<br>"
Response.write "cfile : "&cfile&"<br>"
Response.write "board_file_name1 : "&board_file_name1&"<br>"
'Response.end

SQL="Select * From tk_customer Where cnumber='"&cnumber&"' "
Rs.open SQL,Dbcon
if not (Rs.EOF or Rs.BOF ) then

    Response.write "<script>alert('중복된 사업자 번호가 있습니다.');location.replace('/mem/corplist.asp');</script>"

else
    SQL=" Insert into tk_customer (cname, caddr1, caddr2, cpost, cnumber, cnick, ctkidx, cstatus, cbuy, csales, cceo, ctype, citem, cemail1 "
    SQL=SQL&" , cgubun, cmove, cbran, cdlevel, cflevel, calevel, cslevel, csylevel, cmemo, cfile, cfax, ctel, ctel2 , cwdate ) "
    SQL=SQL&" Values ('"&cname&"', '"&caddr1&"', '"&caddr2&"', '"&cpost&"', '"&cnumber&"', '"&cnick&"', '"&ctkidx&"', '"&cstatus&"', '"&cbuy&"' "
    SQL=SQL&" , '"&csales&"', '"&cceo&"','"&ctype&"', '"&citem&"', '"&cemail1&"', '"&cgubun&"', '"&cmove&"', '"&cbran&"', '"&cdlevel&"' "
    SQL=SQL&" , '"&cflevel&"', '"&calevel&"','"&cslevel&"', '"&csylevel&"', '"&cmemo&"', '"&board_file_name1&"', '"&cfax&"', '"&ctel&"', '"&ctel2&"', getdate() ) "
    Response.write (SQL)&"<br>"
    'Response.end
    Dbcon.Execute (SQL) 

end if

Response.write "<script>alert('업체가 등록되었습니다.');location.replace('corplist.asp');</script>"

set Rs=Nothing
call dbClose()
%> 