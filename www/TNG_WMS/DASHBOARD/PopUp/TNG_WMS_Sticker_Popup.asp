<%@ Language="VBScript" CodePage="65001" %>
<%
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

' 우측(바류) 판단
Function IsRightGroup(ByVal nm)
  Dim s : s = LCase(Trim("" & nm))

  ' 공백/특수표현 변형 고려 (코너바, 픽스바, 세로/가로/하바 등)
  If InStr(s, "가로") > 0 And InStr(s, "바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "세로") > 0 And InStr(s, "바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "하바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "코너바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "픽스바") > 0 Then IsRightGroup = True : Exit Function
  If InStr(s, "펀개") > 0 Then IsRightGroup = True : Exit Function

  ' 기본 좌측
  IsRightGroup = False
End Function

' 체크박스가 필요한 항목(예: 세트/핵심류)
Function NeedCheckbox(ByVal nm)
  Dim s : s = Trim("" & nm)
  If InStr(s, "픽스세트") > 0 Then NeedCheckbox = True : Exit Function
  If InStr(s, "박스세트") > 0 Then NeedCheckbox = True : Exit Function
  If InStr(s, "자동홀바") > 0 Then NeedCheckbox = True : Exit Function
  If InStr(s, "자동홑바") > 0 Then NeedCheckbox = True : Exit Function
  If InStr(s, "중간소대") > 0 Then NeedCheckbox = True : Exit Function
  NeedCheckbox = False
End Function


' =========================================================
' payload -> 2칸 분할 HTML
'  - 1차: 키워드로 좌/우 분류
'  - 2차: 한쪽으로 쏠리면 자동 균형(반반 보정)
'  - 3차: 체크박스(좌측 핵심 항목) 출력
' =========================================================
Function PayloadToHtml(ByVal payload, ByVal sumQty)
  Dim out, items, i, p, nm, bl, qt, lineText
  Dim L(), R(), lN, rN, all(), aN
  Dim diff, moveCnt

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

            ' 체크박스 붙이기(원하면 조건 변경 가능)
            lineText = "<span class='chk'></span>" & lineText
            ' 전체도 저장(균형 보정용)
            ReDim Preserve all(aN)
            all(aN) = lineText
            aN = aN + 1

            ' 1차 분류
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

  ' ===== 2차: 쏠림 방지(한쪽이 너무 많으면 반반 보정) =====
  ' 기준: 차이가 2개 이상이면 보정
  diff = lN - rN
  If diff >= 2 Or diff <= -2 Then
    ' 분류가 너무 한쪽으로 쏠리면, 전체를 “그냥 반반”으로 재분배
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

  ' ===== HTML 출력 =====
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
' Param
' =========================
Dim wms_idx
wms_idx = SafeInt(Request("wms_idx"))
If wms_idx <= 0 Then
  Response.Write "wms_idx가 없습니다."
  Call dbClose()
  Response.End
End If

' ============================================================
' sjsidx 기반 정보 캐시 (tng_sjaSub)
'  [0]=framename(or 출력명), [1]=pname, [2]=bigo, [3]=mwidth, [4]=mheight, [5]=qtyidx
' ============================================================
Dim dictSjs
Set dictSjs = Server.CreateObject("Scripting.Dictionary")

Dim SQL_PREF1, RsPref1, ps_sjsidx, ps_framename, ps_pname
Dim ps_tmp, ps_bigo, ps_mwidth, ps_mheight, ps_qtyidx

SQL_PREF1 = ""
SQL_PREF1 = SQL_PREF1 & "SELECT A.sjsidx, A.sjidx, A.framename, "
SQL_PREF1 = SQL_PREF1 & "       P.pname, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_wichi1, A.asub_wichi2, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_bigo1, A.asub_bigo2, A.asub_bigo3, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_meno1, A.asub_meno2, "
SQL_PREF1 = SQL_PREF1 & "       A.mwidth, A.mheight, A.qtyidx "
SQL_PREF1 = SQL_PREF1 & "FROM tng_sjaSub A "
SQL_PREF1 = SQL_PREF1 & "JOIN tk_wms_meta M ON A.sjidx = M.sjidx "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_paint P ON A.pidx = P.pidx "
SQL_PREF1 = SQL_PREF1 & "WHERE M.wms_idx = " & wms_idx & " "
SQL_PREF1 = SQL_PREF1 & "  AND A.astatus = '1' "

Set RsPref1 = Dbcon.Execute(SQL_PREF1)

Do Until RsPref1.EOF
  ps_sjsidx    = "" & RsPref1("sjsidx")
  ps_framename = Nz(RsPref1("framename"))
  ps_pname     = Nz(RsPref1("pname"))

  ps_tmp = Trim( Nz(RsPref1("asub_wichi1")) & " " & Nz(RsPref1("asub_wichi2")) & " " & _
                 Nz(RsPref1("asub_bigo1")) & " " & Nz(RsPref1("asub_bigo2")) & " " & _
                 Nz(RsPref1("asub_bigo3")) & " " & Nz(RsPref1("asub_meno1")) & " " & Nz(RsPref1("asub_meno2")) )
  ps_bigo = Replace(ps_tmp, "  ", " ")

  ps_mwidth  = SafeInt(RsPref1("mwidth"))
  ps_mheight = SafeInt(RsPref1("mheight"))
  ps_qtyidx  = SafeInt(RsPref1("qtyidx"))

  If Not dictSjs.Exists(ps_sjsidx) Then
    dictSjs.Add ps_sjsidx, Array(ps_framename, ps_pname, ps_bigo, ps_mwidth, ps_mheight, ps_qtyidx)
  End If

  RsPref1.MoveNext
Loop
RsPref1.Close : Set RsPref1 = Nothing

' ============================================================
' sjsidx별 수량 캐시 (tk_framek) : SUM(quan)
' ============================================================
Dim dictQty
Set dictQty = Server.CreateObject("Scripting.Dictionary")

Dim RsQ, SQLQ, q_sjsidx, q_qty
Set RsQ = Server.CreateObject("ADODB.Recordset")

SQLQ = ""
SQLQ = SQLQ & "SELECT F.sjsidx, SUM(ISNULL(F.quan,0)) AS qty "
SQLQ = SQLQ & "FROM tk_framek F "
SQLQ = SQLQ & "JOIN tk_wms_meta M ON F.sjidx = M.sjidx "
SQLQ = SQLQ & "WHERE M.wms_idx = " & wms_idx & " "
SQLQ = SQLQ & "GROUP BY F.sjsidx "

RsQ.Open SQLQ, Dbcon, 1, 1
Do Until RsQ.EOF
  q_sjsidx = "" & RsQ("sjsidx")
  q_qty = SafeInt(RsQ("qty"))
  dictQty(q_sjsidx) = q_qty
  RsQ.MoveNext
Loop
RsQ.Close : Set RsQ = Nothing
Set RsQ = Nothing

' ============================================================
' sjsidx별 cargo 개수 캐시 (tk_wms_cargo): COUNT(*) * 2 만큼 스티커 반복
'  - 1) tk_wms_cargo에 wms_idx가 있으면 그걸 사용
'  - 2) 없으면 sjidx로 meta 조인 fallback
' ============================================================
Dim dictCargo
Set dictCargo = Server.CreateObject("Scripting.Dictionary")

Dim RsC, SQLC
Set RsC = Server.CreateObject("ADODB.Recordset")

On Error Resume Next

SQLC = ""
SQLC = SQLC & "SELECT sjsidx, COUNT(*) AS cargo_cnt "
SQLC = SQLC & "FROM tk_wms_cargo "
SQLC = SQLC & "WHERE wms_idx = " & wms_idx & " "
SQLC = SQLC & "GROUP BY sjsidx "

RsC.Open SQLC, Dbcon, 1, 1

If Err.Number <> 0 Then
  Err.Clear
  RsC.Close

  SQLC = ""
  SQLC = SQLC & "SELECT C.sjsidx, COUNT(*) AS cargo_cnt "
  SQLC = SQLC & "FROM tk_wms_cargo C "
  SQLC = SQLC & "JOIN tk_wms_meta M ON C.sjidx = M.sjidx "
  SQLC = SQLC & "WHERE M.wms_idx = " & wms_idx & " "
  SQLC = SQLC & "GROUP BY C.sjsidx "

  RsC.Open SQLC, Dbcon, 1, 1
End If

On Error GoTo 0

If Not (RsC.BOF Or RsC.EOF) Then
  Do Until RsC.EOF
    dictCargo("" & RsC("sjsidx")) = SafeInt(RsC("cargo_cnt"))
    RsC.MoveNext
  Loop
End If

RsC.Close : Set RsC = Nothing

' =========================================================
' 1) 상단 공통정보 (거래처/받는이/주소)
' =========================================================
Dim RsM, SQLM
Set RsM = Server.CreateObject("ADODB.Recordset")

SQLM = ""
SQLM = SQLM & "SELECT TOP 1 "
SQLM = SQLM & "  M.wms_idx, M.sjidx, M.recv_name, M.recv_addr, M.recv_addr1, "
SQLM = SQLM & "  C.cname "
SQLM = SQLM & "FROM tk_wms_meta M "
SQLM = SQLM & "LEFT JOIN TNG_SJA A ON M.sjidx = A.sjidx "
SQLM = SQLM & "LEFT JOIN tk_customer C ON A.sjcidx = C.cidx "
SQLM = SQLM & "WHERE M.wms_idx=" & wms_idx

RsM.Open SQLM, Dbcon, 1, 1

Dim cname, recv_name, recv_addr, recv_addr1
cname = "" : recv_name = "" : recv_addr = "" : recv_addr1 = ""
If Not (RsM.BOF Or RsM.EOF) Then
  cname      = Nz(RsM("cname"))
  recv_name  = Nz(RsM("recv_name"))
  recv_addr  = Nz(RsM("recv_addr"))
  recv_addr1 = Nz(RsM("recv_addr1"))
End If
RsM.Close : Set RsM = Nothing

' =========================================================
' 2) 스냅샷 목록 : wms_idx 기준 (sjsidx별 payload)
' =========================================================
Dim RsS, SQLS
Set RsS = Server.CreateObject("ADODB.Recordset")

SQLS = ""
SQLS = SQLS & "SELECT sjsidx, sum_qty, payload "
SQLS = SQLS & "FROM tk_wms_sticker_snapshot "
SQLS = SQLS & "WHERE wms_idx=" & wms_idx & " "
SQLS = SQLS & "ORDER BY sjsidx ASC"

RsS.Open SQLS, Dbcon, 1, 1

Dim items(), cnt
cnt = 0
ReDim items(0)

Do Until RsS.EOF
  Dim sjsidx, sum_qty, payload
  sjsidx  = SafeInt(RsS("sjsidx"))
  sum_qty = SafeInt(RsS("sum_qty"))
  payload = Nz(RsS("payload"))

  Dim itemName, meas, qtyTxt, colorTxt, arrSjs
  itemName = "" : meas = "" : qtyTxt = "" : colorTxt = ""

  If dictSjs.Exists(CStr(sjsidx)) Then
    arrSjs = dictSjs(CStr(sjsidx))

    itemName = Nz(arrSjs(0))
    If Nz(arrSjs(2)) <> "" Then itemName = itemName & "|" & Nz(arrSjs(2))

    If SafeInt(arrSjs(3)) > 0 And SafeInt(arrSjs(4)) > 0 Then
      meas = "(" & SafeInt(arrSjs(3)) & " X " & SafeInt(arrSjs(4)) & ")"
    End If

    If dictQty.Exists(CStr(sjsidx)) Then
      qtyTxt = CStr(dictQty(CStr(sjsidx)))
    ElseIf sum_qty > 0 Then
      qtyTxt = CStr(sum_qty)
    End If
  End If

  ReDim Preserve items(cnt)
  items(cnt) = Array( _
    sjsidx, _
    itemName, _
    meas, _
    qtyTxt, _
    "", _
    PayloadToHtml(payload, sum_qty) _
  )

  cnt = cnt + 1
  RsS.MoveNext
Loop

RsS.Close : Set RsS = Nothing
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Sticker Print</title>

<style>
  @page{ size: 100mm 100mm; margin: 0; }
  html, body{ margin:0; padding:0; }
  body{ font-family:'맑은 고딕'; background:#fff; }

  /* =========================
     Sticker Page
     ========================= */
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
  .tr-qty   td{ padding-top: 0.20mm !important; padding-bottom: 0.20mm !important; }

  .addr-cell{
    font-size: 2.3mm !important;
    line-height: 1.02 !important;
  }

  .tr-detail td{
    padding-top: 2.2mm !important;
    padding-bottom: 2.2mm !important;
  }

  /* =========================
     Item / Measure / Qty (3칸)
     ========================= */
  .itemmeas, .itemmeas *{
    word-break: normal !important;
    overflow-wrap: normal !important;
  }

  .itemmeas{
    display:grid;
    grid-template-columns: 1fr auto auto; /* 품목명 / 검측 / 수량 */
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

  /* =========================
     Detail 2-column with dashed separator
     ========================= */
  .detail2{
    width:100%;
    border-collapse:collapse;
    table-layout:fixed;
  }

  .detail2 td{
    border:0 !important;
    padding:0 !important;
    vertical-align:top;
  }

  .detail2 .col{
    width:50%;
    box-sizing:border-box;
  }

  /* 왼쪽 칸: 오른쪽 점선 + 오른쪽 패딩 */
  .detail2 .col.left{
    padding-right:1.5mm !important;
    border-right:0.2mm dashed #bdbdbd !important;
  }

  /* 오른쪽 칸: 왼쪽 패딩 */
  .detail2 .col.right{
    padding-left:1.5mm !important;
  }

  /* =========================
     Detail font override
     ========================= */
  .stk td .detail-wrap,
  .stk td .detail-wrap *{
    font-size: 3.0mm !important;
    font-weight: 800 !important;
    line-height: 1.12 !important;
  }

  /* =========================
     Checkbox for printing
     ========================= */
  .chk{
    display:inline-block;
    width: 2.6mm;
    height: 2.6mm;
    border: 0.25mm solid #111;
    margin-right: 1.0mm;
    vertical-align: -0.25mm;
    box-sizing:border-box;
  }

  @media print{
    body{ margin:0; padding:0; }
  }
</style>


</head>
<body>

<%
Dim i, itemA
If cnt = 0 Then
  Response.Write "<div>저장된 스티커 데이터가 없습니다.</div>"
Else
  For i = 0 To cnt-1

    itemA = items(i)

    Dim hasB, itemSjsidx
    hasB = False
    itemSjsidx = SafeInt(itemA(0))

    Dim A_item, A_meas, A_qty, A_color, A_detail
    A_item   = Nz(itemA(1))
    A_meas   = Nz(itemA(2))
    A_qty    = Nz(itemA(3))
    A_color  = Nz(itemA(4))
    A_detail = Nz(itemA(5))

    ' =========================================================
    ' cargo 개수 * 2 만큼 스티커 반복 출력
    ' =========================================================
    Dim printN, cargoCnt, k
    printN = 1
    cargoCnt = 0

    If dictCargo.Exists(CStr(itemSjsidx)) Then
      cargoCnt = SafeInt(dictCargo(CStr(itemSjsidx)))
      If cargoCnt > 0 Then printN = cargoCnt * 2
    End If
    If printN < 1 Then printN = 1

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
      <%= TD2Detail("<div class='detail-wrap'>" & A_detail & "</div>", "", hasB) %>
    </tr>

  </table>
</div>

<%
    Next ' k
  Next ' i
End If
%>

</body>
</html>

<%
Call dbClose()
%>
