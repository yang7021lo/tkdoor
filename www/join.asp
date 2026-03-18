<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"

projectname="회원가입"
%>
<!--#include virtual="/inc/dbcon.asp"-->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no" />
    <meta name="description" content="회원가입" />
    <meta name="yang" content="양양" />
    <title><%=projectname%></title>
    <link rel="icon" sizes="image/x-icon" href="/inc/favicon.ico">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script>
        function inputPhoneNumber(obj){
            var number = obj.value.replace(/[^0-9]/g,"");
            var phone = "";

            if(number.length < 4) {
                return number;
            }else if(number.length < 7) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3);
            }else if(number.length < 11) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,3);
                phone += "-";
                phone += number.substr(6);
            }else{
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,4);
                phone += "-";
                phone += number.substr(7);
            }
            obj.value = phone;
        }

        function validateForm(){
            if(document.frmMain.mname.value == ""){
                alert("이름을 입력하세요.");
            return    
            }
            if(document.frmMain.mhp.value == ""){
                alert("휴대폰 번호를 입력하세요.");
            return    
            }
            if(document.frmMain.ep_check.value == ""){
                alert("휴대폰 중복확인 필요합니다.");
            return    
            }
            else{
                document.frmMain.submit();
            }
        }
        function checker(){
            var str = frmMain.mhp.value;
            if (str.length < 13)
                alert("휴대폰번호는 13자리입니다. 모두 입력해 주세요");
            else
            {
                if (str=="") 
                    alert("휴대폰 번호를 꼭 입력해 주세요");
                else
                    hide.location.href="/inc/codeCheckhp.asp?mhp="+str;
            }
        }
    </script>
</head>
<body class="bg-light">
<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="row border rounded-5 p-3 bg-white shadow box-area">    
        
            <div class="col-md-6 rounded-4 d-flex justify-content-center align-items-center flex-column left-box" style="background-image: ;">
                <!--<img src="taekwang_logo.jpg" class="col-md-11 rounded-4 d-flex justify-content-center align-items-center flex-column left-box" alt="/etc/s1/signin.jpg">-->
                <img src="taekwang_logo.jpg" class="img-fluid" style="max-width:50%;">
            </div>

            <form class="col-md-6 right-box" name="frmMain" action="joindb.asp" method="post">
                
                <div class="input-group mb-3"><br></div>

                <div class="header-text mb-4">
                     <h2 style="font-family: 'GmarB', sans-serif;">태광도어</h2>
                     <p>회원가입</p>
                </div>

                <div class="input-group mb-2"><br></div>

                <input type="hidden" name="ep_check" value="<%=Request("ep_check")%>">

                <iframe name="hide" width="0" height="0" href="about:blank" border="0"></iframe>


                <div class="input-group mb-3">
                    <input type="text" class="form-control form-control-lg bg-light fs-6" placeholder="이름" style="font-family: 'GmarM', sans-serif !important;" name="mname" required>
                </div>
                <div class="input-group mb-3">
                    <input type="tel" class="form-control form-control-lg bg-light fs-6" onkeyup="inputPhoneNumber(this);" placeholder="전화번호" name="mhp" maxlength="13" value="" required>
                    <button type="button" class="btn btn-outline-primary" onclick="checker();" >중복확인</button>
                </div>

                <div class="input-group mb-4"></div>

                <div class="input-group mb-7">
                    <button type="button" class="btn btn-outline-primary" onclick="validateForm();" >회원가입</button>
                    <button type="button" class="btn btn-outline-secondary" onclick="location.replace('/index.asp');">취 소</button>
                </div>   
            </form>
    </div>
</div>



    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
   
    
</body>
</html>