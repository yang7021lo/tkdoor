<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
call DbOpen()

' ===============================
' 파라미터
' ===============================
Dim pType, pId
pType = LCase(Trim(Request("type")))
pId   = Trim(Request("id"))

If pType = "" Or Not IsNumeric(pId) Then
    Response.Write "INVALID PARAMETER"
    Response.End
End If
pId = CLng(pId)

' ===============================
' 타입별 설정
' ===============================
Dim titleText, sqlList, sqlDeactivateTarget

Select Case pType

Case "mold"
    titleText = "금형"
    sqlList = "SELECT material_id, material_name " & _
              "FROM dbo.bom2_material " & _
              "WHERE mold_id=" & pId & " AND is_active=1"
    sqlDeactivateTarget = _
        "UPDATE dbo.bom2_mold SET is_active=0 WHERE mold_id=" & pId

Case "surface"
    titleText = "표면처리"
    sqlList = "SELECT material_id, material_name " & _
              "FROM dbo.bom2_material " & _
              "WHERE surface_id=" & pId & " AND is_active=1"
    sqlDeactivateTarget = _
        "UPDATE dbo.bom2_surface SET is_active=0 WHERE surface_id=" & pId

Case "length"
    titleText = "길이"
    sqlList = "SELECT material_id, material_name " & _
              "FROM dbo.bom2_material " & _
              "WHERE length_id=" & pId & " AND is_active=1"
    sqlDeactivateTarget = _
        "UPDATE dbo.bom2_length SET is_active=0 WHERE length_id=" & pId

Case "title"
    titleText = "리스트 타이틀"
    sqlList = _
        "SELECT DISTINCT m.material_id, m.material_name, v.value " & _
        "FROM dbo.bom2_table_value v " & _
        "JOIN dbo.bom2_material m ON v.material_id = m.material_id " & _
        "WHERE v.list_title_id=" & pId & _
        " AND v.is_active=1 AND m.is_active=1"
    sqlDeactivateTarget = _
        "UPDATE dbo.bom2_list_title SET is_active=0 WHERE list_title_id=" & pId

Case Else
    Response.Write "INVALID TYPE"
    Response.End
End Select

' ===============================
' 사용 중 Material 조회
' ===============================
Dim Rs
Set Rs = Server.CreateObject("ADODB.Recordset")
Rs.Open sqlList, Dbcon

Dim hasMaterial
hasMaterial = Not Rs.EOF

Dim materialIds
materialIds = ""

If hasMaterial Then
    Do While Not Rs.EOF
        materialIds = materialIds & Rs("material_id") & ","
        Rs.MoveNext
    Loop
    materialIds = Left(materialIds, Len(materialIds)-1)
    Rs.MoveFirst
End If

' ===============================
' POST 처리
' ===============================
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then

    Dim action
    action = Request("action")

    If pType = "title" Then
        ' 🔥 title 은 table_value 만 비활성화
        If action = "force" Or action = "deactivate" Then
            Dbcon.Execute _
                "UPDATE dbo.bom2_table_value " & _
                "SET is_active = 0 " & _
                "WHERE list_title_id = " & pId
        End If
        Dbcon.Execute sqlDeactivateTarget

    Else
        ' 🔥 나머지는 material → 대상 비활성화
        If action = "force" And materialIds <> "" Then
            Dbcon.Execute _
                "UPDATE dbo.bom2_material SET is_active=0 " & _
                "WHERE material_id IN (" & materialIds & ")"
        End If

        If action = "force" Or action = "deactivate" Then
            Dbcon.Execute sqlDeactivateTarget
        End If
    End If

    Rs.Close
    Set Rs = Nothing
    call DbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<script>
alert("비활성화가 완료되었습니다.");
if (window.opener) window.opener.location.reload();
window.close();
</script>
</head>
<body></body>
</html>
<%
    Response.End
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=titleText%> 비활성화</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background:#f1f3f5; }
.popup-box{
    background:#fff;
    border-radius:8px;
    padding:20px;
    box-shadow:0 10px 25px rgba(0,0,0,.1);
}
</style>
</head>

<body class="p-3">
<div class="popup-box">

<h5 class="mb-3 text-danger">🔒 <%=titleText%> 비활성화</h5>

<% If Not hasMaterial Then %>

<div class="alert alert-success mb-3">
사용 중인 항목이 없습니다.<br>바로 비활성화할 수 있습니다.
</div>

<form method="post" class="text-end">
<input type="hidden" name="action" value="deactivate">
<button class="btn btn-danger">비활성화</button>
<button type="button" class="btn btn-secondary" onclick="window.close()">취소</button>
</form>

<% Else %>

<div class="alert alert-warning mb-3">
<strong>⚠ 사용 중인 Material 이 존재합니다.</strong>
</div>

<div class="table-responsive mb-3">
<table class="table table-bordered table-sm">
<thead class="table-light">
<tr>
    <th style="width:80px;" class="text-center">상태</th>
    <th>Material 명</th>
    <% If pType="title" Then %>
        <th style="width:120px;">값</th>
    <% End If %>
</tr>
</thead>
<tbody>
<%
Rs.MoveFirst
Do While Not Rs.EOF
%>
<tr>
    <td class="text-center">
        <span class="badge bg-danger">사용중</span>
    </td>
    <td><%=Rs("material_name")%></td>

    <% If pType="title" Then %>
        <td>
            <% 
                If Trim(Rs("value") & "") <> "" Then
                    Response.Write Rs("value")
                Else
                    Response.Write "-"
                End If
            %>
        </td>
    <% End If %>
</tr>
<%
Rs.MoveNext
Loop
%>
</tbody>
</table>
</div>

<form method="post" class="text-end">
<input type="hidden" name="action" value="force">
<button class="btn btn-danger">
<% If pType="title" Then %>
값 비활성화 후 계속
<% Else %>
Material 비활성화 후 계속
<% End If %>
</button>
<button type="button" class="btn btn-secondary" onclick="window.close()">취소</button>
</form>

<% End If %>

</div>
</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call DbClose()
%>
