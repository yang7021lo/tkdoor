<%@ CodePage="65001" Language="VBScript" %>
<%
' ===============================
'  SVG 전용 미니모듈 (렌더링만)
' ===============================
Option Explicit
Response.ContentType = "text/html; charset=utf-8"
Response.CharSet     = "utf-8"
Response.Buffer      = True

' === 직접 DB 연결 (인클루드 제거) ===
Public Dbcon
Const OLE_DB = "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;User ID=tkd001;Password=tkd2713!;"

Sub dbOpen()
  If Not IsObject(Dbcon) Then
    Set Dbcon = Server.CreateObject("ADODB.Connection")
    Dbcon.ConnectionTimeout = 30
    Dbcon.CommandTimeout    = 30
  End If
  If Dbcon.State = 0 Then
    Dbcon.Open OLE_DB
  End If
End Sub

Sub dbClose()
  On Error Resume Next
  If IsObject(Dbcon) Then
    If Dbcon.State <> 0 Then Dbcon.Close
    Set Dbcon = Nothing
  End If
End Sub

' --- 유틸 ---
Function SafeLng(v, d)
  If IsNull(v) Then SafeLng = d : Exit Function
  Dim s : s = Trim(CStr(v))
  If s = "" Or Not IsNumeric(s) Then
    SafeLng = d
  Else
    SafeLng = CLng(s)
  End If
End Function

' 최소 이스케이프(따옴표만) - 문자열 파라미터용
Function Q(s)
  If IsNull(s) Then s = ""
  Q = Replace(CStr(s), "'", "''")
End Function
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>SVG 미니모듈</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/documents/outsideOrder/assets/css/index.css" rel="stylesheet">
</head>

<!--#include virtual="/TNG1/TNG1_B_suju5.asp"-->


<!--#include virtual="/TNG1/TNG1_B_suju4 copy.asp"-->


<!-- 도면 수치 표현 모듈 (data-value/data-type 사용) -->

<!-- Bootstrap JS (이미 없다면 추가) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>

<!-- floating download button (excluded from capture) -->
<button
  id="btnDownloadBody"
  data-html2canvas-ignore="true"
  style="
    position:fixed; right:16px; bottom:16px; z-index:2000;
    padding:.6rem 1rem; border:1px solid rgba(0,0,0,.15); border-radius:10px;
    background:#fff; box-shadow:0 .5rem 1rem rgba(0,0,0,.15); cursor:pointer;
  "
>
  이미지 다운로드
</button>

<script>
  // 필요: html2canvas v1.4+ (이미 로드되어 있어야 함)
  (function () {
    const btn = document.getElementById('btnDownloadBody');

    function ts() {
      const d = new Date();
      const p = n => String(n).padStart(2, '0');
      return `${d.getFullYear()}${p(d.getMonth()+1)}${p(d.getDate())}-${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
    }

    async function captureBodyToDataURL(scaleWanted = 2, bg = '#ffffff') {
      const el = document.body;
      const rect = el.getBoundingClientRect();
      const w = Math.max(el.scrollWidth, el.offsetWidth, rect.width || 0) | 0;
      const h = Math.max(el.scrollHeight, el.offsetHeight, rect.height || 0) | 0;

      // 브라우저 캔버스 한계(대부분 16384px) 안전 처리
      const MAX_DIM = 16384;
      let scale = scaleWanted;
      if (Math.max(w * scale, h * scale) > MAX_DIM) {
        scale = Math.max(1, Math.floor(MAX_DIM / Math.max(w, h)));
      }

      // 캡처 전 스크롤 제로로
      const sx = window.scrollX, sy = window.scrollY;
      try { window.scrollTo(0, 0); } catch {}

      const canvas = await html2canvas(el, {
        backgroundColor: bg,
        scale,
        useCORS: true,
        allowTaint: false,
        logging: false
      });

      // 원래 스크롤 복원
      try { window.scrollTo(sx, sy); } catch {}

      return canvas.toDataURL('image/png');
    }

    btn.addEventListener('click', async () => {
      try {
        btn.disabled = true;
        btn.textContent = '생성 중...';
        const dataUrl = await captureBodyToDataURL(2, '#ffffff');
        const a = document.createElement('a');
        a.href = dataUrl;
        a.download = `body-capture-${ts()}.png`;
        document.body.appendChild(a);
        a.click();
        a.remove();
      } catch (e) {
        console.error(e);
        alert('이미지 생성에 실패했습니다.');
      } finally {
        btn.disabled = false;
        btn.textContent = '이미지 다운로드';
      }
    });
  })();
</script>


</body>
</html>
<%
call dbClose()
%>
