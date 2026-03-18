<%@ codepage="65001" language="VBScript" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<html>
<head>
  <title>테이블 스키마 &amp; 조인 시각화 (Print-Friendly A4)</title>
  <style>
    /* 화면용 스타일 */
    .table-box {
      float: left;
      width: 30%;
      margin: 10px;
      border: 1px solid #ccc;
      padding: 8px;
      box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
    }
    .table-box h3 {
      margin-top: 0;
      font-size: 1.1em;
      text-align: center;
    }
    .table-box table {
      width: 100%;
      border-collapse: collapse;
    }
    .table-box th, .table-box td {
      border: 1px solid #ddd;
      padding: 4px;
      font-size: 0.9em;
    }
    .clearfix { clear: both; }
    .joins { margin: 20px; font-size: 1em; page-break-inside: avoid; }
    .joins ul { list-style: none; padding-left: 0; }
    .joins li { margin: 6px 0; }
    pre.sql {
      background: #f8f8f8;
      padding: 10px;
      border: 1px solid #eee;
      overflow-x: auto;
      page-break-inside: avoid;
    }

    /* 프린트 전용 스타일 */
    @page {
      size: A4 portrait;
      margin: 15mm 10mm;
    }
    @media print {
      body {
        margin: 0;
        padding: 0;
        -webkit-print-color-adjust: exact;
      }
      .table-box {
        float: none !important;
        display: inline-block !important;
        width: 48% !important;
        margin: 5px 1% !important;
        box-shadow: none !important;
        page-break-inside: avoid;
      }
      .joins, pre.sql {
        page-break-inside: avoid !important;
      }
      .no-print { display: none !important; }
    }
  </style>
</head>
<body>

  <h1 class="no-print">테이블 스키마 &amp; 조인 시각화</h1>
  <p class="no-print">“인쇄 → PDF” 시 A4 용지에 최적화됩니다.</p>

  <%
    call dbOpen()
    Dim Rs, tables, i, tbl
    Set Rs = Server.CreateObject("ADODB.Recordset")

    ' 스키마 조회할 테이블 목록 확장
    tables = Array( _
      "tng_sja", "tk_member", "tk_customer", _
      "tng_sjaSub", "tng_sjb", "tng_sjbtype" _
    )

    Response.Write "<h2>1. 테이블 스키마</h2>"
    For i = 0 To UBound(tables)
      tbl = tables(i)
      SQL =  "SELECT COLUMN_NAME, DATA_TYPE " _
           & "FROM INFORMATION_SCHEMA.COLUMNS " _
           & "WHERE TABLE_NAME = '" & tbl & "' " _
           & "ORDER BY ORDINAL_POSITION"
      Rs.Open SQL, Dbcon

      Response.Write "<div class='table-box'>"
      Response.Write "<h3>" & tbl & "</h3>"
      Response.Write "<table>"
      Response.Write "<tr><th>컬럼명</th><th>데이터타입</th></tr>"

      Do While Not Rs.EOF
        Response.Write "<tr>"
        Response.Write "<td>" & Rs("COLUMN_NAME") & "</td>"
        Response.Write "<td>" & Rs("DATA_TYPE")   & "</td>"
        Response.Write "</tr>"
        Rs.MoveNext
      Loop

      Response.Write "</table>"
      Response.Write "</div>"
      Rs.Close
    Next
  %>

  <div class="clearfix"></div>

  <h2>2. 테이블 간 조인 관계</h2>
  <div class="joins">
    <ul>
      <li>① <strong>tng_sja</strong>.<em>sjmidx</em> = <strong>tk_member</strong>.<em>midx</em>  (거래처 담당자)</li>
      <li>② <strong>tk_member</strong>.<em>cidx</em> = <strong>tk_customer</strong>.<em>cidx</em> (거래처 회사)</li>
      <li>③ <strong>tng_sja</strong>.<em>meidx</em> = <strong>tk_member</strong>.<em>midx</em>  (수정자)</li>
      <li>④ <strong>tng_sjaSub</strong>.<em>sjb_idx</em> = <strong>tng_sjb</strong>.<em>sjb_idx</em>  (부속 항목)</li>
      <li>⑤ <strong>tng_sjb</strong>.<em>sjb_type_no</em> = <strong>tng_sjbtype</strong>.<em>sjb_type_no</em>  (항목 종류)</li>
    </ul>
  </div>

  <h2>3. 실제 조인 SQL 예시 – Main Query</h2>
  <pre class="sql">
SELECT 
    A.sjdate,
    A.sjnum,
    CONVERT(VARCHAR(10), A.cgdate, 121)    AS cgdate,
    CONVERT(VARCHAR(10), A.djcgdate, 121)  AS djcgdate,
    A.cgtype,
    A.cgaddr,
    A.cgset,
    A.sjmidx,
    A.sjcidx,
    A.midx,
    CONVERT(VARCHAR(10), A.wdate, 121)     AS wdate,
    A.meidx,
    CONVERT(VARCHAR(10), A.mewdate, 121)   AS mewdate,
    A.tsprice,
    A.trate,
    A.tdisprice,
    A.tfprice,
    A.taxprice,
    A.tzprice,
    B.mname                              AS cus_mname,
    C.cname                              AS cus_cname,
    D.mname                              AS our_mname
FROM tng_sja A
    JOIN tk_member  B ON A.sjmidx = B.midx
    JOIN tk_customer C ON B.cidx  = C.cidx
    JOIN tk_member  D ON A.meidx  = D.midx
WHERE A.sjidx = '<%= rsjidx %>'
  </pre>

  <h2>4. 실제 조인 SQL 예시 – Sub Query</h2>
  <pre class="sql">
SELECT 
    A.sjsidx,
    B.sjb_idx,
    F.sjb_type_name,
    A.mwidth,
    A.mheight,
    A.sjsprice,
    A.quan,
    A.sprice,
    A.fprice,
    A.taxrate
FROM tng_sjaSub A
    LEFT JOIN tng_sjb      B ON A.sjb_idx       = B.sjb_idx
    LEFT JOIN tng_sjbtype  F ON B.sjb_type_no   = F.sjb_type_no
WHERE A.sjidx = '<%= rsjidx %>' 
  AND A.astatus = 1
  </pre>

<%
    Set Rs = Nothing
    Dbcon.Close
%>

</body>
</html>
