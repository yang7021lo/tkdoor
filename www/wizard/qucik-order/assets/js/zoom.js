        (function(){
          const svg = document.getElementById('canvas');
          const vp  = document.getElementById('vp');
          const pzReadout = document.getElementById('pzReadout');

          let k = 1, tx = 0, ty = 0;                 // scale, translate (SVG user unit)
          const kMin = 0.2, kMax = 10;
          const WHEEL_STEP = 1.1;

          function applyTransform() {
            vp.setAttribute('transform', `matrix(${k} 0 0 ${k} ${tx} ${ty})`);
            if (pzReadout) pzReadout.textContent = `scale=${k.toFixed(2)} tx=${tx.toFixed(1)} ty=${ty.toFixed(1)}`;
          }

          function clientToLocal(e, target = vp) {
            const pt = svg.createSVGPoint();
            pt.x = (e.clientX !== undefined) ? e.clientX : e.touches[0].clientX;
            pt.y = (e.clientY !== undefined) ? e.clientY : e.touches[0].clientY;
            const m = target.getScreenCTM().inverse();
            return pt.matrixTransform(m);
          }

          function zoomAt(cx, cy, factor) {
            const newK = Math.max(kMin, Math.min(kMax, k * factor));
            if (newK === k) return;
            tx = tx + (k - newK) * cx;
            ty = ty + (k - newK) * cy;
            k = newK;
            applyTransform();
          }

          // 마우스 휠 줌
          svg.addEventListener('wheel', (e) => {
            e.preventDefault();
            const p = clientToLocal(e, vp);
            const f = (e.deltaY < 0) ? WHEEL_STEP : (1 / WHEEL_STEP);
            zoomAt(p.x, p.y, f);
          }, { passive:false });

          // 드래그 팬
          let isPanning = false;
          let last = null;

          svg.addEventListener('pointerdown', (e) => {
            e.preventDefault();
            isPanning = true;
            last = { x: e.clientX, y: e.clientY };
            svg.setPointerCapture(e.pointerId);
          });
          svg.addEventListener('pointermove', (e) => {
            if (!isPanning) return;
            const dxPx = e.clientX - last.x;
            const dyPx = e.clientY - last.y;
            last = { x: e.clientX, y: e.clientY };
            const ctm = svg.getScreenCTM();
            tx += dxPx / ctm.a;
            ty += dyPx / ctm.d;
            applyTransform();
          });
          const endPan = (e)=>{ if(isPanning){ isPanning=false; try{svg.releasePointerCapture(e.pointerId);}catch(_){} } };
          svg.addEventListener('pointerup', endPan);
          svg.addEventListener('pointercancel', endPan);
          svg.addEventListener('pointerleave', endPan);

          // 터치 핀치 줌 + 팬
          let touches = new Map(); // id -> {clientX,clientY}
          let pinch = null;        // {k0, tx0, ty0, p:{x,y}, d0}

          svg.addEventListener('touchstart', (e) => {
            for (const t of e.changedTouches) touches.set(t.identifier, {x:t.clientX, y:t.clientY});
            if (touches.size === 2) {
              const [a,b] = [...touches.values()];
              const d0 = Math.hypot(b.x - a.x, b.y - a.y);
              const midClient = { x:(a.x+b.x)/2, y:(a.y+b.y)/2 };
              const pt = svg.createSVGPoint(); pt.x = midClient.x; pt.y = midClient.y;
              const p = pt.matrixTransform(vp.getScreenCTM().inverse());
              pinch = { k0:k, tx0:tx, ty0:ty, p, d0 };
            }
          }, {passive:true});

          svg.addEventListener('touchmove', (e) => {
            if (touches.size === 2 && pinch) {
              e.preventDefault();
              for (const t of e.changedTouches) touches.set(t.identifier, {x:t.clientX, y:t.clientY});
              const [a,b] = [...touches.values()];
              const d = Math.hypot(b.x - a.x, b.y - a.y);
              const f = (d / pinch.d0) || 1;
              let newK = Math.max(kMin, Math.min(kMax, pinch.k0 * f));
              tx = pinch.tx0 + (pinch.k0 - newK) * pinch.p.x;
              ty = pinch.ty0 + (pinch.k0 - newK) * pinch.p.y;
              k = newK;
              applyTransform();
            } else if (touches.size === 1 && !pinch) {
              e.preventDefault();
              const t = e.changedTouches[0];
              if (!last) last = {x:t.clientX, y:t.clientY};
              const dxPx = t.clientX - last.x;
              const dyPx = t.clientY - last.y;
              last = {x:t.clientX, y:t.clientY};
              const ctm = svg.getScreenCTM();
              tx += dxPx / ctm.a;
              ty += dyPx / ctm.d;
              applyTransform();
            }
          }, {passive:false});

          svg.addEventListener('touchend', (e) => {
            for (const t of e.changedTouches) touches.delete(t.identifier);
            if (touches.size < 2) pinch = null;
            if (touches.size === 0) last = null;
          });
          svg.addEventListener('touchcancel', (e) => {
            touches.clear(); pinch = null; last = null;
          });

          applyTransform();
        })();