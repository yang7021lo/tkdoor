<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
call DbOpen()
Response.CharSet="utf-8"

Dim mold_id
If Not IsNumeric(Request("mold_id")) Then
    Response.Write "INVALID"
    Response.End
End If
mold_id = CLng(Request("mold_id"))

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = "SELECT material_id, material_name " & _
      "FROM bom2_material " & _
      "WHERE mold_id = " & mold_id & " AND is_active = 1"

Rs.Open sql, Dbcon

If Rs.EOF Then
    Response.Write "EMPTY"
Else
    Do While Not Rs.EOF
        Response.Write Rs("material_id") & "|" & Rs("material_name") & vbCrLf
        Rs.MoveNext
    Loop
End If

Rs.Close
call DbClose()
%>
