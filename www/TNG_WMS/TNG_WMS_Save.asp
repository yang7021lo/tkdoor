<%@codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Rs.CursorLocation = 3

sjidx = Trim(Request("sjidx"))

If sjidx="" Then
    Response.Write "<h2 style='color:red'>❌ sjidx 없음</h2>"
    Response.End
End If
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>WMS SAVE ENGINE</title>
<style>
body { background:#111; color:#0f0; font-family:Consolas; font-size:14px; padding:20px }
h2 { color:#0f0 }
pre { background:#000; color:#0f0; padding:10px; border-radius:6px; }
.ok { color:#4cff00; font-weight:bold }
.err { color:red; font-weight:bold }
</style>
</head>
<body>

<h2>🚚 WMS SAVE ENGINE — sjidx=<%=sjidx%></h2>

<%
' ==========================================================
' ① 수주 헤더 정보 불러오기
' ==========================================================
SQL = "SELECT TOP 1 sjcidx, cgtype, cgaddr FROM tng_sja WHERE sjidx='"&sjidx&"'"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    rsjcidx = Trim(Rs("sjcidx"))
    cgtype  = Trim(Rs("cgtype"))
    cgaddr  = Trim(Rs("cgaddr"))
End If
Rs.Close

If rsjcidx="" Then
    Response.Write "<div class='err'>❌ tng_sja 조회 실패</div>"
    Response.End
End If


' ==========================================================
' ② tk_daesin 최신 정보(택배/용차) 
' ==========================================================
SQL = "SELECT TOP 1 * FROM tk_daesin WHERE sjidx='"&sjidx&"' AND dsstatus='1' ORDER BY dsidx DESC"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    last_dsidx   = Rs("dsidx")
    dsdate       = Rs("dsdate")
    ds_to_name   = Rs("ds_to_name")
    ds_to_tel    = Rs("ds_to_tel")
    ds_to_addr   = Rs("ds_to_addr")
    ds_to_addr1  = Rs("ds_to_addr1")
    ds_to_costyn = Rs("ds_to_costyn")
    clean_prepay = Rs("ds_to_prepay")
End If
Rs.Close

If dsdate="" Then
    dsdate = Replace(Date(),"-","/")
End If

If Not IsNumeric(clean_prepay) Then clean_prepay = 0
If clean_prepay>0 Then prepay_flag="1" Else prepay_flag="0"

Response.Write "<pre>dsidx="&last_dsidx&"  도착일="&dsdate&"</pre>"


' ==========================================================
' ③ RULE ENGINE 함수 
' ==========================================================
Function GetRuleValue(rule_group, cgtype, wms_type)
    SQLr = "SELECT condition_sql, result_value FROM tk_rule_core WHERE company_id='1' AND rule_group='"&rule_group&"' AND active='1' ORDER BY priority ASC"
    Set Rr = Server.CreateObject("ADODB.Recordset")
    Rr.Open SQLr, Dbcon

    Do While Not Rr.EOF
        cond = Rr("condition_sql")
        cond = Replace(cond, "cgtype", cgtype)
        cond = Replace(cond, "wms_type", wms_type)

        If Eval(cond)=True Then
            GetRuleValue = Trim(Rr("result_value"))
            Rr.Close: Set Rr=Nothing
            Exit Function
        End If
        Rr.MoveNext
    Loop

    Rr.Close: Set Rr=Nothing
    GetRuleValue = ""
End Function


' ==========================================================
' ④ WMS_TYPE / SENDER / WAREHOUSE / CARRIER RULE APPLY
' ==========================================================
wms_type = GetRuleValue("WMS_TYPE", cgtype, 0)
If wms_type="" Then wms_type="1"

sender_code = GetRuleValue("SENDER_RULE", cgtype, wms_type)
If sender_code="" Then sender_code="CARGO_DAESIN"

SQL="SELECT TOP 1 * FROM tk_wms_sender WHERE sender_code='"&sender_code&"'"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    sender_name  = Rs("sender_name")
    sender_tel   = Rs("sender_tel")
    sender_addr  = Rs("sender_addr")
    sender_addr1 = Rs("sender_addr1")
End If
Rs.Close

warehouse_idx = GetRuleValue("WAREHOUSE_RULE", cgtype, wms_type)
If warehouse_idx="" Then warehouse_idx="NULL"

carrier_id = GetRuleValue("CARRIER_RULE", cgtype, wms_type)
If carrier_id="dsidx" Then carrier_id = last_dsidx
If carrier_id="" Then carrier_id="NULL"


Response.Write "<pre>"
Response.Write "wms_type="&wms_type&vbCrLf
Response.Write "sender_code="&sender_code&vbCrLf
Response.Write "warehouse_idx="&warehouse_idx&vbCrLf
Response.Write "carrier_id="&carrier_id&vbCrLf
Response.Write "</pre>"


' ==========================================================
' ⑤ META INSERT 
' ==========================================================
SQL = ""
SQL = SQL & "INSERT INTO tk_wms_meta ( "
SQL = SQL & " company_id, wms_no, cidx, sjidx, sjsidx, wms_type, carrier_id, "
SQL = SQL & " driver_id, warehouse_idx, planned_ship_dt, actual_ship_dt, "
SQL = SQL & " sender_name, sender_tel, sender_addr, sender_addr1, "
SQL = SQL & " recv_name, recv_tel, recv_addr, recv_addr1, "
SQL = SQL & " cost_yn, prepay_yn, total_quan, total_weight, status, "
SQL = SQL & " reg_user, reg_date, upd_user, upd_date, memo "
SQL = SQL & ") VALUES ( "
SQL = SQL & " '1', NULL, '"&rsjcidx&"', '"&sjidx&"', NULL, "
SQL = SQL & " '"&wms_type&"', "&carrier_id&", "
SQL = SQL & " NULL, "&warehouse_idx&", "
SQL = SQL & " '"&dsdate&"', '"&dsdate&"', "
SQL = SQL & " '"&sender_name&"', '"&sender_tel&"', '"&sender_addr&"', '"&sender_addr1&"', "
SQL = SQL & " '"&ds_to_name&"', '"&ds_to_tel&"', '"&ds_to_addr&"', '"&ds_to_addr1&"', "
SQL = SQL & " '"&ds_to_costyn&"', '"&prepay_flag&"', '0', NULL, '0', "
SQL = SQL & " '"&C_midx&"', GETDATE(), '"&C_midx&"', GETDATE(), NULL "
SQL = SQL & ")"

Dbcon.Execute SQL
Response.Write "<div class='ok'>✔ META 생성 완료</div>"


' ==========================================================
' ⑥ 생성된 wms_idx 조회
' ==========================================================
SQL = "SELECT TOP 1 wms_idx FROM tk_wms_meta WHERE sjidx='"&sjidx&"' ORDER BY wms_idx DESC"
Rs.Open SQL, Dbcon
new_wms_idx = 0
If Not (Rs.BOF Or Rs.EOF) Then
    new_wms_idx = Rs("wms_idx")
End If
Rs.Close

If new_wms_idx=0 Then
    Response.Write "<div class='err'>❌ wms_idx 조회 실패</div>"
    Response.End
End If

Response.Write "<pre>new_wms_idx = "&new_wms_idx&"</pre>"


' ==========================================================
' ⑦ DETAIL INSERT
' ==========================================================
SQL = ""
SQL = SQL & "INSERT INTO tk_wms_detail ( "
SQL = SQL & " company_id, wms_idx, sjidx, sjsidx, fkidx, fksidx, bfidx, "
SQL = SQL & " baname, blength, unit, quan, weight, warehouse_idx, "
SQL = SQL & " stock_loc_idx, lot_idx, serial_no, status, memo, xsize, ysize "
SQL = SQL & ") "
SQL = SQL & "SELECT "
SQL = SQL & " '1', '"&new_wms_idx&"', A.sjidx, A.sjsidx, "
SQL = SQL & " B.fkidx, B.fksidx, B.bfidx, "
SQL = SQL & " CASE WHEN B.WHICHI_AUTO<>0 THEN C.set_name_AUTO "
SQL = SQL & "      WHEN B.WHICHI_FIX<>0  THEN C.set_name_FIX END, "
SQL = SQL & " B.blength, 'mm', '1', NULL, NULL, NULL, NULL, NULL, '1', "
SQL = SQL & " (ISNULL(C.bfimg1,'') + '|' + ISNULL(C.bfimg2,'') + '|' + ISNULL(C.bfimg3,'') + '|' + ISNULL(C.bfimg4,'')), "
SQL = SQL & " B.xsize, B.ysize "
SQL = SQL & "FROM tk_framek A "
SQL = SQL & "JOIN tk_framekSub B ON A.fkidx=B.fkidx "
SQL = SQL & "LEFT JOIN tk_barasiF C ON B.bfidx=C.bfidx "
SQL = SQL & "WHERE A.sjidx='"&sjidx&"' "
SQL = SQL & "AND B.gls='0' "
SQL = SQL & "AND B.bfidx<>'0' "
SQL = SQL & "AND (B.WHICHI_FIX<>0 OR B.WHICHI_AUTO<>0)"

Dbcon.Execute(SQL)

Response.Write "<div class='ok'>✔ DETAIL 생성 완료</div>"


' ==========================================================
' ⑧ META 총수량 갱신
' ==========================================================
SQL = ""
SQL = SQL & "UPDATE tk_wms_meta "
SQL = SQL & "SET total_quan = (SELECT COUNT(*) FROM tk_wms_detail WHERE wms_idx='"&new_wms_idx&"'), "
SQL = SQL & "    upd_user='"&C_midx&"', upd_date=GETDATE() "
SQL = SQL & "WHERE wms_idx='"&new_wms_idx&"'"

Dbcon.Execute(SQL)

Response.Write "<div class='ok'>✔ META 집계 갱신 완료</div>"


' ==========================================================
' ⑨ WMS_NO 자동 생성
' ==========================================================
SQL = ""
SQL = SQL & "UPDATE tk_wms_meta "
SQL = SQL & "SET wms_no = 'WMS-' + CONVERT(char(8),GETDATE(),112) + '-' + RIGHT('000'+CAST(wms_idx AS varchar(3)),3) "
SQL = SQL & "WHERE wms_idx='"&new_wms_idx&"'"

Dbcon.Execute SQL

Response.Write "<div class='ok'>✔ wms_no 생성 완료</div>"


' ==========================================================
' DONE
' ==========================================================
Response.Write "<h2 class='ok'>🎉 WMS 생성 모두 완료!</h2>"
Response.Write "<div style='margin-top:20px'>"
Response.Write "<a href='/TNG_WMS/TNG_WMS_Debug.asp?sjidx="&sjidx&"' target='_blank' style='color:#4cff00'>🔍 DEBUG 다시보기</a><br>"
Response.Write "<a href='/TNG1_B.asp?sjidx="&sjidx&"&sjcidx="&rsjcidx&"' style='color:#4cff00'>🔙 수주로 돌아가기</a>"
Response.Write "</div>"

call dbClose()
%>

</body>
</html>
