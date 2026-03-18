
(async function () {
  try {
    const res = await fetch("/documents/outsideOrder/db/options.json");
    const json = await res.json();
    const options = (json.data?.options ?? json.options) || [];
    console.log("[options] loaded:", options.length);

    const headers = Array.from(document.querySelectorAll(".header"));
    const optHeader = headers.find(h => (h.querySelector(".title")?.textContent || "").includes("옵션"));
    if (!optHeader) {
      console.warn("[options] .frame-header(옵션) 를 찾지 못했습니다.");
      return;
    }

    const next = optHeader.nextElementSibling;
    let mount = document.createElement("div");
    mount.id = "options-container";
    if (next && next.matches("table.my-2")) {
      next.parentNode.insertBefore(mount, next);
      next.remove();
    } else {
      optHeader.insertAdjacentElement("afterend", mount);
    }

    // 값이 없으면 "-" 반환
    const fmtNum = v => (v == null || v === "" || isNaN(v)) ? "-" : Number(v).toLocaleString("ko-KR");
    const fmtBool = v => (v == null ? "-" : (v ? "예" : "아니오"));

    const tableTpl = (o, seq) => {
      // 활성화된(예) 섹션만 골라서 행 수 계산
      const sections = [
        sectionTpl("재분", o.redivision),
        sectionTpl("로비폰", o.lobbyPhone),
        sectionTpl("보양재", o.protectiveMaterial),
        sectionTpl("하부레일", o.bottomRail)
      ];

      // sectionTpl에서 ""(스킵) 된 건 행수에 포함 안 함
      const activeCount = sections.filter(html => html !== "").length;

      // 기본 행수 계산
      // 제품명 1행 + (옵션 섹션당 2행) + 최종가 2행
      const rowspanCount = 1 + (activeCount * 2) + 2;

      return `
    <table class="my-2" style="width:100%;border-collapse:collapse;margin-bottom:20px;page-break-inside:avoid;">
      <thead>
        <tr>
          <th style="width:6%;">#</th>
          <th class="txt-left">제품명</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td rowspan="${rowspanCount}" style="width:6%;">${seq}</td>
          <td class="text-start">${o.name ?? "-"}</td>
        </tr>

        ${sections.join("")}

        <tr>
          <td class="inner-wrap" colspan="7" style="padding:0;">
            <table class="inner"><thead><tr>
              <th class="text-end">옵션 최종가</th>
            </tr></thead></table>
          </td>
        </tr>
        <tr>
          <td class="inner-wrap" colspan="7" style="padding:0;">
            <table class="inner"><tbody><tr>
              <td class="text-end" data-unit="원">${fmtNum(o.finalAmount)}</td>
            </tr></tbody></table>
          </td>
        </tr>
      </tbody>
    </table>
  `;
    };

    function sectionTpl(label, data) {
      if (!data || !data.enabled) return ""; // 아니오면 스킵

      return `
    <tr>
      <td class="inner-wrap" colspan="7" style="padding:0;">
        <table class="inner"><thead><tr>
          <th style="width:12%;">${label} 여부</th>
          <th style="width:18%;">${label} 단가</th>
          <th style="width:10%;">${label} 수량</th>
          <th style="width:18%;">${label} 총액</th>
        </tr></thead></table>
      </td>
    </tr>
    <tr>
      <td class="inner-wrap" colspan="7" style="padding:0;">
        <table class="inner"><tbody><tr>
          <td style="width:12%;" class="text-center">${fmtBool(data.enabled)}</td>
          <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(data.unitPrice)}</td>
          <td style="width:10%;" class="text-end" data-unit="개">${fmtNum(data.quantity)}</td>
          <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(data.total)}</td>
        </tr></tbody></table>
      </td>
    </tr>
  `;
    }



    mount.innerHTML = options.map((o, i) => tableTpl(o, o.seq ?? (i + 1))).join("");
    console.log("[options] 제품당 테이블 렌더 완료");
  } catch (err) {
    console.error("[options] 렌더 실패:", err);
  }
})();
