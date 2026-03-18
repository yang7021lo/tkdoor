<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' master_id
' ===============================
Dim master_id
If IsNumeric(Request("master_id")) Then
    master_id = CLng(Request("master_id"))
Else
    Response.Write "INVALID MASTER"
    Response.End
End If

' ===============================
' Master
' ===============================
Dim RsMaster, sqlMaster
Set RsMaster = Server.CreateObject("ADODB.Recordset")

sqlMaster = "SELECT item_no, item_name FROM bom2_master WHERE master_id=" & master_id
RsMaster.Open sqlMaster, Dbcon

If RsMaster.EOF Then
    Response.Write "MASTER NOT FOUND"
    Response.End
End If

Dim master_item_no, master_item_name
master_item_no   = RsMaster("item_no")
master_item_name = RsMaster("item_name")

' ===============================
' Material
' ===============================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT m.material_id, m.master_id, " & _
      "ma.item_no, ma.item_name, " & _
      "m.material_name, " & _
      "m.length_id, m.surface_id, m.mold_id, " & _
      "l.bom_length, s.surface_name, mo.mold_name, " & _
      "m.unity_type, m.set_yn " & _
      "FROM bom2_material m " & _
      "JOIN bom2_master ma ON m.master_id = ma.master_id " & _
      "LEFT JOIN bom2_length  l  ON m.length_id  = l.length_id " & _
      "LEFT JOIN bom2_surface s  ON m.surface_id = s.surface_id " & _
      "LEFT JOIN bom2_mold    mo ON m.mold_id    = mo.mold_id " & _
      "WHERE m.master_id = " & master_id & " AND m.is_active = 1 " & _
      "ORDER BY m.material_id DESC"

Rs.Open sql, Dbcon 

' ===============================
' Options
' ===============================
Dim RsMold, RsLen, RsSurf
Set RsMold = Server.CreateObject("ADODB.Recordset")
Set RsLen  = Server.CreateObject("ADODB.Recordset")
Set RsSurf = Server.CreateObject("ADODB.Recordset")

RsMold.Open "SELECT mold_id, mold_name FROM bom2_mold WHERE master_id=" & master_id & " and is_active=1 ORDER BY mold_name", Dbcon
RsLen.Open  "SELECT length_id, bom_length FROM bom2_length WHERE master_id=" & master_id & " and is_active=1 ORDER BY bom_length", Dbcon
RsSurf.Open "SELECT surface_id, surface_name FROM bom2_surface where master_id=" & master_id & " and is_active=1 ORDER BY surface_name", Dbcon

' ===============================
' Title
' ===============================
Dim RsTitle, sqlTitle
Set RsTitle = Server.CreateObject("ADODB.Recordset")

sqlTitle = _
"SELECT t.list_title_id, t.title_name, t.density, t.type_id " & _
"FROM bom2_list_title t " & _
"WHERE t.master_id=" & master_id & " AND t.is_active=1 " & _
"ORDER BY t.list_title_id"
' sqlTitle = "SELECT list_title_id, title_name, density FROM bom2_list_title WHERE master_id=" & master_id & " and is_active=1 ORDER BY list_title_id"
RsTitle.Open sqlTitle, Dbcon

If Not (RsTitle.EOF Or RsTitle.BOF) Then
    RsTitle.MoveFirst
End If

' ===============================
' Material Value (table_value)
' ===============================
Dim RsVal, sqlVal
Set RsVal = Server.CreateObject("ADODB.Recordset")

sqlVal = "SELECT v.material_id, v.list_title_id, v.value " & _
         "FROM bom2_table_value v " & _
         "JOIN bom2_material m ON v.material_id = m.material_id " & _
         "WHERE v.is_active = 1 AND m.master_id = " & master_id

RsVal.Open sqlVal, Dbcon

' material_id → (title_id → value)
Dim dictVal, mid, tid
Set dictVal = Server.CreateObject("Scripting.Dictionary")

Do While Not RsVal.EOF
    mid = RsVal("material_id")
    tid = RsVal("list_title_id")

    If Not dictVal.Exists(mid) Then
        Set dictVal(mid) = Server.CreateObject("Scripting.Dictionary")
    End If

    dictVal(mid)(tid) = RsVal("value")
    RsVal.MoveNext
Loop

RsVal.Close
Set RsVal = Nothing

%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>원자재 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4 bg-light">

<script>
const MASTER_ID = <%=master_id%>;
</script>

<h4>원자재 관리</h4>
<div class="text-muted mb-3">
  Master : <strong><%=master_item_no%> (<%=master_item_name%>)</strong>
</div>

<div class="text-end mb-2">
  <button class="btn btn-sm btn-primary" onclick="addMaterialRow()">+ Material 추가</button>
</div>

<!-- option templates -->
<select id="moldOptions" class="d-none">
<option value="">선택</option>
<% Do While Not RsMold.EOF %>
<option value="<%=RsMold("mold_id")%>"><%=RsMold("mold_name")%></option>
<% RsMold.MoveNext : Loop %>
</select>

<select id="lengthOptions" class="d-none">
<option value="">선택</option>
<% Do While Not RsLen.EOF %>
<option value="<%=RsLen("length_id")%>"><%=RsLen("bom_length")%></option>
<% RsLen.MoveNext : Loop %>
</select>

<select id="surfaceOptions" class="d-none">
<option value="">선택</option>
<% Do While Not RsSurf.EOF %>
<option value="<%=RsSurf("surface_id")%>"><%=RsSurf("surface_name")%></option>
<% RsSurf.MoveNext : Loop %>
</select>

<script>
const TITLE_LIST = [
<%
RsTitle.MoveFirst
Do While Not RsTitle.EOF
%>
{
  id: <%=RsTitle("list_title_id")%>,
  name: "<%=RsTitle("title_name")%>",
  type: "<%=RsTitle("type_id")%>"
}
<%
RsTitle.MoveNext
If Not RsTitle.EOF Then Response.Write(",")
Loop
%>
];
</script>

<table class="table table-bordered" id="materialTable">
<thead class="table-light">
<tr>
  <th style="width:80px;">Master</th>
  <th>원자재</th>
  <th>길이</th>
  <th>표면처리</th>
  <th>금형명</th>
  <th>단위</th>
  <th>세트</th>

  <% RsTitle.MoveFirst
     Do While Not RsTitle.EOF
  %>
    <th><%=RsTitle("title_name")%></th>
  <%
     RsTitle.MoveNext
     Loop
  %>
  <th style="width:120px;">관리</th>
</tr>
</thead>

<tbody>

<%
If Rs.EOF Then
%>
<tr class="text-center text-muted">
<td colspan="<%=7 + RsTitle.RecordCount%>">등록된 Material 이 없습니다.</td>
</tr>
<%
Else
Do While Not Rs.EOF
%>
<tr data-id="<%=Rs("material_id")%>"
    data-length-id="<%=Rs("length_id")%>"
    data-surface-id="<%=Rs("surface_id")%>"
    data-mold-id="<%=Rs("mold_id")%>">
  <td>
    <strong><%=Rs("item_no")%></strong><br>
    <small class="text-muted"><%=Rs("item_name")%></small>
  </td>

  <td><%=Rs("material_name")%></td>
  <td><%=Rs("bom_length")%></td>
  <td><%=Rs("surface_name")%></td>
  <td><%=Rs("mold_name")%></td>
  <td><%=Rs("unity_type")%></td>
  <td class="text-center">
    <% If Rs("set_yn") = 1 Then Response.Write("Y") Else Response.Write("-") End If %>
  </td>

  <% RsTitle.MoveFirst
     Do While Not RsTitle.EOF
  %>
    <%

Dim v
v = "-"
If dictVal.Exists(CLng(Rs("material_id"))) Then
    If dictVal(CLng(Rs("material_id"))).Exists(CLng(RsTitle("list_title_id"))) Then
        v = dictVal(CLng(Rs("material_id")))(CLng(RsTitle("list_title_id")))
    End If
End If

Dim typeId
typeId = CStr(RsTitle("type_id"))

If v = "-" Then
    Response.Write("<td>-</td>")
Else
    Select Case typeId

    Case "4" ' checkbox
        If v = "1" Or LCase(v) = "y" Or LCase(v) = "true" Then
            Response.Write("<td class='text-center'>✔</td>")
        Else
            Response.Write("<td class='text-center'>-</td>")
        End If

    Case "2" ' number
        If Trim(RsTitle("density") & "") <> "" Then
            Response.Write("<td>" & v & " " & RsTitle("density") & "</td>")
        Else
            Response.Write("<td>" & v & "</td>")
        End If

    Case Else ' text
        Response.Write("<td>" & v & "</td>")

    End Select
End If

%>
  <%
     RsTitle.MoveNext
     Loop
  %>

  <td>
    <button class="btn btn-sm btn-outline-secondary"
            onclick="event.stopPropagation(); editMaterialRow(this);">
      수정
    </button>

      <button class="btn btn-sm btn-danger"
          onclick="event.stopPropagation(); deactivateMaterial(<%=Rs("material_id")%>)">
    삭제
  </button>
  </td>
</tr>
<%
Rs.MoveNext
Loop
End If
%>

</tbody>
</table>

<script>
function cloneOptions(id){
  return document.getElementById(id).innerHTML;
}

function deactivateMaterial(materialId){
  if(!confirm("해당 Material을 삭제하시겠습니까?")) return;

  fetch("bom2_material_deactivate.asp", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: "material_id=" + materialId
  })
  .then(r => r.text())
  .then(res => {
    if(res === "OK"){
      location.reload();
    }else{
      alert("삭제 실패 : " + res);
    }
  });
}

function buildInfoList(row){
  let r=[];
  row.querySelectorAll("[data-title-id]").forEach(e=>{
    let v = "";

    if(e.type === "checkbox"){
      v = e.checked ? "1" : "";
    }else{
      v = (e.value || "").trim();
    }

    if(v !== ""){
      r.push(e.dataset.titleId + ":" + v);
    }
  });
  return r.join("|");
}

/* ===============================
   INSERT
================================ */
function addMaterialRow(){
  const tbody = document.querySelector("#materialTable tbody");
  if(!tbody) return;

  tbody.querySelectorAll(".text-muted").forEach(tr=>tr.remove());
  if(tbody.querySelector(".material-insert-row")) return;

  const tr = document.createElement("tr");
  tr.className = "material-insert-row";

  let html = `
    <td>
      <strong><%=master_item_no%></strong><br>
      <small class="text-muted"><%=master_item_name%></small>
    </td>

    <td><input name="material_name" class="form-control form-control-sm"></td>

    <td>
      <select name="length_id" class="form-select form-select-sm">
        ${cloneOptions("lengthOptions")}
      </select>
    </td>

    <td>
      <select name="surface_id" class="form-select form-select-sm">
        ${cloneOptions("surfaceOptions")}
      </select>
    </td>

    <td>
      <select name="mold_id" class="form-select form-select-sm">
        ${cloneOptions("moldOptions")}
      </select>
    </td>

    <td><input name="unity_type" class="form-control form-control-sm"></td>

    <td class="text-center">
      <input type="checkbox" name="set_yn">
    </td>
  `;
TITLE_LIST.forEach(t=>{
  if(t.type === "4"){
    html += `
      <td class="text-center">
        <input type="checkbox"
               data-title-id="${t.id}"
               value="1">
      </td>`;
  }else if(t.type === "2"){
    html += `
      <td>
        <input type="number"
               class="form-control form-control-sm"
               data-title-id="${t.id}">
      </td>`;
  }else{
    html += `
      <td>
        <input type="text"
               class="form-control form-control-sm"
               data-title-id="${t.id}">
      </td>`;
  }
});

  html += `
    <td>
      <button class="btn btn-sm btn-success me-1" type="button"
              onclick="saveMaterialInsert(this)">
        저장
      </button>
      <button class="btn btn-sm btn-secondary" type="button"
              onclick="cancelMaterialInsert(this)">
        취소
      </button>
    </td>
  `;

  tr.innerHTML = html;
  tbody.prepend(tr);

  bindEditKeys(tr,
  () => saveMaterialInsert(tr.querySelector("button.btn-success")),
  () => cancelMaterialInsert(tr.querySelector("button.btn-secondary"))
  );
}

function saveMaterialInsert(btn){
  const row = btn.closest("tr");
  if(!row) return alert("입력 행을 찾을 수 없습니다.");

  const params = new URLSearchParams({
    master_id: MASTER_ID,
    material_name: row.querySelector("[name='material_name']").value,
    length_id: row.querySelector("[name='length_id']").value,
    surface_id: row.querySelector("[name='surface_id']").value,
    mold_id: row.querySelector("[name='mold_id']").value,
    unity_type: row.querySelector("[name='unity_type']").value,
    set_yn: row.querySelector("[name='set_yn']").checked ? 1 : 0,
    info_list: buildInfoList(row)
  });

  fetch("bom2_material_save.asp",{
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body: params
  })
  .then(r=>r.text())
  .then(t=>{
    if(t==="OK") location.reload();
    else alert(t);
  });
}

function cancelMaterialInsert(btn){
  const tr = btn.closest("tr");
  if(tr) tr.remove();
}

/* ===============================
   UPDATE
================================ */
function editMaterialRow(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  // 중복 편집 방지
  if(tr.classList.contains("material-edit-row")) return;
  tr.classList.add("material-edit-row");

  // 원본 백업
  tr.dataset.oldHtml = tr.innerHTML;

  const tds = tr.querySelectorAll("td");

  // 값 추출
  const oldMaterialName = tds[1].innerText.trim();
  const oldUnityType    = tds[5].innerText.trim();
  const oldSetYn        = (tds[6].innerText.trim() === "Y");

  // Material명
  tds[1].innerHTML =
    `<input class="form-control form-control-sm" name="material_name" value="${oldMaterialName}">`;

  // Length
  tds[2].innerHTML =
    `<select name="length_id" class="form-select form-select-sm">
      ${cloneOptions("lengthOptions")}
    </select>`;
  tds[2].querySelector("select").value = tr.dataset.lengthId || "";

  // Surface
  tds[3].innerHTML =
    `<select name="surface_id" class="form-select form-select-sm">
      ${cloneOptions("surfaceOptions")}
    </select>`;
  tds[3].querySelector("select").value = tr.dataset.surfaceId || "";

  // Mold
  tds[4].innerHTML =
    `<select name="mold_id" class="form-select form-select-sm">
      ${cloneOptions("moldOptions")}
    </select>`;
  tds[4].querySelector("select").value = tr.dataset.moldId || "";

  // 단위
  tds[5].innerHTML =
    `<input class="form-control form-control-sm" name="unity_type" value="${oldUnityType}">`;

  // 세트
  tds[6].innerHTML =
    `<input type="checkbox" name="set_yn" ${oldSetYn ? "checked" : ""}>`;

  // TITLE 컬럼들(숫자만)
let col = 7;
TITLE_LIST.forEach(t=>{
  const val = (tds[col].innerText || "").trim();

  if(t.type === "4"){ // checkbox
    const checked = (val === "✔");
    tds[col].innerHTML =
      `<input type="checkbox"
              data-title-id="${t.id}"
              ${checked ? "checked" : ""}>`;

  }else if(t.type === "2"){ // number
    tds[col].innerHTML =
      `<input type="number"
              class="form-control form-control-sm"
              data-title-id="${t.id}"
              value="${val === "-" ? "" : val}">`;

  }else{ // text
    tds[col].innerHTML =
      `<input type="text"
              class="form-control form-control-sm"
              data-title-id="${t.id}"
              value="${val === "-" ? "" : val}">`;
  }

  col++;
});

  // 관리 버튼
  tds[col].innerHTML = `
    <button class="btn btn-sm btn-success me-1" type="button"
            onclick="saveMaterialUpdate(this)">
      저장
    </button>
    <button class="btn btn-sm btn-secondary" type="button"
            onclick="cancelMaterialEdit(this)">
      취소
    </button>
  `;

  bindEditKeys(tr,
  () => saveMaterialUpdate(tr.querySelector("button.btn-success")),
  () => cancelMaterialEdit(tr.querySelector("button.btn-secondary"))
  );
}

function saveMaterialUpdate(btn){
  const tr = btn.closest("tr");
  if(!tr) return;

  const params = new URLSearchParams({
    material_id: tr.dataset.id,
    material_name: tr.querySelector("[name='material_name']").value,
    length_id: tr.querySelector("[name='length_id']").value,
    surface_id: tr.querySelector("[name='surface_id']").value,
    mold_id: tr.querySelector("[name='mold_id']").value,
    unity_type: tr.querySelector("[name='unity_type']").value,
    set_yn: tr.querySelector("[name='set_yn']").checked ? 1 : 0,
    info_list: buildInfoList(tr)
  });

  fetch("bom2_material_update.asp",{
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded" },
    body: params
  })
  .then(r=>r.text())
  .then(res=>{
    if(res==="OK"){
      location.reload();
    }else{
      alert("수정 실패 : " + res);
    }
  });
}

function cancelMaterialEdit(btn){
  const tr = btn.closest("tr");
  if(!tr) return;
  tr.innerHTML = tr.dataset.oldHtml;
  tr.classList.remove("material-edit-row");
}


function bindEditKeys(row, onSave, onCancel){
  row.querySelectorAll("input, select").forEach(el=>{
    el.addEventListener("keydown", function(e){
      // Enter = 저장
      if(e.key === "Enter"){
        e.preventDefault();
        onSave();
      }

      // ESC = 취소
      if(e.key === "Escape"){
        e.preventDefault();
        onCancel();
      }
    });
  });
}

// 전역 노출(팝업/다른 스크립트 대비)
window.addMaterialRow = addMaterialRow;
window.saveMaterialInsert = saveMaterialInsert;
window.editMaterialRow = editMaterialRow;
window.saveMaterialUpdate = saveMaterialUpdate;
</script>

</body>
</html>
