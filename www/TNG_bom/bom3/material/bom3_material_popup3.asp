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
  <button class="btn btn-sm btn-primary" onclick="addMaterialRow()">+ Material 추가</button>
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
Sub RenderTitleGroup(q)
    Dim rT, rS
    Set rT = Server.CreateObject("ADODB.Recordset")
    rT.Open q, Dbcon

    Do While Not rT.EOF

        If rT("is_sub") = 0 Then
%>
  <th data-title-id="<%=rT("list_title_id")%>"><%=rT("title_name")%></th>
<%
        Else
            ' SUB 타이틀 → sub 컬럼 확장
            Set rS = Server.CreateObject("ADODB.Recordset")
            rS.Open _
              "SELECT title_sub_id, sub_name, is_select, is_show " & _
              "FROM bom3_list_title_sub " & _
              "WHERE is_active=1 AND list_title_id=" & rT("list_title_id") & _
              " AND (is_select=1 OR is_show=1) " & _
              "ORDER BY CASE WHEN is_select=1 THEN 0 ELSE 1 END, title_sub_id", Dbcon

            Do While Not rS.EOF
%>
  <th
  data-sub-id="<%=rS("title_sub_id")%>"
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

        rT.MoveNext
    Loop

    rT.Close
    Set rT = Nothing
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

<tbody>
<%
' ==================================================
' Material 목록
' ==================================================
Dim RsMat, sqlMat
Set RsMat = Server.CreateObject("ADODB.Recordset")

sqlMat = _
"SELECT material_id, material_name " & _
"FROM bom3_material " & _
"WHERE is_active=1 AND master_id=" & master_id & _
" ORDER BY material_id"

RsMat.Open sqlMat, Dbcon

If RsMat.EOF Then
%>
<tr>
  <td colspan="100" class="text-center text-muted">Material 데이터 없음</td>
</tr>
<%
Else
Do While Not RsMat.EOF
%>

<tr data-material-id="<%=RsMat("material_id")%>">

  <td><%=master_name%></td>

  <td>
    <input type="text" class="form-control form-control-sm"
           value="<%=RsMat("material_name")%>">
  </td>

<%
' ==================================================
' SUB / 일반 컬럼 td 생성
' ==================================================
Dim RsC
Set RsC = Server.CreateObject("ADODB.Recordset")

RsC.Open _
"SELECT t.list_title_id, t.is_sub, s.title_sub_id, s.is_select, s.is_show " & _
"FROM bom3_list_title t " & _
"LEFT JOIN bom3_list_title_sub s ON t.list_title_id=s.list_title_id " & _
"WHERE t.is_active=1 AND ( " & _
" (t.is_sub=1 AND t.is_common=1) OR " & _
" (t.is_sub=0 AND t.is_common=1) OR " & _
" (t.is_sub=1 AND t.is_common=0 AND EXISTS ( " & _
"   SELECT 1 FROM bom3_title_sub_value v " & _
"   JOIN bom3_list_title_sub s2 ON v.title_sub_id = s2.title_sub_id " & _
"   WHERE s2.list_title_id = t.list_title_id " & _
"     AND v.is_active=1 " & _
"     AND (v.master_id IS NULL OR v.master_id=" & master_id & ") " & _
" )) " & _
" OR (t.is_sub=0 AND t.is_common=0 AND t.master_id=" & master_id & ") ) " & _
"AND (s.is_select=1 OR s.is_show=1 OR s.title_sub_id IS NULL) " & _
"ORDER BY t.list_title_id, CASE WHEN s.is_select=1 THEN 0 ELSE 1 END", Dbcon
Do While Not RsC.EOF
%>
<td>
<%
If RsC("is_sub") = 1 Then
    If RsC("is_select") = 1 Then
%>
<select class="form-select form-select-sm"
        data-role="select-sub"
        data-title-sub-id="<%=RsC("title_sub_id")%>"
        onchange="onSelectSubChange(this)">
  <option value="">선택</option>
</select>
<%
    Else
%>
<input type="text" class="form-control form-control-sm"
       data-role="show-sub"
       data-sub-id="<%=RsC("title_sub_id")%>"
       readonly>
<%
    End If
Else
%>
<input type="text" class="form-control form-control-sm">
<%
End If
%>
</td>
<%
    RsC.MoveNext
Loop

RsC.Close
Set RsC = Nothing
%>

  <td class="text-center">
    <button class="btn btn-sm btn-success">저장</button>
    <button class="btn btn-sm btn-danger">삭제</button>
  </td>
</tr>

<%
  RsMat.MoveNext
Loop
End If

RsMat.Close
Set RsMat = Nothing
%>

</tbody>
</table>
</div>

<script>

window.SHOW_MAP = window.SHOW_MAP || {};

/* =========================================
   select 옵션 + SHOW_MAP 로딩 (유일한 진입점)
========================================= */
function loadSelectOptions(sel){
  const titleSubId = sel.dataset.titleSubId;

  fetch(
    "bom3_material_sub_value_list.asp" +
    "?title_sub_id=" + titleSubId +
    "&master_id=<%=master_id%>"
  )
  .then(r => r.text())
  .then(t => {
    t.trim().split("\n").forEach(line => {
      const [id, text, rowId] = line.split("|");
      if (!id) return;

      // select option
      const opt = document.createElement("option");
      opt.value = id;
      opt.textContent = text;
      opt.dataset.rowId = rowId;
      sel.appendChild(opt);

      // SHOW_MAP[rowId][subId] = text
      if (!SHOW_MAP[rowId]) SHOW_MAP[rowId] = {};
      SHOW_MAP[rowId][titleSubId] = text;
    });
  });
}

/* =========================================
   최초 로딩 시 모든 select 초기화
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

      if (target.tagName === "INPUT") {
        target.value = value;
      } else {
        target.textContent = value;
      }
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

  html += `
    <td>
      <input type="text" class="form-control form-control-sm" data-field="material_name">
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

    if (!subId && titleId) {
      html += `
        <td>
          <input type="text" class="form-control form-control-sm"
                 data-title-id="${titleId}">
        </td>`;
      return;
    }

    if (subId && isSelect) {
      html += `
        <td>
          <select class="form-select form-select-sm"
                  data-role="select-sub"
                  data-title-sub-id="${subId}"
                  onchange="onSelectSubChange(this)">
            <option value="">선택</option>
          </select>
        </td>`;
      return;
    }

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
      <button class="btn btn-sm btn-success">저장</button>
      <button class="btn btn-sm btn-outline-secondary" onclick="cancelNewMaterialRow()">취소</button>
    </td>
  `;

  tr.innerHTML = html;
  tbody.prepend(tr);

  /* 신규 행 select도 동일 함수로 로딩 */
  tr.querySelectorAll("select[data-role='select-sub']")
    .forEach(loadSelectOptions);

  const first = tr.querySelector("[data-field='material_name']");
  if(first) first.focus();
}

function cancelNewMaterialRow(){
  const tr = document.getElementById("materialInsertRow");
  if(tr) tr.remove();
}
</script>

</body>
</html>