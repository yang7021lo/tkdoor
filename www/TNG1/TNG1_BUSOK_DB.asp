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
gotopage = Request("gotopage")
rSearchWord    = Request("SearchWord")
' Request 값을 받아 변수에 저장
rTNG_Busok_idx        = Request("TNG_Busok_idx")
T_Busok_name_f       = Request("T_Busok_name_f")
TNG_Busok_comb_st    = Request("TNG_Busok_comb_st")
TNG_Busok_name1_Num  = Request("TNG_Busok_name1_Number")
SJB_TYPE_NO          = Request("SJB_TYPE_NO")
TNG_Busok_name_KR    = Request("TNG_Busok_name_KR")
TNG_Busok_name1      = Request("TNG_Busok_name1")
TNG_Busok_name2      = Request("TNG_Busok_name2")
TNG_Busok_comb_al1   = Request("TNG_Busok_comb_al1")
TNG_Busok_comb_alBJ1 = Request("TNG_Busok_comb_alBJ1")
TNG_Busok_comb_al2   = Request("TNG_Busok_comb_al2")
TNG_Busok_comb_alBJ2 = Request("TNG_Busok_comb_alBJ2")
TNG_Busok_comb_pa1   = Request("TNG_Busok_comb_pa1")
TNG_Busok_comb_pa2   = Request("TNG_Busok_comb_pa2")
TNG_Busok_length1    = Request("TNG_Busok_length1")
TNG_Busok_length2    = Request("TNG_Busok_length2")
TNG_Busok_BLACK      = Request("TNG_Busok_BLACK")
TNG_Busok_PAINT      = Request("TNG_Busok_PAINT")
TNG_Busok_comb_al3   = Request("TNG_Busok_comb_al3")
TNG_Busok_comb_alBJ3 = Request("TNG_Busok_comb_alBJ3")
TNG_Busok_comb_pa3   = Request("TNG_Busok_comb_pa3")
TNG_Busok_images     = Request("TNG_Busok_images")
TNG_Busok_CAD        = Request("TNG_Busok_CAD")
WHICHI_FIX           = Request("WHICHI_FIX")
WHICHI_AUTO          = Request("WHICHI_AUTO")
WHICHI_FIXname           = Request("WHICHI_FIXname")
WHICHI_AUTOname          = Request("WHICHI_AUTOname")
SJB_FA               = Request("SJB_FA")
midx                 = Request("midx")
wdate                = Request("wdate")
emidx                = Request("emidx")
ewdate               = Request("ewdate")

' Response.Write "rTNG_Busok_idx : " & rTNG_Busok_idx & "<br>"
' Response.Write "T_Busok_name_f : " & T_Busok_name_f & "<br>"
' Response.Write "TNG_Busok_comb_st : " & TNG_Busok_comb_st & "<br>"
' Response.Write "TNG_Busok_name1_Number : " & TNG_Busok_name1_Num & "<br>"
' Response.Write "SJB_TYPE_NO : " & SJB_TYPE_NO & "<br>"
' Response.Write "TNG_Busok_name_KR : " & TNG_Busok_name_KR & "<br>"
' Response.Write "TNG_Busok_name1 : " & TNG_Busok_name1 & "<br>"
' Response.Write "TNG_Busok_name2 : " & TNG_Busok_name2 & "<br>"
' Response.Write "TNG_Busok_comb_al1 : " & TNG_Busok_comb_al1 & "<br>"
' Response.Write "TNG_Busok_comb_alBJ1 : " & TNG_Busok_comb_alBJ1 & "<br>"
' Response.Write "TNG_Busok_comb_al2 : " & TNG_Busok_comb_al2 & "<br>"
' Response.Write "TNG_Busok_comb_alBJ2 : " & TNG_Busok_comb_alBJ2 & "<br>"
' Response.Write "TNG_Busok_comb_pa1 : " & TNG_Busok_comb_pa1 & "<br>"
' Response.Write "TNG_Busok_comb_pa2 : " & TNG_Busok_comb_pa2 & "<br>"
' Response.Write "TNG_Busok_length1 : " & TNG_Busok_length1 & "<br>"
' Response.Write "TNG_Busok_length2 : " & TNG_Busok_length2 & "<br>"
' Response.Write "TNG_Busok_BLACK : " & TNG_Busok_BLACK & "<br>"
' Response.Write "TNG_Busok_PAINT : " & TNG_Busok_PAINT & "<br>"
' Response.Write "TNG_Busok_comb_al3 : " & TNG_Busok_comb_al3 & "<br>"
' Response.Write "TNG_Busok_comb_alBJ3 : " & TNG_Busok_comb_alBJ3 & "<br>"
' Response.Write "TNG_Busok_comb_pa3 : " & TNG_Busok_comb_pa3 & "<br>"
' Response.Write "TNG_Busok_images : " & TNG_Busok_images & "<br>"
' Response.Write "TNG_Busok_CAD : " & TNG_Busok_CAD & "<br>"
' Response.Write "WHICHI_FIX : " & WHICHI_FIX & "<br>"
' Response.Write "WHICHI_AUTO : " & WHICHI_AUTO & "<br>"
' Response.Write "SJB_FA : " & SJB_FA & "<br>"
' Response.Write "midx : " & midx & "<br>"
' Response.Write "wdate : " & wdate & "<br>"
' Response.Write "emidx : " & emidx & "<br>"
' Response.Write "ewdate : " & ewdate & "<br>"

'response.end
if part="delete" then 
    SQL="Delete From TNG_Busok  Where TNG_Busok_idx='"&rTNG_Busok_idx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('TNG1_BUSOK.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"');</script>"
else 
    if rTNG_Busok_idx="0" then 
        SQL = "INSERT INTO TNG_Busok (T_Busok_name_f, TNG_Busok_comb_st, TNG_Busok_name1_Number, SJB_TYPE_NO, "
        SQL = SQL & "TNG_Busok_name_KR, TNG_Busok_name1, TNG_Busok_name2, TNG_Busok_comb_al1, TNG_Busok_comb_alBJ1, "
        SQL = SQL & "TNG_Busok_comb_al2, TNG_Busok_comb_alBJ2, TNG_Busok_comb_pa1, TNG_Busok_comb_pa2, "
        SQL = SQL & "TNG_Busok_length1, TNG_Busok_length2, TNG_Busok_BLACK, TNG_Busok_PAINT, "
        SQL = SQL & "TNG_Busok_comb_al3, TNG_Busok_comb_alBJ3, TNG_Busok_comb_pa3, TNG_Busok_images, TNG_Busok_CAD, "
        SQL = SQL & "WHICHI_FIX, WHICHI_AUTO, SJB_FA, midx, wdate, emidx, ewdate) "
        SQL = SQL & "VALUES ('" & T_Busok_name_f & "', '" & TNG_Busok_comb_st & "', '" & TNG_Busok_name1_Num & "', '" & SJB_TYPE_NO & "', "
        SQL = SQL & "'" & TNG_Busok_name_KR & "', '" & TNG_Busok_name1 & "', '" & TNG_Busok_name2 & "', '" & TNG_Busok_comb_al1 & "', '" & TNG_Busok_comb_alBJ1 & "', "
        SQL = SQL & "'" & TNG_Busok_comb_al2 & "', '" & TNG_Busok_comb_alBJ2 & "', '" & TNG_Busok_comb_pa1 & "', '" & TNG_Busok_comb_pa2 & "', "
        SQL = SQL & "'" & TNG_Busok_length1 & "', '" & TNG_Busok_length2 & "', '" & TNG_Busok_BLACK & "', '" & TNG_Busok_PAINT & "', "
        SQL = SQL & "'" & TNG_Busok_comb_al3 & "', '" & TNG_Busok_comb_alBJ3 & "', '" & TNG_Busok_comb_pa3 & "', '" & TNG_Busok_images & "', '" & TNG_Busok_CAD & "', "
        SQL = SQL & "'" & WHICHI_FIX & "', '" & WHICHI_AUTO & "', '" & SJB_FA & "', '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE())"

        'Response.write (SQL)&"<br>"
        'Response.END
        Dbcon.Execute(SQL)

        SQL=" Select max(TNG_Busok_idx) From TNG_Busok  "
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            TNG_Busok_idx = Rs(0)
        End If
        Rs.Close

        response.write "<script>location.replace('TNG1_BUSOK.asp?gotopage=" & gotopage & "&TNG_Busok_idx="&TNG_Busok_idx&"&SearchWord="&rSearchWord&"#"&TNG_Busok_idx&"');</script>"
    else
        SQL = "UPDATE TNG_Busok SET "
        SQL = SQL & "T_Busok_name_f = '" & T_Busok_name_f & "', TNG_Busok_comb_st = '" & TNG_Busok_comb_st & "', "
        SQL = SQL & "TNG_Busok_name1_Number = '" & TNG_Busok_name1_Num & "', SJB_TYPE_NO = '" & SJB_TYPE_NO & "', "
        SQL = SQL & "TNG_Busok_name_KR = '" & TNG_Busok_name_KR & "', TNG_Busok_name1 = '" & TNG_Busok_name1 & "', "
        SQL = SQL & "TNG_Busok_name2 = '" & TNG_Busok_name2 & "', TNG_Busok_comb_al1 = '" & TNG_Busok_comb_al1 & "', "
        SQL = SQL & "TNG_Busok_comb_alBJ1 = '" & TNG_Busok_comb_alBJ1 & "', TNG_Busok_comb_al2 = '" & TNG_Busok_comb_al2 & "', "
        SQL = SQL & "TNG_Busok_comb_alBJ2 = '" & TNG_Busok_comb_alBJ2 & "', TNG_Busok_comb_pa1 = '" & TNG_Busok_comb_pa1 & "', "
        SQL = SQL & "TNG_Busok_comb_pa2 = '" & TNG_Busok_comb_pa2 & "', TNG_Busok_length1 = '" & TNG_Busok_length1 & "', "
        SQL = SQL & "TNG_Busok_length2 = '" & TNG_Busok_length2 & "', TNG_Busok_BLACK = '" & TNG_Busok_BLACK & "', "
        SQL = SQL & "TNG_Busok_PAINT = '" & TNG_Busok_PAINT & "', TNG_Busok_comb_al3 = '" & TNG_Busok_comb_al3 & "', "
        SQL = SQL & "TNG_Busok_comb_alBJ3 = '" & TNG_Busok_comb_alBJ3 & "', TNG_Busok_comb_pa3 = '" & TNG_Busok_comb_pa3 & "', "
        
        SQL = SQL & "WHICHI_FIX = '" & WHICHI_FIX & "', WHICHI_AUTO = '" & WHICHI_AUTO & "', SJB_FA = '" & SJB_FA & "', "
        SQL = SQL & "emidx = '" & C_midx & "', ewdate = GETDATE() "
        SQL = SQL & "WHERE TNG_Busok_idx = '" & rTNG_Busok_idx & "'"
        'Response.END
        Dbcon.Execute(SQL)
        response.write "<script>location.replace('TNG1_BUSOK.asp?gotopage=" & gotopage & "&TNG_Busok_idx="&rTNG_Busok_idx&"&SearchWord="&rSearchWord&"#"&rTNG_Busok_idx&"');</script>"
    end if
end if

set Rs = Nothing
call dbClose()
%>

