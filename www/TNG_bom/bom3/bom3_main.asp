<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->

<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"

call DbOpen()

Dim Rs
Set Rs = Server.CreateObject("ADODB.Recordset")


Dim RsSub, sqlSub
Set RsSub = Server.CreateObject("ADODB.Recordset")

sqlSub = _
"SELECT list_title_id, title_name " & _
"FROM bom3_list_title " & _
"WHERE is_sub = 1 " & _
"AND is_active = 1 " & _
"ORDER BY list_title_id"

RsSub.Open sqlSub, Dbcon
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BOM3 관리</title>
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

.material-icon{
  margin-left:6px;
  font-size:14px;
  color:#0d6efd;
  cursor:pointer;
  vertical-align:middle;
}
.material-icon:hover{
  color:#084298;
}
</style>
</head>

<body class="sb-nav-fixed" style="margin-left : 300px;">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div class="container-fluid px-4" style="margin-top:80px;">

    <!-- 🔥 상단 탭 영역 -->
    <div id="tabArea" class="d-flex flex-wrap gap-2">

        <!-- 기본 탭 -->
        <div class="tab-btn active"
             data-url="master/bom3_master_list.asp">
            카테고리
        </div>

        <div class="tab-btn"
             data-url="origin/bom3_origin_list.asp">
            원산구분
        </div>

        <div class="tab-btn"
             data-url="title/bom3_title_list.asp">
            타이틀 관리
        </div>

        <!-- 🔹 title_sub 탭 -->
        <%
        If Not RsSub.EOF Then
            Do While Not RsSub.EOF
        %>
<div class="tab-btn"
     data-url="title/bom3_title_sub_value_list.asp?list_title_id=<%=RsSub("list_title_id")%>">
    <%=RsSub("title_name")%>
</div>
        <%
                RsSub.MoveNext
            Loop
        End If
        %>

    </div>

    <!-- 🔥 AJAX 콘텐츠 영역 -->
    <div id="contentBox" class="panel-box">
        <div class="text-muted">로딩중...</div>
    </div>

</div>


<%
' ===== ORIGIN 목록 조회 =====
Dim RsOrigin, sqlOrigin
Set RsOrigin = Server.CreateObject("ADODB.Recordset")

sqlOrigin = "SELECT origin_type_no, origin_name FROM bom3_origin_type ORDER BY origin_type_no"
RsOrigin.Open sqlOrigin, Dbcon

Dim RsMaster, RsType
Set RsMaster = Server.CreateObject("ADODB.Recordset")
Set RsType   = Server.CreateObject("ADODB.Recordset")

RsMaster.Open _
"SELECT master_id, item_name FROM bom3_master WHERE is_active=1 ORDER BY item_name", Dbcon

RsType.Open _
"SELECT type_id, type_name FROM bom3_title_type ORDER BY type_id", Dbcon

%>


<script>
console.log("??")
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
console.log("ORIGIN_LIST",ORIGIN_LIST)

const MASTER_LIST = [
<%
Dim firstM
firstM = True

If Not RsMaster.EOF Then
    Do While Not RsMaster.EOF
        If Not firstM Then Response.Write "," & vbCrLf
        firstM = False
%>
{
    id: <%=RsMaster("master_id")%>,
    name: "<%=Replace(RsMaster("item_name"),"""","\""")%>"
}
<%
        RsMaster.MoveNext
    Loop
End If
%>
];

const TYPE_LIST = [
<%
Dim firstT
firstT = True

If Not RsType.EOF Then
    Do While Not RsType.EOF
        If Not firstT Then Response.Write "," & vbCrLf
        firstT = False
%>
{
    id: <%=RsType("type_id")%>,
    name: "<%=Replace(RsType("type_name"),"""","\""")%>"
}
<%
        RsType.MoveNext
    Loop
End If
%>
];
function getTypeOptions(selected){
    let html = `<option value="">선택</option>`;
    TYPE_LIST.forEach(t=>{
        html += `<option value="${t.id}" ${selected==t.id?"selected":""}>
                    ${t.name}
                 </option>`;
    });
    return html;
}

function getMasterOptions(selected){
    let html = `<option value="">선택</option>`;
    MASTER_LIST.forEach(m=>{
        html += `<option value="${m.id}" ${selected==m.id?"selected":""}>
                    ${m.name}
                 </option>`;
    });
    return html;
}

$(function(){
  const url = sessionStorage.getItem("afterReloadTabUrl");

  if(url){
    sessionStorage.removeItem("afterReloadTabUrl");

    // ✅ 탭 active도 맞추고 content 로드
    $(".tab-btn").removeClass("active");
    const btn = document.querySelector(`.tab-btn[data-url="${url}"]`);
    if(btn) btn.classList.add("active");

    loadContent(url, function(){
      // ✅ (선택) 리로드 후 연속입력까지 원하면
      if(sessionStorage.getItem("afterReloadOpenTitleAdd") === "1"){
        sessionStorage.removeItem("afterReloadOpenTitleAdd");
        openTitleAdd();
      }
    });

  }else{
    // 기존 기본 진입
    loadContent("master/bom3_master_list.asp");
  }
});


//탭 클릭
$(document).on("click", ".tab-btn", function(){
    $(".tab-btn").removeClass("active");
    $(this).addClass("active");

    const url = $(this).data("url");
    loadContent(url);
});

function loadContent(url, done){
  $("#contentBox").html(`<div class="text-muted">로딩중...</div>`);

  fetch(url)
    .then(res => res.text())
    .then(html => {
      $("#contentBox").html(html);
      if(typeof done === "function") done();   // ✅ 로딩 완료 후
    })
    .catch(() => {
      $("#contentBox").html(`<div class="text-danger">불러오기 실패</div>`);
    });
}

function reloadCurrentTab(done){
  const active = document.querySelector(".tab-btn.active");
  if(!active) return;

  const url = active.dataset.url;
  if(url) loadContent(url, done);             // ✅ 여기서 콜백 전달
}


function escapeHtml(str){
    return (str ?? "").toString()
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


//원산구분 시작 ********************************************


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

function titleInsertKey(e){
  if(e.key === "Enter"){
    e.preventDefault();
    const tr = e.target.closest("tr");
    const btn = tr?.querySelector(".js-title-insert-save");
    if(btn) btn.click();
  }

  if(e.key === "Escape"){
    e.preventDefault();
    const tr = e.target.closest("tr");
    if(tr && tr.id === "titleInsertRow"){
      tr.remove();
    }else{
      cancelTitleEdit(e.target);
    }
  }
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

  fetch("origin/bom3_origin_save.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:"origin_name=" + encodeURIComponent(val)
  })
  .then(r => r.text())
  .then(res => {
    res = (res || "").trim();
    console.log("server res:", res);

    if(res.indexOf("OK|") === 0){
      const newId = (res.split("|")[1] || "").trim();
      appendOriginRow(newId, val);     // ✅ data-id 들어감
      input.value = "";
      input.focus();
      return;
    }

    if(res === "DUPLICATE"){ alert("이미 등록된 원산구분명입니다."); return; }
    if(res === "EMPTY"){ alert("값을 입력하세요"); return; }

    alert("저장 실패: " + res);
  });
}




/* ---------- insert 취소 ---------- */
function cancelOriginInsert(){
    const tr = document.getElementById("originInsertRow");
    if(tr) tr.remove();
}

/* ---------- 신규 row 즉시 반영 ---------- */
function appendOriginRow(id, name){
  const tbody = document.querySelector("#originTable tbody");
  const insertRow = document.getElementById("originInsertRow");

  const tr = document.createElement("tr");
  tr.dataset.id = String(id);                 // ✅ update 때 사용
  tr.setAttribute("data-id", String(id));     // ✅(선택)

  tr.innerHTML = `
    <td class="origin-text">${escapeHtml(name)}</td>
    <td>
      <button class="btn btn-sm btn-outline-secondary"
              onclick="editOriginRow(this)">수정</button>
    </td>
  `;

  if(insertRow && insertRow.nextSibling) tbody.insertBefore(tr, insertRow.nextSibling);
  else tbody.appendChild(tr);
}



/* ---------- 수정 (기존 로직 유지) ---------- */
function editOriginRow(btn){
    const tr = btn.closest("tr");
    const td = tr.querySelector(".origin-text");
    const oldText = td.innerText.trim();
    console.log("tr",tr)
    console.log("oldText",oldText)


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
  const id = tr.dataset.id || tr.getAttribute("data-id");

  const input = tr.querySelector("input");
  const val = input.value.trim();

  console.log("tr",tr)
  console.log("DEBUG update id=", id, "val=", val);

  if(!id || !/^\d+$/.test(String(id))){
    alert("INVALID_ID: 이 행에 data-id가 없습니다. (추가 직후라면 서버 OK|id 확인)");
    return;
  }

  if(!val){
    alert("값을 입력하세요");
    input.focus();
    return;
  }

  fetch("origin/bom3_origin_update.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:"origin_type_no=" + encodeURIComponent(id) +
         "&origin_name=" + encodeURIComponent(val)
  })
  .then(r=>r.text())
  .then(res=>{
    res = (res || "").trim();
    console.log("res", res);

    if(res === "OK"){
      tr.querySelector(".origin-text").innerText = val;
      restoreOriginButtons(tr);
    }else{
      alert("수정 실패 : " + res);
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
    `;
}

//master 부분 ************************************************
/* ===============================
   master 전용 인라인 편집 함수 시작
================================ */
let MASTER_EDITING = false;

function openMasterAdd(){
    const tbody = document.querySelector("#masterTable tbody");
    if(!tbody) return;

    // ✅ 원산구분 리스트가 "선택"만 있는지 체크
    const originHtml = getOriginOptions("");
    const temp = document.createElement("select");
    temp.innerHTML = originHtml;

    // value가 빈 값이 아닌 옵션(실제 데이터)이 있는지 검사
    const hasRealOrigin = Array.from(temp.options).some(op => (op.value || "").trim() !== "");

    // ✅ 실제 옵션이 하나도 없으면(= '선택'만 있으면) 알럿
    if(!hasRealOrigin){
        alert("원산구분을 먼저 생성해주세요.");
        return;
    }

    let insertRow = document.getElementById("masterInsertRow");
    if(insertRow){
        insertRow.querySelector("input").focus();
        return;
    }

    insertRow = document.createElement("tr");
    insertRow.id = "masterInsertRow";

    insertRow.innerHTML = `
        <td>
            <input type="text" class="form-control form-control-sm"
                   placeholder="품번"
                   onkeydown="masterInsertKey(event)">
        </td>

        <td>
            <input type="text" class="form-control form-control-sm"
                   placeholder="품목명"
                   onkeydown="masterInsertKey(event)">
        </td>

        <td>
            <select class="form-select form-select-sm"
                    onkeydown="masterInsertKey(event)">
                ${originHtml}
            </select>
        </td>

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

    const itemNo    = tr.querySelector("td:nth-child(1) input").value.trim();
    const name      = tr.querySelector("td:nth-child(2) input").value.trim();
    const origin    = tr.querySelector("td:nth-child(3) select").value;
    const is_active = tr.querySelector("td:nth-child(4) select").value;

    if(!itemNo || !name){
        alert("품번과 품목명을 입력하세요");
        return;
    }

    if(!origin){
        alert("원산구분을 선택하세요");
        return;
    }

    fetch("master/bom3_master_save.asp", {
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


function getIsActiveFromTr(tr){
  const txt = tr.querySelector(".master-status")?.innerText.trim();
  return (txt === "사용") ? 1 : 0;
}

function renderMasterNameCell(tr, name){
  const masterId = tr.dataset.id;
  const isActive = getIsActiveFromTr(tr);

  tr.querySelector(".master-name").innerHTML = `
    <span onclick="openMaterialPopup(${masterId}, ${isActive})">${escapeHtml(name)}</span>
    <i class="bi bi-box-seam material-icon"
       title="자재(Material) 관리"
       onclick="event.stopPropagation(); openMaterialPopup(${masterId}, ${isActive})"></i>
  `;
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

    // ✅ 아이콘 포함 원본 HTML 저장 (이게 핵심)
    tr.dataset.oldNameHtml = tr.querySelector(".master-name").innerHTML;

    tr.dataset.oldName   = tr.querySelector(".master-name").innerText;
    tr.dataset.oldOrigin = tr.querySelector(".master-origin").dataset.originId;

    tr.dataset.oldStatusText =
      tr.querySelector(".master-status").innerText.trim();

    tr.querySelector(".master-name").innerHTML = `
        <input type="text" class="form-control form-control-sm"
               value="${tr.dataset.oldName}"
               onclick="event.stopPropagation()"
               onkeydown="masterUpdateKey(event, this)">
    `;

    tr.querySelector(".master-origin").innerHTML = `
        <select class="form-select form-select-sm">
            ${getOriginOptions(tr.dataset.oldOrigin)}
        </select>
    `;

    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-success me-1"
            onclick="saveMasterUpdate(this)"><i class="bi bi-check"></i></button>
        <button class="btn btn-sm btn-secondary"
            onclick="cancelMasterUpdate(this)"><i class="bi bi-x"></i></button>
    `;
}

function getOriginNameById(id){
    const o = ORIGIN_LIST.find(x=>x.id==id);
    return o ? o.name : "";
}


function saveMasterUpdate(btn){
    const tr = btn.closest("tr");
    const masterId = tr.dataset.id;

    const itemNo = tr.querySelector("td:first-child").innerText.trim();
    const name   = tr.querySelector(".master-name input").value.trim();
    const origin = tr.querySelector(".master-origin select").value;
    
    console.log("itemNo",itemNo)
    console.log("name",name)
    console.log("origin",origin)



    if(!itemNo || !name){
        alert("품번과 품목명을 입력하세요");
        return;
    }

    fetch("master/bom3_master_update.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "master_id=" + masterId +
            "&item_no=" + encodeURIComponent(itemNo) +
            "&item_name=" + encodeURIComponent(name) +
            "&origin_type_no=" + origin
    })
    .then(r=>r.text())
    .then(res=>{
        if(res === "OK"){
            MASTER_EDITING = false;

            tr.querySelector("td:first-child").innerText = itemNo;

            renderMasterNameCell(tr, name);

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

    // ✅ 아이콘 포함 원본 HTML로 복원
    tr.querySelector(".master-name").innerHTML = tr.dataset.oldNameHtml;

    tr.querySelector(".master-origin").innerText = getOriginNameById(tr.dataset.oldOrigin);
    tr.querySelector(".master-origin").dataset.originId = tr.dataset.oldOrigin;

    tr.querySelector(".master-status").innerText = tr.dataset.oldStatusText;

    restoreMasterButtons(tr);

    delete tr.dataset.oldNameHtml;
}


function openDeactivate(type, id){

  window.open(

    "common/deactivate_popup.asp?type=" + type + "&id=" + id,

    "deactivatePopup",

    "width=520,height=600"

  );

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
   타이틀 추가
================================ */
function openTitleAdd(){
    const tbody = document.querySelector("#titleTable tbody");
    if(!tbody) return;

    if(document.getElementById("titleInsertRow")){
        document.querySelector("#titleInsertRow input")?.focus();
        return;
    }

    const tr = document.createElement("tr");
    tr.id = "titleInsertRow";

    tr.innerHTML = `
        <td>
        <select class="form-select form-select-sm"
                onkeydown="titleInsertKey(event)">
            ${getMasterOptions("")}
        </select>
        </td>

        <td>
            <input class="form-control form-control-sm"
                   placeholder="타이틀명"
                   onkeydown="titleInsertKey(event)">
        </td>
        <td class="text-center">
            <input type="checkbox" class="title-ck title-ck-a"
                    onchange="toggleExclusiveCheckbox(this)">
        </td>

        <td class="text-center">
            <input type="checkbox" class="title-ck title-ck-b"
                    onchange="toggleExclusiveCheckbox(this)">
        </td>
        <td>
            <select class="form-select form-select-sm"
                    onkeydown="titleInsertKey(event)">
                ${getTypeOptions("")}
            </select>
        </td>

        <td>
            <input class="form-control form-control-sm"
                   placeholder="단위"
                   onkeydown="titleInsertKey(event)">
        </td>

        <td class="text-center">
            <button class="btn btn-sm btn-success me-1 js-title-insert-save"
                    onclick="saveTitleInsert(this)">✔</button>
            <button class="btn btn-sm btn-secondary"
                    onclick="this.closest('tr').remove()">✖</button>
        </td>
    `;

    tbody.insertBefore(tr, tbody.firstChild);
    tr.querySelector("input")?.focus();
}


function toggleExclusiveCheckbox(chk){
  const tr = chk.closest("tr");
  if(!tr) return;

  const ckSub    = tr.querySelector(".title-ck-a"); // SUB
  const ckCommon = tr.querySelector(".title-ck-b"); // 공통

  // 1) 둘 중 하나만 체크되게
  if(chk.checked){
    [ckSub, ckCommon].forEach(c => { if(c && c !== chk) c.checked = false; });
  }

  // 2) 컨트롤들
  const selMaster = tr.children[0].querySelector("select");
  const selType   = tr.children[4].querySelector("select");
  const inpDense  = tr.children[5].querySelector("input");

  // 3) 기본 활성화
  selMaster.disabled = false;
  selType.disabled   = false;
  inpDense.disabled  = false;

  // ✅ 4) 체크박스가 하나라도 체크되면 MASTER는 "선택"으로 초기화
  const anyChecked = (ckSub && ckSub.checked) || (ckCommon && ckCommon.checked);
  if(anyChecked){
    selMaster.value = ""; // <option value="">선택</option> 로 돌아감
  }

  // 5) 조건별 disabled
  if(ckSub && ckSub.checked){
    // SUB면 MASTER/타입/단위 비활성화 (+ 값도 초기화하고 싶으면 아래 2줄 추가)
    // selType.value = "";
    // inpDense.value = "";
    selMaster.disabled = true;
    selType.disabled   = true;
    inpDense.disabled  = true;

  }else if(ckCommon && ckCommon.checked){
    // 공통이면 MASTER만 비활성화
    selMaster.disabled = true;
  }
}


function saveTitleInsert(btn){
  const tr = btn.closest("tr");

  const masterId = tr.children[0].querySelector("select").value;
  const title    = tr.children[1].querySelector("input").value.trim();
  const isSub    = tr.children[2].querySelector("input").checked ? 1 : 0;
  const isCommon = tr.children[3].querySelector("input").checked ? 1 : 0;
  const typeId   = tr.children[4].querySelector("select").value;
  const density  = tr.children[5].querySelector("input").value.trim();

  // ✅ validation
  if(!title){
    alert("타이틀명을 입력하세요");
    tr.children[1].querySelector("input").focus();
    return;
  }

  if(isSub){
    // SUB: title만 필수
  }else if(isCommon){
    if(!typeId){
      alert("타입을 선택하세요");
      tr.children[4].querySelector("select").focus();
      return;
    }
  }else{
    if(!masterId){
      alert("마스터를 선택하세요");
      tr.children[0].querySelector("select").focus();
      return;
    }
    if(!typeId){
      alert("타입을 선택하세요");
      tr.children[4].querySelector("select").focus();
      return;
    }
  }

  fetch("title/bom3_title_save.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "master_id=" + encodeURIComponent(masterId) +
      "&title_name=" + encodeURIComponent(title) +
      "&is_sub=" + isSub +
      "&is_common=" + isCommon +
      "&type_id=" + encodeURIComponent(typeId) +
      "&density=" + encodeURIComponent(density)
  })
  .then(r=>r.text())
  .then(res=>{
    res = (res || "").trim();

    // ✅ SUB 저장: 탭 버튼 갱신 필요 → 전체 리로드 + 복귀/연속입력 플래그 저장
    if(res === "OK_SUB"){
      sessionStorage.setItem("afterReloadTabUrl", "title/bom3_title_list.asp");
      sessionStorage.setItem("afterReloadOpenTitleAdd", "1"); // 연속입력 원하면
      window.location.reload();
      return;
    }

    // ✅ 일반 저장: 현재 탭만 reload 후 입력행 다시 생성
    if(res === "OK"){
      reloadCurrentTab(() => {
        openTitleAdd();
        document.querySelector("#titleInsertRow input")?.focus();
      });
      return;
    }

    // ❌ 그 외
    alert("저장 실패 : " + res);
    tr.children[1].querySelector("input")?.focus();
  })
  .catch(err=>{
    console.log(err);
    alert("저장 중 오류");
    tr.children[1].querySelector("input")?.focus();
  });
}

function editTitleRow(btn){
  const tr = btn.closest("tr");
  tr.dataset.oldHtml = tr.innerHTML;

  const oldMasterId = tr.querySelector(".master-name")?.dataset.master || "";
  const oldTitle    = tr.querySelector(".title-name")?.innerText.trim() || "";
  const oldTypeId   = tr.querySelector(".type-name")?.dataset.typeId || "";
  const oldDensity  = tr.querySelector(".density")?.innerText.trim() || "";

  const isSub    = tr.children[2].innerText.trim() === "SUB";
  const isCommon = tr.children[3].innerText.trim() === "공통";

  tr.dataset.mode = isSub ? "sub" : (isCommon ? "common" : "normal");

  // MASTER
  tr.children[0].innerHTML = `
    <select class="form-select form-select-sm">
      ${getMasterOptions(oldMasterId)}
    </select>
  `;

  // TITLE
  tr.children[1].innerHTML = `
    <input class="form-control form-control-sm"
           value="${escapeHtml(oldTitle)}">
  `;

  // TYPE
  tr.children[4].innerHTML = `
    <select class="form-select form-select-sm">
      ${getTypeOptions(oldTypeId)}
    </select>
  `;

  // DENSITY
  tr.children[5].innerHTML = `
    <input class="form-control form-control-sm"
           value="${escapeHtml(oldDensity)}">
  `;

  const selMaster = tr.children[0].querySelector("select");
  const selType   = tr.children[4].querySelector("select");
  const inpDense  = tr.children[5].querySelector("input");

  if(isSub){
    selMaster.disabled = true;
    selType.disabled   = true;
    inpDense.disabled  = true;
  }else if(isCommon){
    selMaster.disabled = true;
  }

  tr.children[6].innerHTML = `
    <button class="btn btn-sm btn-success me-1"
            onclick="saveTitleUpdate(this)">✔</button>
    <button class="btn btn-sm btn-secondary"
            onclick="cancelTitleEdit(this)">✖</button>
  `;
}

function cancelTitleEdit(el){
  const tr = el.closest("tr");
  if(tr && tr.dataset.oldHtml){
    tr.innerHTML = tr.dataset.oldHtml;
    delete tr.dataset.oldHtml;
    delete tr.dataset.mode;
  }
}

function getTypeNameById(id){
  id = String(id);
  const t = TYPE_LIST.find(x => String(x.id) === id);
  return t ? t.name : "";
}

function saveTitleUpdate(el){
  const tr = el.closest("tr");
  const id = tr.dataset.id;
  const mode = tr.dataset.mode || "normal"; // "sub" | "common" | "normal"

  const masterId  = tr.querySelector("td:nth-child(1) select")?.value || "";
  const titleName = tr.querySelector("td:nth-child(2) input")?.value.trim() || "";
  const typeId    = tr.querySelector("td:nth-child(5) select")?.value || "";
  const density   = tr.querySelector("td:nth-child(6) input")?.value.trim() || "";

  if (!titleName) {
    alert("타이틀명을 입력해주세요.");
    tr.querySelector("td:nth-child(2) input")?.focus();
    return;
  }

  if (mode !== "sub") {
    if (!typeId) {
      alert("타입을 선택해주세요.");
      tr.querySelector("td:nth-child(5) select")?.focus();
      return;
    }
    if (mode === "normal" && !masterId) {
      alert("MASTER를 선택해주세요.");
      tr.querySelector("td:nth-child(1) select")?.focus();
      return;
    }
  }

  const params = new URLSearchParams();
  params.append("list_title_id", id);
  params.append("title_name", titleName);

  if (mode !== "sub") {
    params.append("type_id", typeId);
    params.append("density", density || "");
  }
  if (mode === "normal") {
    params.append("master_id", masterId);
  }

  fetch("title/bom3_title_update.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body: params.toString()
  })
  .then(r => r.text())
  .then(res => {
    res = (res || "").trim();

    if(res !== "OK"){
      alert("수정 실패 : " + res);
      return;
    }

    // ✅✅ 핵심: 성공하면 oldHtml로 먼저 원복(=회색 select/input 제거)
    if(tr.dataset.oldHtml){
      tr.innerHTML = tr.dataset.oldHtml;
      delete tr.dataset.oldHtml;
    }

    // ✅ 원복된 DOM(뷰모드)에서 다시 찾아서 값 반영
    const tdTitle = tr.querySelector(".title-name");
    if(tdTitle) tdTitle.innerText = titleName;

    if (mode !== "sub") {
      const tdType = tr.querySelector(".type-name");
      if(tdType){
        tdType.dataset.typeId = typeId;
        tdType.innerText = getTypeNameById(typeId);
      }

      const tdDensity = tr.querySelector(".density");
      if(tdDensity) tdDensity.innerText = density || "";
    }

    if (mode === "normal") {
      const tdMaster = tr.querySelector(".master-name");
      if(tdMaster){
        tdMaster.dataset.master = masterId;
        tdMaster.innerText = getMasterNameById(masterId);
      }
    }

    // ✅ 모드값 정리 + 버튼 복원
    delete tr.dataset.mode;
    restoreTitleButtons(tr);
  })
  .catch(err => {
    console.log(err);
    alert("수정 중 오류");
  });
}

function restoreTitleButtons(tr){
  tr.querySelector("td:last-child").innerHTML = `
    <button class="btn btn-sm btn-outline-secondary me-1"
            onclick="editTitleRow(this)">수정</button>
    <button class="btn btn-sm btn-outline-danger"
            onclick="deleteTitle(this)">삭제</button>
  `;
  delete tr.dataset.oldHtml; // 있으면 정리
}


/* ===============================
   삭제 (껍데기)
================================ */
function deleteTitle(btn){
  const tr = btn.closest("tr");
  const id = tr?.dataset?.id;

  if(!id){
    alert("ID가 없습니다.");
    return;
  }

  // ✅ 카테고리 중지 팝업과 동일하게 사용
  openDeactivate("title", id);
}





//**********타이틀 서브******************
// 추가(인서트 row)
function openSubValueAdd(defaultMasterId){
  const table = document.getElementById("subValueTable");
  if(!table) return;

  // ✅ 서브항목(헤더)이 없으면 추가 금지
  // thead th[data-title-sub-id] 중 0이 아닌 게 하나도 없으면 "서브 항목 없음" 상태
  const ths = table.querySelectorAll("thead th[data-title-sub-id]");
  const hasRealSub = Array.from(ths).some(th => (th.dataset.titleSubId || "0") !== "0");

  if(!hasRealSub){
    alert("카테고리 서브 헤더를 먼저 생성해주세요.");
    return;
  }

  const tbody = table.querySelector("tbody");
  if(!tbody) return;

  if(document.getElementById("subValueInsertRow")){
    document.querySelector("#subValueInsertRow select")?.focus();
    return;
  }

  const tr = document.createElement("tr");
  tr.id = "subValueInsertRow";

  let html = "";

  // 카테고리
  html += `
    <td>
      <select id="subValueMaster" class="form-select form-select-sm" onkeydown="subValueKey(event)">
        ${getMasterOptions(defaultMasterId || "")}
      </select>
    </td>
  `;

  // 컬럼들
  table.querySelectorAll("thead th[data-title-sub-id]").forEach(th=>{
    html += `
      <td>
        <input type="text" class="form-control form-control-sm"
               data-title-sub-id="${th.dataset.titleSubId}"
               onkeydown="subValueKey(event)">
      </td>
    `;
  });

  // 관리
  html += `
    <td class="text-center">
      <button type="button" class="btn btn-sm btn-success me-1" onclick="saveSubValueRow()">✔</button>
      <button type="button" class="btn btn-sm btn-secondary" onclick="cancelSubValueInsert()">✖</button>
    </td>
  `;

  tr.innerHTML = html;
  tbody.insertBefore(tr, tbody.firstChild);

  const sel = tr.querySelector("#subValueMaster");
  if(sel && defaultMasterId) sel.value = defaultMasterId;

  tr.querySelector("select")?.focus();
}


function subValueKey(e){
  const tr = e.target.closest("tr");
  const isInsert = !!tr && tr.id === "subValueInsertRow";

  if(e.key === "Enter"){
    e.preventDefault();
    if(isInsert) saveSubValueRow();
    else saveSubValueUpdate(e.target);
  }

  if(e.key === "Escape"){
    e.preventDefault();
    if(isInsert) cancelSubValueInsert();
    else cancelSubValueUpdate(e.target);
  }
}


function reopenInsertRowAfterReload(keepMasterId){
  // 중복 타이머 방지
  if(window._subValueReopenTimer){
    clearInterval(window._subValueReopenTimer);
    window._subValueReopenTimer = null;
  }

  let tries = 0;
  window._subValueReopenTimer = setInterval(() => {
    tries++;

    const tbody = document.querySelector("#subValueTable tbody");
    if(tbody){
      clearInterval(window._subValueReopenTimer);
      window._subValueReopenTimer = null;

      // 이미 있으면 또 만들지 않음
      if(!document.getElementById("subValueInsertRow")){
        openSubValueAdd(keepMasterId);

        // 첫 번째 입력칸으로 바로 이동(원하면)
        document.querySelector("#subValueInsertRow input[data-title-sub-id]")?.focus();
      }
    }

    // 2초 정도면 충분 (50ms * 40)
    if(tries > 40){
      clearInterval(window._subValueReopenTimer);
      window._subValueReopenTimer = null;
    }
  }, 50);
}


function cancelSubValueInsert(){
  document.getElementById("subValueInsertRow")?.remove();
}

// 저장(추가) - JSON 응답 버전
function saveSubValueRow(){
  const tr = document.getElementById("subValueInsertRow");
  if(!tr) return;

  const masterId = document.getElementById("subValueMaster")?.value || "";
  if(!masterId){
    alert("카테고리를 선택하세요");
    return;
  }

  const table = document.getElementById("subValueTable");
  const listTitleId = table?.dataset?.listTitleId;
  if(!listTitleId){
    alert("타이틀 정보가 없습니다");
    return;
  }

  const params = [];
  let hasAny = false;

  tr.querySelectorAll("input[data-title-sub-id]").forEach(input=>{
    const val = input.value.trim();
    const titleSubId = input.dataset.titleSubId;
    if(val !== ""){
      hasAny = true;
      params.push("title_sub_id[]=" + encodeURIComponent(titleSubId));
      params.push("sub_value[]=" + encodeURIComponent(val));
    }
  });

  if(!hasAny){
    alert("값을 입력하세요");
    return;
  }

  fetch("title/bom3_title_sub_value_save.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "list_title_id=" + encodeURIComponent(listTitleId) +
      "&master_id=" + encodeURIComponent(masterId) +
      "&" + params.join("&")
  })
  .then(r => r.json())
  .then(data => {
    if(data && data.ok){
      reloadCurrentTab();           
      reopenInsertRowAfterReload(); 
    }else{
      alert((data && data.msg) ? data.msg : "저장 실패");
      console.log("save res:", data);
    }
  })
  .catch(err=>{
    alert("저장 중 오류");
    console.log(err);
  });
}


/* ===============================
   ✅ 수정(행 전체: 카테고리 select + 값 input)
================================ */

function editSubValueRow(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  // 이미 편집중이면 중복 방지
  if(tr.dataset.oldHtml) return;

  // 원복용 백업
  tr.dataset.oldHtml = tr.innerHTML;

  // 1) 카테고리 td -> select
  const tdMaster = tr.querySelector("td.sv-master");
  const oldMasterId = tdMaster ? (tdMaster.dataset.masterId || "") : "";

  if(tdMaster){
    tdMaster.innerHTML = `
      <select class="form-select form-select-sm sv-master-sel">
        ${getMasterOptions(oldMasterId)}
      </select>
    `;
  }

  // 2) 값 td 전부 -> input
  tr.querySelectorAll("td.sub-value").forEach(td=>{
    const text = (td.textContent || "").trim();

    // 화면에 '-' 로 보이는건 실제 값 없음으로 처리
    const oldVal = (text === "-" ? "" : text);

    td.dataset.oldVal = oldVal;

    td.innerHTML = `
      <input type="text"
             class="form-control form-control-sm sv-input"
             value="${escapeHtml(oldVal)}">
    `;
  });

  // 3) 버튼 -> 저장/취소
  const tdAction = tr.querySelector("td:last-child");
  if(tdAction){
    tdAction.innerHTML = `
      <button type="button" class="btn btn-sm btn-success me-1"
              onclick="saveSubValueUpdate(this)">✔</button>
      <button type="button" class="btn btn-sm btn-secondary"
              onclick="cancelSubValueUpdate(this)">✖</button>
    `;
  }

  // 4) 포커스
  tr.querySelector("input.sv-input")?.focus();
}


// 취소
function cancelSubValueUpdate(el){
  const tr = el.closest("tr");
  if(!tr) return;

  if(tr.dataset.oldHtml){
    tr.innerHTML = tr.dataset.oldHtml;
    delete tr.dataset.oldHtml;
  }
}

function saveSubValueUpdate(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  const table = document.getElementById("subValueTable");
  const listTitleId = table?.dataset?.listTitleId || "";   // ✅ 반드시
  const rowId = tr.dataset.rowId || "";                   // ✅ 반드시
  const masterId = tr.querySelector("select.sv-master-sel")?.value || "";

  if(!listTitleId || !rowId){
    alert("필수정보(list_title_id / row_id)가 없습니다.");
    return;
  }
  if(!masterId){
    alert("카테고리를 선택하세요.");
    return;
  }

  const params = [];
  tr.querySelectorAll("td.sub-value").forEach(td=>{
    const titleSubId = td.dataset.titleSubId || "";
    const val = td.querySelector("input")?.value.trim() || "";

    // ✅ 서버가 매칭하려면 title_sub_id[]는 무조건 보내야 함
    params.push("title_sub_id[]=" + encodeURIComponent(titleSubId));
    params.push("sub_value[]=" + encodeURIComponent(val));
  });

  fetch("title/bom3_title_sub_value_save.asp", {
    method: "POST",
    headers: { "Content-Type":"application/x-www-form-urlencoded" },
    body:
      "list_title_id=" + encodeURIComponent(listTitleId) +
      "&row_id=" + encodeURIComponent(rowId) +
      "&master_id=" + encodeURIComponent(masterId) +
      "&" + params.join("&")
  })
  .then(r => r.text())
  .then(t => {
    // ✅ 서버가 에러나면 HTML(<font...>)이 올 수 있어서 text→JSON 파싱
    let res;
    try { res = JSON.parse(t); }
    catch(e){
      console.log("NOT JSON RESPONSE:", t);
      alert("서버 응답이 JSON이 아닙니다(ASP 에러 가능). 콘솔 확인!");
      return;
    }

    if(res.ok === true){
      reloadCurrentTab(); // ✅ 가장 짧고 안정
    }else{
      alert("수정 실패: " + (res.msg || "UNKNOWN"));
    }
  })
  .catch(err=>{
    console.log(err);
    alert("수정 중 오류");
  });
}

/* ===============================
   삭제
================================ */
function deleteSubValue(btn){
  const tr = btn.closest("tr");
  const id = tr ? tr.dataset.rowId : "";   // ✅ data-row-id

  console.log("row_id", id);
  console.log("tr", tr);

  if(!id){
    alert("ID(row_id)가 없습니다.");
    return;
  }

  openSubDeactivate("title", id);
}

function openSubDeactivate(type, id){
  const masterId = window.master_id || 0;

  // ✅ 현재 페이지 URL에서 list_title_id 추출
  const params = new URLSearchParams(window.location.search);
  const listTitleId = params.get("list_title_id") || 0;

  window.open(
    "title/bom3_title_sub_value_popup.asp?type=" + encodeURIComponent(type) +
    "&id=" + encodeURIComponent(id) +
    "&master_id=" + encodeURIComponent(masterId) +
    "&list_title_id=" + encodeURIComponent(listTitleId),   // ✅ 추가
    "subdeactivatePopup",
    "width=520,height=600,scrollbars=yes"
  );
}



function deactivateTitleSubValue(id, masterId, cb){
  const API_URL = "/TNG_bom/bom3/common/title_sub_value_delete.asp"; // ✅ 네 delete API 경로

  const params = new URLSearchParams();
  params.set("sub_value_id", id);
  if (masterId) params.set("master_id", masterId);

  fetch(API_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
    body: params.toString()
  })
  .then(function(res){
    return res.text().then(function(txt){
      let data;
      try { data = JSON.parse(txt); } catch(e) { data = { ok:false, message: txt }; }
      if (!res.ok) data.ok = false;
      if (cb) cb(data);
    });
  })
  .catch(function(err){
    if (cb) cb({ ok:false, message: (err && err.message) ? err.message : String(err) });
  });
}



function restoreSubValueButtons(tr){
    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-outline-secondary me-1"
                onclick="editSubValueRow(this)">수정</button>
        <button class="btn btn-sm btn-outline-danger"
                onclick="deleteSubValue(this)">삭제</button>
    `;
}

function getMasterNameById(id){
    id = String(id);
    const m = MASTER_LIST.find(x => String(x.id) === id);
    return m ? m.name : "";
}

function appendSubValueRow(masterId, values){
  const tbody = document.querySelector("#subValueTable tbody");
  const tr = document.createElement("tr");

  // ⚠ 서버에서 row_id를 안 주면 임시 0
  tr.dataset.rowId = "0";

  let html = "";

  // ✅ sv-master + data-master-id 추가
  html += `
    <td class="sv-master" data-master-id="${masterId}">
      ${escapeHtml(getMasterNameById(masterId))}
    </td>
  `;

  document
    .querySelectorAll("#subValueTable thead th[data-title-sub-id]")
    .forEach(th=>{
      const subId = th.dataset.titleSubId;
      const found = values.find(v=>String(v.titleSubId) === String(subId));
      const text  = found ? found.value : "-";

      // ✅ sub-value + data-title-sub-id 추가
      html += `
        <td class="sub-value" data-title-sub-id="${subId}" data-sub-value-id="">
          ${escapeHtml(text)}
        </td>
      `;
    });

  html += `
    <td class="text-center">
      <button class="btn btn-sm btn-outline-secondary me-1"
              onclick="editSubValueRow(this)">수정</button>
      <button class="btn btn-sm btn-outline-danger"
              onclick="deleteSubValue(this)">삭제</button>
    </td>
  `;

  tr.innerHTML = html;
  tbody.insertBefore(tr, tbody.firstChild);
}


// 마테리얼 팝업 오픈
function openMaterialPopup(master_id, is_active){
  if(is_active != 1){
    alert("중지된 품목입니다.");
    return;
  }

  const url = "material/bom3_material_popup.asp?master_id=" + master_id;
  window.open(
    url,
    "materialPopup",
    "width=1200,height=800,scrollbars=yes,resizable=yes"
  );
}

</script>

</body>
</html>

<%
call DbClose()
%>
