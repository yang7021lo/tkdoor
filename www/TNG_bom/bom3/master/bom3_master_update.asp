<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id, item_no, item_name, origin_type_no

master_id       = Trim(Request("master_id"))
item_no         = Trim(Request("item_no"))
item_name       = Trim(Request("item_name"))
origin_type_no  = Trim(Request("origin_type_no"))

' ===============================
' 필수값 검증
' ===============================
If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "INVALID"
    Response.End
End If

If item_no = "" Or item_name = "" Then
    Response.Write "INVALID"
    Response.End
End If

If origin_type_no = "" Or Not IsNumeric(origin_type_no) Then
    Response.Write "INVALID"
    Response.End
End If

' ===============================
' UPDATE (active는 건드리지 않음)
' ===============================
Dim sql
sql = "UPDATE bom3_master SET " & _
      "item_no = '" & Replace(item_no,"'","''") & "', " & _
      "item_name = N'" & Replace(item_name,"'","''") & "', " & _
      "origin_type_no = " & CLng(origin_type_no) & ", " & _
      "meidx = " & CLng(c_midx) & ", " & _
      "udate = GETDATE() " & _
      "WHERE master_id = " & CLng(master_id)

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>
