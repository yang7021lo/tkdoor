<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim origin_type_no, origin_name
origin_type_no = Trim(Request("origin_type_no"))
origin_name    = Trim(Request("origin_name"))

' ===== 유효성 체크 =====
If origin_type_no = "" Or Not IsNumeric(origin_type_no) Then
    Response.Write "INVALID_ID"
    Response.End
End If

If origin_name = "" Then
    Response.Write "EMPTY"
    Response.End
End If

' ===== 수정 =====
Dim sql
sql = "UPDATE bom3_origin_type SET " & _
      "origin_name = '" & Replace(origin_name, "'", "''") & "' " & _
      "WHERE origin_type_no = " & origin_type_no

Dbcon.Execute sql

Response.Write "OK"

call DbClose()
%>
