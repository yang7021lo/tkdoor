<%
if C_mem_MbrType<>"0" then 
'Response.write "<script>alert('관리자만 접속 가능합니다..');history.back();</script>"
'Response.end

end if

listgubun=Request("listgubun")

if listgubun="dongne" then 
    colldongne="accordion-collapse collapse show"
else 
    colldongne="accordion-collapse collapse"
end if

If listgubun="one" Then 
    headingOne="show"
ElseIf listgubun="two" Then 
    headingTwo="show"
ElseIf listgubun="three" Then 
    headingThree="show"
ElseIf listgubun="four" Then 
    headingFour="show"
ElseIf listgubun="five" Then 
    headingFive="show"
ElseIf listgubun="six" Then 
    headingSix="show"        
End If





%>
<div id="layoutSidenav">
  <div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-light" id="sidenavAccordion">

        <div class="accordion" id="accordionExample">

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingOne">
            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapsehome" aria-expanded="true" aria-controls="collapsehome">
                <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>&nbsp;&nbsp;홈
            </button>
            </h2>
            <div id="collapsehome" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="program.asp?listgubun=one">프로그램</a>
                <a class="nav-link" href="dschedule.asp?listgubun=one">시설</a>
                <a class="nav-link" href="">시설</a>
                <a class="nav-link" href="">사용자</a>
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemember" aria-expanded="false" aria-controls="collapsemember">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;관리자
            </button>
            </h2>
            <div id="collapsemember" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="dongne_mgnt.asp?listgubun=two" >연구노트관리</a>
                <a class="nav-link" href="">전체회원</a>
                <a class="nav-link" href="">수강생</a>
                <a class="nav-link" href="">상담회원</a>
                <a class="nav-link" href="">원어민</a>
                <a class="nav-link" href="">코딩멘토</a>
                <a class="nav-link" href="">관리자</a>
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseclass" aria-expanded="false" aria-controls="collapseclass">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;강의
            </button>
            </h2>
            <div id="collapseclass" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="dongne_mgnt.asp?listgubun=three">과정설계</a>
                <a class="nav-link" href="">재료신청</a>
                <a class="nav-link" href="">타자콘테스트</a>
            </div>
            </div>
        </div>


        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFour">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsework" aria-expanded="false" aria-controls="collapsework">
                <div class="sb-nav-link-icon"><i class="fas fa-laptop-code"></i></div>&nbsp;&nbsp;업무
            </button>
            </h2>
            <div id="collapsework" class="accordion-collapse collapse <%=headingFour%>" aria-labelledby="headingfour" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="dongne_mgnt.asp?listgubun=four">수강료</a>
                <a class="nav-link" href="">재료비</a>
                <a class="nav-link" href="">그룹코드</a>
                <a class="nav-link" href="">업무전달</a>
                <a class="nav-link" href="">상담기록</a>
                <a class="nav-link" href="">인보이스</a>
                <a class="nav-link" href="">매출현황</a>
                <a class="nav-link" href="">매출통계</a>
                <a class="nav-link" href="">수강료설정</a>
                <a class="nav-link" href="">수업일정표</a>
                <a class="nav-link" href="">수강생대장</a>
            </div>
            </div>
        </div>


        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFive">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsedongne" aria-expanded="false" aria-controls="collapsedongne" href="/dadmin/dongne_mgnt.asp">
                <div class="sb-nav-link-icon"><i class="fas fa-book-reader"></i></div>&nbsp;&nbsp;동네형
            </button>
            </h2>
            <div id="collapsedongne" class="accordion-collapse collapse <%=headingFive%>" aria-labelledby="headingFive" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link " href="dongne_mgnt.asp?listgubun=five">연구노트</a>
                <a class="nav-link " href="dongne_policy.asp?listgubun=five">코인포인트정책</a> 
                <a class="nav-link " href="dpoint.asp?listgubun=five">코인포인트현황</a> 
                <a class="nav-link " href="dongne_payment.asp?listgubun=five">정산관리</a> 
            </div>
            </div>
        </div>


        <div class="accordion-item">
            <h2 class="accordion-header" id="headingSix">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseetc" aria-expanded="false" aria-controls="collapseetc">
                <div class="sb-nav-link-icon"><i class="fas fa-expand"></i></div>&nbsp;&nbsp;기타
            </button>
            </h2>
            <div id="collapseetc" class="accordion-collapse collapse <%=headingSix%>" aria-labelledby="headingSix" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="seat_mgnt.asp?listgubun=six">좌석관리</a>
                <a class="nav-link" href="">쿠폰관리</a>
                <a class="nav-link" href="">포인트</a>
                <a class="nav-link" href="">케메마켓</a>
                <a class="nav-link" href="">게시판관리</a>
                <a class="nav-link" href="">업무공유</a>
            </div>
            </div>
        </div>







    </nav>
  </div>
