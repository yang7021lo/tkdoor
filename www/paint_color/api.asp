<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

' ============================================================
' tk_paint 테이블 설정 (페인트 색상 관리)
' ============================================================
Dim CFG_TABLE, CFG_PK, CFG_PK_AUTO
CFG_TABLE = "tk_paint"
CFG_PK = "pidx"
CFG_PK_AUTO = True

' 컬럼 화이트리스트 (field -> 타입)
Dim CFG_COLS
Set CFG_COLS = Server.CreateObject("Scripting.Dictionary")
CFG_COLS.Add "pcode",          "str"
CFG_COLS.Add "pshorten",       "str"
CFG_COLS.Add "pname",          "str"
CFG_COLS.Add "pprice",         "float"
CFG_COLS.Add "pstatus",        "int"
CFG_COLS.Add "pname_brand",    "int"
CFG_COLS.Add "paint_type",     "int"
CFG_COLS.Add "p_percent",      "float"
CFG_COLS.Add "p_image",        "str"
CFG_COLS.Add "p_sample_image", "str"
CFG_COLS.Add "p_sample_name",  "str"
CFG_COLS.Add "coat",           "int"
CFG_COLS.Add "p_hex_color",    "str"

' SELECT 절 (조회용)
Dim CFG_SELECT
CFG_SELECT = "pidx, pcode, pshorten, pname, pprice, pstatus, " & _
             "pname_brand, " & _
             "ISNULL((SELECT pname_brand FROM tk_paint_brand WHERE pbidx = A.pname_brand), '') AS brand_name, " & _
             "paint_type, p_percent, " & _
             "p_image, p_sample_image, p_sample_name, " & _
             "coat, p_hex_color, pewdate, " & _
             "(SELECT mname FROM tk_member WHERE midx = A.pemidx) AS mename"

' FROM 절
Dim CFG_FROM
CFG_FROM = "tk_paint A"

' 기본 정렬
Dim CFG_ORDERBY
CFG_ORDERBY = "pidx DESC"

' 추가 WHERE (없으면 빈문자열)
Dim CFG_WHERE
CFG_WHERE = ""

' 추가 검색 대상 (제조사명 서브쿼리 포함) - {Q}가 검색어로 치환됨
Dim CFG_SEARCH_EXTRA
CFG_SEARCH_EXTRA = "(SELECT pname_brand FROM tk_paint_brand WHERE pbidx = A.pname_brand) LIKE N'%{Q}%'"

' JSON 출력 컬럼 순서
Dim CFG_OUTPUT_COLS
CFG_OUTPUT_COLS = Array("pidx","pcode","pshorten","pname","pprice","pstatus", _
                        "pname_brand","brand_name","paint_type","p_percent", _
                        "p_image","p_sample_image","p_sample_name", _
                        "coat","p_hex_color","pewdate","mename")

' INSERT 시 자동 채번 컬럼 (없음)
Dim CFG_AUTO_INCREMENT
CFG_AUTO_INCREMENT = ""

' 감사 컬럼
Dim CFG_AUDIT_CREATE, CFG_AUDIT_UPDATE
CFG_AUDIT_CREATE = "pmidx,pwdate"
CFG_AUDIT_UPDATE = "pemidx,pewdate"

' ============================================================
' 색상 그룹 필터 (p_hex_color → RGB 변환 후 분류)
' filter_color_group 파라미터로 전달됨
' ============================================================
Dim cgFilter
cgFilter = LCase(Trim(Request("filter_color_group") & ""))

If cgFilter <> "" Then
  If cgFilter = "nocolor" Then
    ' 대표색 미지정
    If CFG_WHERE = "" Then
      CFG_WHERE = "(A.p_hex_color IS NULL OR A.p_hex_color = '')"
    Else
      CFG_WHERE = CFG_WHERE & " AND (A.p_hex_color IS NULL OR A.p_hex_color = '')"
    End If
  Else
    ' CROSS APPLY: hex → RGB 변환 (NULL/빈값 안전)
    Dim rgbSQL
    rgbSQL = " CROSS APPLY (SELECT "
    rgbSQL = rgbSQL & "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 "
    rgbSQL = rgbSQL & "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,2,2),2)) ELSE -1 END AS cR,"
    rgbSQL = rgbSQL & "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 "
    rgbSQL = rgbSQL & "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,4,2),2)) ELSE -1 END AS cG,"
    rgbSQL = rgbSQL & "CASE WHEN ISNULL(LEN(A.p_hex_color),0)>=7 "
    rgbSQL = rgbSQL & "THEN CONVERT(INT,CONVERT(VARBINARY(1),SUBSTRING(A.p_hex_color,6,2),2)) ELSE -1 END AS cB"
    rgbSQL = rgbSQL & ") AS C"
    CFG_FROM = CFG_FROM & rgbSQL

    ' 색상 그룹별 WHERE 조건 (cR+cG+cB = sum, avg = sum/3)
    Dim cgWhere
    cgWhere = "C.cR>=0"

    Select Case cgFilter
      Case "black"
        ' 평균 < 45 (sum < 135) — 아주 어두운 모든 색
        cgWhere = cgWhere & " AND (C.cR+C.cG+C.cB)<135"
      Case "darkgray"
        ' 무채색(채널차<45) + 어두운 (avg 45~115)
        cgWhere = cgWhere & " AND ABS(C.cR-C.cG)<45 AND ABS(C.cG-C.cB)<45 AND ABS(C.cR-C.cB)<50 AND (C.cR+C.cG+C.cB)>=135 AND (C.cR+C.cG+C.cB)<345"
      Case "silver"
        ' 무채색 + 중간밝기 (avg 115~175)
        cgWhere = cgWhere & " AND ABS(C.cR-C.cG)<50 AND ABS(C.cG-C.cB)<50 AND ABS(C.cR-C.cB)<55 AND (C.cR+C.cG+C.cB)>=345 AND (C.cR+C.cG+C.cB)<525"
      Case "lightgray"
        ' 무채색 + 밝은 (avg >= 175)
        cgWhere = cgWhere & " AND ABS(C.cR-C.cG)<45 AND ABS(C.cG-C.cB)<45 AND ABS(C.cR-C.cB)<50 AND (C.cR+C.cG+C.cB)>=525"
      Case "ivory"
        ' 따뜻한 밝은톤: R높,G높,B약간낮, G>B (핑크 제외)
        cgWhere = cgWhere & " AND C.cR>190 AND C.cG>170 AND C.cB>130 AND (C.cG-C.cB)>5 AND (C.cR-C.cB)>15 AND (C.cR+C.cG+C.cB)>510"
      Case "brown"
        ' R>=G>=B, G는 R의 25~80%, 중간밝기
        cgWhere = cgWhere & " AND C.cR>=C.cG AND C.cG>=C.cB AND C.cG>(C.cR/4) AND C.cG<(C.cR*80/100) AND (C.cR-C.cB)>30 AND (C.cR+C.cG+C.cB)>=120 AND (C.cR+C.cG+C.cB)<480"
      Case "red"
        ' R 우세, G<R의 45%, B<R의 55% (노랑/주황 완전 차단)
        cgWhere = cgWhere & " AND C.cR>140 AND C.cR>=C.cG AND C.cR>=C.cB AND C.cG<(C.cR*45/100) AND C.cB<(C.cR*55/100)"
      Case "orange"
        ' R 높고, G=R의 30~70%, B<R의 30% (빨강/노랑과 분리)
        cgWhere = cgWhere & " AND C.cR>160 AND C.cG>(C.cR*30/100) AND C.cG<(C.cR*70/100) AND C.cB<(C.cR*30/100)"
      Case "yellow"
        ' R,G 모두 높고 비슷(G>R의 70%), B 낮음(G의 55% 미만)
        cgWhere = cgWhere & " AND C.cR>150 AND C.cG>140 AND C.cG>(C.cR*70/100) AND C.cB<(C.cG*55/100)"
      Case "green"
        ' G가 최대, R보다 확실히 높음
        cgWhere = cgWhere & " AND C.cG>=C.cR AND C.cG>=C.cB AND (C.cG-C.cR)>25"
      Case "blue"
        ' B가 최대, 밝은쪽 (sum>=200)
        cgWhere = cgWhere & " AND C.cB>C.cR AND C.cB>C.cG AND (C.cR+C.cG+C.cB)>=200 AND (C.cB-C.cR)>30"
      Case "navy"
        ' B가 최대, 어두운쪽 (sum<200)
        cgWhere = cgWhere & " AND C.cB>=C.cR AND C.cB>=C.cG AND (C.cR+C.cG+C.cB)<200 AND C.cB>30"
      Case "purple"
        ' R과 B 모두 G보다 확실히 높음 (빨강+파랑 혼합)
        cgWhere = cgWhere & " AND C.cR>(C.cG+15) AND C.cB>(C.cG+15) AND ABS(C.cR-C.cB)<120"
      Case Else
        cgWhere = ""
    End Select

    If cgWhere <> "" Then
      If CFG_WHERE = "" Then
        CFG_WHERE = cgWhere
      Else
        CFG_WHERE = CFG_WHERE & " AND (" & cgWhere & ")"
      End If
    End If
  End If
End If
%>
<!--#include virtual="/common_crud/crud_json.asp"-->
<!--#include virtual="/common_crud/crud_api.asp"-->
<%
call dbClose()
%>
