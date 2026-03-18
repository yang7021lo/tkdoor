<%@codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Rs.CursorLocation = 3

sjidx = Trim(Request("sjidx"))
If sjidx="" Then
  Response.Write "<div class='alert alert-danger m-3'>sjidx 없음</div>"
  Response.End
End If

table = LCase(Trim(Request("table")))
If table="" Then table="tng_sja"
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>WMS 통합조회 (sjidx=<%=sjidx%>)</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  body { font-family:'맑은 고딕'; font-size:13px; }
  .table-wrap { max-height:80vh; overflow:auto; margin-top:10px; }
  td.null-cell { color:red; font-weight:bold; }
  .nav-tabs .nav-link.active { font-weight:bold; }
</style>
</head>
<body class="p-3">

<h4>📦 WMS 통합조회 (sjidx=<%=sjidx%>)</h4>

<ul class="nav nav-tabs">
<%
tabs = Array( _
  "tng_sja","tng_sjasub","tk_framek","tk_frameksub","tk_barasif", _
  "tk_wms_meta","tk_wms_detail", _
  "tk_rule_core","tk_wms_sender" _
)

For Each t In tabs
%>
  <li class="nav-item">
    <a class="nav-link <%If table=t Then Response.Write("active")%>"
       href="?table=<%=t%>&sjidx=<%=sjidx%>"><%=UCase(t)%></a>
  </li>
<%
Next
%>
</ul>

<%
SQL=""

Select Case table

' ================================
' ① 수주헤더
' ================================
Case "tng_sja"
  SQL = ""
  SQL = SQL & "SELECT "
  SQL = SQL & "sjidx, sjnum, sjcidx, cgtype, "
  SQL = SQL & "CONVERT(varchar(10),sjdate,120) AS sjdate, "
  SQL = SQL & "CONVERT(varchar(10),cgdate,120) AS cgdate, "
  SQL = SQL & "CONVERT(varchar(10),djcgdate,120) AS djcgdate, "
  SQL = SQL & "cgaddr, suju_kyun_status "
  SQL = SQL & "FROM TNG_SJA WHERE sjidx='" & sjidx & "'"

' ================================
' ② 수주상세
' ================================
Case "tng_sjasub"
  SQL = ""
  SQL = SQL & "SELECT "
  SQL = SQL & "sjsidx, sjidx, quan, mwidth, mheight, sjb_idx, "
  SQL = SQL & "frame_price, fprice "
  SQL = SQL & "FROM tng_sjaSub WHERE sjidx='" & sjidx & "'"

' ================================
' ③ 프레임 헤더
' ================================
Case "tk_framek"
  SQL = ""
  SQL = SQL & "SELECT "
  SQL = SQL & "fkidx, sjidx, sjsidx, sjb_type_no, fidx, "
  SQL = SQL & "fknickname, ow, oh, tw, th, "
  SQL = SQL & "GREEM_O_TYPE, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, "
  SQL = SQL & "framek_price, quan, dooryn "
  SQL = SQL & "FROM tk_framek WHERE sjidx='" & sjidx & "'"

' ================================
' ④ 프레임 상세(bar)
' ================================
Case "tk_frameksub"
  SQL = ""
  SQL = SQL & "SELECT "
  SQL = SQL & "fksidx, fkidx, bfidx, blength, xsize, ysize, gls, "
  SQL = SQL & "WHICHI_FIX, WHICHI_AUTO, garo_sero, door_W, door_h, "
  SQL = SQL & "glasstype, busok, OPT, FL "
  SQL = SQL & "FROM tk_framekSub "
  SQL = SQL & "WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE sjidx='" & sjidx & "')"

' ================================
' ⑤ 자재 마스터
' ================================
Case "tk_barasif"
  SQL = ""
  SQL = SQL & "SELECT "
  SQL = SQL & "bfidx, set_name_FIX, set_name_AUTO, WHICHI_FIX, WHICHI_AUTO, "
  SQL = SQL & "xsize, ysize, bfimg1, bfimg2, bfimg3 "
  SQL = SQL & "FROM tk_barasiF "
  SQL = SQL & "WHERE bfidx IN (SELECT DISTINCT bfidx FROM tk_framekSub S JOIN tk_framek K ON K.fkidx=S.fkidx WHERE K.sjidx='" & sjidx & "')"

' ================================
' ⑥ WMS META
' ================================
Case "tk_wms_meta"
 SQL = ""
 SQL = SQL & "SELECT "
 SQL = SQL & "wms_idx, wms_no, sjidx, cidx, wms_type, "
 SQL = SQL & "CONVERT(varchar(10),planned_ship_dt,120) AS planned_ship_dt, "
 SQL = SQL & "CONVERT(varchar(10),actual_ship_dt,120) AS actual_ship_dt, "
 SQL = SQL & "sender_name, sender_tel, recv_name, recv_tel, status "
 SQL = SQL & "FROM tk_wms_meta WHERE sjidx='" & sjidx & "' ORDER BY wms_idx DESC"

' ================================
' ⑦ WMS DETAIL
' ================================
Case "tk_wms_detail"
 SQL = ""
 SQL = SQL & "SELECT "
 SQL = SQL & "wmsd_idx, wms_idx, sjidx, sjsidx, fkidx, fksidx, bfidx, "
 SQL = SQL & "baname, blength, quan, xsize, ysize, status, bfimg, "
 SQL = SQL & "fixauto_type, is_door, paint_yn ,bfgroup "
 SQL = SQL & "FROM tk_wms_detail WHERE sjidx='" & sjidx & "' ORDER BY wmsd_idx DESC"

' ================================
' ⑧ RULE CORE
' ================================
Case "tk_rule_core"
 SQL = ""
 SQL = SQL & "SELECT rule_group, rule_name, condition_sql, result_value, priority, active "
 SQL = SQL & "FROM tk_rule_core WHERE rule_group='WMS_TYPE' ORDER BY priority"

' ================================
' ⑨ SENDER
' ================================
Case "tk_wms_sender"
 SQL = ""
 SQL = SQL & "SELECT sender_id, sender_name, sender_tel, sender_addr, sender_addr1, use_yn "
 SQL = SQL & "FROM tk_wms_sender ORDER BY sender_id"

End Select
%>

<%
On Error Resume Next
Rs.Open SQL, Dbcon

If Err.Number<>0 Then
  Response.Write "<div class='alert alert-danger mt-3'>SQL 오류: " & Err.Description & "</div>"
  Response.Write "<pre>" & Server.HTMLEncode(SQL) & "</pre>"
Else
%>

<h5 class="mt-3"><%=UCase(table)%></h5>

<div class="table-wrap">
<table class="table table-bordered table-hover table-sm">
  <thead class="table-light">
    <tr>
      <%
      For i=0 To Rs.Fields.Count-1
        Response.Write "<th>" & Rs.Fields(i).Name & "</th>"
      Next
      %>
    </tr>
  </thead>

  <tbody>
  <%
  If Not (Rs.BOF Or Rs.EOF) Then
    Do While Not Rs.EOF
      Response.Write "<tr>"
      For i=0 To Rs.Fields.Count-1
        val = Rs(i)
        If IsNull(val) Or Trim(val)="" Then
          Response.Write "<td class='null-cell'>NULL</td>"
        Else
          Response.Write "<td>" & Server.HTMLEncode(val) & "</td>"
        End If
      Next
      Response.Write "</tr>"
      Rs.MoveNext
    Loop
  Else
    Response.Write "<tr><td colspan='30' class='text-center text-muted'>데이터 없음</td></tr>"
  End If
  %>
  </tbody>
</table>
</div>

<%
End If
Rs.Close
Set Rs=Nothing
call dbClose()
%>

</body>
</html>
