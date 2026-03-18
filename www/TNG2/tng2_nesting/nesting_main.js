/* nesting_main.js */
(function(){
  'use strict';

  // 좌측 테이블
  const tableLeft = new Tabulator("#tableLeft", {
    data: ALL_PLATES,
    layout: "fitColumns",
    height: "100%",
    selectable: true,
    columns: [
      {formatter:"rowSelection", titleFormatter:"rowSelection", hozAlign:"center", headerSort:false, width:40},
      {title:"코드", field:"qtyco_idx", width:50, hozAlign:"center"},
      {title:"이름", field:"qtyname", widthGrow:2},
      {title:"규격", field:"spec", width:100},
      {title:"두께", field:"thickness", width:50, hozAlign:"center"}
    ],
    rowDblClick: function(e, row) {
      moveToRight([row.getData()]);
    }
  });

  // 필터
  document.getElementById("filterLeft").addEventListener("input", function(e) {
    const val = e.target.value.trim().toLowerCase();
    if (!val) { tableLeft.clearFilter(); return; }
    tableLeft.setFilter(function(data) {
      return (data.qtyname||"").toLowerCase().includes(val) ||
             (data.spec||"").toLowerCase().includes(val) ||
             String(data.qtyco_idx).includes(val);
    });
  });

  // 우측 테이블
  const tableRight = new Tabulator("#tableRight", {
    data: SELECTED_PLATES,
    layout: "fitColumns",
    height: "100%",
    selectable: true,
    columns: [
      {formatter:"rowSelection", titleFormatter:"rowSelection", hozAlign:"center", headerSort:false, width:40},
      {title:"코드", field:"qtyco_idx", width:50, hozAlign:"center"},
      {title:"이름", field:"qtyname", widthGrow:2},
      {title:"규격", field:"spec", width:100},
      {title:"두께", field:"thickness", width:50, hozAlign:"center"},
      {title:"수량", field:"qty", width:80, hozAlign:"right", editor:"number", 
        formatter:function(cell){return Number(cell.getValue()).toLocaleString();}}
    ],
    rowDblClick: function(e, row) {
      moveToLeft([row.getData()]);
    }
  });

  function updateCount() {
    document.getElementById("selectedCount").textContent = tableRight.getData().length + "개";
  }
  updateCount();

  function moveToRight(items) {
    if (!items || !items.length) return;
    const rightData = tableRight.getData();
    const keys = new Set(rightData.map(d => d.qtyco_idx));
    const newItems = items.filter(item => !keys.has(item.qtyco_idx));
    newItems.forEach(item => { item.qty = item.qty || 100000; });
    if (newItems.length) {
      tableRight.addData(newItems);
      updateCount();
    }
  }

  function moveToLeft(items) {
    if (!items || !items.length) return;
    const removeIds = new Set(items.map(d => d.qtyco_idx));
    tableRight.setData(tableRight.getData().filter(d => !removeIds.has(d.qtyco_idx)));
    updateCount();
  }

  document.getElementById("btnMoveRight").onclick = function() {
    const sel = tableLeft.getSelectedData();
    if (!sel.length) { alert("좌측에서 선택하세요."); return; }
    moveToRight(sel);
    tableLeft.deselectRow();
  };

  document.getElementById("btnMoveLeft").onclick = function() {
    const sel = tableRight.getSelectedData();
    if (!sel.length) { alert("우측에서 선택하세요."); return; }
    moveToLeft(sel);
    tableRight.deselectRow();
  };

  // 네스팅 실행
  document.getElementById("btnNesting").onclick = function() {
    const plates = tableRight.getData();
    if (!plates.length) { alert("판재를 선택하세요."); return; }
    
    // 세션 스토리지에 저장
    const data = {
      plates: plates,
      items: PART_ITEMS,
      header: HEADER,
      params: PARAMS
    };
    sessionStorage.setItem("NESTING_DATA", JSON.stringify(data));
    
    // 결과 페이지로 이동
    location.href = "nesting_result.asp?sjidx=" + PARAMS.sjidx + "&cidx=" + PARAMS.cidx + "&sjmidx=" + PARAMS.sjmidx;
  };

  // F12 방지
  document.addEventListener("keydown", function(e) {
    if (e.key === "F12" || (e.ctrlKey && e.shiftKey && e.key === "I") || (e.ctrlKey && e.key === "u")) {
      e.preventDefault(); return false;
    }
  });
  document.addEventListener("contextmenu", function(e) { e.preventDefault(); });
})();
