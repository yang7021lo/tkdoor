<%@ codepage="65001" language="vbscript" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"

  rsjcidx=request("sjcidx")
  rsjidx=request("sjidx")
  rsjb_type_no=request("sjb_type_no")
  rbalju_status=request("balju_status")



%>
  <!--#include virtual="/inc/dbcon.asp"-->
  <!--#include virtual="/inc/cookies.asp"-->
<%
  call dbOpen()
  Set Rs = Server.CreateObject ("ADODB.Recordset")

  If IsNull(rbalju_status) Or CInt(rbalju_status & "0") = 0 Then
    sql="update tng_sja set balju_status=1 "
    sql=sql&" where sjidx='"&rsjidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
  End If  
%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>발주 선택</title>

  <!-- Bootstrap (CDN) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    html, body { height: 100%; }
    body { background: #f6f7fb; }

    .center-wrap{
      min-height: 100%;
      display: flex;
      align-items: center;     /* 세로 중앙 */
      justify-content: center; /* 가로 중앙 */
      padding: 24px;
    }

    .center-card{
      width: min(720px, 100%);
      border: 1px solid rgba(0,0,0,.06);
      border-radius: 18px;
      box-shadow: 0 10px 30px rgba(0,0,0,.06);
      background: #fff;
      padding: 28px;
    }

    .btn-wide{
      min-width: 160px;
      height: 52px;
      border-radius: 14px;
      font-weight: 700;
      letter-spacing: .2px;
    }

    @media (max-width: 420px){
      .btn-wide{ min-width: 100%; }
    }

    .div-top {
        margin-top: 30px;
    }
  </style>
</head>

<body>
  <div class="center-wrap">
    <div class="center-card text-center">
      <div class="mb-3">
        <div class="h5 mb-1">원하는 작업을 선택하세요</div>
        <div class="text-muted" style="font-size:.95rem;"></div>
      </div>
      <%If rsjb_type_no >= 8 Then%>
        <div class="d-flex gap-3 justify-content-center flex-wrap">
          <button type="button" class="btn btn-outline-primary btn-wide" onclick="window.open('TNG1_B_baljuST.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>');">절곡발주</button>
          <button type="button" class="btn btn-outline-primary btn-wide" onclick="window.open('TNG1_B_baljuST1.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>');">샤링발주</button>
          <button type="button" class="btn btn-outline-primary btn-wide" onclick="window.open('TNG1_B_baljuAL.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>');">AL발주</button>
        </div>
        <div class="div-top">
            <button type="button" class="btn btn-dark btn-wide" data-bs-dismiss="modal" onclick="closePopup()">닫기</button>
        </div>
      <% Else %>
        <!-- 모달 -->
        <div class="modal fade" id="poModal" tabindex="-1" aria-hidden="true">
          <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">발주서 품목 선택</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
              </div>
              <div class="modal-body">
                <table class="table table-hover align-middle">
                  <colgroup>
                    <col style="width:80px"><col><col style="width:120px"><col style="width:140px">
                  </colgroup>
                  <thead class="table-light">
                    <tr>
                      <th class="text-center">순번</th>
                      <th>품목</th>
                      <th class="text-center">출력여부(0/1)</th>
                      <th class="text-center">액션(출력)</th>
                    </tr>
                  </thead>
                  <tbody id="itemTableBody">


                  </tbody>
                </table>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closePopup()">닫기</button>
              </div>
            </div>
          </div>
        </div>
        <script>
        (function () {
          const poModal       = document.getElementById('poModal');
          const itemTableBody = document.getElementById('itemTableBody');
          const listUrl       = '/TNG1/modal/print/index.asp?sjidx=<%=rsjidx%>';

          function loadPoTbody() {
            itemTableBody.innerHTML =
              '<tr><td colspan="4" class="text-center">불러오는 중...</td></tr>';
            fetch(listUrl + '&_=' + Date.now(), { cache: 'no-store' })
              .then(res => res.text())
              .then(html => itemTableBody.innerHTML = html)
              .catch(() => {
                itemTableBody.innerHTML =
                  '<tr><td colspan="4" class="text-center text-danger">불러오기 실패</td></tr>';
              });
          }

          // 모달 열릴 때 목록 로드
          poModal.addEventListener('show.bs.modal', loadPoTbody);

          // 출력 버튼: 출력창 띄우고, UI상 printed=1로만 표시 (저장 X)
          document.addEventListener('click', (e) => {
            const btn = e.target.closest('.btnPrint');
            if (!btn) return;

            const tr = btn.closest('tr');
            const id = tr && tr.dataset.id;
            if (!id) return;

        const cidx   = tr.querySelector('.hidCidx')?.value;
        const sjidx  = tr.querySelector('.hidSjidx')?.value;
        const sjsidx = tr.querySelector('.hidSjsidx')?.value;

        if (!cidx || !sjidx || !sjsidx) {
          alert('파라미터 누락(cidx/sjidx/sjsidx)');
          return;
        }

        // ✅ 올바른 방식: 쿼리스트링은 전부 URL 하나에
        const url = '/documents/insideOrder'
          + '?cidx='  + encodeURIComponent(cidx)
          + '&sjidx=' + encodeURIComponent(sjidx)
          + '&sjsidx='+ encodeURIComponent(sjsidx);

        window.open(url, '_blank');         // 새 탭
        // location.href = url;             // 같은 탭 이동을 원하면 이걸 사용

            // UI만 1로
            const cell = tr.querySelector('.cellPrinted');
            if (cell) cell.textContent = '1';

            // 원하면 버튼 상태 변경(선택)
            // btn.disabled = true;
            // btn.classList.remove('btn-outline-primary');
            // btn.classList.add('btn-secondary');
            // btn.textContent = '출력됨';
          });
        })();
        </script>
      <%End IF%>
    </div>
  </div>

  <script>
    function closePopup() {
    // 부모 페이지 새로고침 (선택)
    if (window.opener && !window.opener.closed) {
        window.opener.location.reload();
    }

    // 팝업 창 닫기 (X 버튼과 동일)
    window.close();
    }
    document.addEventListener('DOMContentLoaded', function () {
      const modalEl = document.getElementById('poModal');
      if (!modalEl) return;

      const modal = new bootstrap.Modal(modalEl, {
        backdrop: 'static',   // 바깥 클릭 방지 (선택)
        keyboard: true        // ESC 허용
      });

      modal.show();
    });
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
