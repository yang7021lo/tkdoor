<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim origin_name
origin_name = Trim(Request("origin_name"))

' ===== 유효성 체크 =====
If origin_name = "" Then
    Response.Write "EMPTY"
    Response.End
End If

' ===== 저장 =====
Dim sql
sql = "INSERT INTO bom2_origin_type (origin_name) " & _
      "VALUES ('" & Replace(origin_name, "'", "''") & "')"

Dbcon.Execute sql

Response.Write "OK"

call DbClose()
%>
