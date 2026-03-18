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
gubun=request("gubun")


If gubun = "" Then
    '▼ HTML 출력 부분
    Dim sjb_idx, bfidx, bftype
    sjb_idx = Request("rsjb_idx")
    bfidx   = Request("rbfidx")
    bftype  = Request("rbftype")
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>이미지 붙여넣기 업로드</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <script>
    // 붙여넣기 이벤트 감지
    document.addEventListener('paste', function (event) {
      const items = (event.clipboardData || event.originalEvent.clipboardData).items;
      for (let i = 0; i < items.length; i++) {
        if (items[i].type.indexOf('image') === 0) {
          const file = items[i].getAsFile();
          const formData = new FormData();
          formData.append('pasteImage', file);
          formData.append('gubun', 'input');
          formData.append('rsjb_idx', '<%=sjb_idx%>');
          formData.append('rbfidx', '<%=bfidx%>');
          formData.append('rbftype', '<%=bftype%>');

          fetch('TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD.asp', {
            method: 'POST',
            body: formData
          })
          .then(res => res.text())
          .then(resText => {
            // 업로드 후 리로드 or 창닫기
            // alert(resText);
            opener.location.reload();
            window.close();
          })
          .catch(err => alert('업로드 실패: ' + err));
        }
      }
    });

    function delConfirm() {
      if (confirm('이미지를 삭제하시겠습니까?')) {
        location.href = 'TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD.asp?gubun=delete&rbftype=<%=bftype%>&rsjb_idx=<%=sjb_idx%>&rbfidx=<%=bfidx%>';
      }
    }
    </script>
</head>
<body class="container py-5 text-center">
  <h2>이미지 붙여넣기 업로드</h2>
  <p>이 페이지에 <strong>Ctrl+V</strong>로 이미지를 붙여넣어 업로드하세요.</p>
  <button type="button" class="btn btn-outline-secondary" onclick="delConfirm()">삭제</button>
  <button type="button" class="btn btn-outline-secondary" onclick="window.close();">창 닫기</button>
</body>
</html>

<%
elseif gubun = "input" Then
    '▼ 붙여넣은 이미지(클립보드) 처리
    Dim uploadform
    Set uploadform = Server.CreateObject("DEXT.FileUpload")
    uploadform.AutoMakeFolder = True
    uploadform.DefaultPath = DefaultPath_bfimg

    'Dim sjb_idx, bfidx, bftype
    sjb_idx = encodesTR(uploadform("rsjb_idx"))
    bfidx   = encodesTR(uploadform("rbfidx"))
    bftype  = encodesTR(uploadform("rbftype"))

    Dim clipImg, board_file_name1
    Set clipImg = uploadform("pasteImage")

    If Not clipImg Is Nothing Then
      ' 파일 저장
      clipImg.Save ,False
      board_file_name1 = clipImg.LastSavedFileName

      ' 확장자만 떼서 새로운 이름 생성
      Dim splcf, ext
      splcf = Split(board_file_name1, ".")
      ext   = splcf(UBound(splcf))

      board_file_name1 = ymdhns & "." & ext
      Call uploadform.SaveAs(board_file_name1, False) ' 실제 rename

      ' DB 업데이트
      Dim SQL
      If bftype = "bfimg1" Then
        SQL = "Update tk_barasif set bfimg1='" & board_file_name1 & "' where bfidx='" & bfidx & "' "
      ElseIf bftype = "bfimg2" Then
        SQL = "Update tk_barasif set bfimg2='" & board_file_name1 & "' where bfidx='" & bfidx & "' "
      End If

      dbCon.Execute(SQL)

      ' 리다이렉트 or 창닫기
      Response.Write "<script>opener.location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?rsjb_idx=" & sjb_idx & "&rbfidx=" & bfidx & "');window.close();</script>"

    Else
      Response.Write "클립보드 이미지 없음"
    End If

elseif gubun = "delete" Then
    '▼ 삭제 로직 그대로 유지
    'Dim sjb_idx, bfidx, bftype
    sjb_idx = Request("rsjb_idx")
    bfidx   = Request("rbfidx")
    bftype  = Request("rbftype")

    If bftype = "bfimg1" Then
      SQL = "Update tk_barasif set bfimg1='' where bfidx='" & bfidx & "' "
      dbCon.Execute(SQL)
    ElseIf bftype = "bfimg2" Then
      SQL = "Update tk_barasif set bfimg2='' where bfidx='" & bfidx & "' "
      dbCon.Execute(SQL)
    End If

    Response.Write "<script>opener.location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?rsjb_idx=" & sjb_idx & "&rbfidx=" & bfidx & "');window.close();</script>"
End If

set Rs = Nothing
call dbClose()
%>
