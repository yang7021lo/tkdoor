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

  projectname="견적서"
  rsjidx=Request("sjidx")
  gubun=Request("gubun")


  SQL="select A.sjdate, A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121), A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx "
  SQL=SQL&" , A.midx, Convert(Varchar(10),A.wdate,121), A.meidx, Convert(Varchar(10),A.mewdate,121) "
  SQL=SQL&" , A.tsprice, A.trate, A.tdisprice, A.tfprice, A.taxprice, A.tzprice, B.mname, C.cname, D.mname "
  SQL=SQL&" From tng_sja A "
  SQL=SQL&" Join tk_member B On A.sjmidx=B.midx "
  SQL=SQL&" Join tk_customer C On B.cidx=C.cidx "
  SQL=SQL&" Join tk_member D On A.meidx=D.midx "
  SQL=SQL&" where A.sjidx='"&rsjidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      sjdate=Rs(0)    '수주일자
      sjnum=Rs(1)     '수주번호
      cgdate=Rs(2)    '출고일자
      djcgdate=Rs(3)  '도장출고일자
      cgtype=Rs(4)    '출고방식
      cgaddr=Rs(5)    '현장명
      cgset=Rs(6)     '입금후출고 설정
      sjmidx=Rs(7)    '거래처 담당자키
      sjcidx=Rs(8)    '거래처키
      midx=Rs(9)      '작성자키
      wdate=Rs(10)    '작성일
      meidx=Rs(11)    '수정자키
      mewdate=Rs(12)  '수정일
      tsprice=Rs(13)  '공급가
      trate=Rs(14)    '할인율
      tdisprice=Rs(15)'할인금액
      tfprice=Rs(16)  '최공공급가액
      taxprice=Rs(17) '세액
      tzprice=Rs(18)  '최종가
      cus_mname=Rs(19)'거래처 담당자 명
      cus_cname=Rs(20)  '거래서 회사명
      our_mname=Rs(21)  '자사 담당자명
    End if
    RS.Close
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
            zoom: 0.8;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
    <style>
        .header {
            text-align: center;
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 20px;
            position: relative;
            display: inline-block;
        }
        .header::after {
            content: "";
            display: block;
            width: 100%;
            height: 3px;
            background-color: black;
            position: absolute;
            bottom: -5px;
            left: 0;
        }
        .table thead th { background-color: #f8f9fa; }
    </style>

  <style>

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
  </style>



    <script>
        function formatCurrency(input) {
            let value = input.value.replace(/[^0-9]/g, '');
            value = new Intl.NumberFormat('ko-KR').format(value);
            input.value = value;
        }
    </script>
    <style>
         /* 프린트 설정 */
        @page {
            size: A4 portrait; /* 기본값: 세로(A4) */
            margin: 0mm; /* 최소 여백 설정 */
        }
        @media print {
            .form-control {
                width: auto; /* 인쇄 시 너비 자동 조정 */
            }
            .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */
        }
    </style>
</head>
<body class="sb-nav-fixed">

<div id="layoutSidenav_content">    
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
            <div class="card card-body mb-1"><!-- *  1111  -->
                <div class="row ">
                    <div class="container mt-1 TEXT-CENTER">
                        <div class="header" >견 적 서</div>
                        <button class="print-btn" onclick="window.print()">🖨️ 출력하기</button>
                    </div>
                </div>
                <div class="row ">
                    <div class="col-7">
                        <div class="input-group mb-3">
                            <span class="input-group-text" style="font-weight: bold;">견적번호&nbsp;&nbsp;&nbsp;</span>
                            <input type="text" class="form-control" style="font-weight: bold;" name="" value="<%=sjnum%>">
                        </div> 
                        <div class="input-group mb-3">
                            <span class="input-group-text" style="font-weight: bold;">업&nbsp;체&nbsp;명&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            <input type="text" class="form-control" style="font-weight: bold;" name="" value="<%=cus_cname%>">
                        </div> 
                        <div class="input-group mb-3">    
                            <span class="input-group-text" style="font-weight: bold;">견적일자&nbsp;&nbsp;&nbsp;</span>
                            <input type="text" class="form-control" style="font-weight: bold;" name="" value="<%=FormatDateTime(sjdate,vbLongDate)%>">
                        </div> 
                        <div class="input-group mb-3">
                            <span class="input-group-text" style="font-weight: bold;">프로젝트명</span>
                            <input type="text" class="form-control" style="font-weight: bold;" name="" value="<%=cgaddr%>">
                        </div>
                        <div class="input-group mb-3">
                            <span class="input-group-text" style="font-weight: bold;">총&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</span>
                            <input type="text" class="form-control" style="font-weight: bold;" name="" value="<%=formatCurrency(tzprice)%>"  >
                        </div>
                    </div>
                    <div class="col-5">
                        <img id="image1" src="\img\frame\taekwang_logo1.jpg" alt="태광도어" class="active img-fluid ">
                    </div>  
                </div> 

            </div>     
<!-- 품목별 견젹 내용 시작 -->
 <%
SQL = "SELECT A.sjsidx, B.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.sjsprice, A.quan, A.sprice, A.fprice, A.taxrate "
SQL = SQL & "FROM tng_sjaSub A "
SQL = SQL & "LEFT JOIN tng_sjb B ON A.sjb_idx = B.sjb_idx "
SQL = SQL & "LEFT JOIN tng_sjbtype F ON B.sjb_type_no = F.sjb_type_no "
SQL = SQL & "WHERE A.sjidx = '" & rsjidx & "' AND A.astatus = 1 "
Rs1.Open SQL, Dbcon
If Not (Rs1.EOF Or Rs1.BOF) Then
  i = 1
  Do While Not Rs1.EOF
    sjb_idx = Rs1("sjb_idx")
    sjb_type_name = Rs1("sjb_type_name")
    mwidth = Rs1("mwidth")
    mheight = Rs1("mheight")
    sjsprice = Rs1("sjsprice")
    quan = Rs1("quan")
    sprice = Rs1("sprice")
    fprice = Rs1("fprice")
    taxrate = Rs1("taxrate")
%>

<div class="card mb-2 p-2">
  <div class="row">
    <div class="field">
      <span>품목</span>
      <input type="text" value="<%= sjb_type_name %>" readonly>
      <span>규격</span>
      <input type="text" value="<%=mwidth%> x <%=mheight%>" readonly>
      <span>재질</span>
      <input type="text" value="" readonly>
      <span>도장</span>
      <input type="text" value="" readonly>
      <span>도어포함여부</span>
      <input type="text" value="" readonly>
      <span>기타</span>
      <input type="text" value="" readonly>
    </div>
  </div>
  <div class="row p-3">
    <table id="datatablesSimple"  class="table">
        <thead>
            <tr>
                <th align="center">No.</th>
                <th align="center">품명</th>
                <th align="center">개소명</th>
                <th align="center">규격 W</th>
                <th align="center">규격 H</th>
                <th align="center">수량</th>
                <th align="center">단가</th>
                <th align="center">금액</th>
            </tr>
        </thead>
        <tbody>
    <%
    %> 
            <tr>
                <td><%=no-i%></td>
                <td><%=sjb_type_name%></td>
                <td><%=aaa%></td>
                <td><%=mwidth%></td>
                <td><%=mheight%></td>
                <td><%=quan%></td>
                <td><%=sjsprice%></td>
                <td><%=fprice%></td>
                <td><%=tstatus_text%></td>
            </tr>
    <%
    %>
            </tbody>
    </table> 
  </div>
<%
    i = i + 1
    Rs1.MoveNext
  Loop
End If
Rs1.Close
%>
</div>



<!-- 품목별 견적 내용 끝 -->



            <div class="card card-body mb-1"><!-- *  33333333  -->
                <div class="d-flex justify-content-end align-items-center">
                    <label for="name" style="margin-right: 10px; font-size: 20px; font-weight: bold;">공     급     가     총     액</label>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="<%=FormatNumber(tfprice,0)%>원" readonly style="width: 400px;">
                </div>
                <div class="d-flex justify-content-end align-items-center">
                    <label for="name" style="margin-right: 10px; font-size: 20px; font-weight: bold;">세   액 (부  가  가  치  세 )</label>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="<%=FormatNumber(taxprice,0)%>원" readonly style="width: 400px;">
                </div>
                <div class="d-flex justify-content-end align-items-center">
                    <label for="name" style="margin-right: 10px; font-size: 20px; font-weight: bold;">합        계        금        액</label>
                    <input type="text" class="form-control" id="" name="" placeholder="" value="<%=FormatNumber(tzprice,0)%>원" readonly style="width: 400px;">
                </div>
            </div>  
        </div>      
        </div>
    </div>
</main>                          
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
