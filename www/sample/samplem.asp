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
listgubun="one"
subgubun="one2"
projectname="샘플"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


%>
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

    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->

    <div class="py-5 container text-center  card card-body">

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
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 이름
 
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
 
    </body>
</html>
<%
 
%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
