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
' tk_paint_sample 테이블 설정 (샘플지급 이력)
' ============================================================
Dim CFG_TABLE, CFG_PK, CFG_PK_AUTO
CFG_TABLE = "tk_paint_sample"
CFG_PK = "psidx"
CFG_PK_AUTO = True

' 컬럼 화이트리스트 (field -> 타입)
Dim CFG_COLS
Set CFG_COLS = Server.CreateObject("Scripting.Dictionary")
CFG_COLS.Add "pidx",          "int"
CFG_COLS.Add "sample_type",   "int"
CFG_COLS.Add "sjidx",         "int"
CFG_COLS.Add "company_name",  "str"
CFG_COLS.Add "recipient",     "str"
CFG_COLS.Add "qty",           "int"
CFG_COLS.Add "sample_date",   "str"
CFG_COLS.Add "memo",          "str"

' SELECT 절 (서브쿼리로 페인트정보, 수주현장명, 수정자 조회)
Dim CFG_SELECT
CFG_SELECT = "A.psidx, A.pidx, " & _
             "ISNULL((SELECT pname FROM tk_paint WHERE pidx = A.pidx), '') AS paint_name, " & _
             "ISNULL((SELECT pcode FROM tk_paint WHERE pidx = A.pidx), '') AS paint_code, " & _
             "ISNULL((SELECT p_hex_color FROM tk_paint WHERE pidx = A.pidx), '') AS paint_hex, " & _
             "A.sample_type, A.sjidx, " & _
             "ISNULL((SELECT CONVERT(VARCHAR(10),sjdate,121) + '_' + sjnum FROM tng_sja WHERE sjidx = A.sjidx), '') AS sj_sjnum, " & _
             "ISNULL((SELECT cgaddr FROM tng_sja WHERE sjidx = A.sjidx), '') AS sj_cgaddr, " & _
             "ISNULL((SELECT c.cname FROM tng_sja s JOIN tk_customer c ON c.cidx = s.sjcidx WHERE s.sjidx = A.sjidx), '') AS sj_cname, " & _
             "A.company_name, A.recipient, A.qty, " & _
             "CONVERT(VARCHAR(10), A.sample_date, 23) AS sample_date, " & _
             "A.memo, A.psewdate, " & _
             "(SELECT mname FROM tk_member WHERE midx = A.psemidx) AS mename"

' FROM 절
Dim CFG_FROM
CFG_FROM = "tk_paint_sample A"

' 기본 정렬
Dim CFG_ORDERBY
CFG_ORDERBY = "psidx DESC"

' 추가 WHERE
Dim CFG_WHERE
CFG_WHERE = ""

' 추가 검색 대상 (페인트명, 코드, 수주명 포함)
Dim CFG_SEARCH_EXTRA
CFG_SEARCH_EXTRA = "(SELECT pname FROM tk_paint WHERE pidx = A.pidx) LIKE N'%{Q}%'" & _
                   "|(SELECT pcode FROM tk_paint WHERE pidx = A.pidx) LIKE N'%{Q}%'" & _
                   "|(SELECT cgaddr FROM tng_sja WHERE sjidx = A.sjidx) LIKE N'%{Q}%'" & _
                   "|(SELECT c.cname FROM tng_sja s JOIN tk_customer c ON c.cidx = s.sjcidx WHERE s.sjidx = A.sjidx) LIKE N'%{Q}%'"

' JSON 출력 컬럼 순서
Dim CFG_OUTPUT_COLS
CFG_OUTPUT_COLS = Array("psidx","pidx","paint_name","paint_code","paint_hex", _
                        "sample_type","sjidx","sj_sjnum","sj_cgaddr","sj_cname", _
                        "company_name","recipient","qty","sample_date", _
                        "memo","psewdate","mename")

' 자동 채번 없음
Dim CFG_AUTO_INCREMENT
CFG_AUTO_INCREMENT = ""

' 감사 컬럼
Dim CFG_AUDIT_CREATE, CFG_AUDIT_UPDATE
CFG_AUDIT_CREATE = "psmidx,pswdate"
CFG_AUDIT_UPDATE = "psemidx,psewdate"

' ============================================================
' 구분 필터 (sample_type)
' ============================================================
Dim stFilter
stFilter = Trim(Request("filter_sample_type") & "")
If stFilter <> "" And IsNumeric(stFilter) Then
  If CFG_WHERE = "" Then
    CFG_WHERE = "A.sample_type = " & CLng(stFilter)
  Else
    CFG_WHERE = CFG_WHERE & " AND A.sample_type = " & CLng(stFilter)
  End If
End If

%>
<!--#include virtual="/common_crud/crud_json.asp"-->
<!--#include virtual="/common_crud/crud_api.asp"-->
<%
call dbClose()
%>
