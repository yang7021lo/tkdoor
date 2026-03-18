/* ================================
   네스팅 메인 페이지 JS
   /tng2/nesting/nesting_main.js
================================ */

(function(){
  'use strict';

  // =============================
  // 좌측 테이블 (전체 판재 목록)
  // =============================
  const tableLeft = new Tabulator("#tableLeft", {
    data: ALL_SHEETS,
    layout: "fitColumns",
    height: "100%",
    selectable: true,
    selectableRangeMode: "click",
    columns: [
      {
        formatter: "rowSelection",
        titleFormatter: "rowSelection",
        hozAlign: "center",
        headerSort: false,
        width: 40,
        cellClick: function(e, cell) {
          cell.getRow().toggleSelect();
        }
      },
      { title: "코드", field: "qtyco_idx", width: 60, hozAlign: "center" },
      { title: "이름", field: "qtyname", widthGrow: 2 },
      { title: "규격", field: "spec", width: 100 },
      { title: "재질", field: "qtyname", width: 80 },
      { title: "두께", field: "sheet_t", width: 60, hozAlign: "center" },
      { title: "HL", field: "hl", width: 40, hozAlign: "center" }
    ],
    rowDblClick: function(e, row) {
      moveToRight([row.getData()]);
    }
  });

  // 좌측 필터
  document.getElementById("filterLeft").addEventListener("input", function(e) {
    const val = e.target.value.trim().toLowerCase();
    if (!val) {
      tableLeft.clearFilter();
      return;
    }
    tableLeft.setFilter(function(data) {
      return (
        (data.qtyname || "").toLowerCase().includes(val) ||
        (data.spec || "").toLowerCase().includes(val) ||
        (data.sheet_t || "").toLowerCase().includes(val) ||
        String(data.qtyco_idx).includes(val)
      );
    });
  });

  // =============================
  // 우측 테이블 (선택된 판재 목록)
  // =============================
  const tableRight = new Tabulator("#tableRight", {
    data: SELECTED_SHEETS,
    layout: "fitColumns",
    height: "100%",
    selectable: true,
    selectableRangeMode: "click",
    columns: [
      {
        formatter: "rowSelection",
        titleFormatter: "rowSelection",
        hozAlign: "center",
        headerSort: false,
        width: 40,
        cellClick: function(e, cell) {
          cell.getRow().toggleSelect();
        }
      },
      { title: "코드", field: "qtyco_idx", width: 50, hozAlign: "center" },
      { 
        title: "이름", 
        field: "qtyname", 
        widthGrow: 2,
        formatter: function(cell) {
          const d = cell.getRow().getData();
          // 재질-두께-규격 조합
          return `${d.qtyname || ""}-${d.sheet_t || ""}-${d.spec || ""}`;
        }
      },
      { title: "규격", field: "spec", width: 100 },
      { title: "재질", field: "qtyname", width: 70 },
      { title: "두께", field: "sheet_t", width: 50, hozAlign: "center" },
      { title: "HL", field: "hl", width: 35, hozAlign: "center" },
      { 
        title: "수량", 
        field: "qty", 
        width: 80, 
        hozAlign: "right",
        editor: "number",
        editorParams: {
          min: 0,
          max: 999999
        },
        formatter: function(cell) {
          const val = cell.getValue();
          return val ? Number(val).toLocaleString() : "0";
        }
      }
    ],
    rowDblClick: function(e, row) {
      moveToLeft([row.getData()]);
    }
  });

  // 선택 카운트 업데이트
  function updateSelectedCount() {
    const count = tableRight.getData().length;
    document.getElementById("selectedCount").textContent = count + "개 선택";
  }
  updateSelectedCount();

  // =============================
  // 이동 함수
  // =============================
  function moveToRight(items) {
    if (!items || items.length === 0) return;
    
    const rightData = tableRight.getData();
    const rightKeys = new Set(rightData.map(d => d.qtyco_idx));
    
    const newItems = items.filter(item => !rightKeys.has(item.qtyco_idx));
    
    newItems.forEach(item => {
      item.qty = item.qty || 100000; // 기본 수량
    });
    
    if (newItems.length > 0) {
      tableRight.addData(newItems);
      updateSelectedCount();
    }
  }

  function moveToLeft(items) {
    if (!items || items.length === 0) return;
    
    const removeIds = new Set(items.map(d => d.qtyco_idx));
    const rightData = tableRight.getData();
    const remaining = rightData.filter(d => !removeIds.has(d.qtyco_idx));
    
    tableRight.setData(remaining);
    updateSelectedCount();
  }

  // =============================
  // 버튼 이벤트
  // =============================
  // 선택 항목 우측으로
  document.getElementById("btnMoveRight").addEventListener("click", function() {
    const selected = tableLeft.getSelectedData();
    if (selected.length === 0) {
      alert("좌측에서 항목을 선택하세요.");
      return;
    }
    moveToRight(selected);
    tableLeft.deselectRow();
  });

  // 선택 항목 좌측으로 (제거)
  document.getElementById("btnMoveLeft").addEventListener("click", function() {
    const selected = tableRight.getSelectedData();
    if (selected.length === 0) {
      alert("우측에서 항목을 선택하세요.");
      return;
    }
    moveToLeft(selected);
    tableRight.deselectRow();
  });

  // 전체 우측으로
  document.getElementById("btnMoveAllRight").addEventListener("click", function() {
    const all = tableLeft.getData();
    moveToRight(all);
  });

  // 전체 좌측으로 (전체 제거)
  document.getElementById("btnMoveAllLeft").addEventListener("click", function() {
    if (!confirm("모든 선택 항목을 제거하시겠습니까?")) return;
    tableRight.setData([]);
    updateSelectedCount();
  });

  // =============================
  // 네스팅 실행
  // =============================
  document.getElementById("btnNesting").addEventListener("click", function() {
    const selectedSheets = tableRight.getData();
    
    if (selectedSheets.length === 0) {
      alert("우측에 판재를 추가해주세요.");
      return;
    }
    
    // 세션 스토리지에 데이터 저장
    const nestingData = {
      sheets: selectedSheets,
      items: NESTING_ITEMS,
      header: HEADER_INFO,
      params: PARAMS
    };
    
    sessionStorage.setItem("NESTING_DATA", JSON.stringify(nestingData));
    
    // 네스팅 결과 페이지로 이동
    const url = "nesting_result.asp?sjidx=" + PARAMS.sjidx + 
                "&cidx=" + PARAMS.cidx + 
                "&sjmidx=" + PARAMS.sjmidx;
    window.location.href = url;
  });

  // =============================
  // 절곡수 인쇄
  // =============================
  document.getElementById("btnPrint").addEventListener("click", function() {
    // 세션 스토리지에 데이터 저장
    const printData = {
      items: NESTING_ITEMS,
      header: HEADER_INFO,
      params: PARAMS
    };
    
    sessionStorage.setItem("PRINT_DATA", JSON.stringify(printData));
    
    // 인쇄 페이지 새 창으로 열기
    const url = "nesting_print.asp?sjidx=" + PARAMS.sjidx;
    window.open(url, "nestingPrint", "width=900,height=700");
  });

  // F12 방지 (기본적인 수준)
  document.addEventListener("keydown", function(e) {
    // F12
    if (e.key === "F12") {
      e.preventDefault();
      return false;
    }
    // Ctrl+Shift+I
    if (e.ctrlKey && e.shiftKey && e.key === "I") {
      e.preventDefault();
      return false;
    }
    // Ctrl+U
    if (e.ctrlKey && e.key === "u") {
      e.preventDefault();
      return false;
    }
  });

  // 우클릭 방지
  document.addEventListener("contextmenu", function(e) {
    e.preventDefault();
    return false;
  });

})();
