<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

' =========================
' 1. 파라미터 수신
' =========================
Dim stock_idx, amount, wh_idx, zone, rack, shelf, bin, loc_code, midx

stock_loc_idx = Trim(Request("stock_loc_idx"))
stock_idx = Request("stock_idx")
stock_sub_idx = Request("stock_sub_idx")
amount    = Request("amount")
wh_idx    = Request("wh_idx")
zone      = Trim(Request("zone"))
rack      = Trim(Request("rack"))
shelf     = Trim(Request("shelf"))
bin       = Trim(Request("bin"))
loc_code  = Trim(Request("loc_code"))
mode      = Trim(Request("mode"))
midx      = c_midx   ' cookies.asp 에서 로그인 사용자
meidx      = c_midx   ' cookies.asp 에서 로그인 사용자

' response.Write "stock_idx : "   & stock_idx & "<br/>"
' response.Write "stock_loc_idx : "   & stock_loc_idx & "<br/>"
' response.Write "stock_sub_idx : "   & stock_sub_idx & "<br/>"
' response.Write "amount : "      & amount & "<br/>"
' response.Write "wh_idx : "     & wh_idx & "<br/>"
' response.Write "zone : "       & zone & "<br/>"
' response.Write "rack : "       & rack & "<br/>"
' response.Write "shelf : "      & shelf & "<br/>"
' response.Write "bin : "        & bin & "<br/>"
' response.Write "loc_code : "   & loc_code & "<br/>"
' response.Write "midx : "   & midx & "<br/>"
' response.write "mode : "   & mode & "<br/>"
' response.end

' =========================
' 2. 기본 검증
' =========================
If Not IsNumeric(stock_idx) Or Not IsNumeric(amount) Then
    Response.Write "<script>alert('잘못된 접근입니다.');window.close();</script>"
    Response.End
End If

If zone = "" Or rack = "" Or shelf = "" Or bin = "" Then
    Response.Write "<script>alert('위치 정보가 누락되었습니다.');window.close();</script>"
    Response.End
End If

' =========================
' 3. 잔여 수량 체크 (stock 기준)
' =========================
Dim RsChk, SQL, remain_qty
Set RsChk = Server.CreateObject("ADODB.Recordset")

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  S.amount - ISNULL(SUM(L.amount),0) AS remain_qty "
SQL = SQL & "FROM tk_wms_stock S "
SQL = SQL & "LEFT JOIN tk_wms_stock_loc L "
SQL = SQL & "  ON S.stock_idx = L.stock_idx "
SQL = SQL & "WHERE S.stock_idx = " & CLng(stock_idx) & " "
SQL = SQL & "GROUP BY S.amount "

RsChk.Open SQL, DbCon

' =========================
' 2. 기본 검증
' =========================
If mode <> "delete" Then

    If Not IsNumeric(stock_idx) Or Not IsNumeric(amount) Then
        Response.Write "<script>alert('잘못된 접근입니다.');window.close();</script>"
        Response.End
    End If

    If zone = "" Or rack = "" Or shelf = "" Or bin = "" Then
        Response.Write "<script>alert('위치 정보가 누락되었습니다.');window.close();</script>"
        Response.End
    End If

End If

' =========================
' 3. DELETE는 잔여 수량 체크 없이 바로 처리
' =========================
If mode = "delete" Then

    If Not IsNumeric(stock_loc_idx) Then
        Response.Write "<script>alert('잘못된 접근입니다.');window.close();</script>"
        Response.End
    End If

    SQL = ""
    SQL = SQL & "UPDATE tk_wms_stock_loc SET "
    SQL = SQL & " is_active = 0, "
    SQL = SQL & " meidx = '" & meidx & "', "
    SQL = SQL & " udate = GETDATE() "
    SQL = SQL & "WHERE stock_loc_idx = " & CLng(stock_loc_idx)

    DbCon.Execute SQL

    Response.Write "<script>alert('삭제 완료 되었습니다.');opener.location.reload();window.close();</script>"
    Response.End

End If

RsChk.Close
Set RsChk = Nothing
If mode = "update" Then
SQL = ""
SQL = SQL & "UPDATE tk_wms_stock_loc SET "
SQL = SQL & " wh_idx = " & CLng(wh_idx) & ", "
SQL = SQL & " zone = '" & Replace(zone,"'","''") & "', "
SQL = SQL & " rack = '" & Replace(rack,"'","''") & "', "
SQL = SQL & " shelf = '" & Replace(shelf,"'","''") & "', "
SQL = SQL & " bin = '" & Replace(bin,"'","''") & "', "
SQL = SQL & " loc_code = '" & Replace(loc_code,"'","''") & "', "
SQL = SQL & " amount = " & CLng(amount) & ", "
SQL = SQL & " meidx = '" & meidx & "', "
SQL = SQL & " udate = GETDATE() , "
SQL = SQL & "  stock_idx = " & CLng(stock_idx) & " , "
SQL = SQL & "  stock_sub_idx = " & CLng(stock_sub_idx)
SQL = SQL & "WHERE stock_loc_idx = " & CLng(stock_loc_idx) & " "

DbCon.Execute SQL
Else
    'Do something...
' =========================
' 4. INSERT (위치 적치)
' =========================
SQL = ""
SQL = SQL & "INSERT INTO tk_wms_stock_loc ("
SQL = SQL & " stock_idx, stock_sub_idx, wh_idx, zone, rack, shelf, bin, loc_code, amount, midx, meidx, wdate "
SQL = SQL & ") VALUES ("
SQL = SQL & CLng(stock_idx) & ", "
SQL = SQL & CLng(stock_sub_idx) & ", "
SQL = SQL & CLng(wh_idx) & ", "
SQL = SQL & "'" & Replace(zone,"'","''") & "', "
SQL = SQL & "'" & Replace(rack,"'","''") & "', "
SQL = SQL & "'" & Replace(shelf,"'","''") & "', "
SQL = SQL & "'" & Replace(bin,"'","''") & "', "
SQL = SQL & "'" & Replace(loc_code,"'","''") & "', "
SQL = SQL & CLng(amount) & ", "
SQL = SQL & "'" & midx & "', " 
SQL = SQL & "'" & meidx & "', "
SQL = SQL & "GETDATE() "
SQL = SQL & ")"

DbCon.Execute SQL
End If
' =========================
' 5. 완료 처리
' =========================
Response.Write "<script>alert('저장완료 되었습니다.');opener.location.reload();window.close();</script>"
%>
