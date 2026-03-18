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

    projectname="회원정보 보기"

    midx=Request("midx")

    SQL=" Select B.cidx, B.cname , A.midx, A.mname, A.mpos, A.mtel, A.mhp, A.mfax, Convert(varchar(10),A.mwdate,121),A.memail "
    SQL=SQL&" from tk_member A "
    SQL=SQL&" Join tk_customer B On A.cidx=B.cidx "
    SQL=SQL&" Where A.midx='"&midx&"' "
    Rs.open SQL,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
        rcidx=Rs(0)
        rcname=Rs(1)
        rmidx=Rs(2)
        rmname=Rs(3)
        rmpos=Rs(4)
        rmtel=Rs(5)
        rmhp=Rs(6)
        rmfax=Rs(7)
        rmemail=Rs(9)
        rmwdate=Rs(8)

    End If
    Rs.Close
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
        
        function del(midx) {
            if (confirm("이 항목을 삭제하시겠습니까?")) {
                location.href = "memdel.asp?midx=" + midx;
            }
        }
        

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
            hide.location.href="memcheck.asp?mhp="+str;   
        }
        function pwreset() {
            if (confirm('인증번호를 새로 발급하시겠습니까?'))
            {
                location.href="memreset.asp?midx=<%=midx%>&mhp=<%=rmhp%>&mname=<%=rmname%>"
            }
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
    <div class="input-group mb-3">
        <span class="input-group-text"  style="width:80px;">거래처</span>
        <div class="card text-start" style="width:92%;padding:6 3 6 6">
            <%=rcname%>
        </div>
    </div>
     <div class="input-group mb-3">
       <span class="input-group-text"  style="width:80px;">이&nbsp;&nbsp;&nbsp;름</span>
       <div class="card text-start" style="width:92%;padding:6 3 6 6">
        <%=rmname%>
       </div>
     </div>
     <div class="input-group mb-3">
       <span class="input-group-text" style="width:80px;">직책</span>
       <div class="card text-start" style="width:92%;padding:6 3 6 6">
        <%=rmpos%>
       </div>
     </div>
     <div class="input-group mb-3">
       <span class="input-group-text"  style="width:80px;">전화번호</span>
       <div class="card text-start" style="width:92%;padding:6 3 6 6">
        <%=rmtel%>
       </div>
     </div>
     <div class="input-group mb-3">
       <span class="input-group-text" style="width:80px;">휴대폰</span>
       <div class="card text-start" style="width:92%;padding:6 3 6 6">
        <%=rmhp%>
       </div>
     </div>
     <div class="input-group mb-3">
       <span class="input-group-text" style="width:80px;">팩스</span>
       <div class="card text-start" style="width:92%;padding:6 3 6 6">
        <%=rmfax%>
       </div>
     </div>
     <div class="input-group mb-3">
       <span class="input-group-text" style="width:80px;">이메일</span>
       <div class="card text-start" style="width:92%;padding:6 3 6 6">
        <%=rmemail%>
       </div>
     </div>

 
    <div class="input-group mb-3">
       <button type="button" class="btn btn-outline-primary" Onclick="location.replace('memudt.asp?cidx=<%=cidx%>&midx=<%=midx%>');">수정</button>
       <button type="button" class="btn btn-outline-secondary" Onclick="location.replace('corpview.asp?cidx=<%=cidx%>');">리스트</button>
       <button type="button" class="btn btn-outline-secondary" Onclick="pwreset();">인증번호초기화</button>
    </div>
     </form><
 
    </div>   
<!--화면 끝-->
      </div>
    </div>
    </main>                          
     
    
    <!-- footer 시작 -->    
     
    Coded By 오소리
     
    <!-- footer 끝 --> 
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
            <script src="/js/scripts.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
     
        </body>
    </html>
    
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

