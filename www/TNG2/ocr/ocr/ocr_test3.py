import cv2
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

img = cv2.imread(r"C:\Users\user\Downloads\test_ocr1.png")

# 1. 무조건 키운다
img = cv2.resize(img, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)

# 2. 그레이
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# 3. 약한 블러
gray = cv2.GaussianBlur(gray, (3,3), 0)

# 4. OTSU
_, th = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

# 한글 포함 (whitelist 제거)
config = r'--oem 3 --psm 6'

text = pytesseract.image_to_string(th, lang='kor+eng', config=config)
print(text)