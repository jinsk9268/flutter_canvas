# CANVAS

- 당신을 위한 커스텀 쥬얼리 [CANVAS](https://canvasrings.com/) 의
- 예상 발송일 페이지, 수리 신청 페이지를 구현했습니다

---

## 예상 발송일 페이지

- 주문번호 19자리 입력시 예상 발송일 조회기능 구현

### Methods

- getSendWeekday
  - 주문번호 요일 return
- getSendDate
  - 정해진 양식의 날짜 return
- productSendDate
  - 주문번호 입력 시 예상 발송일 계산하여 return

---

## 수리 신청 페이지

- 유의사항 동의, 수리 신청 내용 선택 (중복 선택 가능) 체크박스 기능 구현
- 다른 제품 선택 기능 (mock data로 선택)
- 유의사항 동의, 수리 신청 내용 1개 이상이 체크 되어야 수리 신청이 가능하도록 구현

### Methods

- repairRequestCheck
  - 유의 사항 동의, 수리 신청 내용 중 하나라도 선택해야 수리 신청 가능
  - 위의 조건에 맞지 않을시 alert dialog return
  - 수리 신청 내용 최종 데이터 저장
