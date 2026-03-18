<%@codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/TNG_WMS_CommonMsg.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

keyword = Trim(Request("keyword"))
If keyword = "" Then keyword = "%"

SQL = ""
SQL = SQL & "SELECT TOP 300 "
SQL = SQL & " wms_idx, wms_no, sjidx, cidx, wms_type, status, "
SQL = SQL & " CONVERT(varchar(10),actual_ship_dt,120) AS shipdt, "
SQL = SQL & " total_quan, reg_date "
SQL = SQL & "FROM tk_wms_meta "
SQL = SQL & "WHERE sjidx LIKE '%" & keyword & "%' "
SQL = SQL & "ORDER BY wms_idx DESC"

Rs.Open SQL, Dbcon
%>

<!DOCTYPE html>
<html>
<head>
<title>TNG WMS 출하 목록</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  body{font-family:'맑은 고딕';font-size:13px;}
  .status-ready{background:#e8ffe8;}
  .status-finish{background:#e6f1ff;}
</style>
</head>

<body class="p-3">

<h4>📦 WMS 출하 목록</h4>

<form method="get" class="row mb-3">
  <div class="col-3">
    <input type="text" name="keyword" value="<%=keyword%>" placeholder="sjidx 검색" class="form-control">
  </div>
  <div class="col-2">
    <button class="btn btn-primary w-100" type="submit">검색</button>
  </div>
  <div class="col-2">
    <button class="btn btn-success w-100" type="button"
      onclick="location.href='TNG_WMS_Meta_Write.asp'">+ 신규 출하 생성</button>
  </div>
</form>

<table class="table table-bordered table-sm">
<thead class="table-light">
<tr>
  <th>wms_idx</th>
  <th>wms_no</th>
  <th>sjidx</th>
  <th>wms_type</th>
  <th>출하일</th>
  <th>수량</th>
  <th>상태</th>
  <th></th>
</tr>
</thead>
<tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then
  Do While Not Rs.EOF
    st = Rs("status")
    rowClass = ""
    If st="0" Then rowClass="status-ready"
    If st="1" Then rowClass="status-finish"

    Response.Write "<tr class='" & rowClass & "'>"
    Response.Write "<td>" & Rs("wms_idx") & "</td>"
    Response.Write "<td>" & Rs("wms_no") & "</td>"
    Response.Write "<td>" & Rs("sjidx") & "</td>"
    Response.Write "<td>" & Rs("wms_type") & "</td>"
    Response.Write "<td>" & Rs("shipdt") & "</td>"
    Response.Write "<td>" & Rs("total_quan") & "</td>"
    Response.Write "<td>" & st & "</td>"

    Response.Write "<td>"
    Response.Write "<button class='btn btn-outline-primary btn-sm' onclick=""location.href='TNG_WMS_Meta_Write.asp?wms_idx=" & Rs("wms_idx") & "';"">수정</button> "
    Response.Write "<button class='btn btn-outline-danger btn-sm' onclick=""if(confirm('삭제?')) location.href='TNG_WMS_Meta_Write.asp?del=" & Rs("wms_idx") & "';"">삭제</button>"
    Response.Write "</td>"

    Response.Write "</tr>"
    Rs.MoveNext
  Loop
Else
  Response.Write "<tr><td colspan='8' class='text-center text-muted'>데이터 없음</td></tr>"
End If
%>

</tbody>
</table>

</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call dbClose()
%>
