<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set RsCheck = Server.CreateObject("ADODB.Recordset")

id = Request("id")

' 🔹 TNG_SJst2_Completed 테이블이 존재하는지 확인
sqlCheck = "SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TNG_SJst2_Completed'"
RsCheck.open sqlCheck, Dbcon, 1, 1

If RsCheck("TableCount") = 0 Then
    ' 🔹 테이블이 없으면 생성
    sqlCreate = "CREATE TABLE TNG_SJst2_Completed (" & _
                "id VARCHAR(50), " & _
                "id_1 INT, " & _
                "x1 INT, " & _
                "y1 INT, " & _
                "x2 INT, " & _
                "y2 INT, " & _
                "stepSize INT, " & _
                "direction VARCHAR(50), " & _
                "lastDirection VARCHAR(50))"
    Dbcon.Execute sqlCreate
End If
RsCheck.Close
Set RsCheck = Nothing

' 🔹 도형 데이터 완료 처리 (데이터는 유지)
If id <> "" Then
    sql = "INSERT INTO TNG_SJst2_Completed (id, id_1, x1, y1, x2, y2, stepSize, direction, lastDirection) " & _
          "SELECT id, id_1, x1, y1, x2, y2, stepSize, direction, lastDirection FROM TNG_SJst2 WHERE id = '" & id & "'"
    Dbcon.Execute sql
End If

' 🔹 완료 후 화면 새로 고침
Response.Redirect "x1y1.asp?id=" & id
call dbClose()
%>
