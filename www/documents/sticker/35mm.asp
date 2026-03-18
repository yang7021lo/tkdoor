<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

Set Rs  = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")

sjidx = Request("sjidx")

%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>ZT231</title>

<style>
:root{
  --wmm:100;
  --hmm:35;
  --pad:2mm;
  --radius:2.5mm;
  --line:0.2mm;
}

html,body{
  margin:0; padding:0;
  background:#fff;
  font-family: system-ui,-apple-system,"Noto Sans KR","Malgun Gothic",sans-serif;
}

@page label{
  size:100mm 35mm;
  margin:0;

}

.label{
  width:100mm;
  height:35mm;
  padding:2mm 2mm 2mm 0mm;
  margin-left:2mm;
  box-sizing:border-box;
  border-radius:var(--radius);
  background:#fff;
  page:label;
  break-after:always;
  
}

/* ===== TABLE ===== */
table{
  width:100%;
  height:100%;
  border-collapse:collapse;
  table-layout:fixed;
  font-size:3.7mm;
}

th,td{
  border:var(--line) solid #111;
  padding:0.6mm 0.8mm;
  vertical-align:middle;
  overflow:hidden;
  word-break:break-word;
  
}

th{
  background:#f3f4f6;
  font-size:2.3mm;
  font-weight:400;
  text-align:center;
}

td{ font-weight:600; }

.center{ text-align:center; }

.v-vert{
  writing-mode:vertical-rl;
  text-orientation:upright;
  line-height:1;
}

/* ===== TEXT ===== */
.fontY{
  display:block;
  line-height:1.25;
}

/* 2줄 제한 (원래 JS 역할 대체) */
.pname-cell .fontY{
  display:-webkit-box;
  -webkit-box-orient:vertical;
  -webkit-line-clamp:2;
  overflow:hidden;
  
}

/* 크게 써야 하는 칸 */
.td-big .fontY{
  font-size:3.3mm;
  line-height:1.05;
  -webkit-line-clamp:1;
}

@media print{ .label{ outline:none } /* .label::after{display:none} 
</style>
</head>

<body>

<%
' =====================[ 1) 메인 품목 ]=====================
sql = ""
sql = sql & "SELECT DISTINCT "
sql = sql & " c.cname, sja.cgaddr, sja.sjnum, "
sql = sql & " sjs.asub_wichi1 AS loc1, sjs.asub_wichi2 AS loc2, "
sql = sql & " (sb.SJB_barlist + ' ' + sbt.SJB_TYPE_NAME) AS framename, "
sql = sql & " qc.qtyname, p.pname, sjs.quan, "
sql = sql & " fk.fkidx, fk.sjb_type_no, "
sql = sql & " sjs.mwidth, sjs.mheight, "
sql = sql & " sjs.sjsidx, "
sql = sql & " (SELECT COUNT(*) FROM tng_sjaSub s2 "
sql = sql & "  WHERE s2.sjidx=sjs.sjidx AND s2.astatus='1' AND s2.sjsidx < sjs.sjsidx) + 1 AS sunno "
sql = sql & "FROM tng_sjaSub sjs "
sql = sql & "LEFT JOIN tng_sja sja ON sjs.sjidx=sja.sjidx "
sql = sql & "LEFT JOIN tk_customer c ON c.cidx=sja.sjcidx "
sql = sql & "LEFT JOIN tk_framek fk ON sjs.sjsidx=fk.sjsidx "
sql = sql & "LEFT JOIN tng_sjb sb ON sb.sjb_idx=fk.sjb_idx "
sql = sql & "LEFT JOIN tng_sjbtype sbt ON sbt.SJB_TYPE_NO=sb.SJB_TYPE_NO "
sql = sql & "LEFT JOIN tk_qty q ON sjs.qtyidx=q.qtyidx "
sql = sql & "LEFT JOIN tk_qtyco qc ON q.qtyno=qc.qtyno "
sql = sql & "LEFT JOIN tk_paint p ON sjs.pidx=p.pidx "
sql = sql & "WHERE sjs.sjidx=" & CLng(sjidx) & " AND sjs.astatus='1' "

Set Rs = Dbcon.Execute(sql)

Do While Not Rs.EOF

  cname   = Rs("cname")
  cgaddr  = Rs("cgaddr")
  sjnum   = Rs("sjnum")
  loc1    = Rs("loc1")
  loc2    = Rs("loc2")
  framename = Rs("framename")
  qtyname = Rs("qtyname")
  pname   = Rs("pname")
  quan    = Rs("quan")
  fkidx   = Rs("fkidx")
  sjbType = Rs("sjb_type_no")
  mwidth  = Rs("mwidth")
  mheight = Rs("mheight")
  sunno   = Rs("sunno")

  printed7 = False
  printed8 = False

  ' =====================[ 2) 서브 자재 ]=====================
  sql = ""
  sql = sql & "SELECT fks.sunstatus "
  sql = sql & "FROM tk_framekSub fks "
  sql = sql & "WHERE fks.fkidx=" & fkidx & " "
  sql = sql & "AND fks.gls=0 "
  sql = sql & "AND fks.sunstatus IN (0,5,6,7,8)"

  Set Rs1 = Dbcon.Execute(sql)

  Do While Not Rs1.EOF

    sunstatus = Rs1("sunstatus")
    skipThis = False

    If sunstatus = 7 And printed7 Then skipThis = True
    If sunstatus = 8 And printed8 Then skipThis = True

    If sunstatus = 7 Then printed7 = True
    If sunstatus = 8 Then printed8 = True

    If Not skipThis Then

      copies = 1
      If IsNumeric(quan) Then copies = CLng(quan)

      For i = 1 To copies
%>

<section class="label">
<table>
<tbody
<tr>
  <th class="v-vert">업체</th>
  <td colspan="3" class="pname-cell"><span class="fontY"><%=cname%></span></td>
  <th class="v-vert">수주</th>
  <td colspan="3" class="center td-big"><span class="fontY"><%=sjnum%></span></td>
  <th>No.</th>
  <td class="center"><span class="fontY"><%=sunno%></span></td>
</tr>

<tr>
  <th class="v-vert">품명</th>
  <td colspan="3" class="pname-cell"><span class="fontY"><%=framename%></span></td>
  <th class="v-vert">검측</th>
  <td colspan="3" class="center td-big">
    <span class="fontY"><%=mwidth%> × <%=mheight%></span>
  </td>
  <th class="v-vert">수량</th>
  <td class="center"><span class="fontY"><%=quan%>개</span></td>
</tr>

<tr>
  <th class="v-vert">재질</th>
  <td class="pname-cell"><span class="fontY"><%=qtyname%></span></td>
  <th class="v-vert">도장</th>
  <td colspan="3" class="pname-cell"><span class="fontY"><%=pname%></span></td>
  <th class="v-vert">현장</th>
  <td colspan="3" class="pname-cell">
    <span class="fontY"><%=cgaddr%> <%=loc1%> <%=loc2%></span>
  </td>
</tr>
</tbody>
</table>
</section>

<%
      Next
    End If

    Rs1.MoveNext
  Loop
  Rs1.Close

  Rs.MoveNext
Loop

Rs.Close
call dbClose()
%>

</body>
</html>
