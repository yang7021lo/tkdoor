
(async function () {
  try {
    // 1) frames.json 로드
    const res = await fetch("/documents/outsideOrder/db/frames.json");
    const json = await res.json();
    const frames = (json.data?.frames ?? json.frames) || [];
    console.log("[frames] loaded:", frames.length);

    // 2) 프레임 섹션 위치 찾기: .frame-header 중 '프레임' 제목을 가진 섹션
    const headers = Array.from(document.querySelectorAll(".header"));
    const frameHeader = headers.find(h => (h.querySelector(".title")?.textContent || "").includes("프레임"));
    if (!frameHeader) {
      console.warn("[frames] .frame-header(프레임) 를 찾지 못했습니다.");
      return;
    }

    // 3) 기존 단일 테이블 제거 후 컨테이너 생성
    const next = frameHeader.nextElementSibling;
    let mount = document.createElement("div");
    mount.id = "frames-container";
    if (next && next.matches("table.my-2")) {
      next.parentNode.insertBefore(mount, next);
      next.remove();
    } else {
      frameHeader.insertAdjacentElement("afterend", mount);
    }

    // 4) 포맷 헬퍼
    const fmtNum = v => (v == null || v === "") ? "" : Number(v).toLocaleString("ko-KR");
    const fmtRate = v => {
      if (v == null || v === "") return "";
      const n = Number(v);
      return (n >= 0 && n <= 1) ? `${(n * 100).toFixed(0)}` : `${n}`;
    };

    // 5) 제품당 <table> 템플릿
    const tableTpl = (f, seq) => `
      <table class="my-2" style="width:100%;border-collapse:collapse;margin-bottom:20px;page-break-inside:avoid;">
        <thead>
          <tr>
            <th style="width:6%;">#</th>
            <th class="txt-left">제품명</th>
            <th class="txt-left" style="width:14%;">재질</th>
            <th class="txt-left" style="width:14%;">도장</th>
            <th class="txt-left" style="width:11%;">도어타입</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td rowspan="5" style="width:6%;">${seq}</td>
            <td class="text-start">${f.name ?? ""}</td>
            <td class="txt-left">${f.material ?? ""}</td>
            <td class="txt-left">${f.coating ?? ""}</td>
            <td class="txt-left">${f.doorType ?? ""}</td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><thead><tr>
                <th style="width:18%;">검측가로</th>
                <th style="width:18%;">검측세로</th>
                <th style="width:18%;">도어높이</th>
                <th style="width:18%;">묻힘</th>
              </tr></thead></table>
            </td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><tbody><tr>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(f.measuredW)}</td>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(f.measuredH)}</td>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(f.doorHeight)}</td>
                <td style="width:18%;" class="text-end" data-unit="mm">${fmtNum(f.buryDepth)}</td>
              </tr></tbody></table>
            </td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><thead><tr>
                <th style="width:18%;">단가</th>
                <th style="width:18%;">수량</th>
                <th style="width:18%;">전체금액</th>
                <th style="width:18%;">할인율</th>
                <th style="width:12%;">할인가</th>
                <th style="width:16%;">최종가</th>
              </tr></thead></table>
            </td>
          </tr>

          <tr>
            <td class="inner-wrap" colspan="7" style="padding:0;">
              <table class="inner"><tbody><tr>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(f.unitPrice)}</td>
                <td style="width:18%;" class="text-end" data-unit="개">${fmtNum(f.quantity)}</td>
                <td style="width:18%;" class="text-end" data-unit="원">${fmtNum(f.grossAmount)}</td>
                <td style="width:18%;" class="text-end" data-unit="%">${fmtRate(f.discountRate)}</td>
                <td style="width:12%;" class="text-end" data-unit="원">${fmtNum(f.discountAmount)}</td>
                <td style="width:16%;" class="text-end" data-unit="원">${fmtNum(f.finalAmount)}</td>
              </tr></tbody></table>
            </td>
          </tr>
        </tbody>
      </table>
    `;

    // 6) 렌더
    mount.innerHTML = frames.map((f, i) => tableTpl(f, f.seq ?? (i + 1))).join("");
    console.log("[frames] 제품당 테이블 렌더 완료");
  } catch (err) {
    console.error("[frames] 렌더 실패:", err);
  }
})();
