<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 변수 수집
' ===============================
Dim master_id, material_name, length_id, surface_id, mold_id
Dim unity_type, set_yn, values
Dim midx

If Not IsNumeric(Session("user_id")) Then
    Response.Write "NO_USER"
    Response.End
End If
midx = CLng(Session("user_id"))

If Not IsNumeric(Request("master_id")) Then
    Response.Write "INVALID_MASTER"
    Response.End
End If
master_id = CLng(Request("master_id"))

material_name = Trim(Request("material_name"))
unity_type    = Trim(Request("unity_type"))
If Trim(Request("set_yn") & "") = "1" Then
    set_yn = 1
Else
    set_yn = 0
End If
values        = Trim(Request("info_list"))

length_id  = Trim(Request("length_id"))
surface_id = Trim(Request("surface_id"))
mold_id    = Trim(Request("mold_id"))

' ===============================
' NULL 정규화 (★ 중요 ★)
' ===============================
If length_id = "" Or Not IsNumeric(length_id) Then
    length_id = "NULL"
End If

If surface_id = "" Or Not IsNumeric(surface_id) Then
    surface_id = "NULL"
End If

If mold_id = "" Or Not IsNumeric(mold_id) Then
    mold_id = "NULL"
End If

If material_name = "" Then
    Response.Write "INVALID"
    Response.End
End If

' ===============================
' Material INSERT
' ===============================
Dim sql
sql = "INSERT INTO bom2_material (" & _
      "master_id, material_name, length_id, surface_id, mold_id, " & _
      "unity_type, set_yn, is_active, midx, cdate" & _
      ") VALUES (" & _
      master_id & ", " & _
      "N'" & Replace(material_name,"'","''") & "', " & _
      length_id & ", " & _
      surface_id & ", " & _
      mold_id & ", " & _
      "N'" & Replace(unity_type,"'","''") & "', " & _
      set_yn & ", 1, " & midx & ", GETDATE()" & _
      ")"

Dbcon.Execute sql

' ===============================
' 방금 생성된 material_id
' ===============================
Dim RsId, material_id
Set RsId = Dbcon.Execute("SELECT SCOPE_IDENTITY()")
material_id = CLng(RsId(0))
Set RsId = Nothing

' ===============================
' table_value INSERT
' ===============================
Dim arr, i, p
If values <> "" Then
    arr = Split(values, "|")
    For i = 0 To UBound(arr)
        p = Split(arr(i), ":")
        If UBound(p) = 1 Then
            If IsNumeric(p(0)) Then
                Dbcon.Execute _
                  "INSERT INTO bom2_table_value " & _
                  "(material_id, list_title_id, value, is_active, cdate) VALUES (" & _
                  material_id & ", " & _
                  CLng(p(0)) & ", " & _
                  "N'" & Replace(p(1),"'","''") & "', 1, GETDATE())"
            End If
        End If
    Next
End If

Response.Write "OK"
call DbClose()
%>
