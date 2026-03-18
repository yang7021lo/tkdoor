<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<% projectname="부속 등록" %>

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
<h3>부속 입력</h3>
    <div class="py-5 container text-center">
        <form name="frmMain" action="busok_itemdb.asp" method="post" ENCTYPE="multipart/form-data">
            <div class="input-group mb-3">
                <div class="col-2">
                <span class="input-group-text">타입선택여부</span>
                    <select class="form-select" name="BUSELECT">
                        <option value="">선택</option>
                        <option value="1" >알미늄바</option>
                        <option value="2" >스텐,껍데기</option>
                        <option value="3" >출몰바</option>
                        <option value="4" >보강</option>
                        <option value="5" >기타,부자재</option>
                    </select>
                </div>
                <div class="col-1">    
                <span class="input-group-text">코드</span>
                <input type="text" class="form-control" name="BUCODE" value="">
                </div>
                <div class="col-1">    
                <span class="input-group-text">축약어</span>
                <input type="text" class="form-control" name="BUshorten" value="">
                </div>
                <div class="col-2">  
                <span class="input-group-text">이름</span>
                <input type="text" class="form-control" name="BUNAME" value="">
                </div>
                <div class="col-2">  
                <span class="input-group-text">단위(EA,Kg,M)</span>
                <input type="text" class="form-control" name="BUQTY" value="">
                </div>
                <div class="col-2">
                <span class="input-group-text">사용중/안함</span>
                    <select class="form-select" name="BUSTATUS">
                        <option value="1">사용중</option>
                        <option value="2" >사용안함</option>
                    </select>
                </div>
            </div> 
            <div class="input-group mb-3">   
                <div class="col-2">  
                <span class="input-group-text">단가</span>
                <input type="text" class="form-control" name="Buprice" value="">
                </div>
                <div class="col-2">  
                <span class="input-group-text">금형NO</span>
                <input type="text" class="form-control" name="BUGEMHYUNG" value="">
                </div>
                <div class="col-2">  
                <span class="input-group-text">AL비중</span>
                <input type="text" class="form-control" name="BUBIJUNG" value="">
                </div>
                <div class="col-1">  
                <span class="input-group-text">깊이/두께</span>
                <input type="text" class="form-control" name="BUDUKKE" value="">
                </div>
                <div class="col-2">  
                <span class="input-group-text">보이는면</span>
                <input type="text" class="form-control" name="BUHIGH" value="">
                </div>
                <div class="col-2">  
                <span class="input-group-text">보강절단치수</span>
                <input type="text" class="form-control" name="BU_BOGANG_LENGTH" value="">
                </div>
            </div> 
            <div class="input-group mb-3">   
                <div class="col-1">  
                    <span class="input-group-text">이미지 파일</span>
                    <input type="file" class="form-control" name="BUIMAGES" accept="image/*">
                </div>
                <div class="col-1">  
                    <span class="input-group-text">캐드 파일</span>
                    <input type="file" class="form-control" name="BUCADFILES">
                </div>
                <div class="col-2">  
                <span class="input-group-text">상바 타입</span>
                <select class="form-select" name="BUsangbarTYPE">
                        <option value="">선택</option>
                        <option value="1" >상바</option>
                        <option value="2" >공용상바</option>
                        <option value="3" >기타</option>
                    </select>
                </div>
                <div class="col-2">  
                <span class="input-group-text">하바 타입</span>
                <select class="form-select" name="BUhabarTYPE">
                        <option value="">선택</option>
                        <option value="1" >상바</option>
                        <option value="2" >공용상바</option>
                        <option value="3" >기타</option>
                    </select>
                </div>
                <div class="col-2">  
                <span class="input-group-text">출몰바 타입</span>
                <select class="form-select" name="BUchulmolbarTYPE">
                        <option value="">선택</option>
                        <option value="1" >안전</option>
                        <option value="2" >안전끼움</option>
                        <option value="3" >자동</option>
                        <option value="4" >복층</option>
                        <option value="4" >NF/하나로</option>
                        <option value="5" >삼중복층</option>
                    </select>
                </div>
                <div class="col-2">  
                <span class="input-group-text">도장 타입</span>
                <select class="form-select" name="BUpainttype">
                        <option value="">선택</option>
                        <option value="1" >도장</option>
                        <option value="2" >비도장</option>
                        <option value="3" >기타</option>
                    </select>
                </div>
                <div class="col-1"> 
                <span class="input-group-text">그룹 타입</span>
                <select class="form-select" name="BUgrouptype">
                        <option value="">선택</option>
                        <option value="1" >스텐안전</option>
                        <option value="2" >스텐복층</option>
                        <option value="3" >스텐단열</option>
                        <option value="4" >통도장안전</option>
                        <option value="4" >통도장복층</option>
                        <option value="5" >통도장단열</option>
                    </select>
                </div>
            </div>
            <div class="input-group mb-3">
                <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
                <button type="button" class="btn btn-outline-secondary" onclick="location.replace('busok_itemin.asp');">닫기</button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
</body>
</html>