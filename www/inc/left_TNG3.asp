<%


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

<style>
.accordion-collapse {
    display: block !important;
    height: auto !important;
    visibility: visible !important;
}
.accordion-button::after {
    display: none;  /* 화살표 제거 */
}
.accordion-button {
    cursor: default !important;
    pointer-events: none;  /* 클릭 무력화 */
}
</style>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingOne">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;출고리스트
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/tng3/TNG3_BOGO.ASP">보고폼 전송</a>
                <a class="nav-link" href="/tng3/TNG3_DO.ASP">도장리스트</a>
                <a class="nav-link" href="/tng3/TNG3_YONG.ASP">용차리스트</a>
                <a class="nav-link" href="/tng3/TNG3_HWA.ASP">화물리스트</a>
                <a class="nav-link" href="/tng3/TNG3_BAE.ASP">배달리스트</a>
                <a class="nav-link" href="/tng3/TNG3_CHANGGO.ASP">창고리스트</a>
            </div>
            </div>
        </div>        
<!--
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;출고
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/tng1/tng3.asp">보고폼 전송</a>
                <a class="nav-link" href="/tng1/tng4.asp">도장리스트</a>
                <a class="nav-link" href="/tng1/tng5.asp">용차리스트</a>
                <a class="nav-link" href="/tng1/tng7.asp">화물리스트</a>
                <a class="nav-link" href="/tng1/tng8.asp">배달리스트</a>
                <a class="nav-link" href="/tng1/tng9.asp">창고리스트</a>
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;생산관리
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/tng1/tng6.asp">작업의뢰등록</a>
                <a class="nav-link" href="/tng1/tng7.asp">작업의뢰현황</a>
                <a class="nav-link" href="/mes/sujunow2.asp">생산실적등록(수기)</a>
                <a class="nav-link" href="w_error.asp?listgubun=one&subgubun=one4">제품출고등록(수기)</a>
                <a class="nav-link" href="w_error_now.asp?listgubun=one&subgubun=one5">생산진행현황</a>
                <a class="nav-link" href="w_sheve_into.asp?listgubun=one&subgubun=one6">생산진행현황판</a>
                <a class="nav-link" href="w_sheve_check.asp?listgubun=one&subgubun=one7">생산현황판</a>
                <a class="nav-link" href="w_sheve_into.asp?listgubun=one&subgubun=one6">공장월력등록</a>
                <a class="nav-link" href="w_sheve_check.asp?listgubun=one&subgubun=one7">작업반별가동시간관리</a>                
            </div>
            </div>
        </div>        
-->
    </nav>
</div>
