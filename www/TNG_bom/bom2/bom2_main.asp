<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->

<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"

call DbOpen()

Dim Rs
Set Rs = Server.CreateObject("ADODB.Recordset")
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BOM2 관리</title>
<link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
body { background:#f8f9fa; }

.tab-btn {
    padding:12px 18px;
    border-radius:6px;
    cursor:pointer;
    background:#e9ecef;
    margin-right:6px;
    font-weight:600;
}
.tab-btn.active {
    background:#0d6efd;
    color:#fff;
}

.panel-box {
    background:#fff;
    margin-top:20px;
    padding:20px;
    border-radius:8px;
    box-shadow:0 2px 5px rgba(0,0,0,0.1);
}
</style>
</head>

<body class="sb-nav-fixed" style="margin-left : 250px;">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div class="container mt-4">

    <!-- 🔥 상단 탭 -->
    <div class="d-flex flex-wrap gap-2" style="margin-top:80px;">
        <div class="tab-btn" onclick="loadTab(this,'master')">카테고리</div>
        <div class="tab-btn" onclick="loadTab(this,'origin')">원산구분</div>
        <div class="tab-btn" onclick="loadTab(this,'mold')">금형정보</div>
        <div class="tab-btn" onclick="loadTab(this,'surface')">표면처리</div>
        <div class="tab-btn" onclick="loadTab(this,'length')">길이관리</div>
        <div class="tab-btn" onclick="loadTab(this,'title')">하위정보</div>
    </div>

    <!-- 🔥 콘텐츠 영역 -->
    <div id="contentBox" class="panel-box">
        <h5 class="text-muted">탭을 선택하세요.</h5>
    </div>

</div>


<%
' ===== ORIGIN 목록 조회 =====
Dim RsOrigin, sqlOrigin
Set RsOrigin = Server.CreateObject("ADODB.Recordset")

sqlOrigin = "SELECT origin_type_no, origin_name FROM bom2_origin_type ORDER BY origin_type_no"
RsOrigin.Open sqlOrigin, Dbcon
%>

<script>

/* ===============================
   ORIGIN LIST (DB 연동)
================================ */
const ORIGIN_LIST = [
<%
Dim first
first = True

If Not RsOrigin.EOF Then
    Do While Not RsOrigin.EOF
        If Not first Then Response.Write "," & vbCrLf
        first = False
%>
    {
        id: <%=RsOrigin("origin_type_no")%>,
        name: "<%=Replace(RsOrigin("origin_name"),"""","\""")%>"
    }
<%
        RsOrigin.MoveNext
    Loop
End If
%>
];

/* ===============================
   공통 부분
================================ */
//특수문자 방지
function escapeHtml(str){
    return str
        .replace(/&/g,"&amp;")
        .replace(/</g,"&lt;")
        .replace(/>/g,"&gt;")
        .replace(/"/g,"&quot;")
        .replace(/'/g,"&#039;");
}


function getOriginOptions(selected){
    let html = `<option value="">선택</option>`;
    ORIGIN_LIST.forEach(o=>{
        html += `<option value="${o.id}" ${selected==o.id?"selected":""}>${o.name}</option>`;
    });
    return html;
}

function getOriginNameById(id){
    const o = ORIGIN_LIST.find(x=>x.id==id);
    return o ? o.name : "";
}


/* ===============================
   현재 선택된 탭 type
================================ */
let currentType = "";

const TAB_URL = {
    master: "master/bom2_master_list.asp",
    origin: "origin/bom2_origin_list.asp",
    mold: "mold/bom2_mold_list.asp",
    surface: "surface/bom2_surface_list.asp",
    length: "length/bom2_length_list.asp",
    title: "title/bom2_title_list.asp"
};


/* ===============================
   탭 로드
================================ */


function loadTab(el, type){
    currentType = type;

    document.querySelectorAll(".tab-btn")
        .forEach(b=>b.classList.remove("is_active"));
    el.classList.add("is_active");

    fetch(TAB_URL[type])
        .then(r=>r.text())
        .then(html=>{
            contentBox.innerHTML = html;
        });
}

/* ===============================
   공통 reload (list.asp 내부에서 사용)
================================ */
function reloadCurrentTab(){
    if(!currentType) return;
    loadTab(
        document.querySelector('.tab-btn.is_active'),
        currentType
    );
}

/* ===============================
   master 전용 인라인 편집 함수 시작
================================ */
let MASTER_EDITING = false;

function openMasterAdd(){
    const tbody = document.querySelector("#masterTable tbody");
    if(!tbody) return;

    let insertRow = document.getElementById("masterInsertRow");
    if(insertRow){
        insertRow.querySelector("input").focus();
        return;
    }

    insertRow = document.createElement("tr");
    insertRow.id = "masterInsertRow";

    insertRow.innerHTML = `
        <!-- ✅ 품번 (item_no) -->
        <td>
            <input type="text" class="form-control form-control-sm"
                   placeholder="품번"
                   onkeydown="masterInsertKey(event)">
        </td>

        <!-- 품목명 -->
        <td>
            <input type="text" class="form-control form-control-sm"
                   placeholder="품목명"
                   onkeydown="masterInsertKey(event)">
        </td>

        <!-- 원산구분 -->
        <td>
            <select class="form-select form-select-sm"
                    onkeydown="masterInsertKey(event)">
                ${getOriginOptions("")}
            </select>
        </td>

        <!-- 상태(active) -->
        <td>
            <select class="form-select form-select-sm">
                <option value="1">사용</option>
                <option value="0">중지</option>
            </select>
        </td>

        <td>-</td>
        <td>
            <button class="btn btn-sm btn-success me-1"
                onclick="saveMasterInsert()"><i class="bi bi-check"></i></button>
            <button class="btn btn-sm btn-secondary"
                onclick="cancelMasterInsert()"><i class="bi bi-x"></i></button>
        </td>
    `;

    tbody.insertBefore(insertRow, tbody.firstChild);
    insertRow.querySelector("input").focus();
}

function masterInsertKey(e){
    if(e.key === "Enter") saveMasterInsert();
    if(e.key === "Escape") cancelMasterInsert();
}

function saveMasterInsert(){
    const tr = document.getElementById("masterInsertRow");
    if(!tr) return;

    const itemNo  = tr.querySelector("td:nth-child(1) input").value.trim();
    const name    = tr.querySelector("td:nth-child(2) input").value.trim();
    const origin  = tr.querySelector("td:nth-child(3) select").value;
    const is_active  = tr.querySelector("td:nth-child(4) select").value;

    if(!itemNo || !name){
        alert("품번과 품목명을 입력하세요");
        return;
    }

    if(!origin){
        alert("원산구분을 선택하세요");
        return;
    }

    fetch("master/bom2_master_save.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "item_no=" + encodeURIComponent(itemNo) +
            "&item_name=" + encodeURIComponent(name) +
            "&origin_type_no=" + encodeURIComponent(origin) +
            "&is_active=" + encodeURIComponent(is_active)
    })
    .then(r => r.text())
.then(res => {
  res = res.trim();

  if(res === "OK"){
    reloadCurrentTab();

    setTimeout(() => {
      openMasterAdd();
    }, 150);

  }else if(res.indexOf("DUPLICATE|") === 0){
    const p = res.split("|");

    const masterId   = p[1];
    const itemName   = p[2];
    const statusText = p[3];

    alert(
      "이미 등록된 품번입니다.\n\n" +
      "품목명    : " + itemName + "\n" +
      "상태      : " + statusText + "\n" +
      "다른 품번으로 등록해주세요."
    );

  }else{
    alert("저장 실패 : " + res);
  }
});

}

function cancelMasterInsert(){
    const tr = document.getElementById("masterInsertRow");
    if(tr) tr.remove();
}

/* ===============================
   수정 (UPDATE)
================================ */

function masterUpdateKey(e, input){
    if(e.key === "Enter"){
        const btn = input.closest("tr")
                         .querySelector("button.btn-success");
        if(btn) btn.click();
    }

    if(e.key === "Escape"){
        const btn = input.closest("tr")
                         .querySelector("button.btn-secondary");
        if(btn) btn.click();
    }
}

function editMasterRow(btn){
    MASTER_EDITING = true;
    const tr = btn.closest("tr");

    tr.dataset.oldItemNo = tr.querySelector("td:first-child").innerText;
    tr.dataset.oldName   = tr.querySelector(".master-name").innerText;
    tr.dataset.oldOrigin = tr.querySelector(".master-origin").dataset.originId;

    // 🔥 상태는 텍스트 그대로만 저장 (절대 계산 X)
    tr.dataset.oldStatusText =
      tr.querySelector(".master-status").innerText.trim();

    // 품번
    tr.querySelector("td:first-child").innerHTML = `
        <input type="text" class="form-control form-control-sm"
               value="${tr.dataset.oldItemNo}"
               onkeydown="masterUpdateKey(event, this)">
    `;

    // 품목명
    tr.querySelector(".master-name").innerHTML = `
        <input type="text" class="form-control form-control-sm"
               value="${tr.dataset.oldName}"
               onclick="event.stopPropagation()"
               onkeydown="masterUpdateKey(event, this)">
    `;

    // 원산구분
    tr.querySelector(".master-origin").innerHTML = `
        <select class="form-select form-select-sm">
            ${getOriginOptions(tr.dataset.oldOrigin)}
        </select>
    `;

    // ❌ 상태 TD는 절대 건드리지 않는다

    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-success me-1"
            onclick="saveMasterUpdate(this)"><i class="bi bi-check"></i></button>
        <button class="btn btn-sm btn-secondary"
            onclick="cancelMasterUpdate(this)"><i class="bi bi-x"></i></button>
    `;
}

function saveMasterUpdate(btn){
    const tr = btn.closest("tr");
    const masterId = tr.dataset.id;

    const itemNo = tr.querySelector("td:first-child input").value.trim();
    const name   = tr.querySelector(".master-name input").value.trim();
    const origin = tr.querySelector(".master-origin select").value;

    if(!itemNo || !name){
        alert("품번과 품목명을 입력하세요");
        return;
    }

    fetch("master/bom2_master_update.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "master_id=" + masterId +
            "&item_no=" + encodeURIComponent(itemNo) +
            "&item_name=" + encodeURIComponent(name) +
            "&origin_type_no=" + origin
            // ❌ active 절대 보내지 않음
    })
    .then(r=>r.text())
    .then(res=>{
        if(res === "OK"){
            MASTER_EDITING = false;

            tr.querySelector("td:first-child").innerText = itemNo;
            tr.querySelector(".master-name").innerText = name;
            tr.querySelector(".master-origin").innerText = getOriginNameById(origin);
            tr.querySelector(".master-origin").dataset.originId = origin;
            restoreMasterButtons(tr);
        }else{
            alert("수정 실패 : " + res);
        }
    });
}


function cancelMasterUpdate(btn){
    MASTER_EDITING = false;
    const tr = btn.closest("tr");

    tr.querySelector("td:first-child").innerText = tr.dataset.oldItemNo;
    tr.querySelector(".master-name").innerText = tr.dataset.oldName;
    tr.querySelector(".master-origin").innerText = getOriginNameById(tr.dataset.oldOrigin);
    tr.querySelector(".master-origin").dataset.originId = tr.dataset.oldOrigin;
    tr.querySelector(".master-status").innerText =
    tr.dataset.oldStatusText;

    restoreMasterButtons(tr);
}

function restoreMasterButtons(tr){
    const statusText =
      tr.querySelector(".master-status").innerText.trim();

    let html = `
        <button class="btn btn-sm btn-outline-secondary me-1"
            onclick="editMasterRow(this)">수정</button>
    `;

    if(statusText === "사용"){
        html += `
            <button class="btn btn-sm btn-danger"
                onclick="openDeactivate('master', ${tr.dataset.id})">
                중지
            </button>
        `;
    }

    tr.querySelector("td:last-child").innerHTML = html;
}

/* ===============================
   master 전용 인라인 편집 함수 종료
================================ */
/* ===============================
   ORIGIN 전용 인라인 편집 함수 시작
================================ */
/* ---------- 공통 ---------- */
function createActionButtons(onSave, onCancel){
    return `
        <button class="btn btn-sm btn-success me-1" onclick="${onSave}">
            <i class="bi bi-check"></i>
        </button>
        <button class="btn btn-sm btn-secondary" onclick="${onCancel}">
            <i class="bi bi-x"></i>
        </button>
    `;
}

/* ---------- 추가 (항상 맨 위) ---------- */
function addOriginRow(){
    const tbody = document.querySelector("#originTable tbody");
    if(!tbody) return;

    let insertRow = document.getElementById("originInsertRow");

    // 이미 있으면 포커스만
    if(insertRow){
        insertRow.querySelector("input").focus();
        return;
    }

    insertRow = document.createElement("tr");
    insertRow.id = "originInsertRow";

    insertRow.innerHTML = `
        
        <td>
            <input type="text" class="form-control form-control-sm"
                   placeholder="원산구분명"
                   onkeydown="originInsertKey(event)">
        </td>
        <td>
            <button class="btn btn-sm btn-success me-1"
                onclick="saveOriginInsert()"><i class="bi bi-check"></i></button>
            <button class="btn btn-sm btn-secondary"
                onclick="cancelOriginInsert()"><i class="bi bi-x"></i></button>
        </td>
    `;

    // 🔥 항상 맨 위
    tbody.insertBefore(insertRow, tbody.firstChild);
    insertRow.querySelector("input").focus();
}

/* ---------- 키 처리 ---------- */
function originInsertKey(e){
    if(e.key === "Enter") saveOriginInsert();
    if(e.key === "Escape") cancelOriginInsert();
}

/* ---------- 저장 (연속 입력) ---------- */
function saveOriginInsert(){
    const insertRow = document.getElementById("originInsertRow");
    if(!insertRow) return;

    const input = insertRow.querySelector("input");
    const val = input.value.trim();

    if(!val){
        alert("값을 입력하세요");
        input.focus();
        return;
    }

    fetch("origin/bom2_origin_save.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:"origin_name=" + encodeURIComponent(val)
    })
    .then(r=>r.text())
    .then(res=>{
        if(res === "OK"){
            // 🔥 저장된 row를 insert 아래에 추가
            appendOriginRow(val);

            // 🔥 입력 유지 → 연속 입력
            input.value = "";
            input.focus();
        }else{
            alert("저장 실패 : " + res);
        }
    });
}

/* ---------- insert 취소 ---------- */
function cancelOriginInsert(){
    const tr = document.getElementById("originInsertRow");
    if(tr) tr.remove();
}

/* ---------- 신규 row 즉시 반영 ---------- */
function appendOriginRow(name){
    const tbody = document.querySelector("#originTable tbody");
    const insertRow = document.getElementById("originInsertRow");

    const tr = document.createElement("tr");
    tr.innerHTML = `
     
        <td class="origin-text">${escapeHtml(name)}</td>
        <td>
            <button class="btn btn-sm btn-outline-secondary"
                onclick="editOriginRow(this)">수정</button>
        </td>
    `;

    // 🔥 insertRow 바로 아래에 누적
    if(insertRow && insertRow.nextSibling){
        tbody.insertBefore(tr, insertRow.nextSibling);
    }else{
        tbody.appendChild(tr);
    }
}

/* ---------- 수정 (기존 로직 유지) ---------- */
function editOriginRow(btn){
    const tr = btn.closest("tr");
    const td = tr.querySelector(".origin-text");
    const oldText = td.innerText.trim();

    tr.dataset.originOld = oldText;

    td.innerHTML = `
        <input type="text" class="form-control form-control-sm"
               value="${oldText}"
               onkeydown="originUpdateKey(event, this)">
    `;

    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-success me-1"
            onclick="saveOriginUpdate(this)"><i class="bi bi-check"></i></button>
        <button class="btn btn-sm btn-secondary"
            onclick="cancelOriginUpdate(this)"><i class="bi bi-x"></i></button>
    `;

    td.querySelector("input").focus();
}

function originUpdateKey(e, input){
    if(e.key === "Enter") saveOriginUpdate(input);
    if(e.key === "Escape") cancelOriginUpdate(input);
}

function saveOriginUpdate(el){
    const tr = el.closest("tr");
    const id = tr.dataset.id;
    const input = tr.querySelector("input");
    const val = input.value.trim();

    if(!val){
        alert("값을 입력하세요");
        input.focus();
        return;
    }

    fetch("origin/bom2_origin_update.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:"origin_type_no=" + id +
             "&origin_name=" + encodeURIComponent(val)
    })
    .then(r=>r.text())
    .then(res=>{
        if(res === "OK"){
            tr.querySelector(".origin-text").innerText = val;
            restoreOriginButtons(tr);
        }else{
            alert("수정 실패");
        }
    });
}

function cancelOriginUpdate(el){
    const tr = el.closest("tr");
    tr.querySelector(".origin-text").innerText = tr.dataset.originOld;
    restoreOriginButtons(tr);
    delete tr.dataset.originOld;
}

function restoreOriginButtons(tr){
    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-outline-secondary"
            onclick="editOriginRow(this)">수정</button>
        <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
    `;
}


/* ===============================
   ORIGIN 전용 인라인 편집 함수 종료
================================ */

/* ==============================
   TITLE 전용 인라인 편집 함수 시작
================================= */

function addTitleRow(){
  const tbody = document.querySelector("#titleTable tbody");
  if(!tbody) return;

  let insertRow = document.getElementById("titleInsertRow");
  if(insertRow){
    insertRow.querySelector("select").focus();
    return;
  }

  const optHTML = document.getElementById("titleMasterOptions").innerHTML;

  insertRow = document.createElement("tr");
  insertRow.id = "titleInsertRow";

  insertRow.innerHTML = `
    <td>
      <select class="form-select form-select-sm"
              onkeydown="titleInsertKey(event)">
        ${optHTML}
      </select>
    </td>
    <td>
      <input type="text" class="form-control form-control-sm"
             placeholder="컬럼명"
             onkeydown="titleInsertKey(event)">
    </td>
    <td>
      <input type="text" class="form-control form-control-sm"
             placeholder="단위"
             onkeydown="titleInsertKey(event)">
    </td>
    <td>
      <select class="form-select form-select-sm title-type-select">
        <option value="">타입 선택</option>
        <option value="1">문자</option>
        <option value="2">숫자</option>
        <option value="4">체크박스</option>
      </select>
    </td>
    <td>
      <button class="btn btn-sm btn-success me-1"
        onclick="saveTitleInsert()"><i class="bi bi-check"></i></button>
      <button class="btn btn-sm btn-secondary"
        onclick="cancelTitleInsert()"><i class="bi bi-x"></i></button>
    </td>
  `;

  tbody.insertBefore(insertRow, tbody.firstChild);
  insertRow.querySelector("select").focus();
}

/* ---------- 타입 텍스트 ---------- */
function typeText(type_id){
  switch(String(type_id)){
    case "1": return "문자";
    case "2": return "숫자";
    case "4": return "체크박스";
    default: return "-";
  }
}

/* ---------- append ---------- */
function appendTitleRow(id, master_id, master_text, title_name, density, type_id){
  const tbody = document.querySelector("#titleTable tbody");

  const tr = document.createElement("tr");
  tr.dataset.id     = id;
  tr.dataset.master = master_id;
  tr.dataset.type   = String(type_id); // 🔥 FIX: 문자열 고정

  tr.innerHTML = `
    <td class="title-master-text">${escapeHtml(master_text)}</td>
    <td class="title-name">${escapeHtml(title_name)}</td>
    <td class="title-density">${escapeHtml(density)}</td>
    <td class="title-type">${typeText(type_id)}</td>
    <td>
      <button class="btn btn-sm btn-outline-secondary"
        onclick="editTitleRow(this)">수정</button>
      <button class="btn btn-sm btn-danger"
        onclick="openDeactivate('title', ${id})">삭제</button>
    </td>
  `;

  tbody.insertBefore(tr, document.getElementById("titleInsertRow")?.nextSibling);
}

/* ---------- insert key ---------- */
function titleInsertKey(e){
  if(e.key === "Enter") saveTitleInsert();
  if(e.key === "Escape") cancelTitleInsert();
}

/* ---------- insert save ---------- */
function saveTitleInsert(){
  const tr = document.getElementById("titleInsertRow");
  if(!tr) return;

  const sel = tr.querySelector("select");
  const master_id   = sel.value;
  const master_text = sel.options[sel.selectedIndex]?.text || "";

  const title_name = tr.querySelector("input[placeholder='컬럼명']").value.trim();
  const density    = tr.querySelector("input[placeholder='단위']").value.trim();
  const type_id    = tr.querySelector(".title-type-select").value;

  if(!master_id){ alert("Master를 선택하세요"); return; }
  if(!title_name){ alert("컬럼명을 입력하세요"); return; }
  if(!type_id){ alert("타입을 선택하세요"); return; }

  fetch("title/bom2_title_save.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "master_id=" + encodeURIComponent(master_id) +
      "&title_name=" + encodeURIComponent(title_name) +
      "&density=" + encodeURIComponent(density) +
      "&type_id=" + encodeURIComponent(type_id)
  })
  .then(r=>r.text())
  .then(res=>{
    if(res.indexOf("OK|") === 0){
      const newId = res.split("|")[1];
      appendTitleRow(newId, master_id, master_text, title_name, density, type_id);
      tr.remove();
      addTitleRow();
    }else{
      alert("저장 실패 : " + res);
    }
  });
}

function cancelTitleInsert(){
  document.getElementById("titleInsertRow")?.remove();
}

/* ==============================
   수정
================================= */

function editTitleRow(btn){
  const tr = btn.closest("tr");

  tr.dataset.oldMasterText = tr.children[0].innerText.trim();
  tr.dataset.oldMaster     = tr.dataset.master;
  tr.dataset.oldName       = tr.children[1].innerText.trim();
  tr.dataset.oldDensity    = tr.children[2].innerText.trim();
  tr.dataset.oldType       = String(tr.dataset.type || ""); // 🔥 FIX

  const optHTML = document.getElementById("titleMasterOptions").innerHTML;

  tr.children[0].innerHTML = `
    <select class="form-select form-select-sm" onkeydown="titleUpdateKey(event)">
      ${optHTML}
    </select>`;
  tr.querySelector("select").value = tr.dataset.oldMaster;

  tr.children[1].innerHTML = `
    <input class="form-control form-control-sm"
           value="${escapeHtml(tr.dataset.oldName)}"
           onkeydown="titleUpdateKey(event)">`;

  tr.children[2].innerHTML = `
    <input class="form-control form-control-sm"
           value="${escapeHtml(tr.dataset.oldDensity)}"
           onkeydown="titleUpdateKey(event)">`;

  tr.children[3].innerHTML = `
    <select class="form-select form-select-sm title-type-select">
      <option value="">타입 선택</option>
      <option value="1">문자</option>
      <option value="2">숫자</option>
      <option value="4">체크박스</option>
    </select>`;
  tr.children[3].querySelector("select").value = tr.dataset.oldType; // 🔥 FIX

  tr.children[4].innerHTML = `
    <button class="btn btn-sm btn-success me-1"
      onclick="saveTitleUpdate(this)"><i class="bi bi-check"></i></button>
    <button class="btn btn-sm btn-secondary"
      onclick="cancelTitleUpdate(this)"><i class="bi bi-x"></i></button>`;
}

/* ---------- update key ---------- */
function titleUpdateKey(e){
  if(e.key === "Enter"){
    e.target.closest("tr").querySelector(".btn-success")?.click();
  }
  if(e.key === "Escape"){
    e.target.closest("tr").querySelector(".btn-secondary")?.click();
  }
}

/* ---------- update save ---------- */
function saveTitleUpdate(btn){
  const tr = btn.closest("tr");
  const id = tr.dataset.id;

  const sel = tr.querySelector("select");
  const master_id   = sel.value;
  const master_text = sel.options[sel.selectedIndex]?.text || "";

  const inputs = tr.querySelectorAll("input");
  const title_name = inputs[0].value.trim();
  const density    = inputs[1].value.trim();
  const type_id    = tr.querySelector(".title-type-select").value;

  if(!master_id || !title_name || !type_id){
    alert("필수값 누락");
    return;
  }

  fetch("title/bom2_title_update.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "list_title_id=" + id +
      "&master_id=" + master_id +
      "&title_name=" + encodeURIComponent(title_name) +
      "&density=" + encodeURIComponent(density) +
      "&type_id=" + type_id
  })
  .then(r=>r.text())
  .then(res=>{
    if(res === "OK"){
      tr.dataset.master = master_id;
      tr.dataset.type   = String(type_id);

      tr.children[0].innerHTML = `<span>${escapeHtml(master_text)}</span>`;
      tr.children[1].innerHTML = `<span>${escapeHtml(title_name)}</span>`;
      tr.children[2].innerHTML = `<span>${escapeHtml(density)}</span>`;
      tr.children[3].innerHTML = `<span>${typeText(type_id)}</span>`;

      restoreTitleButtons(tr);
    }
  });
}

/* ---------- 🔥 FIX 핵심 ---------- */
function restoreTitleButtons(tr){
  const id = tr.dataset.id; // 🔥 FIX

  tr.children[4].innerHTML = `
    <button class="btn btn-sm btn-outline-secondary"
      onclick="editTitleRow(this)">수정</button>
    <button class="btn btn-sm btn-danger"
      onclick="openDeactivate('title', ${id})">삭제</button>`;
}

function cancelTitleUpdate(btn){
  const tr = btn.closest("tr");

  tr.dataset.master = tr.dataset.oldMaster;
  tr.dataset.type   = tr.dataset.oldType;

  tr.children[0].innerHTML = `<span>${escapeHtml(tr.dataset.oldMasterText)}</span>`;
  tr.children[1].innerHTML = `<span>${escapeHtml(tr.dataset.oldName)}</span>`;
  tr.children[2].innerHTML = `<span>${escapeHtml(tr.dataset.oldDensity)}</span>`;
  tr.children[3].innerHTML = `<span>${typeText(tr.dataset.oldType)}</span>`;

  restoreTitleButtons(tr);
}

/* ==============================
   TITLE 전용 인라인 편집 함수 종료
================================= */
/* ===============================
   LENGTH 전용 인라인 편집 함수 시작
================================ */

/* ---------- 추가 (항상 맨 위) ---------- */
function addLengthRow(){
    const tbody = document.querySelector("#lengthTable tbody");
    if(!tbody) return;

    let insertRow = document.getElementById("lengthInsertRow");

    // 이미 있으면 포커스만
    if(insertRow){
        insertRow.querySelector("select").focus();
        return;
    }

    const optHTML = document.getElementById("lengthMasterOptions").innerHTML;

    insertRow = document.createElement("tr");
    insertRow.id = "lengthInsertRow";

    insertRow.innerHTML = `
        <td>
            <select class="form-select form-select-sm"
                    onkeydown="lengthInsertKey(event)">
                ${optHTML}
            </select>
        </td>
        <td>
            <input type="number" step="0.01"
                   class="form-control form-control-sm"
                   placeholder="Length"
                   onkeydown="lengthInsertKey(event)">
        </td>
        <td>-</td>
        <td>-</td>
        <td>
            <button class="btn btn-sm btn-success me-1"
                onclick="saveLengthInsert()"><i class="bi bi-check"></i></button>
            <button class="btn btn-sm btn-secondary"
                onclick="cancelLengthInsert()"><i class="bi bi-x"></i></button>
        </td>
    `;

    // 🔥 항상 맨 위
    tbody.insertBefore(insertRow, tbody.firstChild);
    insertRow.querySelector("select").focus();
}

/* ---------- 키 처리 ---------- */
function lengthInsertKey(e){
    if(e.key === "Enter") saveLengthInsert();
    if(e.key === "Escape") cancelLengthInsert();
}

/* ---------- 저장 (연속 입력) ---------- */
function saveLengthInsert(){
    const tr = document.getElementById("lengthInsertRow");
    if(!tr) return;

    const sel = tr.querySelector("select");
    const inp = tr.querySelector("input");

    const masterId   = sel.value;
    const masterName = sel.options[sel.selectedIndex]?.text || "";
    const lenVal     = inp.value.trim();

    if(!masterId){
        alert("Master를 선택하세요");
        sel.focus();
        return;
    }
    if(!lenVal){
        alert("Length를 입력하세요");
        inp.focus();
        return;
    }

    fetch("length/bom2_length_save.asp", {
        method: "POST",
        headers: { "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "master_id=" + encodeURIComponent(masterId) +
            "&length="   + encodeURIComponent(lenVal)
    })
    .then(r => r.text())
    .then(res => {
        // OK|newId
        if(res.indexOf("OK|") === 0){
            const newId = res.split("|")[1];
            appendLengthRow(newId, masterId, masterName, lenVal);

            // 🔥 연속 입력
            inp.value = "";
            sel.focus();
        }else{
            alert("저장 실패 : " + res);
        }
    });
}

/* ---------- insert 취소 ---------- */
function cancelLengthInsert(){
    const tr = document.getElementById("lengthInsertRow");
    if(tr) tr.remove();
}

/* ---------- 신규 row 즉시 반영 ---------- */
function appendLengthRow(id, masterId, masterName, lenVal){
    const tbody = document.querySelector("#lengthTable tbody");
    const insertRow = document.getElementById("lengthInsertRow");

    const tr = document.createElement("tr");
    tr.dataset.id     = id;
    tr.dataset.master = masterId;
    tr.dataset.length = lenVal;

    tr.innerHTML = `
        <td class="length-master-text">${escapeHtml(masterName)}</td>
        <td class="length-text">${escapeHtml(lenVal)}</td>
        <td class="length-midx">-</td>
        <td class="length-meidx">-</td>
        <td>
            <button class="btn btn-sm btn-outline-secondary"
                onclick="editLengthRow(this)">수정</button>
            <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
        </td>
    `;

    // 🔥 insertRow 바로 아래에 누적
    if(insertRow && insertRow.nextSibling){
        tbody.insertBefore(tr, insertRow.nextSibling);
    }else{
        tbody.appendChild(tr);
    }
}

/* ---------- 수정 ---------- */
function editLengthRow(btn){
    const tr = btn.closest("tr");

    const oldMaster = tr.dataset.master;
    const oldLen    = tr.dataset.length;

    tr.dataset.oldMaster = oldMaster;
    tr.dataset.oldLen    = oldLen;

    const optHTML = document.getElementById("lengthMasterOptions").innerHTML;

    tr.children[0].innerHTML = `
        <select class="form-select form-select-sm"
                onkeydown="lengthUpdateKey(event, this)">
            ${optHTML}
        </select>
    `;
    tr.querySelector("select").value = oldMaster;

    tr.children[1].innerHTML = `
        <input type="number" step="0.01"
               class="form-control form-control-sm"
               value="${escapeHtml(oldLen)}"
               onkeydown="lengthUpdateKey(event, this)">
    `;

    tr.children[4].innerHTML = `
        <button class="btn btn-sm btn-success me-1"
            onclick="saveLengthUpdate(this)"><i class="bi bi-check"></i></button>
        <button class="btn btn-sm btn-secondary"
            onclick="cancelLengthUpdate(this)"><i class="bi bi-x"></i></button>
    `;

    tr.querySelector("input").focus();
}

function lengthUpdateKey(e){
    if(e.key === "Enter") saveLengthUpdate(e.target);
    if(e.key === "Escape") cancelLengthUpdate(e.target);
}

/* ---------- 수정 저장 ---------- */
function saveLengthUpdate(el){
    const tr = el.closest("tr");

    const id  = tr.dataset.id;
    const sel = tr.querySelector("select");
    const inp = tr.querySelector("input");

    const masterId   = sel.value;
    const masterName = sel.options[sel.selectedIndex]?.text || "";
    const lenVal     = inp.value.trim();

    if(!masterId){
        alert("Master를 선택하세요");
        sel.focus();
        return;
    }
    if(!lenVal){
        alert("Length를 입력하세요");
        inp.focus();
        return;
    }

    fetch("length/bom2_length_update.asp", {
        method: "POST",
        headers: { "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "length_id=" + encodeURIComponent(id) +
            "&master_id=" + encodeURIComponent(masterId) +
            "&length=" + encodeURIComponent(lenVal)
    })
    .then(r => r.text())
    .then(res => {
        if(res === "OK"){
            tr.dataset.master = masterId;
            tr.dataset.length = lenVal;

            tr.children[0].innerHTML = `<span class="length-master-text">${escapeHtml(masterName)}</span>`;
            tr.children[1].innerHTML = `<span class="length-text">${escapeHtml(lenVal)}</span>`;

            restoreLengthButtons(tr);
        }else{
            alert("수정 실패 : " + res);
        }
    });
}

/* ---------- 수정 취소 ---------- */
function cancelLengthUpdate(el){
    const tr = el.closest("tr");

    const oldMaster = tr.dataset.oldMaster;
    const oldLen    = tr.dataset.oldLen;

    const optText =
        document.querySelector(
            `#lengthMasterOptions option[value="${oldMaster}"]`
        )?.text || "";

    tr.dataset.master = oldMaster;
    tr.dataset.length = oldLen;

    tr.children[0].innerHTML = `<span class="length-master-text">${escapeHtml(optText)}</span>`;
    tr.children[1].innerHTML = `<span class="length-text">${escapeHtml(oldLen)}</span>`;

    restoreLengthButtons(tr);

    delete tr.dataset.oldMaster;
    delete tr.dataset.oldLen;
}

/* ---------- 버튼 복원 ---------- */
function restoreLengthButtons(tr){
    tr.children[4].innerHTML = `
        <button class="btn btn-sm btn-outline-secondary"
            onclick="editLengthRow(this)">수정</button>
        <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
    `;
}

/* ===============================
   LENGTH 전용 인라인 편집 함수 종료
================================ */
/* ===============================
   MOLD 전용 인라인 편집 함수 (Master Select 포함)
================================ */

function addMoldRow(){
  const tbody = document.querySelector("#moldTable tbody");
  if(!tbody) return;

  let insertRow = document.getElementById("moldInsertRow");
  if(insertRow){
    insertRow.querySelector("select").focus();
    return;
  }

  const optHTML = document.getElementById("moldMasterOptions").innerHTML;

  insertRow = document.createElement("tr");
  insertRow.id = "moldInsertRow";

  insertRow.innerHTML = `
    <td>
      <select class="form-select form-select-sm" onkeydown="moldInsertKey(event)">
        ${optHTML}
      </select>
    </td>
    <td><input type="text" class="form-control form-control-sm" placeholder="금형번호" onkeydown="moldInsertKey(event)"></td>
    <td><input type="text" class="form-control form-control-sm" placeholder="금형명" onkeydown="moldInsertKey(event)"></td>
    <td><input type="number" class="form-control form-control-sm" placeholder="벤더ID" onkeydown="moldInsertKey(event)"></td>
    <td><input type="text" class="form-control form-control-sm" placeholder="CAD 경로" onkeydown="moldInsertKey(event)"></td>
    <td><input type="text" class="form-control form-control-sm" placeholder="이미지 경로" onkeydown="moldInsertKey(event)"></td>
    <td><input type="text" class="form-control form-control-sm" placeholder="메모" onkeydown="moldInsertKey(event)"></td>
    <td>-</td>
    <td>-</td>
    <td>
      <button class="btn btn-sm btn-success me-1" onclick="saveMoldInsert()"><i class="bi bi-check"></i></button>
      <button class="btn btn-sm btn-secondary" onclick="cancelMoldInsert()"><i class="bi bi-x"></i></button>
    </td>
  `;

  tbody.insertBefore(insertRow, tbody.firstChild);
  insertRow.querySelector("select").focus();
}

function deactivateMold(moldId){
  if(!moldId) return;

  if(!confirm("해당 금형을 비활성화하시겠습니까?")){
    return;
  }

  fetch("mold/bom2_mold_deactivate.asp", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "mold_id=" + encodeURIComponent(moldId)
  })
  .then(r => r.text())
  .then(res => {
    if(res === "OK"){
      alert("삭제되었습니다.");
      reloadCurrentTab(); // 또는 location.reload();
    }else{
      alert("처리 실패 : " + res);
    }
  });
}

function moldInsertKey(e){
  if(e.key === "Enter") saveMoldInsert();
  if(e.key === "Escape") cancelMoldInsert();
}

function saveMoldInsert(){
  const tr = document.getElementById("moldInsertRow");
  if(!tr) return;

  const sel = tr.querySelector("select");
  const master_id = sel.value;
  const master_text = sel.options[sel.selectedIndex]?.text || "";

  const inputs = tr.querySelectorAll("input");
  const mold_no   = inputs[0].value.trim();
  const mold_name = inputs[1].value.trim();
  const vender_id = inputs[2].value.trim();
  const cad_path  = inputs[3].value.trim();
  const img_path  = inputs[4].value.trim();
  const memo      = inputs[5].value.trim();

  if(!master_id){
    alert("Master를 선택하세요");
    sel.focus();
    return;
  }
  if(!mold_name){
    alert("금형명은 필수입니다");
    inputs[1].focus();
    return;
  }

  fetch("mold/bom2_mold_save.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "master_id=" + encodeURIComponent(master_id) +
      "&mold_no=" + encodeURIComponent(mold_no) +
      "&mold_name=" + encodeURIComponent(mold_name) +
      "&vender_id=" + encodeURIComponent(vender_id) +
      "&cad_path=" + encodeURIComponent(cad_path) +
      "&img_path=" + encodeURIComponent(img_path) +
      "&memo=" + encodeURIComponent(memo)
  })
  .then(r=>r.text())
  .then(res=>{
    if(res.indexOf("OK|") === 0){
      const newId = res.split("|")[1] || "";
      appendMoldRow(newId, master_id, master_text, mold_no, mold_name, vender_id, cad_path, img_path, memo);

      // 연속 입력
      sel.focus();
      inputs.forEach(i => i.value = "");
    }else{
      alert("저장 실패 : " + res);
    }
  });
}

function cancelMoldInsert(){
  const tr = document.getElementById("moldInsertRow");
  if(tr) tr.remove();
}

function appendMoldRow(id, master_id, master_text, mold_no, mold_name, vender_id, cad_path, img_path, memo){
  const tbody = document.querySelector("#moldTable tbody");
  const insertRow = document.getElementById("moldInsertRow");

  const tr = document.createElement("tr");
  tr.dataset.id = id;
  tr.dataset.master = master_id;

  tr.innerHTML = `
    <td class="mold-master-text">${escapeHtml(master_text)}</td>
    <td class="mold-no">${escapeHtml(mold_no)}</td>
    <td class="mold-name">${escapeHtml(mold_name)}</td>
    <td class="mold-vender">${escapeHtml(vender_id)}</td>
    <td class="mold-cad">${escapeHtml(cad_path)}</td>
    <td class="mold-img">${escapeHtml(img_path)}</td>
    <td class="mold-memo">${escapeHtml(memo)}</td>
    <td>-</td>
    <td>-</td>
    <td>
      <button class="btn btn-sm btn-outline-secondary" onclick="editMoldRow(this)">수정</button>
      <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
    </td>
  `;

  if(insertRow && insertRow.nextSibling){
    tbody.insertBefore(tr, insertRow.nextSibling);
  }else{
    tbody.appendChild(tr);
  }
}

function editMoldRow(btn){
  const tr = btn.closest("tr");
  const id = tr.dataset.id;

  // 기존 값 저장(취소용)
  tr.dataset.oldMasterText = tr.children[0].innerText.trim();
  tr.dataset.oldMaster = tr.dataset.master || "";
  tr.dataset.oldMoldNo = tr.children[1].innerText.trim();
  tr.dataset.oldMoldName = tr.children[2].innerText.trim();
  tr.dataset.oldVender = tr.children[3].innerText.trim();
  tr.dataset.oldCad = tr.children[4].innerText.trim();
  tr.dataset.oldImg = tr.children[5].innerText.trim();
  tr.dataset.oldMemo = tr.children[6].innerText.trim();

  const optHTML = document.getElementById("moldMasterOptions").innerHTML;

  tr.children[0].innerHTML = `
    <select class="form-select form-select-sm" onkeydown="moldUpdateKey(event)">
      ${optHTML}
    </select>
  `;
  tr.querySelector("select").value = tr.dataset.oldMaster;

  tr.children[1].innerHTML = `<input type="text" class="form-control form-control-sm" value="${escapeHtml(tr.dataset.oldMoldNo)}" onkeydown="moldUpdateKey(event)">`;
  tr.children[2].innerHTML = `<input type="text" class="form-control form-control-sm" value="${escapeHtml(tr.dataset.oldMoldName)}" onkeydown="moldUpdateKey(event)">`;
  tr.children[3].innerHTML = `<input type="number" class="form-control form-control-sm" value="${escapeHtml(tr.dataset.oldVender)}" onkeydown="moldUpdateKey(event)">`;
  tr.children[4].innerHTML = `<input type="text" class="form-control form-control-sm" value="${escapeHtml(tr.dataset.oldCad)}" onkeydown="moldUpdateKey(event)">`;
  tr.children[5].innerHTML = `<input type="text" class="form-control form-control-sm" value="${escapeHtml(tr.dataset.oldImg)}" onkeydown="moldUpdateKey(event)">`;
  tr.children[6].innerHTML = `<input type="text" class="form-control form-control-sm" value="${escapeHtml(tr.dataset.oldMemo)}" onkeydown="moldUpdateKey(event)">`;

  tr.children[9].innerHTML = `
    <button class="btn btn-sm btn-success me-1" onclick="saveMoldUpdate(this)"><i class="bi bi-check"></i></button>
    <button class="btn btn-sm btn-secondary" onclick="cancelMoldUpdate(this)"><i class="bi bi-x"></i></button>
  `;

  tr.querySelector("input").focus();
}

function moldUpdateKey(e){
  if(e.key === "Enter") saveMoldUpdate(e.target);
  if(e.key === "Escape") cancelMoldUpdate(e.target);
}

function saveMoldUpdate(el){
  const tr = el.closest("tr");
  const id = tr.dataset.id;

  const sel = tr.querySelector("select");
  const master_id = sel.value;
  const master_text = sel.options[sel.selectedIndex]?.text || "";

  const inputs = tr.querySelectorAll("input");
  const mold_no   = inputs[0].value.trim();
  const mold_name = inputs[1].value.trim();
  const vender_id = inputs[2].value.trim();
  const cad_path  = inputs[3].value.trim();
  const img_path  = inputs[4].value.trim();
  const memo      = inputs[5].value.trim();

  if(!master_id){
    alert("Master를 선택하세요");
    sel.focus();
    return;
  }
  if(!mold_name){
    alert("금형명은 필수입니다");
    inputs[1].focus();
    return;
  }

  fetch("mold/bom2_mold_update.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "mold_id=" + encodeURIComponent(id) +
      "&master_id=" + encodeURIComponent(master_id) +
      "&mold_no=" + encodeURIComponent(mold_no) +
      "&mold_name=" + encodeURIComponent(mold_name) +
      "&vender_id=" + encodeURIComponent(vender_id) +
      "&cad_path=" + encodeURIComponent(cad_path) +
      "&img_path=" + encodeURIComponent(img_path) +
      "&memo=" + encodeURIComponent(memo)
  })
  .then(r=>r.text())
  .then(res=>{
    if(res === "OK"){
      tr.dataset.master = master_id;

      tr.children[0].innerHTML = `<span class="mold-master-text">${escapeHtml(master_text)}</span>`;
      tr.children[1].innerHTML = `<span class="mold-no">${escapeHtml(mold_no)}</span>`;
      tr.children[2].innerHTML = `<span class="mold-name">${escapeHtml(mold_name)}</span>`;
      tr.children[3].innerHTML = `<span class="mold-vender">${escapeHtml(vender_id)}</span>`;
      tr.children[4].innerHTML = `<span class="mold-cad">${escapeHtml(cad_path)}</span>`;
      tr.children[5].innerHTML = `<span class="mold-img">${escapeHtml(img_path)}</span>`;
      tr.children[6].innerHTML = `<span class="mold-memo">${escapeHtml(memo)}</span>`;

      restoreMoldButtons(tr);
    }else{
      alert("수정 실패 : " + res);
    }
  });
}

function cancelMoldUpdate(el){
  const tr = el.closest("tr");

  tr.dataset.master = tr.dataset.oldMaster;

  tr.children[0].innerHTML = `<span class="mold-master-text">${escapeHtml(tr.dataset.oldMasterText)}</span>`;
  tr.children[1].innerHTML = `<span class="mold-no">${escapeHtml(tr.dataset.oldMoldNo)}</span>`;
  tr.children[2].innerHTML = `<span class="mold-name">${escapeHtml(tr.dataset.oldMoldName)}</span>`;
  tr.children[3].innerHTML = `<span class="mold-vender">${escapeHtml(tr.dataset.oldVender)}</span>`;
  tr.children[4].innerHTML = `<span class="mold-cad">${escapeHtml(tr.dataset.oldCad)}</span>`;
  tr.children[5].innerHTML = `<span class="mold-img">${escapeHtml(tr.dataset.oldImg)}</span>`;
  tr.children[6].innerHTML = `<span class="mold-memo">${escapeHtml(tr.dataset.oldMemo)}</span>`;

  restoreMoldButtons(tr);
}

function restoreMoldButtons(tr){
  tr.children[9].innerHTML = `
    <button class="btn btn-sm btn-outline-secondary" onclick="editMoldRow(this)">수정</button>
    <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
  `;
}
/* ===============================
   MOLD 전용 인라인 편집 함수 종료
================================ */
/* ===============================
   Surface 전용 인라인 편집 함수
================================ */

function addSurfaceRow(){
  const tbody = document.querySelector("#surfaceTable tbody");
  if(!tbody) return;

  let insertRow = document.getElementById("surfaceInsertRow");
  if(insertRow){
    insertRow.querySelector("select").focus();
    return;
  }

  const optHTML = document.getElementById("surfaceMasterOptions").innerHTML;

  insertRow = document.createElement("tr");
  insertRow.id = "surfaceInsertRow";

  insertRow.innerHTML = `
    <td>
      <select class="form-select form-select-sm"
              onkeydown="surfaceInsertKey(event)">
        ${optHTML}
      </select>
    </td>
    <td>
      <input type="text" class="form-control form-control-sm"
             placeholder="Surface 명"
             onkeydown="surfaceInsertKey(event)">
    </td>
    <td>
      <input type="text" class="form-control form-control-sm"
             placeholder="Surface Code"
             onkeydown="surfaceInsertKey(event)">
    </td>
    <td>
      <input type="text" class="form-control form-control-sm"
             placeholder="Vender ID"
             onkeydown="surfaceInsertKey(event)">
    </td>
    <td>
      <input type="text" class="form-control form-control-sm"
             placeholder="메모"
             onkeydown="surfaceInsertKey(event)">
    </td>
    <td>-</td>
    <td>-</td>
    <td>
      <button class="btn btn-sm btn-success me-1"
        onclick="saveSurfaceInsert()"><i class="bi bi-check"></i></button>
      <button class="btn btn-sm btn-secondary"
        onclick="cancelSurfaceInsert()"><i class="bi bi-x"></i></button>
    </td>
  `;

  tbody.insertBefore(insertRow, tbody.firstChild);
  insertRow.querySelector("select").focus();
}

/* ===============================
   INSERT 키 처리
================================ */
function surfaceInsertKey(e){
  if(e.key === "Enter"){
    e.preventDefault();
    saveSurfaceInsert();
    return false;
  }
  if(e.key === "Escape"){
    e.preventDefault();
    cancelSurfaceInsert();
    return false;
  }
}

function saveSurfaceInsert(){
  const tr = document.getElementById("surfaceInsertRow");
  if(!tr) return;

  const sel = tr.querySelector("select");
  const master_id = sel.value;
  const master_text = sel.options[sel.selectedIndex]?.text || "";

  const inputs = tr.querySelectorAll("input");
  const surface_name = inputs[0].value.trim();
  const surface_code = inputs[1].value.trim();
  const vender_id    = inputs[2].value.trim();
  const memo         = inputs[3].value.trim();

  if(!master_id){
    alert("Master를 선택하세요");
    sel.focus();
    return;
  }
  if(!surface_name){
    alert("Surface 명은 필수입니다");
    inputs[0].focus();
    return;
  }

  fetch("surface/bom2_surface_save.asp",{
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "master_id=" + encodeURIComponent(master_id) +
      "&surface_name=" + encodeURIComponent(surface_name) +
      "&surface_code=" + encodeURIComponent(surface_code) +
      "&vender_id=" + encodeURIComponent(vender_id) +
      "&memo=" + encodeURIComponent(memo)
  })
  .then(r=>r.text())
.then(res=>{
  if(res.indexOf("OK|") === 0){
    const newId = res.split("|")[1];

    appendSurfaceRow(
      newId,
      master_id,
      master_text,
      surface_name,
      surface_code,
      vender_id,
      memo
    );

    // ✅ 연속 입력 처리
    const inputs = tr.querySelectorAll("input");
    inputs.forEach(i => i.value = "");
    inputs[0].focus();   // Surface 명으로 포커스
  }else{
    alert("저장 실패 : " + res);
  }
});
}

function cancelSurfaceInsert(){
  const tr = document.getElementById("surfaceInsertRow");
  if(tr) tr.remove();
}

function appendSurfaceRow(id, master_id, master_text, name, code, vender, memo){
  const tbody = document.querySelector("#surfaceTable tbody");
  const insertRow = document.getElementById("surfaceInsertRow");

  const tr = document.createElement("tr");
  tr.dataset.id = id;
  tr.dataset.master = master_id;

  tr.innerHTML = `
    <td class="surface-master-text">${escapeHtml(master_text)}</td>
    <td class="surface-name">${escapeHtml(name)}</td>
    <td class="surface-code">${escapeHtml(code || "-")}</td>
    <td class="surface-vender">${escapeHtml(vender || "-")}</td>
    <td class="surface-memo">${escapeHtml(memo || "")}</td>
    <td>-</td>
    <td>-</td>
    <td>
      <button class="btn btn-sm btn-outline-secondary"
        onclick="editSurfaceRow(this)">수정</button>
      <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
    </td>
  `;

  // ✅ 입력 row 바로 아래에 추가
  if (insertRow && insertRow.nextSibling) {
    tbody.insertBefore(tr, insertRow.nextSibling);
  } else {
    tbody.appendChild(tr);
  }
}


/* ===============================
   EDIT / UPDATE
================================ */
function editSurfaceRow(btn){
  const tr = btn.closest("tr");

  tr.dataset.oldMaster = tr.dataset.master;
  tr.dataset.oldMasterText = tr.querySelector(".surface-master-text").innerText;
  tr.dataset.oldName   = tr.querySelector(".surface-name").innerText;
  tr.dataset.oldCode   = tr.querySelector(".surface-code").innerText;
  tr.dataset.oldVender = tr.querySelector(".surface-vender").innerText;
  tr.dataset.oldMemo   = tr.querySelector(".surface-memo").innerText;

  const optHTML = document.getElementById("surfaceMasterOptions").innerHTML;

  tr.querySelector(".surface-master-text").innerHTML =
    `<select class="form-select form-select-sm"
             onkeydown="surfaceUpdateKey(event)">${optHTML}</select>`;
  tr.querySelector("select").value = tr.dataset.oldMaster;

  tr.querySelector(".surface-name").innerHTML =
    `<input class="form-control form-control-sm"
            value="${escapeHtml(tr.dataset.oldName)}"
            onkeydown="surfaceUpdateKey(event)">`;

  tr.querySelector(".surface-code").innerHTML =
    `<input class="form-control form-control-sm"
            value="${escapeHtml(tr.dataset.oldCode)}"
            onkeydown="surfaceUpdateKey(event)">`;

  tr.querySelector(".surface-vender").innerHTML =
    `<input class="form-control form-control-sm"
            value="${escapeHtml(tr.dataset.oldVender)}"
            onkeydown="surfaceUpdateKey(event)">`;

  tr.querySelector(".surface-memo").innerHTML =
    `<input class="form-control form-control-sm"
            value="${escapeHtml(tr.dataset.oldMemo)}"
            onkeydown="surfaceUpdateKey(event)">`;

  tr.lastElementChild.innerHTML = `
    <button class="btn btn-sm btn-success me-1"
      onclick="saveSurfaceUpdate(this)"><i class="bi bi-check"></i></button>
    <button class="btn btn-sm btn-secondary"
      onclick="cancelSurfaceUpdate(this)"><i class="bi bi-x"></i></button>
  `;
}

function saveSurfaceUpdate(btn){
  const tr = btn.closest("tr");
  const id = tr.dataset.id;

  const sel = tr.querySelector("select");
  const master_id = sel.value;
  const master_text = sel.options[sel.selectedIndex]?.text || "";

  const inputs = tr.querySelectorAll("input");
  const surface_name = inputs[0].value.trim();
  const surface_code = inputs[1].value.trim();
  const vender_id    = inputs[2].value.trim();
  const memo         = inputs[3].value.trim();

  if(!master_id || !surface_name){
    alert("Master와 Surface 명은 필수입니다");
    return;
  }

  fetch("surface/bom2_surface_update.asp",{
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "surface_id=" + encodeURIComponent(id) +
      "&master_id=" + encodeURIComponent(master_id) +
      "&surface_name=" + encodeURIComponent(surface_name) +
      "&surface_code=" + encodeURIComponent(surface_code) +
      "&vender_id=" + encodeURIComponent(vender_id) +
      "&memo=" + encodeURIComponent(memo)
  })
  .then(r=>r.text())
  .then(res=>{
    if(res === "OK"){
      tr.dataset.master = master_id;
      tr.querySelector(".surface-master-text").innerText = master_text;
      tr.querySelector(".surface-name").innerText = surface_name;
      tr.querySelector(".surface-code").innerText = surface_code || "-";
      tr.querySelector(".surface-vender").innerText = vender_id || "-";
      tr.querySelector(".surface-memo").innerText = memo || "";
      restoreSurfaceButtons(tr);
    }else{
      alert("수정 실패 : " + res);
    }
  });
}

function cancelSurfaceUpdate(btn){
  const tr = btn.closest("tr");

  tr.dataset.master = tr.dataset.oldMaster;
  tr.querySelector(".surface-master-text").innerText = tr.dataset.oldMasterText;
  tr.querySelector(".surface-name").innerText = tr.dataset.oldName;
  tr.querySelector(".surface-code").innerText = tr.dataset.oldCode;
  tr.querySelector(".surface-vender").innerText = tr.dataset.oldVender;
  tr.querySelector(".surface-memo").innerText = tr.dataset.oldMemo;

  restoreSurfaceButtons(tr);
}

function restoreSurfaceButtons(tr){
  tr.lastElementChild.innerHTML = `
    <button class="btn btn-sm btn-outline-secondary"
      onclick="editSurfaceRow(this)">수정</button>
    <button class="btn btn-sm btn-outline-danger" disabled>삭제</button>
  `;
}

/* ===============================
   UPDATE 키 처리
================================ */
function surfaceUpdateKey(e){
  if(e.key === "Enter"){
    e.preventDefault();
    const btn = e.target.closest("tr")
      .querySelector("button.btn-success");
    if(btn) btn.click();
    return false;
  }
  if(e.key === "Escape"){
    e.preventDefault();
    const btn = e.target.closest("tr")
      .querySelector("button.btn-secondary");
    if(btn) btn.click();
    return false;
  }
}

window.deactivateSurface = function(surfaceId){
  if(!surfaceId) return;

  if(!confirm("해당 표면처리를 비활성화하시겠습니까?\n(데이터는 삭제되지 않습니다)")){
    return;
  }

  fetch("surface/bom2_surface_deactivate.asp", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: "surface_id=" + encodeURIComponent(surfaceId)
  })
  .then(r => r.text())
  .then(res => {
    if(res === "OK"){
      alert("비활성화되었습니다.");
      reloadCurrentTab(); // 탭 구조 유지
    }else{
      alert("처리 실패 : " + res);
    }
  });
}

/* ===============================
   Surface 전용 인라인 편집 함수 종료
================================ */
/* ===============================
   material 전용 인라인 편집 함수 종료
================================ */

function openDeactivate(type, id){
  window.open(
    "common/deactivate_popup.asp?type=" + type + "&id=" + id,
    "deactivatePopup",
    "width=520,height=600"
  );
}

// 마테리얼 팝업
function openMaterialPopup(masterId, is_active){
  if (Number(is_active) !== 1) {
    alert("중지된 항목은 Material을 열 수 없습니다.");
    return;
  }

  const w = 1400;
  const h = 900;
  const left = (screen.width - w) / 2;
  const top  = (screen.height - h) / 2;

  window.open(
    "/TNG_bom/bom2/material/bom2_material_list.asp?master_id=" + masterId,
    "materialPopup",
    `width=${w},height=${h},left=${left},top=${top},resizable=yes,scrollbars=yes`
  );
}
</script>



</body>
</html>

<%
call DbClose()
%>
