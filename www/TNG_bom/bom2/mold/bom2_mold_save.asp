<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 로그인 사용자 (쿠키 기반)
' ===============================
Dim c_midx
c_midx = 0
If request.cookies("tk")("c_midx") <> "" And IsNumeric(request.cookies("tk")("c_midx")) Then
    c_midx = CLng(request.cookies("tk")("c_midx"))
End If

' ===============================
' 파라미터 수신
' ===============================
Dim master_id, mold_no, mold_name
Dim vender_id, cad_path, img_path, memo

master_id = Trim(Request("master_id"))
mold_no   = Trim(Request("mold_no"))
mold_name = Trim(Request("mold_name"))
vender_id = Trim(Request("vender_id"))
cad_path  = Trim(Request("cad_path"))
img_path  = Trim(Request("img_path"))
memo      = Trim(Request("memo"))

' ===============================
' 유효성 체크
' ===============================
If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "INVALID_MASTER"
    Response.End
End If

If mold_name = "" Then
    Response.Write "EMPTY_NAME"
    Response.End
End If


Dim venderSQL
If vender_id = "" Or Not IsNumeric(vender_id) Then
    venderSQL = "NULL"
Else
    venderSQL = CLng(vender_id)
End If

' ===============================
' INSERT
' ===============================
Dim sql
sql = "INSERT INTO bom2_mold " & _
      "(master_id, mold_no, mold_name, vender_id, cad_path, img_path, memo, midx, cdate) VALUES (" & _
      CLng(master_id) & ", " & _
      "'" & Replace(mold_no, "'", "''") & "', " & _
      "'" & Replace(mold_name, "'", "''") & "', " & _
      venderSQL & ", " & _
      "'" & Replace(cad_path, "'", "''") & "', " & _
      "'" & Replace(img_path, "'", "''") & "', " & _
      "'" & Replace(memo, "'", "''") & "', " & _
      c_midx & ", getdate())"

Dbcon.Execute sql

' ===============================
' 새 ID 반환
' ===============================
Dim RsId, newId
Set RsId = Server.CreateObject("ADODB.Recordset")
RsId.Open "SELECT SCOPE_IDENTITY() AS id", Dbcon
newId = RsId("id")
RsId.Close
Set RsId = Nothing

Response.Write "OK|" & newId

call DbClose()
%>
