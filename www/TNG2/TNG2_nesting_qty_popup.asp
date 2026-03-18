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
  Response.Write "<script>alert('sjidx 누락');window.close();</script>"
  Response.End
End If

If LCase(Request("action")) = "save" Then
  Response.ContentType = "application/json"
  Response.Clear
  qtyidx_in = Trim(Request("qtyidx"))
  sheet_w_in = Trim(Request("sheet_w"))
  sheet_h_in = Trim(Request("sheet_h"))
  sheet_t_in = Trim(Request("sheet_t"))

  If qtyidx_in = "" Or sheet_w_in = "" Or sheet_h_in = "" Then
    Response.Write "{""ok"":false,""msg"":""invalid""}"
    Response.End
  End If

  If Not IsNumeric(qtyidx_in) Or Not IsNumeric(sheet_w_in) Or Not IsNumeric(sheet_h_in) Or (sheet_t_in <> "" And Not IsNumeric(sheet_t_in)) Then
    Response.Write "{""ok"":false,""msg"":""invalid""}"
    Response.End
  End If

  sql = ""
  sql = sql & "SELECT TOP 1 QTYNo, QTYNAME FROM tk_qty WHERE qtyidx=" & CLng(qtyidx_in)
  Set RsQ = Dbcon.Execute(sql)
  If RsQ.EOF Then
    Response.Write "{""ok"":false,""msg"":""qty_not_found""}"
    Response.End
  End If
  QTYNo = RsQ(0)
  QTYNAME = RsQ(1)
  RsQ.Close
  Set RsQ = Nothing

  sheet_w_code = CLng(sheet_w_in)
  If sheet_w_code = 1219 Then sheet_w_code = 1
  If sheet_w_code = 1000 Then sheet_w_code = 0

  sql = ""
  On Error Resume Next
  ' qtyco_idx 수동 부여 (PK 대비)
  sql2 = "SELECT ISNULL(MAX(qtyco_idx),0)+1 FROM tk_qtyco"
  Set RsNew = Dbcon.Execute(sql2)
  new_qtyco_idx = RsNew(0)
  RsNew.Close
  Set RsNew = Nothing

  sql = ""
  sql = sql & "INSERT INTO tk_qtyco (qtyco_idx, QTYNo, QTYNAME, QTYcoNAME, QTYcostatus, "
  sql = sql & "sheet_w, sheet_h, sheet_t, is_special) "
  sql = sql & "VALUES ("
  sql = sql & CLng(new_qtyco_idx) & ","
  sql = sql & CLng(QTYNo) & ","
  sql = sql & "'" & Replace(QTYNAME, "'", "''") & "',"
  sql = sql & "'(특수치수자재)',"
  sql = sql & "1,"
  sql = sql & sheet_w_code & ","
  sql = sql & CLng(sheet_h_in) & ","
  If sheet_t_in = "" Then
    sql = sql & "NULL,"
  Else
    sql = sql & CLng(sheet_t_in) & ","
  End If
  sql = sql & "1"
  sql = sql & ")"

  Dbcon.Execute sql
  If Err.Number <> 0 Then
    Response.Write "{""ok"":false,""msg"":""" & Replace(Err.Description, """", "'") & """}"
    Response.End
  End If
  Response.Write "{""ok"":true}"
  Response.End
End If

Function MapSheetW(v)
  If IsNull(v) Or v = "" Then
    MapSheetW = ""
  ElseIf CLng(v) = 1 Then
    MapSheetW = 1219
  Else
    MapSheetW = CLng(v)
  End If
End Function

Function MapSheetT(v)
  If IsNull(v) Or v = "" Then
    MapSheetT = ""
  Else
    Select Case CLng(v)
      Case 3: MapSheetT = "1.2t"
      Case 4: MapSheetT = "1.5t"
      Case Else: MapSheetT = CStr(v) & "t"
    End Select
  End If
End Function

sql = ""
sql = sql & "SELECT DISTINCT q.qtyidx, q.qtyname, c.qtyco_idx, c.sheet_w, c.sheet_h, c.sheet_t, c.is_special "
sql = sql & "FROM tng_sjaSub s "
sql = sql & "JOIN tk_qty q ON s.qtyidx = q.qtyidx "
sql = sql & "JOIN tk_qtyco c ON q.qtyno = c.qtyno "
sql = sql & "WHERE s.sjidx='" & sjidx & "' "
sql = sql & "  AND ISNULL(c.sheet_h,0) > 0 "
sql = sql & "ORDER BY q.qtyname, c.is_special, c.sheet_w, c.sheet_h, c.sheet_t "

Set Rs = Dbcon.Execute(sql)

' qty option list
qtyOptions = ""
sql = ""
sql = sql & "SELECT DISTINCT q.qtyidx, q.qtyname "
sql = sql & "FROM tng_sjaSub s "
sql = sql & "JOIN tk_qty q ON s.qtyidx = q.qtyidx "
sql = sql & "WHERE s.sjidx='" & sjidx & "' "
sql = sql & "ORDER BY q.qtyname "
Set RsOpt = Dbcon.Execute(sql)
Do While Not RsOpt.EOF
  qtyOptions = qtyOptions & "<option value='" & RsOpt("qtyidx") & "'>" & RsOpt("qtyname") & "</option>"
  RsOpt.MoveNext
Loop
RsOpt.Close
Set RsOpt = Nothing

' width / thickness option list
Set dictW = Server.CreateObject("Scripting.Dictionary")
Set dictT = Server.CreateObject("Scripting.Dictionary")
If Not Rs.EOF Then
  Rs.MoveFirst
  Do While Not Rs.EOF
    sw = MapSheetW(Rs("sheet_w"))
    st = MapSheetT(Rs("sheet_t"))
    If sw <> "" Then
      If Not dictW.Exists(CStr(sw)) Then dictW.Add CStr(sw), True
    End If
    If st <> "" Then
      If Not dictT.Exists(CStr(st)) Then dictT.Add CStr(st), True
    End If
    Rs.MoveNext
  Loop
  Rs.MoveFirst
End If

widthOptions = ""
For Each k In dictW.Keys
  widthOptions = widthOptions & "<option value='" & k & "'>" & k & "</option>"
Next
thickOptions = ""
For Each k In dictT.Keys
  thickOptions = thickOptions & "<option value='" & k & "'>" & k & "</option>"
Next
Set dictW = Nothing
Set dictT = Nothing
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>샤링판재선택</title>
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<script src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
<style>
  body{margin:0;font-family:Arial;background:#f6f6f6;}
  .wrap{display:flex;height:100vh;}
  .left{flex:1;padding:12px;overflow:auto;background:#fff;border-right:1px solid #ddd;}
  .right{width:320px;padding:12px;}
  h3{margin:0 0 8px 0;font-size:16px;}
  .field{margin-bottom:10px;}
  .field label{display:block;font-size:12px;color:#666;margin-bottom:4px;}
  .field input{width:100%;padding:6px 8px;font-size:14px;}
  .btns{display:flex;gap:8px;}
  button{padding:8px 10px;font-size:14px;cursor:pointer;}
  .note{font-size:12px;color:#888;margin-top:6px;}
  #filterBox{width:100%;padding:6px 8px;font-size:13px;margin-bottom:8px;}
</style>
</head>
<body>

<div class="wrap">
  <div class="left">
    <h3>샤링리스트</h3>
    <input id="filterBox" type="text" placeholder="">
    <div id="qtycoTable"></div>
  </div>

  <div class="right">
    <h3>선택/직접 입력</h3>
    <div class="field">
      <label>판재</label>
      <select id="inputQty" style="width:100%;padding:6px 8px;font-size:14px;">
        <%=qtyOptions%>
      </select>
    </div>
    <div class="field">
      <label>폭 (mm)</label>
      <select id="inputW" style="width:100%;padding:6px 8px;font-size:14px;">
        <option value="">선택</option>
        <%=widthOptions%>
      </select>
    </div>
    <div class="field">
      <label>길이 (mm)</label>
      <input type="text" id="inputH" placeholder="?? 4000">
    </div>
    <div class="field">
      <label>두께</label>
      <select id="inputT" style="width:100%;padding:6px 8px;font-size:14px;">
        <option value="">선택</option>
        <%=thickOptions%>
      </select>
    </div>
    <div class="btns">
      <button type="button" id="btnApply">적용</button>
      <button type="button" onclick="window.close()">닫기</button>
    </div>
    <div class="note">좌측 목록 클릭 또는 직접 입력 후 적용</div>
  </div>
</div>

<script>
  try{ window.resizeTo(720,520); }catch(e){}
  const inputQty = document.getElementById("inputQty");
  const inputW = document.getElementById("inputW");
  const inputH = document.getElementById("inputH");
  const inputT = document.getElementById("inputT");

  const qtyMap = {};
  Array.from(inputQty.options).forEach(o => {
    if(o.value) qtyMap[o.value] = o.textContent;
  });

  const DATA = [
  <%
    first = True
    Rs.MoveFirst
    Do While Not Rs.EOF
      sw = MapSheetW(Rs("sheet_w"))
      sh = Rs("sheet_h")
      st = MapSheetT(Rs("sheet_t"))
      qtyname = Rs("qtyname")

      If sw <> "" And Not IsNull(sh) And sh <> "" Then
        If Not first Then Response.Write ","
        first = False
        Response.Write "{"
        qtyidx = Rs("qtyidx")
        is_special = Rs("is_special")
        Response.Write """qtyidx"":" & qtyidx & ","
        Response.Write """qtyname"":""" & qtyname & ""","
        Response.Write """w"":" & sw & ","
        Response.Write """h"":" & sh & ","
        Response.Write """t"":""" & st & ""","
        Response.Write """special"":" & is_special
        Response.Write "}"
      End If
      Rs.MoveNext
    Loop
    Rs.Close
    call dbClose()
  %>
  ];

  const table = new Tabulator("#qtycoTable",{
    data: DATA,
    layout: "fitColumns",
    height: "calc(100vh - 120px)",
    selectable:true,
    columns:[
      {formatter:"rowSelection", titleFormatter:"rowSelection", hozAlign:"center", headerSort:false, width:40, cellClick:function(e, cell){
        cell.getRow().toggleSelect();
      }},
      {title:"재질", field:"qtyname", widthGrow:2},
      {title:"규격", field:"size", width:120, formatter:function(cell){
        const d = cell.getRow().getData();
        return `${d.w}×${d.h}`;
      }},
      {title:"두께", field:"t", width:80},
      {title:"특수치수자재", field:"special", width:60, formatter:function(cell){
        return cell.getValue() ? "O" : "";
      }}
    ],
    rowClick:function(e, row){
      const d = row.getData();
      if(d.qtyidx) inputQty.value = d.qtyidx;
      inputW.value = d.w || "";
      inputH.value = d.h || "";
      inputT.value = d.t || "";
      row.toggleSelect();
    }
  });

  document.getElementById("filterBox").addEventListener("input", (e) => {
    const v = e.target.value.trim();
    if(!v){
      table.clearFilter();
      return;
    }
    table.setFilter([
      [
        {field:"qtyname", type:"like", value:v},
        {field:"t", type:"like", value:v},
        {field:"w", type:"like", value:v},
        {field:"h", type:"like", value:v},
      ]
    ]);
  });

  document.getElementById("btnApply").addEventListener("click", () => {
    const qtyidx = inputQty.value;
    const w = Number(inputW.value);
    const h = Number(inputH.value);
    const t = (inputT.value || "").trim();

    if(!qtyidx){
      alert("자재를 선택하세요.");
      return;
    }
    if(!w || !h){
      alert("폭/길이를 입력하세요.");
      return;
    }

    let tCode = "";
    if(t){
      if(t.indexOf("1.2") >= 0) tCode = "3";
      else if(t.indexOf("1.5") >= 0) tCode = "4";
      else if(t.indexOf("0.6") >= 0) tCode = "1";
      else if(t.indexOf("0.8") >= 0) tCode = "2";
      else if(!isNaN(Number(t))) tCode = String(Number(t));
    }

    const params = new URLSearchParams();
    params.set("action","save");
    params.set("sjidx","<%=sjidx%>");
    params.set("qtyidx", qtyidx);
    params.set("sheet_w", String(w));
    params.set("sheet_h", String(h));
    if(tCode !== "") params.set("sheet_t", tCode);

    fetch(location.pathname + "?" + params.toString(), { method:"POST" })
      .then(r => r.text().then(t => ({ ok: r.ok, text: t })))
      .then(({ok, text}) => {
        let res = null;
        try { res = JSON.parse(text); } catch(e) { res = { ok:false, msg:text }; }
        if(!ok || !res.ok){
          alert("저장 실패: " + (res.msg || "unknown"));
          return;
        }
        const rowData = {
          qtyidx: Number(qtyidx),
          qtyname: qtyMap[qtyidx] || "",
          w,
          h,
          t: t || "",
          special: 1
        };
        table.addData([rowData], true);
        table.deselectRow();
        const row = table.getRows().find(r => {
          const d = r.getData();
          return d.qtyidx === rowData.qtyidx && d.w === rowData.w && d.h === rowData.h && d.t === rowData.t;
        });
        if(row) row.select();
        const value = `${w}x${h}`;
        const label = `${w}×${h}` + (t ? ` / ${t}` : "");
        if(window.opener && window.opener.setSheetType){
          window.opener.setSheetType({ value, label, thickness: t });
        }
      })
      .catch(() => alert("저장 실패"));
  });
</script>

</body>
</html>

