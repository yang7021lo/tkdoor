import cv2
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

img = cv2.imread(r"C:\Users\user\Downloads\test_ocr1.png")

# 1. 크게 (3배)
img = cv2.resize(img, None, fx=3, fy=3, interpolation=cv2.INTER_CUBIC)

# 2. 그레이
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# 3. 샤프닝 (선명하게)
kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1,1))
gray = cv2.morphologyEx(gray, cv2.MORPH_CLOSE, kernel)

# 4. OTSU
_, th = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

# 다양한 PSM 모드 테스트
for psm in [6, 11, 12, 13]:
    config = f'--oem 3 --psm {psm} -l kor+eng'
    text = pytesseract.image_to_string(th, config=config)
    print(f"=== PSM {psm} ===")
    print(text[:300])
    print()