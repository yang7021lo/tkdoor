"""
OCR 엔진 모듈
- Tesseract OCR 실행
- 텍스트 + 좌표(bounding box) 추출
- JSON 파일로 저장
"""

import pytesseract
from pytesseract import Output
import json
import os
import sys
from datetime import datetime
from preprocess import preprocess_for_ocr, load_image

# Tesseract 경로 설정 (Windows)
pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'


def extract_text_with_boxes(image, lang='kor+eng', config=''):
    """
    이미지에서 텍스트와 좌표 추출
    
    Returns:
        list of dict: [
            {
                "text": "추출된 텍스트",
                "x": 좌상단 x,
                "y": 좌상단 y,
                "w": 너비,
                "h": 높이,
                "conf": 신뢰도 (0-100)
            }
        ]
    """
    # Tesseract 데이터 추출
    data = pytesseract.image_to_data(image, lang=lang, config=config, output_type=Output.DICT)
    
    results = []
    n_boxes = len(data['text'])
    
    for i in range(n_boxes):
        text = data['text'][i].strip()
        conf = int(data['conf'][i])
        
        # 빈 텍스트, 낮은 신뢰도 제외
        if text and conf > 30:
            results.append({
                "id": len(results),
                "text": text,
                "x": data['left'][i],
                "y": data['top'][i],
                "w": data['width'][i],
                "h": data['height'][i],
                "conf": conf,
                "level": data['level'][i],  # 1=page, 2=block, 3=paragraph, 4=line, 5=word
                "block_num": data['block_num'][i],
                "line_num": data['line_num'][i],
                "word_num": data['word_num'][i]
            })
    
    return results


def get_image_info(image_path, original_img):
    """이미지 메타 정보"""
    h, w = original_img.shape[:2]
    return {
        "filename": os.path.basename(image_path),
        "filepath": os.path.abspath(image_path),
        "width": w,
        "height": h
    }


def run_ocr(image_path, output_json_path=None, lang='kor+eng'):
    """
    OCR 메인 실행 함수
    
    Args:
        image_path: 입력 이미지 경로
        output_json_path: 결과 JSON 저장 경로 (None이면 자동 생성)
        lang: Tesseract 언어 (kor+eng 기본)
    
    Returns:
        dict: OCR 결과 전체
    """
    # 수정 - 전처리 없이 원본 사용
    processed_img, original_img = preprocess_for_ocr(image_path)
    boxes = extract_text_with_boxes(original_img, lang=lang)  # processed_img → original_img
    
    # 결과 구조화
    result = {
        "meta": {
            "created_at": datetime.now().isoformat(),
            "tesseract_lang": lang,
            "total_items": len(boxes)
        },
        "image": get_image_info(image_path, original_img),
        "boxes": boxes
    }
    
    # JSON 저장
    if output_json_path is None:
        base_name = os.path.splitext(os.path.basename(image_path))[0]
        output_json_path = f"{base_name}_ocr.json"
    
    with open(output_json_path, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)
    
    print(f"[OCR 완료] {len(boxes)}개 항목 추출")
    print(f"[저장됨] {output_json_path}")
    
    return result


def filter_boxes_by_region(boxes, x1, y1, x2, y2):
    """
    특정 영역(드래그 범위)에 포함된 box만 필터링
    
    Args:
        boxes: OCR 결과 box 리스트
        x1, y1: 드래그 시작점
        x2, y2: 드래그 끝점
    
    Returns:
        list: 영역 내 box들
    """
    # 좌표 정규화 (드래그 방향 무관)
    min_x = min(x1, x2)
    max_x = max(x1, x2)
    min_y = min(y1, y2)
    max_y = max(y1, y2)
    
    filtered = []
    for box in boxes:
        # box 중심점 계산
        box_cx = box['x'] + box['w'] / 2
        box_cy = box['y'] + box['h'] / 2
        
        # 중심점이 드래그 영역 안에 있는지 확인
        if min_x <= box_cx <= max_x and min_y <= box_cy <= max_y:
            filtered.append(box)
    
    return filtered


def boxes_to_text(boxes, sort_by_position=True):
    """
    box 리스트를 텍스트로 조합
    
    Args:
        boxes: box 리스트
        sort_by_position: True면 위치순 정렬 (위→아래, 왼쪽→오른쪽)
    
    Returns:
        str: 조합된 텍스트
    """
    if not boxes:
        return ""
    
    if sort_by_position:
        # y좌표 우선, 같은 줄이면 x좌표로 정렬
        # 같은 줄 기준: y좌표 차이가 평균 높이의 50% 이내
        avg_height = sum(b['h'] for b in boxes) / len(boxes)
        threshold = avg_height * 0.5
        
        sorted_boxes = sorted(boxes, key=lambda b: (b['y'] // int(threshold + 1), b['x']))
    else:
        sorted_boxes = boxes
    
    return ' '.join(b['text'] for b in sorted_boxes)


# CLI 실행
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("사용법: python ocr_engine.py <이미지 경로> [출력 JSON 경로]")
        print("예시: python ocr_engine.py sample.png result.json")
        sys.exit(1)
    
    image_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else None
    
    result = run_ocr(image_path, output_path)
    
    # 추출된 텍스트 미리보기
    print("\n--- 추출된 텍스트 ---")
    for box in result['boxes'][:10]:  # 처음 10개만
        print(f"[{box['conf']}%] {box['text']}")
    if len(result['boxes']) > 10:
        print(f"... 외 {len(result['boxes']) - 10}개")
