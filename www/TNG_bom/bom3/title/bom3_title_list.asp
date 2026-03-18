<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->

<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim Rs, RsMaster, RsType, sql
Set Rs       = Server.CreateObject("ADODB.Recordset")
Set RsMaster = Server.CreateObject("ADODB.Recordset")
Set RsType   = Server.CreateObject("ADODB.Recordset")

' 타이틀 리스트
sql = _
"SELECT T.list_title_id, T.master_id, T.type_id, " & _
"       T.title_name, T.is_active, T.is_sub, T.is_common, T.density, " & _
"       TY.type_name, M.item_name " & _
"FROM bom3_list_title T " & _
"LEFT JOIN bom3_title_type TY ON T.type_id = TY.type_id " & _
"LEFT JOIN bom3_master M ON T.master_id = M.master_id " & _
"WHERE T.is_active = 1 " & _
"ORDER BY T.list_title_id DESC"

Rs.Open sql, Dbcon

' 마스터 목록
RsMaster.Open _
"SELECT master_id, item_name FROM bom3_master WHERE is_active=1 ORDER BY item_name", Dbcon

' 타입 목록
RsType.Open _
"SELECT type_id, type_name FROM bom3_title_type ORDER BY type_id", Dbcon
%>

<!-- 🔥 상단 액션 -->
<div class="d-flex justify-content-between align-items-center mb-3">
    <h5 class="mb-0">타이틀 관리</h5>
    <button class="btn btn-sm btn-primary" onclick="openTitleAdd()">
        <i class="bi bi-plus-lg"></i> 타이틀 추가
    </button>
</div>

<table class="table table-bordered table-hover align-middle" id="titleTable">
<thead class="table-light">
<tr>
    <th>MASTER</th>
    <th>타이틀명</th>
    <th>SUB</th>
    <th>공통</th>
    <th>타입</th>
    <th>단위</th>
    <th style="width:140px">관리</th>
</tr>
</thead>
<tbody>

<%
If Rs.EOF Then
%>
<tr>
    <td colspan="7" class="text-center text-muted">데이터 없음</td>
</tr>
<%
Else
Do While Not Rs.EOF

  ' ✅ MASTER 표시: item_name(master_id) / item_name 없으면 "-" (괄호만 나오는 것 방지)
  Dim mName, mId, masterDisplay
  mName = Trim(CStr(Rs("item_name") & ""))
  mId   = Trim(CStr(Rs("master_id") & ""))

  If mName <> "" Then
    If mId <> "" Then
      masterDisplay = mName & " (" & mId & ")"
    Else
      masterDisplay = mName
    End If
  Else
    masterDisplay = ""
  End If
%>
<tr data-id="<%=Rs("list_title_id")%>">
    <td class="master-name" data-master="<%=mId%>">
        <%=Server.HTMLEncode(masterDisplay)%>
    </td>

    <td class="title-name"><%=Server.HTMLEncode(Rs("title_name") & "")%></td>

    <td class="text-center">
        <% If Rs("is_sub")=1 Then %>SUB<% Else %>-<% End If %>
    </td>

    <td class="text-center">
        <% If Rs("is_common")=1 Then %>공통<% Else %>-<% End If %>
    </td>

    <td class="type-name" data-type-id="<%=Rs("type_id")%>">
        <%=Server.HTMLEncode(Rs("type_name") & "")%>
    </td>

    <td class="density"><%=Server.HTMLEncode(Rs("density") & "")%></td>

    <td class="text-center">
        <button class="btn btn-sm btn-outline-secondary me-1"
                onclick="editTitleRow(this)">수정</button>
        <button class="btn btn-sm btn-outline-danger"
                onclick="deleteTitle(this)">삭제</button>
    </td>
</tr>
<%
Rs.MoveNext
Loop
End If
%>

</tbody>
</table>

<%
Rs.Close : RsMaster.Close : RsType.Close
Set Rs = Nothing : Set RsMaster = Nothing : Set RsType = Nothing
call DbClose()
%>
