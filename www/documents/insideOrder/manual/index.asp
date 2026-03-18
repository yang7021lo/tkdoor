<%@ Language="VBScript" CodePage="65001" %>
<%
'Option Explicit
Response.Charset = "utf-8"

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


' -------------------------------
' 세션 파라미터 (어쩔수읎어)
' -------------------------------
Dim rfkidx, sjidx, sjsidx
rfkidx = Session("insideOrder.fkidx")
sjidx = Session("insideOrder.sjidx")
sjsidx = Session("insideOrder.sjsidx")

' ----------------------------
' 유틸
' ----------------------------

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
' "YYYY-MM-DD" (뒤에 시간 있으면 무시) → "일/월/화/수/목/금/토"
Function KDowFromYMD(ymd)
  Dim s, a, y, m, d, dt, idx
  s = Trim("" & ymd)
  If InStr(s, " ") > 0 Then s = Left(s, InStr(s, " ") - 1)

  a = Split(s, "-")
  If UBound(a) <> 2 Then KDowFromYMD = "" : Exit Function

  On Error Resume Next
  y = CLng(a(0)) : m = CLng(a(1)) : d = CLng(a(2))
  dt = DateSerial(y, m, d)
  If Err.Number <> 0 Then Err.Clear : KDowFromYMD = "" : Exit Function
  On Error GoTo 0

  idx = Weekday(dt, vbSunday) - 1 ' 0=일
  KDowFromYMD = Array("일","월","화","수","목","금","토")(idx)
End Function
%>
<%
Dim SQL, Rs
Set Rs = Server.CreateObject("ADODB.Recordset")

Call dbOpen()  ' Dbcon.Open 포함된 함수 호출

'==== 화물 정보 불러오기 시작 

SQL = "SELECT dsidx, ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
SQL = SQL & "ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_costyn, ds_to_prepay, "
SQL = SQL & "dsmidx, dswdate, dsmeidx, dswedate, dsstatus, sjidx "
SQL = SQL & "FROM tk_daesin "
SQL = SQL & "WHERE sjidx = '" & sjidx & "' AND dsstatus = 1"
'Response.write (SQL)&"<br><br>"
'response.end
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    dsidx         = Rs(0)
    ds_daesinname = Rs(1)
    ds_daesintel  = Rs(2)
    ds_daesinaddr = Rs(3)
    dsdate        = Rs(4)
    dsmemo        = Rs(5)

    ds_to_num     = Rs(6)
    ds_to_name    = Rs(7)
    ds_to_tel     = Rs(8)
    ds_to_addr    = Rs(9)
    ds_to_costyn  = Rs(10)
    ds_to_prepay  = Rs(11)

    dsmidx        = Rs(12)
    dswdate       = Rs(13)
    dsmeidx       = Rs(14)
    dswedate      = Rs(15)
    dsstatus      = Rs(16)
    dssjidx       = Rs(17)
End If
Rs.Close

'==== 용차 정보 불러오기 시작 

SQL=" Select yidx, yname, ytel, yaddr, ydate, ymemo "
SQL=SQL&", ycarnum, ygisaname, ygisatel, ycostyn, yprepay, ystatus "
SQL=SQL&" , ymidx, ywdate, ymeidx, ywedate "
SQL=SQL&" From tk_yongcha " 
SQL=SQL&" Where sjidx='"&sjidx&"' and ystatus=1 "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      yidx=Rs(0)
      yname=Rs(1)
      ytel=Rs(2)
      yaddr=Rs(3) '하자지주소
      ydate=Rs(4)
      
      ymemo=Rs(5)
      ycarnum=Rs(6)
      ygisaname=Rs(7)
      ygisatel=Rs(8)
      ycostyn=Rs(9)
      yprepay=Rs(10)
      ystatus=Rs(11)
      ymidx=Rs(12)
      ywdate=Rs(13)
      ymeidx=Rs(14)
      ywedate=Rs(15)
    End if
    RS.Close
%>
<%
' ==========================================
' 🎯 fks 그룹 수량 (gls=0 + whichi_auto 1,2 묶기 + 8,9,24 세트 묶기 + whichi_auto=0 이면 WHICHI_FIX로 대체)
' ==========================================
' ==========================================
' 🎯 fks 그룹 수량 계산
'   - gls=0 전체 row 조회
'   - AUTO 1,2 → 1 묶음
'   - AUTO 8,9,24 → blength 기준으로 묶음
'   - FIX (whichi_auto=0 AND whichi_fix≠0) → 묶지 않고 개별 카운트
' ==========================================
' ==========================================
' 🎯 fks 그룹 수량 계산 (새 버전)
'   - gls=0 전체 row 조회
'   - AUTO 1,2 짝(±2mm, 같은 fkidx) → 묶어서 카운트
'   - AUTO 8,9,24 → 8 우선, 없으면 9, 마지막 24 단독
'   - FIX / 기타 AUTO → 그냥 개수
' ==========================================

' 1) 기본 변수
fksCount     = 0
fixCount     = 0
otherCount   = 0
auto12Count  = 0
autoSetCount = 0

Set auto12List = CreateObject("Scripting.Dictionary") ' key: idx, value: fkidx|bl|waa
Set autoSetList = CreateObject("Scripting.Dictionary") ' key: idx, value: fkidx|bl|waa

' 2) 전체 fks 로우 가져오기
SQLfks = ""
SQLfks = SQLfks & "SELECT fkidx, whichi_auto, whichi_fix, blength "
SQLfks = SQLfks & "FROM tk_framekSub "
SQLfks = SQLfks & "WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE sjsidx=" & CLng(sjsidx) & ") "
SQLfks = SQLfks & "  AND gls = 0 "

' 디버그
'Response.Write "<pre>" & SQLfks & "</pre>"

Set rsFksAll = Dbcon.Execute(SQLfks)

Do Until rsFksAll.EOF

    fkidx = CLng(rsFksAll("fkidx"))
    waa   = CLng(rsFksAll("whichi_auto"))
    wfix  = CLng(rsFksAll("whichi_fix"))
    bl    = CLng(rsFksAll("blength"))

    ' 🔸 AUTO 1,2 → 나중에 짝 맞추기
    If waa = 1 Or waa = 2 Then

        idxKey = CStr(auto12List.Count)
        auto12List.Add idxKey, fkidx & "|" & bl & "|" & waa

    ' 🔸 AUTO 8,9,24 → 나중에 세트 계산
    ElseIf waa = 8 Or waa = 9 Or waa = 24 Then

        idxKey = CStr(autoSetList.Count)
        autoSetList.Add idxKey, fkidx & "|" & bl & "|" & waa

    ' 🔸 FIX (AUTO=0, FIX>0) → 그냥 1개씩
    ElseIf waa = 0 And wfix <> 0 Then

        fixCount = fixCount + 1

    ' 🔸 나머지 AUTO (5,6,7 등) → 그냥 1개씩
    Else

        otherCount = otherCount + 1

    End If

    rsFksAll.MoveNext
Loop

rsFksAll.Close : Set rsFksAll = Nothing

' ==========================================
' 🎯 3) AUTO 1,2 처리 (±2mm, fkidx 기준)
' ==========================================
n12 = auto12List.Count

If n12 > 0 Then

    ReDim arrFk12(n12-1)
    ReDim arrBl12(n12-1)
    ReDim arrType12(n12-1)
    ReDim used12(n12-1)

    i = 0
    For Each k In auto12List.Keys
        parts = Split(auto12List(k), "|")
        arrFk12(i)   = CLng(parts(0)) ' fkidx
        arrBl12(i)   = CLng(parts(1)) ' blength
        arrType12(i) = CLng(parts(2)) ' whichi_auto (1 or 2)
        used12(i)    = False
        i = i + 1
    Next

    ' 🔹 1 기준으로 2를 한 번씩 매칭 (같은 fkidx + ±2mm)
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

            auto12Count = auto12Count + 1   ' 1+2 묶음 1개
        End If
    Next

    ' 🔹 매칭되지 않은 2는 단독으로 1개씩
    For i = 0 To n12-1
        If arrType12(i) = 2 And (Not used12(i)) Then
            used12(i) = True
            auto12Count = auto12Count + 1
        End If
    Next

End If

' ==========================================
' 🎯 4) AUTO 8,9,24 세트 처리 (fkidx 기준)
'   - 8 우선 → 9,24 붙여서 세트 하나
'   - 8 없으면 9 → 24 붙여서 세트
'   - 나머지 24 → 단독 1개
'   - 같은 8 이 여러 row면 그 개수만큼 세트(묶지 않음)
' ==========================================
nSet = autoSetList.Count

If nSet > 0 Then

    ReDim arrFkSet(nSet-1)
    ReDim arrBlSet(nSet-1)
    ReDim arrTypeSet(nSet-1)
    ReDim usedSet(nSet-1)

    i = 0
    For Each k In autoSetList.Keys
        parts = Split(autoSetList(k), "|")
        arrFkSet(i)   = CLng(parts(0))
        arrBlSet(i)   = CLng(parts(1))
        arrTypeSet(i) = CLng(parts(2))  ' 8,9,24
        usedSet(i)    = False
        i = i + 1
    Next

    ' 🔹 1단계: 8 기준 세트
    For i = 0 To nSet-1
        If arrTypeSet(i) = 8 And (Not usedSet(i)) Then

            fkBase = arrFkSet(i)
            blBase = arrBlSet(i)
            usedSet(i) = True

            ' 같은 fkidx + ±2mm 범위의 9,24 모두 소모
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

    ' 🔹 2단계: 남은 9 기준 세트
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

    ' 🔹 3단계: 남은 24 단독
    For i = 0 To nSet-1
        If arrTypeSet(i) = 24 And (Not usedSet(i)) Then
            usedSet(i) = True
            autoSetCount = autoSetCount + 1
        End If
    Next

End If

' ==========================================
' 🎯 5) 최종 수량
' ==========================================
fksCount = fixCount + otherCount + auto12Count + autoSetCount

' Response.Write "fixCount     = " & fixCount & "<br>"
' Response.Write "otherCount   = " & otherCount & "<br>"
' Response.Write "auto12Count  = " & auto12Count & "<br>"
' Response.Write "autoSetCount = " & autoSetCount & "<br>"
' Response.Write "<b>최종수량 = " & fksCount & "</b><br>"

%>
<%
SQL = ""
SQL = SQL & "SELECT DISTINCT " & _
            " fk.fkidx      AS fk_idx," & _
            " fk.sjb_type_no      AS frame_type," & _
            " fk.ow         AS fk_ow," & _
            " fk.oh         AS fk_oh," & _
            " fk.tw         AS fk_tw," & _
            " fk.th         AS fk_th," & _
            " (SELECT COUNT(*) " & _
            "      FROM tng_sjaSub s2 " & _
            "     WHERE s2.sjidx = sas.sjidx " & _
            "       AND s2.astatus = '1' " & _
            "       AND s2.sjsidx <= sas.sjsidx " & _
            " ) AS sunno, " & _
            " CHOOSE(ISNULL(fk.dooryn,0)+1, N'도어나중', N'도어같이', N'도어안함') AS fk_dooryn," & _
            " sa.cgaddr     AS sa_addr," & _
            " sa.djcgdate   AS sa_djcgdate," & _
            " sa.cgdate     AS sa_cgdate," & _
            " CASE WHEN sa.cgtype BETWEEN 1 AND 16 " & _
            "      THEN CHOOSE(sa.cgtype, N'화물', N'낮1배달_신두영(인천,고양)', N'낮2배달_최민성(경기)', N'밤1배달_윤성호(수원,천안,능력)', N'밤2배달_김정호(하남)', N'대구창고', N'대전창고', N'부산창고', N'양산창고', N'익산창고', N'원주창고', N'제주창고', N'용차', N'방문', N'1공장', N'인천항')" & _
            "      ELSE N'미지정' END AS sa_cgtype," & _
            " sa.sjdate     AS sa_sjdate," & _
            " sa.sjnum      AS sa_sjnum," & _
            " c.cname       AS c_name," & _
            " sas.mwidth    AS sas_mwidth," & _
            " sas.mheight   AS sas_mheight," & _
            " sas.quan      AS sas_quan," & _
            " sas.asub_wichi1 AS asub_wichi1," & _
            " sas.asub_wichi2 AS asub_wichi2," & _
            " sas.asub_bigo1  AS asub_bigo1," & _
            " sas.asub_bigo2  AS asub_bigo2," & _
            " sas.asub_bigo3  AS asub_bigo3," & _
            " sas.asub_meno1  AS asub_meno1," & _
            " sas.asub_meno2  AS asub_meno2," & _
            " f.fname       AS f_name," & _
            " q.qtyname     AS q_name," & _
            " p.pname       AS p_name," & _
            " p.p_image     AS p_image," & _
            " sb.SJB_barlist + ' ' + sbt.SJB_TYPE_NAME AS framename," & _
            " q.qtyidx      AS qtyidx," & _
            " p.pidx        AS pidx," & _
            " sas.midx, D.mname AS writer_name, " & _              
            " sas.meidx, E.mname AS checker_name " & _             
            "FROM tk_framek      fk " & _
            "LEFT JOIN TNG_SJA   sa   ON sa.sjidx      = fk.sjidx " & _
            "LEFT JOIN tk_customer c   ON c.cidx        = sa.sjcidx " & _
            "LEFT JOIN tng_sjaSub sas  ON sas.sjsidx    = fk.sjsidx " & _
            "LEFT JOIN tk_member D ON sas.midx = D.midx " & _      
            "LEFT JOIN tk_member E ON sas.meidx = E.midx " & _     
            "LEFT JOIN tk_frame    f   ON f.fidx        = fk.fidx " & _
            "LEFT JOIN tk_paint    p   ON p.pidx        = sas.pidx " & _
            "LEFT JOIN tk_qty      q   ON q.qtyidx      = sas.qtyidx " & _
            "LEFT JOIN tng_sjb     sb  ON sb.sjb_idx    = fk.sjb_idx " & _
            "LEFT JOIN tng_sjbtype sbt ON sbt.SJB_TYPE_NO = sb.SJB_TYPE_NO " & _
            "WHERE fk.fkidx = " & CLng(rfkidx)
' 필요하면 sjidx도 함께 고정:
' SQL = SQL & " AND fk.sjidx = '" & sjidx & "'"



Rs.Open SQL, Dbcon, 0, 1

Dim total_count
total_count = Rs("sas_quan")


' 섹션 색상 칠하는 함수
Dim ft, bgClass, frame_type_name
ft = Rs("frame_type")
Select Case ft
  Case "3","7"       ' 초록 배경
    bgClass = "bg-green "
    frame_type_name = "단열"
  Case "1","2","6"   ' 핑크 배경
    bgClass = "bg-pink"
    frame_type_name = "일반"
  Case "4","5"       ' 빨강 배경
    bgClass = "bg-red "
    frame_type_name = "삼중"
  Case Else
    bgClass = ""     ' 기본
End Select

cgtype = rs("sa_cgtype")  ' 컬럼명이 sa_cgtype임

If cgtype = "화물" Then
    ' 비어있으면 기본 주소 사용
    If Trim(sa_cgtype) = "" Then
        cgtype = ds_daesinaddr
    End If

    ' 이미 "대신화물"로 끝나면 그대로 두고, 아니면 추가
    If Right(Trim(cgtype), 4) <> "대신화물" Then
        cgtype = cgtype & "_대신화물"
    End If
elseif cgtype = "용차"  Then

    cgtype = "용차" & "_" & yaddr

End If

asub_total = Rs("asub_wichi1") & "  " & Rs("asub_wichi2") & " / " & _
             Rs("asub_bigo1")  & "  " & Rs("asub_bigo2")  & "  " & _
             Rs("asub_bigo3")  & "  " & Rs("asub_meno1")  & "  " & Rs("asub_meno2")

%>

    <div class="a4-wrap">
        <div id="page" class="page">
            <!-- (간소) 상단 타이틀만 남기고, 기존 헤더는 아래 풋터로 이동 -->
            <h1 class="top-title">
            티엔지-수동
            <span class="top-remark" style="margin-left:20px;"></span>
            </h1>
            <tr>
                <td class="kv" colspan="3">
                    <span class="k <%= font_color %>">위치:비고</span>
                    <span class="v">
                    <span style="color:red;"><%=asub_total%></span><%=Rs("checker_name")%>님
                    </span>
                </td>
            </tr>
      <!-- ===== 스케일 대상 콘텐츠 시작 ===== -->
      <div id="content" class="content-fit">
        <!-- 메타 정보 3열 (콤팩트) -->
        <section class="no-break <%= bgClass %>">
            <table class="table-sm table-bordered table-fixed mb-2">
              <colgroup><col span="3" style="width:33.333%"></colgroup>
              <tbody>
                <tr>
                  <td class="kv"><span class="k">발주처</span><span class="v"><%=Rs("c_name")%></span></td>
                  <td class="kv">
                    <span class="k">수주일자</span>
                    <span class="v">
                        <%= Server.HTMLEncode(Rs("sa_sjdate")) %>
                        (<%= KDowFromYMD(Rs("sa_sjdate")) %>)
                    </span>
                  </td>  
                  <td class="kv"><span class="k">수주번호</span><span class="v"><%=Rs("sa_sjnum")%>__No<%=rs("sunno")%></span></td>
                </tr>
                <tr>
                  <td class="kv"><span class="k">현장명</span><span class="v"><%=Rs("sa_addr")%></span></td>
                  <td class="kv">
                    <span class="k">출고일자</span>
                    <span class="v">
                        <%= Server.HTMLEncode(Rs("sa_cgdate")) %>
                        (<%= KDowFromYMD(Rs("sa_cgdate")) %>)
                    </span>
                  </td>  
                  <td class="kv">
                    <span class="k">도장출고일자</span>
                    <span class="v">
                        <%= Server.HTMLEncode(Rs("sa_djcgdate")) %>
                        (<%= KDowFromYMD(Rs("sa_djcgdate")) %>)
                    </span>
                  </td>   
                </tr>
                <tr>
                  <td class="kv"><span class="k">출고방식</span><span class="v"><%=cgtype%></span></td>
                  <td class="kv"><span class="k">수량</span><span class="v"><%=Rs("sas_quan")%>개</span></td>
                  <td class="kv"><span class="k">재질/도어</span><span class="v"><%=Rs("q_name")%> · 수동타입</span></td>
                </tr>
                <tr>
                  <td class="kv"><span class="k">검측</span><span class="v"><%=Rs("sas_mwidth")%> × <%=Rs("sas_mheight")%>_묶음<%=fksCount%>개</span></td>
                  <td class="kv"><span class="k">오픈</span><span class="v">수동타입</span></td>
                  <td class="kv"><span class="k">색상</span><span class="v"><%=Rs("p_name")%></span></td>
                </tr>
                <tr>
                  <td class="kv" colspan="2"><span class="k <%= font_color %>">프레임타입</span><span class="v"><%=Rs("framename")%>&nbsp<%=Rs("f_name")%></span></td>
                  <td class="td-fitimg">
                    <img src="/img/paint/<%=Rs("p_image")%>" alt="색상 미리보기 없음">
                  </td>
                </tr>
              </tbody>
            </table>
          </section>

<%
Rs.Close
Set Rs = Nothing
%>

<!-- 도면 (SVG) -->
<section class="section drawing wrap no-break">
  <%
      Session("autoSchema.sjidx")  = sjidx
      Session("autoSchema.sjsidx") = sjsidx

      Server.Execute "/schema/export/manual/index.asp"
  %>
</section>


<style>
/* 테이블 기본 */
.table-fixed {
  table-layout: fixed;  /* 고정 레이아웃 → 균등 분배 */
  width: 100%;
}

/* 테이블 헤더 패딩 줄이기 */
.table-fixed th {
  padding-top: 2px;
  padding-bottom: 2px;
  padding-left: 4px;
  padding-right: 4px;
  font-size: 12px;    /* 필요하면 폰트도 살짝 줄임 */
  line-height: 1.2;   /* 줄 간격도 압축 */
}


/* 품명 칸: 줄바꿈 허용 */
.table-fixed td.name,
.table-fixed th.name {
  white-space: normal;   /* 줄바꿈 허용 */
  word-break: break-word; /* 긴 단어도 강제 줄바꿈 */
  vertical-align: top;    /* 여러 줄일 때 위쪽 정렬 */
  font-size: 13px;        /* 필요시 크기 조절 */
  line-height: 1.4;       /* 줄 간격 조금 여유 */
}

/* 숫자 칸은 중앙 정렬 */
.table-fixed td.text-num,
.table-fixed th.text-num {
  text-align: center;
  white-space: nowrap;  /* 숫자는 줄바꿈 안되도록 */
}

  /* 고정 레이아웃 + 전체 폭 */
  .table-fixed { table-layout: fixed; width: 100%; }

  /* 1세트(4칸)가 정확히 50% 차지 → 2세트 = 100% */
  col.c-name { width: 25%; }     /* 자재명 */
  col.c-len  { width: 12.5%; }   /* 절단길이 */
  col.c-qty  { width: 6.25%; }   /* 수량 */

  /* 한 줄 표시 + 넘치면 … 처리 */
  .table.table-fixed th,

  /* 숫자 우측 정렬 */
  .text-num { text-align: right; }

.row.as-columns {
  display: block !important;        /* .row의 flex 끄기 */
  column-count: 2;                  /* 정확히 2열 */
  column-gap: 0.5rem;               /* g-2 간격 느낌 */
}

/* 아이템이 컬럼 경계에서 쪼개지지 않도록 + flex 속성 무력화 */
.row.as-columns > .col {
  break-inside: avoid;
  -webkit-column-break-inside: avoid;
  -moz-column-break-inside: avoid;

  display: block;
  width: 100%;
  max-width: 100% !important;
  flex: none !important;            /* .col의 flex-basis:0 등 무력화 */
  margin: 0 0 0.5rem;               /* 카드 간 간격 */
}
</style>

        <!-- 품목표 (6열) -->
<section class="section">
<!-- 리스트: 1열(모바일) / 2열(md~) -->
<div class="row as-columns g-2">
<%
' ===== 유틸 =====
Function NormName(s)
  Dim t : t = Trim("" & s)
  t = Replace(t, vbCr, "") : t = Replace(t, vbLf, "")
  t = Replace(t, ChrW(&H3000), " ")
  Do While InStr(t, "  ") > 0: t = Replace(t, "  ", " ") : Loop
  t = Replace(t, "–", "-") : t = Replace(t, "—", "-") : t = Replace(t, "―", "-")
  NormName = t
End Function

Function NormMM(v)
  Dim s, p
  s = Trim("" & v)
  s = Replace(s, ",", "")
  s = Replace(s, "㎜", "")
  s = Replace(s, "mm", "")
  p = InStr(s, ".")
  If p > 0 Then s = Left(s, p - 1)
  s = Trim(s)
  If s = "" Then s = "0"
  NormMM = s
End Function

Dim unitQty : unitQty = 1

' ===== SQL =====
Dim sql2, cmd2, rs2
sql2 = ""
sql2 = sql2 & _
  "SELECT " & _
  "  fk.blength                      AS blength, " & _
  "  fk.set_name                 AS set_name, " & _
  "  fk.door_location                  AS door_location, " & _
  "  fk.whichi                   AS whichi, " & _
  "  fk.busok1     AS busok1, " & _
  "  fk.busok1_name               AS busok1_name, " & _
  "  fk.busok2     AS busok2, " & _
  "  fk.busok2_name               AS busok2_name, " & _
  "  fk.set_name AS zip_name_FIX "& vbCrLf & _
  "FROM tkd001.v_framek_busok AS fk " & vbCrLf & _
  "WHERE sjsidx = ? AND gls = 0" & _
  "ORDER BY fk.whichi"
Set cmd2 = Server.CreateObject("ADODB.Command")
Set cmd2.ActiveConnection = Dbcon
cmd2.CommandType = 1
cmd2.CommandText  = sql2
cmd2.Parameters.Append cmd2.CreateParameter("@p_sjsidx", 200, 1, 50, ("" & sjsidx))
Set rs2 = cmd2.Execute

If rs2.EOF Then
%>
  <div class="col">
    <div class="alert alert-light border text-center mb-0">데이터가 없습니다.</div>
  </div>
<%
Else
' === 1) 집계용 딕셔너리 ===
Dim agg : Set agg = Server.CreateObject("Scripting.Dictionary")

Do Until rs2.EOF
  Dim nm, mm, wa, busok1, busok2, busok1_name, busok2_name
  Dim busok_name, busok_count, door_location, qtyRow

  nm = NormName(rs2("zip_name_FIX")) : If nm = "" Then nm = "AL 프레임"
  mm = NormMM(rs2("blength"))
  wa = Trim("" & rs2("whichi"))

  busok1      = rs2("busok1")
  busok2      = rs2("busok2")
  busok1_name = rs2("busok1_name")
  busok2_name = rs2("busok2_name")

  door_location = Trim("" & rs2("door_location"))

  busok_name  = "" : busok_count = 0
  If (Not IsNull(busok1)) And (Not IsNull(busok2)) And (busok1 = busok2) _
     And (Len(Trim("" & busok1_name)) > 0) Then
    busok_name  = "" & busok1_name
    busok_count = 2
  ElseIf IsNull(busok2) And (Not IsNull(busok1)) _
     And (Len(Trim("" & busok1_name)) > 0) Then
    busok_name  = "" & busok1_name
    busok_count = 1
  End If

  ' === 수량(행 기준) ===
  qtyRow = unitQty * total_count  ' 기존 로직 유지(외부 스코프의 total_count 사용)

  ' === 키: 자재명 + 길이 + 도어방향 + 부속구성 ===
  Dim key : key = nm & "|" & mm & "|" & door_location & "|" & busok_name & "|" & CStr(busok_count)

  If Not agg.Exists(key) Then
    Dim it : Set it = Server.CreateObject("Scripting.Dictionary")
    it("nm")            = nm
    it("mm")            = mm
    it("door_location") = door_location
    it("busok_name")    = busok_name
    it("busok_count")   = busok_count
    it("qty")           = CLng(qtyRow)
    agg.Add key, it
  Else
    Dim it2 : Set it2 = agg(key)
    it2("qty") = CLng(it2("qty")) + CLng(qtyRow)

    ' 부속명이 섞여 들어오면 표시는 비움
    If Trim(it2("busok_name")) <> Trim(busok_name) Then
      it2("busok_name")  = ""
      it2("busok_count") = 0
    End If
  End If

  rs2.MoveNext
Loop

' === 2) 렌더링 ===
Dim k
For Each k In agg.Keys
  Dim row : Set row = agg(k)

  Response.Write "<div class=""col"">"
  Response.Write   "<div class=""card shadow-sm h-100"">"
  Response.Write     "<div class=""card-body py-2"">"

  ' 본문
  Response.Write       "<div class=""row g-2 align-items-center"">"

  ' 자재명(+부속)
  Response.Write         "<div class=""col fw-semibold"">" & Server.HTMLEncode(row("nm"))
  If Len(Trim(row("busok_name"))) > 0 And CLng(row("busok_count")) > 0 Then
    Response.Write "<br><span class=""text-body-secondary small"">" _
                 & Server.HTMLEncode(row("busok_name")) _
                 & "(" & CInt(row("busok_count")) & ")</span>"
  End If
  Response.Write         "</div>"

    ' 도어방향
  Response.Write         "<div class=""col-auto text-end fs-4""><span class=""badge text-bg-dark"">" _
                       & Server.HTMLEncode(row("door_location")) & "</span></div>"

  ' 절단길이
  Response.Write         "<div class=""col-auto text-end fs-4""><span class=""badge text-bg-light border"">" _
                       & row("mm") & "mm</span></div>"

  ' 수량(집계결과)
  Response.Write         "<div class=""col-auto text-end fs-4""><span class=""badge text-bg-dark"">" _
                       & CLng(row("qty")) & "</span></div>"

  Response.Write       "</div>" ' row
  Response.Write     "</div>"   ' card-body
  Response.Write   "</div>"     ' card
  Response.Write "</div>"       ' col
Next
End If

If Not rs2 Is Nothing Then If rs2.State <> 0 Then rs2.Close
Set rs2 = Nothing : Set cmd2 = Nothing
%>
</div>

</section>

      </div>

      <!-- ===== 스케일 대상 콘텐츠 끝 ===== -->
    </div>
  </div>
