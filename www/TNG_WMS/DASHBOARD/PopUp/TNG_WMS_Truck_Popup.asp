<%@ Language="VBScript" CodePage="65001" %>
<%

Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
Call dbOpen()

' =========================
' helpers
' =========================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function

Function SafeLong(v)
  On Error Resume Next
  SafeLong = CLng(0 & v)
  On Error GoTo 0
End Function

Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

Dim wms_idx, manual_idx, mode
Dim SQL, Rs, Rs2

Dim driver_name, driver_tel, car_no, car_ton

wms_idx    = Nz(Request("wms_idx"))
manual_idx = Nz(Request("manual_idx"))
mode       = LCase(Nz(Request("mode")))

driver_name = ""
driver_tel  = ""
car_no      = ""
car_ton     = ""

Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")

Dim idW, idM, kind
idW = SafeLong(wms_idx)
idM = SafeLong(manual_idx)

If idM > 0 Then
  kind = "manual"
Else
  kind = "meta"
End If

If kind = "meta" And idW <= 0 Then
  ' meta인데 wms_idx가 없으면 에러
  If mode = "save" Then
    Response.Write "<script>alert('wms_idx가 없습니다.');window.close();</script>"
    Response.End
  End If
End If

If kind = "manual" And idM <= 0 Then
  If mode = "save" Then
    Response.Write "<script>alert('manual_idx가 없습니다.');window.close();</script>"
    Response.End
  End If
End If


' ================================
' 저장 처리 (INSERT / UPDATE)
' ================================
If mode = "save" Then

  driver_name = Nz(Request.Form("driver_name"))
  driver_tel  = Nz(Request.Form("driver_tel"))
  car_no      = Nz(Request.Form("car_no"))
  car_ton     = Nz(Request.Form("car_ton"))

  Dim whereKey, cnt
  whereKey = ""

  If kind = "manual" Then
    whereKey = "manual_idx=" & idM & " AND (wms_idx IS NULL OR wms_idx=0)"
  Else
    whereKey = "wms_idx=" & idW & " AND (manual_idx IS NULL OR manual_idx=0)"
  End If

  SQL = "SELECT COUNT(*) AS cnt FROM tk_wms_delivery_truck WHERE " & whereKey
  Set Rs = DbCon.Execute(SQL)
  cnt = 0
  If Not (Rs.EOF Or Rs.BOF) Then cnt = SafeLong(Rs("cnt"))

  If cnt = 0 Then
    ' INSERT
    SQL = ""
    SQL = SQL & "INSERT INTO tk_wms_delivery_truck ("
    SQL = SQL & " wms_idx, manual_idx, driver_name, driver_tel, car_no, car_ton, wdate, midx "
    SQL = SQL & ") VALUES ("

    If kind = "manual" Then
      SQL = SQL & "NULL, " & idM & ", "
    Else
      SQL = SQL & idW & ", NULL, "
    End If

    SQL = SQL & "N'" & SqlEsc(driver_name) & "', "
    SQL = SQL & "N'" & SqlEsc(driver_tel)  & "', "
    SQL = SQL & "N'" & SqlEsc(car_no)      & "', "

    If car_ton = "" Then
      SQL = SQL & "NULL, "
    Else
      SQL = SQL & "N'" & SqlEsc(car_ton) & "', "
    End If

    SQL = SQL & "GETDATE(), "
    SQL = SQL & "N'" & SqlEsc(midx) & "'"
    SQL = SQL & ")"

  Else
    ' UPDATE
    SQL = ""
    SQL = SQL & "UPDATE tk_wms_delivery_truck SET "
    SQL = SQL & " driver_name=N'" & SqlEsc(driver_name) & "', "
    SQL = SQL & " driver_tel=N'"  & SqlEsc(driver_tel)  & "', "
    SQL = SQL & " car_no=N'"      & SqlEsc(car_no)      & "', "

    If car_ton = "" Then
      SQL = SQL & " car_ton=NULL, "
    Else
      SQL = SQL & " car_ton=N'" & SqlEsc(car_ton) & "', "
    End If

    SQL = SQL & " meidx=N'" & SqlEsc(midx) & "', "
    SQL = SQL & " udate=GETDATE() "
    SQL = SQL & "WHERE " & whereKey
  End If

  DbCon.Execute SQL
%>
<script>
(function () {
  function getRootOpener() {
    var w = window;
    while (w.opener && !w.opener.closed) {
      w = w.opener;
    }
    return w;
  }
  var root = getRootOpener();
  if (root && typeof root.showSavedAlert === "function") {
    root.showSavedAlert("저장이 완료되었습니다.");
  }
  window.close();
})();
</script>
<%
  Response.End
End If


' ================================
' 조회 (페이지 오픈 시)
' ================================
If kind = "manual" Then
  If idM > 0 Then
    SQL = "SELECT driver_name, driver_tel, car_no, car_ton " & _
          "FROM tk_wms_delivery_truck " & _
          "WHERE manual_idx=" & idM & " AND (wms_idx IS NULL OR wms_idx=0)"
    Rs2.Open SQL, DbCon, 1, 1
    If Not Rs2.EOF Then
      driver_name = Nz(Rs2("driver_name"))
      driver_tel  = Nz(Rs2("driver_tel"))
      car_no      = Nz(Rs2("car_no"))
      car_ton     = Nz(Rs2("car_ton"))
    End If
    Rs2.Close
  End If
Else
  If idW > 0 Then
    SQL = "SELECT driver_name, driver_tel, car_no, car_ton " & _
          "FROM tk_wms_delivery_truck " & _
          "WHERE wms_idx=" & idW & " AND (manual_idx IS NULL OR manual_idx=0)"
    Rs2.Open SQL, DbCon, 1, 1
    If Not Rs2.EOF Then
      driver_name = Nz(Rs2("driver_name"))
      driver_tel  = Nz(Rs2("driver_tel"))
      car_no      = Nz(Rs2("car_no"))
      car_ton     = Nz(Rs2("car_ton"))
    End If
    Rs2.Close
  End If
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>용차 정보 입력</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f4f6f9; font-size:16px; }
.page-title { font-weight:700; font-size:18px; }
.card-box { background:#fff; border-radius:14px; padding:16px; margin-bottom:12px; }
.form-label { font-weight:600; margin-bottom:6px; }
.form-control { height:52px; font-size:16px; }

.btn-fixed {
  position:fixed;
  bottom:0; left:0; right:0;
  padding:12px;
  background:#fff;
  border-top:1px solid #ddd;
  z-index:100;
}
.btn-save {
  height:54px;
  font-size:18px;
  font-weight:700;
}
body.has-fixed-btn { padding-bottom:90px; }
</style>
</head>

<body class="has-fixed-btn">
<div class="container-fluid p-3">

<div class="page-title mb-3">🚚 용차 정보 입력 (사랑과물류)</div>

<form method="post">
  <input type="hidden" name="mode" value="save">
  <input type="hidden" name="wms_idx" value="<%=Server.HTMLEncode(wms_idx)%>">
  <input type="hidden" name="manual_idx" value="<%=Server.HTMLEncode(manual_idx)%>">

  <div class="card-box">
    <label class="form-label">차량 톤수</label>
    <select name="car_ton" class="form-select form-control">
      <option value="">선택하세요</option>
      <option value="TON_1"  <% If car_ton="TON_1"  Then Response.Write "selected" %>>1톤</option>
      <option value="TON_14" <% If car_ton="TON_14" Then Response.Write "selected" %>>1.4톤</option>
      <option value="TON_25" <% If car_ton="TON_25" Then Response.Write "selected" %>>2.5톤</option>
      <option value="TON_5"  <% If car_ton="TON_5"  Then Response.Write "selected" %>>5톤</option>
      <option value="LABO"   <% If car_ton="LABO"   Then Response.Write "selected" %>>라보(다마스)</option>
      <option value="BIKE"   <% If car_ton="BIKE"   Then Response.Write "selected" %>>오토바이</option>
    </select>
  </div>

  <div class="card-box">
    <label class="form-label">배송기사 이름</label>
    <input type="text" name="driver_name" class="form-control"
           value="<%=Server.HTMLEncode(driver_name)%>" placeholder="이름 입력">
  </div>

  <div class="card-box">
    <label class="form-label">배송기사 전화번호</label>
    <input type="tel"
           name="driver_tel"
           class="form-control"
           inputmode="numeric"
           maxlength="13"
           oninput="formatPhone(this)"
           value="<%=Server.HTMLEncode(driver_tel)%>"
           placeholder="010-0000-0000">
  </div>

  <div class="card-box">
    <label class="form-label">차량 번호</label>
    <input type="text" name="car_no" class="form-control"
           value="<%=Server.HTMLEncode(car_no)%>" placeholder="예) 12가3456">
  </div>

  <div class="btn-fixed">
    <div class="d-flex gap-2">
      <button type="submit" class="btn btn-primary w-100 btn-save">저장</button>
      <button type="button"
              class="btn btn-secondary w-50 btn-save"
              onclick="alert('카카오톡에서는 닫기 버튼을 사용할 수 없습니다.\n좌측 상단 X 버튼을 눌러주세요.');">
        닫기
      </button>
    </div>
  </div>
</form>

</div>

<script>
function formatPhone(el) {
  let num = (el.value || "").replace(/[^0-9]/g, "");
  if (num.length < 4) {
    el.value = num;
  } else if (num.length < 7) {
    el.value = num.substr(0,3) + "-" + num.substr(3);
  } else if (num.length < 11) {
    el.value = num.substr(0,3) + "-" + num.substr(3,3) + "-" + num.substr(6);
  } else {
    el.value = num.substr(0,3) + "-" + num.substr(3,4) + "-" + num.substr(7,4);
  }
}
</script>

</body>
</html>

<%
Set Rs = Nothing
Set Rs2 = Nothing
Call dbClose()
%>
