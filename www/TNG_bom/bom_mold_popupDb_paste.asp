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

Dim rmold_id, mode
rmold_id = Request("mold_id")
mode     = Request("mode")  ' img / cad
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <title>금형 파일 업로드</title>

    <style>
        body { font-family: Arial; padding: 50px; text-align:center; }
        #preview { display:none; max-width:300px; margin-top:20px; }
    </style>
</head>

<body>
<h2>Ctrl + V로 파일을 붙여넣으세요</h2>
<p>붙여넣기 → 자동 업로드</p>

<img id="preview" src="" />
<p id="status"></p>

<script>
document.addEventListener('paste', function (event) {
    const items = (event.clipboardData || window.clipboardData).items;

    for (let i = 0; i < items.length; i++) {
        if (items[i].type.indexOf('image') !== -1) {

            const file = items[i].getAsFile();
            const reader = new FileReader();

            // 미리보기
            reader.onload = function (e) {
                const img = document.getElementById('preview');
                img.src = e.target.result;
                img.style.display = 'block';
            };
            reader.readAsDataURL(file);

            document.getElementById('status').innerText =
                "업로드 중... 닫지 마세요.";

            // **전송은 기존 방식: form POST → DEXTUpload**
            const hiddenForm = document.createElement('form');
            hiddenForm.method = "post";
            hiddenForm.enctype = "multipart/form-data";
            hiddenForm.action = "bom_mold_popupDb_paste_data.asp?mold_id=<%=rmold_id%>&mode=<%=mode%>";

            const fileInput = document.createElement('input');
            fileInput.type = "file";
            fileInput.name = "pasteImage";

            hiddenForm.appendChild(fileInput);
            document.body.appendChild(hiddenForm);

            // File 객체를 FileInput에 넣기 위해 DataTransfer 사용
            const dt = new DataTransfer();
            dt.items.add(file);
            fileInput.files = dt.files;

            hiddenForm.submit();
        }
    }
});
</script>

<br><br>

<button type="button" class="btn btn-outline-danger"
        onclick="opener.location.reload(); window.close();">
    창닫기
</button>

</body>
</html>

<%
call dbClose()
%>
