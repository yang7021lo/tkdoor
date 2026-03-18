<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim title_sub_id, master_id
If Not IsNumeric(Request("title_sub_id")) Or Not IsNumeric(Request("master_id")) Then
  Response.End
End If

title_sub_id = CLng(Request("title_sub_id"))
master_id    = CLng(Request("master_id"))

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = _
"SELECT sub_value_id, sub_value, row_id " & _
"FROM bom3_title_sub_value " & _
"WHERE is_active=1 " & _
"  AND title_sub_id=" & title_sub_id & _
"  AND (master_id IS NULL OR master_id=" & master_id & ") " & _
"ORDER BY row_id, sub_value_id"

Rs.Open sql, Dbcon

Do While Not Rs.EOF
  Response.Write Rs("sub_value_id") & "|" & _
                 Rs("sub_value") & "|" & _
                 Rs("row_id") & vbCrLf
  Rs.MoveNext
Loop

Rs.Close
call DbClose()
%>