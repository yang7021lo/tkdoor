<%@ codepage="65001" language="vbscript" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"


' ALTER TABLE tk_framekSub ADD
'     entity_type INT NOT NULL DEFAULT 0,
'     parent_fksidx INT NULL,
'     door_no INT DEFAULT 0,
'     sub_type INT DEFAULT 0,
'     arch_r1 FLOAT DEFAULT 0,
'     arch_r2 FLOAT DEFAULT 0,
'     hole_diameter FLOAT DEFAULT 0,
'     hole_depth FLOAT DEFAULT 0,
'     is_virtual BIT DEFAULT 0,
'     calc_done BIT DEFAULT 0;

' CREATE TABLE dbo.tk_framekSub_geom (
'     fksidx INT IDENTITY PRIMARY KEY,
'     fkidx INT NOT NULL,
    
'     entity_type INT NOT NULL,
'     -- 1 유리
'     -- 2 픽스유리
'     -- 3 분할바
'     -- 4 간살
'     -- 5 하부고시
'     -- 6 손잡이
'     -- 7 아치
'     -- 8 타공

'     groupcode INT DEFAULT 0,
'     parent_fksidx INT NULL,

'     xi FLOAT DEFAULT 0,
'     yi FLOAT DEFAULT 0,
'     wi FLOAT DEFAULT 0,
'     hi FLOAT DEFAULT 0,

'     rot_type INT DEFAULT 0,
'     garo_sero INT DEFAULT 0,

'     status INT DEFAULT 1,
'     cdate DATETIME DEFAULT GETDATE()
' );

' CREATE TABLE dbo.tng_door_glass (

'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     bfidx INT,
'     glass_type NVARCHAR(50),
'     glass_t FLOAT,

'     area FLOAT,
'     price INT,

'     memo NVARCHAR(100)
' );

' CREATE TABLE  dbo.tng_fix_glass (
'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     bfidx INT,
'     glass_type NVARCHAR(50),
'     glass_t FLOAT,
    
'     memo NVARCHAR(100)
' );

' CREATE TABLE dbo.tng_divider_bar (

'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     bfidx INT,
'     alength FLOAT,

'     bar_type INT,
'     -- 1 통바
'     -- 2 중간바

'     unitprice INT,
'     sprice INT
' );


' CREATE TABLE dbo.tng_grid_bar (

'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     bfidx INT,
'     alength FLOAT,

'     unitprice INT,
'     sprice INT
' );


' CREATE TABLE dbo.tng_bottom_panel (

'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     bfidx INT,
'     panel_type INT,

'     width FLOAT,
'     height FLOAT,

'     price INT
' );

' CREATE TABLE dbo.tng_handle (

'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     bfidx INT,
'     handle_type INT,

'     position_height INT,

'     price INT
' );

' CREATE TABLE dbo.tng_arch (

'     fksidx INT PRIMARY KEY,
'     fkidx INT NOT NULL,

'     arch_type INT,
'     r1 FLOAT,
'     r2 FLOAT,

'     is_internal BIT
' );

' CREATE TABLE dbo.tng_hole (

'     fksidx INT PRIMARY KEY,
'     fkidx INT,
'     parent_fksidx INT,

'     diameter FLOAT,
'     depth FLOAT,

'     price INT
' );  이렇게 했어.. 추가 크리에이트 된거 Comment 달게..

' 1️⃣ tk_framekSub 추가 컬럼 설명
' 🔹 entity_type INT

' 설명:
' 이 레코드가 어떤 엔티티(형상/자재)인지 구분하는 코드.
' (기존 프레임 바/자재도 0으로 두고, 엔진 전용 요소만 1~8 사용)

' 코드 규칙 예시

' 0 = 기존 프레임/자재(구분 안 함, 레거시)

' 1 = 유리 조각

' 2 = 픽스 유리

' 3 = 분할바(통바/중간바)

' 4 = 간살

' 5 = 하부고시

' 6 = 손잡이

' 7 = 아치

' 8 = 타공(홀)

' 🔹 parent_fksidx INT

' 설명:
' 이 레코드가 **어떤 상위 형상(fksidx)**에 붙어 있는지 나타내는 부모 키.
' 타공/손잡이/보강재 등, 상위 유리·문짝·바 형상에 종속되는 경우 사용.

' 예: 손잡이 → 기준 유리 fksidx

' 예: 타공(홀) → 기준 유리 fksidx

' 예: 보강재 → 기준 세로바 fksidx

' 🔹 door_no INT

' 설명:
' fkidx(프레임 세트) 안에서 몇 번째 도어인지(1~N) 표시하는 번호.
' 동일 fkidx 내의 좌우도어, 3연동, 4짝 도어 구분용.

' 0 = 도어 개념 없음(공용 바, 공용 픽스 등)

' 1~N = 1번 도어, 2번 도어, 3번 도어…

' 🔹 sub_type INT

' 설명:
' 같은 entity_type 안에서 세부 타입을 나누는 코드.
' 예를 들어 분할바/하부고시/손잡이 등 세부 형식 구분용.

' 예시

' 분할바(entity_type=3)

' 1 = 통바

' 2 = 중간바

' 하부고시(entity_type=5)

' 1 = 일체형

' 2 = 앞/뒤 조립형

' 손잡이(entity_type=6)

' 1 = 매립형

' 2 = 노출형

' 🔹 arch_r1 FLOAT

' 설명:
' 아치 형상 계산용 주 반지름 / 장축 값.
' 상·하·좌·우 아치에서 곡선 길이(파이값) 등을 계산할 때 사용.

' entity_type=7(아치)에서 의미 있음

' 타원형 아치일 경우, r1 = 가로방향 반지름 등으로 사용

' 🔹 arch_r2 FLOAT

' 설명:
' 아치 형상 계산용 보조 반지름 / 단축 값.
' 타원형 아치나 비대칭 아치에서 세로방향 반지름 등으로 사용.

' entity_type=7(아치)에서 의미 있음

' r1, r2 조합으로 타원 또는 변형 아치 표현

' 🔹 hole_diameter FLOAT

' 설명:
' 타공(홀) 가공의 지름(mm).
' 손잡이, 유리 타공 등에서 구멍 크기를 나타내며, 가공비 산정에 사용.

' entity_type=8(타공)에서 의미 있음

' 사용 안 하는 엔티티는 0 유지

' 🔹 hole_depth FLOAT

' 설명:
' 타공(홀) 가공의 깊이(mm) 또는 관통 여부 표시용 값.
' 관통일 경우 전체 두께와 동일하게 세팅 가능.

' entity_type=8(타공)에서 의미 있음

' 판넬/알루미늄 타공 가공비 계산에 활용 가능

' 🔹 is_virtual BIT

' 설명:
' 이 레코드가 실제 자재인지,
' 아니면 계산/구조용 가상 노드인지 표시.

' 0 = 실물 자재 (실제 발주·절단 대상)

' 1 = 가상 노드 (계산/분할용, 자재로 출고되지 않음)

' 🔹 calc_done BIT

' 설명:
' 이 레코드에 대해 엔진/Node 계산이 완료되었는지 표시하는 플래그.
' 길이/면적/단가/금액 계산이 끝난 상태인지 체크하는 용도.

' 0 = 아직 계산 전, 또는 변경 후 재계산 필요

' 1 = 최신 계산 상태 (blength, alength, area, sprice 등이 확정 상태)

' 2️⃣ tk_framekSub_geom 테이블 주석용 설명

' 테이블 설명

' 설명:
' tk_framekSub와 분리된 엔진 전용 좌표/형상 스냅샷 테이블.
' 도면 표시, Three.js/뷰어용, 버전 관리용 좌표 데이터를 저장.

' 🔹 fksidx INT (PK)

' 설명:
' 좌표 레코드 식별자.
' 특정 형상(엔티티)의 도면 좌표 1건을 나타내는 기본키.
' 필요 시 tk_framekSub.fksidx와 매핑하여 사용할 수 있음.

' 🔹 fkidx INT

' 설명:
' 상위 프레임 세트 키 (tk_framek.fkidx).
' 어떤 중문 세트의 좌표인지 구분하는 외래 키.

' 🔹 entity_type INT

' 설명:
' 이 좌표가 어떤 엔티티(형상)에 해당하는지 구분하는 코드.
' tk_framekSub.entity_type와 동일 규칙 사용 (1=유리, 2=픽스유리, … 8=타공).

' 🔹 groupcode INT

' 설명:
' 같은 도어/같은 세트에 속한 형상들을 묶는 그룹 코드.
' 예: 한 도어의 유리 조각들, 한 쌍의 손잡이, 하나의 아치 세트 등.

' 🔹 parent_fksidx INT

' 설명:
' 상위 형상(부모) 좌표 키.
' 유리 위에 있는 타공/손잡이/보강재 등 종속 형상과의 관계 표현.

' 🔹 xi / yi / wi / hi FLOAT

' xi 설명:
' 도면 좌상단 기준 X 좌표(시작 위치).
' 캔버스/뷰어 기준 상대 위치.

' yi 설명:
' 도면 좌상단 기준 Y 좌표(시작 위치).

' wi 설명:
' 도면에서 표시되는 가로 길이 (픽셀 또는 mm 환산값).

' hi 설명:
' 도면에서 표시되는 세로 높이 (픽셀 또는 mm 환산값).

' 🔹 rot_type INT

' 설명:
' 형상 회전/방향 코드.
' 손잡이 방향, 아치 방향(상/하/좌/우), 부재의 회전 상태 표현용.

' 🔹 garo_sero INT

' 설명:
' 형상의 방향/구분 코드.

' 0 = 가로 요소 (하부고시, 가로바 등)

' 1 = 세로 요소 (세로바, 세로 간살 등)

' 2 = 포인트/점 요소 (손잡이, 타공 위치 등)

' 🔹 status INT

' 설명:
' 좌표 레코드 사용 상태.

' 1 = 사용

' 0 = 삭제/비활성

' 🔹 cdate DATETIME

' 설명:
' 좌표 레코드 생성 일시.
' 엔진/도면 버전 추적용.

' 3️⃣ tng_door_glass 테이블 주석

' 테이블 설명

' 설명:
' 중문 도어 유리 조각에 대한 속성/면적/금액 정보를 저장하는 테이블.
' 하나의 fksidx(좌표)에 대응하는 실제 유리 정보.

' fksidx INT

' tk_framekSub.fksidx 참조.
' 해당 유리 조각의 좌표/형상 레코드 키.

' fkidx INT

' 상위 프레임 세트 키 (tk_framek.fkidx).
' 조회 편의를 위한 중복 저장.

' bfidx INT

' 유리 자재 마스터 키 (tk_barasiF.bfidx).
' 사용된 유리 종류/규격 연결.

' glass_type NVARCHAR(50)

' 유리 종류(투명, 망입, 브론즈, 로이 등) 문자 설명.

' glass_t FLOAT

' 유리 두께(mm).

' area FLOAT

' 유리 면적 (시스템 기준 단위: mm² 또는 m²).
' 가격 계산 및 원가 산정용.

' price INT

' 해당 유리 조각의 공급가/원가 금액.
' 면적 × 단가 등의 결과값.

' memo NVARCHAR(100)

' 유리별 비고/특이사항(예: 모서리 연마, 추가 가공 등).

' 4️⃣ tng_fix_glass 테이블 주석

' 테이블 설명

' 설명:
' 중문 주변의 픽스 유리(고정 유리)에 대한 속성 정보 테이블.

' fksidx INT

' tk_framekSub.fksidx 참조 (픽스 유리 좌표).

' fkidx INT

' 상위 프레임 세트 키.

' bfidx INT

' 픽스 유리에 사용된 유리 자재 마스터 키.

' glass_type NVARCHAR(50)

' 픽스 유리 종류 설명.

' glass_t FLOAT

' 픽스 유리 두께(mm).

' memo NVARCHAR(100)

' 픽스 유리 비고.

' 5️⃣ tng_divider_bar 테이블 주석

' 테이블 설명

' 설명:
' 중문의 **분할바(통바/중간바)**에 대한 정보.
' 한 줄짜리 바(통바) 또는 중간 분할용 바 length/가격 저장.

' fksidx INT

' tk_framekSub.fksidx 참조 (분할바 좌표 키).

' fkidx INT

' 상위 프레임 세트 키.

' bfidx INT

' 분할바에 사용된 알루미늄/자재 마스터 키.

' alength FLOAT

' 실제 절단 길이(mm).

' bar_type INT

' 1=통바, 2=중간바 등 형태 구분 코드.

' unitprice INT

' 미터당 단가(또는 단위 길이당 단가).

' sprice INT

' 해당 분할바 1개에 대한 실 금액 (alength + pcent 반영 결과).

' 6️⃣ tng_grid_bar 테이블 주석

' 테이블 설명

' 설명:
' 중문 **간살 바(격자 바)**에 대한 길이/금액 정보.
' 세로 간살, 가로 간살 등 복수 개의 바를 관리.

' fksidx INT

' tk_framekSub.fksidx 참조 (간살 좌표).

' fkidx INT

' 상위 프레임 세트 키.

' bfidx INT

' 간살 자재 마스터 키.

' alength FLOAT

' 간살 절단 길이(mm).

' unitprice INT

' 간살 자재의 단가(미터당 등).

' sprice INT

' 간살 1개에 대한 확정 금액.

' 7️⃣ tng_bottom_panel 테이블 주석

' 테이블 설명

' 설명:
' 도어 하단의 **하부고시(판넬)**에 대한 정보.
' 조립형/붙임형 등 여러 타입의 하부고시를 표현.

' fksidx INT

' tk_framekSub.fksidx 참조 (하부고시 좌표).

' fkidx INT

' 상위 프레임 세트 키.

' bfidx INT

' 하부고시에 사용되는 판넬/자재 마스터 키.

' panel_type INT

' 하부고시 타입 코드 (일체형/조립형 등).

' width FLOAT

' 하부고시 가로 치수(mm).

' height FLOAT

' 하부고시 세로 치수(mm).

' price INT

' 하부고시 1개에 대한 금액.

' 8️⃣ tng_handle 테이블 주석

' 테이블 설명

' 설명:
' 중문의 **손잡이(핸들)**에 대한 정보.
' 위치/종류/가격을 엔진과 분리하여 관리.

' fksidx INT

' tk_framekSub.fksidx 참조 (손잡이 좌표).

' fkidx INT

' 상위 프레임 세트 키.

' bfidx INT

' 손잡이 자재 마스터 키.

' handle_type INT

' 손잡이 타입 코드 (매립형, 노출형, 바형 등).

' position_height INT

' 바닥 기준 손잡이 설치 높이(mm).
' 현장 치수/시공 기준으로 중요 정보.

' price INT

' 손잡이 1세트 금액.

' 9️⃣ tng_arch 테이블 주석

' 테이블 설명

' 설명:
' 중문의 아치(곡선 상부/하부/측면) 형상 정보 테이블.
' 반지름/타원 계수 등 곡선 계산용 파라미터 저장.

' fksidx INT

' tk_framekSub.fksidx 참조 (아치 좌표).

' fkidx INT

' 상위 프레임 세트 키.

' arch_type INT

' 아치 타입 코드 (반원, 타원, 비대칭 등).

' r1 FLOAT

' 아치 곡선 계산용 주 반지름/장축 값.

' r2 FLOAT

' 아치 곡선 계산용 보조 반지름/단축 값.

' is_internal BIT

' 1이면 유리 내부 기준 아치, 0이면 외곽 기준 아치 등, 기준 좌표/형상 구분용.

' 🔟 tng_hole 테이블 주석

' 테이블 설명

' 설명:
' 유리/판넬 등에 들어가는 타공(홀) 가공 정보 테이블.

' fksidx INT

' tk_framekSub.fksidx 참조 (홀 위치 좌표).

' fkidx INT

' 상위 프레임 세트 키.

' parent_fksidx INT

' 이 타공이 적용된 상위 형상(fksidx).
' 예: 유리 조각 fksidx.

' diameter FLOAT

' 타공 지름(mm).

' depth FLOAT

' 타공 깊이(mm) 또는 관통 여부 기준값.

' price INT

' 타공 1개당 가공비/금액.  중문용 디비
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>Door Engine v1</title>
<link rel="stylesheet" type="text/css" href="/door/Engine/door_engine.css">
</head>
<body>

<!-- ================= 상단 구조 선택 ================= -->
<div id="topBar">

  <div class="topBox">
    <h4>① 중문 종류</h4>
    <div class="topList" id="doorTypeList">
      <div class="topItem" data-type="hinge">여닫이</div>
      <div class="topItem" data-type="sliding">슬라이딩</div>
      <div class="topItem" data-type="folding">폴딩</div>
      <div class="topItem" data-type="auto">자동</div>
      <div class="topItem" data-type="pocket">포켓</div>
      <div class="topItem" data-type="swing">스윙</div>
      <div class="topItem" data-type="fixmix">픽스+중문</div>
    </div>
  </div>

  <div class="topBox">
    <h4>② 세부 구조</h4>
    <div class="topList" id="doorDetailList">
      <div style="color:#888;">중문 종류 선택</div>
    </div>
  </div>
</div>

<!-- ================= 본문 ================= -->
<div id="wrap">

<!-- ================= 캔버스 ================= -->
<div id="canvasWrap">
  <canvas id="canvas" width="1200" height="700"></canvas>
</div>

<!-- ================= 우측 패널 ================= -->
<div id="panel">

  <div class="box">
    <h3>구조</h3>
    <div id="structureInfo">구조 선택 안됨</div>
  </div>

  <!-- 도어 전체 -->
  <div class="box">
    <h3>도어 전체</h3>
    <div class="row one rightbtn">
      <span>수</span><input id="doorCount" readonly>
      <span>가로</span><input id="doorW" type="number" value="900">
      <span>세로</span><input id="doorH" type="number" value="2200">
      <button id="btnApplyDoor">적용</button>
    </div>
  </div>

  <!-- 선택 프레임 -->
  <div class="box">
    <h3>선택 프레임</h3>
    <div class="row one rightbtn">
      <span>가로</span><input id="selW" type="number">
      <span>세로</span><input id="selH" type="number">
      <button id="btnApplyFrame">적용</button>
    </div>
  </div>

  <!-- 하부고시 -->
  <div class="box">
    <h3>하부고시</h3>
    <div class="row one rightbtn">
      <span>높이</span><input id="bottomH" type="number" value="0">
      <button id="btnApplyBottom">적용</button>
      <button id="btnResetBottom">제거</button>
    </div>
  </div>

  <!-- 세로 간살 -->
  <div class="box">
    <h3>세로 간살</h3>
    <div class="row one">
      <button id="btnAddVG">1개</button>
      <button id="btnAddVGN">N등분</button>
      <button id="btnResetVG">전체삭제</button>
    </div>
  </div>

  <!-- 가로 간살 -->
  <div class="box">
    <h3>가로 간살</h3>
    <div class="row one">
      <button id="btnAddHG">1개</button>
      <button id="btnAddHGN">N등분</button>
    </div>
    <div class="row one">
      <button id="btnResetHGZone">선택만삭제</button>
      <button id="btnResetHGFrame">전체삭제</button>
    </div>
  </div>

  <!-- 아치 -->
  <div class="box">
    <h3>아치</h3>
    <div class="arcGrid">
      <label>상</label><input id="topArcH" type="number">
      <label>하</label><input id="botArcH" type="number">
      <label>좌</label><input id="leftArcD" type="number">
      <label>우</label><input id="rightArcD" type="number">
    </div>
    <div class="arcBtns">
      <button id="btnApplyArc">적용</button>
      <button id="btnResetArc">리셋</button>
    </div>
  </div>

</div>
</div>

<!-- ================= 하단 ================= -->
<div id="bottomUI">

  <!-- 전체 절단치 (타이틀만) -->
  <div id="bottomRow1">
    <div class="bottomBox full">
      <div class="bottomTitle">전체 절단치</div>
    </div>
  </div>

  <!-- 가로 5칸 -->
  <div id="bottomRow2" class="cutGrid">

    <div class="bottomBox">
      <div class="bottomTitle">프레임</div>
      <div id="cutFrame" class="bottomContent"></div>
    </div>

    <div class="bottomBox">
      <div class="bottomTitle">픽스</div>
      <div id="cutFix" class="bottomContent"></div>
    </div>

    <div class="bottomBox">
      <div class="bottomTitle">하부고시</div>
      <div id="cutBottom" class="bottomContent"></div>
    </div>

    <div class="bottomBox">
      <div class="bottomTitle">간살</div>
      <div id="cutBar" class="bottomContent"></div>
    </div>

    <div class="bottomBox">
      <div class="bottomTitle">아치</div>
      <div id="cutArc" class="bottomContent"></div>
    </div>

  </div>

</div>


<script src="/door/Engine/door_engine.js"></script>
</body>
</html>
