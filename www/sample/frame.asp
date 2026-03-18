<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SVG 사각형 조작</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }
        .controls { margin-top: 10px; }
        .btn-group { margin: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <svg id="canvas" width="800" height="600" style="border:1px solid black; display: block; margin: auto;">
            <rect id="rect" x="50" y="50" width="100" height="100" fill="white" stroke="black" stroke-width="1"></rect>
        </svg>
        
        <div class="controls">
            <div class="row justify-content-center">
                <div class="col-auto">
                    <label class="form-label">X:</label>
                    <input type="number" id="x" class="form-control" value="50">
                </div>
                <div class="col-auto">
                    <label class="form-label">Y:</label>
                    <input type="number" id="y" class="form-control" value="50">
                </div>
                <div class="col-auto">
                    <label class="form-label">Width:</label>
                    <input type="number" id="width" class="form-control" value="100">
                </div>
                <div class="col-auto">
                    <label class="form-label">Height:</label>
                    <input type="number" id="height" class="form-control" value="100">
                </div>
            </div>
        </div>
        
        <div class="controls">
            <button class="btn btn-info" onclick="setSample(200, 45)">200x45 선택</button>
            <button class="btn btn-info" onclick="setSample(60, 200)">60x200 선택</button>
        </div>
        
        <div class="controls">
            <div class="btn-group">
                <button class="btn btn-secondary" onclick="moveRect(0, -10)">위로</button>
            </div>
            <div class="btn-group">
                <button class="btn btn-secondary" onclick="moveRect(-10, 0)">왼쪽</button>
                <button class="btn btn-secondary" onclick="moveRect(10, 0)">오른쪽</button>
            </div>
            <div class="btn-group">
                <button class="btn btn-secondary" onclick="moveRect(0, 10)">아래로</button>
            </div>
        </div>
        
        <div class="controls">
            <button class="btn btn-success" onclick="changeWidth(10)">Width 증가</button>
            <button class="btn btn-danger" onclick="changeWidth(-10)">Width 감소</button>
            <button class="btn btn-success" onclick="changeHeight(10)">Height 증가</button>
            <button class="btn btn-danger" onclick="changeHeight(-10)">Height 감소</button>
        </div>
        
        <button class="btn btn-primary mt-3" onclick="sendData()">전송</button>
    </div>
    
    <script>
        function updateRect() {
            let rect = document.getElementById("rect");
            rect.setAttribute("x", document.getElementById("x").value);
            rect.setAttribute("y", document.getElementById("y").value);
            rect.setAttribute("width", document.getElementById("width").value);
            rect.setAttribute("height", document.getElementById("height").value);
        }

        function moveRect(dx, dy) {
            let rect = document.getElementById("rect");
            let x = parseInt(rect.getAttribute("x")) + dx;
            let y = parseInt(rect.getAttribute("y")) + dy;
            rect.setAttribute("x", x);
            rect.setAttribute("y", y);
            document.getElementById("x").value = x;
            document.getElementById("y").value = y;
        }
        
        function changeWidth(dw) {
            let rect = document.getElementById("rect");
            let width = Math.max(10, parseInt(rect.getAttribute("width")) + dw);
            rect.setAttribute("width", width);
            document.getElementById("width").value = width;
        }
        
        function changeHeight(dh) {
            let rect = document.getElementById("rect");
            let height = Math.max(10, parseInt(rect.getAttribute("height")) + dh);
            rect.setAttribute("height", height);
            document.getElementById("height").value = height;
        }
        
        document.querySelectorAll("input").forEach(input => {
            input.addEventListener("input", function() {
                updateRect();
            });
        });
        
        function sendData() {
            let formData = new FormData();
            formData.append("x", document.getElementById("x").value);
            formData.append("y", document.getElementById("y").value);
            formData.append("width", document.getElementById("width").value);
            formData.append("height", document.getElementById("height").value);
            
            fetch("framedb.asp", {
                method: "POST",
                body: formData
            }).then(response => response.text()).then(data => {
                console.log("서버 응답:", data);
            }).catch(error => {
                console.error("전송 오류:", error);
            });
        }
        
        function setSample(width, height) {
            document.getElementById("width").value = width;
            document.getElementById("height").value = height;
            updateRect();
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


<%
set Rs=Nothing
call dbClose()
%>
