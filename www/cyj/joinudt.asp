<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
projectname="회원가입"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

%>

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
            else{
                document.frmMain.submit();
            }
        }

    </script>
</head>
<body class="bg-light">
 
    
    <div class="py-5 container text-center">
        <div class="input-group mb-3">
            <h3>인증번호 재발급</h3>
        </div>
<form name="frmMain" action="joinudtdb.asp" method="post">
        <div class="input-group mb-3">
            <span class="input-group-text">이  름&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="mname" value="">
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">휴대폰 번호</span>
            <input type="tel" class="form-control" onkeyup="inputPhoneNumber(this);" name="mhp" maxlength="13" value="">

        </div>
    

        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();" >등 록</button>
            <button type="button" class="btn btn-outline-secondary" onclick="location.replace('/etc/s1/join.asp');">취 소</button>
        </div>
       
</form>

    </div>
    
    </div>




    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
   
    
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>