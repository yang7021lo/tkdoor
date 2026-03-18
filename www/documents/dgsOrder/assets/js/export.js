(function () {
  'use strict';

  // ====== 캡처 제외 CSS 주입 (.no-capture) ======
  (function ensureNoCaptureStyle() {
    if (!document.getElementById('noCaptureStyle')) {
      const s = document.createElement('style');
      s.id = 'noCaptureStyle';
      s.textContent = '.no-capture{visibility:hidden !important;}';
      document.head.appendChild(s);
    }
  })();

  // ====== 동적 스크립트 로더 & 라이브러리 보장 ======
  function loadScript(src) {
    return new Promise((resolve, reject) => {
      const s = document.createElement('script');
      s.src = src;
      s.async = true;
      s.onload = resolve;
      s.onerror = () => reject(new Error('Failed to load ' + src));
      document.head.appendChild(s);
    });
  }
  async function ensureHtml2Canvas() {
    if (!window.html2canvas) {
      await loadScript('https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js');
    }
  }
  async function ensureJsZip() {
    if (!window.JSZip) {
      await loadScript('https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js');
    }
  }
// ====== A4 페이지 선택 규칙 (ID만 집어서 캡처)
function getPages(id = 'export') {
  const el = document.getElementById(id);
  return el ? [el] : [document.body];
}


  // 캡처 시 UI(플로팅 버튼/모달 등) 숨기기
  function toggleUi(hide) {
    const targets = [
      document.querySelector('.print-fab'),
      document.querySelector('.modal.show'),
      document.querySelector('.modal-backdrop')
    ].filter(Boolean);
    targets.forEach(el => el.classList.toggle('no-capture', !!hide));
  }

  // 지정 엘리먼트를 캔버스로 렌더
  async function renderCanvas(el) {
    try { await document.fonts?.ready; } catch (e) {}
    await ensureHtml2Canvas();
    toggleUi(true);
    const canvas = await html2canvas(el, {
      useCORS: true,
      backgroundColor: '#ffffff',
      scale: Math.max(2, window.devicePixelRatio || 1),
      logging: false
    });
    toggleUi(false);
    return canvas;
  }

  // 파일명 타임스탬프
  function stamp(prefix) {
    const d = new Date();
    const p = n => String(n).padStart(2, '0');
    return `${prefix}_${d.getFullYear()}${p(d.getMonth()+1)}${p(d.getDate())}_${p(d.getHours())}${p(d.getMinutes())}`;
  }

  // dataURL → Blob (폴백용)
  function dataURLToBlob(dataUrl) {
    const [meta, b64] = dataUrl.split(',');
    const mime = (meta.match(/data:(.*?);/) || [,'image/png'])[1];
    const bin = atob(b64);
    const len = bin.length;
    const u8 = new Uint8Array(len);
    for (let i = 0; i < len; i++) u8[i] = bin.charCodeAt(i);
    return new Blob([u8], { type: mime });
  }

  // Canvas → Blob
  function canvasToBlob(canvas, type = 'image/png', quality) {
    return new Promise(resolve => {
      if (canvas.toBlob) {
        canvas.toBlob(b => resolve(b || dataURLToBlob(canvas.toDataURL(type, quality))), type, quality);
      } else {
        resolve(dataURLToBlob(canvas.toDataURL(type, quality)));
      }
    });
  }

  // ====== PNG를 "Ctrl+C처럼" 클립보드에 넣기 (이미지 형식만) ======
  async function copyPngToClipboard(blob) {
    if (navigator.clipboard && window.ClipboardItem) {
      try {
        await navigator.clipboard.write([ new ClipboardItem({ 'image/png': blob }) ]);
        return true;
      } catch (e) {}
    }
    return false;
  }

  // ====== 액션: 이미지 다운로드 (여러 페이지면 ZIP) ======
  async function handleDownloadImages() {
    const pages = getPages();
    if (pages.length === 1) {
      const c = await renderCanvas(pages[0]);
      const b = await canvasToBlob(c, 'image/png');
      const url = URL.createObjectURL(b);
      const a = document.createElement('a');
      a.href = url;
      a.download = stamp('견적서') + '.png';
      a.click();
      URL.revokeObjectURL(url);
    } else {
      await ensureJsZip();
      const zip = new JSZip();
      for (let i = 0; i < pages.length; i++) {
        const c = await renderCanvas(pages[i]);
        const b = await canvasToBlob(c, 'image/png');
        zip.file(`page-${String(i+1).padStart(2,'0')}.png`, b);
      }
      const blob = await zip.generateAsync({ type: 'blob' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = stamp('견적서_이미지') + '.zip';
      a.click();
      URL.revokeObjectURL(url);
    }
  }

  // ====== 액션: 이미지 복사 (선택한 페이지 1장) ======
  async function handleCopyImage() {
    const pages = getPages();
    const sel = document.getElementById('pagePicker');
    let idx = 0;
    if (sel && sel.value) idx = Math.max(0, Number(sel.value) - 1);

    const c = await renderCanvas(pages[idx]);
    const blob = await canvasToBlob(c, 'image/png');

    const ok = await copyPngToClipboard(blob);
    if (ok) {
      alert('이미지 복사 완료'); // Ctrl+V로 즉시 붙여넣기 가능
      return;
    }

    // 모든 경로 실패 시: 새 탭 열어 수동 저장/복사 지원
    const url = URL.createObjectURL(blob);
    window.open(url, '_blank');
    setTimeout(() => URL.revokeObjectURL(url), 30000);
  }

  // ====== 모달 열릴 때 페이지 선택 UI 동적 구성 ======
  const modal = document.getElementById('downloadModal');
  if (modal) {
    modal.addEventListener('shown.bs.modal', () => {
      const pages = getPages();
      const wrap = document.getElementById('pagePickerWrap');
      const select = document.getElementById('pagePicker');
      if (wrap && select) {
        if (pages.length > 1) {
          wrap.classList.remove('d-none');
          select.innerHTML = pages.map((_, i) => `<option value="${i+1}">${i+1} 페이지</option>`).join('');
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