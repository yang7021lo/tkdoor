<%@ codepage="65001" language="vbscript"%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link rel="icon" type="image/x-icon"
      href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
call dbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

projectname = "재고 관리"
page_name = "TNG_WMS_Stock_List.asp?"
listgubun="one"
' =========================
' 페이징 변수
' =========================
Dim gotopage, pagesize
gotopage = Request("gotopage")
If gotopage = "" Or Not IsNumeric(gotopage) Then gotopage = 1
gotopage = CInt(gotopage)

pagesize = 10   ' 한 페이지당 10건
%>

<!-- BOM 캐시 -->
<!--#include virtual="/TNG_WMS/Cache/Cache_bom.asp"-->

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>재고 관리</title>
    <link rel="stylesheet" href="/TNG_WMS/STOCK/TNG_WMS_Stock.css">

    <script>
        /**
         * 재고 팝업 열기
         * @param {number} stock_idx 재고 IDX (수정일 경우에만 전달)
         */
        function openStockPopup(stock_idx) {
            var url = 'TNG_WMS_Stock_PopUp.asp';
            if (stock_idx) url += '?stock_idx=' + stock_idx;
            window.open(url, 'stockPopup',
                'width=900,height=700,scrollbars=yes,resizable=yes');
        }
        /**
         * 재고 상세페이지 이동 열기
         * @param {number} stock_idx 재고 IDX (수정일 경우에만 전달)
         */
        function openStockDetailPopup(stock_idx) {
            var url = 'Sub/TNG_WMS_Stock_Detail.asp';
            if (stock_idx) {
                url += '?stock_idx=' + stock_idx;
            }
            location.href = url;   // 페이지 이동
        }
    </script>
</head>

<body>

<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->

<div class="page-wrap">

    <div class="top-bar">
        <div></div>
        <a href="javascript:void(0);"
           class="btn btn-primary"
           onclick="openStockPopup();">
            + 신규 등록
        </a>
    </div>

<%
' =========================
' SQL
' =========================
sql = ""
sql = sql & " SELECT stock_idx, material_id, amount, status, wdate "
sql = sql & " FROM tk_wms_stock "
sql = sql & " WHERE is_active = 1 "
sql = sql & " ORDER BY stock_idx ASC "

' =========================
' Recordset 페이징 설정
' =========================
Rs.CursorLocation = 3   ' adUseClient
Rs.PageSize = pagesize
Rs.Open sql, DbCon, 1, 1   ' adOpenKeyset, adLockReadOnly

If Rs.PageCount > 0 Then
    If gotopage > Rs.PageCount Then gotopage = Rs.PageCount
    If gotopage < 1 Then gotopage = 1
    Rs.AbsolutePage = gotopage
End If
%>

    <table>
        <thead>
            <tr>
                <th>자재 이름</th>
                <th>구매 수량</th>
                <th>입고 상태</th>
                <th>주문일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then

    Dim i
    i = 0

    Do Until Rs.EOF Or i >= Rs.PageSize

        stock_idx   = Rs("stock_idx")
        material_id = Rs("material_id")

        If dictBom.Exists(CStr(material_id)) Then
            item_name = dictBom(CStr(material_id))
        Else
            item_name = "(미등록 자재)"
        End If

        amount = Rs("amount")
        wdate  = Rs("wdate")

        Dim statusTxt, statusClass
        Select Case Rs("status")
            Case 0
                statusTxt = "입고전"
                statusClass = "status-0"
            Case 1
                statusTxt = "입고진행중"
                statusClass = "status-1"
            Case 2
                statusTxt = "입고완료"
                statusClass = "status-2"
            Case 3
                statusTxt = "반품"
                statusClass = "status-0"
            Case Else
                statusTxt = "-"
                statusClass = ""
        End Select
%>
            <tr>
                <td onclick="openStockDetailPopup(<%=stock_idx%>);"><%=item_name%></td>
                <td><%=amount%></td>
                <td class="<%=statusClass%>"><%=statusTxt%></td>
                <td><%=Left(CStr(wdate),10)%></td>
                <td>
                    <a href="javascript:void(0);"
                       class="btn-edit"
                       onclick="openStockPopup(<%=stock_idx%>);">
                        수정
                    </a>
                    <a href="TNG_WMS_Stock_DB.asp?stock_idx=<%=stock_idx%>&mode=delete"
                       class="btn-delete"
                       onclick="return confirm('삭제하시겠습니까?');">
                        삭제
                    </a>
                </td>
            </tr>
<%
        Rs.MoveNext
        i = i + 1
    Loop

Else
%>
            <tr>
                <td colspan="5">등록된 재고가 없습니다.</td>
            </tr>
<%
End If
%>

        </tbody>
    </table>

    <!-- 페이징 (기존 paging.asp 그대로 사용) -->
    <!--#include virtual="/inc/paging.asp"-->

</div>
</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call dbClose()
%>
