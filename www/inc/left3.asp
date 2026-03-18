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
            <h2 class="accordion-header" id="headingtwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseout" aria-expanded="false" aria-controls="collapseout">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;출고
            </button>
            </h2>
            <div id="collapseout" class="accordion-collapse collapse <%=headingtwo%>" aria-labelledby="headingtwo" data-bs-parent="#accordionExample">
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
            <h2 class="accordion-header" id="headingthree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseask" aria-expanded="false" aria-controls="collapseask">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;조회
            </button>
            </h2>
            <div id="collapseask" class="accordion-collapse collapse <%=headingthree%>" aria-labelledby="headingthree" data-bs-parent="#accordionExample">
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
            <h2 class="accordion-header" id="headingfour">
            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapsehome" aria-expanded="true" aria-controls="collapsehome">
                <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>&nbsp;&nbsp;자재등록
            </button>
            </h2>
            <div id="collapsehome" class="accordion-collapse collapse <%=headingfour%>" aria-labelledby="headingfour" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/frmmgnt.asp">제품관리</a>
                <a class="nav-link" href="/matmgntex.asp?qtype=1">금속/재질/도장</a>
                <a class="nav-link" href="/appmgnt.asp">자재관리</a>
                <a class="nav-link" href="/unitmgnt.asp">단가관리</a>
                <a class="nav-link" href="/glass_itemin.asp">유리등록</a>
                <a class="nav-link" href="/glass_item.asp">유리</a>
                <a class="nav-link" href="/key_itemin.asp">키등록</a>
                <a class="nav-link" href="/key_item.asp">키</a>
                <a class="nav-link" href="/paint_itemin.asp">페인트등록</a>
                <a class="nav-link" href="/paint_item.asp">페인트</a>
                <a class="nav-link" href="/tagong_itemin.asp">손잡이등록</a>
                <a class="nav-link" href="/tagong_item.asp">손잡이</a>
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemember" aria-expanded="false" aria-controls="collapsemember">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;DOC메뉴2
            </button>
            </h2>
            <div id="collapsemember" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="frmmgnt.asp">DOC서브메뉴4</a>
                <a class="nav-link" href="matmgnt.asp">DOC서브메뉴5</a>
                <a class="nav-link" href="appmgnt.asp">DOC서브메뉴6</a>
                <a class="nav-link" href="unitmgnt.asp">DOC서브메뉴7</a>
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
