<%@ Language="VBScript" CodePage="65001" %>
<%
Option Explicit
Session.CodePage="65001"
Response.Charset="utf-8"
Response.Buffer = True
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
Call dbOpen()

' =========================
' Safe helpers
' =========================
Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function

Function SafeInt(v)
  On Error Resume Next
  SafeInt = CLng(0 & v)
  On Error GoTo 0
End Function

Function HtmlEnc(ByVal s)
  s = "" & s
  s = Replace(s, "&", "&amp;")
  s = Replace(s, "<", "&lt;")
  s = Replace(s, ">", "&gt;")
  HtmlEnc = s
End Function

Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

' =========================
' TD builders (2-column)
' =========================
Function TD2(ByVal leftHtml, ByVal rightHtml, ByVal hasB)
  If CBool(hasB) Then
    TD2 = "<td class='cell center'>" & leftHtml & "</td>" & _
          "<td class='cell center'>" & rightHtml & "</td>"
  Else
    TD2 = "<td class='cell center' colspan='2'>" & leftHtml & "</td>"
  End If
End Function

Function TD2Detail(ByVal leftHtml, ByVal rightHtml, ByVal hasB)
  If CBool(hasB) Then
    TD2Detail = "<td class='cell'>" & leftHtml & "</td>" & _
                "<td class='cell'>" & rightHtml & "</td>"
  Else
    TD2Detail = "<td class='cell' colspan='2'>" & leftHtml & "</td>"
  End If
End Function

' =========================
' 우측(바류) 판단
' =========================
Function IsRightGroup(ByVal nm)
  Dim s : s = LCase(Trim("" & nm))

  If InStr(s, "가로") > 0 And InStr(s, "바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "세로") > 0 And InStr(s, "바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "하바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "코너바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "픽스바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "펀개") > 0 Then IsRightGroup = True : Exit Function

  IsRightGroup = False
End Function

' =========================
' spec_text(자유 입력) -> payload(name^len^qty|...) 변환
' =========================
Function SpecToPayload(ByVal specText, ByRef outSum)
  Dim s, norm, arr, i, part, payload, nm, bl, qt, m
  outSum = 0
  payload = ""

  s = Nz(specText)
  If s = "" Then SpecToPayload = "" : Exit Function

  norm = s
  norm = Replace(norm, vbCrLf, "|")
  norm = Replace(norm, vbLf, "|")
  norm = Replace(norm, vbCr, "|")
  norm = Replace(norm, "/", "|")
  norm = Replace(norm, "／", "|")
  norm = Replace(norm, ",", "|")
  norm = Replace(norm, "，", "|")
  norm = Replace(norm, " / ", "|")
  norm = Replace(norm, " | ", "|")
  norm = Replace(norm, "│", "|")
  norm = Replace(norm, "×", "x")
  norm = Replace(norm, "X", "x")

  arr = Split(norm, "|")

  Dim re1, re2
  Set re1 = New RegExp
  re1.IgnoreCase = True
  re1.Global = False
  re1.Pattern = "^\s*(.+?)\s+(\d+)\s*x\s*(\d+)\s*$"

  Set re2 = New RegExp
  re2.IgnoreCase = True
  re2.Global = False
  re2.Pattern = "^\s*(.+?)\s*x\s*(\d+)\s*$"

  For i = 0 To UBound(arr)
    part = Trim(arr(i))
    If part <> "" Then
      nm = "" : bl = 0 : qt = 0

      If re1.Test(part) Then
        Set m = re1.Execute(part)(0)
        nm = Trim(m.SubMatches(0))
        bl = SafeInt(m.SubMatches(1))
        qt = SafeInt(m.SubMatches(2))
      ElseIf re2.Test(part) Then
        Set m = re2.Execute(part)(0)
        nm = Trim(m.SubMatches(0))
        bl = 0
        qt = SafeInt(m.SubMatches(1))
      Else
        nm = part
        bl = 0
        qt = 1
      End If

      If nm <> "" And qt > 0 Then
        If payload <> "" Then payload = payload & "|"
        payload = payload & Replace(nm, "|", "") & "^" & CLng(bl) & "^" & CLng(qt)
        outSum = outSum + qt
      End If
    End If
  Next

  SpecToPayload = payload
End Function

' =========================
' payload -> 2칸 분할 HTML
' =========================
Function PayloadToHtml(ByVal payload, ByVal sumQty)
  Dim out, items, i, p, nm, bl, qt, lineText
  Dim L(), R(), lN, rN, all(), aN
  Dim diff

  out = ""
  payload = Nz(payload)

  lN = 0 : rN = 0 : aN = 0
  ReDim L(0) : ReDim R(0) : ReDim all(0)

  If payload <> "" Then
    items = Split(payload, "|")
    For i = 0 To UBound(items)
      If Trim(items(i)) <> "" Then
        p = Split(items(i), "^")
        If UBound(p) >= 2 Then
          nm = Trim(p(0))
          bl = Trim(p(1))
          qt = Trim(p(2))

          If nm <> "" Then
            lineText = HtmlEnc(nm)
            If bl <> "" And bl <> "0" Then lineText = lineText & " " & HtmlEnc(bl)
            lineText = lineText & " × " & HtmlEnc(qt)

            lineText = "<span class='chk'></span>" & lineText

            ReDim Preserve all(aN)
            all(aN) = lineText
            aN = aN + 1

            If IsRightGroup(nm) Then
              ReDim Preserve R(rN) : R(rN) = lineText : rN = rN + 1
            Else
              ReDim Preserve L(lN) : L(lN) = lineText : lN = lN + 1
            End If
          End If
        End If
      End If
    Next
  End If

  diff = lN - rN
  If diff >= 2 Or diff <= -2 Then
    Erase L : Erase R
    lN = 0 : rN = 0
    ReDim L(0) : ReDim R(0)

    Dim half : half = aN \ 2
    If half < 1 Then half = 1

    For i = 0 To aN-1
      If i < half Then
        ReDim Preserve L(lN) : L(lN) = all(i) : lN = lN + 1
      Else
        ReDim Preserve R(rN) : R(rN) = all(i) : rN = rN + 1
      End If
    Next
  End If

  If aN > 0 Then
    Dim leftHtml, rightHtml
    leftHtml = "" : rightHtml = ""

    For i = 0 To lN-1
      leftHtml = leftHtml & L(i) & "<br><br>"
    Next
    For i = 0 To rN-1
      rightHtml = rightHtml & R(i) & "<br><br>"
    Next

    out = out & "<table class='detail2'><tr>" & _
                "<td class='col left'>" & leftHtml & "</td>" & _
                "<td class='col right'>" & rightHtml & "</td>" & _
                "</tr></table>"
  End If

  PayloadToHtml = out
End Function

' =========================
' Param: manual_idx
' =========================
Dim manual_idx
manual_idx = SafeInt(Request("manual_idx"))
If manual_idx <= 0 Then
  Response.Write "manual_idx가 없습니다."
  Call dbClose()
  Response.End
End If

' =========================================================
' tk_wms_dashboard_manual 1건 조회
'  ※ 당신 요구사항: item_name 컬럼 사용
' =========================================================
Dim RsM, SQLM
Set RsM = Server.CreateObject("ADODB.Recordset")

SQLM = ""
SQLM = SQLM & "SELECT TOP 1 "
SQLM = SQLM & "  manual_idx, ymd, wms_type, "
SQLM = SQLM & "  customer_name, recv_name, recv_tel, dest_text, "
SQLM = SQLM & "  item_name, material_text, paint_no, spec_text, remark "
SQLM = SQLM & "FROM dbo.tk_wms_dashboard_manual WITH (NOLOCK) "
SQLM = SQLM & "WHERE manual_idx=" & manual_idx & " AND is_active=1 "

RsM.Open SQLM, Dbcon, 1, 1

If (RsM.BOF Or RsM.EOF) Then
  Response.Write "해당 수동건이 없습니다."
  RsM.Close : Set RsM = Nothing
  Call dbClose()
  Response.End
End If

Dim ymd, wms_type, cname, recv_name, recv_tel, recv_addr, recv_addr1
Dim item_name, material_text, paint_no, spec_text, remark

ymd        = Nz(RsM("ymd"))
wms_type   = SafeInt(RsM("wms_type"))
cname      = Nz(RsM("customer_name"))
recv_name  = Nz(RsM("recv_name"))
recv_tel   = Nz(RsM("recv_tel"))
recv_addr  = Nz(RsM("dest_text"))
recv_addr1 = ""

item_name     = Nz(RsM("item_name"))
material_text = Nz(RsM("material_text"))
paint_no      = Nz(RsM("paint_no"))
spec_text     = Nz(RsM("spec_text"))
remark        = Nz(RsM("remark"))

RsM.Close : Set RsM = Nothing

' =========================================================
' 수동 포장 박스 개수 = tk_wms_cargo에서 manual_idx로 COUNT(*)
'  - 이것을 * 2 해서 스티커 반복 횟수로 사용
' =========================================================
Dim cargoCntManual, printN
cargoCntManual = 0
printN = 1

Dim RsC, SQLC
Set RsC = Server.CreateObject("ADODB.Recordset")

SQLC = ""
SQLC = SQLC & "SELECT COUNT(*) AS cargo_cnt "
SQLC = SQLC & "FROM tk_wms_cargo WITH (NOLOCK) "
SQLC = SQLC & "WHERE status = 1 AND manual_idx = " & manual_idx & " "

RsC.Open SQLC, DbCon, 1, 1
If Not (RsC.BOF Or RsC.EOF) Then
  cargoCntManual = SafeInt(RsC("cargo_cnt"))
End If
RsC.Close : Set RsC = Nothing

If cargoCntManual > 0 Then
  printN = cargoCntManual * 2
Else
  ' 포장 데이터가 아직 없으면 1장만(원하면 0으로 해서 "없음" 표기도 가능)
  printN = 1
End If

' =========================================================
' spec_text -> payload 변환 + 합계 계산
' =========================================================
Dim sum_qty, payload, detailHtml
sum_qty = 0
payload = SpecToPayload(spec_text, sum_qty)
detailHtml = PayloadToHtml(payload, sum_qty)

' =========================================================
' Sticker 출력 데이터 1건
' =========================================================
Dim A_item, A_meas, A_qty
A_item = item_name
If material_text <> "" Then A_item = A_item & " / " & material_text
If paint_no <> "" Then A_item = A_item & " / " & paint_no

A_meas = ""
A_qty  = ""
If sum_qty > 0 Then A_qty = CStr(sum_qty)
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Sticker Print (Manual)</title>

<style>
  @page{ size: 100mm 100mm; margin: 0; }
  html, body{ margin:0; padding:0; }
  body{ font-family:'맑은 고딕'; background:#fff; }

  .sticker{
    width: 100mm;
    height: 100mm;
    box-sizing: border-box;
    padding: 3mm;
    page-break-after: always;
    overflow: hidden;
  }

  table.stk{
    width:100%;
    height:100%;
    border-collapse: collapse;
    table-layout: fixed;
  }

  .stk td{
    border: 0.2mm solid #d9d9d9;
    padding: 0.8mm 1.1mm;
    vertical-align: middle;
    font-size: 2.7mm;
    line-height: 1.08;
    word-break: break-word;
    overflow-wrap: anywhere;
  }

  .lab{
    width: 22mm;
    font-weight: 800;
    text-align: center;
    background: #fafafa;
  }

  .cell{ width:auto; }
  .center{ text-align:center; }

  .tr-tight td{ padding-top: 0.25mm !important; padding-bottom: 0.25mm !important; }
  .tr-detail td{
    padding-top: 2.2mm !important;
    padding-bottom: 2.2mm !important;
  }

  .addr-cell{
    font-size: 2.3mm !important;
    line-height: 1.02 !important;
  }

  .itemmeas{
    display:grid;
    grid-template-columns: 1fr auto auto;
    align-items: baseline;
    column-gap: 2mm;
    width:100%;
    overflow:hidden;
  }

  .itemmeas .nm{
    min-width:0;
    overflow:hidden;
    white-space:nowrap;
    text-overflow:ellipsis;
    color:#666;
    font-weight:500;
    font-size: 2.7mm;
  }

  .itemmeas .ms{
    white-space:nowrap;
    color:#111;
    font-weight:900;
    font-size: 4.2mm;
  }

  .itemmeas .qty{
    white-space:nowrap;
    color:#111;
    font-weight:900;
    font-size: 4.6mm;
  }

  .detail2{ width:100%; border-collapse:collapse; table-layout:fixed; }
  .detail2 td{ border:0 !important; padding:0 !important; vertical-align:top; }
  .detail2 .col{ width:50%; box-sizing:border-box; }
  .detail2 .col.left{ padding-right:1.5mm !important; border-right:0.2mm dashed #bdbdbd !important; }
  .detail2 .col.right{ padding-left:1.5mm !important; }

  .stk td .detail-wrap, .stk td .detail-wrap *{
    font-size: 3.0mm !important;
    font-weight: 800 !important;
    line-height: 1.12 !important;
  }

  .chk{
    display:inline-block;
    width: 2.6mm;
    height: 2.6mm;
    border: 0.25mm solid #111;
    margin-right: 1.0mm;
    vertical-align: -0.25mm;
    box-sizing:border-box;
  }
</style>
</head>
<body>

<%
Dim k
For k = 1 To printN
%>

<div class="sticker">
  <table class="stk">

    <tr>
      <td class="lab">거래처명</td>
      <td class="cell center" colspan="2"><%=HtmlEnc(cname)%> | <%=HtmlEnc(recv_name)%></td>
    </tr>

    <tr class="tr-tight">
      <td class="lab">지점명/주소</td>
      <%
        Response.Write TD2( _
          "<span class='addr-cell'>" & HtmlEnc(recv_addr) & "</span>", _
          "<span class='addr-cell'>" & HtmlEnc(recv_addr1) & "</span>", _
          (recv_addr1 <> "") _
        )
      %>
    </tr>

    <tr>
      <td class="lab">품목명/검측/수량</td>
      <td class="cell center" colspan="2">
        <div class="itemmeas">
          <span class="nm" title="<%=HtmlEnc(A_item)%>"><%=HtmlEnc(A_item)%></span>
          <span class="ms"><%=HtmlEnc(A_meas)%></span>
          <span class="qty"> X <%=HtmlEnc(A_qty)%></span>
        </div>
      </td>
    </tr>

    <tr class="tr-detail">
      <td class="lab">세부사항(내용물)</td>
      <%= TD2Detail("<div class='detail-wrap'>" & detailHtml & "</div>", "", False) %>
    </tr>

  </table>
</div>

<%
Next
%>

</body>
</html>

<%
Call dbClose()
%>
