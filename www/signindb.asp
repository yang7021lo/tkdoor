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
%>
<%

mname=encodestr(Request("mname"))
mkakao=encodestr(Request("mkakao"))
 
mmkakao=md5(mkakao)


'response.write mname&"<br>"
'response.write mkakao&"<br>"
'response.write mmkakao&"<br>"
'response.write mhp&"<br>"
'response.write mfax&"<br>"
'response.write kmail&"<br>"
'response.write miid&"<br>"
'response.end

 
'response.write miid&"<br>"
'response.end
mmkakao = Replace(mmkakao, "'", "")
mmkakao = Replace(mmkakao, "%", "")
SQL="select midx,  mname, cidx from tk_member where mname='"&mname&"' and mpw='"&mmkakao&"' "
rs.open sql,dbcon,1,1,1
if not (Rs.EOF or Rs.BOF) then
  midx=rs(0)
  mname=rs(1)
  cidx=rs(2)
 
  'response.write mname&"<br>"
  'response.end   

    response.cookies("tk")("c_midx")=midx
    response.cookies("tk")("c_mname")=mname
    response.cookies("tk")("c_cidx")=cidx    
    response.write "<script>location.replace('/ooo/advice/advicem.asp')</script>"



else
response.write "<script>alert('해당하는 정보가 없습니다.');location.replace('/index.asp');</script>"
end if 

rs.close 
%>
<%
Set Rs=Nothing
call dbClose()
%>




