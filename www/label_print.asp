<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
rstkidx = CLng(Request("stkidx"))

Set Rs = Server.CreateObject("ADODB.Recordset")
SQL = "SELECT * FROM STK WHERE stkidx = '" & rstkidx & "'"
Rs.Open SQL, Dbcon, 1

If Rs.EOF Then
    Response.Write "<h3>해당 라벨 데이터가 없습니다.</h3>"
    Response.End
End If
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>라벨 출력</title>
<style>
@page {
    size: 100mm 45mm; /* 라벨 크기 */
    margin: 0;
}
@media print {
    body { margin: 0; padding: 0; }
}
body {
    margin: 0;
    font-family: Arial, sans-serif;
}
.label {
    width: 100mm;
    height: 45mm;
    border: 0.3mm solid #000;
    box-sizing: border-box;
}
table {
    width: 100%;
    height: 100%;
    font-size: 3mm;
    table-layout: fixed;
    border-collapse: collapse;
}
th, td {
    border: 0.1mm solid #000;
    padding: 0.5mm;
    vertical-align: middle;
    text-align: left;
}
th {
    background-color: #f9f9f9;
    font-weight: bold;
}
.center { text-align: center; }
</style>
</head>
<body onload="window.print();">

<div class="label">
    <table>
        <tr>
            <th style="width:15%;">거래처</th>
            <td colspan="9"><%=Rs("stk1")%></td>
        </tr>
        <tr>
            <th>현장명</th>
            <td colspan="9"><%=Rs("stk2")%></td>
        </tr>
        <tr>
            <th>검측</th>
            <td colspan="9" class="center">
                <%=Rs("stk3")%> x <%=Rs("stk4")%>
            </td>
        </tr>
        <tr>
            <th>위치</th>
            <td colspan="9"><%=Rs("stk5")%></td>
        </tr>
        <tr>
            <th>비고</th>
            <td colspan="9"><%=Rs("stk6")%></td>
        </tr>
    </table>
</div>

</body>
</html>
<%
Rs.Close
Set Rs = Nothing
%>
