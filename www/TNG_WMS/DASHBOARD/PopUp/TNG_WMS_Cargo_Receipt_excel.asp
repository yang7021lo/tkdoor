<%@ Language="VBScript" CodePage="65001" %>
<%
Option Explicit

Response.Buffer = True
Response.Clear
Response.Charset = "utf-8"
Response.ContentType = "application/vnd.ms-excel"
Response.AddHeader "Content-Disposition", "attachment;filename=WMS_Cargo_Receipt_" & Replace(Date(),"-","") & ".xls"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<%
Call dbOpen()

' =========================
' Helpers
' =========================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function
Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

Dim Rs, RsWMS, RsDiC, RsMan, SQL
Set Rs    = Server.CreateObject("ADODB.Recordset")
Set RsWMS = Server.CreateObject("ADODB.Recordset")
Set RsDiC = Server.CreateObject("ADODB.Recordset")
Set RsMan = Server.CreateObject("ADODB.Recordset")

Dim ymd
ymd = Trim(Request("ymd"))
If ymd = "" Then ymd = Date()

' =========================
' WMS META 캐시 (meta 전용)
' =========================
Dim dictWms
Set dictWms = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT DISTINCT wms_idx, recv_tel, wms_type, recv_name, recv_addr, sender_name "
SQL = SQL & "FROM tk_wms_meta "
SQL = SQL & "WHERE actual_ship_dt = '" & SqlEsc(ymd) & "' "
SQL = SQL & "AND wms_type IN (1,17,18,19) "
SQL = SQL & "ORDER BY recv_name "

RsWMS.Open SQL, DbCon, 1, 1
Do Until RsWMS.EOF
  Dim key, item
  key = CStr(RsWMS("wms_idx"))

  Set item = Server.CreateObject("Scripting.Dictionary")
  item("recv_tel")    = Nz(RsWMS("recv_tel"))
  item("recv_addr")   = Nz(RsWMS("recv_addr"))
  item("sender_name") = Nz(RsWMS("sender_name"))

  Set dictWms(key) = item
  RsWMS.MoveNext
Loop
RsWMS.Close

' =========================
' DELIVERY INFO 캐시 (meta 전용)
' =========================
Dim dictRecvTel
Set dictRecvTel = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT wms_idx, pay_type "
SQL = SQL & "FROM tk_wms_delivery_info "
SQL = SQL & "WHERE is_active = 1 "

RsDiC.Open SQL, DbCon, 1, 1
Do Until RsDiC.EOF
  dictRecvTel(CStr(RsDiC("wms_idx"))) = RsDiC("pay_type")
  RsDiC.MoveNext
Loop
RsDiC.Close

' =========================
' MANUAL 캐시 (manual_idx 기준)
'  - 품명: item_name 사용
' =========================
Dim dictManual
Set dictManual = Server.CreateObject("Scripting.Dictionary")

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & " manual_idx, ymd, wms_type, customer_name, recv_name, recv_tel, dest_text, item_name "
SQL = SQL & "FROM dbo.tk_wms_dashboard_manual WITH (NOLOCK) "
SQL = SQL & "WHERE is_active = 1 "
SQL = SQL & "  AND ymd = '" & SqlEsc(ymd) & "' "
SQL = SQL & "  AND wms_type IN (1,17,18,19) "

RsMan.Open SQL, DbCon, 1, 1
Do Until RsMan.EOF
  Dim mkey, mitem
  mkey = CStr(RsMan("manual_idx"))

  Set mitem = Server.CreateObject("Scripting.Dictionary")
  mitem("recv_name")     = Nz(RsMan("recv_name"))
  mitem("recv_tel")      = Nz(RsMan("recv_tel"))
  mitem("dest_text")     = Nz(RsMan("dest_text"))      ' 주소/지점명 역할
  mitem("customer_name") = Nz(RsMan("customer_name"))
  mitem("item_name")     = Nz(RsMan("item_name"))
  mitem("wms_type")      = Nz(RsMan("wms_type"))

  Set dictManual(mkey) = mitem
  RsMan.MoveNext
Loop
RsMan.Close

' =========================
' CARGO 집계
'  - meta: wms_idx NOT NULL
'  - manual: wms_idx NULL + manual_idx NOT NULL
'  - 그룹키 (kind, grp_id)로 분리
' =========================
SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN 'manual' ELSE 'meta' END AS kind, "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN manual_idx ELSE wms_idx END AS grp_id, "
SQL = SQL & "  wms_idx, manual_idx, "
SQL = SQL & "  COUNT(*) AS box_cnt, "
SQL = SQL & "  SUM(cargo_price) AS total_price, "
SQL = SQL & "  MAX(recv_name) AS recv_name, "
SQL = SQL & "  ISNULL(MAX(cargo_memo),'') AS cargo_memo "
SQL = SQL & "FROM tk_wms_cargo "
SQL = SQL & "WHERE status = 1 "
SQL = SQL & "  AND created_dt = '" & SqlEsc(ymd) & "' "
SQL = SQL & "GROUP BY "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN 'manual' ELSE 'meta' END, "
SQL = SQL & "  CASE WHEN wms_idx IS NULL AND manual_idx IS NOT NULL THEN manual_idx ELSE wms_idx END, "
SQL = SQL & "  wms_idx, manual_idx "
SQL = SQL & "ORDER BY kind ASC, grp_id DESC "

Rs.Open SQL, DbCon, 1, 1
%>

<table border="1">
<tr style="background:#f2f2f2;font-weight:bold;">
  <th>보내는 업체</th>
  <th>받는업체</th>
  <th>받는업체 연락처</th>
  <th>품명</th>
  <th>포장</th>
  <th>수량</th>
  <th>지불방법</th>
  <th>운임비</th>
  <th>주소</th>
</tr>

<%
Do Until Rs.EOF

  Dim kind, grp_id, wmsIdx, manualIdx
  Dim recv_tel, recv_addr, pay_text, memo, recv_name

  kind = Nz(Rs("kind"))
  grp_id = Nz(Rs("grp_id"))
  wmsIdx = Nz(Rs("wms_idx"))
  manualIdx = Nz(Rs("manual_idx"))

  recv_name = Nz(Rs("recv_name"))
  recv_tel = ""
  recv_addr = ""
  pay_text = "현화"

  If kind = "manual" Then
    ' 수동: tk_wms_dashboard_manual 값 사용
    If dictManual.Exists(CStr(grp_id)) Then
      If recv_name = "" Then recv_name = dictManual(CStr(grp_id))("recv_name")
      recv_tel  = dictManual(CStr(grp_id))("recv_tel")
      recv_addr = dictManual(CStr(grp_id))("dest_text")
    End If

    ' 지불방법: 수동은 기본 현화(원하면 규칙 추가)
    pay_text = "현화"

    ' 품명 우선순위:
    ' 1) cargo_memo (있으면)
    ' 2) manual.item_name (없으면)
    ' 3) 기본 프레임
    If Nz(Rs("cargo_memo")) <> "" Then
      memo = Nz(Rs("cargo_memo"))
    ElseIf dictManual.Exists(CStr(grp_id)) Then
      memo = Nz(dictManual(CStr(grp_id))("item_name"))
      If memo = "" Then memo = "프레임"
    Else
      memo = "프레임"
    End If


  Else
    ' meta: 기존 캐시 사용
    If dictWms.Exists(wmsIdx) Then
      recv_tel  = dictWms(wmsIdx)("recv_tel")
      recv_addr = dictWms(wmsIdx)("recv_addr")
    End If

    If dictRecvTel.Exists(wmsIdx) And IsNumeric(dictRecvTel(wmsIdx)) Then
      If CLng(dictRecvTel(wmsIdx)) = 0 Then
        pay_text = "현화"
      Else
        pay_text = "착불"
      End If
    Else
      pay_text = "현화"
    End If

    If Nz(Rs("cargo_memo")) = "" Then
      memo = "프레임"
    Else
      memo = Nz(Rs("cargo_memo"))
    End If
  End If
%>

<tr>
  <td>태광도어</td>
  <td><%=recv_name%></td>
  <td><%=recv_tel%></td>
  <td><%=memo%></td>
  <td>B</td>
  <td><%=Rs("box_cnt")%></td>
  <td><%=pay_text%></td>
  <td><%=Rs("total_price")%></td>
  <td><%=recv_addr%></td>
</tr>

<%
  Rs.MoveNext
Loop

Rs.Close
Set Rs = Nothing
Call dbClose()
%>
</table>
