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
' tk_qtyco 테이블 설정
' ============================================================
Dim CFG_TABLE, CFG_PK, CFG_PK_AUTO
CFG_TABLE = "tk_qtyco"
CFG_PK = "qtyco_idx"
CFG_PK_AUTO = True

' 컬럼 화이트리스트 (field → 타입)
Dim CFG_COLS
Set CFG_COLS = Server.CreateObject("Scripting.Dictionary")
CFG_COLS.Add "QTYNo",                "str"
CFG_COLS.Add "QTYNAME",              "str"
CFG_COLS.Add "QTYcoNAME",            "str"
CFG_COLS.Add "unittype_qtyco_idx",   "int"
CFG_COLS.Add "QTYcostatus",          "int"
CFG_COLS.Add "kg",                   "float"
CFG_COLS.Add "sheet_w",              "float"
CFG_COLS.Add "sheet_h",              "float"
CFG_COLS.Add "sheet_t",              "float"
CFG_COLS.Add "coil_cut",             "str"

' SELECT 절 (조회용)
Dim CFG_SELECT
CFG_SELECT = "qtyco_idx, QTYNo, QTYNAME, QTYcoNAME, " & _
             "unittype_qtyco_idx, QTYcostatus, kg, " & _
             "sheet_w, sheet_h, sheet_t, coil_cut, " & _
             "QTYcoewdate, " & _
             "(SELECT mname FROM tk_member WHERE midx = A.QTYcoemidx) AS mename"

' FROM 절
Dim CFG_FROM
CFG_FROM = "tk_qtyco A"

' 기본 정렬
Dim CFG_ORDERBY
CFG_ORDERBY = "qtyco_idx DESC"

' 추가 WHERE (없으면 빈문자열)
Dim CFG_WHERE
CFG_WHERE = ""

' JSON 출력 컬럼 순서
Dim CFG_OUTPUT_COLS
CFG_OUTPUT_COLS = Array("qtyco_idx","QTYNo","QTYNAME","QTYcoNAME", _
                        "unittype_qtyco_idx","QTYcostatus","kg", _
                        "sheet_w","sheet_h","sheet_t","coil_cut", _
                        "QTYcoewdate","mename")

' INSERT 시 자동 채번 컬럼 (비어있으면 MAX+1)
Dim CFG_AUTO_INCREMENT
CFG_AUTO_INCREMENT = "QTYNo"

' 감사 컬럼
Dim CFG_AUDIT_CREATE, CFG_AUDIT_UPDATE
CFG_AUDIT_CREATE = "QTYcomidx,QTYcowdate"
CFG_AUDIT_UPDATE = "QTYcoemidx,QTYcoewdate"
%>
<!--#include virtual="/common_crud/crud_json.asp"-->
<!--#include virtual="/common_crud/crud_api.asp"-->
<%
call dbClose()
%>
