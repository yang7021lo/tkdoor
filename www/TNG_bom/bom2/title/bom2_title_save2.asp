<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

Dim title_name, density, master_id, cidx

title_name = Trim(Request("title_name"))
density    = Trim(Request("density"))
master_id  = Trim(Request("master_id"))

' ===== 필수값 체크 =====
If title_name = "" Then
    Response.Write "EMPTY_TITLE"
    Response.End
End If

If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "INVALID_MASTER"
    Response.End
End If

' ===== cidx =====
If IsNumeric(Session("cidx")) Then
    cidx = CLng(Session("cidx"))
Else
    Response.Write "NO_CIDX"
    Response.End
End If

' ===== INSERT =====
Dim sql
sql = "INSERT INTO bom2_list_title " & _
      "(master_id, title_name, density, cidx, cdate) VALUES (" & _
      CLng(master_id) & ", " & _
      "N'" & Replace(title_name,"'","''") & "', " & _
      "N'" & Replace(density,"'","''") & "', " & _
      cidx & ", GETDATE())"

Dbcon.Execute sql

' ===== 새 ID 반환 =====
Dim RsId, newId
Set RsId = Server.CreateObject("ADODB.Recordset")
RsId.Open "SELECT SCOPE_IDENTITY() AS id", Dbcon
newId = RsId("id")
RsId.Close
Set RsId = Nothing

Response.Write "OK|" & newId

call DbClose()
%>
