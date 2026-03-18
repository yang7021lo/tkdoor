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

part = Request("part")

' 🔹 파일 및 폼 데이터 읽기
kgotopage = Request("kgotopage")
rSearchWord = Request("SearchWord")

' 🔹 tng_unitprice_t 테이블 기준 변수
ruptidx = Request("uptidx")
rbfwidx = Request("bfwidx")
rbfidx = Request("bfidx")
rsjbtidx = Request("sjbtidx")
rqtyco_idx = Request("qtyco_idx")
rprice = Request("price")
rupstatus = Request("upstatus")
rSJB_IDX = Request("SJB_IDX")
rQTYIDX = Request("QTYIDX")

' 🔹 요청 받은 변수 출력 (디버그용)
'Response.Write "ruptidx : " & ruptidx & "<br>"
'Response.Write "rbfwidx : " & rbfwidx & "<br>"
'Response.Write "rbfidx : " & rbfidx & "<br>"
'Response.Write "rsjbtidx : " & rsjbtidx & "<br>"
'Response.Write "rqtyco_idx : " & rqtyco_idx & "<br>"
'Response.Write "rprice : " & rprice & "<br>"
'Response.Write "rupstatus : " & rupstatus & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rQTYIDX : " & rQTYIDX & "<br>"
'Response.Write "rSearchWord : " & rSearchWord & "<br>"
'Response.Write "kgotopage : " & kgotopage & "<br>"
'Response.End

' 삭제 처리
If part = "delete" Then
    sql = "DELETE FROM tkd001.tng_unitprice_t WHERE uptidx = " & ruptidx
    'Response.Write sql & "<br>"
    'Response.End
    Dbcon.Execute(sql)

    Response.Write "<script>location.replace('unitprice_t.asp?kgotopage=" & kgotopage & "&SearchWord=" & rSearchWord & "');</script>"

Else
    ' 신규 등록 처리
    If ruptidx = "0" Then

        If rbfwidx = "" Then
            rbfwidx = "0"
        End If
        If rbfidx = "" Then
            rbfidx = "0"
        End If
        If rsjbtidx = "" Then
            rsjbtidx = "0"
        End If
        If rqtyco_idx = "" Then
            rqtyco_idx = "0"
        End If
        ' If rprice = "" Then
        '    rprice = "0"
        ' End If
        If rupstatus = "" Then
            rupstatus = "0"
        End If
        If rSJB_IDX = "" Then
            rSJB_IDX = "0"
        End If
        If rQTYIDX = "" Then
            rQTYIDX = "0"
        End If

        ' 새로운 uptidx 번호 구하기
        sql = "SELECT ISNULL(MAX(uptidx), 0) + 1 FROM tkd001.tng_unitprice_t"
        'Response.Write sql & "<br>"
    'Response.End
        Rs.Open sql, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            ruptidx = Rs(0)
        End If
        Rs.Close

        ' INSERT 실행
        sql = "INSERT INTO tkd001.tng_unitprice_t (uptidx, bfwidx, bfidx, sjbtidx, qtyco_idx, price, upstatus, SJB_IDX, QTYIDX) "
        sql = sql & "VALUES (" & ruptidx & ", " & rbfwidx & ", " & rbfidx & ", " & rsjbtidx & ", " & rqtyco_idx & ", "
        sql = sql & "'" & rprice & "', " & rupstatus & ", " & rSJB_IDX & ", " & rQTYIDX & ")"
        'Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)

        Response.Write "<script>location.replace('unitprice_t.asp?kgotopage=" & kgotopage & "&uptidx=" & ruptidx & "&SearchWord=" & rSearchWord & "#" & ruptidx & "');</script>"

    Else
        ' UPDATE 실행
        sql = "UPDATE tng_unitprice_t SET "
        sql = sql & "bfwidx = " & rbfwidx & ", "
        sql = sql & "bfidx = " & rbfidx & ", "
        sql = sql & "sjbtidx = " & rsjbtidx & ", "
        sql = sql & "qtyco_idx = " & rqtyco_idx & ", "
        sql = sql & "price = '" & rprice & "', "
        sql = sql & "upstatus = " & rupstatus & ", "
        sql = sql & "SJB_IDX = " & rSJB_IDX & ", "
        sql = sql & "QTYIDX = " & rQTYIDX & " "
        sql = sql & "WHERE uptidx = " & ruptidx
        'Response.Write sql & "<br>"
    'Response.End

        Dbcon.Execute(sql)

        Response.Write "<script>location.replace('unitprice_t.asp?kgotopage=" & kgotopage & "&uptidx=" & ruptidx & "&SearchWord=" & rSearchWord & "#" & ruptidx & "');</script>"
    End If
End If

Set Rs = Nothing
call dbClose()
%>
