<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
Response.Buffer   = True
%>

<!--#include virtual="/inc/dbcon.asp"-->

<%
Call dbOpen()

Function Nz(v)
  If IsNull(v) Then Nz = "" Else Nz = Trim(CStr(v))
End Function

Function SqlEsc(s)
  s = Nz(s)
  SqlEsc = Replace(s, "'", "''")
End Function

Dim Rs, RsManual, SQL, SQLM
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsManual = Server.CreateObject("ADODB.Recordset")

Dim ymd
ymd = Trim(Request("ymd"))
If ymd = "" Then ymd = Date()

' =========================
' (1) 기존: tk_wms_meta 리스트 (유지)
' =========================
SQL = ""
SQL = SQL & "SELECT DISTINCT wms_idx, recv_name, wms_type, sjidx "
SQL = SQL & "FROM tk_wms_meta "
SQL = SQL & "WHERE actual_ship_dt = '" & SqlEsc(ymd) & "' "
SQL = SQL & "AND wms_type IN (1,17,18,19) "
SQL = SQL & "ORDER BY recv_name "

Rs.Open SQL, DbCon, 1, 1

' =========================
' (2) 추가: tk_wms_dashboard_manual 리스트
'  - ymd 동일일자
'  - wms_type 1/17/18/19만
'  - item_text 를 item_name(표시용)으로 사용
' =========================
SQLM = ""
SQLM = SQLM & "SELECT manual_idx, ymd, wms_type, recv_name, item_name "
SQLM = SQLM & "FROM dbo.tk_wms_dashboard_manual WITH (NOLOCK) "
SQLM = SQLM & "WHERE is_active=1 "
SQLM = SQLM & "  AND ymd = '" & SqlEsc(ymd) & "' "
SQLM = SQLM & "  AND wms_type IN (1,17,18,19) "
SQLM = SQLM & "ORDER BY recv_name "

RsManual.Open SQLM, DbCon, 1, 1
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>화물 수탁증 입력</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f4f6f9; font-size:18px; line-height:1.6; }
.section { background:#fff; border-radius:14px; padding:16px; margin-bottom:16px; }
.section-title { font-weight:800; font-size:20px; margin-bottom:12px; }
.summary-box { border:2px solid #0d6efd; background:#eef4ff; }
.recv-btn { width:100%; padding:16px; font-size:18px; margin-bottom:10px; border-radius:12px; text-align:left; }
.recv-btn.selected { background-color: #0d6efd; color: #fff; border-color: #0d6efd;}
.muted-hint { color:#6c757d; font-size:14px; }

.box-control { display:flex; align-items:center; justify-content:space-between; gap:10px; }
.box-control button { width:70px; height:56px; font-size:26px; }
.box-control input { height:56px; font-size:22px; text-align:center; }

.slot-card { border:2px solid #dee2e6; border-radius:14px; padding:14px; margin-bottom:12px; background:#fff; }
.slot-card select { font-size:18px; height:56px; }

.badge-manual{ background:#6f42c1; }
.badge-meta{ background:#0d6efd; }
</style>

<script>
var ymd = "<%=Replace(Trim(Request("ymd")),"""","")%>";
</script>
</head>

<body>
<div class="container-fluid p-3 pb-5">

<h4 class="fw-bold mb-3">화물 수탁증 입력</h4>

<!-- ① 수탁자 선택 -->
<div class="section">
  <div class="section-title">① 수탁자 선택</div>

  <input type="text" id="searchRecv" class="form-control mb-3"
         placeholder="수탁자명 검색"
         onkeyup="filterRecv();"
         style="font-size:18px;height:56px;">

  <div id="recvList">

    <!-- (A) 기존 meta 목록 -->
    <div class="muted-hint mb-2">[기존 출고건]</div>
    <%
      Do Until Rs.EOF
        Dim cargo_status
        cargo_status = 0
        If Not IsNull(Rs("wms_type")) And Rs("wms_type") <> "" Then
          If CInt(Rs("wms_type")) = 12 Then cargo_status = 1
        End If
    %>
      <button type="button"
              class="btn btn-outline-primary recv-btn recv-item"
              data-kind="meta"
              data-wms-idx="<%=Rs("wms_idx")%>"
              data-sjidx="<%=CLng(0 & Rs("sjidx"))%>"
              data-name="<%=Server.HTMLEncode("" & Rs("recv_name"))%>"
              data-wms-type="<%=CLng(0 & Rs("wms_type"))%>"
              data-cargo-status="<%=cargo_status%>"
              onclick="selectRecv(this);">
        
        <%=Server.HTMLEncode("" & Rs("recv_name"))%>
      </button>
    <%
        Rs.MoveNext
      Loop
    %>

    <!-- (B) 추가 manual 목록 -->
    <div class="muted-hint mt-3 mb-2">[수동 출고건]</div>
    <%
      If RsManual.BOF And RsManual.EOF Then
        Response.Write "<div class='muted-hint'>수동 출고 데이터가 없습니다.</div>"
      Else
        Do Until RsManual.EOF
          Dim m_manual_idx, m_recv_name, m_wms_type, m_item_name
          m_manual_idx = CLng(0 & RsManual("manual_idx"))
          m_recv_name  = Nz(RsManual("recv_name"))
          m_wms_type   = CLng(0 & RsManual("wms_type"))
          m_item_name  = Nz(RsManual("item_name")) ' 여기서 item_name으로 씀(표시/framename 대체)
    %>
      <button type="button"
              class="btn btn-outline-secondary recv-btn recv-item"
              data-kind="manual"
              data-manual-idx="<%=m_manual_idx%>"
              data-name="<%=Server.HTMLEncode(m_recv_name)%>"
              data-wms-type="<%=m_wms_type%>"
              data-item-name="<%=Server.HTMLEncode(m_item_name)%>"
              onclick="selectRecv(this);">
        
        <div class="fw-bold"><%=Server.HTMLEncode(m_recv_name)%></div>
        <div class="muted-hint" style="margin-top:4px;">
          품목명: <%=Server.HTMLEncode(m_item_name)%>
        </div>
      </button>
    <%
          RsManual.MoveNext
        Loop
      End If
    %>

  </div>
</div>

<!-- 요약 -->
<div class="section summary-box" id="summaryBox">
  <div class="section-title">현재 선택</div>
  <div><strong>구분 :</strong> <span id="sumKind">-</span></div>
  <div><strong>수탁자 :</strong> <span id="sumRecv">미선택</span></div>
  <div><strong>품목명 :</strong> <span id="sumItem">-</span></div>
  <div><strong>박스 수량 :</strong> <span id="sumBox">-</span></div>
</div>

<!-- 상세 -->
<div id="cargoDetail" style="display:none;">

  <!-- ② 박스 수(수동) -->
  <div class="section">
    <div class="section-title">② 박스 수량</div>

    <div class="box-control">
      <button type="button" class="btn btn-secondary" onclick="changeBox(-1)">−</button>
      <input type="number" id="boxCnt" value="1" min="1" class="form-control" onchange="renderBoxes();">
      <button type="button" class="btn btn-secondary" onclick="changeBox(1)">+</button>
    </div>

    <div class="muted-hint mt-2">
      박스 수를 정한 뒤, 각 박스 카드에서 framename과 길이를 선택하세요.
      (수동건은 framename이 “품목명(item_name)”으로 표시됩니다.)
    </div>
  </div>

  <!-- ③ 박스별 프레임/길이 선택 -->
  <div class="section">
    <div class="section-title">③ 박스별 선택</div>
    <div id="slotArea"></div>
  </div>

  <div class="section">
    <button class="btn btn-primary w-100 py-3" onclick="saveCargo();">저장</button>
  </div>

</div>
</div>

<script>
var recvBtnScrollTop = 0;

var cargoData = {
  kind: "meta",           // "meta" | "manual"
  wms_idx: null,
  sjidx: null,

  manual_idx: 0,
  item_name: "",          // ✅ manual일 때 품목명(=item_name)

  wms_type: null,
  ymd: ymd,
  recv_name: "",
  cargo_status: 0,

  // framename 옵션(기존은 sjsidx/framename 목록, manual은 1개짜리로 구성)
  frameOptions: [],

  // 박스 단위: [{sjsidx:"", frame_name:"", cargo_rect:""}]
  items: []
};

function filterRecv() {
  var q = document.getElementById("searchRecv").value.toLowerCase();
  document.querySelectorAll('.recv-item').forEach(function(b){
    b.style.display = (String(b.dataset.name || "").toLowerCase().indexOf(q) > -1) ? '' : 'none';
  });
}

function getCargoRectOptions() {
  var html = ''
    + '<option value="">길이 선택</option>'
    + '<option value="정사각형_1000이하">정사각형 - 1000 이하</option>'
    + '<option value="정사각형_2500">정사각형 - 2500</option>'
    + '<option value="정사각형_3000이상">정사각형 - 3000 이상</option>';

  if (cargoData.wms_type === 17 || cargoData.wms_type === 18) {
    html += ''
      + '<option value="정사각형_4000이상">정사각형 - 4000 이상</option>'
      + '<option value="사다리꼴_2">사다리꼴 - 2M</option>'
      + '<option value="사다리꼴_2.5~3.4">사다리꼴 - 2.5M~3.4M</option>'
      + '<option value="사다리꼴_3.5~4.5">사다리꼴 - 3.5M~4.5M</option>'
      + '<option value="사다리꼴_4.5~5">사다리꼴 - 4.5M~5M</option>';
  }
  return html;
}

function getFrameNameOptions(){
  var html = '<option value="">framename 선택(선택)</option>';
  cargoData.frameOptions.forEach(function(o){
    html += '<option value="' + escapeHtmlAttr(String(o.sjsidx)) + '">'
         +  escapeHtml(String(o.framename))
         +  '</option>';
  });
  return html;
}

function changeBox(d){
  var el = document.getElementById("boxCnt");
  var v = parseInt(el.value || "1", 10) + d;
  if (v < 1) v = 1;
  el.value = v;
  renderBoxes();
}

function selectRecv(btn) {
  document.querySelectorAll('.recv-btn').forEach(function(b){ b.classList.remove('selected'); });
  btn.classList.add('selected');

  recvBtnScrollTop = btn.getBoundingClientRect().top + window.scrollY;

  // 공통
  cargoData.kind     = String(btn.dataset.kind || "meta");
  cargoData.recv_name= String(btn.dataset.name || "");
  cargoData.wms_type = parseInt(btn.dataset.wmsType || "0", 10);

  document.getElementById("sumRecv").innerText = cargoData.recv_name;
  document.getElementById("sumKind").innerText = (cargoData.kind === "manual" ? "수동" : "기존");
  document.getElementById("cargoDetail").style.display = "block";

  // ---- manual 선택 처리 ----
  if (cargoData.kind === "manual") {
    cargoData.manual_idx = parseInt(btn.dataset.manualIdx || "0", 10);

    // ✅ 여기서 item_name을 만든다: 버튼 data-item-name에서 가져옴
    cargoData.item_name = String(btn.dataset.itemName || "").trim();
    if (!cargoData.item_name) cargoData.item_name = "(품목명 없음)";
    document.getElementById("sumItem").innerText = cargoData.item_name;

    // ✅ manual은 framename 옵션을 1개로 고정(표시용)
    cargoData.frameOptions = [{
      sjsidx: "manual-" + String(cargoData.manual_idx),
      framename: cargoData.item_name
    }];

    // meta 전용값 초기화
    cargoData.wms_idx = null;
    cargoData.sjidx   = null;
    cargoData.cargo_status = 0;

    renderBoxes();

    // ✅ manual도 아래로 스크롤
    setTimeout(function(){
      var y = summaryBox.offsetTop + summaryBox.offsetHeight;
      window.scrollTo({top:y,behavior:"smooth"});
    }, 50);

    return;
  }

  // ---- 기존(meta) 선택 처리 (기존 로직 유지) ----
  cargoData.manual_idx = 0;
  cargoData.item_name  = "";
  document.getElementById("sumItem").innerText = "-";

  cargoData.wms_idx      = String(btn.dataset.wmsIdx || "");
  cargoData.sjidx        = parseInt(btn.dataset.sjidx || "0", 10);
  cargoData.cargo_status = parseInt(btn.dataset.cargoStatus || "0", 10);

  if (!cargoData.sjidx) {
    alert("sjidx가 비어있습니다. tk_wms_meta.sjidx 값을 확인하세요.");
    cargoData.frameOptions = [{ sjsidx:"", framename:"(framename 없음)" }];
    renderBoxes();
    return;
  }

  loadFrameOptions()
    .then(function(){ return loadExistCargo(); })
    .then(function(){
      setTimeout(function(){
        var y = summaryBox.offsetTop + summaryBox.offsetHeight;
        window.scrollTo({top:y,behavior:"smooth"});
      }, 50);
    })
    .catch(function(err){
      alert("framename 로드 실패: " + err);
    });
}

/** framename 옵션 목록 로드(기존 meta 전용) */
function loadFrameOptions(){
  cargoData.frameOptions = [];

  var url = "/TNG_WMS/Dashboard/Popup/TNG_WMS_Cargo_Frame_Load.asp?sjidx=" + encodeURIComponent(String(cargoData.sjidx));

  return fetch(url, { cache: "no-store" })
    .then(function(res){ return res.json(); })
    .then(function(data){
      var list = [];
      if (Array.isArray(data)) list = data;
      else if (data && Array.isArray(data.framename_list)) list = data.framename_list;

      var seen = {};
      var opts = [];

      list.forEach(function(x){
        var sjsidx = String(x.sjsidx || "").trim();
        var name   = String(x.framename || "").trim();
        if (!name) name = "(미지정)";
        if (!sjsidx) return;
        if (seen[sjsidx]) return;
        seen[sjsidx] = true;
        opts.push({ sjsidx: sjsidx, framename: name });
      });

      if (opts.length === 0) opts = [{ sjsidx:"", framename:"(framename 없음)" }];

      cargoData.frameOptions = opts;
      renderBoxes();
    });
}

/** framename select 변경 시 sjsidx + framename(텍스트) 같이 저장 */
function onChangeFrame(i, sel){
  var sjsidx = sel.value || "";
  var fname  = sel.options[sel.selectedIndex] ? sel.options[sel.selectedIndex].text : "";
  cargoData.items[i].sjsidx = sjsidx;
  cargoData.items[i].frame_name = fname;
}

function renderBoxes(){
  var cnt = parseInt(document.getElementById("boxCnt").value || "1", 10);
  if (cnt < 1) cnt = 1;

  document.getElementById("sumBox").innerText = cnt + " 박스";

  // items 길이 맞추기(기존 선택 유지)
  var next = [];
  for (var i=0;i<cnt;i++){
    if (cargoData.items[i]) next.push(cargoData.items[i]);
    else next.push({ sjsidx:"", frame_name:"", cargo_rect:"" });
  }
  cargoData.items = next;

  // ✅ manual이면 기본 framename(=item_name) 자동 주입
  if (cargoData.kind === "manual" && cargoData.frameOptions && cargoData.frameOptions.length > 0) {
    var def = cargoData.frameOptions[0];
    for (var j=0; j<cargoData.items.length; j++){
      if (!cargoData.items[j].sjsidx) cargoData.items[j].sjsidx = def.sjsidx;
      if (!cargoData.items[j].frame_name) cargoData.items[j].frame_name = def.framename;
    }
  }

  // 렌더
  var html = "";
  for (var k=0;k<cnt;k++){
    html += ''
      + '<div class="slot-card">'
      + '  <div class="fw-bold mb-2">박스 ' + (k+1) + '</div>'
      + '  <div class="mb-2">'
      + '    <div class="muted-hint mb-1">framename</div>'
      + '    <select class="form-select" onchange="onChangeFrame('+k+', this);">'
      +        getFrameNameOptions()
      + '    </select>'
      + '  </div>'
      + '  <div>'
      + '    <div class="muted-hint mb-1">길이</div>'
      + '    <select class="form-select" onchange="cargoData.items['+k+'].cargo_rect=this.value;">'
      +        getCargoRectOptions()
      + '    </select>'
      + '  </div>'
      + '</div>';
  }
  slotArea.innerHTML = html;

  // 기존 선택값 반영
  var allSelects = slotArea.querySelectorAll("select.form-select");
  for (var t=0;t<cnt;t++){
    var fSel = allSelects[t*2 + 0];
    var rSel = allSelects[t*2 + 1];

    if (fSel) fSel.value = cargoData.items[t].sjsidx || "";
    if (rSel) rSel.value = cargoData.items[t].cargo_rect || "";
  }
}

/** 기존 저장 복원: meta는 wms_idx로 기존 로드 (유지) */
function loadExistCargo(){
  if (cargoData.kind !== "meta") return Promise.resolve();
  if (!cargoData.wms_idx) return Promise.resolve();

  return fetch("TNG_WMS_Cargo_Receipt_Load.asp?wms_idx=" + encodeURIComponent(cargoData.wms_idx), { cache: "no-store" })
    .then(function(res){ return res.json(); })
    .then(function(list){
      if (!list || list.length === 0) return;

      document.getElementById("boxCnt").value = list.length;
      renderBoxes();

      for (var i=0; i<list.length; i++){
        if (cargoData.items[i]) cargoData.items[i].cargo_rect = list[i].cargo_rect || "";
      }
      renderBoxes();
    });
}

function saveCargo(){
  // 길이는 필수
  for (var i=0;i<cargoData.items.length;i++){
    if (!cargoData.items[i].cargo_rect){
      alert((i+1) + "번 박스 길이를 선택하세요.");
      return;
    }
  }

  var params = new URLSearchParams();

  // ✅ kind를 같이 보냄(서버에서 분기 가능)
  params.append("kind", cargoData.kind);

  // meta일 때는 기존 파라미터 유지
  if (cargoData.kind === "meta") {
    if (!cargoData.wms_idx) { alert("수탁자를 선택하세요."); return; }
    params.append("wms_idx", cargoData.wms_idx);
    params.append("sjidx", cargoData.sjidx);
    params.append("wms_type", cargoData.wms_type);
    params.append("ymd", cargoData.ymd);
    params.append("recv_name", cargoData.recv_name);
    params.append("cargo_status", cargoData.cargo_status);
  } else {
    // manual일 때: manual_idx + item_name 같이 보냄(서버에서 필요하면 사용)
    if (!cargoData.manual_idx) { alert("수동 출고건을 선택하세요."); return; }
    params.append("manual_idx", cargoData.manual_idx);
    params.append("wms_type", cargoData.wms_type);
    params.append("ymd", cargoData.ymd);
    params.append("recv_name", cargoData.recv_name);
    params.append("item_name", cargoData.item_name);
  }

  params.append("box_cnt", cargoData.items.length);

  for (var j=0;j<cargoData.items.length;j++){
    params.append("sjsidx_" + j, cargoData.items[j].sjsidx || "");
    params.append("frame_name_" + j, cargoData.items[j].frame_name || "");
    params.append("cargo_rect_" + j, cargoData.items[j].cargo_rect || "");
  }

  fetch("TNG_WMS_Cargo_Receipt_DB.asp", {
    method:"POST",
    headers:{ "Content-Type":"application/x-www-form-urlencoded; charset=UTF-8" },
    body: params.toString()
  })
  .then(function(r){ return r.text(); })
  .then(function(txt){
    if (String(txt).trim() === "OK") {
      alert("저장되었습니다.");

      setTimeout(function(){
        window.scrollTo({ top: recvBtnScrollTop - 40, behavior: "smooth" });
      }, 100);

      if (window.opener) window.opener.location.reload();
    } else {
      alert(txt);
    }
  })
  .catch(function(e){
    alert("저장 중 오류: " + e);
  });
}

function escapeHtml(s){
  return String(s)
    .replaceAll("&","&amp;")
    .replaceAll("<","&lt;")
    .replaceAll(">","&gt;")
    .replaceAll('"',"&quot;")
    .replaceAll("'","&#039;");
}
function escapeHtmlAttr(s){
  return String(s)
    .replaceAll('"',"&quot;")
    .replaceAll("<","&lt;")
    .replaceAll(">","&gt;");
}
</script>

</body>
</html>

<%
On Error Resume Next
If Not (Rs Is Nothing) Then
  If Rs.State = 1 Then Rs.Close
End If
If Not (RsManual Is Nothing) Then
  If RsManual.State = 1 Then RsManual.Close
End If
Set Rs = Nothing
Set RsManual = Nothing
Call dbClose()
%>
