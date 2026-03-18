<%@codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet  = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Rs.CursorLocation = 3

sjidx = Trim(Request("sjidx"))
If sjidx = "" Then
  Response.Write "<h2 style='color:red;font-weight:bold'>❌ sjidx 필요</h2>"
  Response.End
End If
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>WMS DEBUG (sjidx=<%=sjidx%>)</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { font-family:'맑은 고딕'; font-size:14px; background:#000; color:#0f0; }
pre  { background:#000; color:#0f0; padding:12px; border-radius:5px; border:1px solid #0f0; }
h3   { color:#0f0; }
h4   { color:#ff0; margin-top:25px; }
.table td, .table th { color:#fff; background:#111; border-color:#333; }
.sql-title { color:#0ff; font-weight:bold; }
.err { color:red; font-weight:bold; }
</style>
</head>
<body class="p-3">

<h3>📦 WMS DEBUG MODE — sjidx=<%=sjidx%></h3>


<!-- =========================================================
  1) 수주 헤더 (tng_sja)
============================================================ -->
<h4>① 수주 헤더 (tng_sja)</h4>
<%
SQL = "SELECT * FROM tng_sja WHERE sjidx='" & sjidx & "'"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
%>
<table class="table table-bordered table-sm">
<tr>
  <th>sjidx</th><th>sjnum</th><th>cgdate</th><th>cgtype</th><th>cgaddr</th>
</tr>
<tr>
  <td><%=Rs("sjidx")%></td>
  <td><%=Rs("sjnum")%></td>
  <td><%=Rs("cgdate")%></td>
  <td><%=Rs("cgtype")%></td>
  <td><%=Rs("cgaddr")%></td>
</tr>
</table>
<%
cgtype = Trim(Rs("cgtype"))
cgaddr = Trim(Rs("cgaddr"))
End If
Rs.Close
%>


<!-- =========================================================
  2) tk_daesin 현재 데이터
============================================================ -->
<h4>② 기존 화물/용차 데이터 (tk_daesin)</h4>
<%
SQL = "SELECT TOP 1 * FROM tk_daesin WHERE sjidx='" & sjidx & "' AND dsstatus=1 ORDER BY dsidx DESC"
Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
%>
<table class="table table-bordered table-sm">
<tr><th>dsidx</th><th>받는이</th><th>주소</th><th>도착일</th></tr>
<tr>
<td><%=Rs("dsidx")%></td>
<td><%=Rs("ds_to_name")%></td>
<td><%=Rs("ds_to_addr")%></td>
<td><%=Rs("dsdate")%></td>
</tr>
</table>
<%
last_dsidx   = Rs("dsidx")
dsdate       = Rs("dsdate")
ds_to_name   = Rs("ds_to_name")
ds_to_tel    = Rs("ds_to_tel")
ds_to_addr   = Rs("ds_to_addr")
ds_to_addr1  = Rs("ds_to_addr1")
ds_to_cost   = Rs("ds_to_costyn")
clean_prepay = Rs("ds_to_prepay")
Else
last_dsidx   = "NULL"
dsdate       = ""
ds_to_name   = ""
ds_to_tel    = ""
ds_to_addr   = ""
ds_to_addr1  = ""
ds_to_cost   = "0"
clean_prepay = 0
End If
Rs.Close
%>


<!-- =========================================================
  3) 룰 시스템 - Eval 금지 / 직접 조건 처리
============================================================ -->
<%
Function GetRuleValue(rule_group, cgtype, wms_type)
    SQLr = "SELECT condition_sql, result_value FROM tk_rule_core " _
         & "WHERE company_id='1' AND rule_group='" & rule_group & "' AND active='1' " _
         & "ORDER BY priority ASC"

    Set Rr = Server.CreateObject("ADODB.Recordset")
    Rr.Open SQLr, Dbcon

    Do While Not Rr.EOF
        cond_sql = Trim(Rr("condition_sql"))

        result = False

        If cond_sql = "cgtype='택배'"     And cgtype="택배" Then result=True
        If cond_sql = "cgtype='용차'"     And cgtype="용차" Then result=True
        If cond_sql = "cgtype='직접수령'" And cgtype="직접수령" Then result=True
        If cond_sql = "wms_type=1"        And wms_type=1     Then result=True
        If cond_sql = "wms_type=2"        And wms_type=2     Then result=True
        If cond_sql = "always"            Then result=True

        If result = True Then
            GetRuleValue = Rr("result_value")
            Rr.Close : Set Rr = Nothing
            Exit Function
        End If

        Rr.MoveNext
    Loop

    Rr.Close : Set Rr = Nothing
    GetRuleValue = ""
End Function


' ------------- wms_type 결정 -------------
wms_type = GetRuleValue("WMS_TYPE", cgtype, 0)
If wms_type = "" Then wms_type = 1


' ------------- sender 결정 -------------
sender_code = GetRuleValue("SENDER_RULE", cgtype, wms_type)
If sender_code = "" Then sender_code = "CARGO_DAESIN"

sender_name="" : sender_tel="" : sender_addr="" : sender_addr1=""

SQL = "SELECT TOP 1 * FROM tk_wms_sender WHERE sender_code='" & sender_code & "'"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
  sender_name  = Rs("sender_name")
  sender_tel   = Rs("sender_tel")
  sender_addr  = Rs("sender_addr")
  sender_addr1 = Rs("sender_addr1")
End If
Rs.Close


' ------------- 창고 -------------
warehouse_idx = GetRuleValue("WAREHOUSE_RULE", cgtype, wms_type)
If warehouse_idx = "" Then warehouse_idx = "NULL"

' ------------- carrier (대신화물지점 or 용차) -------------
carrier_id = GetRuleValue("CARRIER_RULE", cgtype, wms_type)
If carrier_id = "dsidx" Then carrier_id = last_dsidx
If carrier_id = "" Then carrier_id = "NULL"
%>


<h4>③ RULE 적용 결과</h4>
<pre>
wms_type      = <%=wms_type%>
sender_code   = <%=sender_code%>
warehouse_idx = <%=warehouse_idx%>
carrier_id    = <%=carrier_id%>
</pre>
<!-- =========================================================
  4) tk_wms_meta INSERT SQL (콘솔 스타일)
============================================================ -->
<h4>④ tk_wms_meta INSERT SQL (Preview)</h4>

<%
' prepay 플래그 (IIf 금지)
If IsNumeric(clean_prepay) Then
    If CLng(clean_prepay) > 0 Then
        prepay_yn = "1"
    Else
        prepay_yn = "0"
    End If
Else
    prepay_yn = "0"
End If

company_id = "1"

metaSQL = ""
metaSQL = metaSQL & "INSERT INTO tk_wms_meta (" & vbCrLf
metaSQL = metaSQL & "  company_id, wms_no, cidx, sjidx, sjsidx, wms_type," & vbCrLf
metaSQL = metaSQL & "  carrier_id, driver_id, warehouse_idx, planned_ship_dt, actual_ship_dt," & vbCrLf
metaSQL = metaSQL & "  sender_name, sender_tel, sender_addr, sender_addr1," & vbCrLf
metaSQL = metaSQL & "  recv_name, recv_tel, recv_addr, recv_addr1," & vbCrLf
metaSQL = metaSQL & "  cost_yn, prepay_yn, total_quan, total_weight, status," & vbCrLf
metaSQL = metaSQL & "  reg_user, reg_date, upd_user, upd_date, memo" & vbCrLf
metaSQL = metaSQL & ") VALUES (" & vbCrLf
metaSQL = metaSQL & "  '" & company_id & "'," & vbCrLf
metaSQL = metaSQL & "  NULL," & vbCrLf
metaSQL = metaSQL & "  '" & rsjcidx & "'," & vbCrLf
metaSQL = metaSQL & "  '" & sjidx & "'," & vbCrLf
metaSQL = metaSQL & "  NULL," & vbCrLf
metaSQL = metaSQL & "  '" & wms_type & "'," & vbCrLf
metaSQL = metaSQL & "  " & carrier_id & "," & vbCrLf
metaSQL = metaSQL & "  NULL," & vbCrLf
metaSQL = metaSQL & "  " & warehouse_idx & "," & vbCrLf
metaSQL = metaSQL & "  '" & dsdate & "'," & vbCrLf
metaSQL = metaSQL & "  '" & dsdate & "'," & vbCrLf
metaSQL = metaSQL & "  '" & sender_name & "'," & vbCrLf
metaSQL = metaSQL & "  '" & sender_tel & "'," & vbCrLf
metaSQL = metaSQL & "  '" & sender_addr & "'," & vbCrLf
metaSQL = metaSQL & "  '" & sender_addr1 & "'," & vbCrLf
metaSQL = metaSQL & "  '" & ds_to_name & "'," & vbCrLf
metaSQL = metaSQL & "  '" & ds_to_tel & "'," & vbCrLf
metaSQL = metaSQL & "  '" & ds_to_addr & "'," & vbCrLf
metaSQL = metaSQL & "  '" & ds_to_addr1 & "'," & vbCrLf
metaSQL = metaSQL & "  '" & ds_to_cost & "'," & vbCrLf
metaSQL = metaSQL & "  '" & prepay_yn & "'," & vbCrLf
metaSQL = metaSQL & "  0," & vbCrLf
metaSQL = metaSQL & "  NULL," & vbCrLf
metaSQL = metaSQL & "  0," & vbCrLf
metaSQL = metaSQL & "  '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE(), NULL" & vbCrLf
metaSQL = metaSQL & ");"
%>

<pre><%=metaSQL%></pre>



<!-- =========================================================
  5) tk_wms_detail INSERT SQL (네온 콘솔)
============================================================ -->
<h4>⑤ tk_wms_detail INSERT SQL (Preview)</h4>

<%
detailSQL = ""
detailSQL = detailSQL & "INSERT INTO tk_wms_detail (" & vbCrLf
detailSQL = detailSQL & "  company_id, wms_idx, sjidx, sjsidx, fkidx, fksidx, bfidx," & vbCrLf
detailSQL = detailSQL & "  baname, blength, unit, quan, weight, warehouse_idx," & vbCrLf
detailSQL = detailSQL & "  stock_loc_idx, lot_idx, serial_no, status, bfimg, xsize, ysize" & vbCrLf
detailSQL = detailSQL & ")" & vbCrLf
detailSQL = detailSQL & "SELECT" & vbCrLf
detailSQL = detailSQL & "  1 AS company_id," & vbCrLf
detailSQL = detailSQL & "  (NEW_WMS_IDX) AS wms_idx," & vbCrLf
detailSQL = detailSQL & "  A.sjidx," & vbCrLf
detailSQL = detailSQL & "  A.sjsidx," & vbCrLf
detailSQL = detailSQL & "  B.fkidx," & vbCrLf
detailSQL = detailSQL & "  B.fksidx," & vbCrLf
detailSQL = detailSQL & "  B.bfidx," & vbCrLf
detailSQL = detailSQL & "  CASE" & vbCrLf
detailSQL = detailSQL & "    WHEN B.WHICHI_AUTO <> 0 THEN C.set_name_AUTO" & vbCrLf
detailSQL = detailSQL & "    WHEN B.WHICHI_FIX  <> 0 THEN C.set_name_FIX" & vbCrLf
detailSQL = detailSQL & "    ELSE C.set_name_FIX" & vbCrLf
detailSQL = detailSQL & "  END AS baname," & vbCrLf
detailSQL = detailSQL & "  B.blength," & vbCrLf
detailSQL = detailSQL & "  'mm' AS unit," & vbCrLf
detailSQL = detailSQL & "  1 AS quan," & vbCrLf
detailSQL = detailSQL & "  NULL AS weight," & vbCrLf
detailSQL = detailSQL & "  NULL AS warehouse_idx," & vbCrLf
detailSQL = detailSQL & "  NULL AS stock_loc_idx," & vbCrLf
detailSQL = detailSQL & "  NULL AS lot_idx," & vbCrLf
detailSQL = detailSQL & "  NULL AS serial_no," & vbCrLf
detailSQL = detailSQL & "  1 AS status," & vbCrLf
detailSQL = detailSQL & "  (C.bfimg1 + '|' + C.bfimg2 + '|' + C.bfimg3 + '|' + C.bfimg4) AS bfimg," & vbCrLf
detailSQL = detailSQL & "  B.xsize," & vbCrLf
detailSQL = detailSQL & "  B.ysize" & vbCrLf
detailSQL = detailSQL & "FROM tk_framek A" & vbCrLf
detailSQL = detailSQL & "JOIN tk_framekSub B ON A.fkidx = B.fkidx" & vbCrLf
detailSQL = detailSQL & "LEFT JOIN tk_barasiF C ON B.bfidx = C.bfidx" & vbCrLf
detailSQL = detailSQL & "WHERE A.sjidx = '" & sjidx & "'" & vbCrLf
detailSQL = detailSQL & "  AND B.gls = '0'" & vbCrLf
detailSQL = detailSQL & "  AND B.bfidx <> '0'" & vbCrLf
detailSQL = detailSQL & "  AND (B.WHICHI_FIX <> 0 OR B.WHICHI_AUTO <> 0)" & vbCrLf
detailSQL = detailSQL & ";"
%>

<pre><%=detailSQL%></pre>

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Rs.CursorLocation = 3

sjidx = Trim(Request("sjidx"))
If sjidx = "" Then
    Response.Write "<h3 style='color:red'>❌ sjidx 없음 — 실행 불가</h3>"
    Response.End
End If

Response.Write "<h2>🚚 WMS 생성 실행 (sjidx=" & sjidx & ")</h2>"
Response.Write "<pre style='background:#000;color:#0f0;padding:10px;border-radius:4px;'>"

'=============================================================
' 1) 기존 WMS 존재 여부 검사
'=============================================================
SQL = "SELECT TOP 1 wms_idx FROM tk_wms_meta WHERE sjidx='" & sjidx & "' ORDER BY wms_idx DESC"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    oldIdx = Rs("wms_idx")
    Rs.Close
    Response.Write "⚠ 기존 WMS 존재: wms_idx=" & oldIdx & vbCrLf
    Response.Write "→ 새로운 WMS 생성은 가능하지만 중복 주의!" & vbCrLf & "</pre>"
Else
    Rs.Close
End If


'=============================================================
' 2) tng_sja + tk_daesin 기본정보 로드
'=============================================================
SQL = "SELECT sjcidx, cgtype, cgaddr FROM tng_sja WHERE sjidx='" & sjidx & "'"
Rs.Open SQL, Dbcon
If Not(Rs.BOF Or Rs.EOF) Then
    rsjcidx = Rs("sjcidx")
    cgtype  = Trim(Rs("cgtype"))
    cgaddr  = Trim(Rs("cgaddr"))
End If
Rs.Close


SQL = "SELECT TOP 1 * FROM tk_daesin WHERE sjidx='" & sjidx & "' AND dsstatus=1 ORDER BY dsidx DESC"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    dsidx        = Rs("dsidx")
    dsdate       = Rs("dsdate")
    ds_to_name   = Rs("ds_to_name")
    ds_to_tel    = Rs("ds_to_tel")
    ds_to_addr   = Rs("ds_to_addr")
    ds_to_addr1  = Rs("ds_to_addr1")
    ds_to_cost   = Rs("ds_to_costyn")
    clean_prepay = Rs("ds_to_prepay")
Else
    ' 기본값 세팅
    dsidx = "NULL"
    dsdate = ""
    ds_to_name = ""
    ds_to_tel = ""
    ds_to_addr = ""
    ds_to_addr1 = ""
    ds_to_cost = "0"
    clean_prepay = "0"
End If
Rs.Close

If Not IsNumeric(clean_prepay) Then clean_prepay = 0
If CLng(clean_prepay) > 0 Then prepay_yn = "1" Else prepay_yn = "0"


'=============================================================
' 3) 룰 엔진 불러오기
'=============================================================
Function GetRuleValue(rule_group, cgtype, wms_type)
    SQLr = "SELECT condition_sql, result_value FROM tk_rule_core WHERE rule_group='" & rule_group & "' AND active='1' ORDER BY priority ASC"
    Set Rr = Server.CreateObject("ADODB.Recordset")
    Rr.Open SQLr, Dbcon

    Do While Not Rr.EOF
        cond = Rr("condition_sql")
        cond = Replace(cond, "cgtype", "'" & cgtype & "'")
        cond = Replace(cond, "wms_type", "'" & wms_type & "'")

        If Eval(cond) = True Then
            GetRuleValue = Rr("result_value")
            Rr.Close: Set Rr = Nothing
            Exit Function
        End If
        Rr.MoveNext
    Loop

    Rr.Close: Set Rr = Nothing
    GetRuleValue = ""
End Function


'=============================================================
' 4) 룰 적용 – WMS_TYPE / SENDER / WAREHOUSE / CARRIER
'=============================================================
wms_type = GetRuleValue("WMS_TYPE", cgtype, 0)
If wms_type = "" Then wms_type = 1

sender_code = GetRuleValue("SENDER_RULE", cgtype, wms_type)
If sender_code = "" Then sender_code = "CARGO_DAESIN"

sender_name="" : sender_tel="" : sender_addr="" : sender_addr1=""

SQL = "SELECT TOP 1 * FROM tk_wms_sender WHERE sender_code='" & sender_code & "'"
Rs.Open SQL, Dbcon
If Not(Rs.BOF Or Rs.EOF) Then
    sender_name  = Rs("sender_name")
    sender_tel   = Rs("sender_tel")
    sender_addr  = Rs("sender_addr")
    sender_addr1 = Rs("sender_addr1")
End If
Rs.Close

warehouse_idx = GetRuleValue("WAREHOUSE_RULE", cgtype, wms_type)
If warehouse_idx = "" Then warehouse_idx = "NULL"

carrier_id = GetRuleValue("CARRIER_RULE", cgtype, wms_type)
If carrier_id = "dsidx" Then carrier_id = dsidx
If carrier_id = "" Then carrier_id = "NULL"


'=============================================================
' 5) META INSERT 실행
'=============================================================
metaSQL = ""
metaSQL = metaSQL & "INSERT INTO tk_wms_meta (" & vbCrLf
metaSQL = metaSQL & " company_id, wms_no, cidx, sjidx, sjsidx, wms_type," & vbCrLf
metaSQL = metaSQL & " carrier_id, driver_id, warehouse_idx, planned_ship_dt, actual_ship_dt," & vbCrLf
metaSQL = metaSQL & " sender_name, sender_tel, sender_addr, sender_addr1," & vbCrLf
metaSQL = metaSQL & " recv_name, recv_tel, recv_addr, recv_addr1," & vbCrLf
metaSQL = metaSQL & " cost_yn, prepay_yn, total_quan, total_weight, status," & vbCrLf
metaSQL = metaSQL & " reg_user, reg_date, upd_user, upd_date, memo" & vbCrLf
metaSQL = metaSQL & ") VALUES (" & vbCrLf
metaSQL = metaSQL & " '1', NULL, '" & rsjcidx & "', '" & sjidx & "', NULL," & vbCrLf
metaSQL = metaSQL & " '" & wms_type & "', " & carrier_id & ", NULL, " & warehouse_idx & "," & vbCrLf
metaSQL = metaSQL & " '" & dsdate & "', '" & dsdate & "'," & vbCrLf
metaSQL = metaSQL & " '" & sender_name & "', '" & sender_tel & "', '" & sender_addr & "', '" & sender_addr1 & "'," & vbCrLf
metaSQL = metaSQL & " '" & ds_to_name & "', '" & ds_to_tel & "', '" & ds_to_addr & "', '" & ds_to_addr1 & "'," & vbCrLf
metaSQL = metaSQL & " '" & ds_to_cost & "', '" & prepay_yn & "', 0, NULL, 0," & vbCrLf
metaSQL = metaSQL & " '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE(), NULL" & vbCrLf
metaSQL = metaSQL & ");"

Response.Write "META SQL 실행..." & vbCrLf
Dbcon.Execute metaSQL
Response.Write metaSQL & vbCrLf

' 방금 생성된 wms_idx
SQL = "SELECT MAX(wms_idx) AS newIdx FROM tk_wms_meta WHERE sjidx='" & sjidx & "'"
Rs.Open SQL, Dbcon
new_wms_idx = Rs("newIdx")
Rs.Close

Response.Write "👉 new_wms_idx = " & new_wms_idx & vbCrLf



'=============================================================
' 6) DETAIL INSERT 실행
'=============================================================
detailSQL = ""
detailSQL = detailSQL & "INSERT INTO tk_wms_detail (" & vbCrLf
detailSQL = detailSQL & " company_id, wms_idx, sjidx, sjsidx, fkidx, fksidx, bfidx," & vbCrLf
detailSQL = detailSQL & " baname, blength, unit, quan, weight, warehouse_idx," & vbCrLf
detailSQL = detailSQL & " stock_loc_idx, lot_idx, serial_no, status, bfimg, xsize, ysize" & vbCrLf
detailSQL = detailSQL & ")" & vbCrLf
detailSQL = detailSQL & "SELECT" & vbCrLf
detailSQL = detailSQL & "  1 AS company_id," & vbCrLf
detailSQL = detailSQL & "  " & new_wms_idx & " AS wms_idx," & vbCrLf
detailSQL = detailSQL & "  A.sjidx," & vbCrLf
detailSQL = detailSQL & "  A.sjsidx," & vbCrLf
detailSQL = detailSQL & "  B.fkidx," & vbCrLf
detailSQL = detailSQL & "  B.fksidx," & vbCrLf
detailSQL = detailSQL & "  B.bfidx," & vbCrLf
detailSQL = detailSQL & "  CASE WHEN B.WHICHI_AUTO<>0 THEN C.set_name_AUTO" & vbCrLf
detailSQL = detailSQL & "       WHEN B.WHICHI_FIX<>0 THEN C.set_name_FIX END," & vbCrLf
detailSQL = detailSQL & "  B.blength," & vbCrLf
detailSQL = detailSQL & "  'mm', 1, NULL," & vbCrLf
detailSQL = detailSQL & "  NULL, NULL, NULL, 1," & vbCrLf
detailSQL = detailSQL & "  (C.bfimg1+'|'+C.bfimg2+'|'+C.bfimg3+'|'+C.bfimg4)," & vbCrLf
detailSQL = detailSQL & "  B.xsize, B.ysize" & vbCrLf
detailSQL = detailSQL & "FROM tk_framek A" & vbCrLf
detailSQL = detailSQL & "JOIN tk_framekSub B ON A.fkidx=B.fkidx" & vbCrLf
detailSQL = detailSQL & "LEFT JOIN tk_barasiF C ON B.bfidx=C.bfidx" & vbCrLf
detailSQL = detailSQL & "WHERE A.sjidx='" & sjidx & "'" & vbCrLf
detailSQL = detailSQL & "  AND B.gls='0'" & vbCrLf
detailSQL = detailSQL & "  AND B.bfidx<>'0'" & vbCrLf
detailSQL = detailSQL & "  AND (B.WHICHI_FIX<>0 OR B.WHICHI_AUTO<>0)"
detailSQL = detailSQL & ";"

Response.Write vbCrLf & "DETAIL SQL 실행..." & vbCrLf
Dbcon.Execute detailSQL
Response.Write detailSQL & vbCrLf


Response.Write vbCrLf & "🎉 WMS 생성 완료!" & vbCrLf
Response.Write "</pre>"

call dbClose()
%>
