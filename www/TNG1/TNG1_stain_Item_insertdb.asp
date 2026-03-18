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

' 파일 및 폼 데이터 읽기
kgotopage = Request("kgotopage")
rSearchWord    = Request("SearchWord")


' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
' 🔹 tk_qty 테이블 기준 변수
rQTYIDX     = Request("QTYIDX")
rQTYNo      = Request("QTYNo")
rQTYNAME    = Request("QTYNAME")
rQTYSTATUS  = Request("QTYSTATUS")
rQTYPAINT   = Request("QTYPAINT")
rQTYINS     = Request("QTYINS")
rQTYLABEL   = Request("QTYLABEL")
rQTYPAINTW  = Request("QTYPAINTW")
qtype       = Request("qtype")
rtaidx      = Request("taidx")
rATYPE      = Request("ATYPE")
rqtyprice   = Request("qtyprice")
rkg         = Request("kg")
rsheet_t       = Request("sheet_t")
rrobbyprice1       = Request("robbyprice1")
rrobbyprice2       = Request("robbyprice2")
rdoorbase_price= Request("doorbase_price")
'Response.Write "rqtyidx : " & rqtyidx & "<br>"
'Response.Write "rQTYNo : " & rQTYNo & "<br>"
'Response.Write "rQTYNAME : " & rQTYNAME & "<br>"
'Response.Write "rQTYcoNAME : " & rQTYcoNAME & "<br>"
'Response.Write "rQTYcostatus : " & rQTYcostatus & "<br>"
'Response.Write "rQTYcomidx : " & rQTYcomidx & "<br>"
'Response.Write "rQTYcowdate : " & rQTYcowdate & "<br>"
'Response.Write "rQTYcoemidx : " & rQTYcoemidx & "<br>"
'Response.Write "rQTYcoewdate : " & rQTYcoewdate & "<br>"
'Response.Write "rsheet_w : " & rsheet_w & "<br>"
'Response.Write "rsheet_h : " & rsheet_h & "<br>"
'Response.Write "rsheet_t : " & rsheet_t & "<br>"
'Response.Write "rcoil_cut : " & rcoil_cut & "<br>"
'Response.Write "rcoil_t : " & rcoil_t & "<br>"
'Response.end

if part="delete" then 
    sql = "DELETE FROM tk_qty WHERE QTYIDX = " & rQTYIDX

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_stain_Item_insert.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"');</script>"
else 

    if rqtyidx="0" then 
    
     ' 🔹 새로운 sjbtidx 번호 구하기
        SQL = "SELECT ISNULL(MAX(QTYIDX), 0) + 1 FROM tk_qty"
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rQTYIDX = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tk_qty (QTYIDX, QTYNo, QTYNAME, QTYSTATUS, QTYPAINT, QTYINS, QTYLABEL, QTYPAINTW, QTYmidx, QTYwdate, QTYemidx, QTYewdate, qtype, taidx, ATYPE, qtyprice, kg, sheet_t) "
        sql = sql & "VALUES ('" & rQTYIDX & "', '" & rQTYNo & "', '" & rQTYNAME & "', '" & rQTYSTATUS & "', "
        sql = sql & "'" & rQTYPAINT & "', '" & rQTYINS & "', '" & rQTYLABEL & "', '" & rQTYPAINTW & "', "
        sql = sql & C_midx & ", GETDATE(), " & C_midx & ", GETDATE(), "
        sql = sql & "'" & qtype & "', '" & rtaidx & "', '" & rATYPE & "', '" & rqtyprice & "' , '" & rkg & "' , '" & rsheet_t & "')"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)

        SQL=" Select max(QTYIDX) From tk_qty  "
        Rs.open Sql,Dbcon,1,1,1
        If Not (Rs.EOF Or Rs.BOF) Then
            QTYIDX = Rs(0)
        End If
        Rs.Close

        response.write "<script>location.replace('TNG1_stain_Item_insert.asp?kgotopage=" & kgotopage & "&QTYIDX="&rQTYIDX&"&SearchWord="&rSearchWord&"#"&rQTYIDX&"');</script>"

        'if rSJB_IDX <>"" then     
        'response.write "<script>opener.location.replace('TNG1_PUMMOK_Item.asp');window.close();</script>"  
        'response.write "<script>location.replace('TNG1_STAIN_ITEM_Insertdb.asp');</script>"
        'elseif rTNG_Busok_idx <>"" then
        'response.write "<script>opener.location.replace('TNG1_BUSOK.asp');window.close();</script>"  
        'response.write "<script>location.replace('TNG1_STAIN_ITEM_Insertdb.asp');</script>"
        'end if
    else
sql = "UPDATE tk_qty SET "
sql = sql & " QTYNo = '" & rQTYNo & "', QTYNAME = '" & rQTYNAME & "', QTYSTATUS = '" & rQTYSTATUS & "', QTYPAINT = '" & rQTYPAINT & "', "
sql = sql & " QTYINS = '" & rQTYINS & "', QTYLABEL = '" & rQTYLABEL & "', QTYPAINTW = '" & rQTYPAINTW & "', "
sql = sql & " QTYemidx = '" & C_midx & "', QTYewdate = GETDATE(), qtype = '" & qtype & "', taidx = '" & rtaidx & "', ATYPE = '" & rATYPE & "', qtyprice = '" & rqtyprice & "' , sheet_t = '" & rsheet_t & "',  kg = '" & rkg & "' , "
sql = sql & " robbyprice1 = '" & rrobbyprice1 & "', robbyprice2 = '" & rrobbyprice2 & "', doorbase_price = '" & rdoorbase_price & "' "  
sql = sql & " WHERE QTYIDX = '" & rQTYIDX & "'"

    Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_stain_Item_insert.asp?kgotopage=" & kgotopage & "&QTYIDX="&rQTYIDX&"&SearchWord="&rSearchWord&"#"&rQTYIDX&"');</script>"
    'response.write "<script>window.close();</script>"
    'response.write "<script>location.replace('TNG1_PUMMOK_Item.asp');</script>"
    end if
end if
set Rs=Nothing
call dbClose()
%>
