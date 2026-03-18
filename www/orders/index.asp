<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>발주 목록</title>
  <!-- Bootstrap CSS & Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
  <style>
    .table-progress { height: 6px; margin-top: .25rem; }
    th.sortable { cursor: pointer; user-select: none; }
    th.sortable .sort-indicator { font-size: .8em; margin-left: 4px; visibility: hidden; }
    th.sortable.asc .sort-indicator.asc,
    th.sortable.desc .sort-indicator.desc { visibility: visible; }
  </style>
</head>
<body class="bg-light">
  <div class="container py-5">
    <h1 class="mb-4"><i class="bi bi-card-list me-2"></i>발주 목록</h1>

    <!-- 검색창 -->
    <div class="mb-3">
      <input id="search-input" type="text" class="form-control" placeholder="고객명, 주문번호, 상태 등으로 검색하세요">
    </div>

    <div class="table-responsive">
      <table class="table table-striped table-hover align-middle">
        <thead class="table-light">
          <tr>
            <th class="sortable" data-key="cname">고객명
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="statusText">상태
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="kidx">주문번호
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="kwdate">발주일
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="kidate">확인일
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="krdate">완료일
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="fmname">발주자
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="smname">입고담당
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th class="sortable" data-key="pct">진행률
              <span class="sort-indicator asc">▲</span><span class="sort-indicator desc">▼</span>
            </th>
            <th>내역보기</th>
          </tr>
        </thead>
        <tbody id="order-table-body">
          <!-- rows 삽입 -->
        </tbody>
      </table>
    </div>
  </div>

  <footer style="text-align: center; padding: 1rem 0; font-size: 0.9rem; color: #6c757d; background-color: #f8f9fa;">
  <a href="https://www.paletto.kr" target="_blank" rel="noopener" style="display: inline-flex; align-items: center; text-decoration: none; color: inherit;">
    <span style="margin-right: 0.1em;">Designed by Paletto</span>
    <img src="https://paletto.kr/assets/favicon/favicon.ico" alt="Paletto Logo" style="height: 1.5em; width: auto; vertical-align: middle;" />
  </a>
</footer>


  <script type="module">
    import { sortData } from './module/comparator/main.js';
    import { getComparator } from './module/comparator/comparatorFactory.js';

    let orders = [];
    let currentKey = 'kidx', currentDir = 'desc';

    const columnMeta = {
      cname:      { type: 'string' },
      statusText: { type: 'enum', options: { orderMap: { 발주중:0, 납품처확인:1, 진행중:2, 완료:3, 취소:4 } } },
      kidx:       { type: 'integer' },
      kwdate:     { type: 'date' },
      kidate:     { type: 'date' },
      krdate:     { type: 'date' },
      fmname:     { type: 'string' },
      smname:     { type: 'string' },
      pct:        { type: 'float' }
    };

    const searchInput = document.getElementById('search-input');
    const ths = document.querySelectorAll('th.sortable');
    const tbody = document.getElementById('order-table-body');

    ths.forEach(th => {
      th.addEventListener('click', () => {
        const key = th.dataset.key;
        if (currentKey === key) currentDir = currentDir === 'asc' ? 'desc' : 'asc';
        else { currentKey = key; currentDir = 'asc'; }
        updateSortIndicators();
        renderTable();
      });
    });

    function updateSortIndicators() {
      ths.forEach(th => {
        th.classList.remove('asc','desc');
        if (th.dataset.key === currentKey) th.classList.add(currentDir);
      });
    }

    function filterOrders(list, q) {
      if (!q) return list;
      q = q.trim().toLowerCase();
      return list.filter(i =>
        (i.cname || '').toLowerCase().includes(q) ||
        String(i.kidx || '').includes(q) ||
        (i.statusText || '').toLowerCase().includes(q) ||
        (i.fmname || '').toLowerCase().includes(q) ||
        (i.smname || '').toLowerCase().includes(q)
      );
    }

    function renderTable() {
      tbody.innerHTML = '';
      let view = filterOrders(orders, searchInput.value);
      view = sortData(view, currentKey, currentDir, columnMeta[currentKey]);

      view.forEach(item => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td>${item.cname}</td>
          <td><span class="badge bg-${item.badgeClass} rounded-pill">${item.statusText}</span></td>
          <td>${item.kidx}</td>
          <td>${item.kwdate||'-'}</td>
          <td>${item.kidate||'-'}</td>
          <td>${item.krdate||'-'}</td>
          <td>${item.fmname}</td>
          <td>${item.smname}</td>
          <td>
            <div class="d-flex justify-content-between small"><span>${item.pct}%</span></div>
            <div class="progress table-progress">
              <div class="progress-bar bg-${item.badgeClass}"
                   role="progressbar" style="width:${item.pct}%;"></div>
            </div>
          </td>
          <td>
            <a href="detail/index.asp?kidx=${item.kidx}"
               class="btn btn-sm btn-outline-primary">
              <i class="bi bi-eye"></i>
            </a>
          </td>`;
        tbody.appendChild(tr);
      });
    }

    searchInput.addEventListener('input', renderTable);

    fetch('/orders/module/list_extractor.asp')
      .then(res => res.json())
      .then(list => {
        orders = list;
        updateSortIndicators();
        renderTable();
      })
      .catch(err => console.error('발주 리스트 로드 실패:', err));
  </script>
</body>
</html>
