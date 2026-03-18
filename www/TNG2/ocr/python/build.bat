@echo off
echo ========================================
echo OCR GUI exe 빌드
echo ========================================

pip install pyinstaller easyocr opencv-python requests

echo.
echo 빌드 시작...
pyinstaller --onefile --windowed --name "OCR_Upload" --icon=NONE ocr_gui.py

echo.
echo 완료! dist 폴더에 OCR_Upload.exe 생성됨
pause
