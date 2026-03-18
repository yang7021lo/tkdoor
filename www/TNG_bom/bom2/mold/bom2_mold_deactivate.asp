<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim mold_id
mold_id = Trim(Request.Form("mold_id"))

If mold_id = "" Or Not IsNumeric(mold_id) Then
    Response.Write "INVALID"
    Response.End
End If

Dim sql
sql = "UPDATE bom2_mold SET is_active = 0 WHERE mold_id = " & CLng(mold_id)

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>