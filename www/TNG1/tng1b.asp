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
    sjcidx=request("cidx") '발주처idx
  rsjcidx=request("sjcidx") '발주처idx
  rsjmidx=request("sjmidx") '거래처담당자idx
  rsjidx=request("sjidx") '수주idx
  rsjsidx=request("sjsidx") '품목idx

  SearchWord=Request("SearchWord")
  gubun=Request("gubun")

	page_name="tng1_b.asp?listgubun="&listgubun&"&"

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
'
  basePrice=replace(Request("basePrice"),",","")            '수주 공급가 합
  discountRate=round(replace(Request("discountRate"),",",""),0)       '수주 추가할인율
  discountAmount=replace(Request("discountAmount"),",","")   '수주 추가할인금액
  discountedPrice=replace(Request("discountedPrice"),",","") '수주 최종 공급가
  tax=replace(Request("tax"),",","")                         '세액 합
  finalPrice=replace(Request("finalPrice"),",","")           '수주 최종가

  'response.write basePrice&"/<br>"
  'response.write discountRate&"/<br>"
  'response.write discountAmount&"/<br>"
  'response.write discountedPrice&"/<br>"
  'response.write tax&"/<br>"
  'response.write finalPrice&"/<br>"

  SQL="Update tng_sja set tsprice='"&basePrice&"', trate='"&discountRate&"', tdisprice='"&discountAmount&"', tfprice='"&discountedPrice&"', taxprice='"&tax&"', tzprice='"&finalPrice&"' Where sjidx='"&rsjidx&"' "
  'response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
end if
'=============
'수주금액 입력 끝


SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnumber,B.mname, B.mhp , A.cbran ,A.cmove"
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
  cbran=Rs(13)
  cmove=Rs(14)

End If
Rs.Close

'=============
'수주정보 시작
sjdate=Request("sujudate")
if sjdate="" then sjdate=date() end if 

if rsjidx="" then '수주정보가 없다면
  'response.write "<br><br><br><br><br><br><br><br>"

  fix_date = Mid(Replace(sjdate, "-", ""), 3)  'sjdate = "2025-07-28" → 250728  
  SQL="select max(sjnum) from TNG_SJA where Convert(varchar(10),sjdate,112)='"&sjdate&"' "
  ' 또는: Convert(varchar(10), sjdate, 121) → yyyy-mm-dd / 112 → yyyymmdd
  'response.write (SQL)&"<br><br><br><br><br><br><br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    new_sjnum=Rs(0)
    If IsNull(new_sjnum) Or new_sjnum = "" Then
        sjnum = fix_date & "0001"
    Else
        sjnum = CStr(CLng(new_sjnum) + 1)
    End If

  End if
  RS.Close

else    '수주정보가 있다면
  SQL="select sjdate, sjnum, Convert(Varchar(10),cgdate,121), Convert(Varchar(10),djcgdate,121), cgtype, cgaddr, cgset, sjmidx, sjcidx "
  SQL=SQL&" , midx, Convert(Varchar(10),wdate,121), meidx, Convert(Varchar(10),mewdate,121) "
  SQL=SQL&" , tsprice, trate, tdisprice, tfprice, taxprice, tzprice "
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
      tsprice=Rs(13)
      trate=Rs(14)
      tdisprice=Rs(15)
      tfprice=Rs(16)
      taxprice=Rs(17)
      tzprice=Rs(18)
    End if
    RS.Close

end if

'=============
'수중정보 끝

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
    <link rel="icon" sizes="image/x-icon" href="/taekwang_logo.svg">
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

    .row-card {
      display: flex;
      align-items: center;
      padding: 15px 20px;
      border: 1px solid #ccc;
      border-radius: 3px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.05);
      background-color: #fff;
      font-family: Arial, sans-serif;
      gap: 16px;
      overflow-x: auto;
      white-space: nowrap;
    }
    .field {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .field span {
      font-weight: bold;
      font-size: 13px;
      color: #333;
      border: 1px solid #ccc;
      background-color: #f0f0f0;
      border-radius: 6px;
      padding: 4px 8px;
    }

    .field input {
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 4px 8px;
      font-size: 14px;
      width: 120px;
      text-align: right;
    }
    .button {
      padding: 8px 14px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 14px;
      cursor: pointer;
    }

    .button:hover {
      background-color: #0056b3;
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
            /*
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
          */
            else {
                document.fyong.submit();
            }
        } 
        function daesin() {
            if(document.fdaesin.ds_to_name.value == "" ) {
                alert("택배/화물 받는분 이름을 입력하세요.");
            return
            }
            if(document.fdaesin.ds_to_tel.value == "" ) {
                alert("택배/화물 받는분 전화번호를 입력하세요.");
            return
            }
            if(document.fdaesin.ds_to_addr.value == "" ) {
                alert("택배/화물 받는 주소를 입력하세요.");
            return
            }
            if(document.fdaesin.dsdate.value == "" ) {
                alert("택배 도착일을 입력해주세요.");
            return
            }
            else {
                document.fdaesin.submit();
            }
        }   
        function del(sTR){
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_db.asp?gubun=delete&sjcidx=<%=sjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
            }
        }
        function udt1(rsjsidx){
            if (confirm("삭제 하시겠습니까?"))
            {
               
                location.href="TNG1_B.asp?gubun=udt1&sjcidx=<%=sjcidx%>&sjidx=<%=rsjidx%>&sjmidx=<%=rsjmidx%>&sjsidx="+rsjsidx;
            }
        }
        
        function delyong(sTR){
            if (confirm("용차정보를 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_dbyong.asp?gubun=delete&sjcidx=<%=sjcidx%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
            }
        }
        function deldaesin(sTR){
            if (confirm("화물/택바 정보를 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_dbDaesin.asp?gubun=delete&sjcidx=<%=sjcidx%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
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

</head>
<body>
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
            <div class="col-md-9" >
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
                <label for="name">관리등급</label><p>
                <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
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
                <div class="col-md-3">
                <label for="name">참고사항</label><p>
                <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                </div>
                
              </div>  <!-- 거래처 정보 선택 끝  -->
                      <!-- 수주정보 선택 시작  -->
              <form name="frmMain" action="TNG1_B_db.asp" method="post" enctype="multipart/form-data">
                <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
                <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
                <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                <div class="row ">
                  <div class="col-md-12">
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
                          <label for="name">기본출고방식</label><p>
                          <select name="cgtype" class="form-control" id="cgtype" required>
                                <option value="1" <% if cmove="1" then Response.write "selected" end if %>>화물</option>                        
                                <option value="2" <% if cmove="2" then Response.write "selected" end if %>>낮1배달</option>
                                <option value="3" <% if cmove="3" then Response.write "selected" end if %>>낮2배달</option>
                                <option value="4" <% if cmove="4" then Response.write "selected" end if %>>밤1배달</option>
                                <option value="5" <% if cmove="5" then Response.write "selected" end if %>>밤2배달</option>
                                <option value="6" <% if cmove="6" then Response.write "selected" end if %>>대구창고</option>
                                <option value="7" <% if cmove="7" then Response.write "selected" end if %>>대전창고</option>
                                <option value="8" <% if cmove="8" then Response.write "selected" end if %>>부산창고</option>
                                <option value="9" <% if cmove="9" then Response.write "selected" end if %>>양산창고</option>
                                <option value="10" <% if cmove="10" then Response.write "selected" end if %>>익산창고</option>
                                <option value="11" <% if cmove="11" then Response.write "selected" end if %>>원주창고</option>
                                <option value="12" <% if cmove="12" then Response.write "selected" end if %>>제주창고</option>
                          </select>
                      </div>
                      <div class="col-md-2">
                          <label for="name">현장명</label><p>
                          <input type="text" class="form-control" id="cgaddr" name="cgaddr" placeholder="" value="<%=cgaddr%>" >
                      </div>
                      <div class="col-md-1">
                          <label for="name">입금후출고 설정</label><p>
                          <select name="cgset" class="form-control" id="cgset" required>
                              <option value="0">해당없음</option>
                              <option value="1">적용</option>

                          </select>
                      </div>
                      <div class="col-md-1">
                          <label for="name">업체담당자명</label><p>
                          <input type="text" class="form-control" id="" name="" placeholder="" value="<%=mname%>" readonly>
                      </div>
                      <div class="col-md-1">
                          <label for="name">업체담당자 TEL</label><p>
                          <input type="text" class="form-control" id="" name="" placeholder="" value="<%=mhp%>"  readonly>
                      </div>
                      <div class="col-md-2">
                            <button class="btn btn-success btn-small" type="button" Onclick="validateform();"><% if rsjidx="" then %>저장<% else %>수정<% end if %></button>
                            <% if rsjidx<>"" then %><button class="btn btn-danger btn-small" type="button" onclick="del();">삭제</button><% end if %>
                            <%
                              if rsjidx<>"" then 
                                class_text="btn btn-secondary btn-small"
                              else
                                class_text="btn btn-outline-secondary btn-small"
                              end if
                            %>
                            <button class="<%=class_text%>" type="button" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju2.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>>신규견적등록</button>
                            <button class="<%=class_text%>" type="button" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju_temp.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&sjb_type_no=1','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>>테스트</button>
                      </div>
                    </div>
                  </div>
              </form> 
              </div>       
            </div>
            <div class="col-md-3" > <!---도면 보이는 라인 -->
              <div class="card card-body" >
                <div class="row">
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본이미지 등록
                    </button>
                  </div>
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본파일 등록
                    </button>
                  </div>
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_datalist.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본리스트
                    </button>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본이미지 등록
                    </button>
                  </div>
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본파일 등록
                    </button>
                  </div>
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본리스트
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
<!-- 수주정보 선택 끝  -->
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
                                <th class="text-center">도장</th>
                                <th class="text-center">단가</th>
                                <th class="text-center">수량</th>
                                <th class="text-center">공급가</th>
                                <!-- <th class="text-center">할인율</th> -->
                                <th class="text-center">할인금액</th>
                                <th class="text-center">세액</th>
                                <th class="text-center">최종가</th>
                                <th class="text-center">최종등록자</th>
                                <th class="text-center">최종등록일</th>
                            </tr>
                        </thead>
                        <tbody>
<%
SQL="Select distinct A.sjsidx, A.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.qtyidx, g.qtyname, A.sjsprice, A.quan, A.disrate, A.disprice, A.taxrate, A.sprice, A.fprice "
SQL=SQL&" , A.midx, D.mname, A.mwdate, A.meidx, E.mname, A.mewdate, A.astatus ,f.sjb_type_no  , a.framename , i.pname "
SQL=SQL&" From tng_sjaSub A "
SQL=SQL&" left outer Join tng_sjb B On A.sjb_idx=B.sjb_idx "
SQL=SQL&" left outer Join tk_qty C On A.qtyidx=C.qtyidx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no "
SQL=SQL&" Left Outer JOin tk_qtyco g On c.qtyno=g.qtyno "
'SQL=SQL&" Left Outer JOin tk_framek h On a.sjsidx=h.sjsidx "  ,h.fkidx
SQL=SQL&" Left Outer JOin tk_paint i On a.pidx=i.pidx "
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
    sjb_type_no=Rs(21)
    'fkidx=Rs(22)        'framek
    framename=Rs(22)    '프레임명
    pname=Rs(23)        '도장명

%> 

                            <tr>
                                <td class="text-center"><button type="button" class="btn btn-outline-danger" Onclick="udt1('<%=sjsidx%>');"><%=i%></button></td>
                                <td class="text-center"><button class="<%=class_text%>" type="submit" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju2.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>','_blank','width=1500  , height=1000, top=200, left=900' );"<% end if %>><%=framename%></button></td>
                                <td class="text-end">
                                <button 
                                    class="<%=class_text%>" 
                                    type="button" 
                                    onclick="toggleSubTable('<%=sjsidx%>', this)">
                                    <%=formatnumber(mwidth,0)%>mm
                                </button>
                                </td>
                                <td class="text-end"><%=formatnumber(mheight,0)%>mm</td>
                                <td class="text-center"><%=qtyname%></td>
                                <td class="text-center"><%=pname%></td>
                                <td class="text-end"><%=formatnumber(sjsprice,0)%>원</td>
                                <td class="text-end"><%=formatnumber(quan,0)%>EA</td>
                                <td class="text-end"><%=formatnumber(fprice,0)%>원</td>
                               <!-- <td class="text-end"><%=disrate%>%</td> -->
                                <td class="text-end"><%=formatnumber(disprice,0)%>원</td>
                                <td class="text-end"><%=formatnumber(taxrate,0)%>원</td>
                                <td class="text-end"><%=formatnumber(sprice,0)%>원</td>
                                <td class="text-center"><%=mename%></td>
                                <td class="text-center"><button class="btn btn-light btn-small" type="submit" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju2.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&sjb_type_no=<%=sjb_type_no%>','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>><%=left(mewdate,10)%></button></td>
                            </tr>
                            <tr class="sub-table-row" id="sub-<%=sjsidx%>" style="display: none;">
                                <td colspan="15">
                                    <div id="sub-table-content-<%=sjsidx%>">불러오는 중...</div>
                                </td>
                            </tr>
                            <!-- ASP → JS 변수로 전달 -->
                            <script>
                                const sjcidx = "<%=sjcidx%>";
                                const sjmidx = "<%=sjmidx%>";
                                const sjidx = "<%=rsjidx%>";
                                const sjsidx = "<%=sjsidx%>";
                            </script>
                            <script>
                            function toggleSubTable(sjsidx, btn) {
                            const row = document.getElementById(`sub-${sjsidx}`);
                            const content = document.getElementById(`sub-table-content-${sjsidx}`);

                            if (row.style.display === "none") {
                                // 다른 열린 행 모두 닫기
                                document.querySelectorAll(".sub-table-row").forEach(r => r.style.display = "none");

                                // 현재 행 열기
                                row.style.display = "table-row";

                                // Ajax 로드
                                fetch(`TNG1_B_table.asp?sjcidx=${sjcidx}&sjmidx=${sjmidx}&sjidx=${sjidx}&sjsidx=${sjsidx}`)
                                .then(res => res.text())
                                .then(html => content.innerHTML = html)
                                .catch(err => content.innerHTML = "불러오기 실패");
                            } else {
                                row.style.display = "none";
                            }
                            }
                            </script>


<%

afprice=fprice+afprice  '공급가의  합
asprice=sprice+asprice  '최종가의 합
ataxrate=taxrate+ataxrate  '세액 의 합
aquan=quan+aquan    '수량 의 합
adisprice=disprice+adisprice  '할인액 의 합


adisrate=disrate+adisrate  '사용안함

Rs.movenext
Loop
End If
Rs.Close


'response.write "afprice"&"="& afprice &"<br>"
'response.write "asprice"&"="& asprice &"<br>"
'response.write "ataxrate"&"="& ataxrate &"<br>"
'response.write "aquan"&"="& aquan &"<br>"
'response.write "adisprice"&"="& adisprice &"<br>"
%>
        <!--
    <script type="text/javascript">
        let basePrice = <%= afprice %>;

        function formatNumber(num) {
            return num.toLocaleString('ko-KR');
        }

        function unformatNumber(str) {
            return parseInt(str.replace(/,/g, '')) || 0;
        }

        // 숫자만 입력 가능
        function onlyNumberKey(e) {
            const key = e.key;
            return /\d/.test(key) || key === 'Backspace' || key === 'Delete' || key === 'ArrowLeft' || key === 'ArrowRight';
        }

        // 엔터키 입력 시 실행
        function handleKeyDown(e, callback) {
            if (e.key === "Enter" || e.keyCode === 13) {
                e.preventDefault();
                callback();
            }
        }

        function updateFromRate() {
            let rate = parseFloat(document.getElementById("discountRate").value) || 0;
            let discountAmount = Math.floor(basePrice * (rate / 100));
            updateValues(basePrice - discountAmount);
        }

        function updateFrombasePrice() {
            let discountAmount = unformatNumber(document.getElementById("basePrice").value);
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
    -->
<form method="post" namd="supriceinput" action="tng1_b.asp">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="gubun" value="supriceinput">
<%
if isnull(tsprice) then tsprice="0" end if
if isnull(trate) then trate="0" end if
if isnull(tdisprice) then tdisprice="0" end if 
if isnull(tfprice) then tfprice="0" end if
if isnull(taxprice) then taxprice="0" end if 
if isnull(tzprice) then tzprice="0" end if 

if tsprice <> 0 then 

  basePrice = tsprice
  defaultRate = trate
  defaultAmount = tdisprice
  discountedPrice = tfprice
  tax = taxprice
  finalPrice = tzprice

else
  'basePrice = afprice  '공급가의  합
  'defaultRate = 10
  'defaultAmount = basePrice * (defaultRate / 100)
  'discountedPrice = basePrice - defaultAmount
  'tax = discountedPrice * 0.1
  'finalPrice = discountedPrice + tax

    basePrice = afprice  '공급가의  합
    'defaultRate = 10
    defaultAmount = ataxrate '세액 의 합
    discountedPrice = adisprice '할인액 의 합
    'tax = discountedPrice * 0.1
    finalPrice = asprice '최종가의 합

end if

'response.write "2afprice"&"="& afprice &"<br>"
'response.write "basePrice"&"="& basePrice &"<br>"
'response.write "2asprice"&"="& asprice &"<br>"
'response.write "2ataxrate"&"="& ataxrate &"<br>"
'response.write "2aquan"&"="& aquan &"<br>"
'response.write "2adisprice"&"="& adisprice &"<br>"

%>



            <tr>
              <td class="text-center">합계</td>
              <td class="text-center"></td>
              <td class="text-center"></td>
              <td class="text-end"></td>
              <td class="text-end"></td>
              <td class="text-center"></td>
              <td class="text-end"></td>
              <td class="text-end"><%=formatnumber(aquan,0)%>EA</td>
              <!--
              <td class="text-end">
                <input type="text" name="basePrice" value="<%= FormatNumber(basePrice, 0) %>" 
                onkeydown="handleKeyDown(event, updateFrombasePrice)" 
                onkeypress="if (!onlyNumberKey(event)) event.preventDefault();" 
                style="text-align: right;background: #ccc;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" >원
              </td>
              -->
              <td class="text-end"> <!--공급가-->
                <input type="text" name="basePrice" value="<%= FormatNumber(basePrice, 0) %>" 
                style="text-align: right;background: #ccc;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" >원
              </td>
              <!-- 
              <td class="text-end"> 할증퍼센트
                <input type="text" id="discountRate" name="discountRate" value="<%= defaultRate %>" 
                onkeydown="handleKeyDown(event, updateFromRate)" 
                onkeypress="if (!onlyNumberKey(event)) event.preventDefault();" 
                style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:80px;">%
                </td>
              -->
              <!-- 
              <td class="text-end">
                <input type="text" id="discountedPrice" name="discountedPrice" value="<%= FormatNumber(discountedPrice, 0) %>" 
                onkeydown="handleKeyDown(event, updateFromDiscountedPrice)" 
                onkeypress="if (!onlyNumberKey(event)) event.preventDefault();" 
                style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;">원
              </td>
              -->
              <td class="text-end"> <!--할인금액-->
                <input type="text" id="discountedPrice" name="discountedPrice" value="<%= FormatNumber(discountedPrice, 0) %>" 
                style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;">원
              </td>
              <!--
              <td class="text-end"> 
                <input type="text" id="discountAmount" name="discountAmount" value="<%= FormatNumber(defaultAmount, 0) %>" 
                onkeydown="handleKeyDown(event, updateFromAmount)" 
                onkeypress="if (!onlyNumberKey(event)) event.preventDefault();" 
                style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;">원
              </td>
              -->
              <td class="text-end"> <!--세액-->
                <input type="text" id="discountAmount" name="discountAmount" value="<%= FormatNumber(defaultAmount, 0) %>" 
                style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;">원
              </td>
              <!--
                <td class="text-end"> 
                    <input type="text" id="tax" name="tax" value="<%= FormatNumber(tax, 0) %>" 
                    style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" readonly>원
                </td>
              -->
              <td class="text-end">
                <input type="text" id="finalPrice" name="finalPrice" value="<%= FormatNumber(finalPrice, 0) %>" 
                style="text-align: right;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" readonly>원
              </td>
              <td class="text-center"><button class="btn btn-success btn-small" type="button" Onclick="submit();">저장</button></td>
            </tr>
</form>
                            </tbody>
                    </table>    
                </div>
            </div>
<%

%>
            <div  class="row-card mb-1"> 
              <div class="field">
                <span>공급가합</span>
                <input type="text" value="<%=FormatNumber(tsprice,0)%>원" readonly>
              </div>
              <div class="field">
                <span>할인율</span>
                <input type="text" value="<%=FormatNumber(trate,0)%>%" readonly>
              </div>
              <div class="field">
                <span>할인금액</span>
                <input type="text" value="<%=FormatNumber(tdisprice,0)%>원" readonly>
              </div>
              <div class="field">
                <span>최종공급가액</span>
                <input type="text" value="<%=FormatNumber(tfprice,0)%>" readonly>
              </div>
              <div class="field">
                <span>세액</span>
                <input type="text" value="<%=FormatNumber(taxprice,0)%>" readonly>
              </div>
              <div class="field">
                <span>최종금액</span>
                <input type="text" value="<%=FormatNumber(tzprice,0)%>" readonly>
              </div>
              <!-- 견적서 출력 버튼 (모달 토글) -->
            <button type="button" class="btn btn-primary"
                    data-bs-toggle="modal" data-bs-target="#quotationModal">
            견적서 출력
            </button>
              <button class="button" onclick="alert('발주서 출력 기능 연결')">발주서 출력</button>
            </div>
    
         
<!-- 용차 정보 불러오기 시작 -->
<%
SQL=" Select yidx, yname, ytel, yaddr, ydate, ymemo "
SQL=SQL&", ycarnum, ygisaname, ygisatel, ycostyn, yprepay, ystatus "
SQL=SQL&" , ymidx, ywdate, ymeidx, ywedate "
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
                    <%
                    if yname="" then
                    yname=cceo
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">용차받는분</label><p>
                    <input type="text" class="form-control" id="yname" name="yname" placeholder="" value="<%=yname%>">
                    </div>
                    <%
                    if ytel="" then
                    ytel=ctel
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">용차받는전화</label><p>
                    <input type="tel" class="form-control" id="ytel" name="ytel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ytel%>">
                    </div>
                    <!-- !다음(Daum) 우편번호 서비스 -->
                    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                    <script>
                      function openDaumPostcode() {
                        new daum.Postcode({
                          oncomplete: function(data) {
                            // 도로명 주소 기준
                            var fullAddr = data.roadAddress; 
                            if (fullAddr === '') {
                              fullAddr = data.jibunAddress; // 지번 주소 fallback
                            }

                            document.getElementById('yaddr').value = fullAddr;
                          }
                        }).open();
                      }
                    </script>
                    <div class="col-md-1">
                    <%
                    if yaddr="" then
                    yaddr=ccaddr1
                    end if
                    %>
                    <label for="name">하차지주소</label><p>
                    <input type="text" class="form-control" id="yaddr" name="yaddr" placeholder="주소를 입력하세요" onclick="openDaumPostcode();" value="<%=yaddr%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차도착일</label><p>
                    <input type="date" class="form-control" id="ydate" name="ydate" placeholder="" value="<%=Left(ydate,10)%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차도착시간</label><p>
                    <input type="time" class="form-control" id="ydateh" name="ydateh" placeholder="" value="<%=hour(ydate)%>:<%=minute(ydate)%>">
                    </div>
                  </div>
                  <div class="row ">
                    <div class="col-md-1">
                    <label for="name">용차당부사항</label><p>
                    <input type="text" class="form-control" id="ymemo" name="ymemo" placeholder="" value="<%=ymemo%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차차량번호</label><p>
                    <input type="tel" class="form-control" id="ycarnum" name="ycarnum"  placeholder="예: 127우9556" value="<%=ycarnum%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">운전자명</label><p>
                    <input type="text" class="form-control" id="ygisaname" name="ygisaname" placeholder="" value="<%=ygisaname%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">배차차량전번</label><p>
                    <input type="text" class="form-control" id="ygisatel" name="ygisatel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ygisatel%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차착불여부</label><p>
                        <select name="ycostyn" class="form-control" id="ycostyn" required>
                          <option value="0" <% If ycostyn = "0" Then Response.Write "selected" %>>해당없음</option>
                          <option value="1" <% If ycostyn = "1" Then Response.Write "selected" %>>착불</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                    <label for="name">선불금액</label><p>
                    <input type="text" class="form-control" id="yprepay" name="yprepay" placeholder="" value="<%=FormatNumber(yprepay,0)%>원" >
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
<!-- 대신화물 정보 정보 불러오기 시작 -->
<%
SQL = "SELECT dsidx, ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
SQL = SQL & "ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_costyn, ds_to_prepay, "
SQL = SQL & "dsmidx, dswdate, dsmeidx, dswedate, dsstatus, sjidx "
SQL = SQL & "FROM tk_daesin "
SQL = SQL & "WHERE sjidx = '" & rsjidx & "' AND dsstatus = 1"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    dsidx         = Rs(0)
    ds_daesinname = Rs(1)
    ds_daesintel  = Rs(2)
    ds_daesinaddr = Rs(3)
    dsdate        = Rs(4)
    dsmemo        = Rs(5)

    ds_to_num     = Rs(6)
    ds_to_name    = Rs(7)
    ds_to_tel     = Rs(8)
    ds_to_addr    = Rs(9)
    ds_to_costyn  = Rs(10)
    ds_to_prepay  = Rs(11)

    dsmidx        = Rs(12)
    dswdate       = Rs(13)
    dsmeidx       = Rs(14)
    dswedate      = Rs(15)
    dsstatus      = Rs(16)
    dssjidx       = Rs(17)
End If
Rs.Close



%>
<!-- 대신화물 정보 불러오기 끝 -->            
            <div class="card card-body mb-1">  <!-- * 화물 선택 -->    
              <form name="fdaesin" action="TNG1_B_dbDaesin.asp" method="post" enctype="multipart/form-data">
              <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
              <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
              <input type="hidden" name="sjidx" value="<%=rsjidx%>">
              <% if dsidx<>"" then %>
              <input type="hidden" name="dsidx" value="<%=dsidx%>">
              <% end if%>            
                <div class="row ">
                    <div class="col-md-1"> 
                        <label for="name">대신화물지점 조회</label><p>
                        <button class="btn btn-primary btn-small" type="button"
                        onclick="window.open('https://www.ds3211.co.kr/freight/agencySearch.ht', '_blank', 'width=1500,height=1000,top=200,left=500');">조회</button>
                    </div>
                    <div class="col-md-1">
                    <label for="name">대신화물지점 전화번호</label><p>
                    <input type="text" class="form-control" id="ds_daesintel" name="ds_daesintel" placeholder="" value="<%=ds_daesintel%>">
                    </div> 
                    <div class="col-md-1">
                    <%
                    if ds_daesinaddr="" then
                    ds_daesinaddr=CBRAN
                    end if
                    %>
                    <label for="name">대신화물지점 주소</label><p>
                    <input type="text" class="form-control" id="ds_daesinaddr" name="ds_daesinaddr" placeholder="" value="<%=ds_daesinaddr%>">
                    </div> 
                    <%
                    if ds_to_name="" then
                    ds_to_name=cceo
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">받는이 이름</label><p>
                    <input type="text" class="form-control" id="ds_to_name" name="ds_to_name" placeholder="" value="<%=ds_to_name%>">
                    </div> 
                    <%
                    if ds_to_addr="" then
                    ds_to_addr=caddr1
                    end if
                    %>
                    <div class="col-md-3">
                    <label for="name">받는이 주소</label><p>
                    <input type="text" class="form-control" id="ds_to_addr" name="ds_to_addr" placeholder="택배 받는이 주소를 입력하세요" onclick="openDaumPostcode();" value="<%=ds_to_addr%>">
                    </div> 
                    <%
                    if ds_to_tel="" then
                    ds_to_tel=ctel
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">받는이 전화번호</label><p>
                    <input type="tel" class="form-control" id="ds_to_tel" name="ds_to_tel"  placeholder="" value="<%=ds_to_tel%>">
                    </div>
                  </div>
                  <div class="row ">
                    <div class="col-md-1">
                    <label for="name">택배도착일</label><p>
                    <input type="date" class="form-control" id="dsdate" name="dsdate" placeholder="" value="<%=dsdate%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">택배착불여부</label><p>
                        <select name="ds_to_costyn" class="form-control" id="ds_to_costyn" required>
                          <option value="0" <% If ds_to_costyn = "0" Then Response.Write "selected" %>>해당없음</option>
                          <option value="1" <% If ds_to_costyn = "1" Then Response.Write "selected" %>>착불</option>
                        </select>
                        </select>
                    </div>
                    <div class="col-md-1">
                    <label for="name">선불금액</label><p>
                    <input type="text" class="form-control" id="ds_to_prepay" name="ds_to_prepay" placeholder="" value="<%=FormatNumber(ds_to_prepay,0)%>원" >
                    </div> 
                    <div class="col-md-1">
                    <label for="name">추가사항</label><p>
                    <input type="text" class="form-control" id="dsmemo" name="dsmemo" placeholder="" value="<%=dsmemo%>">
                    </div> 
                    <div class="col-md-1">
                    <% if rsjidx<>"" then %>
                        <label for="name">저장/삭제</label><p>
                        <% if dsidx="" then %>
                        <button class="btn btn-success btn-small" type="button" Onclick="daesin();">저장</button>
                        <% else %>
                        <button class="btn btn-success btn-small" type="button" Onclick="daesin();">수정</button>
                        <button class="btn btn-danger btn-small" type="button" Onclick="deldaesin();">삭제</button>
                        
                        <% end if %>
                    <% end if %>
                    </div>
                </div>
            </div>
            </form>
        </div>
        
    </div>

    
</main>   
</div>                       

</div>

<!-- 모달 -->
<div class="modal fade" id="quotationModal" tabindex="-1" aria-labelledby="quotationModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="quotationModalLabel">견적서 유형 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body d-grid gap-2">
        <button type="button" class="btn btn-outline-secondary"
          onclick="window.open('/TNG1/quotation/internal/index.asp?sjidx=<%=rsjidx%>','kyun','width=1000,height=900');">
          간이 견적서
        </button>
        <button type="button" class="btn btn-outline-secondary"
          onclick="window.open('/TNG1/quotation/external/index.asp?sjidx=<%=rsjidx%>','kyun','width=1000,height=900');">
          직인 견적서
        </button>
        <button type="button" class="btn btn-outline-secondary"
          onclick="window.open('/TNG1/quotation/specific/index.asp?sjidx=<%=rsjidx%>','kyun','width=1000,height=900');">
          상세 견적서
        </button>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
      </div>
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
