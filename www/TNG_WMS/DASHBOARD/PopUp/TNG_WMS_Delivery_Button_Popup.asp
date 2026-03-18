<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Dim wms_idx, manual_idx, wms_type, ymd
wms_idx     = Trim(Request("wms_idx"))
manual_idx  = Trim(Request("manual_idx"))  ' ✅ 추가
wms_type    = Trim(Request("wms_type"))
ymd         = Trim(Request("ymd"))

' 안전: ymd 비어있으면 오늘로
If ymd = "" Then ymd = Date()

' manual_idx가 숫자인지 체크(원하면 강화 가능)
'If manual_idx <> "" And Not IsNumeric(manual_idx) Then manual_idx = ""
'If wms_idx <> "" And Not IsNumeric(wms_idx) Then wms_idx = ""
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>배송 정보 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f4f6f9; font-size:14px; }
.btn-box {
    display: flex;
    flex-direction: column;
    gap: 14px;
}
.btn-box a {
    padding: 14px;
    font-size: 15px;
    font-weight: 600;
}
</style>
</head>

<body>
<div class="container p-4">

<h5 class="mb-4 text-center">배송 정보 관리</h5>

<div class="btn-box">
    <% If CStr(manual_idx) = "" Then %>
      <!-- 1️⃣ wms_type 변경 -->
      <a href="javascript:void(0);"
        class="btn btn-outline-primary"
        onclick="window.open(
          '/TNG_WMS/DASHBOARD/POPUP/TNG_WMS_Type_Select_Popup.asp?wms_idx=<%=Server.URLEncode(wms_idx)%>&manual_idx=<%=Server.URLEncode(manual_idx)%>&wms_type=<%=Server.URLEncode(wms_type)%>&ymd=<%=Server.URLEncode(ymd)%>',
          'wmsTypePopup',
          'width=420,height=420,scrollbars=yes'
        );">
        출고 유형 변경
      </a>
    <% End If %>
    <!-- 2️⃣ 화물 / 택배 수정 -->
    <a href="javascript:void(0);"
       class="btn btn-outline-success"
       onclick="window.open(
         '/TNG_WMS/DASHBOARD/POPUP/TNG_WMS_Delivery_Info_Popup.asp?wms_idx=<%=Server.URLEncode(wms_idx)%>&manual_idx=<%=Server.URLEncode(manual_idx)%>&wms_type=<%=Server.URLEncode(wms_type)%>&ymd=<%=Server.URLEncode(ymd)%>',
         'deliveryInfoPopup',
         'width=520,height=520,scrollbars=yes'
       );">
       화물 · 택배 정보 수정
    </a>

    <% If CStr(wms_type) = "13" Then %>
    <!-- 3️⃣ 용차 (사랑과물류) -->
    <a href="javascript:void(0);"
       class="btn btn-outline-danger"
       onclick="window.open(
         '/TNG_WMS/DASHBOARD/POPUP/TNG_WMS_Truck_Popup.asp?wms_idx=<%=Server.URLEncode(wms_idx)%>&manual_idx=<%=Server.URLEncode(manual_idx)%>&wms_type=<%=Server.URLEncode(wms_type)%>&ymd=<%=Server.URLEncode(ymd)%>',
         'truckPopup',
         'width=420,height=650,scrollbars=yes'
       );">
       용차 정보 입력 (사랑과물류)
    </a>
    <% End If %>

</div>

<div class="text-center mt-4">
    <button class="btn btn-secondary" onclick="window.close()">닫기</button>
</div>

</div>
</body>
</html>
