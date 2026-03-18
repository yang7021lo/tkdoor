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
projectname="발주사"
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
        <link href="css/styles.css" rel="stylesheet" />
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
          function checker(){
            var str = frmMain.cnumber.value;
            //alert(str.length);
            if (str.length == 11){
                hide.location.href="/inc/codechecker.asp?cnumber="+str;
            }
            else { 
              alert("사업자번호는 10자리입니다.");
            }
          }

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
	                    document.getElementById("UserAdd1").value = '';
	                }
	
	                // 선택된 우편번호와 주소 정보를 input 박스에 넣는다.
	                document.getElementById('zipp_code_id').value = data.zonecode;
	                document.getElementById("UserAdd1").value = addr;
	                document.getElementById("UserAdd1").value += extraAddr;
	                document.getElementById("UserAdd2").focus(); // 우편번호 + 주소 입력이 완료되었음으로 상세주소로 포커스 이동
	            }
	        }).open();
	    }
	</script>
    <!-- Custom styles for this template -->
    <link href="sidebars.css" rel="stylesheet">
    </head>
    <body class="sb-nav-fixed">


<!--#include virtual="/inc/top.asp"-->
<!-- -->        

<!--#include virtual="/inc/left.asp"-->
<!-- -->

            <div id="layoutSidenav_content">
<%
if gubun="" then 
%>            
                <main>
                    <div class="container-fluid px-4">
                        <div class="row justify-content-between">

                            <div class="col-12 mt-4 mb-2 text-end">
<!--modal start -->
                                <!-- Button trigger modal -->
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                                발주사조회
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="exampleModalLabel">발주사 조회</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="customer.asp?listgubun=two&subgubun=two1" name="searchForm">
                                                <div class="input-group">
                                                    <input class="form-control" type="text" placeholder="검색" aria-label="검색" aria-describedby="btnNavbarSearch" name="SearchWord" />
                                                    <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>&nbsp;
                                                    <button type="button" class="btn btn-primary" onClick="location.replace('customer.asp?gubun=insert&listgubun=<%=listgubun%>&subgubun=<%=subgubun%>')">발주사 추가</button>
                                                </div>
                                            </form>

                                        </div>
                  
                                    </div>
                                </div>
                                </div>
                                

                            </div>
                            <div></div>
<!--modal end -->

                        </div>
 
 
<%
SQL=" Select A.cidx, A.cname, A.caddr1, A.caddr2, A.cpost, A.cmidx, A.cdidx, Convert(varchar(10),A.cwdate,121), A.cnumber "
'SQL=SQL&" , B.mname, C.mname "
SQL=SQL&" From tk_customer A "
'SQL=SQL&" Left Outer Join tk_member B On A.cmidx=B.midx"
'SQL=SQL&" Left Outer Join tk_member C On A.cdidx=B.midx"
If SearchWord<>"" Then 
SQL=SQL&" Where (A.cname  like '%"&request("SearchWord")&"%' or A.caddr1  like '%"&request("SearchWord")&"%' or A.caddr2  like '%"&request("SearchWord")&"%' )"
End If 
SQL=SQL&" Order by A.cwdate desc "
'response.write (SQL)
	Rs.open Sql,Dbcon,1,1,1
	Rs.PageSize = 8

	if not (Rs.EOF or Rs.BOF ) then
	no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
	totalpage=Rs.PageCount '		
	Rs.AbsolutePage =gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if
	bgcolor="#FFFFFF"
	tempValue=i mod 2
	if tempvalue=1 then bgcolor="#F5F5F5"

  cidx=Rs(0)
  cname=Rs(1)
  caddr1=Rs(2)
  caddr2=Rs(3)
  cpost=Rs(4)
  cmidx=Rs(5)
  cdidx=Rs(6)
  cwdate=Rs(7)
  cnumber=Rs(8)

SQL=" select mname, mpos From tk_member where cidx='"&cdidx&"' "
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
  imname=Rs1(0)
  impos=Rs1(1)
End if
Rs1.Close
%>
                        <div class="card mb-4">
                            <div class="card-body">
                            <button type="button" class="btn btn-outline-success"><%=cname%></button>
                            <!--<h6 class="border-bottom pb-2 "><strong><%=cname%></strong></h6>-->
                                <div class="row  row-cols-1 row-cols-sm-1 row-cols-md-2 g-3 mb-2">
                                    <div class="col-md-2"><b>사업자번호</b>&nbsp;<%=cnumber%></div>
                                    <div class="col-md-10"><b>주소</b>&nbsp;(<%=cpost%>)<%=caddr1%>&nbsp;<%=caddr2%></div>
                                </div>
                                <div class="row  row-cols-2 row-cols-sm-4 row-cols-md-4 g-3 mb-2">
                                    <div class="col-md-2"><b>내부담당자</b>&nbsp;<%=imname%><%=impos%></div>
                                    <div class="col-md-2"><b>등록일</b>&nbsp;<%=cwdate%></div>
                                </div>
<%
SQL=" Select mname, mpos, mtel, mhp, mfax, memail, Convert(varchar(10),mwdate,121) " 
SQL=SQL&" From tk_member "
SQL=SQL&" Where cidx='"&cidx&"' "
'response.write (SQL)&"<br><br>"
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do while not Rs1.EOF
  mname=Rs1(0)
  mpos=Rs1(1)
  mtel=Rs1(2)
  mhp=Rs1(3)
  mfax=Rs1(4)
  memail=Rs1(5)
  mwdate=Rs1(6)
%>                                
                                <div class="row  row-cols-1 row-cols-sm-4 row-cols-md-6 g-3 mb-2">
                                    <div class="col-sm-2"><b>발주사담당</b>&nbsp;<%=mname%><%=mpos%></div>
                                    <div class="col-sm-2"><b>전화</b>&nbsp;<%=mtel%></div>
                                    <div class="col-sm-2"><b>휴대폰</b>&nbsp;<%=mhp%></div>
                                    <div class="col-sm-2"><b>팩스</b>&nbsp;<%=mfax%></div>
                                    <div class="col-sm-4"><b>이메일</b>&nbsp;<%=memail%></div>
                                </div>
<%
Rs1.movenext
Loop
End if
Rs1.close
%>     
                                <div class="row  row-cols-2 row-cols-sm-4 row-cols-md-1 g-3 mb-2">
                                    <div class="col">
                                      <button type="button" class="btn btn-danger" Onclick="location.replace('order.asp?gubun=add&cidx=<%=cidx%>');">신규견적</button>
                                    </div>
                                </div>                           
                            </div>
                        </div>
<%
			Rs.MoveNext 
			i=i+1
			Next 
 
%>
                    <div class="row">
                      <div  class="col-12 py-3"> 
<!--#include Virtual = "/inc/paging.asp" -->
                      </div>
                    </div>
<%
    Else
      Response.write "<script>alert('조회 결과가 없어 신규등록 화면으로 이동합니다.');location.replace('customer.asp?gubun=insert');</script>"
		End If   
    Rs.Close
 
%> 
                    </div>

                </main>
 
<%
elseif gubun="insert" then 
%> 

                <main>
                    <div class="container-fluid px-4 mt-4 mb-2"> 
                        <div class="card mb-4"> 
                            <div class="card-body">
          

                              <div class="row mt-2">
<form name="frmMain" action="customer.asp" method="post"  >	
<input type="hidden" name="ep_check" value="<%=Request("ep_check")%>">
<input type="hidden" name="gubun" value="input">
<iframe name="hide" width="0" height="0" href="about:blank" border="0"></iframe>
                                <div class="row">
                                  <div class="col-md-4 mb-3">
                                    <label for="name">발주사</label>
                                    <input type="text" class="form-control" id="cname" name="cname" placeholder="" value="" required>
                                    <div class="invalid-feedback">
                                      이름을 입력해주세요.
                                    </div>
                                  </div>
                                  <div class="col-md-2 mb-3">
                                    <label for="name">사업자번호</label>
                                    <input type="number" class="form-control" id="cnumber" name="cnumber" placeholder="" value="" required>
                                    <div class="invalid-feedback">
                                      사업자번호를 입력해주세요.
                                    </div>
                                  </div>
                                
                                  <div class="col-md-2 mb-3">
                                    <label for="name">&nbsp;</label>
                                    
                                    <button type="button" class="form-control btn btn-primary" onclick="checker();">중복확인</button>
                                    <div class="invalid-feedback">
                                      이름을 입력해주세요.
                                    </div>
                                  </div>


                                  <div class="col-md-4 mb-3">
                                    <label for="name">내부담당자</label>
                                    <select name="cdidx" class="form-control" id="root" required>
                                      <option value="1" <% if cdidx="0" Then %>selected<% end if %>>이양희</option>
                                      <option value="2" <% if cdidx="2" Then %>selected<% end if %>>안선호</option>
                                      <option value="3" <% if cdidx="3" Then %>selected<% end if %>>김호영</option>
                                    </select>	
                                    <div class="invalid-feedback">
                                      이름을 입력해주세요.
                                    </div>
                                  </div>
                                </div>

                                <div class="row">
                                  <div class="col-md-4">
                                    <input type="button" id="zipp_btn" class="btn btn-primary" onclick="execDaumPostcode()" value="우편번호 찾기">
                                    <input type="text" class="form-control" id="zipp_code_id"  name="cpost" maxlength="10" placeholder="" style="width: 50%; display: inline;" readonly>
                                    <div class="invalid-feedback">
                                      우편번호를 입력하세요.
                                    </div>
                                  </div>
                      
                                </div>
                                <div class="row">
                                  <div class="col-md-5">
                                    <label for="address" class="form-label">주소</label>
                                    <input type="text" class="form-control" name="caddr1" id="UserAdd1" maxlength="40" placeholder="기본 주소를 입력하세요" required readonly>
                                    <div class="invalid-feedback">
                                      우편번호 검색을 통해 주소를 입력하세요.
                                    </div>
                                  </div>

                                  <div class="col-md-5">
                                    <label for="address2" class="form-label">상세주소 <span class="text-muted"></span></label>
                                    <input type="text" class="form-control" name="caddr2" id="UserAdd2" maxlength="40" placeholder="상세 주소를 입력하세요">
                                  </div>
                                </div>  

                                <div class="row">
                                  <div class="col-md-4 mb-3">
                                    <label for="name">담당자이름</label>
                                    <input type="text" class="form-control" id="mname" name="mname" placeholder="" value="" required>
                                    <div class="invalid-feedback">
                                      이름을 입력해주세요.
                                    </div>
                                  </div>
                                  <div class="col-md-4 mb-3">
                                    <label for="name">직책</label>
                                    <input type="text" class="form-control" id="mpos" name="mpos" placeholder="" value="" required>
                                    <div class="invalid-feedback">
                                      직책을 입력해주세요.
                                    </div>
                                  </div>
                                  <div class="col-md-4 mb-3">
                                    <label for="email">이메일</label>
                                    <input type="email" class="form-control" id="memail" name="memail" placeholder="" value="" required>
                                    <div class="invalid-feedback">
                                      이메일을 입력해주세요.
                                    </div>
                                  </div>
                                </div>
                                <div class="row">
                                  <div class="col-md-4 mb-3">
                                    <label for="nickname">전화번호</label>
                                    <input type="tel" class="form-control" onkeyup="inputPhoneNumber(this);" id="mtel" name="mtel"  maxlength="13" placeholder="숫자만입력" required>
                                    <div class="invalid-feedback">
                                      전화번호를 입력해주세요.
                                    </div>
                                  </div>
                                  <div class="col-md-4 mb-3">
                                    <label for="nickname">휴대폰</label>
                                    <input type="tel" class="form-control" onkeyup="inputPhoneNumber(this);" id="mhp" name="mhp"  maxlength="13" placeholder="숫자만입력" required>
                                    <div class="invalid-feedback">
                                      휴대폰번호를 입력해주세요.
                                    </div>
                                  </div>
                                  <div class="col-md-4 mb-3">
                                    <label for="nickname">팩스</label>
                                    <input type="tel" class="form-control" onkeyup="inputPhoneNumber(this);" id="mfax" name="mfax"  maxlength="13" placeholder="숫자만입력" required>
                                    <div class="invalid-feedback">
                                      팩스번호를 입력해주세요.
                                    </div>
                                  </div>


                                </div>
                      

                                <div class="row text-center">
                                  <div class="col-md-12 mb-3">
                                    <button class="btn btn-primary"  type="submit" >저장</button>
                                  </div>
                                </div>
    
</form>

                              </div>

                            </div>
                        </div>
                    </div>
                </main>  
                          
<%
end if
%>
<!-- footer 시작 -->                
 
<!-- footer 끝 --> 
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
        <script src="assets/demo/chart-area-demo.js"></script>
        <script src="assets/demo/chart-bar-demo.js"></script>
<!--
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
        <script src="js/datatables-simple-demo.js"></script>
-->
    </body>
</html>
<%
if gubun="input" then 
cname=Request("cname")
cnumber=Request("cnumber")
cdidx=Request("cdidx")
cpost=Request("cpost")
caddr1=Request("caddr1")
caddr2=Request("caddr2")

mname=Request("mname")
mpos=Request("mpos")
mtel=Request("mtel")
mhp=Request("mhp")
mfax=Request("mfax")
memail=Request("memail") 
 
response.write cname&"<br>"
response.write cnumber&"<br>"
response.write cdidx&"<br>"
response.write cpost&"<br>"
response.write caddr1&"<br>"
response.write caddr2&"<br>"
response.write mname&"<br>"
response.write mpos&"<br>"
response.write mtel&"<br>"
response.write mhp&"<br>"
response.write mfax&"<br>"
response.write memail&"<br>"

SQL=" Insert into tk_customer (cname, cnumber, caddr1, caddr2, cpost, cdidx, cwdate) "
SQL=SQL&" Values ('"&cname&"', '"&cnumber&"', '"&caddr1&"', '"&caddr2&"', '"&cpost&"', '"&cdidx&"', getdate())"
'response.write (SQL)&"<br><br>"
'response.end
Dbcon.Execute (SQL)	

SQL=" Select cidx From tk_customer Where cnumber='"&cnumber&"' "
Rs.Open sql, dbCon	,1,1,1	
	if not (Rs.EOF or Rs.BOF ) then
    cidx=rs(0)

    SQL=" Insert into tk_member (mname, mpos, mtel, mhp, mfax, memail, mwdate, cidx) "
    SQL=SQL&" Values ('"&mname&"', '"&mpos&"', '"&mtel&"', '"&mhp&"', '"&mfax&"', '"&memail&"', getdate(), '"&cidx&"') "
    'response.write (SQL)&"<br><br>"
    'response.end
    Dbcon.Execute (SQL)	
    response.write "<script>location.replace('customer.asp');</script>"
  End if
Rs.Close


end if 
%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
