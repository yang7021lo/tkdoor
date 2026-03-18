<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Call DbOpen()
On Error GoTo 0

' ===============================
' helpers
' ===============================
Function SqlStr(s)
  SqlStr = Replace(s & "", "'", "''")
End Function

Function ExecAff(sqlText)
  Dim aff : aff = 0
  Dbcon.Execute sqlText, aff
  ExecAff = aff
End Function

' ✅ title 값 UPSERT (is_active는 건드리지 않음 / is_active=1만 대상으로 UPDATE)
Sub UpsertTitleValue(matId, titleId, v)
  Dim aff, sql

  ' 1) 활성(is_active=1) 데이터가 있으면 UPDATE
  sql = "UPDATE bom3_table_value " & _
        "SET value=N'" & SqlStr(v) & "', udate=GETDATE() " & _
        "WHERE material_id=" & CLng(matId) & _
        " AND list_title_id=" & CLng(titleId) & _
        " AND is_active=1 " & _
        " AND title_sub_id IS NULL"
  aff = ExecAff(sql)

  ' 2) 없으면 INSERT (활성으로 저장)
  If aff = 0 Then
    sql = "INSERT INTO bom3_table_value (material_id, list_title_id, value, is_active) VALUES (" & _
          CLng(matId) & "," & CLng(titleId) & ",N'" & SqlStr(v) & "',1)"
    Call ExecAff(sql)
  End If
End Sub

' ✅ sub 값 UPSERT (is_active는 건드리지 않음 / is_active=1만 대상으로 UPDATE)
Sub UpsertSubValue(matId, subId, subValId)
  Dim aff, sql

  ' 1) 활성(is_active=1) 데이터가 있으면 UPDATE
  sql = "UPDATE bom3_table_value " & _
        "SET title_sub_value_id=" & CLng(subValId) & ", udate=GETDATE() " & _
        "WHERE material_id=" & CLng(matId) & _
        " AND title_sub_id=" & CLng(subId) & _
        " AND is_active=1 " & _
        " AND list_title_id IS NULL"
  aff = ExecAff(sql)

  ' 2) 없으면 INSERT (활성으로 저장)
  If aff = 0 Then
    sql = "INSERT INTO bom3_table_value (material_id, title_sub_id, title_sub_value_id, is_active) VALUES (" & _
          CLng(matId) & "," & CLng(subId) & "," & CLng(subValId) & ",1)"
    Call ExecAff(sql)
  End If
End Sub

' ===============================
' params
' ===============================
Dim material_id, master_id, material_name
material_id   = Trim(Request("material_id"))
master_id     = Trim(Request("master_id"))
material_name = Trim(Request("material_name"))

If Not IsNumeric(master_id) Or material_name = "" Then
  Response.Write "INVALID_DATA"
  Call DbClose()
  Response.End
End If

Dim isNew
isNew = (material_id = "")

' ===============================
' material insert/update (기존 로직 유지)
' ===============================
If isNew Then

  Dbcon.Execute _
    "INSERT INTO bom3_material (master_id, material_name) VALUES (" & _
      CLng(master_id) & ",N'" & SqlStr(material_name) & "')"

  Dim rsID
  Set rsID = Dbcon.Execute("SELECT @@IDENTITY")
  material_id = rsID(0)
  rsID.Close
  Set rsID = Nothing

Else

  If Not IsNumeric(material_id) Then
    Response.Write "INVALID_MATERIAL_ID"
    Call DbClose()
    Response.End
  End If

  Dbcon.Execute _
    "UPDATE bom3_material SET material_name=N'" & _
    SqlStr(material_name) & "', udate=GETDATE() " & _
    "WHERE material_id=" & CLng(material_id)

  ' ❌ 수정에서는 is_active=0 처리 금지 (삭제에서만)
  ' Dbcon.Execute "UPDATE bom3_table_value SET is_active=0 WHERE material_id=" & material_id

End If

' ===============================
' title 저장 (UPSERT)
' - 기존처럼 빈 값은 스킵(기존 유지)
' ===============================
Dim k, val, titleId
For Each k In Request.Form
  If Left(k,6) = "title_" Then
    val = Trim(Request.Form(k))
    titleId = Replace(k, "title_", "")

    If val <> "" And IsNumeric(titleId) Then
      Call UpsertTitleValue(material_id, titleId, val)
    End If
  End If
Next

' ==================================================
' SUB JSON 저장 (UPSERT)
' ==================================================
Dim subsJson
subsJson = Trim(Request("subs_json"))

If subsJson <> "" Then

  subsJson = Replace(subsJson, "[", "")
  subsJson = Replace(subsJson, "]", "")

  Dim items, i
  items = Split(subsJson, "},")

  For i = 0 To UBound(items)

    Dim item, subId, subVal
    item = items(i)
    item = Replace(item, "{", "")
    item = Replace(item, "}", "")
    item = Replace(item, """", "")

    Dim parts
    parts = Split(item, ",")

    subId  = Split(parts(0), ":")(1)
    subVal = Split(parts(1), ":")(1)

    If IsNumeric(subId) And IsNumeric(subVal) Then
      Call UpsertSubValue(material_id, subId, subVal)
    End If

  Next
End If

Response.Write "OK|" & material_id
Call DbClose()
Response.End
%>
