/* ================================
   네스팅 계산 엔진
   /tng2/nesting/nesting_calc.js
   
   - 1D Strip Packing 알고리즘
   - 폭(width) 기준 스트립 배치
   - 길이(length) 방향으로 피스 배치
================================ */

var NestingCalc = (function() {
  'use strict';

  /**
   * 아이템 확장 (수량만큼 개별 객체로)
   * @param {Array} items - [{width, length, qty, baname, material}, ...]
   * @returns {Array} - 개별 피스 배열
   */
  function expandItems(items) {
    const out = [];
    
    items.forEach(function(it) {
      const qty = Number(it.qty || 0);
      for (let i = 0; i < qty; i++) {
        out.push({
          w: Number(it.width),
          len: Number(it.length),
          name: it.baname || "",
          material: it.material || ""
        });
      }
    });
    
    // 폭 내림차순, 길이 내림차순 정렬
    out.sort(function(a, b) {
      return (b.w - a.w) || (b.len - a.len);
    });
    
    return out;
  }

  /**
   * 시트 빌드 (1D Strip Packing)
   * @param {Array} items - 확장된 피스 배열
   * @param {number} sheetW - 시트 길이 방향 (가로)
   * @param {number} sheetH - 시트 폭 방향 (세로)
   * @returns {Array} - 시트 배열
   */
  function buildSheets(items, sheetW, sheetH) {
    const sheets = [];
    let sheet = { strips: [], usedW: 0, items: [] };
    sheets.push(sheet);

    // 폭별로 그룹핑
    const map = new Map();
    items.forEach(function(it) {
      if (!map.has(it.w)) map.set(it.w, []);
      map.get(it.w).push(it);
    });

    // 폭 내림차순으로 처리
    var widths = Array.from(map.keys()).sort(function(a, b) { return b - a; });
    
    widths.forEach(function(w) {
      const arr = map.get(w);

      while (arr.length > 0) {
        // 현재 시트에 공간이 없으면 새 시트
        if (sheet.usedW + w > sheetH) {
          sheet = { strips: [], usedW: 0, items: [] };
          sheets.push(sheet);
        }

        // 새 스트립 생성
        const strip = { stripW: w, pieces: [], usedLen: 0 };

        // 스트립에 피스 배치 (길이 방향)
        while (arr.length > 0 && strip.usedLen + arr[0].len <= sheetW) {
          const piece = arr.shift();
          strip.pieces.push(piece);
          strip.usedLen += piece.len;
          sheet.items.push(piece);
        }

        sheet.strips.push(strip);
        sheet.usedW += w;

        // 안전장치: 피스가 시트보다 큰 경우
        if (strip.pieces.length === 0 && arr.length > 0) {
          arr.shift();
        }
      }
    });

    // 통계 계산
    sheets.forEach(function(s, idx) {
      s.sheetNo = idx + 1;
      
      // 사용 면적
      let usedArea = 0;
      s.strips.forEach(function(st) {
        st.pieces.forEach(function(p) {
          usedArea += p.w * p.len;
        });
      });
      
      const totalArea = sheetW * sheetH;
      s.usedArea = usedArea;
      s.totalArea = totalArea;
      s.lossRate = ((totalArea - usedArea) / totalArea * 100).toFixed(2);
    });

    return sheets;
  }

  /**
   * 재질별 그룹핑
   * @param {Array} items - 원본 아이템 배열
   * @returns {Array} - 재질 목록
   */
  function getMaterialList(items) {
    const set = new Set();
    items.forEach(function(it) {
      if (it.material) set.add(it.material);
    });
    return Array.from(set);
  }

  /**
   * 재질별 필터링
   * @param {Array} items - 원본 아이템 배열
   * @param {string} material - 재질명
   * @returns {Array} - 필터링된 아이템
   */
  function filterByMaterial(items, material) {
    if (!material) return items;
    return items.filter(function(it) {
      return it.material === material;
    });
  }

  /**
   * 폭별 필터링
   * @param {Array} items - 원본 아이템 배열
   * @param {number} width - 폭
   * @returns {Array} - 필터링된 아이템
   */
  function filterByWidth(items, width) {
    return items.filter(function(it) {
      return Number(it.width) === Number(width);
    });
  }

  /**
   * 시트 규격 파싱
   * @param {string} value - "1219x4000" 형식
   * @returns {Object} - {sheetW, sheetH, label}
   */
  function parseSheet(value) {
    const parts = (value || "1219x4000").split("x");
    const w = Number(parts[0]) || 1219;
    const h = Number(parts[1]) || 4000;
    return {
      sheetW: h,  // 길이 방향
      sheetH: w,  // 폭 방향
      label: w + "×" + h
    };
  }

  /**
   * 폭별 그룹 통계
   * @param {Array} items - 원본 아이템 배열
   * @returns {Array} - [{width, count, lengths}, ...]
   */
  function getWidthStats(items) {
    const map = new Map();
    
    items.forEach(function(it) {
      const w = Number(it.width);
      if (!map.has(w)) {
        map.set(w, { width: w, count: 0, totalQty: 0, lengths: new Set() });
      }
      const stat = map.get(w);
      stat.count++;
      stat.totalQty += Number(it.qty || 0);
      stat.lengths.add(Number(it.length));
    });

    return Array.from(map.values()).sort(function(a, b) {
      return b.width - a.width;
    });
  }

  // 공개 API
  return {
    expandItems: expandItems,
    buildSheets: buildSheets,
    getMaterialList: getMaterialList,
    filterByMaterial: filterByMaterial,
    filterByWidth: filterByWidth,
    parseSheet: parseSheet,
    getWidthStats: getWidthStats
  };

})();
