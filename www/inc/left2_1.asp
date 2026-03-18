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
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemobile" aria-expanded="true" aria-controls="collapsemobile">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;모바일(조회)
                </button>
                </h2>
                <div id="collapsemobile" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="mo_jaego.asp?listgubun=one&subgubun=one1">재고</a>
                    <a class="nav-link" href="mo_sang.asp?listgubun=one&subgubun=one2">생산진행</a>
                    <a class="nav-link" href="mo_ilbo.asp?listgubun=one&subgubun=one3">일보 (수량까지) </a>
                    <a class="nav-link" href="mo_sugem.asp?listgubun=one&subgubun=one4">수금 (일,월,연)</a>
                    <a class="nav-link" href="mo_sale.asp?listgubun=one&subgubun=one5">매출 (일,월,연)</a>
                    <a class="nav-link" href="mo_sale_saup.asp?listgubun=one&subgubun=one6">매출/사업자별</a>
                    <a class="nav-link" href="mo_sale_buseo.asp?listgubun=one&subgubun=one7">매출/부서별</a>
                    <a class="nav-link" href="mo_sale_upche.asp?listgubun=one&subgubun=one8">매출/업체별</a>
                    <a class="nav-link" href="mo_sale_pum.asp?listgubun=one&subgubun=one9">매출/품목별</a>
                    <a class="nav-link" href="mo_misu.asp?listgubun=one&subgubun=one10">미수금현황</a>
                    
                </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="headingTwo">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemobile" aria-expanded="false" aria-controls="collapsemobile">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;입출납
                </button>
                </h2>
                <div id="collapsemobile" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="pay_in.asp?listgubun=two&subgubun=two1">출납내역등록</a>
                    <a class="nav-link" href="pay_check.asp?listgubun=two&subgubun=two2">출납조회</a>
                    <a class="nav-link" href="pay_geajung_in.asp?listgubun=two&subgubun=two3">계정등록</a>
                    <a class="nav-link" href="pay_geajung_now.asp?listgubun=two&subgubun=two4">계정현황</a>
                    <a class="nav-link" href="pay_um_in.asp?listgubun=two&subgubun=two5">어음등록</a>
                    <a class="nav-link" href="pay_um_check.asp?listgubun=two&subgubun=two6">어음조회</a>
                    <a class="nav-link" href="pay_um_now.asp?listgubun=two&subgubun=two7">어음현황</a>
                    <a class="nav-link" href="pay_card.asp?listgubun=two&subgubun=two8">카드매출(홈텍스)</a>
                    <a class="nav-link" href="pay_card_bupin.asp?listgubun=two&subgubun=two9">법인카드등록</a>
                    <a class="nav-link" href="pay_card_in.asp?listgubun=two&subgubun=two10">카드내역등록(홈텍스)</a>
                    <a class="nav-link" href="pay_card_check.asp?listgubun=two&subgubun=two11">카드사용조회</a>
                    <a class="nav-link" href="pay_card_jukgem.asp?listgubun=two&subgubun=two12">예적금조회</a>
                </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="headingThree">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseasset" aria-expanded="false" aria-controls="collapseasset">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;고정자산
                </button>
                </h2>
                <div id="collapseasset" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="ass1.asp?listgubun=three&subgubun=three1">유형등록</a>
                    <a class="nav-link" href="ass2.asp?listgubun=three&subgubun=three2">고정자산등록</a>
                    <a class="nav-link" href="ass3.asp?listgubun=three&subgubun=three3">고정자산전표조회</a>
                    <a class="nav-link" href="ass4.asp?listgubun=three&subgubun=three4">고정자산대장</a>
                    <a class="nav-link" href="ass5.asp?listgubun=three&subgubun=three5">증가내역</a>
                    <a class="nav-link" href="ass6.asp?listgubun=three&subgubun=three6">감소내역</a>
                    <a class="nav-link" href="ass7.asp?listgubun=three&subgubun=three7">증감대장</a>
                    <a class="nav-link" href="ass8.asp?listgubun=three&subgubun=three8">수불부</a>
                    <a class="nav-link" href="ass9.asp?listgubun=three&subgubun=three9">감가상각</a>
    
                  
                    
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
