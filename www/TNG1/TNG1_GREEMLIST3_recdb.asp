
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

rSJB_IDX=Request("SJB_IDX")
rSearchWord=Request("SearchWord")

part=Request("part")
fname=Request("fname")
'Response.write part&"/<br>"

'프레임 생성 시작
'================================
if part="finsert" then 

SQL="insert into tk_frame (fname, fmidx, fwdate, fstatus) values ('"&fname&"', '"&C_midx&"', getdate(), 1)"
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)
'Response.end
SQL="Select max(fidx) From tk_frame "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then  
        rfidx=Rs(0)
    End If
    Rs.Close
response.write "<script>location.replace('TNG1_GREEMLIST3_REC.asp?rfidx="&rfidx&"');</script>"
end If
'================================
'프레임 생성 끝

'프레임 수정 시작 
'================================
if part="fupdate" then 
rfidx=Request("rfidx")
SQL="Update tk_frame set fname='"&fname&"' Where fidx='"&rfidx&"' "
Dbcon.Execute (SQL)
response.write "<script>location.replace('TNG1_GREEMLIST3_REC.asp?rfidx="&rfidx&"');</script>"
end if
'================================
'프레임 수정 끝
'부속 생성 추가하기 시작
'================================
if part="fminsert" then 
rfidx=Request("rfidx")
axi=Request("x-input")
ayi=Request("y-input")
awi=Request("width-input")
ahi=Request("height-input")
WHICHI_AUTO=Request("WHICHI_AUTO")
WHICHI_FIX=Request("WHICHI_FIX")



response.write xinput&"<br>"
response.write yinput&"<br>"
response.write widthinput&"<br>"
response.write heightinput&"<br>"
SQL=" Insert into tk_frameSub (fidx, xi, yi, wi, hi, fmidx, fwdate, WHICHI_AUTO, WHICHI_FIX) "
SQL=SQL&" Values ('"&rfidx&"','"&axi&"','"&ayi&"','"&awi&"','"&ahi&"','"&C_midx&"', getdate(),'"&WHICHI_AUTO&"','"&WHICHI_FIX&"') "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)
'Response.end
response.write "<script>location.replace('TNG1_GREEMLIST3_REC.asp?rfidx="&rfidx&"');</script>"
end if
'================================
'부속 생성 추가하기 끝
'부속 삭제하기 시작
'================================
if part="fmdel" then 
rfidx=Request("rfidx")
rfsidx=Request("rfsidx")

SQL="Delete From tk_frameSub  Where fsidx='"&rfsidx&"' "
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)
'Response.end
response.write "<script>location.replace('TNG1_GREEMLIST3_REC.asp?rfidx="&rfidx&"');</script>"
end if
'================================
'부속 삭제하기 끝

'부속 수정하기 시작
'================================
if part="fmupdate" then 
  rfidx=Request("rfidx")
  rfsidx=Request("rfsidx")
  axi=Request("xi")
  ayi=Request("yi")
  awi=Request("wi")
  ahi=Request("hi")
  WHICHI_AUTO=Request("WHICHI_AUTO")
  WHICHI_FIX=Request("WHICHI_FIX")

  SQL = "Update tk_frameSub "
  SQL = SQL & "Set xi='" & axi & "', yi='" & ayi & "', wi='" & awi & "', hi='" & ahi & "', WHICHI_AUTO='" & WHICHI_AUTO & "', WHICHI_FIX='" & WHICHI_FIX & "' "
  SQL = SQL & "Where fsidx='" & rfsidx & "'"

  'Response.write (SQL) & "<br>"
  Dbcon.Execute (SQL)
  'Response.end
  
  response.write "<script>location.replace('TNG1_GREEMLIST3_REC.asp?rfidx="&rfidx&"&rfsidx="&rfsidx&"');</script>"
end if
'================================
'부속 수정하기 끝



set Rs=Nothing
call dbClose()
%>
