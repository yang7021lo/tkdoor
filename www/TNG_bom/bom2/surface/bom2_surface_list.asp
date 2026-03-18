<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT " & _
      "S.surface_id, S.master_id, " & _
      "M.item_no, M.item_name AS master_name, " & _
      "S.surface_name, S.surface_code, S.vender_id, S.memo, S.midx, S.meidx " & _
      "FROM bom2_surface S " & _
      "INNER JOIN bom2_master M ON S.master_id = M.master_id " & _
      "WHERE s.is_active=1 " & _
      "ORDER BY S.surface_id DESC"

Rs.Open sql, Dbcon

' ===============================
' master 옵션 (status=1)
' ===============================
Dim RsM, sqlM
Set RsM = Server.CreateObject("ADODB.Recordset")

sqlM = "SELECT master_id, item_no, item_name " & _
       "FROM bom2_master " & _
       "WHERE is_active = 1 " & _
       "ORDER BY item_no ASC"
RsM.Open sqlM, Dbcon
%>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="mb-0">표면(Surface) 관리</h5>
  <button class="btn btn-sm btn-primary" onclick="addSurfaceRow()">추가</button>
</div>

<!-- 🔥 master 옵션 템플릿 -->
<select id="surfaceMasterOptions" class="d-none">
  <option value="">선택</option>
  <%
    Do While Not RsM.EOF
  %>
    <option value="<%=RsM("master_id")%>">
      <%=RsM("item_no")%>(<%=RsM("item_name")%>)
    </option>
  <%
      RsM.MoveNext
    Loop
  %>
</select>

<table class="table table-bordered table-hover" id="surfaceTable">
<thead class="table-light">
<tr>
  <th style="width:200px;">Master</th>
<th>Surface 명</th>
<th style="width:140px;">Surface Code</th>
<th style="width:120px;">Vender</th>
<th>메모</th>
  <th style="width:80px;">작성</th>
  <th style="width:80px;">수정</th>
  <th style="width:120px;"></th>
</tr>
</thead>
<tbody>
<%
If Not (Rs.EOF Or Rs.BOF) Then
  Do While Not Rs.EOF
%>
<tr data-id="<%=Rs("surface_id")%>"
    data-master="<%=Rs("master_id")%>">

<td class="surface-master-text">
  <%=Rs("item_no")%>(<%=Rs("master_name")%>)
</td>
<td class="surface-name"><%=Rs("surface_name")%></td>
<td class="surface-code"><%=Rs("surface_code")%></td>
<td class="surface-vender"><%=Rs("vender_id")%></td>
<td class="surface-memo"><%=Rs("memo")%></td>
  <td><%=Rs("midx")%></td>
  <td><%=Rs("meidx")%></td>
  <td>
    <button class="btn btn-sm btn-outline-secondary"
        onclick="editSurfaceRow(this)">수정</button>
<button
  class="btn btn-sm btn-danger"
  onclick="openDeactivate('surface', <%=Rs("surface_id")%>)">
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

<%
Rs.Close : Set Rs = Nothing
RsM.Close : Set RsM = Nothing
call DbClose()
%>
