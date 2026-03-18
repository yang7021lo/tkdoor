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

Dim mold_id, mode
mold_id = Request("mold_id")
mode    = Request("mode")   ' img / cad
%>
 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>BOM 금형 업로드</title>

    <style>
        body { font-family: Arial; padding: 50px; text-align: center; }
        #preview { display: none; max-width: 300px; margin-top: 20px; }
    </style>
</head>
<body>
  <h2>Ctrl + V로 이미지를 붙여넣으세요</h2>
  <p>붙여넣은 파일을 서버로 업로드합니다.</p>

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

          const formData = new FormData();
          formData.append('pasteImage', file);

          // 🔥 여기만 바뀜
          fetch('bom_mold_popupDb_paste_data.asp?mold_id=<%=mold_id%>&mode=<%=mode%>', {
            method: 'POST',
            body: formData
          })
          .then(res => res.text())
          .then(text => {
            document.getElementById('status').innerText = '✔ 업로드 완료: ' + text;
          })
          .catch(err => {
            document.getElementById('status').innerText = '❌ 업로드 실패: ' + err;
          });

        }
      }
    });
  </script>

  <button type="button" class="btn btn-outline-danger"
          onclick="opener.location.replace('bom_mold_popup.asp?mold_id=<%=mold_id%>');window.close();">
      창닫기
  </button>

</body>
</html>

<%
set Rs = Nothing
call dbClose()
%>
