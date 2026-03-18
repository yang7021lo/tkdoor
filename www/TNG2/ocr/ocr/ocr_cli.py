"""
OCR CLI 래퍼
- ASP에서 WScript.Shell로 호출
- 단순 입력 → JSON 출력 구조
"""

import sys
import os
import json
import argparse

# 같은 폴더의 모듈 import
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ocr_engine import run_ocr, filter_boxes_by_region, boxes_to_text


def main():
    parser = argparse.ArgumentParser(description='OCR CLI for ASP integration')
    parser.add_argument('image', help='입력 이미지 경로')
    parser.add_argument('-o', '--output', help='출력 JSON 경로')
    parser.add_argument('-l', '--lang', default='kor+eng', help='Tesseract 언어 (기본: kor+eng)')
    parser.add_argument('--filter', nargs=4, type=int, metavar=('X1', 'Y1', 'X2', 'Y2'),
                        help='영역 필터 (x1 y1 x2 y2)')
    
    args = parser.parse_args()
    
    # 이미지 존재 확인
    if not os.path.exists(args.image):
        print(json.dumps({"error": f"파일 없음: {args.image}"}, ensure_ascii=False))
        sys.exit(1)
    
    try:
        # OCR 실행
        result = run_ocr(args.image, args.output, args.lang)
        
        # 영역 필터 적용
        if args.filter:
            x1, y1, x2, y2 = args.filter
            filtered = filter_boxes_by_region(result['boxes'], x1, y1, x2, y2)
            text = boxes_to_text(filtered)
            
            print(json.dumps({
                "success": True,
                "filtered_count": len(filtered),
                "text": text,
                "boxes": filtered
            }, ensure_ascii=False))
        else:
            print(json.dumps({
                "success": True,
                "output_file": args.output or f"{os.path.splitext(args.image)[0]}_ocr.json"
            }, ensure_ascii=False))
            
    except Exception as e:
        print(json.dumps({"error": str(e)}, ensure_ascii=False))
        sys.exit(1)


if __name__ == "__main__":
    main()
