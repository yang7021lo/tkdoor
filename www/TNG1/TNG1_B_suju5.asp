

<%
' === 연결 ===
call dbOpen()

' -------------------------------
' 파라미터 (최소한)
' -------------------------------
Dim sjidx    : sjidx    = Trim(Request("sjidx"))
Dim rsjidx    : rsjidx    = Trim(Request("sjidx"))
Dim sjsidx   : sjsidx   = Trim(Request("sjsidx"))
Dim rfkidx   : rfkidx   = Trim(Request("fkidx"))   ' 선택 프레임(옵션)
Dim rfksidx  : rfksidx  = Trim(Request("fksidx"))  ' 선택 바(옵션)

If sjidx = "" Or sjsidx = "" Then
  Response.Write "<h3>missing params: sjidx & sjsidx are required</h3>"
  call dbClose()
  Response.End
End If

' SQL에서 사용할 이스케이프
Dim sjidxSql, sjsidxSql
sjidxSql  = Q(sjidx)
sjsidxSql = Q(sjsidx)

' -------------------------------
' 캔버스 메타 크기 (없으면 BBox로 자동)
' -------------------------------
Dim sja_mwidth, sja_mheight
sja_mwidth  = 0
sja_mheight = 0

Dim RsMeta, SqlMeta
Set RsMeta = Server.CreateObject("ADODB.Recordset")
SqlMeta = ""
SqlMeta = SqlMeta & "SELECT ISNULL(mwidth,0), ISNULL(mheight,0) "
SqlMeta = SqlMeta & "FROM tng_sjaSub "
SqlMeta = SqlMeta & "WHERE sjidx='" & sjidxSql & "' AND sjsidx='" & sjsidxSql & "'"
RsMeta.Open SqlMeta, Dbcon, 1, 1
If Not (RsMeta.BOF Or RsMeta.EOF) Then
  sja_mwidth  = CDbl(RsMeta(0))
  sja_mheight = CDbl(RsMeta(1))
End If
RsMeta.Close
Set RsMeta = Nothing

' -------------------------------
' 도형 데이터 조회 (필수 컬럼)
'  - fstype: 0=바, 1=유리, 2=묻힘
'  - WHICHI_FIX / WHICHI_AUTO / gls 색상 매핑
'  - data-* 유지용: ysize, blength(yblength), alength, garo_sero
' -------------------------------
Dim Rs, Sql
Set Rs = Server.CreateObject("ADODB.Recordset")
Sql = ""
Sql = Sql & "SELECT "
Sql = Sql & "  ISNULL(A.fkidx,0)       AS fkidx, "
Sql = Sql & "  ISNULL(B.fksidx,0)      AS fksidx, "
Sql = Sql & "  ISNULL(B.xi,0)          AS xi, "
Sql = Sql & "  ISNULL(B.yi,0)          AS yi, "
Sql = Sql & "  ISNULL(B.wi,0)          AS wi, "
Sql = Sql & "  ISNULL(B.hi,0)          AS hi, "
Sql = Sql & "  ISNULL(B.fstype,0)      AS fstype, "
Sql = Sql & "  ISNULL(B.WHICHI_FIX,0)  AS WHICHI_FIX, "
Sql = Sql & "  ISNULL(B.WHICHI_AUTO,0) AS WHICHI_AUTO, "
Sql = Sql & "  ISNULL(B.gls,0)         AS gls, "
Sql = Sql & "  ISNULL(B.ysize,0)       AS ysize, "
Sql = Sql & "  ISNULL(B.blength,0)     AS yblength, "
Sql = Sql & "  ISNULL(B.alength,0)     AS alength, "
Sql = Sql & "  ISNULL(B.garo_sero,0)   AS garo_sero "
Sql = Sql & "FROM tk_framek A "
Sql = Sql & "LEFT JOIN tk_framekSub B ON A.fkidx = B.fkidx "
Sql = Sql & "WHERE A.sjidx='" & sjidxSql & "' AND A.sjsidx='" & sjsidxSql & "' "
Sql = Sql & "ORDER BY B.xi ASC, B.yi ASC"
Rs.Open Sql, Dbcon, 1, 1
%>

<div class="canvas-wrap" id="svgCanvas" data-total-width="<%=Server.HTMLEncode(CStr(sja_mwidth))%>"
     data-total-height="<%=Server.HTMLEncode(CStr(sja_mheight))%>">

<svg id="canvas" svg xmlns="http://www.w3.org/2000/svg" style="width: 100%; height: 100%;" aria-label="좌표(300,300) 샘플"      >
  <!-- 실제 도형 레이어 -->
  <g id="viewport" transform="translate(0,0) scale(1)" clip-path="url(#artboardClip)">
  <%
    If Not (Rs.BOF Or Rs.EOF) Then
      Do While Not Rs.EOF
        Dim fkidx, fksidx, xi, yi, wi, hi, fstype, whichi_fix, whichi_auto, gls
        Dim ysize, yblength, alength, garo_sero

        fkidx        = Rs("fkidx")
        fksidx       = Rs("fksidx")
        xi           = Rs("xi")
        yi           = Rs("yi")
        wi           = Rs("wi")
        hi           = Rs("hi")
        fstype       = Rs("fstype")
        whichi_fix   = Rs("WHICHI_FIX")
        whichi_auto  = Rs("WHICHI_AUTO")
        gls          = Rs("gls")
        ysize        = Rs("ysize")
        yblength     = Rs("yblength")
        alength      = Rs("alength")
        garo_sero    = Rs("garo_sero")

        ' 색상/선 지정
        Dim stroke_text, fill_text
        stroke_text = "#A9A9A9" : fill_text = "white"

        Dim fknum, fksnum, rfknum, rfksnum, fstypeNum
        fknum     = SafeLng(fkidx , -1)
        fksnum    = SafeLng(fksidx, -1)
        rfknum    = SafeLng(rfkidx, -1)
        rfksnum   = SafeLng(rfksidx,-1)
        fstypeNum = SafeLng(fstype, 0)

        If (rfksnum >= 0 And fksnum = rfksnum) Then
          stroke_text = "#696969" : fill_text = "#BEBEBE"
        ElseIf (rfknum >= 0 And fknum = rfknum) Then
          If fstypeNum = 1 Then
            stroke_text = "#779ECB" : fill_text = "#ADD8E6"
          Else
            stroke_text = "#D3D3D3" : fill_text = "#EEEEEE"
          End If
        Else
          If fstypeNum = 1 Then
            stroke_text = "#779ECB" : fill_text = "#ADD8E6"
          Else
            stroke_text = "#A9A9A9" : fill_text = "white"
          End If
        End If

        ' AUTO/FIX & gls 색상 우선 규칙(간단화)
        If SafeLng(fstype,0) <> 2 Then ' 묻힘 제외
          If whichi_auto <> 0 And whichi_fix = 0 Then
            Select Case SafeLng(gls,0)
              Case 0
                If SafeLng(whichi_auto,0) = 21 Then
                    fill_text = "#FFC0CB"   ' 재료분리대
                ElseIf SafeLng(whichi_auto,0) = 20 Then
                    fill_text = "#FA8072"   ' 하부레일
                Else
                    fill_text = "#DCDCDC"   ' 자재(일반)
                End If
              Case 1: fill_text="#cce6ff"
              Case 2: fill_text="#ccccff"
              Case 3: fill_text="#FFFFE0"
              Case 4: fill_text="#FFFF99"
            End Select
          ElseIf (SafeLng(whichi_fix,0) <> 0 And SafeLng(whichi_auto,0) = 0) Then
            Select Case SafeLng(gls,0)
              Case 0: If SafeLng(whichi_fix,0)=24 Then fill_text="#FFC0CB" Else fill_text="#DCDCDC"
              Case 1: fill_text="#cce6ff"
              Case 2: fill_text="#ccccff"
              Case 3: fill_text="#FFFFE0"
              Case 4: fill_text="#FFFF99"
              Case 5: fill_text="#CCFFCC"
              Case 6: fill_text="#CCFFCC"
            End Select
          End If
        End If

        ' data-* 치수/타입
        Dim real_wi, real_hi, rect_type, glsNum, garoNum
        glsNum  = SafeLng(gls, 0)
        garoNum = SafeLng(garo_sero, 0)

        If glsNum <> 0 Then
          real_wi = SafeLng(alength , 0)
          real_hi = SafeLng(yblength, 0)
        Else
          If garoNum = 1 Then
            real_wi = SafeLng(ysize   , 0)
            real_hi = SafeLng(yblength, 0)
          Else
            real_wi = SafeLng(yblength, 0)
            real_hi = SafeLng(ysize   , 0)
          End If
        End If

        rect_type = "자재"
        If SafeLng(whichi_auto,0) <> 0 And SafeLng(whichi_fix,0) = 0 Then
            Select Case glsNum
            Case 0
                If SafeLng(whichi_auto,0) = 21 Then
                rect_type = "재료분리대"
                ElseIf SafeLng(whichi_auto,0) = 20 Then
                rect_type = "하부레일"
                Else
                rect_type = "자재"
                End If

            Case 1: rect_type = "외도어"
            Case 2: rect_type = "양개도어"
            Case 3: rect_type = "유리"
            Case 4: rect_type = "상부남마유리"
            End Select

        ElseIf SafeLng(whichi_fix,0) <> 0 And SafeLng(whichi_auto,0) = 0 Then
          Select Case glsNum
            Case 0: If SafeLng(whichi_fix,0)=24 Then rect_type="재료분리대" Else rect_type="자재"
            Case 1: rect_type="외도어"
            Case 2: rect_type="양개도어"
            Case 3: rect_type="유리"
            Case 4: rect_type="상부남마유리"
            Case 5: rect_type="박스라인하부픽스유리"
            Case 6: rect_type="박스라인상부픽스유리"
          End Select
        End If

' 클릭 이동용 쿼리스트링
Dim qs
qs = "sjidx="  & Server.URLEncode(sjidx)  & _
     "&sjsidx=" & Server.URLEncode(sjsidx) & _
     "&fkidx="  & Server.URLEncode(CStr(fkidx)) & _
     "&fksidx=" & Server.URLEncode(CStr(fksidx))

  %>
    <% If SafeLng(fstype,0) = 2 Then %>
      <!-- 묻힘: 해칭 -->
      <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>"
            fill="url(#diagonalHatch)" stroke="black" stroke-width="1"
            data-value="width=<%=real_wi%>,height=<%=real_hi%>,w_a=<%=whichi_auto%>,g_a=<%=gls%>,garo_sero=<%=garo_sero%>"
            data-type="<%=rect_type%>"
            onclick="location.replace('?<%=qs%>');" />
    <% Else %>
      <!-- 바/유리 -->
      <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>"
            fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1"
            data-value="width=<%=real_wi%>,height=<%=real_hi%>,w_a=<%=whichi_auto%>,g_a=<%=gls%>,garo_sero=<%=garo_sero%>"
            data-type="<%=rect_type%>"
            onclick="location.replace('?<%=qs%>');" />
    <% End If %>
  <%
        Rs.MoveNext
      Loop
    End If
    Rs.Close
    Set Rs = Nothing
  %>
  </g>
</svg>
</div>
<!-- 도면 수치 표현 모듈 (data-value/data-type 사용) -->
<script src="/schema/total.js"></script>
<script src="/schema/horizontal.js"></script>
<script src="/schema/vertical.js"></script>
<script src="/schema/intergrate.js"></script>


<script>
/** SVG를 내부 그룹(#viewport)의 바운딩박스에 맞춰 딱 맞게 조정 */
(function (root) {
  // el의 변환(CTM)을 적용한 바운딩박스(루트 SVG 좌표계 기준) 계산
  function getTransformedBBox(el) {
    const bb = el.getBBox();                 // 요소 로컬 bbox
    const m = el.getCTM();                   // 요소 -> 루트 좌표 변환행렬
    const P = (x, y) =>
      (window.DOMPoint
        ? new DOMPoint(x, y).matrixTransform(m)
        : (function(){                        // DOMPoint 폴백
            const pt = el.ownerSVGElement.createSVGPoint();
            pt.x = x; pt.y = y; return pt.matrixTransform(m);
          })());

    const p1 = P(bb.x, bb.y);
    const p2 = P(bb.x + bb.width, bb.y);
    const p3 = P(bb.x, bb.y + bb.height);
    const p4 = P(bb.x + bb.width, bb.y + bb.height);

    const xs = [p1.x, p2.x, p3.x, p4.x];
    const ys = [p1.y, p2.y, p3.y, p4.y];
    const minX = Math.min.apply(null, xs);
    const maxX = Math.max.apply(null, xs);
    const minY = Math.min.apply(null, ys);
    const maxY = Math.max.apply(null, ys);

    return { x: minX, y: minY, width: maxX - minX, height: maxY - minY };
  }

  /**
   * SVG 크기를 그룹에 맞춤
   * @param svgId    루트 SVG id (기본: 'canvas')
   * @param groupId  내부 그룹 id (기본: 'viewport')
   * @param options  { padding=0, setSize=true, pxPerUnit=1 }
   *  - padding:    사방 여백(사용 좌표 단위)
   *  - setSize:    true면 CSS width/height를 px로 고정(글자 크기 고정에 유리)
   *  - pxPerUnit:  1유닛당 몇 px로 보일지 (setSize=true일 때만 적용)
   */
  function fitSvgToGroup(svgId='canvas', groupId='viewport', { padding=0, setSize=true, pxPerUnit=1 } = {}) {
    const svg = document.getElementById(svgId);
    const g   = document.getElementById(groupId);
    if (!svg || !g) return;

    const bb = getTransformedBBox(g);
    const x = bb.x - padding;
    const y = bb.y - padding;
    const w = bb.width  + padding * 2;
    const h = bb.height + padding * 2;

    // 그룹이 화면에 딱 맞게 보이도록 viewBox를 그룹 bbox로 설정
    svg.setAttribute('viewBox', `${x} ${y} ${w} ${h}`);

    // 글자 크기를 "항상 고정"하려면 setSize=true로 px 고정 권장
    if (setSize) {
      svg.style.width  = (w * pxPerUnit) + 'px';
      svg.style.height = (h * pxPerUnit) + 'px';
      // 반응형이 필요하면 setSize=false로 두고, 대신 글자 비스케일링 전략을 따로 써야 함
    }

    // 필요 시: 가장자리 잘림 방지
    svg.setAttribute('preserveAspectRatio', 'xMinYMin meet');

    return { x, y, width: w, height: h };
  }

  root.SVGFit = { fitSvgToGroup };
})(window);

// 사용 예시: DOM 로드 후 SVG를 내부 그룹에 딱 맞춤
document.addEventListener('DOMContentLoaded', () => {
  // 패딩 20, 폰트 고정(px), 1유닛=1px
  SVGFit.fitSvgToGroup('canvas', 'viewport', { padding: 20, setSize: true, pxPerUnit: 1 });

  // 만약 반응형(컨테이너에 맞춰 늘었다 줄었다)으로 보이되,
  // 글자까지 같이 스케일돼도 괜찮다면:
  // SVGFit.fitSvgToGroup('canvas', 'viewport', { padding: 20, setSize: false });
});
</script>




  <!-- (선택) Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
