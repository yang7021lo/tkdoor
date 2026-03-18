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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")

copy_bfidx = Request("copy_bfidx")
rSJB_IDX = Request("SJB_IDX")

'Response.Write "copy_bfidx : " & copy_bfidx & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'response.end

if copy_bfidx = "" then
    response.write "<script>alert('잘못된 접근입니다.');history.back();</script>"
    response.end
end if

'=====================
' 1. 원본 tk_barasiF  데이터 조회
'=====================
sql = "SELECT set_name_FIX, set_name_AUTO, WHICHI_FIX, WHICHI_AUTO, xsize, ysize" 
sql = sql & ", pcent, gwsize, gysize, dwsize, dysize"
sql = sql & ", gwsize1, gwsize2, gwsize3, gwsize4, gwsize5"
sql = sql & ", gysize1, gysize2, gysize3, gysize4, gysize5"
sql = sql & ", dwsize1, dysize1, TNG_Busok_idx, TNG_Busok_idx2"
sql = sql & ", TNG_Busok_idx3, bfimg1, bfimg2, bfimg3, bfimg4 "
sql = sql & ", boyang, boyangname, boyangtype "
sql = sql & "FROM tk_barasiF WHERE bfidx = '" & copy_bfidx & "'"
'response.write (SQL)&"<br>"
'response.end
Rs.Open sql, Dbcon, 1, 1
If Not (Rs.EOF Or Rs.BOF) Then
    set_name_FIX   = Rs(0)
    set_name_AUTO  = Rs(1)
    WHICHI_FIX     = Rs(2)
    WHICHI_AUTO    = Rs(3)
    xsize          = Rs(4)
    ysize          = Rs(5)
    pcent          = Rs(6)
    gwsize         = Rs(7)
    gysize         = Rs(8)
    dwsize         = Rs(9)
    dysize         = Rs(10)
    gwsize1        = Rs(11)
    gwsize2        = Rs(12)
    gwsize3        = Rs(13)
    gwsize4        = Rs(14)
    gwsize5        = Rs(15)
    gysize1        = Rs(16)
    gysize2        = Rs(17)
    gysize3        = Rs(18)
    gysize4        = Rs(19)
    gysize5        = Rs(20)
    dwsize1        = Rs(21)
    dysize1        = Rs(22)
    TNG_Busok_idx  = Rs(23)
    TNG_Busok_idx2 = Rs(24)
    TNG_Busok_idx3 = Rs(25)
    bfimg1         = Rs(26)
    bfimg2         = Rs(27)
    bfimg3         = Rs(28)
    bfimg4         = Rs(29)
    boyang       = Rs(30)
    boyangname   = Rs(31)
    boyangtype   = Rs(32)
End If
Rs.Close

if (Trim(set_name_FIX) = "" or IsNull(set_name_FIX)) and (Trim(set_name_AUTO) <> "" and Not IsNull(set_name_AUTO)) then

    yset_name_AUTO = set_name_AUTO & "_복사"

else

    yset_name_FIX = set_name_FIX & "_복사"

end if

' 2. 새로운 tk_barasiF 데이터 Insert
sql = "INSERT INTO tk_barasiF ( sjb_idx, set_name_FIX, set_name_AUTO, WHICHI_FIX"
sql = sql & ", WHICHI_AUTO, xsize, ysize, pcent, gwsize"
sql = sql & ", gysize, dwsize, dysize, gwsize1, gwsize2"
sql = sql & ", gwsize3, gwsize4, gwsize5, gysize1, gysize2"
sql = sql & ", gysize3, gysize4, gysize5, dwsize1, dysize1"
sql = sql & ", bfimg1, bfimg2, bfimg3, bfimg4, TNG_Busok_idx"
sql = sql & ", TNG_Busok_idx2, TNG_Busok_idx3, bfmidx, bfwdate "
sql = sql & ", boyang, boyangname, boyangtype ) "

sql = sql & "VALUES ( '" & rSJB_IDX & "', '" & yset_name_FIX & "', '" & yset_name_AUTO & "', '" & WHICHI_FIX & "'"
sql = sql & ", '" & WHICHI_AUTO & "', '" & xsize & "', '" & ysize & "', '" & pcent & "', '" & gwsize & "'"
sql = sql & ", '" & gysize & "', '" & dwsize & "', '" & dysize & "', '" & gwsize1 & "', '" & gwsize2 & "'"
sql = sql & ", '" & gwsize3 & "', '" & gwsize4 & "', '" & gwsize5 & "', '" & gysize1 & "', '" & gysize2 & "'"
sql = sql & ", '" & gysize3 & "', '" & gysize4 & "', '" & gysize5 & "', '" & dwsize1 & "', '" & dysize1 & "'"
sql = sql & ", '" & bfimg1 & "', '" & bfimg2 & "', '" & bfimg3 & "', '" & bfimg4 & "', '" & TNG_Busok_idx & "'"
sql = sql & ", '" & TNG_Busok_idx2 & "', '" & TNG_Busok_idx3 & "', '" & c_midx & "', getdate() "
sql = sql & ", '" & boyang & "', '" & boyangname & "', '" & boyangtype & "' ) "
'response.write (SQL)&"<br>"
'response.end
Dbcon.Execute sql

' 3. 새로 생성된 bfidx 값 조회
    sql = "SELECT ISNULL(MAX(bfidx), 0)  FROM tk_barasiF"
    Rs.Open sql, Dbcon
        new_bfidx = Rs(0)
    Rs.Close


'=====================
' 4. 해당 new_bfidx 의 모든 baidx 반복  가져오기
'=====================
sql = "SELECT baidx, baname, bachannel, g_bogang, g_busok, bastatus"
sql = sql & ", xsize, ysize, sx1, sx2, sy1, sy2 "
sql = sql & "FROM tk_barasi WHERE bfidx = '" & copy_bfidx & "'"
'response.write (SQL)&"<br>"
'response.end
Rs.Open sql, Dbcon, 1, 1
Do While Not Rs.EOF

    copy_baidx = Rs(0)
    baname     = Rs(1)
    bachannel  = Rs(2)
    g_bogang   = Rs(3)
    g_busok    = Rs(4)
    bastatus   = Rs(5)
    xsize      = Rs(6)
    ysize      = Rs(7)
    sx1        = Rs(8)
    sx2        = Rs(9)
    sy1        = Rs(10)
    sy2        = Rs(11)

    If Trim(baname) = "" Then

        If set_name_FIX <> "" Then
            baname = set_name_FIX
        ElseIf set_name_AUTO <> "" Then
            baname = set_name_AUTO
        Else
            baname = "무명"
        End If

    End If

    new_baname = baname 
    'response.write "new_baname : " & new_baname & "<br>"

        ' 5. tk_barasi 인서트
        sql2 = "INSERT INTO tk_barasi (baname, bamidx, bawdate, bastatus"
        sql2 = sql2 & ", xsize, ysize, sx1, sx2, sy1, sy2, bachannel, g_bogang, g_busok, bfidx) "
        sql2 = sql2 & "VALUES ('" & new_baname & "', '" & c_midx & "', getdate(), '" & bastatus & "'"
        sql2 = sql2 & ", '" & xsize & "', '" & ysize & "', '" & sx1 & "', '" & sx2 & "', '" & sy1 & "', '" & sy2 & "'"
        sql2 = sql2 & ", '" & bachannel & "', '" & g_bogang & "', '" & g_busok & "', '" & new_bfidx & "')"
        'response.write (sql2)&"<br>"
        'response.end
        Dbcon.Execute sql2

        ' 6. 새로 생성된 baidx 값 조회
        sql3 = "SELECT MAX(baidx) FROM tk_barasi"
        Rs1.Open sql3, Dbcon, 1, 1
            new_baidx = Rs1(0)
        Rs1.Close

        '=====================
        ' 7. tk_barasisub 복사
        '=====================
        sql4 = "SELECT x1, y1, x2, y2, bassize, basdirection, final, ysr1, ysr2, ody, idv, accsize, kak, basp2 "
        sql4 = sql4 & "FROM tk_barasisub WHERE baidx = '" & copy_baidx & "' ORDER BY basidx ASC"
        'response.write (sql4)&"<br>"
        'response.end
        Rs2.Open sql4, Dbcon, 1, 1
        Do While Not Rs2.EOF
            x1           = Rs2(0)
            y1           = Rs2(1)
            x2           = Rs2(2)
            y2           = Rs2(3)
            bassize      = Rs2(4)
            basdirection = Rs2(5)
            final        = Rs2(6)
            ysr1         = Rs2(7)
            ysr2         = Rs2(8)
            ody          = Rs2(9)
            idv          = Rs2(10)
            accsize      = Rs2(11)
            kak          = Rs2(12)
            basp2        = Rs2(13)

            sql5 = "INSERT INTO tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection"
            sql5 = sql5 & ", basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak, basp2, bfidx) "
            sql5 = sql5 & "VALUES ('" & new_baidx & "', '" & x1 & "', '" & y1 & "', '" & x2 & "', '" & y2 & "', "
            sql5 = sql5 & "'" & bassize & "', '" & basdirection & "', '" & c_midx & "', getdate(), '" & final & "', "
            sql5 = sql5 & "'" & ysr1 & "', '" & ysr2 & "', '" & ody & "', '" & idv & "', '" & accsize & "', '" & kak & "', '" & basp2 & "', '" & new_bfidx & "')"
            'response.write (sql5)&"<br>"
            'response.end
            Dbcon.Execute sql5

            Rs2.MoveNext
        Loop
        Rs2.Close

        Rs.MoveNext
    Loop
    Rs.Close


'=====================
' 복사 완료 후 이동
'=====================
response.write "<script>alert('복사 완료');location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?bfidx=" & new_bfidx & "&SJB_IDX=" & rSJB_IDX & "');</script>"

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
