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


copy_baidx = Request("copy_baidx")
rbfidx = Request("bfidx")
rSJB_IDX = Request("SJB_IDX")

'Response.Write "copy_baidx : " & copy_baidx & "<br>"
'Response.Write "rbfidx : " & rbfidx & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'response.end

' 1. 원본 절곡 데이터 조회


sql = sql & "SELECT baname, bastatus, xsize, ysize, sx1, sx2, sy1, sy2, bachannel, g_bogang, g_busok "
sql = sql & "FROM tk_barasi WHERE baidx='" & copy_baidx & "'"
'response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then  

    baname=Rs(0)
    bastatus=Rs(1)
    xsize=Rs(2)
    ysize=Rs(3)
    sx1=Rs(4)
    sx2=Rs(5)
    sy1=Rs(6)
    sy2=Rs(7)
    bachannel=Rs(8)
    g_bogang=Rs(9)
    g_busok=Rs(10)

End If
Rs.Close

' 2. 새로운 절곡 데이터 Insert
sql = sql & "INSERT INTO tk_barasi ("
sql = sql & "  baname, bamidx, bawdate, bastatus, "
sql = sql & "  xsize, ysize, sx1, sx2, sy1, sy2, "
sql = sql & "  bachannel, g_bogang, g_busok, bfidx"
sql = sql & ") VALUES ("
sql = sql & "'" & baname & "', "
sql = sql & "'" & c_midx & "', "
sql = sql & "GETDATE(), "
sql = sql & "'" & bastatus & "', "
sql = sql & "'" & xsize & "', "
sql = sql & "'" & ysize & "', "
sql = sql & "'" & sx1 & "', "
sql = sql & "'" & sx2 & "', "
sql = sql & "'" & sy1 & "', "
sql = sql & "'" & sy2 & "', "
sql = sql & "'" & bachannel & "', "
sql = sql & "'" & g_bogang & "', "
sql = sql & "'" & g_busok & "', "
sql = sql & "'" & rbfidx & "')"
'response.write (SQL)&"<br>"
'response.end
Dbcon.Execute(sql)

' 3. 새로 생성된 baidx 값 조회
sql = "SELECT MAX(baidx) FROM tk_barasi"
Rs.Open sql, Dbcon
If Not Rs.EOF Then
    new_baidx = Rs(0)
End If
Rs.Close

' 4. 기존 절곡 Sub 값 복사
sql = "SELECT x1, y1, x2, y2, bassize, basdirection, final, ysr1, ysr2, ody, idv, accsize, kak "
sql = sql & "FROM tk_barasisub WHERE baidx = '" & copy_baidx & "' ORDER BY basidx ASC"
'response.write (SQL)&"<br>"
'response.end
Rs.Open sql, Dbcon
Do While Not Rs.EOF

    x1 = Rs(0)
    y1 = Rs(1)
    x2 = Rs(2)
    y2 = Rs(3)
    bassize = Rs(4)
    basdirection = Rs(5)
    final = Rs(6)
    ysr1 = Rs(7)
    ysr2 = Rs(8)
    ody = Rs(9)
    idv = Rs(10)
    accsize = Rs(11)
    kak = Rs(12)

    sql2 = "INSERT INTO tk_barasisub (baidx, x1, y1, x2, y2, bassize, basdirection"
    sql2 = sql2 & ", basmidx, baswdate, final, ysr1, ysr2, ody, idv, accsize, kak) "
    sql2 = sql2 & "VALUES ('" & new_baidx & "', '" & x1 & "', '" & y1 & "', '" & x2 & "', '" & y2 & "' "
    sql2 = sql2 & " , '" & bassize & "', '" & basdirection & "', '" & c_midx & "', getdate(), '" & final & "' "
    sql2 = sql2 & " , '" & ysr1 & "', '" & ysr2 & "', '" & ody & "', '" & idv & "', '" & accsize & "', '" & kak & "')"
    'response.write (sql2)&"<br>"
    'response.end
    Dbcon.Execute(sql2)
    Rs.MoveNext
Loop
Rs.Close

'response.end
' 5. 완료 후 이동
Response.Write "<script>alert('복사 완료되었습니다.');"
Response.Write "location.href='tng1_julgok_in_sub2.asp?SJB_IDX=" & rSJB_IDX & "&bfidx=" & rbfidx & "&baidx=" & new_baidx & "';</script>"








%>
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
