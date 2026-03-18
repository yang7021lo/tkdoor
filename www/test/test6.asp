<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Form Submit Example</title>
</head>
<body>
  <h1>Form Submit Example</h1>
  <!-- form 태그에 action과 method 설정 -->
  <form id="myForm" action="test6db.asp" method="POST">
    <label for="inputField">Type something and press Enter:</label><br>
    <input type="text" id="inputField1" name="inputValue1" placeholder="Type here" required />
    <input type="text" id="inputField2" name="inputValue2" placeholder="Type here" required />
    <button type="submit">Submit</button>
  </form>

  <script>
    // JavaScript로 Enter 키 이벤트 감지 및 폼 전송
    document.addEventListener('DOMContentLoaded', () => {
      const inputField = document.getElementById('inputField');
      const form = document.getElementById('myForm');

      inputField.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
          event.preventDefault(); // 기본 Enter 동작 방지
          form.submit(); // 폼 전송
        }
      });
    });
  </script>
</body>
</html>
