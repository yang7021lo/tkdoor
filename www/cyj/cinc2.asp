<%
   cidx=Request("cidx")

    SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo, A.ctkidx, A.cgubun, A.cmove, A.caddr1, A.cmemo, A.cwdate, A.cbuy, A.csales "
    SQL=SQL&" , A.cnick, A.cnumber, A.cfile, A.ctype, A.citem, A.cemail1, A.cpost, A.caddr2, A.cbran, A.cdlevel, A.cflevel "
    SQL=SQL&" , A.calevel, A.cslevel, A.csylevel, A.cfax, A.ctel, A.ctel2 "
    SQL=SQL&" From tk_customer A "
    SQL=SQL&" Where A.cidx="&cidx&" "
    Rs.open SQL,Dbcon,1,1,1
    if not (Rs.EOF or Rs.BOF ) then
        rcidx=Rs(0)
        rcstatus=Rs(1)
        rcname=Rs(2)
        rcceo=Rs(3)
        rctkidx=Rs(4)
            select case rctkidx
                case "1"
                    rctkidx_text="태광도어"
                case "2"
                    rctkidx_text="티엔지단열프레임"
                case "3"
                    rctkidx_text="태광인텍"
            end select
        rcgubun=Rs(5)
            select case rcgubun
                case "1"
                    rcgubun_text="강화도어"
                case "2"
                    rcgubun_text="부속"
                case "3"
                    rcgubun_text="자동문"
                case "4"
                    rcgubun_text="창호,절곡"
                case "5"
                    rcgubun_text="프레임만"
                case "6"
                    rcgubun_text="소비자"
                case "7"
                    rcgubun_text="소송중"
                case "8"
                    rcgubun_text="거래처의거래처"
            end select
        rcmove=Rs(6)
            select case rcmove
                case "1"
                    rcmove_text="화물"
                case "2"
                    rcmove_text="낮1배달"
                case "3"
                    rcmove_text="낮2배달"
                case "4"
                    rcmove_text="밤1배달"
                case "5"
                    rcmove_text="밤2배달"
                case "6"
                    rcmove_text="대구창고"
                case "7"
                    rcmove_text="대전창고"
                case "8"
                    rcmove_text="부산창고"
                case "9"
                    rcmove_text="양산창고"
                case "10"
                    rcmove_text="익산창고"
                case "11"
                    rcmove_text="원주창고"
            end select        
        rcaddr1=Rs(7)
        rcmemo=Rs(8)
        rcwdate=Rs(9)
        rcbuy=Rs(10)
            select case rcbuy
                case "0"
                    rcbuy_text="X"
                case "1"
                    rcbuy_text="O"
            end select
        rcsales=Rs(11)
            select case rcsales
                case "0"
                    rcsales_text="X"
                case "1"
                    rcsales_text="O"
            end select
        rcnick=Rs(12)
        rcnumber=Rs(13)
        rcfile=Rs(14)
        rctype=Rs(15)
        rcitem=Rs(16)
        rcemail1=Rs(17)
        rcpost=Rs(18)
        rcaddr2=Rs(19)
        rcbran=Rs(20)
        rcdlevel=Rs(21)
            select case rcdlevel
                case "1"
                    rcdlevel_text="A"
                case "2"
                    rcdlevel_text="B"
                case "3"
                    rcdlevel_text="C"
                case "4"
                    rcdlevel_text="D"
                case "5"
                    rcdlevel_text="E"
            end select
        rcflevel=Rs(22)
            select case rcdlevel
                case "1"
                    rcflevel_text="A"
                case "2"
                    rcflevel_text="B"
                case "3"
                    rcflevel_text="C"
                case "4"
                    rcflevel_text="D"
                case "5"
                    rcflevel_text="E"
            end select
        rcalevel=Rs(23)
        select case rcdlevel
        case "1"
                rcflevel_text="A"
            case "2"
                rcflevel_text="B"
            case "3"
                rcflevel_text="C"
            case "4"
                rcflevel_text="D"
            case "5"
                rcflevel_text="E"
        end select
        rcslevel=Rs(24)
        select case rcslevel
            case "1"
                rcslevel_text="A"
            case "2"
                rcslevel_text="B"
            case "3"
                rcslevel_text="C"
            case "4"
                rcslevel_text="D"
            case "5"
                rcslevel_text="E"
        end select
        rcsylevel=Rs(25)
        select case rcsylevel
            case "1"
                rcsylevel_text="A"
            case "2"
                rcsylevel_text="B"
            case "3"
                rcsylevel_text="C"
            case "4"
                rcsylevel_text="D"
            case "5"
                rcsylevel_text="E"
        end select
        rcfax=Rs(26)
        rctel=Rs(27)
        rctel2=Rs(28)
      

    end if
    Rs.close
%>
        <div class="row mb-0">
<!-- 거래처 정보 시작 -->
            <table class="table table-bordered">
            <tbody>
                <tr>
                    
                    <th width="100px;" class="bg-light">업체명</th>
                    <td><%=rcname%></td>
                    <th class="bg-light">사업자번호</th>
                    <td><%=rcnumber%></td>
                    <th class="bg-light">대표자명</th>
                    <td><%=rcceo%></td>
                    <th class="bg-light">별칭</th>
                    <td colspan="3"><%=rcnick%></td>
       
                </tr>
                <!--
                <tr>
                    <th class="bg-light">업태</th>
                    <td><%=rctype%></td>
                    <th class="bg-light">업종</th>
                    <td><%=rcitem%></td>
                    <th class="bg-light">출고</th>
                    <td><%=rcmove_text%></td>
                    <th class="bg-light">지점</th>
                    <td><%=rcbran%></td>
                    <th class="bg-light">주소</th>
                    <td colspan="5"><%=rcpost%>&nbsp;&nbsp;<%=rcaddr1%>&nbsp;<%=rcaddr2%></td>
                </tr>
                -->
                <tr>
                    <th class="bg-light">대표전화</th>
                    <td><%=rctel%></td>
                    <th class="bg-light">대표전화2</th>
                    <td><%=rctel2%></td>
                    <th class="bg-light">대표팩스</th>
                    <td><%=rcfax%></td>
                    <th class="bg-light">업체구분</th>
                    <td><%=rcgubun_text%></td>
                    <th class="bg-light">사업장</th>
                    <td><%=rctkidx_text%></td>
        
                </tr>
                <!--
                <tr>
                    <th class="bg-light">매입처</th>
                    <td><%=rcbuy_text%></td>
                    <th class="bg-light">매출처</th>
                    <td><%=rcsales_text%></td>
                    <th class="bg-light">도어등급</th>
                    <td><%=rcdlevel_text%></td>
                    <th class="bg-light">프레임등급</th>
                    <td><%=rcflevel_text%></td>
                    <th class="bg-light">자동문등급</th>
                    <td><%=rcalevel_text%></td>
                    <th class="bg-light">보호대등급</th>
                    <td><%=rcslevel_text%></td>
                    <th class="bg-light">시스템등급</th>
                    <td><%=rcsylevel_text%></td>
                </tr>
 -->
            </tbody>
            </table>
<!-- 거래처 정보 끝 -->
        </div>
        <div  class="row mb-2 px-0 py-0">
<!-- 버튼 정보 시작 -->
            <div class="btn-group" role="group" aria-label="Basic outlined example">
            <button type="button" class="btn <% if hoyoung="1" then %>btn-primary<% else %>btn-outline-primary<% end if %>" onClick="location.replace('/cyj/corpudt.asp?cidx=<%=cidx%>')">정보수정</button>
            <button type="button" class="btn <% if hoyoung="2" then %>btn-success<% else %>btn-outline-success<% end if %>" onClick="">수주관리</button>
            <button type="button" class="btn <% if hoyoung="3" then %>btn-danger<% else %>btn-outline-danger<% end if %>" onClick="location.replace('/khy/list.asp?cidx=<%=cidx%>')">발주관리</button>
            <button type="button" class="btn <% if hoyoung="4" then %>btn-warning<% else %>btn-outline-warning<% end if %>" onClick="">매출내역</button>
            <button type="button" class="btn <% if hoyoung="5" then %>btn-info<% else %>btn-outline-info<% end if %>" onClick="location.replace('/cyj/corpview.asp?cidx=<%=cidx%>')">소속사용자</button>
            <button type="button" class="btn <% if hoyoung="6" then %>btn-secondary<% else %>btn-outline-secondary<% end if %>" onClick="location.replace('/ooo/advice/advicelist.asp?cidx=<%=cidx%>')">상담관리</button>
            <button type="button" class="btn <% if hoyoung="7" then %>btn-dark<% else %>btn-outline-dark<% end if %>" onClick="location.replace('/report/corpreport.asp?cidx=<%=cidx%>')">성적서</button>
            
            </div>
<!-- 버튼 정보 끝 -->
        </div>