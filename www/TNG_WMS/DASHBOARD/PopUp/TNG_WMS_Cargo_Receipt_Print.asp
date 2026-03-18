<%@ Language="VBScript" CodePage="65001" %>
<%

Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<%
Call dbOpen()

Dim Rs, RsWMS, RsDiC, RsMan
Set Rs    = Server.CreateObject("ADODB.Recordset")
Set RsWMS = Server.CreateObject("ADODB.Recordset")
Set RsDiC = Server.CreateObject("ADODB.Recordset")
Set RsMan = Server.CreateObject("ADODB.Recordset")

Dim ymd
ymd = Trim(Request("ymd"))
If ymd = "" Then ymd = Date()

' =========================
' helpers (Null-safe)
' =========================
Function Nz(v)
  If IsNull(v) Then
    Nz = ""
  Else
    Nz = Trim(CStr(v))
  End If
End Function

Function SafeLong(v)
  On Error Resume Next
  SafeLong = CLng(0 & Nz(v))
  On Error GoTo 0
End Function

Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

Function JsEsc(s)
  s = Nz(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  s = Replace(s, vbCr, "\n")
  s = Replace(s, vbLf, "\n")
  JsEsc = s
End Function

' =========================
' WMS META 캐시 (meta 전용)
' =========================
Dim dictWms
Set dictWms = Server.CreateObject("Scripting.Dictionary")

Dim SQL
SQL = ""
SQL = SQL & "SELECT DISTINCT wms_idx, recv_tel, wms_type, recv_name, recv_addr, sender_name "
SQL = SQL & "FROM tk_wms_meta "
SQL = SQL & "WHERE actual_ship_dt = '" & SqlEsc(ymd) & "' "
SQL = SQL & "AND wms_type IN (1,17,18,19) "
SQL = SQL & "ORDER BY recv_name "

RsWMS.Open SQL, DbCon, 1, 1

Do Until RsWMS.EOF
  Dim key, item
  key = Nz(RsWMS("wms_idx"))  ' ✅ CStr 제거 (Null-safe)

  If key <> "" Then
    Set item = Server.CreateObject("Scripting.Dictionary")
    item("recv_tel")    = Nz(RsWMS("recv_tel"))
    item("wms_type")    = Nz(RsWMS("wms_type"))
    item("recv_addr")   = Nz(RsWMS("recv_addr"))
    item("sender_name") = Nz(RsWMS("sender_name"))

    If dictWms.Exists(key) Then
        dictWms.Remove key
    End If
    dictWms.Add key, item
  End If

  RsWMS.MoveNext
Loop
RsWMS.Close

' =========================
' DELIVERY INFO 캐시 (wms_idx 기준 - meta 전용)
' =========================
Dim dictRecvTel
Set dictRecvTel = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT wms_idx, pay_type "
SQL = SQL & "FROM tk_wms_delivery_info "
SQL = SQL & "WHERE is_active = 1 "

RsDiC.Open SQL, DbCon, 1, 1
Do Until RsDiC.EOF
  Dim dkey
  dkey = Nz(RsDiC("wms_idx"))  ' ✅ CStr 제거 (Null-safe)

  If dkey <> "" Then
    dictRecvTel(dkey) = RsDiC("pay_type")
  End If

  RsDiC.MoveNext
Loop
RsDiC.Close

' =========================
' MANUAL 캐시 (manual_idx 기준)
' =========================
Dim dictManual
Set dictManual = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & " manual_idx, ymd, wms_type, customer_name, recv_name, recv_tel, dest_text, item_name, paint_no "
SQL = SQL & "FROM tk_wms_dashboard_manual WITH (NOLOCK) "
SQL = SQL & "WHERE is_active = 1 "
SQL = SQL & "  AND ymd = '" & SqlEsc(ymd) & "' "
SQL = SQL & "  AND wms_type IN (1,17,18,19) "

RsMan.Open SQL, DbCon, 1, 1
Do Until RsMan.EOF
  Dim mkey, mitem
  mkey = Nz(RsMan("manual_idx")) ' ✅ CStr 제거 (Null-safe)

  If mkey <> "" Then
    Set mitem = Server.CreateObject("Scripting.Dictionary")
    mitem("recv_name")      = Nz(RsMan("recv_name"))
    mitem("recv_tel")       = Nz(RsMan("recv_tel"))
    mitem("dest_text")      = Nz(RsMan("dest_text"))
    mitem("customer_name")  = Nz(RsMan("customer_name"))
    mitem("item_name")      = Nz(RsMan("item_name"))
    mitem("paint_no")       = Nz(RsMan("paint_no"))
    mitem("wms_type")       = Nz(RsMan("wms_type"))

    If dictManual.Exists(mkey) Then
        dictManual.Remove mkey
    End If
    dictManual.Add mkey, mitem
  End If


  RsMan.MoveNext
Loop
RsMan.Close

' =====================================================
' CARGO 집계 (meta + manual)
'  - 둘 다 NULL인 쓰레기 데이터 방지 조건 추가
' =====================================================
SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN 'manual' ELSE 'meta' END AS kind, "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN manual_idx ELSE wms_idx END AS grp_id, "
SQL = SQL & "  wms_idx, manual_idx, "
SQL = SQL & "  COUNT(*) AS box_cnt, "
SQL = SQL & "  SUM(cargo_price) AS total_price, "
SQL = SQL & "  MAX(recv_name) AS recv_name, "
SQL = SQL & "  MAX(cargo_memo) AS cargo_memo "
SQL = SQL & "FROM tk_wms_cargo "
SQL = SQL & "WHERE status = 1 "
SQL = SQL & "  AND created_dt = '" & SqlEsc(ymd) & "' "
SQL = SQL & "  AND (wms_idx IS NOT NULL OR manual_idx IS NOT NULL) "  ' ✅ 추가
SQL = SQL & "GROUP BY "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN 'manual' ELSE 'meta' END, "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN manual_idx ELSE wms_idx END, "
SQL = SQL & "  wms_idx, manual_idx "
SQL = SQL & "ORDER BY kind ASC, grp_id DESC "

Rs.Open SQL, DbCon, 1, 1
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>대신화물 수탁증</title>
<style>
body { font-family:"Malgun Gothic", Arial; font-size:13px; background:#fff; }
.wrap { width:900px; margin:0 auto; }
.tbl { width:100%; border-collapse:collapse; }
.tbl th, .tbl td { border:1px solid #000; padding:6px; text-align:center; }
.tbl th { background:#f7f7f7; font-weight:700; }
@media print { body{margin:0;} }
</style>
</head>

<body>
<div class="wrap">

<script>
  var excelRows = [
    ["보내는업체","받는업체","받는업체 연락처","품명","포장","수량","지불방법","운임비","주소"]
  ];
</script>

<%
If Rs.EOF Then
%>
  <div style="text-align:center; margin-top:40px;">조회된 수탁증 데이터가 없습니다.</div>
<%
Else
  Do Until Rs.EOF

    Dim kind, grp_id, curWmsIdx, curManualIdx
    Dim recv_tel, pay_text, recv_addr, cargo_memo, recv_name

    kind = Nz(Rs("kind"))
    grp_id = Nz(Rs("grp_id"))          ' ✅ grp_id도 Nz로 (Null-safe)
    curWmsIdx = Nz(Rs("wms_idx"))      ' ✅ Null-safe
    curManualIdx = SafeLong(Rs("manual_idx"))

    recv_name = Nz(Rs("recv_name"))
    recv_tel = ""
    recv_addr = ""
    pay_text = "현화"

    If kind = "manual" Then
      If grp_id <> "" And dictManual.Exists(grp_id) Then
        recv_tel  = Nz(dictManual(grp_id)("recv_tel"))
        recv_addr = Nz(dictManual(grp_id)("dest_text"))
        If recv_name = "" Then recv_name = Nz(dictManual(grp_id)("recv_name"))
      End If

      If Nz(Rs("cargo_memo")) = "" Then
        If grp_id <> "" And dictManual.Exists(grp_id) Then
          cargo_memo = Nz(dictManual(grp_id)("item_name"))
          If cargo_memo = "" Then cargo_memo = "프레임"
        Else
          cargo_memo = "프레임"
        End If
      Else
        cargo_memo = Nz(Rs("cargo_memo"))
      End If

    Else
      If curWmsIdx <> "" And dictWms.Exists(curWmsIdx) Then
        recv_addr = Nz(dictWms(curWmsIdx)("recv_addr"))
        recv_tel  = Nz(dictWms(curWmsIdx)("recv_tel"))
      End If

      If curWmsIdx <> "" And dictRecvTel.Exists(curWmsIdx) And IsNumeric(dictRecvTel(curWmsIdx)) Then
        If CLng(dictRecvTel(curWmsIdx)) = 0 Then
          pay_text = "현화"
        ElseIf CLng(dictRecvTel(curWmsIdx)) = 1 Then
          pay_text = "착불"
        Else
          pay_text = "현화"
        End If
      End If

      If Nz(Rs("cargo_memo")) = "" Then
        cargo_memo = "프레임"
      Else
        cargo_memo = Nz(Rs("cargo_memo"))
      End If
    End If
%>

<table class="tbl" style="margin-bottom:15px;">
<tr>
  <th>보내는 업체</th>
  <th style="width:200px">받는업체</th>
  <th>받는업체 연락처</th>
  <th>품 명</th>
  <th>포 장</th>
  <th>수 량</th>
  <th>지불방법</th>
  <th>운 임 비</th>
</tr>
<tr>
  <td>태광도어</td>
  <td><%=recv_name%></td>
  <td><%=recv_tel%></td>
  <td>
    <input type="text"
           name="cargo_memo"
           value="<%=Replace(cargo_memo, """", "&quot;")%>"
           data-kind="<%=kind%>"
           data-wms-idx="<%=curWmsIdx%>"
           data-manual-idx="<%=curManualIdx%>"
           onkeydown="if(event.key === 'Enter'){ saveCargoMemo(this); return false; }"
           style="width:95%; text-align:center;">
  </td>
  <td>B</td>
  <td><%=Rs("box_cnt")%></td>
  <td><%=pay_text%></td>
  <td><%=FormatNumber(Rs("total_price"),0)%></td>
</tr>
</table>

<table class="tbl" style="margin-bottom:30px;">
<tr>
  <th style="width:150px;">받는분 주소</th>
  <td style="text-align:center; font-weight:700;"><%=recv_addr%></td>
</tr>
</table>

<script>
  excelRows.push([
    "태광도어",
    "<%=JsEsc(recv_name)%>",
    "<%=JsEsc(recv_tel)%>",
    "<%=JsEsc(cargo_memo)%>",
    "B",
    "<%=JsEsc(Rs("box_cnt"))%>",
    "<%=JsEsc(pay_text)%>",
    "<%=JsEsc(FormatNumber(Rs("total_price"),0))%>",
    "<%=JsEsc(recv_addr)%>"
  ]);
</script>

<%
    Rs.MoveNext
  Loop
End If
%>

<div style="text-align:right; margin:10px 0;">
  <a  onclick="downloadExcel(); return false;"
     style="padding:6px 12px; border:1px solid #333; background:#f2f2f2; text-decoration:none; font-weight:700;">
    엑셀 다운로드
  </a>
</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/xlsx@0.18.5/dist/xlsx.full.min.js"></script>
<script>
function saveCargoMemo(el) {
  const memo = (el.value || "").trim();
  const kind = el.getAttribute("data-kind") || "meta";
  const wmsIdx = el.getAttribute("data-wms-idx") || "";
  const manualIdx = el.getAttribute("data-manual-idx") || "";

  const xhr = new XMLHttpRequest();
  xhr.open("POST", "TNG_WMS_Cargo_Memo_Update.asp", true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4) {
      if (xhr.status === 200 && xhr.responseText.trim() === "OK") {
        el.style.backgroundColor = "#e7f9ef";
        setTimeout(() => { el.style.backgroundColor = ""; }, 800);
      } else {
        alert("저장 실패: " + xhr.responseText);
      }
    }
  };

  let body = "kind=" + encodeURIComponent(kind)
           + "&cargo_memo=" + encodeURIComponent(memo);

  if (kind === "manual") {
    if (!manualIdx) { alert("manual_idx 없음"); return; }
    body += "&manual_idx=" + encodeURIComponent(manualIdx);
  } else {
    if (!wmsIdx) { alert("wms_idx 없음"); return; }
    body += "&wms_idx=" + encodeURIComponent(wmsIdx);
  }

  xhr.send(body);
}

function downloadExcel() {
  if (!window.XLSX) {
    alert("XLSX library not loaded.");
    return;
  }
  if (!window.excelRows || window.excelRows.length <= 1) {
    alert("No data to export.");
    return;
  }
  var ymdVal = "<%=JsEsc(ymd)%>";
  var fname = "화물 수탁증_" + (ymdVal || "data") + ".xlsx";

  var ws = XLSX.utils.aoa_to_sheet(window.excelRows);
  ws["!cols"] = [
    {wch:12},  // A
    {wch:28},  // B
    {wch:18},  // C
    {wch:14},  // D
    {wch:8},   // E
    {wch:6},   // F
    {wch:10},  // G
    {wch:10},  // H
    {wch:30}   // I
  ];
  var wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, "WMS");
  XLSX.writeFile(wb, fname);
}
</script>

</body>
<%
Rs.Close
Set Rs = Nothing
Call dbClose()
%>
</html>
