<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id, title_name, density, type_id

master_id  = Trim(Request("master_id"))
title_name = Trim(Request("title_name"))
density    = Trim(Request("density"))
type_id    = Trim(Request("type_id"))

' ===============================
' 유효성 검사
' ===============================
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
' INSERT
' ===============================
Dim sql
sql = _
"INSERT INTO bom2_list_title (" & _
"  master_id, title_name, density, type_id, is_active, cdate" & _
") VALUES (" & _
  CLng(master_id) & ", " & _
  "N'" & Replace(title_name,"'","''") & "', " & _
  "N'" & Replace(density,"'","''") & "', " & _
  CLng(type_id) & ", 1, GETDATE()" & _
")"

Dbcon.Execute sql

' 새 ID 반환
Dim rs
Set rs = Dbcon.Execute("SELECT SCOPE_IDENTITY()")
Response.Write "OK|" & CLng(rs(0))

call DbClose()
%>
