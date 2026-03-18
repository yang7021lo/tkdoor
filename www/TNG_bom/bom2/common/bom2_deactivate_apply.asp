<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id
If IsNumeric(Request("master_id")) Then
    master_id = CLng(Request("master_id"))
Else
    Response.Write "잘못된 접근입니다."
    Response.End
End If

Dim rs, sql, item_name
Set rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT item_name FROM bom2_master WHERE master_id=" & master_id
rs.Open sql, Dbcon
If rs.EOF Then
    Response.Write "MASTER NOT FOUND"
    Response.End
End If
item_name = rs("item_name")
rs.Close
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Master 비활성화 처리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
<form method="post" action="bom2_master_deactivate_process.asp">
<input type="hidden" name="master_id" value="<%=master_id%>">

<div class="card shadow-sm">
<div class="card-body">

<h5 class="mb-3 text-danger">🔒 <%=item_name%> 비활성화</h5>

<!-- ================= MATERIAL ================= -->
<h6 class="mt-4">
  <input type="checkbox" id="chk_all_material" checked
         onclick="toggleAll('material', this.checked)">
  Material
</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th style="width:40px;"></th>
  <th>Material명</th>
  <th>길이</th>
  <th>표면처리</th>
  <th>금형</th>
  <th>단위</th>
  <th>세트</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT m.material_id, m.material_name, " & _
      "l.bom_length, s.surface_name, mo.mold_name, " & _
      "m.unity_type, m.set_yn " & _
      "FROM bom2_material m " & _
      "LEFT JOIN bom2_length  l  ON m.length_id  = l.length_id " & _
      "LEFT JOIN bom2_surface s  ON m.surface_id = s.surface_id " & _
      "LEFT JOIN bom2_mold    mo ON m.mold_id    = mo.mold_id " & _
      "WHERE m.master_id=" & master_id

Set rs = Dbcon.Execute(sql)

If rs.EOF Then
%>
<tr><td colspan="7" class="text-center text-muted">데이터 없음</td></tr>
<%
Else
Do Until rs.EOF
%>
<tr>
  <td class="text-center">
    <input type="checkbox" name="material_id[]"
           value="<%=rs("material_id")%>"
           data-group="material" checked
           onclick="syncGroup('material')">
  </td>
  <td><%=rs("material_name")%></td>
  <td><%=rs("bom_length") & ""%></td>
  <td><%=rs("surface_name") & ""%></td>
  <td><%=rs("mold_name") & ""%></td>
  <td><%=rs("unity_type") & ""%></td>
  <td class="text-center">
<%
Dim setText
setText = "-"
If Not IsNull(rs("set_yn")) Then
  If CStr(rs("set_yn")) = "1" Then setText = "Y"
End If
Response.Write setText
%>
</td>
</tr>
<%
rs.MoveNext
Loop
End If
rs.Close
%>
</tbody>
</table>

<!-- ================= MOLD ================= -->
<h6 class="mt-4">
  <input type="checkbox" id="chk_all_mold" checked
         onclick="toggleAll('mold', this.checked)">
  Mold
</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th style="width:40px;"></th>
  <th>금형명</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT DISTINCT mo.mold_id, mo.mold_name " & _
      "FROM bom2_material m " & _
      "JOIN bom2_mold mo ON m.mold_id = mo.mold_id " & _
      "WHERE m.master_id=" & master_id

Set rs = Dbcon.Execute(sql)
If rs.EOF Then
%>
<tr><td colspan="2" class="text-center text-muted">데이터 없음</td></tr>
<%
Else
Do Until rs.EOF
%>
<tr>
  <td class="text-center">
    <input type="checkbox" name="mold_id[]"
           value="<%=rs("mold_id")%>"
           data-group="mold" checked
           onclick="syncGroup('mold')">
  </td>
  <td><%=rs("mold_name")%></td>
</tr>
<%
rs.MoveNext
Loop
End If
rs.Close
%>
</tbody>
</table>

<!-- ================= LENGTH ================= -->
<h6 class="mt-4">
  <input type="checkbox" id="chk_all_length" checked
         onclick="toggleAll('length', this.checked)">
  Length
</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th style="width:40px;"></th>
  <th>길이</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT length_id, bom_length FROM bom2_length " & _
      "WHERE master_id=" & master_id & " AND is_active=1"

Set rs = Dbcon.Execute(sql)
If rs.EOF Then
%>
<tr><td colspan="2" class="text-center text-muted">데이터 없음</td></tr>
<%
Else
Do Until rs.EOF
%>
<tr>
  <td class="text-center">
    <input type="checkbox" name="length_id[]"
           value="<%=rs("length_id")%>"
           data-group="length" checked
           onclick="syncGroup('length')">
  </td>
  <td><%=rs("bom_length")%></td>
</tr>
<%
rs.MoveNext
Loop
End If
rs.Close
%>
</tbody>
</table>

<!-- ================= SURFACE ================= -->
<h6 class="mt-4">
  <input type="checkbox" id="chk_all_surface" checked
         onclick="toggleAll('surface', this.checked)">
  표면처리
</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th style="width:40px;"></th>
  <th>표면처리명</th>
  <th>Code</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT surface_id, surface_name, surface_code FROM bom2_surface " & _
      "WHERE master_id=" & master_id & " AND is_active=1"

Set rs = Dbcon.Execute(sql)
If rs.EOF Then
%>
<tr><td colspan="3" class="text-center text-muted">데이터 없음</td></tr>
<%
Else
Do Until rs.EOF
%>
<tr>
  <td class="text-center">
    <input type="checkbox" name="surface_id[]"
           value="<%=rs("surface_id")%>"
           data-group="surface" checked
           onclick="syncGroup('surface')">
  </td>
  <td><%=rs("surface_name")%></td>
  <td><%=rs("surface_code") & ""%></td>
</tr>
<%
rs.MoveNext
Loop
End If
rs.Close
%>
</tbody>
</table>

<hr>

<!-- ================= LIST TITLE ================= -->
<h6 class="mt-4">
  <input type="checkbox" id="chk_all_title" checked
         onclick="toggleAll('title', this.checked)">
  List Title
</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th style="width:40px;"></th>
  <th>컬럼명</th>
  <th>단위</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT list_title_id, title_name, density " & _
      "FROM bom2_list_title " & _
      "WHERE master_id=" & master_id & " AND is_active=1 " & _
      "ORDER BY list_title_id"

Set rs = Dbcon.Execute(sql)

If rs.EOF Then
%>
<tr>
  <td colspan="3" class="text-center text-muted">데이터 없음</td>
</tr>
<%
Else
Do Until rs.EOF
%>
<tr>
  <td class="text-center">
    <input type="checkbox" name="title_id[]"
           value="<%=rs("list_title_id")%>"
           data-group="title" checked
           onclick="syncGroup('title')">
  </td>
  <td><%=rs("title_name")%></td>
  <td><%=rs("density") & ""%></td>
</tr>
<%
rs.MoveNext
Loop
End If
rs.Close
%>
</tbody>
</table>


<div class="mt-4 d-flex gap-2">
  <button type="submit" class="btn btn-danger">
    선택 항목 비활성화 실행
  </button>
  <a href="../bom2_main.asp" class="btn btn-secondary">
    취소
  </a>
</div>

</div>
</div>
</form>
</div>

<script>
function toggleAll(group, checked){
  document
    .querySelectorAll('input[data-group="'+group+'"]')
    .forEach(cb => cb.checked = checked);
}

function syncGroup(group){
  const all = document.querySelectorAll('input[data-group="'+group+'"]');
  const checked = document.querySelectorAll('input[data-group="'+group+'"]:checked');
  const master = document.getElementById('chk_all_' + group);
  if(master) master.checked = (all.length === checked.length);
}
</script>

</body>
</html>

<%
call DbClose()
%>
