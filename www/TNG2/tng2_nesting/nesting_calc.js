/* ================================
   네스팅 계산 엔진 v2
   /tng2/nesting/nesting_calc.js
   
   규칙 기반 2D Strip Packing
   - 부품 길이 기준 판재 선택
   - 재절단 부품 통합 처리
   - 우선순위 정렬
================================ */

var NestingCalc = (function() {
  'use strict';

  /**
   * 부품을 길이 기준으로 판재에 매칭
   * 규칙 2-1: 부품 길이 >= 3900 → 4000판재, >= 2900 → 3000판재, 나머지 → 2440판재
   */
  function matchPlateByLength(partLength, availablePlates) {
    // 사용 가능한 판재 중에서 부품이 들어갈 수 있는 가장 작은 판재 선택
    const sorted = availablePlates
      .filter(p => p.length >= partLength)
      .sort((a, b) => a.length - b.length);
    
    if (sorted.length > 0) return sorted[0];
    
    // 맞는 판재가 없으면 가장 큰 판재 반환
    return availablePlates.sort((a, b) => b.length - a.length)[0];
  }

  /**
   * 같은 크기(width x length) 부품 그룹핑 및 통합
   * 규칙 3-1: 같은 크기면 부품ID 달라도 통합
   */
  function groupPartsBySize(items) {
    const groups = new Map();
    
    items.forEach(item => {
      const key = item.width + 'x' + item.length;
      if (!groups.has(key)) {
        groups.set(key, {
          width: item.width,
          length: item.length,
          totalQty: 0,
          parts: [],
          material: item.material || ''
        });
      }
      const g = groups.get(key);
      g.totalQty += item.qty;
      g.parts.push(item);
    });
    
    return Array.from(groups.values());
  }

  /**
   * 부품 정렬 (규칙 4-1)
   * 1순위: 길이 내림차순
   * 2순위: 같은 크기 총 수량 내림차순 (재절단 우선)
   * 3순위: 폭 내림차순
   */
  function sortParts(groupedParts) {
    return groupedParts.sort((a, b) => {
      // 1순위: 길이 내림차순
      if (b.length !== a.length) return b.length - a.length;
      // 2순위: 수량 내림차순
      if (b.totalQty !== a.totalQty) return b.totalQty - a.totalQty;
      // 3순위: 폭 내림차순
      return b.width - a.width;
    });
  }

  /**
   * 판재 그룹별 부품 분류 (규칙 2-2)
   */
  function classifyPartsByPlate(groupedParts, availablePlates) {
    const plateGroups = {};
    
    availablePlates.forEach(p => {
      const key = p.width + 'x' + p.length;
      plateGroups[key] = {
        plate: p,
        parts: [],
        usedArea: 0
      };
    });
    
    groupedParts.forEach(part => {
      const plate = matchPlateByLength(part.length, availablePlates);
      const key = plate.width + 'x' + plate.length;
      plateGroups[key].parts.push({...part, remainingQty: part.totalQty});
    });
    
    return plateGroups;
  }

  /**
   * 단일 판재에 부품 배치 (Strip Packing)
   * @param {Object} plate - {width, length}
   * @param {Array} parts - 배치할 부품들 (remainingQty > 0인 것들)
   * @returns {Object} - {placements, usedArea, lossRate, remainingParts}
   */
  function packSinglePlate(plate, parts) {
    const placements = [];
    let currentY = 0; // 폭 방향 누적
    const strips = [];
    
    // 아직 배치할 부품이 있고 공간이 남아있는 동안 반복
    let availableParts = parts.filter(p => p.remainingQty > 0);
    
    while (currentY < plate.width && availableParts.length > 0) {
      // 현재 위치에서 가장 긴 부품 찾기 (길이가 판재에 맞고 폭이 남은 공간에 맞는)
      const remainingWidth = plate.width - currentY;
      
      // 배치 가능한 부품 찾기
      const fittingParts = availableParts.filter(p => 
        p.length <= plate.length && p.width <= remainingWidth && p.remainingQty > 0
      );
      
      if (fittingParts.length === 0) break;
      
      // 같은 길이 부품들을 스트립으로 배치
      // 가장 긴 부품 그룹 선택
      const maxLength = Math.max(...fittingParts.map(p => p.length));
      const sameLengthParts = fittingParts.filter(p => p.length === maxLength);
      
      // 스트립 생성
      const strip = {
        y: currentY,
        length: maxLength,
        pieces: []
      };
      
      let stripWidth = 0;
      
      // 같은 길이 부품들을 폭 방향으로 쌓기
      for (const part of sameLengthParts) {
        while (part.remainingQty > 0 && stripWidth + part.width <= remainingWidth) {
          strip.pieces.push({
            width: part.width,
            length: part.length,
            x: stripWidth,
            y: currentY,
            name: part.parts[0]?.baname || ''
          });
          stripWidth += part.width;
          part.remainingQty--;
          
          placements.push({
            width: part.width,
            length: part.length,
            x: stripWidth - part.width,
            y: currentY,
            name: part.parts[0]?.baname || ''
          });
        }
      }
      
      // 남은 폭 공간에 짧은 부품 추가 배치 시도
      const remainingStripWidth = remainingWidth - stripWidth;
      if (remainingStripWidth > 0) {
        // 길이가 더 짧은 부품 중 폭이 맞는 것 찾기
        const shorterParts = availableParts.filter(p => 
          p.length < maxLength && 
          p.length <= plate.length && 
          p.width <= remainingStripWidth && 
          p.remainingQty > 0
        );
        
        for (const part of shorterParts) {
          while (part.remainingQty > 0 && stripWidth + part.width <= remainingWidth) {
            strip.pieces.push({
              width: part.width,
              length: part.length,
              x: stripWidth,
              y: currentY,
              name: part.parts[0]?.baname || ''
            });
            
            placements.push({
              width: part.width,
              length: part.length,
              x: stripWidth,
              y: currentY,
              name: part.parts[0]?.baname || ''
            });
            
            stripWidth += part.width;
            part.remainingQty--;
          }
        }
      }
      
      if (strip.pieces.length > 0) {
        strips.push(strip);
        // 스트립에서 가장 큰 폭 사용
        const maxWidth = Math.max(...strip.pieces.map(p => p.width));
        currentY += maxWidth;
      } else {
        break;
      }
      
      availableParts = parts.filter(p => p.remainingQty > 0);
    }
    
    // 사용 면적 계산
    let usedArea = 0;
    placements.forEach(p => {
      usedArea += p.width * p.length;
    });
    
    const totalArea = plate.width * plate.length;
    const lossArea = totalArea - usedArea;
    const lossRate = (lossArea / totalArea * 100).toFixed(2);
    
    return {
      placements,
      strips,
      usedArea,
      lossArea,
      lossRate: parseFloat(lossRate),
      totalArea
    };
  }

  /**
   * 메인 네스팅 함수
   * @param {Array} items - 부품 목록 [{width, length, qty, baname, material}, ...]
   * @param {Array} availablePlates - 선택된 판재 목록 [{width, length, qty}, ...]
   * @returns {Object} - 네스팅 결과
   */
  function runNesting(items, availablePlates) {
    // 1. 부품 크기별 그룹핑
    const grouped = groupPartsBySize(items);
    
    // 2. 우선순위 정렬
    const sorted = sortParts(grouped);
    
    // 3. 판재별 분류
    const plateGroups = classifyPartsByPlate(sorted, availablePlates);
    
    // 4. 판재별 배치 실행
    const sheets = [];
    let sheetNo = 1;
    
    // 판재 길이 내림차순으로 처리 (큰 판재부터)
    const plateKeys = Object.keys(plateGroups).sort((a, b) => {
      const pa = plateGroups[a].plate;
      const pb = plateGroups[b].plate;
      return pb.length - pa.length;
    });
    
    for (const key of plateKeys) {
      const pg = plateGroups[key];
      const plate = pg.plate;
      let parts = pg.parts;
      
      // 해당 판재 그룹의 모든 부품이 배치될 때까지 반복
      while (parts.some(p => p.remainingQty > 0)) {
        const result = packSinglePlate(plate, parts);
        
        if (result.placements.length === 0) break;
        
        sheets.push({
          sheetNo: sheetNo++,
          plate: {
            width: plate.width,
            length: plate.length,
            spec: plate.width + '×' + plate.length
          },
          placements: result.placements,
          strips: result.strips,
          usedArea: result.usedArea,
          lossArea: result.lossArea,
          lossRate: result.lossRate,
          totalArea: result.totalArea
        });
        
        // 모든 부품이 배치됐으면 종료
        if (!parts.some(p => p.remainingQty > 0)) break;
      }
    }
    
    // 5. 통계 계산
    let totalUsedArea = 0;
    let totalLossArea = 0;
    let totalPlateArea = 0;
    
    sheets.forEach(s => {
      totalUsedArea += s.usedArea;
      totalLossArea += s.lossArea;
      totalPlateArea += s.totalArea;
    });
    
    // 판재 타입별 수량 집계
    const plateSummary = {};
    sheets.forEach(s => {
      const key = s.plate.spec;
      if (!plateSummary[key]) {
        plateSummary[key] = { count: 0, spec: s.plate.spec, width: s.plate.width, length: s.plate.length };
      }
      plateSummary[key].count++;
    });
    
    return {
      sheets,
      summary: {
        totalSheets: sheets.length,
        totalUsedArea: totalUsedArea / 1000000, // m²
        totalLossArea: totalLossArea / 1000000, // m²
        totalPlateArea: totalPlateArea / 1000000, // m²
        overallLossRate: ((totalLossArea / totalPlateArea) * 100).toFixed(2),
        plateSummary: Object.values(plateSummary)
      },
      groupedParts: grouped
    };
  }

  /**
   * 절곡수 리스트 생성 (인쇄용)
   * 폭 기준 그룹핑, 번호 매기기
   */
  function generateCuttingList(items) {
    // 폭별 그룹핑
    const widthGroups = new Map();
    
    items.forEach(item => {
      const w = item.width;
      if (!widthGroups.has(w)) {
        widthGroups.set(w, {
          width: w,
          material: item.material || '',
          lengths: new Map()
        });
      }
      const g = widthGroups.get(w);
      const len = item.length;
      if (!g.lengths.has(len)) {
        g.lengths.set(len, 0);
      }
      g.lengths.set(len, g.lengths.get(len) + item.qty);
    });
    
    // 폭 내림차순 정렬
    const sortedWidths = Array.from(widthGroups.keys()).sort((a, b) => b - a);
    
    const cuttingList = [];
    let groupNo = 1;
    
    sortedWidths.forEach(width => {
      const group = widthGroups.get(width);
      const lengths = Array.from(group.lengths.entries())
        .sort((a, b) => b[0] - a[0]); // 길이 내림차순
      
      cuttingList.push({
        no: groupNo++,
        width: width,
        material: group.material,
        items: lengths.map(([len, qty]) => ({ length: len, qty: qty }))
      });
    });
    
    // 총 수량 계산
    let totalQty = 0;
    cuttingList.forEach(g => {
      g.items.forEach(item => {
        totalQty += item.qty;
      });
    });
    
    return {
      groups: cuttingList,
      totalQty: totalQty
    };
  }

  // 공개 API
  return {
    runNesting: runNesting,
    generateCuttingList: generateCuttingList,
    groupPartsBySize: groupPartsBySize,
    sortParts: sortParts
  };

})();

// Node.js 환경 지원
if (typeof module !== 'undefined' && module.exports) {
  module.exports = NestingCalc;
}
