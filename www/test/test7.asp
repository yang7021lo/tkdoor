<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Send Data to aaa.asp</title>
</head>
<body>
  <h1>Form Submit Example</h1>
  <!-- Form 정의 -->
  <form id="myForm" action="aaa.asp" method="POST">
    <label for="input1">Input 1:</label><br>
    <input type="text" id="input1" name="input1" placeholder="Enter first value" required /><br><br>
    
    <label for="input2">Input 2:</label><br>
    <input type="text" id="input2" name="input2" placeholder="Enter second value" required /><br><br>
    
    <label for="selectField">Select an Option:</label><br>
    <select id="selectField" name="option" required>
      <option value="" disabled selected>Select an option</option>
      <option value="Option 1">Option 1</option>
      <option value="Option 2">Option 2</option>
      <option value="Option 3">Option 3</option>
    </select><br><br>
    
    <button type="submit">Submit</button>
  </form>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const form = document.getElementById('myForm');
      const input1 = document.getElementById('input1');
      const input2 = document.getElementById('input2');
      const selectField = document.getElementById('selectField');

      // Enter 키 이벤트 처리
      form.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
          event.preventDefault(); // 기본 Enter 동작 방지
            form.submit(); // 모든 값이 입력되었을 때만 폼 전송
          
        }
      });

      // Select 필드 선택 시 폼 전송
      selectField.addEventListener('change', () => {
        {
          form.submit(); // 값이 모두 입력되었을 때 폼 전송
        }
      });
    });
  </script>
</body>
</html>
