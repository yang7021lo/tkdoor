<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

' 제조사 목록 조회 (tk_paint_brand) → JS 변수로 전달
Dim rsBrand, brandValues, brandMap
brandValues = ""
brandMap = ""
Set rsBrand = Dbcon.Execute("SELECT pbidx, pname_brand FROM tk_paint_brand WHERE pbidx > 0 ORDER BY pbidx")
Do While Not rsBrand.EOF
  If brandValues <> "" Then brandValues = brandValues & ","
  If brandMap <> "" Then brandMap = brandMap & ","
  brandValues = brandValues & """" & rsBrand(0) & """:""" & rsBrand(1) & """"
  brandMap = brandMap & """" & rsBrand(0) & """:""" & rsBrand(1) & """"
  rsBrand.MoveNext
Loop
rsBrand.Close
Set rsBrand = Nothing

call dbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>페인트 색상 관리 (tk_paint)</title>
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
<style>
<!--#include virtual="/common_crud/css/crud.css"-->

/* ============================================================
   페인트 색상 관리 - 커스텀 스타일
   ============================================================ */

/* --- 이미지 셀 --- */
.paint-img-cell { cursor: pointer; }
.paint-img-cell img {
  width: 50px; height: 35px; object-fit: cover;
  border: 1px solid #ccc; border-radius: 2px;
}
.paint-img-empty {
  color: #999; font-size: 10px; cursor: pointer;
  text-decoration: underline;
}

/* --- 대표색 미리보기 --- */
.paint-color-swatch {
  display: inline-block; width: 20px; height: 14px;
  border: 1px solid #999; border-radius: 2px;
  vertical-align: middle; margin-right: 4px;
}
.paint-hex-text {
  font-family: monospace; font-size: 11px;
}

/* --- 추출 버튼 --- */
.extract-btn {
  font-size: 10px; padding: 1px 8px; cursor: pointer;
  background: #4361ee; color: #fff; border: none; border-radius: 2px;
}
.extract-btn:hover { background: #3a56d4; }

/* --- 대표색 일괄 추출 버튼 --- */
.crud-btn-extract {
  background: #7c3aed; color: #fff; border-color: #7c3aed; font-weight: 600;
}
.crud-btn-extract:hover { background: #6d28d9; }

/* --- 일괄 추출 진행 표시 --- */
.batch-progress {
  font-size: 12px; color: #4361ee; font-weight: 600;
  margin-left: 10px;
}

/* --- 이미지 붙여넣기 모달 --- */
.paste-overlay {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.5); z-index: 10000;
  display: flex; justify-content: center; align-items: center;
  animation: crudToastIn 0.2s ease;
}
.paste-box {
  background: #fff; border-radius: 10px; padding: 24px 30px;
  max-width: 500px; width: 90%; text-align: center;
  box-shadow: 0 8px 30px rgba(0,0,0,0.2);
}
.paste-title {
  font-size: 16px; font-weight: 700; margin-bottom: 8px;
  color: #1e293b;
}
.paste-desc {
  font-size: 13px; color: #666; margin-bottom: 16px;
}
.paste-area {
  border: 2px dashed #4361ee; border-radius: 8px;
  padding: 30px 20px; margin-bottom: 12px;
  background: #f8fafc; color: #4361ee; font-weight: 600;
  font-size: 14px; cursor: text;
  min-height: 80px;
  outline: none;
}
.paste-area:focus {
  border-color: #7c3aed; background: #faf5ff;
}
.paste-preview {
  max-width: 300px; max-height: 200px;
  display: none; margin: 12px auto;
  border: 2px solid #4361ee; border-radius: 4px;
}
.paste-status {
  font-size: 13px; margin-top: 8px; min-height: 20px;
}
.paste-close {
  margin-top: 12px; padding: 6px 20px;
  border: 1px solid #ccc; border-radius: 4px;
  cursor: pointer; background: #f8f9fa; font-size: 13px;
}
.paste-close:hover { background: #e9ecef; }

/* --- 이미지 미리보기 팝업 --- */
.imgview-overlay {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.7); z-index: 10000;
  display: flex; justify-content: center; align-items: center;
  animation: crudToastIn 0.2s ease;
  cursor: pointer;
}
.imgview-box {
  background: #fff; border-radius: 10px; padding: 16px;
  max-width: 90vw; max-height: 90vh;
  box-shadow: 0 8px 30px rgba(0,0,0,0.3);
  text-align: center; cursor: default;
  display: flex; flex-direction: column; align-items: center;
}
.imgview-box img {
  max-width: 80vw; max-height: 70vh;
  object-fit: contain; border-radius: 4px;
  border: 1px solid #ddd;
}
.imgview-info {
  margin-top: 10px; font-size: 13px; color: #555;
  display: flex; gap: 12px; align-items: center;
}
.imgview-name { font-weight: 600; color: #1e293b; }
.imgview-btn {
  padding: 5px 14px; font-size: 12px; border-radius: 4px;
  border: 1px solid #cbd5e1; cursor: pointer; background: #f8fafc;
  font-weight: 600; transition: all 0.15s;
}
.imgview-btn:hover { background: #e2e8f0; }
.imgview-btn-upload { background: #3b82f6; color: #fff; border-color: #3b82f6; }
.imgview-btn-upload:hover { background: #2563eb; }

/* --- 색상카드 인라인 팝업 --- */
.colorcard-overlay {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.5); z-index: 10000;
  display: flex; justify-content: center; align-items: center;
  animation: crudToastIn 0.2s ease;
  cursor: pointer;
}
.colorcard-box {
  background: #fff; border-radius: 10px; padding: 16px;
  box-shadow: 0 8px 30px rgba(0,0,0,0.3);
  text-align: center; cursor: default;
  display: flex; flex-direction: column; align-items: center; gap: 10px;
}
.colorcard-box img {
  cursor: pointer; border: 1px solid #ddd;
}
.colorcard-status {
  font-size: 12px; font-weight: 600; min-height: 18px; color: #059669;
}
.colorcard-hint {
  font-size: 11px; color: #999;
}
.colorcard-btns {
  display: flex; gap: 8px; align-items: center;
}
.colorcard-btn-copy {
  padding: 6px 16px; font-size: 12px; font-weight: 700;
  background: #3b82f6; color: #fff; border: none; border-radius: 5px;
  cursor: pointer;
}
.colorcard-btn-copy:hover { background: #2563eb; }
.colorcard-btn-close {
  padding: 6px 16px; font-size: 12px;
  background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 5px;
  cursor: pointer;
}
.colorcard-btn-close:hover { background: #e2e8f0; }

/* ============================================================
   제조사 관리 팝업
   ============================================================ */
.brand-overlay {
  position: fixed; top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.45); z-index: 10000;
  display: flex; justify-content: center; align-items: center;
  animation: crudToastIn 0.2s ease;
}
.brand-popup {
  background: #fff; border-radius: 10px; padding: 0;
  width: 460px; max-height: 80vh;
  box-shadow: 0 8px 30px rgba(0,0,0,0.25);
  display: flex; flex-direction: column;
  overflow: hidden;
}
.brand-popup-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 20px; background: #1e293b; color: #fff;
  border-radius: 10px 10px 0 0;
}
.brand-popup-header h5 { margin: 0; font-size: 15px; font-weight: 700; }
.brand-popup-close {
  background: none; border: none; color: #94a3b8; font-size: 20px;
  cursor: pointer; line-height: 1; padding: 0 4px;
}
.brand-popup-close:hover { color: #fff; }
.brand-popup-body {
  padding: 16px 20px; overflow-y: auto; flex: 1;
}
.brand-popup-toolbar {
  display: flex; gap: 6px; margin-bottom: 10px; align-items: center;
}
.brand-popup-toolbar .brand-btn {
  padding: 4px 12px; font-size: 12px; border-radius: 4px;
  border: 1px solid #cbd5e1; cursor: pointer; background: #f8fafc;
  font-weight: 600; transition: all 0.15s;
}
.brand-popup-toolbar .brand-btn:hover { background: #e2e8f0; }
.brand-popup-toolbar .brand-btn-add { background: #3b82f6; color: #fff; border-color: #3b82f6; }
.brand-popup-toolbar .brand-btn-add:hover { background: #2563eb; }
.brand-popup-toolbar .brand-btn-save { background: #059669; color: #fff; border-color: #059669; }
.brand-popup-toolbar .brand-btn-save:hover { background: #047857; }
.brand-popup-toolbar .brand-btn-del { background: #ef4444; color: #fff; border-color: #ef4444; }
.brand-popup-toolbar .brand-btn-del:hover { background: #dc2626; }
.brand-popup-status {
  font-size: 11px; color: #64748b; margin-left: auto;
}
#brandTable { font-size: 12px; }
#brandTable .tabulator-row.brand-row-new { background: #eff6ff !important; }
#brandTable .tabulator-row.brand-row-changed { background: #fefce8 !important; }
#brandTable .tabulator-row.brand-row-deleted td { text-decoration: line-through; color: #999 !important; }
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
window.CRUD_CONFIG = {
  apiUrl: "api.asp",
  tableEl: "#crud-table",
  pk: "pidx",
  pageSize: 50,
  layout: "fitDataFill",

  columns: [
    // --- 순번 ---
    {title:"#", formatter:"rownum", width:40, hozAlign:"center", headerSort:false, editable:false},

    // --- ID ---
    {field:"pidx", title:"ID", width:55, hozAlign:"center", editable:false},

    // --- 페인트 이미지 (클릭: 업로드 모달) ---
    {field:"p_image", title:"이미지", minWidth:70, hozAlign:"center", editable:false,
      formatter: function(c) {
        var v = c.getValue();
        var hasImg = v && v !== "" && v !== "0";
        var hex = c.getRow().getData().p_hex_color;
        if (!hasImg && hex && hex !== "" && hex !== "0") {
          // 이미지 없지만 hex 있으면 → 색상 스워치로 대체
          return '<div style="width:50px;height:35px;background:' + hex + ';border:1px solid #ccc;border-radius:2px;cursor:pointer" title="' + hex + ' (클릭:업로드)"></div>';
        }
        if (!hasImg) return '<span class="paint-img-empty">클릭:업로드</span>';
        return '<div class="paint-img-cell"><img src="/img/paint/' + v + '" title="클릭: 이미지 변경"></div>';
      }
    },

    // --- 페인트 기본 정보 ---
    {field:"pname",    title:"페인트명", minWidth:140, editor:"input"},
    {field:"pcode",    title:"코드",    minWidth:100, editor:"input"},

    // --- 제조사 (tk_paint_brand 테이블에서 동적 로드) ---
    {field:"pname_brand", title:"제조사", minWidth:90, hozAlign:"center",
      editor:"list",
      editorParams:{values:{<%=brandValues%>}},
      formatter: function(c) {
        var m = {<%=brandMap%>};
        return m[c.getValue()] || c.getValue();
      }
    },

    // --- 색상 타입 (1~4) ---
    {field:"paint_type", title:"색상타입", minWidth:75, hozAlign:"center",
      editor:"list",
      editorParams:{values:{"1":"기본","2":"원색","3":"브라운","4":"메탈릭"}},
      formatter: function(c) {
        var m = {"1":"기본","2":"원색","3":"브라운","4":"메탈릭"};
        return m[c.getValue()] || c.getValue();
      }
    },

    // --- 대표색 HEX (스워치 클릭→색상카드팝업, hex텍스트 클릭→에디터) ---
    {field:"p_hex_color", title:"대표색", minWidth:130, editor:"input", editable:false,
      formatter: function(c) {
        var v = c.getValue();
        if (!v) return '<span class="paint-hex-text" style="color:#999;cursor:pointer">미지정</span>';
        return '<span class="paint-color-swatch" style="background:' + v + ';cursor:pointer" title="색상카드 보기"></span>' +
               '<span class="paint-hex-text" style="cursor:pointer" title="클릭하여 수정">' + v + '</span>';
      }
    },

    // --- 대표색 추출 버튼 (이미지에서 자동 추출) ---
    {field:"_extract", title:"추출", width:60, headerSort:false, hozAlign:"center", editable:false,
      formatter: function(c) {
        var data = c.getRow().getData();
        if (!data.p_image) return '';
        if (data.p_hex_color && data.p_hex_color !== '') {
          return '<span style="display:inline-block;width:18px;height:14px;background:' + data.p_hex_color + ';border:1px solid #999;border-radius:2px;vertical-align:middle" title="' + data.p_hex_color + '"></span>' +
                 ' <button class="extract-btn" style="font-size:9px;padding:0 4px;background:#6b7280">재</button>';
        }
        return '<button class="extract-btn">추출</button>';
      }
    },

    // --- 도장횟수 (코트) ---
    {field:"coat", title:"도장횟수", minWidth:75, hozAlign:"center",
      editor:"list",
      editorParams:{values:{"1":"1코트","2":"2코트"}},
      formatter: function(c) {
        var v = c.getValue();
        if (!v || v === "0") return '';
        if (v === "2") return '<b style="color:#dc2626">2코트</b>';
        return v + "코트";
      }
    },

    // --- 부가 정보 ---
    {field:"pprice",    title:"단가",   minWidth:75, hozAlign:"right",  editor:"number"},
    {field:"p_percent", title:"할증%",  minWidth:55, hozAlign:"right",  editor:"number"},

    // --- 상태 ---
    {field:"pstatus", title:"상태", width:50, hozAlign:"center",
      editor:"list",
      editorParams:{values:{"0":"❌","1":"✅"}},
      formatter: function(c) { return c.getValue() == "1" ? "✅" : "❌"; }
    },

    // --- 감사 정보 (수정 불가) ---
    {field:"pewdate", title:"수정일", width:100, editable:false},
    {field:"mename",  title:"수정자", width:80,  editable:false}
  ],

  // 엑셀 붙여넣기 컬럼 순서
  pasteColumns: [
    "pname","pshorten","pcode","pname_brand","paint_type",
    "p_hex_color","coat","pprice","p_percent","pstatus"
  ],

  // 저장 전 pname 앞에 pcode 자동 합치기
  onBeforeSave: function(batch) {
    function mergePcode(row) {
      var code = (row.pcode || '').trim();
      var name = (row.pname || '').trim();
      if (code && code !== '0' && name && name.indexOf(code) !== 0) {
        row.pname = code + ' ' + name;
      } else if (code && !name) {
        row.pname = code;
      }
    }
    if (batch.insert) batch.insert.forEach(mergePcode);
    if (batch.update) batch.update.forEach(function(row) {
      if (row.pcode !== undefined || row.pname !== undefined) {
        mergePcode(row);
      }
    });
    return batch;
  }
};
</script>

<!-- ============================================================
     2. CRUD 엔진 (공통 모듈)
     ============================================================ -->
<script>
<!--#include virtual="/common_crud/js/crud_core.js"-->
</script>

<!-- ============================================================
     3. 페인트 색상 관리 커스텀 확장
        - 이미지 붙여넣기 업로드
        - Canvas API 대표색 추출
        - 일괄 추출
     ============================================================ -->
<script>
(function(){
"use strict";

// --- Tabulator 테이블 참조 (crud_core.js에서 생성됨) ---
var table = null;

document.addEventListener("DOMContentLoaded", function(){
  table = window.CrudEngine.getTable();
  addExtraToolbar();
  initCellClick();

  // ★ 데이터 로드 완료 후 자동 일괄 추출 (최초 1회)
  var autoExtractDone = false;
  table.on("dataProcessed", function(){
    if (autoExtractDone) return;
    autoExtractDone = true;
    setTimeout(function(){ autoExtract(); }, 500);
  });
});

// ============================================================
// (A) 추가 툴바 버튼 — 대표색 일괄 추출
// ============================================================
function addExtraToolbar() {
  var toolbar = document.querySelector(".crud-toolbar-left");
  if (!toolbar) return;

  // ★ 제조사 필터 드롭다운
  var brandSelect = document.createElement("select");
  brandSelect.className = "crud-brand-filter";
  brandSelect.style.cssText = "padding:4px 8px;font-size:12px;border:1px solid #cbd5e1;border-radius:4px;margin-right:4px;font-weight:600;cursor:pointer;";
  brandSelect.innerHTML = '<option value="">전체 제조사</option>';
  var bMap = {<%=brandMap%>};
  for (var bk in bMap) {
    if (bMap.hasOwnProperty(bk)) {
      brandSelect.innerHTML += '<option value="' + bk + '">' + bMap[bk] + '</option>';
    }
  }
  brandSelect.onchange = function() {
    if (!window.CRUD_CONFIG._filters) window.CRUD_CONFIG._filters = {};
    window.CRUD_CONFIG._filters.pname_brand = this.value;
    console.log('[PAINT] 제조사 필터:', this.value, bMap[this.value] || '전체');
    window.CrudEngine.getTable().setData();
  };
  toolbar.appendChild(brandSelect);

  // ★ 색상 그룹 필터 드롭다운
  var colorOpts = [
    {v:"",          t:"전체 색상",            c:""},
    {v:"black",     t:"검은색",      c:"#222222"},
    {v:"darkgray",  t:"진회색",      c:"#666666"},
    {v:"silver",    t:"실버",        c:"#AAAAAA"},
    {v:"lightgray", t:"밝은회색",    c:"#D0D0D0"},
    {v:"ivory",     t:"아이보리",    c:"#F5F0DC"},
    {v:"brown",     t:"갈색(브라운)", c:"#8B5513"},
    {v:"red",       t:"빨강",        c:"#DD2222"},
    {v:"orange",    t:"주황",        c:"#EE7711"},
    {v:"yellow",    t:"노랑",        c:"#CCBB00"},
    {v:"green",     t:"초록",        c:"#228B22"},
    {v:"blue",      t:"파랑",        c:"#3355FF"},
    {v:"navy",      t:"남색",        c:"#000066"},
    {v:"purple",    t:"보라",        c:"#8822CC"},
    {v:"nocolor",   t:"미지정",      c:""}
  ];
  var colorSelect = document.createElement("select");
  colorSelect.style.cssText = "padding:4px 8px;font-size:12px;border:2px solid #cbd5e1;border-radius:4px;margin-right:6px;font-weight:700;cursor:pointer;min-width:90px;";
  for (var ci = 0; ci < colorOpts.length; ci++) {
    var opt = document.createElement("option");
    opt.value = colorOpts[ci].v;
    opt.textContent = colorOpts[ci].t;
    colorSelect.appendChild(opt);
  }
  colorSelect.onchange = function() {
    var idx = this.selectedIndex;
    var c = colorOpts[idx] ? colorOpts[idx].c : '';
    if (c) {
      this.style.backgroundColor = c;
      this.style.borderColor = c;
      var r = parseInt(c.substr(1,2),16), g = parseInt(c.substr(3,2),16), b = parseInt(c.substr(5,2),16);
      this.style.color = (r*299+g*587+b*114)/1000 > 128 ? '#000' : '#fff';
    } else {
      this.style.backgroundColor = '';
      this.style.borderColor = '#cbd5e1';
      this.style.color = '';
    }
    if (!window.CRUD_CONFIG._filters) window.CRUD_CONFIG._filters = {};
    window.CRUD_CONFIG._filters.color_group = this.value;
    console.log('[PAINT] 색상 필터:', this.value, colorOpts[idx].t);
    window.CrudEngine.getTable().setData();
  };
  toolbar.appendChild(colorSelect);

  // 일괄 추출 버튼
  var btn = document.createElement("button");
  btn.className = "crud-btn crud-btn-extract";
  btn.title = "이미지가 있고 대표색이 없는 항목을 일괄 추출합니다";
  btn.textContent = "대표색 일괄추출";
  btn.onclick = batchExtract;
  toolbar.appendChild(btn);

  // 진행률 표시
  var prog = document.createElement("span");
  prog.id = "batchProg";
  prog.className = "batch-progress";
  toolbar.appendChild(prog);
}

// ============================================================
// (B) 셀 클릭 이벤트 핸들러
// ============================================================
function initCellClick() {
  table.on("cellClick", function(e, cell){
    var field = cell.getField();

    // 이미지 셀 클릭
    if (field === "p_image") {
      var data = cell.getRow().getData();
      if (data.pidx && data.pidx !== "" && data.pidx !== "0") {
        if (data.p_image) {
          // 이미지 있으면 → 큰 이미지 미리보기 팝업
          openImagePopup(data.pidx, data.p_image, data.pname || "");
        } else {
          // 이미지 없으면 → 바로 업로드 모달
          openPasteModal(data.pidx, "p_image");
        }
      }
    }

    // 대표색 스워치 클릭 → 인라인 색상카드 팝업 (복사 가능)
    if (field === "p_hex_color" && e.target.closest(".paint-color-swatch")) {
      var rowData = cell.getRow().getData();
      if (rowData.pidx && rowData.p_hex_color) {
        openColorCard(rowData);
      }
    }

    // 대표색 hex텍스트 클릭 → 수동으로 에디터 열기
    if (field === "p_hex_color" && e.target.closest(".paint-hex-text")) {
      cell.edit();
    }

    // 추출 버튼 클릭 → 해당 행 대표색 추출
    if (field === "_extract" && e.target.closest(".extract-btn")) {
      extractForRow(cell.getRow());
    }
  });
}

// ============================================================
// (B-2) 색상카드 인라인 팝업 (Canvas → 이미지 복사 가능)
// ============================================================
function openColorCard(rowData) {
  var hex = rowData.p_hex_color || "#CCCCCC";
  var brandMap = {<%=brandMap%>};
  var brandName = brandMap[rowData.pname_brand] || "";
  var pcode = rowData.pcode || "";
  var pname = rowData.pname || "";

  console.log('[PAINT] 색상카드 열기 pidx=' + rowData.pidx + ' hex=' + hex);

  // 기존 팝업 제거
  var old = document.querySelector(".colorcard-overlay");
  if (old) old.remove();

  // Canvas로 색상카드 이미지 생성
  var W = 480, H = 160, SW = 300;
  var canvas = document.createElement("canvas");
  canvas.width = W; canvas.height = H;
  var ctx = canvas.getContext("2d");

  // 배경
  ctx.fillStyle = "#fff";
  ctx.fillRect(0, 0, W, H);

  // 왼쪽 대표색
  ctx.fillStyle = hex;
  ctx.fillRect(0, 0, SW, H);

  // 구분선
  ctx.strokeStyle = "#ddd";
  ctx.lineWidth = 1;
  ctx.beginPath(); ctx.moveTo(SW, 0); ctx.lineTo(SW, H); ctx.stroke();

  // 오른쪽 텍스트
  var tx = SW + 16, ty = 45;
  if (brandName) {
    ctx.fillStyle = "#1a237e";
    ctx.font = "bold 14px 'Malgun Gothic', sans-serif";
    ctx.fillText(brandName, tx, ty); ty += 22;
  }
  if (pcode) {
    ctx.fillStyle = "#333";
    ctx.font = "bold 13px 'Malgun Gothic', sans-serif";
    ctx.fillText(pcode, tx, ty); ty += 20;
  }
  if (pname) {
    ctx.fillStyle = "#555";
    ctx.font = "13px 'Malgun Gothic', sans-serif";
    ctx.fillText(pname, tx, ty); ty += 22;
  }
  ctx.fillStyle = "#999";
  ctx.font = "11px Consolas, monospace";
  ctx.fillText(hex, tx, ty);

  // 테두리
  ctx.strokeStyle = "#ccc";
  ctx.strokeRect(0.5, 0.5, W - 1, H - 1);

  // 팝업 생성
  var overlay = document.createElement("div");
  overlay.className = "colorcard-overlay";
  overlay.innerHTML =
    '<div class="colorcard-box">' +
      '<img id="ccImg" title="클릭하면 이미지 복사">' +
      '<div class="colorcard-btns">' +
        '<button class="colorcard-btn-copy" id="ccCopy">이미지 복사</button>' +
        '<button class="colorcard-btn-close" id="ccClose">닫기</button>' +
      '</div>' +
      '<span class="colorcard-status" id="ccStatus"></span>' +
      '<span class="colorcard-hint">복사 후 카톡/메일에 Ctrl+V 붙여넣기</span>' +
    '</div>';

  document.body.appendChild(overlay);

  // Canvas → img
  var imgEl = document.getElementById("ccImg");
  imgEl.src = canvas.toDataURL("image/png");

  // 복사 함수
  function doCopy() {
    var st = document.getElementById("ccStatus");
    canvas.toBlob(function(blob) {
      if (!blob) { st.textContent = "실패"; st.style.color = "#ef4444"; return; }
      try {
        var item = new ClipboardItem({"image/png": blob});
        navigator.clipboard.write([item]).then(function() {
          console.log("[COLOR_CARD] 복사 성공");
          st.textContent = "복사 완료!";
          st.style.color = "#059669";
          setTimeout(function(){ st.textContent = ""; }, 2000);
        }).catch(function(err) {
          console.error("[COLOR_CARD] Clipboard API 실패:", err);
          st.textContent = "우클릭 → 이미지 복사 사용";
          st.style.color = "#f59e0b";
        });
      } catch(e) {
        console.error("[COLOR_CARD] ClipboardItem 미지원:", e);
        st.textContent = "우클릭 → 이미지 복사 사용";
        st.style.color = "#f59e0b";
      }
    }, "image/png");
  }

  // 이벤트
  document.getElementById("ccCopy").onclick = doCopy;
  imgEl.onclick = doCopy;
  overlay.addEventListener("click", function(e) { if (e.target === overlay) overlay.remove(); });
  document.getElementById("ccClose").onclick = function(){ overlay.remove(); };
  var escH = function(e) { if (e.key === "Escape") { overlay.remove(); document.removeEventListener("keydown", escH); } };
  document.addEventListener("keydown", escH);
}

// ============================================================
// (C-0) 이미지 미리보기 팝업
// ============================================================
function openImagePopup(pidx, fileName, paintName) {
  console.log('[PAINT] 이미지 팝업 pidx=' + pidx + ' file=' + fileName);

  // 기존 팝업 제거
  var old = document.querySelector(".imgview-overlay");
  if (old) old.remove();

  var imgSrc = "/img/paint/" + fileName;
  var overlay = document.createElement("div");
  overlay.className = "imgview-overlay";
  overlay.innerHTML =
    '<div class="imgview-box">' +
      '<img src="' + imgSrc + '" alt="' + (paintName || fileName) + '">' +
      '<div class="imgview-info">' +
        '<span class="imgview-name">' + (paintName || "") + '</span>' +
        '<span style="color:#999;font-size:11px">' + fileName + '</span>' +
        '<button class="imgview-btn imgview-btn-upload" id="imgviewUpload">이미지 변경</button>' +
        '<button class="imgview-btn" id="imgviewClose">닫기</button>' +
      '</div>' +
    '</div>';

  document.body.appendChild(overlay);

  // 배경 클릭으로 닫기
  overlay.addEventListener("click", function(e) {
    if (e.target === overlay) overlay.remove();
  });

  // 닫기 버튼
  document.getElementById("imgviewClose").onclick = function(){ overlay.remove(); };

  // 이미지 변경 버튼 → 업로드 모달로 전환
  document.getElementById("imgviewUpload").onclick = function(){
    overlay.remove();
    openPasteModal(pidx, "p_image");
  };

  // ESC 닫기
  var escHandler = function(e){ if (e.key === "Escape") { overlay.remove(); document.removeEventListener("keydown", escHandler); } };
  document.addEventListener("keydown", escHandler);
}

// ============================================================
// (C-1) 이미지 붙여넣기 업로드 모달
// ============================================================
var _uploadPidx = null;

function openPasteModal(pidx, type) {
  _uploadPidx = pidx;

  // 기존 모달 제거
  var old = document.querySelector(".paste-overlay");
  if (old) old.remove();

  // 모달 생성
  var overlay = document.createElement("div");
  overlay.className = "paste-overlay";
  overlay.innerHTML =
    '<div class="paste-box">' +
      '<div class="paste-title">이미지 붙여넣기</div>' +
      '<div class="paste-desc">아래 영역을 클릭한 후 Ctrl+V로 이미지를 붙여넣으세요</div>' +
      '<div class="paste-area" contenteditable="true" id="pasteArea">여기에 Ctrl+V</div>' +
      '<img class="paste-preview" id="pastePreview">' +
      '<div class="paste-status" id="pasteStatus"></div>' +
      '<button class="paste-close" id="pasteClose">닫기</button>' +
    '</div>';

  document.body.appendChild(overlay);

  // 오버레이 클릭으로 닫기
  overlay.addEventListener("click", function(e) {
    if (e.target === overlay) overlay.remove();
  });

  // 닫기 버튼
  document.getElementById("pasteClose").onclick = function(){ overlay.remove(); };

  // 붙여넣기 이벤트 (paste-area에서 캡처)
  var area = document.getElementById("pasteArea");
  area.focus();
  area.addEventListener("paste", function(e){
    e.preventDefault();
    handleImagePaste(e, pidx, type);
  });
}

function handleImagePaste(e, pidx, type) {
  var items = (e.clipboardData || window.clipboardData).items;

  for (var i = 0; i < items.length; i++) {
    if (items[i].type.indexOf("image") === -1) continue;

    var file = items[i].getAsFile();
    var status = document.getElementById("pasteStatus");
    var preview = document.getElementById("pastePreview");

    // 미리보기 표시
    var reader = new FileReader();
    reader.onload = function(ev) {
      if (preview) {
        preview.src = ev.target.result;
        preview.style.display = "block";
      }
    };
    reader.readAsDataURL(file);

    // 업로드
    if (status) status.textContent = "업로드 중...";
    status.style.color = "#4361ee";

    var formData = new FormData();
    formData.append("pasteImage", file);

    fetch("upload.asp?pidx=" + pidx + "&type=" + (type || "p_image"), {
      method: "POST",
      body: formData
    })
    .then(function(r){ return r.json(); })
    .then(function(res){
      if (res.result === "ok") {
        if (status) {
          status.textContent = "업로드 완료: " + res.fileName;
          status.style.color = "#059669";
        }
        // 1초 후 모달 닫고 테이블 새로고침
        setTimeout(function(){
          var ov = document.querySelector(".paste-overlay");
          if (ov) ov.remove();
          window.CrudEngine.reload();
        }, 1000);
      } else {
        if (status) {
          status.textContent = "실패: " + (res.msg || "알 수 없는 오류");
          status.style.color = "#dc2626";
        }
      }
    })
    .catch(function(err){
      if (status) {
        status.textContent = "네트워크 오류: " + err;
        status.style.color = "#dc2626";
      }
    });

    break; // 첫 번째 이미지만 처리
  }
}

// ============================================================
// (D) Canvas API 대표색 추출
//     - 이미지 중앙 40% 영역 샘플링
//     - 5단위 RGB 양자화 → 최빈색 선택
//     - 너무 어둡거나(< 30) 밝은(> 240) 픽셀 제외
// ============================================================
function extractDominantColor(imgUrl) {
  return new Promise(function(resolve, reject) {
    var img = new Image();
    img.onload = function() {
      try {
        var canvas = document.createElement("canvas");
        var ctx = canvas.getContext("2d");
        canvas.width = img.naturalWidth;
        canvas.height = img.naturalHeight;
        ctx.drawImage(img, 0, 0);

        // 중앙 40% 영역만 샘플링 (가장자리 30% 제외)
        var margin = 0.3;
        var sx = Math.floor(img.naturalWidth * margin);
        var sy = Math.floor(img.naturalHeight * margin);
        var sw = Math.max(1, Math.floor(img.naturalWidth * (1 - 2 * margin)));
        var sh = Math.max(1, Math.floor(img.naturalHeight * (1 - 2 * margin)));

        var imageData = ctx.getImageData(sx, sy, sw, sh);
        var pixels = imageData.data;

        // 5단위 RGB 양자화 후 빈도 집계
        var colorCounts = {};
        var total = 0;

        for (var i = 0; i < pixels.length; i += 4) {
          var r = Math.round(pixels[i]     / 5) * 5;
          var g = Math.round(pixels[i + 1] / 5) * 5;
          var b = Math.round(pixels[i + 2] / 5) * 5;
          var a = pixels[i + 3];

          // 투명 픽셀 제외
          if (a < 128) continue;
          // 너무 어두운/밝은 픽셀 제외 (테두리/배경)
          var brightness = (r + g + b) / 3;
          if (brightness < 30 || brightness > 240) continue;

          var key = r + "," + g + "," + b;
          colorCounts[key] = (colorCounts[key] || 0) + 1;
          total++;
        }

        // 유효한 픽셀이 없으면 회색 반환
        if (total === 0) { resolve("#808080"); return; }

        // 최빈색 결정
        var maxCount = 0;
        var dominant = "128,128,128";
        for (var key in colorCounts) {
          if (colorCounts[key] > maxCount) {
            maxCount = colorCounts[key];
            dominant = key;
          }
        }

        // RGB → HEX 변환
        var parts = dominant.split(",");
        var hex = "#" +
          ("0" + parseInt(parts[0]).toString(16)).slice(-2) +
          ("0" + parseInt(parts[1]).toString(16)).slice(-2) +
          ("0" + parseInt(parts[2]).toString(16)).slice(-2);

        resolve(hex.toUpperCase());
      } catch (err) {
        reject(err.message || "Canvas 처리 오류");
      }
    };
    img.onerror = function() { reject("이미지 로드 실패"); };
    img.src = imgUrl;
  });
}

// ============================================================
// (E) 단일 행 대표색 추출
// ============================================================
function extractForRow(row) {
  var data = row.getData();
  if (!data.p_image) {
    toast("이미지가 없는 항목입니다.", "info");
    return;
  }

  // 추출 중 표시
  var cells = row.getCells();
  for (var i = 0; i < cells.length; i++) {
    if (cells[i].getField() === "_extract") {
      cells[i].getElement().innerHTML = '<span style="font-size:10px;color:#4361ee">...</span>';
      break;
    }
  }

  var imgUrl = "/img/paint/" + data.p_image;

  extractDominantColor(imgUrl)
    .then(function(hex) {
      // p_hex_color 셀 값 설정 (cellEdited 이벤트 발생 → dirty buffer 자동 업데이트)
      var cell = row.getCell("p_hex_color");
      if (cell) cell.setValue(hex);
      toast("대표색 추출: " + hex, "success");
    })
    .catch(function(err) {
      toast("추출 실패: " + err, "error");
      row.reformat(); // 추출 버튼 복원
    });
}

// ============================================================
// (F) 일괄 대표색 추출 (수동 - 버튼 클릭)
//     - 이미지가 있고 대표색이 없는 항목만 대상
//     - 순차 처리 (100ms 딜레이, 과부하 방지)
// ============================================================
function batchExtract() {
  var targets = getExtractTargets();
  if (targets.length === 0) {
    toast("추출할 항목이 없습니다.\n(이미지 있고 + 대표색 없는 항목만 대상)", "info");
    return;
  }
  if (!confirm(targets.length + "건의 대표색을 추출하시겠습니까?")) return;
  runExtractQueue(targets);
}

// ============================================================
// (G) 자동 일괄 추출 (페이지 로드 시 1회)
//     - confirm 없이 바로 실행
// ============================================================
function autoExtract() {
  var targets = getExtractTargets();
  if (targets.length === 0) return;
  toast(targets.length + "건 대표색 자동 추출 시작...", "info");
  runExtractQueue(targets);
}

// --- 추출 대상 행 수집 (이미지 있고 + 대표색 없는 항목) ---
function getExtractTargets() {
  var rows = table.getRows();
  var targets = [];
  for (var i = 0; i < rows.length; i++) {
    var d = rows[i].getData();
    if (d.p_image && (!d.p_hex_color || d.p_hex_color === "")) {
      targets.push(rows[i]);
    }
  }
  return targets;
}

// --- 순차 추출 실행 큐 ---
function runExtractQueue(targets) {
  var prog = document.getElementById("batchProg");
  var ok = 0, fail = 0;

  function next(idx) {
    if (idx >= targets.length) {
      if (prog) prog.textContent = "완료! " + ok + "건" + (fail > 0 ? " (실패 " + fail + ")" : "");
      toast("일괄 추출 완료: " + ok + "건 성공" + (fail > 0 ? ", " + fail + "건 실패" : ""), ok > 0 ? "success" : "error");
      return;
    }

    var row = targets[idx];
    var d = row.getData();
    if (prog) prog.textContent = (idx + 1) + "/" + targets.length + " 추출 중...";

    extractDominantColor("/img/paint/" + d.p_image)
      .then(function(hex) {
        var cell = row.getCell("p_hex_color");
        if (cell) cell.setValue(hex);
        ok++;
      })
      .catch(function() { fail++; })
      .then(function() {
        setTimeout(function(){ next(idx + 1); }, 100);
      });
  }

  next(0);
}

// ============================================================
// 유틸리티
// ============================================================
function toast(msg, type) {
  var el = document.createElement("div");
  el.className = "crud-toast " + (type || "info");
  el.textContent = msg;
  document.body.appendChild(el);
  setTimeout(function(){
    el.style.opacity = "0";
    el.style.transition = "opacity 0.3s";
    setTimeout(function(){ el.remove(); }, 300);
  }, 3000);
}

})();
</script>

<!-- ============================================================
     4. 제조사(Brand) 관리 팝업
     ============================================================ -->
<script>
(function(){
"use strict";

// 현재 브랜드 맵 (서버에서 초기화)
var brandMap = {<%=brandMap%>};
console.log('[BRAND] 초기 브랜드맵:', brandMap);

// ============================================================
// 메인 CRUD 툴바 우측에 "제조사 관리" 버튼 추가
// ============================================================
document.addEventListener("DOMContentLoaded", function(){
  var toolbarRight = document.querySelector(".crud-toolbar-right");
  if (!toolbarRight) { console.warn('[BRAND] .crud-toolbar-right 없음'); return; }

  // ★ 샘플지급 관리 버튼
  var sampleBtn = document.createElement("button");
  sampleBtn.className = "crud-btn";
  sampleBtn.style.cssText = "background:#059669;color:#fff;border-color:#059669;font-weight:600;margin-right:6px;";
  sampleBtn.textContent = "샘플지급 관리";
  sampleBtn.title = "샘플지급 이력 관리 페이지";
  sampleBtn.onclick = function(){ window.open('/paint_sample/index.asp', '_blank'); };
  toolbarRight.insertBefore(sampleBtn, toolbarRight.firstChild);

  // 제조사 관리 버튼
  var btn = document.createElement("button");
  btn.className = "crud-btn";
  btn.style.cssText = "background:#6366f1;color:#fff;border-color:#6366f1;font-weight:600;margin-right:6px;";
  btn.textContent = "제조사 관리";
  btn.title = "페인트 제조사 추가/수정/삭제";
  btn.onclick = openBrandPopup;
  toolbarRight.insertBefore(btn, sampleBtn);
  console.log('[BRAND] 제조사 관리 + 샘플지급 버튼 추가 완료');
});

// ============================================================
// 팝업 열기
// ============================================================
var brandTable = null;
var brandDirty = {};   // pbidx → {action:'update'|'insert'|'delete', data:{...}}
var brandTempSeq = 0;

function openBrandPopup() {
  console.log('[BRAND] 팝업 열기');

  // 기존 팝업 제거
  var old = document.querySelector(".brand-overlay");
  if (old) old.remove();

  var overlay = document.createElement("div");
  overlay.className = "brand-overlay";
  overlay.innerHTML =
    '<div class="brand-popup">' +
      '<div class="brand-popup-header">' +
        '<h5>제조사 관리 (tk_paint_brand)</h5>' +
        '<button class="brand-popup-close" id="brandClose">&times;</button>' +
      '</div>' +
      '<div class="brand-popup-body">' +
        '<div class="brand-popup-toolbar">' +
          '<button class="brand-btn brand-btn-add" id="brandAdd">+ 추가</button>' +
          '<button class="brand-btn brand-btn-save" id="brandSave">저장</button>' +
          '<span class="brand-popup-status" id="brandStatus"></span>' +
        '</div>' +
        '<div id="brandTable"></div>' +
      '</div>' +
    '</div>';

  document.body.appendChild(overlay);

  // 오버레이 클릭으로 닫기
  overlay.addEventListener("click", function(e){ if (e.target === overlay) closeBrandPopup(); });
  document.getElementById("brandClose").onclick = closeBrandPopup;
  document.getElementById("brandAdd").onclick = brandAddRow;
  document.getElementById("brandSave").onclick = brandSave;

  // ESC 닫기
  overlay._escHandler = function(e){ if (e.key === "Escape") closeBrandPopup(); };
  document.addEventListener("keydown", overlay._escHandler);

  // 테이블 생성 & 데이터 로드
  brandDirty = {};
  brandTempSeq = 0;
  createBrandTable();
  loadBrandData();
}

function closeBrandPopup() {
  console.log('[BRAND] 팝업 닫기');
  var overlay = document.querySelector(".brand-overlay");
  if (overlay) {
    if (overlay._escHandler) document.removeEventListener("keydown", overlay._escHandler);
    overlay.remove();
  }
  if (brandTable) { brandTable.destroy(); brandTable = null; }

  // 메인 테이블 제조사 드롭다운 갱신
  refreshBrandDropdown();
}

// ============================================================
// Tabulator 테이블 생성
// ============================================================
function createBrandTable() {
  brandTable = new Tabulator("#brandTable", {
    height: "350px",
    layout: "fitColumns",
    columns: [
      {title:"#", formatter:"rownum", width:40, hozAlign:"center", headerSort:false},
      {field:"pbidx", title:"ID", width:60, hozAlign:"center", editable:false},
      {field:"pname_brand", title:"제조사명", editor:"input", minWidth:200},
      // --- 행별 삭제 버튼 ---
      {title:"", width:40, hozAlign:"center", headerSort:false, editable:false,
        formatter: function(c) {
          return '<span style="color:#ef4444;cursor:pointer;font-weight:bold;font-size:14px" title="삭제">&times;</span>';
        }
      }
    ]
  });

  // cellEdited → dirty 마킹
  brandTable.on("cellEdited", function(cell){
    var row = cell.getRow();
    var data = row.getData();
    var pk = data.pbidx;
    console.log('[BRAND] cellEdited pk=' + pk + ' field=' + cell.getField() + ' val=' + cell.getValue());

    if (String(pk).indexOf("NEW_") === 0) {
      if (!brandDirty[pk]) brandDirty[pk] = {action:"insert", data:{}};
      brandDirty[pk].data.pname_brand = data.pname_brand;
    } else {
      if (!brandDirty[pk]) brandDirty[pk] = {action:"update", data:{}};
      if (brandDirty[pk].action !== "delete") {
        brandDirty[pk].data.pbidx = pk;
        brandDirty[pk].data.pname_brand = data.pname_brand;
      }
    }
    row.getElement().classList.add(String(pk).indexOf("NEW_") === 0 ? "brand-row-new" : "brand-row-changed");
    updateBrandStatus();
  });

  // X 버튼 클릭 → 삭제 처리
  brandTable.on("cellClick", function(e, cell){
    // 마지막 컬럼(삭제 버튼)인지 확인
    if (cell.getColumn().getDefinition().title !== "") return;
    var row = cell.getRow();
    var data = row.getData();
    var pk = data.pbidx;
    console.log('[BRAND] 삭제 클릭 pk=' + pk);
    brandDeleteRow(row, pk);
  });
}

// ============================================================
// 데이터 로드
// ============================================================
function loadBrandData() {
  console.log('[BRAND] 데이터 로드');
  fetch("brand_api.asp?action=list&size=500&sort=pbidx&dir=ASC")
    .then(function(r){ return r.json(); })
    .then(function(res){
      console.log('[BRAND] 로드 완료:', res.data ? res.data.length : 0, '건');
      if (res.data && brandTable) {
        brandTable.setData(res.data);
      }
    })
    .catch(function(e){
      console.error('[BRAND] 로드 실패:', e);
      setBrandStatus("로드 실패: " + e.message, "red");
    });
}

// ============================================================
// 행 추가
// ============================================================
function brandAddRow() {
  brandTempSeq++;
  var tempId = "NEW_" + brandTempSeq;
  console.log('[BRAND] 행 추가 tempId=' + tempId);

  brandTable.addRow({pbidx: tempId, pname_brand: ""}, true);
  brandDirty[tempId] = {action:"insert", data:{pname_brand:""}};
  updateBrandStatus();

  // 추가된 행에 포커스
  setTimeout(function(){
    var rows = brandTable.getRows();
    if (rows.length > 0) {
      var firstRow = rows[0];
      var cell = firstRow.getCell("pname_brand");
      if (cell) cell.edit();
    }
  }, 100);
}

// ============================================================
// 행 삭제 처리 (X 버튼 클릭)
// ============================================================
function brandDeleteRow(row, pk) {
  if (String(pk).indexOf("NEW_") === 0) {
    // 신규 행 → 바로 제거
    delete brandDirty[pk];
    row.delete();
    console.log('[BRAND] 신규 행 제거 pk=' + pk);
  } else {
    // 기존 행 → 이미 삭제 마킹된 경우 복원, 아니면 삭제 마킹
    var el = row.getElement();
    if (brandDirty[pk] && brandDirty[pk].action === "delete") {
      // 복원 (토글)
      delete brandDirty[pk];
      el.classList.remove("brand-row-deleted");
      console.log('[BRAND] 삭제 취소(복원) pk=' + pk);
    } else {
      // 삭제 마킹
      brandDirty[pk] = {action:"delete", data:{pbidx: pk}};
      el.classList.add("brand-row-deleted");
      console.log('[BRAND] 삭제 마킹 pk=' + pk);
    }
  }
  updateBrandStatus();
}

// ============================================================
// 저장 (batch API)
// ============================================================
function brandSave() {
  var keys = Object.keys(brandDirty);
  if (keys.length === 0) {
    setBrandStatus("변경사항 없음", "#64748b");
    return;
  }

  var batch = {insert:[], update:[], "delete":[]};
  for (var i = 0; i < keys.length; i++) {
    var entry = brandDirty[keys[i]];
    if (entry.action === "insert") {
      if (entry.data.pname_brand && entry.data.pname_brand.trim() !== "") {
        batch.insert.push({pname_brand: entry.data.pname_brand});
      }
    } else if (entry.action === "update") {
      batch.update.push(entry.data);
    } else if (entry.action === "delete") {
      batch["delete"].push(entry.data);
    }
  }

  console.log('[BRAND] 저장 batch:', JSON.stringify(batch));
  setBrandStatus("저장 중...", "#3b82f6");

  fetch("brand_api.asp?action=batch", {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(batch)
  })
  .then(function(r){ return r.json(); })
  .then(function(res){
    console.log('[BRAND] 저장 응답:', res);
    if (res.result === "ok") {
      setBrandStatus("저장 완료! (추가:" + (res.inserted||0) + " 수정:" + (res.updated||0) + " 삭제:" + (res.deleted||0) + ")", "#059669");
      brandDirty = {};
      // 데이터 리로드
      loadBrandData();
    } else {
      setBrandStatus("저장 실패: " + (res.msg || "알 수 없는 오류"), "#ef4444");
    }
  })
  .catch(function(e){
    console.error('[BRAND] 저장 실패:', e);
    setBrandStatus("저장 실패: " + e.message, "#ef4444");
  });
}

// ============================================================
// 제조사 드롭다운 갱신 (팝업 닫을 때)
// ============================================================
function refreshBrandDropdown() {
  console.log('[BRAND] 드롭다운 갱신 시작');

  fetch("brand_api.asp?action=list&size=500&sort=pbidx&dir=ASC")
    .then(function(r){ return r.json(); })
    .then(function(res){
      if (!res.data) return;
      console.log('[BRAND] 드롭다운 갱신:', res.data.length, '건');

      // 새 맵 생성
      var newValues = {};
      var newMap = {};
      for (var i = 0; i < res.data.length; i++) {
        var d = res.data[i];
        newValues[d.pbidx] = d.pname_brand;
        newMap[d.pbidx] = d.pname_brand;
      }

      // 글로벌 brandMap 갱신
      brandMap = newMap;

      // 메인 Tabulator 컬럼 정의 갱신
      var mainTable = window.CrudEngine.getTable();
      if (!mainTable) return;

      // pname_brand 컬럼 찾아서 editorParams, formatter 갱신
      var cols = mainTable.getColumnDefinitions();
      for (var ci = 0; ci < cols.length; ci++) {
        if (cols[ci].field === "pname_brand") {
          cols[ci].editorParams = {values: newValues};
          cols[ci].formatter = function(c) {
            return newMap[c.getValue()] || c.getValue();
          };
          break;
        }
      }

      // 컬럼 재설정 → 테이블 갱신
      mainTable.setColumns(cols);

      // 데이터 리로드 (컬럼 재설정 후 데이터도 갱신)
      window.CrudEngine.reload();
      console.log('[BRAND] 드롭다운 갱신 완료');
    })
    .catch(function(e){
      console.error('[BRAND] 드롭다운 갱신 실패:', e);
    });
}

// ============================================================
// 유틸
// ============================================================
function setBrandStatus(msg, color) {
  var el = document.getElementById("brandStatus");
  if (el) { el.textContent = msg; el.style.color = color || "#64748b"; }
}

function updateBrandStatus() {
  var count = Object.keys(brandDirty).length;
  setBrandStatus(count > 0 ? count + "건 변경됨" : "", "#f59e0b");
}

})();
</script>

</body>
</html>
