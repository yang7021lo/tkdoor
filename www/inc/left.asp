<%

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
                <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>&nbsp;&nbsp;고객사
            </button>
            </h2>
            <div id="collapsehome" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="h_idpw.asp">ID,PW부여</a>
                <a class="nav-link" href="h_takeoff.asp">견적등록</a>
                <a class="nav-link" href="h_order.asp">주문등록</a>   
                <a class="nav-link" href="h_glass.asp">유리조회</a>   
                <a class="nav-link" href="h_tranglass.asp">유리전송</a>   
                <a class="nav-link" href="h_state.asp">내역서조회</a>   
                <a class="nav-link" href="h_bill.asp">계산서조회</a>   
                <a class="nav-link" href="h_out.asp">출고조회</a>   
                <a class="nav-link" href="h_data.asp">자료실</a>   
                <a class="nav-link" href="h_data_cad.asp">도면</a>   
                <a class="nav-link" href="h_data_kolas.asp">성적서</a>   
                <a class="nav-link" href="h_data_cata.asp">카다록</a>   
                <a class="nav-link" href="h_data_color.asp">색상표</a>   
                <a class="nav-link" href="h_data_build.asp">조립도</a>   
   
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;수주
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="w_in.asp">수주등록</a>
                <a class="nav-link" href="w_now.asp">수주현황</a>
                <a class="nav-link" href="w_pass.asp">수주진행</a>
                <a class="nav-link" href="w_error.asp">불량등록(사유)</a>
                <a class="nav-link" href="w_error_now.asp">불량현황</a>
                <a class="nav-link" href="w_sheve_into.asp">보류취소등록</a>
                <a class="nav-link" href="w_sheve_check.asp">보류취소조회</a>
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemat" aria-expanded="false" aria-controls="collapsemat">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;자재
            </button>
            </h2>
            <div id="collapsemat" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="m_basic.asp">재고기초</a>
                <a class="nav-link" href="m_inout.asp">입출고등록</a>
                <a class="nav-link" href="m_lot.asp">로트별 재고현황</a>
                <a class="nav-link" href="m_inout_check.asp">수불집계</a>
                <a class="nav-link" href="m_inout_list.asp">수불대장</a>

            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFour">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsepaint" aria-expanded="false" aria-controls="collapsepaint">
                <div class="sb-nav-link-icon"><i class="fa fa-id-card"></i></div>&nbsp;&nbsp;도장
            </button>
            </h2>
            <div id="collapsepaint" class="accordion-collapse collapse <%=headingFour%>" aria-labelledby="headingFour" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="p_in.asp">페인트등록</a>
                <a class="nav-link" href="p_in_list.asp">페인트조회</a>
                <a class="nav-link" href="p_out.asp">외부도장등록</a>
                <a class="nav-link" href="p_out_list.asp">외부도장현황</a>
                <a class="nav-link" href="p_error.asp">불량등록(사유)</a>
                <a class="nav-link" href="p_error_list.asp">불량현황</a>

            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFive">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fa fa-microchip"></i></div>&nbsp;&nbsp;발주
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingFive%>" aria-labelledby="headingFive" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="or_in.asp">발주등록(입고예정)</a>
                <a class="nav-link" href="or_list.asp">발주현황</a>
                <a class="nav-link" href="or_ahead.asp">발주진행</a>
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingSix">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseout" aria-expanded="false" aria-controls="collapseout">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;출고
            </button>
            </h2>
            <div id="collapseout" class="accordion-collapse collapse <%=headingSix%>" aria-labelledby="headingSix" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="out_list.asp">창고재고</a>
                <a class="nav-link" href="out_listup.asp">리스트</a>
                <a class="nav-link" href="out_bea.asp">배달 </a>
                <a class="nav-link" href="out_chango.asp">창고</a>
                <a class="nav-link" href="out_hwa.asp">화물</a>
                <a class="nav-link" href="out_yong.asp">용차</a>

            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingSeven">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsekolas" aria-expanded="false" aria-controls="collapsekolas">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;성적서
            </button>
            </h2>
            <div id="collapsekolas" class="accordion-collapse collapse <%=headingSeven%>" aria-labelledby="headingSeven" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="ko_pass.asp">발행</a>
                <a class="nav-link" href="ko_list.asp">현황</a>
                <a class="nav-link" href="ko_in.asp">기초성적서등록 </a>
                <a class="nav-link" href="ko_check.asp">조회후재발송</a>
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingEight">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsebasic" aria-expanded="false" aria-controls="collapsebasic">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;기초
            </button>
            </h2>
            <div id="collapsebasic" class="accordion-collapse collapse <%=headingEight%>" aria-labelledby="headingEight" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="b_cus.asp">거래처등록</a>
                <a class="nav-link" href="b_item.asp">품목등록</a>
                <a class="nav-link" href="b_bill.asp">단가표 </a>
                <a class="nav-link" href="b_bill_base.asp">기본단가</a>
                <a class="nav-link" href="b_bill_by.asp">거래처별수정</a>
                <a class="nav-link" href="b_bill_all.asp">일괄수정</a>
                <a class="nav-link" href="b_mat.asp">자재등록 </a>
                <a class="nav-link" href="b_money.asp">자금기초</a>
                <a class="nav-link" href="b_monitor.asp">현황판설정(사무실)</a>
                <a class="nav-link" href="b_in.asp">출고등록</a>
                <a class="nav-link" href="b_power.asp">사용자메뉴권한 </a>
                <a class="nav-link" href="b_cash.asp">계좌등록</a>
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingNine">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseperson" aria-expanded="false" aria-controls="collapseperson">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;인사
            </button>
            </h2>
            <div id="collapseperson" class="accordion-collapse collapse <%=headingNine%>" aria-labelledby="headingNine" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="ps_in.asp">사원등록(폰번호)</a>
                <a class="nav-link" href="ps_office.asp">부서등록</a>
                <a class="nav-link" href="ps_pay.asp">급여등록 </a>
                <a class="nav-link" href="ps_paylist.asp">급여대장</a>
                <a class="nav-link" href="ps_paycheck.asp">급여명세서</a>
                <a class="nav-link" href="ps_yeoncha.asp">연차</a>
                <a class="nav-link" href="ps_now.asp">연차현황 </a>
                <a class="nav-link" href="ps_inout.asp">출퇴근기록(세콤)</a>
                <a class="nav-link" href="ps_inoutcheck.asp">근태관리</a>
                <a class="nav-link" href="ps_email.asp">공용메일</a>
              
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTen">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsebuyout" aria-expanded="false" aria-controls="collapsebuyout">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;매입
            </button>
            </h2>
            <div id="collapsebuyout" class="accordion-collapse collapse <%=headingTen%>" aria-labelledby="headingTen" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="buy_in.asp">등록(발주불러오기)</a>
                <a class="nav-link" href="buy_check.asp">입고확인</a>
                <a class="nav-link" href="buy_origin.asp">매입거래원장 </a>
                <a class="nav-link" href="buy_check.asp">매입현황</a>
                <a class="nav-link" href="buy_georae.asp">매입현황/거래처별</a>
                <a class="nav-link" href="buy_saup.asp">매입현황/사업자별</a>
                <a class="nav-link" href="buy_buseo.asp">매입현황/부서별</a>
                <a class="nav-link" href="buy_pum.asp">매입현황/품목별</a>
                <a class="nav-link" href="buy_jigep_in.asp">지급등록</a>
                <a class="nav-link" href="buy_jigep_now.asp">지급현황</a>
                <a class="nav-link" href="buy_jigep_no.asp">미지급현황</a>
              
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingEleven">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsesale" aria-expanded="false" aria-controls="collapsesale">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;매출
            </button>
            </h2>
            <div id="collapsesale" class="accordion-collapse collapse <%=headingEleven%>" aria-labelledby="headingEleven" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="s_enter.asp">등록(수주불러오기)</a>
                <a class="nav-link" href="s_list.asp">매출미등록조회</a>
                <a class="nav-link" href="s_georae.asp">매출거래원장 </a>
                <a class="nav-link" href="s_now.asp">매출현황</a>
                <a class="nav-link" href="s_now_georae.asp">매출현황/거래처별</a>
                <a class="nav-link" href="s_now_saup.asp">매출현황/사업자별</a>
                <a class="nav-link" href="s_now_buseo.asp">매출현황/부서별</a>
                <a class="nav-link" href="s_now_pum.asp">매출현황/품목별</a>
                <a class="nav-link" href="s_sugem_in.asp">수금등록</a>
                <a class="nav-link" href="s_sugem_now.asp">수금현황</a>
                <a class="nav-link" href="s_misugem.asp">미수금현황</a>
                <a class="nav-link" href="s_alarm.asp">날짜설정 미결제시 알림 </a>
              
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwelve">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemobile" aria-expanded="false" aria-controls="collapsemobile">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;모바일(조회)
            </button>
            </h2>
            <div id="collapsemobile" class="accordion-collapse collapse <%=headingTwelve%>" aria-labelledby="headingTwelve" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="mo_jaego.asp">재고</a>
                <a class="nav-link" href="mo_sang.asp">생산진행</a>
                <a class="nav-link" href="mo_ilbo.asp">일보 (수량까지) </a>
                <a class="nav-link" href="mo_sugem.asp">수금 (일,월,연)</a>
                <a class="nav-link" href="mo_sale.asp">매출 (일,월,연)</a>
                <a class="nav-link" href="mo_sale_saup.asp">매출/사업자별</a>
                <a class="nav-link" href="mo_sale_buseo.asp">매출/부서별</a>
                <a class="nav-link" href="mo_sale_upche.asp">매출/업체별</a>
                <a class="nav-link" href="mo_sale_pum.asp">매출/품목별</a>
                <a class="nav-link" href="mo_misu.asp">미수금현황</a>
              
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThirteen">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemobile" aria-expanded="false" aria-controls="collapsemobile">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;입출납
            </button>
            </h2>
            <div id="collapsemobile" class="accordion-collapse collapse <%=headingThirteen%>" aria-labelledby="headingThirteen" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="pay_in.asp">출납내역등록</a>
                <a class="nav-link" href="pay_check.asp">출납조회</a>
                <a class="nav-link" href="pay_geajung_in.asp">계정등록</a>
                <a class="nav-link" href="pay_geajung_now.asp">계정현황</a>
                <a class="nav-link" href="pay_um_in.asp">어음등록</a>
                <a class="nav-link" href="pay_um_check.asp">어음조회</a>
                <a class="nav-link" href="pay_um_now.asp">어음현황</a>
                <a class="nav-link" href="pay_card.asp">카드매출(홈텍스)</a>
                <a class="nav-link" href="pay_card_bupin.asp">법인카드등록</a>
                <a class="nav-link" href="pay_card_in.asp">카드내역등록(홈텍스)</a>
                <a class="nav-link" href="pay_card_check.asp">카드사용조회</a>
                <a class="nav-link" href="pay_card_jukgem.asp">예적금조회</a>

             
              
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFourteen">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseask" aria-expanded="false" aria-controls="collapseask">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;조회
            </button>
            </h2>
            <div id="collapseask" class="accordion-collapse collapse <%=headingFourteen%>" aria-labelledby="headingFourteen" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="as_nae.asp">내역서전송</a>
                <a class="nav-link" href="as_fax.asp">팩스전송</a>
                <a class="nav-link" href="as_munja.asp">문자전송</a>
                <a class="nav-link" href="as_email.asp">이메일전송</a>
                <a class="nav-link" href="as_gongji.asp">직원공지전송</a>
                <a class="nav-link" href="as_login.asp">로그인이력</a>
                <a class="nav-link" href="as_sujung_list.asp">수정이력</a>
                <a class="nav-link" href="as_sujung_check.asp">수신확인(홈텍스)</a>

              
                
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFifteen">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseasset" aria-expanded="false" aria-controls="collapseasset">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;고정자산
            </button>
            </h2>
            <div id="collapseasset" class="accordion-collapse collapse <%=headingFifteen%>" aria-labelledby="headingFifteen" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="ass1.asp">유형등록</a>
                <a class="nav-link" href="ass2.asp">고정자산등록</a>
                <a class="nav-link" href="ass3.asp">고정자산전표조회</a>
                <a class="nav-link" href="ass4.asp">고정자산대장</a>
                <a class="nav-link" href="ass5.asp">증가내역</a>
                <a class="nav-link" href="ass6.asp">감소내역</a>
                <a class="nav-link" href="ass7.asp">증감대장</a>
                <a class="nav-link" href="ass8.asp">수불부</a>
                <a class="nav-link" href="ass9.asp">감가상각</a>

              
                
            </div>
            </div>
        </div>


<!--

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
