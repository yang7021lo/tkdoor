<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>작업의뢰등록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
  <div class="container mt-4">
    <h5 class="text-center mb-4">작업의뢰등록</h5>
    <div class="row mb-3">
      <div class="col-md-3">
        <label for="date" class="form-label">일자</label>
        <input type="date" class="form-control" id="date" value="2025-01-10">
      </div>
      <div class="col-md-3">
        <label for="number" class="form-label">번호</label>
        <input type="number" class="form-control" id="number" value="109">
      </div>
      <div class="col-md-3">
        <label for="urgency" class="form-label">긴급</label>
        <select class="form-select" id="urgency">
          <option selected>일반</option>
          <option>긴급</option>
        </select>
      </div>
      <div class="col-md-3">
        <label for="output" class="form-label">출고구분</label>
        <select class="form-select" id="output">
          <option selected>화물</option>
          <option>택배</option>
        </select>
      </div>
    </div>
    <div class="row mb-3">
      <div class="col-md-3">
        <label for="status" class="form-label">상태</label>
        <select class="form-select" id="status">
          <option selected>검토</option>
          <option>완료</option>
        </select>
      </div>
      <div class="col-md-3">
        <label class="form-label">인쇄</label>
        <div>
          <input type="radio" class="btn-check" name="printOption" id="work" autocomplete="off" checked>
          <label class="btn btn-outline-primary" for="work">작업</label>
          <input type="radio" class="btn-check" name="printOption" id="label" autocomplete="off">
          <label class="btn btn-outline-secondary" for="label">라벨</label>
        </div>
      </div>
    </div>
    <div class="mb-3">
      <label for="note" class="form-label">참고</label>
      <textarea class="form-control" id="note" rows="2"></textarea>
    </div>
    <table class="table table-bordered text-center">
      <thead>
        <tr>
          <th scope="col">No.</th>
          <th scope="col">구분</th>
          <th scope="col">거래처</th>
          <th scope="col">현장</th>
          <th scope="col">품명</th>
          <th scope="col">규격</th>
          <th scope="col">수량</th>
          <th scope="col">작업인쇄</th>
          <th scope="col">라벨인쇄</th>
          <th scope="col">유리인쇄</th>
          <th scope="col">세부정보</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>1</td>
          <td>도어</td>
          <td>사무실</td>
          <td>3</td>
          <td>신형단열자동 65*90</td>
          <td>1000x2400</td>
          <td>1</td>
          <td>좌</td>
          <td>24T</td>
          <td>H/L</td>
          <td></td>
        </tr>
      </tbody>
    </table>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
