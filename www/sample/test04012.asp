<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>화면 캡처 및 저장</title>
  <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
  <style>
    #captureArea {
      width: 400px;
      padding: 20px;
      border: 1px solid #ccc;
      background: #f9f9f9;
    }
  </style>
</head>
<body>

  <h2>📸 캡처 대상 영역</h2>
  <div id="captureArea">
    <p>이 영역이 캡처됩니다.</p>
    <p>html2canvas 라이브러리를 사용합니다.</p>
  </div>

  <br>
  <button onclick="captureAndSave()">📥 캡처 후 저장</button>

  <script>
    function captureAndSave() {
      const captureArea = document.getElementById('captureArea');
      html2canvas(captureArea).then(canvas => {
        // 이미지 데이터 얻기
        const image = canvas.toDataURL("image/png");
        
        // 다운로드 링크 만들기
        const link = document.createElement("a");
        link.href = image;
        link.download = "capture.png";  // 사용자는 저장 경로 선택하게 됨
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
      });
    }
  </script>

</body>
</html>
