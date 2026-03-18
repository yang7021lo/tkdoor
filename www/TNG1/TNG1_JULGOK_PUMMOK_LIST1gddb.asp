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

part=Request("part")
gotopage=Request("gotopage")





' Request 값을 받아 변수에 저장
rSJB_IDX       = Request("SJB_IDX")
rbfidx         = Request("bfidx")
rset_name_FIX  = Request("set_name_FIX")
rset_name_AUTO = Request("set_name_AUTO")
rWHICHI_FIX    = Request("WHICHI_FIX")
rWHICHI_AUTO   = Request("WHICHI_AUTO")
rxsize         = Request("xsize")
rysize         = Request("ysize")
rbfimg1        = Request("bfimg1")
rbfimg2        = Request("bfimg2")
rbfimg3        = Request("bfimg3")

rbfmidx        = Request("bfmidx")
rbfwdate       = Request("bfwdate")
rbfemidx       = Request("bfemidx")
rbfewdate      = Request("bfewdate")
rTNG_Busok_idx      = Request("TNG_Busok_idx")
rTNG_Busok_idx2      = Request("TNG_Busok_idx2")

rgwsize  = Request("gwsize")
rgysize  = Request("gysize")
rdwsize  = Request("dwsize")
rdysize  = Request("dysize")

' 값 출력 (디버깅용)
 'Response.Write "rTNG_Busok_idx : " & rTNG_Busok_idx & "<br>"
 'Response.Write "rTNG_Busok_idx2 : " & rTNG_Busok_idx2 & "<br>"
 'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
 'Response.Write "rbfidx : " & rbfidx & "<br>"
 'Response.Write "part : " & part & "<br>"
' Response.Write "set_name_FIX : " & set_name_FIX & "<br>"
' Response.Write "set_name_AUTO : " & set_name_AUTO & "<br>"
' Response.Write "WHICHI_FIX : " & WHICHI_FIX & "<br>"
' Response.Write "WHICHI_AUTO : " & WHICHI_AUTO & "<br>"
' Response.Write "xsize : " & xsize & "<br>"
' Response.Write "ysize : " & ysize & "<br>"
' Response.Write "bfimg1 : " & bfimg1 & "<br>"
' Response.Write "bfimg2 : " & bfimg2 & "<br>"
' Response.Write "bfidx : " & bfidx & "<br>"
' Response.Write "bfmidx : " & bfmidx & "<br>"
' Response.Write "bfwdate : " & bfwdate & "<br>"
' Response.Write "bfemidx : " & bfemidx & "<br>"
' Response.Write "bfewdate : " & bfewdate & "<br>"
'response.end
if part="delete" then 
    SQL="Delete From tk_barasiF Where bfidx='"&rbfidx&"' "
    'Response.write (SQL)&"<br>"
    'Response.end
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1GD.asp?gotopage="&gotopage&"&SJB_IDX="&rSJB_IDX&"');</script>"
else 
    if rbfidx="0" then 
        SQL = "INSERT INTO tk_barasiF (set_name_FIX, set_name_AUTO, WHICHI_FIX, WHICHI_AUTO, xsize, ysize, bfimg1, bfimg2, sjb_idx, bfmidx, bfwdate, bfemidx, bfewdate, gwsize, gysize, dwsize, dysize) "
        SQL = SQL & "VALUES ('" & rset_name_FIX & "', '" & rset_name_AUTO & "', '" & rWHICHI_FIX & "', '" & rWHICHI_AUTO & "', "
        SQL = SQL & "'" & rxsize & "', '" & rysize & "', '" & rbfimg1 & "', '" & rbfimg2 & "', "
        SQL = SQL & "'" & rsjb_idx & "', '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE(), "
        SQL = SQL & "'" & rgwsize & "', '" & rgysize & "', '" & rdwsize & "', '" & rdysize & "')"
        'Response.write (SQL)&"<br>"
        'Response.END
        Dbcon.Execute(SQL)

        SQL=" Select max(bfidx) From tk_barasiF "
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            bfidx = Rs(0)
        End If
        Rs.Close

        response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1GD.asp?gotopage="&gotopage&"&bfidx="&bfidx&"&sjb_idx="&rsjb_idx&"');</script>"
    else


mode = Request("mode")


'  UPDATE 후 리턴 시
response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1GD.asp?gotopage="&gotopage&"&bfidx=" & rbfidx & "&sjb_idx=" & rsjb_idx & "&mode=" & mode & "');</script>"

'tng_busok TB에서 이미지 정보 불러와 tk_barasiF에 업데이트하기 시작 

        SQL=" select TNG_Busok_images from tng_busok where TNG_busok_idx='"&rTNG_busok_idx&"' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfimg1 = Rs(0)

        End If
        Rs.Close

        SQL=" select TNG_Busok_images from tng_busok where TNG_busok_idx='"&rTNG_busok_idx2&"' "
        'Response.write(SQL) & "<br>"
        'Response.END
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            rbfimg2 = Rs(0)

        End If
        Rs.Close
'tng_busok TB에서 이미지 정보 불러와 tk_barasiF에 업데이트하기 끝
        SQL = "UPDATE tk_barasiF SET "
        SQL = SQL & "set_name_FIX = '" & rset_name_FIX & "', set_name_AUTO = '" & rset_name_AUTO & "', "
        SQL = SQL & "WHICHI_FIX = '" & rWHICHI_FIX & "', WHICHI_AUTO = '" & rWHICHI_AUTO & "', xsize = '" & rxsize & "', ysize = '" & rysize & "', "
        SQL = SQL & "bfimg1 = '" & rbfimg1 & "', bfimg2 = '" & rbfimg2 & "', sjb_idx = '" & rsjb_idx & "', "
        SQL = SQL & "bfemidx = '" & C_midx & "', bfewdate = GETDATE() , TNG_busok_idx='"&rTNG_busok_idx&"' , TNG_busok_idx2='"&rTNG_busok_idx2&"' , "
        SQL = SQL & "gwsize = '" & rgwsize & "', gysize = '" & rgysize & "', "
        SQL = SQL & "dwsize = '" & rdwsize & "', dysize = '" & rdysize & "' "
        SQL = SQL & "WHERE bfidx = '" & rbfidx & "'"
        'Response.write(SQL) & "<br>"
        'Response.END
        Dbcon.Execute(SQL)
        response.write "<script>location.replace('TNG1_JULGOK_PUMMOK_LIST1GD.asp?gotopage="&gotopage&"&bfidx="&rbfidx&"&sjb_idx="&rsjb_idx&"');</script>"
    end if
end if

set Rs = Nothing
call dbClose()
%>

