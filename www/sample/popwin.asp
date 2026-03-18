<%

i=Request("i")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새로운 페이지</title>
    <!-- Bootstrap 5 CSS 연결 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <div class="container mt-5">
        <h1 class="text-center">환영합니다!</h1>
        <p class="text-center">HTML <%=i%>번째 페이지입니다.</p>

        <!-- 버튼 예시 -->
        <div class="text-center mt-4">
            3초후에 자동으로 닫힘니다.
        </div>
    </div>

    <!-- Bootstrap 5 JS (Popper 포함) 연결 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 3초 후 자동으로 창 닫기 -->
    <script>
        setTimeout(function() {
            window.close();
        }, 3000); // 3000ms = 3초
    </script>

</body>
</html>
