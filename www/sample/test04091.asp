<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>버튼 간격 1px</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .btn-spacing > .btn {
      margin-right: 1px;
    }

    /* 마지막 버튼 오른쪽 여백 제거 */
    .btn-spacing > .btn:last-child {
      margin-right: 0;
    }
  </style>
</head>
<body class="p-4">

  <div class="btn-spacing">
    <button type="button" class="btn btn-primary">버튼 1</button>
    <button type="button" class="btn btn-secondary">버튼 2</button>
    <button type="button" class="btn btn-success">버튼 3</button>
    <button type="button" class="btn btn-danger">버튼 4</button>
  </div>

</body>
</html>
