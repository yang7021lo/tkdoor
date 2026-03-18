
<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<!--#include virtual="/TNG_bom/bom2/common/deactivate_config.asp"-->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()
%>
 
<%
targetType = LCase(Request("type"))
targetId   = CLng(Request("id"))

Set cfg = GetDeactivateConfig(targetType)
If cfg Is Nothing Then
    Response.Write "INVALID TYPE"
    Response.End
End If
%>

<h5 class="text-danger">
  🔒 <%=cfg("label")%> 비활성화
</h5>

<p class="text-muted">
  해당 <%=cfg("label")%>를 사용하는 Material이 존재합니다.<br>
  먼저 Material을 비활성화해야 합니다.
</p>

<form method="post" action="deactivate_process.asp">
<input type="hidden" name="type" value="<%=targetType%>">
<input type="hidden" name="id" value="<%=targetId%>">

<!-- Material 목록 테이블 -->
<table class="table table-sm table-bordered">
<thead>
<tr>
  <th><input type="checkbox" checked onclick="toggleAll(this)"></th>
  <th>Material명</th>
</tr>
</thead>
<tbody>
<%
sql = Replace(cfg("material_sql"), "@id", targetId)
Set rs = Dbcon.Execute(sql)

If rs.EOF Then
%>

<p class="text-muted">
  연결된 Material이 없습니다.<br>
  바로 <strong><%=cfg("label")%></strong> 비활성화를 진행할 수 있습니다.
</p>

<form method="post" action="deactivate_process.asp">
  <input type="hidden" name="type" value="<%=targetType%>">
  <input type="hidden" name="id" value="<%=targetId%>">

  <button class="btn btn-danger">비활성화 실행</button>
  <a href="javascript:history.back()" class="btn btn-secondary">취소</a>
</form>

<%
Else
%>

<p class="text-danger fw-bold">
  ⚠ 해당 <%=cfg("label")%>를 사용하는 Material이 존재합니다.<br>
  먼저 Material을 비활성화해야 합니다.
</p>

<form method="post" action="deactivate_process.asp">
<input type="hidden" name="type" value="<%=targetType%>">
<input type="hidden" name="id" value="<%=targetId%>">

<table class="table table-sm table-bordered">
<thead>
<tr>
  <th style="width:40px;">
    <input type="checkbox" checked onclick="toggleAll(this)">
  </th>
  <th>Material명</th>
</tr>
</thead>
<tbody>
<%
Do Until rs.EOF
%>
<tr>
  <td>
    <input type="checkbox" name="material_id[]"
           value="<%=rs("material_id")%>" checked>
  </td>
  <td><%=rs("material_name")%></td>
</tr>
<%
rs.MoveNext
Loop
%>
</tbody>
</table>

<button class="btn btn-danger">비활성화 실행</button>
<a href="javascript:history.back()" class="btn btn-secondary">취소</a>

</form>

<%
End If
rs.Close
%>

</tbody>
</table>

<button class="btn btn-danger">비활성화 실행</button>
<a href="javascript:history.back()" class="btn btn-secondary">취소</a>

</form>
