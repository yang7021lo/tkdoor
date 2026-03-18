
import { getComparator } from '/orders/module/comparator/comparatorFactory.js';

/**
 * @param {Array<Object>} data         원본 데이터 배열
 * @param {string}          key        정렬 대상 컬럼 키
 * @param {'asc'|'desc'}    direction  정렬 방향
 * @param {Object}          meta       { type: 'string'|'integer'|..., options: {...} }
 * @returns {Array<Object>}            정렬된 새 배열
 */
export function sortData(data, key, direction = 'asc', meta = { type: 'string' }) {
  const cmp = getComparator(meta.type, meta.options);
  const sorted = data.slice().sort((a, b) => {
    const res = cmp(a[key], b[key]);
    return direction === 'asc' ? res : -res;
  });
  return sorted;
}