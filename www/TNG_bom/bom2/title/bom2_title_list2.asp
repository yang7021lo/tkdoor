<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' TITLE 목록
' ===============================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

Dim cidx
If IsNumeric(Session("cidx")) Then
    cidx = CLng(Session("cidx"))
Else
    Response.Write "NO_CIDX"
    Response.End
End If

sql = "SELECT T.list_title_id, T.master_id, " & _
      "M.item_no, M.item_name AS master_name, " & _
      "T.title_name, T.density " & _
      "FROM bom2_list_title T " & _
      "INNER JOIN bom2_master M ON T.master_id = M.master_id " & _
      "WHERE T.cidx = " & cidx & " " & _
      "and T.is_active=1 " & _
      "ORDER BY T.list_title_id DESC"

Rs.Open sql, Dbcon

' ===============================
' master 옵션 (status = 1) – 인서트/수정용
' ===============================
Dim RsMaster, sqlMaster
Set RsMaster = Server.CreateObject("ADODB.Recordset")

sqlMaster = "SELECT master_id, item_no, item_name " & _
            "FROM bom2_master " & _
            "WHERE is_active = 1 " & _
            "ORDER BY item_no ASC"

RsMaster.Open sqlMaster, Dbcon
%>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0">컬럼명 관리</h5>
    <button class="btn btn-sm btn-primary" onclick="addTitleRow()">추가</button>
</div>

<!-- 🔥 MOLD / SURFACE 와 동일: 숨김 Master 옵션 -->
<select id="titleMasterOptions" class="d-none">
  <option value="">선택</option>
  <%
    Do While Not RsMaster.EOF
  %>
<option value="<%=RsMaster("master_id")%>">
  <%=RsMaster("item_no")%>(<%=RsMaster("item_name")%>)
</option>
  <%
      RsMaster.MoveNext
    Loop
  %>
</select>

<table class="table table-bordered table-hover" id="titleTable">
<thead class="table-light">
<tr>
    <th style="width:200px;">Master</th>
    <th>컬럼명</th>
    <th style="width:160px;">단위</th>
    <th style="width:140px;"></th>
</tr>
</thead>
<tbody>
<%
If Not (Rs.EOF Or Rs.BOF) Then
    Do While Not Rs.EOF
%>
<tr data-id="<%=Rs("list_title_id")%>"
    data-master="<%=Rs("master_id")%>">
<td class="title-master-text">
    <%=Rs("item_no")%>(<%=Rs("master_name")%>)
</td>
    <td class="title-name"><%=Rs("title_name")%></td>
    <td class="title-density"><%=Rs("density")%></td>
    <td>
        <button class="btn btn-sm btn-outline-secondary"
            onclick="editTitleRow(this)">수정</button>
<button
  class="btn btn-sm btn-danger"
  onclick="openDeactivate('title', <%=Rs("list_title_id")%>)">
  삭제
</button>

    </td>
</tr>
<%
        Rs.MoveNext
    Loop
Else
%>
<tr>
    <td colspan="4" class="text-center text-muted">데이터 없음</td>
</tr>
<%
End If
%>
</tbody>
</table>

<%
Rs.Close : Set Rs = Nothing
RsMaster.Close : Set RsMaster = Nothing
call DbClose()
%>
