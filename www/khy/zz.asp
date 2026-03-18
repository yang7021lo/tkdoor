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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")

    listgubun="four"
    projectname="자재등록"
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
        
        function validateForm(){
            if(document.frmMain.order_name.value ==""){
                alert(" 자재명을 입력하세요.");
            return
            } 
            if(document.frmMain.order_type.value ==""){
                alert("자재 재질을 선택하세요.");
            return
            } 
            if(document.frmMain.order_length.value ==""){
                alert("자재 길이를 선택하세요.");
            return
            } 
            else{
                document.frmMain.submit();
            }
        }
    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"--> 


<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!-- 내용 입력 시작 -->  
<div class=" py-5 container text-center">
    <div class="input-group mb-3">
        <h3>자재등록</h3>
    </div>
    <form name="frmMain" action="khorderdb.asp" method="post">
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">부서</span>
                    <select class="form-select" name="order_dept">
                        <option value="1">도어</option>
                        <option value="2">프레임</option>
                        <option value="3">시스템도어</option>
                        <option value="4">자동문</option>
                        <option value="5">보호대</option>
                        <option value="6">기타</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">자재명&nbsp;&nbsp;&nbsp;</span>
                    <input type="text" class="form-control" name="order_name" value="">
                </div>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">자재길이</span>
                    <select class="form-select" name="order_length">
                        <option value="0" >없음</option>
                        <option value="1" >2,200mm</option>
                        <option value="2">2,400mm</option>
                        <option value="3">2,500mm</option>
                        <option value="4">2,800mm</option>
                        <option value="5">3,000mm</option>
                        <option value="6">3,200mm</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text">자재재질</span>
                    <select class="form-select" name="order_type">
                        <option value="0" >없음</option>
                        <option value="1">무피</option>
                        <option value="2">백피</option>
                        <option value="3">블랙</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-primary" Onclick="validateForm();">등록</button>
            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('khorderlist.asp');">리스트</button>
        </div>
    </form>
</div>
Coded By 호영
<!-- 내용입력 끝 -->
  </div>
</div>
</main>                          

<!-- footer 시작 -->    

 
<!-- footer 끝 --> 

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