 <%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT " & _
      "M.mold_id, M.master_id, " & _
      "MS.item_no, MS.item_name AS master_name, " & _
      "M.mold_no, M.mold_name, M.vender_id, " & _
      "M.cad_path, M.img_path, M.memo, M.midx, M.meidx " & _
      "FROM bom2_mold M " & _
      "INNER JOIN bom2_master MS ON M.master_id = MS.master_id " & _
      "WHERE M.is_active=1 " & _
      "ORDER BY M.mold_id DESC"

Rs.Open sql, Dbcon

' ===============================
' master(status=1) 옵션
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
  <h5 class="mb-0">금형 관리</h5>
  <button class="btn btn-sm btn-primary" onclick="addMoldRow()">추가</button>
</div>

<!-- 🔥 여기!!! (LENGTH랑 동일한 위치) -->
<!-- master 옵션 템플릿 (JS에서 복사해서 사용) -->
<select id="moldMasterOptions" class="d-none">
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
<!-- origin 옵션 템플릿 -->
<select id="masterOriginOptions" class="d-none">
  <option value="">선택</option>
  <%
    Dim RsO2
    Set RsO2 = Server.CreateObject("ADODB.Recordset")
    RsO2.Open "SELECT origin_type_no, origin_name FROM bom2_origin_type ORDER BY origin_type_no", Dbcon
    Do While Not RsO2.EOF
  %>
    <option value="<%=RsO2("origin_type_no")%>"><%=RsO2("origin_name")%></option>
  <%
      RsO2.MoveNext
    Loop
    RsO2.Close
    Set RsO2 = Nothing
  %>
</select>

<table class="table table-bordered table-hover" id="moldTable">
<thead class="table-light">
<tr>
  <th style="width:200px;">Master</th>
  <th style="width:120px;">금형번호</th>
  <th style="width:180px;">금형명</th>
  <th style="width:90px;">벤더</th>
  <th>CAD</th>
  <th>이미지</th>
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
<tr data-id="<%=Rs("mold_id")%>"
    data-master="<%=Rs("master_id")%>">

<td class="mold-master-text">
  <%=Rs("item_no")%>(<%=Rs("master_name")%>)
</td>
  <td class="mold-no"><%=Rs("mold_no")%></td>
  <td class="mold-name"><%=Rs("mold_name")%></td>
  <td class="mold-vender"><%=Rs("vender_id")%></td>
  <td class="mold-cad"><%=Rs("cad_path")%></td>
  <td class="mold-img"><%=Rs("img_path")%></td>
  <td class="mold-memo"><%=Rs("memo")%></td>
  <td><%=Rs("midx")%></td>
  <td><%=Rs("meidx")%></td>
  <td>
    <button class="btn btn-sm btn-outline-secondary" onclick="editMoldRow(this)">수정</button>
<button
  class="btn btn-sm btn-danger"
  onclick="openDeactivate('mold', <%=Rs("mold_id")%>)">
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
RsMaster.Close : Set RsMaster = Nothing
call DbClose()
%>

