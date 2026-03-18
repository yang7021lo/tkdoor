<%@ codepage="65001" language="vbscript" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<%
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

' ================================
' 숫자 x 숫자 패턴 제거
' ================================
Function CleanNameOnly(bn)
    Dim regEx
    Set regEx = New RegExp
    regEx.Pattern = "^\s*\d+\s*[xX]\s*\d+\s*_?\s*"  ' 숫자 X 숫자 패턴 제거
    regEx.IgnoreCase = True
    regEx.Global = True
    CleanNameOnly = Trim(regEx.Replace(bn, ""))
End Function


Set Rs  = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Set RsC = Server.CreateObject("ADODB.Recordset")

rsjcidx = Request("sjcidx")
rsjmidx = Request("sjmidx")

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
SQL_PREF2 = SQL_PREF2 & "WHERE M.actual_ship_dt = '" & ymd & "' "
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
%>

<!DOCTYPE html>
<html lang="ko">
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
    </div>

    <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
    <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">

    <button type="button" class="btn btn-outline-secondary" onclick="moveDay(-1)">◀ 이전날</button>
    <button type="button" class="btn btn-outline-secondary" onclick="moveDay(1)">다음날 ▶</button>

    <button type="button" class="btn btn-outline-primary" onclick="setToday()">오늘</button>
    <button type="button" class="btn btn-outline-primary" onclick="setYesterday()">어제</button>
    <button type="button" class="btn btn-outline-primary" onclick="setRecent7()">최근 7일</button>
    <button type="button" class="btn btn-outline-primary" onclick="setThisMonth()">이번 달</button>

    <button class="btn btn-success">조회</button>
    <button type="button" class="btn btn-success" onclick="location.href='TNG_WMS_excel.asp?ymd=<%=ymd%>'">
    📥 엑셀 다운로드
    </button>

    <button type="button" class="btn btn-success"
    onclick="location.href='/TNG_WMS/TNG_WMS_DJDASHBOARD.asp?ymd=<%=ymd%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>'">
    도장대시보드
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
document.getElementById('ymd').addEventListener('change', submitForm);
</script>

<%
' ============================================================
' 1. META 조회 (메인 루프)
' ============================================================
SQL = ""
SQL = SQL & "SELECT M.wms_idx, M.sjidx, C.cname, A.cgaddr, R.rule_name, "
SQL = SQL & "       M.sender_name, M.recv_addr, M.recv_addr1, "
SQL = SQL & "       FORMAT(M.reg_date,'yyyy-MM-dd') reg_date, "
SQL = SQL & "       M.wms_type, A.cgset, M.memo, M.recv_name, M.recv_tel "
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
        If totalSJS = 0 Then totalSJS = 1

        Rs1.Open SQL1, Dbcon
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

                    ElseIf InStr(bn2, "박스") > 0 Then
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

                            boxOut(j)(1) = boxCnt/2
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

                    If finalList(i)(3) <> "" Then
                        sizesHTML = sizesHTML & "<b>" & CleanNameOnly(finalList(i)(3)) & "</b>&nbsp;"
                    End If

                    sizesHTML = sizesHTML & "<b>" & finalList(i)(0) & "</b> × " & finalList(i)(1)
                    sizesHTML = sizesHTML & "</span>"

                    sumQuan = sumQuan + finalList(i)(1)
                Next

                sizesHTML = sizesHTML & "<span style='margin-left:18px;color:#d00000;font-weight:bold;'>총 " & sumQuan & "개</span>"
            End If





            ' ====================================================
            ' 6. 도장번호 (dictDj 사용)
            ' ====================================================
            djnum = ""
            If dictDj.Exists(CStr(cur_sjsidx)) Then
                djnum = dictDj(CStr(cur_sjsidx))
            End If

            ' ====================================================
            ' 7. 최종 tr HTML 구성
            ' ====================================================
            trHTML = "<tr>"

            ' 배송정보 표시
            If wms_type = 1 Then
                displayInfo = "지점명: " & recv_addr & "<br>받는이: " & recv_name & "<br>전화: " & recv_tel
            Else
                displayInfo = "지점명: " & recv_addr & "<br>상세주소: " & recv_addr1 & "<br>받는이: " & recv_name & "<br>전화: " & recv_tel
            End If

            If rowCounter = 0 Then
                trHTML = trHTML & "<td rowspan='" & totalSJS & "' onclick=""window.open('/TNG1/TNG1_B.asp?sjcidx=" & rsjcidx & "&sjmidx=" & rsjmidx & "&sjidx=" & sjidx & "&suju_kyun_status=0','_blank');"" style='cursor:pointer;'>" & cname & "</td>"
                trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & reg_date & "</td>"
                trHTML = trHTML & "<td rowspan='" & totalSJS & "'>" & wmsTypeName & "</td>"
                trHTML = trHTML & "<td rowspan='" & totalSJS & "' onclick=""window.open('TNG_WMS_Type_popup.asp?sjidx=" & sjidx & "&sjsidx=" & cur_sjsidx & "&wms_type=" & wms_type & "','move','width=450,height=520,scrollbars=yes');"" style='cursor:pointer; font-weight:bold;'>"
                trHTML = trHTML & displayInfo & "</td>"
            End If

            trHTML = trHTML & "<td><div class='framename'>" & framename & "<span class='group'> (" & mwidth & " X " & mheight  & ")</span></div></td>"
            trHTML = trHTML & "<td>" & qtyname & " / " & pname & " <span class='bigo'>" & recv_addr & "</span></td>"

            If djnum <> "" AND qtyidx <> 5 Then
                trHTML = trHTML & "<td><span class='djnum-soft'>" & djnum & "</span></td>"
            Else
                trHTML = trHTML & "<td></td>"
            End If

            trHTML = trHTML & "<td>" & sizesHTML & "</td>"

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
                    trHTML = trHTML & "<td onclick=""window.open('TNG_WMS_Bigo_popup.asp?sjidx=" & sjidx & "','move','width=1300,height=520,scrollbars=yes');"" style='cursor:pointer; font-weight:bold; white-space:pre-line; line-height:1.4;'>" & memoText & "</td>"
                Else
                    trHTML = trHTML & "<td onclick=""window.open('TNG_WMS_Bigo_popup.asp?sjidx=" & sjidx & "','move','width=1300,height=520,scrollbars=yes');""></td>"
                End If
            Else
                trHTML = trHTML & "<td onclick=""window.open('TNG_WMS_Bigo_popup.asp?sjidx=" & sjidx & "','move','width=1300,height=520,scrollbars=yes');""></td>"
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
