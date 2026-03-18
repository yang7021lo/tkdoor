<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SVG 실시간 합산</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
        }
        svg {
            border: 1px solid #ccc;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <h2>두 숫자를 입력하세요</h2>
    <input type="number" id="num1" placeholder="첫 번째 숫자">
    <input type="number" id="num2" placeholder="두 번째 숫자">
    <br>
 
<!-- SVG 시작 -->
    <svg width="1000" height="600"  fill="none" stroke="#000000" stroke-width="1" >
        <rect x="80" y="35" width="10" height="300" /><!-- 좌측자동홈바 -->
        <rect x="560" y="35" width="10" height="300" /><!-- 우측자동홈바 -->
        <rect x="300" y="75" width="15" height="265" /><!-- 중간소대 -->
        <rect x="90" y="35" width="470" height="40" /><!-- 상바 -->
        <rect x="90" y="200" width="210" height="40" /><!-- 걸레받이 -->    
        
        <line x1="80" y1="5" x2="80" y2="28" />
        <line x1="80" y1="15" x2="230" y2="15" stroke-dasharray="5" />

        <text x="320" y="20" fill="#000000" font-size="14" text-anchor="middle" >가로외경 :&nbsp;&nbsp;&nbsp;&nbsp; </text>   
        <text x="360" y="20"  fill="#000000" font-size="14" text-anchor="left"  id="result" >0</text>
 
        <line x1="570" y1="5" x2="570" y2="28" />
        <line x1="400" y1="15" x2="570" y2="15" stroke-dasharray="5" />

        <text x="30" y="150" fill="#000000" font-size="14" text-anchor="middle">외경높이</text> 
        <text x="30" y="190" fill="#000000" font-size="14" text-anchor="middle"><%=odoorh%>mm</text> 
        <text x="50" y="170"  fill="#000000" font-size="14" text-anchor="middle"  id="hei" >0</text>
    </svg>
<!-- SVG 시작 -->
    <script>
        $(document).ready(function() {
            $('input').on('input', function() {
                let num1 = parseFloat($('#num1').val()) || 0;
                let num2 = parseFloat($('#num2').val()) || 0;
                let sum = num1 + num2;
                let hei = num1 - 20;
                $('#result').text(sum+'mm');
                $('#hei').text(hei);
            });
        });
    </script>
</body>
</html>
