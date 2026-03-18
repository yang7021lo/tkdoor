<%@ Language="VBScript" CodePage="65001" %>
<!--#include virtual="/inc/dbcon.asp"-->
<%
' ======================================================================
'  이 파일은 SVG만 반환하는 ASP 엔드포인트입니다.
'  - 응답 헤더를 SVG로 고정하고
'  - DB에서 절곡 구간(tk_barasisub)을 불러와
'  - 각 구간을 <line>으로 그리고, 필요하면 길이 라벨 <text>도 함께 출력합니다.
'  - viewBox를 데이터의 경계로 자동 산정하여, 컨테이너 DIV에 맞춰 스케일됩니다.
' ======================================================================

' ---------- 응답 형식/인코딩 고정 ----------
Response.Buffer = True                 ' 버퍼 켜서 include나 오류로 찍힌 HTML이 즉시 나가지 않도록 함
Response.Expires = -1                  ' 캐시 방지
Response.Charset = "utf-8"             ' UTF-8
Response.ContentType = "image/svg+xml" ' SVG MIME
On Error Resume Next                   ' 이후 오류는 수동 처리(아래 SvgErrorAndEnd 사용)

' ---------- 쿼리 파라미터 수집 ----------
baidx  = Request("baidx")              ' 필수: 대상 절곡의 baidx
stroke = Request("stroke") : If stroke = "" Then stroke = "#000"  ' 선 색상 (기본 검정)
sw     = Request("sw")     : If sw = "" Then sw = "1"             ' 선 두께 (픽셀)
fs     = Request("fs")     : If fs = "" Then fs = "8"             ' 폰트 크기 (픽셀)
labels = Request("labels") : If labels = "" Then labels = "1"     ' 1: 라벨 표시, 0: 미표시
bg     = Request("bg")                                                 ' 1: 흰 배경 rect 그림
fit    = LCase(Trim(Request("fit"))) : If fit = "" Then fit = "contain"
' fit은 컨테이너(DIV) 대비 SVG 배치 방식입니다:
' - contain(meet): 전체가 보이도록 내부 맞춤
' - cover(slice) : 빈 공간 없이 꽉 채우되 일부 잘릴 수 있음
' - stretch(none): 종횡비 무시하고 컨테이너 가득 늘림

' ---------- fit → preserveAspectRatio 값 매핑 ----------
Select Case fit
  Case "cover"   : par = "xMidYMid slice" ' 종횡비 유지, 잘려도 중앙 정렬
  Case "stretch" : par = "none"           ' 종횡비 무시, 뷰박스를 컨테이너에 꽉 채움
  Case Else      : par = "xMidYMid meet"  ' 기본: 종횡비 유지, 전체가 보이도록 중앙 정렬
End Select

' ---------- 공통 에러 응답 도우미 ----------
Sub SvgErrorAndEnd(msg)
  ' (중요) 어떤 오류여도 SVG 문서로 응답해야
  '        <font> 같은 HTML이 섞여 XML 파서 에러가 나지 않습니다.
  Response.Clear
  Response.ContentType = "image/svg+xml"
  Response.Write "<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%' viewBox='0 0 800 200'>"
  Response.Write "<rect x='0' y='0' width='800' height='200' fill='#fff'/>"
  Response.Write "<text x='20' y='60' font-family='monospace' font-size='16' fill='#d00'>SVG ERROR</text>"
  Response.Write "<text x='20' y='100' font-family='monospace' font-size='14' fill='#000'>" & Server.HTMLEncode(msg) & "</text>"
  Response.Write "</svg>"
  Response.End
End Sub

' ---------- 필수 파라미터 체크 ----------
If baidx = "" Then SvgErrorAndEnd("Missing baidx")

' ---------- DB 연결 ----------
' /inc/dbcon.asp 안의 dbOpen()이 연결을 여는 것으로 가정합니다.
call dbOpen()
If Err.Number <> 0 Then SvgErrorAndEnd("DB open failed: " & Err.Description)

' (중요) include나 dbOpen 내부에서 출력된 내용(디버그 HTML 등)을 제거
Response.Clear
Response.ContentType = "image/svg+xml"

' ---------- 데이터 조회 ----------
' 각 구간의 시작/끝 좌표, 입력 치수, 방향을 조회합니다.
sql = "SELECT x1,y1,x2,y2,bassize,basdirection FROM tk_barasisub WHERE baidx='" & baidx & "' ORDER BY basidx ASC"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, Dbcon
If Err.Number <> 0 Then SvgErrorAndEnd("SQL error: " & Err.Description)

' 대상 데이터가 없으면 빈 SVG 반환
If rs.EOF Then
  Response.Write "<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%' viewBox='0 0 100 100'/>"
  rs.Close : Set rs = Nothing : call dbClose() : Response.End
End If

' ---------- 경계 계산 및 메모리 적재 ----------
' - 전체 도형의 min/max x,y를 구해 viewBox로 사용
' - 한 번 루프에서 배열에 누적해두고, 다음 단계에서 SVG를 그립니다.
minX = 1E+20 : minY = 1E+20
maxX =-1E+20 : maxY =-1E+20
n = -1

Do Until rs.EOF
  ' Null 안전 처리 + 숫자 변환
  x1 = 0 : If Not IsNull(rs("x1")) Then x1 = CDbl(rs("x1"))
  y1 = 0 : If Not IsNull(rs("y1")) Then y1 = CDbl(rs("y1"))
  x2 = 0 : If Not IsNull(rs("x2")) Then x2 = CDbl(rs("x2"))
  y2 = 0 : If Not IsNull(rs("y2")) Then y2 = CDbl(rs("y2"))
  sizev = 0 : If Not IsNull(rs("bassize")) Then sizev = CDbl(rs("bassize"))
  dir   = 0 : If Not IsNull(rs("basdirection")) And rs("basdirection")<>"" Then dir = CLng(rs("basdirection"))

  ' 입력 치수(bassize)가 0이면 실제 선 길이로 보정
  If sizev = 0 Then
    If x1 = x2 Then sizev = Abs(y2 - y1) Else sizev = Abs(x2 - x1)
  End If

  ' 방향값이 없으면 좌표 변화로 추론 (→1, ↓2, ←3, ↑4)
  If dir = 0 Then
    If (x2 > x1 And y2 = y1) Then
      dir = 1
    ElseIf (y2 > y1 And x2 = x1) Then
      dir = 2
    ElseIf (x2 < x1 And y2 = y1) Then
      dir = 3
    ElseIf (y2 < y1 And x2 = x1) Then
      dir = 4
    Else
      dir = 1 ' 둘 다 바뀌는 등 비정형이면 기본값 → 로 처리
    End If
  End If

  ' 전체 경계 갱신 (시작/끝 좌표 모두 반영)
  If x1 < minX Then minX = x1
  If x2 < minX Then minX = x2
  If y1 < minY Then minY = y1
  If y2 < minY Then minY = y2
  If x1 > maxX Then maxX = x1
  If x2 > maxX Then maxX = x2
  If y1 > maxY Then maxY = y1
  If y2 > maxY Then maxY = y2

  ' 레코드 적재 (가변 배열 확장)
  n = n + 1
  If n = 0 Then
    ReDim aX1(0), aY1(0), aX2(0), aY2(0), aSZ(0), aDIR(0)
  Else
    ReDim Preserve aX1(n), aY1(n), aX2(n), aY2(n), aSZ(n), aDIR(n)
  End If
  aX1(n)=x1 : aY1(n)=y1 : aX2(n)=x2 : aY2(n)=y2 : aSZ(n)=sizev : aDIR(n)=dir

  rs.MoveNext
Loop
rs.Close : Set rs = Nothing
call dbClose()

' ---------- viewBox 산정 ----------
' pad 만큼 여백을 둔 경계 박스를 viewBox로 설정합니다.
pad = 10
vbX = minX - pad : vbY = minY - pad
vbW = (maxX - minX) + pad*2
vbH = (maxY - minY) + pad*2
If vbW <= 0 Then vbW = 100 ' 방어코드: 점/수평선 한 점만 있는 경우
If vbH <= 0 Then vbH = 100

' ---------- SVG 문서 시작 ----------
Response.Write "<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%' viewBox='" & vbX & " " & vbY & " " & vbW & " " & vbH & "' preserveAspectRatio='" & par & "'>"

' 배경 (요청 시)
If bg = "1" Then
  Response.Write "<rect x='" & vbX & "' y='" & vbY & "' width='" & vbW & "' height='" & vbH & "' fill='#ffffff'/>"
End If

' 스타일:
'  - .seg: 선 색/두께/채우기 없음
'  - .t  : 라벨 텍스트 스타일
'  (※ 선/텍스트 두께를 화면 픽셀로 고정하려면 .seg에 vector-effect:non-scaling-stroke 추가 고려)
Response.Write "<style>.seg{stroke:" & stroke & ";stroke-width:" & sw & ";fill:none}.t{fill:#000;font-size:" & fs & "px;font-family:sans-serif;opacity:.9}</style>"

' ---------- 도형 그리기 루프 ----------
For i = 0 To n
  x1=aX1(i): y1=aY1(i): x2=aX2(i): y2=aY2(i): sizev=aSZ(i): dir=aDIR(i)

  ' 구간 선 하나 그리기
  Response.Write "<line class='seg' x1='" & x1 & "' y1='" & y1 & "' x2='" & x2 & "' y2='" & y2 & "'/>"

  ' 길이 라벨(옵션)
  If labels <> "0" Then
    ' 라벨 위치: 구간 중앙을 기준으로 방향에 따라 오프셋
    ' tweak은 긴 수직/수평 선에서 시각적 여백을 주기 위한 미세 조정
    tweak = 0 : If sizev > 30 Then tweak = - 30

    Select Case dir
      Case 1 ' → : 선 위 중앙에 배치
        tx = x1 + (Abs(x2 - x1)/2) : ty = y1 - 1
      Case 2 ' ↓ : 선 오른쪽 중앙에 배치
        tx = x1 - 5 : ty = y1 + (Abs(y2 - y1)/2) + tweak + 10
      Case 3 ' ← : 선 아래 중앙에 배치
        tx = x1 - (Abs(x2 - x1)/2) : ty = y1 + 5
      Case 4 ' ↑ : 선 왼쪽 중앙에 배치
        tx = x1 + 5 : ty = y1 - (Abs(y2 - y1)/2) + tweak + 10
      Case Else ' 비정형: 선 중앙
        tx = (x1 + x2)/2 : ty = (y1 + y2)/2
    End Select

    ' 숫자 포맷: 정수면 소수점 없이, 아니면 소수1자리
    If sizev = Int(sizev) Then
      labelText = CStr(Int(sizev))
    Else
      labelText = Replace(FormatNumber(sizev, 1), ",", "")
    End If

    Response.Write "<text class='t' x='" & tx & "' y='" & ty & "' text-anchor='middle'>" & labelText & "</text>"
  End If
Next

' ---------- SVG 문서 끝 ----------
Response.Write "</svg>"
%>