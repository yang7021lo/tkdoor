<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Call DbOpen()

Dim master_id
If IsNumeric(Request("master_id")) Then
    master_id = CLng(Request("master_id"))
Else
    Response.Write "잘못된 접근입니다."
    Response.End
End If

Dim rs, sql, item_name
Set rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT item_name FROM bom3_master WHERE master_id=" & master_id
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
<form method="post" action="bom3_master_deactivate_process.asp">
<input type="hidden" name="master_id" value="<%=master_id%>">

<div class="card shadow-sm">
<div class="card-body">

<h5 class="mb-3 text-danger">🔒 <%=item_name%> 비활성화</h5>

<!-- ================= MATERIAL ================= -->
<h6 class="mt-4">Material</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th>Material명</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT material_name " & _
      "FROM bom3_material " & _
      "WHERE master_id=" & master_id & " AND is_active=1 " & _
      "ORDER BY material_id"

Set rs = Dbcon.Execute(sql)

If rs.EOF Then
%>
<tr><td class="text-center text-muted">데이터 없음</td></tr>
<%
Else
  Do Until rs.EOF
%>
<tr>
  <td><%=rs("material_name")%></td>
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
<h6 class="mt-4">List Title</h6>

<table class="table table-sm table-bordered">
<thead class="table-light">
<tr>
  <th>Title</th>
</tr>
</thead>
<tbody>
<%
sql = "SELECT tt.title_name, tt.density " & _
      "FROM bom3_list_title tt " & _
      "WHERE tt.master_id=" & master_id & " " & _
      "  AND tt.is_active = 1 " & _
      "ORDER BY tt.list_title_id ASC"

Set rs = Dbcon.Execute(sql)

If rs.EOF Then
%>
<tr><td class="text-center text-muted">데이터 없음</td></tr>
<%
Else
  Do Until rs.EOF
%>
<tr>
  <td>
    <strong><%=rs("title_name")%></strong>
    <span class="text-muted ms-2"><%=rs("density") & ""%></span>
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

<div class="alert alert-warning py-2 mb-3" role="alert" style="margin-bottom:12px;">
  <strong>주의:</strong> 비활성화 실행 후에는 <b>복구할 수 없습니다.
</div>
<div class="mt-4 d-flex gap-2">
  <button type="submit" class="btn btn-danger">
    비활성화 실행
  </button>
  <a href="../bom3_main.asp" class="btn btn-secondary">
    취소
  </a>
</div>

</div>
</div>
</form>
</div>

</body>
</html>

<%
Call DbClose()
%>
