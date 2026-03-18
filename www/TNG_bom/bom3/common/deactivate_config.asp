<%
' ===============================
' Deactivate 대상 설정
' ===============================
Function GetDeactivateConfig(targetType)

    Dim cfg
    Set cfg = Server.CreateObject("Scripting.Dictionary")

    Select Case LCase(targetType)

Case "mold"
  cfg("label") = "금형"
  cfg("pk") = "mold_id"
  cfg("table") = "bom3_mold"
  cfg("name_col") = "mold_name"
  cfg("material_sql") = _
    "SELECT material_id, material_name FROM bom3_material " & _
    "WHERE mold_id=@id AND is_active=1"

Case "surface"
  cfg("label") = "표면처리"
  cfg("pk") = "surface_id"
  cfg("table") = "bom3_surface"
  cfg("name_col") = "surface_name"
  cfg("material_sql") = _
    "SELECT material_id, material_name FROM bom3_material " & _
    "WHERE surface_id=@id AND is_active=1"

Case "length"
  cfg("label") = "길이"
  cfg("pk") = "length_id"
  cfg("table") = "bom3_length"
  cfg("name_col") = "bom_length"
  cfg("material_sql") = _
    "SELECT material_id, material_name FROM bom3_material " & _
    "WHERE length_id=@id AND is_active=1"

Case "title"
  cfg("label") = "타이틀"
  cfg("pk") = "list_title_id"
  cfg("table") = "bom3_list_title"
  cfg("name_col") = "title_name"
  cfg("material_sql") = _
    "SELECT material_id, material_name FROM bom3_material " & _
    "WHERE info_list LIKE '%" & targetId & ":%' AND is_active=1"

End Select


    Set GetDeactivateConfig = cfg
End Function
%>
