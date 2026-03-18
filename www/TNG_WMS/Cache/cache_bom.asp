<%
' ==========================================
' BOM MASTER CACHE
' material_id -> item_name
' ==========================================

Dim dictBom, RsBom, sqlBom
Set dictBom = Server.CreateObject("Scripting.Dictionary")
Set Rs1 = Server.CreateObject("ADODB.Recordset")

sqlBom = ""
sqlBom = sqlBom & " SELECT material_id, material_name "
sqlBom = sqlBom & " FROM bom2_material "
sqlBom = sqlBom & " WHERE is_active = 1 "

Set Rs1 = DbCon.Execute(sqlBom)
'response.write "<!-- BOM 캐시 로드 완료: " & Rs1.RecordCount & " 건 -->" ' 디버그용
If Not (Rs1.BOF Or Rs1.EOF) Then
    Do Until Rs1.EOF
        dictBom(CStr(Rs1("material_id"))) = Rs1("material_name")
        Rs1.MoveNext
    Loop
End If

Rs1.Close
Set Rs1 = Nothing


%>
