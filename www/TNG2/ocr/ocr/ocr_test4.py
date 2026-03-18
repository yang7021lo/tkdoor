import cv2
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

img = cv2.imread(r"C:\Users\user\Downloads\test_ocr1.png")

# 1. 크게
img = cv2.resize(img, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)

# 2. 그레이
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# 3. 블러 약하게
gray = cv2.GaussianBlur(gray, (3,3), 0)

# 4. OTSU (adaptive X)
_, th = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

config = r'--oem 3 --psm 6 -l kor+eng'

text = pytesseract.image_to_string(th, config=config)
print(text)