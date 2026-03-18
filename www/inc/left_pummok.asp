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
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsepaint" aria-expanded="false" aria-controls="collapsepaint">
                <div class="sb-nav-link-icon"><i class="fa fa-id-card"></i></div>&nbsp;&nbsp;품목등록-도어
            </button>
            </h2>
            <div id="collapsepaint" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="pummok_door.asp">도어품목</a>
                <a class="nav-link" href="pummok_goods.asp">품명(안전/일반)</a>
                <a class="nav-link" href="pummok_barlist.asp">규격(50*90)</a>
                <a class="nav-link" href="pummok_glass.asp">유리</a>                
                <a class="nav-link" href="pummok_key.asp">키</a>
                <a class="nav-link" href="pummok_tagong.asp">손잡이</a>
                <a class="nav-link" href="pummok_hinge.asp">힌지</a>
                <a class="nav-link" href="pummok_kyukja.asp">격자</a>
                <a class="nav-link" href="pummok_busok.asp">부속자재</a> 
                <a class="nav-link" href="pummok_Busok_ST_item.asp">도어 절곡바라시</a> 
                <a class="nav-link" href="p_in_list.asp">중간바</a>
                <a class="nav-link" href="p_out.asp?listgubun=two&subgubun=two3">기타가공</a>                                 

            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fa fa-microchip"></i></div>&nbsp;&nbsp;자동문
            </button>
            </h2>
            <div id="collapsepaint" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="p_in.asp">완제품</a>
                <a class="nav-link" href="p_in_list.asp">세트부속</a>
                <a class="nav-link" href="p_out.asp?listgubun=two&subgubun=two3">기본부속</a>
                <a class="nav-link" href="p_in_list.asp">기타부속</a>
                <a class="nav-link" href="p_out.asp?listgubun=two&subgubun=two3">옵션 제품</a>                
                    
            </div>
            </div>
        </div>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fa fa-microchip"></i></div>&nbsp;&nbsp;단열
            </button>
            </h2>
            <div id="collapsepaint" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="p_in.asp">단열</a>
                    
            </div>
            </div>
        </div>  

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFour">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fa fa-microchip"></i></div>&nbsp;&nbsp;보호대
            </button>
            </h2>
            <div id="collapsepaint" class="accordion-collapse collapse <%=headingFour%>" aria-labelledby="headingFour" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="p_in.asp">보호대</a>
                    
            </div>
            </div>
        </div> 

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFive">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fa fa-microchip"></i></div>&nbsp;&nbsp;기타
            </button>
            </h2>
            <div id="collapsepaint" class="accordion-collapse collapse <%=headingFive%>" aria-labelledby="headingFive" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="pummok_glass.asp">유리</a>
                <a class="nav-link" href="p_in.asp">기타품목</a>
                <a class="nav-link" href="pummok_paint.asp">페인트</a>
                <a class="nav-link" href="p_in.asp">원자재</a>                                                
                    
            </div>
            </div>
        </div>                           
        
    
    
<!--  
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingFive">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsemat" aria-expanded="false" aria-controls="collapsemat">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;자재
            </button>
            </h2>
            <div id="collapsemat" class="accordion-collapse collapse <%=headingFour%>" aria-labelledby="headingFour" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="m_basic.asp?listgubun=four&subgubun=four1">재고기초</a>
                <a class="nav-link" href="m_inout.asp?listgubun=four&subgubun=four2">입출고등록</a>
                <a class="nav-link" href="m_lot.asp?listgubun=four&subgubun=four3">로트별 재고현황</a>
                <a class="nav-link" href="m_inout_check.asp?listgubun=four&subgubun=four4">수불집계</a>
                <a class="nav-link" href="m_inout_list.asp?listgubun=four&subgubun=four5">수불대장</a>

            </div>
            </div>
        </div>

        <div class="accordion" id="accordionExample">

            <div class="accordion-item">
                <h2 class="accordion-header" id="headingSix">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsekolas" aria-expanded="false" aria-controls="collapsekolas">
                    <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;성적서
                </button>
                </h2>
                <div id="collapsekolas" class="accordion-collapse collapse <%=headingFive%>" aria-labelledby="headingFive" data-bs-parent="#accordionExample">
                <div class="accordion-body">
                    <a class="nav-link" href="ko_pass.asp?listgubun=five&subgubun=five1">발행</a>
                    <a class="nav-link" href="ko_list.asp?listgubun=five&subgubun=five2">현황</a>
                    <a class="nav-link" href="ko_in.asp?listgubun=five&subgubun=five3">기초성적서등록 </a>
                    <a class="nav-link" href="ko_check.asp?listgubun=five&subgubun=five4">조회후재발송</a>
                    
                </div>
                </div>
            </div>

        

     

        

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingSeven">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseclass" aria-expanded="false" aria-controls="collapseclass">
                <div class="sb-nav-link-icon"><i class="fas fa-chalkboard-teacher"></i></div>&nbsp;&nbsp;거래처
            </button>
            </h2>
            <div id="collapseclass" class="accordion-collapse collapse <%=headingSix%>" aria-labelledby="headingSix" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/mem/corplist.asp">거래처목록</a>
                <a class="nav-link" href="#">2</a>

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
