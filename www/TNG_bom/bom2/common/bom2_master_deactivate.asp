<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

Dim master_id
master_id = Trim(Request("master_id"))

If master_id = "" Or Not IsNumeric(master_id) Then
    Response.Write "잘못된 접근입니다."
    Response.End
End If

Dim rs, sql, item_name
Set rs = Server.CreateObject("ADODB.Recordset")

' Master 정보
sql = "SELECT item_name FROM bom2_master WHERE master_id=" & master_id
rs.Open sql, Dbcon
If rs.EOF Then
    Response.Write "존재하지 않는 Master 입니다."
    Response.End
End If
item_name = rs("item_name")
rs.Close

Function getCnt(q)
    Set rs = Dbcon.Execute(q)
    getCnt = rs(0)
    rs.Close
End Function

Dim cnt_material, cnt_mold, cnt_length, cnt_surface, cnt_title

cnt_material = getCnt("SELECT COUNT(*) FROM bom2_material WHERE master_id=" & master_id & " AND is_active=1")
cnt_mold     = getCnt("SELECT COUNT(DISTINCT mold_id) FROM bom2_material WHERE master_id=" & master_id & " AND is_active=1 AND mold_id IS NOT NULL")
cnt_length   = getCnt("SELECT COUNT(*) FROM bom2_length WHERE master_id=" & master_id & " AND is_active=1")
cnt_surface  = getCnt("SELECT COUNT(*) FROM bom2_surface WHERE master_id=" & master_id & " AND is_active=1")
cnt_title    = getCnt("SELECT COUNT(*) FROM bom2_list_title WHERE master_id=" & master_id & " AND is_active=1")
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Master 비활성화 안내</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
  <div class="card shadow-sm">
    <div class="card-body">

      <h5 class="text-danger mb-3">⚠️ 비활성화 안내</h5>

      <p>
        <strong><%=item_name%></strong> 과(와) 연결된 데이터가 존재합니다.<br>
        Master를 비활성화하려면 아래 항목들을 먼저 비활성화해야 합니다.
      </p>

      <ul>
        <li>Material : <%=cnt_material%> 건</li>
        <li>Mold : <%=cnt_mold%> 건</li>
        <li>Length : <%=cnt_length%> 건</li>
        <li>Surface : <%=cnt_surface%> 건</li>
        <li>List Title : <%=cnt_title%> 건</li>
      </ul>

      <div class="mt-4 d-flex gap-2">
        <a href="bom2_deactivate_apply.asp?master_id=<%=master_id%>"
           class="btn btn-danger">
          연결 항목 비활성화 진행
        </a>
        <a href="../bom2_main.asp"
           class="btn btn-secondary">
          취소
        </a>
      </div>

    </div>
  </div>
</div>

</body>
</html>

<%
call DbClose()
%>
