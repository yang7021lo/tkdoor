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
    [ctel]     대표번호
    [cfax]     팩스번호
    [ctel1]    전화번호2
  
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

    If c_midx="" then 
    Response.write "<script>alert('로그인 하세요.');location.replace('/index.asp');</script>"
    End If

    listgubun="one"
    projectname="업체별담당자"
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
    <!--#include virtual="/inc/left_cyj.asp"-->
    
    
    <div id="layoutSidenav_content">            
    <main>
      <div class="container-fluid px-4">
       <div class="row justify-content-between py-3 ">
<!-- 거래처 기본정보 include 시작 --> 
<!--#include virtual="/cyj/cinc2.asp"-->
<!-- 거래처 기본정보 include 끝 --> 

<!--화면시작-->

        <div class="row">
            <div class="col-10">&nbsp;
            </div>
            <div class="col-2 text-end ">
                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('mem.asp?cidx=<%=cidx%>');">사용자등록</button>    
            </div>
        </div>
        <div class="row mb-2 px-3 py-4">
<!-- 회원 정보 시작 -->
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">회사</th>
                      <th align="center">이름</th>
                      <th align="center">직책</th>
                      <th align="center">전화번호</th>
                      <th align="center">핸드폰</th>
                      <th align="center">팩스</th>
                      <th align="center">메일</th>
                      <th align="center">등록일</th>  
                      <th align="center">수정자</th>  
                      <th align="center">수정일</th>  
                      <th align="center">관리</th> 
                      <th align="center">자재발주</th> 
                  </tr>
              </thead>
              <tbody>
<%
SQL=" Select B.cidx, B.cname , A.midx, A.mname, A.mpos, A.mtel, A.mhp, A.mfax, A.memail, Convert(varchar(10),A.mwdate,121) "
SQL=SQL&" , Convert(varchar(10),A.udate,121), C.mname "
SQL=SQL&" from tk_member A "
SQL=SQL&" Join tk_customer B On A.cidx=B.cidx "
SQL=SQL&" Left Outer Join tk_member C On A.midx=C.midx "
SQL=SQL&" Where A.cidx='"&cidx&"'  "
SQL=SQL&" Order by A.mwdate DESC "
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 5                     

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) +1
totalpage=Rs.PageCount
Rs.AbsolutePage =gotopage
i=1
for j=i to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no=j-0 then exit for end if

cidx=Rs(0)
cname=Rs(1)
midx=Rs(2)
mname=Rs(3)
mpos=Rs(4)
mtel=Rs(5)
mhp=Rs(6)
mfax=Rs(7)
memail=Rs(8)
mwdate=Rs(9)
udate=Rs(10)
cmname=Rs(11)
%>


                  <tr>
                      <td><%=no-j%></td>
                      <td><%=cname%></td>
                      <td><%=mname%></td>
                      <td><%=mpos%></td>
                      <td><%=mtel%></td>
                      <td><%=mhp%></td>
                      <td><%=mfax%></td>
                      <td><%=memail%></td>
                      <td><%=mwdate%></td>
                      <td><%=cmname%></td>
                      <td><%=udate%></td>
                      <td><button type="button" class="btn btn-primary" onClick="location.replace('memview.asp?cidx=<%=cidx%>&midx=<%=midx%>')">관리</button></td>
                      <td><button type="button" class="btn btn-primary" onClick="alert('자재발주를 등록하시겠습니까?');location.replace('/khy/korderdb.asp?kcidx=<%=cidx%>&kmidx=<%=midx%>')">자재발주</button></td>
                  </tr>
<%
    Rs.MoveNext
    Next
    End If
    Rs.Close
%>
              </tbody>
          </table>
<!-- 회원 정보 끝 -->
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

