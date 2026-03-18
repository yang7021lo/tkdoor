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
fw = Request("fw") ' 전체 가로
fh = Request("fh") ' 전체 세로
bars = Request("bars") ' 세로바 개수

If fw = "" OR IsNull(fw) Then fw = 200 ' 기본값
If fh = "" OR IsNull(fh) Then fh = 200 ' 기본값
If bars = "" OR IsNull(bars) Then bars = 4 ' 기본값

' 🔹 id_1 자동 증가
Set RsId1 = Server.CreateObject("ADODB.Recordset")
sqlId1 = "SELECT COALESCE(MAX(CAST(id_1 AS INT)), 0) + 1 AS newId1 FROM TNG_SJst2_rect WHERE id = '" & id & "'"
RsId1.open sqlId1, Dbcon, 1, 1
If Not RsId1.EOF AND NOT IsNull(RsId1("newId1")) Then
    id_1 = RsId1("newId1")
Else
    id_1 = 1
End If
RsId1.Close
Set RsId1 = Nothing

' 🔹 사각형 크기 자동 계산 (수정된 계산식 적용)
barWidth = 5 ' 세로바 너비 (고정)
cellWidth = Int((fw - ((bars - 1) * barWidth)) / bars) ' 가로 셀 크기 (bars 개수로 나눔)
cellHeight = Int(fh / bars) ' 세로 셀 크기

' 🔹 내경 계산 (a, b)
a_value = cellWidth
b_value = Int((fh - (bars * 10)) / 2) ' 내경 세로 계산

' 🔹 새 사각형 추가 (좌측부터 우측, 위에서 아래로 추가)
xPos = ((id_1 - 1) MOD bars) * (cellWidth + barWidth)
yPos = ((id_1 - 1) \ bars) * cellHeight

sql = "INSERT INTO TNG_SJst2_rect (id, id_1, x, y, width, height, a_value, b_value) " & _
      "VALUES ('" & id & "', " & id_1 & ", " & xPos & ", " & yPos & ", " & cellWidth & ", " & cellHeight & ", " & a_value & ", " & b_value & ")"
Dbcon.Execute sql

response.write "<script>location.replace('r_x1y1.asp?id=" & id & "');</script>"
call dbClose()
%>
