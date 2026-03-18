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
subgubun="one1"
projectname="발주현황"

%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")


	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"

gubun=Request("gubun")
doc_type=Request("doc_type")
oidx=REquest("oidx")
if doc_type="" then 
  doc_type="e"
end if

Select case doc_type
  case "e"
    doc_type_text="견적서"
  case "o"
    doc_type_text="발주서"
  case "w"
    doc_type_text="작업지시서"
End select

'업무기본 순서
'검측-견적서+발주서(소량의 경우 동시진행 많이함)생성-발주처 컨펌-작업지시서 전송 
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
    <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>



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
                                신규발주
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
                                            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="order.asp?listgubun=two&subgubun=two1" name="searchForm">
                                                <div class="input-group">
                                                    <input class="form-control" type="text" placeholder="검색" aria-label="검색" aria-describedby="btnNavbarSearch" name="SearchWord" />
                                                    <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>&nbsp;
                                                    <button type="button" class="btn btn-primary" onClick="location.replace('customer.asp?gubun=insert')">발주사 추가</button>
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
SQL=" Select A.oidx, A.otitle, B.cname, A.oftype, Convert(Varchar(10),A.odday,121), Convert(varchar(10),A.owdate,121), ostatus "
SQL=SQL&" , C.mname, D.mname "
SQL=SQL&" From tk_order A "
SQL=SQL&" Join tk_customer B On A.cidx=B.cidx "
SQL=SQL&" Join tk_member C On A.omidx=C.midx "
SQL=SQL&" Join tk_member D On A.odidx=D.midx "
SQL=SQL&" Order by A.oidx desc "
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

oidx=Rs(0)
otitle=Rs(1)
cname=Rs(2)
oftype=Rs(3)
Select case oftype
  case "1"
    oftype_text="무방향 외도어 기본"
  case "2"
    oftype_text="무방향 외도어 상부남마"
  case "3"
    oftype_text="무방향 외도어 상부남마 중간소대"
  case "4"
    oftype_text="양개기본본"
  case "5"
    oftype_text="양개 상부남마"
end select
odday=Rs(4)
owdate=Rs(5)
ostatus=Rs(6)
Select case ostatus
  case "0"
    ostatus_text="발주등록"
    class_text="text-primary"
  case "1"
    ostatus_text="단계1"
    class_text="text-secondary"
  case "2"
    ostatus_text="단계2"
    class_text="text-success"
  case "3"
    ostatus_text="단계3"
    class_text="text-danger"
  case "4"
    ostatus_text="단계4"
    class_text="text-warning"
end select
'
mname=Rs(7)
dname=Rs(8)
%> 
<button type="button" class="btn btn-outline-primary" Onclick="location.replace('order.asp?gubun=view&oidx=<%=oidx%>');"><b>주문번호</b>&nbsp;<%=oidx%></button><p>
                        <div class="card mb-4">
                            <div class="card-body">
                            <h6 class="border-bottom pb-2 "><strong><%=otitle%></strong></h6>
                                <div class="row  row-cols-2 row-cols-sm-4 row-cols-md-4 g-3 mb-2">
                                    <div class="col-sm-2"><b>발주사</b>&nbsp;<%=cname%></div>
                                    <div class="col-sm-2"><b>프레임</b>&nbsp;<%=oftype_text%></div>
                                    <div class="col-sm-2"><b>발주일</b>&nbsp;<%=odday%></div>
                                    <div class="col-sm-2"><b>납기일</b>&nbsp;<%=owdate%></div>
                                    <div class="col-sm-2"><b>고객사담당</b>&nbsp;<%=mname%></div>
                                    <div class="col-sm-2"><b>내부담당자</b>&nbsp;<%=dname%></div>
                                    <div class="col-sm-4"><b>진행상태</b>&nbsp;<font class="<%=class_text%>"><%=ostatus_text%></font></div>
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
		End If   
    Rs.Close
%>
                    </div>

                </main>


 
 

<!--

                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">번호</th>
                                            <th align="center">주문명</th>
                                            <th align="center">수량</th>
                                            <th align="center">프레임</th>
                                            <th align="center">발주일</th>
                                            <th align="center">납기일</th>
                                            <th align="center">발주사</th>  
                                            <th align="center">발주사담당</th>
                                            <th align="center">내부담당</th>
                                        </tr>
                                    </thead>

                                    <tbody>
<%

SQL="Select A.otitle, A.cidx, A.oquan, A.ocolor, A.oftype, A.oinsw, A.oinsh, A.odoorw, A.odoorh, A.odoorgw, A.odoorgh, A.ofixgw, A.ofixgh, A.onamma, A.obitg"
SQL=SQL&" , A.onglass1w, A.onglass1h, A.onglass2w, A.onglass2h, A.odoormsg, A.odday, A.odinsh, A.ouprice, A.oeprice"
SQL=SQL&" , A.oboxtop, A.oboxtopq, A.oboxfront, A.oboxfrontq, A.oboxbottom, A.oboxbottomq, A.otopwnam, A.otopwnamq, A.oboxabs, A.oboxabsq, A.oboxcap, A.oboxcapq"
SQL=SQL&" , A.oautohome1, A.oautohome1q, A.oautohome2, A.oautohome2q, A.ojgsd, A.ojgsdq, A.otopjgsd, A.otopjgsdq, A.ohomedead, A.ohomedeadq"
SQL=SQL&" , A.ofixtopbar, A.ofixtopbarq, A.ofixbottomebar, A.ofixbottomebarq, A.ofixosi, A.ofixosiq"
SQL=SQL&" , A.owdate, A.omidx, A.odidx, A.ostatus"
SQL=SQL&" , B.cname, C.mname, D.mname"
SQL=SQL&" From tk_order A"
SQL=SQL&" Join tk_customer B On A.cidx=B.cidx"
SQL=SQL&" Left Outer Join tk_member C On A.omidx=C.midx"
SQL=SQL&" Left Outer Join tk_member D On A.odidx=D.midx"
If SearchWord<>"" Then 
SQL=SQL&"  and (C.mname  like '%"&request("SearchWord")&"%' or D.mname  like '%"&request("SearchWord")&"%' or A.otitle  like '%"&request("SearchWord")&"%' or B.cname like '%"&request("SearchWord")&"%'  )"
End If 

SQL=SQL&" Order by A.owdate desc"
 
'Response.write (SQL)	
'Response.write (SQL)	
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


%>  
                                        <tr>
                                            <td align="center"><%=no-i%></td>
                                            <td align="center"><%=mem_mbrtype_text%></td>
                                            <td><a href="member.asp?gubun=view&listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&s_mem_mbrid=<%=mem_mbrid%>&mem_mbrid=<%=mem_mbrid%>"><% If etc2="1" then %><u><% end if %><%=mem_mbrName%><br><%=mem_f_name%></a></td>
                                            <td><%=mem_Addr2%></td>
                                            <td><%=mem_grade_text%></td>
                                            <td><%=mem_TelNo2%></td>
                                            <td><%=mem_WDate%></td>
                                            <td><%=mem_WDate%></td>
                                            <td><button type="button" class="btn btn-primary" onClick="location.replace('member.asp?gubun=view&listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&s_mem_mbrid=<%=mem_mbrid%>&mem_mbrid=<%=mem_mbrid%>&topcode=<%=topcode%>')">관리</button></td>
                                        </tr>
<%
			Rs.MoveNext 
			i=i+1
			Next 
 
%>
                                    </tbody>
                                </table>
<%
    Rs.Close
			End If    
%>    
-->                   
<%
elseif gubun="add" then 

cidx=Request("cidx")

  if cidx="" then 
  response.write "<script>alert('발주사를 먼저 선택해 주세요.');location.replace('customer.asp');</script>"
  response.end
  end if
%>
                <main>

  <div class="album py-5 bg-light">
    <div class="container">

      <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
        <div class="col">
          <div class="card shadow-sm">
            <img src="img/door/door_001.png" class="card-img-top" alt="..." onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=1');">

            <div class="card-body">
              <p class="card-text">무방향 외도어 기본</p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=1');">선택</button>
                </div>
                <!--<small class="text-muted">9 mins</small>-->
              </div>
            </div>
          </div>
        </div>
        <div class="col">
          <div class="card shadow-sm">
            <img src="img/door/door_002.png" class="card-img-top" alt="..." onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=2');">
            <div class="card-body">
              <p class="card-text">무방향 외도어 상부남마</p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <button type="button" class="btn btn-sm btn-outline-secondary"  onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=2');">선택</button>
                </div>
                <!--<small class="text-muted">9 mins</small>-->
              </div>
            </div>
          </div>
        </div>
        <div class="col">
          <div class="card shadow-sm">
            <img src="img/door/door_003.png" class="card-img-top" alt="..." onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=3');">
            <div class="card-body">
              <p class="card-text">무방향 외도어 상부남마 중간소대</p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=3');">선택</button>
                </div>
                <!--<small class="text-muted">9 mins</small>-->
              </div>
            </div>
          </div>
        </div>

        <div class="col">
          <div class="card shadow-sm">
            <img src="img/door/door_004.png" class="card-img-top" alt="..." onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=4');">
            <div class="card-body">
              <p class="card-text">양개기본</p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=4');">선택</button>
                </div>
                <!--<small class="text-muted">9 mins</small>-->
              </div>
            </div>
          </div>
        </div>
        <div class="col">
          <div class="card shadow-sm">
            <img src="img/door/door_005.png" class="card-img-top" alt="..." onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=5');">
            <div class="card-body">
              <p class="card-text">양개 상부남마</p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.replace('order.asp?gubun=insert&cidx=<%=cidx%>&oftype=5');">선택</button>
                </div>
                <!--<small class="text-muted">9 mins</small>-->
              </div>
            </div>
          </div>
        </div>
        <div class="col">
          <div class="card shadow-sm">
            <svg class="bd-placeholder-img card-img-top" width="100%" height="225" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Placeholder: Thumbnail" preserveAspectRatio="xMidYMid slice" focusable="false"><title>Placeholder</title><rect width="100%" height="100%" fill="#55595c"/><text x="50%" y="50%" fill="#eceeef" dy=".3em">Thumbnail</text></svg>

            <div class="card-body">
              <p class="card-text">대기 </p>
              <div class="d-flex justify-content-between align-items-center">
                <div class="btn-group">
                  <!--<button type="button" class="btn btn-sm btn-outline-secondary">선택</button>-->
                </div>
                <!--<small class="text-muted">9 mins</small>-->
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

                </main> 
<%
elseif gubun="view" then 
oidx=REquest("oidx")
'Response.write oidx&"<br>"

SQL=" Select A.oidx, A.otitle, A.cidx, A.oquan, A.ocolor, A.oftype, A.oinsw, A.oinsh "
SQL=SQL&" , A.odoorw, A.odoorh, A.odoorgw, A.odoorgh, A.ofixgw, A.ofixgh, A.onamma, A.obitg "
SQL=SQL&" , A.onglass1w, A.onglass1h, A.onglass2w, A.onglass2h, A.odoormsg, A.odday, A.odinsh, A.ouprice "
SQL=SQL&" , A.oeprice, A.oboxtop, A.oboxtopq, A.oboxfront, A.oboxfrontq, A.oboxbottom, A.oboxbottomq "
SQL=SQL&" , A.otopwnam, A.otopwnamq, A.oboxabs, A.oboxabsq, A.oboxcap, A.oboxcapq, A.oautohome1, A.oautohome1q "
SQL=SQL&" , A.oautohome2, A.oautohome2q, A.ojgsd, A.ojgsdq, A.ofixtopbar, A.ofixtopbarq "
SQL=SQL&" , A.ofixbottomebar, A.ofixbottomebarq, A.ofixosi, A.ofixosiq "
SQL=SQL&" , A.otopjgsd, A.otopjgsdq, A.ohomedead, A.ohomedeadq, Convert(Varchar(10),A.owdate,121)"
SQL=SQL&" , A.omidx, A.ostatus, A.odidx "
SQL=SQL&" , B.mname, B.mpos, B.mtel, B.mhp, B.mfax, B.memail "
SQL=SQL&" , C.mname, C.mpos, C.mtel, C.mhp, C.mfax, C.memail "
SQL=SQL&" , D.cname, D.cnumber "
SQL=SQL&" From  tk_order A "
SQL=SQL&" Join tk_member B On A.omidx=B.midx "
SQL=SQL&" Join tk_member C On A.odidx=C.midx "
SQL=SQL&" Join tk_customer D On A.cidx=D.cidx "
SQL=SQL&" Where A.oidx='"&oidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  oidx=Rs(0)
  otitle=Rs(1)
  cidx=Rs(2)
  oquan=Rs(3)
  ocolor=Rs(4)
  oftype=Rs(5)
  oinsw=Rs(6)
  oinsh=Rs(7)
  odoorw=Rs(8)
  odoorh=Rs(9)
  odoorgw=Rs(10)
  odoorgh=Rs(11)
  ofixgw=Rs(12)
  ofixgh=Rs(13)
  onamma=Rs(14)
  obitg=Rs(15)
  onglass1w=Rs(16)
  onglass1h=Rs(17)
  onglass2w=Rs(18)
  onglass2h=Rs(19)
  odoormsg=Rs(20)
  odday=Rs(21)
  odinsh=Rs(22)
  ouprice=Rs(23)
  oeprice=Rs(24)
  oboxtop=Rs(25)
  oboxtopq=Rs(26)
  oboxfront=Rs(27)
  oboxfrontq=Rs(28)
  oboxbottom=Rs(29)
  oboxbottomq=Rs(30)
  otopwnam=Rs(31)
  otopwnamq=Rs(32)
  oboxabs=Rs(33)
  oboxabsq=Rs(34)
  oboxcap=Rs(35)
  oboxcapq=Rs(36)
  oautohome1=Rs(37)
  oautohome1q=Rs(38)
  oautohome2=Rs(39)
  oautohome2q=Rs(40)
  ojgsd=Rs(41)
  ojgsdq=Rs(42)
  ofixtopbar=Rs(43)
  ofixtopbarq=Rs(44)
  ofixbottomebar=Rs(45)
  ofixbottomebarq=Rs(46)
  ofixosi=Rs(47)
  ofixosiq=Rs(48)
  otopjgsd=Rs(49)
  otopjgsdq=Rs(50)
  ohomedead=Rs(51)
  ohomedeadq=Rs(52)
  owdate=Rs(53)
  omidx=Rs(54)
  ostatus=Rs(55)
  odidx=Rs(56)

  amname=Rs(57)
  ampos=Rs(58)
  amtel=Rs(59)
  amhp=Rs(60)
  amfax=Rs(61)
  amemail=Rs(62)

  bmname=Rs(63)
  bmpos=Rs(64)
  bmtel=Rs(65)
  bmhp=Rs(66)
  bmfax=Rs(67)
  bmemail=Rs(68)
  
  cname=Rs(69)
  cnumber=Rs(70)

  Select case  ocolor
    case "0"
      ocolor_text="실버"
    case "1"
      ocolor_text="블랙"
    case "2"
      ocolor_text="레드"
  end Select

  Select Case oftype
    Case "1"
      oftype_text="무방향 외도어 기본"
      oftype_img="/tkdoor/img/door/door_001.png"
    Case "2"
      oftype_text="무방향 외도어 상부남마"
      oftype_img="/tkdoor/img/door/door_002.png"
    Case "3"
      oftype_text="무방향 외도어 상부남마 중간소대"
      oftype_img="/tkdoor/img/door/door_003.png"
    Case "4"
      oftype_text="양개기본"
      oftype_img="/tkdoor/img/door/door_004.png"
    Case "5"
      oftype_text="양개 상부남마"
      oftype_img="/tkdoor/img/door/door_005.png"
  End Select

  Select Case onamma
    Case "0"
      onamma_text="없음"
    Case "1"
      onamma_text="있음"
  End Select

  Select Case odoormsg
    Case "0"
      odoormsg_text="해당없음"
    Case "1"
      odoormsg_text="도어별도"
    Case "2"
      odoormsg_text="도어포함"
  End Select

  Select Case ostatus
    Case "0"
      ostatus_text="검측입력"
    Case "1"
      ostatus_text="견적서 및 발주서 전송"
    Case "2"
      ostatus_text="견적서 및 발주서 수락"
    Case "3"
      ostatus_text="작업지시서 전송"
    Case "4"
      ostatus_text="절단작업중"
    Case "5"
      ostatus_text="가공작업중"
    Case "6"
      ostatus_text="조립작업중"
    Case "7"
      ostatus_text="포장중"
    Case "8"
      ostatus_text="배송중"
    Case "9"
      ostatus_text="배송완료"
  End Select


End If
Rs.Close

opensize =fix((oinsw-90-65)/2) '오픈사이즈 : (검측x-90-65)/2
baseboard = oinsw-opensize-90-65 ' 검측x-오픈사이즈-90-65
%>    

<% if doc_type="e" then %>
<main>
  <div class="container-fluid px-4 mt-4 mb-2"> 
    <div class="card mb-4"> 
      <div class="card-body">
        <div class="row text-center">
          <h1><%=doc_type_text%></h1>
        </div>

        <div class="row mt-2">
          <div class="row">
            <h3 class="text-primary"><%=otitle%></h3>
          </div>
          <div class="row">
            <div class="col">&nbsp;</div>
          </div>
          <div class="row">

             <div class="col-md-3 mb-3">
             <label for="cname"><strong>발주처</strong></label>
              <font class="text-secondary"><%=cname%></font>
            </div>
            <div class="col-md-3 mb-3">
            <label for="cname"><strong>사업자번호</strong></label>
              <font class="text-secondary"><%=cnumber%></font>
            </div>
            <div class="col-md-3 mb-3">
            <label for="cname"><strong>담당자</strong></label>
              <font class="text-secondary"><%=amname%>&nbsp;<%=ampos%></font>
            </div>
            
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="cname"><strong>작성일</strong></label>
              <font class="text-secondary"><%=Year(owdate)%>년&nbsp;<%=Month(owdate)%>월&nbsp;<%=Day(owdate)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="cname"><strong>발주일</strong></label>
              <font class="text-secondary"><%=Year(oodate)%>년&nbsp;<%=Month(oodate)%>월&nbsp;<%=Day(oodate)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>납기일</strong></label>
              <font class="text-secondary"><%=Year(odday)%>년&nbsp;<%=Month(odday)%>월&nbsp;<%=Day(odday)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>진행단계</strong></label>
              <font class="text-secondary"><%=ostatus_text%></font>
            </div>
          </div>
          <div class="row">
            <div class="col">&nbsp;</div>
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="oquan"><strong>수량</strong></label>
              <font class="text-secondary"><%=oquan%>틀</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="ocolor"><strong>색상</strong></label>
                <font class="text-secondary"><%=ocolor_text%></font>
            </div>

            <div class="col-md-3 mb-3">
              <label for="oftype_text"><strong>프레임종류</strong></label>
              <font class="text-secondary"><%=oftype_text%></font>
            </div>
            <div class="col-md-3 mb-3">
 
            </div>
          </div>

          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="oinsw"><strong>검측11</strong></label>
              <font class="text-secondary"><%=FormatNumber(oinsw,0)%>mm &times<%=FormatNumber(oinsh,0)%>mm</font>
            </div>
 
            <div class="col-md-3 mb-3">
              <label for="odoorgw"><strong>도어유리</strong></label>
                <font class="text-secondary"><%=FormatNumber(odoorgw,0)%>mm &times<%=FormatNumber(odoorgh,0)%>mm</font>
            </div>

            <div class="col-md-3 mb-3">
              <label for="onamma"><strong>남마소대</strong></label>
                <font class="text-secondary"><%=onamma_text%></font>
            </div>
             <div class="col-md-3 mb-3">
 
            </div>
          </div>



          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="odoorw"><strong>도어제작</strong></label>
              <font class="text-secondary"><%=FormatNumber(odoorw,0)%>mm &times<%=FormatNumber(odoorh,0)%>mm</font>
            </div>
 
            <div class="col-md-3 mb-3">
              <label for="ofixgw"><strong>픽스유리</strong></label>
              <font class="text-secondary"><%=FormatNumber(ofixgw,0)%>mm &times<%=FormatNumber(ofixgh,0)%>mm</font>
            </div>

            <div class="col-md-3 mb-3">
              <label for="odidx"><strong>발주담당</strong></label>
              <font class="text-secondary"><%=bmname%>&nbsp;<%=bmpos%></font>
            </div>
          </div>  
 
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="odoorw"><strong>바닥묻힘</strong></label>
              <font class="text-secondary"><%=FormatNumber(obitg,0)%>mm</font>
            </div>
 
            <div class="col-md-3 mb-3">
              <label for="ofixgw"><strong>도어제작여부</strong></label>
              <font class="text-secondary"><%=odoormsg_text%></font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>도어 검축 높이</strong></label>
              <font class="text-secondary"><%=FormatNumber(odinsh,0)%>mm</font>
            </div>
            <div class="col-md-3 mb-3">
 
            </div>
          </div>  
          <div class="row">
            <div class="col-md-10 ">
<!--#include virtual="/doorframe/dframe_001.asp"-->
            </div>
          </div>
          <div class="row">
 
          </div>
        </div>
</form>
      </div>
    </div>
  </div>
</main>   
<% elseif doc_type="o" then %>
<main>
  <div class="container-fluid px-4 mt-4 mb-2"> 
    <div class="card mb-4"> 
      <div class="card-body">
        <div class="row text-center">
          <h1><%=doc_type_text%></h1>
        </div>

        <div class="row mt-2">
          <div class="row">
            <h3 class="text-primary"><%=otitle%></h3>
          </div>
          <div class="row">
            <div class="col">&nbsp;</div>
          </div>
          <div class="row">

             <div class="col-md-3 mb-3">
             <label for="cname"><strong>발주처</strong></label>
              <font class="text-secondary"><%=cname%></font>
            </div>
            <div class="col-md-3 mb-3">
            <label for="cname"><strong>사업자번호</strong></label>
              <font class="text-secondary"><%=cnumber%></font>
            </div>
            <div class="col-md-3 mb-3">
            <label for="cname"><strong>담당자</strong></label>
              <font class="text-secondary"><%=amname%>&nbsp;<%=ampos%></font>
            </div>
            
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="cname"><strong>작성일</strong></label>
              <font class="text-secondary"><%=Year(owdate)%>년&nbsp;<%=Month(owdate)%>월&nbsp;<%=Day(owdate)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="cname"><strong>발주일</strong></label>
              <font class="text-secondary"><%=Year(oodate)%>년&nbsp;<%=Month(oodate)%>월&nbsp;<%=Day(oodate)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>납기일</strong></label>
              <font class="text-secondary"><%=Year(odday)%>년&nbsp;<%=Month(odday)%>월&nbsp;<%=Day(odday)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>진행단계</strong></label>
              <font class="text-secondary"><%=ostatus_text%></font>
            </div>
          </div>
          <div class="row">
            <div class="col">&nbsp;</div>
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="oquan"><strong>수량</strong></label>
              <font class="text-secondary"><%=oquan%>틀</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="ocolor"><strong>색상</strong></label>
                <font class="text-secondary"><%=ocolor_text%></font>
            </div>

            <div class="col-md-3 mb-3">
              <label for="oftype_text"><strong>프레임종류</strong></label>
              <font class="text-secondary"><%=oftype_text%></font>
            </div>
            <div class="col-md-3 mb-3">
 
            </div>
          </div>

          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="oinsw"><strong>검축</strong></label>
              <font class="text-secondary"><%=FormatNumber(oinsw,0)%>mm &times<%=FormatNumber(oinsh,0)%>mm</font>
            </div>
 
            <div class="col-md-3 mb-3">
              <label for="odoorgw"><strong>도어유리</strong></label>
                <font class="text-secondary"><%=FormatNumber(odoorgw,0)%>mm &times<%=FormatNumber(odoorgh,0)%>mm</font>
            </div>

            <div class="col-md-3 mb-3">
              <label for="onamma"><strong>남마소대</strong></label>
                <font class="text-secondary"><%=onamma_text%></font>
            </div>
             <div class="col-md-3 mb-3">
 
            </div>
          </div>



          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="odoorw"><strong>도어제작</strong></label>
              <font class="text-secondary"><%=FormatNumber(odoorw,0)%>mm &times<%=FormatNumber(odoorh,0)%>mm</font>
            </div>
 
            <div class="col-md-3 mb-3">
              <label for="ofixgw"><strong>픽스유리</strong></label>
              <font class="text-secondary"><%=FormatNumber(ofixgw,0)%>mm &times<%=FormatNumber(ofixgh,0)%>mm</font>
            </div>

            <div class="col-md-3 mb-3">
              <label for="odidx"><strong>발주담당</strong></label>
              <font class="text-secondary"><%=bmname%>&nbsp;<%=bmpos%></font>
            </div>
          </div>  
 
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="odoorw"><strong>바닥묻힘</strong></label>
              <font class="text-secondary"><%=FormatNumber(obitg,0)%>mm</font>
            </div>
 
            <div class="col-md-3 mb-3">
              <label for="ofixgw"><strong>도어제작여부</strong></label>
              <font class="text-secondary"><%=odoormsg_text%></font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>도어 검축 높이</strong></label>
              <font class="text-secondary"><%=FormatNumber(odinsh,0)%>mm</font>
            </div>
            <div class="col-md-3 mb-3">
 
            </div>
          </div>  
          <div class="row">
            <div class="col-md-10 ">
<!--#include virtual="/doorframe/dframe_001.asp"-->
            </div>
          </div>
          <div class="row">

          </div>
        </div>
</form>
      </div>
    </div>
  </div>
</main>  
<% elseif doc_type="w" then %>
<main>
  <div class="container-fluid px-4 mt-4 mb-2"> 
    <div class="card mb-4"> 
      <div class="card-body">
        <div class="row text-center">
          <h1><%=doc_type_text%></h1>
        </div>

        <div class="row mt-2">
          <div class="row">
            <h3 class="text-primary"><%=otitle%></h3>
          </div>
          <div class="row">
            <div class="col">&nbsp;</div>
          </div>
          <div class="row">

             <div class="col-md-3 mb-3">
             <label for="cname"><strong>발주처</strong></label>
              <font class="text-secondary"><%=cname%></font>
            </div>
            <div class="col-md-3 mb-3">
            <label for="cname"><strong>사업자번호</strong></label>
              <font class="text-secondary"><%=cnumber%></font>
            </div>
            <div class="col-md-3 mb-3">
            <label for="cname"><strong>담당자</strong></label>
              <font class="text-secondary"><%=amname%>&nbsp;<%=ampos%></font>
            </div>
            
          </div>
          <div class="row">
            <div class="col-md-3 mb-3">
              <label for="cname"><strong>작성일</strong></label>
              <font class="text-secondary"><%=Year(owdate)%>년&nbsp;<%=Month(owdate)%>월&nbsp;<%=Day(owdate)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="cname"><strong>발주일</strong></label>
              <font class="text-secondary"><%=Year(oodate)%>년&nbsp;<%=Month(oodate)%>월&nbsp;<%=Day(oodate)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>납기일</strong></label>
              <font class="text-secondary"><%=Year(odday)%>년&nbsp;<%=Month(odday)%>월&nbsp;<%=Day(odday)%>일</font>
            </div>
            <div class="col-md-3 mb-3">
              <label for="odday"><strong>진행단계</strong></label>
              <font class="text-secondary"><%=ostatus_text%></font>
            </div>
          </div>
          <div class="row">
            <div class="col">&nbsp;</div>
          </div>
          <div class="row ms-1">
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="oquan"><strong>수량</strong></label>
              <font class="text-secondary"><%=oquan%>틀</font>
            </div>
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="ocolor"><strong>색상</strong></label>
                <font class="text-secondary"><%=ocolor_text%></font>
            </div>

            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="oftype_text"><strong>프레임종류</strong></label>
              <font class="text-secondary"><%=oftype_text%></font>
            </div>
            <div class="col-md-2 border border-secondary p-2 mb-2 me-1">
              <label for="odidx"><strong>발주담당</strong></label>
              <font class="text-secondary"><%=bmname%>&nbsp;<%=bmpos%></font>
            </div>

          </div>

          <div class="row ms-1">
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="oinsw"><strong>검축</strong></label>
              <font class="text-secondary"><%=FormatNumber(oinsw,0)%>mm &times<%=FormatNumber(oinsh,0)%>mm</font>
            </div>
 
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odoorgw"><strong>도어유리</strong></label>
                <font class="text-secondary"><%=FormatNumber(odoorgw,0)%>mm &times<%=FormatNumber(odoorgh,0)%>mm</font>
            </div>

            <div class="col-md-3  border border-secondary p-2 mb-2 me-1">
              <label for="onamma"><strong>남마소대</strong></label>
                <font class="text-secondary"><%=onamma_text%></font>
            </div>
            <div class="col-md-2 border border-secondary p-2 mb-2 me-1">
              <label for="ofixgw"><strong>도어제작여부</strong></label>
              <font class="text-secondary"><%=odoormsg_text%></font>
            </div>
          </div>



          <div class="row ms-1">
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odoorw"><strong>도어제작</strong></label>
              <font class="text-secondary"><%=FormatNumber(odoorw,0)%>mm &times<%=FormatNumber(odoorh,0)%>mm</font>
            </div>
 
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="ofixgw"><strong>픽스유리</strong></label>
              <font class="text-secondary"><%=FormatNumber(ofixgw,0)%>mm &times<%=FormatNumber(ofixgh,0)%>mm</font>
            </div>

            <div class="col-md-2 border border-secondary p-2 mb-2 me-1">
 
            </div>
            <div class="col-md-2 border border-secondary p-2 mb-2 me-1">
 
            </div>

          </div>  
 
          <div class="row ms-1">
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odoorw"><strong>바닥묻힘</strong></label>
              <font class="text-secondary"><%=FormatNumber(obitg,0)%>mm</font>
            </div>
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>도어 검축 높이</strong></label>
              <font class="text-secondary"><%=FormatNumber(odinsh,0)%>mm</font>
            </div>
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>블랙/실버단가</strong></label>
              <font class="text-secondary"><%=FormatNumber(ouprice,0)%>원</font>
            </div>
            <div class="col-md-2 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>기타도장단가</strong></label>
              <font class="text-secondary"><%=FormatNumber(oeprice,0)%>원</font>
            </div>
          </div>  

          <div class="row">
            <span class="border"></span>
          </div>
          <div class="row mt-2">
            <div class="col-md-3"><h4>부속품 리스트</h4></div>
          </div>
          <div class="row ms-1">
            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>박스상판</strong></label>
              <font class="text-secondary"><%=FormatNumber(oboxtop,0)%>mm&nbsp;<%=oboxtopq%>EA</font>
            </div>
            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>박스전면</strong></label>
              <font class="text-secondary"><%=FormatNumber(oboxfront,0)%>mm&nbsp;<%=oboxfrontq%>EA</font>
            </div>            
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>박스하판</strong></label>
              <font class="text-secondary"><%=FormatNumber(oboxbottom,0)%>mm&nbsp;<%=oboxbottomq%>EA</font>
            </div>

            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>상부가로남마바</strong></label>
              <font class="text-secondary"><%=FormatNumber(otopwnam,0)%>mm&nbsp;<%=otopwnamq%>EA</font>
            </div>
            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>박스ABS</strong></label>
              <font class="text-secondary"><%=FormatNumber(oboxabs,0)%>mm&nbsp;<%=oboxabsq%>EA</font>
            </div>            
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>박스뚜껑</strong></label>
              <font class="text-secondary"><%=FormatNumber(oboxcap,0)%>mm&nbsp;<%=oboxcapq%>EA</font>
            </div>



            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>자동홈바1</strong></label>
              <font class="text-secondary"><%=FormatNumber(oautohome1,0)%>mm&nbsp;<%=oautohome1q%>EA</font>
            </div>
            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>자동홈바2</strong></label>
              <font class="text-secondary"><%=FormatNumber(oautohome2,0)%>mm&nbsp;<%=oautohome2q%>EA</font>
            </div>            
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>중간소대</strong></label>
              <font class="text-secondary"><%=FormatNumber(ojgsd,0)%>mm&nbsp;<%=ojgsdq%>EA</font>
            </div>

            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>픽스상바</strong></label>
              <font class="text-secondary"><%=FormatNumber(ofixtopbar,0)%>mm&nbsp;<%=ofixtopbarq%>EA</font>
            </div>
            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>픽스하바</strong></label>
              <font class="text-secondary"><%=FormatNumber(ofixbottomebar,0)%>mm&nbsp;<%=ofixbottomebarq%>EA</font>
            </div>            
            <div class="col-md-3 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>픽스오사이</strong></label>
              <font class="text-secondary"><%=FormatNumber(ofixosi,0)%>mm&nbsp;<%=ofixosiq%>EA</font>
            </div>

            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>상부중간소대</strong></label>
              <font class="text-secondary"><%=FormatNumber(otopjgsd,0)%>mm&nbsp;<%=otopjgsdq%>EA</font>
            </div>
            <div class="col-md-4 border border-secondary p-2 mb-2 me-1">
              <label for="odday"><strong>홈마감판</strong></label>
              <font class="text-secondary"><%=FormatNumber(ohomedead,0)%>mm&nbsp;<%=ohomedeadq%>EA</font>
            </div>            
 
          </div>


          <div class="row">
            <div class="col-md-10 ">
<!--#include virtual="/doorframe/dframe_001.asp"-->
            </div>
          </div>

        </div>
</form>
      </div>
    </div>
  </div>
</main>  
<% end if%>            
<%
elseif gubun="insert" or gubun="edit" then 

  if gubun="insert" then 
    cidx=Request("cidx")
    oftype=Request("oftype")

    SQL="Select cname, cnumber, cdidx from tk_customer where cidx='"&cidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      cname=Rs(0)
      cnumber=Rs(1)
      cdidx=Rs(2)
    End if
    Rs.Close 

    SQL="select midx, mname From tk_member where cidx='"&cidx&"' "
    'response.write (SQL)&"<br><br><br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      midx=Rs(0)
      mname=Rs(1)
    End if
    Rs.Close 


  elseif gubun="edit" then 
    oidx=Request("oidx")
    SQL=" Select A.oidx, A.otitle, A.cidx, A.oquan, A.ocolor, A.oftype, A.oinsw, A.oinsh "
    SQL=SQL&" , A.odoorw, A.odoorh, A.odoorgw, A.odoorgh, A.ofixgw, A.ofixgh, A.onamma, A.obitg "
    SQL=SQL&" , A.onglass1w, A.onglass1h, A.onglass2w, A.onglass2h, A.odoormsg, A.odday, A.odinsh, A.ouprice "
    SQL=SQL&" , A.oeprice, A.oboxtop, A.oboxtopq, A.oboxfront, A.oboxfrontq, A.oboxbottom, A.oboxbottomq "
    SQL=SQL&" , A.otopwnam, A.otopwnamq, A.oboxabs, A.oboxabsq, A.oboxcap, A.oboxcapq, A.oautohome1, A.oautohome1q "
    SQL=SQL&" , A.oautohome2, A.oautohome2q, A.ojgsd, A.ojgsdq, A.ofixtopbar, A.ofixtopbarq "
    SQL=SQL&" , A.ofixbottomebar, A.ofixbottomebarq, A.ofixosi, A.ofixosiq "
    SQL=SQL&" , A.otopjgsd, A.otopjgsdq, A.ohomedead, A.ohomedeadq, Convert(Varchar(10),A.owdate,121)"
    SQL=SQL&" , A.omidx, A.ostatus, A.odidx "
    SQL=SQL&" , B.mname, B.mpos, B.mtel, B.mhp, B.mfax, B.memail "
    SQL=SQL&" , C.mname, C.mpos, C.mtel, C.mhp, C.mfax, C.memail "
    SQL=SQL&" , D.cname, D.cnumber "
    SQL=SQL&" From  tk_order A "
    SQL=SQL&" Join tk_member B On A.omidx=B.midx "
    SQL=SQL&" Join tk_member C On A.odidx=C.midx "
    SQL=SQL&" Join tk_customer D On A.cidx=D.cidx "
    SQL=SQL&" Where A.oidx='"&oidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      oidx=Rs(0)
      otitle=Rs(1)
      cidx=Rs(2)
      oquan=Rs(3)
      ocolor=Rs(4)
      oftype=Rs(5)
      oinsw=Rs(6)
      oinsh=Rs(7)
      odoorw=Rs(8)
      odoorh=Rs(9)
      odoorgw=Rs(10)
      odoorgh=Rs(11)
      ofixgw=Rs(12)
      ofixgh=Rs(13)
      onamma=Rs(14)
      obitg=Rs(15)
      onglass1w=Rs(16)
      onglass1h=Rs(17)
      onglass2w=Rs(18)
      onglass2h=Rs(19)
      odoormsg=Rs(20)
      odday=Rs(21)
      odinsh=Rs(22)
      ouprice=Rs(23)
      oeprice=Rs(24)
      oboxtop=Rs(25)
      oboxtopq=Rs(26)
      oboxfront=Rs(27)
      oboxfrontq=Rs(28)
      oboxbottom=Rs(29)
      oboxbottomq=Rs(30)
      otopwnam=Rs(31)
      otopwnamq=Rs(32)
      oboxabs=Rs(33)
      oboxabsq=Rs(34)
      oboxcap=Rs(35)
      oboxcapq=Rs(36)
      oautohome1=Rs(37)
      oautohome1q=Rs(38)
      oautohome2=Rs(39)
      oautohome2q=Rs(40)
      ojgsd=Rs(41)
      ojgsdq=Rs(42)
      ofixtopbar=Rs(43)
      ofixtopbarq=Rs(44)
      ofixbottomebar=Rs(45)
      ofixbottomebarq=Rs(46)
      ofixosi=Rs(47)
      ofixosiq=Rs(48)
      otopjgsd=Rs(49)
      otopjgsdq=Rs(50)
      ohomedead=Rs(51)
      ohomedeadq=Rs(52)
      owdate=Rs(53)
      midx=Rs(54)
      ostatus=Rs(55)
      odidx=Rs(56)

      mname=Rs(57)
      ampos=Rs(58)
      amtel=Rs(59)
      amhp=Rs(60)
      amfax=Rs(61)
      amemail=Rs(62)

      bmname=Rs(63)
      bmpos=Rs(64)
      bmtel=Rs(65)
      bmhp=Rs(66)
      bmfax=Rs(67)
      bmemail=Rs(68)
      
      cname=Rs(69)
      cnumber=Rs(70)
    End if
    Rs.Close
  end if






Select Case oftype
  Case "1"
    oftype_text="무방향 외도어 기본"
  Case "2"
    oftype_text="무방향 외도어 상부남마"
  Case "3"
    oftype_text="무방향 외도어 상부남마 중간소대"
  Case "4"
    oftype_text="양개기본"
  Case "5"
    oftype_text="양개 상부남마"
End Select

%> 
<!--
질문 
1. 남마유리 서식
2. 필수여부



도어검측H = 검측H - 230 - 뭍힘
odinsh = oinsh - 230 - obitg

도어제작 W =(검축W-155)/2+75
odoorw = (oinsw-155)/2+75


도어제작 H  =도어검축H + 10
odoorh = odinsh + 10
 


도어유리 W = 도어제작 W - 108
odoorgw = odoorw - 108

오픈사이즈 = (검측W - 45 - 45 - 65)/2
opensize = (oinsw - 45 - 45 - 65)/2

걸제받이 치수 = 검축W - 오픈사이즈 - 45 - 45 - 65
mopsize = oinsw - opensize  - 45 - 45 - 65

픽스유리W = 걸제받이 치수 - 8
ofixgwv = mopsize - 8

픽스유리H = 도어검측H - 110
ofixgh = odinsh - 110


oboxtop = oinsw-90			'박스상판 너비 : 검축w-90
oboxtopq = oquan			'박스상판 수량

oboxfront = oboxfront			'박스전면 너비 : 박스상판 너비
oboxfrontq = oquan			'박스전면 수량

oboxbottom = oboxfront			'박스하판 너비 : 박스상판 너비
oboxbottomq = oquan			'박스하판 수량


otopwnam = oboxfront			'상부가로남마바 너비 : 박스상판 너비
otopwnamq	 = oquan		'상부가로남마바 수량

oboxabs = oboxfront			'박스ABS 너비 : 박스상판 너비
oboxabsq = oquan * 2			'박스ABS 수량

oboxcap	= oboxtop-2		'박스뚜껑 너비 : 박스상판 너비-2
oboxcapq = oquan			'박스뚜껑 수량


oautohome1 = oinsh			'자동홈바1 너비 : 검축높이
oautohome1q = oquan * 2			'자동홈바1 수량

oautohome2 = oinsh			'자동홈바2 너비 : 검축높이
oautohome2q = oquan * 2			'자동홈바2 수량

ojgsd	= odinsh + obitg 		'증간소대 높이 : 도어검측높이 + 바닥묻힘
ojgsdq = oquan			'증간소대 수량

ofixtopbar = mopsize			'픽스상바 H : 걸레받이 치수
ofixtopbarq = oquan			'픽스상바 수량

ofixbottomebar = mopsize			'픽스하바 H : 걸제받이 치수
ofixbottomebarq = oquan			'픽스하바 수량

ofixosi = mopsize - 1			'픽스오사이 너비 : 걸제받이 치수 - 1
ofixosiq = oquan * 2			'픽스오사이 수량



otopjgsd			'상부증간소대 H
otopjgsdq			'상부증간소대 수량

ohomedead			'홈 마감판 너비
ohomedeadq			'홈 마감판 수량
-->
    <script>
    //수량
    function oquanf() {

        var oquan = 0;
 
        oquan = Number($('#oquan').val());

        oboxtopq = Math.floor(oquan);  //박스상판수량
        oboxfrontq = Math.floor(oquan);  //박스전면수량
        oboxbottomq = Math.floor(oquan);  //박스하판수량
        otopwnamq = Math.floor(oquan);  //박스하판수량
        oboxabsq = Math.floor(oquan*2);  //박스하판수량
        oboxcapq = Math.floor(oquan);  //박스하판수량
        oautohome1q = Math.floor(oquan);  //자동홈바1수량
        oautohome2q = Math.floor(oquan);  //자동홈바2수량
        ojgsdq = Math.floor(oquan);  //중간소대수량
        ofixtopbarq = Math.floor(oquan);  //픽스상바 수량
        ofixbottomebarq = Math.floor(oquan);  //픽스하바 수량
        ofixosiq = Math.floor(oquan * 2); //픽스오사이 수량

        $('#oboxtopq').val(oboxtopq);
        $('#oboxfrontq').val(oboxfrontq);
        $('#oboxbottomq').val(oboxbottomq);
        $('#otopwnamq').val(otopwnamq);
        $('#oboxabsq').val(oboxabsq);
        $('#oboxcapq').val(oboxcapq);
        $('#oautohome1q').val(oautohome1q);
        $('#oautohome2q').val(oautohome2q);
        $('#ojgsdq').val(ojgsdq);
        $('#ofixtopbarq').val(ofixtopbarq);
        $('#ofixbottomebarq').val(ofixbottomebarq);
        $('#ofixosiq').val(ofixosiq);
            
    }

    //검측W 입력
    function oinswf() {
        var oinsw = '';
        var odoorw = 0;
        var secondNum = 0;

        oinsw = Number($('#oinsw').val());  //검측W 입력값

        odoorw = Math.floor((oinsw-155)/2+75);  //도어제작W 계산
        odoorgw = Math.floor(odoorw-108); //도어유리W
        opensize = Math.floor((oinsw-45-45-65)/2);  //오픈사이즈
        mopsize = Math.floor(oinsw-opensize-45-45-65);  //걸레받이 사이즈
        ofixgwv = Math.floor(mopsize-8);  //픽스유리W
        oboxtop = Math.floor(oinsw-90);  //박스상판W
        oboxfront = Math.floor(oinsw-90);  //박스전면W
        oboxbottom = Math.floor(oinsw-90);  //박스하판W
        otopwnam = Math.floor(oinsw-90);  //상부가로남마바
        oboxabs = Math.floor(oinsw-90);  //박스ABS
        oboxcap = Math.floor(oinsw-90-2);  //박스뚜껑

        ofixtopbar = Math.floor(mopsize); //픽스상바 H : 걸레받이 치수
        ofixbottomebar = Math.floor(mopsize); //픽스하바 H : 걸제받이 치수
        ofixosi = Math.floor(mopsize - 1);    //픽스오사이 너비 : 걸제받이 치수 - 1


        $('#odoorw').val(odoorw);
        $('#odoorgw').val(odoorgw);
        $('#opensize').val(opensize);
        $('#mopsize').val(mopsize);
        $('#ofixgwv').val(ofixgwv);
        $('#oboxtop').val(oboxtop);
        $('#oboxfront').val(oboxfront);
        $('#oboxbottom').val(oboxbottom);
        $('#otopwnam').val(otopwnam);
        $('#oboxabs').val(oboxabs);
        $('#oboxcap').val(oboxcap);

        $('#ofixtopbar').val(ofixtopbar);
        $('#ofixbottomebar').val(ofixbottomebar);
        $('#ofixosi').val(ofixosi);

    }

    //검측H 입력
    function oinshf() {
        var oinsh = '';
        var odoorh = 0;
 
        oinsh = Number($('#oinsh').val());

        odoorh = Math.floor(oinsh + 10);  //도어제작H
        odoorgh = Math.floor(odoorh-145); //도어유리H
        $('#odoorh').val(odoorh);
        $('#odoorgh').val(odoorgh);        
    }

    //묻힘 입력
    function obitgf() {

        var obitg = 0;

        oinsh = Number($('#oinsh').val());  //검측 높이입력값
        obitg = Number($('#obitg').val());  //묻힘 입력값
        odinsh =  Number($('#odinsh').val()); //도어곰축높이

        odinsh = Math.floor(oinsh - 230 - obitg); //도어검축H
        odoorh = Math.floor(odinsh + 10); //도어제작H
        odoorgh =  Math.floor(odoorh - 145);  //도어유리H
        ofixgh = odinsh - 110 //픽스유리H
        oautohome1 = oinsh	//자동홈바 1
        oautohome2 = oinsh	//자동홈바 2
        ojgsd	= odinsh + obitg 		//증간소대 높이 : 도어검측높이 + 바닥묻힘
        $('#odinsh').val(odinsh);
        $('#odoorh').val(odoorh);
        $('#odoorgh').val(odoorgh);
        $('#ofixgh').val(ofixgh);   
        $('#oautohome1').val(oautohome1); 
        $('#oautohome2').val(oautohome2); 
        $('#ojgsd').val(ojgsd); 
    }

 
 

    </script>
                <main>
                    <div class="container-fluid px-4 mt-4 mb-2"> 
                        <div class="card mb-4"> 
                            <div class="card-body">
                              <div class="row">

                              </div>

                              <div class="row mt-2">

<form name="frmMain" action="order.asp" method="post"  >	
<% if gubun="insert" then %> 
<input type="hidden" name="gubun" value="input">
<% elseif gubun="edit" then %>
<input type="hidden" name="gubun" value="update">
<input type="hidden" name="oidx" value="<%=oidx%>">
<input type="hidden" name="ostatus" value="<%=ostatus%>">
<% end if %>
<input type="hidden" name="cidx" value="<%=cidx%>">
<input type="hidden" name="omidx" value="<%=midx%>">
<input type="hidden" name="oftype" value="<%=oftype%>">

          <div class="row">
            <div class="col-md-2 mb-3">
              <h2><%=Year(date())%>.<%=Month(date())%>.<%=Day(date())%></h2>
            </div>
            <div class="col-md-2 mb-3">
              <h3>티엔지발주서</h3>
            </div>
            <div class="col-md-4 mb-3">
              <label for="name">주문명</label>
              <input type="text" class="form-control" id="otitle" name="otitle" placeholder="<%=otitle%>" value="<%=otitle%>" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="name">발주처</label>
              <input type="text" class="form-control" id="cname" name="cname" placeholder="" value="<%=cname%>(<%=cnumber%>)" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">고객사담당자</label>
              <input type="text" class="form-control" id="mname" name="mname" placeholder="" value="<%=mname%>" readonly>
            </div>
            
          </div>

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="name">수량</label>
              <input type="number" class="form-control" id="oquan" name="oquan" placeholder="<%=oquan%>" value="<%=oquan%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oquanf();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">색상</label>
                <select name="ocolor" class="form-control" id="ocolor" required>
                  <option value="0" <% if ocolor="0" Then %>selected<% end if %>>실버</option>
                  <option value="1" <% if ocolor="1" or ocolor=""  Then %>selected<% end if %>>블랙</option>
                  <option value="2" <% if ocolor="2" Then %>selected<% end if %>>레드</option>
                </select>	
            </div>
            <div class="col-md-4 mb-3 text-Danger text-center">
               
            </div>
            <div class="col-md-4 mb-3">
              <label for="nickname">프레임종류</label>
              <input type="text" class="form-control" id="oftype_text" name="oftype_text" placeholder="" value="<%=oftype_text%>" readonly>
            </div>
          </div>

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="name">검측111</label>
              <input type="number" class="form-control" id="oinsw" name="oinsw" placeholder="너비(mm)" value="<%=oinsw%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinswf();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">&nbsp;</label>
              <input type="number" class="form-control" id="oinsh" name="oinsh" placeholder="높이(mm)" value="<%=oinsh%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');oinshf();" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">도어유리</label>
              <input type="number" class="form-control" id="odoorgw" name="odoorgw" placeholder="너비(mm))" value="<%=odoorgw%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">&nbsp;</label>
              <input type="number" class="form-control" id="odoorgh" name="odoorgh" placeholder="높이(mm)" value="<%=odoorgh%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">남마소대</label>
                <select name="onamma" class="form-control" id="onamma" required>
                  <option value="0" <% if onamma="0" Then %>selected<% end if %>>없음</option>
                  <option value="1" <% if onamma="1" Then %>selected<% end if %>>있음</option>
                </select>	
            </div>
            <div class="col-md-2 mb-3">
              <label for="odidx">발주담당</label>
                <select name="odidx" class="form-control" id="odidx" required>
<%
SQL=" Select midx, mname, mpos, mtel, mhp, mfax, memail, Convert(varchar(10), mwdate,121) "
SQL=SQL&" From tk_member "
SQL=SQL&" where cidx=1"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  Do until Rs.EOF
  midx=Rs(0)
  mname=Rs(1)
  mpos=Rs(2)
  mtel=Rs(3)
  mhp=Rs(4)
  mfax=Rs(5)
  memail=Rs(6)
  mwdate=Rs(7)
%>                
                  <option value="<%=midx%>" <% if Cint(midx)=Cint(odidx) Then %>selected<% end if %>><%=mname%></option>
<%
  Rs.MoveNext
  Loop
End If
Rs.close
%>
                </select>	
            </div>
          </div>



          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">도어제작</label>
              <input type="number" class="form-control" id="odoorw" name="odoorw" placeholder="너비(mm)" value="<%=odoorw%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="name">&nbsp;</label>
              <input type="number" class="form-control" id="odoorh" name="odoorh" placeholder="높이(mm)" value="<%=odoorh%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="name">픽스유리</label>
              <input type="number" class="form-control" id="ofixgwv" name="ofixgw" placeholder="너비(mm)" value="<%=ofixgw%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">&nbsp</label>
              <input type="number" class="form-control" id="ofixgh" name="ofixgh" placeholder="높이(mm)" value="<%=ofixgh%>" readonly>
            </div>
            <div class="col-md-4 mb-3">
              <label for="name">납기일</label>
              <input type="date" class="form-control" id="odday" name="odday" placeholder="<%=odday%>" value="<%=odday%>" required>
            </div>

          </div>  

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">바닥묻힘</label>
              <input type="number" class="form-control" id="obitg" name="obitg" placeholder="너비(mm)" value="<%=obitg%>" onKeyup="this.value=this.value.replace(/[^-0-9]/g,'');obitgf();" required>
            </div>
            <div class="col-md-4 mb-3">
              <label for="odoormsg">도어제작여부</label>
                <select name="odoormsg" class="form-control" id="odoormsg" required>
                  <option value="0" <% if odoormsg="0" Then %>selected<% end if %>>해당없음</option>
                  <option value="1" <% if odoormsg="1" Then %>selected<% end if %>>도어별도</option>
                  <option value="2" <% if odoormsg="2" Then %>selected<% end if %>>도어포함</option>
                </select>	
            </div>  


            <div class="col-md-2 mb-3">
              <label for="name">도어검축 높이</label>
              <input type="number" class="form-control" id="odinsh" name="odinsh" placeholder="높이(mm)" value="<%=odinsh%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">블랙/실버단가</label>
              <input type="number" class="form-control" id="ouprice" name="ouprice" placeholder="" value="<%=ouprice%>" required>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">기타도장단가</label>
              <input type="number" class="form-control" id="oeprice" name="oeprice" placeholder="" value="<%=oeprice%>" required>
            </div>
          </div>

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">오픈사이즈</label>
              <input type="number" class="form-control" id="opensize" name="opensize" placeholder="너비(mm)" value="<%=opensize%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="name">걸레받이치수</label>
              <input type="number" class="form-control" id="mopsize" name="mopsize" placeholder="길이(mm)" value="<%=mopsize%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">남마유리1</label>
              <input type="number" class="form-control" id="onglass1w" name="onglass1w" placeholder="너비(mm)" value="<%=onglass1w%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="name">&nbsp;</label>
              <input type="number" class="form-control" id="onglass1h" name="onglass1h" placeholder="높이(mm)" value="<%=onglass1h%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">남마유리2</label>
              <input type="number" class="form-control" id="onglass2w" name="onglass2w" placeholder="너비(mm)" value="<%=onglass2w%>" readonly>
            </div>
            <div class="col-md-2 mb-3">
              <label for="nickname">&nbsp;</label>
              <input type="number" class="form-control" id="onglass2h" name="onglass2h" placeholder="높이(mm)" value="<%=onglass2h%>" readonly>
            </div>
          </div>

          <div class="row">

            <div class="col-md-2 mb-3">
              <label for="nickname">박스상판</label>
              <input type="number" class="form-control" id="oboxtop" name="oboxtop" placeholder="" value="<%=oboxtop%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스상판수량</label>
              <input type="number" class="form-control" id="oboxtopq" name="oboxtopq" placeholder="개" value="<%=oboxtopq%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스전면</label>
              <input type="number" class="form-control" id="oboxfront" name="oboxfront" placeholder="" value="<%=oboxfront%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스전면수량</label>
              <input type="number" class="form-control" id="oboxfrontq" name="oboxfrontq" placeholder="개" value="<%=oboxfrontq%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스하판</label>
              <input type="number" class="form-control" id="oboxbottom" name="oboxbottom" placeholder="" value="<%=oboxbottom%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스하판수량</label>
              <input type="number" class="form-control" id="oboxbottomq" name="oboxbottomq" placeholder="개" value="<%=oboxbottomq%>" readonly>
            </div>  

          </div>

<!--

-->
          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">상부가로남마바</label>
              <input type="number" class="form-control" id="otopwnam" name="otopwnam" placeholder="" value="<%=otopwnam%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">상부가로남마바 수량</label>
              <input type="number" class="form-control" id="otopwnamq" name="otopwnamq" placeholder="개" value="<%=otopwnamq%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스ABS</label>
              <input type="number" class="form-control" id="oboxabs" name="oboxabs" placeholder="" value="<%=oboxabs%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스ABS 수량</label>
              <input type="number" class="form-control" id="oboxabsq" name="oboxabsq" placeholder="" value="<%=oboxabsq%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스뚜껑</label>
              <input type="number" class="form-control" id="oboxcap" name="oboxcap" placeholder="" value="<%=oboxcap%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">박스뚜껑 수량</label>
              <input type="number" class="form-control" id="oboxcapq" name="oboxcapq" placeholder="" value="<%=oboxcapq%>" readonly>
            </div>  
          </div>
 

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">자동홈바1</label>
              <input type="number" class="form-control" id="oautohome1" name="oautohome1" placeholder="" value="<%=oautohome1%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">자동홈바1 수량</label>
              <input type="number" class="form-control" id="oautohome1q" name="oautohome1q" placeholder="개" value="<%=oautohome1q%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">자동홈바2</label>
              <input type="number" class="form-control" id="oautohome2" name="oautohome2" placeholder="" value="<%=oautohome2%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">자동홈바2 수량</label>
              <input type="number" class="form-control" id="oautohome2q" name="oautohome2q" placeholder="개" value="<%=oautohome2q%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">중간소대</label>
              <input type="number" class="form-control" id="ojgsd" name="ojgsd" placeholder="" value="<%=ojgsd%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">중간소대 수량</label>
              <input type="number" class="form-control" id="ojgsdq" name="ojgsdq" placeholder="개" value="<%=ojgsdq%>" readonly>
            </div>  
    
          </div>

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">픽스 상바</label>
              <input type="number" class="form-control" id="ofixtopbar" name="ofixtopbar" placeholder="" value="<%=ofixtopbar%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">픽스 상파 수량</label>
              <input type="number" class="form-control" id="ofixtopbarq" name="ofixtopbarq" placeholder="개" value="<%=ofixtopbarq%>" readonly>
            </div> 
            <div class="col-md-2 mb-3">
              <label for="nickname">픽스하바</label>
              <input type="number" class="form-control" id="ofixbottomebar" name="ofixbottomebar" placeholder="" value="<%=ofixbottomebar%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">픽스하바 수량</label>
              <input type="number" class="form-control" id="ofixbottomebarq" name="ofixbottomebarq" placeholder="개" value="<%=ofixbottomebarq%>" readonly>
            </div> 
            <div class="col-md-2 mb-3">
              <label for="nickname">픽스오사이</label>
              <input type="number" class="form-control" id="ofixosi" name="ofixosi" placeholder="" value="<%=ofixosi%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">픽스오사이 수량</label>
              <input type="number" class="form-control" id="ofixosiq" name="ofixosiq" placeholder="개" value="<%=ofixosiq%>" readonly>
            </div> 

             
          </div>

          <div class="row">
            <div class="col-md-2 mb-3">
              <label for="nickname">상부중간소대</label>
              <input type="number" class="form-control" id="otopjgsd" name="otopjgsd" placeholder="" value="<%=otopjgsd%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">상부중간소대 수량</label>
              <input type="number" class="form-control" id="otopjgsdq" name="otopjgsdq" placeholder="개" value="<%=otopjgsdq%>" readonly>
            </div> 
            <div class="col-md-2 mb-3">
              <label for="nickname">홈 마감판</label>
              <input type="number" class="form-control" id="ohomedead" name="ohomedead" placeholder="" value="<%=ohomedead%>" readonly>
            </div>  
            <div class="col-md-2 mb-3">
              <label for="nickname">홈 마감판 수량</label>
              <input type="number" class="form-control" id="ohomedeadq" name="ohomedeadq" placeholder="개" value="<%=ohomedeadq%>" readonly>
            </div> 
 
             
          </div>

          <div class="row">
            <button class="btn btn-primary"  type="submit" >저장</button>
          </div>
                              </div>
</form>
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
        <script src="js/scripts.js"></script>
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
    
otitle=Request("otitle")			'주문명
cidx=Request("cidx")			'발주사명
oquan=Request("oquan")			'수량
ocolor=Request("ocolor")			'색상
'oftype=Request("oftype")			'프레임종류
'TB만들어 int로 저장할 것
oftype=1

oinsw=Request("oinsw")			'검축너비
oinsh=Request("oinsh")			'검축높이
odoorw=Request("odoorw")			'도어제작너비
odoorh=Request("odoorh")			'도어제작높이
odoorgw=Request("odoorgw")			'도어유리너비
odoorgh=Request("odoorgh")			'도어유리높이
ofixgw=Request("ofixgw")			'픽스유리너비
ofixgh=Request("ofixgh")			'픽스유리높이
onamma=Request("onamma")			'남마소대
obitg=Request("obitg")			'바닥묻힘
onglass1w=Request("onglass1w")			'남마유리1너비
onglass1h=Request("onglass1h")			'남마유리1높이
onglass2w=Request("onglass2w")			'남마유리2너비
onglass2h=Request("onglass2h")			'남마유리2높이
odoormsg=Request("odoormsg")			'도어제작메시지
odday=Request("odday")			'납기일
odinsh=Request("odinsh")			'도어검축높이
ouprice=Request("ouprice")			'블랙/실버 단가
oeprice=Request("oeprice")			'기타도장 단가


oboxtop = Request("oboxtop")			'박스상판 너비 : 검축w-45
oboxtopq = Request("oboxtopq")			'박스상판 수량

oboxfront = Request("oboxfront")			'박스전면 너비 : 박스상판 너비
oboxfrontq = Request("oboxfrontq")			'박스전면 수량

oboxbottom = Request("oboxbottom")			'박스하판 너비 : 박스상판 너비
oboxbottomq = Request("oboxbottomq")			'박스하판 수량

otopwnam = Request("otopwnam")			'상부가로남마바 너비 : 박스상판 너비
otopwnamq = Request("otopwnamq")			'상부가로남마바 수량

oboxabs = Request("oboxabs")			'박스ABS 너비 : 박스상판 너비
oboxabsq = Request("oboxabsq")			'박스ABS 수량

oboxcap = Request("oboxcap")	'박스뚜껑 너비 : 박스상판 너비-2
oboxcapq = Request("oboxcapq")			'박스뚜껑 수량

oautohome1 = Request("oautohome1")			'자동홈바1 너비 : 검축높이
oautohome1q = Request("oautohome1q")			'자동홈바1 수량

oautohome2 = Request("oautohome2")			'자동홈바2 너비 : 검축높이
oautohome2q = Request("oautohome2q")			'자동홈바2 수량

ojgsd = Request("ojgsd")			'증간소대 너비 : ??
ojgsdq = Request("ojgsdq")			'증간소대 수량

ofixtopbar = Request("ofixtopbar")			'픽스상바 너비
ofixtopbarq = Request("ofixtopbarq")			'픽스상바 수량

ofixbottomebar = Request("ofixbottomebar")			'픽스하바 너비
ofixbottomebarq = Request("ofixbottomebarq")			'픽스하바 수량

ofixosi = Request("ofixosi")			'픽스오사이 너비
ofixosiq = Request("ofixosiq")			'픽스오사이 수량

otopjgsd = Request("otopjgsd")			'상부증간소대 너비
otopjgsdq = Request("otopjgsdq")			'상부증간소대 수량

ohomedead = Request("ohomedead")			'홈마감판 너비
ohomedeadq = Request("ohomedeadq")			'홈마감판 수량

omidx = Request("omidx")			'고객사담당자
odidx = Request("odidx")			'태광담당자


opensize = Request("opensize")			'오픈사이즈
mopensize = Request("mopensize")			'걸레받이치수

'owdate			'등록일
'발주일
 
'ostatus			'진행상태

SQL=" select max(oidx) from tk_order "
response.write  (SQL)&"<br><br>"
Rs.Open sql, dbCon	,1,1,1	
	if not (Rs.EOF or Rs.BOF ) then
    oidx=Rs(0)
    oidx=oidx+1
  else
    oidx=1
  end if
Rs.Close  

SQL=" Insert into tk_order (oidx, otitle, cidx, oquan, ocolor, oftype, oinsw, oinsh "
SQL=SQL&" , odoorw, odoorh, odoorgw, odoorgh, ofixgw, ofixgh, onamma, obitg "
SQL=SQL&" , onglass1w, onglass1h, onglass2w, onglass2h, odoormsg, odday, odinsh, ouprice "
SQL=SQL&" , oeprice, oboxtop, oboxtopq, oboxfront, oboxfrontq, oboxbottom, oboxbottomq "
SQL=SQL&" , otopwnam, otopwnamq, oboxabs, oboxabsq, oboxcap, oboxcapq, oautohome1, oautohome1q "
SQL=SQL&" , oautohome2, oautohome2q, ojgsd, ojgsdq, ofixtopbar, ofixtopbarq "
SQL=SQL&" , ofixbottomebar, ofixbottomebarq, ofixosi, ofixosiq, otopjgsd, otopjgsdq, ohomedead "
SQL=SQL&" , ohomedeadq, omidx, ostatus, odidx, opensize, mopensize) "
SQL=SQL&" Values ('"&oidx&"', '"&otitle&"', '"&cidx&"', '"&oquan&"', '"&ocolor&"', '"&oftype&"', '"&oinsw&"', '"&oinsh&"' "
SQL=SQL&" , '"&odoorw&"', '"&odoorh&"', '"&odoorgw&"', '"&odoorgh&"' , '"&ofixgw&"', '"&ofixgh&"', '"&onamma&"', '"&obitg&"' "
SQL=SQL&" , '"&onglass1w&"', '"&onglass1h&"', '"&onglass2w&"', '"&onglass2h&"', '"&odoormsg&"', '"&odday&"', '"&odinsh&"', '"&ouprice&"' "
SQL=SQL&" , '"&oeprice&"', '"&oboxtop&"', '"&oboxtopq&"', '"&oboxfront&"', '"&oboxfrontq&"', '"&oboxbottom&"', '"&oboxbottomq&"' "
SQL=SQL&" , '"&otopwnam&"', '"&otopwnamq&"', '"&oboxabs&"', '"&oboxabsq&"', '"&oboxcap&"', '"&oboxcapq&"', '"&oautohome1&"', '"&oautohome1q&"' "
SQL=SQL&" , '"&oautohome2&"', '"&oautohome2q&"', '"&ojgsd&"', '"&ojgsdq&"', '"&ofixtopbar&"', '"&ofixtopbarq&"' "
SQL=SQL&" , '"&ofixbottomebar&"', '"&ofixbottomebarq&"', '"&ofixosi&"', '"&ofixosiq&"', '"&otopjgsd&"', '"&otopjgsdq&"', '"&ohomedead&"' "
SQL=SQL&" , '"&ohomedeadq&"', '"&omidx&"', '0', '"&odidx&"',  '"&opensize&"', '"&mopensize&"' "
SQL=SQL&" ) "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)	
Response.write "<script>location.replace('order.asp?gubun=view&oidx="&oidx&"');</script>"
elseif gubun="update" then 

oidx=Request("oidx")  '레코드키값
otitle=Request("otitle")			'주문명
cidx=Request("cidx")			'발주사명
oquan=Request("oquan")			'수량
ocolor=Request("ocolor")			'색상
oftype=Request("oftype")			'프레임종류
'TB만들어 int로 저장할 것
 

oinsw=Request("oinsw")			'검축너비
oinsh=Request("oinsh")			'검축높이
odoorw=Request("odoorw")			'도어제작너비
odoorh=Request("odoorh")			'도어제작높이
odoorgw=Request("odoorgw")			'도어유리너비
odoorgh=Request("odoorgh")			'도어유리높이
ofixgw=Request("ofixgw")			'픽스유리너비
ofixgh=Request("ofixgh")			'픽스유리높이
onamma=Request("onamma")			'남마소대
obitg=Request("obitg")			'바닥묻힘
onglass1w=Request("onglass1w")			'남마유리1너비
onglass1h=Request("onglass1h")			'남마유리1높이
onglass2w=Request("onglass2w")			'남마유리2너비
onglass2h=Request("onglass2h")			'남마유리2높이
odoormsg=Request("odoormsg")			'도어제작메시지
odday=Request("odday")			'납기일
odinsh=Request("odinsh")			'도어검축높이
ouprice=Request("ouprice")			'블랙/실버 단가
oeprice=Request("oeprice")			'기타도장 단가


oboxtop = Request("oboxtop")			'박스상판 너비 : 검축w-45
oboxtopq = Request("oboxtopq")			'박스상판 수량

oboxfront = Request("oboxfront")			'박스전면 너비 : 박스상판 너비
oboxfrontq = Request("oboxfrontq")			'박스전면 수량

oboxbottom = Request("oboxbottom")			'박스하판 너비 : 박스상판 너비
oboxbottomq = Request("oboxbottomq")			'박스하판 수량

otopwnam = Request("otopwnam")			'상부가로남마바 너비 : 박스상판 너비
otopwnamq = Request("otopwnamq")			'상부가로남마바 수량

oboxabs = Request("oboxabs")			'박스ABS 너비 : 박스상판 너비
oboxabsq = Request("oboxabsq")			'박스ABS 수량

oboxcap = Request("oboxcap")	'박스뚜껑 너비 : 박스상판 너비-2
oboxcapq = Request("oboxcapq")			'박스뚜껑 수량

oautohome1 = Request("oautohome1")			'자동홈바1 너비 : 검축높이
oautohome1q = Request("oautohome1q")			'자동홈바1 수량

oautohome2 = Request("oautohome2")			'자동홈바2 너비 : 검축높이
oautohome2q = Request("oautohome2q")			'자동홈바2 수량

ojgsd = Request("ojgsd")			'증간소대 너비 : ??
ojgsdq = Request("ojgsdq")			'증간소대 수량

ofixtopbar = Request("ofixtopbar")			'픽스상바 너비
ofixtopbarq = Request("ofixtopbarq")			'픽스상바 수량

ofixbottomebar = Request("ofixbottomebar")			'픽스하바 너비
ofixbottomebarq = Request("ofixbottomebarq")			'픽스하바 수량

ofixosi = Request("ofixosi")			'픽스오사이 너비
ofixosiq = Request("ofixosiq")			'픽스오사이 수량

otopjgsd = Request("otopjgsd")			'상부증간소대 너비
otopjgsdq = Request("otopjgsdq")			'상부증간소대 수량

ohomedead = Request("ohomedead")			'홈마감판 너비
ohomedeadq = Request("ohomedeadq")			'홈마감판 수량

omidx = Request("omidx")			'고객사담당자
odidx = Request("odidx")			'태광담당자

opensize = Request("opensize")			'오픈사이즈
mopensize = Request("mopensize")			'걸레받이치수

'owdate			'등록일
oodate = Request("oodate")  '발주일 발주처 컨펌
ostatus = Request("ostatus")			'진행상태

SQL="Update tk_order set otitle='"&otitle&"', cidx='"&cidx&"', oquan='"&oquan&"', ocolor='"&ocolor&"', oftype='"&oftype&"', oinsw='"&oinsw&"', oinsh='"&oinsh&"' "
SQL=SQL&" , odoorw='"&odoorw&"', odoorh='"&odoorh&"', odoorgw='"&odoorgw&"', odoorgh='"&odoorgh&"', ofixgw='"&ofixgw&"', ofixgh='"&ofixgh&"', onamma='"&onamma&"' "
SQL=SQL&" , obitg='"&obitg&"' , onglass1w='"&onglass1w&"', onglass1h='"&onglass1h&"', onglass2w='"&onglass2w&"', onglass2h='"&onglass2h&"', odoormsg='"&odoormsg&"'"
SQL=SQL&" , odday='"&odday&"', odinsh='"&odinsh&"', ouprice='"&ouprice&"', oeprice='"&oeprice&"', oboxtop='"&oboxtop&"', oboxtopq='"&oboxtopq&"'"
SQL=SQL&" , oboxfront='"&oboxfront&"', oboxfrontq='"&oboxfrontq&"', oboxbottom='"&oboxbottom&"', oboxbottomq='"&oboxbottomq&"'"
SQL=SQL&" , otopwnam='"&otopwnam&"', otopwnamq='"&otopwnamq&"', oboxabs='"&oboxabs&"', oboxabsq='"&oboxabsq&"', oboxcap='"&oboxcap&"'"
SQL=SQL&" , oboxcapq='"&oboxcapq&"', oautohome1='"&oautohome1&"', oautohome1q='"&oautohome1q&"' "
SQL=SQL&" , oautohome2='"&oautohome2&"', oautohome2q='"&oautohome2q&"', ojgsd='"&ojgsd&"', ojgsdq='"&ojgsdq&"', ofixtopbar='"&ofixtopbar&"'"
SQL=SQL&" , ofixtopbarq='"&ofixtopbarq&"', ofixbottomebar='"&ofixbottomebar&"', ofixbottomebarq='"&ofixbottomebarq&"', ofixosi='"&ofixosi&"'"
SQL=SQL&" , ofixosiq='"&ofixosiq&"', otopjgsd='"&otopjgsd&"', otopjgsdq='"&otopjgsdq&"', ohomedead='"&ohomedead&"' "
SQL=SQL&" , ohomedeadq='"&ohomedeadq&"', omidx='"&omidx&"', ostatus='"&ostatus&"',oodate='"&oodate&"', odidx='"&odidx&"' "
SQL=SQL&" , opensize='"&opensize&"', mopensize='"&mopensize&"' "
SQL=SQL&" Where oidx='"&oidx&"' "
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)	
'response.end
Response.write "<script>location.replace('order.asp?gubun=view&oidx="&oidx&"');</script>"
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
