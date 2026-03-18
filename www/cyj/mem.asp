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

    If c_midx="" then 
    Response.write "<script>alert('로그인 하세요.');location.replace('/index.asp');</script>"
    End If

    listgubun="one"
    projectname="회원관리-등록"
    developername="오소리"
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
rcidx=Request("cidx")
if rcidx="" then 
    rcidx="1"
end if

'REsponse.write rcidx&"/"

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

        function oessign(obj){
            if(document.oFrom.mname.value ==""){
                alert("이름을 입력하세요.");
            return
            } 
            if(document.oFrom.mpos.value ==""){
                alert("직책을 입력해 주세요");
            return
            }
            if(document.oFrom.mtel.value ==""){
                alert(" 전화번호를 입력해 주십시요.");
            return
            } 
            if(document.oFrom.mhp.value ==""){
                alert(" 휴대폰 번호를 입력해 주십시요.");
            return
            } 
            if(document.oFrom.mfax.value ==""){
                alert("팩스 번호를 입력해 주세요");
            return
            }
            if(document.oFrom.memail.value ==""){
                alert(" 이메일을 입력해 주십시요.");
            return
            } 
            if(document.oFrom.ep_check.value ==""){
                alert("휴대폰번호 중복체크를 해주세요.");
            return
            } 
            
            else{
                document.oFrom.submit();
            }
        }
        //전화번호 입력 함수
        function inputPhoneNumber(obj) {
            var number = obj.value.replace(/[^0-9]/g,"");
            var phone = "";

            if(number.length < 4) {
                return number;
            } else if(number.length < 7) {
                phone +=number.substr(0,3);
                phone +="-";
                phone +=number.substr(3);
            } else if(number.length < 11) {
                phone +=number.substr(0,3);
                phone +="-";
                phone +=number.substr(3,3);
                phone +="-";
                phone +=number.substr(6);  
            } else {
                phone +=number.substr(0,3);
                phone +="-";
                phone +=number.substr(3,4);
                phone +="-";
                phone += number.substr(7);
            } 
            obj.value =phone;
        } 

        function memcheck() {
            var str = oFrom.mhp.value;
            hide.location.href="memcheck.asp?mhp="+str;     //   memcheck.asp의 용도는 휴대폰 번호 중복 체크하고 결과 반환
        }
    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_cyj.asp"-->
    <div id="layoutSidenav_content">            
    <main>
      <div class="container-fluid px-4">
       <div class="row justify-content-between py-3 ">
<!-- 거래처 기본정보 include 시작 --> 
<!--#include virtual="/cyj/cinc2.asp"-->
<!-- 거래처 기본정보 include 끝 --> 

<!--화면시작-->

    <div class="py-3 container text-center  card card-body">

     <form name="oFrom" action="memdb.asp" method="post">
     <input type="hidden" name="ep_check" value="<%=ep_check%>">
     <input type="hidden" name="cidx" value="<%=rcidx%>">

     <iframe name="hide" width="0" height="0" href="about:blank" border="0"></iframe>
 
     <div class="input-group mb-3">
       <span class="input-group-text">이름</span>
       <input type="text" class="form-control" name="mname" value="">

       <span class="input-group-text">직책</span>
       <input type="text" class="form-control" name="mpos" value="">

       <span class="input-group-text">전화번호</span>
       <input type="text" class="form-control" name="mtel" onkeyup="inputPhoneNumber(this);" value=""  maxlength="13">
 
       <span class="input-group-text">휴대폰</span>
       <input type="text" class="form-control" name="mhp" value="" onkeyup="inputPhoneNumber(this);" maxlength="13">
       <button type="button" class="btn btn-outline-primary"  onclick="memcheck();">중복확인</button>

       <span class="input-group-text">팩스</span>
       <input type="text" class="form-control" name="mfax" value="" onkeyup="inputPhoneNumber(this);" maxlength="13">

       <span class="input-group-text">이메일</span>
       <input type="text" class="form-control" name="memail" value="">
     </div>

 
    <div class="input-group mb-3">
       <button type="button" class="btn btn-outline-primary" Onclick="oessign();">등록</button>
       <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('mem.asp');">취소</button>
    </div>
     </form>
 
    </div>    

    <!--화면 끝-->
<!-- footer 시작 -->    
    <div class="row">
        <div class="col-12 text-end">
            Coded By <%=developername%>
        </div>
    </div>
<!-- footer 끝 --> 
  </div>
</div>
                                                    
</main>                          
 


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
