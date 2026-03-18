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
</head>
<body>

<!--#include virtual="/TNG1/TNG1_B_suju5.asp"-->


<!--#include virtual="/TNG1/TNG1_B_suju4 copy.asp"-->


<!-- 도면 수치 표현 모듈 (data-value/data-type 사용) -->
<script src="/schema/total.js"></script>
<script src="/schema/horizontal.js"></script>
<script src="/schema/vertical.js"></script>
<script src="/schema/intergrate.js"></script>





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
<%
call dbClose()
%>
