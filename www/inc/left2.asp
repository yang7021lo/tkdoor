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
ElseIf listgubun="seven" Then 
    headingSeven="show"          
End If


%>
<div id="layoutSidenav">
  <div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-light" id="sidenavAccordion">

        <div class="accordion" id="accordionExample">

           
            
            <div class="accordion-item">
                <h2 class="accordion-header" id="headingOne">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsebasic" aria-expanded="true" aria-controls="collapsebasic">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;기초
                </button>
                </h2>
                <div id="collapsebasic" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="b_cus.asp?listgubun=one&subgubun=one1">거래처등록</a>
                    <a class="nav-link" href="b_item.asp?listgubun=one&subgubun=one2">품목등록</a>
                    <a class="nav-link" href="b_bill.asp?listgubun=one&subgubun=one3">단가표 </a>
                    <a class="nav-link" href="b_bill_base.asp?listgubun=one&subgubun=one4">기본단가</a>
                    <a class="nav-link" href="b_bill_by.asp?listgubun=one&subgubun=one5">거래처별수정</a>
                    <a class="nav-link" href="b_bill_all.asp?listgubun=one&subgubun=one6">일괄수정</a>
                    <a class="nav-link" href="b_mat.asp?listgubun=one&subgubun=one7">자재등록 </a>
                    <a class="nav-link" href="b_money.asp?listgubun=one&subgubun=one8">자금기초</a>
                    <a class="nav-link" href="b_monitor.asp?listgubun=one&subgubun=one9">현황판설정(사무실)</a>
                    <a class="nav-link" href="b_in.asp?listgubun=one&subgubun=one10">출고등록</a>
                    <a class="nav-link" href="b_power.asp?listgubun=one&subgubun=one11">사용자메뉴권한 </a>
                    <a class="nav-link" href="b_cash.asp?listgubun=one&subgubun=one12">계좌등록</a>
                    
                </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="headingTwo">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseperson" aria-expanded="false" aria-controls="collapseperson">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;인사
                </button>
                </h2>
                <div id="collapseperson" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="ps_in.asp?listgubun=two&subgubun=two1">사원등록(폰번호)</a>
                    <a class="nav-link" href="ps_office.asp?listgubun=two&subgubun=two2">부서등록</a>
                    <a class="nav-link" href="ps_pay.asp?listgubun=two&subgubun=two3">급여등록 </a>
                    <a class="nav-link" href="ps_paylist.asp?listgubun=two&subgubun=two4">급여대장</a>
                    <a class="nav-link" href="ps_paycheck.asp?listgubun=two&subgubun=two5">급여명세서</a>
                    <a class="nav-link" href="ps_yeoncha.asp?listgubun=two&subgubun=two6">연차</a>
                    <a class="nav-link" href="ps_now.asp?listgubun=two&subgubun=two7">연차현황 </a>
                    <a class="nav-link" href="ps_inout.asp?listgubun=two&subgubun=two8">출퇴근기록(세콤)</a>
                    <a class="nav-link" href="ps_inoutcheck.asp?listgubun=two&subgubun=two9">근태관리</a>
                    <a class="nav-link" href="ps_email.asp?listgubun=two&subgubun=two10">공용메일</a>
                  
                    
                </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="headingThree">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsebuyout" aria-expanded="false" aria-controls="collapsebuyout">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;매입
                </button>
                </h2>
                <div id="collapsebuyout" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="buy_in.asp?listgubun=three&subgubun=three1">등록(발주불러오기)</a>
                    <a class="nav-link" href="buy_check.asp?listgubun=three&subgubun=three2">입고확인</a>
                    <a class="nav-link" href="buy_origin.asp?listgubun=three&subgubun=three3">매입거래원장 </a>
                    <a class="nav-link" href="buy_check.asp?listgubun=three&subgubun=three4">매입현황</a>
                    <a class="nav-link" href="buy_georae.asp?listgubun=three&subgubun=three5">매입현황/거래처별</a>
                    <a class="nav-link" href="buy_saup.asp?listgubun=three&subgubun=three6">매입현황/사업자별</a>
                    <a class="nav-link" href="buy_buseo.asp?listgubun=three&subgubun=three7">매입현황/부서별</a>
                    <a class="nav-link" href="buy_pum.asp?listgubun=three&subgubun=three8">매입현황/품목별</a>
                    <a class="nav-link" href="buy_jigep_in.asp?listgubun=three&subgubun=three9">지급등록</a>
                    <a class="nav-link" href="buy_jigep_now.asp?listgubun=three&subgubun=three10">지급현황</a>
                    <a class="nav-link" href="buy_jigep_no.asp?listgubun=three&subgubun=three11">미지급현황</a>
                  
                    
                </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="headingFour">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsesale" aria-expanded="false" aria-controls="collapsesale">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;매출
                </button>
                </h2>
                <div id="collapsesale" class="accordion-collapse collapse <%=headingFour%>" aria-labelledby="headingFour" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="s_enter.asp?listgubun=four&subgubun=four1">등록(수주불러오기)</a>
                    <a class="nav-link" href="s_list.asp?listgubun=four&subgubun=four2">매출미등록조회</a>
                    <a class="nav-link" href="s_georae.asp?listgubun=four&subgubun=four3">매출거래원장 </a>
                    <a class="nav-link" href="s_now.asp?listgubun=four&subgubun=four4">매출현황</a>
                    <a class="nav-link" href="s_now_georae.asp?listgubun=four&subgubun=four5">매출현황/거래처별</a>
                    <a class="nav-link" href="s_now_saup.asp?listgubun=four&subgubun=four6">매출현황/사업자별</a>
                    <a class="nav-link" href="s_now_buseo.asp?listgubun=four&subgubun=four7">매출현황/부서별</a>
                    <a class="nav-link" href="s_now_pum.asp?listgubun=four&subgubun=four8">매출현황/품목별</a>
                    <a class="nav-link" href="s_sugem_in.asp?listgubun=four&subgubun=four9">수금등록</a>
                    <a class="nav-link" href="s_sugem_now.asp?listgubun=four&subgubun=four10">수금현황</a>
                    <a class="nav-link" href="s_misugem.asp?listgubun=four&subgubun=four11">미수금현황</a>
                    <a class="nav-link" href="s_alarm.asp?listgubun=four&subgubun=four12">날짜설정 미결제시 알림 </a>
                  
                    
                </div>
                </div>
            </div>

           
<!--
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseclass" aria-expanded="false" aria-controls="collapseclass">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;메뉴3
            </button>
            </h2>
            <div id="collapseclass" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="textbook.asp?listgubun=three&subgubun=three1">1</a>
                <a class="nav-link" href="material.asp?listgubun=three&subgubun=three2">2</a>

            </div>
            </div>
        </div>


        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFour">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsework" aria-expanded="false" aria-controls="collapsework">
                <div class="sb-nav-link-icon"><i class="fas fa-laptop-code"></i></div>&nbsp;&nbsp;메뉴4
            </button>
            </h2>
            <div id="collapsework" class="accordion-collapse collapse <%=headingFour%>" aria-labelledby="headingfour" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="settlement.asp?listgubun=four&subgubun=four1">1</a>
                <a class="nav-link" href="mgnt_material.asp?listgubun=four&subgubun=four2">2</a>              
                <a class="nav-link" href="sales.asp?listgubun=four&subgubun=four3">3</a>
                <a class="nav-link" href="settle_anl.asp?listgubun=four&subgubun=four4">4</a>
                <a class="nav-link" href="anl2.asp?listgubun=four&subgubun=four5">5</a>

            </div>
            </div>
        </div>
 

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFive">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsedongne" aria-expanded="false" aria-controls="collapsedongne" href="/dadmin/dongne_mgnt.asp">
                <div class="sb-nav-link-icon"><i class="fas fa-book-reader"></i></div>&nbsp;&nbsp;메뉴5
            </button>
            </h2>
            <div id="collapsedongne" class="accordion-collapse collapse <%=headingFive%>" aria-labelledby="headingFive" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link " href="dongne_mgnt.asp?listgubun=five&subgubun=five1">1</a>
                <a class="nav-link " href="dongne_policy.asp?listgubun=five&subgubun=five2">2</a> 
                <a class="nav-link " href="dpoint.asp?listgubun=five&subgubun=five3">3</a> 
                <a class="nav-link " href="dongne_payment.asp?listgubun=five&subgubun=five4">4</a> 
            </div>
            </div>
        </div>
 

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingSix">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseetc" aria-expanded="false" aria-controls="collapseetc">
                <div class="sb-nav-link-icon"><i class="fas fa-expand"></i></div>&nbsp;&nbsp;메뉴6
            </button>
            </h2>
            <div id="collapseetc" class="accordion-collapse collapse <%=headingSix%>" aria-labelledby="headingSix" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="mgnt_board.asp?listgubun=six&subgubun=six1">1</a>
                <a class="nav-link" href="seat_mgnt.asp?listgubun=six&subgubun=six2">2</a>

            </div>
            </div>
        </div>

-->





    </nav>
  </div>
