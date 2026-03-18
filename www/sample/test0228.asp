<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SVG Line Scale</title>
    <style>
        svg {
            border: 1px solid black;
        }
    </style>
</head>
<body>
    <button onclick="scaleElements(1.2)">확대</button>
    <button onclick="scaleElements(0.8)">축소</button>
    <svg id="mySVG" width="400" height="400">
        <line x1="50" y1="50" x2="150" y2="150" stroke="black" stroke-width="2"/>
        <line x1="100" y1="50" x2="200" y2="150" stroke="red" stroke-width="2"/>
        <text x="50" y="40" font-size="16" fill="black">Test</text>
    </svg>
    
    <script>
        function scaleElements(scaleFactor) {
            const elements = document.querySelectorAll("#mySVG line, #mySVG text");
            elements.forEach(element => {
                let x1 = element.getAttribute("x1");
                let y1 = element.getAttribute("y1");
                let x2 = element.getAttribute("x2");
                let y2 = element.getAttribute("y2");
                let x = element.getAttribute("x");
                let y = element.getAttribute("y");
                let fontSize = element.getAttribute("font-size");
                
                if (x1 !== null && y1 !== null && x2 !== null && y2 !== null) {
                    element.setAttribute("x1", parseFloat(x1) * scaleFactor);
                    element.setAttribute("y1", parseFloat(y1) * scaleFactor);
                    element.setAttribute("x2", parseFloat(x2) * scaleFactor);
                    element.setAttribute("y2", parseFloat(y2) * scaleFactor);
                }
                
                if (x !== null && y !== null) {
                    element.setAttribute("x", parseFloat(x) * scaleFactor);
                    element.setAttribute("y", parseFloat(y) * scaleFactor);
                }
                
                if (fontSize !== null) {
                    element.setAttribute("font-size", parseFloat(fontSize) * scaleFactor);
                }
            });
        }
    </script>
</body>
</html>
