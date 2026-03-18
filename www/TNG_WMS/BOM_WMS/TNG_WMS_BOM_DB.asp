<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

' =========================
' 파라미터
' =========================
Dim mode, bw_idx, bw_no, material_id, stock_idx, bw_price

mode        = Trim(Request("mode"))
bw_idx      = Trim(Request("bw_idx"))
bw_no       = Trim(Request("bw_no"))
material_id = Trim(Request("material_id"))
stock_idx   = Trim(Request("stock_idx"))
bw_price    = Trim(Request("bw_price"))
is_popup = Trim(Request("is_popup"))
midx      = c_midx   ' cookies.asp 에서 로그인 사용자
meidx      = c_midx   ' cookies.asp 에서 로그인 사용자

' response.Write "mode : "       & mode & "<br/>"
' response.Write "bw_idx : "     & bw_idx & "<br/>" 
' response.Write "bw_no : "      & bw_no & "<br/>"
' response.Write "material_id : " & material_id & "<br/>"
' response.Write "stock_idx : "  & stock_idx & "<br/>"
' response.Write "bw_price : "   & bw_price & "<br/>"
' Response.Write "midx : "       & midx & "<br/>"
' Response.Write "meidx : "      & meidx & "<br/>"
' If is_popup = "1" Then
'     response.Write "is_popup : true<br/>"
' Else
'     response.Write "is_popup : false<br/>"
' End If
' response.end
' =========================
' 기본 검증
' =========================
If mode <> "delete" Then
    If bw_no = "" Then
        Response.Write "<script>alert('기계번호를 입력해주세요.');history.back();</script>"
        Response.End
    End If

    If material_id = "" Then
        Response.Write "<script>alert('자재를 선택해주세요.');history.back();</script>"
        Response.End
    End If

    If stock_idx = "" Or Not IsNumeric(stock_idx) Then
        Response.Write "<script>alert('재고번호가 올바르지 않습니다.');history.back();</script>"
        Response.End
    End If

    If bw_price = "" Or Not IsNumeric(bw_price) Then
        Response.Write "<script>alert('기계 금액이 올바르지 않습니다.');history.back();</script>"
        Response.End
    End If
End If
' =========================
' 기계번호 중복 체크 (서버단 최종 방어)
' =========================
Dim chkSql
chkSql = ""
chkSql = chkSql & " SELECT bw_idx "
chkSql = chkSql & " FROM tk_bom_wms "
chkSql = chkSql & " WHERE bw_no = '" & Replace(bw_no,"'","''") & "' "
chkSql = chkSql & " AND is_active = 1 "

If mode = "update" Then
    If bw_idx = "" Or Not IsNumeric(bw_idx) Then
        Response.Write "<script>alert('잘못된 접근입니다.');history.back();</script>"
        Response.End
    End If
    chkSql = chkSql & " AND bw_idx <> " & bw_idx
End If

Rs.Open chkSql, DbCon, 1, 1

If Not Rs.EOF Then
    Rs.Close
    Response.Write "<script>alert('이미 등록된 기계번호입니다.');history.back();</script>"
    Response.End
End If

Rs.Close

' =========================
' INSERT
' =========================
If mode = "insert" Then

    sql = ""
    sql = sql & " INSERT INTO tk_bom_wms ( "
    sql = sql & "   bw_no, material_id, stock_idx, bw_price, "
    sql = sql & "   midx, meidx, wdate, is_active "
    sql = sql & " ) VALUES ( "
    sql = sql & " '" & Replace(bw_no,"'","''") & "', "
    sql = sql & " '" & Replace(material_id,"'","''") & "', "
    sql = sql & " " & stock_idx & ", "
    sql = sql & " " & bw_price & ", "
    sql = sql & " '" & midx & "', "
    sql = sql & " '" & meidx & "', "
    sql = sql & " GETDATE(), "
    sql = sql & " 1 "
    sql = sql & " ) "

    DbCon.Execute sql

' =========================
' UPDATE
' =========================
ElseIf mode = "update" Then

    sql = ""
    sql = sql & " UPDATE tk_bom_wms SET "
    sql = sql & "   bw_no       = '" & Replace(bw_no,"'","''") & "', "
    sql = sql & "   material_id = '" & Replace(material_id,"'","''") & "', "
    sql = sql & "   stock_idx   = " & stock_idx & ", "
    sql = sql & "   bw_price    = " & bw_price & ", "
    sql = sql & "   meidx       = '" & meidx & "', "
    sql = sql & "   udate       = GETDATE() "
    sql = sql & " WHERE bw_idx = " & bw_idx

    DbCon.Execute sql

' =========================
' DELETE (Soft)
' =========================
ElseIf mode = "delete" Then

    If bw_idx = "" Or Not IsNumeric(bw_idx) Then
        Response.Write "<script>alert('잘못된 접근입니다.');history.back();</script>"
        Response.End
    End If

    sql = ""
    sql = sql & " UPDATE tk_bom_wms SET "
    sql = sql & "   is_active = 0, "
    sql = sql & "   meidx = '" & meidx & "', "
    sql = sql & "   udate = GETDATE() "
    sql = sql & " WHERE bw_idx = " & bw_idx

    DbCon.Execute sql

Else
    Response.Write "<script>alert('정의되지 않은 처리 방식입니다.');history.back();</script>"
    Response.End
End If
%>

<script>
<%
If is_popup = "1" Then
%>
    // 팝업에서 저장된 경우
    if (window.opener && !window.opener.closed) {
        window.opener.location.reload();
    }
    window.close();
<%
Else
%>
    // 일반 페이지에서 처리된 경우 (리스트)
    location.href = "TNG_WMS_Bom_List.asp";
<%
End If
%>
</script>

<%
Set Rs = Nothing
call dbClose()
%>
