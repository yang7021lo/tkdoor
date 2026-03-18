import easyocr
import json
import sys
import os
from datetime import datetime

# EasyOCR 리더 초기화 (최초 1회 모델 로딩)
reader = easyocr.Reader(['ko', 'en'], gpu=False)

def run_ocr(image_path, output_path=None):
    result = reader.readtext(image_path)
    
    boxes = []
    for i, (bbox, text, conf) in enumerate(result):
        # bbox: [[x1,y1], [x2,y1], [x2,y2], [x1,y2]]
        x = int(min(p[0] for p in bbox))
        y = int(min(p[1] for p in bbox))
        w = int(max(p[0] for p in bbox) - x)
        h = int(max(p[1] for p in bbox) - y)
        
        boxes.append({
            "id": i,
            "text": text,
            "x": x, "y": y, "w": w, "h": h,
            "conf": int(conf * 100)
        })
    
    output = {
        "meta": {
            "created_at": datetime.now().isoformat(),
            "engine": "easyocr",
            "total_items": len(boxes)
        },
        "image": {
            "filename": os.path.basename(image_path),
            "filepath": os.path.abspath(image_path)
        },
        "boxes": boxes
    }
    
    if output_path is None:
        base = os.path.splitext(image_path)[0]
        output_path = f"{os.path.basename(base)}_ocr.json"
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    
    print(f"[OCR 완료] {len(boxes)}개 항목")
    print(f"[저장됨] {output_path}")
    
    for box in boxes[:10]:
        print(f"[{box['conf']}%] {box['text']}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("사용법: python ocr_easyocr.py <이미지>")
        sys.exit(1)
    run_ocr(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else None)
