<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Form Example</title>
  <!-- 부트스트랩 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <div class="container mt-4">
    <h1>Form Example Without Loops</h1>
    <form id="manualForm" action="aaa.asp" method="POST">
      <!-- Input Fields -->
      <input type="text" class="form-control mb-2" name="input1" placeholder="Input 1">
      <input type="text" class="form-control mb-2" name="input2" placeholder="Input 2">
      <input type="text" class="form-control mb-2" name="input3" placeholder="Input 3">
      <!-- (중간 생략) -->
      <input type="text" class="form-control mb-2" name="input50" placeholder="Input 50">
      
      <!-- Select Fields -->
      <select class="form-select mb-2" name="select1">
        <option value="" disabled selected>Select 1</option>
        <option value="Option 1">Option 1</option>
        <option value="Option 2">Option 2</option>
      </select>
      <select class="form-select mb-2" name="select2">
        <option value="" disabled selected>Select 2</option>
        <option value="Option 1">Option 1</option>
        <option value="Option 2">Option 2</option>
      </select>
      <!-- (중간 생략) -->
      <select class="form-select mb-2" name="select20">
        <option value="" disabled selected>Select 20</option>
        <option value="Option 1">Option 1</option>
        <option value="Option 2">Option 2</option>
      </select>
    </form>
  </div>

  <script>
    // Select 변경 시 자동 제출 기능 추가
    document.addEventListener('DOMContentLoaded', () => {
      const form = document.getElementById('manualForm');
      form.addEventListener('change', (event) => {
        if (event.target.tagName === 'SELECT') {
          form.submit();
        }
      });
    });
  </script>
  <!-- 부트스트랩 JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
