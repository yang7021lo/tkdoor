// 1) 문자열 비교 (locale-sensitive)
export function stringComparator(a = '', b = '') {
  return String(a).localeCompare(String(b), 'ko', { sensitivity: 'base' });
}

// 2) 정수 비교
export function integerComparator(a = 0, b = 0) {
  const na = parseInt(a, 10) || 0;
  const nb = parseInt(b, 10) || 0;
  return na - nb;
}

// 3) 부동소수점 비교
export function floatComparator(a = 0, b = 0) {
  const na = parseFloat(a) || 0;
  const nb = parseFloat(b) || 0;
  return na - nb;
}

// 4) 날짜 비교 (ISO 문자열 또는 Date 객체)
export function dateComparator(a, b) {
  const da = a ? new Date(a) : null;
  const db = b ? new Date(b) : null;
  if (!da && !db) return 0;
  if (!da) return 1;
  if (!db) return -1;
  return da - db;
}

// 5) 알파뉴메릭 (문+숫자) 비교
export function alphanumericComparator(a = '', b = '') {
  const re = /(\D*)(\d+)(.*)/;
  const ma = String(a).match(re) || ['', String(a), '0', ''];
  const mb = String(b).match(re) || ['', String(b), '0', ''];
  const [ , pa, na, sa ] = ma;
  const [ , pb, nb, sb ] = mb;
  if (pa !== pb) return pa.localeCompare(pb, 'ko', {sensitivity:'base'});
  if (+na !== +nb) return +na - +nb;
  return sa.localeCompare(sb, 'ko', {sensitivity:'base'});
}

// 6) 상태(Enum) 비교 (순서를 정의해서)
export function enumComparator(orderMap) {
  return (a, b) => {
    const ia = orderMap[a] ?? Number.MAX_SAFE_INTEGER;
    const ib = orderMap[b] ?? Number.MAX_SAFE_INTEGER;
    return ia - ib;
  };
}

// 7) Boolean 비교 (false < true)
export function booleanComparator(a = false, b = false) {
  return (a === b) ? 0 : (a ? 1 : -1);
}