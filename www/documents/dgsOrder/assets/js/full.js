function openPreviewFullscreen(rsjidx, rsjsidx) {
  const url = `/documents/dgsOrder/preview?sjidx=${encodeURIComponent(rsjidx)}&sjsidx=${encodeURIComponent(rsjsidx)}`;

  // 1) Fullscreen overlay + iframe (권장)
  if (document.fullscreenEnabled && Element.prototype.requestFullscreen) {
    const wrap = document.createElement('div');
    wrap.id = 'fsWrap';
    Object.assign(wrap.style, {
      position: 'fixed', inset: '0', background: '#000',
      display: 'flex', alignItems: 'stretch', justifyContent: 'center',
      zIndex: 2147483647
    });

    const iframe = document.createElement('iframe');
    iframe.src = url;
    iframe.allow = 'fullscreen';
    Object.assign(iframe.style, {
      border: '0', width: '100%', height: '100%', flex: '1 1 auto'
    });

    const closeBtn = document.createElement('button');
    closeBtn.type = 'button';
    closeBtn.textContent = '×';
    closeBtn.title = '닫기(Esc)';
    Object.assign(closeBtn.style, {
      position: 'absolute', top: '12px', right: '12px',
      padding: '8px 12px', fontSize: '20px',
      border: '0', borderRadius: '8px',
      background: 'rgba(0,0,0,.5)', color: '#fff', cursor: 'pointer'
    });

    function exitFS() {
      try { if (document.fullscreenElement) document.exitFullscreen(); } catch (e) {}
      cleanup();
    }
    function onKey(e){ if (e.key === 'Escape') exitFS(); }
    function cleanup(){
      document.removeEventListener('keydown', onKey);
      if (wrap && wrap.parentNode) wrap.parentNode.removeChild(wrap);
    }

    closeBtn.onclick = exitFS;
    document.addEventListener('keydown', onKey);

    wrap.appendChild(iframe);
    wrap.appendChild(closeBtn);
    document.body.appendChild(wrap);

    // 사용자 제스처 컨텍스트 내에서 즉시 요청
    try {
      wrap.requestFullscreen({ navigationUI: 'hide' }).catch(() => {});
    } catch (e) {}

    return;
  }

  // 2) 폴백: 최대화 팝업
  const feat = [
    'noopener','noreferrer',
    'menubar=0','toolbar=0','location=0','status=0',
    'resizable=1','scrollbars=1',
    `width=${screen.availWidth}`, `height=${screen.availHeight}`,
    'left=0','top=0'
  ].join(',');
  const w = window.open(url, '_blank', feat);
  try { w && w.focus(); } catch (e) {}
}
