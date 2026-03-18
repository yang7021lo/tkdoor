<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")


    if serdate="" then 
        serdate=date()
    end if
%> 
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no"/>
    <meta name="description" content="고객문의 접수 웹사이트 기초과정"/>
    <meta name="작가" content="yang"/>
    <title>nboard</title>
    <link rel="icon" type="image/png" sizes="32x32" href="http://devkevin.cafe24.com/lyh/favicon-32x32.png">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script>
        function inputPhoneNumber(obj){
            var number = obj.value.replace(/[^0-9]/g,"");
            var phone = "";
            if(number.length < 4){
                return number;
            }else if(number.length<7){
                phone+=number.substr(0,3);
                phone+="-";
                phone+=number.substr(3);
            }else if(number.length<11){
                phone+=number.substr(0,3);
                phone+="-";
                phone+=number.substr(3,3);
                phone+="-";
                phone+=number.substr(6);
            }else{
                phone+=number.substr(0,3);
                phone+="-";
                phone+=number.substr(3,4);
                phone+="-";
                phone+=number.substr(7);
            }
            obj.value=phone;
        }
        function validateForm(){
            if(document.frmMain.corp_name.value==""){
                alert("제목을 입력해주세요");
                return
            }
            if(document.frmMain.qcontents.value==""){
                alert("제안사항을 입력해주세요");
                return
            }
            document.frmMain.submit();
        }
    </script>
</head>
<body class="bg-light">
    <div class="py-5 container text-center">
        <h3>제안사항 작성하기</h3>
        <form name="frmMain" action="nboarddb.asp" method="post" enctype="multipart/form-data">
            <div class="input-group mb-3">
                <span class="input-group-text">제목</span>
                <input type="text" class="form-control" name="jemok" value="">
            </div>
            <div class="input-group mb-3">
                <span class="input-group-text">제안사항</span>
                <textarea class="form-control" name="jeansahang" rows="10"></textarea>
            </div>
            <div class="input-group mb-3">
                <span class="input-group-text">파일 업로드</span>
                <input type="file" class="form-control" name="uploadFile1" multiple>
            </div>
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-primary" onclick="validateForm();">등록</button>
                <button type="button" class="btn btn-outline-secondary" onclick="location.replace('nboard.asp');">취소</button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
