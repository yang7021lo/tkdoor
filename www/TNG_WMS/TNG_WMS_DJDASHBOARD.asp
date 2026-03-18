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

'========================================
' 공통 유틸
'========================================
Function Clean(v)
    If IsNull(v) Then Clean = "" : Exit Function
    v = Trim(v)
    v = Replace(v, "-", "")
    v = Replace(v, "_", "")
    v = Replace(v, ".", "")
    Clean = v
End Function

' 숫자 x 숫자 패턴 제거 (현재는 사용 안 하지만 남겨둠)
Function CleanNameOnly(bn)
    Dim regEx
    Set regEx = New RegExp
    regEx.Pattern = "^\s*\d+\s*[xX]\s*\d+\s*_?\s*"
    regEx.IgnoreCase = True
    regEx.Global = True
    CleanNameOnly = Trim(regEx.Replace(bn, ""))
End Function

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

Dim Rs, Rs1, Rs2, Rs3, RsC
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
' 0-1. 출력 버퍼
' ============================================================
Dim normalHTML
normalHTML  = ""

' ============================================================
' 0-2. 캐시용 딕셔너리들
' ============================================================
Dim dictSjs, dictDj, dictDetail, dictFks
Set dictSjs    = Server.CreateObject("Scripting.Dictionary")
Set dictDj     = Server.CreateObject("Scripting.Dictionary")
Set dictDetail = Server.CreateObject("Scripting.Dictionary")   ' key = sjsidx
Set dictFks    = Server.CreateObject("Scripting.Dictionary")   ' key = sjsidx

' ============================================================
' 0-3. sjsidx 기반 정보 캐시 (tng_sjaSub + qty + paint)
' ============================================================
Dim SQL_PREF1, RsPref1
Dim ps_sjsidx, ps_framename, ps_qtyname, ps_pname
Dim ps_tmp, ps_bigo, ps_mwidth, ps_mheight, ps_qtyidx, ps_p_image

SQL_PREF1 = ""
SQL_PREF1 = SQL_PREF1 & "SELECT A.sjsidx, A.sjidx, A.framename, "
SQL_PREF1 = SQL_PREF1 & "       G.qtyname, P.pname, P.p_image, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_wichi1, A.asub_wichi2, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_bigo1, A.asub_bigo2, A.asub_bigo3, "
SQL_PREF1 = SQL_PREF1 & "       A.asub_meno1, A.asub_meno2, "
SQL_PREF1 = SQL_PREF1 & "       A.mwidth, A.mheight, A.qtyidx, A.coat "
SQL_PREF1 = SQL_PREF1 & "FROM tng_sjaSub A "
SQL_PREF1 = SQL_PREF1 & "JOIN tk_wms_meta M ON A.sjidx = M.sjidx "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_qty C ON A.qtyidx = C.qtyidx "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_qtyco G ON C.qtyno = G.qtyno "
SQL_PREF1 = SQL_PREF1 & "LEFT JOIN tk_paint P ON A.pidx = P.pidx "
SQL_PREF1 = SQL_PREF1 & "WHERE M.paint_ship_dt = '" & ymd & "' "
SQL_PREF1 = SQL_PREF1 & "  AND A.astatus = '1' "

Set RsPref1 = Dbcon.Execute(SQL_PREF1)

Do Until RsPref1.EOF
    ps_sjsidx    = "" & RsPref1("sjsidx")
    ps_framename = "" & RsPref1("framename")
    ps_qtyname   = "" & RsPref1("qtyname")
    ps_pname     = "" & RsPref1("pname")
    ps_p_image   = "" & RsPref1("p_image")

    ps_tmp = Trim("" & RsPref1("asub_wichi1") & " " & RsPref1("asub_wichi2") & " " & _
                        RsPref1("asub_bigo1") & " " & RsPref1("asub_bigo2") & " " & _
                        RsPref1("asub_bigo3") & " " & RsPref1("asub_meno1") & " " & RsPref1("asub_meno2"))
    ps_bigo = Replace(ps_tmp, "  ", " ")

    ps_mwidth  = RsPref1("mwidth")
    ps_mheight = RsPref1("mheight")
    ps_qtyidx  = RsPref1("qtyidx")
    ps_coat = RsPref1("coat")

    If Not dictSjs.Exists(ps_sjsidx) Then
        dictSjs.Add ps_sjsidx, Array(ps_framename, ps_qtyname, ps_pname, ps_bigo, ps_mwidth, ps_mheight, ps_qtyidx, ps_p_image, ps_coat)
    End If

    RsPref1.MoveNext
Loop
RsPref1.Close : Set RsPref1 = Nothing

' ============================================================
' 0-4. 도장번호 + memo 캐시 (sjsidx 기준, 최신 1건)
' ============================================================
Dim SQL_PREF2, RsPref2
Dim pd_sjsidx, pd_djnum, pd_memo

SQL_PREF2 = ""
SQL_PREF2 = SQL_PREF2 & ";WITH X AS ("
SQL_PREF2 = SQL_PREF2 & "    SELECT "
SQL_PREF2 = SQL_PREF2 & "        D.sjsidx, "
SQL_PREF2 = SQL_PREF2 & "        D.djnum, "
SQL_PREF2 = SQL_PREF2 & "        D.memo, "
SQL_PREF2 = SQL_PREF2 & "        ROW_NUMBER() OVER (PARTITION BY D.sjsidx ORDER BY D.djnum DESC) AS rn "
SQL_PREF2 = SQL_PREF2 & "    FROM tk_wms_djnum D "
SQL_PREF2 = SQL_PREF2 & "    JOIN tk_wms_meta M ON D.sjidx = M.sjidx "
SQL_PREF2 = SQL_PREF2 & "    WHERE M.paint_ship_dt = '" & ymd & "' "
SQL_PREF2 = SQL_PREF2 & ") "
SQL_PREF2 = SQL_PREF2 & "SELECT sjsidx, djnum, memo "
SQL_PREF2 = SQL_PREF2 & "FROM X "
SQL_PREF2 = SQL_PREF2 & "WHERE rn = 1 "
SQL_PREF2 = SQL_PREF2 & "ORDER BY sjsidx"

Set RsPref2 = Dbcon.Execute(SQL_PREF2)

Do Until RsPref2.EOF
    pd_sjsidx = "" & RsPref2("sjsidx")
    pd_djnum  = "" & RsPref2("djnum")
    pd_memo   = "" & RsPref2("memo")

    If Not dictDj.Exists(pd_sjsidx) Then
        dictDj.Add pd_sjsidx, Array(pd_djnum, pd_memo)
    End If

    RsPref2.MoveNext
Loop
RsPref2.Close : Set RsPref2 = Nothing

' ============================================================
' 0-5. tk_wms_detail 캐시 : key = sjsidx
' ============================================================
' ============================================================
' 0-5. tk_wms_detail 캐시 : key = sjsidx
' ============================================================
Dim SQL_DETAIL, RsDet, keyD

SQL_DETAIL = ""
SQL_DETAIL = SQL_DETAIL & "SELECT D.wms_idx, D.sjsidx, D.blength, D.quan, D.bfgroup, D.baname "
SQL_DETAIL = SQL_DETAIL & "FROM tk_wms_detail D "
SQL_DETAIL = SQL_DETAIL & "JOIN tk_wms_meta M ON D.wms_idx = M.wms_idx "
SQL_DETAIL = SQL_DETAIL & "WHERE M.paint_ship_dt = '" & ymd & "' "

Set RsDet = Dbcon.Execute(SQL_DETAIL)

Do Until RsDet.EOF
    ' ★ key = sjsidx 로만 사용 (wms_idx 절대 섞지 않기)
    keyD = CStr(RsDet("sjsidx"))

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
SQL_FKS = SQL_FKS & "WHERE M.paint_ship_dt = '" & ymd & "' AND FS.gls = 0 "

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
<title>📦 WMS 도장 대시보드</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { font-family:'맑은 고딕','Noto Sans KR',sans-serif; font-size:20px; background:#f8f9fa; margin:20px; }

body.drag-on, html.drag-on {
    user-select: text;
    -webkit-user-select: text;
    -moz-user-select: text;
    -ms-user-select: text;
}
body.drag-off, html.drag-off {
    user-select: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
}

.wms-table { width:100%; background:white; border-collapse:collapse; }
.wms-table th, .wms-table td { 
    padding:10px; 
    border-bottom:1px solid #e5e5e5;   
     border-left: 1px solid #e5e5e5;
    border-right: 1px solid #e5e5e5; 
    vertical-align:top;
}
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
    font-size: 20px;
    color: #003380;
    background: #f3f8ff;
    border: 1px solid #ccd9ff;
    padding: 2px 6px;
    border-radius: 3px;
}
.pnamebold {
    font-weight: 700;
    font-size: 23px;
}
.totalbold {
    font-weight: 700;
    font-size: 23px;
    color: #ff0000;
}
.spbold {
    font-weight: 700;
    font-size: 20px;
}

.col-center {
    text-align: center;
    vertical-align: middle !important;
}

.col-left {
    vertical-align: middle !important;
}

</style>
</head>

<body class="p-4 drag-on">

<h3 class="table-title">📦 WMS 도장 대시보드</h3>

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
    <!-- <button type="button" class="btn btn-success" onclick="location.href='TNG_WMS_excel.asp?ymd=<%=ymd%>'">
        📥 엑셀 다운로드
    </button> -->
    <button type="button" class="btn btn-success"
        onclick="location.href='/TNG_WMS/TNG_WMS_DASHBOARD.asp?ymd=<%=ymd%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>'">
        출하대시보드
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
' 1. 메인 조회 : 도장번호(djnum) 기준 정렬
'    → 당신이 원하는 SQL 그대로 사용
' ============================================================
Dim SQL
SQL = ""
SQL = SQL & ";WITH DJ AS ("
SQL = SQL & "    SELECT sjsidx, djnum"
SQL = SQL & "    FROM ("
SQL = SQL & "        SELECT "
SQL = SQL & "            sjsidx,"
SQL = SQL & "            djnum,"
SQL = SQL & "            ROW_NUMBER() OVER (PARTITION BY sjsidx ORDER BY djnum DESC) rn"
SQL = SQL & "        FROM tk_wms_djnum"
SQL = SQL & "    ) X"
SQL = SQL & "    WHERE rn = 1"
SQL = SQL & ") "
SQL = SQL & "SELECT"
SQL = SQL & "      S.sjsidx,"
SQL = SQL & "      S.sjidx,"
SQL = SQL & "      DJ.djnum,"
SQL = SQL & "      C.cname,"
SQL = SQL & "      A.cgset,"
SQL = SQL & "      S.coat"
SQL = SQL & " FROM tng_sjasub S"
SQL = SQL & " JOIN tk_wms_meta M ON S.sjidx = M.sjidx"
SQL = SQL & " JOIN TNG_SJA A      ON S.sjidx = A.sjidx"
SQL = SQL & " JOIN tk_customer C  ON A.sjcidx = C.cidx"
SQL = SQL & " LEFT JOIN DJ        ON S.sjsidx = DJ.sjsidx"
SQL = SQL & " WHERE M.paint_ship_dt = '" & ymd & "'"
SQL = SQL & "   AND DJ.djnum IS NOT NULL"
SQL = SQL & " ORDER BY DJ.djnum, S.sjidx, S.sjsidx"   ' ← 정렬 안정성 위해 2차 정렬 추가


'response.write "SQL : " & SQL & "<br>"
Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
    Do Until Rs.EOF

        rowNo = rowNo + 1

        cur_sjsidx = "" & Rs("sjsidx")
        sjidx      = Rs("sjidx")
        djnum      = "" & Rs("djnum")
        cname      = "" & Rs("cname")
        cgset      = "" & Rs("cgset")   ' (입금후출고 분리 등 필요 시 사용)

        ' ============================================
        ' 1) sjsidx 기반 기본 정보 (재질/품명/이미지/비고)
        ' ============================================
        framename = "" : qtyname = "" : pname = "" : bigo = ""
        mwidth = 0 : mheight = 0 : qtyidx = ""
        paint_img = ""

        If dictSjs.Exists(cur_sjsidx) Then
            Dim arrSjs
            arrSjs    = dictSjs(cur_sjsidx)
            framename = arrSjs(0)
            qtyname   = arrSjs(1)
            pname     = arrSjs(2)
            bigo      = arrSjs(3)
            mwidth    = arrSjs(4)
            mheight   = arrSjs(5)
            qtyidx    = arrSjs(6)
            paint_img = arrSjs(7)
            coat      = arrSjs(8)
        End If

        ' ============================================
        ' 2) 규격 병합 (tk_wms_detail, sjsidx 기준)
        ' ============================================
        sizesHTML = ""
        sumQuan   = 0
        totalquan = 0

        keyD = cur_sjsidx   ' ★ sjsidx 기준

        If dictDetail.Exists(keyD) Then
            Set arrD = dictDetail(keyD)

            Dim combineList(), sizeCount
            ReDim combineList(0) : sizeCount = 0

            For Each row In arrD
                bl2   = CLng(row(0))
                q2    = CLng(row(1))
                rawGp = CStr(row(2))
                rawBn = CStr(row(3))

                gp = Clean(rawGp)
                bn = Clean(rawBn)

                If bl2 > 0 Then
                    merged = False

                    For i = 0 To sizeCount - 1
                        gp0  = Clean(combineList(i)(2))
                        bn0  = Clean(combineList(i)(3))
                        len0 = CLng(combineList(i)(0))

                        sameBn = True
                        If bn <> "" And bn0 <> "" Then sameBn = (bn = bn0)

                        sameGp = True
                        If gp <> "" And gp0 <> "" Then sameGp = (gp = gp0)

                        sameLen = (Abs(len0 - bl2) <= 2)

                        If sameBn And sameGp And sameLen Then
                            combineList(i)(1) = combineList(i)(1) + q2
                            If bl2 > len0 Then combineList(i)(0) = bl2
                            merged = True
                            Exit For
                        End If
                    Next

                    If Not merged Then
                        ReDim Preserve combineList(sizeCount)
                        combineList(sizeCount) = Array(bl2, q2, rawGp, rawBn)
                        sizeCount = sizeCount + 1
                    End If
                End If
            Next

            ' 정렬 (바명 → 길이 → 그룹)
            For x = 0 To sizeCount - 2
                For y = x + 1 To sizeCount - 1
                    a = combineList(x)
                    b = combineList(y)

                    If (Clean(a(3)) = "" And Clean(b(3)) <> "") _
                       Or (Clean(a(3)) = Clean(b(3)) And a(0) > b(0)) _
                       Or (Clean(a(3)) = Clean(b(3)) And a(0) = b(0) And Clean(a(2)) > Clean(b(2))) Then

                        tmp = combineList(x)
                        combineList(x) = combineList(y)
                        combineList(y) = tmp
                    End If
                Next
            Next

            For x = 0 To sizeCount - 1
                If combineList(x)(0) > 0 Then
                    sumQuan = sumQuan + combineList(x)(1)

                    sizesHTML = sizesHTML & "<span style='margin-right:12px;'>"

                    If combineList(x)(3) <> "" Then
                        sizesHTML = sizesHTML & "<b>" & combineList(x)(3) & "</b>&nbsp;"
                    End If

                    sizesHTML = sizesHTML & "<b>" & combineList(x)(0) & "</b> × " & combineList(x)(1)

                    If combineList(x)(2) <> "" Then
                        sizesHTML = sizesHTML & "<span class='group'>(" & combineList(x)(2) & ")</span>"
                    End If

                    sizesHTML = sizesHTML & "</span>"
                End If
            Next

            totalquan = sumQuan
        End If

        ' ============================================
        ' 3) 도장번호 메모 (tk_wms_djnum.memo)
        ' ============================================
        djmemo = ""
        If dictDj.Exists(cur_sjsidx) Then
            Dim arrDj
            arrDj  = dictDj(cur_sjsidx)
            ' djnum = arrDj(0)  ' 메인 SQL에서 이미 가져옴
            djmemo = arrDj(1)
        End If

        ' ============================================
        ' 4) 최종 tr HTML 구성
        ' ============================================
        trHTML = "<tr>"

        ' 순번(#)
        trHTML = trHTML & "<td class='col-center'><span class='djnum-soft'>" & rowNo & "</span></td>"

        ' 재질 (qtyname / pname)
        trHTML = trHTML & "<td class='col-left' onclick=""window.open('/TNG1/TNG1_B.asp?sjcidx=" & rsjcidx & _
        "&sjmidx=" & rsjmidx & "&sjidx=" & sjidx & _
        "&suju_kyun_status=0','_blank');"" style='cursor:pointer;'>" & _
        "<span class='pnamebold'>" & qtyname & "<br>" & pname & "</span></td>"
        
        ' 코트
        Select Case coat
            Case 0
                coat_text = "❌"
            Case 1
                coat_text = "기본(2코트)"
            Case 2
                coat_text = "필수(3코트)"
            Case Else
                coat_text = "?"
        End Select 
        trHTML = trHTML & "<td class='col-center'><span class='djnum-soft'>" & coat_text & "</span></td>"
        
        ' 도장이미지
        If paint_img <> "" Then
            trHTML = trHTML & "<td class='col-center'><img src='" & paint_img & "' style='width:60px; display:block;'></td>"
        Else
            trHTML = trHTML & "<td class='col-center'><img src='/img/paint/' style='width:60px; display:block;'></td>"
        End If

        ' 도장번호
        If djnum <> "" And qtyidx <> 5 Then
            trHTML = trHTML & "<td class='col-center'><span class='djnum-soft'>" & djnum & "</span></td>"
        Else
            trHTML = trHTML & "<td></td>"
        End If

        ' 총수량 (sjsidx 한 건 기준)
        If totalquan > 0 Then
            trHTML = trHTML & "<td class='col-center'><span class='totalbold'>" & totalquan & "개</span></td>"
        Else
            trHTML = trHTML & "<td></td>"
        End If

        ' 규격 × 길이
        If sizesHTML <> "" Then
            trHTML = trHTML & "<td>" & sizesHTML & "</td>"
        Else
            trHTML = trHTML & "<td></td>"
        End If

        ' 거래처명
        trHTML = trHTML & "<td class='col-center'><span class='spbold' >" & cname & "</span></td>"

        ' 품목명(검측)
        trHTML = trHTML & "<td class='col-left'><span class='spbold'>" & framename & "</span></td>"

        ' 비고 (도장번호 메모)
        If djmemo <> "" Then
            trHTML = trHTML & "<td class='col-left' onclick=""window.open('TNG_WMS_Bigo_Djpopup.asp?sjsidx=" & cur_sjsidx & "','move','width=1300,height=520,scrollbars=yes');"" style='cursor:pointer; font-weight:bold; white-space:pre-line; line-height:1.4;'><span class='spbold'>" & djmemo & "</span></td>"
        Else
            trHTML = trHTML & "<td class='col-left'onclick=""window.open('TNG_WMS_Bigo_Djpopup.asp?sjsidx=" & cur_sjsidx & "','move','width=1300,height=520,scrollbars=yes');""></td>"
        End If

        trHTML = trHTML & "</tr>"

        ' ★ 도장대시보드는 일반/특이 나누지 않고 한 버퍼만 사용
        normalHTML = normalHTML & trHTML

        Rs.MoveNext
    Loop
End If

Rs.Close
%>

<table class="wms-table">
<thead>
<tr style="background:#eef4ff;">
    <th style="width:2%;">#</th>
    <th style="width:12%;">재질</th>
    <th style="width:8%;">코트</th>
    <th style="width:5%;">도장이미지</th>
    <th style="width:5%;">도장번호</th>
    <th style="width:5%;">총수량</th>
    <th style="width:28%;">규격 (길이 × 수량)</th>
    <th style="width:11%;">거래처명</th>
    <th style="width:13%;">품목명(검측)</th>
    <th style="width:9%;">비고</th>
</tr>
</thead>
<tbody>
    <%= normalHTML %>
</tbody>
</table>

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
