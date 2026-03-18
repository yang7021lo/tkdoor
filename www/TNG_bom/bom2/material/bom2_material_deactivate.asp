<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim material_id
If IsNumeric(Request("material_id")) Then
    material_id = CLng(Request("material_id"))
Else
    Response.Write "INVALID_ID"
    Response.End
End If

Dim sql
sql = "UPDATE bom2_material SET is_active = 0, udate = GETDATE() " & _
      "WHERE material_id = " & material_id

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>
