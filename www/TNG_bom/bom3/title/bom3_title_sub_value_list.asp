<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.Charset = "utf-8"

Call DbOpen()

' ===============================
' debug
' ===============================
Dim isDebug
isDebug = (Trim(Request("debug")) = "1")

Sub Die(msg)
  Response.Write msg
  On Error Resume Next
  Call DbClose()
  Response.End
End Sub

Sub DieErr(where, sqlText)
  Response.Write "<div style='font-family:consolas,monospace;padding:12px;border:1px solid #f5c2c7;background:#f8d7da;color:#842029;'>"
  Response.Write "<b>ERROR @ " & where & "</b><br>"
  Response.Write "Err.Number: " & Err.Number & "<br>"
  Response.Write "Err.Description: " & Server.HTMLEncode(Err.Description) & "<br>"
  If isDebug Then
    Response.Write "<hr><b>SQL</b><pre style='white-space:pre-wrap;'>" & Server.HTMLEncode(sqlText) & "</pre>"
  End If
  Response.Write "</div>"
  On Error Resume Next
  Call DbClose()
  Response.End
End Sub

Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = CStr(v)
End Function

Function NzLng(v, def)
  If IsNull(v) Then
    NzLng = def
  ElseIf IsNumeric(v) Then
    NzLng = CLng(v)
  Else
    NzLng = def
  End If
End Function

' ===============================
' list_title_id
' ===============================
Dim list_title_id
If IsNumeric(Request("list_title_id")) Then
  list_title_id = CLng(Request("list_title_id"))
Else
  Call Die("INVALID_LIST_TITLE_ID")
End If

' ===============================
' 타이틀 정보
' ===============================
Dim RsTitle, title_name, sqlTitle
Set RsTitle = Server.CreateObject("ADODB.Recordset")

sqlTitle = _
"SELECT title_name " & _
"FROM bom3_list_title " & _
"WHERE list_title_id = " & list_title_id & _
" AND is_active = 1"

On Error Resume Next
RsTitle.Open sqlTitle, Dbcon
If Err.Number <> 0 Then Call DieErr("RsTitle.Open", sqlTitle)
On Error GoTo 0

If RsTitle.EOF Then
  RsTitle.Close : Set RsTitle = Nothing
  Call Die("TITLE NOT FOUND")
End If

title_name = Nz(RsTitle("title_name"))
RsTitle.Close
Set RsTitle = Nothing

' ===============================
' 타이틀 서브(헤더)
' MoveFirst를 쓰려면 Client+Static 권장
' ===============================
Dim RsSub, sqlSub
Set RsSub = Server.CreateObject("ADODB.Recordset")
RsSub.CursorLocation = 3 ' adUseClient
RsSub.CursorType = 3     ' adOpenStatic
RsSub.LockType = 1       ' adLockReadOnly

sqlSub = _
"SELECT title_sub_id, sub_name " & _
"FROM bom3_list_title_sub " & _
"WHERE list_title_id = " & list_title_id & _
" AND is_active = 1 " & _
"ORDER BY midx, title_sub_id"

On Error Resume Next
RsSub.Open sqlSub, Dbcon
If Err.Number <> 0 Then Call DieErr("RsSub.Open", sqlSub)
On Error GoTo 0

' ===============================
' 값(내용) - sub_value_id까지 포함
' ===============================
Dim RsValue, sqlValue
Set RsValue = Server.CreateObject("ADODB.Recordset")
RsValue.CursorLocation = 3
RsValue.CursorType = 3
RsValue.LockType = 1

sqlValue = _
"SELECT v.row_id, v.master_id, m.item_name AS master_name, " & _
"       v.title_sub_id, v.sub_value_id, v.sub_value " & _
"FROM bom3_title_sub_value v " & _
"JOIN bom3_list_title_sub s ON v.title_sub_id = s.title_sub_id " & _
"JOIN bom3_master m ON v.master_id = m.master_id " & _
"WHERE s.list_title_id = " & list_title_id & _
"  AND v.is_active = 1 " & _
"ORDER BY v.row_id, v.title_sub_id"

On Error Resume Next
RsValue.Open sqlValue, Dbcon
If Err.Number <> 0 Then Call DieErr("RsValue.Open", sqlValue)
On Error GoTo 0

' ===============================
' dic 구조:
' dic(row_id) = { master_id, master_name, values(title_sub_id)=Array(sub_value_id, sub_value) }
' ===============================
Dim dic, dicRow, valuesDic
Set dic = Server.CreateObject("Scripting.Dictionary")

Do While Not RsValue.EOF
  Dim rid, mid, sid, svid, sval, mname
  rid  = NzLng(RsValue("row_id"), 0)
  mid  = NzLng(RsValue("master_id"), 0)
  sid  = NzLng(RsValue("title_sub_id"), 0)
  svid = NzLng(RsValue("sub_value_id"), 0)
  sval = Nz(RsValue("sub_value"))
  mname = Nz(RsValue("master_name"))

  If rid > 0 And sid > 0 Then
    Dim ridKey, sidKey
    ridKey = CStr(rid)
    sidKey = CStr(sid)

    If Not dic.Exists(ridKey) Then
      Set dicRow = Server.CreateObject("Scripting.Dictionary")
      dicRow.Add "master_id", mid
      dicRow.Add "master_name", mname

      Set valuesDic = Server.CreateObject("Scripting.Dictionary")
      dicRow.Add "values", valuesDic

      dic.Add ridKey, dicRow
    End If

    ' values(title_sub_id) = Array(sub_value_id, sub_value)
    dic(ridKey)("values")(sidKey) = Array(svid, sval)
  End If

  RsValue.MoveNext
Loop

RsValue.Close
Set RsValue = Nothing
%>

<!-- ===============================
     상단
================================ -->
<div class="d-flex justify-content-between align-items-center mb-3">
  <h5 class="mb-0"><%=Server.HTMLEncode(title_name)%> 서브 값 관리</h5>

  <div class="d-flex gap-2">
    <button class="btn btn-sm btn-primary" onclick="openSubValueAdd()">
      <i class="bi bi-plus-lg"></i> 값 추가
    </button>

    <button class="btn btn-sm btn-outline-secondary"
            onclick="openTitleSubManage(<%=list_title_id%>)">
      <i class="bi bi-gear"></i> <%=Server.HTMLEncode(title_name)%> 관리
    </button>
  </div>
</div>

<table class="table table-bordered align-middle"
       id="subValueTable"
       data-list-title-id="<%=list_title_id%>">
  <thead class="table-light">
    <tr>
      <th style="width:160px">카테고리</th>
      <%
        Dim colCount, hasSub
        colCount = 0
        hasSub = (Not RsSub.EOF)

        If Not hasSub Then
          colCount = 1
      %>
          <th class="text-muted" data-title-sub-id="0">서브 항목 없음</th>
      <%
        Else
          RsSub.MoveFirst
          Do While Not RsSub.EOF
            colCount = colCount + 1
      %>
            <th data-title-sub-id="<%=RsSub("title_sub_id")%>">
              <%=Server.HTMLEncode(Nz(RsSub("sub_name")))%>
            </th>
      <%
            RsSub.MoveNext
          Loop
        End If
      %>
      <th style="width:140px">관리</th>
    </tr>
  </thead>

  <tbody>
  <%
    If dic.Count = 0 Then
  %>
    <tr>
      <td colspan="<%=colCount + 2%>" class="text-center text-muted">
        등록된 값이 없습니다.
      </td>
    </tr>
  <%
    Else
      Dim rowKey
      For Each rowKey In dic.Keys
  %>
    <tr data-row-id="<%=rowKey%>">

      <%
        ' ✅ 카테고리 표시: master_name(master_id) / 이름 없으면 "-" (괄호만 나오는 것 방지)
        Dim catName, catId, catDisplay
        catName = Trim(Nz(dic(rowKey)("master_name")))
        catId   = Trim(CStr(dic(rowKey)("master_id") & ""))

        If catName <> "" Then
          If catId <> "" Then
            catDisplay = catName & " (" & catId & ")"
          Else
            catDisplay = catName
          End If
        Else
          catDisplay = ""
        End If
      %>

      <!-- 수정 버튼이 select로 바꾸기 위해 필요한 구조 -->
      <td class="sv-master" data-master-id="<%=catId%>">
        <%=Server.HTMLEncode(catDisplay)%>
      </td>

      <%
        If Not hasSub Then
          ' 서브가 없을 때도 컬럼수 맞추기
      %>
          <td class="sub-value text-muted" data-title-sub-id="0" data-sub-value-id="">-</td>
      <%
        Else
          RsSub.MoveFirst
          Do While Not RsSub.EOF
            Dim tsidKey, a, subValueId, subValueText
            tsidKey = CStr(RsSub("title_sub_id"))

            If dic(rowKey)("values").Exists(tsidKey) Then
              a = dic(rowKey)("values")(tsidKey)
              subValueId = a(0)
              subValueText = a(1)
      %>
              <td class="sub-value"
                  data-title-sub-id="<%=tsidKey%>"
                  data-sub-value-id="<%=subValueId%>">
                <%=Server.HTMLEncode(Nz(subValueText))%>
              </td>
      <%
            Else
      %>
              <td class="sub-value text-muted"
                  data-title-sub-id="<%=tsidKey%>"
                  data-sub-value-id="">-</td>
      <%
            End If

            RsSub.MoveNext
          Loop
        End If
      %>

      <td class="text-center">
        <button class="btn btn-sm btn-outline-secondary"
                onclick="editSubValueRow(this)">수정</button>
        <button class="btn btn-sm btn-outline-danger"
                onclick="deleteSubValue(this)">삭제</button>
      </td>
    </tr>
  <%
      Next
    End If
  %>
  </tbody>
</table>

<script>
function openTitleSubManage(listTitleId){
  const url = "title/bom3_title_sub_manage.asp?list_title_id=" + listTitleId;
  window.open(url, "titleSubManage", "width=700,height=600,scrollbars=yes");
}
</script>

<%
If Not (RsSub Is Nothing) Then
  If RsSub.State = 1 Then RsSub.Close
  Set RsSub = Nothing
End If

Call DbClose()
%>
