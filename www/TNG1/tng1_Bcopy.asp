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

  listgubun="one" 
  projectname="발주 및 견적"

  rsjcidx=request("sjcidx") '발주처idx
  rsjmidx=request("sjmidx") '거래처담당자idx
  rsjidx=request("sjidx") '수주idx
  rsjsidx=request("sjsidx") '품목idx

  SearchWord=Request("SearchWord")
  gubun=Request("gubun")
 

	page_name="tng1_b.asp?listgubun="&listgubun&"&"




SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnumber,B.mname, B.mhp "
SQL=SQL&" From tk_customer A "
SQL=SQL&" Left outer Join tk_member B On A.cidx=B.cidx "
SQL=SQL&" Where B.midx='"&rsjmidx&"' "
SQL=SQL&"  Order by A.cname asc "
'Response.write (SQL)
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  cidx=Rs(0)
  cstatus=Rs(1)
    select case cstatus
      case "0"
        cstatus_text="미사용"
      case "1"
        cstatus_text="사용"
    end select
  cname=Rs(2)
  cceo=Rs(3)
  ctkidx=Rs(4)
    If ctkidx="1" then 
      ctkidx_text="태광도어"
    Elseif ctkidx="2" then 
      ctkidx_text="티엔지단열프레임"
    Elseif ctkidx="3" then
      ctkidx_text="태광인텍"
    End If 

  caddr1=Rs(5)
  cmemo=Rs(6)
  cwdate=Rs(7)
  ctel=Rs(8)
  cfax=Rs(9)
  cnumber=Rs(10)
  cnumtext=Left(cnumber,3)&"-"&Mid(cnumber,4,2)&"-"&Right(cnumber,5)
  mname=Rs(11)
  mhp=Rs(12)
  if cmemo<>"" then cmemo=replace(cmemo, chr(13)&chr(10),"<br>")

End If
Rs.Close

'=============
'수주정보 시작
sjdate=Request("sujudate")
if sjdate="" then sjdate=date() end if 

if rsjidx="" then '수주정보가 없다면
  'response.write "<br><br><br><br><br><br><br><br>"
  SQL="select max(sjnum) from TNG_SJA where Convert(varchar(10),sjdate,121)='"&sjdate&"' "
  'response.write (SQL)&"<br><br><br><br><br><br><br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    sjnum=Rs(0)
    If Isnull(sjnum) then
      sjnum="1"
    else
      sjnum=sjnum+1
    End If

  End if
  RS.Close

else    '수주정보가 있다면
  SQL="select sjdate, sjnum, Convert(Varchar(10),cgdate,121), Convert(Varchar(10),djcgdate,121), cgtype, cgaddr, cgset, sjmidx, sjcidx "
  SQL=SQL&" , midx, Convert(Varchar(10),wdate,121), meidx, Convert(Varchar(10),mewdate,121) "
  SQL=SQL&" From tng_sja where sjidx='"&rsjidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      sjdate=Rs(0)
      sjnum=Rs(1)
      cgdate=Rs(2)
      djcgdate=Rs(3)
      cgtype=Rs(4)
      cgaddr=Rs(5)
      cgset=Rs(6)
      sjmidx=Rs(7)
      sjcidx=Rs(8)
      midx=Rs(9)
      wdate=Rs(10)
      meidx=Rs(11)
      mewdate=Rs(12)
    End if
    RS.Close

end if

'=============
'수중정보 끝
'=============
'품목삭제 시작 
if Request("gubun")="udt1" then 

    SQL=" update tng_sjaSub set astatus=0 where sjsidx='"&rsjsidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

end if
'품목삭제 끝
'=============

'수주금액 입력 시작
'=============
if gubun="supriceinput" then 
  tsprice=Request("tsprice")        '수주 공급가 합
  trate=Request("trate")            '수주 추가할인율
  if trate="" then trate="0" end if
  tdisprice=Request("tdisprice")    '수주 추가할인금액
  if tdisprice="" then tdisprice="0" end if
  tfprice=Request("tfprice")        '수주 최종 공급가
  taxprice=Request("taxprice")      '세액 합
  tzprice=Request("tzprice")        '수주 최종가

response.write trate&"/<br>"
end if
'=============
'수주금액 입력 끝
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
    <link rel="icon" sizes="image/x-icon" href="/inc/tkico.png">
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        a:link {
        color: #070707;
        text-decoration: none;
        }
        a:visited {
        color: #070707;
        text-decoration: none;
        }
        a:hover {
        color: #070707;
        text-decoration: none;
        }
    </style>
    <style>
        body {
            /zoom: 0.8;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 카드 전체 크기 조정 */
        .card.card-body {
            padding: 10px; /* 내부 여백 줄이기 */
            margin-bottom: 0.5rem; /* 하단 여백 줄이기 */
        }

        /* 글씨 크기 및 입력 필드 크기 조정 */
        .form-control {
            font-size: 14px; /* 글씨 크기 줄이기 */
            height: 25px; /* 입력 필드 높이 줄이기 */
            padding: 1px 1px; /* 내부 여백 줄이기 */
        }

        /* 레이블 크기 조정 */
        label {
            font-size: 14px;
            margin-bottom: 0px; /* 레이블과 입력 필드 간격 최소화 */
        }

        /* 행(row) 간격 줄이기 */
        .row {
            margin-bottom: 0px; /* 행 간격 줄이기 */
        }
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 14px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
    <script>
        function validateform() {
            if(document.frmMain.sjcidx.value == "" ) {
                alert("거래처를 선택하세요.");
            return
            }
            if(document.frmMain.cgdate.value == "" ) {
                alert("출고 날짜를 입력해주세요.");
            return
            }
            if(document.frmMain.djcgdate.value == "" ) {
                alert("도장출고 날짜를 입력해주세요.");
            return
            }
            if(document.frmMain.cgaddr.value == "" ) {
                alert("현장명을 입력해주세요.");
            return
            }
            else {
                document.frmMain.submit();
            }
        }

        function yong() {
            if(document.fyong.yname.value == "" ) {
                alert("용차 받는분 이름을 입력하세요.");
            return
            }
            if(document.fyong.ytel.value == "" ) {
                alert("용차 받는분 전화번호를 입력하세요.");
            return
            }
            if(document.fyong.yaddr.value == "" ) {
                alert("하차지 주소를 입력하세요.");
            return
            }
            if(document.fyong.ydate.value == "" ) {
                alert("용차 도착일시를 입력해주세요.");
            return
            }
            if(document.fyong.ymemo.value == "" ) {
                alert("당부사항을 입력해 주세요.");
            return
            }
            if(document.fyong.ycarnum.value == "" ) {
                alert("용차 차량번호를 입력해 주세요.");
            return
            }
            if(document.fyong.ygisaname.value == "" ) {
                alert("용차 운전자명을 입력해 주세요.");
            return
            }
            if(document.fyong.ygisatel.value == "" ) {
                alert("운전자 전화번호를 입력해 주세요.");
            return
            }
            if(document.fyong.ycostyn.value == "" ) {
                alert("착불여부을 선택해 주세요.");
            return
            }
            if(document.fyong.yprepay.value == "" ) {
                alert("선불금액을 입력해 주세요.");
            return
            }

            else {
                document.fyong.submit();
            }
        }   
        function del(sTR){
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_db.asp?gubun=delete&sjidx=<%=rsjidx%>";
            }
        }
        function udt1(rsjsidx){
            if (confirm("삭제 하시겠습니까?"))
            {
               
                location.href="TNG1_B.asp?gubun=udt1&sjidx=<%=rsjidx%>&sjsidx="+rsjsidx;
            }
        }
        
        function delyong(sTR){
            if (confirm("용차정보를 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_dbyong.asp?gubun=delete&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
            }
        }
        function inputPhoneNumber(obj){
            var number = obj.value.replace(/[^0-9]/g,"");
            var phone = "";

            if(number.length < 4) {
                return number;
            }else if(number.length < 7) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3);
            }else if(number.length < 11) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,3);
                phone += "-";
                phone += number.substr(6);
            }else{
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,4);
                phone += "-";
                phone += number.substr(7);
            }
            obj.value = phone;
        }
    </script>

    <script type="text/javascript">
        let basePrice = <%= basePrice %>;

        function formatNumber(num) {
            return num.toLocaleString('ko-KR');
        }

        function unformatNumber(str) {
            return parseInt(str.replace(/,/g, '')) || 0;
        }

        function updateFromRate() {
            let rate = parseFloat(document.getElementById("discountRate").value) || 0;
            let discountAmount = Math.floor(basePrice * (rate / 100));
            updateValues(basePrice - discountAmount);
        }

        function updateFromAmount() {
            let discountAmount = unformatNumber(document.getElementById("discountAmount").value);
            updateValues(basePrice - discountAmount);
        }

        function updateFromDiscountedPrice() {
            let discountedPrice = unformatNumber(document.getElementById("discountedPrice").value);
            updateValues(discountedPrice);
        }

        function updateValues(discountedPrice) {
            let discountAmount = basePrice - discountedPrice;
            let rate = ((discountAmount / basePrice) * 100).toFixed(2);
            let tax = Math.floor(discountedPrice * 0.10);
            let finalPrice = discountedPrice + tax;

            document.getElementById("discountRate").value = rate;
            document.getElementById("discountAmount").value = formatNumber(discountAmount);
            document.getElementById("discountedPrice").value = formatNumber(discountedPrice);
            document.getElementById("tax").value = formatNumber(tax);
            document.getElementById("finalPrice").value = formatNumber(finalPrice);
        }

        window.onload = function () {
            updateFromRate();
        };
    </script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
<!-- 거래처 정보 선택 시작  -->
        <div class="card card-body mb-1">  
          <div class="row ">
              <div class="col-md-2">
              <label for="name">거래처</label><p>
              <input type="text" class="form-control" id="cname" name="cname" placeholder="" value="<%=cname%>" onclick="window.open('choicecorp.asp','cho','top=100, left=400, width=800, height=600');">
              </div>
              <div class="col-md-2">
              <label for="name">사업장</label><p>
              <input type="text" class="form-control" id="ctkidx_text" name="ctkidx_text" placeholder="" value="<%=ctkidx_text%>" readonly>
              </div> 
              <div class="col-md-1">
              <label for="name">TEL</label><p>
              <input type="text" class="form-control" id="" name="ctel" placeholder="" value="<%=ctel%>" readonly>
              </div> 
              <div class="col-md-1">
              <label for="name">FAX</label><p>
              <input type="text" class="form-control" id="cfax" name="cfax" placeholder="" value="<%=cfax%>" readonly>
              </div> 
              <div class="col-md-2">
              <label for="name">비고</label><p>
              <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
              </div>
              <div class="col-md-2">
              <label for="name">참고사항</label><p>
              <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
              </div>
              <div class="col-md-2">
              <label for="name">관리등급</label><p>
              <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
              </div>
          </div>
        </div>
<!-- 거래처 정보 선택 끝  -->
<!-- 수주정보 선택 시작  -->

              <div class="card card-body mb-1">  
<form name="frmMain" action="TNG1_B_db.asp" method="post" enctype="multipart/form-data">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">수주일자</label><p>
                        <input type="date" class="form-control" id="sjdate" name="sjdate" placeholder="<%=sjdate%>" value="<%=sjdate%>" >
                    </div>
                    <div class="col-md-1">
                        <label for="name">수주번호</label><p>
                        <input type="number" class="form-control" id="sjnum" name="sjnum" placeholder="<%=sjnum%>" value="<%=sjnum%>" readonly>
                    </div> 
                    <div class="col-md-1">
                        <label for="name">출고일자</label><p>
                        <input type="date" class="form-control" id="cgdate" name="cgdate" placeholder="" value="<%=cgdate%>" >
                    </div>
                    <div class="col-md-1">
                        <label for="name">도장출고일자</label><p>
                        <input type="date" class="form-control" id="djcgdate" name="djcgdate" placeholder="" value="<%=djcgdate%>" >
                    </div>  
                    <div class="col-md-1">
                        <label for="name">출고방식</label><p>
                        <select name="cgtype" class="form-control" id="cgtype" required>
                            <option value="1">A타입</option>
                            <option value="2">B타입</option>
                            <option value="3">C타입</option>
                            <option value="4">D타입</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="name">현장명</label><p>
                        <input type="text" class="form-control" id="cgaddr" name="cgaddr" placeholder="" value="<%=cgaddr%>" >
                    </div>

 
                    <div class="col-md-1">
                        <label for="name">입금후출고 설정</label><p>
                        <select name="cgset" class="form-control" id="cgtype" required>
                            <option value="0">해당없음</option>
                            <option value="1">적용</option>

                        </select>
                    </div>
                    <div class="col-md-1">
                        <label for="name"> 업체담당자명</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="<%=mname%>" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">업체담당자 TEL</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="<%=mhp%>"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">수정/저장/삭제</label><p>
                        <button class="btn btn-success btn-small" type="button" Onclick="validateform();"><% if rsjidx="" then %>저장<% else %>수정<% end if %></button>
                        <% if rsjidx<>"" then %><button class="btn btn-danger btn-small" type="button" onclick="del();">삭제</button><% end if %>
                    </div>
                </div>
</form>
              </div>

<!-- 수주정보 선택 끝  -->
<form name="frmMain1" action="TNG1_B_db.asp" method="post" enctype="multipart/form-data">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">

            <div class="card card-body mb-1">  <!-- * 견적  /  품목선택 -->
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">견적/발주</label><p>
                        <button class="btn btn-primary btn-small " type="button" >견적</button>
                        <button class="btn btn-success btn-small " type="button" >발주</button>
                    </div>
                    <div class="col-md-1">
                        <label for="name">품번번호</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                    <div class="col-md-2">
                        <label for="name">품번번호 추가/삭제</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">품목</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">스텐재질</label><p>
                        <select name="SJY_yongmoney_yn" class="form-control" id="SJY_yongmoney_yn" required>
                          <option value="0">없음</option>
<%
SQL=" Select qtyidx, qtyname " 
SQL=SQL&" From tk_qty "
SQL=SQL&" Where qtyname<>'' and qtystatus='1' "
SQL=SQL&" Order by qtyname ASC "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  qtyidx=Rs(0)
  qtyname=Rs(1)
%>
                            <option value="<%=qtyidx%>"><%=qtyname%></option>
<%
Rs.movenext
Loop
End if
Rs.close
%>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <label for="name">도장색상</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_yongmoney_yn" readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">위치</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_wichi"  readonly>
                    </div> 
                    <div class="col-md-1">
                        <label for="name">비고1</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_bigo1"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">추가사항1</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_meno1" readonly>
                    </div>
                </div>    
                <div class="row ">           
                    <div class="col-md-12">
<%
SQL=" Select sjbtidx, sjb_type_no, sjb_type_name "
SQL=SQL&" From tng_sjbtype "
SQL=SQL&" Where sjbtstatus=1 "
'Response.write (SQL)&"<br><br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  sjbtidx=Rs(0)
  sjb_type_no=Rs(1)
  sjb_type_name=Rs(2)
  if rsjidx<>"" then 
    class_text="btn btn-secondary btn-small"
  else
    class_text="btn btn-outline-secondary btn-small"
  end if
%>
<button class="<%=class_text%>" type="submit" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_type_no=<%=sjb_type_no%>','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>><%=sjb_type_name%></button>                     
<%
Rs.movenext
Loop
End if
Rs.close
%>
                    </div>
                </div>    
            </div>
</form>            
<!-- 용차 정보 불러오기 시작 
tng1_b.asp 용차용 table 만들기 -->
<%
SQL=" Select yidx, yname, ytel, yaddr, ydate, ymemo, ycarnum, ygisaname, ygisatel, ycostyn, yprepay, ystatus, ymidx, ywdate, ymeidx, ywedate "
SQL=SQL&" From tk_yongcha " 
SQL=SQL&" Where sjidx='"&rsjidx&"' and ystatus=1 "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      yidx=Rs(0)
      yname=Rs(1)
      ytel=Rs(2)
      yaddr=Rs(3)
      ydate=Rs(4)
      
      ymemo=Rs(5)
      ycarnum=Rs(6)
      ygisaname=Rs(7)
      ygisatel=Rs(8)
      ycostyn=Rs(9)
      yprepay=Rs(10)
      ystatus=Rs(11)
      ymidx=Rs(12)
      ywdate=Rs(13)
      ymeidx=Rs(14)
      ywedate=Rs(15)
    End if
    RS.Close

%>
<!-- 용차 정보 불러오기 끝 -->

            <div class="card card-body mb-1">  <!-- * 용차 선택 -->   
<form name="fyong" action="TNG1_B_dbyong.asp" method="post" enctype="multipart/form-data">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<% if yidx<>"" then %>
<input type="hidden" name="yidx" value="<%=yidx%>">
<% end if%>
                <div class="row ">
                    <div class="col-md-1">
                    <label for="name">용차받는분</label><p>
                    <input type="text" class="form-control" id="yname" name="yname" placeholder="" value="<%=yname%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차받는전화</label><p>
                    <input type="tel" class="form-control" id="ytel" name="ytel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ytel%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">하차지주소</label><p>
                    <input type="text" class="form-control" id="yaddr" name="yaddr" placeholder="" value="<%=yaddr%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차도착일</label><p>
                    <input type="date" class="form-control" id="ydate" name="ydate" placeholder="" value="<%=Left(ydate,10)%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차도착시간</label><p>
                    <input type="time" class="form-control" id="ydateh" name="ydateh" placeholder="" value="<%=hour(ydate)%>:<%=minute(ydate)%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차당부사항</label><p>
                    <input type="text" class="form-control" id="ymemo" name="ymemo" placeholder="" value="<%=ymemo%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차차량번호</label><p>
                    <input type="tel" class="form-control" id="ycarnum" name="ycarnum"  placeholder="" value="<%=dnum%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">운전자명</label><p>
                    <input type="text" class="form-control" id="ygisaname" name="ygisaname" placeholder="" value="<%=dname%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">배차차량전번</label><p>
                    <input type="text" class="form-control" id="ygisatel" name="ygisatel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=dtel%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차착불여부</label><p>
                        <select name="ycostyn" class="form-control" id="ycostyn" required>
                            <option value="0">해당없음</option>
                            <option value="1">착불</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                    <label for="name">선불금액</label><p>
                    <input type="text" class="form-control" id="yprepay" name="yprepay" placeholder="" value="<%=yprepay%>">
                    </div> 
                    <div class="col-md-1">
                    <% if rsjidx<>"" then %>
                        <label for="name">저장/삭제</label><p>
                        <% if yidx="" then %>
                        <button class="btn btn-success btn-small" type="button" Onclick="yong();">저장</button>
                        <% else %>
                        <button class="btn btn-success btn-small" type="button" Onclick="yong();">수정</button>
                        <button class="btn btn-danger btn-small" type="button" Onclick="delyong();">삭제</button>
                        
                        <% end if %>
                    <% end if %>
                    </div>
                </div>
</form>

            </div>
            <div class="card card-body mb-1">  <!-- * 화물 선택 -->    
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">대신화물지점</label><p>
                        <button class="btn btn-primary btn-small" type="button"
                        onclick="window.open('https://www.ds3211.co.kr/freight/agencySearch.ht', '_blank', 'width=1500,height=1000,top=200,left=500');">조회</button>
                    </div>
                    <div class="col-md-1">
                        <label for="name">화물착불yn</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_hwamoney_yn"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">화물 선불금액</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_hwamoney"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">화물당부사항</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJY_hwameno "  readonly>
                    </div>
                    <div class="col-md-2">
                        <label for="name">수정/저장/삭제</label><p>
                        <button class="btn btn-primary btn-small " type="submit" >수정</button>
                        <button class="btn btn-success btn-small " type="submit" >저장</button>
                        <button class="btn btn-danger btn-small " type="submit" >삭제</button>
                    </div>
                </div>
            </div>



            <div class="card card-body mb-1">       <!-- * 누적 품목 단가 데이터 불러오기 55555555555555555555-->   
                <div class="col-md-12">
                    <table id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                                <th class="text-center">순번</th>
                                <th class="text-center">기본품목</th>
                                <th class="text-center">검측가로</th>
                                <th class="text-center">검측세로</th>
                                <th class="text-center">재질</th>
                                <th class="text-center">단가</th>
                                <th class="text-center">수량</th>
                                <th class="text-center">공급가</th>
                                <th class="text-center">할인율</th>
                                <th class="text-center">할인금액</th>
                                <th class="text-center">할인공급가</th>
                                <th class="text-center">세액</th>
                                <th class="text-center">최종가</th>
                                <th class="text-center">최종등록자</th>
                                <th class="text-center">최종등록일</th>
                            </tr>
                        </thead>
                        <tbody>
<%
SQL="Select A.sjsidx, B.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.qtyidx, C.qtyname, A.sjsprice, A.quan, A.disrate, A.disprice, A.taxrate, A.sprice, A.fprice "
SQL=SQL&" , A.midx, D.mname, A.mwdate, A.meidx, E.mname, A.mewdate, A.astatus "
SQL=SQL&" From tng_sjaSub A "
SQL=SQL&" left outer Join tng_sjb B On A.sjb_idx=B.sjb_idx "
SQL=SQL&" left outer Join tk_qty C On A.qtyidx=C.qtyidx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no "
SQL=SQL&" Where A.sjidx<>'0' and A.sjidx='"&rsjidx&"' "
SQL=SQL&" and A.astatus='1' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    i=i+1               '순번

    sjsidx=Rs(0)        '주문품목키
    sjb_idx=Rs(1)       '기본품목키
    sjb_type_name=Rs(2)  '기본품목명
    mwidth=Rs(3)        '검측가로
    mheight=Rs(4)       '검측세로
    qtyidx=Rs(5)        '재질키
    qtyname=Rs(6)       '재질명
    sjsprice=Rs(7)      '단가
    quan=Rs(8)          '수량
    disrate=Rs(9)       '할인율
    disprice=Rs(10)     '할인금액
    taxrate=Rs(11)      '세율
    sprice=Rs(12)       '공급가
    fprice=Rs(13)       '최종가
    midx=Rs(14)         '최초작성자키
    mname=Rs(15)        '최초작성자명
    mwdate=Rs(16)       '최초작성일
    meidx=Rs(17)        '최종작성자키
    mename=Rs(18)       '최종작성자명
    mewdate=Rs(19)      '최종작성일
    astatus=Rs(20)      '1은 사용 0은 사용안함 수정/삭제 ㅋㅋㅋㅋ
%> 
                            <tr>
                                <td class="text-center"><button type="button" class="btn btn-outline-danger" Onclick="udt1('<%=sjsidx%>');"><%=i%></button></td>
                                <td class="text-center"><button class="<%=class_text%>" type="submit" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&sjb_type_no=<%=sjb_type_no%>','_blank','width=1500  , height=1000, top=200, left=900' );"<% end if %>><%=sjb_type_name%></button></td>
                                <td class="text-end"><%=formatnumber(mwidth,0)%>mm</td>
                                <td class="text-end"><%=formatnumber(mheight,0)%>mm</td>
                                <td class="text-center"><%=qtyname%></td>
                                <td class="text-end"><%=formatnumber(sjsprice,0)%>원</td>
                                <td class="text-end"><%=formatnumber(quan,0)%>EA</td>
                                <td class="text-end"><%=formatnumber(fprice,0)%>원</td>
                                <td class="text-end"><%=disrate%>%</td>
                                <td class="text-end"><%=formatnumber(disprice,0)%>원</td>
                                <td class="text-end"><%=formatnumber(fprice-disprice,0)%>원</td>
                                <td class="text-end"><%=formatnumber(taxrate,0)%>원</td>
                                <td class="text-end"><%=formatnumber(sprice,0)%>원</td>
                                <td class="text-center"><%=mename%></td>
                                <td class="text-center"><button class="btn btn-light btn-small" type="submit" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&sjb_type_no=<%=sjb_type_no%>','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>><%=left(mewdate,10)%></button></td>
                            </tr>
<%
afprice=fprice+afprice
ataxrate=taxrate+ataxrate
asprice=sprice+asprice
aquan=quan+aquan
adisrate=disrate+adisrate
adisprice=disprice+adisprice
Rs.movenext
Loop
End If
Rs.Close
%>
<!--
<form name="frmMain1" action="TNG1_B_db.asp" method="post">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="gubun" value="supriceinput">
                            <tr>
                                <td class="text-center">합계</td>
                                <td class="text-center"></td>
                                <td class="text-end"></td>
                                <td class="text-end"></td>
                                <td class="text-center"></td>
                                <td class="text-end"></td>
                                <td class="text-end"><%=formatnumber(aquan,0)%>EA</td>
                                <td class="text-end"><%=formatnumber(afprice,0)%>원</td>
                                <td class="text-end">
 
                                <table  align="right">
                                  <tr>
                                    <td><input type="text" class="form-control" id="trate" name="trate" style="width: 80;text-align: right;background: none; border: none; outline: none;" value="<%=formatnumber(adisrate,0)%>" ></td>
                                    <td>%</td>
                                  </tr>
                                </table>
 
                                </td>
                                <td class="text-end">
 
                                <table  align="right">
                                  <tr>
                                    <td><input type="text" class="form-control" id="tdisprice" name="tdisprice" style="width: 80;text-align: right;background: none; border: none; outline: none;" value="<%=formatnumber(adisprice,0)%>" ></td>
                                    <td>원</td>
                                  </tr>
                                </table>
                                
 
                                </td>
                                <td class="text-end">
 
                                <table  align="right">
                                  <tr>
                                    <td><input type="text" class="form-control" id="tsprice" name="tsprice" style="width: 80;text-align: right;background: none; border: none; outline: none;" value="<%=formatnumber(afprice,0)%>" ></td>
                                    <td>원</td>
                                  </tr>
                                </table>
 
                                </td>
                                <td class="text-end">
 
                                <table  align="right">
                                  <tr>
                                    <td><input type="text" class="form-control" id="taxprice" name="taxprice" style="width: 80;text-align: right;background: none; border: none; outline: none;" value="<%=formatnumber(ataxrate,0)%>" ></td>
                                    <td>원</td>
                                  </tr>
                                </table>
 
                                </td>
                                <td class="text-end">
 
                                <table  align="right">
                                  <tr>
                                    <td><input type="text" class="form-control" id="tzprice" name="tzprice" style="width: 80;text-align: right;background: none; border: none; outline: none;" value="<%=formatnumber(asprice,0)%>" ></td>
                                    <td>원</td>
                                  </tr>
                                </table>
 
                                </td>
                                <td class="text-center"></td>
                                <td class="text-center"><button class="btn btn-primary btn-small " type="submit" >적용</button></td>
                            </tr>
</form>
-->

<form method="post" action="save_result.asp">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="gubun" value="supriceinput">
<%
 
    ' === ASP 변수 선언 ===
    Dim basePrice, defaultRate, defaultAmount
    Dim discountedPrice, tax, finalPrice

    basePrice = 1510000
    defaultRate = 5
    defaultAmount = basePrice * (defaultRate / 100)
    discountedPrice = basePrice - defaultAmount
    tax = discountedPrice * 0.1
    finalPrice = discountedPrice + tax
%>

            <tr>
                                <td class="text-center">합계</td>
                                <td class="text-center"></td>
                                <td class="text-end"></td>
                                <td class="text-end"></td>
                                <td class="text-center"></td>
                                <td class="text-end"></td>
                                <td class="text-end"><%=formatnumber(aquan,0)%>EA</td>
 <td><input type="text" name="basePrice" value="<%= FormatNumber(basePrice, 0, -1, -1, -1) %>" readonly></td>
<td><input type="text" id="discountRate" name="discountRate" value="<%= defaultRate %>" oninput="updateFromRate()"></td>
<td><input type="text" id="discountAmount" name="discountAmount" value="<%= FormatNumber(defaultAmount, 0, -1, -1, -1) %>" oninput="updateFromAmount()"></td>
<td><input type="text" id="discountedPrice" name="discountedPrice" value="<%= FormatNumber(discountedPrice, 0, -1, -1, -1) %>" oninput="updateFromDiscountedPrice()"></td>
<td><input type="text" id="tax" name="tax" value="<%= FormatNumber(tax, 0, -1, -1, -1) %>" readonly></td>
<td><input type="text" id="finalPrice" name="finalPrice" value="<%= FormatNumber(finalPrice, 0, -1, -1, -1) %>" readonly></td>
                                <td class="text-center"></td>
                                <td class="text-center"><input type="submit" value="제출하기"></td>
            </tr>
    </form>
                            </tbody>
                    </table>    
                </div>
            </div>

            <div class="card card-body mb-1">       <!-- * 총 합계금액 불러오기 666666666666-->        
                <div class="col-md-12">
                    <div class="row ">
                        <div class="col-md-1">
                            <label for="name">공급가합</label><p>
                            <input type="text" class="form-control" id="tsprice" name="tsprice" placeholder="" value="<%=tsprice%>" readonly>
                        </div>
                        <div class="col-md-2">
                            <label for="name">할인율</label><p>
                            <input type="text" class="form-control" id="trate" name="trate" placeholder="" value="<%=trate%>" readonly>
                        </div>
                        <div class="col-md-2">
                            <label for="name">할인금액</label><p>
                            <input type="text" class="form-control" id="tdisprice" name="tdisprice" placeholder="" value="<%=tdisprice%>" readonly>
                        </div>
                        <div class="col-md-2">
                            <label for="name">최종공급가액</label><p>
                            <input type="text" class="form-control" id="tfprice" name="tfprice" placeholder="" value="<%=tfprice%>" readonly>
                        </div>
                        <div class="col-md-2">
                            <label for="name">최종세액</label><p>
                            <input type="text" class="form-control" id="taxprice" name="taxprice" placeholder="" value="<%=taxprice%>" readonly>
                        </div>
                        <div class="col-md-2">
                            <label for="name">최종금액</label><p>
                            <input type="text" class="form-control" id="tzprice" name="tzprice" placeholder="" value="<%=tzprice%>" readonly>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</main>                          
<!-- footer 시작 -->    
Coded By 양양
<!-- footer 끝 --> 
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
