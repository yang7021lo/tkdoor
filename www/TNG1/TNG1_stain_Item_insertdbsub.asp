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
gotopage = Request("gotopage")
kgotopage = Request("kgotopage")
rSearchWord    = Request("SearchWord")


' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
rqtyco_idx     = Request("qtyco_idx")
rQTYNo         = Request("QTYNo")
rQTYNAME       = Request("QTYNAME")
rQTYcoNAME     = Request("QTYcoNAME")
rQTYcostatus   = Request("QTYcostatus")
rQTYcomidx     = Request("QTYcomidx")
rQTYcowdate    = Request("QTYcowdate")
rQTYcoemidx    = Request("QTYcoemidx")
rQTYcoewdate   = Request("QTYcoewdate")
rsheet_w       = Request("sheet_w")
rsheet_h       = Request("sheet_h")
rsheet_t       = Request("sheet_t")
rcoil_cut      = Request("coil_cut")
rcoil_t        = Request("coil_t")
rkg        = Request("kg")
runittype_qtyco_idx = Request("unittype_qtyco_idx")
'Response.Write "rqtyco_idx : " & rqtyco_idx & "<br>"
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
    sql = "DELETE FROM tk_qtyco WHERE qtyco_idx = " & rqtyco_idx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    'response.write "<script>window.close();</script>"
    'response.write "<script>location.replace('TNG1_PUMMOK_Item.asp');</script>"
    response.write "<script>location.replace('TNG1_stain_Item_insertsub.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"');</script>"
else 

    if rqtyco_idx="0" then 
    
     ' 🔹 새로운 qtyco_idx 번호 구하기
        SQL = "SELECT ISNULL(MAX(qtyco_idx), 0) + 1 FROM tk_qtyco"
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rqtyco_idx = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tk_qtyco (qtyco_idx, QTYNo, QTYNAME, QTYcoNAME, QTYcostatus" 
        sql = sql & ", QTYcomidx, QTYcowdate, QTYcoemidx, QTYcoewdate" 
        sql = sql & ", sheet_w, sheet_h, sheet_t, coil_cut, coil_t, kg, unittype_qtyco_idx) " 

        sql = sql & "VALUES ("
        sql = sql & "'" & rqtyco_idx & "', '" & rQTYNo & "', '" & rQTYNAME & "', '" & rQTYcoNAME & "', '" & rQTYcostatus & "', "
        sql = sql & "'" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE(), "
        sql = sql & "'" & rsheet_w & "', '" & rsheet_h & "', '" & rsheet_t & "', "
        sql = sql & "'" & rcoil_cut & "', '" & rcoil_t & "', '" & rkg & "' , '" & runittype_qtyco_idx & "')"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_stain_Item_insertsub.asp?gotopage=" & gotopage & "&qtyco_idx="&rqtyco_idx&"&SearchWord="&rSearchWord&"#"&rqtyco_idx&"');</script>"

    else
        sql = "UPDATE tk_qtyco SET "
sql = sql & "QTYNo = '" & rQTYNo & "', QTYNAME = '" & rQTYNAME & "', QTYcoNAME = '" & rQTYcoNAME & "', QTYcostatus = '" & rQTYcostatus & "', "
sql = sql & "QTYcoemidx = '" & C_midx & "', QTYcoewdate = GETDATE(), "
sql = sql & "sheet_w = '" & rsheet_w & "', sheet_h = '" & rsheet_h & "', sheet_t = '" & rsheet_t & "', "
sql = sql & "coil_cut = '" & rcoil_cut & "', coil_t = '" & rcoil_t & "' , kg = '" & rkg & "'  , unittype_qtyco_idx = '" & runittype_qtyco_idx & "' "
sql = sql & "WHERE qtyco_idx = '" & rqtyco_idx & "'"

    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_stain_Item_insertsub.asp?gotopage=" & gotopage & "&qtyco_idx="&rqtyco_idx&"&SearchWord="&rSearchWord&"#"&rqtyco_idx&"');</script>"

    end if
end if
set Rs=Nothing
call dbClose()
%>
