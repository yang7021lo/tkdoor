
<%@ CodePage="65001" Language="VBScript" %>
<%
' ===============================
'  SVG 전용 미니모듈 (렌더링만)
' ===============================
Option Explicit
Response.ContentType = "text/html; charset=utf-8"
Response.CharSet     = "utf-8"
Response.Buffer      = True

' === 직접 DB 연결 (인클루드 제거) ===
Public Dbcon
Const OLE_DB = "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;User ID=tkd001;Password=tkd2713!;"

Sub dbOpen()
  If Not IsObject(Dbcon) Then
    Set Dbcon = Server.CreateObject("ADODB.Connection")
    Dbcon.ConnectionTimeout = 30
    Dbcon.CommandTimeout    = 30
  End If
  If Dbcon.State = 0 Then
    Dbcon.Open OLE_DB
  End If
End Sub

Sub dbClose()
  On Error Resume Next
  If IsObject(Dbcon) Then
    If Dbcon.State <> 0 Then Dbcon.Close
    Set Dbcon = Nothing
  End If
End Sub

' --- 유틸 ---
Function SafeLng(v, d)
  If IsNull(v) Then SafeLng = d : Exit Function
  Dim s : s = Trim(CStr(v))
  If s = "" Or Not IsNumeric(s) Then
    SafeLng = d
  Else
    SafeLng = CLng(s)
  End If
End Function

' 최소 이스케이프(따옴표만) - 문자열 파라미터용
Function Q(s)
  If IsNull(s) Then s = ""
  Q = Replace(CStr(s), "'", "''")
End Function
%>


<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <title>태광 프레임 시공도 - Paletto Agency</title>
    <link rel="shortcut icon" href="/documents/assets/favicon/favicon.ico">
    <style>
    /* 인쇄 전용 */
@media print {
  /* .a4-wrap 한 덩어리는 쪼개지지 않게 */
  .a4-wrap {
    break-inside: avoid;
    page-break-inside: avoid;
  }

  /* 마지막 .a4-wrap을 제외하고는 항상 페이지 나눔 */
  .a4-wrap:not(:last-of-type) {
    break-after: page;        /* 표준 */
    page-break-after: always; /* 구형 브라우저 */
  }
}
.a4-float{
  position: fixed;
  right: calc(16px + env(safe-area-inset-right));
  bottom: calc(16px + env(safe-area-inset-bottom));
  display: flex;
  gap: 8px;
  padding: 8px;
  border-radius: 999px;
  background: rgba(17,17,17,0.6);
  backdrop-filter: blur(6px);
  box-shadow: 0 8px 24px rgba(0,0,0,.25);
  z-index: 2147483647;
}
.a4-float button{
  appearance: none;
  border: 0;
  padding: 8px 12px;
  border-radius: 999px;
  font-weight: 600;
  background: #ffffff;
  cursor: pointer;
}
.a4-float button:hover{ opacity:.9; }

</style>
<link href="/documents/installationManual/assets/index.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">

  
  </head>
  <body>
    <%
' === 연결 ===
Call dbOpen()

' -------------------------------
' 파라미터 (최소한)
' -------------------------------
Dim sjidx    : sjidx    = Trim(Request("sjidx"))
Dim sjsidx   : sjsidx   = Trim(Request("sjsidx"))
Dim rfkidx   : rfkidx   = Trim(Request("fkidx"))   ' 선택 프레임(옵션)
Dim rfksidx  : rfksidx  = Trim(Request("fksidx"))  ' 선택 바(옵션)

If sjidx = "" Or sjsidx = "" Then
  Response.Write "<h3>missing params: sjidx & sjsidx are required</h3>"
  Call dbClose()
  Response.End
End If

' SQL에서 사용할 이스케이프
Dim sjidxSql, sjsidxSql
sjidxSql  = Q(sjidx)
sjsidxSql = Q(sjsidx)

' -------------------------------
' 캔버스 메타 크기 (없으면 BBox로 자동)
' -------------------------------
Dim sja_mwidth, sja_mheight
sja_mwidth  = 0
sja_mheight = 0

Dim RsMeta, SqlMeta
Set RsMeta = Server.CreateObject("ADODB.Recordset")
SqlMeta = ""
SqlMeta = SqlMeta & "SELECT ISNULL(mwidth,0), ISNULL(mheight,0) "
SqlMeta = SqlMeta & "FROM tng_sjaSub "
SqlMeta = SqlMeta & "WHERE sjidx='" & sjidxSql & "' AND sjsidx='" & sjsidxSql & "'"
RsMeta.Open SqlMeta, Dbcon, 1, 1
If Not (RsMeta.BOF Or RsMeta.EOF) Then
  sja_mwidth  = CDbl(RsMeta(0))
  sja_mheight = CDbl(RsMeta(1))
End If
RsMeta.Close : Set RsMeta = Nothing

' -------------------------------
' 자동/수동 fkidx 배열 수집
' -------------------------------
Dim i
Dim Rs, Sql
Dim arrAuto(), arrManual()
Dim autoCount, manualCount
autoCount = 0 : manualCount = 0

' 자동도어 배열
Set Rs = Server.CreateObject("ADODB.Recordset")
Sql = "SELECT ISNULL(A.fkidx,0) AS fkidx " & _
      "FROM tk_framek A " & _
      "WHERE A.sjidx='" & sjidxSql & "' " & _
      "AND A.sjsidx='" & sjsidxSql & "' " & _
      "AND A.GREEM_F_A='2' " & _
      "ORDER BY A.fkidx"
Rs.Open Sql, Dbcon, 1, 1
If Not Rs.EOF Then
  Do Until Rs.EOF
    ReDim Preserve arrAuto(autoCount)
    arrAuto(autoCount) = Rs("fkidx") & ""
    autoCount = autoCount + 1
    Rs.MoveNext
  Loop
End If
Rs.Close : Set Rs = Nothing

' 수동도어 배열
Set Rs = Server.CreateObject("ADODB.Recordset")
Sql = "SELECT ISNULL(A.fkidx,0) AS fkidx " & _
      "FROM tk_framek A " & _
      "WHERE A.sjidx='" & sjidxSql & "' " & _
      "AND A.sjsidx='" & sjsidxSql & "' " & _
      "AND A.GREEM_F_A='1' " & _
      "ORDER BY A.fkidx"
Rs.Open Sql, Dbcon, 1, 1
If Not Rs.EOF Then
  Do Until Rs.EOF
    ReDim Preserve arrManual(manualCount)
    arrManual(manualCount) = Rs("fkidx") & ""
    manualCount = manualCount + 1
    Rs.MoveNext
  Loop
End If
Rs.Close : Set Rs = Nothing

' -------------------------------
' 배열 확인 출력 (옵션)
' -------------------------------
'Response.Write "<h3>자동도어 배열</h3>"
'If autoCount > 0 Then
'  For i = 0 To autoCount - 1
'    Response.Write arrAuto(i) & "<br>"
'  Next
'Else
'  Response.Write "없음<br>"
'End If
'
'Response.Write "<h3>수동도어 배열</h3>"
'If manualCount > 0 Then
'  For i = 0 To manualCount - 1
'    Response.Write arrManual(i) & "<br>"
'  Next
'Else
'  Response.Write "없음<br>"
'End If


' -------------------------------
' 수동도어 발주서 LOOP (Server.Execute)
' -------------------------------
    Session("installationManual.sjidx")  = sjidx
    Session("installationManual.sjsidx") = sjsidx

    Server.Execute "/documents/installationManual/manual/index.asp" 


Call dbClose()
%>


<!-- 플로팅 A4 액션 패널 -->
<div id="a4-actions" class="a4-float" role="toolbar" aria-label="A4 다운로드">
  <button id="downloadA4Zip"  type="button">ZIP 다운로드</button>
  <button id="downloadA4Each" type="button">개별 다운로드</button>
</div>



<!-- 도면 수치 표현 모듈 (data-value/data-type 사용) -->
<script src="/schema/total.js"></script>
<script src="/schema/horizontal.js"></script>
<script src="/schema/vertical.js"></script>
<script src="/schema/intergrate.js"></script>
<script>
/** SVG를 내부 그룹(#viewport)의 바운딩박스에 딱 맞게 조정 + 다수 일괄 적용 + 텍스트 역스케일 보정 */
(function (root) {
  // (원본 그대로) CTM 적용 bbox
  function getTransformedBBox(el) {
    const bb = el.getBBox();
    const m  = el.getCTM();
    if (!m) return { x: bb.x, y: bb.y, width: bb.width, height: bb.height };

    const P = (x, y) =>
      (window.DOMPoint
        ? new DOMPoint(x, y).matrixTransform(m)
        : (function(){
            const pt = el.ownerSVGElement.createSVGPoint();
            pt.x = x; pt.y = y; return pt.matrixTransform(m);
          })());

    const p1 = P(bb.x, bb.y);
    const p2 = P(bb.x + bb.width, bb.y);
    const p3 = P(bb.x, bb.y + bb.height);
    const p4 = P(bb.x + bb.width, bb.y + bb.height);

    const xs = [p1.x, p2.x, p3.x, p4.x];
    const ys = [p1.y, p2.y, p3.y, p4.y];
    const minX = Math.min.apply(null, xs);
    const maxX = Math.max.apply(null, xs);
    const minY = Math.min.apply(null, ys);
    const maxY = Math.max.apply(null, ys);

    return { x: minX, y: minY, width: maxX - minX, height: maxY - minY };
  }

  // 화면 px / SVG 유닛 비율(대략치) — 회전 포함 평균 스케일
  function getPPU(svg) {
    const m = svg.getScreenCTM && svg.getScreenCTM();
    if (!m) return 1;
    const sx = Math.hypot(m.a, m.b);
    const sy = Math.hypot(m.c, m.d);
    return (sx + sy) / 2 || 1;
  }

  /**
   * 단일 SVG를 단일 그룹에 맞춤
   */
  function fitSvgToGroup(svgId='canvas', groupId='viewport', { padding=0, setSize=true, pxPerUnit=1, preserve='xMinYMin meet' } = {}) {
    const svg = document.getElementById(svgId);
    const g   = document.getElementById(groupId);
    if (!svg || !g) return;

    const bb = getTransformedBBox(g);
    const x = bb.x - padding;
    const y = bb.y - padding;
    const w = Math.max(0.0001, bb.width  + padding * 2);
    const h = Math.max(0.0001, bb.height + padding * 2);

    svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);
    svg.setAttribute('preserveAspectRatio', preserve);

    if (setSize) {
      svg.style.width  = (w * pxPerUnit) + 'px';
      svg.style.height = (h * pxPerUnit) + 'px';
    } else {
      svg.style.removeProperty('width');
      svg.style.removeProperty('height');
    }

    return { x, y, width: w, height: h };
  }

  // 텍스트 역스케일 보정
  function compensateTexts(svg, groups, factor, {
    selector = 'text, .dim-text, .label',
    method   = 'transform',         // 'transform' | 'fontSize'
    minScale = 0.75,
    maxScale = 3.0
  } = {}) {
    if (!factor || factor === 1) return;

    // 클램프
    const f = Math.max(minScale, Math.min(maxScale, factor));

    // 대상 텍스트 수집(여러 그룹 합집합)
    const nodes = [];
    for (const g of groups) nodes.push(...g.querySelectorAll(selector));
    if (!nodes.length) return;

    if (method === 'transform') {
      // 좌표는 그대로 두고 글자만 확대/축소
      nodes.forEach(el => {
        el.style.transformBox = 'fill-box';
        el.style.transformOrigin = 'center';
        // 누적되지 않도록 이전 스케일 제거 후 적용
        const prev = el.__svgfitScale || 1;
        const next = f;
        // 기존 스케일을 덮어씌우기 위해 transform 문자열 재조합(간단 버전: scale만 관리)
        el.style.transform = `scale(${next})`;
        el.__svgfitScale = next;
      });
    } else if (method === 'fontSize') {
      // 폰트 크기를 직접 변경(상황에 따라 레이아웃이 달라질 수 있음)
      nodes.forEach(el => {
        const cs = window.getComputedStyle(el);
        const basePx = parseFloat(cs.fontSize) || 12;
        const target = basePx * f;
        el.style.fontSize = target + 'px';
      });
    }
  }

  /**
   * 문서 내 중복 id까지 고려, 모든 #canvas들에 대해 내부 #viewport 기준으로 일괄 맞춤
   * options:
   *  - padding, setSize, pxPerUnit, preserve, mode('first'|'union'), index
   *  - textCompensate: {
   *        enable: true,
   *        selector: 'text, .dim-text, .label',
   *        strength: 1.0,           // 1.0=축소만큼 정확히 키움(화면상 크기 유지), >1이면 더 키움
   *        method: 'transform',     // 'transform' 권장
   *        minScale: 0.75,
   *        maxScale: 3.0
   *    }
   */
  function fitAllById(svgId='canvas', groupId='viewport', {
    padding=0, setSize=true, pxPerUnit=1,
    preserve='xMinYMin meet', mode='first', index=0,
    textCompensate = { enable:false }
  } = {}) {
    const svgs = Array.from(document.querySelectorAll(`svg[id="${svgId}"]`));
    const results = [];

    for (const svg of svgs) {
      const groups = Array.from(svg.querySelectorAll(`[id="${groupId}"]`));
      if (!groups.length) continue;

      const ppuBefore = getPPU(svg);

      let targetBox;
      if (mode === 'union') {
        const boxes = groups.map(g => getTransformedBBox(g));
        const minX = Math.min(...boxes.map(b => b.x));
        const minY = Math.min(...boxes.map(b => b.y));
        const maxX = Math.max(...boxes.map(b => b.x + b.width));
        const maxY = Math.max(...boxes.map(b => b.y + b.height));
        targetBox = { x: minX, y: minY, width: Math.max(0.0001, maxX - minX), height: Math.max(0.0001, maxY - minY) };
      } else {
        const i = Math.max(0, Math.min(groups.length - 1, Number(index) || 0));
        targetBox = getTransformedBBox(groups[i]);
      }

      const x = targetBox.x - padding;
      const y = targetBox.y - padding;
      const w = Math.max(0.0001, targetBox.width  + padding * 2);
      const h = Math.max(0.0001, targetBox.height + padding * 2);

      svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);
      svg.setAttribute('preserveAspectRatio', preserve);

      if (setSize) {
        svg.style.width  = (w * pxPerUnit) + 'px';
        svg.style.height = (h * pxPerUnit) + 'px';
      } else {
        svg.style.removeProperty('width');
        svg.style.removeProperty('height');
      }

      // 텍스트 역보정(레이아웃 반영 후 계산)
      if (textCompensate && textCompensate.enable) {
        requestAnimationFrame(() => {
          const ppuAfter = getPPU(svg);
          // f = (축소 비율)의 역수 -> 화면상 글자크기 유지/증가
          const raw = (ppuBefore && ppuAfter) ? (ppuBefore / ppuAfter) : 1;
          const strength = Math.max(0, Number(textCompensate.strength ?? 1));
          const factor = Math.pow(raw, strength);

          compensateTexts(svg, groups, factor, {
            selector: textCompensate.selector || 'text, .dim-text, .label',
            method: textCompensate.method || 'transform',
            minScale: textCompensate.minScale ?? 0.75,
            maxScale: textCompensate.maxScale ?? 3.0
          });
        });
      }

      results.push({ svg, groups: groups.length, width: w, height: h, mode });
    }

    return results;
  }

  root.SVGFit = { fitSvgToGroup, fitAllById };
})(window);

// === 사용 예시 ===
// 모든 #canvas 들을 #viewport 기준으로 맞추되, 축소된 만큼 글자를 키워 화면 가독성을 유지/강화
document.addEventListener('DOMContentLoaded', () => {
  SVGFit.fitAllById('canvas', 'viewport', {
    padding: 20,
    setSize: false,          // true이면 pxPerUnit로 고정 px 크기 설정
    pxPerUnit: 1,
    mode: 'first',
    index: 0,
    textCompensate: {
      enable: true,
      selector: 'text, .dim-text, .label',
      strength: 1.0,         // 1.0 = 화면상 텍스트 크기 ‘유지’, 1.2처럼 올리면 축소 시 더 크게
      method: 'transform',   // 좌표 유지+글자만 확대, 가장 안전
      minScale: 0.8,
      maxScale: 2.5
    }
  });
});
</script>


<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js"></script>

<script>
  (function(){
    const $$ = (sel, root=document)=>Array.from(root.querySelectorAll(sel));

    // ===== 파일명 유틸 =====
    function pickText(id){
      const el = document.getElementById(id);
      return el ? el.textContent.trim() : "";
    }
    function fileSafe(str, fallback="NA"){
      // 기본 위험 문자 치환
      const s = (str||"")
        .replace(/\s+/g, " ").trim()
        .replace(/[\\\/:*?"<>|#%&{}\[\]\$'@`=+^~;,]/g, "-");
      // Windows 예약어 회피
      const bad = /^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])$/i;
      return (s && !bad.test(s)) ? s : fallback;
    }
    function getPrefix(){
      const company = fileSafe(pickText("company"),  "Company");
      const suju    = fileSafe(pickText("suju_num"), "No");
      const prefix  = `${company}_${suju}`;
      return prefix.length > 120 ? prefix.slice(0,120) : prefix;
    }
    function stamp(prefix='A4'){
      // ZIP 이름 규칙: prefix + 날짜(YYYYMMDD)
      const d=new Date(), p=n=>String(n).padStart(2,'0');
      return `${prefix}_${d.getFullYear()}${p(d.getMonth()+1)}${p(d.getDate())}`;
    }

    // ===== 이미지/폰트 로딩 대기 =====
    async function waitForImages(root=document){
      const imgs = $$('img', root).filter(img=>!img.complete || img.naturalWidth===0);
      if(!imgs.length) return;
      await Promise.all(imgs.map(img=>new Promise(res=>{
        img.addEventListener('load', res,  {once:true});
        img.addEventListener('error', res, {once:true});
      })));
    }

    // data-name → 파일명 파트
    function elName(el, idx){
      return el.getAttribute('data-name') || `page_${String(idx+1).padStart(2,'0')}`;
    }

    // ===== 캡처 =====
    async function render(el){
      el.scrollIntoView({block:'center', inline:'center'});
      await waitForImages(el);
      try{ await document.fonts.ready; }catch(e){}
      const scale = (window.devicePixelRatio && window.devicePixelRatio > 1) ? 2 : 1.5;
      return await html2canvas(el, {
        scale,
        backgroundColor:'#FFFFFF',
        useCORS:true,
        allowTaint:false,
        logging:false,
        windowWidth: document.documentElement.scrollWidth,
        windowHeight: document.documentElement.scrollHeight
      });
    }

    function canvasToBlob(canvas, type='image/png', quality=0.92){
      return new Promise(res=>canvas.toBlob(b=>res(b), type, quality));
    }

    // ===== 개별 PNG 다운로드 =====
    async function downloadIndividually(prefixOverride){
      const prefix = prefixOverride || getPrefix();
      const pages = $$('.a4-wrap');
      let i=0;
      for(const el of pages){
        const cvs  = await render(el);
        const blob = await canvasToBlob(cvs);
        const url  = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${prefix}_${elName(el,i)}.png`; // 파일명 규칙
        document.body.appendChild(a);
        a.click();
        a.remove();
        URL.revokeObjectURL(url);
        i++;
      }
    }

    // ===== ZIP 묶음 다운로드 =====
    async function downloadAsZip(prefixOverride){
      const prefix = prefixOverride || getPrefix();
      const pages = $$('.a4-wrap');
      const zip = new JSZip();
      let i=0;
      for(const el of pages){
        const cvs  = await render(el);
        const blob = await canvasToBlob(cvs);
        const name = `${String(i+1).padStart(2,'0')}_${elName(el,i)}.png`; // ZIP 내부 파일명
        zip.file(name, blob);
        i++;
      }
      const zipped = await zip.generateAsync({type:'blob', compression:'DEFLATE'});
      const url = URL.createObjectURL(zipped);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${stamp(prefix)}.zip`; // ZIP 파일명 규칙
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
    }

    // ===== 버튼 연결 =====
    const btnZip  = document.getElementById('downloadA4Zip');
    const btnEach = document.getElementById('downloadA4Each');
    if(btnZip)  btnZip.addEventListener('click',  ()=>downloadAsZip(getPrefix()));
    if(btnEach) btnEach.addEventListener('click', ()=>downloadIndividually(getPrefix()));
  })();
  </script>



  <!-- (선택) Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  </body>
</html>