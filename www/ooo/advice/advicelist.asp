<!-- 

[aidx] 사용자 기본키
[acidx] 거래처
[acheeorigubun] 상담처리구분(대기0,완료1,전달2)
[aform] 상담형태(견적1,배송2,,부자재관련3.결재4, 내역서5, 성적서6, 기타7)
[agubun]  상담구분(in 1, out2)
[aclaim] 클레임(유1,무2)
[aname] 입력자
[adate] 입력일
[adetails] 상담내용
[acheoriname] 처리자
[acheoridate] 처리일
[acheorimemo] 처리내용
    
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
   
    listgubun="two"   '왼쪽 메뉴 열림 설정을 위한 변수 저장
    projectname="상담일지"  '화면 좌측 상당에 화면의 제목
    developername="오소리"  '화면 하단에 개발자 닉네임 표시
    hoyoung="6" '거래처 정보의 메뉴바 선택여부 표시


SearchWord=Request("SearchWord")
gubun=Request("gubun")
cidx=Request("cidx")

   if request("gotopage")="" then
    gotopage=1
   else
    gotopage=request("gotopage")
   end if

   
   page_name="advicelist.asp?cidx="&cidx&"&listgubun="&listgubun&"&"


%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title><%=projectname%></title>
    <link rel="icon" sizes="image/x-icon" href="/inc/tkico.png">
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
       <div class="row justify-content-between py-3 ">
<!-- 거래처 기본정보 include 시작 --> 
<!--#include virtual="/cyj/cinc2.asp"-->
<!-- 거래처 기본정보 include 끝 --> 
<!-- 내용 입력 시작 -->  
<div class="container py-1 text-center">
    <div class="input-group mb-2">
        <div class="col-12 text-end mb-2">

            <button type="button" class="btn btn-outline-danger" Onclick="window.open('advice.asp?cidx=<%=cidx%>','oes','top=50,left=200 ,width=800,height=900');">신규상담등록</button>
        </div>

        <div class="card mb-4 card-body">


                                <table id="datatablesSimple"  class="table table-bordered">
<!--
                                    <tbody>
                                        <tr>
                                            <td align="center" class="bg-secondary text-white">상담내용</td>
                                            <td align="center" class="bg-secondary text-white">작성</td>
                                            <td align="center" class="bg-secondary text-white">비고</td>
                                            <td align="center" class="bg-secondary text-white">작성자</td>
                                            <td align="center" class="bg-secondary text-white">관리</td>

                                        </tr>
                                    </tbody>
-->
                                    <tbody>
<%

SQL=" select A.aidx, A.acidx, A.aform ,A.agubun, A.aclaim, A.adetails, A.acheorigubun, A.aname, A.adate, A.acheoriname, A.acheoridate, A.acheorimemo "
SQL=SQL&" , B.mname, D.mname, C.cname "
SQL=SQL&" From Tk_advice A"
SQL=SQL&" Join tk_member B On A.aname=B.midx "
SQL=SQL&" Join tk_customer C on A.acidx=C.cidx "
SQL=SQL&" Left Outer Join tk_member D On A.acheoriname=D.midx "
SQL=SQL&" Where A.acidx='"&cidx&"'and A.astatus=1" 
If Request("SearchWord")<>"" Then
SQL=SQL&" and (A.adetails like '%"&request("SearchWord")&"%' or B.mname like '%"&request("SearchWord")&"%'   or C.mname like '%"&request("SearchWord")&"%') "
End If
SQL=SQL&" Order by A.aidx desc "
'response.write (SQL)&"<br>"
Rs.open SQL,Dbcon,1,1,1
Rs.PageSize = 10                     

if not (Rs.EOF or Rs.BOF ) then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) +1
totalpage=Rs.PageCount
Rs.AbsolutePage =gotopage
i=1
for j=i to Rs.RecordCount
if i>Rs.PageSize then exit for end if
if no=j-0 then exit for end if

aidx=Rs(0)
acidx=Rs(1)
aform=Rs(2)
agubun=Rs(3)
aclaim=Rs(4)
adetails=Rs(5)
acheorigubun=Rs(6)
aname=Rs(7)
adate=Rs(8)
acheoriname=Rs(9)
acheoridate=Rs(10)
acheorimemo=Rs(11)
mname=RS(12)
bmname=Rs(13)
cname=Rs(14)
if adetails<>"" then 
    adetails=replace(adetails,chr(13) & chr(10),"<br>") 
end if
if acheorimemo<>"" then 
    acheorimemo=replace(acheorimemo,chr(13) & chr(10),"<br>") 
end if

select case aform
case "1"
    aform_text="견적"
case "2"
    aform_text="배송"
case "3"
    aform_text="부자재관련"
case "4"
    aform_text="결재"
case "5"
    aform_text="내역서"
case "6"
    aform_text="성적서"
case "7"
    aform_text="기타"
end select 

select case agubun
case "0"
    agubun_text="고객->회사"
case "1"
    agubun_text="회사->고객"
end select 

select case aclaim
case "1"
    aclaim_text="유"
case "2"
    aclaim_text="무"
end select 

select case acheorigubun
case "0"
    acheorigubun_text="대기"
case "1"
    acheorigubun_text="완료"
case "2"
    acheorigubun_text="전달"
end select 
%>
<a name="<%=aidx%>">
					<tr>
						<td width="100" align="center" class="bg-light"><b>구분</b></td>
						<td width="140" align="center" class="bg-light"><%=aform_text%></td>
						<td rowspan="5"><%=adetails%><% If acheorimemo<>"" Then %><br><br><font color="red">[처리결과]</font><br><br><%=acheorimemo%><% End If %></td>
						<td rowspan="5"><%=mname%><% If bmname<>"" Then %><br><font color="red">(<%=bmname%>)</font><% End If %></td>
						<td rowspan="5" align="center">
                          
                            <button type="button" class="btn btn-primary" Onclick="window.open('adviceudt.asp?cidx=<%=cidx%>&aidx=<%=aidx%>','oes','top=50,left=200 ,width=800,height=900');">수정</button>
 
						</td>
					</tr>
					<tr>
						<td align="center" class="bg-light"><b>상담구분</b></td>
						<td align="center" class="bg-light"><%=agubun_text%>/<%=aclaim_text%></td>
					</tr>
					<tr>
						<td align="center" class="bg-light"><b>상태</b></td>
						<td align="center" class="bg-light"><%=acheorigubun_text%></td>
					</tr>
					<tr>
						<td align="center" class="bg-light"><b>등록일</b></td>
						<td align="center" class="bg-light">
                            <%=year(adate)%>년&nbsp;<%=month(adate)%>월&nbsp;<%=day(adate)%>일<br>
                            <%=hour(adate)%>시&nbsp;<%=Minute(adate)%>분
                        </td>
					</tr>
					<tr>
						<td align="center" class="bg-light"><b>처리일</b></td>
						<td align="center" class="bg-light">
                        <%=year(acheoridate)%>년&nbsp;<%=month(acheoridate)%>월&nbsp;<%=day(acheoridate)%>일<br>
                        <%=hour(acheoridate)%>시&nbsp;<%=Minute(acheoridate)%>분
                        </td>
					</tr>
                    <tr>
                        <td colspan="5"></td>
                    </tr>
<%

aform_text=""
agubun_text=""
aclaim_text=""
acheorigubun_text=""
 
    rs.MoveNext 
    i=i+1
    next
    end If
	'
%>
                                    </tbody>
                                </table>

        </div>
        <div class="row col-12 py-3">
        <!--#include Virtual = "/inc/paging1.asp"-->
        </div>
<%
Rs.Close
%>
<!-- 케빈 끝  -->
    </div> 
</div>  








<!-- 내용입력 끝 -->
</div>
       </div>
     
      
    </main>                          

    
    <!-- footer 시작 -->    
     
    Coded By <%=developername%>
     
    <!-- footer 끝 --> 
               
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

