<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim list_title_id, title_name, density

list_title_id = Trim(Request("list_title_id"))
title_name    = Trim(Request("title_name"))
density       = Trim(Request("density"))

' ===============================
' 유효성 검사
' ===============================
If Not IsNumeric(list_title_id) Then
    Response.Write "INVALID_ID"
    Response.End
End If

If title_name = "" Then
    Response.Write "EMPTY_TITLE"
    Response.End
End If

' ===============================
' UPDATE ONLY
' ===============================
Dim sql
sql = "UPDATE bom2_list_title SET " & _
      "title_name = N'" & Replace(title_name,"'","''") & "', " & _
      "density = N'" & Replace(density,"'","''") & "', " & _
      "udate = GETDATE() " & _
      "WHERE list_title_id = " & CLng(list_title_id)

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>
