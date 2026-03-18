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
<title>도어 유리 사이즈 - 태광도어</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/documents/dgsOrder/assets/css/index.css" rel="stylesheet">
</head>
<body>
<div id="export" style="height: 100vh;">
<!--#include virtual="/documents/dgsOrder/module/schema/index.asp"-->


<!--#include virtual="/documents/dgsOrder/module/dgs/index.asp"-->
</div>


<!-- 도면 수치 표현 모듈 (data-value/data-type 사용) -->



  <style>
  .no-capture { display:none !important; }
</style>
<div class="print-fab">
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#downloadModal">다운로드</button>
  <button type="button" class="btn btn-outline-secondary" onclick="window.close()">닫기</button>
</div>

<!-- 내보내기 모달 -->
<div class="modal fade" id="downloadModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">내보내기</h5>
      </div>
      <div class="modal-body">
        <div class="small text-muted mb-3">
          A4용지 전용 CSS(폭·높이 mm, 여백 0) 기준으로 그대로 내보냅니다.
        </div>

        <!-- 여러 페이지일 때 이미지 복사용 페이지 선택 -->
        <div id="pagePickerWrap" class="mb-3 d-none">
          <label class="form-label">대상 페이지(이미지 복사 전용)</label>
          <select id="pagePicker" class="form-select"></select>
        </div>

        <div class="d-grid gap-2">
          <button id="btnCopyImage" class="btn btn-outline-secondary">이미지 복사</button>
          <button id="btnDownloadImages" class="btn btn-outline-dark">이미지 다운로드</button>
        </div>
      </div>
    </div>
  </div>
</div>


<!-- Bootstrap JS (이미 없다면 추가) -->
<!-- 캡처/내보내기 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js"></script>
<script src="/documents/dgsOrder/assets/js/export.js"></script>



</body>
</html>
<%
call dbClose()
%>
