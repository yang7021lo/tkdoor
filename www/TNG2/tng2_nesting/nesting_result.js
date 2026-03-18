/* nesting_result.js */
(function() {
  'use strict';

  // 데이터 로드
  let NESTING_DATA = null;
  try {
    const stored = sessionStorage.getItem("NESTING_DATA");
    if (stored) NESTING_DATA = JSON.parse(stored);
  } catch(e) {}

  // 세션 데이터 없으면 DB 데이터 사용
  const ITEMS = (NESTING_DATA && NESTING_DATA.items) ? NESTING_DATA.items : DB_ITEMS;
  const PLATES = (NESTING_DATA && NESTING_DATA.plates) ? NESTING_DATA.plates : [
    {width: 1220, length: 4000, qty: 100000},
    {width: 1220, length: 3000, qty: 100000},
    {width: 1220, length: 2440, qty: 100000}
  ];

  // 네스팅 실행
  const result = NestingCalc.runNesting(ITEMS, PLATES);

  // 요약 테이블
  function renderSummary() {
    const box = document.getElementById('summaryBox');
    let html = '<table class="summary-table">';
    html += '<tr><th>판재 규격</th><th>수량</th><th>단위</th><th>로스율</th></tr>';
    
    result.summary.plateSummary.forEach(p => {
      // 해당 규격 시트들의 평균 로스율
      const sheets = result.sheets.filter(s => s.plate.spec === p.spec);
      const avgLoss = sheets.length > 0 ? 
        (sheets.reduce((sum, s) => sum + s.lossRate, 0) / sheets.length).toFixed(2) : 0;
      
      html += '<tr>';
      html += '<td>' + p.spec + '</td>';
      html += '<td>' + p.count + '</td>';
      html += '<td>장</td>';
      html += '<td>' + avgLoss + '%</td>';
      html += '</tr>';
    });
    
    html += '<tr style="font-weight:bold;background:#e8f0fe">';
    html += '<td>총계</td>';
    html += '<td>' + result.summary.totalSheets + '</td>';
    html += '<td>장</td>';
    html += '<td>' + result.summary.overallLossRate + '%</td>';
    html += '</tr>';
    html += '</table>';
    
    box.innerHTML = html;
  }

  // 시트 목록 렌더링
  function renderSheets() {
    const list = document.getElementById('sheetList');
    list.innerHTML = '';
    
    result.sheets.forEach(sheet => {
      const {card, canvas} = NestingDraw.createSheetCard(sheet);
      list.appendChild(card);
      NestingDraw.drawSheet(canvas, sheet, {maxWidth: 850, margin: 25});
    });
  }

  // 버튼 이벤트
  document.getElementById('btnPrint').onclick = function() {
    window.print();
  };

  document.getElementById('btnBack').onclick = function() {
    location.href = 'nesting_main.asp?sjidx=' + PARAMS.sjidx + '&cidx=' + PARAMS.cidx + '&sjmidx=' + PARAMS.sjmidx;
  };

  document.getElementById('btnCuttingList').onclick = function() {
    // 절곡수 데이터 저장
    sessionStorage.setItem("CUTTING_DATA", JSON.stringify({
      items: ITEMS,
      header: HEADER,
      params: PARAMS
    }));
    window.open('nesting_print.asp?sjidx=' + PARAMS.sjidx, 'cuttingList', 'width=900,height=700');
  };

  // F12 방지
  document.addEventListener("keydown", function(e) {
    if (e.key === "F12" || (e.ctrlKey && e.shiftKey && e.key === "I")) {
      e.preventDefault(); return false;
    }
  });
  document.addEventListener("contextmenu", function(e) { e.preventDefault(); });

  // 초기화
  renderSummary();
  renderSheets();

})();
