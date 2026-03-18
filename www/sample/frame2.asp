<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SVG 사각형 드래그 및 크기 조절</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }
        #canvas { border: 1px solid black; display: block; margin: auto; background-color: white; }
        .controls { margin-top: 10px; }
        .handle { fill: red; cursor: se-resize; }
    </style>
</head>
<body>
    <div class="container">
        <svg id="canvas" width="800" height="600"></svg>
        
        <div class="controls">
            <div class="row justify-content-center">
                <div class="col-auto">
                    <label class="form-label">X:</label>
                    <input type="number" id="x" class="form-control">
                </div>
                <div class="col-auto">
                    <label class="form-label">Y:</label>
                    <input type="number" id="y" class="form-control">
                </div>
                <div class="col-auto">
                    <label class="form-label">Width:</label>
                    <input type="number" id="width" class="form-control">
                </div>
                <div class="col-auto">
                    <label class="form-label">Height:</label>
                    <input type="number" id="height" class="form-control">
                </div>
            </div>
        </div>
    </div>
    
    <script>
        let svg = document.getElementById("canvas");
        let rect = null, handle = null;
        let startX, startY;
        let isResizing = false, isDragging = false;

        svg.addEventListener("mousedown", function(event) {
            if (event.target.tagName === "circle") return;
            startX = event.offsetX;
            startY = event.offsetY;
            rect = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            rect.setAttribute("x", startX);
            rect.setAttribute("y", startY);
            rect.setAttribute("width", 0);
            rect.setAttribute("height", 0);
            rect.setAttribute("fill", "white");
            rect.setAttribute("stroke", "black");
            rect.setAttribute("stroke-width", "1");
            rect.style.cursor = "move";
            svg.appendChild(rect);
        });

        svg.addEventListener("mousemove", function(event) {
            if (!rect) return;
            let currentX = event.offsetX;
            let currentY = event.offsetY;
            let width = Math.abs(currentX - startX);
            let height = Math.abs(currentY - startY);
            rect.setAttribute("width", width);
            rect.setAttribute("height", height);
            rect.setAttribute("x", Math.min(startX, currentX));
            rect.setAttribute("y", Math.min(startY, currentY));
        });

        svg.addEventListener("mouseup", function() {
            if (!rect) return;
            let rectX = parseFloat(rect.getAttribute("x"));
            let rectY = parseFloat(rect.getAttribute("y"));
            let rectWidth = parseFloat(rect.getAttribute("width"));
            let rectHeight = parseFloat(rect.getAttribute("height"));
            
            handle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            handle.setAttribute("cx", rectX + rectWidth);
            handle.setAttribute("cy", rectY + rectHeight);
            handle.setAttribute("r", 5);
            handle.setAttribute("fill", "red");
            handle.style.cursor = "se-resize";
            handle.classList.add("handle");
            svg.appendChild(handle);
            
            document.getElementById("x").value = rectX;
            document.getElementById("y").value = rectY;
            document.getElementById("width").value = rectWidth;
            document.getElementById("height").value = rectHeight;
            
            handle.addEventListener("mousedown", startResize);
            rect = null;
        });

        function startResize(event) {
            isResizing = true;
            let rect = event.target.previousSibling;
            let startX = event.clientX;
            let startY = event.clientY;
            let startWidth = parseFloat(rect.getAttribute("width"));
            let startHeight = parseFloat(rect.getAttribute("height"));
            
            function resizeMove(event) {
                if (!isResizing) return;
                let newWidth = startWidth + (event.clientX - startX);
                let newHeight = startHeight + (event.clientY - startY);
                rect.setAttribute("width", newWidth);
                rect.setAttribute("height", newHeight);
                handle.setAttribute("cx", parseFloat(rect.getAttribute("x")) + newWidth);
                handle.setAttribute("cy", parseFloat(rect.getAttribute("y")) + newHeight);
                document.getElementById("width").value = newWidth;
                document.getElementById("height").value = newHeight;
            }
            
            function resizeEnd() {
                isResizing = false;
                svg.removeEventListener("mousemove", resizeMove);
                svg.removeEventListener("mouseup", resizeEnd);
            }
            
            svg.addEventListener("mousemove", resizeMove);
            svg.addEventListener("mouseup", resizeEnd);
        }
    </script>
</body>
</html>