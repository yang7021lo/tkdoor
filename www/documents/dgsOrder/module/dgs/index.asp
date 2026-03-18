
<%
' ===============================
'  파라미터
' ===============================
Dim rsjsidx
rsjsidx = Request("sjsidx") ' 여기선 원본을 그대로 두고, SQL에 넣을 땐 Q() 사용
%>

<style>
  @import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css");
  * { font-family: Pretendard, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif; }
  html, body { height: 100%; margin: 0; padding: 0; background:#fff; color:#000; -webkit-print-color-adjust: exact; print-color-adjust: exact; }

  .a4-sheet { margin: 0 auto; padding: 16mm; box-sizing: border-box; }

  td[data-unit]:not(:empty)::after {
    content: " " attr(data-unit);
    font-size:.5em; color:#6c757d; margin-left:.15em;
  }

  .avoid-break {
    break-inside: avoid;
    page-break-inside: avoid;
    -webkit-column-break-inside: avoid;
    -webkit-region-break-inside: avoid;
  }

  .fab-wrap{ position: fixed; right: 16px; bottom: 16px; z-index: 2000; }
  .fab-card{
    background: #fff; border: 1px solid rgba(0,0,0,.15); border-radius: .75rem;
    box-shadow: 0 .5rem 1rem rgba(0,0,0,.15); padding: .5rem; display: flex; gap: .5rem;
  }

  @page { size: A4 portrait; margin: 0; }
  @media print {
    .a4-sheet { width: 210mm !important; min-height: 297mm !important; padding: 12mm !important; }
    .avoid-break {
      break-inside: avoid; page-break-inside: avoid;
      -webkit-column-break-inside: avoid; -webkit-region-break-inside: avoid;
    }
    .card { margin-bottom: 10px; }
    .fab-wrap{ display: none !important; }

    .row:not(.keep-print-grid) > [class^="col"],
    .row:not(.keep-print-grid) > [class*=" col-"] {
      flex: 0 0 100% !important;
      max-width: 100% !important;
    }
    .keep-print-grid > .col-md-7 {
      flex: 0 0 58.333333% !important; max-width: 58.333333% !important;
    }
    .keep-print-grid > .col-md-5 {
      flex: 0 0 41.666667% !important; max-width: 41.666667% !important; text-align: right;
    }
  }
</style>

<%
' ===============================
'  DB 오픈
' ===============================
call dbOpen()
%>

<!-- 본문: 좌(도어 유리) / 우(픽스 유리) -->
<div class="row g-2">
  <!-- 좌: 도어 유리 -->
    <div class="card border-dark">
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
                ' --------------------------------------
                ' 도어 유리 리스트 (Dbcon 사용, Q() 사용)
                ' --------------------------------------
                Dim sqlDoor, rsDoor
                Dim doorTypeArr, doorChoiceArr
                Dim kDOOR_W, kDOOR_H, kDOORGLASS_W, kDOORGLASS_H
                Dim kGONAME, kBARNAME, kDOORTYPE, kDOORCHOICE
                Dim kDOORTYPE_text, kDOORCHOICE_text

                sqlDoor = ""
                sqlDoor = sqlDoor & "SELECT "
                sqlDoor = sqlDoor & "  a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls, "
                sqlDoor = sqlDoor & "  b.sjb_idx, b.sjb_type_no, "
                sqlDoor = sqlDoor & "  a.fksidx, b.greem_o_type, b.GREEM_BASIC_TYPE, b.greem_fix_type, "
                sqlDoor = sqlDoor & "  b.qtyidx, b.pidx, b.doorglass_t, b.fixglass_t, b.dooryn, b.GREEM_F_A, "
                sqlDoor = sqlDoor & "  a.doorsizechuga_price, a.door_price, a.goname, a.barNAME, a.doortype, b.doorchoice "
                sqlDoor = sqlDoor & "FROM tk_framekSub a "
                sqlDoor = sqlDoor & "JOIN tk_framek b ON a.fkidx = b.fkidx "
                sqlDoor = sqlDoor & "WHERE b.sjsidx = '" & Q(rsjsidx) & "' AND a.Door_W > 0"

                Set rsDoor = Server.CreateObject("ADODB.Recordset")
                rsDoor.Open sqlDoor, Dbcon

                doorTypeArr   = Array("없음", "좌도어", "우도어")                     ' 0..2
                doorChoiceArr = Array("", "도어 포함가", "도어 별도가", "도어 제외가") ' 0..3

                If Not (rsDoor.BOF Or rsDoor.EOF) Then
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
                <td class="text-end fw-bold fs-4" data-unit="mm"><%= kDOORGLASS_W %></td>
                <td class="text-end fw-bold fs-4" data-unit="mm"><%= kDOORGLASS_H %></td>
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
                ' --------------------------------------
                ' 같은 fkidx 내 동일 규격 묶기 (Dbcon 사용, Q() 사용)
                ' --------------------------------------
                Dim sqlFix, RsFix, dict
                Dim prev_fkidx, j
                Dim now_fkidx, glass_w, glass_h, key

                prev_fkidx = -1
                j = 0

                sqlFix = ""
                sqlFix = sqlFix & "SELECT a.glass_w, a.glass_h, b.fkidx "
                sqlFix = sqlFix & "FROM tk_framekSub a "
                sqlFix = sqlFix & "JOIN tk_framek b ON a.fkidx = b.fkidx "
                sqlFix = sqlFix & "WHERE b.sjsidx = '" & Q(rsjsidx) & "' "
                sqlFix = sqlFix & "  AND a.gls <> 0 "
                sqlFix = sqlFix & "  AND a.glass_w IS NOT NULL AND a.glass_h IS NOT NULL "
                sqlFix = sqlFix & "ORDER BY b.fkidx, a.glass_w, a.glass_h"

                Set RsFix = Server.CreateObject("ADODB.Recordset")
                RsFix.Open sqlFix, Dbcon

                Set dict = Server.CreateObject("Scripting.Dictionary")

                Sub FlushGroupRows(d, jnum)
  Dim kKey, parts, w, h, qty
  For Each kKey In d.Keys
    parts = Split(CStr(kKey), "x")
    w = parts(0) : h = parts(1) : qty = d(kKey)
    Response.Write _
      "<tr>" & _
        "<td>픽스 유리 (" & jnum & ")</td>" & _
        "<td class=""text-end fw-bold fs-4"" data-unit=""mm"">" & w & "</td>" & _
        "<td class=""text-end fw-bold fs-4"" data-unit=""mm"">" & h & "</td>" & _
        "<td class=""text-center fs-4"">" & qty & "</td>" & _
      "</tr>"
  Next
  d.RemoveAll
End Sub


                If Not (RsFix.BOF Or RsFix.EOF) Then
                  Do While Not RsFix.EOF
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

<%
' ===============================
'  DB 닫기
' ===============================
call dbClose()
%>