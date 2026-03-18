<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 기본 검증
' ===============================
If Not IsNumeric(Session("user_id")) Then
    Response.Write "NO_USER"
    Response.End
End If

Dim material_id
If Not IsNumeric(Request("material_id")) Then
    Response.Write "INVALID_ID"
    Response.End
End If
material_id = CLng(Request("material_id"))

' ===============================
' 값 수집
' ===============================
Dim material_name, unity_type, set_yn
Dim length_id, surface_id, mold_id
Dim values

material_name = Trim(Request("material_name"))
unity_type    = Trim(Request("unity_type"))
values        = Trim(Request("info_list"))

length_id  = Trim(Request("length_id"))
surface_id = Trim(Request("surface_id"))
mold_id    = Trim(Request("mold_id"))

' set_yn (IIf 금지)
If Trim(Request("set_yn") & "") = "1" Then
    set_yn = 1
Else
    set_yn = 0
End If

If material_name = "" Then
    Response.Write "INVALID"
    Response.End
End If

' ===============================
' NULL 정규화
' ===============================
If length_id = "" Or Not IsNumeric(length_id) Then length_id = "NULL"
If surface_id = "" Or Not IsNumeric(surface_id) Then surface_id = "NULL"
If mold_id = "" Or Not IsNumeric(mold_id) Then mold_id = "NULL"

' ===============================
' Material UPDATE
' ===============================
Dbcon.Execute _
    "UPDATE bom2_material SET " & _
    "material_name = N'" & Replace(material_name,"'","''") & "', " & _
    "length_id = " & length_id & ", " & _
    "surface_id = " & surface_id & ", " & _
    "mold_id = " & mold_id & ", " & _
    "unity_type = N'" & Replace(unity_type,"'","''") & "', " & _
    "set_yn = " & set_yn & ", " & _
    "udate = GETDATE() " & _
    "WHERE material_id = " & material_id

' ===============================
' 기존 table_value 비활성화
' ===============================
Dbcon.Execute _
    "UPDATE bom2_table_value SET is_active = 0 " & _
    "WHERE material_id = " & material_id

' ===============================
' table_value 재 INSERT
' ===============================
Dim arr, i, p
If values <> "" Then
    arr = Split(values, "|")
    For i = 0 To UBound(arr)
        p = Split(arr(i), ":")
        If UBound(p) = 1 Then
            If IsNumeric(p(0)) Then
                Dbcon.Execute _
                    "INSERT INTO bom2_table_value (" & _
                    "material_id, list_title_id, value, is_active, cdate" & _
                    ") VALUES (" & _
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
