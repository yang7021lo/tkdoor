<%@ codepage="65001" language="vbscript"%>
<meta charset="utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!DOCTYPE html>
<html>
<head>
  <title>판재 엑셀형 관리</title>

  <!-- Tabulator -->
  <link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
  <script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>

  <link href="stain_qtyco.css" rel="stylesheet">
</head>

<body>
<h3>판재 엑셀형 CRUD</h3>

<div id="qtyco-table"></div>

<script>
window.APP_CONFIG = {
  table: "tk_qtyco",
  pk: "qtyco_idx"
};
</script>

<script src="js/query.js"></script>
<script src="js/table.js"></script>
<script src="js/calc.js"></script>

</body>
</html>
