<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet  = "utf-8"

sjidx = Request("sjidx")
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->







<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>ZT231</title>
<style>
  :root{
    --wmm:100; --hmm:45; --pad:2; --radius:2.5mm; --line:0.2mm;
    --r1: 9mm; --r2: 9mm; --r3: 9mm; --r4: 7mm; --r5: 7mm;
  }
  html, body { margin:0; padding:0; background:#fff; font-family: system-ui,-apple-system,"Noto Sans KR","Malgun Gothic",sans-serif; }
  @page label { size: 100mm 45mm; margin: 0; }

  .label{
    width: calc(var(--wmm) * 1mm);
    height: calc(var(--hmm) * 1mm);
    page: label; break-after: always;
    position: relative; box-sizing: border-box;
    border-radius: var(--radius); background:#fff;
    padding: calc(var(--pad) * 1mm);
    overflow: hidden;
    outline: 0.25mm solid rgba(0,0,0,.06);
  }
  .label::after{
    content:""; position:absolute; inset:1.2mm;
    border-radius: calc(var(--radius) - 1.2mm);
    border:.22mm dashed rgba(0,0,0,.16); pointer-events:none;
  }

  table{
    width:100%;
    height: calc( (var(--hmm) * 1mm) - 2 * (var(--pad) * 1mm) );
    border-collapse: collapse; table-layout: fixed;
    line-height:1.12; font-size:3mm; /* 초기값, JS가 덮어씀 */
  }
  th, td{
    border: var(--line) solid #111;
    padding:0.6mm 0.8mm; vertical-align:middle;
    overflow:hidden; word-break: break-word;
  }
  th{ background:#f3f4f6; font-weight:400; font-size:2mm; text-align:center; }
  td{ font-weight:600; }
  .center{ text-align:center; }
  .v-vert{ writing-mode: vertical-rl; text-orientation: upright; line-height:1; }

  col.w-th{width:10%} col.w-td{width:13%} col.w-qrth{width:8%} col.w-qrtd{width:8%}

  tbody tr:nth-child(1){height:var(--r1);min-height:var(--r1);max-height:var(--r1)}
  tbody tr:nth-child(2){height:var(--r2);min-height:var(--r2);max-height:var(--r2)}
  tbody tr:nth-child(3){height:var(--r3);min-height:var(--r3);max-height:var(--r3)}
  tbody tr:nth-child(4){height:var(--r4);min-height:var(--r4);max-height:var(--r4)}
  tbody tr:nth-child(5){height:var(--r5);min-height:var(--r5);max-height:var(--r5)}

  .qr-slot{ text-align:center; padding:0; }
  .qr-code{
    display:inline-flex; align-items:center; justify-content:center;
    width:10mm; height:10mm; border:0.3mm solid #111;
    font-size:2.4mm; font-weight:700; margin:0.5mm; box-sizing:border-box;
  }

  @media print{ .label{ outline:none } /* .label::after{display:none} */ }
</style>
</head>
<body>













<%
Call dbOpen()

Dim sql, rs, rs1, i, cnt, sun_fkidx_1, sunno
i   = 0
cnt = 0

' =====================[ 1) 메인 품목 목록 ]=====================
sql = ""
sql = sql & "SELECT DISTINCT "
sql = sql & "  c.cname                                 AS cname, "
sql = sql & "  sja.cgaddr                               AS cgaddr, "
sql = sql & "  sja.sjnum                                AS sjnum, "
sql = sql & "  sjs.asub_wichi1                          AS loc1, "
sql = sql & "  sjs.asub_wichi2                          AS loc2, "
sql = sql & "  (sb.SJB_barlist + ' ' + sbt.SJB_TYPE_NAME) AS framename, "
sql = sql & "  qc.qtyname                               AS qtyname, "
sql = sql & "  p.pname                                  AS pname, "
sql = sql & "  sjs.quan                                 AS quan, "
sql = sql & "  fk.tw                                 AS tw, "
sql = sql & "  fk.th                                 AS th, "
sql = sql & "  fk.fkidx                                 AS sun_fkidx, "
sql = sql & "  fk.sjb_type_no                           AS sun_sjb_type_no "
sql = sql & "FROM tng_sjaSub      AS sjs "
sql = sql & "LEFT JOIN tng_sja    AS sja ON sjs.sjidx   = sja.sjidx "
sql = sql & "LEFT JOIN tk_customer AS c   ON c.cidx     = sja.sjcidx "
sql = sql & "LEFT JOIN tk_framek   AS fk  ON sjs.sjsidx = fk.sjsidx "
sql = sql & "LEFT JOIN tng_sjb     AS sb  ON sb.sjb_idx = fk.sjb_idx "
sql = sql & "LEFT JOIN tng_sjbtype AS sbt ON sbt.SJB_TYPE_NO = sb.SJB_TYPE_NO "
sql = sql & "LEFT JOIN tk_qty      AS q   ON sjs.qtyidx = q.qtyidx "
sql = sql & "LEFT JOIN tk_qtyco    AS qc  ON q.qtyno    = qc.qtyno "
sql = sql & "LEFT JOIN tk_paint    AS p   ON sjs.pidx   = p.pidx "
sql = sql & "WHERE sjs.sjidx <> '0' "
sql = sql & "  AND sjs.sjidx = " & CLng(sjidx) & " "
sql = sql & "  AND sjs.astatus = '1';"

Set rs = Dbcon.Execute(sql)
If Not (rs.BOF Or rs.EOF) Then
  Do While Not rs.EOF
    i = i + 1

    cname              = rs("cname")
    cgaddr             = rs("cgaddr")
    sjnum              = rs("sjnum")
    loc1               = rs("loc1")
    loc2               = rs("loc2")
    framename          = rs("framename")
    qtyname            = rs("qtyname")
    pname              = rs("pname")
    quan               = rs("quan")
    sun_fkidx          = rs("sun_fkidx")
    sun_sjb_type_no    = rs("sun_sjb_type_no")
    tw          = rs("tw")
    th    = rs("th")
    

    ' =====================[ 2) 서브(자재) 목록 ]=====================
    sql = ""
    sql = sql & "SELECT fks.fksidx AS fksidx "
    sql = sql & "FROM tk_framekSub AS fks "
    sql = sql & "JOIN tk_framek    AS fk  ON fks.fkidx = fk.fkidx "
    sql = sql & "WHERE fks.fkidx = " & CLng(sun_fkidx) & " "
    sql = sql & "  AND fks.gls = 0 "
    sql = sql & "  AND fks.sunstatus IN (0,5,6) "

    If CLng(sun_sjb_type_no) >= 1 And CLng(sun_sjb_type_no) <= 5 Then
    sql = sql & "  AND fks.WHICHI_AUTO NOT IN (9,24) "
    End If

    Set rs1 = Dbcon.Execute(sql)
If Not (rs1.BOF Or rs1.EOF) Then
  Do While Not rs1.EOF
    zfksidx = rs1("fksidx")

    cnt = cnt + 1
    If cnt = 1 Then sun_fkidx_1 = sun_fkidx
    sunno = CLng(sun_fkidx) - CLng(sun_fkidx_1) + 1

    copies = 1
    If IsNumeric(quan) Then copies = CLng(quan)

    For copyIdx = 1 To copies
%>
<section class="label" aria-label="제품 생산관리 스티커">
  <table aria-label="제품 생산관리 표">
    <colgroup>
      <col class="w-th"><col class="w-td"><col class="w-td"><col class="w-td">
      <col class="w-th"><col class="w-td"><col class="w-td"><col class="w-td">
      <col class="w-qrth"><col class="w-qrtd">
    </colgroup>
    <tbody>
      <tr>
        <th class="v-vert">업체</th>
        <td colspan="3" data-max="3" data-min="2.2"><%=cname%></td>
        <th class="v-vert">수주</th>
        <td colspan="3" class="center" data-max="3" data-min="2.2"><%=sjnum%></td>
        <th>No.</th>
        <td class="center" data-max="3" data-min="2.2"><%=sunno%></td>
      </tr>
      <tr>
        <th class="v-vert">품명</th>
        <td colspan="3" data-max="3" data-min="2.2"><%=framename%></td>
        <th class="v-vert">검측</th>
        <td colspan="3" class="center" data-max="4" data-min="2.2"><%=tw%> × <%=th%></td>
        <th class="v-vert">수량</th>
        <td class="center" data-max="3" data-min="2.2"><%=quan%>개</td>
      </tr>
      <tr>
        <th class="v-vert">재질</th>
        <td colspan="4" data-max="3" data-min="2.2"><%=qtyname%></td>
        <th class="v-vert">도장</th>
        <td colspan="4" data-max="3" data-min="2.2"><%=pname%></td>
      </tr>
      <tr>
        <th class="v-vert">현장</th>
        <td colspan="6" data-max="3" data-min="2.2"><%=cgaddr%></td>
        <td rowspan="2" colspan="3" class="qr-slot"><div class="qr-code">QR</div></td>
      </tr>
      <tr>
        <th class="v-vert">위치</th>
        <td colspan="6" data-max="3" data-min="2.2"><%=loc1%> <%=loc2%></td>
      </tr>
    </tbody>
  </table>
</section>
<%
    Next ' copyIdx

    rs1.MoveNext
  Loop
End If

    If Not rs1 Is Nothing Then rs1.Close : Set rs1 = Nothing

    rs.MoveNext
  Loop
End If
If Not rs Is Nothing Then rs.Close : Set rs = Nothing


Call dbClose()
%>






<script>
/* 글자수에 비례해 1차 축소 → 2차 이진탐색으로 최대치 보정 */
(function(){
  // ===== 전역 설정(일괄 적용) =====
  const FIT_MAX = 4.0;     // 기본 최대(mm) — td의 data-max로 오버라이드 가능
  const FIT_MIN = 1.8;     // 기본 최소(mm) — td의 data-min으로 오버라이드 가능
  const REF_BASE = 14;     // 기준 글자수(이 이하이면 보통 최대에 가깝게)
  const BETA = 0.5;        // 비례 축소 강도(0.3 부드럽게 ~ 0.7 강하게)
  const EPS = 0.04;        // 이진탐색 정밀도(mm)

  function setFont(el, mm){ el.style.fontSize = mm + 'mm'; el.style.lineHeight = '1.12'; }
  function fits(el){ return el.scrollWidth <= el.clientWidth + 0.5 && el.scrollHeight <= el.clientHeight + 0.5; }

  function textLength(td){
    // 공백 압축, 줄바꿈 제거. 숫자/영문/한글 모두 1글자로 카운트
    const s = (td.innerText || td.textContent || '').replace(/\s+/g,' ').trim();
    return s.length || 1;
  }

  function initialGuess(td, max, min){
    const L = textLength(td);
    const ref = parseFloat(td.dataset.ref || REF_BASE);
    const beta = parseFloat(td.dataset.beta || BETA);
    // 글자수 비례 축소: max * (ref / L)^beta
    const guess = max * Math.pow(ref / Math.max(L,1), beta);
    return Math.max(min, Math.min(max, guess));
  }

  function fitOne(td){
    if (td.closest('.qr-slot')) return; // QR 칸 제외
    td.style.whiteSpace = 'normal';
    td.style.wordBreak  = 'break-word';
    td.style.overflow   = 'hidden';

    const max = parseFloat(td.dataset.max || FIT_MAX);
    const min = parseFloat(td.dataset.min || FIT_MIN);

    // 1) 글자수 기반 초기 추정
    let g = initialGuess(td, max, min);
    setFont(td, g);

    // 2) 보정 — 가급적 키우기(여유가 있으면 최대까지), 넘치면 줄이며 수렴
    if (fits(td)){
      // 위로 최대까지 탐색
      let lo = g, hi = max, best = g;
      while (hi - lo > EPS){
        const mid = (lo + hi) / 2;
        setFont(td, mid);
        if (fits(td)){ best = mid; lo = mid; } else { hi = mid; }
      }
      setFont(td, best);
      return;
    } else {
      // 아래로 줄이며 맞추기
      let lo = min, hi = g, best = min;
      while (hi - lo > EPS){
        const mid = (lo + hi) / 2;
        setFont(td, mid);
        if (fits(td)){ best = mid; lo = mid; } else { hi = mid; }
      }
      setFont(td, best);
      return;
    }
  }

  function fitAll(){ document.querySelectorAll('td').forEach(fitOne); }

  // 초기 실행: 글꼴/이미지 로드 뒤 실행
  (async function init(){
    try { if (document.fonts && document.fonts.ready) await document.fonts.ready; } catch(e){}
    if (document.readyState !== 'complete'){
      await new Promise(r => window.addEventListener('load', r, {once:true}));
    }
    fitAll();
    // 리사이즈/인쇄 전후 재적용
    let raf; window.addEventListener('resize', () => { cancelAnimationFrame(raf); raf = requestAnimationFrame(fitAll); });
    const mql = window.matchMedia && window.matchMedia('print');
    mql && (mql.addEventListener?.('change', e => { if (e.matches) fitAll(); }) || mql.addListener?.(e => { if (e.matches) fitAll(); }));
    window.addEventListener('beforeprint', fitAll);
    window.addEventListener('afterprint',  fitAll);
  })();
})();
</script>
</body>
</html>
