<%@ codepage="65001" language="vbscript" %>
<!-- #include virtual="/inc/dbcon.asp" -->

<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' list_title_id
' ===============================
Dim list_title_id
If IsNumeric(Request("list_title_id")) Then
    list_title_id = CLng(Request("list_title_id"))
Else
    Response.Write "INVALID LIST TITLE"
    Response.End
End If

' ===============================
' 타이틀명
' ===============================
Dim RsTitle, title_name
Set RsTitle = Server.CreateObject("ADODB.Recordset")

RsTitle.Open _
"SELECT title_name FROM bom3_list_title " & _
"WHERE list_title_id=" & list_title_id, Dbcon

If RsTitle.EOF Then
    Response.Write "TITLE NOT FOUND"
    Response.End
End If

title_name = RsTitle("title_name")
RsTitle.Close
Set RsTitle = Nothing

' ===============================
' 서브 목록
' ===============================
Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

sql = _
"SELECT title_sub_id, sub_name, is_active, is_select, is_show " & _
"FROM bom3_list_title_sub " & _
"WHERE list_title_id=" & list_title_id & _
" ORDER BY midx, title_sub_id"

Rs.Open sql, Dbcon
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=title_name%> 서브 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { padding:20px; background:#f8f9fa; }
</style>
</head>

<body>

<h5 class="mb-3">
    <%=title_name%> - 서브 항목 관리
</h5>

<!-- ===============================
     추가
================================ -->
<form method="post" action="bom3_title_sub_save.asp" class="mb-3">
<input type="hidden" name="list_title_id" value="<%=list_title_id%>">

<div class="input-group">
    <input type="text" name="sub_name"
           class="form-control"
           placeholder="서브 항목명"
           required>
    <button class="btn btn-primary">추가</button>
</div>
</form>

<!-- ===============================
     목록
================================ -->
<table class="table table-bordered table-sm align-middle">
<thead class="table-light">
<tr>
    <th>서브명</th>
    <th style="width:90px;">선택</th>
    <th style="width:90px;">표시</th>
    <th style="width:120px;">상태</th>
    <th style="width:140px;">관리</th>
</tr>
</thead>
<tbody>

<%
If Rs.EOF Then
%>
<tr>
    <td colspan="5" class="text-center text-muted">
        등록된 서브 항목이 없습니다.
    </td>
</tr>
<%
Else
Do While Not Rs.EOF
%>
<tr>
    <form method="post" action="bom3_title_sub_manage_update.asp">
    <input type="hidden" name="title_sub_id" value="<%=Rs("title_sub_id")%>">
    <input type="hidden" name="list_title_id" value="<%=list_title_id%>">

    <!-- 서브명 -->
    <td>
        <input type="text" name="sub_name"
               value="<%=Rs("sub_name")%>"
               class="form-control form-control-sm">
    </td>

    <!-- is_select -->
    <td class="text-center">
        <input type="checkbox"
               class="form-check-input"
               <% If Rs("is_select")=1 Then Response.Write "checked" End If %>
               onclick="toggleSelect(<%=Rs("title_sub_id")%>, <%=list_title_id%>, this)">
    </td>

    <!-- is_show -->
    <td class="text-center">
        <input type="checkbox"
               class="form-check-input"
               <% If Rs("is_show")=1 Then Response.Write "checked" End If %>
               onclick="toggleShow(<%=Rs("title_sub_id")%>, this)">
    </td>

    <!-- 상태 -->
    <td class="text-center">
        <% If Rs("is_active")=1 Then %>
            <span class="badge bg-success">사용</span>
        <% Else %>
            <span class="badge bg-secondary">중지</span>
        <% End If %>
    </td>

    <!-- 관리 -->
    <td class="text-center">
        <button class="btn btn-sm btn-success" type="submit">저장</button>
    </td>
    </form>
</tr>
<%
    Rs.MoveNext
Loop
End If
%>

</tbody>
</table>

<div class="text-end">
    <button class="btn btn-secondary" onclick="window.close()">닫기</button>
</div>

<!-- ===============================
     즉시 저장 JS
================================ -->
<script>
function toggleSelect(titleSubId, listTitleId, cb){
  if(!cb.checked) return; // select는 해제 불가

  fetch("bom3_title_sub_toggle.asp", {
    method: "POST",
    headers: { "Content-Type":"application/x-www-form-urlencoded" },
    body: "mode=select"
        + "&title_sub_id=" + titleSubId
        + "&list_title_id=" + listTitleId
  })
  .then(res => res.text())
  .then(t => {
    if(t !== "OK"){
      alert(t);
      cb.checked = false;
      return;
    }

    // ✅ 다른 select 체크 해제(기존 로직)
    document.querySelectorAll("input[onclick^='toggleSelect']").forEach(el=>{
      if(el !== cb) el.checked = false;
    });

    // ✅ 같은 행의 "표시" 체크박스도 자동 체크 + DB 저장
    var tr = cb.closest("tr");
    if(tr){
      var showCb = tr.querySelector("input[onclick^='toggleShow']");
      if(showCb && !showCb.checked){
        showCb.checked = true;

        // 서버에도 show=1 저장
        fetch("bom3_title_sub_toggle.asp", {
          method: "POST",
          headers: { "Content-Type":"application/x-www-form-urlencoded" },
          body: "mode=show"
              + "&title_sub_id=" + titleSubId
              + "&is_show=1"
        })
        .then(res2 => res2.text())
        .then(t2 => {
          if(t2 !== "OK"){
            alert(t2);
            showCb.checked = false; // 실패하면 되돌림
          }
        });
      }
    }
  });
}

function toggleShow(titleSubId, cb){
  fetch("bom3_title_sub_toggle.asp", {
    method: "POST",
    headers: { "Content-Type":"application/x-www-form-urlencoded" },
    body: "mode=show"
        + "&title_sub_id=" + titleSubId
        + "&is_show=" + (cb.checked ? 1 : 0)
  })
  .then(res => res.text())
  .then(t => {
    if(t !== "OK"){
      alert(t);
      cb.checked = !cb.checked;
    }
  });
}
</script>


</body>
</html>

<%
Rs.Close
Set Rs = Nothing
call DbClose()
%>