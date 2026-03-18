<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>게시판</title>
  <style>
    table {
      border-collapse: collapse;
      width: 80%;
      margin: 20px auto;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: left;
      position: relative;
    }

    .hover-image {
      display: none;
      position: absolute;
      top: 50%;
      left: 110%;
      transform: translateY(-50%);
      width: 150px;
      border: 1px solid #aaa;
      background-color: #fff;
      z-index: 100;
      box-shadow: 0px 0px 5px rgba(0,0,0,0.2);
    }

    .title-cell:hover .hover-image {
      display: block;
    }

    .title-cell {
      cursor: pointer;
    }
  </style>
</head>
<body>

  <table>
    <thead>
      <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td class="title-cell">
          나의 첫 번째 게시물
          <img src="https://via.placeholder.com/150" class="hover-image" alt="미리보기 이미지">
        </td>
        <td>홍길동</td>
      </tr>
      <tr>
        <td>2</td>
        <td class="title-cell">
          두 번째 이야기
          <img src="https://via.placeholder.com/150/87CEFA/000000" class="hover-image" alt="미리보기 이미지">
        </td>
        <td>김철수</td>
      </tr>
      <tr>
        <td>3</td>
        <td class="title-cell">
          여행 후기
          <img src="https://via.placeholder.com/150/FFB6C1/000000" class="hover-image" alt="미리보기 이미지">
        </td>
        <td>이영희</td>
      </tr>
    </tbody>
  </table>

</body>
</html>
