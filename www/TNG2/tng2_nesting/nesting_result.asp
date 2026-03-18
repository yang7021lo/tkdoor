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

If sjidx = "" Then
  Response.Write "<script>alert('sjidx 누락');history.back();</script>"
  Response.End
End If

Function JsonEscape(s)
  If IsNull(s) Then s = ""
  s = CStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  JsonEscape = s
End Function

Function SafeNum(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then SafeNum = 0 Else SafeNum = CDbl(v)
End Function

Function SafeStr(v)
  If IsNull(v) Then SafeStr = "" Else SafeStr = CStr(v)
End Function

' 헤더 정보
sql = "SELECT TOP 1 cname, sjdate, sjnum, cgaddr, cgdate FROM tk_balju_st WHERE sjidx='" & sjidx & "' AND insert_flag=1"
Set RsH = Dbcon.Execute(sql)
If Not RsH.EOF Then
  h_cname  = SafeStr(RsH("cname"))
  h_sjdate = SafeStr(RsH("sjdate"))
  h_sjnum  = SafeStr(RsH("sjnum"))
  h_cgaddr = SafeStr(RsH("cgaddr"))
  h_cgdate = SafeStr(RsH("cgdate"))
End If
RsH.Close

' 부품 데이터 (직접 로드 - sessionStorage 없을 때 대비)
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

jsonItems = "["
first = True
Do While Not RsItems.EOF
  If Not first Then jsonItems = jsonItems & ","
  first = False
  
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

today_date = Year(Now) & "-" & Right("0" & Month(Now), 2) & "-" & Right("0" & Day(Now), 2)
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>네스팅 결과 - 재단도면</title>
<link rel="stylesheet" href="nesting_result.css">
</head>
<body>

<div class="topbar no-print">
  <div class="topbar-left">
    <b>재단도면</b>
    <span><%=h_cgaddr%></span>
  </div>
  <div class="topbar-right">
    <button type="button" id="btnCuttingList" class="btn-secondary">절곡수 인쇄</button>
    <button type="button" id="btnPrint" class="btn-secondary">도면 인쇄</button>
    <button type="button" id="btnBack" class="btn-secondary">판재설정</button>
  </div>
</div>

<div class="print-header">
  <div class="print-title">taegwangdoor</div>
  <div class="print-date">인쇄일 : <%=today_date%></div>
</div>

<div class="info-row">
  <span>주문일 : <%=h_sjdate%></span>
  <span>거래처 : <%=h_cname%></span>
  <span>현장 : <%=h_cgaddr%></span>
</div>

<div class="summary-box" id="summaryBox"></div>

<div id="sheetList" class="sheet-list"></div>

<div class="footer">
  <span>프로그램 ☞ (주)하이컴텍 1566-8591</span>
  <span>http://hicomtech.co.kr</span>
</div>

<script>
const DB_ITEMS = <%=jsonItems%>;
const PARAMS = {sjidx:"<%=sjidx%>",cidx:"<%=cidx%>",sjmidx:"<%=sjmidx%>"};
const HEADER = {cname:"<%=JsonEscape(h_cname)%>",sjdate:"<%=JsonEscape(h_sjdate)%>",cgaddr:"<%=JsonEscape(h_cgaddr)%>"};
</script>
<script src="nesting_calc.js"></script>
<script src="nesting_draw.js"></script>
<script src="nesting_result.js"></script>
</body>
</html>
