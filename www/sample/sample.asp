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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
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
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3>화면제목</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
<!-- input 형식 시작--> 
        <div class="input-group mb-3">
            <span class="input-group-text">제목&nbsp;&nbsp;&nbsp;</span>
            <input type="text" class="form-control" name="htitle" value="">
        </div>
<!-- input 형식 끝--> 
<!-- view 형식 시작--> 
        <div class="input-group mb-3">
            <span class="input-group-text">게시판제목&nbsp;&nbsp;&nbsp;</span>
            <div class="card text-start ms-2" style="width:80%;padding:5 5 5 5;"><%=htitle%></div>
        </div>
<!-- view 형식 끝--> 
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">컬럼명1</th>
                      <th align="center">컬럼명2</th>
                      <th align="center">컬럼명3</th>
                      <th align="center">컬럼명4</th>
                      <th align="center">컬럼명5</th>
                      <th align="center">관리</th>  
                  </tr>
              </thead>
              <tbody>
<%
for i = 1 to 5
%>              
                  <tr>
                      <td><%=i%></td>
                      <td>값1</td>
                      <td>값2</td>
                      <td>값3</td>
                      <td>값4</td>
                      <td>값5</td>
                      <td><button type="button" class="btn btn-primary" onClick="location.replace('')">관리</button></td>
                  </tr>
<%
next
%>
              </tbody>
          </table>
        </div>
<!-- 표 형식 끝--> 
<!-- 버튼 형식 시작--> 
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('hboard_reply.asp?hidx=<%=hidx%>');">답글달기</button>      
        </div>
<!-- 버튼 형식 끝--> 
 
    </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>
