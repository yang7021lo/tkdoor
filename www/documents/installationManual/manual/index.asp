<%@ Language="VBScript" CodePage="65001" %>
<%
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
rfkidx = Session("installationManual.fkidx")
sjidx = Session("installationManual.sjidx")
sjsidx = Session("installationManual.sjsidx")

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



  <div class="a4-wrap">
    <div id="page" class="page">
      <!-- (간소) 상단 타이틀만 남기고, 기존 헤더는 아래 풋터로 이동 -->
<%
Dim SQL, Rs
Set Rs = Server.CreateObject("ADODB.Recordset")

Call dbOpen()  ' Dbcon.Open 포함된 함수 호출

SQL = ""
SQL = SQL & "SELECT DISTINCT " & _
            " fk.fkidx      AS fk_idx," & _
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
            " sa.cgtype     AS cgtype," & _
            " CASE WHEN sa.cgtype BETWEEN 1 AND 12 " & _
            "      THEN CHOOSE(sa.cgtype, N'화물', N'낮1배달', N'낮2배달', N'밤1배달', N'밤2배달', N'대구창고', N'대전창고', N'부산창고', N'양산창고', N'익산창고', N'원주창고', N'제주창고')" & _
            "      ELSE N'미지정' END AS sa_cgtype," & _
            " sa.sjdate     AS sa_sjdate," & _
            " sa.sjnum      AS sa_sjnum," & _ 
            " c.cname       AS c_name," & _
            " sas.mwidth    AS sas_mwidth," & _
            " sas.mheight   AS sas_mheight," & _
            " sas.framename   AS sas_fullname," & _
            " sas.quan      AS sas_quan," & _
            " sas.asub_wichi1      AS loc1," & _
            " sas.asub_wichi2      AS loc2," & _
            " sas.asub_bigo1      AS bigo1," & _
            " sas.asub_bigo2      AS bigo2," & _
            " sas.asub_bigo3      AS bigo3," & _
            " f.fname       AS f_name," & _
            " fk.qtyidx     AS q_idx," & _
            " qc.qtyname     AS q_name," & _
            " p.pname       AS p_name," & _
            " p.p_image       AS p_image," & _
            " sb.SJB_barlist + ' ' + sbt.SJB_TYPE_NAME AS framename " & _
            "FROM tk_framek      fk " & _
            "LEFT JOIN TNG_SJA   sa  ON sa.sjidx  = fk.sjidx " & _
            "LEFT JOIN tk_customer c ON c.cidx    = sa.sjcidx " & _
            "LEFT JOIN tng_sjaSub sas ON sas.sjsidx = fk.sjsidx " & _
            "LEFT JOIN tk_frame    f  ON f.fidx    = fk.fidx " & _
            "LEFT JOIN tk_paint    p  ON p.pidx    = sas.pidx " & _
            "LEFT JOIN tk_qty      q  ON q.qtyidx  = fk.qtyidx " & _
            "LEFT JOIN tk_qtyco      qc  ON qc.qtyno  = q.qtyno " & _
            "LEFT JOIN tng_sjb     sb  ON sb.sjb_idx  = fk.sjb_idx " & _
            "LEFT JOIN tng_sjbtype     sbt  ON sbt.SJB_TYPE_NO  = sb.SJB_TYPE_NO " & _
            "WHERE sas.sjsidx = " & CLng(sjsidx)
' 필요하면 sjidx도 함께 고정:
' SQL = SQL & " AND fk.sjidx = '" & sjidx & "'"



Rs.Open SQL, Dbcon, 0, 1
'response.write (SQL)&"<br>"
Dim total_count
total_count = Rs("sas_quan")



Select Case Rs("cgtype")
  Case "1" :  cgtype_text = "화물"
  Case "2" :  cgtype_text = "낮1배달_신두영(인천,고양)"
  Case "3" :  cgtype_text = "낮2배달_최민성(경기)"
  Case "4" :  cgtype_text = "밤1배달_윤성호(수원,천안,능력)"
  Case "5" :  cgtype_text = "밤2배달_김정호(하남)"
  Case "6" :  cgtype_text = "대구창고"
  Case "7" :  cgtype_text = "대전창고"
  Case "8" :  cgtype_text = "부산창고"
  Case "9" :  cgtype_text = "양산창고"
  Case "10":  cgtype_text = "익산창고"
  Case "11":  cgtype_text = "원주창고"
  Case "12":  cgtype_text = "제주창고"
  Case "13":  cgtype_text = "용차"
  Case "14":  cgtype_text = "방문"
  Case "15":  cgtype_text = "1공장"
  Case "16":  cgtype_text = "인천항"
  Case Else
    cgtype_text = "미지정"
End Select


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



  <div class="d-flex flex-column flex-md-row align-items-start align-items-md-end justify-content-between">
    <!-- 왼쪽: 타이틀 -->
    <h1 class="top-title">티엔지 프레임 시공도</h1>

    <!-- 오른쪽: 현장주소 -->
    <div class="text-md-end">
      <div class="fw-semibold small">현장주소</div>
      <span class="d-inline-block text-truncate text-primary" style="max-width: 48ch;">
        <%=Rs("sa_addr")%> <%=Rs("loc1")%> <%=Rs("loc2")%> <%=Rs("bigo1")%> <%=Rs("bigo2")%> <%=Rs("bigo3")%>
      </span>
    </div>
  </div>

      <!-- ===== 스케일 대상 콘텐츠 시작 ===== -->
      <div id="content" class="content-fit">
        <!-- 메타 정보 3열 (콤팩트) -->
 <section class="no-break">
    <table class="table table-sm table-bordered table-fixed mb-2">
      <colgroup><col span="3" style="width:33.333%"></colgroup>
      <tbody>
        <tr>
        <td class="kv"><span class="k">발주처</span><span class="v" id="company"><%=Rs("c_name")%></span></td>
          <td class="kv"><span class="k">재질/도어</span><span class="v"><%=Rs("q_name")%> · <%=Rs("fk_dooryn")%></span></td>
          <td class="kv"><span class="k">수주번호</span><span class="v" id="suju_num"><%=Rs("sa_sjnum")%>__No<%=rs("sunno")%></span></td>
        </tr>
        <tr>
          <td class="kv"><span class="k">검측</span><span class="v"><%=Rs("sas_mwidth")%> × <%=Rs("sas_mheight")%></span></td>
          
          
<td class="kv">
  <span class="k">오픈</span>
  <span class="v">
  <%
  Dim SQL2, rsOwOh
  SQL2 = "SELECT fk.ow, fk.oh " & _
         "FROM tk_framek fk " & _
         "LEFT JOIN tng_sjaSub sas ON sas.sjsidx = fk.sjsidx " & _
         "WHERE sas.sjsidx = " & CLng(sjsidx) & _
         "AND fk.GREEM_F_A = 2"

  Set rsOwOh = Dbcon.Execute(SQL2)

  Do While Not rsOwOh.EOF
      Response.Write Server.HTMLEncode(CStr(rsOwOh("ow"))) & " × " & Server.HTMLEncode(CStr(rsOwOh("oh"))) & "<br>"
      rsOwOh.MoveNext
  Loop

  rsOwOh.Close
  Set rsOwOh = Nothing
  %>
  </span>
</td>


            <td class="kv">
            <div class="d-flex justify-content-between">
                <div>
                <span class="k">수량</span>
                <span class="v text-primary fw-semibold"><%=Rs("sas_quan")%>개</span>
                </div>
                <div class="vr mx-2"></div> <!-- 세로 구분선 -->
                <div>
                <span class="k">자재묶음</span>
                <span class="v text-success fw-semibold"><%=fksCount%>개</span>
                </div>
            </div>
            </td>
        </tr>
        <tr>
          <td class="kv" colspan="2"><span class="k">프레임타입</span><span class="v"><%=Rs("sas_fullname")%></span></td>
          <td class="kv"><span class="k">색상</span><span class="v"><%=Rs("p_name")%></span></td>
        </tr>
        <tr>
          <td class="kv text-primary" colspan="2"><span class="k">출고방식</span><span class="v"><%=cgtype_text%></span></td>
          <td class="kv text-primary"><span class="k">출고날짜</span><span class="v"><%=Rs("sa_cgdate")%></span></td>
        </tr>
      </tbody>
    </table>
  </section>

<%
Rs.Close
Set Rs = Nothing
%>








<!-- 본문: 좌(도어 유리) / 우(픽스 유리) - 간단화 버전 -->
<%
' 안전 인코딩
Function H(v) : H = Server.HTMLEncode(v & "") : End Function
%>

  <!-- 좌: 도어 유리 -->
    <div class="card border-dark h-100 my-1">
      <div class="card-header bg-light border-dark fw-bold">
        도어 유리 <span class="ms-2 text-secondary fw-normal small">품명 / 도어W·도어H / 도어유리W·도어유리H</span>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-bordered table-sm align-middle mb-0" aria-label="도어 유리 사이즈 표">
            <thead class="table-secondary">
  <tr class="text-center">
    <th>품명</th>
    <th style="width:13%;">도어 폭</th>
    <th style="width:13%;">도어 높이</th>
    <th style="width:15%;">유리 가로</th>
    <th style="width:15%;">유리 세로</th>
    <th style="width:10%;">수량</th>
  </tr>
</thead>
<tbody>
<%
  Dim sqlDoor, rsDoor, qty_base, qty_total
  Dim dType, dChoice, dTypeTxt, dChoiceTxt

  sqlDoor = Join(Array( _
    "SELECT", _
    "  a.goname, a.barNAME,", _
    "  a.door_w, a.door_h, a.doorglass_w, a.doorglass_h,", _
    "  a.doortype, b.doorchoice,", _
    "  COUNT(*) AS qty", _
    "FROM tk_framekSub a", _
    "JOIN tk_framek   b ON a.fkidx = b.fkidx", _
    "WHERE b.sjsidx = " & CLng(sjsidx) & " AND a.door_w > 0", _
    "GROUP BY a.goname, a.barNAME, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.doortype, b.doorchoice", _
    "ORDER BY a.goname, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h" _
  ), vbCrLf)

  Set rsDoor = Server.CreateObject("ADODB.Recordset")
  rsDoor.Open sqlDoor, Dbcon

  If Not (rsDoor.BOF Or rsDoor.EOF) Then
    Do While Not rsDoor.EOF
      ' --- 옵션 텍스트 매핑 (숫자 → 문자열) ---
      dType = 0 : On Error Resume Next : dType = CLng(rsDoor("doortype")) : On Error GoTo 0
      Select Case dType
        Case 1: dTypeTxt = "좌도어"
        Case 2: dTypeTxt = "우도어"
        Case Else: dTypeTxt = "없음"
      End Select

      dChoice = 0 : On Error Resume Next : dChoice = CLng(rsDoor("doorchoice")) : On Error GoTo 0
      Select Case dChoice
        Case 1: dChoiceTxt = "도어 포함가"
        Case 2: dChoiceTxt = "도어 별도가"
        Case 3: dChoiceTxt = "도어 제외가"
        Case Else: dChoiceTxt = "선택되지 않음"
      End Select

      qty_base  = CLng(rsDoor("qty"))
      qty_total = qty_base
      If IsNumeric(total_count) Then
        If CLng(total_count) > 1 Then qty_total = qty_base * CLng(total_count)
      End If

%>
  <tr>
    <td>
      <%= H(rsDoor("goname")) %><br>
      <small class="text-secondary">
        규격 <%= H(rsDoor("barNAME")) %> · <%= H(dTypeTxt) %> · <%= H(dChoiceTxt) %>
      </small>
    </td>
    <td class="text-end" data-unit="mm"><%= rsDoor("door_w") %></td>
    <td class="text-end" data-unit="mm"><%= rsDoor("door_h") %></td>
    <td class="text-end fw-bold fs-4" data-unit="mm"><%= rsDoor("doorglass_w") %></td>
    <td class="text-end fw-bold fs-4" data-unit="mm"><%= rsDoor("doorglass_h") %></td>
    <td class="text-end" data-unit="ea"><%= qty_total %></td>
  </tr>
<%
      rsDoor.MoveNext
    Loop
  Else
%>
  <tr><td colspan="6" class="text-center text-muted">데이터가 없습니다.</td></tr>
<%
  End If
  rsDoor.Close : Set rsDoor = Nothing
%>
</tbody>

          </table>
        </div>
      </div>
  </div>

<div class="card border-dark h-100 my-1">
  <div class="card-header bg-light border-dark fw-bold">
    픽스 유리 <span class="ms-2 text-secondary fw-normal small">품명 / 가로 / 세로 / 수량(EA) × 2세트</span>
  </div>
  <div class="card-body p-0">
    <div class="table-responsive">
      <table class="table table-bordered table-sm align-middle mb-0" aria-label="픽스 유리 사이즈 표">
        
<thead class="table-secondary">
  <tr class="text-center">
    <th style="width:25%;">품명</th>
    <th style="width:9%;">가로</th>
    <th style="width:9%;">세로</th>
    <th style="width:7%;">수량</th>
    <th style="width:25%;">품명</th>
    <th style="width:9%;">가로</th>
    <th style="width:9%;">세로</th>
    <th style="width:7%;">수량</th>
  </tr>
</thead>

<tbody>
<%

' --- 선언 ---
Dim sqlFix, rsFix
Dim curFk, grpNo
Dim cnt, i, j, half

' 동적 배열(평행 배열)로 버퍼
Dim arr_fkidx(), arr_w(), arr_h(), arr_qty(), arr_grp()

' --- DB 연결 보장(프로젝트의 dbOpen() 사용 가정) ---
If (Not IsObject(Dbcon)) Or (Dbcon Is Nothing) Or (Dbcon.State = 0) Then
  Call dbOpen()
End If

' --- 쿼리: fkidx 단위 정렬(그룹 배정용) ---
sqlFix = Join(Array( _
  "SELECT", _
  "  b.fkidx,", _
  "  a.glass_w, a.glass_h,", _
  "  COUNT(*) AS qty", _
  "FROM tk_framekSub a", _
  "JOIN tk_framek b ON a.fkidx = b.fkidx", _
  "WHERE b.sjsidx = " & CLng(sjsidx), _
  "  AND a.gls <> 0", _
  "  AND a.glass_w IS NOT NULL AND a.glass_h IS NOT NULL", _
  "GROUP BY b.fkidx, a.glass_w, a.glass_h", _
  "ORDER BY b.fkidx, a.glass_w, a.glass_h" _
), vbCrLf)

Set rsFix = Dbcon.Execute(sqlFix)

' --- 결과 적재 + 그룹 번호 배정(여기서 curFk/grpNo "살림") ---
curFk = -1
grpNo = 0
cnt = 0

Do Until rsFix.EOF
  ' fkidx 바뀌면 그룹 증가
  If curFk <> rsFix("fkidx") Then
    curFk = rsFix("fkidx")
    grpNo = grpNo + 1
  End If

  ReDim Preserve arr_fkidx(cnt), arr_w(cnt), arr_h(cnt), arr_qty(cnt), arr_grp(cnt)
  arr_fkidx(cnt) = rsFix("fkidx")
  arr_w(cnt)     = rsFix("glass_w")
  arr_h(cnt)     = rsFix("glass_h")
  arr_qty(cnt)   = rsFix("qty")
  arr_grp(cnt)   = grpNo

  cnt = cnt + 1
  rsFix.MoveNext
Loop

If Not (rsFix Is Nothing) Then
  On Error Resume Next
  If rsFix.State <> 0 Then rsFix.Close
  Set rsFix = Nothing
  On Error GoTo 0
End If

' --- 데이터 없으면 안내 ---
If cnt = 0 Then
  Response.Write "<tr><td colspan=""8"" class=""text-center text-muted"">데이터가 없습니다.</td></tr>"
Else
  ' 왼쪽/오른쪽 분할: 왼쪽에 앞쪽 절반, 오른쪽에 뒤쪽 절반
  half = (cnt + 1) \ 2   ' 홀수면 왼쪽이 1개 더 많게

  For i = 0 To half - 1
    j = i + half
    Response.Write "<tr>"

    ' ===== 왼쪽 세트 (그룹번호는 fkidx 변화 기준으로 이미 부여됨) =====
    Response.Write "<td>(" & Server.HTMLEncode(CStr(arr_grp(i))) & ") 픽스 유리</td>"
    Response.Write "<td class=""text-end fw-bold fs-4"" data-unit=""mm"">" & Server.HTMLEncode(CStr(arr_w(i))) & "</td>"
    Response.Write "<td class=""text-end fw-bold fs-4"" data-unit=""mm"">" & Server.HTMLEncode(CStr(arr_h(i))) & "</td>"
    Response.Write "<td class=""text-center fs-4"">" & arr_qty(i)*total_count & "</td>"

    ' ===== 오른쪽 세트 (있으면) =====
    If j < cnt Then
      Response.Write "<td>(" & Server.HTMLEncode(CStr(arr_grp(j))) & ") 픽스 유리</td>"
      Response.Write "<td class=""text-end fw-bold fs-4"" data-unit=""mm"">" & Server.HTMLEncode(CStr(arr_w(j))) & "</td>"
      Response.Write "<td class=""text-end fw-bold fs-4"" data-unit=""mm"">" & Server.HTMLEncode(CStr(arr_h(j))) & "</td>"
      Response.Write "<td class=""text-center fs-4"">" & arr_qty(j)*total_count & "</td>"
    Else
      ' 홀수 개면 오른쪽 비움
      Response.Write "<td colspan=""4"">&nbsp;</td>"
    End If

    Response.Write "</tr>"
  Next
End If
%>
</tbody>

      </table>
    </div>
  </div>
</div>


<!-- 도면 (SVG) -->
<section class="section drawing wrap no-break">
  <%
      Session("autoSchema.sjidx")  = sjidx
      Session("autoSchema.sjsidx") = sjsidx

      Server.Execute "/schema/export/index.asp"
  %>
</section>

      </div>
      <!-- ===== 스케일 대상 콘텐츠 끝 ===== -->
    </div>
  </div>
