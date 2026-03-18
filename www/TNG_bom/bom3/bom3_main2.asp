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

const MASTER_LIST = [
<%
Dim firstM
firstM = True

RsMaster.MoveFirst
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
%>
];

const TYPE_LIST = [
<%
Dim firstT
firstT = True

RsType.MoveFirst
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

// 최초진입시 마스터로
$(function(){
    loadContent("master/bom3_master_list.asp");
});

//탭 클릭
$(document).on("click", ".tab-btn", function(){
    $(".tab-btn").removeClass("active");
    $(this).addClass("active");

    const url = $(this).data("url");
    loadContent(url);
});

function loadContent(url){
    $("#contentBox").html(`<div class="text-muted">로딩중...</div>`);

    fetch(url)
        .then(res => res.text())
        .then(html => {
            $("#contentBox").html(html);
        })
        .catch(() => {
            $("#contentBox").html(
                `<div class="text-danger">불러오기 실패</div>`
            );
        });
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

function reloadCurrentTab(){
    const active = document.querySelector(".tab-btn.active");
    if(!active) return;

    const url = active.dataset.url;
    if(url) loadContent(url);
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
        const btn = e.target.closest("tr")
                            .querySelector(".btn-success");
        if(btn) btn.click();
    }
    if(e.key === "Escape"){
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
    .then(r=>r.text())
    .then(res=>{
        if(res === "OK"){
            // ✅ append 살림 (연속입력 핵심)
            appendOriginRow(val);

            // ✅ 입력 유지
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

    fetch("origin/bom3_origin_update.asp", {
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

//master 부분 ************************************************
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

    fetch("master/bom3_master_update.asp", {
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
            <input type="checkbox">
        </td>

        <td class="text-center">
            <input type="checkbox">
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
            <button class="btn btn-sm btn-success me-1"
                    onclick="saveTitleInsert(this)">✔</button>
            <button class="btn btn-sm btn-secondary"
                    onclick="this.closest('tr').remove()">✖</button>
        </td>
    `;

    tbody.insertBefore(tr, tbody.firstChild);
    tr.querySelector("input")?.focus();
}

/* ===============================
   타이틀 추가 저장 (껍데기)
   👉 나중에 bom3_title_save.asp 연결
================================ */
function saveTitleInsert(btn){
    const tr = btn.closest("tr");

    const masterId = tr.children[0].querySelector("select").value;
    const title    = tr.children[1].querySelector("input").value.trim();
    const isSub    = tr.children[2].querySelector("input").checked ? 1 : 0;
    const isCommon = tr.children[3].querySelector("input").checked ? 1 : 0;
    const typeId   = tr.children[4].querySelector("select").value;
    const density  = tr.children[5].querySelector("input").value.trim();

    if(!masterId){
        alert("마스터를 선택하세요");
        return;
    }
    if(!title){
        alert("타이틀명을 입력하세요");
        return;
    }
    if(!typeId){
        alert("타입을 선택하세요");
        return;
    }

    console.log("INSERT DATA", {
        masterId, title, isSub, isCommon, typeId, density
    });

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
    res = res.trim();

    if(res === "OK_SUB"){
        // 🔥 SUB 생성됨 → 상단 탭 반영 위해 전체 리로드
        window.location.reload();
        return;
    }

    if(res === "OK"){
        // SUB 없음 → 기존 방식
        reloadCurrentTab();
    }else{
        alert("저장 실패 : " + res);
    }
});
}

/* ===============================
   수정
================================ */
function editTitleRow(btn){
    const tr = btn.closest("tr");
    tr.dataset.oldHtml = tr.innerHTML;

    const oldMasterId = tr.querySelector(".master-name")?.dataset.master || "";
    const oldTitle    = tr.querySelector(".title-name")?.innerText.trim() || "";
    const oldTypeId   = tr.querySelector(".type-name")?.dataset.typeId || "";
    const oldDensity  = tr.querySelector(".density")?.innerText.trim() || "";

    // MASTER
    tr.children[0].innerHTML = `
        <select class="form-select form-select-sm">
            ${getMasterOptions(oldMasterId)}
        </select>
    `;

    // TITLE
    tr.children[1].innerHTML = `
        <input class="form-control form-control-sm"
               value="${oldTitle}">
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
               value="${oldDensity}">
    `;

    // ACTION
    tr.children[6].innerHTML = `
        <button class="btn btn-sm btn-success me-1"
                onclick="saveTitleUpdate(this)">✔</button>
        <button class="btn btn-sm btn-secondary"
                onclick="cancelTitleEdit(this)">✖</button>
    `;
}

/* ===============================
   수정 취소
================================ */
function cancelTitleEdit(el){
    const tr = el.closest("tr");
    if(tr && tr.dataset.oldHtml){
        tr.innerHTML = tr.dataset.oldHtml;
        delete tr.dataset.oldHtml;
    }
}

/* ===============================
   수정 저장 (껍데기)
================================ */
function saveTitleUpdate(btn){
    const tr = btn.closest("tr");
    const id = tr.dataset.id;

    const masterId = tr.children[0].querySelector("select").value;
    const title    = tr.children[1].querySelector("input").value.trim();
    const typeId   = tr.children[4].querySelector("select").value;
    const density  = tr.children[5].querySelector("input").value.trim();

    if(!masterId || !title || !typeId){
        alert("필수 항목을 입력하세요");
        return;
    }

    console.log("UPDATE DATA", {
        id, masterId, title, typeId, density
    });

    alert("수정 로직 연결 예정");
}

/* ===============================
   삭제 (껍데기)
================================ */
function deleteTitle(btn){
    if(!confirm("삭제하시겠습니까?")) return;
    const tr = btn.closest("tr");
    tr.remove();
}



//**********타이틀 서브******************

/* ===============================
   TITLE SUB VALUE
================================ */

// 추가
function openSubValueAdd(){
    const tbody = document.querySelector("#subValueTable tbody");
    if(document.getElementById("subValueInsertRow")) return;

    const tr = document.createElement("tr");
    tr.id = "subValueInsertRow";

    let html = "";

    /* 🔹 1. MASTER SELECT */
    html += `
        <td>
            <select id="subValueMaster"
                    class="form-select form-select-sm">
                ${getMasterOptions("")}
            </select>
        </td>
    `;

    /* 🔹 2. title_sub 별 input */
    document.querySelectorAll(
        "#subValueTable thead th[data-title-sub-id]"
    ).forEach(th=>{
        html += `
            <td>
                <input type="text"
                       class="form-control form-control-sm"
                       data-title-sub-id="${th.dataset.titleSubId}">
            </td>
        `;
    });

    /* 🔹 3. 관리 버튼 */
    html += `
        <td class="text-center">
            <button class="btn btn-sm btn-success me-1"
                    onclick="saveSubValueRow()">✔</button>
            <button class="btn btn-sm btn-secondary"
                    onclick="cancelSubValueInsert()">✖</button>
        </td>
    `;

    tr.innerHTML = html;
    tbody.insertBefore(tr, tbody.firstChild);
}
// 저장
function saveSubValueRow(){
    const tr = document.getElementById("subValueInsertRow");
    if(!tr) return;

    const masterId = document.getElementById("subValueMaster").value;
    if(!masterId){
        alert("카테고리를 선택하세요");
        return;
    }

    const table = document.getElementById("subValueTable");
const listTitleId = table.dataset.listTitleId;

if(!listTitleId){
    alert("타이틀 정보가 없습니다");
    return;
}

    const params = [];

    tr.querySelectorAll("input[data-title-sub-id]").forEach(input=>{
        const val = input.value.trim();
        const titleSubId = input.dataset.titleSubId;

        if(val !== ""){
            params.push("title_sub_id[]=" + encodeURIComponent(titleSubId));
            params.push("sub_value[]=" + encodeURIComponent(val));
        }
    });

    if(params.length === 0){
        alert("값을 입력하세요");
        return;
    }

    fetch("title/bom3_title_sub_value_save.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "list_title_id=" + listTitleId +
            "&master_id=" + masterId +
            "&" + params.join("&")
    })
    .then(r=>r.text())
    .then(res=>{
        if(res.trim()==="OK"){
            location.reload();
        }else{
            alert(res);
        }
    });
}

function hidden(name, value){
    const i = document.createElement("input");
    i.type = "hidden";
    i.name = name;
    i.value = value;
    return i;
}

function cancelSubValueInsert(){
    const tr = document.getElementById("subValueInsertRow");
    if(tr) tr.remove();
}

// 수정
function editSubValueRow(btn){
    const tr = btn.closest("tr");
    tr.dataset.old = tr.querySelector(".sub-value").innerText;

    tr.querySelector(".sub-value").innerHTML = `
        <input class="form-control form-control-sm"
               value="${tr.dataset.old}"
               onkeydown="subValueUpdateKey(event,this)">
    `;

    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-success me-1"
                onclick="saveSubValueUpdate(this)">✔</button>
        <button class="btn btn-sm btn-secondary"
                onclick="cancelSubValueUpdate(this)">✖</button>
    `;
}

function subValueUpdateKey(e, input){
    if(e.key === "Enter") saveSubValueUpdate(input);
    if(e.key === "Escape") cancelSubValueUpdate(input);
}

function saveSubValueUpdate(el){
    const tr = el.closest("tr");
    const id = tr.dataset.id;
    const val = tr.querySelector("input").value.trim();

    if(!val){
        alert("값을 입력하세요");
        return;
    }

    fetch("title/bom3_title_sub_value_update.asp", {
        method:"POST",
        headers:{ "Content-Type":"application/x-www-form-urlencoded" },
        body:
            "sub_value_id=" + id +
            "&sub_value=" + encodeURIComponent(val)
    })
    .then(r=>r.text())
    .then(res=>{
        if(res === "OK"){
            tr.querySelector(".sub-value").innerText = val;
            restoreSubValueButtons(tr);
        }else{
            alert("수정 실패");
        }
    });
}

function cancelSubValueUpdate(el){
    const tr = el.closest("tr");
    tr.querySelector(".sub-value").innerText = tr.dataset.old;
    restoreSubValueButtons(tr);
}

function restoreSubValueButtons(tr){
    tr.querySelector("td:last-child").innerHTML = `
        <button class="btn btn-sm btn-outline-secondary me-1"
                onclick="editSubValueRow(this)">수정</button>
        <button class="btn btn-sm btn-outline-danger"
                onclick="deleteSubValue(this)">삭제</button>
    `;
}



</script>

</body>
</html>

<%
call DbClose()
%>
