
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
Set Rs1 = Server.CreateObject("ADODB.Recordset")

SQL = "SELECT A.sidx, A.baridx, A.barNAME, A.rgoidx, A.goname, A.FULL_NAME "
SQL = SQL & ", A.smtype, A.smproc, A.smal, A.smalqu, A.smst, A.smstqu , A.smglass, A.smgrid, A.tagongfok, A.tagonghigh,A.smnote,A.smcomb"
SQL = SQL & ", B.Buidx, B.BUNAME, B.BUSELECT "
SQL = SQL & ", B.SM_GLASSTYPE_1, B.SM_GLASSTYPE_2, B.SM_GLASSTYPE_3, B.SM_GLASSTYPE_4, B.SM_GLASSTYPE_5 "
SQL = SQL & ", B.barNAME1, B.barNAME2, B.barNAME3, B.barNAME4, B.barNAME5 , B.BUPAINT "
SQL = SQL & ", B.BUST_GLASS, B.BUST_GLASStype1, B.BUST_GLASStype2, B.BUST_GLASStype3, B.BUST_GLASStype4, B.BUST_GLASStype5 "
SQL = SQL & ", B.BUST_N_CUT_STATUS, B.BUST_HL_COIL, B.BUST_NUCUT_ShRing, B.BUST_NUCUT_1, B.BUST_NUCUT_2 "
SQL = SQL & ", B.BUST_VCUT_ShRing, B.BUST_VCUT_1, B.BUST_VCUT_2, B.BUST_VCUT_CH "
SQL = SQL & " FROM TKM1 A "
SQL = SQL & " JOIN BUSOK1 B ON A.buidx = B.Kuidx "
SQL = SQL & " WHERE A.smcomb = 1 "
SQL = SQL & "AND (A.barNAME3 = B.barNAME3 OR A.barNAME1 = B.barNAME1) "
SQL = SQL & "AND B.BU_GLASSTYPE_5 = '에치바무홈' "

SQL = SQL & "AND A.SM_GLASSTYPE_5 = '다대무홈' "

response.write(SQL)&"<br>"
'response.end
Rs.Open SQL, Dbcon, 1, 1, 1

    If Not (Rs.EOF Or Rs.BOF) Then
    Do While Not Rs.EOF
        sidx              = rs(0)   ' A.sidx 값
        baridx            = rs(1)   ' A.baridx 값
        barNAME           = rs(2)   ' A.barNAME 값
        rgoidx            = rs(3)   ' A.rgoidx 값
        goname            = rs(4)   ' A.goname 값
        FULL_NAME        = rs(5)   ' A.FULL_NAME 값
        smtype           = rs(6)   ' A.smtype 값
        smproc           = rs(7)   ' A.smproc 값
        smal             = rs(8)   ' A.smal 값
        smalqu           = rs(9)   ' A.smalqu 값
        smst             = rs(10)  ' A.smst 값
        smstqu           = rs(11)  ' A.smstqu 값
        smglass          = rs(12)  ' A.smglass 값
        smgrid           = rs(13)  ' A.smgrid 값
        tagongfok        = rs(14)  ' A.tagongfok 값
        tagonghigh       = rs(15)  ' A.tagonghigh 값
        smnote           = rs(16)  ' A.smnote 값
        smcomb           = rs(17)  ' A.smcomb 값
        Buidx            = rs(18)  ' B.Buidx 값
        BUNAME           = rs(19)  ' B.BUNAME 값
        BUSELECT         = rs(20)  ' B.BUSELECT 값
        SM_GLASSTYPE_1 = rs(21)  ' B.SM_GLASSTYPE_1 값
        SM_GLASSTYPE_2 = rs(22)  ' B.SM_GLASSTYPE_2 값
        SM_GLASSTYPE_3 = rs(23)  ' B.SM_GLASSTYPE_3 값
        SM_GLASSTYPE_4 = rs(24)  ' B.SM_GLASSTYPE_4 값
        SM_GLASSTYPE_5 = rs(25)  ' B.SM_GLASSTYPE_5 값
        barNAME1       = rs(26)  ' B.barNAME1 값
        barNAME2       = rs(27)  ' B.barNAME2 값
        barNAME3       = rs(28)  ' B.barNAME3 값
        barNAME4       = rs(29)  ' B.barNAME4 값
        barNAME5       = rs(30)  ' B.barNAME5 값
        BUPAINT          = rs(31)  ' B.BUPAINT 값
        BUST_GLASS       = rs(32)  ' B.BUST_GLASS 값
        BUST_GLASStype1  = rs(33)  ' B.BUST_GLASStype1 값
        BUST_GLASStype2  = rs(34)  ' B.BUST_GLASStype2 값
        BUST_GLASStype3  = rs(35)  ' B.BUST_GLASStype3 값
        BUST_GLASStype4  = rs(36)  ' B.BUST_GLASStype4 값
        BUST_GLASStype5  = rs(37)  ' B.BUST_GLASStype5 값
        BUST_N_CUT_STATUS = rs(38) ' B.BUST_N_CUT_STATUS 값
        BUST_HL_COIL     = rs(39)  ' B.BUST_HL_COIL 값
        BUST_NUCUT_ShRing = rs(40) ' B.BUST_NUCUT_ShRing 값
        BUST_NUCUT_1     = rs(41)  ' B.BUST_NUCUT_1 값
        BUST_NUCUT_2     = rs(42)  ' B.BUST_NUCUT_2 값
        BUST_VCUT_ShRing = rs(43)  ' B.BUST_VCUT_ShRing 값
        BUST_VCUT_1      = rs(44)  ' B.BUST_VCUT_1 값
        BUST_VCUT_2      = rs(45)  ' B.BUST_VCUT_2 값
        BUST_VCUT_CH     = rs(46)  ' B.BUST_VCUT_CH 값

        if jsidx ="" then jsidx=sidx end if
        if ksidx ="" then ksidx=sidx end if
        rdade=right(BUSELECT,3)
        select case rdade
        case  "다대바" 
            smtype = "H"
            if smtype="H"  then 
                smproc = "SM_DADE2"
            else 
            ksidx=""
            end if

        case  "에치바" 
            smtype = "W"
            if smtype="W" then 
                smproc = "SM_H4"
            else 
            jsidx=""
            end if

        end select



                SQL = "INSERT INTO TKM1 (sidx, buidx, BUNAME, baridx, barNAME, rgoidx, goname,FULL_NAME, smtype, smproc, smal, smalqu, smst, smstqu, "
                SQL = SQL & "smglass, smgrid, tagongfok, tagonghigh, smnote, smcomb, smmidx, smwdate, smemidx, smewdate, "
                SQL = SQL & "SM_GLASSTYPE_1, SM_GLASSTYPE_2, SM_GLASSTYPE_3, SM_GLASSTYPE_4, SM_GLASSTYPE_5, "
                SQL = SQL & "barNAME1, barNAME2, barNAME3, barNAME4, barNAME5, BUSELECT, BUPAINT, BUST_GLASS, "
                SQL = SQL & "BUST_GLASStype1, BUST_GLASStype2, BUST_GLASStype3, BUST_GLASStype4, BUST_GLASStype5, "
                SQL = SQL & "BUST_N_CUT_STATUS, BUST_HL_COIL, BUST_NUCUT_ShRing, BUST_NUCUT_1, BUST_NUCUT_2, "
                SQL = SQL & "BUST_VCUT_ShRing, BUST_VCUT_1, BUST_VCUT_2, BUST_VCUT_CH, "
                SQL = SQL & "BUST_GLASStype6, BUST_GLASStype7, BUST_GLASStype8, BUST_GLASStype9) "
                SQL = SQL & "VALUES ('" & sidx & "', '" & buidx & "', '" & BUNAME & "', '" & baridx & "', '" & barNAME & "', '" & rgoidx & "', '" & goname & "', '" & FULL_NAME & "','" & smtype & "', '" & smproc & "', '" & smal & "', '" & smalqu & "', '" & smst & "', '" & smstqu & "', "
                SQL = SQL & "'" & smglass & "', '" & smgrid & "', '" & tagongfok & "', '" & tagonghigh & "', '" & smnote & "', '" & smcomb & "', '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE(), "
                SQL = SQL & "'" & SM_GLASSTYPE_1 & "', '" & SM_GLASSTYPE_2 & "', '" & SM_GLASSTYPE_3 & "', '" & SM_GLASSTYPE_4 & "', '" & SM_GLASSTYPE_5 & "', "
                SQL = SQL & "'" & barNAME1 & "', '" & barNAME2 & "', '" & barNAME3 & "', '" & barNAME4 & "', '" & barNAME5 & "', '" & BUSELECT & "', '" & BUPAINT & "', '" & BUST_GLASS & "', "
                SQL = SQL & "'" & BUST_GLASStype1 & "', '" & BUST_GLASStype2 & "', '" & BUST_GLASStype3 & "', '" & BUST_GLASStype4 & "', '" & BUST_GLASStype5 & "', "
                SQL = SQL & "'" & BUST_N_CUT_STATUS & "', '" & BUST_HL_COIL & "', '" & BUST_NUCUT_ShRing & "', '" & BUST_NUCUT_1 & "', '" & BUST_NUCUT_2 & "', "
                SQL = SQL & "'" & BUST_VCUT_ShRing & "', '" & BUST_VCUT_1 & "', '" & BUST_VCUT_2 & "', '" & BUST_VCUT_CH & "', "
                SQL = SQL & "'" & BUST_GLASStype6 & "', '" & BUST_GLASStype7 & "', '" & BUST_GLASStype8 & "', '" & BUST_GLASStype9 & "')"

                response.write (SQL) &"<br><br>"
                'Dbcon.Execute (SQL) 

Rs.movenext
Loop
End If 
Rs.Close   

set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>


