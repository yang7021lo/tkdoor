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

If id <> "" Then
    sql = "SELECT * FROM TNG_SJst2_rect WHERE id = '" & id & "' ORDER BY id_1 ASC"
Else
    sql = "SELECT * FROM TNG_SJst2_rect ORDER BY id ASC"
End If

Rs.open sql, Dbcon, 1, 1, 1

Response.Write "<svg width='600' height='600' viewBox='0 0 600 600' fill='none' stroke='black' stroke-width='1'>"

If Not Rs.EOF Then
    Do While Not Rs.EOF
        Response.Write "<rect x='" & Rs("x") & "' y='" & Rs("y") & "' width='" & Rs("width") & "' height='" & Rs("height") & "' stroke='black' fill='none' />"
        Rs.MoveNext
    Loop
End If

Rs.Close
Response.Write "</svg>"
call dbClose()
%>
