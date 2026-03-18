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
  <title>간이 견적서</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
  <link href="/TNG1/quotation/assets/css/main.css" rel="stylesheet">
</head>

<body>
  <div class="a4-page">
    <!-- Print 버튼 -->
    <button class="btn btn-dark no-print print-btn" onclick="window.print()">🖨️ 인쇄</button>

    <!-- 헤더 -->
    <header class="d-flex justify-content-between align-items-center">
      <div class="company-info">
        <h1 class="title mb-0">간이 견적서</h1>
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
          <div class="value">소산</div>
        </div>
        <div class="item">
          <div class="label">견적일자</div>
          <div class="value">2022년 10월 26일 일요일</div>
        </div>
      </div>
      <div class="total-card">
        <div class="label">총액</div>
        <div class="amount">₩28,377,800</div>
      </div>
    </div>

    <!-- 항목 테이블 -->
    <!-- 항목 테이블: 부모/자식 행 구조 -->
    <div class="section table-responsive">
      <!-- 카드 하나가 parent + child 전체를 감싸는 구조 -->
      <div class="section">


                  <div class="card mb-4 shadow-sm">
                    <!-- 카드 헤더에 요약 정보 -->
                    <div class="card-header bg-primary text-white">
                      <div class="d-flex justify-content-between">
                        <div><strong>No. 1</strong> 헤어라인 1.2 (100×45)</div>
                      </div>
                    </div>

                    <!-- 카드 바디에 자식(세부) 테이블 -->
                    <div class="card-body p-0">
                      <table class="table table-bordered table-sm mb-0 text-center">
                        <thead class="table-light">
                          <tr>
                            <th>Sub No.</th>
                            <th>규격</th>
                            <th>가로</th>
                            <th>세로</th>
                            <th>수량</th>
                            <th>단가</th>
                            <th>납품가</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr>
    <td>1</td>
    <td>SSD 103</td>
    <td>33120</td>
    <td>2900</td>
    <td>1</td>
    <td>₩6,270,000</td>
    <td>₩6,270,000</td>
</tr>
<tr>
    <td>2</td>
    <td>SSD 104</td>
    <td>9040</td>
    <td>2900</td>
    <td>1</td>
    <td>₩1,910,000</td>
    <td>₩1,910,000</td>
</tr>
<tr>
    <td>3</td>
    <td>SSD 105</td>
    <td>11360</td>
    <td>2900</td>
    <td>1</td>
    <td>₩2,372,000</td>
    <td>₩2,372,000</td>
</tr>
<tr>
    <td>4</td>
    <td>SSD 106 A</td>
    <td>1835</td>
    <td>2900</td>
    <td>1</td>
    <td>₩450,000</td>
    <td>₩450,000</td>
</tr>
<tr>
    <td>5</td>
    <td>SSD 106</td>
    <td>16465</td>
    <td>2900</td>
    <td>1</td>
    <td>₩3,240,000</td>
    <td>₩3,240,000</td>
</tr>
<tr>
    <td>6</td>
    <td>SSD 107</td>
    <td>25720</td>
    <td>2800</td>
    <td>1</td>
    <td>₩4,672,000</td>
    <td>₩4,672,000</td>
</tr>
<tr>
    <td>7</td>
    <td>SSD 108</td>
    <td>13650</td>
    <td>2500</td>
    <td>1</td>
    <td>₩2,345,000</td>
    <td>₩2,345,000</td>
</tr>
<tr>
    <td>8</td>
    <td>SSD 109</td>
    <td>1050</td>
    <td>2500</td>
    <td>1</td>
    <td>₩240,000</td>
    <td>₩240,000</td>
</tr>
<tr>
    <td>9</td>
    <td>SSD 110</td>
    <td>1050</td>
    <td>2200</td>
    <td>1</td>
    <td>₩186,000</td>
    <td>₩186,000</td>
</tr>
<tr>
    <td>10</td>
    <td>SSD 112</td>
    <td>7500</td>
    <td>2500</td>
    <td>1</td>
    <td>₩1,245,000</td>
    <td>₩1,245,000</td>
</tr>
<tr>
    <td>11</td>
    <td>SSD 113</td>
    <td>9140</td>
    <td>2500</td>
    <td>1</td>
    <td>₩1,836,000</td>
    <td>₩1,836,000</td>
</tr>
<tr>
    <td>12</td>
    <td>SSD 114</td>
    <td>5680</td>
    <td>2500</td>
    <td>1</td>
    <td>₩1,032,000</td>
    <td>₩1,032,000</td>
</tr>

                        </tbody>
                      </table>
                    </div>
                  </div>

      </div>


    </div>


        <!-- 합계 -->
    <div class="section d-flex justify-content-end">
      <table class="table table-borderless table-sm text-end w-auto">
        <tr>
          <th class="px-3">공급가 총액:</th>
          <td class="px-3">₩25,798,000</td>
        </tr>
        <tr>
          <th class="px-3">세액 (부가가치세):</th>
          <td class="px-3">₩2,579,800</td>
        </tr>
        <tr>
          <th class="px-3">합계금액:</th>
          <td class="px-3 fw-bold">₩28,377,800</td>
        </tr>
      </table>
    </div>


    <!-- 푸터 -->
    <footer>
      * 본 견적서는 참고용 샘플입니다.
    </footer>
  </div>
</body>

</html>