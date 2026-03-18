<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT L.length_id, L.master_id, " & _
      "M.item_no, M.item_name AS master_name, " & _
      "L.bom_length, L.midx, L.meidx " & _
      "FROM bom2_length L " & _
      "INNER JOIN bom2_master M ON L.master_id = M.master_id " & _
      "WHERE L.is_active=1 " & _
      "ORDER BY L.length_id DESC"

Rs.Open sql, Dbcon

' master(status=1) 옵션 (드롭다운용)
Dim RsM, sqlM
Set RsM = Server.CreateObject("ADODB.Recordset")
sqlM = "SELECT master_id, item_no, item_name " & _
       "FROM bom2_master " & _
       "WHERE is_active=1 " & _
       "ORDER BY item_no ASC"

RsM.Open sqlM, Dbcon
%>

<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="mb-0">길이 관리</h5>
  <button class="btn btn-sm btn-primary" onclick="addLengthRow()">추가</button>
</div>

<!-- master 옵션 템플릿(숨김) -->
<select id="lengthMasterOptions" class="d-none">
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

<table class="table table-bordered table-hover" id="lengthTable">
  <thead class="table-light">
    <tr>
      <th style="width:200px;">Master</th>
      <th>Length</th>
      <th style="width:90px;">작성자</th>
      <th style="width:90px;">수정자</th>
      <th style="width:140px;"></th>
    </tr>
  </thead>
  <tbody>
  <%
  If Not (Rs.EOF Or Rs.BOF) Then
      Do While Not Rs.EOF
  %>
    <tr data-id="<%=Rs("length_id")%>"
        data-master="<%=Rs("master_id")%>"
        data-length="<%=Rs("bom_length")%>">
<td class="length-master-text">
  <%=Rs("item_no")%>(<%=Rs("master_name")%>)
</td>

      <td class="length-text"><%=Rs("bom_length")%></td>
      <td class="length-midx"><%=Rs("midx")%></td>
      <td class="length-meidx"><%=Rs("meidx")%></td>
      <td>
        <button class="btn btn-sm btn-outline-secondary" onclick="editLengthRow(this)">수정</button>
<button
  class="btn btn-sm btn-danger"
  onclick="openDeactivate('length', <%=Rs("length_id")%>)">
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
