<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자재 진행 현황</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root{
    --bg-page:#eef1f4;
    --border:#d9dee5;
    --primary:#0d6efd;
    --success:#198754;
    --danger:#dc3545;
}

/* ===== Layout ===== */
body{
    background:#f4f6f9;
    font-family:'Segoe UI',sans-serif;
    color:#111827;
}
.main-content{
    margin-left:260px;
    padding:20px;
}

/* =========================================================
   2. 사이드바 (색은 유지, 글씨만 선명하게)
   ========================================================= */
.mp-sidebar {
    width: 260px;
    position: fixed;
    top: 0;
    left: 0;
    height: 100vh;
    background: #f4f6f9;
    border-right: 1px solid var(--border);
    box-shadow: 2px 0 6px rgba(0,0,0,0.08);
    transition: width .25s ease;
}


.mp-sidebar.collapsed ~ .main-content {
    margin-left: 72px;
}

/* 접힘 */
.mp-sidebar.collapsed {
    width: 72px;
}

.mp-sidebar.collapsed .logo-icon,
.mp-sidebar.collapsed .logo-text,
.mp-sidebar.collapsed .menu-item span,
.mp-sidebar.collapsed .menu-section {
    display: none !important;
}

/* ===== Header ===== */
.page-header{
    background:#fff;
    padding:16px 20px;
    border-radius:12px;
    border:1px solid #e5e7eb;
    margin-bottom:12px;
}

/* =========================================================
   3. 메인 영역
   ========================================================= */
.main-content {
    margin-left: 260px;
    padding: 20px;
    background: var(--bg-page);
}
/* ===== Filter ===== */
.filter-bar{
    display:flex;
    gap:8px;
    align-items:center;
    background:#fff;
    padding:12px 16px;
    border-radius:12px;
    border:1px solid #e5e7eb;
    margin-bottom:12px;
}

/* ===== Table ===== */
.table-wrapper{
    background:#fff;
    border-radius:12px;
    border:1px solid #e5e7eb;
    overflow:hidden;
}
.table th{
    background:#f1f5f9;
    font-size:13px;
    font-weight:800;
}
.table td{
    font-size:14px;
    vertical-align:middle;
}
tr.row-stop{
    background:#fff5f5;
}

/* ===== Status Badge ===== */
.badge-status{
    font-size:12px;
    font-weight:800;
}

/* ===== Step Flow ===== */
.step-inline{
    display:flex;
    align-items:center;
    gap:4px;
}
.step-dot{
    width:16px;
    height:16px;
    border-radius:50%;
}
.step-done{background:#22c55e;}
.step-current{background:#0d6efd;}
.step-wait{background:#e5e7eb;}
.step-stop{background:#dc3545;}
.step-line{
    width:12px;
    height:2px;
    background:#e5e7eb;
}

/* ===== Stop Tooltip ===== */
.stop-wrap{position:relative;}
.stop-tooltip{
    display:none;
    position:absolute;
    top:-34px;
    left:50%;
    transform:translateX(-50%);
    background:#fff;
    border:1px solid #dc3545;
    border-radius:6px;
    padding:4px 8px;
    font-size:11px;
    font-weight:700;
    white-space:nowrap;
    box-shadow:0 6px 14px rgba(0,0,0,.15);
}
.stop-wrap:hover .stop-tooltip{display:block;}

td strong {
    font-size: 16px;
    font-weight: 800;
}
</style>
</head>

<body>

<!-- 사이드바 -->
<!--#include virtual="/TNG_WMS/ROLE/TNG_WMS_Sidebar.asp"-->

<div class="main-content">

<!-- Header -->
<div class="page-header">
    <h4 class="mb-1">자재 진행 현황</h4>
    <div class="text-muted small">기준일 : 2025-12-19</div>
</div>

<!-- Filter -->
<div class="filter-bar">
    <input type="date" class="form-control form-control-sm" style="width:160px">
    <select class="form-select form-select-sm" style="width:120px">
        <option value="">전체 상태</option>
        <option>진행중</option>
        <option>중지</option>
        <option>완료</option>
    </select>
    <input type="text" class="form-control form-control-sm" placeholder="스팟">
    <input type="text" class="form-control form-control-sm" placeholder="팀검색">
    <input type="text" class="form-control form-control-sm" placeholder="거래처명">
    <input type="text" class="form-control form-control-sm" placeholder="품목명">
    <input type="text" class="form-control form-control-sm" placeholder="자재명 / 도장번호">
    <button class="btn btn-primary btn-sm px-4">조회</button>
</div>

<!-- Table -->
<div class="table-wrapper">
<table class="table table-bordered align-middle mb-0">
<thead>
<tr>
    <th width="140">거래처명</th>
    <th width="140">품목명</th>
    <th width="140">자재명</th>
    <th width="90">상태</th>
    <th width="110">현재 스팟</th>
    <th width="120">팀 / 기계</th>
    <th width="110">작업일</th>
    <th>진행 흐름</th>
    <th width="70"></th>
</tr>
</thead>
<tbody>

<%
Dim i, matName, workDate, teamName, machineName
Dim curStep, stopStep, stopReason, rowClass

For i = 1 To 3

    matName     = "자재 " & Chr(64+i)
    workDate    = "2025-12-19"
    teamName    = i & "팀"
    machineName = i & "번기계"

    curStep = i + 1
    stopStep = 0
    stopReason = ""

    If i = 2 Then
        stopStep = 3
        stopReason = "기계 이상 발생"
    End If
    rowClass = ""

    If stopStep > 0 Then
        rowClass = "row-stop"
    End If
%>

<tr class="<%=rowClass%>">
<td><strong>거래처</strong></td>
<td><strong>품목명</strong></td>
<td><strong><%=matName%></strong></td>

<td>
<% If stopStep>0 Then %>
    <span class="badge bg-danger badge-status">중지</span>
<% ElseIf curStep>=5 Then %>
    <span class="badge bg-success badge-status">완료</span>
<% Else %>
    <span class="badge bg-primary badge-status">진행중</span>
<% End If %>
</td>

<td><strong>Spot-<%=curStep%></strong></td>
<td><%=teamName%> / <%=machineName%></td>
<td><%=workDate%></td>

<td>
<div class="step-inline">
<%
Dim s
For s = 1 To 5
    If stopStep = s Then
%>
    <div class="stop-wrap">
        <div class="step-dot step-stop"></div>
        <div class="stop-tooltip">중지 : <%=stopReason%></div>
    </div>
<%
    ElseIf curStep > s Then
%>
    <div class="step-dot step-done"></div>
<%
    ElseIf curStep = s Then
%>
    <div class="step-dot step-current"></div>
<%
    Else
%>
    <div class="step-dot step-wait"></div>
<%
    End If
    If s < 5 Then
%>
    <div class="step-line"></div>
<%
    End If
Next
%>
</div>
</td>

<td class="text-end">
    <button class="btn btn-sm btn-outline-primary"
        onclick="openMaterial('<%=i%>')">상세</button>
</td>

</tr>

<%
Next
%>

</tbody>
</table>
</div>

</div>

<script>
function toggleSidebar() {
    document.getElementById('mpSidebar').classList.toggle('collapsed');
}
function openMaterial(id){
    window.open(
        'material_popup.asp?id='+id,
        'mat',
        'width=900,height=700,scrollbars=yes'
    );
}
</script>

</body>
</html>
