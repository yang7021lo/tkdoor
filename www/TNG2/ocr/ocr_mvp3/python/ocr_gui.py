"""
OCR GUI 프로그램
- 이미지 선택
- EasyOCR 실행
- 카페24 서버에 업로드
"""
import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import easyocr
import cv2
import json
import os
import subprocess
import requests
import webbrowser
from datetime import datetime
from threading import Thread
from urllib.parse import quote

# ========================================
# 설정
# ========================================
BASE_URL = "http://tkd001.cafe24.com"
SERVER_URL = BASE_URL + "/TNG2/ocr/ocr_mvp3/asp/upload_ocr.asp"
VIEW_URL = BASE_URL + "/TNG2/ocr/ocr_mvp3/asp/ocr_view.asp"

# ========================================
# OCR 엔진
# ========================================
reader = None

def init_reader():
    global reader
    if reader is None:
        reader = easyocr.Reader(['ko', 'en'], gpu=False)
    return reader

def run_ocr(image_path):
    """OCR 실행 - 2배 확대"""
    r = init_reader()
    
    img = cv2.imread(image_path)
    if img is None:
        return None, "이미지 로드 실패"
    
    h_orig, w_orig = img.shape[:2]
    
    # 2배 확대
    img = cv2.resize(img, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)
    
    # OCR 실행
    results = r.readtext(img, detail=1, paragraph=False)
    
    # 결과 변환
    boxes = []
    for i, (bbox, text, conf) in enumerate(results):
        x = int(min(p[0] for p in bbox) / 2)
        y = int(min(p[1] for p in bbox) / 2)
        w = int((max(p[0] for p in bbox) - min(p[0] for p in bbox)) / 2)
        h = int((max(p[1] for p in bbox) - min(p[1] for p in bbox)) / 2)
        
        boxes.append({
            "id": i,
            "text": text.strip(),
            "x": x,
            "y": y,
            "w": w,
            "h": h,
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
            "width": w_orig,
            "height": h_orig
        },
        "boxes": boxes
    }
    
    return output, None

# ========================================
# GUI
# ========================================
class OCRApp:
    def __init__(self, root):
        self.root = root
        self.root.title("OCR 업로드 프로그램")
        self.root.geometry("600x500")
        self.root.configure(bg="#1e1e1e")
        
        self.selected_files = []
        self.setup_ui()
    
    def setup_ui(self):
        # 스타일
        style = ttk.Style()
        style.theme_use('clam')
        style.configure("TButton", padding=10, font=('맑은 고딕', 10))
        style.configure("TLabel", background="#1e1e1e", foreground="white", font=('맑은 고딕', 10))
        style.configure("TFrame", background="#1e1e1e")
        
        # 메인 프레임
        main_frame = ttk.Frame(self.root, padding=20)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # 제목
        title = ttk.Label(main_frame, text="📷 OCR 업로드", font=('맑은 고딕', 16, 'bold'))
        title.pack(pady=(0, 20))
        
        # 버튼 프레임
        btn_frame = ttk.Frame(main_frame)
        btn_frame.pack(fill=tk.X, pady=10)
        
        self.btn_select = ttk.Button(btn_frame, text="📁 이미지 선택", command=self.select_files)
        self.btn_select.pack(side=tk.LEFT, padx=5)
        
        self.btn_clear = ttk.Button(btn_frame, text="🗑 목록 지우기", command=self.clear_list)
        self.btn_clear.pack(side=tk.LEFT, padx=5)
        
        self.btn_upload = ttk.Button(btn_frame, text="🚀 OCR + 업로드", command=self.start_process)
        self.btn_upload.pack(side=tk.RIGHT, padx=5)
        
        # 파일 리스트
        list_frame = ttk.Frame(main_frame)
        list_frame.pack(fill=tk.BOTH, expand=True, pady=10)
        
        self.file_listbox = tk.Listbox(list_frame, bg="#2d2d2d", fg="white", 
                                        selectbackground="#0e639c", font=('맑은 고딕', 10),
                                        height=10)
        self.file_listbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        
        scrollbar = ttk.Scrollbar(list_frame, orient=tk.VERTICAL, command=self.file_listbox.yview)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.file_listbox.config(yscrollcommand=scrollbar.set)
        
        # 진행 상태
        self.progress_var = tk.StringVar(value="대기 중...")
        self.progress_label = ttk.Label(main_frame, textvariable=self.progress_var)
        self.progress_label.pack(pady=5)
        
        self.progress_bar = ttk.Progressbar(main_frame, mode='determinate', length=400)
        self.progress_bar.pack(pady=5)
        
        # 로그
        log_frame = ttk.Frame(main_frame)
        log_frame.pack(fill=tk.BOTH, expand=True, pady=10)
        
        self.log_text = tk.Text(log_frame, bg="#2d2d2d", fg="#00ff00", 
                                 font=('Consolas', 9), height=8)
        self.log_text.pack(fill=tk.BOTH, expand=True)
    
    def log(self, msg):
        self.log_text.insert(tk.END, f"{datetime.now().strftime('%H:%M:%S')} {msg}\n")
        self.log_text.see(tk.END)
        self.root.update()
    
    def select_files(self):
        files = filedialog.askopenfilenames(
            title="이미지 선택",
            filetypes=[
                ("이미지 파일", "*.png *.jpg *.jpeg *.bmp *.tiff"),
                ("모든 파일", "*.*")
            ]
        )
        if files:
            self.selected_files.extend(files)
            self.update_list()
    
    def update_list(self):
        self.file_listbox.delete(0, tk.END)
        for f in self.selected_files:
            self.file_listbox.insert(tk.END, os.path.basename(f))
    
    def clear_list(self):
        self.selected_files = []
        self.file_listbox.delete(0, tk.END)
        self.log("목록 초기화")
    
    def start_process(self):
        if not self.selected_files:
            messagebox.showwarning("경고", "이미지를 선택하세요")
            return
        
        # 스레드로 실행 (GUI 멈춤 방지)
        thread = Thread(target=self.process_files)
        thread.start()
    
    def process_files(self):
        total = len(self.selected_files)
        self.progress_bar['maximum'] = total
        self.progress_bar['value'] = 0
        
        self.log(f"=== {total}개 파일 처리 시작 ===")
        
        success_count = 0
        
        for i, filepath in enumerate(self.selected_files):
            filename = os.path.basename(filepath)
            self.progress_var.set(f"처리 중: {filename} ({i+1}/{total})")
            self.log(f"[{i+1}/{total}] {filename}")
            
            # OCR 실행
            self.log("  OCR 실행 중...")
            result, error = run_ocr(filepath)
            
            if error:
                self.log(f"  ❌ OCR 실패: {error}")
                continue
            
            self.log(f"  ✓ OCR 완료: {result['meta']['total_items']}개 추출")
            
            # 서버 업로드
            self.log("  업로드 중...")
            upload_result = self.upload_to_server(filepath, result)

            if upload_result:
                self.log(f"  ✓ 업로드 완료")
                success_count += 1

                # 브라우저에서 열기
                img_name = upload_result.get('image', '')
                json_name = upload_result.get('json', '')
                if img_name and json_name:
                    self.open_in_browser(img_name, json_name)
            else:
                self.log(f"  ❌ 업로드 실패")
            
            self.progress_bar['value'] = i + 1
            self.root.update()
        
        self.progress_var.set(f"완료! ({success_count}/{total} 성공)")
        self.log(f"=== 완료: {success_count}/{total} 성공 ===")
        messagebox.showinfo("완료", f"처리 완료!\n성공: {success_count}/{total}")
    
    def upload_to_server(self, image_path, ocr_result):
        """서버에 이미지 + JSON 업로드. 성공 시 {image, json} 파일명 반환"""
        try:
            filename = os.path.basename(image_path)
            json_filename = os.path.splitext(filename)[0] + "_ocr.json"
            json_bytes = json.dumps(ocr_result, ensure_ascii=False).encode('utf-8')

            with open(image_path, 'rb') as img_file:
                files = {
                    'image': (filename, img_file, 'image/png'),
                    'json': (json_filename, json_bytes, 'application/octet-stream')
                }
                response = requests.post(SERVER_URL, files=files, timeout=30)

            self.log(f"  응답 코드: {response.status_code}")
            self.log(f"  응답 내용: {response.text[:300]}")

            if response.status_code == 200:
                try:
                    result = response.json()
                    if result.get('success'):
                        return result
                    return None
                except:
                    self.log(f"  JSON 파싱 실패")
                    return None
            else:
                return None

        except Exception as e:
            self.log(f"  업로드 에러: {str(e)}")
            return None

    def open_in_browser(self, image_name, json_name):
        """업로드 결과를 브라우저에서 열기"""
        url = f"{VIEW_URL}?file={quote(image_name)}&json={quote(json_name)}"
        self.log(f"  브라우저 열기: {url}")

        edge_paths = [
            r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
            r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"
        ]
        edge = None
        for p in edge_paths:
            if os.path.exists(p):
                edge = p
                break

        if edge:
            subprocess.Popen([edge, url])
        else:
            webbrowser.open(url, new=1)

# ========================================
# 메인
# ========================================
if __name__ == "__main__":
    root = tk.Tk()
    app = OCRApp(root)
    root.mainloop()
