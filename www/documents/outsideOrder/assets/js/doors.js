
(async function () {
  try {
    // 1) doors.json 로드
    const res = await fetch("/documents/outsideOrder/db/doors.json");
    const json = await res.json();
    const doors = (json.data?.doors ?? json.doors) || [];
    console.log("[doors] loaded:", doors.length);

    // 2) 도어 섹션 위치 찾기
    const headers = Array.from(document.querySelectorAll(".header"));
    const doorHeader = headers.find(h => (h.querySelector(".title")?.textContent || "").includes("도어"));
    if (!doorHeader) {
      console.warn("[doors] .frame-header(도어) 를 찾지 못했습니다.");
      return;
    }

    // 3) 기존 단일 테이블 제거 후 컨테이너 생성
    const next = doorHeader.nextElementSibling;
    let mount = document.createElement("div");
    mount.id = "doors-container";
    if (next && next.matches("table.my-2")) {
      next.parentNode.insertBefore(mount, next);
      next.remove();
    } else {
      doorHeader.insertAdjacentElement("afterend", mount);
    }

    // 4) 포맷 헬퍼
    const fmtNum = v => (v == null || v === "") ? "" : Number(v).toLocaleString("ko-KR");
    const fmtRate = v => {
      if (v == null || v === "") return "";
      const n = Number(v);
      return (n >= 0 && n <= 1) ? `${(n * 100).toFixed(0)}` : `${n}`;
    };

    // 5) 제품당 <table> 템플릿
    const tableTpl = (d, seq) => `
      <table class="my-2" style="width:100%;border-collapse:collapse;margin-bottom:20px;page-break-inside:avoid;">
        <thead>
          <tr>
            <th style="width:6%;">#</th>
            <th class="txt-left">제품명</th>
            <th class="txt-left" style="width:14%;">가격여부</th>
            <th class="txt-left" style="width:11%;">도어타입</th>
            <th class="txt-left" style="width:8%;">규격</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td rowspan="5" style="width:6%;">${seq}</td>
            <td class="text-start">${d.name ?? ""}</td>
            <td class="txt-left">${d.priceType ?? ""}</td>
            <td class="txt-left">${d.doorType ?? ""}</td>
            <td class="txt-left">${d.spec ?? ""}</td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><thead><tr>
                <th style="width:18%;">도어가로</th>
                <th style="width:18%;">도어세로</th>
                <th style="width:18%;">도어유리가로</th>
                <th style="width:18%;">도어유리세로</th>
              </tr></thead></table>
            </td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><tbody><tr>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(d.doorW)}</td>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(d.doorH)}</td>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(d.glassW)}</td>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(d.glassH)}</td>
              </tr></tbody></table>
            </td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><thead><tr>
                <th style="width:18%;">도어 단가</th>
                <th style="width:10%;">수량</th>
                <th style="width:18%;">추가금액</th>
                <th style="width:18%;">전체금액</th>
                <th style="width:10%;">할인율</th>
                <th style="width:18%;">할인가</th>
                <th style="width:18%;">도어 최종가</th>
              </tr></thead></table>
            </td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><tbody><tr>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(d.unitPrice)}</td>
                <td style="width:10%;" class="text-end" data-unit="개">${fmtNum(d.quantity)}</td>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(d.extraAmount)}</td>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(d.grossAmount)}</td>
                <td style="width:10%;" class="text-end" data-unit="%">${fmtRate(d.discountRate)}</td>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(d.discountAmount)}</td>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(d.finalAmount)}</td>
              </tr></tbody></table>
            </td>
          </tr>
        </tbody>
      </table>
    `;

    // 6) 렌더
    mount.innerHTML = doors.map((d, i) => tableTpl(d, d.seq ?? (i + 1))).join("");
    console.log("[doors] 제품당 테이블 렌더 완료");
  } catch (err) {
    console.error("[doors] 렌더 실패:", err);
  }
})();
