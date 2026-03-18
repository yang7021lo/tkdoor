<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

' ============================================================
' MODE: import (POST JSON → DB INSERT)
' ============================================================
If UCase(Request.ServerVariables("REQUEST_METHOD")) = "POST" And Request.QueryString("action") = "import" Then
  Response.ContentType = "application/json"

  ' Body 읽기
  Dim bodyStr, stm
  If Request.TotalBytes > 0 Then
    Set stm = Server.CreateObject("ADODB.Stream")
    stm.Type = 1
    stm.Open
    stm.Write Request.BinaryRead(Request.TotalBytes)
    stm.Position = 0
    stm.Type = 2
    stm.Charset = "utf-8"
    bodyStr = stm.ReadText
    stm.Close
    Set stm = Nothing
  Else
    Response.Write "{""result"":""fail"",""msg"":""No data""}"
    Response.End
  End If

  ' 간단한 JSON 배열 파싱: [{pname, pcode, pname_brand, p_hex_color, paint_type}, ...]
  ' VBScript에 JSON 파서가 없으므로 간단한 라인 파싱
  ' 프론트에서 action=import&items=JSON 배열로 보내는 대신
  ' 라인별 파이프 구분: "name|code|brandIdx|hex|paintType" 으로 전송

  Dim lines, insertCount, errMsg
  lines = Split(bodyStr, vbLf)
  insertCount = 0
  errMsg = ""

  On Error Resume Next
  Dbcon.Execute "BEGIN TRANSACTION"
  If Err.Number <> 0 Then
    Response.Write "{""result"":""fail"",""msg"":""" & Replace(Err.Description, """", "'") & """}"
    Err.Clear
    Response.End
  End If

  Dim i, parts, sql, ln
  Dim pname, pcode, brandIdx, hexColor, paintType
  For i = 0 To UBound(lines)
    ln = Trim(lines(i))
    If ln <> "" Then
      parts = Split(ln, "|")
      If UBound(parts) >= 4 Then
        pname     = Trim(parts(0))
        pcode     = Trim(parts(1))
        brandIdx  = Trim(parts(2))
        hexColor  = Trim(parts(3))
        paintType = Trim(parts(4))

        If pname <> "" Or pcode <> "" Then
          sql = "INSERT INTO tk_paint (pname, pcode, pname_brand, p_hex_color, paint_type, pstatus, pmidx, pwdate, pemidx, pewdate) " & _
                "VALUES (" & _
                "N'" & Replace(pname, "'", "''") & "', " & _
                "N'" & Replace(pcode, "'", "''") & "', "

          If brandIdx <> "" And IsNumeric(brandIdx) Then
            sql = sql & CLng(brandIdx) & ", "
          Else
            sql = sql & "NULL, "
          End If

          sql = sql & "N'" & Replace(hexColor, "'", "''") & "', "

          If paintType <> "" And IsNumeric(paintType) Then
            sql = sql & CLng(paintType) & ", "
          Else
            sql = sql & "1, "
          End If

          sql = sql & "1, '" & C_midx & "', GETDATE(), '" & C_midx & "', GETDATE())"

          Dbcon.Execute sql
          If Err.Number <> 0 Then
            errMsg = "INSERT 오류 (행 " & (i+1) & "): " & Err.Description
            Err.Clear
            Exit For
          End If
          insertCount = insertCount + 1
        End If
      End If
    End If
  Next

  If errMsg <> "" Then
    Dbcon.Execute "ROLLBACK"
    If Err.Number <> 0 Then Err.Clear
    Response.Write "{""result"":""fail"",""msg"":""" & Replace(errMsg, """", "'") & """,""inserted"":" & insertCount & "}"
  Else
    Dbcon.Execute "COMMIT"
    If Err.Number <> 0 Then
      Response.Write "{""result"":""fail"",""msg"":""COMMIT 오류""}"
      Err.Clear
    Else
      Response.Write "{""result"":""ok"",""inserted"":" & insertCount & "}"
    End If
  End If
  On Error GoTo 0
  Response.End
End If

' ============================================================
' 기존 브랜드 목록 (매핑용)
' ============================================================
Dim rsBrand, brandJSON
brandJSON = "["
Set rsBrand = Dbcon.Execute("SELECT pbidx, pname_brand FROM tk_paint_brand WHERE pbidx > 0 ORDER BY pbidx")
Dim bFirst : bFirst = True
Do While Not rsBrand.EOF
  If Not bFirst Then brandJSON = brandJSON & ","
  bFirst = False
  brandJSON = brandJSON & "{""id"":" & rsBrand(0) & ",""name"":""" & Replace(rsBrand(1) & "", """", "'") & """}"
  rsBrand.MoveNext
Loop
rsBrand.Close
Set rsBrand = Nothing
brandJSON = brandJSON & "]"

' 기존 페인트 코드 목록 (중복 체크용)
Dim rsExist, existJSON
existJSON = "["
Set rsExist = Dbcon.Execute("SELECT pcode FROM tk_paint WHERE pcode IS NOT NULL AND pcode <> '' ORDER BY pcode")
Dim eFirst : eFirst = True
Do While Not rsExist.EOF
  If Not eFirst Then existJSON = existJSON & ","
  eFirst = False
  existJSON = existJSON & """" & Replace(rsExist(0) & "", """", "\""") & """"
  rsExist.MoveNext
Loop
rsExist.Close
Set rsExist = Nothing
existJSON = existJSON & "]"

call dbClose()
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>노루페인트 컬러 임포트</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { font-family: "Malgun Gothic", sans-serif; background: #f1f5f9; padding: 20px; }
.wrap { max-width: 1100px; margin: 0 auto; }
.card { border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 16px; }
.card-header { font-weight: 700; }
h4 { margin: 0; }
textarea { font-family: 'Consolas', monospace; font-size: 11px; }
.step-num { display: inline-flex; align-items: center; justify-content: center;
  width: 28px; height: 28px; border-radius: 50%; background: #6366f1; color: #fff;
  font-weight: 700; font-size: 14px; margin-right: 8px; }
.preview-table { width: 100%; font-size: 11px; border-collapse: collapse; }
.preview-table th { background: #1e293b; color: #fff; padding: 6px 8px; position: sticky; top: 0; }
.preview-table td { padding: 4px 8px; border-bottom: 1px solid #e2e8f0; }
.preview-table tr:hover { background: #f8fafc; }
.preview-table tr.dup { background: #fef2f2; color: #999; }
.preview-table tr.dup td { text-decoration: line-through; }
.color-chip { display: inline-block; width: 20px; height: 14px; border: 1px solid #999;
  border-radius: 2px; vertical-align: middle; margin-right: 4px; }
.stats { display: flex; gap: 16px; flex-wrap: wrap; }
.stat-card { background: #fff; border-radius: 8px; padding: 12px 20px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.08); text-align: center; min-width: 100px; }
.stat-card .num { font-size: 24px; font-weight: 700; }
.stat-card .label { font-size: 11px; color: #64748b; }
.brand-map-row { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; font-size: 12px; }
.brand-map-row .code { font-weight: 700; width: 60px; }
.log-area { max-height: 150px; overflow-y: auto; font-size: 11px; font-family: monospace;
  background: #1e293b; color: #4ade80; padding: 10px; border-radius: 6px; white-space: pre-wrap; }
</style>
</head>
<body>
<div class="wrap">
  <h4 class="mb-3">노루페인트 컬러 → tk_paint 임포트</h4>

  <!-- STEP 1: JSON 붙여넣기 -->
  <div class="card">
    <div class="card-header bg-primary text-white">
      <span class="step-num">1</span> JSON 데이터 붙여넣기
    </div>
    <div class="card-body">
      <p class="text-muted mb-2" style="font-size:12px">
        노루페인트 사이트에서 <code>noroo_extract_v3.js</code> 실행 후 다운로드된 JSON 파일 내용을 붙여넣거나,
        파일을 드래그&드롭 하세요.
      </p>
      <textarea id="jsonInput" class="form-control" rows="6" placeholder='[{"code":"NR-001","name":"화이트","company":"NR","hex":"#FFFFFF"}, ...]'></textarea>
      <div class="mt-2 d-flex gap-2">
        <button id="btnParse" class="btn btn-primary btn-sm">파싱 & 미리보기</button>
        <button id="btnLoadFile" class="btn btn-outline-secondary btn-sm">JSON 파일 열기</button>
        <input type="file" id="fileInput" accept=".json" style="display:none">
        <span id="parseStatus" class="align-self-center" style="font-size:12px;color:#64748b"></span>
      </div>
    </div>
  </div>

  <!-- STEP 2: 브랜드 매핑 -->
  <div class="card" id="step2Card" style="display:none">
    <div class="card-header bg-indigo text-white" style="background:#6366f1!important">
      <span class="step-num">2</span> 회사코드 → 제조사 매핑
    </div>
    <div class="card-body">
      <p class="text-muted mb-2" style="font-size:12px">
        노루페인트 회사코드를 tk_paint_brand에 매핑하세요. 없으면 "자동생성"을 선택하면 새 브랜드가 만들어집니다.
      </p>
      <div id="brandMappings"></div>
    </div>
  </div>

  <!-- STEP 3: 미리보기 -->
  <div class="card" id="step3Card" style="display:none">
    <div class="card-header bg-success text-white">
      <span class="step-num">3</span> 미리보기 & 임포트
    </div>
    <div class="card-body">
      <div class="stats mb-3" id="statsArea"></div>
      <div style="max-height:400px;overflow-y:auto;border:1px solid #e2e8f0;border-radius:6px">
        <table class="preview-table" id="previewTable">
          <thead><tr><th>#</th><th>코드</th><th>컬러명</th><th>회사</th><th>대표색</th><th>중복</th></tr></thead>
          <tbody></tbody>
        </table>
      </div>
      <div class="mt-3 d-flex gap-2 align-items-center">
        <button id="btnImport" class="btn btn-success btn-sm" disabled>DB에 임포트</button>
        <label class="form-check-label" style="font-size:12px">
          <input type="checkbox" id="chkSkipDup" checked class="form-check-input"> 중복 코드 건너뛰기
        </label>
        <span id="importStatus" style="font-size:12px;color:#64748b"></span>
      </div>
    </div>
  </div>

  <!-- 로그 -->
  <div class="card" id="logCard" style="display:none">
    <div class="card-header bg-dark text-white">임포트 로그</div>
    <div class="card-body p-0">
      <div class="log-area" id="logArea"></div>
    </div>
  </div>
</div>

<script>
(function(){
"use strict";

// 서버에서 전달받은 데이터
var BRANDS = <%=brandJSON%>;
var EXIST_CODES = new Set(<%=existJSON%>);

console.log('[IMPORT] 브랜드:', BRANDS.length, '개');
console.log('[IMPORT] 기존 코드:', EXIST_CODES.size, '개');

var parsedData = [];
var companySet = new Set();

// --- 파일 열기 ---
document.getElementById("btnLoadFile").onclick = function(){ document.getElementById("fileInput").click(); };
document.getElementById("fileInput").onchange = function(e){
  var file = e.target.files[0];
  if (!file) return;
  var reader = new FileReader();
  reader.onload = function(ev){
    document.getElementById("jsonInput").value = ev.target.result;
    document.getElementById("parseStatus").textContent = file.name + " 로드됨";
  };
  reader.readAsText(file);
};

// --- 드래그&드롭 ---
var ta = document.getElementById("jsonInput");
ta.addEventListener("dragover", function(e){ e.preventDefault(); ta.style.borderColor="#6366f1"; });
ta.addEventListener("dragleave", function(){ ta.style.borderColor=""; });
ta.addEventListener("drop", function(e){
  e.preventDefault();
  ta.style.borderColor="";
  var file = e.dataTransfer.files[0];
  if (file) {
    var reader = new FileReader();
    reader.onload = function(ev){ ta.value = ev.target.result; };
    reader.readAsText(file);
  }
});

// --- 파싱 ---
document.getElementById("btnParse").onclick = parseJSON;

function parseJSON() {
  var raw = document.getElementById("jsonInput").value.trim();
  if (!raw) { alert("JSON 데이터를 입력하세요"); return; }

  try {
    parsedData = JSON.parse(raw);
    if (!Array.isArray(parsedData)) {
      if (parsedData.data) parsedData = parsedData.data;
      else parsedData = [parsedData];
    }
  } catch(e) {
    alert("JSON 파싱 실패: " + e.message);
    return;
  }

  console.log('[IMPORT] 파싱 완료:', parsedData.length, '건');
  document.getElementById("parseStatus").textContent = parsedData.length + "건 파싱됨";
  document.getElementById("parseStatus").style.color = "#059669";

  // 회사코드 수집
  companySet = new Set();
  parsedData.forEach(function(c){ if (c.company) companySet.add(c.company); });

  // STEP 2: 브랜드 매핑 UI
  buildBrandMapping();
  document.getElementById("step2Card").style.display = "";

  // STEP 3: 미리보기
  buildPreview();
  document.getElementById("step3Card").style.display = "";
}

// --- 브랜드 매핑 UI ---
function buildBrandMapping() {
  var div = document.getElementById("brandMappings");
  div.innerHTML = "";

  // 자동매핑 추측
  var autoMap = {
    "NR": "노루",
    "CVR": "Cover",
    "CGI": "컬러가이드",
    "TPG": "PANTONE",
    "DLX": "DLX"
  };

  companySet.forEach(function(code) {
    var row = document.createElement("div");
    row.className = "brand-map-row";

    var label = document.createElement("span");
    label.className = "code";
    label.textContent = code;
    row.appendChild(label);

    var arrow = document.createElement("span");
    arrow.textContent = "→";
    row.appendChild(arrow);

    var sel = document.createElement("select");
    sel.className = "form-select form-select-sm";
    sel.style.width = "200px";
    sel.id = "brandMap_" + code;

    // 옵션: 자동생성
    var optAuto = document.createElement("option");
    optAuto.value = "AUTO";
    optAuto.textContent = "자동생성 (" + code + ")";
    sel.appendChild(optAuto);

    // 기존 브랜드
    var guessKey = autoMap[code] || "";
    BRANDS.forEach(function(b) {
      var opt = document.createElement("option");
      opt.value = b.id;
      opt.textContent = b.id + ": " + b.name;
      if (guessKey && b.name.indexOf(guessKey) !== -1) opt.selected = true;
      sel.appendChild(opt);
    });

    row.appendChild(sel);
    div.appendChild(row);
  });
}

// --- 미리보기 테이블 ---
function buildPreview() {
  var tbody = document.querySelector("#previewTable tbody");
  tbody.innerHTML = "";

  var dupCount = 0;
  var newCount = 0;
  var companyCount = {};

  parsedData.forEach(function(c, i) {
    var isDup = EXIST_CODES.has(c.code);
    if (isDup) dupCount++;
    else newCount++;

    var cmp = c.company || "?";
    companyCount[cmp] = (companyCount[cmp] || 0) + 1;

    var tr = document.createElement("tr");
    if (isDup) tr.className = "dup";
    tr.innerHTML =
      "<td>" + (i + 1) + "</td>" +
      "<td>" + esc(c.code) + "</td>" +
      "<td>" + esc(c.name) + "</td>" +
      "<td>" + esc(cmp) + "</td>" +
      "<td>" + (c.hex ? '<span class="color-chip" style="background:' + esc(c.hex) + '"></span>' + esc(c.hex) : '') + "</td>" +
      "<td>" + (isDup ? '<span style="color:#ef4444">중복</span>' : '<span style="color:#059669">신규</span>') + "</td>";
    tbody.appendChild(tr);
  });

  // 통계
  var statsHtml =
    '<div class="stat-card"><div class="num">' + parsedData.length + '</div><div class="label">전체</div></div>' +
    '<div class="stat-card"><div class="num" style="color:#059669">' + newCount + '</div><div class="label">신규</div></div>' +
    '<div class="stat-card"><div class="num" style="color:#ef4444">' + dupCount + '</div><div class="label">중복</div></div>';

  for (var k in companyCount) {
    statsHtml += '<div class="stat-card"><div class="num">' + companyCount[k] + '</div><div class="label">' + esc(k) + '</div></div>';
  }
  document.getElementById("statsArea").innerHTML = statsHtml;

  // 임포트 버튼 활성화
  document.getElementById("btnImport").disabled = false;
}

// --- 임포트 실행 ---
document.getElementById("btnImport").onclick = doImport;

function doImport() {
  var skipDup = document.getElementById("chkSkipDup").checked;
  var btn = document.getElementById("btnImport");
  btn.disabled = true;
  btn.textContent = "임포트 중...";

  document.getElementById("logCard").style.display = "";
  var logArea = document.getElementById("logArea");
  logArea.textContent = "";

  function log(msg) {
    logArea.textContent += msg + "\n";
    logArea.scrollTop = logArea.scrollHeight;
    console.log('[IMPORT]', msg);
  }

  // 브랜드 매핑 수집
  var brandMapping = {};
  companySet.forEach(function(code) {
    var sel = document.getElementById("brandMap_" + code);
    brandMapping[code] = sel ? sel.value : "AUTO";
  });
  log("브랜드 매핑: " + JSON.stringify(brandMapping));

  // 임포트할 행 생성 (파이프 구분 텍스트)
  var lines = [];
  var skipCount = 0;

  parsedData.forEach(function(c) {
    if (skipDup && EXIST_CODES.has(c.code)) {
      skipCount++;
      return;
    }

    var brandVal = brandMapping[c.company] || "";
    if (brandVal === "AUTO") brandVal = ""; // 서버에서 NULL 처리

    // name|code|brandIdx|hex|paintType
    lines.push(
      (c.name || "") + "|" +
      (c.code || "") + "|" +
      brandVal + "|" +
      (c.hex || "") + "|" +
      "1"
    );
  });

  log("전체: " + parsedData.length + "건, 건너뜀: " + skipCount + "건, 임포트: " + lines.length + "건");

  if (lines.length === 0) {
    log("임포트할 항목이 없습니다.");
    btn.disabled = false;
    btn.textContent = "DB에 임포트";
    return;
  }

  if (!confirm(lines.length + "건을 tk_paint에 임포트하시겠습니까?")) {
    btn.disabled = false;
    btn.textContent = "DB에 임포트";
    return;
  }

  log("서버 전송 중...");

  fetch("import_noroo.asp?action=import", {
    method: "POST",
    headers: {"Content-Type": "text/plain; charset=utf-8"},
    body: lines.join("\n")
  })
  .then(function(r){ return r.json(); })
  .then(function(res){
    log("서버 응답: " + JSON.stringify(res));
    if (res.result === "ok") {
      log("임포트 완료! " + res.inserted + "건 삽입됨");
      document.getElementById("importStatus").textContent = res.inserted + "건 임포트 완료!";
      document.getElementById("importStatus").style.color = "#059669";
    } else {
      log("오류: " + (res.msg || "알 수 없는 오류"));
      document.getElementById("importStatus").textContent = "실패: " + res.msg;
      document.getElementById("importStatus").style.color = "#ef4444";
    }
  })
  .catch(function(e){
    log("네트워크 오류: " + e.message);
  })
  .finally(function(){
    btn.disabled = false;
    btn.textContent = "DB에 임포트";
  });
}

function esc(s) {
  if (!s) return "";
  return String(s).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
}

})();
</script>
</body>
</html>
