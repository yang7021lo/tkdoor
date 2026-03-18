<%@ codepage="65001" language="vbscript"%>
<%
On Error Resume Next
Session.CodePage="65001"
Response.CharSet="utf-8"
Server.ScriptTimeout = 300
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
debug_mode = (Request("debug") = "1")
If debug_mode Then
  Response.Write "<pre>DBG entry</pre>"
End If

Sub CheckErr(tag)
  If Err.Number <> 0 Then
    Response.Write "<pre>[ERROR] " & tag & " :: " & Err.Number & " - " & Err.Description & "</pre>"
    Err.Clear
  End If
End Sub

call dbOpen()
On Error Resume Next
Dbcon.CommandTimeout = 300
CheckErr "dbOpen"

cidx  = Request("cidx")
sjidx = Request("sjidx")
sjmidx = Request("sjmidx")
 response.write "<!-- DEBUG PARENT cidx=" & cidx & " sjmidx=" & sjmidx & " sjidx=" & sjidx & " -->"
If debug_mode Then
  Response.Write "<pre>DBG start sjidx=" & sjidx & "</pre>"
End If


If sjidx = "" Then
  Response.Write "<script>alert('sjidx 누락');history.back();</script>"
  Response.End
End If

If Err.Number <> 0 Then
  Response.Write "<pre style='color:#c00'>[ERROR] " & Err.Number & " - " & Err.Description & "</pre>"
  Response.End
End If

' ===============================
' HEADER QTYNAME (from tk_balju_st)
' ===============================
display_qtyname = ""
sql = "SELECT TOP 1 baname, qtyname, g_bogang, g_busok " & _
      "FROM tk_balju_st WHERE sjidx='" & sjidx & "' AND insert_flag=1"
Set RsQty = Dbcon.Execute(sql)
If Not RsQty.EOF Then
  baname = RsQty(0)
  qtyname = RsQty(1)
  g_bogang = RsQty(2)
  g_busok = RsQty(3)

  If IsNull(baname) Then baname = ""
  If IsNull(qtyname) Then qtyname = ""
  If IsNull(g_bogang) Then g_bogang = 0
  If IsNull(g_busok) Then g_busok = 0

  If InStr(baname, "재료") > 0 And InStr(baname, "갈바") = 0 Then
    display_qtyname = "헤어라인 1.2T"
  ElseIf g_bogang = 1 Or g_busok = 1 Then
    display_qtyname = "갈바1.2T"
  ElseIf InStr(baname, "보양") > 0 Then
    display_qtyname = "갈바1.2T"
  Else
    display_qtyname = qtyname
  End If
End If
RsQty.Close
Set RsQty = Nothing

Function MaterialKey(baname, qtyname, g_bogang, g_busok)
  baname = SafeStr(baname)
  qtyname = SafeStr(qtyname)
  g_bogang = SafeNum(g_bogang)
  g_busok = SafeNum(g_busok)

  If g_bogang = 1 Or g_busok = 1 Then
    MaterialKey = "갈바1.2T"
  ElseIf InStr(baname, "보양") > 0 Then
    MaterialKey = "갈바1.2T"
  ElseIf InStr(baname, "재료") > 0 And InStr(baname, "갈바") = 0 Then
    MaterialKey = "헤어라인 1.2T"
  Else
    MaterialKey = qtyname
  End If
End Function

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

Function MapSheetW(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    MapSheetW = ""
  ElseIf CLng(v) = 1 Then
    MapSheetW = 1219
  Else
    MapSheetW = CLng(v)
  End If
End Function

Function MapSheetT(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    MapSheetT = ""
  Else
    Select Case CLng(v)
      Case 3: MapSheetT = "1.2t"
      Case 4: MapSheetT = "1.5t"
      Case Else: MapSheetT = CStr(v) & "t"
    End Select
  End If
End Function

Function SafeNum(v)
  If IsNull(v) Or v = "" Or Not IsNumeric(v) Then
    SafeNum = 0
  Else
    SafeNum = CDbl(v)
  End If
End Function

Function SafeStr(v)
  If IsNull(v) Then
    SafeStr = ""
  Else
    SafeStr = CStr(v)
  End If
End Function

' ===============================
' SHEET OPTIONS (from qty/qtyco)
' ===============================
sheetOptions = ""
defaultSheetValue = ""
defaultSheetLabel = ""

sql = ""
sql = sql & "SELECT DISTINCT c.qtyco_idx, c.sheet_w, c.sheet_h, c.sheet_t, q.qtyname "
sql = sql & "FROM tng_sjaSub s "
sql = sql & "JOIN tk_qty q ON s.qtyidx = q.qtyidx "
sql = sql & "JOIN tk_qtyco c ON q.qtyno = c.qtyno "
sql = sql & "WHERE s.sjidx='" & sjidx & "' "
sql = sql & "  AND ISNULL(c.sheet_h,0) > 0 "
sql = sql & "ORDER BY c.sheet_w, c.sheet_h, c.sheet_t "

Set RsSheet = Dbcon.Execute(sql)
CheckErr "sheetOptions query"
If Err.Number <> 0 Then
  Response.Write "<pre>[ERROR] sheetOptions query :: " & Err.Number & " - " & Err.Description & "</pre>"
  Response.End
End If
Do While Not RsSheet.EOF
  sw = MapSheetW(RsSheet("sheet_w"))
  sh = RsSheet("sheet_h")
  st = MapSheetT(RsSheet("sheet_t"))

  If sw <> "" And Not IsNull(sh) And sh <> "" Then
    sheetValue = sw & "x" & sh
    sheetLabel = sw & "x" & sh
    If st <> "" Then sheetLabel = sheetLabel & " / " & st

    If defaultSheetValue = "" Then
      defaultSheetValue = sheetValue
      defaultSheetLabel = sheetLabel
    End If

    sheetOptions = sheetOptions & "<option value='" & sheetValue & "'>" & sheetLabel & "</option>"
  End If

  RsSheet.MoveNext
Loop
RsSheet.Close
Set RsSheet = Nothing
If debug_mode Then
  Response.Write "<pre>DBG sheetOptions_len=" & Len(sheetOptions) & "</pre>"
End If

sql = ""
sql = sql & "WITH base AS ( "
sql = sql & " SELECT sjidx, baidx, baname, blength, quan, xsize, ysize, sx1, sx2, sy1, sy2 "
sql = sql & "      , qtyname, g_bogang, g_busok "
sql = sql & " FROM tk_balju_st "
sql = sql & " WHERE sjidx='" & sjidx & "' AND insert_flag=1 "
sql = sql & "), grp AS ( "
sql = sql & " SELECT MIN(baname) baname, CAST(blength AS INT) blength, "
sql = sql & " MIN(quan) quan, COUNT(*) same_xy_count, MIN(baidx) baidx, "
sql = sql & " MIN(qtyname) qtyname, "
sql = sql & " MIN(g_bogang) g_bogang, MIN(g_busok) g_busok "
sql = sql & " FROM base "
sql = sql & " GROUP BY baidx, baname, blength, xsize, ysize, sx1, sx2, sy1, sy2, qtyname, g_bogang, g_busok "
sql = sql & "), w AS ( "
sql = sql & " SELECT baidx, MAX(accsize) accsize "
sql = sql & " FROM tk_barasisub GROUP BY baidx "
sql = sql & ") "
sql = sql & "SELECT g.baname, g.blength, (g.quan*g.same_xy_count) qty, w.accsize, "
sql = sql & "       g.qtyname, g.g_bogang, g.g_busok "
sql = sql & "FROM grp g LEFT JOIN w ON g.baidx=w.baidx "
sql = sql & "WHERE ISNULL(w.accsize,0)>0 "
sql = sql & "ORDER BY w.accsize DESC, g.blength DESC"

Set Rs = Dbcon.Execute(sql)
CheckErr "raw items query"
If Err.Number <> 0 Then
  Response.Write "<pre>[ERROR] raw items query :: " & Err.Number & " - " & Err.Description & "</pre>"
  Response.End
End If

json = "["
first = True
rowCount = 0
Do While Not Rs.EOF
  If Not first Then json = json & ","
  first = False
  material_key = MaterialKey(Rs("baname"), Rs("qtyname"), Rs("g_bogang"), Rs("g_busok"))

  json = json & "{"
  json = json & """baname"":""" & JsonEscape(Rs("baname")) & ""","
  json = json & """width"":" & SafeNum(Rs("accsize")) & ","
  json = json & """length"":" & SafeNum(Rs("blength")) & ","
  json = json & """qty"":" & SafeNum(Rs("qty")) & ","
  json = json & """material"":""" & JsonEscape(material_key) & """"
  json = json & "}"
  rowCount = rowCount + 1
  Rs.MoveNext
Loop
json = json & "]"

Rs.Close
call dbClose()
If debug_mode Then
  Response.Write "<pre>DBG raw_items=" & rowCount & "</pre>"
End If
%>

<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>TNG2 Nesting</title>

<link rel="stylesheet" href="/tng2/css/tng2_nesting.css">
<script src="https://cdn.jsdelivr.net/npm/split.js/dist/split.min.js"></script>

<%
Dim jsSheetValue, jsSheetLabel
If defaultSheetValue <> "" Then
  jsSheetValue = defaultSheetValue
Else
  jsSheetValue = "1219x4000"
End If
If defaultSheetLabel <> "" Then
  jsSheetLabel = defaultSheetLabel
Else
  jsSheetLabel = ""
End If
%>
<script>
  const RAW_ITEMS = <%=json%>;
  window.SHEET_VALUE = "<%=jsSheetValue%>";
  window.SHEET_LABEL = "<%=jsSheetLabel%>";
  window.SELECTED_MATERIAL = "";
</script>
</head>

<body>

<div class="topbar">
  <b>네스팅 작업지시서</b>
  <% If display_qtyname <> "" Then %>
    <span style="margin-left:8px;color:#333;font-weight:bold;">[<%=display_qtyname%>]</span>
  <% End If %>

  <button type="button" id="btnSheetSelect">자재선택</button>
  <span id="sheetLabel"></span>
  <div id="materialTabs" class="materialTabs"></div>

  <button id="btnGenerate">네스팅 생성</button>
  <button id="btnPrint">A4 출력</button>

  <span id="stat"></span>
</div>

<div class="wrap">
  <div id="left">
    <iframe src="/tng2/TNG2_nesting_list.asp?cidx=<%=cidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"></iframe>
  </div>
  <div id="right">
    <div id="sheetList" class="sheetList"></div>
  </div>
</div>

<script>
  (function(){
    const btn = document.getElementById("btnSheetSelect");
    btn.addEventListener("click", () => {
      const url = "/tng2/TNG2_nesting_qty_popup.asp?sjidx=<%=sjidx%>&sjmidx=<%=sjmidx%>&cidx=<%=cidx%>";
      window.open(url, "nestingQtyPopup", "width=720,height=520,top=100,left=120");
    });

    const labelEl = document.getElementById("sheetLabel");
    function setLabelFromValue(value, label){
      if(label){
        labelEl.textContent = label;
        return;
      }
      if(!value) return;
      const parts = value.split("x");
      if(parts.length === 2){
        labelEl.textContent = parts[0] + "×" + parts[1];
      }else{
        labelEl.textContent = value;
      }
    }

    setLabelFromValue(window.SHEET_VALUE, window.SHEET_LABEL);

    window.setSheetType = function(payload){
      if(!payload || !payload.value) return;
      window.SHEET_VALUE = payload.value;
      setLabelFromValue(payload.value, payload.label);
    };
  })();
</script>

<script src="/tng2/js/nesting_calc.js"></script>
<script src="/tng2/js/nesting_draw_screen.js"></script>
<script src="/tng2/js/nesting_draw_print.js"></script>
<script src="/tng2/js/tng2_nesting.js"></script>
</body>
</html>
