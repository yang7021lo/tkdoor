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
<html lang="ko">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>견적서</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/css/main.css" rel="stylesheet">
</head>

<body>
  <div class="a4-page">
    <!-- Print 버튼 -->
    <button class="btn btn-dark no-print print-btn" onclick="window.print()">🖨️ 인쇄</button>

    <!-- 헤더 -->
    <header class="d-flex justify-content-between align-items-center">
      <div class="company-info">
        <h1 class="title mb-0">견적서</h1>
      </div>
      <div class="text-end meta-info">
        <h2 class="mb-1">(주) 태광도어</h2>
        <div>경기 안산시 단원구 번영2로 25</div>
        <div>031-493-0516 | supports@tkdoor.kr</div>
      </div>
    </header>

    <!-- 프로젝트 & 총액 -->
    <div class="section d-flex justify-content-between align-items-start">
      <div class="project-card">
        <div class="item">
          <div class="label">업체명</div>
          <div class="value"><%=cus_cname%></div>
        </div>
        <div class="item">
          <div class="label">프로젝트명</div>
          <div class="value"><%=cgaddr%></div>
        </div>
        <div class="item">
          <div class="label">견적번호</div>
          <div class="value"><%=sjnum%></div>
        </div>
        <div class="item">
          <div class="label">견적일자</div>
          <div class="value"><%=FormatDateTime(sjdate,vbLongDate)%></div>
        </div>
      </div>
      <div class="total-card">
        <div class="label">총액</div>
        <div class="amount"><%=formatCurrency(tzprice)%></div>
      </div>
    </div>

    <!-- 항목 테이블 -->
    <!-- 항목 테이블: 부모/자식 행 구조 -->
    <div class="section table-responsive">
      <!-- 카드 하나가 parent + child 전체를 감싸는 구조 -->
      <div class="section">


<!-- 카드 루프 ON -->
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



                  <div class="card mb-4 shadow-sm">
                    <!-- 카드 헤더에 요약 정보 -->
                    <div class="card-header bg-primary text-white">
                      <div class="d-flex justify-content-between">
                        <div><strong>No. <%=i%></strong> <%= sjb_type_name %> (<%=mwidth%>×<%=mheight%>)</div>
                        <!-- 작은 속성 카드 블록 예시 -->
                        <div class="d-flex flex-wrap gap-2">
                          <!-- 재질 카드 -->
                          <div class="card border" style="width:6rem; font-size:.75rem;">
                            <div class="card-body p-1 text-center">
                              <div class="fw-semibold">재질</div>
                              <div>NaN</div>
                            </div>
                          </div>
                          <!-- 도장 카드 -->
                          <div class="card border" style="width:6rem; font-size:.75rem;">
                            <div class="card-body p-1 text-center">
                              <div class="fw-semibold">도장</div>
                              <div>NaN</div>
                            </div>
                          </div>
                          <!-- 도어 포함 여부 카드 -->
                          <div class="card border" style="width:6rem; font-size:.75rem;">
                            <div class="card-body p-1 text-center">
                              <div class="fw-semibold">도어포함</div>
                              <div>NaN</div>
                            </div>
                          </div>
                          <!-- 기타 카드 -->
                          <div class="card border" style="width:6rem; font-size:.75rem;">
                            <div class="card-body p-1 text-center">
                              <div class="fw-semibold">기타</div>
                              <div>NaN</div>
                            </div>
                          </div>
                        </div>

                      </div>
                    </div>

                    <!-- 카드 바디에 자식(세부) 테이블 -->
                    <div class="card-body p-0">
                      <table class="table table-bordered table-sm mb-0 text-center">
                        <thead class="table-light">
                          <tr>
                            <th>Sub No.</th>
                            <th>세부 품목</th>
                            <th>장소</th>
                            <th>규격 W</th>
                            <th>규격 H</th>
                            <th>수량</th>
                            <th>단가</th>
                            <th>금액</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr>
                            <td>1</td>
                            <td><%=sjb_type_name%></td>
                            <td><%=aaa%></td>
                            <td><%=mwidth%></td>
                            <td><%=mheight%></td>
                            <td><%=quan%></td>
                            <td><%=sjsprice%></td>
                            <td><%=fprice%></td>
                          </tr>
                        </tbody>
                      </table>
                    </div>
                  </div>
        


<%
    i = i + 1
    Rs1.MoveNext
  Loop
End If
Rs1.Close
%>


      </div>


    </div>


    <!-- 합계 -->
    <div class="section d-flex justify-content-end">
      <table class="table table-borderless table-sm text-end w-auto">
        <tr>
          <th class="px-3">공급가 총액:</th>
          <td class="px-3"><%=formatCurrency(tfprice)%></td>
        </tr>
        <tr>
          <th class="px-3">세액 (부가가치세):</th>
          <td class="px-3"><%= FormatCurrency(taxprice) %></td>
        </tr>
        <tr>
          <th class="px-3">합계금액:</th>
          <td class="px-3 fw-bold"><%= FormatCurrency(tzprice) %></td>
        </tr>
      </table>
    </div>

    <!-- 푸터 -->
    <footer>
      본 견적서는 전화 또는 이메일 확인 후 발주서 접수일에 최종 확정됩니다.
    </footer>
  </div>
</body>

</html>