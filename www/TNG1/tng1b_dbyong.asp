<!DOCTYPE html>
<html lang="en">
<head>
<%@codepage="65001" Language="vbscript"%>
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
Set Rs=Server.CreateObject("ADODB.Recordset")
Set Rs1=Server.CreateObject("ADODB.Recordset")



'삭제 요청 처리 시작
'====================
gubun=Request("gubun")


if gubun="delete" then
  rsjcidx=Request("sjcidx")
  rsjmidx=Request("sjmidx")
  rsjidx=Request("sjidx")

  SQL=" Update tk_yongcha set ystatus='0' where sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)
  response.write "<script>location.replace('tng1b.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"');</script>"

end if
'====================
'삭제 요청 처리 끝
%>
<%
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_bfimg

rsjcidx = encodesTR(uploadform("sjcidx"))
rsjmidx = encodesTR(uploadform("sjmidx"))
rsjidx = encodesTR(uploadform("sjidx"))
ryidx = encodesTR(uploadform("yidx"))
ryname = encodesTR(uploadform("yname"))
rytel = encodesTR(uploadform("ytel"))
ryaddr = encodesTR(uploadform("yaddr"))
rydate = encodesTR(uploadform("ydate"))
ydateh = encodesTR(uploadform("ydateh"))
rydate = rydate&" "&ydateh
rymemo = encodesTR(uploadform("ymemo"))
rycarnum = encodesTR(uploadform("ycarnum"))
rygisaname = encodesTR(uploadform("ygisaname"))
rygisatel = encodesTR(uploadform("ygisatel"))
rycostyn = encodesTR(uploadform("ycostyn"))
ryprepay = encodesTR(uploadform("yprepay"))
rystatus = encodesTR(uploadform("ystatus"))

'bfimg = uploadform("bfimg")
'uploadform.AutoMakeFolder = True
'uploadform.DefaultPath=DefaultPath_bfimg
'bfimg = uploadform("bfimg").Save( ,false)   '실질적인 파일 저장
'board_file_name1 = uploadform("bfimg").LastSavedFileName '파일저장 경로에서 파일명과 확장자만 board_file_name1변수에 저장한다.
'Response.write buidx&"<br>"
'Response.write board_file_name1&"<br>"
'if bfimg<>"" then 
'    splcyj=split(board_file_name1,".")
'    afilename=splcyj(0) 'aaaa'
'    bfilename=splcyj(1) 'pdf/jpg/hwp'
'    board_file_name1=ymdhns&"."&bfilename
'    board_file_name0 = uploadform.SaveAs(board_file_name1, False)        
'end if 
'uploadform.DeleteFile bfimg 

'기존 용차 정보가 있다면 ystatus를 0으로 변경하고 수정자와 수정일시 등록하고 새로 등록한다.
if ryidx<>"" then 
  SQL=" Update tk_yongcha set ystatus='0', ymeidx='"&C_midx&"', ywedate=getdate() Where yidx='"&ryidx&"' "
  dbCon.execute (SQL)
end if
  SQL=" Insert into tk_yongcha (sjidx, yname, ytel, yaddr, ydate, ymemo, ycarnum, ygisaname, ygisatel, ycostyn, yprepay, ystatus, ymidx, ywdate, ymeidx, ywedate ) "
  SQL=SQL&" Values ('"&rsjidx&"', '"&ryname&"', '"&rytel&"', '"&ryaddr&"', '"&rydate&"', '"&rymemo&"', '"&rycarnum&"', '"&rygisaname&"', '"&rygisatel&"' "
  SQL=SQL&" , '"&rycostyn&"', '"&ryprepay&"', '1', '"&C_midx&"', getdate(), '"&C_midx&"', getdate() )"
  Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)

response.write "<script>location.replace('tng1b.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"');</script>"

%>
<%
Set Rs=Nothing
call dbClose()
%>




