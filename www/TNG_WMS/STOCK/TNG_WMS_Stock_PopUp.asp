<%@ codepage="65001" language="vbscript"%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%
Dim Rs, idx, isEdit
Dim pageMode, pageTitle
Dim vMaterial, vAmount, vCidx, vPreInDate, vTotalPrice, vStatus

Set Rs = Server.CreateObject("ADODB.Recordset")

stock_idx = Trim(Request("stock_idx"))
isEdit = (stock_idx <> "")

call dbOpen()

' 기본값
vMaterial = ""
vAmount = ""
vCidx = ""
vPreInDate = ""
vTotalPrice = ""
vStatus = "0"  ' 기본: 입고전

If isEdit Then
    pageMode = "수정"
    pageTitle = "재고 수정"

    sql = "SELECT * FROM tk_wms_stock WHERE stock_idx=" & stock_idx
    Set Rs = DbCon.Execute(sql)

    If Not (Rs.BOF Or Rs.EOF) Then
        If Not IsNull(Rs("material_id")) Then vMaterial = Rs("material_id")
        If Not IsNull(Rs("amount")) Then vAmount = Rs("amount")
        If Not IsNull(Rs("cidx")) Then vCidx = Rs("cidx")
        If Not IsNull(Rs("total_price")) Then vTotalPrice = Rs("total_price")
        If Not IsNull(Rs("status")) Then vStatus = CStr(Rs("status"))

        ' date는 yyyy-mm-dd 형태로 맞추기
        If Not IsNull(Rs("pre_in_date")) Then
            vPreInDate = Left(CStr(Rs("pre_in_date")), 10)
        End If
    End If
Else
    pageMode = "등록"
    pageTitle = "재고 등록"
End If
Dim vCname
vCname = ""


%>
<!-- BOM 캐시 -->
<!--#include virtual="/TNG_WMS/Cache/Cache_bom.asp"-->
<!--#include virtual="/TNG_WMS/Cache/Cache_customer.asp"-->

<%

If vCidx <> "" Then

    If dictCustomerOne.Exists(CStr(vCidx)) Then
        vCname = dictCustomerOne(CStr(vCidx))
    Else
        vCname = "(알 수 없는 거래처)"
    End If
End If
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%=pageTitle%></title>
    <link rel="stylesheet" href="/inc/css/wms.css">

    <style>
        .form-box {
            background:#fff;
            border:1px solid #dcdfe6;
            padding:20px;
            max-width:700px;
        }
        .form-row { margin-bottom:12px; }
        .form-row label {
            display:block;
            margin-bottom:4px;
            font-weight:600;
        }
        .form-row input, .form-row select {
            width:100%;
            padding:8px;
            border:1px solid #ccc;
        }
        .btn-area { margin-top:20px; }
    </style>
    <script>
    function openCustomerPopup() {
        window.open(
            'customer/customer_popup.asp',
            'customerPopup',
            'width=900,height=700,scrollbars=yes'
        );
    }
    </script>
</head>

<body>
<div class="page-wrap">

<h2>재고 <%=pageMode%></h2>

<form method="post" action="TNG_WMS_stock_DB.asp" class="form-box">
<input type="hidden" name="stock_idx" value="<%=stock_idx%>">
<input type="hidden" name="is_popup" value="1">

<div class="form-row">
    <label>자재 이름</label>
    <select name="material_id" required>
        <option value="">-- 자재 선택 --</option>
    <%
    Dim k, selectedAttr
    For Each k In dictBom.Keys
        selectedAttr = ""
        If CStr(k) = CStr(vMaterial) Then
            selectedAttr = "selected"
        End If
    %>
            <option value="<%=k%>" <%=selectedAttr%>>
                <%=dictBom(k)%>
            </option>
    <%
    Next
    %>
    </select>
</div>


<div class="form-row">
    <label>구매 수량</label>
    <input type="number" name="amount" value="<%=vAmount%>" required>
</div>

<div class="form-row">
    <label>거래처</label>

    <input type="hidden" name="cidx" id="cidx" value="<%=vCidx%>">

    <input type="text" id="cname" readonly
           value="<%=vCname%>"
           placeholder="거래처를 선택하세요">

    <button type="button" class="btn"
            onclick="openCustomerPopup();">
        선택
    </button>
</div>
<div class="form-row">
    <label>입고 예정일</label>
    <input type="date" name="pre_in_date" value="<%=vPreInDate%>">
</div>

<div class="form-row">
    <label>총 구매 금액</label>
    <input type="number" name="total_price" value="<%=vTotalPrice%>">
</div>

<div class="form-row">
    <label>입고 상태</label>
    <select name="status">
        <option value="0" <% If vStatus="0" Then Response.Write "selected" %>>입고전</option>
        <option value="1" <% If vStatus="1" Then Response.Write "selected" %>>입고진행중</option>
        <option value="2" <% If vStatus="2" Then Response.Write "selected" %>>입고완료</option>
        <option value="3" <% If vStatus="3" Then Response.Write "selected" %>>불발</option>
    </select>
</div>

<div class="btn-area">
    <button class="btn btn-primary">저장</button>

</div>

</form>

</div>
</body>
</html>

<%
If isEdit Then
    Rs.Close
End If
Set Rs = Nothing
call dbClose()
%>
