<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>스팟 상세 관리</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
/* 전체 기본 글씨 */
body {
    font-size: 15px;
    line-height: 1.55;
    color: #111827;
}

/* 페이지 타이틀 */
h5.fw-bold,
.page-title {
    font-size: 22px;
    font-weight: 800;
    letter-spacing: 0.2px;
}

/* 섹션 타이틀 */
.section-title {
    font-size: 16px;
    font-weight: 700;
    color: #111827;
}

/* 테이블 */
.table th {
    font-size: 14.5px;
    font-weight: 700;
    color: #111827;
}

.table td {
    font-size: 15px;
    font-weight: 600;
    color: #111827;
}

/* 상태 배지 */
.status-badge,
.badge {
    font-size: 13.5px;
    font-weight: 700;
    padding: 6px 12px;
}

/* 상태 숫자 (진행중/완료/중지) */
.status-row strong,
.table td strong {
    font-size: 19px;
    font-weight: 800;
    color: #0f172a;
}

/* select box */
.form-select {
    font-size: 15px;
    font-weight: 700;
    padding: 8px 12px;
}

/* textarea */
textarea.form-control {
    font-size: 14.5px;
    font-weight: 600;
    line-height: 1.5;
}

/* 버튼 */
.btn {
    font-size: 14.5px;
    font-weight: 700;
    padding: 8px 16px;
}

/* 버튼 대비 강화 */
.btn-primary {
    background-color: #0d6efd;
    border-color: #0d6efd;
}

.btn-secondary {
    background-color: #6b7280;
    border-color: #6b7280;
}

/* 모달 제목 */
.modal-title {
    font-size: 18px;
    font-weight: 800;
}

/* 모달 본문 */
.modal-body {
    font-size: 15px;
    font-weight: 600;
}

/* 카드 */
.detail-card {
    max-width: 900px;
    margin: 0 auto;
    border-radius: 12px;
}

/* 섹션 타이틀 */
.section-title {
    font-weight: 700;
    font-size: 15px;
    margin-bottom: 10px;
}

/* 상태 배지 */
.status-badge {
    font-size: 13px;
    padding: 5px 10px;
}

/* 중지 사유 */
.stop-reason {
    margin-top: 6px;
}
</style>
</head>

<body>

<div class="container-fluid p-4">

    <div class="card shadow-sm detail-card">
        <div class="card-body">

            <h5 class="mb-4 fw-bold">스팟 상세 자재 관리</h5>

            <!-- 자재 리스트 -->
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>자재명</th>
                        <th>현재 스팟</th>
                        <th>기계</th>
                        <th>현재 상태</th>
                        <th width="260">상태 변경</th>
                    </tr>
                </thead>
                <tbody>

<%
' ===============================
' 더미 데이터 (실제론 DB 조회)
' ===============================
Dim i, itemName, curSpot, machineNo, curStatus

For i = 1 To 6

    itemName  = "자재 " & Chr(64 + i)   ' A, B, C...
    curSpot   = "Spot 1"
    machineNo = i & "번 기계"

    If i Mod 3 = 0 Then
        curStatus = "STOP"
    ElseIf i Mod 2 = 0 Then
        curStatus = "DONE"
    Else
        curStatus = "RUN"
    End If
%>

                    <tr data-item-id="<%=i%>">
                        <td><%=itemName%></td>
                        <td><%=curSpot%></td>
                        <td><%=machineNo%></td>
                        <td>
                            <% If curStatus = "RUN" Then %>
                                <span class="badge bg-primary status-badge">진행중</span>
                            <% ElseIf curStatus = "DONE" Then %>
                                <span class="badge bg-success status-badge">완료</span>
                            <% Else %>
                                <span class="badge bg-danger status-badge">중지</span>
                            <% End If %>
                        </td>
                        <td>
                            <select class="form-select form-select-sm status-select">
                                <option value="RUN"  <% If curStatus="RUN"  Then Response.Write "selected" %>>진행중</option>
                                <option value="DONE" <% If curStatus="DONE" Then Response.Write "selected" %>>완료</option>
                                <option value="STOP" <% If curStatus="STOP" Then Response.Write "selected" %>>중지</option>
                            </select>

                            <!-- 중지 사유 -->
                            <textarea class="form-control form-control-sm stop-reason <% If curStatus<>"STOP" Then Response.Write "d-none" %>"
                                      rows="2"
                                      placeholder="중지 사유 입력"></textarea>
                        </td>
                    </tr>

<%
Next
%>

                </tbody>
            </table>

            <!-- 버튼 -->
            <div class="d-flex justify-content-end gap-2 mt-3">
                <button class="btn btn-secondary" onclick="window.close()">닫기</button>
                <button class="btn btn-primary">저장</button>
            </div>

        </div>
    </div>

</div>

<!-- 완료 시 다음 스팟 선택 모달 -->
<div class="modal fade" id="nextSpotModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">다음 스팟 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <p class="mb-3">
            자재가 완료되었습니다.<br>
            다음 공정을 선택하세요.
        </p>

        <select class="form-select" id="nextSpotSelect">
            <option value="">선택하세요</option>
            <option value="2">Spot 2</option>
            <option value="3">Spot 3</option>
            <option value="4">Spot 4</option>
        </select>
      </div>

      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button class="btn btn-primary" id="confirmNextSpot">확인</button>
      </div>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
let currentRow = null;
const nextSpotModal = new bootstrap.Modal(
    document.getElementById('nextSpotModal')
);

document.querySelectorAll('.status-select').forEach(sel => {
    sel.addEventListener('change', function () {

        const row = this.closest('tr');
        const stopReason = row.querySelector('.stop-reason');

        // 중지
        if (this.value === 'STOP') {
            stopReason.classList.remove('d-none');
        } else {
            stopReason.classList.add('d-none');
        }

        // 완료
        if (this.value === 'DONE') {
            currentRow = row;
            nextSpotModal.show();
        }
    });
});

document.getElementById('confirmNextSpot').addEventListener('click', function () {
    const spot = document.getElementById('nextSpotSelect').value;

    if (!spot) {
        alert('다음 스팟을 선택하세요.');
        return;
    }

    // 여기서 currentRow 기준으로 DB 업데이트 로직 연동
    console.log('선택된 다음 스팟:', spot, currentRow.dataset.itemId);

    nextSpotModal.hide();
});
</script>

</body>
</html>
