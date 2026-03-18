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
' 파라미터 수신 (문자열 상태)
' ===============================
Dim mold_id_s, master_id_s, vender_id_s
Dim mold_no, mold_name, cad_path, img_path, memo

mold_id_s   = Trim(Request("mold_id"))
master_id_s = Trim(Request("master_id"))
vender_id_s = Trim(Request("vender_id"))

mold_no   = Trim(Request("mold_no"))
mold_name = Trim(Request("mold_name"))
cad_path  = Trim(Request("cad_path"))
img_path  = Trim(Request("img_path"))
memo      = Trim(Request("memo"))

' ===============================
' 필수값 검사
' ===============================
If Not IsNumeric(mold_id_s) Or Not IsNumeric(master_id_s) Or mold_name = "" Then
    Response.Write "INVALID"
    Response.End
End If

Dim mold_id, master_id
mold_id   = CLng(mold_id_s)
master_id = CLng(master_id_s)


Dim venderSQL
If vender_id_s = "" Or Not IsNumeric(vender_id_s) Then
    venderSQL = "NULL"
Else
    venderSQL = CLng(vender_id_s)
End If

' ===============================
' UPDATE
' ===============================
Dim sql
sql = "UPDATE bom2_mold SET " & _
      "master_id = " & master_id & ", " & _
      "mold_no = '" & Replace(mold_no,"'","''") & "', " & _
      "mold_name = '" & Replace(mold_name,"'","''") & "', " & _
      "vender_id = " & venderSQL & ", " & _
      "cad_path = '" & Replace(cad_path,"'","''") & "', " & _
      "img_path = '" & Replace(img_path,"'","''") & "', " & _
      "memo = '" & Replace(memo,"'","''") & "', " & _
      "meidx = " & c_midx & ", " & _
      "udate = getdate() " & _
      "WHERE mold_id = " & mold_id

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>
