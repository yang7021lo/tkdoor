// 컬럼 타입에 맞는 Comparator를 반환하는 팩토리

import {
  stringComparator,
  integerComparator,
  floatComparator,
  dateComparator,
  alphanumericComparator,
  enumComparator,
  booleanComparator
} from '/orders/module/comparator/comparator.js';

export function getComparator(type, options = {}) {
  switch (type) {
    case 'string':       return stringComparator;
    case 'integer':      return integerComparator;
    case 'float':        return floatComparator;
    case 'date':         return dateComparator;
    case 'alphanumeric': return alphanumericComparator;
    case 'enum':         return enumComparator(options.orderMap || {});
    case 'boolean':      return booleanComparator;
    default:
      console.warn(`Unknown comparator type: ${type}, falling back to string.`);
      return stringComparator;
  }
}