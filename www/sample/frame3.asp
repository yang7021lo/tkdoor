<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SVG 사각형 그리기</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .resize-handle {
      fill: red;
      cursor: pointer;
      r: 5;
    }
    .svg-container {
      border: 2px solid #000; /* 캔버스 테두리 */
      margin-top: 20px;
      width: 800px;
      height: 600px;
    }
    .dimension-label {
      font-size: 12px;
      fill: black;
    }
    .canvas-container {
      flex: 1;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .controls-container {
      max-width: 300px;
      padding: 20px;
      border-left: 1px solid #ccc;
    }
  </style>
</head>
<body>

  <div class="container-fluid">
    <div class="row">
      <!-- 캔버스 영역 -->
      <div class="canvas-container col-md-8">
        <div class="svg-container">
          <svg id="canvas" width="800" height="600" class="d-block">
            <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
            <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
            <text id="width-label" class="dimension-label"></text>
            <text id="height-label" class="dimension-label"></text>
          </svg>
        </div>
      </div>

      <!-- 입력 필드 및 버튼 영역 -->
      <div class="controls-container col-md-4">
        <h2 class="my-4">SVG 사각형 그리기</h2>

        <div class="form-group row">
          <label for="x-input" class="col-sm-4 col-form-label">X:</label>
          <div class="col-sm-8">
            <input type="number" class="form-control" id="x-input" disabled>
          </div>
        </div>

        <div class="form-group row">
          <label for="y-input" class="col-sm-4 col-form-label">Y:</label>
          <div class="col-sm-8">
            <input type="number" class="form-control" id="y-input" disabled>
          </div>
        </div>

        <div class="form-group row">
          <label for="width-input" class="col-sm-4 col-form-label">Width:</label>
          <div class="col-sm-8">
            <input type="number" class="form-control" id="width-input" disabled>
          </div>
        </div>

        <div class="form-group row">
          <label for="height-input" class="col-sm-4 col-form-label">Height:</label>
          <div class="col-sm-8">
            <input type="number" class="form-control" id="height-input" disabled>
          </div>
        </div>

        <div class="btn-group" role="group">
          <button class="btn btn-primary" id="move-left">왼쪽</button>
          <button class="btn btn-primary" id="move-up">위</button>
          <button class="btn btn-primary" id="move-right">오른쪽</button>
          <button class="btn btn-primary" id="move-down">아래</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    const canvas = document.getElementById('canvas');
    const rectangle = document.getElementById('rectangle');
    const resizeHandle = document.getElementById('resize-handle');
    const widthLabel = document.getElementById('width-label');
    const heightLabel = document.getElementById('height-label');
    const xInput = document.getElementById('x-input');
    const yInput = document.getElementById('y-input');
    const widthInput = document.getElementById('width-input');
    const heightInput = document.getElementById('height-input');

    let isDrawing = false;
    let isResizing = false;
    let isMoving = false;
    let startX, startY, startMouseX, startMouseY;

    // 사각형 그리기
    canvas.addEventListener('mousedown', (e) => {
      if (!isResizing && !isMoving) {
        startX = e.offsetX;
        startY = e.offsetY;
        isDrawing = true;
        rectangle.setAttribute('x', startX);
        rectangle.setAttribute('y', startY);
        rectangle.setAttribute('width', 0);
        rectangle.setAttribute('height', 0);
        resizeHandle.setAttribute('cx', startX);
        resizeHandle.setAttribute('cy', startY);
      }
    });

    // 사각형 크기 조정
    canvas.addEventListener('mousemove', (e) => {
      if (isDrawing) {
        const width = e.offsetX - startX;
        const height = e.offsetY - startY;
        rectangle.setAttribute('width', width);
        rectangle.setAttribute('height', height);
        resizeHandle.setAttribute('cx', startX + width);
        resizeHandle.setAttribute('cy', startY + height);
        widthLabel.textContent = `Width: ${Math.abs(width)}px`;
        heightLabel.textContent = `Height: ${Math.abs(height)}px`;
        widthLabel.setAttribute('x', startX + width / 2);
        widthLabel.setAttribute('y', startY - 5);
        heightLabel.setAttribute('x', startX + width + 5);
        heightLabel.setAttribute('y', startY + height / 2);
      } else if (isResizing) {
        const width = e.offsetX - startX;
        const height = e.offsetY - startY;
        rectangle.setAttribute('width', width);
        rectangle.setAttribute('height', height);
        resizeHandle.setAttribute('cx', startX + width);
        resizeHandle.setAttribute('cy', startY + height);
        widthLabel.textContent = `Width: ${Math.abs(width)}px`;
        heightLabel.textContent = `Height: ${Math.abs(height)}px`;
        widthLabel.setAttribute('x', startX + width / 2);
        widthLabel.setAttribute('y', startY - 5);
        heightLabel.setAttribute('x', startX + width + 5);
        heightLabel.setAttribute('y', startY + height / 2);
      } else if (isMoving) {
        const dx = e.offsetX - startMouseX;
        const dy = e.offsetY - startMouseY;
        const x = startX + dx;
        const y = startY + dy;
        rectangle.setAttribute('x', x);
        rectangle.setAttribute('y', y);
        resizeHandle.setAttribute('cx', x + parseInt(rectangle.getAttribute('width')));
        resizeHandle.setAttribute('cy', y + parseInt(rectangle.getAttribute('height')));
        widthLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) / 2);
        widthLabel.setAttribute('y', y - 5);
        heightLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) + 5);
        heightLabel.setAttribute('y', y + parseInt(rectangle.getAttribute('height')) / 2);
      }
      updateInputs();
    });

    // 마우스 놓기
    canvas.addEventListener('mouseup', () => {
      isDrawing = false;
      isResizing = false;
      isMoving = false;
    });

    // 리사이즈 핸들 클릭 시 리사이징 시작
    resizeHandle.addEventListener('mousedown', (e) => {
      e.stopPropagation(); // 부모 이벤트로 전파되지 않도록
      startX = parseInt(rectangle.getAttribute('x'));
      startY = parseInt(rectangle.getAttribute('y'));
      startMouseX = e.offsetX;
      startMouseY = e.offsetY;
      isResizing = true;
    });

    // 사각형 클릭 시 이동 시작
    rectangle.addEventListener('mousedown', (e) => {
      startX = parseInt(rectangle.getAttribute('x'));
      startY = parseInt(rectangle.getAttribute('y'));
      startMouseX = e.offsetX;
      startMouseY = e.offsetY;
      isMoving = true;
    });

    // 이동 버튼 기능
    document.getElementById('move-left').addEventListener('click', () => moveRectangle(-10, 0));
    document.getElementById('move-up').addEventListener('click', () => moveRectangle(0, -10));
    document.getElementById('move-right').addEventListener('click', () => moveRectangle(10, 0));
    document.getElementById('move-down').addEventListener('click', () => moveRectangle(0, 10));

    // 사각형 위치 이동
    function moveRectangle(dx, dy) {
      const x = parseInt(rectangle.getAttribute('x')) + dx;
      const y = parseInt(rectangle.getAttribute('y')) + dy;
      rectangle.setAttribute('x', x);
      rectangle.setAttribute('y', y);
      resizeHandle.setAttribute('cx', x + parseInt(rectangle.getAttribute('width')));
      resizeHandle.setAttribute('cy', y + parseInt(rectangle.getAttribute('height')));
      widthLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) / 2);
      widthLabel.setAttribute('y', y - 5);
      heightLabel.setAttribute('x', x + parseInt(rectangle.getAttribute('width')) + 5);
      heightLabel.setAttribute('y', y + parseInt(rectangle.getAttribute('height')) / 2);
      updateInputs();
    }

    // 입력 값 업데이트
    function updateInputs() {
      xInput.value = rectangle.getAttribute('x');
      yInput.value = rectangle.getAttribute('y');
      widthInput.value = rectangle.getAttribute('width');
      heightInput.value = rectangle.getAttribute('height');
    }
  </script>
</body>
</html>
