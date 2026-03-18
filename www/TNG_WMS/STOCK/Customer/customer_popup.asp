<%@ codepage="65001" language="vbscript"%>
<!--#include virtual="/inc/dbcon.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<%
Dim Rs, sql, keyword
Set Rs = Server.CreateObject("ADODB.Recordset")

keyword = Trim(Request("keyword"))

call dbOpen()

sql = ""
sql = sql & "SELECT TOP 50 "
sql = sql & " cidx, cname, cceo, ctel "
sql = sql & "FROM tk_customer "

If keyword <> "" Then
    sql = sql & "WHERE ( "
    sql = sql & " cname LIKE '%" & keyword & "%' "
    sql = sql & " OR cceo LIKE '%" & keyword & "%' "
    sql = sql & " OR ctel LIKE '%" & keyword & "%' "
    sql = sql & ") "
End If

sql = sql & "ORDER BY cname"

Rs.Open sql, DbCon, 1, 1
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>거래처 선택</title>

<link rel="stylesheet" href="/inc/css/wms.css">

<style>
.popup-wrap {
    padding:15px;
}
.search-box {
    margin-bottom:10px;
}
.search-box input {
    padding:6px;
    width:250px;
}
.table-wrap {
    max-height:520px;
    overflow:auto;
    border:1px solid #ddd;
}
.table-wrap table {
    width:100%;
    border-collapse:collapse;
}
.table-wrap th, .table-wrap td {
    padding:8px;
    border-bottom:1px solid #eee;
    text-align:left;
    font-size:14px;
}
.table-wrap tr:hover {
    background:#f1f5ff;
    cursor:pointer;
}
</style>

<script>
function selectCustomer(cidx, cname) {
    if (!opener || opener.closed) return;

    var d = opener.document;

    // 1. idx 계열 자동 분기
    if (d.getElementById('company_idx')) {
        d.getElementById('company_idx').value = cidx;
    } 
    else if (d.getElementById('cidx')) {
        d.getElementById('cidx').value = cidx;
    }

    // 2. name 계열 자동 분기
    if (d.getElementById('company_name')) {
        d.getElementById('company_name').value = cname;
    } 
    else if (d.getElementById('cname')) {
        d.getElementById('cname').value = cname;
    }

    window.close();
}
</script>
</head>

<body>
<div class="popup-wrap">

<h2>거래처 선택</h2>

<form method="get" class="search-box">
    <input type="text" name="keyword" value="<%=keyword%>"
           placeholder="거래처명 / 대표자 / 전화번호">
    <button class="btn btn-primary">검색</button>
</form>

<div class="table-wrap">
<table>
<thead>
<tr>
    <th>거래처명</th>
    <th>대표자</th>
    <th>전화번호</th>
</tr>
</thead>
<tbody>

<%
If Not (Rs.BOF Or Rs.EOF) Then
    Do Until Rs.EOF
%>
<tr onclick="selectCustomer('<%=Rs("cidx")%>', '<%=Replace(Rs("cname"),"'","")%>')">
    <td><%=Rs("cname")%></td>
    <td><%=Rs("cceo")%></td>
    <td><%=Rs("ctel")%></td>
</tr>
<%
        Rs.MoveNext
    Loop
Else
%>
<tr>
    <td colspan="3">검색 결과가 없습니다.</td>
</tr>
<%
End If
%>

</tbody>
</table>
</div>

</div>
</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call dbClose()
%>
