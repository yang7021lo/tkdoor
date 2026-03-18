(async function () {
  try {
    // 1) 데이터 로드
    const [fRes, dRes] = await Promise.all([ fetch("/documents/outsideOrder/db/frames.json"), fetch("/documents/outsideOrder/db/doors.json") ]);
    const fJson = await fRes.json();
    const dJson = await dRes.json();
    const frames = (fJson.data?.frames ?? fJson.frames) || [];
    const doors  = (dJson.data?.doors  ?? dJson.doors)  || [];
    console.log("[detail] frames:", frames.length, "doors:", doors.length);

    // 2) 필수 요소 체크
    const mount = document.getElementById("detail-container");
    if (!mount) { console.error("[detail] #detail-container 없음"); return; }
    const tpl = document.getElementById("tpl-detail-section");
    if (!tpl) { console.error("[detail] #tpl-detail-section 없음"); return; }

    // 3) 헬퍼
    const getByPath = (obj, path) =>
      path.split('.').reduce((o, k) => (o && o[k] !== undefined ? o[k] : undefined), obj);

    const fmt = (val, fmtDecl) => {
      if (val == null || val === "") return "";
      if (!fmtDecl) return val;
      const [kind, arg] = fmtDecl.split(':');
      if (kind === 'number') {
        const n = Number(val);
        return isNaN(n) ? val : n.toLocaleString(arg || 'ko-KR');
      }
      if (kind === 'percent') {
        const n = Number(val);
        if (isNaN(n)) return val;
        if (arg === 'auto') return (n >= 0 && n <= 1) ? `${(n*100).toFixed(0)}` : `${n}`;
        return `${n}%`;
      }
      return val;
    };

    const bindNode = (root, data) => {
      root.querySelectorAll("[data-text]").forEach(el => {
        const val = getByPath(data, el.getAttribute("data-text"));
        el.textContent = fmt(val, el.getAttribute("data-format"));
      });
      root.querySelectorAll("[data-html]").forEach(el => {
        const val = getByPath(data, el.getAttribute("data-html"));
        el.innerHTML = val ?? "";
      });
      root.querySelectorAll("[data-svg]").forEach(svg => {
        const val = getByPath(data, svg.getAttribute("data-svg"));
        svg.innerHTML = val ?? "";
      });
      root.querySelectorAll("[data-attr-src], [data-attr-href], [data-attr-title]").forEach(el => {
        ["src","href","title"].forEach(attr => {
          const key = `data-attr-${attr}`;
          if (el.hasAttribute(key)) {
            const v = getByPath(data, el.getAttribute(key));
            if (v != null) el.setAttribute(attr, String(v));
          }
        });
      });
      root.querySelectorAll("[data-if]").forEach(el => {
        const v = getByPath(data, el.getAttribute("data-if"));
        if (!v) el.remove();
      });
    };

    // 4) seq 매칭
    const fMap = new Map(frames.map(x => [Number(x.seq), x]));
    const dMap = new Map(doors.map(x  => [Number(x.seq), x]));
    const allSeq = Array.from(new Set([...fMap.keys(), ...dMap.keys()])).sort((a,b)=>a-b);

    // 5) ===== 렌더링: 템플릿 복제 + 데이터 주입 =====
    const frag = document.createDocumentFragment();
    for (const seq of allSeq) {
      const f = fMap.get(seq) || {};
      const d = dMap.get(seq) || {};
      const clone = tpl.content.cloneNode(true);
      bindNode(clone, { seq, frames: f, doors: d });
      frag.appendChild(clone);
    }
    mount.replaceChildren(frag);
    console.log("[detail] 템플릿 클론 방식으로 #detail-container 렌더 완료");
  } catch (err) {
    console.error("[detail] 렌더 실패:", err);
  }
})();
