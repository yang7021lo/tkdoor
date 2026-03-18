<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")

%>
<%
rsjcidx=request("cidx")
rsjidx=request("sjidx")
rsjsidx=request("sjsidx")
rfkidx=request("fkidx")
'Response.Write "rsjsidx : " & rsjsidx & "<br>" 

'fkidx 찾기


%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <title>티엔지 발주서 (A4 세로)</title>
    <style>
    @page {
        size: A4 portrait; /* 세로 방향 A4 설정 */
        margin: 10mm;
    }

    @media print {
        body {
        margin: 0;
        }

        .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */

        .print-container {
        width: 100%;
        font-size: 12px;
        }

        table {
        width: 100%;
        border-collapse: collapse;
        }

        th, td {
        border: 0.3mm solid #333;
        padding: 0px;
        vertical-align: middle;
        text-align: center;
        }

        .header {
        background-color: #f0f0f0;
        font-weight: bold;
        }

        .highlight {
        background-color: yellow;
        font-weight: bold;
        font-size: 16px;
        }

        .sub-header {
        background-color: #ddd;
        font-weight: bold;
        }

        .left {
        text-align: left;
        }

        .bold {
        font-weight: bold;
        }
    }

    /* 화면 보기용 */
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f9f9f9;
    }

    .print-container {
        width: 800px;
        margin: 0 auto;
        border: 1px solid #333;
        padding: 10px;
        background-color: #fff;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        border: 1px solid #333;
        padding: 0px;
        text-align: center;
    }

    .highlight {
        background-color: yellow;
        font-weight: bold;
        font-size: 18px;
    }

    .qr-code {
        width: 80px;
        height: 80px;
        background-color: #eee;
        line-height: 80px;
        margin: 0 auto;
    }

    </style>
</head>
<body>
<%
'수주 기본 정보불러오기
'===================
SQL="Select Convert(Varchar(10),A.sjdate,121), A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121) "
SQL=SQL&" , A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx, A.midx, A.wdate, A.meidx, A.mewdate  "
SQL=SQL&" , B.cname, C.mname, C.mtel, C.mhp, C.mfax, C.memail, D.mname, E.mname, A.su_kjtype "
SQL=SQL&" From TNG_SJA A "
SQL=SQL&" Join tk_customer B On A.sjcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.sjmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Where sjidx='"&rsjidx&"' " 
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
  sjdate=Rs(0)    '수주일
  sjnum=Rs(1)     '수주번호
  cgdate=Rs(2)    '출고일자
  djcgdate=Rs(3)  '도장출고일자
  cgtype=Rs(4)    '출고방식
  cgaddr=Rs(5)    '현장명
  cgset=Rs(6)     '입금후 출고 설정
  sjmidx=Rs(7)    '거래처 담당자키
  sjcidx=Rs(8)    '거래처 키
  midx=Rs(9)      '등록자키
  wdate=Rs(10)    '등록일시
  meidx=Rs(11)    '수정자키
  mewdate=Rs(12)  '수정일시
  cname=Rs(13)    '거래처명
  mname=Rs(14)    '거래처 담당자명
  mtel=Rs(15)     '거래처 담당자 전화번호
  mhp=Rs(16)      '거래처 담당자 휴대폰
  mfax=Rs(17)     '거래처 담당자 팩스
  memail=Rs(18)   '거래처 담당자 이메일
  amname=Rs(19)   '등록자명
  bmname=Rs(20)   '수정자명
  su_kjtype=Rs(21) '견적이냐 수주냐냐. 견적이 1 수주주가 2  <----- 수주인지 견적인지 구분 

    Select Case cgtype
        Case "1"
            cgtype_text = "화물"
        Case "2"
            cgtype_text = "낮1배달"
        Case "3"
            cgtype_text = "낮2배달"
        Case "4"
            cgtype_text = "밤1배달"
        Case "5"
            cgtype_text = "밤2배달"
        Case "6"
            cgtype_text = "대구창고"
        Case "7"
            cgtype_text = "대전창고"
        Case "8"
            cgtype_text = "부산창고"
        Case "9"
            cgtype_text = "양산창고"
        Case "10"
            cgtype_text = "익산창고"
        Case "11"
            cgtype_text = "원주창고"
        Case "12"
            cgtype_text = "제주창고"
        Case Else
            cgtype_text = "미지정"
    End Select

End If
Rs.Close
%>
<%
'품목정보
'===================



    SQL = "SELECT a.mwidth, a.mheight, a.qtyidx, a.sjsprice, a.disrate, a.disprice, "
    SQL = SQL & "a.fprice, a.sjb_idx, a.quan, a.taxrate, a.sprice, a.asub_wichi1, "
    SQL = SQL & "a.asub_wichi2, a.asub_bigo1, a.asub_bigo2, a.asub_bigo3, a.asub_meno1, "
    SQL = SQL & "a.asub_meno2, a.astatus, a.py_chuga, a.door_price, a.whaburail, a.robby_box, "
    SQL = SQL & "a.jaeryobunridae, a.boyangjea, a.pidx, b.sjb_type_no "
    SQL = SQL & ",c.pname ,d.qtyname ,c.p_image "
    SQL = SQL & "FROM tng_sjaSub a "
    SQL = SQL & "left outer JOIN TNG_SJB b ON b.sjb_idx = a.sjb_idx "
    SQL=SQL&" Left Outer JOin tk_paint c On a.pidx=c.pidx "
    SQL=SQL&" left outer Join tk_qty d On a.qtyidx=d.qtyidx "
    SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "' "
    'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then
        sja_mwidth        = Rs(0)   ' 검측 가로
        sja_mheight       = Rs(1)   ' 검측 세로
        sja_qtyidx        = Rs(2)   ' 재질
        sja_sjsprice      = Rs(3)   ' 품목가
        sja_disrate       = Rs(4)   ' 할인율
        sja_disprice      = Rs(5)   ' 할인가

        sja_fprice        = Rs(6)   ' 최종가
        sja_sjb_idx       = Rs(7)   ' sjb_idx
        sja_quan          = Rs(8)   ' 수량
        sja_taxrate       = Rs(9)   ' 세율
        sja_sprice        = Rs(10)  ' 공급가
        sja_sub_wichi1    = Rs(11)  ' 위치1

        sja_sub_wichi2    = Rs(12)  ' 위치2
        sja_sub_bigo1     = Rs(13)  ' 비고1
        sja_sub_bigo2     = Rs(14)  ' 비고2
        sja_sub_bigo3     = Rs(15)  ' 비고3
        sja_sub_meno1     = Rs(16)  ' 추가사항1
        sja_sub_meno2     = Rs(17)  ' 추가사항2

        sja_astatus       = Rs(18)  ' 상태
        sja_py_chuga      = Rs(19)  ' 추가금
        sja_door_price    = Rs(20)  ' 도어가격
        sja_whaburail     = Rs(21)  ' 하부레일
        sja_robby_box     = Rs(22)  ' 로비박스
        sja_jaeryobunridae= Rs(23)  ' 자재분리대

        sja_boyangjea     = Rs(24)  ' 보양개수
        sja_pidx          = Rs(25)  ' 페인트 pidx
        sja_sjb_type_no   = Rs(26)  ' 제품타입
        sja_pname             = Rs(27)  ' 페인트 이름
        sja_qtyname           = Rs(28)  ' 재질 이름
        sja_p_image          = Rs(29)  ' 페인트 이미지
    End If
    Rs.Close

'===================
'품목정보 끝
%>
<%
'프레임 정보 불러오기
'===================

SQL = "SELECT A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi"
SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO, A.sjb_idx, b.fstype, b.blength"
SQL = SQL & ", B.WHICHI_FIX, B.WHICHI_AUTO, D.glassselect, E.glassselect "
SQL = SQL & ", B.door_w, B.door_h , B.glass_w, B.glass_h, B.ysize,b.doortype "
SQL = SQL & ", a.fname,a.tw,a.th,a.ow,a.oh,a.fl,a.dooryn ,a.GREEM_F_A "
SQL = SQL & ", f.SJB_barlist, g.sjb_type_name ,a.greem"
SQL = SQL & " FROM tk_framek A"
SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
SQL = SQL & " LEFT OUTER JOIN tng_whichitype D ON B.WHICHI_FIX = D.WHICHI_FIX "
SQL = SQL & " LEFT OUTER JOIN tng_whichitype E ON B.WHICHI_AUTO = E.WHICHI_AUTO"
SQL = SQL & " left outer Join tng_sjb f On a.sjb_idx=f.sjb_idx "
SQL=SQL&" Left Outer JOin tng_sjbtype g On f.sjb_type_no=g.sjb_type_no "
SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "' " ' sja 로 크게 루프?? 
'SQL = SQL & "and a.fkidx = '" & rfkidx & "' "
'Response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
    fkidx         = Rs(0) '품목별. 자동은 1개당 1장 수동은 집합해서 모아서 출력
    fksidx        = Rs(1)
    xi            = Rs(2)
    yi            = Rs(3)
    wi            = Rs(4)
    hi            = Rs(5)
    set_name_FIX  = Rs(6) '수동 자재이름
    set_name_AUTO = Rs(7) '자동 자재이름
    sjb_idx       = Rs(8)
    fstype        = Rs(9) 
    yblength      = Rs(10) '절단길이
    whichi_fix    = Rs(11)
    whichi_auto   = Rs(12)
    glassselect_fix   = Rs(13)
    glassselect_auto   = Rs(14)
    door_w            = Rs(15)
    door_h            = Rs(16)
    glass_w = Rs(17)
    glass_h = Rs(18)
    ysize = Rs(19)
    doortype = Rs(20)
    fname = Rs(21) '프레임 이름
    tw = Rs(22) '검측 가로
    th = Rs(23) '검측 세로
    ow = Rs(24) '오픈 가로   
    oh = Rs(25) '오픈 세로
    fl = Rs(26) '묻힘
    dooryn = Rs(27) '도어유무
    SJB_barlist = Rs(28) '프레임 규격
    sjb_type_name = Rs(29) '프레임 타입 이름

     select case dooryn_text
        case 0
            dooryn_text="도어나중"
        case 1
            dooryn_text="도어같이"
        case 2
            dooryn_text="도어안함"
     end select

End If
Rs.Close
'===================
'프레임 끝                            
%>
    <div class="print-container">
        <div class="row ">
            <div class="container mt-1 TEXT-CENTER">
                <button class="print-btn" onclick="window.print()">🖨️[제품라벨 : 100x45] 레이블 프린터 전용 출력하기</button>
            </div>
        </div>
        <table>
        <th colspan="4">티엔지 AL 발주서</th>
        <th colspan="2">발주처</th>
            <td colspan="2">울산화성특수</td>
        <tr>
        <th>수주일자</th>
            <th><%=sjdate%>(<%=WeekdayName(Weekday(sjdate), True)%>)</th>
            <th>수주번호</th>
            <th><%=sjnum%></th>
        </tr>
        <tr>
            <th>도장출고일자</th>
            <th><%=djcgdate%>(<%=WeekdayName(Weekday(djcgdate), True)%>)</th>
            <th>출고일자</th>
            <th><%=cgdate%> (<%=WeekdayName(Weekday(cgdate), True)%>)</th>
            <th>출고방식</th>
            <th><%=cgtype_text%></th>
            <!--
            출고방식이 배달/화물/용차/방문 인데 현대 배달만 설정되어 있음
            화물일 경우 화물지점 설정하도록
            용차일 경우 용차정보 설정하도록 추가관리 필요???
            발주서에는 생략하고 따로 리스트 업해야하는게 더 좋은지??
            -->
        </tr>

        <tr>
        <th>현장명</th>
            <th><%=cgaddr%></th>
            <th>현장명</th>
            <th><%=cgaddr%></th>
        </tr>
            <th>프레임타입</th>
            <th><%=SJB_barlist%>_<%=sjb_type_name%>_<%=fname%></th>

        </tr>

   
        <tr>
            <th>재질/색상</th>
            
            <td colspan="3"><%=sja_qtyname%></td>
            <td colspan="3"><%=sja_pname%></td>
            <td> <!-- 페인트 이미지 p_image -->
            <img src="/img/paint/<%=sja_p_image%>" loading="lazy" width="170" height="50"  border="0">
            </td>  
             <th>수량</th>
            <td colspan="3"><%=sja_quan%>틀</td>
        </tr>
              <tr>
            <th>검측</th>
            <td><%=tw%></td>
            <td>X</td>
            <td><%=th%></td>
        </tr>
        <tr>
            <th>오픈</th>
            <td><%=ow%></td>
            <td>X</td>
            <td><%=oh%></td>
        </tr>
        <tr>
            <th>도어유무</th>
            <th><%=dooryn_text%></th>
    
        </tr>

        </table>

        <table style="margin-top: 10px;">
<%
SQL = "SELECT A.fkidx, B.fksidx, B.ysize , b.blength , B.WHICHI_FIX, B.WHICHI_AUTO "
SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO "
SQL = SQL & ",  B.xsize ,c.bfidx "
SQL = SQL & ",c.TNG_Busok_idx,c.TNG_Busok_idx2,c.TNG_Busok_idx3 "
SQL = SQL & ",c.bfimg1,c.bfimg2,c.bfimg3 ,c.bfimg4 "
SQL = SQL & ",d.T_Busok_name_f,e.T_Busok_name_f,f.T_Busok_name_f " 
SQL = SQL & ",d.TNG_Busok_images,e.TNG_Busok_images,f.TNG_Busok_images ,GREEM_F_A " 
SQL = SQL & " FROM tk_framek A"
SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
SQL = SQL & " LEFT OUTER JOIN TNG_Busok d ON c.TNG_Busok_idx = d.TNG_Busok_idx"
SQL = SQL & " LEFT OUTER JOIN TNG_Busok e ON c.TNG_Busok_idx2 = e.TNG_Busok_idx"
SQL = SQL & " LEFT OUTER JOIN TNG_Busok f ON c.TNG_Busok_idx3 = f.TNG_Busok_idx"
SQL = SQL & " WHERE a.sjsidx = '" & rsjsidx & "' "
SQL = SQL & " and b.gls=0 " ' 자재일 경우
'Response.write (SQL)&"<br>"
'response.end
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF

fkidx            = Rs(0) '품목별. 자동은 1개당 1장 수동은 집합해서 모아서 출력
fksidx           = Rs(1)
ysize            = Rs(2) '정면폭 -set_name_FIX or set_name_AUTO  포함됨
blength          = Rs(3) '절단치수
whichi_fix       = Rs(4)
whichi_auto      = Rs(5)
set_name_FIX     = Rs(6) '수동품명
set_name_AUTO    = Rs(7) '자동품명
xsize = rs(8)   '측면폭 -set_name_FIX or set_name_AUTO  포함됨
bfidx = rs(9) 
TNG_Busok_idx = rs(10) '소요 알루미늄자재 1
TNG_Busok_idx2 = rs(11) '소요 알루미늄자재재 2
TNG_Busok_idx3  = rs(12) '소요 알루미늄자재 3
bfimg1  = rs(13)  '자재 결합 이미지1
bfimg2  = rs(14) '자재 결합 이미지2
bfimg3  = rs(15) '자재 결합 이미지3
bfimg4  = rs(16) '자재 결합 이미지4
T_Busok_name_f1  = rs(17) '알루미늄 원 자재명1
T_Busok_name_f2  = rs(18)  '알루미늄 원 자재명2
T_Busok_name_f3  = rs(19) ' 알루미늄 원 자재명3
TNG_Busok_images1  = rs(20) ' 알루미늄 원 자재이미지1
TNG_Busok_images2  = rs(21) '알루미늄 원 자재이미지2
TNG_Busok_images3  = rs(22) '알루미늄 원 자재이미지3
GREEM_F_A = Rs(23) '   GREEM_F_A=1(수동) ,  GREEM_F_A=2(자동) 

    if GREEM_F_A = 1 then ' 수동일 경우

    '수동은 모아서 한번에 출력

    elseif GREEM_F_A = 2 then  '자동일 경우
    '자동은 fkidx 1개당 1페이지 출력
    %>

    <tr>
            <th colspan="4" rowspan="4">품명</th>
            <th colspan="4" rowspan="4" ><%=set_name_AUTO%></th>
            <td colspan="4" rowspan="4"> <!-- 자재 결합 이미지1 TNG_Busok_images1 -->
                <img src="/img/frame/bfimg/<%=bfimg1%>"   height="30" >
            </td>  
            <!-- 알루미늄 원 자재는 기본이 1개 총 3개일 수 있음. 조건문이 ....  -->
            <th rowspan="1">자재명1</th>
            <td rowspan="1">  <!-- 알루미늄 원 자재이미지1 -->
                <img src="/img/frame/bfimg/<%=TNG_Busok_images1%>"   height="30" >
            </td>  
            <td rowspan="1"><%=T_Busok_name_f1%></td>
            
            <th rowspan="4">절단치수</th>
            <td rowspan="4"><%=blength%>mm</td>
            <th  rowspan="4">수량</th>
            <td rowspan="4"><%=sja_quan%>개</td>
        </tr>
        <tr>
            <th rowspan="1">자재명2</th>
            <td rowspan="1"> <!-- 알루미늄 원 자재이미지2 -->
            <img src="/img/frame/bfimg/<%=TNG_Busok_images2%>"   height="30" >
            </td> 
            <td rowspan="1"><%=T_Busok_name_f2%></td>
        </tr>
        <tr>
            <th rowspan="1">자재명3</th>
            <td rowspan="1"> <!-- 알루미늄 원 자재이미지3 -->
            <img src="/img/frame/bfimg/<%=TNG_Busok_images3%>"   height="30" >
            </td> 
            <td rowspan="1" ><%=T_Busok_name_f3%></td>
        </tr>
        <tr>
        
        </tr>

    <%
    End If
%>
        

            
        
<%
Rs.movenext
Loop
End if
Rs.close
%>
        </table>

<div class="row ">
    <div class="col-12 text-end">
Coded By SUN
    </div>
 </div>
    </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
</body>
</html>

<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
