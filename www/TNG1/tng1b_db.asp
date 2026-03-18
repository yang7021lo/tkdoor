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
  rsjidx=Request("sjidx")
  SQL="Delete from TNG_SJA Where sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)
  response.write "<script>location.replace('tng1b.asp');</script>"

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

sjdate = encodesTR(uploadform("sjdate"))
sjnum = encodesTR(uploadform("sjnum"))
cgdate = encodesTR(uploadform("cgdate"))
djcgdate = encodesTR(uploadform("djcgdate"))
cgtype = encodesTR(uploadform("cgtype"))
cgaddr = encodesTR(uploadform("cgaddr"))
cgset = encodesTR(uploadform("cgset"))
sjmidx = encodesTR(uploadform("sjmidx"))
sjcidx = encodesTR(uploadform("sjcidx"))
midx = encodesTR(uploadform("midx"))
sjidx = encodesTR(uploadform("sjidx"))
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

if sjidx="" then 
  SQL=" Insert into TNG_SJA (sjdate, sjnum, cgdate, djcgdate, cgtype, cgaddr, cgset, sjmidx, sjcidx, midx, wdate, meidx, mewdate) "
  SQL=SQL&" Values ('"&sjdate&"', '"&sjnum&"', '"&cgdate&"', '"&djcgdate&"', '"&cgtype&"', '"&cgaddr&"', '"&cgset&"', '"&sjmidx&"' "
  SQL=SQL&" , '"&sjcidx&"', '"&C_midx&"', getdate(), '"&C_midx&"', getdate())"
  'Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)

  SQL="Select max(sjidx) From TNG_SJA "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    sjidx=Rs(0)
  End If
  Rs.Close
else
  SQL=" Update TNG_SJA set sjdate='"&sjdate&"', sjnum='"&sjnum&"', cgdate='"&cgdate&"', djcgdate='"&djcgdate&"', cgtype='"&cgtype&"' "
  SQL=SQL&" , cgaddr='"&cgaddr&"', cgset='"&cgset&"', sjmidx='"&sjmidx&"', sjcidx='"&sjcidx&"', meidx='"&C_midx&"', mewdate=getdate() "
  SQL=SQL&" Where sjidx='"&sjidx&"' "
  dbCon.execute (SQL)
end if
response.write "<script>location.replace('tng1b.asp?sjcidx="&sjcidx&"&sjmidx="&sjmidx&"&sjidx="&sjidx&"');</script>"

%>
<%
Set Rs=Nothing
call dbClose()
%>




