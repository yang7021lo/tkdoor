<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT origin_type_no, origin_name FROM bom2_origin_type ORDER BY origin_type_no ASC"
Rs.Open sql, Dbcon
%>

<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0">원산구분 관리</h5>
    <button class="btn btn-sm btn-primary" onclick="addOriginRow()">추가</button>
</div>
<table class="table table-bordered table-hover" id="originTable">
<thead class="table-light">
<tr>
    <th>원산구분명</th>
    <th style="width:140px;">관리</th>
</tr>
</thead>
<tbody>
<%
If Not (Rs.EOF Or Rs.BOF) Then
    Do While Not Rs.EOF
%>
<tr data-id="<%=Rs("origin_type_no")%>">
    <td class="origin-text"><%=Rs("origin_name")%></td>
    <td>
        <button class="btn btn-sm btn-outline-secondary"
            onclick="editOriginRow(this)">수정</button>
        
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
Rs.Close
Set Rs = Nothing
%>