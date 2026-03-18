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

id = Request("id")
id_1 = Request("id_1")

sql = "SELECT * FROM TNG_SJst2_rect WHERE id = '" & id & "' AND id_1 = " & id_1
Rs.open sql, Dbcon, 1, 1, 1

If Not Rs.EOF Then
    x = Rs("x")
    y = Rs("y")
    width = Rs("width")
    height = Rs("height")
    a_value = Rs("a_value")
    b_value = Rs("b_value")
End If
Rs.Close
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>사각형 수정</title>
</head>
<body>
<h3>사각형 수정</h3>

<form method="post" action="r_x1y1_update.asp">
    <input type="hidden" name="id" value="<%= id %>">
    <input type="hidden" name="id_1" value="<%= id_1 %>">

    <label>가로 (W):</label>
    <input type="number" name="width" value="<%= width %>" required><br>

    <label>세로 (H):</label>
    <input type="number" name="height" value="<%= height %>" required><br>

    <label>내경 가로 (A):</label>
    <input type="number" name="a_value" value="<%= a_value %>" required><br>

    <label>내경 세로 (B):</label>
    <input type="number" name="b_value" value="<%= b_value %>" required><br>

    <button type="submit">수정</button>
</form>

</body>
</html>
