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

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingOne">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseone" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;성적서
            </button>
            </h2>
            <div id="collapseone" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/report/totalreport.asp">성적서발송 현황</a>
                <!--<a class="nav-link" href="/report/rSEND.asp">성적서전송</a>-->
                <a class="nav-link" href="/report/remainlistorg2.asp">성적서현황</a>
                <a class="nav-link" href="/report/remaingroup.asp">성적서그룹 현황</a>
                <!--<a class="nav-link" href="/report/corpreport.asp">거래처별 발송된 성적서 리스트</a>-->
                <!-- <a class="nav-link" href="/report/nappoomlist.asp">납품확인서 리스트</a>
                <a class="nav-link" href="/report/taxpaymentlist.asp">납세증명서 리스트</a> -->
                <a class="nav-link" href="/report/reglist.asp">성적서품목 현황</a>
            </div>
            </div>
        </div>        

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsetwo" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;발주
            </button>
            </h2>
            <div id="collapsetwo" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/balju/baljuAL.asp">알루미늄발주</a>
                <a class="nav-link" href="/balju/baljuSTN.asp">스테인리스발주</a>
                <a class="nav-link" href="/balju/baljumulti.asp">???</a>
            </div>
            </div>
        </div>
<!--
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;생산관리
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
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


