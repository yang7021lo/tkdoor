<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim surface_id
surface_id = Trim(Request.Form("surface_id"))

If surface_id = "" Or Not IsNumeric(surface_id) Then
    Response.Write "INVALID"
    Response.End
End If

Dbcon.Execute _
    "UPDATE bom2_surface SET is_active = 0 WHERE surface_id = " & CLng(surface_id)

Response.Write "OK"
call DbClose()
%>
