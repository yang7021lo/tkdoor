<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 파라미터 수신
' ===============================
Dim surface_id_s, master_id_s
Dim surface_name, surface_code, vender_id, memo
Dim c_midx

surface_id_s  = Trim(Request("surface_id"))
master_id_s   = Trim(Request("master_id"))
surface_name  = Trim(Request("surface_name"))
surface_code  = Trim(Request("surface_code"))
vender_id     = Trim(Request("vender_id"))
memo          = Trim(Request("memo"))

' ===============================
' 로그인 사용자
' ===============================
c_midx = 0
If Request.Cookies("tk")("c_midx") <> "" _
   And IsNumeric(Request.Cookies("tk")("c_midx")) Then
    c_midx = CLng(Request.Cookies("tk")("c_midx"))
End If

' ===============================
' 유효성 검사
' ===============================
If Not IsNumeric(surface_id_s) _
   Or Not IsNumeric(master_id_s) _
   Or surface_name = "" Then

    Response.Write "INVALID"
    Response.End
End If

Dim surface_id, master_id
surface_id = CLng(surface_id_s)
master_id  = CLng(master_id_s)

' ===============================
' vender_id SQL 조각 생성 (🔥 핵심)
' ===============================
Dim vender_sql
If vender_id = "" Then
    vender_sql = "vender_id = NULL, "
Else
    vender_sql = "vender_id = '" & Replace(vender_id,"'","''") & "', "
End If

' ===============================
' UPDATE
' ===============================
Dim sql
sql = "UPDATE bom2_surface SET " & _
      "master_id = " & master_id & ", " & _
      "surface_name = N'" & Replace(surface_name,"'","''") & "', " & _
      "surface_code = N'" & Replace(surface_code,"'","''") & "', " & _
      vender_sql & _
      "memo = N'" & Replace(memo,"'","''") & "', " & _
      "meidx = " & c_midx & ", " & _
      "udate = GETDATE() " & _
      "WHERE surface_id = " & surface_id

Dbcon.Execute sql

Response.Write "OK"
call DbClose()
%>
