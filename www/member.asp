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
listgubun=Request("listgubun")
subgubun=Request("subgubun")
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")

mtype=Request("mtype")
gubun=Request("gubun")
sub_gubun=Request("sub_gubun")
ser_settle_code=Request("ser_settle_code")
teacher_mbrid=Request("teacher_mbrid")
sub_gubun2=Request("sub_gubun2")

mgubun=Request("mgubun")
s_wb_code=Request("s_wb_code")
topcode=Request("topcode")

'지역변수
s_mem_mbrid=Request("s_mem_mbrid")
s_settle_code=Request("s_settle_code")
If mgubun="" Then 
mgubun="1"
End If 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="member.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"

gubun=Request("gubun")
mem_mbrid=Request("mem_mbrid")
If mem_mbrid="" Then 
mem_mbrid=C_mem_mbrid
End If 


%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title><%=progectname%></title>
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
        function check(sTR)
        {
            if (confirm("해당 수업 시간으로 스케줄 배정 하시겠습니까?"))
            {
                location.href="member.asp?gubun=tcre&t_mem_mbrid=<%=C_mem_mbrid%>&mem_mbrid=<%=Request("mem_mbrid")%>&teacher_mbrid=<%=teacher_mbrid%>&ser_settle_code=<%=ser_settle_code%>&suup_code="+sTR;
            }
        }
        function check1(sTR)
        {
            if (confirm("해당 수업 시간으로 스케줄 배정 하시겠습니까?"))
            {
                location.href="member.asp?gubun=tcre2&t_mem_mbrid=<%=C_mem_mbrid%>&mem_mbrid=<%=Request("mem_mbrid")%>&teacher_mbrid=<%=teacher_mbrid%>&ser_settle_code=<%=ser_settle_code%>&suup_code="+sTR;
            }
        }

        function check3(sTR)
        {
            if (confirm("스케줄을 정말 삭제 하시겠습니까?"))
            {
                location.href="member.asp?gubun=reset&mtype=<%=Request("mtype")%>&mem_mbrid=<%=Request("mem_mbrid")%>&ser_settle_code="+sTR;
            }
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
                            <div class="col-4">

                            </div>
                            <div class="col-2 mt-4 mb-2 text-end">
<!--modal start -->
                                <!-- Button trigger modal -->
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
                                검색
                                </button>

                                <!-- Modal -->
                                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
            <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="member.asp?listgubun=two&subgubun=two1" name="searchForm">
                <div class="input-group">
                    <input class="form-control" type="text" placeholder="검색" aria-label="검색" aria-describedby="btnNavbarSearch" name="SearchWord" />
                    <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>
                </div>
            </form>

                                    </div>
                                    <div class="modal-footer">

                                    </div>
                                    </div>
                                </div>
                                </div>
                            </div>
<!--modal end -->
                        </div>
 
                        <div class="card mb-4">
 
                            <div class="card-body ">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th align="center">번호</th>
                                            <th align="center">구분</th>
                                            <th align="center">연구원</th>
                                            <th align="center">소속</th>
                                            <th align="center">학년</th>
                                            <th align="center">연락처</th>
                                            <th align="center">가입일</th>
                                            <th align="center">관리</th>  
                                        </tr>
                                    </thead>

                                    <tbody>
<%
SQL=" Select D.mem_mbrid, D.mem_mbrName, D.mem_mbrEngName, D.mem_gmt, D.mem_TelNo1, D.mem_TelNo2, D.mem_TelNo3, D.mem_Addr1, D.mem_Addr2, D.mem_mbrImg, D.mem_Email, Convert(Varchar(10),D.mem_Wdate,121) "
SQL=SQL&" , D.mem_NickName, D.languag_code, D.injeung_status, D.mem_skypeid, D.mem_f_name, D.mem_grade, D.mem_mbrtype, D.etc2, D.seller_name, E.edc_name "
SQL=SQL&" From ek_member D "
SQL=SQL&" Join ek_educenter E On D.edc_idx=E.edc_idx "
SQL=SQL&" Where D.mem_mbrid<>'' and D.edc_idx='"&C_mem_edc_idx&"' "

If SearchWord<>"" Then 
SQL=SQL&"  and (D.mem_mbrname  like '%"&request("SearchWord")&"%' or D.mem_NickName  like '%"&request("SearchWord")&"%' or D.mem_mbrid  like '%"&request("SearchWord")&"%' or D.mem_TelNo1 like '%"&request("SearchWord")&"%' or D.mem_TelNo2 like '%"&request("SearchWord")&"%' or D.mem_TelNo3 like '%"&request("SearchWord")&"%' )"

End If 
SQL=SQL&" Order by D.mem_wdate desc"
 
Response.write (SQL)	
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


mem_mbrid=Rs(0)
mem_mbrName=Rs(1)
mem_mbrEngName=Rs(2)
mem_gmt=Rs(3)
mem_TelNo1=Rs(4)
mem_TelNo2=Rs(5)
mem_TelNo3=Rs(6)
mem_Addr1=Rs(7)
mem_Addr2=Rs(8)
mem_mbrImg=Rs(9)
mem_Email=Rs(10)
mem_Wdate=Rs(11)
mem_NickName=Rs(12)
language_code=Rs(13)
injeung_status=Rs(14)
mem_skypeid=Rs(15)
mem_f_name=Rs(16)
mem_grade=Rs(17)
mem_mbrtype=Rs(18)
etc2=Rs(19)	'학습자 위드파파/에듀넷몰 학습자 구분 0: 에듀넷몰,1:위드파파'
seller_name=Rs(20)
edc_name=Rs(21)
Select Case podcastYN
Case "0"
	podcastYN_text=""
Case "1"
	podcastYN_text="<font color=red>Y</font>"
Case "2"
	podcastYN_text="<font color=blue>N</font>"
End Select 

Select Case mem_mbrtype
Case "0"
	mem_mbrtype_text="본사"
Case "1"
	mem_mbrtype_text="원어민"
Case "2"
	mem_mbrtype_text="회원"
Case "3"
	mem_mbrtype_text="센터"
Case "4"
	mem_mbrtype_text="학교교사"
Case "5"
	mem_mbrtype_text="학습코치"
Case "6"
	mem_mbrtype_text="교사지원자"
Case "7"
	mem_mbrtype_text="코딩상담신청"
Case "8"
	mem_mbrtype_text="학부모"

End Select 

 

Select Case mem_grade
Case "0"
	mem_grade_text="5세이하"
Case "1"
	mem_grade_text="6세"
Case "2"
	mem_grade_text="7세"
Case "3"
	mem_grade_text="초1"
Case "4"
	mem_grade_text="초2"
Case "5"
	mem_grade_text="초3"
Case "6"
	mem_grade_text="초4"
Case "7"
	mem_grade_text="초5"
Case "8"
	mem_grade_text="초6"
Case "9"
	mem_grade_text="중1"
Case "10"
	mem_grade_text="중2"
Case "11"
	mem_grade_text="중3"
Case "12"
	mem_grade_text="고1"
Case "13"
	mem_grade_text="고2"
Case "14"
	mem_grade_text="고3"
Case "15"
	mem_grade_text="대학생"
Case "16"
	mem_grade_text="직장인"
Case "17"
	mem_grade_text="주부"
Case "18"
	mem_grade_text="성인"

End Select 
%>  
                                        <tr>
                                            <td align="center"><%=no-i%></td>
                                            <td align="center"><%=mem_mbrtype_text%></td>
                                            <td><a href="member.asp?gubun=view&listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&s_mem_mbrid=<%=mem_mbrid%>&mem_mbrid=<%=mem_mbrid%>"><% If etc2="1" then %><u><% end if %><%=mem_mbrName%><br><%=mem_f_name%></a></td>
                                            <td><%=mem_Addr2%></td>
                                            <td><%=mem_grade_text%></td>
                                            <td><%=mem_TelNo2%></td>
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
                            </div>

                    <div class="row">
                      <div  class="col-12 py-3"> 
 
                      </div>
                    </div>

<%
    Rs.Close
			End If    
%>                             
                        </div>
                    </div>
                </main>
<%
elseif gubun="view" then 
%>
                <main>
                    <div class="container-fluid px-4 mt-4 mb-2"> 
                        <div class="card mb-4"> 
                            <div class="card-body">
                              <div class="row">

                              </div>

                              <div class="row mt-2">


                                <table id="datatablesSimple"  class="table table-bordered">
                                    <tbody>
                                        <tr>
                                            <td align="center" class="bg-secondary text-white">강좌명</td>
                                            <td align="center" class="bg-secondary text-white">수업시간</td>
                                            <td align="center" class="bg-secondary text-white">수업횟수</td>
                                            <td align="center" class="bg-secondary text-white">교육비</td>
                                            <td align="center" class="bg-secondary text-white">시작일</td>
                                            <td align="center" class="bg-secondary text-white">종료일</td>
                                            <td align="center" class="bg-secondary text-white">관리</td>  
                                        </tr>
                                    </tbody>

                                    <tbody>
<%
SQL=" Select C.package_name, C.lec_time, C.week_cnt, C.week_tcnt, C.month_cnt, C.Class_cnt, C.f_lec_time, C.f_week_cnt, C.f_week_tcnt, A.settle_code, D.wb_title  "
SQL=SQL&" , Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",A.settle_date)),121) "
SQL=SQL&" , Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",A.settle_Sdate)),121) "
SQL=SQL&" , Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",A.settle_Edate)),121) "
SQL=SQL&" ,(Select Min(Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",D.l_s_date)),121)) From ek_sch_detail_room_mem D where D.settle_code=A.settle_code) "
SQL=SQL&" ,(Select Max(Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",D.l_f_date)),121)) From ek_sch_detail_room_mem D where D.settle_code=A.settle_code ) "
SQL=SQL&" , settle_amount "
SQL=SQL&" From ek_settlement A "
SQL=SQL&" Join ek_CashCode B On A.cash_idx=B.cash_idx "
SQL=SQL&" Join ek_package C On B.package_code=C.package_code "
SQL=SQL&" Left Outer Join ek_wb D On A.wb_idx=D.idx "
SQL=SQL&" Where A.settle_mbr_id='"&s_mem_mbrid&"'  "
SQL=SQL&" Order by settle_date desc,settle_code desc "
'Response.write (SQL)
	Rs.Open sql, dbCon	,1,1,1	
	if not (Rs.EOF or Rs.BOF ) then
		Do until Rs.EOF

		package_name=Rs(0)
		lec_time=Rs(1)
		week_cnt=Rs(2)
		week_tcnt=Rs(3)
		month_cnt=Rs(4)
		Class_cnt=Rs(5)
		f_lec_time=Rs(6)
		f_week_cnt=Rs(7)
		f_week_tcnt=Rs(8)
		settle_code=Rs(9)
		wb_title=Rs(10)
		settle_date=Rs(11)
		settle_Sdate=Rs(12)
		settle_Edate=Rs(13)
		l_s_date=Rs(14)
		l_f_date=Rs(15)
        settle_amount=Rs(16)

SQL=" select l_s_date, l_f_date "
SQL=SQL&"from ek_sch_detail_room_mem "
SQL=SQL&"where settle_code='"&settle_code&"' "
Rs1.open Sql,Dbcon
If not (Rs1.EOF or Rs1.BOF ) Then
    dl_s_date=Rs1(0)
    dl_f_date=Rs1(1)
    difftime=DateDiff("n", dl_s_date, dl_f_date)

End If 
Rs1.Close


SQL=" Select count(*) "
SQL=SQL&" From ek_sch_detail_room A "
SQL=SQL&" Join ek_sch_detail_room_mem B On A.sch_room_idx=B.sch_room_idx "
SQL=SQL&" Join ek_member D On A.sch_teach_id=D.mem_mbrid where B.mem_mbrid='"&s_mem_mbrid&"' and B.settle_code='"&settle_code&"'  "
'Response.write (sql)&"<br><br>"
Rs1.open Sql,Dbcon
If not (Rs1.EOF or Rs1.BOF ) Then
		NL_cnt=Rs1(0)'원어민수업수
End If 
Rs1.Close
'
%>

                                        <tr id="<%=settle_code%>">
                                            <td align="center"><%=wb_title%><br><%=package_name%>&nbsp;1:<%=Class_cnt%>&nbsp;<%=month_cnt%>개월[<%=settle_code%>]</td>
                                            <td align="center"><%=difftime%>분</td>
                                            <td align="center"><%=NL_cnt%>회</td>
                                            <td align="center"><%=FormatCurrency(settle_amount)%></td>
                                            <td align="center"><%=Left(dateadd("d",0,l_s_date),10)%></td>
                                            <td align="center"><%=Left(dateadd("d",0,l_f_date),10)%></td>
                                            <td align="left">
					<%If l_s_date<>"" Then  %>	
					<button type="button" class="btn btn-primary" onClick="location.replace('member.asp?gubun=view&listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&s_mem_mbrid=<%=mem_mbrid%>&mem_mbrid=<%=mem_mbrid%>&ser_settle_code=<%=settle_code%>#<%=settle_code%>')">스케줄상세보기</button>
					<button type="button" class="btn btn-primary" onClick="location.replace('ind_sch_mgnt.asp?listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&mem_mbrid=<%=mem_mbrid%>&settle_code=<%=settle_code%>')">스케줄관리</button>
<!--
					<button type="button" class="btn btn-primary" Onclick="advice_card('AdviceCard_pop.asp?listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&mem_MbrId=<%=mem_mbrid%>&sd_gubun=2&ResultType=1&settle_code=<%=settle_code%>&topcode=<%=topcode%>&pg_gubun=se&advice_idx=<%=advice_idx%>&gotopage=<%=gotopage%>&SearchWord=<%=request("SearchWord")%>&kcode=1');">멘토정기리포트</button>
-->
					<% End If %>
					<button type="button" class="btn btn-primary" onClick="location.replace('member.asp?gubun=view&listgubun=<%=listgubun%>&subgubun=<%=subgubun%>&s_mem_mbrid=<%=s_mem_mbrid%>&ser_settle_code=<%=settle_code%>&s_settle_code=<%=settle_code%>&mem_mbrid=<%=s_mem_mbrid%>&sub_gubun=int#<%=settle_code%>')">강사배정</button>

                                            </td>  
                                        </tr>
<% If Trim(settle_code)=Trim(ser_settle_code) Then %>
<!-- 수업배정 시작 -->
<% If sub_gubun="int" Then %>
<tr bgcolor="#FFFFFF">
	<td colspan="9">
<!-- iframe 시작 -->
<iframe src="reservation.asp?s_mem_mbrid=<%=s_mem_mbrid%>&s_settle_code=<%=s_settle_code%>" name="main" width="99%" height="900" marginwidth="0"  marginheight="0"  scrolling="auto" align="left" frameborder="0" border="0" allowtransparency="true"></iframe> 
<!-- iframe 끝 -->	
	</td>
</tr> 
<% End If %>
<!-- 수업배정 끝 -->
			<tr>
				<td colspan="7">
<table class="table table-bordered">
<tr>
	<td align="center" width="40"  class="bg-secondary text-white">번호</td>
	<td align="center" width="120" class="bg-secondary text-white">날짜</td>
	<td align="center" width="500" class="bg-secondary text-white">활동</td>
	<td align="center" width="80" class="bg-secondary text-white">관리</td>
</tr>
<%
SQL=" Select distinct   A.sch_day_code, A.sch_room_idx , A.sch_detail_jindo, A.sch_detail_state, A.sch_detail_lec_date, C.mem_mbrname, A.Lec_idx, B.absent"
SQL=SQL&" From ek_sch_detail A "
SQL=SQL&" Join ek_sch_detail_Room_mem B On  A.sch_room_idx=B.sch_room_idx "
SQL=SQL&" Join ek_member C On A.sch_detail_teach_id=C.mem_mbrid "
 
SQL=SQL&" Where B.mem_mbrid='"&Request("mem_mbrid")&"'  and B.settle_code='"&settle_code&"' "

If tg_code="1" Then 
SQL=SQL&" and Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",A.sch_detail_Stime)),121)>=Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",B.l_s_date)),121) "
SQL=SQL&" and Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",A.sch_detail_Stime)),121)<=Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",B.l_f_date)),121)   "
SQL=SQL&"  and (B.e_date is null or Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",A.sch_detail_Stime)),121)=Convert(varchar(10),dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",B.e_date)),121) ) "
ElseIf tg_code="2" Then 
SQL=SQL&" and Convert(varchar(10),dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",A.sch_detail_Stime)),121)>=Convert(varchar(10),dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",B.l_s_date)),121) "
SQL=SQL&" and Convert(varchar(10),dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",A.sch_detail_Stime)),121)<=Convert(varchar(10),dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",B.l_f_date)),121)   "
SQL=SQL&"  and (B.e_date is null or Convert(varchar(10),dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",A.sch_detail_Stime)),121)=Convert(varchar(10),dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",B.e_date)),121) ) "
End If 


SQL=SQL&" Order by A.sch_detail_lec_date asc "
'Response.write (SQL)&"<br>"
Rs1.open Sql,Dbcon,1,1,1
If not (rs1.EOF or rs1.BOF ) then
Do until rs1.EOF
	sch_day_code=Rs1(0)
	sch_room_idx=Rs1(1)
	sch_detail_jindo=Rs1(2)
	sch_detail_state=Rs1(3)
	sch_detail_lec_date=Rs1(4)
	teacher_name=Rs1(5)
	Lec_idx=Rs1(6)
	absent=Rs1(7)
k=k+1


	Select Case absent
	Case "1"
		absent_text="출석"
	Case "2"
		absent_text="결석"
	End Select 


'Response.write sch_day_code&"<br>"

 
SQL=" Select B.lecturede_idx, B.report, B.advice, B.padvice, B.ctype, B.stime, B.ftime, C.lcomment, B.fdate "
SQL=SQL&" From ek_lecture A "
SQL=SQL&" Join ek_lectureDe B On A.lec_idx=B.lec_idx "
SQL=SQL&" Left Outer Join ek_like C On B.lecturede_idx=C.lecturede_idx and C.ltype=2 "
SQL=SQL&" Where A.sch_day_code='"&sch_day_code&"' and A.sch_room_idx='"&sch_room_idx&"' and A.mbr_id='"&Request("mem_mbrid")&"' "
'response.write (SQL)&"<br>"
Rs2.open Sql,Dbcon,1,1,1
If not (rs2.EOF or rs2.BOF ) Then
	lecturede_idx=Rs2(0)
    report=Rs2(1)
    advice=Rs2(2)
    padvice=Rs2(3)
    ctype=Rs2(4)
    dstime=Rs2(5)
    dftime=Rs2(6)
	lcomment=Rs2(7)
    tfdate=Rs2(8)

End If 
Rs2.close
	If Isnull(lecturede_idx) Then 
		ind_state_text=""
	Else 
		ind_state_text="<font color=red>출석</font>"
	End If 
	
 

SQL=" Select B.Lesson_title, B.wb_level_idx, B.idx, B.wb_code, A.wb_title "
SQL=SQL&" From ek_wb A "
SQL=SQL&" Join ek_webbook B On A.wb_code=B.wb_code "
SQL=SQL&" Where B.idx='"&sch_detail_jindo&"' "
'Response.write (SQL)
Rs2.open Sql,Dbcon,1,1,1

If not (rs2.EOF or rs2.BOF ) Then
	Lesson_title=Rs2(0)
	wb_level_idx=Rs2(1)
	wb_idx=Rs2(2)
	wb_code=Rs2(3)
	wb_title=Rs2(4)
End If 
Rs2.Close



If tg_code="1" Then 
SQL="Select dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",min(sch_detail_Stime))), dateadd(minute,"&tg_minute&",dateadd(hour,"&tg_hour&",max(sch_detail_Etime))) From ek_sch_detail Where  sch_day_code='"&sch_day_code&"' and sch_room_idx='"&sch_room_idx&"' "
ElseIf tg_code="2" Then 
SQL="Select dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",min(sch_detail_Stime))), dateadd(minute,-"&tg_minute&",dateadd(hour,-"&tg_hour&",max(sch_detail_Etime))) From ek_sch_detail Where  sch_day_code='"&sch_day_code&"' and sch_room_idx='"&sch_room_idx&"' "
End If 
		'Response.write (SQL)
		Rs2.open Sql,Dbcon,1,1,1
		If not (rs2.EOF or rs2.BOF ) Then
		sch_detail_Stime=Rs2(0)
		sch_detail_Etime=Rs2(1)
		End If 
		Rs2.Close


Select Case weekday(sch_detail_Stime)

Case "1"
	week_day_text="일"
Case "2"
	week_day_text="월"
Case "3"
	week_day_text="화"
Case "4"
	week_day_text="수"
Case "5"
	week_day_text="목"
Case "6"
	week_day_text="금"
Case "7"
	week_day_text="토"
End Select 


%>
<tr height="25">
	<td align="center" ><%=k%></td>
	<td align="center"><%=Left(sch_detail_Stime,10)%>[<%=week_day_text%>]<br>(<%=FormatDateTime(sch_detail_Stime,4)&"~"&FormatDateTime(sch_detail_Etime,4)%>)</td>
	<td >
<%
SQL=" Select A.stime, A.ftime, A.gaptime, A.memo, B.wb_level_title "
SQL=SQL&" From ek_tdplan A "
SQL=SQL&" Join ek_wblevel B On A.wb_level_idx=B.wb_level_idx "
SQL=SQL&" Where A.lecturede_idx='"&lecturede_idx&"' "
SQL=SQL&" Order by A.stime asc "
 
'Response.write (SQL)&"<br>"
Rs2.open Sql,Dbcon,1,1,1
If not (Rs2.EOF or Rs2.BOF ) then
Do until Rs2.EOF
    qstime=Rs2(0)
    qftime=Rs2(1)
    qgaptime=Rs2(2)
    qmemo=Rs2(3)
    qwb_level_title=Rs2(4)
%>
[<%=hour(qstime)%>시 <%=minute(qstime)%>분~<%=hour(qftime)%>시 <%=minute(qftime)%>분(<%=qgaptime%>분)] : <font color="red"><%=qwb_level_title%> |</font> <%=qmemo%><br>
<%
Rs2.MoveNext
Loop
End If
Rs2.close
%>

<b>다음계획:</b><%=report%><br><b>선생님:</b><%=advice%><br><b>부모님:</b><%=lcomment%>
    </td>
 

	<td align="center" width="80" >
		<% if absent="1" then %>
		<button type="button" class="btn btn-outline-success"><%=absent_text%></button>
		<% else %>
		<button type="button" class="btn btn-outline-danger"><%=absent_text%></button>	
		<% end if %>
        <br><%=sch_room_idx%>
	</td>
</tr>
<%
sch_detail_state_text=""
sch_detail_state=""
ind_state_text=""
report=""
advice=""
padvice=""
dstime="0"
dftime="0"
qstime="0"
qftime="0"
qwb_level_title=""
qmemo=""
lecturede_idx=""
absent=""
absent_text=""
tfdate=""
Rs1.MoveNext
Loop
End If
Rs1.close
%>
</table>
                
                </td>
            </tr>
<% End if %>
<%
CL_cnt=0
NL_cnt=0
difftime=0
		Rs.MoveNext
		Loop 
	end if
	Rs.close		
%>
                                    </tbody>
                                </table>

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
if gubun="likemsg" then 
    
elseif gubun="fdel" then 
 
elseif gubun="del" then 
mem_mbrid=Request("mem_mbrid")


SQL=" select * from ek_settlement where settle_mbr_id='"&mem_mbrid&"' "
Rs.open Sql,Dbcon,1,1,1
If not (Rs.EOF or Rs.BOF ) then

    response.write "<script>alert('결제 정보가 존재합니다.');location.replace('member.asp?gubun=view&listgubun="&listgubun&"&subgubun="&subgubun&"&s_mem_mbrid="&mem_mbrid&"&mem_mbrid="&mem_mbrid&"');</script>"


Else 
    SQL="Delete From ek_member Where mem_mbrid='"&mem_mbrid&"' "
    'Response.write (SQL)
    'Response.end
    Dbcon.Execute (SQL)	
    response.write "<script>location.replace('member.asp?listgubun="&listgubun&"&subgubun="&subgubun&"');</script>"

End If
Rs.Close


 
elseif gubun="seat_status" then 
 
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
