<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
call DbOpen()

Dim ids
ids = Trim(Request("material_ids"))

If ids = "" Then
    Response.Write "INVALID"
    Response.End
End If

Dim sql
sql = "UPDATE bom2_material SET is_active = 0, udate = GETDATE() " & _
      "WHERE material_id IN (" & ids & ")"

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>