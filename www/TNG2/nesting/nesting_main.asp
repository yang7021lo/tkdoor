<%@ codepage="65001" language="vbscript"%>
<%
On Error Resume Next
Session.CodePage="65001"
Response.CharSet="utf-8"
Server.ScriptTimeout = 300

' 디버그 모드
debug_mode = (Request("debug") = "1")
If debug_mode Then Response.Write "<pre>DEBUG MODE ON</pre>"

Sub CheckErr(tag)
  If Err.Number <> 0 Then
    Response.Write "<pre style='color:red'>[ERROR] " & tag & " :: " & Err.Number & " - " & Err.Description & "</pre>"
    Err.Clear
  End If
End Sub
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
If debug_mode Then Response.Write "<pre>Include OK</pre>"

call dbOpen()
CheckErr "dbOpen"
Dbcon.CommandTimeout = 300

sjidx  = Request("sjidx")
sjmidx = Request("sjmidx")
' cidx 또는 sjcidx 둘 다 지원
cidx   = Request("cidx")
If cidx = "" Then cidx = Request("sjcidx")

If sjidx = "" Then
  Response.Write "<script>alert('sjidx 누락');history.back();</script>"
  Response.End
End If

' ===============================
' 헤더 정보 조회
' ===============================
sql = "SELECT TOP 1 cname, sjdate, sjnum, cgaddr, cgdate, djcgdate " & _
      "FROM tk_balju_st WHERE sjidx='" & sjidx & "' AND insert_flag=1"
Set RsH = Dbcon.Execute(sql)
If Not RsH.EOF Then
  h_cname    = RsH("cname") & ""
  h_sjdate   = RsH("sjdate") & ""
  h_sjnum    = RsH("sjnum") & ""
  h_cgaddr   = RsH("cgaddr") & ""
  h_cgdate   = RsH("cgdate") & ""
  h_djcgdate = RsH("djcgdate") & ""
End If
RsH.Close

h_djnum = ""
sql = "SELECT djnum FROM tk_wms_djnum WHERE sjidx='" & sjidx & "'"
Set RsD = Dbcon.Execute(sql)
If Not RsD.EOF Then h_djnum = RsD("djnum") & ""
RsD.Close

' ===============================
' 헬퍼 함수
' ===============================
Function JsonEscape(s)
  If IsNull(s) Then s = ""
  s = CStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  s = Replace(s, vbCr, "\n")
  s = Replace(s, vbLf, "\n")
  JsonEscape = s
End Function

Function SafeNum(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    SafeNum = 0
  Else
    SafeNum = CDbl(v)
  End If
End Function

Function SafeStr(v)
  If IsNull(v) Then SafeStr = "" Else SafeStr = CStr(v)
End Function

Function MapSheetW(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    MapSheetW = ""
  ElseIf CLng(v) = 1 Then
    MapSheetW = 1219
  Else
    MapSheetW = CLng(v)
  End If
End Function

Function MapSheetT(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    MapSheetT = ""
  Else
    Select Case CLng(v)
      Case 3: MapSheetT = "1.2T"
      Case 4: MapSheetT = "1.5T"
      Case Else: MapSheetT = CStr(v) & "T"
    End Select
  End If
End Function

' ===============================
' 좌측: 전체 판재 목록 (tk_qty + tk_qtyco)
' ===============================
sql = ""
sql = sql & "SELECT DISTINCT q.qtyidx, q.qtyno, q.qtyname, "
sql = sql & "       c.qtyco_idx, c.sheet_w, c.sheet_h, c.sheet_t "
sql = sql & "FROM tk_qty q "
sql = sql & "JOIN tk_qtyco c ON q.qtyno = c.qtyno "
sql = sql & "WHERE ISNULL(c.sheet_h,0) > 0 "
sql = sql & "  AND c.QTYcostatus = 1 "
sql = sql & "ORDER BY q.qtyname, c.sheet_w, c.sheet_h"

Set RsAll = Dbcon.Execute(sql)
jsonAll = "["
firstAll = True
Do While Not RsAll.EOF
  sw = MapSheetW(RsAll("sheet_w"))
  sh = RsAll("sheet_h")
  st = MapSheetT(RsAll("sheet_t"))
  
  If sw <> "" And Not IsNull(sh) And sh <> "" Then
    If Not firstAll Then jsonAll = jsonAll & ","
    firstAll = False
    
    ' 규격명 조합
    spec = sw & "*" & sh
    
    jsonAll = jsonAll & "{"
    jsonAll = jsonAll & """qtyco_idx"":" & RsAll("qtyco_idx") & ","
    jsonAll = jsonAll & """qtyidx"":" & RsAll("qtyidx") & ","
    jsonAll = jsonAll & """qtyno"":" & RsAll("qtyno") & ","
    jsonAll = jsonAll & """qtyname"":""" & JsonEscape(RsAll("qtyname")) & ""","
    jsonAll = jsonAll & """spec"":""" & spec & ""","
    jsonAll = jsonAll & """sheet_w"":" & sw & ","
    jsonAll = jsonAll & """sheet_h"":" & sh & ","
    jsonAll = jsonAll & """sheet_t"":""" & st & ""","
    jsonAll = jsonAll & Chr(34) & "hl" & Chr(34) & ":" & Chr(34) & Chr(34)
    jsonAll = jsonAll & "}"
  End If
  RsAll.MoveNext
Loop
jsonAll = jsonAll & "]"
RsAll.Close

' ===============================
' 우측: 현재 수주에 연결된 판재 (tng_sjaSub 기반)
' ===============================
sql = ""
sql = sql & "SELECT DISTINCT s.qtyidx, q.qtyno, q.qtyname, "
sql = sql & "       c.qtyco_idx, c.sheet_w, c.sheet_h, c.sheet_t "
sql = sql & "FROM tng_sjaSub s "
sql = sql & "JOIN tk_qty q ON s.qtyidx = q.qtyidx "
sql = sql & "JOIN tk_qtyco c ON q.qtyno = c.qtyno "
sql = sql & "WHERE s.sjidx='" & sjidx & "' "
sql = sql & "  AND ISNULL(c.sheet_h,0) > 0 "
sql = sql & "ORDER BY q.qtyname, c.sheet_w, c.sheet_h"

Set RsSel = Dbcon.Execute(sql)
jsonSel = "["
firstSel = True
Do While Not RsSel.EOF
  sw = MapSheetW(RsSel("sheet_w"))
  sh = RsSel("sheet_h")
  st = MapSheetT(RsSel("sheet_t"))
  
  If sw <> "" And Not IsNull(sh) And sh <> "" Then
    If Not firstSel Then jsonSel = jsonSel & ","
    firstSel = False
    
    spec = sw & "*" & sh
    
    jsonSel = jsonSel & "{"
    jsonSel = jsonSel & """qtyco_idx"":" & RsSel("qtyco_idx") & ","
    jsonSel = jsonSel & """qtyidx"":" & RsSel("qtyidx") & ","
    jsonSel = jsonSel & """qtyno"":" & RsSel("qtyno") & ","
    jsonSel = jsonSel & """qtyname"":""" & JsonEscape(RsSel("qtyname")) & ""","
    jsonSel = jsonSel & """spec"":""" & spec & ""","
    jsonSel = jsonSel & """sheet_w"":" & sw & ","
    jsonSel = jsonSel & """sheet_h"":" & sh & ","
    jsonSel = jsonSel & """sheet_t"":""" & st & ""","
    jsonSel = jsonSel & """hl"":"""","
    jsonSel = jsonSel & """qty"":100000"
    jsonSel = jsonSel & "}"
  End If
  RsSel.MoveNext
Loop
jsonSel = jsonSel & "]"
RsSel.Close

' ===============================
' 절곡 아이템 목록
' ===============================
sql = ""
sql = sql & "WITH base AS ( "
sql = sql & " SELECT sjidx, baidx, baname, CAST(blength AS INT) blength, "
sql = sql & "        quan, xsize, ysize, sx1, sx2, sy1, sy2, "
sql = sql & "        qtyname, g_bogang, g_busok "
sql = sql & " FROM tk_balju_st "
sql = sql & " WHERE sjidx='" & sjidx & "' AND insert_flag=1 "
sql = sql & "), grp AS ( "
sql = sql & " SELECT MIN(baname) baname, blength, "
sql = sql & "        MIN(quan) quan, COUNT(*) same_xy_count, MIN(baidx) baidx, "
sql = sql & "        MIN(qtyname) qtyname, MIN(g_bogang) g_bogang, MIN(g_busok) g_busok "
sql = sql & " FROM base "
sql = sql & " GROUP BY baidx, baname, blength, xsize, ysize, sx1, sx2, sy1, sy2, qtyname, g_bogang, g_busok "
sql = sql & "), w AS ( "
sql = sql & " SELECT baidx, MAX(accsize) accsize "
sql = sql & " FROM tk_barasisub GROUP BY baidx "
sql = sql & ") "
sql = sql & "SELECT g.baname, g.blength, (g.quan*g.same_xy_count) qty, w.accsize, "
sql = sql & "       g.qtyname, g.g_bogang, g.g_busok "
sql = sql & "FROM grp g LEFT JOIN w ON g.baidx=w.baidx "
sql = sql & "WHERE ISNULL(w.accsize,0)>0 "
sql = sql & "ORDER BY w.accsize DESC, g.blength DESC"

Set RsItems = Dbcon.Execute(sql)
jsonItems = "["
firstItem = True
Do While Not RsItems.EOF
  If Not firstItem Then jsonItems = jsonItems & ","
  firstItem = False
  
  ' 재질 키 결정
  material_key = SafeStr(RsItems("qtyname"))
  g_bogang = SafeNum(RsItems("g_bogang"))
  g_busok = SafeNum(RsItems("g_busok"))
  baname = SafeStr(RsItems("baname"))
  
  If g_bogang = 1 Or g_busok = 1 Then
    material_key = "갈바1.2T"
  ElseIf InStr(baname, "보양") > 0 Then
    material_key = "갈바1.2T"
  ElseIf InStr(baname, "재료") > 0 And InStr(baname, "갈바") = 0 Then
    material_key = "헤어라인 1.2T"
  End If
  
  jsonItems = jsonItems & "{"
  jsonItems = jsonItems & """baname"":""" & JsonEscape(baname) & ""","
  jsonItems = jsonItems & """width"":" & SafeNum(RsItems("accsize")) & ","
  jsonItems = jsonItems & """length"":" & SafeNum(RsItems("blength")) & ","
  jsonItems = jsonItems & """qty"":" & SafeNum(RsItems("qty")) & ","
  jsonItems = jsonItems & """material"":""" & JsonEscape(material_key) & """"
  jsonItems = jsonItems & "}"
  RsItems.MoveNext
Loop
jsonItems = jsonItems & "]"
RsItems.Close

call dbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>네스팅 판재설정</title>
<link rel="stylesheet" href="nesting_main.css">
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
</head>
<body>

<div class="header-bar">
  <div class="header-info">
    <span><b>발주처:</b> <%=h_cname%></span>
    <span><b>수주일:</b> <%=h_sjdate%></span>
    <span><b>수주번호:</b> <%=h_sjnum%></span>
    <span><b>현장:</b> <%=h_cgaddr%></span>
    <span><b>출고일:</b> <%=h_cgdate%></span>
  </div>
  <div class="header-actions">
    <button type="button" id="btnNesting" class="btn-primary">네스팅 실행</button>
    <button type="button" id="btnPrint" class="btn-secondary">절곡수 인쇄</button>
  </div>
</div>

<div class="main-wrap">
  <!-- 좌측: 전체 판재 목록 -->
  <div class="panel panel-left">
    <div class="panel-header">
      <h3>판재 목록</h3>
      <input type="text" id="filterLeft" placeholder="검색..." class="filter-input">
    </div>
    <div id="tableLeft"></div>
  </div>

  <!-- 중앙: 이동 버튼 -->
  <div class="panel-center">
    <button type="button" id="btnMoveRight" class="btn-move">&gt;&gt;</button>
    <button type="button" id="btnMoveLeft" class="btn-move">&lt;&lt;</button>
    <button type="button" id="btnMoveAllRight" class="btn-move">&gt;</button>
    <button type="button" id="btnMoveAllLeft" class="btn-move">&lt;</button>
  </div>

  <!-- 우측: 선택된 판재 목록 -->
  <div class="panel panel-right">
    <div class="panel-header">
      <h3>이동[✓]</h3>
      <span class="selected-count" id="selectedCount">0개 선택</span>
    </div>
    <div id="tableRight"></div>
  </div>
</div>

<script>
// 전역 데이터
const ALL_SHEETS = <%=jsonAll%>;
const SELECTED_SHEETS = <%=jsonSel%>;
const NESTING_ITEMS = <%=jsonItems%>;

// 파라미터
const PARAMS = {
  cidx: "<%=cidx%>",
  sjidx: "<%=sjidx%>",
  sjmidx: "<%=sjmidx%>"
};

// 헤더 정보
const HEADER_INFO = {
  cname: "<%=JsonEscape(h_cname)%>",
  sjdate: "<%=JsonEscape(h_sjdate)%>",
  sjnum: "<%=JsonEscape(h_sjnum)%>",
  cgaddr: "<%=JsonEscape(h_cgaddr)%>",
  cgdate: "<%=JsonEscape(h_cgdate)%>",
  djcgdate: "<%=JsonEscape(h_djcgdate)%>",
  djnum: "<%=JsonEscape(h_djnum)%>"
};
</script>
<script src="nesting_main.js"></script>

</body>
</html>
