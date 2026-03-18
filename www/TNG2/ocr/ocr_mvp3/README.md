# OCR 검측 입력 시스템

## 구조

```
ocr_final/
├── python/
│   ├── ocr_gui.py      ← Python GUI (이미지 선택 + OCR + 업로드)
│   └── build.bat       ← exe 빌드 스크립트
│
└── asp/
    ├── upload_ocr.asp  ← 업로드 API
    ├── ocr_view.asp    ← 뷰어 (클릭 → 인풋)
    ├── css/
    │   └── ocr.css
    ├── js/
    │   └── ocr.js
    └── results/        ← JSON 저장 폴더
```

## 설치 (팀원 PC)

```bash
pip install easyocr opencv-python requests pyinstaller
```

## exe 빌드

```bash
cd python
build.bat
```

→ `dist/OCR_Upload.exe` 생성

## 사용법

### 1. exe 실행
- `OCR_Upload.exe` 실행
- 이미지 선택 (여러 개 가능)
- "OCR + 업로드" 버튼 클릭
- 자동으로 서버에 업로드됨

### 2. 웹 뷰어
```
http://tkd001.cafe24.com/TNG2/ocr/asp/ocr_view.asp?file=파일명.png
```

### 3. 입력 방법
- 이미지에서 숫자 클릭
- 가로 → 세로 → 수량 순서로 입력됨
- "확정" 버튼 클릭
- 다음 라인으로 이동

### 단축키
- Enter: 확정
- Tab: 건너뛰기
- Esc: 초기화

## 서버 배포

asp 폴더를 카페24에 업로드:
```
/TNG2/ocr/asp/
```

이미지 저장 경로:
```
/img/door/
```

## 추후 작업

MES 연동 시 `ocr.js`의 `nextLine()` 함수에서:
```javascript
// TODO: 추후 MES 연동 시 여기서 서버로 전송
// sendToMES(state.results);
```
이 부분에 DB 저장 로직 추가
