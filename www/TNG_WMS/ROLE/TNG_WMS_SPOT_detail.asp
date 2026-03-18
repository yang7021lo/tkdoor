<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>자재 상세 관리</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background-color: #f4f6f9;
}

/* 카드 */
.detail-card {
    max-width: 700px;
    margin: 0 auto;
    border-radius: 12px;
}

/* 섹션 타이틀 */
.section-title {
    font-weight: 600;
    font-size: 15px;
    margin-bottom: 10px;
}

/* 상태 뱃지 */
.status-badge {
    font-size: 14px;
    padding: 6px 12px;
}

/* 폼 라벨 */
.form-label {
    font-weight: 600;
}
</style>
</head>

<body>

<div class="container-fluid p-4">

    <div class="card shadow-sm detail-card">
        <div class="card-body">

            <!-- 자재 기본 정보 -->
            <div class="mb-4">
                <div class="section-title">자재 정보</div>

                <table class="table table-sm">
                    <tr>
                        <th width="120">자재명</th>
                        <td>자재 A</td>
                    </tr>
                    <tr>
                        <th>현재 스팟</th>
                        <td>Spot 1</td>
                    </tr>
                    <tr>
                        <th>기계 번호</th>
                        <td>1번 기계</td>
                    </tr>
                </table>
            </div>

            <!-- 현재 상태 -->
            <div class="mb-4">
                <div class="section-title">현재 상태</div>

                <span class="badge bg-primary status-badge">진행중</span>
                <!-- 완료면 bg-success / 중지면 bg-danger -->
            </div>

            <!-- 상태 변경 -->
            <div class="mb-4">
                <div class="section-title">상태 변경</div>

                <select class="form-select">
                    <option value="RUN" selected>진행중</option>
                    <option value="DONE">완료</option>
                    <option value="STOP">중지</option>
                </select>
            </div>

            <!-- 스팟 이동 -->
            <div class="mb-4">
                <div class="section-title">스팟 이동</div>

                <select class="form-select">
                    <option value="1" selected>Spot 1</option>
                    <option value="2">Spot 2</option>
                    <option value="3">Spot 3</option>
                    <option value="4">Spot 4</option>
                </select>
            </div>

            <!-- 중지 사유 (중지일 때만 사용) -->
            <div class="mb-4">
                <div class="section-title">중지 사유</div>

                <textarea class="form-control" rows="3"
                          placeholder="중지 사유를 입력하세요"></textarea>
            </div>

            <!-- 버튼 -->
            <div class="d-flex justify-content-end gap-2">
                <button class="btn btn-secondary">취소</button>
                <button class="btn btn-primary">저장</button>
            </div>

        </div>
    </div>

</div>

</body>
</html>
