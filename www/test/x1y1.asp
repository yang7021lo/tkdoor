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
sql = "SELECT COUNT(*) AS count FROM TNG_SJst2 WHERE id = '" & selectedId & "'"
Rs.open sql, Dbcon, 1, 1
hasData = (Rs("count") > 0)
Rs.Close

' 새로운 도형 추가 요청 시 처리
If Request("new") = "1" Then
    sql = "SELECT MAX(id) AS lastId FROM TNG_SJst2 WHERE id LIKE '" & formattedDate & "_%'"
    Rs.open sql, Dbcon, 1, 1
    If Not Rs.EOF AND NOT IsNull(Rs("lastId")) Then
        lastNum = Split(Rs("lastId"), "_")(1)
        selectedId = formattedDate & "_" & (CInt(lastNum) + 1)
    Else
        selectedId = formattedDate & "_1"
    End If
    Rs.Close
    response.write "<script>location.replace('x1y1.asp?id=" & selectedId & "');</script>"
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

<form method="get" action="x1y1.asp">
    <label for="selectedDate">날짜 선택:</label>
    <input type="date" id="selectedDate" name="selectedDate" value="<%= selectedDate %>" onchange="this.form.submit()">
</form>

<form method="get" action="x1y1.asp">
    <label for="id">진행 중인 도형:</label>
    <select name="id" id="id" onchange="this.form.submit()">
        <option value="">도형 선택</option>
        <%
        sql = "SELECT DISTINCT id FROM TNG_SJst2 WHERE id LIKE '" & formattedDate & "_%' ORDER BY id ASC"
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

<!-- 선 추가 폼 -->
<form method="post" action="x1y1db.asp">
    <input type="hidden" name="id" value="<%= selectedId %>">
    <label for="stepSize">크기:</label>
    <input type="number" name="stepSize" required>

    <% If Not hasData Then %>
        <label for="startDirection">초기 방향:</label>
        <select name="startDirection">
            <option value="3시">3시</option>
            <option value="6시">6시</option>
            <option value="9시">9시</option>
            <option value="12시">12시</option>
        </select>
    <% Else %>
        <label for="direction">추가 방향 선택:</label>
        <select name="direction">
            <option value="clockwise">시계 방향</option>
            <option value="counterclockwise">반시계 방향</option>
        </select>
    <% End If %>

    <button type="submit">새 선 추가</button>
</form>

<h4>현재 진행 중인 도형</h4>
<table border="1">
    <tr>
        <th>id_1</th>
        <th>x1</th>
        <th>y1</th>
        <th>x2</th>
        <th>y2</th>
        <th>크기</th>
        <th>방향</th>
        <th>수정</th>
        <th>삭제</th>
    </tr>
    <%
    If selectedId <> "" Then
        sql = "SELECT * FROM TNG_SJst2 WHERE id = '" & selectedId & "' ORDER BY id_1 ASC"
        Rs.open sql, Dbcon, 1, 1
        If Not Rs.EOF Then
            Do While Not Rs.EOF
                Response.Write "<tr>"
                Response.Write "<td>" & Rs("id_1") & "</td>"
                Response.Write "<td>" & Rs("x1") & "</td>"
                Response.Write "<td>" & Rs("y1") & "</td>"
                Response.Write "<td>" & Rs("x2") & "</td>"
                Response.Write "<td>" & Rs("y2") & "</td>"
                Response.Write "<td>" & Rs("stepSize") & "</td>"
                Response.Write "<td>" & Rs("direction") & "</td>"
                Response.Write "<td><a href='x1y1_edit.asp?id=" & Rs("id") & "&id_1=" & Rs("id_1") & "'>수정</a></td>"
Response.Write "<td><a href='x1y1_delete.asp?id=" & Rs("id") & "&id_1=" & Rs("id_1") & "' onclick='return confirm(&quot;삭제하시겠습니까?&quot;);'>삭제</a></td>"
                Response.Write "</tr>"
                Rs.MoveNext
            Loop
        Else
            Response.Write "<tr><td colspan='9'>현재 진행 중인 데이터가 없습니다.</td></tr>"
        End If
        Rs.Close
    End If
    %>
</table>

<!-- SVG 출력 -->
<iframe src="x1y1_draw.asp?id=<%= selectedId %>" width="600" height="600"></iframe>

<%
call dbClose()
%>
