<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

' 날짜 선택
selectedDate = Trim(Request("selectedDate"))
If selectedDate = "" Then
    selectedDate = Date()
End If
formattedDate = Year(selectedDate) & Right("0" & Month(selectedDate), 2) & Right("0" & Day(selectedDate), 2)

' 선택된 ID (도형 그룹)
selectedId = Trim(Request("id"))

' 해당 ID에 데이터가 있는지 확인
sql = "SELECT COUNT(*) AS count FROM TNG_SJst2_rect WHERE id = '" & selectedId & "'"
Rs.open sql, Dbcon, 1, 1
hasData = (Rs("count") > 0)
Rs.Close

' 새로운 도형 추가 요청 시 처리
If Request("new") = "1" Then
    sql = "SELECT MAX(id) AS lastId FROM TNG_SJst2_rect WHERE id LIKE '" & formattedDate & "_%'"
    Rs.open sql, Dbcon, 1, 1
    If Not Rs.EOF AND NOT IsNull(Rs("lastId")) Then
        lastNum = Split(Rs("lastId"), "_")(1)
        selectedId = formattedDate & "_" & (CInt(lastNum) + 1)
    Else
        selectedId = formattedDate & "_1"
    End If
    Rs.Close
    response.write "<script>location.replace('r_x1y1.asp?id=" & selectedId & "');</script>"
    Response.End
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>절곡 바라시 관리</title>
    <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
</head>

<body>
<h3>절곡 바라시 관리 - <%= selectedDate %></h3>

<form method="get" action="r_x1y1.asp">
    <label for="selectedDate">날짜 선택:</label>
    <input type="date" id="selectedDate" name="selectedDate" value="<%= selectedDate %>" onchange="this.form.submit()">
</form>

<form method="get" action="r_x1y1.asp">
    <label for="id">진행 중인 도형:</label>
    <select name="id" id="id" onchange="this.form.submit()">
        <option value="">도형 선택</option>
        <%
        sql = "SELECT DISTINCT id FROM TNG_SJst2_rect WHERE id LIKE '" & formattedDate & "_%' ORDER BY id ASC"
        Rs.open sql, Dbcon, 1, 1
        If Not Rs.EOF Then
            Do While Not Rs.EOF
                Response.Write "<option value='" & Rs("id") & "'"
                If selectedId = Rs("id") Then Response.Write " selected"
                Response.Write ">" & Rs("id") & "</option>"
                Rs.MoveNext
            Loop
        End If
        Rs.Close
        %>
    </select>
    <button type="submit" name="new" value="1">새로운 도형 추가</button>
</form>

<!-- 입력 폼 -->
<form method="post" action="r_x1y1db.asp">
    <input type="hidden" name="id" value="<%= selectedId %>">
    <label for="fw">전체 가로(FW):</label>
    <input type="number" name="fw" required>

    <label for="fh">전체 세로(FH):</label>
    <input type="number" name="fh" required>

    <label for="bars">세로바 개수:</label>
    <input type="number" name="bars" required>

    <button type="submit">새 도형 추가</button>
</form>

<h4>현재 진행 중인 도형</h4>
<table border="1">
    <tr>
        <th>idx</th>
        <th>id_1</th>
        <th>x</th>
        <th>y</th>
        <th>width</th>
        <th>height</th>
        <th>a_value</th>
        <th>b_value</th>
        <th>삭제</th>
    </tr>
</table>

<iframe src="r_x1y1_draw.asp?id=<%= selectedId %>" width="1000 " height="1000"></iframe>

<%
call dbClose()
%> 
