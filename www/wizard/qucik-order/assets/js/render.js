(function () {
      // ---------- 유틸 ----------
      const $ = s => document.querySelector(s);
      const $$ = s => Array.from(document.querySelectorAll(s));
      const clamp = (v, a, b) => Math.max(a, Math.min(b, v));

      // ---------- 마법사(단계) ----------
      const steps = $$('.step');
      const status = $('#status');
      const prog = $('#prog');
      let si = 0;

      function renderStep() {
        steps.forEach((el, idx) => el.classList.toggle('active', idx === si));
        status.textContent = `${si + 1} / ${steps.length}`;
        const pct = steps.length > 1 ? (si / (steps.length - 1)) * 100 : 100;
        prog.style.width = pct + '%';
        // 상단 점 버튼 상태
        $$('#wizardPane .dots .btn').forEach((b, idx) => {
          b.classList.toggle('btn-light', idx === si);
          b.classList.toggle('btn-outline-light', idx !== si);
        });
      }
      $('#prevBtn').addEventListener('click', () => { si = clamp(si - 1, 0, steps.length - 1); renderStep(); });
      $('#nextBtn').addEventListener('click', () => { si = clamp(si + 1, 0, steps.length - 1); renderStep(); });
      $$('#wizardPane [data-goto]').forEach(b => {
        b.addEventListener('click', () => { si = +b.dataset.goto | 0; renderStep(); });
      });

      // ---------- 요소 참조 ----------
      const doorW = $('#doorW'), doorH = $('#doorH'), cornerR = $('#cornerR'), rot = $('#rot');
      const frameT = $('#frameT'), glassMX = $('#glassMX'), glassMY = $('#glassMY'), strokeW = $('#strokeW');
      const frameC = $('#frameC'), glassC = $('#glassC'), gridOn = $('#gridOn'), shadowOn = $('#shadowOn');

      const svg = $('svg');                 // 우측 SVG
      const doorGroup = $('#doorGroup');
      const frameRing = $('#frameRing');
      const glassRect = $('#glassRect');
      const pivot = $('#pivot');
      const gridRect = $('#gridRect');
      const readout = $('#readout');        // 좌측 데이터 리드아웃(우측 헤더에 표시)

      // ---------- 렌더링 ----------
      function update() {
        // 입력값(mm)
        const DW = +doorW.value || 900;
        const DH = +doorH.value || 2100;
        const FT = +frameT.value || 50;
        const GMX = +glassMX.value || 150;
        const GMY = +glassMY.value || 150;
        const R   = +cornerR.value || 8;
        const DEG = +rot.value || 0;

        // 캔버스(viewBox)
        const VBW = 400, VBH = 600, M = 20; // margin
        const scale = Math.min((VBW - M * 2) / DW, (VBH - M * 2) / DH); // mm -> viewBox
        const w = DW * scale, h = DH * scale;

        // 그룹 위치/회전(중심 기준)
        const cx = M + w / 2, cy = M + h / 2;
        doorGroup.setAttribute('transform', `translate(0,0) rotate(${DEG} ${cx} ${cy})`);

        // 프레임(링) 그리기: 외곽/내곽 두 사각형으로 링 구현
        const rx = R * scale, ry = rx;
        const outer = { x: M, y: M, w, h, r: rx };
        const inner = { x: M + FT * scale, y: M + FT * scale, w: w - 2 * FT * scale, h: h - 2 * FT * scale, r: Math.max(0, rx - FT * scale) };

        frameRing.innerHTML = `
          <path d="
            M ${outer.x} ${outer.y}
            h ${outer.w} v ${outer.h} h ${-outer.w} Z
            M ${inner.x} ${inner.y}
            h ${inner.w} v ${inner.h} h ${-inner.w} Z
          " fill="${frameC.value}" fill-rule="evenodd"
            ${shadowOn.checked ? 'filter="url(#shadow)"' : ''} />
          <rect x="${outer.x}" y="${outer.y}" width="${outer.w}" height="${outer.h}"
                rx="${rx}" ry="${ry}" fill="none"
                stroke="${frameC.value}" stroke-width="${+strokeW.value}" />
        `;

        // 유리(프레임 안쪽 여백 적용)
        const gx = inner.x + GMX * scale;
        const gy = inner.y + GMY * scale;
        const gw = Math.max(0, inner.w - 2 * GMX * scale);
        const gh = Math.max(0, inner.h - 2 * GMY * scale);
        const gr = Math.max(0, Math.min(rx, R * scale - FT * scale - Math.max(GMX, GMY) * scale));

        glassRect.setAttribute('x', gx);
        glassRect.setAttribute('y', gy);
        glassRect.setAttribute('width', gw);
        glassRect.setAttribute('height', gh);
        glassRect.setAttribute('rx', gr);
        glassRect.setAttribute('ry', gr);
        glassRect.setAttribute('fill', glassC.value);
        glassRect.setAttribute('stroke-width', +strokeW.value);
        glassRect.setAttribute('filter', shadowOn.checked ? 'url(#shadow)' : '');

        // 피벗(캔버스 좌표)
        pivot.setAttribute('cx', cx);
        pivot.setAttribute('cy', cy);

        // 옵션
        gridRect.setAttribute('opacity', gridOn.checked ? '1' : '0');

        // 리드아웃(좌측 데이터 상태)
        readout.textContent = `door=${DW}×${DH}mm, frame=${FT}mm, glassMargin=${GMX}/${GMY}mm, r=${R}, rot=${DEG}°, scale=${scale.toFixed(3)}`;
      }

      // 이벤트 바인딩
      const inputs = [doorW, doorH, cornerR, rot, frameT, glassMX, glassMY, strokeW, frameC, glassC, gridOn, shadowOn];
      inputs.forEach(el => {
        ['input', 'change'].forEach(ev => el.addEventListener(ev, update, { passive: true }));
      });

      // 초기 렌더
      renderStep();
      update();
    })();