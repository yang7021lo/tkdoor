/* ================================
   네스팅 드로잉 (Canvas)
   /tng2/nesting/nesting_draw.js
   
   - 화면용 드로잉
   - 인쇄용 드로잉
================================ */

var NestingDraw = (function() {
  'use strict';

  // 색상 팔레트
  const COLORS = {
    sheet: '#ffffff',
    strip: '#bcd4ea',
    stripHover: '#a8c8e8',
    stripSelected: 'rgba(255, 80, 80, 0.6)',
    border: '#111111',
    text: '#111111',
    textLight: '#666666',
    loss: '#f0f0f0'
  };

  /**
   * 화면용 시트 드로잉
   * @param {HTMLCanvasElement} canvas
   * @param {Object} sheet - 시트 데이터
   * @param {number} sheetW - 시트 길이
   * @param {number} sheetH - 시트 폭
   * @param {Object} selectedItem - 선택된 아이템 (옵션)
   */
  function drawSheetScreen(canvas, sheet, sheetW, sheetH, selectedItem) {
    const margin = 20;
    const baseW = 900;
    const scale = (baseW - margin * 2) / sheetW;

    canvas.width = baseW;
    canvas.height = sheetH * scale + margin * 2;

    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // 배경
    ctx.fillStyle = COLORS.sheet;
    ctx.fillRect(margin, margin, sheetW * scale, sheetH * scale);

    // 외곽선
    ctx.strokeStyle = COLORS.border;
    ctx.lineWidth = 2;
    ctx.strokeRect(margin, margin, sheetW * scale, sheetH * scale);

    let y = 0;
    let cutNo = 1;

    sheet.strips.forEach(function(st) {
      const rh = st.stripW * scale;
      const ry = margin + y * scale;

      // 스트립 배경
      ctx.fillStyle = COLORS.strip;
      ctx.fillRect(margin, ry, sheetW * scale, rh);
      ctx.strokeStyle = COLORS.border;
      ctx.strokeRect(margin, ry, sheetW * scale, rh);

      let x = 0;
      st.pieces.forEach(function(p) {
        const rw = p.len * scale;
        const rx = margin + x * scale;

        // 선택된 아이템 하이라이트
        const isSelected = selectedItem && 
          Number(p.w) === Number(selectedItem.width);

        if (isSelected) {
          ctx.fillStyle = COLORS.stripSelected;
          ctx.fillRect(rx, ry, rw, rh);
        }

        // 피스 테두리
        ctx.strokeStyle = COLORS.border;
        ctx.lineWidth = 1;
        ctx.strokeRect(rx, ry, rw, rh);

        // 치수 텍스트
        ctx.fillStyle = isSelected ? '#fff' : COLORS.text;
        ctx.font = 'bold 11px Arial';
        ctx.fillText(p.w + '×' + p.len, rx + 4, ry + 14);
        
        // 절단 번호
        ctx.font = '10px Arial';
        ctx.fillStyle = COLORS.textLight;
        ctx.fillText('#' + cutNo++, rx + 4, ry + rh - 4);

        // 자재명 (공간이 있으면)
        if (rw > 60 && rh > 30 && p.name) {
          ctx.fillStyle = COLORS.textLight;
          ctx.font = '9px Arial';
          const name = p.name.length > 10 ? p.name.substring(0, 10) + '...' : p.name;
          ctx.fillText(name, rx + 4, ry + 26);
        }

        x += p.len;
      });

      // 남은 공간 표시
      if (x < sheetW) {
        const lossW = (sheetW - x) * scale;
        const lossX = margin + x * scale;
        ctx.fillStyle = COLORS.loss;
        ctx.fillRect(lossX, ry, lossW, rh);
        ctx.strokeRect(lossX, ry, lossW, rh);
        
        // LOSS 텍스트
        ctx.fillStyle = '#999';
        ctx.font = 'bold 10px Arial';
        ctx.fillText('LOSS', lossX + 4, ry + rh / 2 + 4);
      }

      y += st.stripW;
    });

    // 하단 남은 공간
    if (y < sheetH) {
      const lossH = (sheetH - y) * scale;
      const lossY = margin + y * scale;
      ctx.fillStyle = COLORS.loss;
      ctx.fillRect(margin, lossY, sheetW * scale, lossH);
      ctx.strokeStyle = COLORS.border;
      ctx.strokeRect(margin, lossY, sheetW * scale, lossH);
    }
  }

  /**
   * 인쇄용 시트 드로잉
   * @param {HTMLCanvasElement} canvas
   * @param {Object} sheet
   * @param {number} sheetW
   * @param {number} sheetH
   */
  function drawSheetPrint(canvas, sheet, sheetW, sheetH) {
    const A4_W = 794;
    const PRINT_H = 650;
    const margin = 30;

    canvas.width = A4_W;
    canvas.height = PRINT_H;

    const usableW = A4_W - margin * 2;
    const usableH = PRINT_H - margin * 2;

    const scale = Math.min(usableW / sheetW, usableH / sheetH);

    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // 외곽
    ctx.strokeStyle = COLORS.border;
    ctx.lineWidth = 2;
    ctx.strokeRect(margin, margin, sheetW * scale, sheetH * scale);

    let y = 0;

    sheet.strips.forEach(function(st) {
      const rh = st.stripW * scale;
      const ry = margin + y * scale;

      ctx.fillStyle = '#cfe3f2';
      ctx.fillRect(margin, ry, sheetW * scale, rh);
      ctx.strokeRect(margin, ry, sheetW * scale, rh);

      let x = 0;
      st.pieces.forEach(function(p) {
        const rw = p.len * scale;
        const rx = margin + x * scale;
        ctx.strokeRect(rx, ry, rw, rh);
        x += p.len;
      });

      y += st.stripW;
    });
  }

  /**
   * 시트 카드 HTML 생성
   * @param {Object} sheet
   * @param {string} label - 시트 규격 라벨
   * @returns {HTMLElement}
   */
  function createSheetCard(sheet, label) {
    const card = document.createElement('div');
    card.className = 'sheet-card';

    // 헤더
    const head = document.createElement('div');
    head.className = 'sheet-head';
    head.innerHTML = 
      '<span class="sheet-no">#' + sheet.sheetNo + ' 시트</span>' +
      '<span class="sheet-spec">' + label + '</span>' +
      '<span class="loss-rate">로스율: ' + sheet.lossRate + '%</span>';

    // 캔버스 래퍼
    const wrap = document.createElement('div');
    wrap.className = 'canvas-wrap';

    const canvas = document.createElement('canvas');
    wrap.appendChild(canvas);

    // 상세 정보
    const detail = document.createElement('div');
    detail.className = 'sheet-detail';

    let detailHtml = '<div class="detail-row">';
    sheet.strips.forEach(function(st) {
      st.pieces.forEach(function(p) {
        detailHtml += '<span class="detail-item">' + p.w + '×' + p.len + '</span>';
      });
    });
    detailHtml += '</div>';
    detail.innerHTML = detailHtml;

    card.appendChild(head);
    card.appendChild(wrap);
    card.appendChild(detail);

    return { card: card, canvas: canvas };
  }

  // 공개 API
  return {
    drawSheetScreen: drawSheetScreen,
    drawSheetPrint: drawSheetPrint,
    createSheetCard: createSheetCard
  };

})();
