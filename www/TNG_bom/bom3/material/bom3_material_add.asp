<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet="utf-8"
call DbOpen()

Dim master_id
If Not IsNumeric(Request("master_id")) Then
  Response.End
End If

master_id = CLng(Request("master_id"))

' 빈 material 생성
Dbcon.Execute _
"INSERT INTO bom3_material (master_id, material_name) VALUES (" & _
master_id & ", N'')"

' 방금 생성된 material_id
Dim Rs
Set Rs = Server.CreateObject("ADODB.Recordset")
Rs.Open "SELECT @@IDENTITY AS material_id", Dbcon

Response.Write Rs("material_id")

Rs.Close
call DbClose()
%>