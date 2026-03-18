"""
OCR 전처리 모듈
- 이미지 이진화
- 노이즈 제거
- 기울기 보정 (옵션)
"""

import cv2
import numpy as np


def load_image(image_path):
    """이미지 로드"""
    img = cv2.imread(image_path)
    if img is None:
        raise FileNotFoundError(f"이미지를 찾을 수 없습니다: {image_path}")
    return img


def to_grayscale(img):
    """그레이스케일 변환"""
    if len(img.shape) == 3:
        return cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    return img


def remove_noise(img, kernel_size=3):
    """노이즈 제거 (미디안 블러)"""
    return cv2.medianBlur(img, kernel_size)


def binarize(img, method='adaptive'):
    """
    이진화 처리
    method: 'adaptive' | 'otsu' | 'simple'
    """
    if method == 'adaptive':
        return cv2.adaptiveThreshold(
            img, 255, 
            cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
            cv2.THRESH_BINARY, 11, 2
        )
    elif method == 'otsu':
        _, binary = cv2.threshold(img, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        return binary
    else:
        _, binary = cv2.threshold(img, 127, 255, cv2.THRESH_BINARY)
        return binary


def deskew(img):
    """기울기 보정 (선택적)"""
    coords = np.column_stack(np.where(img > 0))
    if len(coords) == 0:
        return img
    
    angle = cv2.minAreaRect(coords)[-1]
    
    if angle < -45:
        angle = -(90 + angle)
    else:
        angle = -angle
    
    # 너무 큰 각도면 보정 안함
    if abs(angle) > 10:
        return img
    
    h, w = img.shape[:2]
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    rotated = cv2.warpAffine(img, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)
    
    return rotated


def enhance_contrast(img):
    """대비 강화 (CLAHE)"""
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
    return clahe.apply(img)


def preprocess_for_ocr(image_path, enhance=True, denoise=True, use_deskew=False):
    """
    OCR용 전처리 파이프라인
    
    Returns:
        - processed_img: 전처리된 이미지 (numpy array)
        - original_img: 원본 이미지 (화면 표시용)
    """
    # 원본 로드
    original = load_image(image_path)
    
    # 그레이스케일
    gray = to_grayscale(original)
    
    # 대비 강화
    if enhance:
        gray = enhance_contrast(gray)
    
    # 노이즈 제거
    if denoise:
        gray = remove_noise(gray)
    
    # 이진화 (Adaptive가 일반적으로 더 좋음)
    binary = binarize(gray, method='adaptive')
    
    # 기울기 보정 (선택적 - 스캔 문서에 유용)
    if use_deskew:
        binary = deskew(binary)
    
    return binary, original


if __name__ == "__main__":
    # 테스트
    import sys
    if len(sys.argv) > 1:
        processed, original = preprocess_for_ocr(sys.argv[1])
        cv2.imwrite("preprocessed_test.png", processed)
        print("전처리 완료: preprocessed_test.png")
