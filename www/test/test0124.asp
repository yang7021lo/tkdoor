<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Data to aaa.asp</title>
    <style>
        /* 스타일 정의: 테두리 제거 */
        .input-field {
            width: 100%; /* 입력 필드 너비 */
            padding: 10px; /* 안쪽 여백 */
            margin-bottom: 15px; /* 아래 여백 */
            border: none; /* 테두리 제거 */
            border-bottom: 2px solid #ccc; /* 하단 경계선만 추가 */
            font-size: 16px; /* 글자 크기 */
            outline: none; /* 포커스 시 외곽선 제거 */
        }

        .input-field:focus {
            border-bottom: 2px solid #007bff; /* 포커스 시 경계선 강조 */
        }

        .submit-button {
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }

        .submit-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div style="max-width: 400px; margin: 50px auto;">
        <h1>Submit Data</h1>
        <form id="dataForm" action="test0123db.asp" method="POST">
            <!-- 첫 번째 input -->
            <input 
                type="text" 
                name="ri" 
                class="input-field" 
                placeholder="Enter Field 1" 

            >
            <!-- 두 번째 input -->
            <input 
                type="text" 
                name="cname" 
                class="input-field" 
                placeholder="Enter Field 2" 

            >
            <!-- 세 번째 input -->
            <input 
                type="text" 
                name="cvalue" 
                class="input-field" 
                placeholder="Enter Field 3" 

            >
            <!-- 숨겨진 Submit 버튼 -->
            <button type="submit" id="hiddenSubmit" style="display: none;"></button>
        </form>
    </div>

    <script>
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
    </script>
</body>
</html>
