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

%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function




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
    <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
    <script>
    //검측W 입력
    function oinswf() {
        var oinsw = '';
        var odoorw = 0;
        var secondNum = 0;

        oinsw = Number($('#oinsw').val());  //검측W 입력값

        odoorw = Math.floor((oinsw-155)/2+75);  //도어제작W 계산
        odoorgw = Math.floor(odoorw-108); //도어유리W



        $('#odoorw').val(odoorw);
        $('#odoorgw').val(odoorgw);


    }

    </script>
 
  </head>
  <body class="sb-nav-fixed">



<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!-- 내용 입력 시작 -->  

<div class="row">
            <div class="col-md-2 mb-3">
              <label for="name">검측111</label>
              <input type="number" class="form-control" id="oinsw" name="oinsw" placeholder="너비(mm)" value="<%=oinsw%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinswf();" required>
            </div>

            <div class="col-md-2 mb-3">
              <label for="nickname">도어유리</label>
              <input type="number" class="form-control" id="odoorgw" name="odoorgw" placeholder="너비(mm))" value="<%=odoorgw%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">&nbsp;</label>
              <input type="number" class="form-control" id="odoorgh" name="odoorgh" placeholder="높이(mm)" value="<%=odoorgh%>" readonly>
            </div>







<!-- 내용입력 끝 -->
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 양양
 
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
