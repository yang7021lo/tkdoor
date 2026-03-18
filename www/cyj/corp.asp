<!-- 

    [cidx]     키값            
    [cname]    업체이름
    [caddr1]   주소
    [caddr2]   상세주소
    [cpost]    우편번호
    [cmidx]    우리쪽담당자
    [cdidx]    고객사담당자
    [cwdate]   등록일
    [cnumber]  사업자등록번호
    [cnick]    업체별칭
    [ctkidx]   사업장구분
    [cstatus]  거래여부(0미사용,1사용)
    [cbuy]     매입처여부(0미사용,1사용)
    [csales]   매출처여부(0미사용,1사용)
    [cceo]     대표자
    [ctype]    업태
    [citem]    업종
    [cemail1]  계산서이메일
    [cgubun]   업체구분
    [cmove]    출고
    [cbran]    지점
    [cdlevel]  도어등급
    [cflevel]  프레임등급
    [calevel]  자동문등급
    [cslevel]  보호대등급
    [csylevel] 시스템등급
    [cmemo]    비고
    [ctel]     전화번호 
    [ctel2]    전화번호2
    [cfax]     팩스번호
  


-->
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
    projectname="거래처 등록"
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


    //휴대번호
    function inputPhoneNumber(obj) {

    var number = obj.value.replace(/[^0-9]/g, "");
    var phone = "";


    if(number.length < 4) {
        return number;
    } else if(number.length < 7) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3);
    } else if(number.length < 11) {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 3);
        phone += "-";
        phone += number.substr(6);
    } else {
        phone += number.substr(0, 3);
        phone += "-";
        phone += number.substr(3, 4);
        phone += "-";
        phone += number.substr(7);
    }
    obj.value = phone;
}

</script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <!-- CDN 방식 사용 -->
    <script>
	function execDaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                // 팝업을 통한 검색 결과 항목 클릭 시 실행
	                var addr = ''; // 주소_결과값이 없을 경우 공백 
	                var extraAddr = ''; // 참고항목
	
	                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	                if (data.userSelectedType === 'R') { // 도로명 주소를 선택
	                    addr = data.roadAddress;
	                } else { // 지번 주소를 선택
	                    addr = data.jibunAddress;
	                }
	
	                if(data.userSelectedType === 'R'){
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                } else {
	                    document.getElementById("caddr1").value = '';
	                }
	
	                // 선택된 우편번호와 주소 정보를 input 박스에 넣는다.
	                document.getElementById('zipp_code_id').value = data.zonecode;
	                document.getElementById("caddr1").value = addr;
	                document.getElementById("caddr1").value += extraAddr;
	                document.getElementById("caddr2").focus(); // 우편번호 + 주소 입력이 완료되었음으로 상세주소로 포커스 이동
	            }
	        }).open();
        }

function checker(){
	var str = ABC.cnumber.value;
  //alert(str.length);
	if (str.length == 10){
			hide.location.href="/inc/codechecker.asp?cnumber="+str;
  }
	else { 
		alert("사업자번호는 10자리입니다.");
  }
}


    function validateForm(){
        if(document.ABC.cname.value == "" ){
            alert("회사명을 입력해 주십시오.");
        return
        }
        if(document.ABC.cnumber.value == "" ){
            alert("사업자등록번호를 입력해 주십시오.");
        return
        }
        if(document.ABC.cceo.value == "" ){
            alert("대표자 이름을 입력해 주십시오.");
        return
        }
        if(document.ABC.cemail1.value == "" ){
            alert("계산서 이메일 주소를 입력해 주십시오.");
        return
        }

        if(document.ABC.ep_check.value == "" ){
            alert("사업자등록번호 중복확인이 필요합니다.");
        return
        }
        else{
            document.ABC.submit();
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
   <div class="row justify-content-between">
<!--화면시작-->
    <div class="py-0 mt-3 mb-3 container text-start  card card-body">
<form name="ABC" action="corpdb.asp" method="post" ENCTYPE="multipart/form-data">	
<iframe name="hide" width="0" height="0"></iframe>
<input type="hidden" name="ep_check" value="<%=ep_check%>">
        <div class="row">
 
            <div class="col-md-3 mb-3">
            <label for="name"><b>거래여부</b></label>

                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="cstatus" value="0" >
                    <label class="form-check-label" >미사용</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="cstatus" value="1" <% if cstatus="" then %>checked<% end if %>>
                    <label class="form-check-label" >사용</label>
                </div>

            </div>
            <div class="col-md-3 mb-3">
            <label for="name"><b>매입처여부</b></label>

                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="cbuy" value="0" >
                    <label class="form-check-label" >비적용</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="cbuy" value="1"  <% if cbuy="" then %>checked<% end if %>>
                    <label class="form-check-label" >적용</label>
                </div>
 
            </div>

            <div class="col-md-3 mb-3">
            <label for="name"><b>매출처여부</b></label>

                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="csales" value="0" >
                    <label class="form-check-label" >비적용</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="csales" value="1"  <% if csales="" then %>checked<% end if %>>
                    <label class="form-check-label" >적용</label>
                </div>
            </div>
        </div>
        <div class="row">

            <div class="col-md-4 mb-3">
            <label for="name"><b>업체명</b></label>
            <input type="text" class="form-control" id="cname" name="cname" placeholder="" value="" required>
                <div class="invalid-feedback">
                    이름을 입력해주세요.
                </div>
            </div>

            <div class="col-md-2 mb-3">
            <label for="name"><b>업체 별칭</b></label>
            <input type="text" class="form-control" id="cnick" name="cnick" placeholder="" value="" required>
                <div class="invalid-feedback">
                    이름을 입력해주세요.
                </div>
            </div>

            <div class="col-md-2 mb-3">
            <label for="name"><b>사업자번호</b></label>
            <input type="text" class="form-control" id="cnumber" name="cnumber" placeholder="" value="" maxlength="10"  required>
                <div class="invalid-feedback">
                    사업자번호를 입력해주세요.
                </div>
            </div>
        
            <div class="col-md-2 mb-3">
            <label for="name">&nbsp;</label>
            
            <button type="button" class="form-control btn btn-primary" onclick="checker();">중복</button>
            <div class="invalid-feedback">
                이미 가입된 사업자번호입니다.
            </div>
            </div>
            <div class="col-md-2 mb-3">
                <label><b>사업장</b></label>
                    <select class="form-select" id="ctkidx" name="ctkidx">
                        <option value="1" selected>태광도어</option>
                        <option value="2">티엔지단열프레임</option>
                        <option value="3">태광인텍</option>
                    </select>
            </div>


        </div>
 
        <div class="row">

            <div class="col-md-3 mb-3">
            <label for="name"><b>사업자등록파일</b></label>
                <input type="file" class="form-control" id="cfile" name="cfile" placeholder="" value="" required>
            </div>
            
            <div class="col-md-1 mb-3">
                <label for="name"><b>대표자</b></label>
                    <input type="text" class="form-control" id="cceo" name="cceo" placeholder="" value="" required>
            </div>

            <div class="col-md-2 mb-3">
            <label for="name"><b>업태</b></label>
                <input type="text" class="form-control" id="ctype" name="ctype" placeholder="" value="" required>
            </div>

            <div class="col-md-2 mb-3">
            <label for="name"><b>업종</b></label>
                <input type="text" class="form-control" id="citem" name="citem" placeholder="" value="" required>
            </div>
            <div class="col-md-4 mb-3">
                <label for="name"><b>계산서이메일</b></label>
                    <input type="email" class="form-control" id="cemail1" name="cemail1" placeholder="" value="" required>
            </div>
            

        </div>
        <div class="row">

            <div class="col-md-2">
            <input type="text" class="form-control" id="zipp_code_id" onclick="execDaumPostcode()" name="cpost" maxlength="10" placeholder="우편번호 찾기" style="width: 100%; display: inline;" readonly>
                <div class="invalid-feedback">
                    우편번호를 입력하세요.
                </div>
            </div>

            <div class="col-md-6">
            <input type="text" class="form-control" name="caddr1" id="caddr1" maxlength="40" placeholder="우편번호 찾기를 선택하세요." required readonly>
                <div class="invalid-feedback">
                    우편번호 검색을 통해 주소를 입력하세요.
                </div>
            </div>

            <div class="col-md-4">
                <input type="text" class="form-control" name="caddr2" id="caddr2" maxlength="40" placeholder="상세 주소를 입력하세요">
            </div>
        </div>  
 
    </div>
 
    <div class="py-2 mb-3 container text-start  card card-body">  
        <div class="row">
            <div class="col-md-2 mb-3">
                <label for="name"><b>Tel</b></label>
                    <input type="tel" class="form-control" id="ctel" name="ctel" placeholder="전화번호" value="" maxlength="13" onkeyup="inputPhoneNumber(this)";  required>
            </div>
            <div class="col-md-2 mb-3">
                <label for="name"><b>Tel2</b></label>
                    <input type="tel" class="form-control" id="ctel2" name="ctel2" placeholder="전화번호2" value="" maxlength="13" onkeyup="inputPhoneNumber(this)"; required>
            </div>
            <div class="col-md-2 mb-3">
                <label for="name"><b>Fax</b></label>
                    <input type="tel" class="form-control" id="cfax" name="cfax" placeholder="팩스번호" value="" maxlength="13" onkeyup="inputPhoneNumber(this)"; required>
            </div>

            <div class="col-md-2 mb-3">
                <label><b>업체구분</b></label>
                    <select class="form-select" id="cgubun" name="cgubun" >
                        <option value="">선택하세요.</option>
                        <option value="1">강화도어</option>
                        <option value="2">부속</option>
                        <option value="3">자동문</option>
                        <option value="4">창호,절곡</option>
                        <option value="5">프레임만</option>
                        <option value="6">소비자</option>
                        <option value="7">소송중</option>
                        <option value="8">거래처의거래처</option>
                    </select>
            </div>

            <div class="col-md-2 mb-3">
                <label><b>출고</b></label>
                    <select class="form-select" id="cmove" name="cmove">
                        <option value="">선택하세요.</option>
                        <option value="1">화물</option>                        
                        <option value="2">낮1배달</option>
                        <option value="3">낮2배달</option>
                        <option value="4">밤1배달</option>
                        <option value="5">밤2배달</option>
                        <option value="6">대구창고</option>
                        <option value="7">대전창고</option>
                        <option value="8">부산창고</option>
                        <option value="9">양산창고</option>
                        <option value="10">익산창고</option>
                        <option value="11">원주창고</option>
                    </select>
            </div>

            <div class="col-md-2 mb-3">
                <label for="name"><b>지점</b></label>
                    <input type="text" class="form-control" id="cbran" name="cbran" placeholder="대신화물지점" value="" required>
            </div>
        </div>
        <div class="row">
        
            <div class="col-md-2 mb-3">
                <label for="name"><b>도어등급</b></label>
                <select class="form-select" id="cdlevel" name="cdlevel">
                    <option value="0" selected>--선택--</option>
                    <option value="1">10만(기본)</option>                        
                    <option value="2">9만</option>
                    <option value="3">11만</option>
                    <option value="4">12만</option>
                    <option value="5">소비자</option>
                    <option value="6">1000*2400</option>
                </select>
            </div>
            <div class="col-md-2 mb-3">
                <label for="name"><b>프레임등급</b></label>
                <select class="form-select" id="cflevel" name="cflevel">
                    <option value="0" selected>--기본--</option>
                    <option value="1">A 수동,자동 전체 10% 디씨</option>                        
                    <option value="2">B 수동만10%디씨</option>
                    <option value="3">C 자동만10%디씨</option>
                    <option value="4">D 전체10%업</option> 
                    <option value="5">E 미설정</option>
                </select>
            </div>
            <div class="col-md-2 mb-3">
                <label for="name"><b>자동문등급</b></label>
                <select class="form-select" id="calevel" name="calevel">
                    <option value="0" selected>--선택--</option>
                    <option value="1">TK 2S+</option>                        
                    <option value="2">TK 1S</option>
                    <option value="3">소비자</option>
                    <option value="4">D</option>
                    <option value="5">E</option>
                </select>
            </div>
            <div class="col-md-2 mb-3">
                <label for="name"><b>보호대등급</b></label>
                <select class="form-select" id="cslevel" name="cslevel">
                    <option value="0" selected>--선택--</option>
                    <option value="1">4500</option>                        
                    <option value="2">5000</option>
                    <option value="3">5500</option>
                    <option value="4">소비자</option>
                    <option value="5">4100</option>
                </select>
            </div>
            <div class="col-md-2 mb-3">
                <label for="name"><b>시스템등급</b></label>
                <select class="form-select" id="csylevel" name="csylevel">
                    <option value="0" selected>--선택--</option>
                    <option value="1">강화도어</option>                        
                    <option value="2">공업사</option>
                    <option value="3">C</option>
                    <option value="4">D</option>
                    <option value="5">강화도어2400</option>
                </select>
            </div>
        </div>
        <div class="row">
        
            <div class="col-md-12 mb-3">
                <label for="name"><b>비고</b></label>
                    <textarea class="form-control"  name="cmemo"></textarea>
            </div>
 
        </div>
    </div>
 
   
<!-- 버튼 형식 시작--> 
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="validateForm();">등록</button>      
        </div>
<!-- 버튼 형식 끝--> 
<div class="row ">
    <div class="col-12 text-end">
Coded By 기리
    </div>
 </div>
    <!--화면 끝-->
  </div>
</form>  
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
