<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim row_id, master_id
If Not IsNumeric(Request("row_id")) Or Not IsNumeric(Request("master_id")) Then
  Response.End
End If

row_id    = CLng(Request("row_id"))
master_id = CLng(Request("master_id"))

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = _
"SELECT title_sub_id, sub_value " & _
"FROM bom3_title_sub_value " & _
"WHERE is_active=1 " & _
"  AND row_id=" & row_id & _
"  AND (master_id IS NULL OR master_id=" & master_id & ")"

Rs.Open sql, Dbcon

Do While Not Rs.EOF
  Response.Write Rs("title_sub_id") & "|" & Rs("sub_value") & vbCrLf
  Rs.MoveNext
Loop

Rs.Close
call DbClose()
%>