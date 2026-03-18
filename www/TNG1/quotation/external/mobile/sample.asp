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
  <title>직인 견적서</title>
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
        <h1 class="title mb-0">직인 견적서</h1>
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
          <div class="value">(주)아사아블로이엔트런스시스템</div>
        </div>
        <div class="item">
          <div class="label">프로젝트명</div>
          <div class="value">창원 상남동 힐스테이트</div>
        </div>
        <div class="item">
          <div class="label">견적번호</div>
          <div class="value">QT-20250625-002</div>
        </div>
        <div class="item">
          <div class="label">견적일자</div>
          <div class="value">2025년 6월 25일 토요일</div>
        </div>
        <div class="item">
          <div class="label">시공 장소</div>
          <div class="value">창원 상남동 힐스테이트</div>
        </div>
      </div>
      <div class="total-card">
        <img class="corp-stamp" width="100%" src="https://media.discordapp.net/attachments/1176516578616029254/1387307988511096865/1.png?ex=685cdebf&is=685b8d3f&hm=0018e32545a6e6f56b0cf038fa39e36cd6e24ccad45b7add3315a2c617d82873&=&format=webp&quality=lossless&width=2784&height=1310">
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
                        <div><strong>No. 1</strong> 헤어라인1.2+지정색도장</div>
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
        <thead class="table-dark">
          <tr>
            <th scope="col">번호</th>
            <th scope="col">품명</th>
            <th scope="col">규격 (W×H)</th>
            <th scope="col">수량</th>
            <th scope="col">단가</th>
            <th scope="col">금액</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>1</td>
            <td>ASD1 135×45 단열AL자동프레임 (도어포함가)</td>
            <td>2300×2700</td>
            <td>1</td>
            <td>₩700,000</td>
            <td>₩700,000</td>
          </tr>
          <tr>
            <td>3</td>
            <td>ASD2 120×45 일반AL자동프레임 (도어포함가)</td>
            <td>2300×2700</td>
            <td>4</td>
            <td>₩480,000</td>
            <td>₩1,920,000</td>
          </tr>
          <tr>
            <td>5</td>
            <td>ASD3 135×45 단열AL자동프레임 (도어포함가)</td>
            <td>4000×2700</td>
            <td>1</td>
            <td>₩1,048,000</td>
            <td>₩1,048,000</td>
          </tr>
          <tr>
            <td>7</td>
            <td>ASD4 120×45 일반AL자동프레임 (도어포함가)</td>
            <td>4000×2700</td>
            <td>1</td>
            <td>₩770,000</td>
            <td>₩770,000</td>
          </tr>
          <tr>
            <td>12</td>
            <td>재료분리대 (양개)</td>
            <td>—</td>
            <td>2</td>
            <td>₩25,000</td>
            <td>₩50,000</td>
          </tr>
          <tr>
            <td>13</td>
            <td>재료분리대 (편개)</td>
            <td>—</td>
            <td>2</td>
            <td>₩20,000</td>
            <td>₩40,000</td>
          </tr>
        </tbody>
      </table>
                    </div>
                  </div>
        




      </div>


    </div>


    <!-- 합계 (샘플 HTML) -->
<div class="section d-flex justify-content-end">
  <table class="table table-borderless table-sm text-end w-auto">
    <tr>
      <th class="px-3">공급가 총액:</th>
      <td class="px-3">₩4,528,000</td>
    </tr>
    <tr>
      <th class="px-3">세액 (부가가치세 10%):</th>
      <td class="px-3">₩452,800</td>
    </tr>
    <tr>
      <th class="px-3">합계금액:</th>
      <td class="px-3 fw-bold">₩4,980,800</td>
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