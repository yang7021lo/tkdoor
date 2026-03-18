<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
Call dbOpen()
rwh_idx = Request("wh_idx")
rmode = Request("mode")
rloc_code = Request("loc_code")
' 창고
Dim RsWh, SQL
Set RsWh = Server.CreateObject("ADODB.Recordset")
SQL = "SELECT wh_idx, wh_name FROM tk_wms_warehouse WHERE is_active=1 ORDER BY wh_name"
RsWh.Open SQL, DbCon
%>


<!--#include virtual="/TNG_WMS/Cache/Cache_bom.asp"-->


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자재 위치 등록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f4f6f9; font-size:14px; }
.loc-code { font-weight:700; color:#0d6efd; }
</style>
</head>

<body>
<div class="container p-4">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h5 class="fw-bold mb-0">📍 자재 위치 등록</h5>

    <% If rmode = "update"  Then %>
    <div style="width:260px;">
        <select class="form-select form-select-sm"
                id="stock_loc_idx_sel"
                onchange="loadStockLocDetail(this.value)">
            <option value="">LOT 선택</option>
            <%
            Dim RsTop, SQL_TOP
            Set RsTop = Server.CreateObject("ADODB.Recordset")

            SQL_TOP = ""
            SQL_TOP = SQL_TOP & "SELECT stock_loc_idx "
            SQL_TOP = SQL_TOP & "FROM tk_wms_stock_loc "
            SQL_TOP = SQL_TOP & "WHERE wh_idx = " & rwh_idx & " "
            SQL_TOP = SQL_TOP & "AND loc_code = '" & rloc_code & "' "
            SQL_TOP = SQL_TOP & "AND ISNULL(use_yn,1)=1 "
            SQL_TOP = SQL_TOP & "AND is_active = 1 "
            SQL_TOP = SQL_TOP & "ORDER BY stock_loc_idx DESC"
            response.Write SQL_TOP & "<br/>"
            RsTop.Open SQL_TOP, DbCon

            Do Until RsTop.EOF
            %>
                <option value="<%=RsTop("stock_loc_idx")%>">
                    LOT-<%=RsTop("stock_loc_idx")%>
                </option>
            <%
                RsTop.MoveNext
            Loop

            RsTop.Close : Set RsTop = Nothing
            %>
        </select>
    </div>
    <% End If %>
</div>

<form method="post" action="TNG_WMS_Location_DB.asp" onsubmit="return validateForm();">
<input type="hidden" name="mode" value="<%=rmode%>">
<input type="hidden" name="stock_loc_idx" id="stock_loc_idx" value="">
<!-- 창고 -->
<div class="mb-3">
    <label class="form-label">창고</label>
    <select name="wh_idx" class="form-select" required>
        <option value="">창고 선택</option>
        <% Do Until RsWh.EOF %>
            <option value="<%=RsWh("wh_idx")%>"><%=RsWh("wh_name")%></option>
        <% RsWh.MoveNext : Loop %>
    </select>
</div>

<!-- 위치 -->
<div class="row mb-3">
    <div class="col"><label>Zone</label><input id="zone" name="zone" class="form-control" required></div>
    <div class="col"><label>Rack</label><input id="rack" name="rack" class="form-control" required></div>
    <div class="col"><label>Shelf</label><input id="shelf" name="shelf" class="form-control" required></div>
    <div class="col"><label>Bin</label><input id="bin" name="bin" class="form-control" required></div>
</div>

<!-- Loc Code -->
<div class="mb-3">
    <label>Loc Code</label>
    <input id="loc_code" name="loc_code" class="form-control loc-code" readonly required>
</div>

<!-- 자재 -->
<div class="mb-3">
    <label>자재</label>
    <select id="material_id" name="material_id" class="form-select" required onchange="loadLots()">
        <option value="">자재 선택</option>
        <%
        Dim k
        For Each k In dictBom.Keys
        %>
            <option value="<%=k%>"><%=k%> | <%=dictBom(k)%></option>
        <%
        Next
        %>
    </select>
</div>

<!-- LOT -->
<div class="mb-3">
    <label>입고 LOT</label>
    <select id="stock_sub_idx" name="stock_sub_idx" class="form-select" required onchange="setRemain()">
        <option value="">LOT 선택</option>
    </select>
</div>

<!-- 잔여 -->
<div class="mb-3">
    <label>잔여 수량</label>
    <input id="remain_qty" class="form-control" readonly>
</div>
<input type="hidden" id="stock_idx" name="stock_idx">

<!-- 수량 -->
<div class="mb-4">
    <label>적재 수량</label>
    <input id="amount" name="amount" type="number" class="form-control" min="1" max="<%=amount%>" required>
</div>

<div class="text-end">
    <button class="btn btn-primary">등록</button>
    <button type="button" class="btn btn-secondary" onclick="window.close()">닫기</button>
    <% If rmode = "update"  Then %>
        <button class="btn btn-danger" onclick="submitDelete();">삭제</button>
    <% End If %>
</div>

</form>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    function pad(v) {
        if (!v) return "";
        return v.length === 1 ? "0" + v : v;
    }

    function updateLoc() {
        const zoneEl  = document.getElementById("zone");
        const rackEl  = document.getElementById("rack");
        const shelfEl = document.getElementById("shelf");
        const binEl   = document.getElementById("bin");
        const locEl   = document.getElementById("loc_code");

        if (!zoneEl || !rackEl || !shelfEl || !binEl || !locEl) return;

        const z = zoneEl.value.trim().toUpperCase();
        const r = pad(rackEl.value.trim());
        const s = pad(shelfEl.value.trim());
        const b = pad(binEl.value.trim());

        if (z && r && s && b) {
            locEl.value = z + "-" + r + "-" + s + "-" + b;
        } else {
            locEl.value = "";
        }
    }

    ["zone", "rack", "shelf", "bin"].forEach(function (id) {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener("input", updateLoc);
        }
    });

});

function loadLots(){
    let m = material_id.value;
    stock_sub_idx.innerHTML='<option value="">LOT 선택</option>';
    remain_qty.value=""; amount.value="";
    if(!m) return;

    fetch("/TNG_WMS/LOCATION/AJAX/TNG_WMS_AJAX_Location.asp?material_id="+m)
    .then(r=>r.json())
    .then(data=>{
        data.forEach(d=>{
            stock_sub_idx.innerHTML +=
                `<option 
                    value="${d.stock_sub_idx}" 
                    data-stock="${d.stock_idx}"
                    data-remain="${d.remain_qty}">
                    LOT-${d.stock_sub_idx} (잔여 ${d.remain_qty})
                </option>`;
        });
    });
}

function setRemain(){
    const opt = stock_sub_idx.selectedOptions[0];
    if (!opt) return;

    const stockIdx  = opt.dataset.stock;
    const remainQty = opt.dataset.remain;

    document.getElementById("stock_idx").value = stockIdx;
    document.getElementById("remain_qty").value = remainQty;
    amount.max = remainQty;
}

function validateForm(){
    if(Number(amount.value) > Number(remain_qty.value)){
        alert("적치 수량이 잔여 수량을 초과했습니다.");
        return false;
    }
    return true;
}

function loadStockLocDetail(stock_loc_idx){
    if(!stock_loc_idx) return;

    fetch("/TNG_WMS/LOCATION/AJAX/TNG_WMS_AJAX_Location_Detail.asp?stock_loc_idx=" + stock_loc_idx)
        .then(r => r.json())
        .then(d => {

            // 창고
            document.querySelector("select[name='wh_idx']").value = d.wh_idx;
            // stock_loc_idx
            document.getElementById("stock_loc_idx").value  = d.stock_loc_idx;
            // 위치
            document.getElementById("zone").value  = d.zone;
            document.getElementById("rack").value  = d.rack;
            document.getElementById("shelf").value = d.shelf;
            document.getElementById("bin").value   = d.bin;
            document.getElementById("loc_code").value = d.loc_code;

            // 재고 관련
            document.getElementById("stock_sub_idx").value = d.stock_sub_idx;
            document.getElementById("stock_idx").value = d.stock_idx;
            document.getElementById("remain_qty").value = d.amount;

            // 적재 수량 (수정 가능)
            document.getElementById("amount").value = d.amount;

            // ✅ 자재 자동 선택 (핵심)
            if (d.material_id) {
                material_id.value = d.material_id;
            }
           

        });
}
function submitDelete(){
    if (!confirm("해당 위치 정보를 삭제하시겠습니까?")) {
        return;
    }

    // mode를 delete로 변경
    document.querySelector("input[name='mode']").value = "delete";

    // form 전송
    document.forms[0].submit();
}
</script>

</body>
</html>
