<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim length_id, master_id, lenVal
length_id = Trim(Request("length_id"))
master_id = Trim(Request("master_id"))
lenVal    = Trim(Request("length"))

If length_id = "" Or Not IsNumeric(length_id) Then
    Response.Write "INVALID_ID"
    Response.End
End If

If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "INVALID_MASTER"
    Response.End
End If

If lenVal = "" Or Not IsNumeric(lenVal) Then
    Response.Write "INVALID_LENGTH"
    Response.End
End If

Dim c_midx
c_midx = 0

If request.cookies("tk")("c_midx") <> "" And IsNumeric(request.cookies("tk")("c_midx")) Then
    c_midx = CLng(request.cookies("tk")("c_midx"))
End If

Dim sql
sql = "UPDATE bom2_length SET " & _
      "master_id=" & CLng(master_id) & ", " & _
      "bom_length=" & CDbl(lenVal) & ", " & _
      "meidx=" & c_midx & ", " & _
      "udate=getdate() " & _
      "WHERE length_id=" & CLng(length_id)

Dbcon.Execute sql
Response.Write "OK"

call DbClose()
%>
