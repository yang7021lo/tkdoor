<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 파라미터 수신
' ===============================
Dim master_id_s, surface_name, surface_code, vender_id, memo
master_id_s   = Trim(Request("master_id"))
surface_name  = Trim(Request("surface_name"))
surface_code  = Trim(Request("surface_code"))
vender_id     = Trim(Request("vender_id"))
memo          = Trim(Request("memo"))

' ===============================
' 로그인 사용자
' ===============================
Dim c_midx
c_midx = 0
If Request.Cookies("tk")("c_midx") <> "" _
   And IsNumeric(Request.Cookies("tk")("c_midx")) Then
    c_midx = CLng(Request.Cookies("tk")("c_midx"))
End If

' ===============================
' 유효성 검사
' ===============================
If Not IsNumeric(master_id_s) Or surface_name = "" Then
    Response.Write "INVALID"
    Response.End
End If

Dim master_id
master_id = CLng(master_id_s)

' ===============================
' vender_id SQL 조각 (🔥 핵심)
' ===============================
Dim vender_sql
If vender_id = "" Then
    vender_sql = "NULL"
Else
    vender_sql = "'" & Replace(vender_id,"'","''") & "'"
End If

' ===============================
' INSERT
' ===============================
Dim sql
sql = "INSERT INTO bom2_surface (" & _
      "master_id, surface_name, surface_code, vender_id, memo, midx, cdate" & _
      ") VALUES (" & _
      master_id & ", " & _
      "N'" & Replace(surface_name,"'","''") & "', " & _
      "N'" & Replace(surface_code,"'","''") & "', " & _
      vender_sql & ", " & _
      "N'" & Replace(memo,"'","''") & "', " & _
      c_midx & ", GETDATE())"

Dbcon.Execute sql

' ===============================
' 신규 ID 반환
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
