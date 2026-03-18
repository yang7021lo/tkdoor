<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet="utf-8"
call DbOpen()

Dim material_id, title_sub_id, title_sub_value_id
If Not IsNumeric(Request("material_id")) _
Or Not IsNumeric(Request("title_sub_id")) _
Or Not IsNumeric(Request("title_sub_value_id")) Then
  Response.End
End If

material_id = CLng(Request("material_id"))
title_sub_id = CLng(Request("title_sub_id"))
title_sub_value_id = CLng(Request("title_sub_value_id"))

' sub_value 문자열
Dim Rs, sub_value, list_title_id
Set Rs = Server.CreateObject("ADODB.Recordset")

Rs.Open _
"SELECT v.sub_value, s.list_title_id " & _
"FROM bom3_title_sub_value v " & _
"JOIN bom3_list_title_sub s ON v.title_sub_id=s.title_sub_id " & _
"WHERE v.title_sub_value_id=" & title_sub_value_id, Dbcon

If Rs.EOF Then Response.End

sub_value = Rs("sub_value")
list_title_id = Rs("list_title_id")
Rs.Close

' UPSERT
Dbcon.Execute _
"IF EXISTS (SELECT 1 FROM bom3_table_value " & _
"WHERE material_id=" & material_id & _
" AND title_sub_id=" & title_sub_id & ") " & _
"BEGIN " & _
" UPDATE bom3_table_value SET " & _
"   title_sub_value_id=" & title_sub_value_id & "," & _
"   value=N'" & Replace(sub_value,"'","''") & "'," & _
"   udate=GETDATE() " & _
" WHERE material_id=" & material_id & _
"   AND title_sub_id=" & title_sub_id & _
"END ELSE BEGIN " & _
" INSERT INTO bom3_table_value " & _
" (material_id, list_title_id, title_sub_id, title_sub_value_id, value) VALUES (" & _
material_id & "," & list_title_id & "," & title_sub_id & "," & title_sub_value_id & ",N'" & Replace(sub_value,"'","''") & "')" & _
"END"

call DbClose()
%>