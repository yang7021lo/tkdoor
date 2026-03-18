<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id, lenVal
master_id = Trim(Request("master_id"))
lenVal    = Trim(Request("length"))

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

' 1️⃣ INSERT
Dim sql
sql = "INSERT INTO bom2_length (master_id, bom_length, midx, meidx, cdate) VALUES (" & _
      CLng(master_id) & ", " & CDbl(lenVal) & ", " & c_midx & ",  " & c_midx & ", getdate())"

Dbcon.Execute sql

' 2️⃣ 방금 insert된 ID 조회
Dim RsId, newId
Set RsId = Server.CreateObject("ADODB.Recordset")

sql = "SELECT SCOPE_IDENTITY() AS new_id"
RsId.Open sql, Dbcon

newId = ""
If Not RsId.EOF Then
    newId = RsId("new_id")
End If

RsId.Close
Set RsId = Nothing

Response.Write "OK|" & newId

call DbClose()
%>
