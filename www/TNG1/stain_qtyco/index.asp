<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>판재 관리 (tk_qtyco)</title>
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
<style>
<!--#include virtual="/common_crud/css/crud.css"-->
</style>
</head>
<body>

<div class="crud-wrap">
  <div id="crud-table"></div>
  <div class="crud-loading">저장 중...</div>
</div>

<script>
window.CRUD_CONFIG = {
  apiUrl: "api.asp",
  tableEl: "#crud-table",
  pk: "qtyco_idx",
  pageSize: 50,

  columns: [
    {field:"qtyco_idx",            title:"IDX",     width:60,  hozAlign:"center", editable:false},
    {field:"QTYNo",                title:"번호",    width:70,  editor:"input"},
    {field:"QTYNAME",              title:"판재명",  width:130, editor:"input"},
    {field:"QTYcoNAME",            title:"회사명",  width:130, editor:"input"},
    {field:"unittype_qtyco_idx",   title:"타입",    width:80,  hozAlign:"center",
      editor:"list",
      editorParams:{values:{"0":"❌","1":"H/L","2":"P/L","3":"갈바","4":"블랙H/L","5":"블랙,골드","6":"바이브_등","7":"브론즈_등","8":"지급판","9":"AL/도장","10":"AL/블랙","11":"헤어1.5"}},
      formatter:function(c){var m={"0":"❌","1":"H/L","2":"P/L","3":"갈바","4":"블랙H/L","5":"블랙,골드","6":"바이브_등","7":"브론즈_등","8":"지급판","9":"AL/도장","10":"AL/블랙","11":"헤어1.5"};return m[c.getValue()]||c.getValue();}
    },
    {field:"QTYcostatus",          title:"사용",    width:50,  hozAlign:"center",
      editor:"list",
      editorParams:{values:{"0":"❌","1":"✅"}},
      formatter:function(c){return c.getValue()=="1"?"✅":"❌";}
    },
    {field:"kg",                   title:"단가(Kg)",width:80,  hozAlign:"right",  editor:"number"},
    {field:"sheet_w",              title:"가로",    width:80,  hozAlign:"center",
      editor:"list",
      editorParams:{values:{"0":"1000(1)","1":"1219(4)"}},
      formatter:function(c){var m={"0":"1000(1)","1":"1219(4)"};return m[c.getValue()]||c.getValue();}
    },
    {field:"sheet_h",              title:"세로",    width:70,  hozAlign:"right",  editor:"number"},
    {field:"sheet_t",              title:"두께",    width:70,  hozAlign:"center",
      editor:"list",
      editorParams:{values:{"0":"❌","1":"0.6t","2":"0.8t","3":"1.2t","4":"1.5t"}},
      formatter:function(c){var m={"0":"❌","1":"0.6t","2":"0.8t","3":"1.2t","4":"1.5t"};return m[c.getValue()]||c.getValue();}
    },
    {field:"coil_cut",             title:"코일",    width:60,  hozAlign:"center", editor:"input"},
    {field:"mename",               title:"수정자",  width:80,  editable:false},
    {field:"QTYcoewdate",          title:"수정일",  width:100, editable:false}
  ],

  // 엑셀 붙여넣기 시 컬럼 매핑 순서 (QTYNo는 서버 자동채번)
  pasteColumns: ["QTYNAME","QTYcoNAME","unittype_qtyco_idx","QTYcostatus","kg","sheet_w","sheet_h","sheet_t","coil_cut"]
};
</script>
<script>
<!--#include virtual="/common_crud/js/crud_core.js"-->
</script>

</body>
</html>
