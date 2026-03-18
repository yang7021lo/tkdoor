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
    추가
    [ctel]     전화번호 
    [ctel2]    전화번호2
    [cfax]     팩스번호
    [cridx]    작성자
    [cudtidx]  수정자

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
projectname="거래처 목록"
    developername="기리"
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


if request("rcstatus")="" then
rcstatus=1
else
rcstatus=request("rcstatus")
end if

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="corpsetting.asp?SearchWord="&SearchWord&"&"


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
 
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_cyj.asp"-->

<div id="layoutSidenav_content">            
<main>
  <div class="container-fluid px-4">
   <div class="row justify-content-between">
<!--화면시작-->
<!-- 버튼 형식 시작--> 
    <div class="row mt-3 mb-1">
        <div class="col-10">&nbsp; 
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" >검색</button>
        </div>
       
    </div>

                        <div class="text-end mb-1">
                            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>

                                    <div class="modal-body">  
                                        <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="corpsetting.asp"name="form1">
                                            <div class="mb-3">
                                                <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord">
                                            </div>

                                            <div class="col-12">
                                                <button type="button" class="btn btn-primary" Onclick="submit();">검색</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            </div>
                        </div>
<!-- 버튼 형식 끝--> 
<!-- 표 형식 시작--> 
 
        <div class="input-group mb-3">
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th class="text-start">번호</th>
                        <th class="text-start">거래여부</th>
                        <th class="text-start">회사명</th>
                        <th class="text-start">업체구분</th>
                        <th class="text-start">도어등급</th>
                        <th class="text-start">프레임등급</th>
                        <th class="text-start">자동문등급</th>
                        <th class="text-start">보호대등급</th>
                        <th class="text-start">시스템등급</th>
                        <th class="text-start">수정자</th>
                        <th class="text-start">수정일시</th>
                        <th class="text-start">관리</th>
                    </tr>
                </thead>
  <tbody>
<%
SQL=" Select A.cidx, A.cstatus, A.cname, A.cgubun,  A.cdlevel, A.cflevel, A.calevel,  A.cslevel, A.csylevel, B.mname "
SQL=SQL&" From tk_customer A "
SQL=SQL&" left outer Join tk_member B On A.cmidx=B.midx "
SQL=SQL&" where A.cstatus='"&rcstatus&"' "
if Request("SearchWord")<>"" then  
SQL=SQL&" and A.cname like '%"&Request("SearchWord")&"%' or A.cnumber like '%"&Request("SearchWord")&"%' or A.cceo like '%"&Request("SearchWord")&"%' "
SQl=SQL&" or  A.cmemo like '%"&Request("SearchWord")&"%' or  A.caddr1 like '%"&Request("SearchWord")&"%' "
End if


SQL=SQL&"  Order by A.cwdate desc "

'Response.write (SQL)
	Rs.open Sql,Dbcon,1,1,1
	Rs.PageSize = 15

	if not (Rs.EOF or Rs.BOF ) then
	no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
	totalpage=Rs.PageCount '		
	Rs.AbsolutePage =gotopage
	i=1
	for j=1 to Rs.RecordCount 
	if i>Rs.PageSize then exit for end if
	if no-j=0 then exit for end if


cidx=Rs(0)
cstatus=Rs(1)
  select case cstatus
    case "0"
      cstatus_text="미사용"
    case "1"
      cstatus_text="사용"
  end select
cname=Rs(2)
cgubun=Rs(3)

cdlevel=Rs(4)
cflevel=Rs(5)
  
calevel=Rs(6)
  
cslevel=Rs(7)
  
csylevel=Rs(8)
  
mname=Rs(9)

if cmemo<>"" then cmemo=replace(cmemo, chr(13)&chr(10),"<br>")
%>              
<form name="corpset" action="corpsettingdb.asp" method="post" >
    <input type="hidden" name="cidx" value="<%=cidx%>">
    <input type="hidden" name="gotopage" value="<%=gotopage%>">
                  <tr>
                      <td class="text-center"><%=no-j%></td>
                      <td><%=cstatus_text%></td>
                      <td><a title="<%=cmemo%>"><%=cname%></a><br><small class="text-secondary"><%=cnumtext%></small></td>
                            
                            <!-- CIDX와 등급을 조인하여 cdlevel, cflevel, calevel, cslevel, csylevel를 cidx에 맞는 수치를 불러올 수 있게 명령 구성 필요 -->
                            <!-- IIF가 현재 cidx와 일치하는 등급에 selected를 부여하여, 기존 저장된 데이터를 불러옴 -->
                            <td>
                                <select name="cgubun" class="form-select form-select-sm">
                                <option value="0" <%If cgubun="0" then Response.write "selected" end if %>>--선택--</option>
                                <option value="1" <%If cgubun="1" then Response.write "selected" end if %>>강화도어</option>
                                <option value="2" <%If cgubun="2" then Response.write "selected" end if %>>부속</option>
                                <option value="3" <%If cgubun="3" then Response.write "selected" end if %>>자동문</option>
                                <option value="4" <%If cgubun="4" then Response.write "selected" end if %>>창호,절곡</option>
                                <option value="5" <%If cgubun="5" then Response.write "selected" end if %>>프레임만</option>
                                <option value="6" <%If cgubun="6" then Response.write "selected" end if %>>소비자</option>
                                <option value="7" <%If cgubun="7" then Response.write "selected" end if %>>소송중</option>
                                <option value="8" <%If cgubun="8" then Response.write "selected" end if %>>거래처의거래처</option>
                                </select>
                            </td>
                            
                            
                            <!-- 도어등급 -->
                            <td>
                                <select name="cdlevel" class="form-select form-select-sm">
                                <option value="0" <%If cdlevel="0" then Response.write "selected" end if %>>--선택--</option>
                                <option value="1" <%If cdlevel="1" then Response.write "selected" end if %>>10만(기본)</option>
                                <option value="2" <%If cdlevel="2" then Response.write "selected" end if %>>9만</option>
                                <option value="3" <%If cdlevel="3" then Response.write "selected" end if %>>11만</option>
                                <option value="4" <%If cdlevel="4" then Response.write "selected" end if %>>12만</option>
                                <option value="5" <%If cdlevel="5" then Response.write "selected" end if %>>소비자</option>
                                <option value="6" <%If cdlevel="6" then Response.write "selected" end if %>>1000*2400</option>
                                </select>
                            </td>

                            <!-- 프레임등급 -->
                            <td>
                                <select name="cflevel" class="form-select form-select-sm">
                                <option value="0" <%If cflevel="0" then Response.write "selected" end if %>>--선택--</option>
                                <option value="1" <%If cflevel="1" then Response.write "selected" end if %>>A</option>
                                <option value="2" <%If cflevel="2" then Response.write "selected" end if %>>B</option>
                                <option value="3" <%If cflevel="3" then Response.write "selected" end if %>>C</option>
                                <option value="4" <%If cflevel="4" then Response.write "selected" end if %>>D</option>
                                <option value="5" <%If cflevel="5" then Response.write "selected" end if %>>E</option>
                                </select>
                            </td>

                            <!-- 자동문등급 -->
                            <td>
                                <select name="calevel" class="form-select form-select-sm">
                                <option value="0" <%If calevel="0" then Response.write "selected" end if %>>--선택--</option>
                                <option value="1" <%If calevel="1" then Response.write "selected" end if %>>TK 2S+</option>
                                <option value="2" <%If calevel="2" then Response.write "selected" end if %>>TK 1S</option>
                                <option value="3" <%If calevel="3" then Response.write "selected" end if %>>소비자</option>
                                <option value="4" <%If calevel="4" then Response.write "selected" end if %>>D</option>
                                <option value="5" <%If calevel="5" then Response.write "selected" end if %>>E</option>
                                </select>
                            </td>

                            <!-- 보호대등급 -->
                            <td>
                                <select name="cslevel" class="form-select form-select-sm">
                                <option value="0" <%If cslevel="0" then Response.write "selected" end if %>>--선택--</option>
                                <option value="1" <%If cslevel="1" then Response.write "selected" end if %>>4500</option>
                                <option value="2" <%If cslevel="2" then Response.write "selected" end if %>>5000</option>
                                <option value="3" <%If cslevel="3" then Response.write "selected" end if %>>5500</option>
                                <option value="4" <%If cslevel="4" then Response.write "selected" end if %>>소비자</option>
                                <option value="5" <%If cslevel="5" then Response.write "selected" end if %>>4100</option>
                                </select>
                            </td>

                            <!-- 시스템등급 -->
                            <td>
                                <select name="csylevel" class="form-select form-select-sm">
                                <option value="0" <%If csylevel="0" then Response.write "selected" end if %>>--선택--</option>
                                <option value="1" <%If csylevel="1" then Response.write "selected" end if %>>강화도어</option>
                                <option value="2" <%If csylevel="2" then Response.write "selected" end if %>>공업사</option>
                                <option value="3" <%If csylevel="3" then Response.write "selected" end if %>>C</option>
                                <option value="4" <%If csylevel="4" then Response.write "selected" end if %>>D</option>
                                <option value="5" <%If csylevel="5" then Response.write "selected" end if %>>강화도어2400</option>
                                </select>
                            </td>
                    <td></td>
                    <td></td>
                      <td><button type="button" class="btn btn-primary" onClick="submit();">저장</button></td>
                  </tr>
</form>
<%
  cstatus_text=""
  ctkidx_text=""
  cgubun_text=""
  cmove_text=""

Rs.MoveNext
i=i+1
Next
End if
%>
              </tbody>
          </table>
        </div>
    
        <div class="row col-12 py-3">
<!--#include virtual="/inc/paging1.asp"-->
        </div>
<%
Rs.Close
%>

            <div class="col-12 text-end">
                Coded By <%=developername%>
            </div>
<!--화면종료-->
   </div>
</div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
</main>
</div> 
    </body>
</html>

<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
