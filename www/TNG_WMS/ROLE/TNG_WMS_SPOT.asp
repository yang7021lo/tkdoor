<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"

Dim selDate
selDate = Request("ymd")
If selDate = "" Then selDate = Date()
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Spot Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* ================= 상단 빈 공간 제거 ================= */

/* 상위 wrapper 강제 초기화 */
.app-layout,
.main-content {
    margin-top: 0 !important;
    padding-top: 0 !important;
}

/* 혹시 모를 page/content wrapper */
.page-wrapper,
.page-content,
.content-wrapper {
    margin-top: 0 !important;
    padding-top: 0 !important;
}
/* ================= 운영 기준 컬러 변수 (최상단) ================= */
:root {
    --bg-page: #eef1f4;
    --bg-card: #ffffff;
    --border: #d9dee5;

    --text-main: #111827;   /* 거의 검정 */
    --text-sub:  #374151;   /* 짙은 회청 */
    --text-soft: #4b5563;

    --primary: #0d6efd;
    --success: #198754;
    --danger:  #dc3545;
}

body {
    background: var(--bg-page);
    color: var(--text-main);
    font-family: 'Segoe UI', sans-serif;
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

/* =========================================================
   3. 메인 영역
   ========================================================= */
.main-content {
    margin-left: 260px;
    padding: 20px;
    background: var(--bg-page);
}

.mp-sidebar.collapsed ~ .main-content {
    margin-left: 72px;
}

/* =========================================================
   4. 상단 헤더 카드
   ========================================================= */
.page-header-card {
    background: var(--bg-card);
    border-radius: 14px;
    padding: 18px 22px;
    border: 1px solid var(--border);
    box-shadow: 0 4px 14px rgba(0,0,0,.06);
}

.page-title {
    font-size: 20px;
    font-weight: 800;
    color: var(--text-main);
}

.page-sub {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-sub);
}

/* =========================================================
   5. 검색 영역 (현장 가독성)
   ========================================================= */
.header-filter {
    display: flex;
    align-items: center;
    gap: 10px;
}

.filter-group {
    display: flex;
    align-items: center;
    gap: 6px;
    background: #f1f3f5;
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 6px 10px;
}

.filter-group input[type="date"] {
    border: none;
    background: transparent;
    font-size: 14px;
    font-weight: 700;
    color: var(--text-main);
    outline: none;
}

.btn-filter {
    background: var(--primary);
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 8px 16px;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
}

/* =========================================================
   6. Spot 카드 (가독성 최우선)
   ========================================================= */
.spot-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: 12px;
}

/* 중지 카드 */
.spot-card.stop-alert {
    border: 2px solid var(--danger);
    background: #fff5f5;
}

/* =========================================================
   7. 카드 헤더
   ========================================================= */
.spot-header-strip {
    display: flex;
    border-bottom: 1px solid var(--border);
}

.spot-strip {
    width: 84px;
    font-size: 14px;
    font-weight: 800;
    color: #fff;
    background: var(--primary);
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 12px;
}

.spot-card.stop-alert .spot-strip {
    background: var(--danger);
}

.spot-header-content {
    padding: 8px 12px;
    color: var(--text-main);
}

.spot-header-content .fw-semibold {
    font-size: 14px;
    font-weight: 700;
}

.spot-header-content .date {
    font-size: 13px;
    font-weight: 600;
    color: var(--text-sub);
}

/* =========================================================
   8. 상태 영역 (숫자 중심)
   ========================================================= */
.status-row {
    display: flex;
    align-items: center;
    margin-bottom: 6px;
}

.status-row strong {
    font-size: 19px;
    font-weight: 800;
    color: var(--text-main);
}

/* =========================================================
   9. 배지 (색 + 글자 대비)
   ========================================================= */
.badge {
    font-size: 12px;
    font-weight: 700;
    color: #fff !important;
}

/* =========================================================
   10. 총합 영역
   ========================================================= */
.spot-card .text-muted {
    color: var(--text-soft) !important;
    font-weight: 600;
}

.spot-card .d-flex strong {
    font-size: 18px;
    font-weight: 800;
    color: var(--text-main);
}

/* =========================================================
   11. 버튼
   ========================================================= */
.btn-outline-secondary {
    border-color: var(--border);
    color: var(--text-main);
    font-weight: 600;
}

.btn-outline-secondary:hover {
    background: #f1f3f5;
}

/* =========================================================
   12. 불필요한 옅은 회색 완전 제거
   ========================================================= */
.text-muted {
    color: var(--text-sub) !important;
    opacity: 1 !important;
}


/* 카드 갯수 */
@media (min-width: 1200px) {
    .col-xl-2-4 {
        flex: 0 0 auto;
        width: 20%;
    }
}

.run-dots {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    margin-left: 6px;
}

/* 각 점 */
.run-dots span {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--primary);   /* 진행중 색상 */
    opacity: 0.3;
    animation: runBlink 1.4s infinite ease-in-out;
}

/* 순차 애니메이션 */
.run-dots span:nth-child(1) {
    animation-delay: 0s;
}
.run-dots span:nth-child(2) {
    animation-delay: .2s;
}
.run-dots span:nth-child(3) {
    animation-delay: .4s;
}

/* 애니메이션 정의 */
@keyframes runBlink {
    0%   { opacity: 0.25; }
    20%  { opacity: 1; }
    100% { opacity: 0.25; }
}

/* hover 기준 */
.status-hover {
    position: relative;
}

/* 툴팁 박스 */
.status-tooltip {
    position: absolute;
    top: 100%;
    left: 0;
    margin-top: 6px;
    min-width: 180px;
    background: #ffffff;
    border: 1px solid var(--border);
    border-radius: 10px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    padding: 10px 12px;
    font-size: 13px;
    color: var(--text-main);
    z-index: 100;
    display: none;
}

/* 타이틀 */
.status-tooltip .tooltip-title {
    font-weight: 700;
    margin-bottom: 6px;
}

/* 리스트 */
.status-tooltip ul {
    padding-left: 16px;
    margin: 0;
}

.status-tooltip li {
    margin-bottom: 4px;
}

/* Hover 시 표시 */
.status-hover:hover .status-tooltip {
    display: block;
}

</style>
</head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
<body>

<div class="app-layout">

    <!--#include virtual="/TNG_WMS/ROLE/TNG_WMS_Sidebar.asp"-->


    <!-- ================= Main ================= -->
    <main class="main-content">

        <div class="page-header-card mb-4">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">

                <!-- 타이틀 -->
                <div>
                    <h4 class="page-title mb-1">스팟별 자재 진행 현황</h4>
                    <div class="page-sub">기준일 : 2025-12-19</div>
                </div>

                <!-- 검색 / 필터 -->
                <form class="header-filter">
                    <div class="filter-group">
                        <span class="filter-icon">📅</span>
                        <input type="date" name="ymd" value="<%=ymd_html%>">
                    </div>

                    <button type="submit" class="btn-filter">
                        조회
                    </button>
                </form>

            </div>
        </div>
        <div class="row g-3">

<%
Dim i, spotName, teamName, runCnt, doneCnt, stopCnt, totalCnt
For i = 1 To 18

    spotName = "Spot-" & Right("0" & i, 2)
    teamName = ((i Mod 3) + 1) & "팀"

    runCnt  = (i * 2) Mod 7
    doneCnt = (i * 3) Mod 10

    stopCnt = 0
    If i Mod 5 = 0 Then stopCnt = 1

    totalCnt = runCnt + doneCnt + stopCnt
%>

            <div class="col-xl-2-4 col-lg-3 col-md-4 col-sm-6">
                <div class="card shadow-sm spot-card <% If stopCnt > 0 Then %>stop-alert<% End If %> h-100">

                    <div class="card-header spot-header-strip">
                        <div class="spot-strip <% If stopCnt > 0 Then %>stop<% End If %>">
                            <span><%=spotName%></span>
                        </div>
                        <div class="spot-header-content">
                            <div class="fw-semibold">
                                <span class="badge bg-primary me-1"><%=teamName%> | 기계이름</span> 담당자
                            </div>
                            <div class="date"><%=selDate%></div>
                        </div>
                    </div>

                    <div class="card-body py-2">

                        <div class="status-row status-hover">
                            <span class="badge bg-primary me-2">진행중</span>
                            <strong><%=runCnt%></strong>

                            <% If runCnt > 0 Then %>
                                <span class="run-dots"><span></span><span></span><span></span></span>

                                <!-- 툴팁 -->
                                <div class="status-tooltip">
                                    <div class="tooltip-title">진행중 자재</div>
                                    <ul>
                                        <li>자재 A </li>
                                        <li>자재 B </li>
                                        <li>자재 C </li>
                                    </ul>
                                </div>
                            <% End If %>
                        </div>

                        <div class="status-row">
                            <span class="badge bg-success me-2">완료</span>
                            <strong><%=doneCnt%></strong>
                        </div>

                        <div class="status-row">
                            <span class="badge bg-danger me-2">중지</span>
                            <strong><%=stopCnt%></strong>
                        </div>

                        <hr class="my-2">

                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted">총</span>
                                <strong class="ms-1"><%=totalCnt%></strong>
                            </div>
                            <button class="btn btn-outline-secondary btn-sm"
                                    onclick="window.open('TNG_WMS_SPOT_Popup_detail.asp?spot_id=<%=i%>&ymd=<%=selDate%>',
                                    'SPOTDetail','width=700,height=700,scrollbars=yes')">
                                상세
                            </button>
                        </div>

                    </div>
                </div>
            </div>

<%
Next
%>

        </div>
    </main>

</div>
<script>
    function toggleSidebar() {
    document.getElementById('mpSidebar').classList.toggle('collapsed');
}
</script>
</body>
</html>
