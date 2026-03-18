<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Small Input Example</title>
  <!-- 부트스트랩 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <div class="container mt-4">
    <h1>Small Input Example</h1>
    <form>
      <!-- 기본 크기 input -->
      <div class="mb-3">
        <label for="defaultInput" class="form-label">Default Input</label>
        <input type="text" class="form-control" id="defaultInput" placeholder="Default size">
      </div>

      <!-- 작은 크기 input -->
      <div class="mb-3">
        <label for="smallInput" class="form-label">Small Input</label>
        <input type="text" class="form-control form-control-sm" id="smallInput" placeholder="Small size">
      </div>
    </form>
  </div>
  <!-- 부트스트랩 JS (선택 사항) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
