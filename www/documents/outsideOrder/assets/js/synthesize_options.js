
(async function () {
  try {
    console.log("[load] synthesize.json 로드 시작");
    const res = await fetch("/documents/outsideOrder/db/synthesize.json");
    const json = await res.json();
    console.log("[load] 로드 성공:", json);

    // =========================================================
    // 0) 유틸/포맷터
    // =========================================================
    const fmtNumber = v =>
      (v === null || v === undefined || v === "" || isNaN(Number(v)))
        ? "" : Number(v).toLocaleString("ko-KR");

    const fmtDateYMD = v => {
      if (!v) return "";
      const d = new Date(v);
      if (isNaN(d)) return String(v);
      const y = d.getFullYear();
      const m = String(d.getMonth() + 1).padStart(2, "0");
      const day = String(d.getDate()).padStart(2, "0");
      return `${y}. ${m}. ${day}`;
    };

    const fmtSize = (w, h) =>
      [w, h].every(v => v != null && v !== "" && !isNaN(Number(v)))
        ? `${fmtNumber(w)} × ${fmtNumber(h)}`
        : "";

    const NUMBER_FIELDS =
      /(subtotal|vat|total|unitPrice|lineAmount|grossAmount|finalAmount|extraAmount|quantity|measuredSizeW|measuredSizeH)$/i;
    const DATE_FIELDS = /(quoteDate|dueDate|generatedAt|date|createdAt|updatedAt)$/i;

    const getByPath = (obj, path) =>
      path.split(".").reduce((o, k) => (o && k in o ? o[k] : undefined), obj);

    const formatByPath = (path, val) => {
      if (val === null || val === undefined) return "";
      if (DATE_FIELDS.test(path)) return fmtDateYMD(val);
      if (NUMBER_FIELDS.test(path) && !isNaN(Number(val))) return fmtNumber(val);
      return String(val);
    };

    // =========================================================
    // 1) 데이터 준비 + 합계 계산
    // =========================================================
    const data = json.data ?? json;
    const items = Array.isArray(data.items) ? data.items : [];

    const itemSum = items.reduce((s, it) => {
      const line = Number(
        it.lineAmount ?? (Number(it.unitPrice || 0) * Number(it.quantity || 0))
      );
      return s + (isFinite(line) ? line : 0);
    }, 0);

    const expectedSubtotal = itemSum;
    const expectedVat = Math.round(expectedSubtotal * 0.1);
    const expectedTotal = expectedSubtotal + expectedVat;

    const givenSubtotal = Number(data.subtotal || 0);
    const givenVat = Number(data.vat || 0);
    const givenTotal = Number(data.total || 0);

    if (givenSubtotal !== expectedSubtotal ||
        givenVat !== expectedVat ||
        givenTotal !== expectedTotal) {
      console.warn("[check] 합계 불일치 감지", {
        givenSubtotal, expectedSubtotal, givenVat, expectedVat, givenTotal, expectedTotal
      });
    } else {
      console.log("[check] 합계 일치 OK");
    }

    const view = structuredClone(data);
    view.items = items;
    view.subtotal = expectedSubtotal;
    view.vat = expectedVat;
    view.total = expectedTotal;

    const statusMap = { PAID: "입금완료", UNPAID: "미입금", PARTIAL: "부분입금" };
    view.paymentStatusText = statusMap[view.paymentStatus] ?? String(view.paymentStatus ?? "");

    // =========================================================
    // 2) 템플릿 확보
    // =========================================================
    let tplEl = document.querySelector("table.my-2 tbody tr.table-body");
    if (!tplEl) {
      console.error("[tpl] tbody 안에 .table-body 템플릿 행이 필요합니다.");
      return;
    }
    tplEl.dataset.template = "item";
    tplEl.style.display = "none";

    const mount = tplEl.parentElement;

    // =========================================================
    // 3) 치환 유틸
    // =========================================================
    const replaceTextTokens = (text, contextItem, seq) => {
      if (!text || !/\{[^}]+\}/.test(text)) return text;

      let t = text;
      t = t.replace(/\{seq\}/g, String(seq));

      t = t.replace(/\{items\[([^\]]+)\]\}/g, (_m, keyRaw) => {
        const key = String(keyRaw).trim();
        let val = contextItem?.[key];

        if (key === "measuredSize") {
          return fmtSize(contextItem?.measuredSizeW, contextItem?.measuredSizeH);
        }
        if ((key === "lineAmount" || key === "amount") &&
            (val === undefined || val === null || val === "")) {
          val = Number(contextItem?.unitPrice || 0) * Number(contextItem?.quantity || 0);
        }
        const path = `items.${key}`;
        return formatByPath(path, val);
      });

      t = t.replace(/\{paymentStatus\([^)]+\)\}/g, view.paymentStatusText);

      t = t.replace(/\{([a-zA-Z0-9_.]+)\}/g, (_m, path) => {
        if (path.startsWith("items")) return _m;
        const val = getByPath(view, path);
        return formatByPath(path, val);
      });

      return t;
    };

    // 속성 값 치환
    const replaceAttrTokens = (scope, contextItem, seq) => {
      const els = (scope.querySelectorAll ? scope.querySelectorAll("*") : []);
      els.forEach(el => {
        Array.from(el.attributes || []).forEach(attr => {
          const v = attr.value;
          if (v && /\{[^}]+\}/.test(v)) {
            const next = replaceTextTokens(v, contextItem, seq);
            if (next !== v) el.setAttribute(attr.name, next);
          }
        });
      });
    };

    const fillNode = (node, item, seq) => {
      // 텍스트 치환
      const walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT, null);
      const toEdit = [];
      while (walker.nextNode()) toEdit.push(walker.currentNode);
      toEdit.forEach(textNode => {
        textNode.nodeValue = replaceTextTokens(textNode.nodeValue, item, seq);
      });

      // 속성 치환
      replaceAttrTokens(node, item, seq);

      // rowspan seq
      const firstRowspan = node.querySelector("td[rowspan], th[rowspan]");
      if (firstRowspan && !/\{seq\}/.test(firstRowspan.textContent)) {
        firstRowspan.textContent = String(seq);
      }

      // data-date-path
      node.querySelectorAll("[data-date-path]").forEach(el => {
        const p = el.dataset.datePath;
        const v = (p in view) ? view[p] : item?.[p];
        el.textContent = fmtDateYMD(v);
      });

      
    };

    const applyGlobalBindings = () => {
      const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT, {
        acceptNode(node) {
          return (!node.nodeValue || !/\{[^}]+\}/.test(node.nodeValue))
            ? NodeFilter.FILTER_REJECT
            : NodeFilter.FILTER_ACCEPT;
        }
      });
      const nodes = [];
      while (walker.nextNode()) nodes.push(walker.currentNode);
      nodes.forEach(n => {
        n.nodeValue = replaceTextTokens(n.nodeValue, null, "");
      });

      // 속성도 전역 치환
      replaceAttrTokens(document, null, "");

      document.querySelectorAll("[data-bind-total]").forEach(el => {
        const key = el.dataset.bindTotal;
        if (key && key in view) el.textContent = formatByPath(key, view[key]);
      });
    };

    // =========================================================
    // 4) 렌더
    // =========================================================
    const render = () => {
      Array.from(mount.querySelectorAll("tr"))
        .filter(tr => tr !== tplEl && !tr.matches(".table-head"))
        .forEach(tr => tr.remove());

      console.log(`[items] 제품 ${view.items.length}개 렌더`);

      view.items.forEach((it, i) => {
        const clone = tplEl.cloneNode(true);
        clone.style.display = "";
        clone.removeAttribute("data-template");
        fillNode(clone, it, i + 1);
        mount.appendChild(clone);
      });

      applyGlobalBindings();
    };

    render();

    // =========================================================
    // 5) 템플릿 변경 감지
    // =========================================================
    const mo = new MutationObserver(() => {
      console.log("[tpl] 템플릿 변경 감지 → 재렌더");
      render();
    });
    mo.observe(tplEl, { attributes: true, childList: true, subtree: true, characterData: true });

    // =========================================================
    // 6) 외부 데이터 갱신 API
    // =========================================================
    window.setFrontData = (next) => {
      const nextData = next.data ?? next;
      const nextItems = Array.isArray(nextData.items) ? nextData.items : [];

      const nItemSum = nextItems.reduce((s, it) => {
        const line = Number(
          it.lineAmount ?? (Number(it.unitPrice || 0) * Number(it.quantity || 0))
        );
        return s + (isFinite(line) ? line : 0);
      }, 0);

      view.items = nextItems;
      view.subtotal = nItemSum;
      view.vat = Math.round(nItemSum * 0.1);
      view.total = view.subtotal + view.vat;

      view.paymentStatus = nextData.paymentStatus;
      view.paymentStatusText = statusMap[view.paymentStatus] ?? String(view.paymentStatus ?? "");

      for (const k of Object.keys(nextData)) {
        if (k === "items") continue;
        view[k] = nextData[k];
      }

      if (next.meta) view.meta = next.meta;

      console.log("[data] setFrontData 적용", view);
      render();
    };

    window._frontView = view;

  } catch (e) {
    console.error("[error] front.json 로딩/렌더 실패:", e);
  }
})();
