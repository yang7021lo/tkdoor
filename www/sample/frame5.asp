<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사각형 드래그 및 크기 조정</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        svg {
            border: 1px solid #ddd;
            cursor: pointer;
        }
        .handle {
            fill: red;
            cursor: nwse-resize;
        }
        .info-inputs {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-left: 10px;
        }
        label {
            font-weight: bold;
        }
    </style>
</head>
<body class="p-4">
    <div class="container d-flex">
        <div>
            <h2 class="mb-3">SVG 사각형 조작</h2>
            <svg id="svgCanvas" width="500" height="300">
                <text id="widthLabel" x="100" y="40" font-size="14">100</text>
                <text id="heightLabel" x="160" y="100" font-size="14">100</text>
            </svg>
            <div class="mt-3">
                <button class="btn btn-primary" onclick="moveRect(-10, 0)">◀ 왼쪽</button>
                <button class="btn btn-primary" onclick="moveRect(10, 0)">오른쪽 ▶</button>
                <button class="btn btn-primary" onclick="moveRect(0, -10)">▲ 위</button>
                <button class="btn btn-primary" onclick="moveRect(0, 10)">아래 ▼</button>
            </div>
        </div>
        <div class="info-inputs">
            <label>X: <input type="number" id="inputX" value="50"></label>
            <label>Y: <input type="number" id="inputY" value="50"></label>
            <label>Width: <input type="number" id="inputWidth" value="100"></label>
            <label>Height: <input type="number" id="inputHeight" value="100"></label>
        </div>
    </div>
    <script>
        const svg = document.getElementById("svgCanvas");
        let rect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        let handle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
        let widthLabel = document.getElementById("widthLabel");
        let heightLabel = document.getElementById("heightLabel");
        let dragging = false, resizing = false;
        let offsetX, offsetY, startX, startY;

        rect.setAttribute("x", 50);
        rect.setAttribute("y", 50);
        rect.setAttribute("width", 100);
        rect.setAttribute("height", 100);
        rect.setAttribute("fill", "white");
        rect.setAttribute("stroke", "black");
        rect.setAttribute("stroke-width", 2);
        rect.style.cursor = "move";
        
        handle.setAttribute("cx", 150);
        handle.setAttribute("cy", 150);
        handle.setAttribute("r", 5);
        handle.setAttribute("class", "handle");
        
        svg.appendChild(rect);
        svg.appendChild(handle);
        
        rect.addEventListener("mousedown", (e) => {
            dragging = true;
            offsetX = e.offsetX - rect.x.baseVal.value;
            offsetY = e.offsetY - rect.y.baseVal.value;
        });
        
        handle.addEventListener("mousedown", (e) => {
            resizing = true;
            startX = e.offsetX;
            startY = e.offsetY;
        });
        
        document.addEventListener("mousemove", (e) => {
            if (dragging) {
                rect.setAttribute("x", e.offsetX - offsetX);
                rect.setAttribute("y", e.offsetY - offsetY);
                updateUI();
            }
            if (resizing) {
                let newWidth = Math.max(10, e.offsetX - rect.x.baseVal.value);
                let newHeight = Math.max(10, e.offsetY - rect.y.baseVal.value);
                rect.setAttribute("width", newWidth);
                rect.setAttribute("height", newHeight);
                updateUI();
            }
        });
        
        document.addEventListener("mouseup", () => {
            dragging = false;
            resizing = false;
        });
        
        function updateUI() {
            let x = Number(rect.getAttribute("x"));
            let y = Number(rect.getAttribute("y"));
            let width = Number(rect.getAttribute("width"));
            let height = Number(rect.getAttribute("height"));

            handle.setAttribute("cx", x + width);
            handle.setAttribute("cy", y + height);
            widthLabel.setAttribute("x", x + width / 2);
            widthLabel.textContent = width;
            heightLabel.setAttribute("x", x + width + 5);
            heightLabel.setAttribute("y", y + height / 2);
            heightLabel.textContent = height;

            document.getElementById("inputX").value = x;
            document.getElementById("inputY").value = y;
            document.getElementById("inputWidth").value = width;
            document.getElementById("inputHeight").value = height;
        }
        
        function moveRect(dx, dy) {
            let x = Number(rect.getAttribute("x")) + dx;
            let y = Number(rect.getAttribute("y")) + dy;
            rect.setAttribute("x", x);
            rect.setAttribute("y", y);
            updateUI();
        }
        
        document.querySelectorAll(".info-inputs input").forEach(input => {
            input.addEventListener("input", (e) => {
                rect.setAttribute(e.target.id.replace("input", "").toLowerCase(), e.target.value);
                updateUI();
            });
        });
    </script>
</body>
</html>
