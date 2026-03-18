<%


'If listgubun="one" Then 
'    headingOne="show"
'ElseIf listgubun="two" Then 
'    headingTwo="show"
'ElseIf listgubun="three" Then 
'    headingThree="show"
'ElseIf listgubun="four" Then 
'    headingFour="show"
'ElseIf listgubun="five" Then 
'    headingFive="show"
'ElseIf listgubun="six" Then 
'    headingSix="show"        
'End If


%>
<div id="layoutSidenav">
  <div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-light" id="sidenavAccordion">

<style>
.accordion-button::after {
    display: block;  /* 화살표 표시 */
}
.accordion-button {
    cursor: pointer !important;
}
.accordion-button:not(.collapsed)::after {
    transform: rotate(180deg);  /* 열렸을 때 화살표 회전 */
}
</style>

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingOne">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;발주
            </button>
            </h2>
            <div id="collapseOne" class="accordion-collapse collapse <%=headingOne%>" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
            <div class="accordion-body">
                <a class="nav-link" href="/tng1/TNG1_sujulist.asp">견적목록</a>
                <a class="nav-link" href="/tng1/TNG1_sujulist_balju.asp">수주목록</a>
                <!--
                <a class="nav-link" href="/tng1/TNG1_B.asp">수주_견적 등록</a>
                <a class="nav-link" href="/tng1/tng2.asp">수주서 출력</a>
                <a class="nav-link" href="/tng1/TNG1_KYUN.ASP">견적서 </a>
                <a class="nav-link" href="/tng1/tng10.asp">도면&유리치수 </a>
                <a class="nav-link" href="/tng1/tng11.asp">유리치수 </a>
                <a class="nav-link" href="/tng1/tng12.asp">내역서 </a>
                -->
            </div>
            </div>
        </div>        

        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;제품등록
            </h2>
            <div id="collapseTwo" class="accordion-collapse collapse <%=headingTwo%>" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
            <div class="accordion-body">
                <a class="nav-link" href="/TNG1/TNG1_FRAME_A_BAJU.asp">입면도면 테스트</a>
                <a class="nav-link" href="/TNG1/TNG1_GREEMLIST.asp">입면도면 보기</a>
                <a class="nav-link" href="/TNG1/TNG1_GREEMLIST_edit.asp">입면도면 리스트</a>
                <a class="nav-link" href="/TNG1/TNG1_GREEMLIST_editsub.asp">입면도면_서브등록</a>
                <!-- <a class="nav-link" href="/TNG1/TNG1_JULGOK_PUMMOK_LIST.asp">절곡도면 등록</a> -->
                <a class="nav-link" href="/tng1/TNG1_PUMMOK_Item.asp">품목등록</a>
                <a class="nav-link" href="/tng1/TNG1_SJB_TYPE_INSERTgl.asp">품목_유리도어_등록</a>
                <a class="nav-link" href="/tng1/TNG1_whichi_INSERT.asp?mode=sudong">품목_자재위치_등록</a>
                <a class="nav-link" href="/tng1/TNG1_BUSOK.asp">AL자재등록</a>
                <a class="nav-link" href="/tng1/TNG1_stain_Item_insert.asp">st자재등록</a>
                <!--<a class="nav-link" href="/tng1/TNG1_stain_Item_insertsub.asp">st자재_서브등록</a>-->
                <a class="nav-link" href="/tng1/stain_qtyco/index.asp">st자재_서브등록</a>
                <a class="nav-link" href="/tng1/unitprice2.asp">단가등록</a>
                <a class="nav-link" href="/tng1/unitprice3.asp">단가등록2</a>
                <a class="nav-link" href="/tng1/unittype_p.asp">수동 단가TABLE</a>
                <a class="nav-link" href="/tng1/unittype_pa.asp">자동 단가TABLE</a>
                <a class="nav-link" href="/tng1/unittype_al.asp">AL 단가TABLE</a>
                <a class="nav-link" href="/tng1/TNG1_pcent_whichi_INSERT.asp?mode=sudong">자재위치 할증등록</a>
                
            </div>
            </div>
        </div>



        <div class="accordion-item">
            <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseorder" aria-expanded="false" aria-controls="collapseorder">
                <div class="sb-nav-link-icon"><i class="fas fa-robot"></i></div>&nbsp;&nbsp;생산관리
            </button>
            </h2>
            <div id="collapseorder" class="accordion-collapse collapse <%=headingThree%>" aria-labelledby="headingThree" data-bs-parent="#accordionExample">
            <div class="accordion-body">
                <a class="nav-link" href="/tng1/TNG1_JULGOK_MASTER_GRID.asp">절곡 마스터 그리드</a>
                <a class="nav-link" href="/tng1/price_adjustment_v2.asp">단가인상현황</a>
                <a class="nav-link" href="/paint_color/index.asp">색상표</a>
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

    </nav>
</div>
