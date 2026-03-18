<%@ Language="VBScript" CodePage="65001" %>
<%
Option Explicit
Response.Charset = "utf-8"

Dim sjidx : sjidx = Request("sjidx")

' ----------------------------
' 유틸
' ----------------------------
Function ToBool(v)
  Dim s : s = LCase(Trim(CStr(v)))
  ToBool = (s = "1" Or s = "true" Or s = "on" Or s = "yes")
End Function

' UTF-8 파일을 안전하게 읽어 Response로 쓰기
Sub WriteFileUtf8(virtPath)
  On Error Resume Next
  Dim stm, phys
  phys = Server.MapPath(virtPath)
  Set stm = Server.CreateObject("ADODB.Stream")
  stm.Type = 2 ' text
  stm.Charset = "utf-8"
  stm.Open
  stm.LoadFromFile phys
  Response.Write stm.ReadText
  stm.Close
  Set stm = Nothing
  If Err.Number <> 0 Then
    Response.Write "<div class=""alert alert-danger"">HTML 포함 실패: " & Server.HTMLEncode(virtPath) & "</div>"
    Err.Clear
  End If
  On Error GoTo 0
End Sub

' 확장자에 따라 처리: .asp/.asa → Server.Execute, 그 외(.html 등) → 파일 읽기 출력
Sub SafeInclude(virtPath)
  On Error Resume Next
  Dim fso, phys, ext
  Set fso = Server.CreateObject("Scripting.FileSystemObject")
  phys = Server.MapPath(virtPath)
  If Not fso.FileExists(phys) Then
    Response.Write "<div class=""alert alert-warning"">섹션 파일이 없습니다: " & Server.HTMLEncode(virtPath) & "</div>"
    Set fso = Nothing
    Exit Sub
  End If
  ext = LCase(fso.GetExtensionName(phys))
  Set fso = Nothing

  If (ext = "asp") Or (ext = "asa") Then
    Call Server.Execute(virtPath)
    If Err.Number <> 0 Then
      Response.Write "<div class=""alert alert-danger"">ASP 섹션 실행 오류: " & Server.HTMLEncode(virtPath) & "</div>"
      Err.Clear
    End If
  Else
    Call WriteFileUtf8(virtPath)
  End If
  On Error GoTo 0
End Sub

%>
<%
' ----------------------------
' 폼 값 수신
' ----------------------------
Dim fFrame, fDoor, fDrawing, fPerProduct
fFrame      = ToBool(Request.Form("frame"))
fDoor       = ToBool(Request.Form("door"))
fDrawing    = ToBool(Request.Form("drawing"))
fPerProduct = ToBool(Request.Form("perProduct"))

' 숨은 입력용 문자열 값 (IIf 금지 → If..Then..Else)
Dim frameVal, doorVal, drawingVal, perProdVal
If fFrame Then frameVal = "1" Else frameVal = "0"
If fDoor Then doorVal = "1" Else doorVal = "0"
If fDrawing Then drawingVal = "1" Else drawingVal = "0"
If fPerProduct Then perProdVal = "1" Else perProdVal = "0"
%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>간이견적서</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="/documents/outsideOrder/assets/css/index.css" rel="stylesheet">
  <style>
    .card-header{ background:#f7f7f9; }
  </style>
</head>
<body class="p-4">
  <div class="print-sheet">

    <% Call SafeInclude("/documents/outsideOrder/template/synthesize/index.html") %>

    <% If fFrame Then %>
    <div class="a4-line"></div>
    <% Call SafeInclude("/documents/outsideOrder/template/frames/index.html") %>
    <% End If %>

    <% If fDoor Then %>
    <div class="a4-line"></div>
    <% Call SafeInclude("/documents/outsideOrder/template/doors/index.html") %>
    <% End If %>

    <% If fPerProduct Then %>
    <% Call "/documents/outsideOrder/template/products/index.html" %>
    <% End If %>

  </div>

  <style>
  .no-capture { display:none !important; }
</style>


<div class="print-fab">
  <button type="button" class="btn btn-dark" onclick="window.print()">유지보수 종료</button>
  <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#downloadModal">다운로드</button>
  <button type="button" class="btn btn-outline-secondary" onclick="window.close()">닫기</button>
</div>

<!-- 내보내기 모달 -->
<div class="modal fade" id="downloadModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">내보내기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
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


<script src="/documents/outsideOrder/assets/js/synthesize.js"></script>
  <script src="/documents/outsideOrder/assets/js/products.js"></script>
    <script src="/documents/outsideOrder/assets/js/doors.js"></script>
      <script src="/documents/outsideOrder/assets/js/frames.js"></script>

      <!-- Bootstrap 5 JS (모달용) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- 캡처/내보내기 라이브러리 -->
<script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js"></script>
<script src="/documents/outsideOrder/assets/js/export.js"></script>




</body>
</html>
