import cv2
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

image_path = r'C:\Users\user\Downloads\test_ocr1.png'

# 이미지 로드
img = cv2.imread(image_path)

# 그레이스케일
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# 방법 1: 단순 이진화
_, binary1 = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY)

# 방법 2: OTSU
_, binary2 = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

# 방법 3: Adaptive
binary3 = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)

# 방법 4: 반전 + OTSU (손글씨에 효과적)
inverted = cv2.bitwise_not(gray)
_, binary4 = cv2.threshold(inverted, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
binary4 = cv2.bitwise_not(binary4)

# 각각 테스트
print("=== 원본 ===")
print(pytesseract.image_to_string(gray, lang='kor+eng')[:500])

print("\n=== 단순 이진화 ===")
print(pytesseract.image_to_string(binary1, lang='kor+eng')[:500])

print("\n=== OTSU ===")
print(pytesseract.image_to_string(binary2, lang='kor+eng')[:500])

print("\n=== Adaptive ===")
print(pytesseract.image_to_string(binary3, lang='kor+eng')[:500])

print("\n=== 반전+OTSU ===")
print(pytesseract.image_to_string(binary4, lang='kor+eng')[:500])