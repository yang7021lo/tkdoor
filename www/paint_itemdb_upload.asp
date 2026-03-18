<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

    '▼ HTML 출력 부분
    Dim pidx
    rpidx=request("pidx")
    gotopage = Request("gotopage")
    SearchWord   = Request("SearchWord")
    rtype  = Request("type") ' [type] 타입 (1.페인트 p_image 2.페인트 샘플 p_sample_image)

    'REsponse.write "rsjb_idx:"&rsjb_idx&"<br>"
    'REsponse.write "rbfidx:"&rbfidx&"<br>"
    'REsponse.write "rbftype:"&rbftype&"<br>"

%>

<!DOCTYPE html>
<html lang="ko">
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
    body { font-family: Arial; padding: 50px; text-align: center; }
    #preview { display: none; max-width: 300px; margin-top: 20px; }
  </style>

</head>
<body>
  <h2>Ctrl + V로 이미지를 붙여넣으세요</h2>
  <p>붙여넣은 이미지를 서버에 자동 업로드합니다.</p>

  <img id="preview" src="" alt="미리보기" />
  <p id="status"></p>

  <form id="hiddenForm" enctype="multipart/form-data" method="post" style="display:none;">
    <input type="file" id="uploadFile" name="pasteImage" accept="image/*">
  </form>

  <script>
    document.addEventListener('paste', function (event) {
      const items = (event.clipboardData || window.clipboardData).items;

      for (let i = 0; i < items.length; i++) {
        if (items[i].type.indexOf('image') !== -1) {
          const file = items[i].getAsFile();
          const reader = new FileReader();

          reader.onload = function (e) {
            const img = document.getElementById('preview');
            img.src = e.target.result;
            img.style.display = 'block';
          };
          reader.readAsDataURL(file);

          // 업로드 처리
          const formData = new FormData();
          formData.append('pasteImage', file);

          fetch('paint_itemdb_upload_paste.asp?pidx=<%=rpidx%>&gotopage=<%=gotopage%>&SearchWord=<%=SearchWord%>&type=<%=rtype%>', {
            method: 'POST',
            body: formData // ✅ Content-Type 자동 설정됨
          })
          .then(res => res.text())
          .then(text => {
            document.getElementById('status').innerText = '✅ 업로드 완료: ' + text;
          })
          .catch(err => {
            document.getElementById('status').innerText = '❌ 업로드 실패: ' + err;
          });
        }
      }
    });
  </script>
  <button type="button" class="btn btn-outline-danger" onclick="opener.location.replace('paint_itemin.asp?pidx=<%=rpidx%>&gotopage=<%=gotopage%>&SearchWord=<%=SearchWord%>');window.close();">창닫기</button>
  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>


<%


set Rs = Nothing
call dbClose()
%>
