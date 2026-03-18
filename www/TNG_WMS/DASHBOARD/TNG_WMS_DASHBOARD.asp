<%@ codepage="65001" language="vbscript" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<%
' =========================================================
' 타임아웃 / 버퍼 / 실행 안정성 풀 세팅
' =========================================================
Server.ScriptTimeout = 30       
Response.Buffer = True
Response.Expires = -1
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
On Error Resume Next



%>

<!-- DB / 쿠키 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()

Function Clean(v)
    If IsNull(v) Then Clean = "" : Exit Function
    v = Trim(v)
    ' 비교용으로만 사용하므로 특수문자 제거만
    v = Replace(v, "-", "")
    v = Replace(v, "_", "")
    v = Replace(v, ".", "")
    Clean = v
End Function

' ================================
' 박스세트 / 박스커버 AND 픽스하바/ 픽스상바/ 오사이 병합 규칙
' ================================
Function NormalizeName(name)
    If InStr(name, "박스세트") > 0 Then
        NormalizeName = "박스세트"
    ElseIf InStr(name, "박스커버") > 0 Then
        NormalizeName = "박스커버"
    ElseIf InStr(name, "픽스하바") > 0 Then
        NormalizeName = "픽스하바"
    ElseIf InStr(name, "픽스상바") > 0 Then
        NormalizeName = "픽스상바"
    ElseIf InStr(name, "오사이") > 0 Then
        NormalizeName = "오사이"
    Else
        NormalizeName = name
    End If
End Function

' ================================
' 픽스하바/ 픽스상바/ 오사이 개수 묶기
' ================================

Function MyMin(a,b)
    If a < b Then MyMin = a Else MyMin = b
End Function



' =========================================================
' 기존 동작 유지:
'   - 앞의 "숫자 X 숫자(_)" 형태는 제거
' 개선:
'   - 두번째 숫자에 90/180이 붙어있어도(예: 120180도) 180도/90도부터 남김
' =========================================================
Function CleanNameOnly(bn)
    Dim s, rest, p180, p90, pos
    s = Trim("" & bn)
    If s = "" Then CleanNameOnly = "" : Exit Function

    ' 유니코드 곱셈기호 대비
    s = Replace(s, "×", "X")

    ' 1) "첫번째 숫자 X"까지만 제거 (두번째 숫자+각도까지 한 번에 먹지 않게)
    Dim reHead
    Set reHead = New RegExp
    reHead.Pattern = "^\s*\d+\s*[xX]\s*"
    reHead.IgnoreCase = True
    reHead.Global = False

    rest = s
    If reHead.Test(rest) Then rest = Trim(reHead.Replace(rest, ""))  ' 예: "120_180도 코너바" / "120180도 코너바"

    ' 2) 남은 문자열에서 180도/90도 있으면 그 지점부터 반환 (원하신 “90/180만 남김”)
    p180 = InStr(rest, "180도")
    p90  = InStr(rest, "90도")

    If p180 > 0 Or p90 > 0 Then
        If p180 > 0 And p90 > 0 Then
            pos = p180 : If p90 < pos Then pos = p90
        ElseIf p180 > 0 Then
            pos = p180
        Else
            pos = p90
        End If

        CleanNameOnly = Trim(Mid(rest, pos))
        Exit Function
    End If

    ' 3) (기존처럼) 두번째 숫자(치수)도 제거하고 나머지 반환
    Dim reDim2
    Set reDim2 = New RegExp
    reDim2.Pattern = "^\s*\d+\s*_?\s*"
    reDim2.IgnoreCase = True
    reDim2.Global = False

    If reDim2.Test(rest) Then rest = Trim(reDim2.Replace(rest, ""))

    CleanNameOnly = rest
End Function


Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Set RsC = Server.CreateObject("ADODB.Recordset")

rsjcidx = Request("sjcidx")
rsjmidx = Request("sjmidx")
wms_type = Trim(Request("wms_type"))
Dim debugBaname
debugBaname = False

Function BuildPayloadFromFinalList(ByRef finalList, ByVal finalCnt)
  Dim i, nm, bl, qt, s
  s = ""
  For i = 0 To finalCnt - 1
    nm = CleanNameOnly(finalList(i)(3))
    bl = CLng(finalList(i)(0))
    qt = CLng(finalList(i)(1))
    s = s & Replace(nm,"|","") & "^" & bl & "^" & qt & "|"
  Next
  If Len(s) > 0 Then s = Left(s, Len(s)-1)
  BuildPayloadFromFinalList = s
End Function

Function HtmlEnc(ByVal s)
    s = "" & s
    s = Replace(s, "&", "&amp;")
    s = Replace(s, "<", "&lt;")
    s = Replace(s, ">", "&gt;")
    HtmlEnc = s
End Function

' ============================================================
' 0. 날짜 처리
' ============================================================
ymd = Trim(Request("ymd"))

If ymd = "" Then
    ymd = Replace(Date(), "-", "")
End If
ymd = Replace(ymd, "-", "")

ymd_html = Left(ymd,4) & "-" & Mid(ymd,5,2) & "-" & Mid(ymd,7,2)

' ============================================================
' 0-1. 출력 버퍼 (일반 / 특이배송)
' ============================================================
Dim normalHTML, specialHTML
normalHTML  = ""
specialHTML = ""

Dim prev_wms_type_normal, prev_wms_type_special
prev_wms_type_normal  = ""
prev_wms_type_special = ""

' ============================================================
' 0-2. 공통 함수 (정렬용)
' ============================================================
Function SortByLength(x, y)
    ' x(0), y(0) = blength
    If x(0) < y(0) Then
        SortByLength = -1
    ElseIf x(0) > y(0) Then
        SortByLength = 1
    Else
        SortByLength = 0
    End If
End Function

Function SortFks(x, y)
    ' x(0)=fkidx, x(3)=blength
    If x(0) < y(0) Then
        SortFks = -1
    ElseIf x(0) > y(0) Then
        SortFks = 1
    Else
        If x(3) < y(3) Then
            SortFks = -1
        ElseIf x(3) > y(3) Then
            SortFks = 1
        Else
            SortFks = 0
        End If
    End If
End Function


  Function GetWmsTypeName(ByVal t)
  Dim nm : nm = "-"
  If IsNumeric(t) Then
    Select Case CLng(t)
      Case 1:  nm = "화물"
      Case 2:  nm = "낮1배달_신두영(인천,고양)"
      Case 3:  nm = "낮2배달_최민성(경기)"
      Case 4:  nm = "밤1배달_윤성호(수원,천안,능력)"
      Case 5:  nm = "밤2배달_김정호(하남)"
      Case 6:  nm = "대구창고"
      Case 7:  nm = "대전창고"
      Case 8:  nm = "부산창고"
      Case 9:  nm = "양산창고"
      Case 10: nm = "익산창고"
      Case 11: nm = "원주창고"
      Case 12: nm = "제주창고"
      Case 13: nm = "용차"
      Case 14: nm = "방문"
      Case 15: nm = "1공장"
      Case 16: nm = "인천항"
      Case 17: nm = "제주화물"
      Case 18: nm = "제주택배"
      Case 19: nm = "택배"
      Case Else: nm = "-"
    End Select
  End If
  GetWmsTypeName = nm
End Function

' ============================================================
' 0-3. sjsidx 기반 정보 캐시 (tng_sjaSub + qty + paint)
' ============================================================
Dim dictSjs, dictDj, dictDetail, dictFks
Set dictSjs    = Server.CreateObject("Scripting.Dictionary")
Set dictDj     = Server.CreateObject("Scripting.Dictionary")
Set dictDetail = Server.CreateObject("Scripting.Dictionary")
Set dictFks    = Server.CreateObject("Scripting.Dictionary")

Dim SQL_PREF1, RsPref1, ps_sjsidx, ps_framename, ps_qtyname, ps_pname
Dim ps_tmp, ps_bigo, ps_mwidth, ps_mheight, ps_qtyidx

SQL_PREF1 = ""
SQL_PREF1 = SQL_PREF1 & "SELECT A.sjsidx, A.sjidx, A.framename, "
SQL_PREF1 = SQL_PREF1 & "       G.qtyname, P.pname, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_wichi1, A.asub_wichi2, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_bigo1, A.asub_bigo2, A.asub_bigo3, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_meno1, A.asub_meno2, "
SQL_PREF1 = SQL_PREF1 & "       A.mwidth, A.mheight, A.qtyidx "
SQL_PREF1 = SQL_PREF1 & "FROM tng_sjaSub A "
SQL_PREF1 = SQL_PREF1 & "JOIN tk_wms_meta M ON A.sjidx = M.sjidx "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_qty C ON A.qtyidx = C.qtyidx "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_qtyco G ON C.qtyno = G.qtyno "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_paint P ON A.pidx = P.pidx "
SQL_PREF1 = SQL_PREF1 & "WHERE M.actual_ship_dt = '" & ymd & "' "
SQL_PREF1 = SQL_PREF1 & "  AND A.astatus = '1' "

Set RsPref1 = Dbcon.Execute(SQL_PREF1)

Do Until RsPref1.EOF
    ps_sjsidx    = "" & RsPref1("sjsidx")
    ps_framename = "" & RsPref1("framename")
    ps_qtyname   = "" & RsPref1("qtyname")
    ps_pname     = "" & RsPref1("pname")

    ps_tmp = Trim("" & RsPref1("asub_wichi1") & " " & RsPref1("asub_wichi2") & " " & _
                        RsPref1("asub_bigo1") & " " & RsPref1("asub_bigo2") & " " & _
                        RsPref1("asub_bigo3") & " " & RsPref1("asub_meno1") & " " & RsPref1("asub_meno2"))
    ps_bigo = Replace(ps_tmp, "  ", " ")

    ps_mwidth  = RsPref1("mwidth")
    ps_mheight = RsPref1("mheight")
    ps_qtyidx  = RsPref1("qtyidx")

    If Not dictSjs.Exists(ps_sjsidx) Then
        dictSjs.Add ps_sjsidx, Array(ps_framename, ps_qtyname, ps_pname, ps_bigo, ps_mwidth, ps_mheight, ps_qtyidx)
    End If

    RsPref1.MoveNext
Loop
RsPref1.Close : Set RsPref1 = Nothing

' ============================================================
' 0-4. 도장번호 djnum 캐시 (sjsidx 기준)
' ============================================================
Dim SQL_PREF2, RsPref2, pd_sjsidx, pd_djnum

SQL_PREF2 = ""
SQL_PREF2 = SQL_PREF2 & "SELECT D.sjsidx, D.djnum "
SQL_PREF2 = SQL_PREF2 & "FROM tk_wms_djnum D "
SQL_PREF2 = SQL_PREF2 & "JOIN tk_wms_meta M ON D.sjidx = M.sjidx "
SQL_PREF2 = SQL_PREF2 & "LEFT JOIN tng_sjasub B ON D.sjsidx = B.sjsidx "
SQL_PREF2 = SQL_PREF2 & "LEFT JOIN tk_paint C ON B.pidx = C.pidx "
SQL_PREF2 = SQL_PREF2 & "WHERE M.actual_ship_dt = '" & ymd & "' "
SQL_PREF2 = SQL_PREF2 & "AND (B.qtyidx <> 5 OR (C.pidx IS NULL OR C.pidx = 0)) "
SQL_PREF2 = SQL_PREF2 & "ORDER BY D.sjsidx, D.djnum"

Set RsPref2 = Dbcon.Execute(SQL_PREF2)

Do Until RsPref2.EOF
    pd_sjsidx = "" & RsPref2("sjsidx")
    pd_djnum  = "" & RsPref2("djnum")

    If Not dictDj.Exists(pd_sjsidx) Then
        dictDj.Add pd_sjsidx, pd_djnum
    End If

    RsPref2.MoveNext
Loop
RsPref2.Close : Set RsPref2 = Nothing

' ============================================================
' 0-5. detail(길이×수량) 캐시 : key = wms_idx & "_" & sjsidx
' ============================================================
Dim SQL_DETAIL, RsDet, keyD

SQL_DETAIL = ""
SQL_DETAIL = SQL_DETAIL & "SELECT D.wms_idx, D.sjsidx, D.blength, D.quan, D.bfgroup, D.baname "
SQL_DETAIL = SQL_DETAIL & "FROM tk_wms_detail D "
SQL_DETAIL = SQL_DETAIL & "JOIN tk_wms_meta M ON D.wms_idx = M.wms_idx "
SQL_DETAIL = SQL_DETAIL & "WHERE M.actual_ship_dt = '" & ymd & "' "

Set RsDet = Dbcon.Execute(SQL_DETAIL)

Do Until RsDet.EOF
    keyD = CStr(RsDet("wms_idx")) & "_" & CStr(RsDet("sjsidx"))

    If Not dictDetail.Exists(keyD) Then
        Set dictDetail(keyD) = CreateObject("System.Collections.ArrayList")
    End If

    dictDetail(keyD).Add Array( _
        CLng(0 & RsDet("blength")), _
        CLng(0 & RsDet("quan")), _
        CStr("" & RsDet("bfgroup")), _
        CStr("" & RsDet("baname")) _
    )

    RsDet.MoveNext
Loop
RsDet.Close : Set RsDet = Nothing

' blength 기준 정렬
Dim kD, arrTemp, arrSorted, it
For Each kD In dictDetail.Keys
    Set arrTemp = dictDetail(kD)
    Set arrSorted = CreateObject("System.Collections.ArrayList")

    For Each it In arrTemp
        arrSorted.Add it
    Next

    arrSorted.Sort GetRef("SortByLength")
    Set dictDetail(kD) = arrSorted
Next

' ============================================================
' 0-6. FRAMEK 캐시 : key = sjsidx
' ============================================================
Dim SQL_FKS, RsF, keyF

SQL_FKS = ""
SQL_FKS = SQL_FKS & "SELECT S.sjsidx, FS.fkidx, FS.whichi_auto, FS.whichi_fix, FS.blength "
SQL_FKS = SQL_FKS & "FROM tk_framekSub FS "
SQL_FKS = SQL_FKS & "JOIN tk_framek S ON FS.fkidx = S.fkidx "
SQL_FKS = SQL_FKS & "JOIN tk_wms_meta M ON S.sjidx = M.sjidx "
SQL_FKS = SQL_FKS & "WHERE M.actual_ship_dt = '" & ymd & "' AND FS.gls = 0 "

Set RsF = Dbcon.Execute(SQL_FKS)

Do Until RsF.EOF
    keyF = CStr(RsF("sjsidx"))

    If Not dictFks.Exists(keyF) Then
        Set dictFks(keyF) = CreateObject("System.Collections.ArrayList")
    End If

    dictFks(keyF).Add Array( _
        CLng(0 & RsF("fkidx")), _
        CLng(0 & RsF("whichi_auto")), _
        CLng(0 & RsF("whichi_fix")), _
        CLng(0 & RsF("blength")) _
    )

    RsF.MoveNext
Loop
RsF.Close : Set RsF = Nothing

Dim arrTempF, sortedF, x
For Each keyF In dictFks.Keys
    Set arrTempF = dictFks(keyF)
    Set sortedF  = CreateObject("System.Collections.ArrayList")

    For Each x In arrTempF
        sortedF.Add x
    Next

    sortedF.Sort GetRef("SortFks")
    Set dictFks(keyF) = sortedF
Next


' ====================================================
' DOOR 캐시 생성
' ====================================================
Dim dictDoor
Set dictDoor = CreateObject("Scripting.Dictionary")

Dim RsDoor, SQL_DOOR
Set RsDoor = Server.CreateObject("ADODB.Recordset")

SQL_DOOR = ""
SQL_DOOR = SQL_DOOR & "SELECT DISTINCT "
SQL_DOOR = SQL_DOOR & "    S.sjsidx, "
SQL_DOOR = SQL_DOOR & "    M.wms_idx, "
SQL_DOOR = SQL_DOOR & "    S.dooryn, "
SQL_DOOR = SQL_DOOR & "    FS.fkidx, "
SQL_DOOR = SQL_DOOR & "    FS.blength, "
SQL_DOOR = SQL_DOOR & "    FS.whichi_fix, "
SQL_DOOR = SQL_DOOR & "    FS.whichi_auto, "
SQL_DOOR = SQL_DOOR & "    FS.goname, "
SQL_DOOR = SQL_DOOR & "    B.set_name_FIX, "
SQL_DOOR = SQL_DOOR & "    B.set_name_AUTO "
SQL_DOOR = SQL_DOOR & "FROM tk_framekSub AS FS "
SQL_DOOR = SQL_DOOR & "INNER JOIN tk_framek AS S "
SQL_DOOR = SQL_DOOR & "    ON FS.fkidx = S.fkidx "
SQL_DOOR = SQL_DOOR & "INNER JOIN tk_wms_meta AS M "
SQL_DOOR = SQL_DOOR & "    ON S.sjidx = M.sjidx "
SQL_DOOR = SQL_DOOR & "INNER JOIN tk_barasiF AS B "
SQL_DOOR = SQL_DOOR & "    ON FS.bfidx = B.bfidx "
SQL_DOOR = SQL_DOOR & "WHERE ( "
SQL_DOOR = SQL_DOOR & "    M.actual_ship_dt = '" & Replace(ymd,"'","''") & "' "
SQL_DOOR = SQL_DOOR & "    AND S.dooryn = 1 "
SQL_DOOR = SQL_DOOR & "    AND ( "
SQL_DOOR = SQL_DOOR & "         FS.whichi_fix IN (12,13) "
SQL_DOOR = SQL_DOOR & "      OR FS.whichi_auto IN (12,13) "
SQL_DOOR = SQL_DOOR & "    ) "
SQL_DOOR = SQL_DOOR & ") "


RsDoor.Open SQL_DOOR, DbCon, 1, 1

Do While Not RsDoor.EOF

    Dim keySjs, rowDoor
    keySjs = CStr(RsDoor("sjsidx"))

    ' row 구조:
    ' 0: fkidx
    ' 1: blength
    ' 2: whichi_auto
    ' 3: whichi_fix
    rowDoor = Array( _
        CLng(RsDoor("fkidx")), _
        CLng(RsDoor("dooryn")), _
        CLng(RsDoor("blength")), _
        CLng(RsDoor("whichi_auto")), _
        CLng(RsDoor("whichi_fix")), _
        Trim("" & RsDoor("goname")) _
    )

    If Not dictDoor.Exists(keySjs) Then
        Set dictDoor(keySjs) = CreateObject("Scripting.Dictionary")
    End If

    dictDoor(keySjs).Add dictDoor(keySjs).Count, rowDoor

    RsDoor.MoveNext
Loop

RsDoor.Close
Set RsDoor = Nothing

' ============================================================
' 도어 수량 캐시 (sjsidx 기준)
' ============================================================
Dim dictDoorCnt
Set dictDoorCnt = Server.CreateObject("Scripting.Dictionary")

Dim RsDoorCnt, sqlDoor
Set RsDoorCnt = Server.CreateObject("ADODB.Recordset")

sqlDoor = ""
sqlDoor = sqlDoor & "SELECT S.sjsidx, COUNT(FS.fksidx) AS doorCnt "
sqlDoor = sqlDoor & "FROM tk_framekSub AS FS "
sqlDoor = sqlDoor & "INNER JOIN tk_framek AS S "
sqlDoor = sqlDoor & "    ON FS.fkidx = S.fkidx "
sqlDoor = sqlDoor & "WHERE ( "
sqlDoor = sqlDoor & "       FS.whichi_fix IN (12,13) "
sqlDoor = sqlDoor & "    OR FS.whichi_auto IN (12,13) "
sqlDoor = sqlDoor & ") "
sqlDoor = sqlDoor & "GROUP BY S.sjsidx "

RsDoorCnt.Open sqlDoor, DbCon, 1, 1


Do While Not RsDoorCnt.EOF
    Dim k
    k = Trim(CStr(RsDoorCnt("sjsidx")))
    dictDoorCnt(k) = CInt(RsDoorCnt("doorCnt"))
    RsDoorCnt.MoveNext
Loop
RsDoorCnt.Close
Set RsDoorCnt = Nothing
%>
<!--#include virtual="/TNG_WMS/Cache/Cache_customer.asp"-->
<!DOCTYPE html>
<html lang="ko">
<script>
window.showSavedAlert = function (msg) {
    var el = document.getElementById("saveAlert");
    if (!el) return;

    el.innerText = msg || "용차기사 팝업이 저장되었습니다.";
    el.style.display = "block";

    setTimeout(function () {
        el.style.display = "none";
    }, 2000);
};
</script>
<head>
<meta charset="utf-8">
<title>📦 WMS 출하 대시보드</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { font-family:'맑은 고딕'; font-size:14px; background:#f8f9fa; margin: 20px; font-family: 'Noto Sans KR', sans-serif; }

/* 기본: 드래그 가능 */
body.drag-on, html.drag-on {
    user-select: text;
    -webkit-user-select: text;
    -moz-user-select: text;
    -ms-user-select: text;
}

/* PDF 캡처 시만 드래그 비활성 */
body.drag-off, html.drag-off {
    user-select: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
}

.wms-table { width:100%; background:white; border-collapse:collapse; }
.wms-table th, .wms-table td { padding:10px; border-bottom:1px solid #e5e5e5; vertical-align:top; }
.group { color:#0d6efd; font-weight:bold; }
.framename { font-weight:bold; }
.bigo { white-space:pre-line; color:#777; font-size:12px; }
.group-row{
    background:#d9e8ff; 
    font-weight:bold; 
    color:#003380;
}
.group-row td{
    padding:8px 12px;
    border-top:2px solid #003380;
}

#select-area {
    position: absolute;
    border: 2px dashed red;
    background: rgba(255,0,0,0.1);
    display: none;
    pointer-events: none; 
    z-index: 1000;
}
.djnum-soft {
    font-weight: 700;
    font-size: 14px;
    color: #003380;
    background: #f3f8ff;
    border: 1px solid #ccd9ff;
    padding: 2px 6px;
    border-radius: 3px;
}
</style>
</head>

<body class="p-4 drag-on">
<div id="saveAlert"
     style="display:none;
            position:fixed;
            top:20px;
            right:20px;
            padding:12px 18px;
            background:#198754;
            color:#fff;
            border-radius:6px;
            z-index:9999;">
    용차기사 팝업이 저장되었습니다.
</div>
<h3 class="table-title">📦 WMS 출하 대시보드</h3>

<button type="button" onclick="startCaptureMode()" style="padding:10px 18px;">
📄 PDF 영역 캡처하기
</button>

<form method="get" id="dateForm" class="mb-3">
  <div class="d-flex flex-wrap gap-2 align-items-center" style="max-width:100%;">
   <div id="select-area"></div>

    <div class="input-group" style="width:220px;">
      <span class="input-group-text">출고일</span>
      <input type="date" name="ymd" id="ymd" value="<%=ymd_html%>" class="form-control">
      <input type="hidden" id="wms_type" name="wms_type" />
    </div>

    <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
    <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">

    <button type="button" class="btn btn-outline-secondary" onclick="moveDay(-1)">◀ 이전날</button>
    <button type="button" class="btn btn-outline-secondary" onclick="moveDay(1)">다음날 ▶</button>

    <button type="button" class="btn btn-dark" onclick="openManualPopup()">수동등록</button>
    <button type="button" class="btn btn-outline-primary" onclick="goWithWmsType('')">전체보기</button>
    <button type="button" class="btn btn-outline-primary" onclick="goWithWmsType('1,17,18,19')">화물,택배보기</button>
    <button type="button" class="btn btn-outline-primary" onclick="goWithWmsType('2,3,4,5')">배달보기</button>

  
    <button class="btn btn-success">조회</button>
    <button type="button" class="btn btn-success" onclick="location.href='TNG_WMS_excel.asp?ymd=<%=ymd%>'">
    📥 엑셀 다운로드
    </button>

    <button type="button" class="btn btn-success"
    onclick="location.href='/TNG_WMS/DASHBOARD/TNG_WMS_DJDASHBOARD.asp?ymd=<%=ymd%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>'">
    도장대시보드
    </button>
    <button type="button" class="btn btn-success"
        onclick="window.open(
            '/TNG_WMS/DASHBOARD/PopUp/TNG_WMS_Cargo_Receipt_Popup.asp?ymd=<%=ymd%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>',
            'djDashboardPopup',
            'width=1200,height=800,scrollbars=yes,resizable=yes'
        );">
        화물 박스 링크
    </button>

    <button type="button" class="btn btn-success"
        onclick="window.open(
            '/TNG_WMS/DASHBOARD/PopUp/TNG_WMS_Cargo_Receipt_print.asp?ymd=<%=ymd%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>',
            'djDashboardPopup',
            'width=1200,height=800,scrollbars=yes,resizable=yes'
        );">
        화물 수탁증
    </button>

  </div>
</form>

<script>
function submitForm() {
    document.getElementById('dateForm').submit();
}
function setToday() {
    const t = new Date();
    document.getElementById('ymd').value = t.toISOString().substring(0,10);
    submitForm();
}
function setYesterday() {
    const d = new Date();
    d.setDate(d.getDate() - 1);
    document.getElementById('ymd').value = d.toISOString().substring(0,10);
    submitForm();
}
function moveDay(n) {
    const ymd = document.getElementById('ymd');
    let d = new Date(ymd.value);
    d.setDate(d.getDate() + n);
    ymd.value = d.toISOString().substring(0,10);
    submitForm();
}
function setRecent7() {
    const d = new Date();
    d.setDate(d.getDate() - 7);
    document.getElementById('ymd').value = d.toISOString().substring(0,10);
    submitForm();
}
function setThisMonth() {
    const d = new Date();
    const first = new Date(d.getFullYear(), d.getMonth(), 1);
    document.getElementById('ymd').value = first.toISOString().substring(0,10);
    submitForm();
}

function openManualPopup(manual_idx){
  const ymd = document.getElementById('ymd')?.value || '';
  const url = 'PopUp/TNG_WMS_Dashboard_Manual_Popup.asp?ymd=' + encodeURIComponent(ymd) + '&manual_idx=' + manual_idx;
  window.open(url, 'manualPop', 'width=900,height=720,scrollbars=yes,resizable=yes');
}

function goWithWmsType(wmsTypeCsv) {
  const ymdEl = document.getElementById('ymd');
  const ymd = ymdEl ? ymdEl.value : '';

  // 현재 URL 기반으로 파라미터 세팅
  const url = new URL(window.location.href);

  // 기존 값 유지/갱신
  if (ymd) url.searchParams.set('ymd', ymd);
  url.searchParams.set('wms_type', wmsTypeCsv); // 예: "1,17,18,19"

  // 이동
  window.location.href = url.toString();
}

document.getElementById('ymd').addEventListener('change', submitForm);
</script>

<%

' =========================================================
' [MANUAL] 수동테이블을 wms_type별로 HTML로 미리 묶기
' =========================================================
Dim dictManualByType, dictManualPrinted
Set dictManualByType = Server.CreateObject("Scripting.Dictionary")
Set dictManualPrinted = Server.CreateObject("Scripting.Dictionary")

Dim RsM, SQLM
Set RsM = Server.CreateObject("ADODB.Recordset")

SQLM = ""
SQLM = SQLM & "SELECT manual_idx, ymd, wms_type, customer_name, recv_name, recv_tel, "
SQLM = SQLM & "       dest_text, item_name, meas_name, material_text, paint_no, spec_text, remark "
SQLM = SQLM & "FROM dbo.tk_wms_dashboard_manual WITH (NOLOCK) "
SQLM = SQLM & "WHERE is_active=1 AND ymd='" & Replace(ymd,"'","''") & "' "

If wms_type_filter <> "" Then
  SQLM = SQLM & " AND wms_type IN(" & wms_type_filter & ") "
End If

SQLM = SQLM & "ORDER BY wms_type, manual_idx"

RsM.Open SQLM, DbCon, 1, 1

Do Until RsM.EOF
  Dim mType, mKey, mTr, mSpec
  mType = CLng(0 & RsM("wms_type"))
  mKey = CStr(mType)

  mSpec = "" & RsM("spec_text")
  mSpec = Replace(Server.HTMLEncode(mSpec), vbCrLf, "<br>")




  mTr = ""
mTr = mTr & "<tr class='manual-row' style='cursor:default;'>"  ' ✅ row 클릭 제거

mTr = mTr & "<td>" & Server.HTMLEncode("" & RsM("customer_name")) & "</td>"
mTr = mTr & "<td>" & Server.HTMLEncode("" & RsM("ymd")) & "</td>"

' =========================
' 출고구분 + 버튼 영역
' =========================
mTr = mTr & "<td style='font-weight:bold;'>"
mTr = mTr & GetWmsTypeName(mType)

' 버튼 영역
mTr = mTr & "<div style='margin-top:6px; display:flex; gap:6px; flex-wrap:wrap;'>"
  ' (1) 배송정보 버튼(원하면 유지)
  mTr = mTr & "  <button type='button' class='btn btn-sm btn-outline-primary' "
  mTr = mTr & "    onclick=""event.stopPropagation(); window.open('PopUp/TNG_WMS_Delivery_Button_Popup.asp?manual_idx=" & RsM("manual_idx") & _
              "&wms_type=" & mType & _
              "&ymd=" & Server.URLEncode("" & RsM("ymd")) & _
              "','move','width=450,height=520,scrollbars=yes');"">"
  mTr = mTr & "    배송정보"
  mTr = mTr & "  </button>"

If (mType = 1 Or mType = 17 Or mType = 18 Or mType = 19) Then

  ' (2) 스티커 출력
  mTr = mTr & "  <button type='button' class='btn btn-sm btn-success' "
  mTr = mTr & "    onclick=""event.stopPropagation(); window.open('PopUp/TNG_WMS_Sticker_POPUP_Manual.asp?manual_idx=" & RsM("manual_idx") & "','_blank');"">"
  mTr = mTr & "    스티커 출력"
  mTr = mTr & "  </button>"

End If

  ' (3) ✅ 수정 버튼 (스티커 출력 밑/옆에 같이 배치)
  mTr = mTr & "  <button type='button' class='btn btn-sm btn-warning' "
  mTr = mTr & "    onclick=""event.stopPropagation(); window.open('PopUp/TNG_WMS_Dashboard_Manual_Popup.asp?manual_idx=" & RsM("manual_idx") & "','edit','width=760,height=820,scrollbars=yes');"">"
  mTr = mTr & "    수정"
  mTr = mTr & "  </button>"

mTr = mTr & "</div>"
mTr = mTr & "</td>"

' =========================
' 나머지 컬럼
' =========================
mTr = mTr & "<td style='font-weight:bold;'>"
mTr = mTr & "지점명: " & Server.HTMLEncode("" & RsM("dest_text")) & "<br>"
mTr = mTr & "받는이: " & Server.HTMLEncode("" & RsM("recv_name")) & "<br>"
mTr = mTr & "전화: " & Server.HTMLEncode("" & RsM("recv_tel"))
mTr = mTr & "</td>"

mTr = mTr & "<td><div class='framename'>" & Server.HTMLEncode("" & RsM("item_name")) & _
            "<span class='group'> (" & Server.HTMLEncode("" & RsM("meas_name")) & ")</span></div></td>"
mTr = mTr & "<td>" & Server.HTMLEncode("" & RsM("material_text")) & "</td>"
mTr = mTr & "<td><span class='djnum-soft'>" & Server.HTMLEncode("" & RsM("paint_no")) & "</span></td>"
mTr = mTr & "<td>" & mSpec & "</td>"
mTr = mTr & "<td class='bigo'>" & Server.HTMLEncode("" & RsM("remark")) & "</td>"

mTr = mTr & "</tr>"

  If Not dictManualByType.Exists(mKey) Then
    dictManualByType.Add mKey, ""
  End If
  dictManualByType(mKey) = dictManualByType(mKey) & mTr

  RsM.MoveNext
Loop
RsM.Close : Set RsM = Nothing

' ============================================================
' 1. META 조회 (메인 루프)
' ============================================================
SQL = ""
SQL = SQL & "SELECT M.wms_idx, M.sjidx, C.cname, A.cgaddr, R.rule_name, "
SQL = SQL & "       M.sender_name, M.recv_addr, M.recv_addr1, "
SQL = SQL & "       FORMAT(M.reg_date,'yyyy-MM-dd') reg_date, "
SQL = SQL & "       M.wms_type, A.cgset, M.memo, M.recv_name, M.recv_tel, M.actual_ship_dt, C.cidx "
SQL = SQL & "FROM tk_wms_meta M "
SQL = SQL & "JOIN ("
SQL = SQL & "    SELECT sjidx, MIN(wms_idx) AS wms_idx "
SQL = SQL & "    FROM tk_wms_meta "
SQL = SQL & "    WHERE actual_ship_dt='" & ymd & "' "
SQL = SQL & "    GROUP BY sjidx"
SQL = SQL & ") B ON M.wms_idx = B.wms_idx "
SQL = SQL & "JOIN TNG_SJA A ON M.sjidx = A.sjidx "
SQL = SQL & "JOIN tk_customer C ON A.sjcidx = C.cidx "
SQL = SQL & "LEFT JOIN tk_rule_core R ON M.wms_type = R.rule_id "
IF wms_type <> "" THEN
SQL = SQL & "WHERE M.wms_type IN(" & wms_type & ")"
END IF
SQL = SQL & "ORDER BY M.wms_type, M.wms_idx"

Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
    Do Until Rs.EOF

        wms_idx = Rs("wms_idx")
        sjidx   = Rs("sjidx")
        cname   = Rs("cname")
        cgaddr  = Rs("cgaddr")
        rule    = Rs("rule_name")
        sender_name = Rs("sender_name")
        recv_addr   = Rs("recv_addr")
        recv_addr1  = Rs("recv_addr1")
        reg_date = Rs("reg_date")
        wms_type = Rs("wms_type")
        cgset    = "" & Rs("cgset")
        memo     = Rs("memo")
        recv_name = Rs("recv_name")
        recv_tel  = Rs("recv_tel")
        actual_ship_dt  = Rs("actual_ship_dt")
        cidx     = Rs("cidx")

        ' 출고구분 텍스트
        wmsTypeName = "-"
        If Not IsNull(wms_type) And wms_type <> "" Then
            Select Case CInt(wms_type)
                Case 1:  wmsTypeName = "화물"
                Case 2:  wmsTypeName = "낮1배달_신두영(인천,고양)"
                Case 3:  wmsTypeName = "낮2배달_최민성(경기)"
                Case 4:  wmsTypeName = "밤1배달_윤성호(수원,천안,능력)"
                Case 5:  wmsTypeName = "밤2배달_김정호(하남)"
                Case 6:  wmsTypeName = "대구창고"
                Case 7:  wmsTypeName = "대전창고"
                Case 8:  wmsTypeName = "부산창고"
                Case 9:  wmsTypeName = "양산창고"
                Case 10: wmsTypeName = "익산창고"
                Case 11: wmsTypeName = "원주창고"
                Case 12: wmsTypeName = "제주창고"
                Case 13: wmsTypeName = "용차"
                Case 14: wmsTypeName = "방문"
                Case 15: wmsTypeName = "1공장"
                Case 16: wmsTypeName = "인천항"
                Case 17: wmsTypeName = "제주화물"
                Case 18: wmsTypeName = "제주택배"
                Case 19: wmsTypeName = "택배"
                Case Else: wmsTypeName = "-"
            End Select
        End If

        isSpecial = (Trim(cgset) = "1")

        ' 그룹 헤더
        If Not IsNull(wms_type) And wms_type <> "" Then
            Dim groupHTML
            groupHTML = "<tr class='group-row'><td colspan='9'>" & wmsTypeName & "</td></tr>"

            If isSpecial Then
                If wms_type <> prev_wms_type_special Then
                    specialHTML = specialHTML & groupHTML
                    prev_wms_type_special = wms_type
                End If
            Else
                If wms_type <> prev_wms_type_normal Then
                    normalHTML = normalHTML & groupHTML
                    prev_wms_type_normal = wms_type
                ' [MANUAL] 같은 wms_type 수동행을 그룹 시작에 1회 삽입
                    Dim kType
                    kType = CStr(wms_type)
                    If dictManualByType.Exists(kType) Then
                        If Not dictManualPrinted.Exists(kType) Then
                            normalHTML = normalHTML & dictManualByType(kType)
                            dictManualPrinted.Add kType, True
                        End If
                    End If
                End If
            End If
        End If


        ' ====================================================
        ' 현 wms_idx 기준 sjsidx 목록
        ' ====================================================
        SQL1 = "SELECT DISTINCT sjsidx FROM tk_wms_detail WHERE wms_idx=" & wms_idx & " ORDER BY sjsidx ASC"
        Rs1.Open SQL1, Dbcon

       totalSJS = 0
        If Not (Rs1.BOF Or Rs1.EOF) Then
            Do Until Rs1.EOF
                totalSJS = totalSJS + 1
                Rs1.MoveNext
            Loop
        End If
        Rs1.Close
        Rs1.Open SQL1, Dbcon
        If totalSJS = 0 Then totalSJS = 1

       
        rowCounter = 0

       Do Until Rs1.EOF
            cur_sjsidx = Rs1("sjsidx")

            

            ' ====================================================
            ' 3. sjsidx 기반 품목/규격 정보 (캐시 사용)
            ' ====================================================
            framename = "" : qtyname = "" : pname = "" : bigo = ""
            mwidth = 0 : mheight = 0 : qtyidx = ""

            If dictSjs.Exists(CStr(cur_sjsidx)) Then
                Dim arrSjs
                arrSjs    = dictSjs(CStr(cur_sjsidx))
                framename = arrSjs(0)
                qtyname   = arrSjs(1)
                pname     = arrSjs(2)
                bigo      = arrSjs(3)
                mwidth    = arrSjs(4)
                mheight   = arrSjs(5)
                qtyidx    = arrSjs(6)
            End If

            ' ====================================================
            ' 4. fks 그룹 수량 계산 (캐시 사용)
            ' ====================================================
            fksCount = 0 : fixCount = 0 : otherCount = 0
            auto12Count = 0 : autoSetCount = 0

            Set auto12List = CreateObject("Scripting.Dictionary")
            Set autoSetList = CreateObject("Scripting.Dictionary")

            
                doortxt = ""
                doorname = ""
                doorDetailTxt = ""

                If dictDoor.Exists(CStr(cur_sjsidx)) Then

                    Dim doorList, firstKey, firstRow
                    Set doorList = dictDoor(CStr(cur_sjsidx))

                    ' -----------------------------
                    ' 1) dooryn : 캐시에서 추출 (첫 row)
                    ' -----------------------------
                    firstKey = doorList.Keys()(0)
                    firstRow = doorList(firstKey)

                    dooryn = CLng(firstRow(1))   ' ⭐ rowDoor(1) = dooryn
                   
                    wauto = CLng(firstRow(3)) 
                    wfix = CLng(firstRow(4)) 

                    
                    If CInt(wauto & "0") > 0 Then
                        doorname = Trim(firstRow(5) & "")
                    ElseIf CInt(wfix & "0") > 0 Then
                        doorname = Trim(firstRow(6) & "")
                    End If
                    
                    ' -----------------------------
                    ' 2) 도어 상태 텍스트
                    ' -----------------------------
                    Select Case dooryn
                        Case 1
                            doortxt = "도어같이"
                        Case 0
                            doortxt = "도어나중"
                        Case 2
                            doortxt = "도어안함"
                        Case Else
                            doortxt = ""
                    End Select

                    ' -----------------------------
                    ' 3) 도어 상세 (dooryn = 1일 때만)
                    ' -----------------------------
                    If dooryn = 1 Then
    
                        doorCnt = 0

                        key = Trim(CStr(RsDoorCnt("sjsidx")))

                        If dictDoorCnt.Exists(CStr(cur_sjsidx)) Then
                            doorCnt = dictDoorCnt(CStr(cur_sjsidx)) * 4
                        Else
                            doorCnt = 0
                        End If
               
                        doorDetailTxt = doorname
              
                    End If
                End If
        
            If dictFks.Exists(CStr(cur_sjsidx)) Then
                Set listF = dictFks(CStr(cur_sjsidx))

                For Each row In listF
                    fkidx = row(0)
                    waa   = row(1)
                    wfix  = row(2)
                    bl    = row(3)

                    If waa = 1 Or waa = 2 Then
                        auto12List.Add CStr(auto12List.Count), fkidx & "|" & bl & "|" & waa
                    ElseIf waa = 8 Or waa = 9 Or waa = 24 Then
                        autoSetList.Add CStr(autoSetList.Count), fkidx & "|" & bl & "|" & waa
                    ElseIf waa = 0 And wfix <> 0 Then
                        fixCount = fixCount + 1
                    Else
                        otherCount = otherCount + 1
                    End If
                Next
            End If

            ' AUTO 1,2 세트 처리 (기존 로직 유지)
            n12 = auto12List.Count
            If n12 > 0 Then
                ReDim arrFk12(n12-1)
                ReDim arrBl12(n12-1)
                ReDim arrType12(n12-1)
                ReDim used12(n12-1)

                i = 0
                For Each k2 In auto12List.Keys
                    parts = Split(auto12List(k2), "|")
                    arrFk12(i)   = CLng(parts(0))
                    arrBl12(i)   = CLng(parts(1))
                    arrType12(i) = CLng(parts(2))
                    used12(i)    = False
                    i = i + 1
                Next

                For i = 0 To n12-1
                    If arrType12(i) = 1 And (Not used12(i)) Then
                        fkBase = arrFk12(i)
                        blBase = arrBl12(i)

                        bestJ    = -1
                        bestDiff = 0

                        For j = 0 To n12-1
                            If arrType12(j) = 2 And (Not used12(j)) Then
                                If arrFk12(j) = fkBase Then
                                    diff = Abs(blBase - arrBl12(j))
                                    If diff <= 2 Then
                                        If bestJ = -1 Or diff < bestDiff Then
                                            bestJ    = j
                                            bestDiff = diff
                                        End If
                                    End If
                                End If
                            End If
                        Next

                        used12(i) = True
                        If bestJ <> -1 Then used12(bestJ) = True

                        auto12Count = auto12Count + 1
                    End If
                Next

                For i = 0 To n12-1
                    If arrType12(i) = 2 And (Not used12(i)) Then
                        used12(i) = True
                        auto12Count = auto12Count + 1
                    End If
                Next
            End If

            ' AUTO 8,9,24 세트 처리 (기존 로직 유지)
            nSet = autoSetList.Count
            If nSet > 0 Then
                ReDim arrFkSet(nSet-1)
                ReDim arrBlSet(nSet-1)
                ReDim arrTypeSet(nSet-1)
                ReDim usedSet(nSet-1)

                i = 0
                For Each k3 In autoSetList.Keys
                    parts = Split(autoSetList(k3), "|")
                    arrFkSet(i)   = CLng(parts(0))
                    arrBlSet(i)   = CLng(parts(1))
                    arrTypeSet(i) = CLng(parts(2))
                    usedSet(i)    = False
                    i = i + 1
                Next

                For i = 0 To nSet-1
                    If arrTypeSet(i) = 8 And (Not usedSet(i)) Then
                        fkBase = arrFkSet(i)
                        blBase = arrBlSet(i)
                        usedSet(i) = True

                        For j = 0 To nSet-1
                            If Not usedSet(j) Then
                                If arrFkSet(j) = fkBase Then
                                    If arrTypeSet(j) = 9 Or arrTypeSet(j) = 24 Then
                                        If Abs(blBase - arrBlSet(j)) <= 2 Then
                                            usedSet(j) = True
                                        End If
                                    End If
                                End If
                            End If
                        Next

                        autoSetCount = autoSetCount + 1
                    End If
                Next

                For i = 0 To nSet-1
                    If arrTypeSet(i) = 9 And (Not usedSet(i)) Then
                        fkBase = arrFkSet(i)
                        blBase = arrBlSet(i)
                        usedSet(i) = True

                        For j = 0 To nSet-1
                            If Not usedSet(j) Then
                                If arrFkSet(j) = fkBase And arrTypeSet(j) = 24 Then
                                    If Abs(blBase - arrBlSet(j)) <= 2 Then
                                        usedSet(j) = True
                                    End If
                                End If
                            End If
                        Next

                        autoSetCount = autoSetCount + 1
                    End If
                Next

                For i = 0 To nSet-1
                    If arrTypeSet(i) = 24 And (Not usedSet(i)) Then
                        usedSet(i) = True
                        autoSetCount = autoSetCount + 1
                    End If
                Next
            End If

            ' ============================================================
            ' 규격 병합 (BEST 구조)
            ' ============================================================
            sizesHTML = "" : sumQuan = 0

            keyD = CStr(wms_idx) & "_" & CStr(cur_sjsidx)

            If dictDetail.Exists(keyD) Then
                Set arrD = dictDetail(keyD)

                ' -----------------------------------------------------------
                ' STEP 1) arrD 원본 수집
                ' -----------------------------------------------------------
                Dim baseList(), baseCnt
                ReDim baseList(0) : baseCnt = 0

                For Each row In arrD
                    bl2 = CLng(row(0))
                    q2  = CLng(row(1))
                    gp2 = CStr(row(2))
                    bn2 = CStr(row(3))
                    
                    If bl2 > 0 Then
                        ReDim Preserve baseList(baseCnt)
                        baseList(baseCnt) = Array(bl2, q2, gp2, bn2)
                        baseCnt = baseCnt + 1
                    End If
                Next


                ' -----------------------------------------------------------
                ' STEP 2) 카테고리 분리: FIX / BOX / NORMAL
                ' -----------------------------------------------------------
                Dim fixList(), fixCnt
                Dim boxList(), boxCnt
                Dim normalList(), normalCnt

                ReDim fixList(0) : fixCnt = 0
                ReDim boxList(0) : boxCnt = 0
                ReDim normalList(0) : normalCnt = 0

                For i = 0 To baseCnt - 1
                    bl2 = baseList(i)(0)
                    q2  = baseList(i)(1)
                    gp2 = baseList(i)(2)
                    bn2 = baseList(i)(3)

                    If InStr(bn2, "픽스하바") > 0 Or InStr(bn2, "픽스상바") > 0 Or InStr(bn2, "오사이") > 0 Then
                        ReDim Preserve fixList(fixCnt)
                        fixList(fixCnt) = baseList(i)
                        fixCnt = fixCnt + 1

                    ElseIf InStr(bn2, "박스세트") > 0 Or InStr(bn2, "박스커버") > 0 Then
                        ReDim Preserve boxList(boxCnt)
                        boxList(boxCnt) = baseList(i)
                        boxCnt = boxCnt + 1

                    Else
                        ReDim Preserve normalList(normalCnt)
                        normalList(normalCnt) = baseList(i)
                        normalCnt = normalCnt + 1
                    End If
                Next



                ' -----------------------------------------------------------
                ' STEP 3) FIX 조합 (C안)
                ' -----------------------------------------------------------
                Dim fixOut(), fixOutCnt
                ReDim fixOut(0) : fixOutCnt = 0

                If fixCnt > 0 Then
                    Dim fixMap
                    Set fixMap = CreateObject("Scripting.Dictionary")

                    ' FIX 수량 합산
                    For i = 0 To fixCnt - 1
                        bl2 = fixList(i)(0)
                        q2  = fixList(i)(1)
                        bn2 = fixList(i)(3)
                        keyLen = CStr(bl2)
                        'Response.Write "sjidx : " & sjidx & "<br>"
                        'Response.Write "keyLen : " & keyLen & "<br>"                        
                        If Not fixMap.Exists(keyLen) Then
                            fixMap.Add keyLen, Array(0,0,0,bl2)
                        End If

                        info = fixMap(keyLen)

                        If InStr(bn2, "픽스하바") > 0 Then info(0) = info(0) + q2
                        If InStr(bn2, "픽스상바") > 0 Then info(1) = info(1) + q2
                        If InStr(bn2, "오사이") > 0 Then info(2) = info(2) + q2

                        fixMap(keyLen) = info
                    Next

                    ' -----------------------------------------------------------
                    ' FIX 길이 중 sjidx 기준 최대값 추출
                    ' -----------------------------------------------------------
                    Dim maxFixLen
                    maxFixLen = 0

                    For i = 0 To fixCnt - 1
                        bl2 = fixList(i)(0)
                        If bl2 > maxFixLen Then maxFixLen = bl2
                    Next

                    'Response.Write "sjidx : " & sjidx & ", maxFixLen : " & maxFixLen & "<br>"

                   
                    ' FIX 조합하기
                    For Each L In fixMap.Keys
                        info = fixMap(L)

                        totalBA   = totalBA   + info(0)
                        totalSANG = totalSANG + info(1)
                        totalOSAI = totalOSAI + info(2)
                    Next

                    ' sjidx 기준으로 한 번만 출력
                    'Response.Write "sjidx : " & sjidx & "<br>"
                    'Response.Write "ba : " & totalBA & "<br>"
                    'Response.Write "sang : " & totalSANG & "<br>"
                    'Response.Write "osai : " & totalOSAI & "<br>"
                    'Response.Write "bl2 : " & bl2 & "<br><br>"
                    
                    ' 1) 픽스세트 (하바 + 상바 + 오사이 2개)
                    setCnt = MyMin(MyMin(totalBA, totalSANG), Int(totalOSAI / 2))

                    If setCnt > 0 Then
                        ReDim Preserve fixOut(fixOutCnt)
                        fixOut(fixOutCnt) = Array(baseLen, setCnt, "", "픽스세트")
                        fixOutCnt = fixOutCnt + 1

                        totalBA   = totalBA   - setCnt
                        totalSANG = totalSANG - setCnt
                        totalOSAI = totalOSAI - (setCnt * 2)

                    ' 2) 하바세트 (하바 + 오사이)
                    ElseIf totalBA > 0 And totalOSAI > 0 Then
                        habaSet = MyMin(totalBA, totalOSAI)

                        ReDim Preserve fixOut(fixOutCnt)
                        fixOut(fixOutCnt) = Array(baseLen, habaSet, "", "하바세트")
                        fixOutCnt = fixOutCnt + 1

                        totalBA   = totalBA   - habaSet
                        totalOSAI = totalOSAI - habaSet

                    ' 3) 상바세트 (상바 + 오사이)
                    ElseIf totalSANG > 0 And totalOSAI > 0 Then
                        sangSet = MyMin(totalSANG, totalOSAI)

                        ReDim Preserve fixOut(fixOutCnt)
                        fixOut(fixOutCnt) = Array(baseLen, sangSet, "", "상바세트")
                        fixOutCnt = fixOutCnt + 1

                        totalSANG = totalSANG - sangSet
                        totalOSAI = totalOSAI - sangSet

                    ' 4) 나머지 오사이 단품 (±2mm 병합 포함)
                    ElseIf totalOSAI > 0 Then
                        mergedO = False
   
                        If Not mergedO Then
                            ReDim Preserve fixOut(fixOutCnt)
                            fixOut(fixOutCnt) = Array(baseLen, totalOSAI, "", "오사이")
                            fixOutCnt = fixOutCnt + 1
                        End If
                    End If
                    If fixOutCnt > 0 Then
                        For i = 0 To fixOutCnt - 1
                            fixOut(i)(0) = maxFixLen
                        Next
                    End If

                    'totalBA = 0
                    'totalSANG = 0
                    'totalOSAI = 0
                End If



                ' -----------------------------------------------------------
                ' STEP 4) 박스세트 병합
                ' -----------------------------------------------------------
                Dim boxOut(), boxOutCnt
                ReDim boxOut(0) : boxOutCnt = 0

                For i = 0 To boxCnt - 1
                    
                    bl2 = boxList(i)(0)
                    bn2 = NormalizeName(boxList(i)(3))

                    merged = False

                    For j = 0 To boxOutCnt - 1
                        bl0 = boxOut(j)(0)
                        bn0 = NormalizeName(boxOut(j)(3))

                        If InStr(bn0, "박스") > 0 And Abs(bl0 - bl2) <= 2 Then

                            If bn2 = "박스세트" Or bn0 = "박스세트" Then
                                boxOut(j)(3) = "박스세트"
                            Else
                                boxOut(j)(3) = "박스커버"
                            End If
                            
                            pairCnt = Int(boxCnt / 2)
                            remain  = boxCnt Mod 2

                            boxOut(j)(1) = pairCnt

                            If remain > 0 Then
                                ' 단품 박스 처리 로직 추가
                            End If

                            If bl2 > bl0 Then boxOut(j)(0) = bl2

                            merged = True
                            Exit For
                        End If
                    Next

                    If Not merged Then
                        ReDim Preserve boxOut(boxOutCnt)
                        boxOut(boxOutCnt) = Array(bl2, 1, "", bn2)
                        boxOutCnt = boxOutCnt + 1
                    End If
                    
                Next



                ' -----------------------------------------------------------
                ' STEP 5) 일반 바 병합
                ' -----------------------------------------------------------
                Dim normOut(), normOutCnt
                ReDim normOut(0) : normOutCnt = 0

                For i = 0 To normalCnt - 1
                    bl2 = normalList(i)(0)
                    q2  = normalList(i)(1)
                    gp2 = normalList(i)(2)
                    bn2 = normalList(i)(3)

                    merged = False

                    For j = 0 To normOutCnt - 1
                        bl0 = normOut(j)(0)
                        bn0 = normOut(j)(3)
                        gp0 = normOut(j)(2)

                        If Abs(bl0 - bl2) <= 2 And Clean(bn0) = Clean(bn2) And Clean(gp0) = Clean(gp2) Then
                            normOut(j)(1) = normOut(j)(1) + q2
                            If bl2 > bl0 Then normOut(j)(0) = bl2
                            merged = True
                            Exit For
                        End If
                    Next

                    If Not merged Then
                        ReDim Preserve normOut(normOutCnt)
                        normOut(normOutCnt) = Array(bl2, q2, gp2, bn2)
                        normOutCnt = normOutCnt + 1
                    End If
                Next




                ' -----------------------------------------------------------
                ' STEP 6) 최종 리스트 합치기
                ' -----------------------------------------------------------
                Dim finalList(), finalCnt
                finalCnt = fixOutCnt + boxOutCnt + normOutCnt
                ReDim finalList(finalCnt - 1)

                idx = 0
                For i = 0 To fixOutCnt - 1: finalList(idx) = fixOut(i): idx = idx + 1: Next
                For i = 0 To boxOutCnt - 1: finalList(idx) = boxOut(i): idx = idx + 1: Next
                For i = 0 To normOutCnt - 1: finalList(idx) = normOut(i): idx = idx + 1: Next


                ' -----------------------------------------------------------
                ' STEP 7) 정렬
                ' -----------------------------------------------------------
                For x = 0 To finalCnt - 2
                    For y = x + 1 To finalCnt - 1
                        a = finalList(x)
                        b = finalList(y)

                        If (Clean(a(3)) = "" And Clean(b(3)) <> "") _
                        Or (Clean(a(3)) = Clean(b(3)) And a(0) > b(0)) Then
                            tmp = finalList(x)
                            finalList(x) = finalList(y)
                            finalList(y) = tmp
                        End If
                    Next
                Next


                ' -----------------------------------------------------------
                ' STEP 8) 출력
                ' -----------------------------------------------------------
                For i = 0 To finalCnt - 1
                    
                    sizesHTML = sizesHTML & "<span style='margin-right:12px;'>"
                    If debugBaname Then
                        Response.Write "<!-- BANAME RAW=[" & finalList(i)(3) & "] => CLEAN=[" & CleanNameOnly(finalList(i)(3)) & "] -->" & vbCrLf
                    End If
                    If finalList(i)(3) <> "" Then
                        sizesHTML = sizesHTML & "<b>" & CleanNameOnly(finalList(i)(3)) & "</b>&nbsp;"
                    End If

                    sizesHTML = sizesHTML & "<b>" & finalList(i)(0) & "</b> × " & finalList(i)(1)
                    sizesHTML = sizesHTML & "</span>"

                    sumQuan = sumQuan + finalList(i)(1)
                Next

                ' 도어명 (있을 때만)
                If doorName <> "" Then
                    sizesHTML = sizesHTML & "<span><b>"&doorDetailTxt&"</b> × " &doorcnt&"</span>"
                    sumQuan = sumQuan + doorCnt
                    doorName = ""
                    doorCnt = 0
                End If
                
                sizesHTML = sizesHTML & "<span style='margin-left:18px;color:#d00000;font-weight:bold;'>총 " & sumQuan & "개</span>"
                
            End If





            ' ====================================================
            ' 6. 도장번호 (dictDj 사용)
            ' ====================================================
            djnum = ""
            If dictDj.Exists(CStr(cur_sjsidx)) Then
                djnum = dictDj(CStr(cur_sjsidx))
            End If

            If Not IsNull(recv_addr) Then
                recvAddr = Trim(recv_addr)
            End If

            ' recv_addr가 비어있으면 cbran 대체
            If recvAddr = "" Then
                If dictCustomerOne.Exists(cidx) Then
                    recvAddr = dictCustomerOne(cidx)("cbran")
                End If
            End If

            If dictCustomerOne.Exists(cidx) Then
                    cname = dictCustomerOne(cidx)("cname")
            End If

            If cname = recv_name Then
                sub_cname = ""
            Else
                sub_cname = "(" & recv_name & ")"
            End If



            ' ====================================================
            ' 7. 최종 tr HTML 구성
            ' ====================================================
            trHTML = "<tr>"

            ' 배송정보 표시
            If wms_type = 1 Then
                displayInfo = "지점명: " & recvAddr & "<br>받는이: " & recv_name & "<br>전화: " & recv_tel
            Else
                displayInfo = "지점명: " & recvAddr & "<br>상세주소: " & recv_addr1 & "<br>받는이: " & recv_name & "<br>전화: " & recv_tel
            End If

            If rowCounter = 0 Then
                trHTML = trHTML & "<td rowspan='" & totalSJS & "' onclick=""window.open('/TNG1/TNG1_B.asp?sjcidx=" & rsjcidx & "&sjmidx=" & rsjmidx & "&sjidx=" & sjidx & "&suju_kyun_status=0','_blank');"" style='cursor:pointer;'>" & cname & "<span class='bigo'>" & sub_cname & "</span></td>"
                    ' 버튼 HTML (wms_idx 그룹당 1번만 출력)
                
                    Dim btnHTML
                    btnHTML = ""
                    btnHTML = btnHTML & "<div style='margin-top:6px; display:flex; gap:6px; flex-wrap:wrap;'>"
                    btnHTML = btnHTML & "  <button type='button' class='btn btn-sm btn-primary' "
                    btnHTML = btnHTML & "    onclick=""event.stopPropagation(); saveStickerSnapshot(" & wms_idx & ", '" & ymd_html & "');"">"
                    btnHTML = btnHTML & "    스티커 생성"
                    btnHTML = btnHTML & "  </button>"
                    btnHTML = btnHTML & "  <button type='button' class='btn btn-sm btn-success' "
                    btnHTML = btnHTML & "    onclick=""event.stopPropagation(); window.open('/TNG_WMS/DASHBOARD/POPUP/TNG_WMS_Sticker_POPUP.asp?wms_idx=" & wms_idx & "','_blank');"">"
                    btnHTML = btnHTML & "    스티커 출력"
                    btnHTML = btnHTML & "  </button>"
                    btnHTML = btnHTML & "</div>"
                
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "' >" & actual_ship_dt & "</td>"
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "' " & _
                    "onclick=""window.open('PopUp/TNG_WMS_Delivery_Button_Popup.asp?wms_idx=" & wms_idx & "&wms_type=" & wms_type & "&ymd=" & actual_ship_dt & "','move','width=450,height=520,scrollbars=yes');"" " & _
                    "style='cursor:pointer; font-weight:bold;'>"
                    trHTML = trHTML & wmsTypeName
                    If wms_type = 1 or wms_type = 17 or wms_type = 18 or wms_type = 19 Then
                        trHTML = trHTML & btnHTML
                    End If
                    trHTML = trHTML & "</td>"
                    trHTML = trHTML & "<td rowspan='" & totalSJS & "' onclick=""window.open('PopUp/TNG_WMS_Type_popup.asp?sjidx=" & sjidx & "&sjsidx=" & cur_sjsidx & "&wms_type=" & wms_type & "','move','width=450,height=520,scrollbars=yes');"" style='cursor:pointer; font-weight:bold;'>"
                    trHTML = trHTML & displayInfo & "</td>"
                
            End If

            trHTML = trHTML & "<td><div class='framename'>" & framename & "<span class='group'> (" & mwidth & " X " & mheight  & ")</span></div></td>"
            trHTML = trHTML & "<td>" & qtyname & " / " & pname & " <span class='bigo'>" & recvAddr & "</span></td>"

            If djnum <> "" AND qtyidx <> 5 Then
                trHTML = trHTML & "<td><span class='djnum-soft'>" & djnum & "</span></td>"
            Else
                trHTML = trHTML & "<td></td>"
            End If

            Dim payload
            payload = ""

            If finalCnt > 0 Then
                payload = BuildPayloadFromFinalList(finalList, finalCnt)
            End If

            ' 도어 포함 (원하면 유지)
            If Trim(doorDetailTxt & "") <> "" And CLng(0 & doorCnt) > 0 Then
                If payload <> "" Then payload = payload & "|"
                payload = payload & Replace(CleanNameOnly(doorDetailTxt), "|", "") & "^0^" & CLng(doorCnt)
            End If

            trHTML = trHTML & "<td class='stk-cell' data-wms='" & wms_idx & "' data-sjs='" & cur_sjsidx & "' data-sum='" & sumQuan & "'>"
            trHTML = trHTML & sizesHTML
            trHTML = trHTML & "<textarea class='stk-payload' style='display:none;'>" & HtmlEnc(payload) & "</textarea>"
            trHTML = trHTML & "</td>"
                        

            

            ' 메모 분리 / 출력
            arrMemo = Split("" & memo, "||")
            If Trim(memo) <> "" Then
                Dim memoText
                memoText = ""
                If rowCounter <= UBound(arrMemo) Then
                    memoText = Trim(arrMemo(rowCounter))
                End If
                If memoText = """" Then memoText = ""

                If memoText <> "" Then
                    trHTML = trHTML & "<td onclick=""window.open('PopUp/TNG_WMS_Bigo_popup.asp?sjidx=" & sjidx & "','move','width=1300,height=520,scrollbars=yes');"" style='cursor:pointer; font-weight:bold; white-space:pre-line; line-height:1.4;'>" & memoText & "</td>"
                Else
                    trHTML = trHTML & "<td onclick=""window.open('PopUp/TNG_WMS_Bigo_popup.asp?sjidx=" & sjidx & "','move','width=1300,height=520,scrollbars=yes');""></td>"
                End If
            Else
                trHTML = trHTML & "<td onclick=""window.open('PopUp/TNG_WMS_Bigo_popup.asp?sjidx=" & sjidx & "','move','width=1300,height=520,scrollbars=yes');"">"&doortxt&"</td>"
            End If

            trHTML = trHTML & "</tr>"

            If isSpecial Then
                specialHTML = specialHTML & trHTML
            Else
                normalHTML  = normalHTML  & trHTML
            End If

            rowCounter = rowCounter + 1
            Rs1.MoveNext
        Loop

        Rs1.Close
        Rs.MoveNext
    Loop
End If

Rs.Close
' =========================================================
' [MANUAL] META에 없는 출고구분도 출력 (수동행만 있는 경우)
' =========================================================

For Each kType In dictManualByType.Keys
    If Not dictManualPrinted.Exists(kType) Then
        groupHTML = "<tr class='group-row'><td colspan='9'>" & GetWmsTypeName(CLng(0 & kType)) & "</td></tr>"
        normalHTML = normalHTML & groupHTML & dictManualByType(kType)
        dictManualPrinted.Add kType, True
    End If
Next
%>

<table class="wms-table">
<thead>
<tr style="background:#eef4ff;">
    <th style="width:10%;">거래처명</th>
    <th style="width:8%;">수주일자</th>
    <th style="width:7%;">출고구분</th>
    <th style="width:10%;">도착지(현장)</th>
    <th style="width:12%;">품목명(검측)</th>
    <th style="width:9%;">재질</th>
    <th style="width:6%;">도장번호</th>
    <th style="width:25%;">규격 (길이 × 수량) 총수량</th>
    <th style="width:20%;">비고</th>
</tr>
</thead>
<tbody>
    <%= normalHTML %>
</tbody>
</table>

<% If specialHTML <> "" Then %>
<br><br>
<h4 style="color:#d00000;font-weight:bold;">입금후출고</h4>
<table class="wms-table" style="border:2px solid #ff0000; background:#fff5f5;">
<thead>
<tr style="background:#ffe5e5;color:#c40000;font-weight:bold;">
    <th style="width:10%;">거래처명</th>
    <th style="width:8%;">수주일자</th>
    <th style="width:7%;">출고구분</th>
    <th style="width:10%;">도착지(현장)</th>
    <th style="width:12%;">품목명(검측)</th>
    <th style="width:9%;">재질</th>
    <th style="width:6%;">도장번호</th>
    <th style="width:25%;">규격 (길이 × 수량) 총수량</th>
    <th style="width:20%;">비고</th>
</tr>
</thead>
<tbody>
    <%= specialHTML %>
</tbody>
</table>
<% End If %>

<!-- html2canvas -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<!-- jsPDF -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<script>

async function saveStickerSnapshot(wms_idx, ymd){
  const cells = document.querySelectorAll(`.stk-cell[data-wms="${wms_idx}"]`);
  if(!cells.length){
    alert('저장할 규격 데이터가 없습니다.1');
    console.log('stk-cell count:', document.querySelectorAll('.stk-cell').length);
    
    return;
  }

  const lines = [];
  cells.forEach(td => {
    const sjsidx = td.getAttribute('data-sjs') || '';
    const sum = td.getAttribute('data-sum') || '0';
    const ta = td.querySelector('.stk-payload');
    const payload = ta ? (ta.value || ta.textContent || '') : '';

    if(payload.trim() !== ''){
      lines.push(`${sjsidx}\t${sum}\t${payload}`);
    }
  });

  if(!lines.length){
    alert('저장할 규격 데이터가 없습니다.');
    return;
  }

  const form = new URLSearchParams();
  form.append('wms_idx', wms_idx);
  form.append('ymd', ymd || '');
  form.append('data', lines.join('\n'));

  const res = await fetch('/TNG_WMS/DASHBOARD/TNG_WMS_Sticker_Snapshot_Save.asp', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
    body: form.toString(),
    cache: 'no-store'
  });

  alert(await res.text());
}
let startX, startY, endX, endY;
let isDragging = false;
let enableCapture = false;

const area = document.getElementById("select-area");

function startCaptureMode() {
    enableCapture = true;
    alert("PDF로 저장할 영역을 드래그하세요.");
        // 1) PDF 찍을 동안만 드래그 OFF
    document.body.classList.remove("drag-on");
    document.body.classList.add("drag-off");
}
window.startCaptureMode = startCaptureMode;

document.addEventListener("mousedown", function(e) {
    if (!enableCapture) return;

    isDragging = true;
    startX = e.pageX;
    startY = e.pageY;

    area.style.left = startX + "px";
    area.style.top = startY + "px";
    area.style.width = "0px";
    area.style.height = "0px";
    area.style.display = "block";
});

document.addEventListener("mousemove", function(e) {
    if (!isDragging || !enableCapture) return;

    endX = e.pageX;
    endY = e.pageY;

    area.style.width = Math.abs(endX - startX) + "px";
    area.style.height = Math.abs(endY - startY) + "px";
    area.style.left = Math.min(startX, endX) + "px";
    area.style.top = Math.min(startY, endY) + "px";
});

document.addEventListener("mouseup", async function(e) {
    if (!isDragging || !enableCapture) return;

    isDragging = false;
    endX = e.pageX;
    endY = e.pageY;

    await captureToPDF();
    enableCapture = false;
});

async function captureToPDF() {
    const rect = area.getBoundingClientRect();
    area.style.display = "none";

    const scrollX = window.scrollX;
    const scrollY = window.scrollY;

    const canvas = await html2canvas(document.documentElement, {
        scale: 2,
        useCORS: true,
        backgroundColor: null,
        scrollX: -scrollX,
        scrollY: -scrollY
    });

    const croppedCanvas = document.createElement("canvas");
    croppedCanvas.width = rect.width * 2;
    croppedCanvas.height = rect.height * 2;
    const ctx = croppedCanvas.getContext("2d");

    ctx.fillStyle = "#ffffff";
    ctx.fillRect(0, 0, croppedCanvas.width, croppedCanvas.height);

    ctx.drawImage(
        canvas,
        (rect.left + scrollX) * 2,
        (rect.top + scrollY) * 2,
        rect.width * 2,
        rect.height * 2,
        0, 0,
        rect.width * 2,
        rect.height * 2
    );

    const imgData = croppedCanvas.toDataURL("image/png");

    const A4_PORTRAIT = [595, 842];
    const A4_LANDSCAPE = [842, 595];

    const pdfSize = (rect.width > rect.height) ? A4_LANDSCAPE : A4_PORTRAIT;
    const { jsPDF } = window.jspdf;

    const pdf = new jsPDF({
        orientation: rect.width > rect.height ? "l" : "p",
        unit: "pt",
        format: pdfSize
    });

    const pageWidth = pdfSize[0];
    const pageHeight = pdfSize[1];

    const scale = pageWidth / rect.width;
    const imgW = rect.width * scale;
    const imgH = rect.height * scale;

    const posX = 0;
    const posY = (pageHeight - imgH) / 2;

    pdf.addImage(imgData, "PNG", posX, posY, imgW, imgH);

    const pdfBlob = pdf.output("blob");
    const pdfUrl = URL.createObjectURL(pdfBlob);
    window.open(pdfUrl, "_blank");

    area.style.width = "0px";
    area.style.height = "0px";
    area.style.display = "none";

    // 2) PDF 생성이 끝나면 드래그 다시 ON
    document.body.classList.remove("drag-off");
    document.body.classList.add("drag-on");
}



</script>

</body>
</html>

<%
Set RsC = Nothing
Set Rs  = Nothing
Set Rs1 = Nothing
Set Rs2 = Nothing
Set Rs3 = Nothing
call dbClose()
%>
