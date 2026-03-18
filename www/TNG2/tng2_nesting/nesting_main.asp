<%@ codepage="65001" language="vbscript"%>
<%
On Error Resume Next
Session.CodePage="65001"
Response.CharSet="utf-8"
Server.ScriptTimeout = 300

debug_mode = (Request("debug") = "1")

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
call dbOpen()
CheckErr "dbOpen"
Dbcon.CommandTimeout = 300

sjidx  = Request("sjidx")
sjmidx = Request("sjmidx")
cidx   = Request("cidx")
If cidx = "" Then cidx = Request("sjcidx")

If debug_mode Then 
  Response.Write "<pre>sjidx=" & sjidx & " cidx=" & cidx & "</pre>"
End If

If sjidx = "" Then
  Response.Write "<script>alert('sjidx 누락');history.back();</script>"
  Response.End
End If

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

' ===============================
' 헤더 정보
' ===============================
sql = "SELECT TOP 1 cname, sjdate, sjnum, cgaddr, cgdate FROM tk_balju_st WHERE sjidx='" & sjidx & "' AND insert_flag=1"
Set RsH = Dbcon.Execute(sql)
CheckErr "header"
If Not RsH.EOF Then
  h_cname  = SafeStr(RsH("cname"))
  h_sjdate = SafeStr(RsH("sjdate"))
  h_sjnum  = SafeStr(RsH("sjnum"))
  h_cgaddr = SafeStr(RsH("cgaddr"))
  h_cgdate = SafeStr(RsH("cgdate"))
End If
RsH.Close

' ===============================
' 좌측: 전체 판재 마스터 (tk_qty + tk_qtyco)
' ===============================
sql = "SELECT q.qtyidx, q.qtyno, q.qtyname, c.qtyco_idx, c.sheet_w, c.sheet_h, c.sheet_t " & _
      "FROM tk_qty q JOIN tk_qtyco c ON q.qtyno = c.qtyno " & _
      "WHERE ISNULL(c.sheet_h,0) > 0 AND c.QTYcostatus = 1 " & _
      "ORDER BY q.qtyname, c.sheet_h DESC"

Set RsAll = Dbcon.Execute(sql)
CheckErr "allPlates"

jsonAll = "["
firstAll = True
Do While Not RsAll.EOF
  sw = RsAll("sheet_w")
  If IsNull(sw) Or sw = "" Then sw = 1219
  If CLng(sw) = 1 Then sw = 1219
  
  sh = RsAll("sheet_h")
  st = RsAll("sheet_t")
  If IsNull(st) Or st = "" Then 
    stLabel = ""
  Else
    Select Case CLng(st)
      Case 3: stLabel = "1.2T"
      Case 4: stLabel = "1.5T"
      Case Else: stLabel = CStr(st) & "T"
    End Select
  End If
  
  If Not IsNull(sh) And sh <> "" Then
    If Not firstAll Then jsonAll = jsonAll & ","
    firstAll = False
    
    jsonAll = jsonAll & "{"
    jsonAll = jsonAll & """qtyco_idx"":" & RsAll("qtyco_idx") & ","
    jsonAll = jsonAll & """qtyidx"":" & RsAll("qtyidx") & ","
    jsonAll = jsonAll & """qtyname"":""" & JsonEscape(RsAll("qtyname")) & ""","
    jsonAll = jsonAll & """width"":" & sw & ","
    jsonAll = jsonAll & """length"":" & sh & ","
    jsonAll = jsonAll & """spec"":""" & sw & "*" & sh & ""","
    jsonAll = jsonAll & """thickness"":""" & stLabel & ""","
    jsonAll = jsonAll & """qty"":100000"
    jsonAll = jsonAll & "}"
  End If
  RsAll.MoveNext
Loop
jsonAll = jsonAll & "]"
RsAll.Close

' ===============================
' 우측: 현재 수주 연결 판재
' ===============================
sql = "SELECT DISTINCT q.qtyidx, q.qtyno, q.qtyname, c.qtyco_idx, c.sheet_w, c.sheet_h, c.sheet_t " & _
      "FROM tng_sjaSub s " & _
      "JOIN tk_qty q ON s.qtyidx = q.qtyidx " & _
      "JOIN tk_qtyco c ON q.qtyno = c.qtyno " & _
      "WHERE s.sjidx='" & sjidx & "' AND ISNULL(c.sheet_h,0) > 0 " & _
      "ORDER BY q.qtyname, c.sheet_h DESC"

Set RsSel = Dbcon.Execute(sql)
CheckErr "selectedPlates"

jsonSel = "["
firstSel = True
Do While Not RsSel.EOF
  sw = RsSel("sheet_w")
  If IsNull(sw) Or sw = "" Then sw = 1219
  If CLng(sw) = 1 Then sw = 1219
  
  sh = RsSel("sheet_h")
  st = RsSel("sheet_t")
  If IsNull(st) Or st = "" Then 
    stLabel = ""
  Else
    Select Case CLng(st)
      Case 3: stLabel = "1.2T"
      Case 4: stLabel = "1.5T"
      Case Else: stLabel = CStr(st) & "T"
    End Select
  End If
  
  If Not IsNull(sh) And sh <> "" Then
    If Not firstSel Then jsonSel = jsonSel & ","
    firstSel = False
    
    jsonSel = jsonSel & "{"
    jsonSel = jsonSel & """qtyco_idx"":" & RsSel("qtyco_idx") & ","
    jsonSel = jsonSel & """qtyidx"":" & RsSel("qtyidx") & ","
    jsonSel = jsonSel & """qtyname"":""" & JsonEscape(RsSel("qtyname")) & ""","
    jsonSel = jsonSel & """width"":" & sw & ","
    jsonSel = jsonSel & """length"":" & sh & ","
    jsonSel = jsonSel & """spec"":""" & sw & "*" & sh & ""","
    jsonSel = jsonSel & """thickness"":""" & stLabel & ""","
    jsonSel = jsonSel & """qty"":100000"
    jsonSel = jsonSel & "}"
  End If
  RsSel.MoveNext
Loop
jsonSel = jsonSel & "]"
RsSel.Close

' ===============================
' 부품 데이터 (절곡 아이템)
' ===============================
sql = "WITH base AS ( " & _
      " SELECT baidx, baname, CAST(blength AS INT) blength, quan, xsize, ysize, sx1, sx2, sy1, sy2, qtyname " & _
      " FROM tk_balju_st WHERE sjidx='" & sjidx & "' AND insert_flag=1 " & _
      "), grp AS ( " & _
      " SELECT MIN(baname) baname, blength, MIN(quan) quan, COUNT(*) same_xy, MIN(baidx) baidx, MIN(qtyname) qtyname " & _
      " FROM base GROUP BY baidx, baname, blength, xsize, ysize, sx1, sx2, sy1, sy2, qtyname " & _
      "), w AS ( " & _
      " SELECT baidx, MAX(accsize) accsize FROM tk_barasisub GROUP BY baidx " & _
      ") " & _
      "SELECT g.baname, g.blength, (g.quan*g.same_xy) qty, w.accsize, g.qtyname " & _
      "FROM grp g LEFT JOIN w ON g.baidx=w.baidx " & _
      "WHERE ISNULL(w.accsize,0)>0 " & _
      "ORDER BY w.accsize DESC, g.blength DESC"

Set RsItems = Dbcon.Execute(sql)
CheckErr "items"

jsonItems = "["
firstItem = True
Do While Not RsItems.EOF
  If Not firstItem Then jsonItems = jsonItems & ","
  firstItem = False
  
  jsonItems = jsonItems & "{"
  jsonItems = jsonItems & """baname"":""" & JsonEscape(RsItems("baname")) & ""","
  jsonItems = jsonItems & """width"":" & SafeNum(RsItems("accsize")) & ","
  jsonItems = jsonItems & """length"":" & SafeNum(RsItems("blength")) & ","
  jsonItems = jsonItems & """qty"":" & SafeNum(RsItems("qty")) & ","
  jsonItems = jsonItems & """material"":""" & JsonEscape(RsItems("qtyname")) & """"
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
<title>네스팅 - 판재설정</title>
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
<link rel="stylesheet" href="nesting_main.css">
</head>
<body>

<div class="header-bar">
  <div class="header-left">
    <b>네스팅 판재설정</b>
    <span class="header-info"><%=h_cgaddr%> | <%=h_cname%> | <%=h_sjdate%></span>
  </div>
  <div class="header-right">
    <button type="button" id="btnNesting" class="btn-primary">네스팅 실행</button>
  </div>
</div>

<div class="main-wrap">
  <div class="panel panel-left">
    <div class="panel-header">
      <h3>판재 목록</h3>
      <input type="text" id="filterLeft" placeholder="검색..." class="filter-input">
    </div>
    <div id="tableLeft"></div>
  </div>

  <div class="panel-center">
    <button type="button" id="btnMoveRight" class="btn-move">>></button>
    <button type="button" id="btnMoveLeft" class="btn-move"><<</button>
  </div>

  <div class="panel panel-right">
    <div class="panel-header">
      <h3>선택된 판재 (이동[✓])</h3>
      <span id="selectedCount" class="badge">0개</span>
    </div>
    <div id="tableRight"></div>
  </div>
</div>

<script>
const ALL_PLATES = <%=jsonAll%>;
const SELECTED_PLATES = <%=jsonSel%>;
const PART_ITEMS = <%=jsonItems%>;
const PARAMS = {
  sjidx: "<%=sjidx%>",
  cidx: "<%=cidx%>",
  sjmidx: "<%=sjmidx%>"
};
const HEADER = {
  cname: "<%=JsonEscape(h_cname)%>",
  sjdate: "<%=JsonEscape(h_sjdate)%>",
  cgaddr: "<%=JsonEscape(h_cgaddr)%>",
  cgdate: "<%=JsonEscape(h_cgdate)%>"
};
</script>
<script src="nesting_main.js"></script>
</body>
</html>
