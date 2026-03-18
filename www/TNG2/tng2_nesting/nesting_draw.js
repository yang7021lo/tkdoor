/* nesting_draw.js - Canvas 드로잉 */
var NestingDraw = (function() {
  'use strict';

  const COLORS = {
    bg: '#ffffff',
    strip: '#cfe3f2',
    border: '#333333',
    text: '#111111',
    loss: '#f5f5f5',
    lossText: '#999999'
  };

  /**
   * 시트 Canvas 드로잉
   */
  function drawSheet(canvas, sheet, options) {
    options = options || {};
    const margin = options.margin || 30;
    const maxWidth = options.maxWidth || 800;
    
    const plateW = sheet.plate.length; // 길이 방향 (가로)
    const plateH = sheet.plate.width;  // 폭 방향 (세로)
    
    const scale = (maxWidth - margin * 2) / plateW;
    
    canvas.width = maxWidth;
    canvas.height = plateH * scale + margin * 2;
    
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // 배경
    ctx.fillStyle = COLORS.bg;
    ctx.fillRect(margin, margin, plateW * scale, plateH * scale);
    
    // 외곽선
    ctx.strokeStyle = COLORS.border;
    ctx.lineWidth = 2;
    ctx.strokeRect(margin, margin, plateW * scale, plateH * scale);
    
    // 스트립 및 부품 배치
    if (sheet.strips && sheet.strips.length > 0) {
      sheet.strips.forEach(function(strip) {
        const stripY = margin + strip.y * scale;
        const stripH = Math.max(...strip.pieces.map(p => p.width)) * scale;
        
        // 스트립 배경
        ctx.fillStyle = COLORS.strip;
        ctx.fillRect(margin, stripY, plateW * scale, stripH);
        
        // 각 부품
        strip.pieces.forEach(function(piece) {
          const px = margin + piece.x * scale;
          const py = stripY;
          const pw = piece.length * scale;
          const ph = piece.width * scale;
          
          ctx.strokeStyle = COLORS.border;
          ctx.lineWidth = 1;
          ctx.strokeRect(px, py, pw, ph);
          
          // 치수 텍스트
          ctx.fillStyle = COLORS.text;
          ctx.font = '10px Arial';
          const label = piece.width + '×' + piece.length;
          ctx.fillText(label, px + 3, py + 12);
          
          // 부품명 (공간 있으면)
          if (pw > 50 && ph > 24 && piece.name) {
            ctx.font = '9px Arial';
            ctx.fillStyle = '#666';
            const name = piece.name.length > 12 ? piece.name.substring(0,12) + '..' : piece.name;
            ctx.fillText(name, px + 3, py + 24);
          }
        });
      });
    } else if (sheet.placements && sheet.placements.length > 0) {
      // placements 직접 사용
      sheet.placements.forEach(function(p) {
        const px = margin + p.x * scale;
        const py = margin + p.y * scale;
        const pw = p.length * scale;
        const ph = p.width * scale;
        
        ctx.fillStyle = COLORS.strip;
        ctx.fillRect(px, py, pw, ph);
        
        ctx.strokeStyle = COLORS.border;
        ctx.lineWidth = 1;
        ctx.strokeRect(px, py, pw, ph);
        
        ctx.fillStyle = COLORS.text;
        ctx.font = '10px Arial';
        ctx.fillText(p.width + '×' + p.length, px + 3, py + 12);
      });
    }
    
    // 로스 영역 표시
    if (sheet.lossRate > 5) {
      ctx.fillStyle = 'rgba(200,200,200,0.3)';
      // 하단 남은 공간
      const usedHeight = sheet.strips ? 
        Math.max(...sheet.strips.map(s => s.y + Math.max(...s.pieces.map(p => p.width)))) : 
        (sheet.placements ? Math.max(...sheet.placements.map(p => p.y + p.width)) : 0);
      
      if (usedHeight < plateH) {
        const lossY = margin + usedHeight * scale;
        const lossH = (plateH - usedHeight) * scale;
        ctx.fillRect(margin, lossY, plateW * scale, lossH);
        ctx.fillStyle = COLORS.lossText;
        ctx.font = 'bold 11px Arial';
        ctx.fillText('LOSS', margin + 10, lossY + 20);
      }
    }
  }

  /**
   * 시트 카드 HTML 생성
   */
  function createSheetCard(sheet) {
    const card = document.createElement('div');
    card.className = 'sheet-card';
    
    // 헤더
    const head = document.createElement('div');
    head.className = 'sheet-head';
    head.innerHTML = 
      '<span class="sheet-no"># ' + sheet.sheetNo + '</span>' +
      '<span>' + sheet.plate.spec + '</span>' +
      '<span>두께: 1.2T</span>' +
      '<span>수량: 1</span>' +
      '<span class="loss-rate">로스율: ' + sheet.lossRate + '%</span>';
    
    // Canvas
    const wrap = document.createElement('div');
    wrap.className = 'canvas-wrap';
    const canvas = document.createElement('canvas');
    wrap.appendChild(canvas);
    
    // 상세 정보
    const detail = document.createElement('div');
    detail.className = 'sheet-detail';
    
    let itemsHtml = '<div class="detail-title">배치 부품:</div><div class="detail-items">';
    const placements = sheet.placements || [];
    
    // 부품 그룹핑 (같은 크기)
    const groups = {};
    placements.forEach(p => {
      const key = p.width + '×' + p.length;
      if (!groups[key]) groups[key] = {width: p.width, length: p.length, count: 0, name: p.name};
      groups[key].count++;
    });
    
    Object.values(groups).forEach(g => {
      itemsHtml += '<span class="detail-item">' + g.name + ': ' + g.length + '×' + g.width + ' = ' + g.count + '</span>';
    });
    itemsHtml += '</div>';
    
    // 로스 영역
    if (sheet.lossRate > 0) {
      itemsHtml += '<div class="detail-loss">로스 영역: ';
      let lossNo = 1;
      // 간략히 D1, D2 형식으로
      itemsHtml += '<span>D' + lossNo + ': ' + Math.round(sheet.lossArea/1000) + 'mm²</span>';
      itemsHtml += '</div>';
    }
    
    detail.innerHTML = itemsHtml;
    
    card.appendChild(head);
    card.appendChild(wrap);
    card.appendChild(detail);
    
    return {card: card, canvas: canvas};
  }

  return {
    drawSheet: drawSheet,
    createSheetCard: createSheetCard
  };
})();
