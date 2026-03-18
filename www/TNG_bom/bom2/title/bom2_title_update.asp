<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim list_title_id, master_id, title_name, density, type_id

list_title_id = Trim(Request("list_title_id"))
master_id     = Trim(Request("master_id"))
title_name    = Trim(Request("title_name"))
density       = Trim(Request("density"))
type_id       = Trim(Request("type_id"))

' ===============================
' 유효성 검사
' ===============================
If Not IsNumeric(list_title_id) Then
    Response.Write "INVALID_ID"
    Response.End
End If

If Not IsNumeric(master_id) Then
    Response.Write "INVALID_MASTER"
    Response.End
End If

If title_name = "" Then
    Response.Write "EMPTY_TITLE"
    Response.End
End If

If Not IsNumeric(type_id) Then
    Response.Write "INVALID_TYPE"
    Response.End
End If

' ===============================
' UPDATE
' ===============================
Dim sql
sql = _
"UPDATE bom2_list_title SET " & _
"  master_id = " & CLng(master_id) & ", " & _
"  title_name = N'" & Replace(title_name,"'","''") & "', " & _
"  density = N'" & Replace(density,"'","''") & "', " & _
"  type_id = " & CLng(type_id) & ", " & _
"  udate = GETDATE() " & _
"WHERE list_title_id = " & CLng(list_title_id)

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>
