<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left3.asp"-->

<% projectname="손잡이 등록" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
      a:link {
        color: #070707;
        text-decoration: none;
      }
      a:visited {
        color: #070707;
        text-decoration: none;
      }
      a:hover {
        color: #070707;
        text-decoration: none;
      }
    </style>
<script>
    function validateForm(){
       
            document.frmMain.submit();
        }

        
   
</script>
 
  </head>
<body class="bg-light">
   손잡이 등록
    
    <div class="py-5 container text-center">
     
<form name="frmMain" action="hd_itemdb.asp" method="post">
      

        <div class="input-group mb-3">
            <span class="input-group-text">코드&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="tagongcode" value="">
        </div>

        <div class="input-group mb-3">
            <span class="input-group-text">축약어&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="tagongshorten" value="">
        </div>

        <div class="input-group mb-3">
            <span class="input-group-text">손잡이품명&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="tagongname" value="">
        </div>

        <div class="input-group mb-3">
            <span class="input-group-text">타공거리&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="tagongpunch" value="">
        </div>

        <div class="input-group mb-3">
            <span class="input-group-text">단가&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="tagongprice" value="">
        </div>


        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
            <input type="text" class="form-control" name="hdprice" value="">
            <button type="button" class="btn btn-outline-secondary" onclick="location.replace('tagong_itemin.asp');">닫기</button>
        </div>

        


</form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
   
    
</body>
</html>