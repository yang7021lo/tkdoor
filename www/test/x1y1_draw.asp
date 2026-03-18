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

sql = "SELECT * FROM TNG_SJst2 WHERE id = '" & id & "' ORDER BY id_1 ASC"
Rs.open sql, Dbcon, 1, 1

Response.Write "<svg width='600' height='600' viewBox='0 0 100 100' fill='none' stroke='black' stroke-width='1'>"

If Not Rs.EOF Then
    Do While Not Rs.EOF
        Response.Write "<line x1='" & Rs("x1") & "' y1='" & Rs("y1") & "' x2='" & Rs("x2") & "' y2='" & Rs("y2") & "' />"
        Rs.MoveNext
    Loop
End If

Rs.Close
Response.Write "</svg>"
call dbClose()
%>
