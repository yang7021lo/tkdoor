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


  <!-- 기본 파비콘 (브라우저 탭) -->
  <link rel="shortcut icon" href="https:/paletto.kr/assets/favicon/favicon.ico">

  <!-- PNG 파비콘 (브라우저 지원) -->
  <link rel="icon" type="image/png" sizes="16x16" href="https:/paletto.kr/assets/favicon/favicon-16x16.png">
  <link rel="icon" type="image/png" sizes="32x32" href="https:/paletto.kr/assets/favicon/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="96x96" href="https:/paletto.kr/assets/favicon/favicon-96x96.png">
  <link rel="icon" type="image/png" sizes="192x192" href="https:/paletto.kr/assets/favicon/android-icon-192x192.png">

  <!-- Apple Touch 아이콘 -->
  <link rel="apple-touch-icon" sizes="57x57" href="https:/paletto.kr/assets/favicon/apple-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="60x60" href="https:/paletto.kr/assets/favicon/apple-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="72x72" href="https:/paletto.kr/assets/favicon/apple-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="76x76" href="https:/paletto.kr/assets/favicon/apple-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="114x114" href="https:/paletto.kr/assets/favicon/apple-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="120x120" href="https:/paletto.kr/assets/favicon/apple-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="144x144" href="https:/paletto.kr/assets/favicon/apple-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="152x152" href="https:/paletto.kr/assets/favicon/apple-icon-152x152.png">
  <link rel="apple-touch-icon" sizes="180x180" href="https:/paletto.kr/assets/favicon/apple-icon-180x180.png">
</head>

<body>
  <div class="a4-page">
    <!-- Print 버튼 -->
<button id="printBtn" class="btn btn-dark no-print print-btn">🖨️ 인쇄</button>

<script>
  (function(){
    const printBtn = document.getElementById('printBtn');

    function isUnsupportedWebview() {
      const ua = navigator.userAgent || '';
      // 카카오톡 웹뷰 UA에 KAKAOTALK, DM 웹뷰 예시로 Instagram 포함
      return /KAKAOTALK/i.test(ua) || /Instagram/i.test(ua);
    }

    printBtn.addEventListener('click', function(){
      if (isUnsupportedWebview()) {
        alert(
          '인쇄 기능이 지원되지 않는 환경입니다.\n' +
          '일반 브라우저(Chrome, Safari 등)에서 열어 인쇄해주세요.'
        );
      } else {
        window.print();
      }
    });
  })();
</script>


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

    <!-- 항목 섹션 -->
<div class="section">

  <!-- 데스크톱(md ≥768px): 기존 카드 + 테이블 -->
  <div class="d-none d-md-block">
    <div class="card mb-4 shadow-sm">
      <div class="card-header text-black">
        <div class="parent-title"><strong>No. 1</strong> 헤어라인 1.2 (100×45)</div>
      </div>
      <div class="card-body p-0">
        <table class="table table-bordered table-sm mb-0 text-center">
          <thead class="table-light">
            <tr class="table table-secondary">
              <th>Sub No.</th><th>규격</th><th>가로</th><th>세로</th>
              <th>수량</th><th>단가</th><th>납품가</th>
            </tr>
          </thead>
          <tbody>
            <tr><td>1</td><td>SSD 103</td><td>33120</td><td>2900</td><td>1</td><td>₩6,270,000</td><td>₩6,270,000</td></tr>
            <tr><td>2</td><td>SSD 104</td><td>9040</td><td>2900</td><td>1</td><td>₩1,910,000</td><td>₩1,910,000</td></tr>
            <tr><td>3</td><td>SSD 105</td><td>11360</td><td>2900</td><td>1</td><td>₩2,372,000</td><td>₩2,372,000</td></tr>
            <tr><td>4</td><td>SSD 106 A</td><td>1835</td><td>2900</td><td>1</td><td>₩450,000</td><td>₩450,000</td></tr>
            <tr><td>5</td><td>SSD 106</td><td>16465</td><td>2900</td><td>1</td><td>₩3,240,000</td><td>₩3,240,000</td></tr>
            <tr><td>6</td><td>SSD 107</td><td>25720</td><td>2800</td><td>1</td><td>₩4,672,000</td><td>₩4,672,000</td></tr>
            <tr><td>7</td><td>SSD 108</td><td>13650</td><td>2500</td><td>1</td><td>₩2,345,000</td><td>₩2,345,000</td></tr>
            <tr><td>8</td><td>SSD 109</td><td>1050</td><td>2500</td><td>1</td><td>₩240,000</td><td>₩240,000</td></tr>
            <tr><td>9</td><td>SSD 110</td><td>1050</td><td>2200</td><td>1</td><td>₩186,000</td><td>₩186,000</td></tr>
            <tr><td>10</td><td>SSD 112</td><td>7500</td><td>2500</td><td>1</td><td>₩1,245,000</td><td>₩1,245,000</td></tr>
            <tr><td>11</td><td>SSD 113</td><td>9140</td><td>2500</td><td>1</td><td>₩1,836,000</td><td>₩1,836,000</td></tr>
            <tr><td>12</td><td>SSD 114</td><td>5680</td><td>2500</td><td>1</td><td>₩1,032,000</td><td>₩1,032,000</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- 모바일(md <768px): 부모 카드 + 자식 카드 리스트 -->
  <div class="d-block d-md-none">
    <div class="card mb-4 shadow-sm">
      <!-- 부모 카드 헤더 -->
      <div class="card-header text-black">
        <div class="parent-title"><strong>No. 1</strong> 헤어라인 1.2 (100×45)</div>
      </div>
      <!-- 자식 카드들 -->
      <div class="card-body p-2">
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">1. SSD 103</div>
            <div class="detail-grid">
              <span>규격: SSD 103</span>
              <span>가로: 33,120</span>
              <span>세로: 2,900</span>
              <span>수량: 1</span>
              <span>단가: ₩6,270,000</span>
              <span>납품가: ₩6,270,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">2. SSD 104</div>
            <div class="detail-grid">
              <span>규격: SSD 104</span>
              <span>가로: 9,040</span>
              <span>세로: 2,900</span>
              <span>수량: 1</span>
              <span>단가: ₩1,910,000</span>
              <span>납품가: ₩1,910,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">3. SSD 105</div>
            <div class="detail-grid">
              <span>규격: SSD 105</span>
              <span>가로: 11,360</span>
              <span>세로: 2,900</span>
              <span>수량: 1</span>
              <span>단가: ₩2,372,000</span>
              <span>납품가: ₩2,372,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">4. SSD 106 A</div>
            <div class="detail-grid">
              <span>규격: SSD 106 A</span>
              <span>가로: 1,835</span>
              <span>세로: 2,900</span>
              <span>수량: 1</span>
              <span>단가: ₩450,000</span>
              <span>납품가: ₩450,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">5. SSD 106</div>
            <div class="detail-grid">
              <span>규격: SSD 106</span>
              <span>가로: 16,465</span>
              <span>세로: 2,900</span>
              <span>수량: 1</span>
              <span>단가: ₩3,240,000</span>
              <span>납품가: ₩3,240,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">6. SSD 107</div>
            <div class="detail-grid">
              <span>규격: SSD 107</span>
              <span>가로: 25,720</span>
              <span>세로: 2,800</span>
              <span>수량: 1</span>
              <span>단가: ₩4,672,000</span>
              <span>납품가: ₩4,672,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">7. SSD 108</div>
            <div class="detail-grid">
              <span>규격: SSD 108</span>
              <span>가로: 13,650</span>
              <span>세로: 2,500</span>
              <span>수량: 1</span>
              <span>단가: ₩2,345,000</span>
              <span>납품가: ₩2,345,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">8. SSD 109</div>
            <div class="detail-grid">
              <span>규격: SSD 109</span>
              <span>가로: 1,050</span>
              <span>세로: 2,500</span>
              <span>수량: 1</span>
              <span>단가: ₩240,000</span>
              <span>납품가: ₩240,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">9. SSD 110</div>
            <div class="detail-grid">
              <span>규격: SSD 110</span>
              <span>가로: 1,050</span>
              <span>세로: 2,200</span>
              <span>수량: 1</span>
              <span>단가: ₩186,000</span>
              <span>납품가: ₩186,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">10. SSD 112</div>
            <div class="detail-grid">
              <span>규격: SSD 112</span>
              <span>가로: 7,500</span>
              <span>세로: 2,500</span>
              <span>수량: 1</span>
              <span>단가: ₩1,245,000</span>
              <span>납품가: ₩1,245,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">11. SSD 113</div>
            <div class="detail-grid">
              <span>규격: SSD 113</span>
              <span>가로: 9,140</span>
              <span>세로: 2,500</span>
              <span>수량: 1</span>
              <span>단가: ₩1,836,000</span>
              <span>납품가: ₩1,836,000</span>
            </div>
          </div>
        </div>
        <div class="card mobile-item-card">
          <div class="card-body p-2">
            <div class="fw-semibold mb-1">12. SSD 114</div>
            <div class="detail-grid">
              <span>규격: SSD 114</span>
              <span>가로: 5,680</span>
              <span>세로: 2,500</span>
              <span>수량: 1</span>
              <span>단가: ₩1,032,000</span>
              <span>납품가: ₩1,032,000</span>
            </div>
          </div>
        </div>
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