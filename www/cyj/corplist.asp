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
	page_name="corplist.asp?SearchWord="&SearchWord&"&"


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
            <button type="button" class="btn btn-success" Onclick="location.replace('corplist.asp?odr=1');">업체명순</button>  
            <button type="button" class="btn btn-success" Onclick="location.replace('corplist.asp?odr=2');">등록순</button>
            <button type="button" class="btn btn-danger" Onclick="location.replace('corplist.asp?rcstatus=0');">미사용</button>  

        </div>
        <div class="col-2 text-end">
          <button type="button" class="btn btn-success" Onclick="location.replace('corp.asp');">신규등록</button>  
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
                        <th class="text-start">대표자</th>
                        <th class="text-start">대표번호</th>
                        <th class="text-start">팩스</th>
                        <th class="text-start">사업장</th>
                        <th class="text-start">주소</th>
                        <th class="text-start">등록자</th>
                        <th class="text-start">관리</th>  
                        <th class="text-start">수주</th>  
                    </tr>
                </thead>
  <tbody>
<%
SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnumber,B.mname "
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
	Rs.PageSize = 10

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
cceo=Rs(3)
ctkidx=Rs(4)
  If ctkidx="1" then 
    ctkidx_text="태광도어"
  Elseif ctkidx="2" then 
    ctkidx_text="티엔지단열프레임"
  Elseif ctkidx="3" then
    ctkidx_text="태광인텍"
  End If 

caddr1=Rs(5)
cmemo=Rs(6)
cwdate=Rs(7)
ctel=Rs(8)
cfax=Rs(9)
cnumber=Rs(10)
cnumtext=Left(cnumber,3)&"-"&Mid(cnumber,4,2)&"-"&Right(cnumber,5)
mname=Rs(11)

if cmemo<>"" then cmemo=replace(cmemo, chr(13)&chr(10),"<br>")
%>              
                  <tr>
                      <td class="text-center"><%=no-j%></td>
                      <td><%=cstatus_text%></td>
                      <td><a title="<%=cmemo%>"><%=cname%></a><br><small class="text-secondary"><%=cnumtext%></small></td>
                      <td><%=cceo%></td>
                      <td><%=ctel%></td>
                      <td><%=cfax%></td>
                      <td><%=ctkidx_text%></td>
                      <td><%=caddr1%>&nbsp;<%=caddr2%></td>
                      <td><%=mname%></td>
                      <td><button type="button" class="btn btn-primary" onClick="location.replace('corpview.asp?cidx=<%=cidx%>')">보기</button></td>
                        <td><button type="button" class="btn btn-warning" onClick="location.replace('/lyh/sujuin.asp?cidx=<%=cidx%>')">선택</button></td>
                  </tr>

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
