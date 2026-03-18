<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Call DbOpen()

' ===============================
' 유틸
' ===============================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = CStr(v)
End Function

Function SqlStr(s)
  SqlStr = Replace(Nz(s), "'", "''")
End Function

' SQL Server LIKE 특수문자 escape: %, _, [
Function LikeEscape(s)
  s = Nz(s)
  s = Replace(s, "[", "[[]")
  s = Replace(s, "%", "[%]")
  s = Replace(s, "_", "[_]")
  LikeEscape = s
End Function


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
Session("material_master_id") = master_id

' ===============================
' ✅ master_name (카테고리 표시용)
' ===============================
Dim master_name, rsM
master_name = ""
Set rsM = Server.CreateObject("ADODB.Recordset")
rsM.Open "SELECT item_name FROM bom3_master WHERE master_id=" & master_id, Dbcon
If Not rsM.EOF Then master_name = rsM("item_name") & ""
rsM.Close : Set rsM = Nothing


' ===============================
' ✅ 검색 세션(q) : master_id별로 유지
' ===============================
Dim sessKey, q, qEsc, searchFilter, matWhere
sessKey = "BOM3_MAT_Q_" & CStr(master_id)

q = Trim(Nz(Request("q")))

' q가 넘어오면 세션 저장 (빈값이면 저장 안 함)
If Len(q) > 0 Then
  Session(sessKey) = q
Else
  If Not IsEmpty(Session(sessKey)) Then
    q = Trim(Nz(Session(sessKey)))
  Else
    q = ""
  End If
End If

' 공통 WHERE (material alias = m)
matWhere = "m.master_id=" & master_id & " AND m.is_active=1"

searchFilter = ""
If q <> "" Then
  qEsc = LikeEscape(SqlStr(q))

  ' ✅ 검색 필터:
  ' 1) material_name
  ' 2) title 값(tv.value)
  ' 3) select-sub 값(svSel.sub_value)
  ' 4) ✅ show-sub 포함: 선택된 row_id 세트의 전체 sub_value(svAll.sub_value)
  searchFilter = _
    " AND ( " & _
    "   m.material_name LIKE '%" & qEsc & "%' " & _
    "   OR EXISTS ( " & _
    "     SELECT 1 " & _
    "     FROM bom3_table_value tv2 " & _
    "     WHERE tv2.is_active=1 " & _
    "       AND tv2.material_id = m.material_id " & _
    "       AND tv2.title_sub_id IS NULL " & _
    "       AND ISNULL(tv2.value,'') LIKE '%" & qEsc & "%' " & _
    "   ) " & _
    "   OR EXISTS ( " & _
    "     SELECT 1 " & _
    "     FROM bom3_table_value tv3 " & _
    "     JOIN bom3_title_sub_value svSel " & _
    "       ON svSel.sub_value_id = tv3.title_sub_value_id " & _
    "      AND svSel.is_active=1 " & _
    "     WHERE tv3.is_active=1 " & _
    "       AND tv3.material_id = m.material_id " & _
    "       AND tv3.title_sub_id IS NOT NULL " & _
    "       AND ISNULL(svSel.sub_value,'') LIKE '%" & qEsc & "%' " & _
    "   ) " & _
    "   OR EXISTS ( " & _
    "     SELECT 1 " & _
    "     FROM ( " & _
    "       SELECT DISTINCT s.list_title_id, sv.row_id " & _
    "       FROM bom3_table_value v " & _
    "       JOIN bom3_title_sub_value sv " & _
    "         ON v.title_sub_value_id = sv.sub_value_id " & _
    "        AND sv.is_active=1 " & _
    "       JOIN bom3_list_title_sub s " & _
    "         ON sv.title_sub_id = s.title_sub_id " & _
    "        AND s.is_active=1 " & _
    "       WHERE v.material_id = m.material_id " & _
    "         AND v.is_active=1 " & _
    "         AND v.title_sub_id IS NOT NULL " & _
    "     ) sel " & _
    "     JOIN bom3_list_title_sub s2 " & _
    "       ON s2.list_title_id = sel.list_title_id " & _
    "      AND s2.is_active=1 " & _
    "     JOIN bom3_title_sub_value svAll " & _
    "       ON svAll.title_sub_id = s2.title_sub_id " & _
    "      AND svAll.row_id     = sel.row_id " & _
    "      AND svAll.is_active  = 1 " & _
    "     WHERE ISNULL(svAll.sub_value,'') LIKE '%" & qEsc & "%' " & _
    "   ) " & _
    " ) "
End If


' ==================================================
' 1) 헤더와 동일한 "컬럼 정의" 만들기 (순서 고정)
' ==================================================
Dim colKind(), colTitleId(), colSubId(), colIsSelect(), colIsShow()
Dim colCount : colCount = 0

Sub PushCol(kind, titleId, subId, isSelect, isShow)
    If colCount = 0 Then
        ReDim colKind(0)
        ReDim colTitleId(0)
        ReDim colSubId(0)
        ReDim colIsSelect(0)
        ReDim colIsShow(0)
    Else
        ReDim Preserve colKind(colCount)
        ReDim Preserve colTitleId(colCount)
        ReDim Preserve colSubId(colCount)
        ReDim Preserve colIsSelect(colCount)
        ReDim Preserve colIsShow(colCount)
    End If

    colKind(colCount) = kind
    colTitleId(colCount) = titleId
    colSubId(colCount) = subId
    colIsSelect(colCount) = isSelect
    colIsShow(colCount) = isShow

    colCount = colCount + 1
End Sub

Sub BuildColumns(sqlTitle)
    Dim rsTitle, rsSub
    Set rsTitle = Server.CreateObject("ADODB.Recordset")
    rsTitle.Open sqlTitle, Dbcon

    Do While Not rsTitle.EOF
        If rsTitle("is_sub") = 0 Then
            Call PushCol("title", CLng(rsTitle("list_title_id")), 0, 0, 0)
        Else
            Set rsSub = Server.CreateObject("ADODB.Recordset")
            rsSub.Open _
              "SELECT title_sub_id, is_select, is_show " & _
              "FROM bom3_list_title_sub " & _
              "WHERE is_active=1 " & _
              "AND list_title_id=" & CLng(rsTitle("list_title_id")) & _
              " AND (is_select=1 OR is_show=1) " & _
              "ORDER BY CASE WHEN is_select=1 THEN 0 ELSE 1 END, title_sub_id", Dbcon

            Do While Not rsSub.EOF
                Call PushCol("sub", 0, CLng(rsSub("title_sub_id")), CInt(rsSub("is_select")), CInt(rsSub("is_show")))
                rsSub.MoveNext
            Loop

            rsSub.Close
            Set rsSub = Nothing
        End If

        rsTitle.MoveNext
    Loop

    rsTitle.Close
    Set rsTitle = Nothing
End Sub

Call BuildColumns("SELECT * FROM bom3_list_title WHERE is_active=1 AND is_sub=1 AND is_common=1")
Call BuildColumns("SELECT * FROM bom3_list_title WHERE is_active=1 AND is_sub=0 AND is_common=1")
Call BuildColumns( _
"SELECT * FROM bom3_list_title t " & _
"WHERE t.is_active=1 AND t.is_sub=1 AND t.is_common=0 " & _
"AND EXISTS ( " & _
"  SELECT 1 FROM bom3_title_sub_value v " & _
"  JOIN bom3_list_title_sub s ON v.title_sub_id = s.title_sub_id " & _
"  WHERE s.list_title_id = t.list_title_id " & _
"    AND v.is_active=1 " & _
"    AND (v.master_id IS NULL OR v.master_id=" & master_id & ") " & _
")" _
)
Call BuildColumns("SELECT * FROM bom3_list_title WHERE is_active=1 AND is_sub=0 AND is_common=0 AND master_id=" & master_id)


' ==================================================
' 2) Material 목록 (✅ 검색 반영)
' ==================================================
Dim rsMat, sqlMat
Set rsMat = Server.CreateObject("ADODB.Recordset")

sqlMat = _
  "SELECT m.material_id, m.material_name " & _
  "FROM bom3_material m " & _
  "WHERE " & matWhere & searchFilter & _
  "ORDER BY m.material_id"

rsMat.Open sqlMat, Dbcon

If rsMat.EOF Then
%>
<tr>
  <td colspan="100" class="text-center text-muted">
    <%=IIf(q<>"", "검색 결과 없음", "Material 데이터 없음")%>
  </td>
</tr>
<%
    rsMat.Close : Set rsMat = Nothing
    Call DbClose()
    Response.End
End If


' ==================================================
' 3) 값들을 미리 로딩 (N+1 방지) - (✅ 검색 반영)
' ==================================================
Dim dictTitleAll, dictSubTextAll, dictSubIdAll
Set dictTitleAll   = Server.CreateObject("Scripting.Dictionary")
Set dictSubTextAll = Server.CreateObject("Scripting.Dictionary")
Set dictSubIdAll   = Server.CreateObject("Scripting.Dictionary")

' --- title values
Dim rsTV, sqlTV
Set rsTV = Server.CreateObject("ADODB.Recordset")

sqlTV = _
"SELECT tv.material_id, tv.list_title_id, tv.value " & _
"FROM bom3_table_value tv " & _
"JOIN bom3_material m ON tv.material_id=m.material_id " & _
"WHERE " & matWhere & searchFilter & _
"  AND tv.is_active=1 AND tv.title_sub_id IS NULL"

rsTV.Open sqlTV, Dbcon

Do While Not rsTV.EOF
    Dim mid, tid, v
    mid = CStr(rsTV("material_id"))
    tid = CStr(rsTV("list_title_id"))
    v = rsTV("value") & ""

    Dim d1
    If Not dictTitleAll.Exists(mid) Then
        Set d1 = Server.CreateObject("Scripting.Dictionary")
        dictTitleAll.Add mid, d1
    Else
        Set d1 = dictTitleAll(mid)
    End If

    If d1.Exists(tid) Then
        If Trim(v) <> "" Then
            If InStr(1, " / " & d1(tid) & " / ", " / " & v & " / ", vbTextCompare) = 0 Then
                d1(tid) = d1(tid) & " / " & v
            End If
        End If
    Else
        d1.Add tid, v
    End If

    rsTV.MoveNext
Loop
rsTV.Close : Set rsTV = Nothing


' --- sub values (✅ show-sub 포함 row_id 세트)
Dim rsSub, sqlSub
Set rsSub = Server.CreateObject("ADODB.Recordset")

sqlSub = _
"WITH SEL AS ( " & _
"  SELECT DISTINCT v.material_id, s.list_title_id, sv.row_id " & _
"  FROM bom3_table_value v " & _
"  JOIN bom3_title_sub_value sv ON v.title_sub_value_id = sv.sub_value_id " & _
"  JOIN bom3_list_title_sub s ON sv.title_sub_id = s.title_sub_id " & _
"  JOIN bom3_material m ON v.material_id=m.material_id " & _
"  WHERE " & matWhere & searchFilter & _
"    AND v.is_active=1 " & _
"    AND sv.is_active=1 " & _
"    AND s.is_active=1 " & _
"    AND v.title_sub_id IS NOT NULL " & _
"), " & _
"FULLSET AS ( " & _
"  SELECT sel.material_id, sv.title_sub_id, sv.sub_value_id, sv.sub_value " & _
"  FROM SEL sel " & _
"  JOIN bom3_list_title_sub s ON s.list_title_id = sel.list_title_id AND s.is_active=1 " & _
"  JOIN bom3_title_sub_value sv ON sv.title_sub_id = s.title_sub_id " & _
"                             AND sv.row_id = sel.row_id " & _
"  WHERE sv.is_active=1 " & _
") " & _
"SELECT material_id, title_sub_id, sub_value_id, sub_value " & _
"FROM FULLSET " & _
"ORDER BY material_id, title_sub_id"

rsSub.Open sqlSub, Dbcon

Do While Not rsSub.EOF
    Dim mid2, sid2, svid2, stext2
    mid2 = CStr(rsSub("material_id"))
    sid2 = CStr(rsSub("title_sub_id"))
    svid2 = rsSub("sub_value_id") & ""
    stext2 = rsSub("sub_value") & ""

    Dim dTxt, dId
    If Not dictSubTextAll.Exists(mid2) Then
        Set dTxt = Server.CreateObject("Scripting.Dictionary")
        dictSubTextAll.Add mid2, dTxt
    Else
        Set dTxt = dictSubTextAll(mid2)
    End If

    If Not dictSubIdAll.Exists(mid2) Then
        Set dId = Server.CreateObject("Scripting.Dictionary")
        dictSubIdAll.Add mid2, dId
    Else
        Set dId = dictSubIdAll(mid2)
    End If

    dTxt(sid2) = stext2
    dId(sid2)  = svid2

    rsSub.MoveNext
Loop
rsSub.Close : Set rsSub = Nothing


' ==================================================
' 4) 출력
' ==================================================
Do While Not rsMat.EOF

    Dim material_id, material_name
    material_id = CLng(rsMat("material_id"))
    material_name = rsMat("material_name") & ""

    Dim kMid : kMid = CStr(material_id)

    Dim dTitle, dSubTxt, dSubId
    Set dTitle = Nothing
    Set dSubTxt = Nothing
    Set dSubId = Nothing
    If dictTitleAll.Exists(kMid) Then Set dTitle = dictTitleAll(kMid)
    If dictSubTextAll.Exists(kMid) Then Set dSubTxt = dictSubTextAll(kMid)
    If dictSubIdAll.Exists(kMid) Then Set dSubId = dictSubIdAll(kMid)
%>
<tr data-material-id="<%=material_id%>">
  <td><%=Server.HTMLEncode(master_name)%></td>

  <td>
    <span class="view-only view-value" data-field="material_name"><%=Server.HTMLEncode(material_name)%></span>
    <input type="text"
           class="form-control form-control-sm edit-only"
           data-field="material_name"
           value="<%=Server.HTMLEncode(material_name)%>">
  </td>

<%
    Dim c
    For c = 0 To colCount - 1

        If colKind(c) = "title" Then
            Dim tKey, tVal
            tKey = CStr(colTitleId(c))
            tVal = ""
            If Not (dTitle Is Nothing) Then
                If dTitle.Exists(tKey) Then tVal = dTitle(tKey)
            End If
%>
  <td>
    <span class="view-only view-value" data-title-id="<%=tKey%>"><%=Server.HTMLEncode(tVal)%></span>
    <input type="text"
           class="form-control form-control-sm edit-only"
           data-title-id="<%=tKey%>"
           value="<%=Server.HTMLEncode(tVal)%>">
  </td>
<%
        Else
            Dim sKey, selVal, showVal
            sKey = CStr(colSubId(c))
            selVal = ""
            showVal = ""

            If Not (dSubId Is Nothing) Then
                If dSubId.Exists(sKey) Then selVal = dSubId(sKey)
            End If
            If Not (dSubTxt Is Nothing) Then
                If dSubTxt.Exists(sKey) Then showVal = dSubTxt(sKey)
            End If

            If colIsSelect(c) = 1 Then
%>
  <td>
    <span class="view-only view-value" data-sub-id="<%=sKey%>"><%=Server.HTMLEncode(showVal)%></span>

    <select class="form-select form-select-sm edit-only"
            data-role="select-sub"
            data-title-sub-id="<%=sKey%>"
            data-selected-value="<%=Server.HTMLEncode(selVal)%>"
            onchange="onSelectSubChange(this)">
      <option value="">선택</option>
    </select>
  </td>
<%
            ElseIf colIsShow(c) = 1 Then
%>
  <td>
    <span class="view-value"
          data-role="show-sub"
          data-sub-id="<%=sKey%>"><%=Server.HTMLEncode(showVal)%></span>
  </td>
<%
            Else
%>
  <td></td>
<%
            End If
        End If
    Next
%>

  <td class="manage-col text-center">
    <button type="button" class="btn btn-sm btn-outline-primary" onclick="editMaterialRow(this)">수정</button>
    <button type="button" class="btn btn-sm btn-danger" onclick="deleteMaterialRow(this)">삭제</button>
  </td>
</tr>
<%
    rsMat.MoveNext
Loop

rsMat.Close
Set rsMat = Nothing

Call DbClose()
%>
