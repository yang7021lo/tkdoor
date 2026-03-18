"""
Flask OCR API 서버
- 카페24 등 Shell 실행 제한 환경용
- 별도 Python 서버로 운영
- ASP에서 HTTP 호출
"""

from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os
import sys
import uuid
from datetime import datetime

# 같은 폴더의 OCR 모듈
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ocr.ocr_engine import run_ocr, filter_boxes_by_region, boxes_to_text

app = Flask(__name__)
CORS(app)  # CORS 허용 (ASP 도메인에서 호출)

# 설정
UPLOAD_FOLDER = './uploads'
RESULT_FOLDER = './ocr_results'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'bmp', 'tiff', 'gif'}

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(RESULT_FOLDER, exist_ok=True)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/')
def index():
    return jsonify({
        "service": "OCR API",
        "version": "1.0.0",
        "endpoints": {
            "POST /ocr": "이미지 업로드 + OCR 실행",
            "GET /result/<filename>": "OCR 결과 JSON 조회",
            "POST /filter": "영역 필터링"
        }
    })


@app.route('/ocr', methods=['POST'])
def process_ocr():
    """
    이미지 업로드 → OCR 실행 → JSON 반환
    
    Request:
        - multipart/form-data
        - file: 이미지 파일
        - lang: 언어 (기본 kor+eng)
    
    Response:
        - success: bool
        - result_file: JSON 파일명
        - boxes: OCR 결과 배열
    """
    # 파일 검증
    if 'file' not in request.files:
        return jsonify({"error": "파일이 없습니다"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "파일명이 없습니다"}), 400
    
    if not allowed_file(file.filename):
        return jsonify({"error": "지원하지 않는 파일 형식"}), 400
    
    # 파일 저장
    ext = file.filename.rsplit('.', 1)[1].lower()
    unique_name = f"{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}.{ext}"
    image_path = os.path.join(UPLOAD_FOLDER, unique_name)
    file.save(image_path)
    
    # OCR 실행
    try:
        lang = request.form.get('lang', 'kor+eng')
        json_filename = unique_name.rsplit('.', 1)[0] + '_ocr.json'
        json_path = os.path.join(RESULT_FOLDER, json_filename)
        
        result = run_ocr(image_path, json_path, lang)
        
        return jsonify({
            "success": True,
            "image_file": unique_name,
            "result_file": json_filename,
            "total_boxes": len(result['boxes']),
            "boxes": result['boxes']
        })
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/result/<filename>')
def get_result(filename):
    """OCR 결과 JSON 반환"""
    json_path = os.path.join(RESULT_FOLDER, filename)
    
    if not os.path.exists(json_path):
        return jsonify({"error": "결과 파일 없음"}), 404
    
    return send_from_directory(RESULT_FOLDER, filename)


@app.route('/filter', methods=['POST'])
def filter_region():
    """
    영역 필터링
    
    Request (JSON):
        - boxes: OCR 박스 배열
        - region: { x1, y1, x2, y2 }
    
    Response:
        - filtered_boxes: 영역 내 박스
        - text: 조합된 텍스트
    """
    data = request.json
    
    if not data or 'boxes' not in data or 'region' not in data:
        return jsonify({"error": "boxes와 region 필요"}), 400
    
    boxes = data['boxes']
    region = data['region']
    
    filtered = filter_boxes_by_region(
        boxes, 
        region['x1'], region['y1'], 
        region['x2'], region['y2']
    )
    
    text = boxes_to_text(filtered)
    
    return jsonify({
        "filtered_count": len(filtered),
        "filtered_boxes": filtered,
        "text": text
    })


@app.route('/uploads/<filename>')
def serve_image(filename):
    """업로드된 이미지 서빙"""
    return send_from_directory(UPLOAD_FOLDER, filename)


if __name__ == '__main__':
    print("=" * 50)
    print("OCR API 서버 시작")
    print("=" * 50)
    print(f"업로드 폴더: {os.path.abspath(UPLOAD_FOLDER)}")
    print(f"결과 폴더: {os.path.abspath(RESULT_FOLDER)}")
    print("=" * 50)
    
    # 개발 서버 (프로덕션에서는 gunicorn 사용)
    app.run(host='0.0.0.0', port=5000, debug=True)
