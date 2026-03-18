<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>onchange 및 마우스 이벤트 예제</title>
    <style>
        #box {
            width: 100px;
            height: 100px;
            background-color: lightgray;
            margin-top: 10px;
            text-align: center;
            line-height: 100px;
            user-select: none;
        }
    </style>
    <script>
        function handleChange(selectElement) {
            const selectedValue = selectElement.value;
            document.getElementById("result").innerText = `선택한 값: ${selectedValue}`;
            document.getElementById("hiddenSubmit").click();
        }

        function handleMouseMove(event) {
            document.getElementById("coordinates").innerText = 
                `X: ${event.clientX}, Y: ${event.clientY}`;
        }

        function handleClick() {
            alert("버튼이 클릭되었습니다!");
        }
    </script>
</head>
<body>
<form id="dataForm" action="test0314db.asp" method="POST" >   
    <h3>onchange 이벤트 예제</h3>
    <select name="BUSTATUS" id="BUSTATUS"  onchange="handleChange(this)">
        <option value="1">옵션 1</option>
        <option value="2">옵션 2</option>
        <option value="3">옵션 3</option>
    </select>
    <p id="result">선택한 값이 여기에 표시됩니다.</p>

    <h3>마우스 이벤트 예제</h3>
    <button onclick="handleClick()">클릭하세요</button>
    <div id="box" onmousemove="handleMouseMove(event)">
        마우스를 올려보세요
    </div>
    <p id="coordinates">마우스 좌표: X: 0, Y: 0</p>
    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>    
</body>
</html>
