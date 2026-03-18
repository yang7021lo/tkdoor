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

selected_bfidx = Request("selected_bfidx")
rSJB_IDX = Request("SJB_IDX")  

'Response.Write "selected_bfidx : " & selected_bfidx & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "copy_bfidx : " & copy_bfidx & "<br>"
'response.end

If copy_bfidx = "" Or selected_bfidx = "" Then
    Response.Write "<script>alert('잘못된 접근입니다.');history.back();</script>"
    Response.End
End If

'=====================
' 1. selected_bfidx 원본의 tk_barasiF 값 추출
'=====================
sql = "SELECT set_name_FIX, set_name_AUTO, WHICHI_FIX, WHICHI_AUTO, xsize, ysize" 
sql = sql & ", pcent, gwsize, gysize, dwsize, dysize"
sql = sql & ", gwsize1, gwsize2, gwsize3, gwsize4, gwsize5"
sql = sql & ", gysize1, gysize2, gysize3, gysize4, gysize5"
sql = sql & ", dwsize1, dysize1, TNG_Busok_idx, TNG_Busok_idx2"
sql = sql & ", TNG_Busok_idx3, bfimg1, bfimg2, bfimg3, bfimg4 "
sql = sql & "FROM tk_barasiF WHERE bfidx = '" & selected_bfidx & "'"
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
End If
Rs.Close


' 2. copy_bfidx 의 tk_barasiF 를 업데이트
sql = "UPDATE tk_barasiF SET"
sql = sql & " xsize='" & xsize & "', ysize='" & ysize & "'"
sql = sql & ", bfimg1='" & bfimg1 & "', bfimg2='" & bfimg2 & "', bfimg3='" & bfimg3 & "', bfimg4='" & bfimg4 & "'"
sql = sql & ", TNG_Busok_idx='" & TNG_Busok_idx & "', TNG_Busok_idx2='" & TNG_Busok_idx2 & "', TNG_Busok_idx3='" & TNG_Busok_idx3 & "'"
sql = sql & ", set_name_FIX='" & set_name_FIX & "', set_name_AUTO='" & set_name_AUTO & "'"
sql = sql & ", WHICHI_FIX='" & WHICHI_FIX & "', WHICHI_AUTO='" & WHICHI_AUTO & "'"
sql = sql & " WHERE bfidx = '" & copy_bfidx & "'"
'response.write (SQL)&"<br>"
'response.end
Dbcon.Execute sql

'  3. tk_barasi 복사 및 tk_barasisub 까지 연결
sql = "SELECT baidx, baname, bachannel, g_bogang, g_busok, bastatus"
sql = sql & ", xsize, ysize, sx1, sx2, sy1, sy2 FROM tk_barasi"
sql = sql & " WHERE bfidx = '" & selected_bfidx & "'"
Rs.Open sql, Dbcon, 1, 1
Do Until Rs.EOF
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
            baname = "없음"
        End If
    End If
    new_baname = baname 
    'response.write "new_baname : " & new_baname & "<br>"

'=====================
' 4. tk_barasi 인서트
'=====================
    sql1 = "INSERT INTO tk_barasi (baname, bamidx, bawdate, bastatus"
    sql1 = sql1 & ", xsize, ysize, sx1, sx2, sy1, sy2, bachannel, g_bogang, g_busok, bfidx)"
    sql1 = sql1 & " VALUES ('" & baname & "', '" & c_midx & "', getdate(), '" & bastatus & "'"
    sql1 = sql1 & ", '" & xsize & "', '" & ysize & "', '" & sx1 & "', '" & sx2 & "', '" & sy1 & "', '" & sy2 & "'"
    sql1 = sql1 & ", '" & bachannel & "', '" & g_bogang & "', '" & g_busok & "', '" & copy_bfidx & "')"
    'response.write (sql1)&"<br>"
    'response.end
    Dbcon.Execute sql1

    ' 5. 새로 생성된 baidx 값 조회

        sql2 = "SELECT MAX(baidx) FROM tk_barasi"
        Rs1.Open sql2, Dbcon, 1, 1
            new_baidx = Rs1(0)
        Rs1.Close

            sql3 = "SELECT x1, y1, x2, y2, bassize, basdirection, final, ysr1, ysr2, ody, idv, accsize, kak, basp2"
            sql3 = sql3 & " FROM tk_barasisub WHERE baidx = '" & copy_baidx & "' ORDER BY basidx ASC"
            'response.write (sql3)&"<br>"
            'response.end
            Rs2.Open sql3, Dbcon, 1, 1
            Do Until Rs2.EOF
                x1 = Rs2(0)
                y1 = Rs2(1)
                x2 = Rs2(2)
                y2 = Rs2(3)
                bassize = Rs2(4)
                basdirection = Rs2(5)
                final = Rs2(6)
                ysr1 = Rs2(7)
                ysr2 = Rs2(8)
                ody = Rs2(9)
                idv = Rs2(10)
                accsize = Rs2(11)
                kak = Rs2(12)
                basp2 = Rs2(13)

                    sql4 = "INSERT INTO tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection"
                    sql4 = sql4 & ", basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak, basp2, bfidx)"
                    sql4 = sql4 & " VALUES ('" & new_baidx & "', '" & x1 & "', '" & y1 & "', '" & x2 & "', '" & y2 & "',"
                    sql4 = sql4 & " '" & bassize & "', '" & basdirection & "', '" & c_midx & "', getdate(), '" & final & "',"
                    sql4 = sql4 & " '" & ysr1 & "', '" & ysr2 & "', '" & ody & "', '" & idv & "', '" & accsize & "', '" & kak & "', '" & basp2 & "', '" & copy_bfidx & "')"
                    'response.write (sql4)&"<br>"
                    'response.end
                    Dbcon.Execute sql4
            Rs2.MoveNext
        Loop
        Rs2.Close
        Rs.MoveNext
    Loop
    Rs.Close

Response.Write "<script>alert('복사 및 업데이트 완료');location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?bfidx=" & copy_bfidx & "&SJB_IDX=" & rSJB_IDX & "');</script>"

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>


