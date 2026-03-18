<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Spot Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background-color: #f4f6f9;
}

/* 카드 */
.spot-card {
    border-radius: 12px;
}
.spot-card.stop-alert {
    border: 2px solid #dc3545;
}

/* 헤더 */
.spot-header {
    background-color: #f8f9fa;
    font-weight: 600;
    font-size: 15px;
}

/* 상태 라인 */
.status-row {
    display: flex;
    align-items: center;
    font-size: 14px;
    margin-bottom: 8px;
}

/* hover 영역 */
.tooltip-wrap {
    position: relative;
    cursor: pointer;
}

.status-row .badge {
    width: 70px;
    text-align: center;
}

/* hover 박스 */
.tooltip-box {
    display: none;
    position: absolute;
    top: -5px;
    left: 110%;
    width: 260px;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 12px;
    font-size: 13px;
    box-shadow: 0 6px 14px rgba(0,0,0,0.15);
    z-index: 999;
}

/* hover 시 표시 */
.tooltip-wrap:hover .tooltip-box {
    display: block;
}

.tooltip-box strong {
    display: block;
    margin-bottom: 8px;
}

.tooltip-box ul {
    margin: 0;
    padding-left: 18px;
    max-height: 180px;
    overflow-y: auto;
}

.tooltip-box li {
    margin-bottom: 4px;
}

/* 총 자재 */
.total-row {
    font-size: 14px;
}
</style>
</head>

<body>

<div class="container-fluid p-4">
    <h4 class="mb-4">스팟별 자재 진행 현황</h4>

    <div class="row">

        <!-- Spot 카드 -->
        <div class="col-md-4 mb-4">
            <div class="card shadow-sm spot-card stop-alert">

                <div class="card-header spot-header">
                    Spot-01
                    <span class="text-muted ms-2">| 기계 1번</span>
                </div>

                <div class="card-body">

                    <!-- 진행 -->
                    <div class="status-row tooltip-wrap">
                        <span class="badge bg-primary me-2">진행중</span>
                        <strong>5</strong>

                        <div class="tooltip-box">
                            <strong>진행중 자재</strong>
                            <ul>
                                <li>자재 A</li>
                                <li>자재 B</li>
                                <li>자재 C</li>
                                <li>자재 D</li>
                                <li>자재 E</li>
                            </ul>
                        </div>
                    </div>

                    <!-- 완료 -->
                    <div class="status-row tooltip-wrap">
                        <span class="badge bg-success me-2">완료</span>
                        <strong>12</strong>

                        <div class="tooltip-box">
                            <strong>완료 자재</strong>
                            <ul>
                                <li>자재 F</li>
                                <li>자재 G</li>
                                <li>자재 H</li>
                                <li>자재 I</li>
                                <li>자재 J</li>
                                <li>자재 K</li>
                                <li>자재 L</li>
                                <li>자재 M</li>
                                <li>자재 N</li>
                                <li>자재 O</li>
                                <li>자재 P</li>
                                <li>자재 Q</li>
                            </ul>
                        </div>
                    </div>

                    <!-- 중지 -->
                    <div class="status-row tooltip-wrap">
                        <span class="badge bg-danger me-2">중지</span>
                        <strong>1</strong>

                        <div class="tooltip-box">
                            <strong>중지 자재</strong>
                            <ul>
                                <li>자재 X (자재 수급 대기)</li>
                            </ul>
                        </div>
                    </div>

                    <hr>

                    <div class="d-flex justify-content-between align-items-center total-row">
                        <div>
                            <span class="text-muted">총 자재</span>
                            <strong class="ms-1">18</strong>
                        </div>

                        <button class="btn btn-outline-secondary btn-sm">
                            자재 상세 보기
                        </button>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>
