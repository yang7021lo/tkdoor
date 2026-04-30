# 강화도어 알림톡 템플릿 5종

> 솔라피에서 카카오 알림톡 템플릿 등록 시 아래 내용을 그대로 사용하세요.
> `#{변수}` 부분은 솔라피 변수 문법에 맞게 치환됩니다.

---

## 1. 수주확인

**템플릿 코드:** `GD_ORDER_CONFIRM`

```
[지니즈 강화도어비서]
#{org_name}에서 알려드립니다.

■ 수주가 확인되었습니다.

- 수주번호: #{order_no}
- 제품명: #{product_name}
- 수량: #{quantity}
- 납품 예정일: #{delivery_date}
- 현장명: #{site_name}

문의사항은 #{org_name} (#{org_phone})으로 연락 부탁드립니다.
```

**카테고리:** 거래/업무
**버튼:** 없음

---

## 2. 납기알림

**템플릿 코드:** `GD_DELIVERY_REMIND`

```
[지니즈 강화도어비서]
#{org_name}에서 알려드립니다.

■ 납품 예정일 안내

- 수주번호: #{order_no}
- 제품명: #{product_name}
- 납품 예정일: #{delivery_date} (D-#{d_day})
- 납품 장소: #{site_address}

현장 수령 준비를 부탁드립니다.
일정 변경 시 #{org_name} (#{org_phone})으로 연락주세요.
```

**카테고리:** 거래/업무
**버튼:** 없음

---

## 3. 출하완료

**템플릿 코드:** `GD_SHIPMENT_DONE`

```
[지니즈 강화도어비서]
#{org_name}에서 알려드립니다.

■ 출하가 완료되었습니다.

- 수주번호: #{order_no}
- 제품명: #{product_name}
- 수량: #{quantity}
- 출하일시: #{shipment_datetime}
- 도착 예정: #{arrival_estimate}
- 배송 차량: #{vehicle_info}

수령 확인 후 이상이 있으시면 #{org_name} (#{org_phone})으로 연락주세요.
```

**카테고리:** 거래/업무
**버튼:** 없음

---

## 4. 견적발송

**템플릿 코드:** `GD_QUOTE_SEND`

```
[지니즈 강화도어비서]
#{org_name}에서 알려드립니다.

■ 견적서가 발송되었습니다.

- 견적번호: #{quote_no}
- 현장명: #{site_name}
- 제품 구성: #{product_summary}
- 견적 금액: #{total_amount}원 (부가세 별도)
- 견적 유효기간: #{valid_until}

상세 견적서는 아래 링크에서 확인하세요.
#{quote_link}

문의: #{org_name} (#{org_phone})
```

**카테고리:** 거래/업무
**버튼:** 웹 링크 — "견적서 보기" → `#{quote_link}`

---

## 5. 미수알림

**템플릿 코드:** `GD_PAYMENT_REMIND`

```
[지니즈 강화도어비서]
#{org_name}에서 알려드립니다.

■ 미수금 안내

- 거래처명: #{contact_name}
- 미수 금액: #{outstanding_amount}원
- 최종 거래일: #{last_transaction_date}
- 미수 기간: #{overdue_days}일 경과

입금 확인 후 자동 반영됩니다.
문의: #{org_name} (#{org_phone})
```

**카테고리:** 거래/업무
**버튼:** 없음

---

## 변수 매핑 (ERP → 솔라피)

| 변수명 | 출처 | 설명 |
|--------|------|------|
| `#{org_name}` | organizations.org_name | 조직명 (원일강화도어) |
| `#{org_phone}` | organizations.phone | 조직 대표번호 |
| `#{order_no}` | orders.order_no | 수주번호 |
| `#{product_name}` | order_items.product_name | 제품명 |
| `#{quantity}` | order_items.quantity | 수량 |
| `#{delivery_date}` | orders.delivery_date | 납품 예정일 |
| `#{site_name}` | orders.site_name | 현장명 |
| `#{site_address}` | orders.site_address | 납품 주소 |
| `#{d_day}` | 계산값 | 납품까지 남은 일수 |
| `#{shipment_datetime}` | shipments.shipped_at | 출하 일시 |
| `#{arrival_estimate}` | shipments.eta | 도착 예정 |
| `#{vehicle_info}` | shipments.vehicle | 배송 차량 정보 |
| `#{quote_no}` | quotes.quote_no | 견적번호 |
| `#{product_summary}` | 계산값 | 제품 요약 (방화도어 GD-900 x 3 외 2건) |
| `#{total_amount}` | quotes.total_amount | 견적 금액 |
| `#{valid_until}` | quotes.valid_until | 견적 유효기간 |
| `#{quote_link}` | 생성값 | 견적서 웹 링크 |
| `#{contact_name}` | contacts.contact_name | 거래처명 |
| `#{outstanding_amount}` | 계산값 | 미수 금액 합계 |
| `#{last_transaction_date}` | 계산값 | 최종 거래일 |
| `#{overdue_days}` | 계산값 | 미수 경과 일수 |

---

## 솔라피 등록 시 참고

1. 솔라피 대시보드 → 카카오톡 → 알림톡 템플릿 → 새 템플릿
2. 카테고리: **거래/업무** 선택
3. 템플릿 내용 붙여넣기 (변수는 `#{변수명}` 형식 유지)
4. 검수 요청 → 카카오 심사 1~2영업일
5. 승인 후 API 발송 가능
