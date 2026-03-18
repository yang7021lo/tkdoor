<%@ Language="VBScript" CodePage="65001" %>
<%

Session.CodePage="65001"
Response.Charset="utf-8"
Response.Buffer=True
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Function Nz(v) : If IsNull(v) Then Nz="" Else Nz=Trim(CStr(v)) End If : End Function
Function SqlEsc(s) : s=Nz(s) : SqlEsc=Replace(s,"'","''") : End Function
Function SafeLong(v)
  On Error Resume Next
  SafeLong = CLng(0 & v)
  On Error GoTo 0
End Function

' ★ item_text fallback 파싱(기존 데이터 호환)
Sub ParseItemText(ByVal itemText, ByRef outItem, ByRef outMeas)
  Dim p
  outItem = "" : outMeas = ""
  itemText = Nz(itemText)
  If itemText = "" Then Exit Sub

  p = Split(itemText, "|")
  If UBound(p) >= 0 Then outItem = Trim(p(0))
  If UBound(p) >= 1 Then outMeas = Trim(p(1))
End Sub

Dim ymd : ymd = Nz(Request("ymd"))
If ymd = "" Then ymd = Date()

Dim mode : mode = LCase(Nz(Request("mode")))
Dim wms_type : wms_type = Nz(Request("wms_type"))
Dim manual_idx : manual_idx = SafeLong(Request("manual_idx"))

Call dbOpen()

' =========================================================
' (A) 저장 - 신규
' =========================================================
If mode = "save" Then
  Dim company_id : company_id = SafeLong(Session("company_id"))
  If company_id <= 0 Then company_id = 1 ' 임시(원하면 제거)

  Dim customer_name, recv_name, recv_tel, dest_text
  Dim item_name, meas_name ' ★ 분리 컬럼
  Dim item_text            ' ★ 기존 호환 컬럼(계속 유지)
  Dim material_text, paint_no, spec_text, remark

  customer_name = Nz(Request("customer_name"))
  recv_name     = Nz(Request("recv_name"))
  recv_tel      = Nz(Request("recv_tel"))
  dest_text     = Nz(Request("dest_text"))

  item_name     = Nz(Request("item_name")) ' ★ NEW
  meas_name     = Nz(Request("meas_name")) ' ★ NEW

  ' ★ item_text는 호환용으로 "품목|검측" 저장
  item_text = item_name
  If meas_name <> "" Then item_text = item_text & "|" & meas_name

  material_text = Nz(Request("material_text"))
  paint_no      = Nz(Request("paint_no"))
  spec_text     = Nz(Request("spec_text"))
  remark        = Nz(Request("remark"))

  If wms_type = "" Then wms_type = "1"

  Dim reg_user
  reg_user = Nz(Session("user_id"))
  If reg_user = "" Then reg_user = Nz(Session("admin_id"))
  If reg_user = "" Then reg_user = "manual"

  Dim SQL
  SQL = ""
  SQL = SQL & "INSERT INTO dbo.tk_wms_dashboard_manual ("
  SQL = SQL & " company_id, ymd, wms_type, "
  SQL = SQL & " customer_name, recv_name, recv_tel, dest_text, "
  SQL = SQL & " item_name, meas_name, " ' ★ 추가
  SQL = SQL & " material_text, paint_no, spec_text, remark, "
  SQL = SQL & " is_active, reg_user, reg_date, upd_user, upd_date"
  SQL = SQL & ") VALUES ("
  SQL = SQL & company_id & ", "
  SQL = SQL & "'" & SqlEsc(ymd) & "', "
  SQL = SQL & SafeLong(wms_type) & ", "
  SQL = SQL & "N'" & SqlEsc(customer_name) & "', "
  SQL = SQL & "N'" & SqlEsc(recv_name) & "', "
  SQL = SQL & "N'" & SqlEsc(recv_tel) & "', "
  SQL = SQL & "N'" & SqlEsc(dest_text) & "', "
  SQL = SQL & "N'" & SqlEsc(item_name) & "', "     ' ★
  SQL = SQL & "N'" & SqlEsc(meas_name) & "', "     ' ★
  SQL = SQL & "N'" & SqlEsc(material_text) & "', "
  SQL = SQL & "N'" & SqlEsc(paint_no) & "', "
  SQL = SQL & "N'" & SqlEsc(spec_text) & "', "
  SQL = SQL & "N'" & SqlEsc(remark) & "', "
  SQL = SQL & "1, "
  SQL = SQL & "N'" & SqlEsc(reg_user) & "', SYSDATETIME(), "
  SQL = SQL & "N'" & SqlEsc(reg_user) & "', SYSDATETIME()"
  SQL = SQL & ")"

  DbCon.Execute SQL
%>
<!doctype html>
<html lang="ko"><head><meta charset="utf-8"><title>저장 완료</title></head>
<body>
<script>
  try { if (window.opener && !window.opener.closed) window.opener.location.reload(); } catch(e){}
  window.close();
</script>
</body></html>
<%
  Call dbClose()
  Response.End
End If

' =========================================================
' (B) 수정 - 업데이트
' =========================================================
If mode = "update" Then
  If manual_idx <= 0 Then
%>
<script>alert('manual_idx가 없습니다.');history.back();</script>
<%
    Call dbClose()
    Response.End
  End If

  Dim company_id_u : company_id_u = SafeLong(Session("company_id"))
  If company_id_u <= 0 Then company_id_u = 1 ' 임시(원하면 제거)

  Dim customer_name_u, recv_name_u, recv_tel_u, dest_text_u
  Dim item_name_u, meas_name_u, item_text_u ' ★
  Dim material_text_u, paint_no_u, spec_text_u, remark_u

  customer_name_u = Nz(Request("customer_name"))
  recv_name_u     = Nz(Request("recv_name"))
  recv_tel_u      = Nz(Request("recv_tel"))
  dest_text_u     = Nz(Request("dest_text"))

  item_name_u     = Nz(Request("item_name")) ' ★
  meas_name_u     = Nz(Request("meas_name")) ' ★

  item_text_u = item_name_u
  If meas_name_u <> "" Then item_text_u = item_text_u & "|" & meas_name_u ' ★ 호환

  material_text_u = Nz(Request("material_text"))
  paint_no_u      = Nz(Request("paint_no"))
  spec_text_u     = Nz(Request("spec_text"))
  remark_u        = Nz(Request("remark"))

  If wms_type = "" Then wms_type = "1"

  Dim upd_user
  upd_user = Nz(Session("user_id"))
  If upd_user = "" Then upd_user = Nz(Session("admin_id"))
  If upd_user = "" Then upd_user = "manual"

  Dim SQLU
  SQLU = ""
  SQLU = SQLU & "UPDATE dbo.tk_wms_dashboard_manual SET "
  SQLU = SQLU & " ymd = '" & SqlEsc(ymd) & "', "
  SQLU = SQLU & " wms_type = " & SafeLong(wms_type) & ", "
  SQLU = SQLU & " customer_name = N'" & SqlEsc(customer_name_u) & "', "
  SQLU = SQLU & " recv_name = N'" & SqlEsc(recv_name_u) & "', "
  SQLU = SQLU & " recv_tel = N'" & SqlEsc(recv_tel_u) & "', "
  SQLU = SQLU & " dest_text = N'" & SqlEsc(dest_text_u) & "', "
  SQLU = SQLU & " item_name = N'" & SqlEsc(item_name_u) & "', " ' ★
  SQLU = SQLU & " meas_name = N'" & SqlEsc(meas_name_u) & "', " ' ★
  SQLU = SQLU & " material_text = N'" & SqlEsc(material_text_u) & "', "
  SQLU = SQLU & " paint_no = N'" & SqlEsc(paint_no_u) & "', "
  SQLU = SQLU & " spec_text = N'" & SqlEsc(spec_text_u) & "', "
  SQLU = SQLU & " remark = N'" & SqlEsc(remark_u) & "', "
  SQLU = SQLU & " upd_user = N'" & SqlEsc(upd_user) & "', "
  SQLU = SQLU & " upd_date = SYSDATETIME() "
  SQLU = SQLU & "WHERE manual_idx=" & manual_idx & " AND is_active=1"

  DbCon.Execute SQLU
%>
<!doctype html>
<html lang="ko"><head><meta charset="utf-8"><title>수정 완료</title></head>
<body>
<script>
  try { if (window.opener && !window.opener.closed) window.opener.location.reload(); } catch(e){}
  window.close();
</script>
</body></html>
<%
  Call dbClose()
  Response.End
End If

' =========================================================
' (B-1) 삭제 - 비활성 처리
' =========================================================
If mode = "delete" Then
  If manual_idx <= 0 Then
%>
<script>alert('manual_idx가 없습니다.');history.back();</script>
<%
    Call dbClose()
    Response.End
  End If

  Dim upd_user_d
  upd_user_d = Nz(Session("user_id"))
  If upd_user_d = "" Then upd_user_d = Nz(Session("admin_id"))
  If upd_user_d = "" Then upd_user_d = "manual"

  Dim SQLD
  SQLD = ""
  SQLD = SQLD & "DELETE FROM dbo.tk_wms_dashboard_manual "
  SQLD = SQLD & "WHERE manual_idx=" & manual_idx & " AND is_active=1"

  DbCon.Execute SQLD
%>
<!doctype html>
<html lang="ko"><head><meta charset="utf-8"><title>삭제 완료</title></head>
<body>
<script>
  try { if (window.opener && !window.opener.closed) window.opener.location.reload(); } catch(e){}
  window.close();
</script>
</body></html>
<%
  Call dbClose()
  Response.End
End If

' =========================================================
' (C) 화면 진입: manual_idx 있으면 조회해서 폼에 채우기
' =========================================================
Dim customer_name_v, recv_name_v, recv_tel_v, dest_text_v
Dim item_name_v, meas_name_v, item_text_v ' ★
Dim material_text_v, paint_no_v, spec_text_v, remark_v

customer_name_v = "" : recv_name_v = "" : recv_tel_v = ""
dest_text_v = "" : material_text_v = ""
paint_no_v = "" : spec_text_v = "" : remark_v = ""
item_name_v = "" : meas_name_v = "" : item_text_v = "" ' ★

If manual_idx > 0 Then
  Dim RS, SQLS
  Set RS = Server.CreateObject("ADODB.Recordset")

  SQLS = ""
  SQLS = SQLS & "SELECT TOP 1 "
  SQLS = SQLS & " ymd, wms_type, customer_name, recv_name, recv_tel, dest_text, "
  SQLS = SQLS & " item_name, meas_name, " ' ★
  SQLS = SQLS & " material_text, paint_no, spec_text, remark "
  SQLS = SQLS & "FROM dbo.tk_wms_dashboard_manual WITH (NOLOCK) "
  SQLS = SQLS & "WHERE manual_idx=" & manual_idx & " AND is_active=1"

  RS.Open SQLS, DbCon, 1, 1
  If Not (RS.BOF Or RS.EOF) Then
    ymd = Nz(RS("ymd"))
    wms_type = Nz(RS("wms_type"))

    customer_name_v = Nz(RS("customer_name"))
    recv_name_v     = Nz(RS("recv_name"))
    recv_tel_v      = Nz(RS("recv_tel"))
    dest_text_v     = Nz(RS("dest_text"))

    item_name_v     = Nz(RS("item_name")) ' ★
    meas_name_v     = Nz(RS("meas_name")) ' ★

    ' ★ 과거 데이터(분리 컬럼 비었을 때)면 item_text에서 파싱
    If item_name_v = "" And item_text_v <> "" Then
      Call ParseItemText(item_text_v, item_name_v, meas_name_v)
    End If

    material_text_v = Nz(RS("material_text"))
    paint_no_v      = Nz(RS("paint_no"))
    spec_text_v     = Nz(RS("spec_text"))
    remark_v        = Nz(RS("remark"))
  End If
  RS.Close : Set RS = Nothing
End If
%>

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <title>수동 출고 등록</title>
  <style>
    body{font-family:맑은 고딕, Arial; margin:16px;}
    .row{display:flex; gap:12px; margin-bottom:10px;}
    .col{flex:1;}
    label{display:block; font-size:12px; color:#555; margin-bottom:4px;}
    input, textarea, select{width:100%; padding:10px; box-sizing:border-box; border:1px solid #ccc; border-radius:6px;}
    textarea{height:90px; resize:vertical;}
    .bar{display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;}
    .btn{padding:10px 14px; border:0; border-radius:8px; cursor:pointer;}
    .btn-primary{background:#0d6efd; color:#fff;}
    .btn-secondary{background:#6c757d; color:#fff;}
  </style>
</head>
<body>

  <div class="bar">
    <div style="font-size:18px; font-weight:700;">
      <% If manual_idx > 0 Then %>수동 출고 수정<% Else %>수동 출고 등록<% End If %>
    </div>
    <button class="btn btn-secondary" onclick="window.close()">닫기</button>
  </div>

  <form method="post" action="TNG_WMS_Dashboard_Manual_Popup.asp" id="manualForm">
    <input type="hidden" name="mode" id="mode" value="<% If manual_idx > 0 Then Response.Write("update") Else Response.Write("save") End If %>">
    <input type="hidden" name="manual_idx" value="<%=manual_idx%>">

    <div class="row">
      <div class="col">
        <label>출고일</label>
        <input type="date" name="ymd" value="<%=Server.HTMLEncode(ymd)%>">
      </div>
      <div class="col">
        <label>출고구분</label>
        <select name="wms_type" id="wms_type">
          <option value="">-</option>
          <option value="1"  <%If wms_type="1"  Then Response.Write("selected")%>>화물</option>
          <option value="2"  <%If wms_type="2"  Then Response.Write("selected")%>>낮1배달_신두영(인천,고양)</option>
          <option value="3"  <%If wms_type="3"  Then Response.Write("selected")%>>낮2배달_최민성(경기)</option>
          <option value="4"  <%If wms_type="4"  Then Response.Write("selected")%>>밤1배달_윤성호(수원,천안,능력)</option>
          <option value="5"  <%If wms_type="5"  Then Response.Write("selected")%>>밤2배달_김정호(하남)</option>
          <option value="6"  <%If wms_type="6"  Then Response.Write("selected")%>>대구창고</option>
          <option value="7"  <%If wms_type="7"  Then Response.Write("selected")%>>대전창고</option>
          <option value="8"  <%If wms_type="8"  Then Response.Write("selected")%>>부산창고</option>
          <option value="9"  <%If wms_type="9"  Then Response.Write("selected")%>>양산창고</option>
          <option value="10" <%If wms_type="10" Then Response.Write("selected")%>>익산창고</option>
          <option value="11" <%If wms_type="11" Then Response.Write("selected")%>>원주창고</option>
          <option value="12" <%If wms_type="12" Then Response.Write("selected")%>>제주창고</option>
          <option value="13" <%If wms_type="13" Then Response.Write("selected")%>>용차</option>
          <option value="14" <%If wms_type="14" Then Response.Write("selected")%>>방문</option>
          <option value="15" <%If wms_type="15" Then Response.Write("selected")%>>1공장</option>
          <option value="16" <%If wms_type="16" Then Response.Write("selected")%>>인천항</option>
          <option value="17" <%If wms_type="17" Then Response.Write("selected")%>>제주화물</option>
          <option value="18" <%If wms_type="18" Then Response.Write("selected")%>>제주택배</option>
          <option value="19" <%If wms_type="19" Then Response.Write("selected")%>>택배</option>
        </select>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>거래처명</label>
        <input name="customer_name" value="<%=Server.HTMLEncode(customer_name_v)%>">
      </div>
      <div class="col">
        <label>받는이</label>
        <input name="recv_name" value="<%=Server.HTMLEncode(recv_name_v)%>">
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>도착지(현장)</label>
        <input name="dest_text" value="<%=Server.HTMLEncode(dest_text_v)%>">
      </div>
      <div class="col">
        <label>도장번호</label>
        <input name="paint_no" value="<%=Server.HTMLEncode(paint_no_v)%>">
      </div>
    </div>


    <div class="row">
      <div class="col">
        <label>품목명</label>
        <input name="item_name" value="<%=Server.HTMLEncode(item_name_v)%>">
      </div>
      <div class="col">
        <label>검측명</label>
        <input name="meas_name" value="<%=Server.HTMLEncode(meas_name_v)%>">
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>재질</label>
        <input name="material_text" value="<%=Server.HTMLEncode(material_text_v)%>">
      </div>
      <div class="col">
        <label>전화번호</label>
        <input type="text" id="recv_tel" name="recv_tel" placeholder="예: 010-1234-5678"
               value="<%=Server.HTMLEncode(recv_tel_v)%>">
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>규격/수량(그대로 입력)</label>
        <textarea name="spec_text" placeholder="예: 픽스세트 1103×1 / 박스세트 2270×1 / ... 또는 줄바꿈으로 입력"><%=Server.HTMLEncode(spec_text_v)%></textarea>
      </div>
    </div>

    <div class="row">
      <div class="col">
        <label>비고</label>
        <input name="remark" value="<%=Server.HTMLEncode(remark_v)%>">
      </div>
    </div>

    <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:12px;">
      <% If manual_idx > 0 Then %>
       <button type="button" class="btn btn-danger" onclick="onDelete()">삭제</button>
      <% End If %>
      <button type="submit" class="btn btn-primary">
        <% If manual_idx > 0 Then %>수정 저장<% Else %>저장<% End If %>
      </button>
    </div>
  </form>

<script>
function onDelete(){
  if(!confirm("삭제하시겠습니까?")) return;
  var mode = document.getElementById("mode");
  var form = document.getElementById("manualForm");
  if(mode && form){
    mode.value = "delete";
    form.submit();
  }
}
const phone = document.getElementById("recv_tel");
if(phone){
  phone.addEventListener("input", function(e) {
    let value = e.target.value.replace(/[^0-9]/g, "");
    if (value.length > 3 && value.length <= 7) {
      value = value.slice(0, 3) + "-" + value.slice(3);
    } else if (value.length > 7) {
      value = value.slice(0, 3) + "-" + value.slice(3, 7) + "-" + value.slice(7, 11);
    }
    e.target.value = value;
  });
}
</script>
</body>
</html>

<%
Call dbClose()
%>
