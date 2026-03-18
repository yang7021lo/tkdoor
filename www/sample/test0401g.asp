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



If gubun = "" Then
    '▼ HTML 출력 부분
    Dim sjb_idx, bfidx, bftype,gubun
    sjb_idx = Request("rsjb_idx")
    bfidx   = Request("rbfidx")
    bftype  = Request("rbftype")
    gubun=request("gubun")
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>클립보드 이미지 업로드</title>
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

          fetch('upload2.asp', {
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
</body>
</html>


<%
elseif gubun = "input" Then




end if
set Rs = Nothing
call dbClose()
%>
