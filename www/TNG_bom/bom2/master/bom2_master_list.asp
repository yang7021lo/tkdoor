<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT m.master_id, m.item_no, m.item_name, m.is_active, m.cdate, o.origin_type_no, o.origin_name " & _
      "FROM bom2_master m " & _
      "JOIN bom2_origin_type o " & _
      "ON m.origin_type_no = o.origin_type_no " & _
      "ORDER BY m.master_id DESC"

Rs.Open sql, Dbcon
%>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0">Master 관리</h5>
    <button class="btn btn-sm btn-primary" onclick="openMasterAdd()">추가</button>
</div>

<table class="table table-bordered table-hover" id="masterTable">
<thead class="table-light">
<tr>
    <th style="width:80px;">ID</th>
    <th>품목명</th>
    <th style="width:140px;">원산구분</th>
    <th style="width:100px;">상태</th>
    <th style="width:140px;">등록일</th>
    <th style="width:120px;">관리</th>
</tr>
</thead>
<tbody>
<%
If Not (Rs.EOF Or Rs.BOF) Then
    Do While Not Rs.EOF

Dim statusText
If CInt(Rs("is_active")) = 1 Then
    statusText = "사용"
Else
    statusText = "중지"
End If
%>
<tr data-id="<%=Rs("master_id")%>"
    >
    <td><%=Rs("item_no")%></td>
    <td class="master-name" onclick="openMaterialPopup(<%=Rs("master_id")%>, <%=Rs("is_active")%>)" style="cursor:pointer;">
    <%=Rs("item_name")%></td>

    <td class="master-origin"
        data-origin-id="<%=Rs("origin_type_no")%>">
        <%=Rs("origin_name")%>
    </td>

    <td class="master-status"><%=statusText%></td>
    <td><%=Left(CStr(Rs("cdate")), 10)%></td>
    <td>
    <% If CInt(Rs("is_active")) = 1 Then %>
<button class="btn btn-sm btn-outline-secondary"
        onclick="event.stopPropagation(); editMasterRow(this)">
    수정
</button>

<button class="btn btn-sm btn-danger"
  onclick="location.href='common/bom2_master_deactivate.asp?master_id=<%=Rs("master_id")%>'">
  중지
</button>
<% End If %>
    </td>
</tr>
<%
        Rs.MoveNext
    Loop
Else
%>
<tr>
    <td colspan="6" class="text-center text-muted">데이터 없음</td>
</tr>
<%
End If
%>
</tbody>
</table>

<%
Rs.Close
Set Rs = Nothing
%>