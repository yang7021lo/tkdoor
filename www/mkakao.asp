<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"

projectname="회원인증"

midx=REquest("midx")

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
        function validateForm(){
            if(document.frmMain.ykakao.value == ""){
                alert("인증번호를 입력하세요.");
            return    
            }

            else{
                document.frmMain.submit();
            }
        }
 
    </script>
</head>
<body class="bg-light">
 
    
    <div class="py-5 container text-center">
        <div class="input-group mb-3">
            <h3>회원가입</h3>
        </div>
<form name="frmMain" action="kakaodb.asp" method="post">
<input type="hidden" name="midx" value="<%=midx%>">

 
        <div class="input-group mb-3">
            카카오톡으로 전송받은 인증코드 4자리 숫자를 입력해 주세요.
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">인증번호</span>
            <input type="text" class="form-control" name="ykakao" value="" maxlength="4">
        </div>


        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();" >인증하기</button>
        </div>
       
</form>

    </div>
    
    </div>




    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
   
    
</body>
</html>