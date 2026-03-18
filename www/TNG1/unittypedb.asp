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
rSJB_IDX = Request("SJB_IDX")
rQTYIDX = Request("QTYIDX")
runittype_qtyco_idx = Request("unittype_qtyco_idx")
runittype_bfwidx = Request("unittype_bfwidx")
rSJB_TYPE_NAME = Request("SJB_TYPE_NAME")
rSJB_barlist = Request("SJB_barlist")


'price_split= Request("price_split")

'rsplit1=split(price_split,"/")
'rprice =rsplit1(0)
'rbfwidx =rsplit1(1)
'rqtyco_idx =rsplit1(2)

' 🔹 요청 받은 변수 출력 (디버그용)
'Response.Write "ruptidx : " & ruptidx & "<br>"
'Response.Write "runittype_qtyco_idx : " & runittype_qtyco_idx & "<br>"
'Response.Write "runittype_bfwidx : " & runittype_bfwidx & "<br>"
'Response.Write "ruptidx : " & ruptidx & "<br>"
'Response.Write "rbfwidx : " & rbfwidx & "<br>"
'Response.Write "rbfidx : " & rbfidx & "<br>"
'Response.Write "rsjbtidx : " & rsjbtidx & "<br>"
'Response.Write "rqtyco_idx : " & rqtyco_idx & "<br>"
'Response.Write "rprice : " & rprice & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rQTYIDX : " & rQTYIDX & "<br>"
'Response.Write "rSearchWord : " & rSearchWord & "<br>"
'Response.Write "kgotopage : " & kgotopage & "<br>"
'Response.End

' 삭제 처리
If part = "delete" Then
    sql = "DELETE FROM tng_unitprice_t WHERE uptidx = " & ruptidx
    'Response.Write sql & "<br>"
    'Response.End
    Dbcon.Execute(sql)

Response.Write "<script>location.replace('unittype.asp?uptidx=" & ruptidx & "&unittype_qtyco_idx=" & runittype_qtyco_idx & "&unittype_bfwidx=" & runittype_bfwidx & "&sjbtidx=" & rsjbtidx & "&SJB_TYPE_NAME=" & rSJB_TYPE_NAME & "');</script>"

Else
        ' 신규 등록 처리 자동등록
            If ruptidx = "" Then


        ' INSERT 실행
        If rbfwidx = "" Then rbfwidx = "0"
        If rbfidx = "" Then rbfidx = "0"
        If rsjbtidx = "" Then rsjbtidx = "0"
        If rqtyco_idx = "" Then rqtyco_idx = "0"
        If rupstatus = "" Then rupstatus = "1"   ' 사용 기본값
        If rSJB_IDX = "" Then rSJB_IDX = "0"
        If rQTYIDX = "" Then rQTYIDX = "0"
        sql = "INSERT INTO tng_unitprice_t ( bfwidx, bfidx, sjbtidx, qtyco_idx, price, upstatus, SJB_IDX, QTYIDX, unittype_bfwidx, unittype_qtyco_idx ) "
        sql = sql & "VALUES (" & rbfwidx & ", " & rbfidx & ", " & rsjbtidx & ", " & rqtyco_idx & ", "
        sql = sql & "'" & rprice & "',  1 , " & rSJB_IDX & ", " & rQTYIDX & ", " & runittype_bfwidx & ", " & runittype_qtyco_idx & ")"
        'Response.Write sql & "<br>"
        'Response.End
        Dbcon.Execute(sql)
Response.Write "<script>location.replace('unittype.asp?SJB_barlist=" & rSJB_barlist & "&uptidx=" & ruptidx & "&sjbtidx=" & rsjbtidx & "&SJB_IDX=" & rSJB_IDX & "&unittype_qtyco_idx=" & runittype_qtyco_idx & "&unittype_bfwidx=" & runittype_bfwidx & "&SJB_TYPE_NAME=" & rSJB_TYPE_NAME & "#"&ruptidx&"');</script>"

    Else
        ' UPDATE 실행
        sql = "UPDATE tng_unitprice_t SET "
        sql = sql & "bfwidx = '" & rbfwidx & "' "
        sql = sql & ", bfidx = '" & rbfidx & "' "
        sql = sql & ", sjbtidx = '" & rsjbtidx & "' "
        sql = sql & ", qtyco_idx = '" & rqtyco_idx & "' "
        sql = sql & ", price = '" & rprice & "' "
        sql = sql & ", upstatus = '1' "
        sql = sql & ", SJB_IDX = '" & rSJB_IDX & "' "
        sql = sql & ", QTYIDX = '" & rQTYIDX & "' "
        sql = sql & ", unittype_bfwidx = '" & runittype_bfwidx & "' "
        sql = sql & ", unittype_qtyco_idx = '" & runittype_qtyco_idx & "' "
        sql = sql & " WHERE uptidx = '" & ruptidx & "' "
        'Response.Write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
    End If
    
Response.Write "<script>location.replace('unittype.asp?SJB_barlist=" & rSJB_barlist & "&uptidx=" & ruptidx & "&sjbtidx=" & rsjbtidx & "&SJB_IDX=" & rSJB_IDX & "&unittype_qtyco_idx=" & runittype_qtyco_idx & "&unittype_bfwidx=" & runittype_bfwidx & "&SJB_TYPE_NAME=" & rSJB_TYPE_NAME & "#"&ruptidx&"');</script>"
End If

Set Rs = Nothing
call dbClose()
%>
