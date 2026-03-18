<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")

rsjidx = Request("sjidx")
SQL = "SELECT a.sjcidx, b.cname,b.cgubun, b.cdlevel, b.cflevel " & _
      "FROM TNG_SJA a " & _
      "JOIN tk_customer b ON b.cidx = a.sjcidx " & _
      "WHERE a.sjidx = '" & rsjidx & "'"
Rs1.Open SQL, Dbcon
If Not (Rs1.BOF Or Rs1.EOF) Then
    sjcidx  = Rs1(0)
    cname   = Rs1(1)
    cgubun  = Rs1(2)
    cdlevel = Rs1(3)
    cflevel = Rs1(4)
End If
Rs1.Close

rsjsidx       = Request("sjsidx")
rfkidx        = Request("fkidx")
rfksidx       = Request("fksidx")
rsjb_idx      = Request("sjb_idx")
rsjb_type_no  = Request("sjb_type_no")
rqtyidx       = Request("qtyidx")
rpidx         = Request("pidx")
rjaebun       = Request("jaebun")
rboyang       = Request("boyang")
gubun         = Request("gubun")
rSearchWord   = Request("SearchWord")
%>

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <title>유리 사이즈 - 태광도어</title>

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    @import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css");
    * { font-family: Pretendard, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif; }
    html, body { height: 100%; margin: 0; padding: 0; background:#fff; color:#000; -webkit-print-color-adjust: exact; print-color-adjust: exact; }

    /* 화면에서 A4 미리보기 느낌 (세로) */
    .a4-sheet {
      margin: 0 auto;
      padding: 16mm;
      box-sizing: border-box;
    }

    /* 단위 접미사 */
    td[data-unit]:not(:empty)::after {
      content: " " attr(data-unit);
      font-size:.5em; color:#6c757d; margin-left:.15em;
    }

    /* 표/블록 쪼개짐 방지 */
    .avoid-break {
      break-inside: avoid;
      page-break-inside: avoid;
      -webkit-column-break-inside: avoid;
      -webkit-region-break-inside: avoid;
    }

    /* 우하단 플로팅 버튼 */
.fab-wrap{
  position: fixed;
  right: 16px;
  bottom: 16px;
  z-index: 2000;
}
.fab-card{
  background: #fff;
  border: 1px solid rgba(0,0,0,.15);
  border-radius: .75rem;
  box-shadow: 0 .5rem 1rem rgba(0,0,0,.15);
  padding: .5rem;
  display: flex;
  gap: .5rem;
}

    /* 인쇄 모드 */
    @page { size: A4 portrait; margin: 0; }
    @media print {
      .a4-sheet { width: 210mm !important; min-height: 297mm !important; padding: 12mm !important; }
      /* 모든 컬럼을 단일 컬럼으로 */
      /* 표/블록 쪼개짐 방지 유지 */
      .avoid-break {
        break-inside: avoid;
        page-break-inside: avoid;
        -webkit-column-break-inside: avoid;
        -webkit-region-break-inside: avoid;
      }
      .card {
        margin-bottom: 10px;
        }
         .fab-wrap{ display: none !important; }
           /* (수정) 모든 row는 1단으로 풀되, keep-print-grid는 예외 */
  .row:not(.keep-print-grid) > [class^="col"],
  .row:not(.keep-print-grid) > [class*=" col-"] {
    flex: 0 0 100% !important;
    max-width: 100% !important;
  }

  /* (선택) 더 확실히: 예외 row는 md 분할을 인쇄에도 명시 */
  .keep-print-grid > .col-md-7 {
    flex: 0 0 58.333333% !important;
    max-width: 58.333333% !important;
  }
  .keep-print-grid > .col-md-5 {
    flex: 0 0 41.666667% !important;
    max-width: 41.666667% !important;
    text-align: right;
  }
    }
  </style>
</head>

<body>

<!-- 우하단 플로팅 (인쇄/닫기) -->
<div class="fab-wrap d-print-none" role="region" aria-label="빠른 작업">
  <div class="fab-card">
    <button type="button" class="btn btn-primary" onclick="window.print()" title="인쇄">
      인쇄
    </button>
    <button type="button" class="btn btn-outline-secondary" onclick="handleClose()" title="닫기">
      닫기
    </button>
  </div>
</div>

  <div class="a4-sheet container-fluid">
  

    <!-- 헤더 -->
    <header class="mb-3">
      <div class="d-flex justify-content-between align-items-center">
        <div class="h4 m-0 fw-bold">태광도어</div>
        <img src="logo.svg" alt="태광도어 로고" style="height:40px;">
      </div>

      <div class="row mt-2 keep-print-grid">
        <div class="col-12 col-md-7">
          <div class="small text-muted">주식회사 태광도어</div>
          <div>경기도 안산시 단원구 번영2로 25</div>
          <div>사업자번호: 123456789</div>
          <div>대표: 김희일</div>
        </div>
        <div class="col-12 col-md-5 text-md-end mt-2 mt-md-0">
          <div class="small text-muted">고객센터</div>
          <div>tkdoor.kr</div>
          <div>supports@tkdoor.kr</div>
          <div>031-493-0516</div>
        </div>
      </div>

      <hr class="border-dark opacity-100 my-3">
    </header>

    <!-- 본문: 좌(도어 유리) / 우(픽스 유리) -->
    <div class="row g-4 avoid-break">
      <!-- 좌: 도어 유리 -->
      <div class="col-12 col-lg-7">
        <div class="card border-dark h-100">
          <div class="card-header bg-light border-dark fw-bold">
            도어 유리 <span class="ms-2 text-secondary fw-normal small">품명 / 도어W·도어H / 도어유리W·도어유리H</span>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-bordered table-sm align-middle mb-0" aria-label="도어 유리 사이즈 표">
                <thead class="table-secondary">
                  <tr class="text-center">
                    <th>품명</th>
                    <th style="width:13%;">도어 폭</th>
                    <th style="width:13%;">도어 높이</th>
                    <th style="width:15%;">유리 가로</th>
                    <th style="width:15%;">유리 세로</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    ' 도어 유리 리스트
                    Dim sqlDoor, rsDoor
                    sqlDoor = "SELECT " & _
                      "a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls," & _
                      "b.sjb_idx, b.sjb_type_no," & _
                      "a.fksidx, b.greem_o_type, b.GREEM_BASIC_TYPE, b.greem_fix_type," & _
                      "b.qtyidx, b.pidx, b.doorglass_t, b.fixglass_t, b.dooryn, b.GREEM_F_A," & _
                      "a.doorsizechuga_price, a.door_price, a.goname, a.barNAME, a.doortype, b.doorchoice " & _
                      "FROM tk_framekSub a " & _
                      "JOIN tk_framek b ON a.fkidx = b.fkidx " & _
                      "WHERE b.sjsidx = '" & Replace(rsjsidx,"'","''") & "' AND a.Door_W > 0"

                    Set rsDoor = Server.CreateObject("ADODB.Recordset")
                    rsDoor.Open sqlDoor, Dbcon

                    Dim doorTypeArr, doorChoiceArr
                    doorTypeArr   = Array("없음", "좌도어", "우도어")                     ' 0..2
                    doorChoiceArr = Array("", "도어 포함가", "도어 별도가", "도어 제외가") ' 0..3

                    If Not rsDoor.EOF Then
                      Do While Not rsDoor.EOF
                        kDOOR_W      = rsDoor("door_w")
                        kDOOR_H      = rsDoor("door_h")
                        kDOORGLASS_W = rsDoor("doorglass_w")
                        kDOORGLASS_H = rsDoor("doorglass_h")
                        kGONAME      = rsDoor("goname")
                        kBARNAME     = rsDoor("barNAME")
                        kDOORTYPE    = rsDoor("doortype")
                        kDOORCHOICE  = rsDoor("doorchoice")

                        If IsNumeric(kDOORTYPE) And kDOORTYPE >= 0 And kDOORTYPE <= 2 Then
                          kDOORTYPE_text = doorTypeArr(kDOORTYPE)
                        Else
                          kDOORTYPE_text = "없음"
                        End If

                        If IsNumeric(kDOORCHOICE) And kDOORCHOICE >= 1 And kDOORCHOICE <= 3 Then
                          kDOORCHOICE_text = doorChoiceArr(kDOORCHOICE)
                        Else
                          kDOORCHOICE_text = "선택되지 않음"
                        End If
                  %>
                  <tr>
                    <td>
                      <%= Server.HTMLEncode(kGONAME) %><br>
                      <small class="text-secondary">규격 <%= Server.HTMLEncode(kBARNAME) %> · <%= kDOORTYPE_text %> · <%= kDOORCHOICE_text %></small>
                    </td>
                    <td class="text-end" data-unit="mm"><%= kDOOR_W %></td>
                    <td class="text-end" data-unit="mm"><%= kDOOR_H %></td>
                    <td class="text-end fw-bold" data-unit="mm"><%= kDOORGLASS_W %></td>
                    <td class="text-end fw-bold" data-unit="mm"><%= kDOORGLASS_H %></td>
                  </tr>
                  <%
                        rsDoor.MoveNext
                      Loop
                    End If
                    rsDoor.Close : Set rsDoor = Nothing
                  %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>

      <!-- 우: 픽스 유리 -->
      <div class="col-12 col-lg-5">
        <div class="card border-dark h-100">
          <div class="card-header bg-light border-dark fw-bold">
            픽스 유리 <span class="ms-2 text-secondary fw-normal small">품명 / 가로 / 세로 / 수량(EA)</span>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-bordered table-sm align-middle mb-0" aria-label="픽스 유리 사이즈 표">
                <thead class="table-secondary">
                  <tr class="text-center">
                    <th style="width:50%;">품명</th>
                    <th style="width:18%;">가로</th>
                    <th style="width:18%;">세로</th>
                    <th style="width:14%;">수량</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    ' 같은 fkidx 내 동일 규격 묶기
                    Dim prev_fkidx, j, RsFix, dict
                    prev_fkidx = -1 : j = 0
                    SQL = "SELECT a.glass_w, a.glass_h, b.fkidx " & _
                          "FROM tk_framekSub a " & _
                          "JOIN tk_framek b ON a.fkidx = b.fkidx " & _
                          "WHERE b.sjsidx = '" & Replace(rsjsidx,"'","''") & "' " & _
                          "  AND a.gls <> 0 " & _
                          "  AND a.glass_w IS NOT NULL AND a.glass_h IS NOT NULL " & _
                          "ORDER BY b.fkidx, a.glass_w, a.glass_h"

                    Set RsFix = Server.CreateObject("ADODB.Recordset")
                    RsFix.Open SQL, Dbcon

                    Set dict = Server.CreateObject("Scripting.Dictionary")

                    Sub FlushGroupRows(d, jnum)
                      Dim key, parts, w, h, qty
                      For Each key In d.Keys
                        parts = Split(key, "x")
                        w = parts(0) : h = parts(1) : qty = d(key)
                        Response.Write _
                          "<tr>" & _
                            "<td>픽스 유리 (" & jnum & ")</td>" & _
                            "<td class=""text-end fw-bold"" data-unit=""mm"">" & w & "</td>" & _
                            "<td class=""text-end fw-bold"" data-unit=""mm"">" & h & "</td>" & _
                            "<td class=""text-end "">" & qty & "</td>" & _
                          "</tr>"
                      Next
                      d.RemoveAll
                    End Sub

                    If Not (RsFix.BOF Or RsFix.EOF) Then
                      Do While Not RsFix.EOF
                        Dim now_fkidx, glass_w, glass_h, key
                        now_fkidx = RsFix("fkidx")

                        If prev_fkidx <> now_fkidx Then
                          If dict.Count > 0 Then Call FlushGroupRows(dict, j)
                          j = j + 1
                          prev_fkidx = now_fkidx
                        End If

                        glass_w = RsFix("glass_w")
                        glass_h = RsFix("glass_h")
                        key = CStr(glass_w) & "x" & CStr(glass_h)

                        If dict.Exists(key) Then
                          dict(key) = dict(key) + 1
                        Else
                          dict.Add key, 1
                        End If

                        RsFix.MoveNext
                      Loop

                      If dict.Count > 0 Then Call FlushGroupRows(dict, j)
                    End If

                    RsFix.Close : Set RsFix = Nothing
                    Set dict = Nothing
                  %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <hr class="border-dark opacity-100 my-4">

    <!-- 푸터 -->
    <footer class="d-flex justify-content-between align-items-center small">
      <div class="text-muted">본 문서는 참고용임.</div>
      <div class="fw-semibold">태광도어 전산</div>
    </footer>
  </div>

  <!-- (선택) Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  function handleClose(){
    // 창으로 열렸으면 닫기, 아니면 이전 페이지로
    try { window.open('', '_self'); window.close(); } catch(e) {}
    if (history.length > 1) history.back();
  }
</script>


</body>
</html>
