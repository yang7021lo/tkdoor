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
stepSize = Request("stepSize")
direction = Request("direction")
startDirection = Request("startDirection")

If stepSize = "" OR IsNull(stepSize) Then stepSize = 10
If direction = "" OR IsNull(direction) Then direction = "clockwise"

' 기존 데이터 조회 (id가 있는 경우)
If id <> "" AND NOT IsNull(id) Then
    sql = "SELECT * FROM TNG_SJst2 WHERE id = '" & id & "' ORDER BY id_1 DESC"
    Rs.open sql, Dbcon, 1, 1, 1
Else
    sql = "SELECT TOP 1 * FROM TNG_SJst2 ORDER BY id DESC"
    Rs.open sql, Dbcon, 1, 1, 1
End If

If Not Rs.EOF Then
    x1 = Rs("x2")
    y1 = Rs("y2")
    lastDirection = Rs("lastDirection")
Else
    x1 = 50
    y1 = 50
    lastDirection = startDirection
End If
Rs.Close 

' 🔹 id_1 증가를 위해 NULL 방지
Set RsId1 = Server.CreateObject("ADODB.Recordset")
sqlId1 = "SELECT COALESCE(MAX(CAST(id_1 AS INT)), 0) + 1 AS newId1 FROM TNG_SJst2 WHERE id = '" & id & "'"
RsId1.open sqlId1, Dbcon, 1, 1
If Not RsId1.EOF AND NOT IsNull(RsId1("newId1")) Then
    id_1 = RsId1("newId1")
Else
    id_1 = 1
End If
RsId1.Close
Set RsId1 = Nothing

' 🔹 방향 설정: 현재 방향을 기준으로 시계/반시계 방향 결정
If direction = "clockwise" Then
    Select Case lastDirection
        Case "3시"
            newX2 = x1
            newY2 = y1 + stepSize ' ↓ 6시 방향 이동
            nextDirection = "6시"

        Case "6시"
            newX2 = x1 - stepSize
            newY2 = y1 ' ← 9시 방향 이동
            nextDirection = "9시"

        Case "9시"
            newX2 = x1
            newY2 = y1 - stepSize ' ↑ 12시 방향 이동
            nextDirection = "12시"

        Case "12시"
            newX2 = x1 + stepSize
            newY2 = y1 ' → 3시 방향 이동
            nextDirection = "3시"
    End Select
Else ' 반시계 방향 (counterclockwise)
    Select Case lastDirection
        Case "3시"
            newX2 = x1
            newY2 = y1 - stepSize ' ↑ 12시 방향 이동
            nextDirection = "12시"

        Case "12시"
            newX2 = x1 - stepSize
            newY2 = y1 ' ← 9시 방향 이동
            nextDirection = "9시"

        Case "9시"
            newX2 = x1
            newY2 = y1 + stepSize ' ↓ 6시 방향 이동
            nextDirection = "6시"

        Case "6시"
            newX2 = x1 + stepSize
            newY2 = y1 ' → 3시 방향 이동
            nextDirection = "3시"
    End Select
End If

' 🔹 새로운 선 추가 (id_1 정상 처리)
sql = "INSERT INTO TNG_SJst2 (id, id_1, x1, y1, x2, y2, stepSize, direction, lastDirection) " & _
      "VALUES ('" & id & "', " & id_1 & ", " & x1 & ", " & y1 & ", " & newX2 & ", " & newY2 & ", " & stepSize & ", '" & direction & "', '" & nextDirection & "')"
Dbcon.Execute sql

response.write "<script>location.replace('x1y1.asp?id=" & id & "');</script>"
call dbClose()
%>
