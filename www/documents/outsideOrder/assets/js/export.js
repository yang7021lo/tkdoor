(function () {
  'use strict';

  /* =========================================================
   *  A4 가로형 캡처 · 멀티페이지 PNG 다운로드 · 클립보드 복사
   *  - html2canvas 동적 로드
   *  - 행 기준 안전 컷라인(tr bottom)으로 슬라이스 (셀 절단 방지)
   *  - 버튼: #btnDownloadImages, #btnCopyImage
   *  - 선택: #pagePicker (모달 내), #downloadModal, #pagePickerWrap
   * ========================================================= */

  // ====== 제외 스타일 (캡처에서 숨길 UI에 .no-capture 클래스) ======
  (function ensureNoCaptureStyle() {
    if (!document.getElementById('noCaptureStyle')) {
      const s = document.createElement('style');
      s.id = 'noCaptureStyle';
      s.textContent = '.no-capture{visibility:hidden !important;}';
      document.head.appendChild(s);
    }
  })();

  // ====== 동적 로더 ======
  function loadScript(src){
    return new Promise((res,rej)=>{
      const s=document.createElement('script');
      s.src=src; s.async=true;
      s.onload=res;
      s.onerror=()=>rej(new Error('Failed '+src));
      document.head.appendChild(s);
    });
  }
  async function ensureHtml2Canvas(){
    if(!window.html2canvas){
      await loadScript('https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js');
    }
  }

  // ====== A4 가로형 강제 (화면/인쇄 공통) ======
  (function ensureA4LandscapeCSS(){
    if(!document.getElementById('a4LandscapeCSS')){
      const s=document.createElement('style');
      s.id='a4LandscapeCSS';
      s.textContent = `
        /* 인쇄 시 여백: 필요에 따라 0~10mm 조정 */
        @page { size: A4 landscape; margin: 8mm; }

        /* 화면 레이아웃 기준 (html2canvas 캡처 대상) */
        .print-sheet {
          width: 297mm;          /* A4 가로 */
          min-height: 210mm;     /* A4 세로 */
          background:#fff;
          margin:0 auto;
        }

        /* 인쇄 시 행/셀 절단 방지(참고) */
        @media print {
          table, thead, tbody, tfoot, tr, td, th {
            page-break-inside: avoid;
            break-inside: avoid;
          }
        }
      `;
      document.head.appendChild(s);
    }
  })();

  // ====== 대상 페이지 수집 ======
  function getPages(){
    let pages = Array.from(document.querySelectorAll('.print-sheet'));
    if(!pages.length) pages = [document.body]; // 폴백
    return pages;
  }

  // ====== UI 숨김 토글 (캡처 방해 요소 가림) ======
  function toggleUi(hide){
    const candidates = [
      document.querySelector('.print-fab'),
      document.querySelector('.modal.show'),
      document.querySelector('.modal-backdrop')
    ].filter(Boolean);
    candidates.forEach(el=>el.classList.toggle('no-capture', !!hide));
  }

  // ====== 렌더: html2canvas로 단일 큰 캔버스 생성 (A4 가로 기준 클론 보정) ======
  async function renderCanvas(el){
    try{await document.fonts?.ready;}catch(e){}
    await ensureHtml2Canvas();
    toggleUi(true);

    const dpr = Math.max(2, window.devicePixelRatio || 1);
    const canvas = await html2canvas(el, {
      useCORS: true,
      backgroundColor: '#ffffff',
      scale: dpr,
      logging: false,
      onclone: (doc)=>{
        const cloneEl = doc.body.querySelector('.print-sheet') || doc.body;
        cloneEl.style.width = '297mm';
        cloneEl.style.minHeight = '210mm';
        cloneEl.style.height = 'auto';     // 내용에 따라 확장
        cloneEl.style.overflow = 'visible';
      }
    });

    toggleUi(false);
    return canvas;
  }

  // ====== (A) 원본 DOM 기준 “안전 컷라인(tr 하단)” 수집 ======
  // el: 캡처한 .print-sheet DOM
  // canvas: html2canvas 결과 (DOM px → 캔버스 px 매핑 필요)
  function collectSafeCutlines(el, canvas){
    const domRect = el.getBoundingClientRect();
    const scale   = canvas.width / domRect.width;  // DOM px → 캔버스 px 스케일
    const rootTop = domRect.top;

    // 행 외에도 쪼개지면 안 되는 블록이 있다면 선택자 확장 가능:
    // const rowSelector = 'tr, .no-split, [data-keep-together]';
    const rowSelector = 'tr';
    const rows = Array.from(el.querySelectorAll(rowSelector));

    const cuts = [];
    for (const tr of rows) {
      const r = tr.getBoundingClientRect();
      const bottomOnCanvas = Math.round((r.bottom - rootTop) * scale);
      if (!cuts.length || cuts[cuts.length - 1] !== bottomOnCanvas) {
        cuts.push(bottomOnCanvas);
      }
    }
    if (cuts.length === 0 || cuts[cuts.length - 1] !== canvas.height) {
      cuts.push(canvas.height); // 최종 하단 안전망
    }
    return cuts;
  }

  // ====== (B) A4 가로 기준 안전 컷라인을 이용한 슬라이스 ======
  function sliceCanvasIntoPages_A4Safe(el, bigCanvas){
    // A4 landscape 비율(세로/가로 = 210 / 297)
    const pageRatio   = 210 / 297;
    const nominalH    = Math.round(bigCanvas.width * pageRatio);
    const cutlines    = collectSafeCutlines(el, bigCanvas); // px(캔버스)

    const parts = [];
    let y = 0;
    const bleed = 2; // 경계 이음새 방지용 1~3px 겹치기

    while (y < bigCanvas.height) {
      const target = y + nominalH;

      // target을 넘지 않는 가장 가까운 cutline 선택
      let cut = null;
      for (let i = 0; i < cutlines.length; i++) {
        const c = cutlines[i];
        if (c <= target) cut = c;
        else break;
      }
      if (cut === null) cut = cutlines[0];
      if (cut <= y) cut = Math.min(y + nominalH, bigCanvas.height); // 안전장치

      const sliceH = Math.min(cut - y, bigCanvas.height - y);
      const c = document.createElement('canvas');
      c.width  = bigCanvas.width;
      c.height = sliceH + (y > 0 ? bleed : 0);

      const ctx = c.getContext('2d');
      ctx.drawImage(
        bigCanvas,
        0, Math.max(0, y - (y > 0 ? bleed : 0)), bigCanvas.width, c.height,
        0, 0, bigCanvas.width, c.height
      );
      parts.push(c);

      y = cut;
    }
    return parts;
  }

  // ====== 유틸 ======
  function stamp(prefix){
    const d=new Date(),p=n=>String(n).padStart(2,'0');
    return `${prefix}_${d.getFullYear()}${p(d.getMonth()+1)}${p(d.getDate())}_${p(d.getHours())}${p(d.getMinutes())}`;
  }
  function dataURLToBlob(dataUrl){
    const [meta,b64]=dataUrl.split(',');
    const mime=(meta.match(/data:(.*?);/)||[, 'image/png'])[1];
    const bin=atob(b64),len=bin.length,u8=new Uint8Array(len);
    for(let i=0;i<len;i++) u8[i]=bin.charCodeAt(i);
    return new Blob([u8],{type:mime});
  }
  function canvasToBlob(canvas,type='image/png',quality){
    return new Promise(resolve=>{
      if(canvas.toBlob){
        canvas.toBlob(b=>resolve(b||dataURLToBlob(canvas.toDataURL(type,quality))),type,quality);
      }else{
        resolve(dataURLToBlob(canvas.toDataURL(type,quality)));
      }
    });
  }

// 금지문자/확장자/공백 정리
function sanitizeFilename(s){
  return String(s)
    .replace(/[\/\\?%*:|"<>]/g, ' ')   // 금지문자 제거
    .replace(/\s+/g, ' ')              // 다중 공백 정리
    .trim()
    .replace(/\.(png|jpg|jpeg|webp)$/i, '') // 확장자 표기 제거
    .replace(/\s/g, '_')               // 공백 → _
    .replace(/_{2,}/g, '_')            // 중복 _ 축소
    .replace(/^_+|_+$/g, '')           // 앞뒤 _ 제거
    .substring(0, 180);                // 너무 길면 컷
}

function pickBaseName(){
  const el = document.getElementById('downloadFileName');
  const v  = el && typeof el.value === 'string' ? el.value.trim() : '';
  return sanitizeFilename(v || stamp('견적서'));
}

// ====== 다운로드 (여러 장 대응: 요소 여러 개 + 요소 하나라도 슬라이스) ======
async function handleDownloadImages(){
  const pages = getPages();
  if (!pages || !pages.length) return;

  const base = pickBaseName(); // ← 히든값 우선, 없으면 '견적서' 타임스탬프

  let fileIndex = 1;
  for (let pi = 0; pi < pages.length; pi++){
    const big = await renderCanvas(pages[pi]);
    const canvases = sliceCanvasIntoPages_A4Safe(pages[pi], big);

    for (let ci = 0; ci < canvases.length; ci++){
      const b = await canvasToBlob(canvases[ci], 'image/png');
      const url = URL.createObjectURL(b);
      const a = document.createElement('a');
      a.href = url;

      a.download = (pages.length === 1 && canvases.length === 1)
        ? `${base}.png`
        : `${base}_p${String(fileIndex++).padStart(2,'0')}.png`;

      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
      await new Promise(r => setTimeout(r, 80));
    }
  }
}


  // ====== 선택 페이지 복사 (슬라이스 중 첫 페이지만) ======
  async function handleCopyImage(){
    const pages = getPages();
    const sel = document.getElementById('pagePicker');
    let idx = 0; if (sel && sel.value) idx = Math.max(0, Number(sel.value)-1);

    const big = await renderCanvas(pages[idx]);
    const parts = sliceCanvasIntoPages_A4Safe(pages[idx], big);
    const first = parts[0] || big;

    const blob = await canvasToBlob(first, 'image/png');
    if (navigator.clipboard && window.ClipboardItem){
      try{
        await navigator.clipboard.write([ new ClipboardItem({ 'image/png': blob }) ]);
        alert('이미지 복사 완료');
        return;
      }catch(e){}
    }
    const url = URL.createObjectURL(blob);
    window.open(url,'_blank');
    setTimeout(()=>URL.revokeObjectURL(url),30000);
  }

  // ====== 모달 진입 시 페이지 선택 옵션 구성 ======
  const modal = document.getElementById('downloadModal');
  if(modal){
    modal.addEventListener('shown.bs.modal', ()=>{
      const pages = getPages();
      const wrap = document.getElementById('pagePickerWrap');
      const select = document.getElementById('pagePicker');
      if (wrap && select){
        if (pages.length > 1){
          wrap.classList.remove('d-none');
          select.innerHTML = pages.map((_,i)=>`<option value="${i+1}">${i+1} 페이지</option>`).join('');
        } else {
          wrap.classList.add('d-none');
        }
      }
    });
  }

  // ====== 버튼 바인딩 ======
  const btnImages = document.getElementById('btnDownloadImages');
  if (btnImages) btnImages.addEventListener('click', handleDownloadImages);
  const btnCopy = document.getElementById('btnCopyImage');
  if (btnCopy) btnCopy.addEventListener('click', handleCopyImage);
})();