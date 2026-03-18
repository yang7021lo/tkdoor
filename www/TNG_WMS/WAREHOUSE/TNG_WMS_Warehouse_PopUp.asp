<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

Dim wh_idx, wh_name, wh_addr, wh_lat, wh_lng, wh_floor, is_active
wh_idx = Trim(Request("wh_idx"))

wh_name  = ""
wh_addr  = ""
wh_lat   = ""
wh_lng   = ""
wh_floor = ""
is_active = 1

If wh_idx <> "" Then
    Dim Rs
    Set Rs = Server.CreateObject("ADODB.Recordset")

    Rs.Open "SELECT * FROM tk_wms_warehouse WHERE wh_idx=" & wh_idx, DbCon

    If Not Rs.EOF Then
        wh_name   = Rs("wh_name")
        wh_addr   = Rs("wh_addr")
        wh_addr_detail   = Rs("wh_addr_detail")
        wh_zip    = Rs("wh_zip_code")
        wh_lat    = Rs("wh_addr_lat")
        wh_lng    = Rs("wh_addr_long")
        wh_floor  = Rs("wh_addr_floor")
        is_active = Rs("is_active")
    End If

    Rs.Close
    Set Rs = Nothing
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>창고 등록 / 수정</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- ✅ Kakao 지도 (좌표 변환만 사용) -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=b8d1d143249772ffdcd77de1baa25006&libraries=services"></script>

<!-- ✅ 다음 주소 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body>
<div class="container p-3">

<h5 class="fw-bold mb-3">
<% If wh_idx="" Then %>➕ 창고 등록<% Else %>✏️ 창고 수정<% End If %>
</h5>

<form method="post" action="TNG_WMS_Warehouse_DB.asp">

<input type="hidden" name="wh_idx" value="<%=wh_idx%>">

<!-- 창고명 -->
<div class="mb-3">
    <label class="form-label">창고명</label>
    <input type="text" name="wh_name" class="form-control"
           value="<%=wh_name%>" required>
</div>

<!-- 주소 -->
<div class="mb-3">
    <label class="form-label">주소</label>
    <div class="input-group">
        <input type="text" name="wh_addr" id="wh_addr"
               class="form-control"
               value="<%=wh_addr%>" readonly required>
        <button type="button" class="btn btn-outline-secondary"
                onclick="execDaumPostcode();">
            주소 검색
        </button>
    </div>
</div>

<!-- 상세주소 -->
<div class="mb-3">
    <label class="form-label">상세주소</label>
    <div class="input-group">
        <input type="text" name="wh_addr_detail" id="wh_addr_detail"
               class="form-control"
               value="<%=wh_addr_detail%>" placeholder="상세주소 입력">
    </div>
</div>

<!-- hidden 우편번호/위도/경도 -->
<input type="hidden" name="wh_zip_code" id="wh_zip_code" value="<%=wh_zip%>">
<input type="hidden" name="wh_addr_lat" id="wh_addr_lat" value="<%=wh_lat%>">
<input type="hidden" name="wh_addr_long" id="wh_addr_long" value="<%=wh_lng%>">

<!-- 층수 -->
<div class="mb-3">
    <label class="form-label">층수</label>
    <input type="number" name="wh_addr_floor"
           class="form-control"
           value="<%=wh_floor%>"
           placeholder="예: 1, 2, -1">
</div>


<div class="text-end">
    <button class="btn btn-primary">저장</button>
    <button type="button" class="btn btn-secondary"
            onclick="window.close();">닫기</button>
</div>

</form>
</div>

<script>
var geocoder = new kakao.maps.services.Geocoder();

/* 다음 주소 */
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = data.roadAddress || data.jibunAddress;
            document.getElementById("wh_zip_code").value = data.zonecode;
            document.getElementById("wh_addr").value = addr;
            convertAddress(addr);
        }
    }).open();
}

/* 주소 → 위경도 */
function convertAddress(addr) {
    geocoder.addressSearch(addr, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            document.getElementById("wh_addr_lat").value  = result[0].y;
            document.getElementById("wh_addr_long").value = result[0].x;
        } else {
            alert("좌표 변환 실패");
        }
    });
}
</script>

</body>
</html>
