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

sjidx = Request("sjidx")
If sjidx = "" Then
  Response.Write "<script>alert('sjidx 누락');window.close();</script>"
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

Function JsonEscape(s)
  If IsNull(s) Then s = ""
  s = CStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  JsonEscape = s
End Function

Function SafeNum(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    SafeNum = 0
  Else
    SafeNum = CDbl(v)
  End If
End Function

' 절곡 아이템 조회
sql = ""
sql = sql & "WITH base AS ( "
sql = sql & " SELECT sjidx, baidx, baname, CAST(blength AS INT) blength, "
sql = sql & "        quan, xsize, ysize, sx1, sx2, sy1, sy2, qtyname "
sql = sql & " FROM tk_balju_st "
sql = sql & " WHERE sjidx='" & sjidx & "' AND insert_flag=1 "
sql = sql & "), grp AS ( "
sql = sql & " SELECT MIN(baname) baname, blength, "
sql = sql & "        MIN(quan) quan, COUNT(*) same_xy_count, MIN(baidx) baidx, "
sql = sql & "        MIN(qtyname) qtyname "
sql = sql & " FROM base "
sql = sql & " GROUP BY baidx, baname, blength, xsize, ysize, sx1, sx2, sy1, sy2, qtyname "
sql = sql & "), w AS ( "
sql = sql & " SELECT baidx, MAX(accsize) accsize "
sql = sql & " FROM tk_barasisub GROUP BY baidx "
sql = sql & ") "
sql = sql & "SELECT g.baname, g.blength, (g.quan*g.same_xy_count) qty, w.accsize, g.qtyname "
sql = sql & "FROM grp g LEFT JOIN w ON g.baidx=w.baidx "
sql = sql & "WHERE ISNULL(w.accsize,0)>0 "
sql = sql & "ORDER BY w.accsize DESC, g.blength DESC"

Set Rs = Dbcon.Execute(sql)

jsonItems = "["
first = True
Do While Not Rs.EOF
  If Not first Then jsonItems = jsonItems & ","
  first = False
  
  jsonItems = jsonItems & "{"
  jsonItems = jsonItems & """baname"":""" & JsonEscape(Rs("baname")) & ""","
  jsonItems = jsonItems & """width"":" & SafeNum(Rs("accsize")) & ","
  jsonItems = jsonItems & """length"":" & SafeNum(Rs("blength")) & ","
  jsonItems = jsonItems & """qty"":" & SafeNum(Rs("qty")) & ","
  jsonItems = jsonItems & """qtyname"":""" & JsonEscape(Rs("qtyname")) & """"
  jsonItems = jsonItems & "}"
  Rs.MoveNext
Loop
jsonItems = jsonItems & "]"
Rs.Close

call dbClose()

today_date = Year(Now) & "-" & Right("0" & Month(Now), 2) & "-" & Right("0" & Day(Now), 2)
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>절곡수 인쇄</title>
<link rel="stylesheet" href="nesting_print.css">
</head>
<body>

<button class="print-btn" onclick="window.print()">인쇄하기</button>

<div class="print-page">
  <div class="header">
    <div class="header-left">taegwangdoor</div>
    <div class="header-right">
      <div class="date-row"><b>출고일 :</b> <%=h_cgdate%></div>
      <div class="date-row"><b>인쇄일 :</b> <%=today_date%></div>
    </div>
  </div>

  <div class="info-box">
    <div class="cell"><span class="label">주문일:</span> <%=h_sjdate%></div>
    <div class="cell"><span class="label">번호:</span> <%=h_sjnum%></div>
    <div class="cell"><span class="label">거래처:</span> <%=h_cname%></div>
    <div class="cell"><span class="label">Tel:1566-8591<br>HP:</span></div>
    <div class="cell" style="flex:1;"><span class="label">현장:</span> <%=h_cgaddr%></div>
  </div>

  <div class="table-header">
    <div class="col-material">재질</div>
    <div class="col-no">번호</div>
    <div class="col-spec">폭 × 길이</div>
    <div class="col-qty">= 수량</div>
    <div class="col-material">재질</div>
    <div class="col-no">번호</div>
    <div class="col-spec">폭 × 길이</div>
    <div class="col-qty">= 수량</div>
  </div>

  <div class="content" id="printContent">
    <div class="content-col" id="colLeft"></div>
    <div class="content-col" id="colRight"></div>
  </div>

  <div class="total-row" id="totalRow">총 절곡 수량 : 0</div>

  <div class="footer">
    <span>프로그램 ☞ (주)하이컴텍 1566-8591</span>
    <span>http://hicomtech.co.kr</span>
    <span>PAGE 1/1</span>
  </div>
</div>

<script>
const ITEMS = <%=jsonItems%>;

(function() {
  'use strict';

  // 폭별 그룹핑
  const widthGroups = new Map();
  let totalQty = 0;

  ITEMS.forEach(function(item) {
    const w = item.width;
    if (!widthGroups.has(w)) {
      widthGroups.set(w, { width: w, qtyname: item.qtyname, lengths: new Map() });
    }
    const group = widthGroups.get(w);
    const len = item.length;
    if (!group.lengths.has(len)) {
      group.lengths.set(len, 0);
    }
    group.lengths.set(len, group.lengths.get(len) + item.qty);
    totalQty += item.qty;
  });

  // 폭 내림차순 정렬
  const sortedWidths = Array.from(widthGroups.keys()).sort(function(a, b) {
    return b - a;
  });

  // 그룹 번호 매기기 및 HTML 생성
  const allGroups = [];
  let groupNo = 1;

  sortedWidths.forEach(function(width) {
    const group = widthGroups.get(width);
    const lengths = Array.from(group.lengths.entries()).sort(function(a, b) {
      return b[0] - a[0]; // 길이 내림차순
    });

    allGroups.push({
      no: groupNo++,
      width: width,
      qtyname: group.qtyname,
      lengths: lengths
    });
  });

  // 좌우 컬럼 분배
  const half = Math.ceil(allGroups.length / 2);
  const leftGroups = allGroups.slice(0, half);
  const rightGroups = allGroups.slice(half);

  function renderColumn(groups) {
    let html = '';
    let currentMaterial = '';

    groups.forEach(function(g) {
      // 재질명 표시 (첫 번째만)
      if (g.qtyname !== currentMaterial) {
        currentMaterial = g.qtyname;
        html += '<div class="material-name">' + (currentMaterial || '기타') + '</div>';
      }

      html += '<div class="width-group">';
      html += '<div class="width-row">';
      html += '<div class="width-no">' + g.no + '</div>';
      html += '<div class="width-items">';

      g.lengths.forEach(function(entry, idx) {
        const len = entry[0];
        const qty = entry[1];
        html += '<div class="item-row">';
        if (idx === 0) {
          html += '<span class="item-spec">' + g.width + '*' + len + '</span>';
        } else {
          html += '<span class="item-spec">' + len + '</span>';
        }
        html += '<span class="item-eq">=</span>';
        html += '<span class="item-qty">' + qty + '</span>';
        html += '</div>';
      });

      html += '</div></div></div>';
    });

    return html;
  }

  document.getElementById('colLeft').innerHTML = renderColumn(leftGroups);
  document.getElementById('colRight').innerHTML = renderColumn(rightGroups);
  document.getElementById('totalRow').textContent = '총 절곡 수량 : ' + totalQty;

})();
</script>

</body>
</html>
