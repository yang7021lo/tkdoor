<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' master_id
' ===============================
Dim master_id
If IsNumeric(Request("master_id")) Then
    master_id = CLng(Request("master_id"))
ElseIf IsNumeric(Session("material_master_id")) Then
    master_id = CLng(Session("material_master_id"))
Else
    Response.End
End If


' ===============================
' 🔥 핵심 LIST SQL (row_id 기준)
' ===============================
Dim rs, sql
Set rs = Server.CreateObject("ADODB.Recordset")

sql = _
"WITH PICK_ROW AS ( " & _
"    SELECT DISTINCT v.material_id, sv.row_id " & _
"    FROM bom3_table_value v " & _
"    JOIN bom3_title_sub_value sv " & _
"      ON v.title_sub_value_id = sv.sub_value_id " & _
"    WHERE v.is_active = 1 " & _
") " & _
"SELECT " & _
"  m.material_id, " & _
"  m.material_name, " & _
"  t.list_title_id, " & _
"  t.is_sub, " & _
"  s.title_sub_id, " & _
"  s.is_select, " & _
"  s.is_show, " & _
"  tv.value      AS title_value, " & _
"  sv2.sub_value AS sub_value " & _
"FROM bom3_material m " & _
"JOIN bom3_list_title t " & _
"  ON t.is_active = 1 " & _
" AND (t.is_common = 1 OR t.master_id = m.master_id) " & _
"LEFT JOIN bom3_list_title_sub s " & _
"  ON s.list_title_id = t.list_title_id " & _
" AND s.is_active = 1 " & _
" AND (s.is_select = 1 OR s.is_show = 1) " & _
"LEFT JOIN bom3_table_value tv " & _
"  ON tv.material_id = m.material_id " & _
" AND tv.list_title_id = t.list_title_id " & _
" AND tv.title_sub_id IS NULL " & _
" AND tv.is_active = 1 " & _
"LEFT JOIN PICK_ROW pr " & _
"  ON pr.material_id = m.material_id " & _
"LEFT JOIN bom3_title_sub_value sv2 " & _
"  ON sv2.row_id = pr.row_id " & _
" AND sv2.title_sub_id = s.title_sub_id " & _
"WHERE m.is_active = 1 " & _
"AND m.master_id = " & master_id & _
"ORDER BY " & _
"  m.material_id, " & _
"  CASE " & _
"    WHEN t.is_common=1 AND t.is_sub=0 THEN 1 " & _
"    WHEN t.is_common=1 AND t.is_sub=1 THEN 2 " & _
"    WHEN t.is_common=0 AND t.is_sub=1 THEN 3 " & _
"    WHEN t.is_common=0 AND t.is_sub=0 THEN 4 " & _
"  END, " & _
"  t.list_title_id, " & _
"  CASE WHEN s.is_select=1 THEN 0 ELSE 1 END, " & _
"  s.title_sub_id"

rs.Open sql, Dbcon


' ===============================
' 출력
' ===============================
If rs.EOF Then
%>
<tr>
    <td colspan="100" class="text-center text-muted">Material 데이터 없음</td>
</tr>
<%
Else

Dim curMaterialId
curMaterialId = -1

Do While Not rs.EOF

    If curMaterialId <> rs("material_id") Then
        If curMaterialId <> -1 Then
%>
    <td class="text-center">
        <button class="btn btn-sm btn-outline-primary">수정</button>
        <button class="btn btn-sm btn-danger">삭제</button>
    </td>
</tr>
<%
        End If

        curMaterialId = rs("material_id")
%>
<tr data-material-id="<%=curMaterialId%>">
    <td><%=master_id%></td>
    <td>
        <span class="view-value">
            <%=Server.HTMLEncode(rs("material_name"))%>
        </span>
    </td>
<%
    End If

    Dim cellValue
    cellValue = ""

    If rs("is_sub") = 1 Then
        cellValue = rs("sub_value") & ""
    Else
        cellValue = rs("title_value") & ""
    End If
%>
    <td>
        <span class="view-value">
            <%=Server.HTMLEncode(cellValue)%>
        </span>
    </td>
<%
    rs.MoveNext
Loop
%>
    <td class="text-center">
        <button class="btn btn-sm btn-outline-primary">수정</button>
        <button class="btn btn-sm btn-danger">삭제</button>
    </td>
</tr>
<%
End If

rs.Close
Set rs = Nothing
call DbClose()
%>