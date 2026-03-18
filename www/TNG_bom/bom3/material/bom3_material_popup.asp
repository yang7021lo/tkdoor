<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ==================================================
' master_id
' ==================================================
Dim master_id
If IsNumeric(Request("master_id")) Then
    master_id = CLng(Request("master_id"))
Else
    Response.Write "INVALID MASTER"
    Response.End
End If

' ==================================================
' Master 정보
' ==================================================
Dim RsM, sqlM
Set RsM = Server.CreateObject("ADODB.Recordset")
sqlM = "SELECT item_name FROM bom3_master WHERE master_id=" & master_id
RsM.Open sqlM, Dbcon

If RsM.EOF Then
    Response.Write "MASTER NOT FOUND"
    Response.End
End If

Dim master_name
master_name = RsM("item_name")
RsM.Close
Set RsM = Nothing


' ==================================================
' ✅ 검색 세션 (master_id별 유지)
'  - doSearch=1 로 제출되면 세션 저장/삭제
'  - reset=1 이면 세션 초기화
' ==================================================
Dim sessKey, searchQ
sessKey = "BOM3_MAT_Q_" & CStr(master_id)
searchQ = ""

On Error Resume Next

If Trim(Request("reset")) = "1" Then
  Session.Contents.Remove(sessKey)
End If

If Trim(Request("doSearch")) = "1" Then
  searchQ = Trim(Request("q"))
  If searchQ = "" Then
    Session.Contents.Remove(sessKey)
  Else
    Session(sessKey) = searchQ
  End If
End If

If Not IsEmpty(Session(sessKey)) Then
  searchQ = Trim(CStr(Session(sessKey)))
Else
  searchQ = ""
End If

On Error GoTo 0


' JS 문자열 안전 처리
Function JsStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  s = Replace(s, vbCr, "\n")
  s = Replace(s, vbLf, "\n")
  JsStr = s
End Function
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Material 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
th, td { white-space: nowrap; vertical-align: middle; }
.material-name { min-width:160px; }
.manage-col { width:120px; }
input.form-control-sm,
select.form-select-sm { min-width:120px; }

.view-only{display:inline;}
.edit-only{display:none;}
tr.editing .view-only{display:none;}
tr.editing .edit-only{display:block;}
</style>
</head>

<body class="p-3">

<!-- ===============================
     상단
================================ -->
<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="mb-0">
    Material 관리 :
    <span class="text-primary"><%=master_name%></span>
  </h5>

  <!-- ✅ 검색 UI + 세션 유지 -->
  <div class="d-flex gap-2 align-items-center">
    <form method="get" class="d-flex gap-2 m-0">
      <input type="hidden" name="master_id" value="<%=master_id%>">
      <input type="hidden" name="doSearch" value="1">

      <input type="text"
             name="q"
             value="<%=Server.HTMLEncode(searchQ)%>"
             class="form-control form-control-sm"
             style="width:240px;"
             placeholder="원자재명/카테고리 검색">

      <button class="btn btn-sm btn-outline-secondary" type="submit">검색</button>

      <a class="btn btn-sm btn-outline-danger"
         href="?master_id=<%=master_id%>&reset=1">초기화</a>
    </form>

    <button class="btn btn-sm btn-primary" onclick="addMaterialRow()">+ Material 추가</button>
  </div>
</div>

<div class="table-responsive">
<table class="table table-bordered table-hover" id="materialTable">

<thead class="table-light">
<tr>
  <th>카테고리</th>
  <th class="material-name">원자재명</th>

<%
' ==================================================
' 헤더 생성 (SUB 구조 확장)
' ==================================================
Sub RenderTitleGroup(sql)
    Dim rsTitle, rS
    Set rsTitle = Server.CreateObject("ADODB.Recordset")
    rsTitle.Open sql, Dbcon

    Do While Not rsTitle.EOF

        If rsTitle("is_sub") = 0 Then
%>
<th data-title-id="<%=rsTitle("list_title_id")%>">
  <%=rsTitle("title_name")%>
</th>
<%
        Else
            Set rS = Server.CreateObject("ADODB.Recordset")
            rS.Open _
              "SELECT title_sub_id, sub_name, is_select, is_show " & _
              "FROM bom3_list_title_sub " & _
              "WHERE is_active=1 " & _
              "AND list_title_id=" & rsTitle("list_title_id") & _
              " AND (is_select=1 OR is_show=1) " & _
              "ORDER BY CASE WHEN is_select=1 THEN 0 ELSE 1 END, title_sub_id", Dbcon

            Do While Not rS.EOF
%>
<th data-sub-id="<%=rS("title_sub_id")%>"
    data-is-select="<%=rS("is_select")%>"
    data-is-show="<%=rS("is_show")%>">
  <%=rS("sub_name")%>
</th>
<%
                rS.MoveNext
            Loop

            rS.Close
            Set rS = Nothing
        End If

        rsTitle.MoveNext
    Loop

    rsTitle.Close
    Set rsTitle = Nothing
End Sub

' ==================================================
' 헤더 순서 (확정)
' ==================================================
Call RenderTitleGroup("SELECT * FROM bom3_list_title WHERE is_active=1 AND is_sub=1 AND is_common=1")
Call RenderTitleGroup("SELECT * FROM bom3_list_title WHERE is_active=1 AND is_sub=0 AND is_common=1")
Call RenderTitleGroup( _
"SELECT * FROM bom3_list_title t " & _
"WHERE t.is_active=1 AND t.is_sub=1 AND t.is_common=0 " & _
"AND EXISTS ( " & _
"  SELECT 1 FROM bom3_title_sub_value v " & _
"  JOIN bom3_list_title_sub s ON v.title_sub_id = s.title_sub_id " & _
"  WHERE s.list_title_id = t.list_title_id " & _
"    AND v.is_active=1 " & _
"    AND (v.master_id IS NULL OR v.master_id=" & master_id & ") " & _
")" _
)
Call RenderTitleGroup("SELECT * FROM bom3_list_title WHERE is_active=1 AND is_sub=0 AND is_common=0 AND master_id=" & master_id)
%>

  <th class="manage-col">관리</th>
</tr>
</thead>

<tbody id="materialListBody">
  <tr>
    <td colspan="100" class="text-center text-muted">
      로딩중...
    </td>
  </tr>
</tbody>
</table>
</div>

<script>
/* ✅ 현재 검색어(세션 기반) — 목록 fetch에 같이 넘김 */
window.MAT_Q = "<%=JsStr(searchQ)%>";

window.SHOW_MAP = window.SHOW_MAP || {};

/* =========================================
   ✅ 신규행 Enter/Esc 키 처리
   - Enter : 저장
   - Esc   : 신규행 취소
========================================= */
function materialInsertKey(e, el){
  if(e.key === "Enter"){
    e.preventDefault();
    const tr = el.closest("tr");
    const btn = tr ? tr.querySelector("button.btn-success") : null;
    if(btn) saveMaterialRow(btn);
  }
  if(e.key === "Escape"){
    e.preventDefault();
    cancelNewMaterialRow();
  }
}

/* =========================================
   select 옵션 + SHOW_MAP 로딩 (유일한 진입점)
========================================= */
function loadSelectOptions(sel){
  const titleSubId = sel.dataset.titleSubId;

  // ✅ 이미 로딩했으면 선택값만 맞추고 끝 (중복 append 방지)
  if (sel.dataset.loaded === "1") {
    const selected = sel.dataset.selectedValue || "";
    if (selected) sel.value = String(selected);
    return Promise.resolve();
  }

  sel.dataset.loaded = "1";

  // ✅ 혹시 옵션이 이미 붙어있다면(리로드 대비) 첫 option("선택")만 남기고 삭제
  Array.from(sel.querySelectorAll("option")).slice(1).forEach(o => o.remove());

  return fetch(
    "bom3_material_sub_value_list.asp" +
    "?title_sub_id=" + encodeURIComponent(titleSubId) +
    "&master_id=<%=master_id%>"
  )
  .then(r => r.text())
  .then(t => {
    const lines = t.trim() ? t.trim().split("\n") : [];
    lines.forEach(line => {
      const [id, text, rowId] = line.split("|");
      if (!id) return;

      const opt = document.createElement("option");
      opt.value = id;
      opt.textContent = text;
      opt.dataset.rowId = rowId;
      sel.appendChild(opt);

      if (!SHOW_MAP[rowId]) SHOW_MAP[rowId] = {};
      SHOW_MAP[rowId][titleSubId] = text;
    });

    // ✅ ⭐ 옵션 로딩 끝나면 기존 선택값 반영
    const selected = sel.dataset.selectedValue || "";
    if (selected) sel.value = String(selected);
  })
  .catch(err => {
    console.error("loadSelectOptions error:", err);
  });
}


/* =========================================
   최초 로딩 시 모든 select 초기화(리스트 내부에서만)
========================================= */
document
  .querySelectorAll("select[data-role='select-sub']")
  .forEach(loadSelectOptions);

/* =========================================
   select 변경 → 같은 row_id 의 is_show 반영
========================================= */
function onSelectSubChange(sel) {
  const rowId = sel.options[sel.selectedIndex]?.dataset.rowId;
  if (!rowId) return;

  const tr = sel.closest("tr");

  fetch(
    "bom3_material_sub_row_map.asp" +
    "?row_id=" + rowId +
    "&master_id=<%=master_id%>"
  )
  .then(r => r.text())
  .then(t => {
    t.trim().split("\n").forEach(line => {
      const [subId, value] = line.split("|");

      const target = tr.querySelector(
        `[data-role='show-sub'][data-sub-id='${subId}']`
      );
      if (!target) return;

      if (target.tagName === "INPUT") target.value = value;
      else target.textContent = value;
    });
  });
}

/* =========================================
   Material 신규 행 추가
========================================= */
function addMaterialRow(){
  const tbody = document.querySelector("#materialTable tbody");
  if(!tbody) return;

  const exist = document.getElementById("materialInsertRow");
  if(exist){
    const firstInput = exist.querySelector("input.form-control");
    if(firstInput) firstInput.focus();
    return;
  }

  const emptyRow = tbody.querySelector("tr td[colspan]");
  if(emptyRow) emptyRow.closest("tr").remove();

  const tr = document.createElement("tr");
  tr.id = "materialInsertRow";

  let html = `<td><%=master_name%></td>`;

  // ✅ material_name 엔터 저장
  html += `
    <td>
      <input type="text" class="form-control form-control-sm"
             data-field="material_name"
             onkeydown="materialInsertKey(event, this)">
    </td>
  `;

  const ths = document.querySelectorAll("#materialTable thead th");

  ths.forEach((th, idx) => {
    if (idx < 2) return;
    if (th.classList.contains("manage-col")) return;

    const subId    = th.dataset.subId;
    const isSelect = th.dataset.isSelect === "1";
    const isShow   = th.dataset.isShow === "1";
    const titleId  = th.dataset.titleId;

    // 일반 title input
    if (!subId && titleId) {
      html += `
        <td>
          <input type="text" class="form-control form-control-sm"
                 data-title-id="${titleId}"
                 onkeydown="materialInsertKey(event, this)">
        </td>`;
      return;
    }

    // sub select
    if (subId && isSelect) {
      html += `
        <td>
          <select class="form-select form-select-sm"
                  data-role="select-sub"
                  data-title-sub-id="${subId}"
                  onchange="onSelectSubChange(this)"
                  onkeydown="materialInsertKey(event, this)">
            <option value="">선택</option>
          </select>
        </td>`;
      return;
    }

    // show-only
    if (subId && isShow) {
      html += `
        <td>
          <span data-role="show-sub"
                data-sub-id="${subId}"></span>
        </td>`;
      return;
    }

    html += `<td></td>`;
  });

  html += `
    <td class="text-center">
      <button class="btn btn-sm btn-success" onclick="saveMaterialRow(this)">저장</button>
      <button class="btn btn-sm btn-outline-secondary" onclick="cancelNewMaterialRow()">취소</button>
    </td>
  `;

  tr.innerHTML = html;
  tbody.prepend(tr);

  // 신규행 select 옵션 로딩
  tr.querySelectorAll("select[data-role='select-sub']")
    .forEach(loadSelectOptions);

  const first = tr.querySelector("[data-field='material_name']");
  if(first) first.focus();
}

function cancelNewMaterialRow(){
  document.getElementById("materialInsertRow")?.remove();
}

function collectMaterialRow(tr){
  const nameEl = tr.querySelector("[data-field='material_name']");
  let materialName = "";

  if(nameEl){
    if(nameEl.tagName === "INPUT") materialName = nameEl.value;
    else materialName = nameEl.textContent.trim();
  }

  const data = {
    material_id: tr.dataset.materialId || "",
    material_name: materialName,
    titles: [],
    subs: []
  };

  // 일반 title
  tr.querySelectorAll("[data-title-id]").forEach(el=>{
    data.titles.push({
      list_title_id: el.dataset.titleId,
      value: el.tagName === "INPUT" ? el.value : el.textContent.trim()
    });
  });

  // sub
  tr.querySelectorAll("select[data-role='select-sub']").forEach(sel=>{
    if (!sel.value) return;
    data.subs.push({
      title_sub_id: sel.dataset.titleSubId,
      sub_value_id: sel.value
    });
  });

  return data;
}

/* =========================================
   ✅ 저장 (신규행 Enter 저장 + 성공 후 신규행 자동 재생성)
========================================= */
function saveMaterialRow(btn){
  const tr = btn.closest("tr");
  const isInsertRow = (tr && tr.id === "materialInsertRow");
  const data = collectMaterialRow(tr);

  fetch("bom3_material_save.asp?debug=1", {
    method: "POST",
    headers: { "Content-Type":"application/x-www-form-urlencoded" },
    body: buildMaterialBody(data)
  })
  .then(r => r.text())
  .then(res => {
    res = (res || "").trim();

    if(res.startsWith("OK|")){
      // ✅ 목록 갱신 끝나면 (신규행 저장일 때만) 신규행 다시 생성
      reloadMaterialList().then(() => {
        if(isInsertRow) addMaterialRow();
      });
    }else{
      alert("저장 실패 : " + res);
    }
  })
  .catch(err=>{
    console.error(err);
    alert("저장 중 오류");
  });
}

/* =========================================
   수정/취소/삭제 기존 로직 유지
========================================= */
function applyMaterialViewMode(tr, materialId){
  tr.dataset.materialId = materialId;

  const nameInput = tr.querySelector("[data-field='material_name']");
  if(nameInput){
    const td = nameInput.closest("td");
    td.innerHTML = `
      <span class="view-value" data-field="material_name">
        ${escapeHtml(nameInput.value)}
      </span>
    `;
  }

  tr.querySelectorAll("input[data-title-id]").forEach(input=>{
    const td = input.closest("td");
    td.innerHTML = `
      <span class="view-value"
            data-title-id="${input.dataset.titleId}">
        ${escapeHtml(input.value)}
      </span>
    `;
  });

  tr.querySelectorAll("select[data-role='select-sub']").forEach(sel=>{
    const opt = sel.options[sel.selectedIndex];
    const text = opt ? opt.textContent : "";
    const td = sel.closest("td");

    td.innerHTML = `
      <span class="view-value"
            data-sub-id="${sel.dataset.titleSubId}">
        ${escapeHtml(text)}
      </span>
    `;
  });

  tr.querySelector(".manage-col").innerHTML = `
    <button class="btn btn-sm btn-outline-primary"
            onclick="editMaterialRow(this)">수정</button>
    <button class="btn btn-sm btn-danger"
            onclick="deleteMaterialRow(this)">삭제</button>
  `;
}

function editMaterialRow(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  const editing = document.querySelector("#materialListBody tr.editing");
  if(editing && editing !== tr){
    alert("다른 행이 수정 중입니다. 먼저 저장/취소 해주세요.");
    return;
  }

  if(!tr.dataset.originalHtml){
    tr.dataset.originalHtml = tr.innerHTML;
  }

  tr.classList.add("editing");

  tr.querySelectorAll("span[data-field='material_name']").forEach(span=>{
    const td = span.closest("td");
    const val = span.textContent.trim();
    td.innerHTML = `
      <input type="text"
             class="form-control form-control-sm"
             data-field="material_name"
             value="${escapeHtml(val)}">
    `;
  });

  tr.querySelectorAll("span[data-title-id]").forEach(span=>{
    const td = span.closest("td");
    const titleId = span.dataset.titleId;
    const val = span.textContent.trim();
    td.innerHTML = `
      <input type="text"
             class="form-control form-control-sm"
             data-title-id="${titleId}"
             value="${escapeHtml(val)}">
    `;
  });

  const promises = [];

  tr.querySelectorAll("span[data-sub-id]").forEach(span=>{
    if(span.dataset.role === "show-sub") return;

    const td = span.closest("td");
    const subId = span.dataset.subId;

    let selected = span.dataset.selectedValue || "";

    if (!selected) {
      const hiddenSel = td.querySelector("select[data-role='select-sub']");
      if (hiddenSel && hiddenSel.dataset.selectedValue) {
        selected = hiddenSel.dataset.selectedValue;
      }
    }

    td.innerHTML = `
      <select class="form-select form-select-sm"
              data-role="select-sub"
              data-title-sub-id="${subId}"
              data-selected-value="${escapeHtml(selected)}"
              onchange="onSelectSubChange(this)">
        <option value="">선택</option>
      </select>
    `;

    const sel = td.querySelector("select");
    promises.push(loadSelectOptions(sel));
  });

  Promise.all(promises).then(()=>{});

  const manageTd = tr.querySelector(".manage-col");
  if(manageTd){
    manageTd.innerHTML = `
      <button type="button" class="btn btn-sm btn-success" onclick="saveEditMaterialRow(this)">저장</button>
      <button type="button" class="btn btn-sm btn-outline-secondary" onclick="cancelEditMaterialRow(this)">취소</button>
    `;
  }
}

function cancelEditMaterialRow(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  if(tr.dataset.originalHtml){
    tr.innerHTML = tr.dataset.originalHtml;
  }
  tr.classList.remove("editing");
  delete tr.dataset.originalHtml;
}

function saveEditMaterialRow(btn){
  // 수정 저장은 saveMaterialRow 재사용 (신규행이 아니면 자동 add 안됨)
  saveMaterialRow(btn);
}

function deleteMaterialRow(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  if(tr.classList.contains("editing")){
    alert("수정 중에는 삭제할 수 없습니다. 먼저 저장/취소 해주세요.");
    return;
  }

  const materialId = tr.dataset.materialId;
  if(!materialId){
    alert("material_id가 없습니다.");
    return;
  }

  if(!confirm("정말로 삭제하시겠습니까?")) return;

  fetch("bom3_material_deactivate.asp", {
    method: "POST",
    headers: { "Content-Type":"application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      master_id: "<%=master_id%>",
      material_id: materialId
    }).toString()
  })
  .then(r => r.text())
  .then(res => {
    res = (res || "").trim();
    if(res === "OK"){
      loadMaterialList();
    }else{
      alert("삭제 실패 : " + res);
    }
  })
  .catch(err => {
    console.error(err);
    alert("삭제 중 오류가 발생했습니다.");
  });
}

/* =========================================
   body build
========================================= */
function buildMaterialBody(data){
  const params = new URLSearchParams();

  params.append("master_id", "<%=master_id%>");
  params.append("material_id", data.material_id || "");
  params.append("material_name", data.material_name);

  data.titles.forEach(t => {
    if(t.value !== ""){
      params.append("title_" + t.list_title_id, t.value);
    }
  });

  if (data.subs.length > 0) {
    params.append("subs_json", JSON.stringify(data.subs));
  }

  return params.toString();
}

function escapeHtml(str){
  if(str === null || str === undefined) return "";
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

/* =========================================
   ✅ 목록 로딩: Promise 리턴 (저장 후 addMaterialRow 연계용)
   ✅ 검색어(q)도 같이 넘김
========================================= */
function loadMaterialList(){
  const q = window.MAT_Q || "";
  return fetch("bom3_material_list.asp?master_id=<%=master_id%>&q=" + encodeURIComponent(q))
    .then(r => r.text())
    .then(html => {
      document.getElementById("materialListBody").innerHTML = html;

      document
        .querySelectorAll("#materialListBody select[data-role='select-sub']")
        .forEach(loadSelectOptions);
    })
    .catch(err => {
      console.error(err);
      document.getElementById("materialListBody").innerHTML =
        `<tr><td colspan="100" class="text-danger text-center">목록 로딩 실패</td></tr>`;
    });
}

function reloadMaterialList(){
  return loadMaterialList();
}

// 최초 로딩
document.addEventListener("DOMContentLoaded", loadMaterialList);
</script>

</body>
</html>
