<!--
웹사이트개발시 사용되는 언어
html : 무대와 같은 존대 화면을 꾸미는 , 보여지는
asp :  DB와의 연동
css : html 꾸며주는 역할 / 색을 입히거나 글체 크기 등등  :데코레이션
js : html을 동적이게 만들어 준다.(움직임을 준다) :데이터의 이동,버튼 기능



bootstrap : 템플릿 사용으로 디자인적인 감각이 없어도 기본이상의 화면을 만들어 준다.
css : <head></head>영역에 삽입: <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
/ js : </body>바로 위에 삽입: <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

-->

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
kidx=request("kidx")
ksidx=request("ksidx")
if gubun="" then
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <script>
        function validateForm() {
            if(document.khy.filedet.value == "" ) {
                alert("파일을 선택하세요.");
            return

            }           
            else {
                document.khy.submit();
            }
        }
    </script>    
</head>

<body>

<!--화면시작-->
<form name="khy" action="korder_upload.asp?gubun=input" method="post" enctype="multipart/form-data">   
    <input type="hidden" class="form-control" name="kidx" value="<%=kidx%>">
    <input type="hidden" class="form-control" name="ksidx" value="<%=ksidx%>">


    <div class="py-5 container text-center">


<!-- input 형식 시작--> 
        <div class="input-group mb-3">
            <input type="file" class="form-control" name="filedet" value="">
        </div>
<!-- input 형식 끝--> 

<!-- 버튼 형식 시작--> 
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">등록</button>
        </div>
<!-- 버튼 형식 끝--> 
 
    </div>    
</form>
    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%
elseif gubun="input" then
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_order


kidx = encodesTR(uploadform("kidx"))
ksidx = encodesTR(uploadform("ksidx"))

filedet = uploadform("filedet")

uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_order

filedet = uploadform("filedet").Save( ,false)   '실질적인 파일 저장

board_file_name1 = uploadform("filedet").LastSavedFileName '파일저장 경로에서 파일명과 확장자만 board_file_name1변수에 저장한다.
Response.write kidx&"<br>"
Response.write ksidx&"<br>"
Response.write board_file_name1&"<br>"

if filedet<>"" then 

    splcyj=split(board_file_name1,".")

    afilename=splcyj(0) 'aaaa'
    bfilename=splcyj(1) 'pdf/jpg/hwp'

    board_file_name1=ymdhns&"."&bfilename
    board_file_name0 = uploadform.SaveAs(board_file_name1, False)        
    
end if 

uploadform.DeleteFile filedet 


SQL="Update tk_korderSub set filedet='"&board_file_name1&"' where ksidx='"&ksidx&"' "
response.write (SQL)&"<br>"

dbCon.execute (SQL)

response.write "<script>opener.location.replace('korder.asp?kidx="&kidx&"');window.close();</script>"

end if
%>
<%
set Rs=Nothing
call dbClose()
%>
