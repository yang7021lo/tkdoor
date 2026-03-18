<%
gubun=request("gubun")

if gubun="win" then 
  For i = 1 to 15
    aleft=100+(30*i)
    atop=100+(30*i)
    winname="pop"&i

  response.write "<script>window.open('popwin.asp?i="&i&"','"&winname&"','top="&atop&", left="&aleft&", width=300, height=300 ');</script>"
  Next
  response.write "<script>location.replace('windowopen.asp');</script>"

end if
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>양양 최고</title>
  <!-- 부트스트랩 CSS 연결 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body class="d-flex flex-column justify-content-center align-items-center vh-100">

  <h1 class="mb-4">양양 최고</h1>
  <button type="button" class="btn btn-primary" onclick="location.replace('windowopen.asp?gubun=win');">창열기</button>

</body>
</html>
