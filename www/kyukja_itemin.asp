<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
listgubun="one"
subgubun="one2"
projectname="품목등록-격자"
%>
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .image-container {
            text-align: center;
            margin-top: 20px;
        }
        /* 기본 이미지 스타일 */
.image-container img {
    border: 2px solid transparent;
    transition: border 0.3s;
}
        /* 활성화된 이미지 스타일 */
.image-container img.active {
    border: 2px solid blue;
}
        .calculation-container {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="text-center my-4">그림 선택 및 계산</h1>

        <!-- 순번 버튼 -->
        <div class="d-flex justify-content-center mb-4">
            <button onclick="selectImage(1)">Select Image 1</button>
            <button onclick="selectImage(2)">Select Image 2</button>
            <button onclick="selectImage(3)">Select Image 3</button>
            <button onclick="selectImage(4)">Select Image 4</button>
            <button onclick="selectImage(5)">Select Image 5</button>
            <button onclick="selectImage(6)">Select Image 6</button>
        </div>

        <!-- 이미지 표시 영역 -->
        <div class="image-container">
            <img id="image1" src="\img\door\gibon_kukja.jpg" alt="1번 그림" class="active">
            <img id="image2" src="\img\door\garo1_kukja.jpg" alt="2번 그림">
            <img id="image3" src="\img\door\garo2_kukja.jpg" alt="3번 그림">
            <img id="image4" src="\img\door\garo3_kukja.jpg" alt="4번 그림">
            <img id="image5" src="\img\door\sadari1_kukja.jpg" alt="5번 그림">
            <img id="image6" src="\img\door\sadari2_kukja.jpg" alt="6번 그림">
        </div>

        <!-- 계산 영역 -->
        <form name="frmMainb" action="kyukja_itemdb.asp" method="post" id="calculationForm"> 
        <div class="row mt-4">
                <!-- a값 입력 -->
                <div class="col-md-4">
                    <label for="aValue" class="form-label">A값 (sjbwide)</label>
                    <input type="number" id="aValue" name="sjbwide" class="form-control" oninput="calculate()" required>
                </div>
                
                <!-- b값 입력 -->
                <div class="col-md-4">
                    <label for="bValue" class="form-label">B값 (sjbhigh)</label>
                    <input type="number" id="bValue" name="sjbhigh" class="form-control" oninput="calculate()" required>
                </div>

                <!-- c값 선택 또는 입력 -->
                <div class="col-md-4">
                    <label for="cValue" class="form-label">C값 (kyukjaPok)</label>
                    <select id="cSelect" class="form-select" onchange="updateCValue()">
                        <option value="40">40</option>
                        <option value="50">50</option>
                        <option value="60">60</option>
                        <option value="70">70</option>
                        <option value="80">80</option>
                        <option value="90">90</option>
                        <option value="100">100</option>
                    </select>
                    <input type="number" id="cValue" name="kyukjaPok" class="form-control mt-2" oninput="calculate()" placeholder="직접 입력 가능">
                </div>
            </div>

            <!-- 계산 결과 -->
            <div class="row mt-4">
                <div class="col-md-6">
                    <label for="kyukjawide" class="form-label">A1값 (kyukjawide)</label>
                    <input type="number" id="kyukjawide" name="kyukjawide" class="form-control" readonly>
                </div>
                <div class="col-md-6">
                    <label for="kyukjahigh" class="form-label">B2값 (kyukjahigh)</label>
                    <input type="number" id="kyukjahigh" name="kyukjahigh" class="form-control" readonly>
                </div>
            </div>

            <!-- 제출 버튼 -->
            <div class="mt-4 text-center">
                <button type="submit" class="btn btn-success">결과 저장</button>
            </div>
        </form>
    </div>

    <script>
    // 이미지 선택
    function selectImage(number) {
    // 모든 이미지를 선택
    const images = document.querySelectorAll('.image-container img');
    
    // 모든 이미지에서 'active' 클래스 제거
    images.forEach(img => img.classList.remove('active'));
    
    // 선택한 이미지에 'active' 클래스 추가
    const selectedImage = document.getElementById(`image${number}`);
    if (selectedImage) {
        selectedImage.classList.add('active');
    } else {
        console.error(`Image with ID "image${number}" not found.`);
    }
}

    // c값 업데이트
    function updateCValue() {
        const cSelect = document.getElementById('cSelect');
        document.getElementById('cValue').value = cSelect.value;
        calculate();
    }

    // 계산 함수
    function calculate() {
        const a = parseFloat(document.getElementById('aValue').value) || 0;
        const b = parseFloat(document.getElementById('bValue').value) || 0;
        const c = parseFloat(document.getElementById('cValue').value) || 0;

        // A1 = (a - c) / 2
    let a1 = (a - c) / 2;

    // B2 = b - c
    let b2 = b - c;

    // 반올림하여 소수점 1자리로 고정 (0.5 단위)
    a1 = Math.round(a1 * 2) / 2; // 0.5 단위로 반올림
    b2 = Math.round(b2 * 2) / 2; // 0.5 단위로 반올림

    // 결과 반영
    document.getElementById('kyukjawide').value = a1.toFixed(1); // 소수점 1자리로 표시
    document.getElementById('kyukjahigh').value = b2.toFixed(1); // 소수점 1자리로 표시
}
</script>
</body>
</html>
