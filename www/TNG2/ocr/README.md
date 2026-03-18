# OCR MVP 환경 설정 가이드

## 1. 필수 설치

### Windows 서버 (카페24 등)

```bash
# 1. Tesseract OCR 설치
# 다운로드: https://github.com/UB-Mannheim/tesseract/wiki
# 설치 경로: C:\Program Files\Tesseract-OCR

# 2. 환경 변수 추가
# PATH에 추가: C:\Program Files\Tesseract-OCR

# 3. 한국어 데이터 설치
# tessdata 폴더에 kor.traineddata 다운로드
# https://github.com/tesseract-ocr/tessdata/blob/main/kor.traineddata
```

### Python 패키지

```bash
pip install pytesseract opencv-python numpy
```

### pytesseract 설정 (Windows)

```python
# ocr_engine.py 상단에 추가 (Windows 환경)
import pytesseract
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
```

---

## 2. 폴더 구조

```
/ocr_mvp/
├── ocr/                      # Python OCR 모듈
│   ├── preprocess.py         # 이미지 전처리
│   ├── ocr_engine.py         # OCR 핵심 엔진
│   └── ocr_cli.py            # CLI 래퍼 (ASP 연동용)
│
├── asp/                      # ASP 웹 인터페이스
│   ├── ocr_upload.asp        # 업로드 페이지
│   ├── ocr_view.asp          # 뷰어 (드래그 선택)
│   ├── ocr_api.asp           # API (Python 실행)
│   ├── uploads/              # 업로드 이미지 저장
│   └── ocr_results/          # OCR 결과 JSON 저장
│
└── README.md
```

---

## 3. ASP 서버 설정

### IIS에서 Python 실행 권한

```
1. IIS 관리자 열기
2. 사이트 선택 → 처리기 매핑
3. WScript.Shell 실행 권한 확인
4. 애플리케이션 풀 계정에 Python 실행 권한 부여
```

### 카페24 환경 제약

```
⚠️ 카페24 공유 호스팅에서는 WScript.Shell 실행이 제한될 수 있음

대안 1: 별도 Python 서버 (Flask/FastAPI)
대안 2: 로컬에서 OCR → JSON 업로드
대안 3: 클라이언트 사이드 OCR (Tesseract.js)
```

---

## 4. 사용 방법

### Python 직접 실행

```bash
# 기본 OCR
python ocr/ocr_cli.py sample.png

# 출력 경로 지정
python ocr/ocr_cli.py sample.png -o result.json

# 영역 필터링 (x1 y1 x2 y2)
python ocr/ocr_cli.py sample.png --filter 50 50 300 200
```

### ASP 웹 인터페이스

```
1. ocr_upload.asp 접속
2. 이미지 업로드
3. OCR 실행 버튼 클릭
4. ocr_view.asp에서 결과 확인
5. 드래그로 영역 선택 → 텍스트 추출
```

---

## 5. JSON 결과 구조

```json
{
  "meta": {
    "created_at": "2025-02-02T10:30:00",
    "tesseract_lang": "kor+eng",
    "total_items": 15
  },
  "image": {
    "filename": "sample.png",
    "width": 800,
    "height": 600
  },
  "boxes": [
    {
      "id": 0,
      "text": "추출된 텍스트",
      "x": 50,      // 좌상단 X
      "y": 30,      // 좌상단 Y
      "w": 80,      // 너비
      "h": 25,      // 높이
      "conf": 95,   // 신뢰도 (0-100)
      "level": 5,   // 1=page, 5=word
      "block_num": 1,
      "line_num": 1,
      "word_num": 1
    }
  ]
}
```

---

## 6. 드래그 → 텍스트 추출 로직

```javascript
// 1. 드래그 좌표 (화면 기준)
const dragX1 = 100, dragY1 = 50;
const dragX2 = 400, dragY2 = 200;

// 2. 원본 이미지 좌표로 변환
const scaleX = imageOriginalWidth / imageDisplayWidth;
const scaleY = imageOriginalHeight / imageDisplayHeight;

const realX1 = dragX1 * scaleX;
const realX2 = dragX2 * scaleX;
// ...

// 3. 박스 중심이 영역 안에 있는지 확인
boxes.filter(box => {
    const cx = box.x + box.w / 2;
    const cy = box.y + box.h / 2;
    return cx >= realX1 && cx <= realX2 && cy >= realY1 && cy <= realY2;
});

// 4. 위치순 정렬 후 텍스트 조합
filteredBoxes.sort((a, b) => {
    if (Math.abs(a.y - b.y) < avgHeight * 0.5) return a.x - b.x;
    return a.y - b.y;
}).map(b => b.text).join(' ');
```

---

## 7. 확장 로드맵

### Phase 2: Flask API 서버

```python
# flask_ocr_server.py
from flask import Flask, request, jsonify
from ocr_engine import run_ocr

app = Flask(__name__)

@app.route('/ocr', methods=['POST'])
def process_ocr():
    file = request.files['image']
    # ... OCR 처리
    return jsonify(result)
```

### Phase 3: Django + React

```
- Django REST Framework 백엔드
- React 프론트엔드
- 실시간 OCR 처리
- 사용자별 히스토리
```

---

## 8. Tesseract.js (클라이언트 사이드 대안)

서버 Python 실행이 불가할 경우:

```html
<script src="https://cdn.jsdelivr.net/npm/tesseract.js@4/dist/tesseract.min.js"></script>
<script>
Tesseract.recognize(imageFile, 'kor+eng', {
    logger: m => console.log(m)
}).then(({ data: { words } }) => {
    // words에 텍스트 + 좌표 포함
});
</script>
```

⚠️ 클라이언트 사이드는 처리 속도가 느리고 한글 정확도가 떨어질 수 있음

---

## 문의사항

이 MVP는 "동작 구조 확인"이 목적입니다.
실제 프로덕션 적용 시 추가 최적화 필요.
