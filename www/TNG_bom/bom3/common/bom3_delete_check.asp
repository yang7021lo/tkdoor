<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"

call DbOpen()

Dim targetType, targetId
targetType = LCase(Trim(Request("type")))
targetId   = Trim(Request("id"))

If targetType = "" Or Not IsNumeric(targetId) Then
    Response.Write "{""error"":""INVALID_PARAM""}"
    Response.End
End If

Dim json
json = "{""target"":{""type"":""" & targetType & """,""id"":" & targetId & "},"
json = json & """dependencies"":{"

' ===============================
' MASTER 기준
' ===============================
If targetType = "master" Then

    ' --- MATERIAL (자동) ---
    json = json & """material"":["
    Dim rs, sql, first
    first = True

    sql = "SELECT material_id FROM bom2_material " & _
          "WHERE master_id=" & targetId & " AND is_active=1"
    Set rs = Dbcon.Execute(sql)
    Do Until rs.EOF
        If Not first Then json = json & ","
        json = json & "{""id"":" & rs("material_id") & "}"
        first = False
        rs.MoveNext
    Loop
    rs.Close : Set rs = Nothing
    json = json & "],"

    ' --- MOLD (선택) ---
    json = json & """mold"":["
    first = True
    sql = "SELECT DISTINCT m.mold_id, m.mold_name " & _
          "FROM bom2_material mt " & _
          "JOIN bom2_mold m ON mt.mold_id = m.mold_id " & _
          "WHERE mt.master_id=" & targetId & _
          " AND mt.is_active=1 AND m.is_active=1"
    Set rs = Dbcon.Execute(sql)
    Do Until rs.EOF
        If Not first Then json = json & ","
        json = json & "{""id"":" & rs("mold_id") & ",""name"":""" & rs("mold_name") & """}"
        first = False
        rs.MoveNext
    Loop
    rs.Close : Set rs = Nothing
    json = json & "],"

    ' --- SURFACE (있다면) ---
    json = json & """surface"":[]"

End If

json = json & "}}"
Response.Write json
%>
