<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

rsjb_idx=Request("sjb_idx")
rsjbsub_Idx=Request("sjbsub_Idx")
rbfidx=Request("bfidx")

' 전체 길이에서 쉼표를 제거한 길이를 빼서 쉼표 개수 구하기
commaCount = Len(rbfidx) - Len(Replace(rbfidx, ",", ""))

spl_rbfidx=split(rbfidx)

REsponse.write rsjb_idx&"<br>"
REsponse.write rbfidx&"<br>"
REsponse.write commaCount&"<br>"
REsponse.write rpummokname&"<br>"

For k = 0 to commaCount




SQL="INSERT  into tng_sjbSub (rsjb_idx,rbfidx,rpummokname) "
SQL=SQL&" Values ('"&rsjb_idx&"','"&spl_rbfidx(k)&"','"&rpummokname&"')"
REsponse.write (SQL)&"<br>"
Next

 

'part=Request("part")

' 파일 및 폼 데이터 읽기

'rSJB_IDX       = Request("SJB_IDX")
'rSJB_TYPE_NO   = Request("SJB_TYPE_NO")
'rSJB_TYPE_NAME = Request("SJB_TYPE_NAME")
'rSJB_barlist   = Request("SJB_barlist")
'rSJB_FA        = Request("SJB_FA")
'rSJB_Paint     = Request("SJB_Paint")
'rSJB_St        = Request("SJB_St")
'rSJB_Al        = Request("SJB_Al")
'rSJB_midx      = Request("SJB_midx")
'rSJB_mdate     = Request("SJB_mdate")
'rSJB_meidx     = Request("SJB_meidx")
'rSJB_medate    = Request("SJB_medate")
'rSearchWord    = Request("SearchWord")
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'Response.Write "rSJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
'Response.Write "rSJB_barlist : " & rSJB_barlist & "<br>"
'Response.Write "rSJB_Paint : " & rSJB_Paint & "<br>"
'Response.Write "rSJB_St : " & rSJB_St & "<br>"
'Response.Write "rSJB_Al : " & rSJB_Al & "<br>"
'Response.Write "rSJB_midx : " & rSJB_midx & "<br>"
'Response.Write "rSJB_mdate : " & rSJB_mdate & "<br>"
'Response.Write "rSJB_meidx : " & rSJB_meidx & "<br>"
'Response.Write "rSJB_medate : " & rSJB_medate & "<br>"
'Response.end

'if part="delete" then 
'    SQL="Delete From TNG_SJB Where SJB_IDX='"&rSJB_IDX&"' "
    'Response.write (SQL)&"<br>"
'    Dbcon.Execute (SQL)

'    response.write "<script>location.replace('TNG1_GREEMLIST3.asp?gotopage=" & gotopage & "&SearchWord=" & rSearchWord & "#" & SJB_IDX & "');</script>"

'else 
'    if sJB_IDX="0" then 
'        SQL = "INSERT INTO TNG_SJB (SJB_TYPE_NO, SJB_TYPE_NAME, SJB_barlist, SJB_FA, SJB_Paint, SJB_St, SJB_Al, SJB_midx, SJB_mdate, SJB_meidx, SJB_medate) "
'        SQL = SQL & "VALUES ('" & rSJB_TYPE_NO & "', '" & rSJB_TYPE_NAME & "', '" & rSJB_barlist & "', '"&rSJB_FA&"' "
'        SQL = SQL & ", '"& rSJB_Paint & ", " & rSJB_St & ", " & rSJB_Al & ", " & C_midx & ",GETDATE(), " & C_midx & ", GETDATE())"
'        Dbcon.Execute(SQL)
        'Response.write (SQL)&"<br>"
'        response.write "<script>alert('입력이 완료되었습니다.');location.replace('TNG1_GREEMLIST3.asp?gotopage=" & gotopage & "&SearchWord=" & rSearchWord & "#" & SJB_IDX & "');</script>"
'    else
'        SQL = "UPDATE TNG_SJB SET "
'        SQL = SQL & " SJB_TYPE_NO = '" & rSJB_TYPE_NO & "', SJB_TYPE_NAME = '" & rSJB_TYPE_NAME & "', SJB_barlist = '" & rSJB_barlist & "' "
'        SQL = SQL & ", SJB_FA='" & rSJB_FA & "', SJB_Paint = '" & rSJB_Paint & "', SJB_St = '" & rSJB_St & "', SJB_Al = '" & rSJB_Al & "'  "
'        SQL = SQL & ", SJB_meidx = '" &C_midx & "', SJB_medate = GETDATE() "
'        SQL = SQL & " WHERE SJB_IDX = '" & rSJB_IDX & "' "
        'Response.write(SQL) & "<br>"
'        Dbcon.Execute(SQL)
'        response.write "<script>location.replace('TNG1_GREEMLIST3.asp?gotopage=" & gotopage & "&SJB_IDX=" & rSJB_IDX & "&SearchWord=" & rSearchWord & "#" & rSJB_IDX & "');</script>"
'    end if
'end if

set Rs = Nothing
call dbClose()
%>
