<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

sjidx = Request("sjidx")
If sjidx = "" Then
  Response.Write "sjidx 누락"
  Response.End
End If
cidx  = Request("cidx")
sjmidx = Request("sjmidx")

' response.write "<!-- DEBUG cidx=" & cidx & " sjmidx=" & sjmidx & " sjidx=" & sjidx & " -->"


Function J(v)
  If IsNull(v) Then v=""
  v = Replace(v, "\", "\\")
  v = Replace(v, """", "\""")
  J = v
End Function
' ===============================
' 상단 헤더 정보
' ===============================
SQL = ""
SQL = SQL & "SELECT TOP 1 "
SQL = SQL & " cname, sjdate, sjnum, cgaddr, cgdate, djcgdate "
SQL = SQL & "FROM tk_balju_st "
SQL = SQL & "WHERE sjidx='" & sjidx & "' AND insert_flag=1"

Set RsH = Dbcon.Execute(SQL)
If Not RsH.EOF Then
  h_cname    = RsH("cname")
  h_sjdate   = RsH("sjdate")
  h_sjnum    = RsH("sjnum")
  h_cgaddr   = RsH("cgaddr")
  h_cgdate   = RsH("cgdate")
  h_djcgdate = RsH("djcgdate")
End If
RsH.Close

h_djnum = ""

SQL = "SELECT djnum FROM tk_wms_djnum WHERE sjidx='" & sjidx & "'"
Set RsD = Dbcon.Execute(SQL)
If Not RsD.EOF Then
  h_djnum = RsD("djnum")
End If
RsD.Close

' ===============================
' 네스팅 리스트 전용 집계
' ===============================
sql = ""
sql = sql & "WITH base AS ( "
sql = sql & " SELECT sjidx, baidx, baname, CAST(blength AS INT) blength, "
sql = sql & "        quan, xsize, ysize, sx1, sx2, sy1, sy2 "
sql = sql & " FROM tk_balju_st "
sql = sql & " WHERE sjidx='" & sjidx & "' AND insert_flag=1 "
sql = sql & "), grp AS ( "
sql = sql & " SELECT "
sql = sql & "   baidx, "
sql = sql & "   MIN(baname) AS baname, "
sql = sql & "   blength, "
sql = sql & "   COUNT(*) AS same_xy, "
sql = sql & "   MIN(quan) AS quan "
sql = sql & " FROM base "
sql = sql & " GROUP BY baidx, baname, blength, xsize, ysize, sx1, sx2, sy1, sy2 "
sql = sql & "), w AS ( "
sql = sql & " SELECT baidx, MAX(accsize) accsize "
sql = sql & " FROM tk_barasisub GROUP BY baidx "
sql = sql & ") "
sql = sql & "SELECT "
sql = sql & " g.baname, "
sql = sql & " g.blength, "
sql = sql & " (g.quan * g.same_xy) AS qty, "
sql = sql & " ISNULL(w.accsize,0) AS width "
sql = sql & "FROM grp g "
sql = sql & "LEFT JOIN w ON g.baidx=w.baidx "
sql = sql & "WHERE ISNULL(w.accsize,0) > 0 "
sql = sql & "ORDER BY width DESC, blength DESC"

Set Rs = Dbcon.Execute(sql)

json = "["
first = True
Do While Not Rs.EOF
  If Not first Then json = json & ","
  first = False
  json = json & "{"
  json = json & """baname"":""" & J(Rs("baname")) & ""","
  json = json & """width"":" & Rs("width") & ","
  json = json & """length"":" & Rs("blength") & ","
  json = json & """qty"":" & Rs("qty")
  json = json & "}"
  Rs.MoveNext
Loop
json = json & "]"

Rs.Close
call dbClose()
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Nesting List</title>

<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>

<style>
body{
  margin:0;
  font-family:Arial;
  background:#fafafa;
}
#table{
  height:100vh;
}
.topHeader{
  display:flex;
  flex-wrap:wrap;

  /* 🔥 핵심: 상하 간격 압축 */
  padding:4px 10px;      /* 기존 12~16px → 4px */
  row-gap:2px;           /* 줄 간격 최소 */
  column-gap:14px;       /* 좌우만 유지 */

  background:#fff;
  border-bottom:1px solid #ddd;

  font-size:13px;        /* 살짝 축소 */
  line-height:1.2;       /* 🔥 높이 줄이는 핵심 */
}


.topHeader div{
  white-space:nowrap;
}

#table{
  height:calc(100vh - 64px); /* 헤더 높이만큼 빼기 */
}
.topHeader{
  cursor:pointer;
}

.topHeader:hover{
  background:#8080ff;
}
.tabulator-group .grp-count{
  color:#d60000;
  font-weight:700;
}

</style>

<script>
const DATA = <%=json%>;
</script>
</head>

<body>

<div class="topHeader" id="orderHeader">
  <div><b>발주처:</b> <%=h_cname%></div>
  <div><b>수주일자:</b> <%=h_sjdate%></div>
  <div><b>수주번호:</b> <%=h_sjnum%></div>
  <div><b>현장명:</b> <%=h_cgaddr%></div>
  <div><b>출고일자:</b> <%=h_cgdate%></div>
  <div><b>도장출고일:</b> <%=h_djcgdate%></div>
  <div><b>도장번호:</b> <%=h_djnum%></div>
</div>

<div id="table"></div>

<script>
const table = new Tabulator("#table",{
  data: DATA,
  layout: "fitColumns",
  height: "100%",
  groupBy: "width",

    groupHeader:function(value, count){
    return "샤링값 " + value + "mm  <span class='grp-count'>(" + count + "건)</span>";
    },


rowClick:function(e, row){
  row.getTable().deselectRow();
  row.select();

  const d = row.getData();

  if(window.parent && window.parent.selectNestingItem){
    window.parent.selectNestingItem({
      width: Number(d.width),
      length: Number(d.length),
      baname: d.baname
    });
  }
},


  columns:[
    {title:"자재명", field:"baname", widthGrow:3},
    {title:"폭(mm)", field:"width", hozAlign:"right"},
    {title:"길이(mm)", field:"length", hozAlign:"right", sorter:"number"},
    {title:"수량", field:"qty", hozAlign:"right", bottomCalc:"sum"}
  ],
});
</script>

<script>
document.getElementById("orderHeader").addEventListener("click", function () {

  const url = "http://tkd001.cafe24.com/tng1/TNG1_B.asp"
            + "?sjcidx=<%=cidx%>"
            + "&sjmidx=<%=sjmidx%>"
            + "&sjidx=<%=sjidx%>"
            + "&suju_kyun_status=0";

  window.open(url, "_blank");

});
</script>

</body>
</html>
