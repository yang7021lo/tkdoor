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
' tk_paint_brand 테이블 설정 (제조사 관리)
' ============================================================
Dim CFG_TABLE, CFG_PK, CFG_PK_AUTO
CFG_TABLE = "tk_paint_brand"
CFG_PK = "pbidx"
CFG_PK_AUTO = True

' 컬럼 화이트리스트
Dim CFG_COLS
Set CFG_COLS = Server.CreateObject("Scripting.Dictionary")
CFG_COLS.Add "pname_brand",  "str"

' SELECT 절
Dim CFG_SELECT
CFG_SELECT = "pbidx, pname_brand"

' FROM 절
Dim CFG_FROM
CFG_FROM = "tk_paint_brand"

' 기본 정렬
Dim CFG_ORDERBY
CFG_ORDERBY = "pbidx ASC"

' 추가 WHERE
Dim CFG_WHERE
CFG_WHERE = ""

' JSON 출력 컬럼 순서
Dim CFG_OUTPUT_COLS
CFG_OUTPUT_COLS = Array("pbidx","pname_brand")

' INSERT 시 자동 채번 컬럼
Dim CFG_AUTO_INCREMENT
CFG_AUTO_INCREMENT = ""

' 감사 컬럼 (없음)
Dim CFG_AUDIT_CREATE, CFG_AUDIT_UPDATE
CFG_AUDIT_CREATE = ""
CFG_AUDIT_UPDATE = ""
%>
<!--#include virtual="/common_crud/crud_json.asp"-->
<!--#include virtual="/common_crud/crud_api.asp"-->
<%
call dbClose()
%>
