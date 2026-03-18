<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<%
Response.CharSet = "utf-8"
Response.ContentType = "text/html"
Response.Buffer = True
Call DbOpen()

' ===============================
' 유틸
' ===============================
Function ToLng(v, def)
  If IsNumeric(v) Then ToLng = CLng(v) Else ToLng = def
End Function

Function HtmlEsc(s)
  Dim t
  t = CStr(s & "")
  t = Replace(t, "&", "&amp;")
  t = Replace(t, "<", "&lt;")
  t = Replace(t, ">", "&gt;")
  t = Replace(t, """", "&quot;")
  HtmlEsc = t
End Function

' ===============================
' 파라미터
' type=title, id=row_id 로 사용
' ===============================
Dim pType, row_id, master_id, list_title_id
pType         = LCase(Trim(Request("type")))
row_id        = ToLng(Trim(Request("id")), 0)
master_id     = ToLng(Trim(Request("master_id")), 0)
list_title_id = ToLng(Trim(Request("list_title_id")), 0)

If pType <> "title" Or row_id <= 0 Then
  Response.Write "<meta charset='utf-8'><b style='color:red'>INVALID PARAM</b>"
  Call DbClose()
  Response.End
End If

' (선택) master_id가 있으면 안전하게 범위 제한
Dim whereMaster
whereMaster = ""
If master_id > 0 Then
  whereMaster = " AND (v.master_id IS NULL OR v.master_id = " & master_id & ")"
End If

' ===============================
' 1) row_id에 묶인 sub_value 목록
' ===============================
Dim RsVals, sqlVals
Set RsVals = Server.CreateObject("ADODB.Recordset")

sqlVals = _
  "SELECT v.sub_value_id, v.title_sub_id, v.sub_value, " & _
  "       s.sub_name, s.is_select, s.is_show " & _
  "FROM dbo.bom3_title_sub_value v " & _
  "JOIN dbo.bom3_list_title_sub s " & _
  "  ON s.title_sub_id = v.title_sub_id " & _
  " AND s.is_active = 1 " & _
  "WHERE v.row_id = " & row_id & _
  "  AND v.is_active = 1" & whereMaster & _
  " ORDER BY CASE WHEN s.is_show=1 THEN 0 WHEN s.is_select=1 THEN 1 ELSE 2 END, v.title_sub_id"

RsVals.Open sqlVals, Dbcon, 1, 1

' ===============================
' 2) 사용중 건수/목록
' ===============================
Dim RsCnt, RsUse, sqlCnt, sqlUse, useCnt
Set RsCnt = Server.CreateObject("ADODB.Recordset")
Set RsUse = Server.CreateObject("ADODB.Recordset")

sqlCnt = _
  "SELECT COUNT(*) AS cnt " & _
  "FROM dbo.bom3_table_value tv " & _
  "JOIN dbo.bom3_title_sub_value v ON v.sub_value_id = tv.title_sub_value_id " & _
  "WHERE v.row_id = " & row_id & _
  "  AND tv.is_active = 1" & whereMaster

RsCnt.Open sqlCnt, Dbcon, 1, 1

useCnt = 0
If Not RsCnt.EOF Then useCnt = CLng(RsCnt("cnt"))

sqlUse = _
  "SELECT TOP 50 " & _
  " tv.table_value_id, tv.material_id, tv.title_sub_id, " & _
  " bm.material_name, m.item_name " & _
  "FROM dbo.bom3_table_value tv " & _
  "JOIN dbo.bom3_title_sub_value v ON v.sub_value_id = tv.title_sub_value_id " & _
  "LEFT JOIN dbo.bom3_material bm ON bm.material_id = tv.material_id " & _
  "LEFT JOIN dbo.bom3_master   m  ON m.master_id   = bm.master_id " & _
  "WHERE v.row_id = " & row_id & _
  "  AND tv.is_active = 1" & whereMaster & _
  " ORDER BY tv.table_value_id DESC"

RsUse.Open sqlUse, Dbcon, 1, 1
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Sub Value 비활성화</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  body{padding:12px;}
  .small-muted{font-size:12px;color:#6b7280;}
</style>
</head>

<body>

<h6 class="mb-2">사용중 조회 후 비활성화</h6>

<div class="border rounded p-2 mb-2">
  <div><b>row_id</b>: <%=row_id%></div>
  <div><b>master_id</b>: <%=master_id%></div>
  <div><b>list_title_id</b>: <%=list_title_id%></div>
</div>

<!-- row_id로 묶인 sub_value 목록 -->
<div class="border rounded p-2 mb-2">
  <div class="mb-2"><b>해당 row의 sub_value 목록</b></div>
  <div class="table-responsive" style="max-height:170px; overflow:auto;">
    <table class="table table-sm table-bordered mb-0">
      <thead class="table-light">
        <tr>
          <th>서브 항목명</th>
          <th>서브 항목값</th>
        </tr>
      </thead>
      <tbody>
      <% If Not (RsVals.EOF Or RsVals.BOF) Then
           Do While Not RsVals.EOF %>
        <tr>
          <td><%=HtmlEsc(RsVals("sub_name"))%></td>
          <td><%=HtmlEsc(RsVals("sub_value"))%></td>
        </tr>
      <%   RsVals.MoveNext
           Loop
         Else %>
        <tr><td colspan="2" class="text-muted text-center">없음</td></tr>
      <% End If %>
      </tbody>
    </table>
  </div>
</div>

<!-- 사용중 목록 -->
<div class="border rounded p-2 mb-2">
  <div class="mb-2">
    <b>사용중 건수</b>: <%=useCnt%>
    <% If useCnt > 0 Then %>
      <span class="text-warning">(사용중 데이터가 있어요)</span>
    <% Else %>
      <span class="text-success">(사용중 없음)</span>
    <% End If %>
  </div>

  <div class="table-responsive" style="max-height:220px; overflow:auto;">
    <table class="table table-sm table-bordered mb-0">
      <thead class="table-light">
        <tr>
          <th>카테고리</th>
          <th>원자재</th>
        </tr>
      </thead>
      <tbody>
      <% If Not (RsUse.EOF Or RsUse.BOF) Then
           Do While Not RsUse.EOF %>
        <tr>
          <td><%=HtmlEsc(RsUse("item_name"))%></td>
          <td><%=HtmlEsc(RsUse("material_name"))%></td>
        </tr>
      <%   RsUse.MoveNext
           Loop
         Else %>
        <tr><td colspan="2" class="text-muted text-center">없음</td></tr>
      <% End If %>
      </tbody>
    </table>
  </div>

  <div class="d-flex justify-content-end gap-2 mt-2">
    <button class="btn btn-sm btn-outline-secondary" type="button" onclick="window.close()">닫기</button>
    <button class="btn btn-sm btn-danger" type="button" onclick="doDeactivate()">비활성화</button>
  </div>
</div>

<script>
  var ROW_ID = <%=row_id%>;
  var MASTER_ID = <%=master_id%>;
  var USE_CNT = <%=useCnt%>;

  // ✅ 절대경로 고정 (title/title 꼬임 방지)
  var DEACTIVATE_URL = "/TNG_bom/bom3/title/bom3_title_sub_value_deactivate.asp";

  // ✅ 완료 후 부모창 갱신
  function refreshOpener(){
    try{
      if (window.opener && !window.opener.closed) {
        if (typeof window.opener.reloadCurrentTab === "function") {
          window.opener.reloadCurrentTab();
        } else {
          window.opener.location.reload();
        }
      }
    }catch(e){}
  }

  // ✅ 비활성화 API 호출
  function callDeactivate(rowId, masterId, callback){
    var url = DEACTIVATE_URL
            + "?row_id=" + encodeURIComponent(rowId)
            + (masterId ? "&master_id=" + encodeURIComponent(masterId) : "")
            + "&view=json";

    var xhr = new XMLHttpRequest();
    xhr.open("POST", url, true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");

    xhr.onreadystatechange = function(){
      if(xhr.readyState !== 4) return;

      var res = null;
      try { res = JSON.parse(xhr.responseText); } catch(e) {}

      if (typeof callback === "function") {
        if (xhr.status >= 200 && xhr.status < 300 && res) {
          callback(res);
        } else {
          callback({
            ok: false,
            message: (res && res.message) ? res.message : ("HTTP " + xhr.status),
            raw: xhr.responseText
          });
        }
      }
    };

    xhr.send("");
  }

  // ✅ 버튼에서 호출
  function doDeactivate(){
    var msg = "정말 비활성화할까요?";
    if (USE_CNT > 0) msg = "현재 사용중 데이터가 " + USE_CNT + "건 있어요.\n그래도 비활성화할까요?";

    if(!confirm(msg)) return;

    callDeactivate(ROW_ID, MASTER_ID, function(result){
      if(result && result.ok){
        alert("삭제되었습니다.");
        refreshOpener();
        window.close();
      }else{
        alert("실패: " + (result && result.message ? result.message : ""));
      }
    });
  }
</script>

</body>
</html>

<%
On Error Resume Next
RsVals.Close : Set RsVals = Nothing
RsCnt.Close  : Set RsCnt  = Nothing
RsUse.Close  : Set RsUse  = Nothing
Call DbClose()
%>
