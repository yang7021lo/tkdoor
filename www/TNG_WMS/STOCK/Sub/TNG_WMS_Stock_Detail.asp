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
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsH = Server.CreateObject("ADODB.Recordset")



Dim stock_idx
stock_idx = Request("stock_idx")
If stock_idx = "" Or Not IsNumeric(stock_idx) Then
    Response.Write "<script>alert('잘못된 접근입니다.');history.back();</script>"
    Response.End
End If
stock_idx = CLng(stock_idx)

midx = c_midx
meidx = c_midx

'response.Write "meidx: " & meidx & "<br/>"
projectname = "재고 상세"

' BOM 캐시
%>
<!-- BOM 캐시 -->
<!--#include virtual="/TNG_WMS/Cache/Cache_bom.asp"-->
<!--#include virtual="/TNG_WMS/Cache/Cache_member.asp"-->
<%
' =====================================================
' 작성자 / 수정자 이름 반환 (NULL 안전)
' =====================================================
Function GetMemberName(ByVal midxValue)
    If IsNull(midxValue) Or midxValue = "" Then
        GetMemberName = "-"
    ElseIf dictMember.Exists(CStr(midxValue)) Then
        GetMemberName = dictMember(CStr(midxValue))
    Else
        GetMemberName = "-"
    End If
End Function

%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>재고 상세</title>

    <!-- 기존 공통 CSS 그대로 사용 -->
    <link rel="stylesheet" href="/TNG_WMS/STOCK/SUb/Sub.css">

    <style>

    </style>

    <script>
       /* ===============================
        POST 방식 팝업 호출
        =============================== */
        function openSubPopup(stock_idx, stock_sub_idx, status, amount, in_date, mode, maxAmount) {

                var f = document.getElementById('subPopupForm');

                f.target              = 'stockSubPopup';
                f.stock_idx.value     = stock_idx;
                f.stock_sub_idx.value = stock_sub_idx || "";
                f.status.value        = status || "";
                f.amount.value        = amount || "";
                f.in_date.value       = in_date || "";
                f.mode.value          = mode || "";
                f.maxAmount.value     = maxAmount || "";

                window.open(
                    '',
                    'stockSubPopup',
                    'width=900,height=700,scrollbars=yes,resizable=yes'
                );

                f.submit();
        }
    </script>
</head>

<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_WMS.asp"-->


<div class="detail-wrap">

<%
' =========================
' 1) 헤더 데이터 조회
' =========================
Dim RsH, sqlH


sqlH = ""
sqlH = sqlH & " SELECT stock_idx, material_id, amount, cidx, wdate, midx, meidx, udate, "
sqlH = sqlH & "        pre_amount, status, cmidx, cm_check_date, pre_in_date, is_active, total_price "
sqlH = sqlH & " FROM tk_wms_stock "
sqlH = sqlH & " WHERE stock_idx = " & stock_idx & " AND is_active = 1 "

RsH.Open sqlH, DbCon, 1, 1

If RsH.EOF Then
    RsH.Close : Set RsH = Nothing
    Response.Write "<script>alert('데이터가 없습니다.');history.back();</script>"
    call dbClose()
    Response.End
End If

Dim material_id, amount, wdate, statusVal, cidx, pre_in_date, total_price
material_id  = RsH("material_id")
amount       = RsH("amount")
wdate        = RsH("wdate")
statusVal    = RsH("status")
vcidx         = RsH("cidx")
pre_in_date  = RsH("pre_in_date")
total_price  = RsH("total_price")
%>
<!--#include virtual="/TNG_WMS/Cache/Cache_customer.asp"-->
<%

If vcidx <> "" Then

    If dictCustomerOne.Exists(CStr(vcidx)) Then
        vCname = dictCustomerOne(CStr(vcidx))
    Else
        vCname = "(알 수 없는 거래처)"
    End If
End If

Dim item_name
If dictBom.Exists(CStr(material_id)) Then
    item_name = dictBom(CStr(material_id))
Else
    item_name = "(미등록 자재)"
End If

' =========================
' 2) sub 합계 계산 (실입고수량)
' =========================
Dim RsSum, sqlSum, sum_in
Set RsSum = Server.CreateObject("ADODB.Recordset")

sqlSum = ""
sqlSum = sqlSum & " SELECT "
sqlSum = sqlSum & "   ISNULL(SUM(CASE "
sqlSum = sqlSum & "       WHEN status = 0 THEN amount "      ' 입고
sqlSum = sqlSum & "       WHEN status = 1 THEN -amount "     ' 반품
sqlSum = sqlSum & "       ELSE 0 "
sqlSum = sqlSum & "   END), 0) AS sum_in "
sqlSum = sqlSum & " FROM tk_wms_stock_sub "
sqlSum = sqlSum & " WHERE stock_idx = " & stock_idx & " "
sqlSum = sqlSum & "   AND is_active = 0 "

RsSum.Open sqlSum, DbCon, 1, 1
sum_in = 0
If Not RsSum.EOF Then sum_in = RsSum("sum_in")
RsSum.Close : Set RsSum = Nothing

' =========================
' 3) 상태 텍스트/뱃지
' =========================
'Response.write "<!-- 상태값: " & CLng(statusVal & "0") & " -->" ' 디버그용
Dim statusTxt, badgeClass
Select Case CLng(statusVal)
    Case 0
        statusTxt = "입고전"
        badgeClass = "gray"
    Case 1
        statusTxt = "입고진행중"
        badgeClass = "success"
    Case 2
        statusTxt = "입고완료"
        badgeClass = "info"
    Case 3
        statusTxt = "반품"
        badgeClass = "danger"
    Case Else
        statusTxt = "-"
        badgeClass = "gray"
End Select

Dim progressTxt
progressTxt = sum_in & " / " & amount
maxAmount = amount - sum_in
Dim writer_name, editor_name

%>

    <!-- =========================
         헤더(요약) 영역
    ========================== -->
    <div class="detail-header">
        <div class="detail-grid">
            <div class="detail-label">자재</div>
            <div class="detail-value"><%=item_name%> <span class="muted">(#<%=stock_idx%>)</span></div>

            <div class="detail-label">상태</div>
            <div class="detail-value">
                <span class="badge-soft <%=badgeClass%>"><%=statusTxt%></span>
            </div>

            <div class="detail-label">구매수량</div>
            <div class="detail-value"><%=amount%></div>

            <div class="detail-label">실입고수량</div>
            <div class="detail-value"><%=sum_in%></div>

            <div class="detail-label">진행(입고/구매)</div>
            <div class="detail-value"><%=progressTxt%></div>

            <div class="detail-label">주문일</div>
            <div class="detail-value"><%=Left(CStr(wdate),10)%></div>

            <div class="detail-label">입고예정일</div>
            <div class="detail-value"><%=Left(CStr(pre_in_date),10)%></div>

            <div class="detail-label">매입처</div>
            <div class="detail-value"><%=vCname%></div>

            <div class="detail-label">총구매금액</div>
            <div class="detail-value"><%=total_price%></div>
        </div>

        <div class="detail-actions">
            <a href="javascript:void(0);" class="btn btn-primary btn-sm" onclick="openSubPopup(<%=stock_idx%>);">
                + 입고 등록
            </a>

        </div>
    </div>
<%
RsH.Close : Set RsH = Nothing
%>
    <!-- =========================
         SUB(입고 이력) 영역
    ========================== -->
    <div class="sub-card">
        <div class="sub-top">
            <h3 class="sub-title">입고 이력</h3>
            <div class="muted">부분입고/반품 이력은 여기에서 누적 관리</div>
        </div>

<%
' =========================
' 4) sub 리스트 조회
' =========================
Dim RsS, sqlS
Set RsS = Server.CreateObject("ADODB.Recordset")

sqlS = ""
sqlS = sqlS & " SELECT stock_sub_idx, amount, stock_idx, in_date, midx, wdate, meidx, udate, is_active, status "
sqlS = sqlS & " FROM tk_wms_stock_sub "
sqlS = sqlS & " WHERE stock_idx = " & stock_idx & " AND is_active = 0 "
sqlS = sqlS & " ORDER BY stock_sub_idx DESC "
RsS.CursorLocation = 3
RsS.Open sqlS, DbCon, 1, 1

If Not (RsS.BOF Or RsS.EOF) Then



%>
        <table class="sub-table">
            <thead>
                <tr>
                    <th>상태</th>
                    <th>입고수량</th>
                    <th>입고일</th>
                    <th>확인자</th>
                    <th>확인일</th>
                    <th>수정자</th>
                    <th>수정일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
<%
    Do Until RsS.EOF
        Dim stock_sub_idx, sub_amount, in_date, smidx, swdate, smeidx, sudate
        stock_sub_idx = RsS("stock_sub_idx")
        sub_amount    = RsS("amount")
        in_date       = RsS("in_date")
        smidx         = RsS("midx")
        swdate        = RsS("wdate")
        smeidx        = RsS("meidx")
        sudate        = RsS("udate")
        status        = RsS("status")

        If status = 0 Then
            statusTxt = "입고"
            badgeClass = "info"
        ElseIf status = 1 Then
            statusTxt = "반품"
            badgeClass = "danger"
        Else
            statusTxt = "기타"
        End If

            Dim vSmidx, vSmeidx

            ' ★ Field → 값으로 먼저 복사
            If IsNull(RsS("midx")) Then
                vSmidx = ""
            Else
                vSmidx = CStr(RsS("midx"))
            End If

            If IsNull(RsS("meidx")) Then
                vSmeidx = ""
            Else
                vSmeidx = CStr(RsS("meidx"))
            End If

            writer_name = GetMemberName(vSmidx)
            editor_name = GetMemberName(vSmeidx)
%>
                <tr>
                    <td><span class="badge-soft <%=badgeClass%>"><%=statusTxt%></span></td>
                    <td><%=sub_amount%></td>
                    <td><%=Left(CStr(in_date),10)%></td>
                    <td><%=writer_name%></td>
                    <td><%=Left(CStr(swdate),10)%></td>
                    <td><%=editor_name%></td>
                    <td><%=Left(CStr(sudate),10)%></td>
                    <td>
                        <!-- sub 수정/삭제는 추후 구현 -->
                        <button class="btn-edit" href="javascript:void(0);" class="btn-edit"
                        onclick="openSubPopup(<%=stock_idx%>, <%=stock_sub_idx%>, <%=status%>, <%=sub_amount%>, '<%=in_date%>', 'update', <%=maxAmount%>);">
                        수정
                        </button>
                        <button class="btn-delete" href="TNG_WMS_Stock_Sub_Update.asp?stock_idx=<%=stock_idx%>&stock_sub_idx=<%=stock_sub_idx%>&mode=delete"
                           onclick="return confirm('해당 입고 이력을 삭제하시겠습니까?');">
                            삭제
                        </button>
                    </td>
                </tr>
<%
        RsS.MoveNext
    Loop
%>
            </tbody>
        </table>
<%
Else
%>
        <div style="padding:14px; border:1px dashed #dee2e6; border-radius:8px; background:#fcfcfd;">
            아직 등록된 입고 이력이 없습니다. 우측 상단 <strong>+ 입고 등록</strong>으로 추가하세요.
        </div>
<%
End If

RsS.Close : Set RsS = Nothing

%>
    </div>

</div><!-- /detail-wrap -->
<!-- ===============================
     POST 팝업용 숨김 FORM
=============================== -->
<form id="subPopupForm"
      method="post"
      action="TNG_WMS_Stock_Sub_Popup.asp"
      target="stockSubPopup">
    <input type="hidden" name="stock_idx">
    <input type="hidden" name="stock_sub_idx">
    <input type="hidden" name="status">
    <input type="hidden" name="amount">
    <input type="hidden" name="in_date">
    <input type="hidden" name="mode">
    <input type="hidden" name="maxAmount">
</form>
</body>
</html>
<script>

</script>
<%
call dbClose()
%>
