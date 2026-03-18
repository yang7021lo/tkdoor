<%@ codepage="65001" language="vbscript"%>
<%
On Error Resume Next
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

sjidx  = Request("sjidx")
sjmidx = Request("sjmidx")
cidx   = Request("cidx")
If cidx = "" Then cidx = Request("sjcidx")

If sjidx = "" Then
  Response.Write "<script>alert('sjidx 누락');history.back();</script>"
  Response.End
End If

' 헤더 정보
sql = "SELECT TOP 1 cname, sjdate, sjnum, cgaddr, cgdate " & _
      "FROM tk_balju_st WHERE sjidx='" & sjidx & "' AND insert_flag=1"
Set RsH = Dbcon.Execute(sql)
If Not RsH.EOF Then
  h_cname  = RsH("cname") & ""
  h_sjdate = RsH("sjdate") & ""
  h_sjnum  = RsH("sjnum") & ""
  h_cgaddr = RsH("cgaddr") & ""
  h_cgdate = RsH("cgdate") & ""
End If
RsH.Close
call dbClose()

Function JsonEscape(s)
  If IsNull(s) Then s = ""
  s = CStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  JsonEscape = s
End Function
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>네스팅 결과</title>
<link rel="stylesheet" href="nesting_result.css">
<script src="https://cdn.jsdelivr.net/npm/split.js/dist/split.min.js"></script>
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
</head>
<body>

<div class="topbar">
  <div class="topbar-left">
    <b>네스팅 결과</b>
    <span class="info-text"><%=h_cgaddr%></span>
  </div>
  <div class="topbar-center">
    <div id="materialTabs" class="material-tabs"></div>
    <div id="sheetChips" class="sheet-chips"></div>
  </div>
  <div class="topbar-right">
    <button type="button" id="btnGenerate" class="btn-primary">네스팅 재생성</button>
    <button type="button" id="btnPrint" class="btn-secondary">인쇄</button>
    <button type="button" id="btnBack" class="btn-secondary">판재설정</button>
    <span id="stat" class="stat-text"></span>
  </div>
</div>

<div class="wrap">
  <div id="left" class="panel-left">
    <div id="itemList"></div>
  </div>
  <div id="right" class="panel-right">
    <div id="nestingSummary" class="nesting-summary"></div>
    <div id="sheetList" class="sheet-list"></div>
  </div>
</div>

<script>
// 헤더 정보
const HEADER_INFO = {
  cname: "<%=JsonEscape(h_cname)%>",
  sjdate: "<%=JsonEscape(h_sjdate)%>",
  sjnum: "<%=JsonEscape(h_sjnum)%>",
  cgaddr: "<%=JsonEscape(h_cgaddr)%>",
  cgdate: "<%=JsonEscape(h_cgdate)%>"
};

const PARAMS = {
  cidx: "<%=cidx%>",
  sjidx: "<%=sjidx%>",
  sjmidx: "<%=sjmidx%>"
};

// 세션 스토리지에서 데이터 로드
let NESTING_DATA = null;
try {
  const stored = sessionStorage.getItem("NESTING_DATA");
  if (stored) {
    NESTING_DATA = JSON.parse(stored);
  }
} catch(e) {
  console.error("데이터 로드 실패", e);
}

if (!NESTING_DATA || !NESTING_DATA.items) {
  alert("네스팅 데이터가 없습니다. 판재설정 페이지로 돌아갑니다.");
  location.href = "nesting_main.asp?sjidx=<%=sjidx%>&cidx=<%=cidx%>&sjmidx=<%=sjmidx%>";
}

const RAW_ITEMS = NESTING_DATA ? NESTING_DATA.items : [];
const SELECTED_SHEETS = NESTING_DATA ? NESTING_DATA.sheets : [];
</script>
<script src="nesting_calc.js"></script>
<script src="nesting_draw.js"></script>
<script src="nesting_result.js"></script>

</body>
</html>
