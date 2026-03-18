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
    Set RsC = Server.CreateObject ("ADODB.Recordset")
    Set Rs = Server.CreateObject ("ADODB.Recordset")
    Set Rs1 = Server.CreateObject ("ADODB.Recordset")
    Set Rs2 = Server.CreateObject ("ADODB.Recordset")
    Set Rs3 = Server.CreateObject ("ADODB.Recordset")

    projectname="절곡 발주서"

' ===== 함수 정의 영역 =====
Function SafeStr(val)
    On Error Resume Next
    If IsNull(val) Or IsEmpty(val) Then
        SafeStr = ""
    Else
        SafeStr = Trim(CStr(val))
    End If
    On Error GoTo 0
End Function
' ==========================

    page_name="TNG1_B_baljuST.asp?"

    rsjcidx=request("cidx") '발주처idx
    rsjcidx=request("sjcidx") '발주처idx 
    rsjmidx=request("sjmidx") '거래처담당자idx
    rsjidx=request("sjidx") '수주idx
    rsjsidx=request("sjsidx") '품목idx

baidx=Request("baidx")
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<meta name="description" content="" />
<meta name="author" content="" />
<title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<style>



</style>

</head>

<body class="sb-nav-fixed">

    <div id="layoutSidenav_content">
        <main>
        <!-- 헤더 -->
 

            <div id="pdfArea" style="background-color:#ffffff; border-radius:8px; display:block;">
            
                <div class="barasi-card">

                        <!-- 🔸 본문 -->
                        <div class="barasi-body">

  

                            <!-- ② SVG (절곡도면) -->
                            <div class="cell info">
                                <div class="card card-body text-start" style="background:#fff; overflow:hidden;">
                                    <!-- * SVG 코드 시작 -->
                                    <svg id="mySVG"
                                        viewBox="0 0 100 100"
                                        width="220"
                                        height="230"
                                        'width="100%"
                                        'height="100%"
                                        fill="none"
                                        stroke="#000"
                                        stroke-width="1"
                                        preserveAspectRatio="xMidYMid meet"
                                        style="display:block; margin:0 auto;">

                                    <%
                                    SQL = "SELECT basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv, tx, ty FROM tk_barasisub WHERE baidx='" & baidx & "' ORDER BY basidx ASC"
                                    Rs2.Open SQL, Dbcon
                                    If Not (Rs2.BOF Or Rs2.EOF) Then
                                        Do While Not Rs2.EOF
                                            basidx = Rs2(0)
                                            bassize = Rs2(1)
                                            basdirection = Rs2(2)
                                            x1 = CDbl(Rs2(3))
                                            y1 = CDbl(Rs2(4))
                                            x2 = CDbl(Rs2(5))
                                            y2 = CDbl(Rs2(6))
                                            accsize = Rs2(7)
                                            idv = Rs2(8)
                                            tx1 = Rs2(9)  ' 데이터베이스에서 tx 가져오기
                                            ty1 = Rs2(10) ' 데이터베이스에서 ty 가져오기

                                    %>
                                            <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                                    <%
                                            If bassize=Int(bassize) Then bassize_int=FormatNumber(bassize,0) Else bassize_int=FormatNumber(bassize,1)
                                    %>
                                            <text x="<%=tx1%>" y="<%=ty1%>" fill="#000" font-size="12" font-family="Arial" font-weight="600" text-anchor="middle" dominant-baseline="middle" style="paint-order:stroke;stroke:white;stroke-width:0.6px;cursor:move;user-select:none;" data-basidx="<%=basidx%>" data-tx="<%=tx1%>" data-ty="<%=ty1%>" oncontextmenu="showPositionEditor(this, event); return false;" onmousedown="startDrag(this, event)" draggable="false"><%=bassize_int%></text>
                                    <%
                                            Rs2.MoveNext
                                        Loop
                                        Rs2.Close
                                    End If
                                    %>
                                    </svg>

                                    <!-- 고정 에디터 컨테이너 -->
                                    <div id="fixedEditorContainer" style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); z-index: 1000;"></div>

                                    <!-- * SVG 코드 끝 -->
                                </div>
                            </div>
                            <!-- 👇 SVGFit 스크립트는 도면 아래로 이동 -->
                            <script>
                            (function (root) {
                            function getTransformedBBox(el) { ... }   // 동일
                            function getPPU(svg) { ... }              // 동일
                            function compensateTexts(svg, groups, factor) { ... }  // 동일
                            function fitAllById(svgId='canvas', groupId='viewport', {padding=20,setSize=false}={}) { ... } // 동일
                            root.SVGFit = { fitAllById };
                            })(window);

                            // ✅ 여기서 실행 (도면 완성 후)
                            window.addEventListener('load', () => {
                            const svg = document.querySelector('#mySVG');
                            if (svg) {
                                svg.setAttribute('preserveAspectRatio', 'xMinYMin meet');
                                const bb = svg.getBBox();
                                svg.setAttribute('viewBox', `${bb.x - 20} ${bb.y - 20} ${bb.width + 40} ${bb.height + 40}`);
                            }
                            });
                            </script>

                            <!-- ④ 길이 출력 -->
                            <div class="cell length">
                               

                            </div>
                        </div>
                </div>
 
            </div>
 

        </main>
    </div>
    <script src="/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/svg-pan-zoom@3.6.1/dist/svg-pan-zoom.min.js"></script>


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


<script>
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("svg[id^='mySVG']").forEach(svg => {
    const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
    Array.from(svg.children).forEach(child => group.appendChild(child));
    svg.appendChild(group);

    const lines = group.querySelectorAll("line");
    const texts = group.querySelectorAll("text");
    if (!lines.length && !texts.length) return;

    // ===== 1) bbox 수집 =====
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    [...lines, ...texts].forEach(el => {
      const x1 = parseFloat(el.getAttribute("x1")) || parseFloat(el.getAttribute("x"));
      const y1 = parseFloat(el.getAttribute("y1")) || parseFloat(el.getAttribute("y"));
      const x2 = parseFloat(el.getAttribute("x2"));
      const y2 = parseFloat(el.getAttribute("y2"));
      if (!isNaN(x1)) minX = Math.min(minX, x1);
      if (!isNaN(y1)) minY = Math.min(minY, y1);
      if (!isNaN(x2)) maxX = Math.max(maxX, x2);
      if (!isNaN(y2)) maxY = Math.max(maxY, y2);
      if (isNaN(x2) && !isNaN(x1)) maxX = Math.max(maxX, x1);
      if (isNaN(y2) && !isNaN(y1)) maxY = Math.max(maxY, y1);
    });

    // ===== 2) 스케일/이동 =====
    const width = maxX - minX;
    const height = maxY - minY;
    const maxDim = Math.max(width, height);
    const targetSize = 100;

    let paddingRatio = 1.2;
    if (maxDim > 200) paddingRatio = 1.3;
    if (maxDim > 400) paddingRatio = 1.4;
    if (maxDim > 800) paddingRatio = 1.5;

    const scale = targetSize / (maxDim * paddingRatio);
    const cx = (minX + maxX) / 2;
    const cy = (minY + maxY) / 2;
    const translateX = (targetSize / 2) - (cx * scale);
    const translateY = (targetSize / 2) - (cy * scale);
    group.setAttribute("transform", `translate(${translateX},${translateY}) scale(${scale})`);

    // ===== 3) 선 두께 보정 =====
    const strokeWidth = Math.max(0.4, Math.min(2.5, 1 / scale));
    lines.forEach(l => l.setAttribute("stroke-width", strokeWidth));

    // ===== 4) 숫자 파싱 =====
    const parseNumber = s => {
      const v = parseFloat(String(s||"").replace(/[^0-9.\-]/g,""));
      return isNaN(v) ? null : v;
    };

    // 최대 길이
    let maxLen = 0, vals = [];
    texts.forEach(t => {
      const v = parseNumber(t.textContent);
      if (v !== null) { vals.push(v); if (v > maxLen) maxLen = v; }
    });

    // ===== 5) 기본 폰트 =====
    let fontScale = 1 / (scale * 0.6);
    let fontSize = 10 * fontScale;

    // 강제 확대 (네 규칙 유지)
    if (maxLen > 150 && maxLen <= 190) fontSize = Math.max(fontSize, 12);
    else if (maxLen > 190 && maxLen <= 250) fontSize = Math.max(fontSize, 30);
    else if (maxLen > 250 && maxLen <= 400) fontSize = Math.max(fontSize, 50);
    else if (maxLen > 400 && maxLen <= 500) fontSize = Math.max(fontSize, 60);
    else if (maxLen > 500 && maxLen <= 800) fontSize = Math.max(fontSize, 70);
    else if (maxLen > 800) fontSize = Math.max(fontSize, 80);
    if (fontSize < 8) fontSize = 8;

    // ===== 6) 기본 offsetDistance =====
    let offsetDistance = 1;
    if (maxLen <= 150) offsetDistance = 1;
    else if (maxLen <= 190) offsetDistance = 15;
    else if (maxLen <= 250) offsetDistance = 35;
    else if (maxLen <= 400) offsetDistance = 40;
    else if (maxLen <= 500) offsetDistance = 50;
    else if (maxLen <= 800) offsetDistance = 60;
    else offsetDistance = 70;

    // 기본 폰트 속성
    const px = fontSize.toFixed(1) + 'px';
    texts.forEach(t => {
      t.setAttribute('font-size', fontSize.toFixed(1));
      t.style.setProperty('font-size', px, 'important');
      t.setAttribute('font-family', 'Arial, Helvetica, sans-serif');
      t.setAttribute('paint-order', 'stroke');
      t.setAttribute('stroke', 'white');
      t.setAttribute('stroke-width', '0.6px');
    });

    svg.style.overflow = 'visible';

    // ===== 7) 먼저 라인 법선 방향으로 1차 이동 (요소별 _offset 우선) =====
    texts.forEach((t, idx) => {
      const tx = parseFloat(t.getAttribute("x"));
      const ty = parseFloat(t.getAttribute("y"));
      if (isNaN(tx) || isNaN(ty)) return;

      // 가장 가까운 라인
      let nearest = null, best = Infinity;
      lines.forEach(l => {
        const x1 = parseFloat(l.getAttribute("x1"));
        const y1 = parseFloat(l.getAttribute("y1"));
        const x2 = parseFloat(l.getAttribute("x2"));
        const y2 = parseFloat(l.getAttribute("y2"));
        if ([x1,y1,x2,y2].some(isNaN)) return;
        const mx = (x1 + x2)/2, my = (y1 + y2)/2;
        const d = Math.hypot(tx - mx, ty - my);
        if (d < best) { best = d; nearest = {x1,y1,x2,y2}; }
      });

      if (!nearest) return;

      const vx = nearest.x2 - nearest.x1;
      const vy = nearest.y2 - nearest.y1;
      const len = Math.hypot(vx, vy);
      if (len === 0) return;

      const nx = -vy / len;
      const ny =  vx / len;

      // 👇 요소별 오버라이드(_offset) 우선 적용
      const thisOffset = t.dataset._offset ? parseFloat(t.dataset._offset) : offsetDistance;

      t.setAttribute("x", (tx + nx * thisOffset));
      t.setAttribute("y", (ty + ny * thisOffset));
      t.dataset._moved = "1";
      t.dataset._idx = String(idx);
    });

    // ===== 8) 겹침 탐지(원근사) =====
    const coords = Array.from(texts).map((t,i) => ({
      i,
      x: parseFloat(t.getAttribute("x")),
      y: parseFloat(t.getAttribute("y")),
      fs: parseFloat(t.getAttribute("font-size")) || fontSize
    }));

    const overlaps = [];
    for (let i = 0; i < coords.length; i++) {
      for (let j = i+1; j < coords.length; j++) {
        const dx = coords[i].x - coords[j].x;
        const dy = coords[i].y - coords[j].y;
        const dist = Math.hypot(dx, dy);

        const rTight = (coords[i].fs + coords[j].fs) * 0.2;
        const rLoose = (coords[i].fs + coords[j].fs) * 0.3;

        let type = null;
        if (dist < rTight) type = "tight";
        else if (dist < rLoose) type = "loose";

        if (type) overlaps.push({i, j, type, dist});
      }
    }

    // ===== 9) 텍스트별 "최대 severity"만 취합 =====
    // rank: none(0) < loose(1) < tight(2)
    const rank = { none:0, loose:1, tight:2 };
    const perText = Array.from({length: texts.length}, () => ({severity:"none"}));

    overlaps.forEach(o => {
      if (rank[o.type] > rank[perText[o.i].severity]) perText[o.i].severity = o.type;
      if (rank[o.type] > rank[perText[o.j].severity]) perText[o.j].severity = o.type;
    });

    // ===== 10) 겹침 반영 (텍스트당 1회만) =====
    const SHRINK_TIGHT = 0.4;
    const SHRINK_LOOSE = 0.6;
    const TIGHT_OFFSET = 200;   // tight 전용 수동 오프셋
    const LOOSE_OFFSET = null;  // null이면 유지

    perText.forEach((st, idx) => {
    if (st.severity === "none") return;
    const t = texts[idx];
    const origSize = parseFloat(t.getAttribute("font-size")) || fontSize;
    const shrink = (st.severity === "tight") ? SHRINK_TIGHT : SHRINK_LOOSE;
    const newSize = (origSize * shrink).toFixed(1);
    /*
    t.setAttribute("font-size", newSize);
    t.style.setProperty("font-size", newSize + "px", "important");
    t.setAttribute("fill", "#ff0000");
    */

    // ✅ 여기서 targetOffset도 저장
    if (st.severity === "tight") {
        t.dataset._tight = "1";
        t.dataset._offset = String(TIGHT_OFFSET);
        t.dataset._targetOffset = String(TIGHT_OFFSET);  // ✅ 추가
    } else {
        t.dataset._tight = "0";
        if (LOOSE_OFFSET != null) {
        t.dataset._offset = String(LOOSE_OFFSET);
        t.dataset._targetOffset = String(LOOSE_OFFSET); // ✅ 추가
        }
    }
    });

    // ===== 13) ✅ 2차 이동: targetOffset과 baseOffset의 차이만큼 추가 이동 =====
        texts.forEach((t) => {
        const target = t.dataset._targetOffset ? parseFloat(t.dataset._targetOffset) : null;
        const base   = t.dataset._baseOffset ? parseFloat(t.dataset._baseOffset) : null;
        const nx     = t.dataset._nx ? parseFloat(t.dataset._nx) : null;
        const ny     = t.dataset._ny ? parseFloat(t.dataset._ny) : null;
        if (target == null || base == null || nx == null || ny == null) return;

        const delta = target - base;        // 원하는 오프셋 - 기존 적용 오프셋
        if (Math.abs(delta) < 0.001) return;

        const x = parseFloat(t.getAttribute("x")) || 0;
        const y = parseFloat(t.getAttribute("y")) || 0;
        t.setAttribute("x", (x + nx * delta));
        t.setAttribute("y", (y + ny * delta));

        // 기록 갱신
        t.dataset._baseOffset = String(thisOffset);
        t.dataset._nx = String(nx);
        t.dataset._ny = String(ny);
        });

    // ===== 디버그 =====
    console.group(`SVG ${svg.id} 디버그`);
    console.log('texts=', texts.length, 'overlaps=', overlaps.length);
    console.log('severity=', perText.map(s=>s.severity));
    console.groupEnd();
  });
});
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
    // 루프된 모든 barasi-card 추적
    const cards = document.querySelectorAll('.barasi-card');
    console.group('🧩 barasi-card layout debug');
    console.log(`총 ${cards.length}개 barasi-card 발견됨`);
    cards.forEach((card, i) => {
        const cs = getComputedStyle(card);
        console.log(
        `%c#${i+1} [barasi-card]`,
        'color:#0af;font-weight:bold;',
        {
            display: cs.display,
            flexGrow: cs.flexGrow,
            flexShrink: cs.flexShrink,
            height: cs.height,
            overflow: cs.overflow,
            marginBottom: cs.marginBottom
        }
        );
    });
    console.groupEnd();

    // flex가 살아있는 부모 컨테이너 찾기
    const pdfArea = document.querySelector('#pdfArea');
    const pdfCS = getComputedStyle(pdfArea);
    console.group('🧩 pdfArea 상태');
    console.log('display=', pdfCS.display, '| overflow=', pdfCS.overflow);
    console.groupEnd();

    // barasi-body 내부 cell 균등 확인
    document.querySelectorAll('.barasi-body').forEach((body, idx) => {
        const cells = body.querySelectorAll('.cell');
        if (!cells.length) return;
        const widths = Array.from(cells).map(c => c.offsetWidth.toFixed(1));
        console.log(`barasi-body[${idx}] cell width:`, widths.join(' / '));
    });

    // 전체 높이 변화 추적 (1초마다)
    let lastHeights = [];
    setInterval(() => {
        const heights = Array.from(cards).map(c => c.offsetHeight);
        if (JSON.stringify(heights) !== JSON.stringify(lastHeights)) {
        console.warn('⚠️ barasi-card 높이 변화 감지:', heights);
        lastHeights = heights;
        }
    }, 1000);
    });
</script>

<script>
document.addEventListener('DOMContentLoaded', () => {
  try {
    const svgs = document.querySelectorAll('svg#canvas');
    if (!svgs.length) {
      console.error('❌ SVGFit: canvas ID를 가진 <svg>를 찾을 수 없습니다.');
      return;
    }

    svgs.forEach((svg, i) => {
      const g = svg.querySelector('#viewport');
      if (!g) {
        console.error(`❌ SVG ${i+1}: #viewport 그룹이 없습니다.`);
      } else {
        const bb = g.getBBox();
        console.log(`✅ SVG ${i+1} bbox: x=${bb.x}, y=${bb.y}, w=${bb.width}, h=${bb.height}`);
      }
    });

    SVGFit.fitAllById('canvas', 'viewport', {
      padding: 20,
      setSize: false,
      preserve: 'xMidYMid meet',
    });
  } catch (err) {
    console.error('🔥 SVGFit 에러 발생:', err);
  }
});
</script>

<!-- ✅ 도면용 스크립트 -->
<script>
(function (root) {
  function getTransformedBBox(el) {
    const bb = el.getBBox();
    const m  = el.getCTM();
    if (!m) return bb;

    const P = (x, y) => {
      const pt = el.ownerSVGElement.createSVGPoint();
      pt.x = x; pt.y = y;
      return pt.matrixTransform(m);
    };
    const p1 = P(bb.x, bb.y);
    const p2 = P(bb.x + bb.width, bb.y);
    const p3 = P(bb.x, bb.y + bb.height);
    const p4 = P(bb.x + bb.width, bb.y + bb.height);
    const xs = [p1.x, p2.x, p3.x, p4.x];
    const ys = [p1.y, p2.y, p3.y, p4.y];
    return {
      x: Math.min(...xs),
      y: Math.min(...ys),
      width: Math.max(...xs) - Math.min(...xs),
      height: Math.max(...ys) - Math.min(...ys)
    };
  }

  function getPPU(svg) {
    const m = svg.getScreenCTM && svg.getScreenCTM();
    if (!m) return 1;
    const sx = Math.hypot(m.a, m.b);
    const sy = Math.hypot(m.c, m.d);
    return (sx + sy) / 2 || 1;
  }

  function compensateTexts(svg, groups, factor) {
    if (!factor || factor === 1) return;
    const nodes = [];
    for (const g of groups) nodes.push(...g.querySelectorAll('text, .dim-text, .label'));
    const f = Math.max(0.75, Math.min(2.5, factor));
    nodes.forEach(el => {
      el.style.transformBox = 'fill-box';
      el.style.transformOrigin = 'center';
      el.style.transform = `scale(${f})`;
    });
  }

  function fitAllById(svgId='canvas', groupId='viewport', {padding=20,setSize=false}={}) {
    const svgs = document.querySelectorAll(`svg[id="${svgId}"]`);
    for (const svg of svgs) {
      const groups = svg.querySelectorAll(`[id="${groupId}"]`);
      if (!groups.length) continue;

      const bb = getTransformedBBox(groups[0]);
      const x = bb.x - padding;
      const y = bb.y - padding;
      const w = bb.width + padding * 2;
      const h = bb.height + padding * 2;
      svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);
      svg.setAttribute('preserveAspectRatio', 'xMinYMin meet');

      requestAnimationFrame(() => {
        const before = getPPU(svg);
        const after = getPPU(svg);
        compensateTexts(svg, groups, before / after);
      });
    }
  }
  root.SVGFit = { fitAllById };
})(window);

document.addEventListener('DOMContentLoaded', () => {
  SVGFit.fitAllById('canvas', 'viewport', {padding:20,setSize:false});
});
</script>

<script>
  let currentEditor = null;
  let currentBasidx = null;
  
  // 드래그 관련 변수
  let isDragging = false;
  let dragElement = null;
  let dragOffset = { x: 0, y: 0 };
  let svg = null;
  let svgRect = null;

  // 드래그 시작
  function startDrag(textElement, event) {
    // 우클릭이면 드래그하지 않음 (에디터 표시)
    if (event.button === 2) return;
    
    event.preventDefault();
    event.stopPropagation();
    
    isDragging = true;
    dragElement = textElement;
    svg = document.getElementById('mySVG');
    svgRect = svg.getBoundingClientRect();
    
    // 현재 텍스트 위치
    const currentX = parseFloat(textElement.getAttribute('x'));
    const currentY = parseFloat(textElement.getAttribute('y'));
    
    // 마우스 위치를 SVG 좌표계로 변환
    const mouseX = (event.clientX - svgRect.left) * (svg.viewBox.baseVal.width / svgRect.width) + svg.viewBox.baseVal.x;
    const mouseY = (event.clientY - svgRect.top) * (svg.viewBox.baseVal.height / svgRect.height) + svg.viewBox.baseVal.y;
    
    // 드래그 오프셋 계산
    dragOffset.x = mouseX - currentX;
    dragOffset.y = mouseY - currentY;
    
    // 텍스트 스타일 변경 (드래그 중임을 표시)
    textElement.style.opacity = '0.7';
    textElement.style.fill = '#007bff';
    
    // 전역 이벤트 리스너 추가
    document.addEventListener('mousemove', drag);
    document.addEventListener('mouseup', stopDrag);
    
    // 클릭 이벤트 방지
    setTimeout(() => {
      textElement.onclick = null;
    }, 10);
  }
  
  // 드래그 중
  function drag(event) {
    if (!isDragging || !dragElement) return;
    
    event.preventDefault();
    
    // 마우스 위치를 SVG 좌표계로 변환
    const mouseX = (event.clientX - svgRect.left) * (svg.viewBox.baseVal.width / svgRect.width) + svg.viewBox.baseVal.x;
    const mouseY = (event.clientY - svgRect.top) * (svg.viewBox.baseVal.height / svgRect.height) + svg.viewBox.baseVal.y;
    
    // 새 위치 계산
    const newX = Math.round(mouseX - dragOffset.x);
    const newY = Math.round(mouseY - dragOffset.y);
    
    // 텍스트 위치 업데이트
    dragElement.setAttribute('x', newX);
    dragElement.setAttribute('y', newY);
  }
  
  // 드래그 종료
  function stopDrag(event) {
    if (!isDragging || !dragElement) return;
    
    isDragging = false;
    
    // 최종 위치 저장
    const finalX = Math.round(parseFloat(dragElement.getAttribute('x')));
    const finalY = Math.round(parseFloat(dragElement.getAttribute('y')));
    
    // 데이터 속성 업데이트
    dragElement.setAttribute('data-tx', finalX);
    dragElement.setAttribute('data-ty', finalY);
    
    // 스타일 복원
    dragElement.style.opacity = '1';
    dragElement.style.fill = '#000';
    
    // 데이터베이스 업데이트
    const basidx = dragElement.getAttribute('data-basidx');
    updateDatabase(basidx, finalX, finalY);
    
    // 이벤트 리스너 제거
    document.removeEventListener('mousemove', drag);
    document.removeEventListener('mouseup', stopDrag);
    
    // 클릭 이벤트 복원
    setTimeout(() => {
      dragElement.onclick = function(e) { showPositionEditor(this, e); };
    }, 100);
    
    dragElement = null;
    svg = null;
    svgRect = null;
  }

  // 고정 위치 에디터 보이기
  function showPositionEditor(textElement, event) {
    event.stopPropagation();
    
    const basidx = textElement.getAttribute('data-basidx');
    const currentTx = Math.round(parseFloat(textElement.getAttribute('data-tx')));
    const currentTy = Math.round(parseFloat(textElement.getAttribute('data-ty')));
    
    currentBasidx = basidx;
    
    // 고정 컨테이너에 에디터 생성
    const container = document.getElementById('fixedEditorContainer');
    container.innerHTML = `
      <div style="background: white; border: 2px solid #007bff; border-radius: 8px; padding: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.3); min-width: 180px;" onclick="event.stopPropagation();">
        <div style="margin-bottom: 15px; font-weight: bold; text-align: center; color: #007bff; font-size: 14px;">위치 조정</div>
        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
          <span style="min-width: 20px; font-weight: bold; color: #666;">X:</span>
          <input type="number" id="txInput" value="${currentTx}" step="1" style="width: 80px; padding: 6px; border: 1px solid #ddd; border-radius: 4px; text-align: center; font-size: 13px;" onclick="event.stopPropagation();" oninput="previewPosition()">
        </div>
        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px;">
          <span style="min-width: 20px; font-weight: bold; color: #666;">Y:</span>
          <input type="number" id="tyInput" value="${currentTy}" step="1" style="width: 80px; padding: 6px; border: 1px solid #ddd; border-radius: 4px; text-align: center; font-size: 13px;" onclick="event.stopPropagation();" oninput="previewPosition()">
        </div>
        <div style="text-align: center; display: flex; gap: 8px; justify-content: center;">
          <button onclick="savePosition()" style="background: #28a745; color: white; border: none; padding: 6px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">저장</button>
          <button onclick="hidePositionEditor()" style="background: #6c757d; color: white; border: none; padding: 6px 16px; border-radius: 4px; cursor: pointer; font-size: 12px;">취소</button>
        </div>
      </div>
    `;
    
    currentEditor = { container, textElement, basidx };
  }

  // 에디터 숨기기 (취소 시 원래 위치로 복원)
  function hidePositionEditor() {
    if (currentEditor) {
      // 원래 위치로 복원
      const textElement = currentEditor.textElement;
      const originalTx = textElement.getAttribute('data-tx');
      const originalTy = textElement.getAttribute('data-ty');
      
      textElement.setAttribute('x', originalTx);
      textElement.setAttribute('y', originalTy);
      
      currentEditor.container.innerHTML = '';
      currentEditor = null;
      currentBasidx = null;
    }
  }

  // 실시간 위치 프리뷰 (DB 저장 없이 화면에만 반영)
  function previewPosition() {
    if (!currentEditor) return;
    
    const txInput = document.getElementById('txInput');
    const tyInput = document.getElementById('tyInput');
    
    if (!txInput || !tyInput) return;
    
    const newTx = Math.round(parseFloat(txInput.value)) || 0;
    const newTy = Math.round(parseFloat(tyInput.value)) || 0;
    
    const textElement = currentEditor.textElement;
    
    // 화면상에만 텍스트 위치 업데이트 (임시)
    textElement.setAttribute('x', newTx);
    textElement.setAttribute('y', newTy);
  }

  // 저장 버튼 클릭 시 위치 업데이트
  function savePosition() {
    if (!currentEditor || !currentBasidx) return;
    
    const txInput = document.getElementById('txInput');
    const tyInput = document.getElementById('tyInput');
    
    if (!txInput || !tyInput) return;
    
    const newTx = Math.round(parseFloat(txInput.value)) || 0;
    const newTy = Math.round(parseFloat(tyInput.value)) || 0;
    
    const textElement = currentEditor.textElement;
    
    // 텍스트 위치 업데이트
    textElement.setAttribute('x', newTx);
    textElement.setAttribute('y', newTy);
    textElement.setAttribute('data-tx', newTx);
    textElement.setAttribute('data-ty', newTy);
    
    // 데이터베이스 업데이트 (AJAX)
    updateDatabase(currentBasidx, newTx, newTy);
    
    // 저장 후 에디터 숨기기
    hidePositionEditor();
  }

  // 데이터베이스 업데이트
  function updateDatabase(basidx, tx, ty) {
    fetch('tng1_julgok_in_sub3.asp', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: `part=update_position&basidx=${basidx}&tx=${tx}&ty=${ty}`
    })
    .then(response => response.text())
    .then(data => {
      console.log('위치 업데이트 완료:', basidx, tx, ty);
    })
    .catch(error => {
      console.error('위치 업데이트 실패:', error);
    });
  }

  // 다른 곳 클릭 시 에디터 숨기기
  document.addEventListener('click', function(event) {
    if (!event.target.closest('#fixedEditorContainer') && !event.target.closest('text[data-basidx]')) {
      hidePositionEditor();
    }
  });
</script>
</body>
</html>

<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()

%>