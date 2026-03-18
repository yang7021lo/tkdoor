
/*─────────────────────────────────────────────────────────────────────────────
[무엇을 하는 코드인가? 한 줄 요약]
- 서버에서 "아이템 목록 JSON" 과 "옵션 목록 JSON" 을 동시에 가져와서
  화면의 표(테이블) 템플릿에 숫자/날짜/문구를 예쁘게 채워 넣어 보여준다.

[이 코드가 기대하는 HTML(핵심만)]
1) 숨겨진 입력: <input type="hidden" id="sjidx" value="...">
   - 서버에서 어떤 견적(sjidx)을 불러올지 알려주는 키

2) 아이템용 테이블 템플릿(필수)
   <table class="my-2">
     <tbody>
       <tr class="table-head"> ... (헤더행이면 그대로 두세요) ... </tr>
       <tr class="table-body" style="display:none">
         <!-- 여기에 {items[name]} 같은 토큰을 마음껏 배치 -->
         <!-- 예: <td>{seq}</td> <td>{items[name]}</td> <td>{items[quantity]}</td> ... -->
       </tr>
     </tbody>
   </table>

3) 옵션 집계용 테이블 템플릿(선택)
   <table class="my-2">
     <tbody>
       <tr class="table-head"> ... </tr>
       <tr class="table-body-option" style="display:none">
         <!-- 예: <td>{seq}</td> <td>{option.label}</td> <td>{option.quantity}</td> <td>{option.total}</td> -->
       </tr>
     </tbody>
   </table>

4) 합계 바인딩(필수 키만 쓰세요)
   - <span data-bind-total="subtotal"></span>
   - <span data-bind-total="vat"></span>
   - <span data-bind-total="total"></span>
   (선택) 세부 합계:
   - <span data-bind-total-items></span>
   - <span data-bind-total-options></span>

[템플릿에 쓸 수 있는 토큰들 예시]
- {seq}             : 1,2,3... 각 행 번호
- {items[name]}     : 아이템의 name 값
- {items[quantity]} : 아이템 수량 (숫자는 자동 천단위 포맷)
- {items[unitPrice]}: 아이템 단가
- {items[lineAmount]}: 라인 금액(없으면 unitPrice*quantity로 계산)
- {items[measuredSize]}: measuredSizeW × measuredSizeH 모양으로 표시
- {paymentStatus(...)} : 결제 상태 한글 변환(입금완료/미입금/부분입금)
- 전역 토큰 {subtotal}, {vat}, {total}, {quoteDate} 등도 가능

[옵션 집계 템플릿에서 쓸 수 있는 토큰]
- {option.label}        : “재분할/로비폰/보양재/하부레일”
- {option.quantity}     : 총 개수 합
- {option.total}        : 총 금액 합
- {option.count}        : 이 옵션이 등장한 아이템 수
- {option.unitPrice} : 단가

[데이터는 어디서 오나?]
- items JSON:   /documents/outsideOrder/db/synthesize.asp?sjidx=...
  - 일반적으로 { data: { items:[...], subtotal, vat, total, ... } } 형태
- options JSON: /documents/outsideOrder/db/options.asp?sjidx=...
  - 일반적으로 { data: { options:[...] } } 형태(옵션만)

[합계 로직]
- 아이템 합 + 옵션 합 → 계산한 subtotal
- vat = subtotal * 10% (반올림)
- total = subtotal + vat
- 서버가 내려준 합계와 다르면 콘솔 경고로 알려줌(그냥 알려만 줌)

[외부에서 데이터 갱신하고 싶을 때]
- window.setFrontData({ items:[...], options:[...], paymentStatus:"PAID" })
  라고 호출하면 재계산+재렌더 자동

─────────────────────────────────────────────────────────────────────────────*/

(async function () {
  try {
    /*───────────────────────────────────────────────────────────────
    [1] 준비: sjidx(견적 키) 읽기 + 설정값 만들기
    - sjidx는 서버 API에서 어떤 데이터를 달라고 할지 알려주는 열쇠
    ───────────────────────────────────────────────────────────────*/
    var el = document.getElementById('sjidx');  // 숨겨진 input을 가져온다
    var key = el ? el.value : '';                // 값이 있으면 그걸 쓰고, 없으면 빈문자
    console.log("[sjidx] 키:", key);

    const CONFIG = {
      urls: {
        // 서버 두 곳에 동시에 요청을 보냄 (아이템 JSON / 옵션 JSON)
        itemsUrl: "/documents/outsideOrder/db/synthesize.asp?sjidx=" + encodeURIComponent(key),
        optionsUrl: "/documents/outsideOrder/db/options.asp?sjidx=" + encodeURIComponent(key),
      },
      // 옵션 JSON 안에서 찾을 옵션 키들(서버가 이 구조로 준다고 가정)
      optionKeys: ["redivision", "lobbyPhone", "protectiveMaterial", "bottomRail"],
      // 위 키를 화면에 보일 한글 라벨로 바꿔주는 표
      optionLabels: {
        redivision: "재료분리대",
        lobbyPhone: "로비폰",
        protectiveMaterial: "보양재",
        bottomRail: "하부레일",
      },
      // 결제 상태를 사람이 읽기 쉬운 말로 바꿔주는 표
      statusMap: { PAID: "입금완료", UNPAID: "미입금", PARTIAL: "부분입금" },
    };

    /*───────────────────────────────────────────────────────────────
    [2] 도우미 함수들: 숫자/날짜/사이즈 포맷, 경로 따라 값 꺼내기
    - fmtNumber(12345) → "12,345"
    - fmtDateYMD("2025-08-24") → "2025. 08. 24"
    - fmtSize(100, 200) → "100 × 200"
    - getByPath(obj,"a.b.c") → obj.a.b.c 값
    - formatByPath(path,val) → 경로 이름 보고 숫자/날짜 자동 포맷
    ───────────────────────────────────────────────────────────────*/
    const fmtNumber = v =>
      (v === null || v === undefined || v === "" || isNaN(Number(v)))
        ? "" : Number(v).toLocaleString("ko-KR");

    const fmtDateYMD = v => {
      if (!v) return "";
      const d = new Date(v);
      if (isNaN(d)) return String(v); // 날짜로 못 바꾸면 원문 그대로
      const y = d.getFullYear();
      const m = String(d.getMonth() + 1).padStart(2, "0");
      const day = String(d.getDate()).padStart(2, "0");
      return `${y}. ${m}. ${day}`;
    };

    const fmtSize = (w, h) =>
      [w, h].every(v => v != null && v !== "" && !isNaN(Number(v)))
        ? `${fmtNumber(w)} × ${fmtNumber(h)}`
        : "";

    // 어떤 경로 이름이면 숫자/날짜로 취급할지 정해둔 규칙(간단 정규식)
    const NUMBER_FIELDS =
      /(subtotal|vat|total|unitPrice|lineAmount|grossAmount|finalAmount|extraAmount|quantity|measuredSizeW|measuredSizeH|discountPrice)$/i;
    const DATE_FIELDS = /(quoteDate|dueDate|generatedAt|date|createdAt|updatedAt)$/i;

    const getByPath = (obj, path) =>
      path.split(".").reduce((o, k) => (o && k in o ? o[k] : undefined), obj);

    const formatByPath = (path, val) => {
      if (val === null || val === undefined) return "";
      if (DATE_FIELDS.test(path)) return fmtDateYMD(val);
      if (NUMBER_FIELDS.test(path) && !isNaN(Number(val))) return fmtNumber(val);
      return String(val);
    };

    /*───────────────────────────────────────────────────────────────
    [3] 서버에서 두 JSON을 "동시에" 받아오기 (빠르게 하려고 Promise.all 사용)
    - itemsRes.json(), optionsRes.json() 으로 실제 데이터를 꺼냄
    - 서버가 { data: {...} } 로 싸서 줄 수도 있으니 안전하게 풀어냄
    ───────────────────────────────────────────────────────────────*/
    console.log("[load] 시작: items & options 병렬 로드", CONFIG.urls);
    const [itemsRes, optionsRes] = await Promise.all([
      fetch(CONFIG.urls.itemsUrl),
      fetch(CONFIG.urls.optionsUrl),
    ]);
    const [itemsJson, optionsJson] = await Promise.all([
      itemsRes.json(),
      optionsRes.json(),
    ]);
    console.log("[load] items 로드 성공:", itemsJson);
    console.log("[load] options 로드 성공:", optionsJson);

    // 서버가 {data:{...}} 형태로 줄 수도 있고, 그냥 {...} 줄 수도 있어서 통일
    const base = itemsJson?.data ?? itemsJson ?? {};
    const items = Array.isArray(base.items) ? base.items : [];
    const optRoot = optionsJson?.data ?? optionsJson ?? {};
    const options = Array.isArray(optRoot.options) ? optRoot.options : [];

    /*───────────────────────────────────────────────────────────────
    [4] 합계 계산(아이템 합, 옵션 합, VAT, 전체)
    - 아이템 라인 금액: it.lineAmount 있으면 그대로, 없으면 단가*수량으로 계산
    - 옵션 최종 금액: op.finalAmount 합산
    - subtotal = 아이템합 + 옵션합
    - vat = subtotal * 10% (반올림)
    - total = subtotal + vat
    - 서버가 내려준 합계와 다르면 콘솔에서 경고로 알려줌(계산은 우리 기준으로 표시)
    ───────────────────────────────────────────────────────────────*/
    const itemSum = items.reduce((s, it) => {
      const line = Number(
        it.lineAmount ?? (Number(it.unitPrice || 0) * Number(it.quantity || 0))
      );
      return s + (isFinite(line) ? line : 0);
    }, 0);

    const optionFinalSum = options.reduce((s, op) => {
      const v = Number(op.finalAmount || 0);
      return s + (isFinite(v) ? v : 0);
    }, 0);

    const expectedSubtotal = itemSum;
    const expectedVat = Math.round(expectedSubtotal * 0.1);
    const expectedTotal = expectedSubtotal + expectedVat;

    const givenSubtotal = Number(base.subtotal || 0);
    const givenVat = Number(base.vat || 0);
    const givenTotal = Number(base.total || 0);

    if (givenSubtotal !== expectedSubtotal ||
      givenVat !== expectedVat ||
      givenTotal !== expectedTotal) {
      console.warn("[check] 합계 불일치 감지", {
        givenSubtotal, expectedSubtotal, givenVat, expectedVat, givenTotal, expectedTotal
      });
    } else {
      console.log("[check] 합계 일치 OK");
    }

    /*───────────────────────────────────────────────────────────────
    [5] 옵션을 "종류별로" 한 장에 요약하기(선택 기능)
    ───────────────────────────────────────────────────────────────*/
    // [5] 옵션 집계 함수
    const buildOptionsAgg = (options) => {
      const optMap = new Map();
      options.forEach(op => {
        CONFIG.optionKeys.forEach(k => {
          const slot = op?.[k];
          if (!slot || slot.enabled === false) return;

          const qty = Number(slot.quantity ?? slot.qty ?? 0) || 0;
          const up = Number(slot.unitPrice ?? slot.price ?? 0) || 0;
          const line = (slot.total != null && slot.total !== "")
            ? Number(slot.total) || 0
            : up * qty;

          if (!optMap.has(k)) {
            optMap.set(k, {
              __type: "optionAgg",
              key: k,
              label: CONFIG.optionLabels[k] ?? k,
              unitPrice: 0,
              quantity: 0,
              total: 0,
              count: 0,
              _qtySum: 0,
              _unitSet: new Set(),
              details: [],
            });
          }
          const acc = optMap.get(k);
          acc.quantity += qty;
          acc.total += Math.round(line);
          acc.count += 1;
          acc._qtySum += qty;
          if (up > 0) acc._unitSet.add(up);
          acc.details.push({ seq: op.seq, name: op.name, unitPrice: up, quantity: qty, total: Math.round(line) });
        });
      });

      const arr = Array.from(optMap.values()).map(r => {
        let unit;
        const units = Array.from(r._unitSet);
        if (units.length === 1) unit = units[0];
        else if (r._qtySum > 0) unit = r.total / r._qtySum; // 가중평균
        else unit = 0;
        r.unitPrice = Math.round(unit);
        delete r._qtySum; delete r._unitSet;
        return r;
      });

      return arr.filter(r => (r.total || r.quantity)).sort((a, b) => b.total - a.total);
    };

    // ✅ 이 한 줄을 “반드시” 여기 붙이세요(아래 [6]보다 위에 있어야 함)
    const optionsAgg = buildOptionsAgg(options);


    /*───────────────────────────────────────────────────────────────
    [6] 화면에서 바로 쓸 "view"라는 큰 바구니를 준비한다
    - 서버가 내려준 기본값(base)을 복사해서 우리가 계산한 값으로 덮어씀
    - 이렇게 하면 템플릿에서 {subtotal}, {vat}, {total} 같은 전역 토큰이 바로 동작
    ───────────────────────────────────────────────────────────────*/
    const view = structuredClone ? structuredClone(base) : JSON.parse(JSON.stringify(base));
    view.items = items;
    view.options = options;
    view.optionsAgg = optionsAgg; // ← 이 줄이 있어야 {option.*} 토큰이 정상 바인딩됩니다.


    view.subtotalItems = itemSum;

    const optionsAggTotal = (Array.isArray(optionsAgg) ? optionsAgg : [])
      .reduce((s, r) => s + (isFinite(r.total) ? r.total : 0), 0);

    // finalAmount가 하나라도 명시된 경우엔 그 합(=optionFinalSum), 아니면 집계값 사용
    const hasAnyFinalAmount = options.some(op => op.finalAmount != null && op.finalAmount !== "");
    view.subtotalOptions = hasAnyFinalAmount ? optionFinalSum : optionsAggTotal;

    view.subtotal = (view.subtotalItems || 0);
    view.vat = Math.round(view.subtotal * 0.1);
    view.total = view.subtotal + view.vat;


    view.paymentStatusText = CONFIG.statusMap[view.paymentStatus] ?? String(view.paymentStatus ?? "");

    /*───────────────────────────────────────────────────────────────
    [7] 템플릿 요소들 찾기(필수: .table-body / 선택: .table-body-option)
    - 이 행들은 복사본을 떠서 실제 데이터로 채워 append 하게 된다
    - 원본 템플릿은 display:none 유지(화면에 안 보임)
    ───────────────────────────────────────────────────────────────*/
    let tplItem = document.querySelector("table.my-2 tbody tr.table-body");
    if (!tplItem) {
      console.error("[tpl] tbody 안에 .table-body(아이템) 템플릿 행이 필요합니다.");
      return;
    }
    tplItem.dataset.template = "item";
    tplItem.style.display = "none";
    const mountItem = tplItem.parentElement; // 아이템을 붙일 부모 <tbody>

    let tplOption = document.querySelector("table.my-2 tbody tr.table-body-option");
    let mountOption = null;
    if (tplOption) {
      tplOption.dataset.template = "option";
      tplOption.style.display = "none";
      mountOption = tplOption.parentElement; // 옵션을 붙일 부모 <tbody>
    } else {
      console.warn("[tpl] 옵션 집계 템플릿(.table-body-option)을 찾지 못했습니다. 옵션 렌더는 생략됩니다.");
    }

    /*───────────────────────────────────────────────────────────────
    [8] 토큰 치환기: 텍스트/속성의 { ... } 부분을 실제 값으로 바꿔 넣는다
    - replaceTextTokens: 문자열 속 {토큰}을 값으로 바꿈
    - replaceAttrTokens: 태그 속성들(href, title 등)의 {토큰}도 바꿈
    - fillNode: 한 행(<tr>) 전체를 돌며 텍스트/속성을 모두 바꿈
    ───────────────────────────────────────────────────────────────*/
    const replaceTextTokens = (text, contextItem, seq) => {
      if (!text || !/\{[^}]+\}/.test(text)) return text; // 토큰이 없으면 그대로 반환

      let t = text;

      // 1) {seq} → 1,2,3... (행 번호)
      t = t.replace(/\{seq\}/g, String(seq));

      // 2) 아이템 전용 토큰 {items[키이름]}
      if (contextItem && contextItem.__type === "item") {
        t = t.replace(/\{items\[([^\]]+)\]\}/g, (_m, keyRaw) => {
          const key = String(keyRaw).trim();
          let val = contextItem?.[key];

          // 특별 규칙: measuredSize는 W × H 형태로 예쁘게 표시
          if (key === "measuredSize") {
            return fmtSize(contextItem?.measuredSizeW, contextItem?.measuredSizeH);
          }
          // lineAmount/amount 비어 있으면 단가*수량으로 계산해서 채움
          if ((key === "lineAmount" || key === "amount") &&
            (val === undefined || val === null || val === "")) {
            val = Number(contextItem?.unitPrice || 0) * Number(contextItem?.quantity || 0);
          }

          // 숫자/날짜는 자동 포맷해서 반환
          const path = `items.${key}`;
          return formatByPath(path, val);
        });
      }

      // 3) 옵션 집계 전용 토큰 {option.xxx}
      if (contextItem && contextItem.__type === "optionAgg") {
        t = t.replace(/\{option\.([a-zA-Z0-9_]+)\}/g, (_m, key) => {
          const v = contextItem[key];
          // 숫자로 보이는 키들은 자동 천단위 포맷
          if (/^(quantity|total|count|unitPrice)$/i.test(key) && !isNaN(Number(v))) {
            return fmtNumber(v);
          }
          return (v ?? "") + "";
        });
      }

      // 4) 결제상태 토큰 {paymentStatus(...)} → 한글 상태로 통일
      t = t.replace(/\{paymentStatus\([^)]+\)\}/g, view.paymentStatusText);

      // 5) 전역 바인딩 {foo.bar}
      //    단, items.* 는 위에서 이미 처리하므로 건드리지 않음
      t = t.replace(/\{([a-zA-Z0-9_.]+)\}/g, (_m, path) => {
        if (path.startsWith("items")) return _m; // items.* 는 패스
        const val = getByPath(view, path);
        return formatByPath(path, val);
      });

      return t;
    };

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
      // (1) 텍스트 노드 안 {토큰} 바꾸기
      const walker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT, null);
      const toEdit = [];
      while (walker.nextNode()) toEdit.push(walker.currentNode);
      toEdit.forEach(textNode => {
        textNode.nodeValue = replaceTextTokens(textNode.nodeValue, item, seq);
      });

      // (2) 속성(href, title, data-*)에도 {토큰}이 있을 수 있으니 바꾸기
      replaceAttrTokens(node, item, seq);

      // (3) 표에서 첫번째 rowspan 같은 칸에 자동으로 행번호 찍어주고 싶을 때
      const firstRowspan = node.querySelector("td[rowspan], th[rowspan]");
      if (firstRowspan && !/\{seq\}/.test(firstRowspan.textContent)) {
        firstRowspan.textContent = String(seq);
      }

      // (4) [data-date-path="quoteDate"] 같이 날짜만 특정 포맷으로 찍고 싶을 때
      node.querySelectorAll("[data-date-path]").forEach(el => {
        const p = el.dataset.datePath;
        const v = (p in view) ? view[p] : item?.[p];
        el.textContent = fmtDateYMD(v);
      });
    };

    /*───────────────────────────────────────────────────────────────
    [9] 전역 바인딩 적용
    - 문서 전체에서 {subtotal},{vat},{total} 같은 전역 토큰을 한번에 바꿈
    - data-bind-total / data-bind-total-items / data-bind-total-options 채우기
    ───────────────────────────────────────────────────────────────*/
    const applyGlobalBindings = () => {
      // 전체 텍스트 노드에서 {토큰} 치환(단, items.*는 위에서 처리됨)
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

      // 속성의 {토큰}도 전역 적용
      replaceAttrTokens(document, null, "");

      // 합계 숫자들 채우기
      document.querySelectorAll("[data-bind-total]").forEach(el => {
        const key = el.dataset.bindTotal;
        if (key && key in view) el.textContent = formatByPath(key, view[key]);
      });

      // (선택) 아이템합/옵션합 분리 표시
      const bi = document.querySelector("[data-bind-total-items]");
      if (bi) bi.textContent = fmtNumber(view.subtotalItems);
      const bo = document.querySelector("[data-bind-total-options]");
      if (bo) bo.textContent = fmtNumber(view.subtotalOptions);
    };

    /*───────────────────────────────────────────────────────────────
    [10] 렌더링(그리기)
    - 템플릿 행을 복사해서 실제 데이터를 끼워 넣고 <tbody>에 추가
    - 그 전에 기존에 붙어 있던 행은 싹 지움(헤더는 유지)
    - 다 끝나면 전역 바인딩으로 합계/날짜 같은 공통 자리도 채움
    ───────────────────────────────────────────────────────────────*/
    const render = () => {
      // 아이템 표 비우기(템플릿/헤더는 남기고 나머지 삭제)
      Array.from(mountItem.querySelectorAll("tr"))
        .filter(tr => tr !== tplItem && !tr.matches(".table-head"))
        .forEach(tr => tr.remove());

      console.log(`[items] 렌더: ${view.items.length}개`);
      view.items.forEach((it, i) => {
        const clone = tplItem.cloneNode(true);   // 템플릿 복사
        clone.style.display = "";                // 보이게 전환
        clone.removeAttribute("data-template");  // 그냥 일반 행으로 만들기
        const ctx = { ...it, __type: "item" };   // 아이템임을 표시
        fillNode(clone, ctx, i + 1);             // 토큰 치환
        mountItem.appendChild(clone);            // 붙이기
      });

      // 옵션 집계 표(있을 때만)
      if (tplOption && mountOption) {
        Array.from(mountOption.querySelectorAll("tr"))
          .filter(tr => tr !== tplOption && !tr.matches(".table-head"))
          .forEach(tr => tr.remove());

        console.log(`[options] 항목별 집계 렌더: ${view.optionsAgg.length}개`);
        view.optionsAgg.forEach((opAgg, i) => {
          const clone = tplOption.cloneNode(true);
          clone.style.display = "";
          clone.removeAttribute("data-template");
          fillNode(clone, opAgg, i + 1);
          mountOption.appendChild(clone);
        });
      }

      // 합계/날짜 등 전역 자리 채우기
      applyGlobalBindings();
    };

    // 첫 렌더 실행
    render();

    /*───────────────────────────────────────────────────────────────
    [11] 템플릿이 바뀌었을 때 자동 재렌더(개발 중 편의)
    - 템플릿 행(.table-body, .table-body-option)을 수정해도 즉시 반영
    ───────────────────────────────────────────────────────────────*/
    const moItems = new MutationObserver(() => {
      console.log("[tpl:item] 변경 감지 → 재렌더");
      render();
    });
    moItems.observe(tplItem, { attributes: true, childList: true, subtree: true, characterData: true });

    if (tplOption) {
      const moOptions = new MutationObserver(() => {
        console.log("[tpl:option] 변경 감지 → 재렌더");
        render();
      });
      moOptions.observe(tplOption, { attributes: true, childList: true, subtree: true, characterData: true });
    }

    /*───────────────────────────────────────────────────────────────
    [12] 외부에서 데이터 밀어넣기(선택)
    - 예: setFrontData({ items:[...], options:[...], paymentStatus:"PAID" })
    - 일부만 줘도 됨(아이템만/옵션만)
    ───────────────────────────────────────────────────────────────*/
    window.setFrontData = (next) => {
      const nextData = next?.data ?? next ?? {};
      const nextItems = Array.isArray(nextData.items) ? nextData.items : (next.items ? next.items : undefined);
      const nextOptions = Array.isArray(nextData.options) ? nextData.options : (next.options ? next.options : undefined);

      // (1) 아이템 교체되면 합계도 다시 계산
      if (nextItems) {
        view.items = nextItems;
        view.subtotalItems = nextItems.reduce((s, it) => {
          const line = Number(
            it.lineAmount ?? (Number(it.unitPrice || 0) * Number(it.quantity || 0))
          );
          return s + (isFinite(line) ? line : 0);
        }, 0);
      }

      // (2) 옵션 교체되면 집계/합계도 다시 계산
      if (nextOptions) {
        view.options = nextOptions;
        view.optionsAgg = buildOptionsAgg(nextOptions);
        view.subtotalOptions = nextOptions.reduce((s, op) => {
          const v = Number(op.finalAmount || 0);
          return s + (isFinite(v) ? v : 0);
        }, 0);
      }

      // (3) 합계/부가세/총액 다시 계산
      view.subtotal = (view.subtotalItems || 0) + (view.subtotalOptions || 0);
      view.vat = Math.round(view.subtotal * 0.1);
      view.total = view.subtotal + view.vat;

      // (4) 결제상태가 들어오면 한글표시도 업데이트
      if ("paymentStatus" in nextData) {
        view.paymentStatus = nextData.paymentStatus;
        view.paymentStatusText = CONFIG.statusMap[view.paymentStatus] ?? String(view.paymentStatus ?? "");
      }
      if (next.meta) view.meta = next.meta;

      // (5) 그 외 전역 필드도 덮어쓰기(quoteDate 같은 것들)
      Object.keys(nextData).forEach(k => {
        if (k === "items" || k === "options") return;
        view[k] = nextData[k];
      });

      console.log("[data] setFrontData 적용:", {
        items: view.items?.length ?? 0,
        options: view.options?.length ?? 0,
        subtotalItems: view.subtotalItems,
        subtotalOptions: view.subtotalOptions,
        subtotal: view.subtotal, vat: view.vat, total: view.total
      });

      render(); // 변경사항 화면 반영
    };

    // 개발 편의를 위해 전역에서 현재 뷰 상태를 확인할 수 있게 노출
    window._frontView = view;

  } catch (e) {
    // 여기로 오면 네트워크 문제나 JSON 형식 오류 같은 게 난 것
    console.error("[error] 통합 로딩/렌더 실패:", e);
  }
})();