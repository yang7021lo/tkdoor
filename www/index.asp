<%@ CodePage="65001" Language="vbscript" %>
<%
Session.CodePage = "65001"
Response.CharSet  = "utf-8"

' —– 쿠키 확인 & 리다이렉트 —–
If Request.Cookies("tk")("c_midx") <> "" Then
    Response.Redirect "/ooo/advice/advicem.asp"
    Response.End
End If
' —– 여기까지 —–
%>
<%mname=request("mname")%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>양 로그인</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link href="/css/index.css" rel="stylesheet" type="text/css">
    <link href="/css/sso.css" rel="stylesheet" type="text/css">
    <script>
    function validateForm(){
        if(document.frmMain.mname.value == "" ){
            alert("이름을 입력해 주십시오.");
        return
        }
        if(document.frmMain.mkakao.value == ""){
            alert("인증번호를 입력해 주십시오.");
        return
        }
        else{
            document.frmMain.submit();
        }
    }
 
    </script>
</head>
<body>
    <!----------------------- Main Container -------------------------->
     <div class="container d-flex justify-content-center align-items-center min-vh-100">
    <!----------------------- Login Container -------------------------->
       <div class="row border rounded-5 p-3 bg-white shadow box-area">
    <!--------------------------- Left Box ----------------------------->
       <div class="col-md-6 rounded-4 d-flex justify-content-center align-items-center flex-column left-box" style="background-image: ;">
        <!--<img src="taekwang_logo.jpg" class="col-md-11 rounded-4 d-flex justify-content-center align-items-center flex-column left-box" alt="/etc/s1/signin.jpg">-->
        <img src="taekwang_logo.jpg" class="img-fluid" style="max-width:50%;">
       </div> 
    <!-------------------- ------ Right Box ---------------------------->
        
       <form class="col-md-6 right-box" name="frmMain" action="signindb.asp" method="POST">
          <div class="row align-items-center">
          
                <div class="input-group mb-3"><br></div>

                <div class="header-text mb-4">
                     <h2 style="font-family: 'GmarB', sans-serif;">태광도어</h2>
                     <p>통합 로그인 시스템</p>
                </div>
                <div class="input-group mb-3">
                    <input type="text" class="form-control form-control-lg bg-light fs-6" placeholder="이름" style="font-family: 'GmarM', sans-serif !important;" name="mname" required>
                </div>
                <div class="input-group mb-1">
                    <input type="text" class="form-control form-control-lg bg-light fs-6" placeholder="인증번호" style="font-family: 'GmarM', sans-serif !important;" name="mkakao" required>
                </div>
                <div class="input-group mb-5 d-flex justify-content-between" style="margin-top: 10px;">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="formCheck">
                        <label for="formCheck" class="form-check-label text-secondary"><small>로그인 상태 유지</small></label>
                    </div>
                    <div class="forgot">
                        <small><a href="joinudt.asp">인증번호 재발급</a></small>
                    </div>
                </div>
                <div class="input-group mb-3">
                    <button class="btn btn-lg btn-primary w-100 fs-6" type="button" onclick="validateForm();">로그인</button>
                </div>
               
                <div class="row">
                    <div class="col-6"><small>계정이 없으신가요? <a href="join.asp">회원가입</a></small></div>
                    <div class="col-6 text-end"><small>Coded by 양양</small></div>
                    
                </div>
          </div>
        </form> 
      </div>

    </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>  
</body>

</html>