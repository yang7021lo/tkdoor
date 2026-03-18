<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
' sjidx URL 파라미터 → 현장명/거래처명 미리 조회
Dim sjidxParam, orderCgaddr, orderCname, orderSjnum, orderSjdate
sjidxParam = Trim(Request("sjidx") & "")
orderCgaddr = ""
orderCname = ""
orderSjnum = ""
orderSjdate = ""

' pidx URL 파라미터 → 페인트정보 미리 조회
Dim pidxParam, paintName, paintCode, paintHex
pidxParam = Trim(Request("pidx") & "")
paintName = ""
paintCode = ""
paintHex = ""

call dbOpen()

If sjidxParam <> "" And IsNumeric(sjidxParam) Then
  Dim rsOrder
  Set rsOrder = Dbcon.Execute( _
    "SELECT ISNULL(s.cgaddr,'') AS cgaddr, ISNULL(c.cname,'') AS cname, " & _
    "ISNULL(s.sjnum,'') AS sjnum, ISNULL(CONVERT(VARCHAR(10),s.sjdate,121),'') AS sjdate " & _
    "FROM tng_sja s LEFT JOIN tk_customer c ON c.cidx = s.sjcidx " & _
    "WHERE s.sjidx = " & CLng(sjidxParam))
  If Not rsOrder.EOF Then
    orderCgaddr = rsOrder("cgaddr") & ""
    orderCname = rsOrder("cname") & ""
    orderSjnum = rsOrder("sjnum") & ""
    orderSjdate = rsOrder("sjdate") & ""
  End If
  rsOrder.Close
  Set rsOrder = Nothing
End If

If pidxParam <> "" And IsNumeric(pidxParam) Then
  Dim rsPaint
  Set rsPaint = Dbcon.Execute( _
    "SELECT ISNULL(pname,'') AS pname, ISNULL(pcode,'') AS pcode, ISNULL(p_hex_color,'') AS hex " & _
    "FROM tk_paint WHERE pidx = " & CLng(pidxParam))
  If Not rsPaint.EOF Then
    paintName = rsPaint("pname") & ""
    paintCode = rsPaint("pcode") & ""
    paintHex = rsPaint("hex") & ""
  End If
  rsPaint.Close
  Set rsPaint = Nothing
End If

call dbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>샘플지급 관리</title>
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
<style>
<!--#include virtual="/common_crud/css/crud.css"-->

/* 페인트 스워치 표시 */
.ps-swatch {
  display: inline-block; width: 16px; height: 12px;
  border: 1px solid #999; border-radius: 2px;
  vertical-align: middle; margin-right: 4px;
}
.ps-paint-cell {
  font-size: 11px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
/* 페인트 자동완성 드롭다운 */
.ps-autocomplete {
  position: absolute; z-index: 9999;
  background: #fff; border: 1px solid #ccc; border-top: none;
  max-height: 220px; overflow-y: auto;
  box-shadow: 0 4px 12px rgba(0,0,0,.15);
  font-size: 12px;
}
.ps-ac-item {
  padding: 4px 8px; cursor: pointer; display: flex; align-items: center; gap: 6px;
}
.ps-ac-item:hover, .ps-ac-item.ps-ac-sel {
  background: #e0e7ff;
}
.ps-ac-swatch {
  display: inline-block; width: 14px; height: 14px;
  border: 1px solid #aaa; border-radius: 2px; flex-shrink: 0;
}
</style>
</head>
<body>

<div class="crud-wrap">
  <div id="crud-table"></div>
  <div class="crud-loading">저장 중...</div>
</div>

<!-- ============================================================
     1. CRUD 설정
     ============================================================ -->
<script>
// URL 파라미터
var urlParams = new URLSearchParams(window.location.search);
var filterPidx = urlParams.get('pidx') || '';
var filterSjidx = urlParams.get('sjidx') || '';
console.log('[SAMPLE] URL 필터 — pidx:', filterPidx || '없음', ', sjidx:', filterSjidx || '없음');

// 서버에서 미리 조회한 수주 정보
var ORDER_INFO = {
  sjidx: '<%=sjidxParam%>',
  cgaddr: '<%=Replace(orderCgaddr, "'", "\'")%>',
  cname: '<%=Replace(orderCname, "'", "\'")%>',
  sjnum: '<%=Replace(orderSjnum, "'", "\'")%>',
  sjdate: '<%=Replace(orderSjdate, "'", "\'")%>'
};
if (ORDER_INFO.sjidx) console.log('[SAMPLE] 수주 정보:', ORDER_INFO);

// 서버에서 미리 조회한 페인트 정보
var PAINT_INFO = {
  pidx: '<%=pidxParam%>',
  pname: '<%=Replace(paintName, "'", "\'")%>',
  pcode: '<%=Replace(paintCode, "'", "\'")%>',
  hex: '<%=Replace(paintHex, "'", "\'")%>'
};
if (PAINT_INFO.pidx) console.log('[SAMPLE] 페인트 정보:', PAINT_INFO);

// ============================================================
// 페인트 자동완성 커스텀 에디터
// ============================================================
var paintAutoEditor = function(cell, onRendered, success, cancel, editorParams) {
  var currentVal = cell.getValue() || '';

  // 컨테이너
  var wrap = document.createElement('div');
  wrap.style.cssText = 'position:relative;width:100%;';

  // 입력창
  var input = document.createElement('input');
  input.type = 'text';
  input.style.cssText = 'width:100%;box-sizing:border-box;padding:3px 6px;font-size:12px;border:1px solid #4361ee;outline:none;';
  input.placeholder = '페인트 검색...';
  wrap.appendChild(input);

  // 드롭다운
  var dropdown = document.createElement('div');
  dropdown.className = 'ps-autocomplete';
  dropdown.style.display = 'none';
  wrap.appendChild(dropdown);

  var items = [];
  var selIdx = -1;
  var debounceTimer = null;

  function renderDropdown(data) {
    items = data;
    selIdx = -1;
    dropdown.innerHTML = '';
    if (!data.length) { dropdown.style.display = 'none'; return; }
    data.forEach(function(item, i) {
      var div = document.createElement('div');
      div.className = 'ps-ac-item';
      var sw = item.h ? '<span class="ps-ac-swatch" style="background:' + item.h + '"></span>' : '';
      div.innerHTML = sw + '<span>' + item.n + '</span>';
      div.onmousedown = function(e) {
        e.preventDefault();
        success(item.v);
      };
      dropdown.appendChild(div);
    });
    dropdown.style.display = 'block';
  }

  function doSearch(q) {
    fetch('paint_lookup.asp?q=' + encodeURIComponent(q))
      .then(function(r) { return r.json(); })
      .then(function(data) {
        console.log('[SAMPLE] 페인트 검색:', q, '→', data.length, '건');
        renderDropdown(data);
      })
      .catch(function(e) { console.error('[SAMPLE] 페인트 검색 오류:', e); });
  }

  input.oninput = function() {
    clearTimeout(debounceTimer);
    var q = input.value.trim();
    if (q.length < 1) { dropdown.style.display = 'none'; return; }
    debounceTimer = setTimeout(function() { doSearch(q); }, 300);
  };

  input.onkeydown = function(e) {
    var els = dropdown.querySelectorAll('.ps-ac-item');
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      selIdx = Math.min(selIdx + 1, els.length - 1);
      els.forEach(function(el, i) { el.classList.toggle('ps-ac-sel', i === selIdx); });
      if (els[selIdx]) els[selIdx].scrollIntoView({block:'nearest'});
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      selIdx = Math.max(selIdx - 1, 0);
      els.forEach(function(el, i) { el.classList.toggle('ps-ac-sel', i === selIdx); });
      if (els[selIdx]) els[selIdx].scrollIntoView({block:'nearest'});
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (selIdx >= 0 && items[selIdx]) {
        success(items[selIdx].v);
      }
    } else if (e.key === 'Escape') {
      cancel();
    }
  };

  input.onblur = function() {
    setTimeout(function() { cancel(); }, 150);
  };

  onRendered(function() {
    input.focus();
    // 열릴 때 초기 목록 표시 (빈 검색)
    doSearch('');
  });

  return wrap;
};

window.CRUD_CONFIG = {
  apiUrl: "api.asp",
  tableEl: "#crud-table",
  pk: "psidx",
  pageSize: 50,
  layout: "fitDataFill",

  columns: [
    // --- 순번 ---
    {title:"#", formatter:"rownum", width:35, hozAlign:"center", headerSort:false, editable:false},

    // --- ID ---
    {field:"psidx", title:"ID", width:50, hozAlign:"center", editable:false},

    // --- 페인트 (AJAX 자동완성 에디터) ---
    {field:"pidx", title:"페인트", minWidth:200,
      editor: paintAutoEditor,
      defaultValue: filterPidx || undefined,
      formatter: function(c) {
        var row = c.getRow().getData();
        var name = row.paint_name || '';
        var code = row.paint_code || '';
        var hex = row.paint_hex || '';
        if (!name && !code) return '<span style="color:#999">선택...</span>';
        var display = name;
        if (code && name.indexOf(code) !== 0) display = code + ' ' + name;
        else if (code && !name) display = code;
        var sw = hex ? '<span class="ps-swatch" style="background:' + hex + '"></span>' : '';
        return '<span class="ps-paint-cell">' + sw + display + '</span>';
      }
    },

    // --- 구분 ---
    {field:"sample_type", title:"구분", width:80, hozAlign:"center",
      editor:"list",
      editorParams:{values:{"1":"샘플","2":"시공","3":"A/S","4":"기타"}},
      formatter: function(c) {
        var m = {"1":"샘플","2":"시공","3":"A/S","4":"기타"};
        return m[c.getValue()] || '<span style="color:#ccc">-</span>';
      }
    },

    // --- 수주번호 (sjidx URL 파라미터 있으면 기본값 자동 설정) ---
    {field:"sjidx", title:"수주번호", minWidth:180, hozAlign:"center", editor:"number",
      defaultValue: filterSjidx || undefined,
      formatter: function(c) {
        var v = c.getValue();
        if (!v || v == "0") return '<span style="color:#ccc">-</span>';
        var row = c.getRow().getData();
        var sjnum = row.sj_sjnum || '';
        return sjnum || v;
      }
    },

    // --- 현장명 (읽기전용, sjidx → tng_sja.cgaddr) ---
    {field:"sj_cgaddr", title:"현장명", minWidth:120, editable:false,
      formatter: function(c) {
        var v = c.getValue();
        return v || '<span style="color:#ccc">-</span>';
      }
    },

    // --- 거래처명 (읽기전용, sjidx → tk_customer.cname) ---
    {field:"sj_cname", title:"거래처명", minWidth:120, editable:false,
      formatter: function(c) {
        var v = c.getValue();
        return v || '<span style="color:#ccc">-</span>';
      }
    },

    // --- 업체명 (수주 없을 때 수동 입력용) ---
    {field:"company_name", title:"업체명(직접)", minWidth:100, editor:"input",
      formatter: function(c) {
        var v = c.getValue();
        return v || '<span style="color:#ccc">-</span>';
      }
    },

    // --- 수령인 ---
    {field:"recipient", title:"수령인", minWidth:80, editor:"input"},

    // --- 수량 ---
    {field:"qty", title:"수량", width:55, hozAlign:"center", editor:"number",
      editorParams:{min:1},
      formatter: function(c) {
        var v = c.getValue();
        return (v && v !== "0") ? v + '개' : '1개';
      }
    },

    // --- 지급일 ---
    {field:"sample_date", title:"지급일", width:105, hozAlign:"center", editor:"input",
      formatter: function(c) {
        var v = c.getValue();
        return v || '';
      }
    },

    // --- 메모 ---
    {field:"memo", title:"메모", minWidth:150, editor:"input"},

    // --- 감사 정보 (읽기전용) ---
    {field:"psewdate", title:"수정일", width:100, editable:false},
    {field:"mename",   title:"수정자", width:70,  editable:false}
  ],

  pasteColumns: [
    "pidx","sjidx","company_name","recipient","qty","sample_date","memo"
  ]
};

// URL 필터 적용 (sjidx 또는 pidx)
(function() {
  var filters = {};
  if (filterSjidx) filters.sjidx = filterSjidx;
  if (filterPidx) filters.pidx = filterPidx;
  if (Object.keys(filters).length > 0) {
    window.CRUD_CONFIG._filters = filters;
    console.log('[SAMPLE] 필터 적용:', filters);
  }
})();
</script>

<!-- ============================================================
     2. CRUD 엔진 (공통 모듈)
     ============================================================ -->
<script>
<!--#include virtual="/common_crud/js/crud_core.js"-->
</script>

<!-- ============================================================
     3. 샘플지급 커스텀 확장
     ============================================================ -->
<script>
(function(){
"use strict";

var table = null;

document.addEventListener("DOMContentLoaded", function(){
  table = window.CrudEngine.getTable();
  addExtraToolbar();

  // URL 파라미터 있으면 데이터 로드 후 자동 행 추가
  if (filterSjidx || filterPidx) {
    table.on("dataProcessed", function autoInsert() {
      table.off("dataProcessed", autoInsert); // 1회만 실행
      console.log('[SAMPLE] 자동 행 추가 — sjidx:', filterSjidx, ', pidx:', filterPidx);
      window.CrudEngine.addRow();
      var rows = table.getRows();
      if (rows.length > 0) {
        var firstRow = rows[0];
        var updateData = {};
        if (ORDER_INFO.sjidx) {
          updateData.sj_sjnum = (ORDER_INFO.sjdate && ORDER_INFO.sjnum) ? ORDER_INFO.sjdate + '_' + ORDER_INFO.sjnum : '';
          updateData.sj_cgaddr = ORDER_INFO.cgaddr;
          updateData.sj_cname = ORDER_INFO.cname;
        }
        if (PAINT_INFO.pidx) {
          updateData.paint_name = PAINT_INFO.pname;
          updateData.paint_code = PAINT_INFO.pcode;
          updateData.paint_hex = PAINT_INFO.hex;
        }
        firstRow.update(updateData);
        console.log('[SAMPLE] 자동세팅:', updateData);
      }
    });
  }

  // sjidx 셀 수정 시 현장명/거래처명 실시간 조회
  table.on("cellEdited", function(cell) {
    if (cell.getField() !== "sjidx") return;
    var sjidx = cell.getValue();
    var row = cell.getRow();
    if (!sjidx || sjidx == "0") {
      row.update({sj_cgaddr: "", sj_cname: ""});
      return;
    }
    fetch("/inc/ajax_sj_info.asp?sjidx=" + encodeURIComponent(sjidx))
      .then(function(r) { return r.json(); })
      .then(function(res) {
        if (res.ok) {
          row.update({sj_cgaddr: res.cgaddr || "", sj_cname: res.cname || ""});
        }
      })
      .catch(function(e) { console.error("[SAMPLE] 수주정보 조회 오류:", e); });
  });

  console.log('[SAMPLE] 초기화 완료');
});

// ============================================================
// 추가 툴바
// ============================================================
function addExtraToolbar() {
  var toolbar = document.querySelector(".crud-toolbar-left");
  if (!toolbar) return;

  // 구분 필터 드롭다운
  var typeSelect = document.createElement("select");
  typeSelect.style.cssText = "padding:4px 8px;font-size:12px;border:1px solid #cbd5e1;border-radius:4px;margin-right:6px;font-weight:600;cursor:pointer;";
  typeSelect.innerHTML = '<option value="">전체 구분</option><option value="1">샘플</option><option value="2">시공</option><option value="3">A/S</option><option value="4">기타</option>';
  typeSelect.onchange = function() {
    if (!window.CRUD_CONFIG._filters) window.CRUD_CONFIG._filters = {};
    window.CRUD_CONFIG._filters.sample_type = this.value;
    window.CrudEngine.getTable().setData();
  };
  toolbar.appendChild(typeSelect);

  // 페인트색상 관리 링크
  var linkBtn = document.createElement("button");
  linkBtn.className = "crud-btn";
  linkBtn.style.cssText = "background:#7c3aed;color:#fff;border-color:#7c3aed;";
  linkBtn.textContent = "페인트 관리";
  linkBtn.title = "페인트 색상 관리 페이지로 이동";
  linkBtn.onclick = function() {
    window.open('/paint_color/index.asp', '_blank');
  };
  toolbar.appendChild(linkBtn);

  // 수주 정보 표시
  if (filterSjidx && ORDER_INFO.sjidx) {
    var info = document.createElement("span");
    info.style.cssText = "font-size:12px;color:#1d4ed8;font-weight:600;margin-left:8px;background:#dbeafe;padding:5px 12px;border-radius:12px;";
    var sjText = '';
    if (ORDER_INFO.sjdate && ORDER_INFO.sjnum) {
      sjText = ORDER_INFO.sjdate + '_' + ORDER_INFO.sjnum;
    } else {
      sjText = '수주 #' + filterSjidx;
    }
    if (ORDER_INFO.cgaddr) sjText += ' | ' + ORDER_INFO.cgaddr;
    if (ORDER_INFO.cname) sjText += ' | ' + ORDER_INFO.cname;
    info.innerHTML = sjText + ' <a href="index.asp" style="color:#999;font-size:11px;margin-left:6px">[전체보기]</a>';
    toolbar.appendChild(info);
  }

  // 페인트 정보 표시
  if (filterPidx && PAINT_INFO.pidx) {
    var info2 = document.createElement("span");
    info2.style.cssText = "font-size:12px;color:#4361ee;font-weight:600;margin-left:8px;background:#eef2ff;padding:5px 12px;border-radius:12px;";
    var pName = PAINT_INFO.pname || '';
    var pCode = PAINT_INFO.pcode || '';
    var pText = pName;
    if (pCode && pName.indexOf(pCode) !== 0) pText = pCode + ' ' + pName;
    else if (pCode && !pName) pText = pCode;
    if (PAINT_INFO.hex) pText = '<span style="display:inline-block;width:12px;height:12px;background:' + PAINT_INFO.hex + ';border:1px solid #999;border-radius:2px;vertical-align:middle;margin-right:4px"></span>' + pText;
    info2.innerHTML = pText + ' <a href="index.asp" style="color:#999;font-size:11px;margin-left:6px">[해제]</a>';
    toolbar.appendChild(info2);
  }
}

})();
</script>

</body>
</html>
