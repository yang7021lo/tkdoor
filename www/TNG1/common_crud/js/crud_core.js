/**
 * CRUD Engine - Generic Tabulator CRUD with Dirty Buffer, Batch API, Clipboard Paste
 *
 * 사용법: window.CRUD_CONFIG 설정 후 이 파일 로드
 */
(function(){
"use strict";

var CFG = window.CRUD_CONFIG;
if (!CFG) { console.error("CRUD_CONFIG not defined"); return; }

// === State ===
var table = null;
var dirtyBuffer = {};    // key → {pk, original, current, status}
var tempIdSeq = 0;
var toolbarEl = null;

// ============================================================
// INIT
// ============================================================
document.addEventListener("DOMContentLoaded", function(){
  createToolbar();
  createTable();
  initClipboard();
  initKeyboard();
});

// ============================================================
// TOOLBAR
// ============================================================
function createToolbar(){
  var el = document.createElement("div");
  el.className = "crud-toolbar";
  el.innerHTML =
    '<div class="crud-toolbar-left">' +
      '<button class="crud-btn crud-btn-add" title="행 추가 (Ctrl+I)">+ 행 추가</button>' +
      '<button class="crud-btn crud-btn-del" title="선택 행 삭제 (Del)">삭제 표시</button>' +
      '<button class="crud-btn crud-btn-save" title="변경 저장 (Ctrl+S)">저장</button>' +
      '<button class="crud-btn" onclick="location.reload()">새로고침</button>' +
    '</div>' +
    '<div class="crud-toolbar-right">' +
      '<span class="crud-dirty-count"></span>' +
      '<input type="text" class="crud-search" placeholder="검색... (Enter)">' +
    '</div>';

  var target = document.querySelector(CFG.tableEl || "#crud-table");
  target.parentNode.insertBefore(el, target);
  toolbarEl = el;

  el.querySelector(".crud-btn-add").onclick = addRow;
  el.querySelector(".crud-btn-del").onclick = markSelectedDeleted;
  el.querySelector(".crud-btn-save").onclick = save;
  el.querySelector(".crud-search").onkeydown = function(e){
    if (e.key === "Enter") doSearch(e.target.value);
  };
}

function updateToolbar(){
  var keys = Object.keys(dirtyBuffer);
  var cnt = keys.length;
  var el = toolbarEl.querySelector(".crud-dirty-count");
  el.textContent = cnt > 0 ? ("변경: " + cnt + "건") : "";
  var btn = toolbarEl.querySelector(".crud-btn-save");
  btn.disabled = cnt === 0;
}

// ============================================================
// TABULATOR
// ============================================================
function createTable(){
  var cols = [];

  // 체크박스 컬럼
  cols.push({
    formatter:"rowSelection", titleFormatter:"rowSelection",
    width:30, headerSort:false, hozAlign:"center", frozen:true
  });

  // 상태 표시 컬럼
  cols.push({
    title:"", field:"_status", width:28, headerSort:false, hozAlign:"center",
    formatter: function(cell){
      var v = cell.getValue();
      if (v === "new") return '<span class="crud-status-new">N</span>';
      if (v === "modified") return '<span class="crud-status-mod">M</span>';
      if (v === "deleted") return '<span class="crud-status-del">D</span>';
      return "";
    }
  });

  // 사용자 컬럼
  for (var i = 0; i < CFG.columns.length; i++){
    var c = CFG.columns[i];
    var col = {
      title: c.title,
      field: c.field,
      width: c.width,
      minWidth: c.minWidth || 50,
      widthGrow: c.widthGrow,
      hozAlign: c.hozAlign,
      headerSort: c.headerSort !== false,
      visible: c.visible !== false
    };
    if (c.editable !== false && c.editor){
      col.editor = c.editor;
      if (c.editorParams) col.editorParams = c.editorParams;
    }
    if (c.formatter) col.formatter = c.formatter;
    cols.push(col);
  }

  table = new Tabulator(CFG.tableEl || "#crud-table", {
    columns: cols,
    layout: "fitColumns",
    height: CFG.height || "calc(100vh - 160px)",
    renderVertical: "virtual",
    movableColumns: true,
    selectable: true,
    selectableRange: false,

    // Remote Pagination
    pagination: true,
    paginationMode: "remote",
    paginationSize: CFG.pageSize || 50,
    paginationSizeSelector: [25, 50, 100, 200, 500],
    sortMode: "remote",

    ajaxURL: CFG.apiUrl + "?action=list",
    ajaxURLGenerator: function(url, config, params){
      var u = CFG.apiUrl + "?action=list";
      u += "&page=" + (params.page || 1);
      u += "&size=" + (params.size || CFG.pageSize || 50);
      if (params.sorters && params.sorters.length > 0){
        u += "&sort=" + params.sorters[0].field;
        u += "&sorter=" + params.sorters[0].dir;
      }
      if (CFG._searchText) u += "&search=" + encodeURIComponent(CFG._searchText);
      return u;
    },
    ajaxResponse: function(url, params, response){
      if (response.error){
        showToast("데이터 로드 오류: " + response.msg, "error");
        return {last_page:1, data:[]};
      }
      return {
        last_page: Math.ceil((response.totalRows || 0) / (response.pageSize || 50)),
        data: response.data || []
      };
    },

    // Events
    cellEdited: onCellEdited,
    rowFormatter: function(row){
      var d = row.getData();
      var el = row.getElement();
      el.classList.remove("crud-row-new", "crud-row-deleted");
      if (d._status === "new") el.classList.add("crud-row-new");
      if (d._status === "deleted") el.classList.add("crud-row-deleted");
    },
    rowContextMenu: [
      {label:"행 삭제 표시", action:function(e,row){ markDeleted(row); }},
      {label:"삭제 취소", action:function(e,row){ unmarkDeleted(row); }},
      {separator:true},
      {label:"행 복제", action:function(e,row){ duplicateRow(row); }}
    ],
    dataLoaded: function(){
      // 페이지 이동 시 dirty buffer에서 현재 페이지에 없는 항목은 유지
    }
  });
}

// ============================================================
// DIRTY BUFFER
// ============================================================
function getRowKey(data){
  var pk = data[CFG.pk];
  if (pk && pk !== "" && pk !== "0") return "pk_" + pk;
  if (data._tempId) return data._tempId;
  return null;
}

function onCellEdited(cell){
  var row = cell.getRow();
  var data = row.getData();
  var key = getRowKey(data);
  if (!key) return;

  if (!dirtyBuffer[key]){
    // 처음 수정: 원본 캡처
    var orig = {};
    var fields = row.getCells();
    for (var i = 0; i < fields.length; i++){
      var f = fields[i].getField();
      if (f && f.charAt(0) !== "_") orig[f] = fields[i].getInitialValue();
    }
    dirtyBuffer[key] = {
      pk: data[CFG.pk] || null,
      original: orig,
      current: shallowCopy(data),
      status: data._status === "new" ? "new" : "modified"
    };
  } else {
    dirtyBuffer[key].current = shallowCopy(data);
  }

  // 원복 체크 (modified만)
  if (dirtyBuffer[key].status === "modified"){
    if (isEqualData(dirtyBuffer[key].original, dirtyBuffer[key].current)){
      delete dirtyBuffer[key];
      row.update({_status:""});
      row.reformat();
      updateToolbar();
      return;
    }
  }

  row.update({_status: dirtyBuffer[key].status});
  row.reformat();
  highlightDirtyCells(row);
  updateToolbar();
}

function highlightDirtyCells(row){
  var data = row.getData();
  var key = getRowKey(data);
  var entry = dirtyBuffer[key];
  var cells = row.getCells();
  for (var i = 0; i < cells.length; i++){
    var f = cells[i].getField();
    if (!f || f.charAt(0) === "_") continue;
    var el = cells[i].getElement();
    if (entry && entry.original[f] !== undefined &&
        String(entry.original[f]) !== String(entry.current[f])){
      el.classList.add("crud-cell-dirty");
    } else {
      el.classList.remove("crud-cell-dirty");
    }
  }
}

// ============================================================
// ROW OPERATIONS
// ============================================================
function addRow(){
  tempIdSeq++;
  var tempId = "_new_" + tempIdSeq;
  var row = {_status:"new", _tempId:tempId};
  // 기본값
  for (var i = 0; i < CFG.columns.length; i++){
    var c = CFG.columns[i];
    if (c.defaultValue !== undefined) row[c.field] = c.defaultValue;
  }
  table.addRow(row, true);
  dirtyBuffer[tempId] = {
    pk:null, original:{}, current:shallowCopy(row), status:"new"
  };
  updateToolbar();
}

function markDeleted(row){
  var data = row.getData();
  var pk = data[CFG.pk];

  // 신규 행은 바로 제거
  if (!pk || pk === "" || pk === "0"){
    var tid = data._tempId;
    if (tid && dirtyBuffer[tid]) delete dirtyBuffer[tid];
    row.delete();
    updateToolbar();
    return;
  }

  var key = "pk_" + pk;
  if (!dirtyBuffer[key]){
    dirtyBuffer[key] = {
      pk:pk, original:shallowCopy(data), current:shallowCopy(data), status:"deleted"
    };
  } else {
    dirtyBuffer[key].status = "deleted";
  }
  row.update({_status:"deleted"});
  row.reformat();
  updateToolbar();
}

function unmarkDeleted(row){
  var data = row.getData();
  var pk = data[CFG.pk];
  if (!pk) return;
  var key = "pk_" + pk;
  if (!dirtyBuffer[key]) return;

  if (isEqualData(dirtyBuffer[key].original, dirtyBuffer[key].current)){
    delete dirtyBuffer[key];
    row.update({_status:""});
  } else {
    dirtyBuffer[key].status = "modified";
    row.update({_status:"modified"});
  }
  row.reformat();
  updateToolbar();
}

function markSelectedDeleted(){
  var rows = table.getSelectedRows();
  if (!rows.length){ showToast("행을 선택하세요.", "info"); return; }
  for (var i = 0; i < rows.length; i++) markDeleted(rows[i]);
}

function duplicateRow(row){
  var data = shallowCopy(row.getData());
  delete data[CFG.pk];
  delete data._status;
  delete data._tempId;
  tempIdSeq++;
  data._tempId = "_new_" + tempIdSeq;
  data._status = "new";
  table.addRow(data, true);
  dirtyBuffer[data._tempId] = {
    pk:null, original:{}, current:shallowCopy(data), status:"new"
  };
  updateToolbar();
}

// ============================================================
// CLIPBOARD PASTE
// ============================================================
function initClipboard(){
  document.addEventListener("paste", function(e){
    // 편집 중이면 무시 (input/textarea)
    var tag = (e.target.tagName || "").toLowerCase();
    if (tag === "input" || tag === "textarea") return;

    var text = (e.clipboardData || window.clipboardData).getData("text");
    if (!text || text.indexOf("\t") < 0) return; // 탭 없으면 엑셀 아님

    e.preventDefault();
    handlePaste(text);
  });
}

function handlePaste(text){
  var pasteCols = CFG.pasteColumns;
  if (!pasteCols || !pasteCols.length){
    showToast("pasteColumns 설정이 없습니다.", "error");
    return;
  }

  var lines = text.split(/\r?\n/).filter(function(l){ return l.trim() !== ""; });
  if (lines.length === 0) return;

  if (lines.length > 500){
    if (!confirm(lines.length + "행을 붙여넣기 하시겠습니까?")) return;
  }

  var newRows = [];
  for (var i = 0; i < lines.length; i++){
    var cells = lines[i].split("\t");
    tempIdSeq++;
    var tempId = "_new_" + tempIdSeq;
    var row = {_status:"new", _tempId:tempId};

    for (var j = 0; j < pasteCols.length && j < cells.length; j++){
      row[pasteCols[j]] = cells[j].trim();
    }

    if (CFG.onRowAdded){
      var result = CFG.onRowAdded(row);
      if (result === false) continue;
      if (result) row = result;
    }

    newRows.push(row);
    dirtyBuffer[tempId] = {
      pk:null, original:{}, current:shallowCopy(row), status:"new"
    };
  }

  if (newRows.length > 0){
    table.addData(newRows, true);
    updateToolbar();
    showToast(newRows.length + "행 붙여넣기 완료 (저장 버튼을 눌러주세요)", "info");
  }
}

// ============================================================
// BATCH SAVE
// ============================================================
function save(){
  var keys = Object.keys(dirtyBuffer);
  if (keys.length === 0){
    showToast("변경사항이 없습니다.", "info");
    return;
  }

  var batch = collectBatchData();

  if (CFG.onBeforeSave){
    batch = CFG.onBeforeSave(batch);
    if (batch === false) return;
  }

  showLoading(true);

  fetch(CFG.apiUrl + "?action=batch", {
    method: "POST",
    headers: {"Content-Type":"application/json; charset=utf-8"},
    body: JSON.stringify(batch)
  })
  .then(function(r){ return r.json(); })
  .then(function(res){
    showLoading(false);
    if (res.result === "ok"){
      showToast(
        "저장 완료: 추가 " + (res.inserted||0) + "건, 수정 " + (res.updated||0) + "건, 삭제 " + (res.deleted||0) + "건",
        "success"
      );
      dirtyBuffer = {};
      updateToolbar();
      table.setData(); // 서버에서 다시 로드
      if (CFG.onAfterSave) CFG.onAfterSave(res);
    } else {
      showToast("저장 실패: " + (res.msg || "알 수 없는 오류"), "error");
    }
  })
  .catch(function(err){
    showLoading(false);
    showToast("네트워크 오류: " + err.message, "error");
  });
}

function collectBatchData(){
  var inserts = [], updates = [], deletes = [];

  for (var key in dirtyBuffer){
    if (!dirtyBuffer.hasOwnProperty(key)) continue;
    var entry = dirtyBuffer[key];
    var clean = stripInternal(entry.current);

    switch(entry.status){
      case "new":
        inserts.push(clean);
        break;
      case "modified":
        // PK + 변경된 필드만
        var changed = {};
        changed[CFG.pk] = entry.pk;
        for (var f in entry.current){
          if (!entry.current.hasOwnProperty(f)) continue;
          if (f.charAt(0) === "_") continue;
          if (String(entry.original[f]) !== String(entry.current[f])){
            changed[f] = entry.current[f];
          }
        }
        updates.push(changed);
        break;
      case "deleted":
        var d = {};
        d[CFG.pk] = entry.pk;
        deletes.push(d);
        break;
    }
  }

  return {insert:inserts, update:updates, delete:deletes};
}

// ============================================================
// SEARCH
// ============================================================
function doSearch(text){
  CFG._searchText = text;
  table.setData(); // 서버 리로드 with search param
}

// ============================================================
// KEYBOARD SHORTCUTS
// ============================================================
function initKeyboard(){
  document.addEventListener("keydown", function(e){
    if ((e.ctrlKey || e.metaKey) && e.key === "s"){
      e.preventDefault();
      save();
    }
    if ((e.ctrlKey || e.metaKey) && e.key === "i"){
      e.preventDefault();
      addRow();
    }
    if (e.key === "Delete" && !isEditing(e.target)){
      markSelectedDeleted();
    }
  });
}

function isEditing(el){
  var tag = (el.tagName || "").toLowerCase();
  return tag === "input" || tag === "textarea" || el.contentEditable === "true";
}

// ============================================================
// UI HELPERS
// ============================================================
function showToast(msg, type){
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

function showLoading(on){
  var el = document.querySelector(".crud-loading");
  if (!el){
    el = document.createElement("div");
    el.className = "crud-loading";
    el.textContent = "저장 중...";
    var wrap = document.querySelector(CFG.tableEl || "#crud-table");
    wrap.parentNode.style.position = "relative";
    wrap.parentNode.insertBefore(el, wrap);
  }
  el.classList.toggle("show", on);
}

// ============================================================
// UTILITY
// ============================================================
function shallowCopy(obj){
  var o = {};
  for (var k in obj) if (obj.hasOwnProperty(k)) o[k] = obj[k];
  return o;
}

function stripInternal(obj){
  var o = {};
  for (var k in obj){
    if (obj.hasOwnProperty(k) && k.charAt(0) !== "_") o[k] = obj[k];
  }
  return o;
}

function isEqualData(a, b){
  for (var k in a){
    if (k.charAt(0) === "_") continue;
    if (String(a[k] || "") !== String(b[k] || "")) return false;
  }
  return true;
}

// Export
window.CrudEngine = {
  getTable: function(){ return table; },
  getDirty: function(){ return dirtyBuffer; },
  addRow: addRow,
  save: save,
  reload: function(){ dirtyBuffer = {}; updateToolbar(); table.setData(); }
};

})();
