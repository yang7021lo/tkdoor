<%@ Language="VBScript" CodePage="65001" %>
<%
Option Explicit
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
      <h1 class="top-title">태광 프레임 시공도 - 자동 타입 <%=rfkidx%></h1>
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
            " CASE WHEN sa.cgtype BETWEEN 1 AND 12 " & _
            "      THEN CHOOSE(sa.cgtype, N'화물', N'낮1배달', N'낮2배달', N'밤1배달', N'밤2배달', N'대구창고', N'대전창고', N'부산창고', N'양산창고', N'익산창고', N'원주창고', N'제주창고')" & _
            "      ELSE N'미지정' END AS sa_cgtype," & _
            " sa.sjdate     AS sa_sjdate," & _
            " sa.sjnum      AS sa_sjnum," & _ 
            " c.cname       AS c_name," & _
            " sas.mwidth    AS sas_mwidth," & _
            " sas.mheight   AS sas_mheight," & _
            " sas.quan      AS sas_quan," & _
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
            "WHERE fk.fkidx = " & CLng(rfkidx)
' 필요하면 sjidx도 함께 고정: 
' SQL = SQL & " AND fk.sjidx = '" & sjidx & "'"


Rs.Open SQL, Dbcon, 0, 1
%>




      <!-- ===== 스케일 대상 콘텐츠 시작 ===== -->
      <div id="content" class="content-fit">
        <!-- 메타 정보 3열 (콤팩트) -->


   <section class="no-break">
    <table class="table table-sm table-bordered table-fixed mb-2">
      <colgroup><col span="3" style="width:33.333%"></colgroup>
      <tbody>
        <tr>
        <td class="kv"><span class="k">발주처</span><span class="v"><%=Rs("c_name")%></span></td>
          <td class="kv"><span class="k">재질/도어</span><span class="v"><%=Rs("qtyidx")%> · <%=Rs("fk_dooryn")%></span></td>
          <td class="kv"><span class="k">수주번호</span><span class="v"><%=Rs("sa_sjnum")%>__No<%=rs("sunno")%></span></td>
        </tr>
        <tr>
          <td class="kv"><span class="k">검측</span><span class="v"><%=Rs("fk_tw")%> × <%=Rs("fk_th")%></span></td>
          <td class="kv"><span class="k">오픈</span><span class="v"><%=Rs("fk_ow")%> × <%=Rs("fk_oh")%></span></td>
          <td class="kv"><span class="k">수량</span><span class="v"><%=Rs("sas_quan")%>개</span></td>
        </tr>
        <tr>
          <td class="kv" colspan="2"><span class="k">프레임타입</span><span class="v"><%=Rs("framename")%></span></td>
          <td class="kv"><span class="k">색상</span><span class="v"><%=Rs("p_name")%></span></td>
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
      Session("autoSchema.fkidx")  = rfkidx

      Server.Execute "/schema/export/auto/index.asp"
  %>
</section>



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
              </tr>
            </thead>
            <tbody>
              <%
                Dim sqlDoor, rsDoor
sqlDoor = Join(Array( _
  "SELECT", _
  "  a.door_w, a.door_h, a.doorglass_w, a.doorglass_h,", _
  "  a.goname, a.barNAME,", _
  "  CASE WHEN a.doortype BETWEEN 0 AND 2", _
  "       THEN CHOOSE(a.doortype+1, N'없음', N'좌도어', N'우도어')", _
  "       ELSE N'없음' END AS doortype_txt,", _
  "  CASE WHEN b.doorchoice BETWEEN 1 AND 3", _
  "       THEN CHOOSE(b.doorchoice, N'도어 포함가', N'도어 별도가', N'도어 제외가')", _
  "       ELSE N'선택되지 않음' END AS doorchoice_txt", _
  "FROM tk_framekSub a", _
  "JOIN tk_framek b ON a.fkidx = b.fkidx", _
  "WHERE b.sjsidx = " & CLng(sjsidx) & " AND a.door_w > 0", _
  "  AND b.fkidx = " & CLng(rfkidx) _
), vbCrLf)


                Set rsDoor = Server.CreateObject("ADODB.Recordset")
                rsDoor.Open sqlDoor, Dbcon

                If Not (rsDoor.BOF Or rsDoor.EOF) Then
                  Do While Not rsDoor.EOF
              %>
                  <tr>
                    <td>
                      <%= H(rsDoor("goname")) %><br>
                      <small class="text-secondary">
                        규격 <%= H(rsDoor("barNAME")) %> · <%= H(rsDoor("doortype_txt")) %> · <%= H(rsDoor("doorchoice_txt")) %>
                      </small>
                    </td>
                    <td class="text-end" data-unit="mm"><%= rsDoor("door_w") %></td>
                    <td class="text-end" data-unit="mm"><%= rsDoor("door_h") %></td>
                    <td class="text-end fw-bold fs-4" data-unit="mm"><%= rsDoor("doorglass_w") %></td>
                    <td class="text-end fw-bold fs-4" data-unit="mm"><%= rsDoor("doorglass_h") %></td>
                  </tr>
              <%
                    rsDoor.MoveNext
                  Loop
                End If
                rsDoor.Close : Set rsDoor = Nothing
              %>
            </tbody>
          </table>
        </div>
      </div>
  </div>

  <!-- 우: 픽스 유리 -->
    <div class="card border-dark h-100 my-1">
      <div class="card-header bg-light border-dark fw-bold">
        픽스 유리 <span class="ms-2 text-secondary fw-normal small">품명 / 가로 / 세로 / 수량(EA)</span>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-bordered table-sm align-middle mb-0" aria-label="픽스 유리 사이즈 표">
            <thead class="table-secondary">
              <tr class="text-center">
                <th style="width:50%;">품명</th>
                <th style="width:18%;">가로</th>
                <th style="width:18%;">세로</th>
                <th style="width:14%;">수량</th>
              </tr>
            </thead>
            <tbody>
              <%
                Dim sqlFix, rsFix, curFk, grpNo
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
                  "  AND b.fkidx = " & CLng(rfkidx), _
                  "GROUP BY b.fkidx, a.glass_w, a.glass_h", _
                  "ORDER BY b.fkidx, a.glass_w, a.glass_h" _
                ), vbCrLf)

                Set rsFix = Server.CreateObject("ADODB.Recordset")
                rsFix.Open sqlFix, Dbcon

                curFk = -1 : grpNo = 0
                If Not (rsFix.BOF Or rsFix.EOF) Then
                  Do While Not rsFix.EOF
                    If curFk <> rsFix("fkidx") Then
                      curFk = rsFix("fkidx")
                      grpNo = grpNo + 1
                    End If
              %>
                    <tr>
                      <td>픽스 유리 (<%= grpNo %>)</td>
                      <td class="text-end fw-bold fs-4" data-unit="mm"><%= rsFix("glass_w") %></td>
                      <td class="text-end fw-bold fs-4" data-unit="mm"><%= rsFix("glass_h") %></td>
                      <td class="text-center fs-4"><%= rsFix("qty") %></td>
                    </tr>
              <%
                    rsFix.MoveNext
                  Loop
                End If
                rsFix.Close : Set rsFix = Nothing
              %>
            </tbody>
          </table>
        </div>
      </div>
    </div>

      </div>
      <!-- ===== 스케일 대상 콘텐츠 끝 ===== -->
    </div>
  </div>