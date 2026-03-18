/* ================================
   네스팅 결과 페이지 JS
   /tng2/nesting/nesting_result.js
   - 통합 네스팅: 선택된 판재 전체 동시 사용
   - 부품 길이 기준 판재 자동 배정
================================ */

(function() {
  'use strict';

  // 전역 상태
  window.SELECTED_ITEM = null;
  window.SELECTED_MATERIAL = null;

  // Split.js 초기화
  Split(['#left', '#right'], {
    sizes: [40, 60],
    minSize: [320, 420],
    gutterSize: 14
  });

  // =============================
  // 판재 자동 배정 (부품 길이 기준)
  // 길이>=3900 → 4000판, >=2900 → 3000판, 나머지 → 2440판
  // =============================
  function assignSheet(partLength) {
    var len = Number(partLength);
    // SELECTED_SHEETS에서 사용 가능한 판재 중 매칭
    var available = SELECTED_SHEETS.map(function(s) {
      var parsed = NestingCalc.parseSheet(s);
      return { value: s, sheetW: parsed.sheetW };
    }).sort(function(a, b) { return b.sheetW - a.sheetW; }); // 큰 판재부터

    // 길이 기준 배정 규칙
    if (len >= 3900) {
      var big = available.find(function(a) { return a.sheetW >= 4000; });
      if (big) return big.value;
    }
    if (len >= 2900) {
      var mid = available.find(function(a) { return a.sheetW >= 3000; });
      if (mid) return mid.value;
    }
    // 나머지 → 가장 작은 판재
    var small = available.find(function(a) { return a.sheetW >= len; });
    if (small) return small.value;

    // 어디에도 안 맞으면 가장 큰 판재
    return available.length > 0 ? available[0].value : '1219x2440';
  }

  // =============================
  // 선택된 판재 칩 렌더링
  // =============================
  function renderSheetChips() {
    var wrap = document.getElementById('sheetChips');
    if (!wrap) return;
    wrap.innerHTML = '';

    SELECTED_SHEETS.forEach(function(s) {
      var parsed = NestingCalc.parseSheet(s);
      var chip = document.createElement('span');
      chip.className = 'sheet-chip';
      chip.textContent = parsed.label;
      wrap.appendChild(chip);
    });
  }

  // =============================
  // 재질 탭 렌더링
  // =============================
  function renderMaterialTabs() {
    var wrap = document.getElementById('materialTabs');
    if (!wrap) return;
    wrap.innerHTML = '';

    var materials = NestingCalc.getMaterialList(RAW_ITEMS);
    if (materials.length === 0) return;

    if (!window.SELECTED_MATERIAL) {
      window.SELECTED_MATERIAL = materials[0];
    }

    materials.forEach(function(m) {
      var btn = document.createElement('button');
      btn.className = 'mat-btn';
      btn.textContent = m;
      btn.onclick = function() {
        window.SELECTED_MATERIAL = m;
        renderMaterialTabs();
        render();
      };
      if (m === window.SELECTED_MATERIAL) {
        btn.classList.add('active');
      }
      wrap.appendChild(btn);
    });
  }

  // =============================
  // 필터링된 아이템 가져오기
  // =============================
  function getFilteredItems() {
    if (!window.SELECTED_MATERIAL) return RAW_ITEMS;
    return NestingCalc.filterByMaterial(RAW_ITEMS, window.SELECTED_MATERIAL);
  }

  // =============================
  // 좌측 아이템 리스트 테이블
  // =============================
  var itemTable = new Tabulator('#itemList', {
    data: RAW_ITEMS,
    layout: 'fitColumns',
    height: '100%',
    groupBy: 'width',
    groupHeader: function(value, count) {
      return '샤링값 ' + value + 'mm <span class="grp-count">(' + count + '건)</span>';
    },
    rowClick: function(e, row) {
      row.getTable().deselectRow();
      row.select();

      var d = row.getData();
      window.SELECTED_ITEM = {
        width: Number(d.width),
        length: Number(d.length),
        baname: d.baname
      };

      render();
    },
    columns: [
      { title: '자재명', field: 'baname', widthGrow: 3 },
      { title: '폭(mm)', field: 'width', hozAlign: 'right', width: 80 },
      { title: '길이(mm)', field: 'length', hozAlign: 'right', width: 100, sorter: 'number' },
      { title: '수량', field: 'qty', hozAlign: 'right', width: 60, bottomCalc: 'sum' }
    ]
  });

  // =============================
  // 통합 네스팅 렌더링
  // =============================
  function render() {
    var list = document.getElementById('sheetList');
    var summaryEl = document.getElementById('nestingSummary');
    list.innerHTML = '';
    summaryEl.innerHTML = '';

    var filteredItems = getFilteredItems();
    var expanded = NestingCalc.expandItems(filteredItems);

    // 부품별 판재 배정
    var sheetGroups = {}; // { "1219x4000": [items...], ... }

    expanded.forEach(function(piece) {
      var assigned = assignSheet(piece.len);
      if (!sheetGroups[assigned]) sheetGroups[assigned] = [];
      sheetGroups[assigned].push(piece);
    });

    // 판재별 네스팅 실행 & 결과 수집
    var allResults = []; // { sheetValue, parsed, sheets }
    var summaryParts = [];
    var totalPieces = 0;
    var totalSheets = 0;
    var globalSheetNo = 0;

    // 판재 크기 내림차순 정렬
    var sheetKeys = Object.keys(sheetGroups).sort(function(a, b) {
      var pa = NestingCalc.parseSheet(a);
      var pb = NestingCalc.parseSheet(b);
      return pb.sheetW - pa.sheetW;
    });

    sheetKeys.forEach(function(sv) {
      var parsed = NestingCalc.parseSheet(sv);
      var items = sheetGroups[sv];
      var sheets = NestingCalc.buildSheets(items, parsed.sheetW, parsed.sheetH);

      // 글로벌 시트 번호 재설정
      sheets.forEach(function(s) {
        globalSheetNo++;
        s.sheetNo = globalSheetNo;
      });

      totalPieces += items.length;
      totalSheets += sheets.length;
      summaryParts.push(parsed.label + ': ' + sheets.length + '장');

      allResults.push({
        sheetValue: sv,
        parsed: parsed,
        sheets: sheets
      });
    });

    // 요약 표시
    var stat = document.getElementById('stat');
    stat.textContent = '총 ' + totalPieces + '개 / 시트 ' + totalSheets + '장';

    if (summaryParts.length > 0) {
      summaryEl.innerHTML = '<div class="summary-bar">' +
        summaryParts.map(function(p) {
          return '<span class="summary-item">' + p + '</span>';
        }).join('') +
        '</div>';
    }

    // 판재별 시트 카드 렌더링
    allResults.forEach(function(r) {
      // 판재 그룹 헤더
      if (allResults.length > 1) {
        var groupHeader = document.createElement('div');
        groupHeader.className = 'sheet-group-header';
        groupHeader.textContent = r.parsed.label + ' (' + r.sheets.length + '장)';
        list.appendChild(groupHeader);
      }

      r.sheets.forEach(function(s) {
        var result = NestingDraw.createSheetCard(s, r.parsed.label);
        NestingDraw.drawSheetScreen(result.canvas, s, r.parsed.sheetW, r.parsed.sheetH, window.SELECTED_ITEM);
        list.appendChild(result.card);
      });
    });
  }

  // =============================
  // 버튼 이벤트
  // =============================
  document.getElementById('btnGenerate').addEventListener('click', function() {
    window.SELECTED_ITEM = null;
    render();
  });

  document.getElementById('btnPrint').addEventListener('click', function() {
    window.print();
  });

  document.getElementById('btnBack').addEventListener('click', function() {
    location.href = 'nesting_main.asp?sjidx=' + PARAMS.sjidx +
                    '&cidx=' + PARAMS.cidx +
                    '&sjmidx=' + PARAMS.sjmidx;
  });

  // =============================
  // F12 방지
  // =============================
  document.addEventListener('keydown', function(e) {
    if (e.key === 'F12') {
      e.preventDefault();
      return false;
    }
    if (e.ctrlKey && e.shiftKey && e.key === 'I') {
      e.preventDefault();
      return false;
    }
    if (e.ctrlKey && e.key === 'u') {
      e.preventDefault();
      return false;
    }
  });

  document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
    return false;
  });

  // =============================
  // 초기화
  // =============================
  renderSheetChips();
  renderMaterialTabs();
  render();

})();
