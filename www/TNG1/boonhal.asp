<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rfkidx=Request("fkidx")
rsjb_idx=Request("sjb_idx")
gubun=Request("gubun")
roptions=request("options")
rfksidx=Request("fksidx")


if roptions="" then 
  roptions="1"    '1:하바분할중간소대, 2:하바1개중간소대, 3:로비폰추가
end if
'response.write "rsjidx:"&rsjidx&"/<br>"
'response.write "rsjsidx:"&rsjsidx&"/<br>"
'response.write "rfkidx:"&rfkidx&"/<br>"
'response.write "rsjb_idx:"&rsjb_idx&"/<br>"
'response.write "gubun:"&gubun&"/<br>"
'response.write "roptions:"&roptions&"/<br>"
'response.write "rfksidx:"&rfksidx&"/<br>"

if gubun="" then 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>하바분할 및 로비폰 추가</title>
    <link rel="icon" type="image/x-icon" href="/taekwang_logo.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <style>
        a:link {
            color: #070707;
            text-decoration: none;
        }
        a:visited {
            color: #070707;
            text-decoration: none;
        }
        a:hover {
            color: #070707;
            text-decoration: none;
        }

      #inputSection {
        display: none;
        margin-top: 20px;
      }
    </style>
    <script>
      function submitWithFksidx(fksidxValue) {
        // hidden input에 값 세팅
        document.getElementById('fksidx').value = fksidxValue;
        document.getElementById('frmMain').submit();
      }
    </script>

</head>
<body>

<!--화면시작-->

    <div class="py-3 container text-center">

<form id="frmMain" method="POST" action="boonhal.asp">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="gubun" value="cmode">
<input type="hidden" id="fksidx" name="fksidx" value="">
<!-- 하바분할 및 로비폰 추가 시작-->
        <div class="input-group mb-2s">
            <h3>하바분할 및 로비폰 추가</h3>
        </div> 
        <div class="input-group mb-2">
          <div class="d-flex gap-4">
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option1" value="1" onclick="toggleInputs()" <% if roptions="1" then response.write "checked" end if %>>
              <label class="form-check-label" for="option1">
                하바분할 중간소대
              </label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option2" value="2" onclick="toggleInputs()" <% if roptions="2" then response.write "checked" end if %>>
              <label class="form-check-label" for="option2">
                하바1개 중간소대
              </label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option3" value="3" onclick="toggleInputs()" <% if roptions="3" then response.write "checked" end if %>>
              <label class="form-check-label" for="option3">
                로비폰 추가
              </label>
            </div>
          </div>
        </div>
        <div>
            <input type="number" class="form-control" id="size_habar" name="size_habar" value="<%=size_habar%>" placeholder="하바치수입력하기" style="width: 330px;">
        </div>
        <div id="inputSection">
          <div class="d-flex align-items-center gap-3 my-3">
            <div>
              <label for="lpheight" class="form-label mb-0 me-2">높이:</label>
              <input type="number" class="form-control d-inline-block" id="lpheight" name="lpheight" placeholder="" style="width: 120px;">
            </div>
            <div>
              <label for="lpdistance" class="form-label mb-0 me-2">하부기준높이:</label>
              <input type="number" class="form-control d-inline-block" id="lpdistance" name="lpdistance" placeholder="" style="width: 120px;">
            </div>
          </div>
        </div>
 </form>
     <script>
      function toggleInputs() {
        const selected = document.querySelector('input[name="options"]:checked').value;
        const inputSection = document.getElementById('inputSection');

        if (selected === '3') {
          inputSection.style.display = 'block';
        } else {
          inputSection.style.display = 'none';
        }
      }
    </script>
        <div class="input-group mb-2s">
            <h3>위치선택</h3>
        </div> 

        <div class="input-group mb-2">
<!-- SVG 시작 -->
                    <%
                      SQL=" Select B.xi, B.yi "
                      SQL=SQL&" From tk_framek A "
                      SQL=SQL&" JOIN tk_framekSub B ON A.fkidx = B.fkidx "
                      SQL=SQL&" WHERE A.sjidx = '" & rsjidx & "'  AND A.sjsidx = '" & rsjsidx & "'  "
                      SQL=SQL&" and B.xi in "
                      SQL=SQL&" (select min(D.xi) From tk_framek C "
                      SQL=SQL&" JOIN tk_framekSub D ON C.fkidx = D.fkidx "
                      SQL=SQL&" WHERE C.sjidx = '" & rsjidx & "'  AND C.sjsidx = '" & rsjsidx & "' ) "      
                      'Response.write (SQL)&"<br>"
                      'response.end        
                      Rs.open Sql,Dbcon
                      If Not (Rs.bof or Rs.eof) Then 
                        bxi=Rs(0) '가장 좌측에 있는 바의 x좌표
                        byi=Rs(1) '가장 좌측에 있는 바의 y좌표
                      End If
                      Rs.Close
                    %>
          <div class="canvas-container" id="svgCanvas" style="width: 100%; height: 600; padding: 0px;">
              <div class="svg-container">
                  <svg id="canvas" width="100%" height="100%" class="d-block">
                  <g id="viewport" transform="translate(0, 0) scale(1)">
                  <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                  <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                  <text id="width-label" class="dimension-label"></text>
                  <text id="height-label" class="dimension-label"></text>

                      <%
                      SQL = "SELECT A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi"
                      SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO, A.sjb_idx, b.fstype, b.blength"
                      SQL = SQL & ", B.WHICHI_FIX, B.WHICHI_AUTO, D.glassselect, E.glassselect "
                      SQL = SQL & ", B.door_w, B.door_h , B.glass_w, B.glass_h "
                      SQL = SQL & " FROM tk_framek A"
                      SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
                      SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
                      SQL = SQL & " LEFT OUTER JOIN tng_whichitype D ON B.WHICHI_FIX = D.WHICHI_FIX "
                      SQL = SQL & " LEFT OUTER JOIN tng_whichitype E ON B.WHICHI_AUTO = E.WHICHI_AUTO"
                      SQL = SQL & " WHERE A.sjidx = '" & rsjidx & "' AND A.sjsidx = '" & rsjsidx & "'"
                      'SQL = SQL & " and B.fksidx='2995'"
                      'Response.write (SQL)&"<br>"
                      'response.end
                      Rs.open Sql,Dbcon
                      If Not (Rs.bof or Rs.eof) Then 
                      Do while not Rs.EOF
                          i = i + 1
                          fkidx         = Rs(0)
                          fksidx        = Rs(1)
                          xi            = Rs(2)
                          yi            = Rs(3)
                          wi            = Rs(4)
                          hi            = Rs(5)
                          set_name_FIX  = Rs(6)
                          set_name_AUTO = Rs(7)
                          sjb_idx       = Rs(8)
                          fstype        = Rs(9)
                          yblength      = Rs(10)
                          whichi_fix    = Rs(11)
                          whichi_auto   = Rs(12)
                          glassselect_fix   = Rs(13)
                          glassselect_auto   = Rs(14)
                          door_w            = Rs(15)
                          door_h            = Rs(16)
                          glass_w = Rs(17)
                          glass_h = Rs(18)

                          xi=xi-bxi
                          yi=yi-byi
                          if rfksidx="" then rfksidx="0" end if
                            if cint(fksidx)=cint(rfksidx) then 
                            stroke_text="#696969"
                            fill_text="#BEBEBE"
                            else
                              if cint(fkidx)=cint(rfkidx) then 
                                  if fstype="1" then '유리라면
                                      stroke_text="#779ECB"
                                      fill_text="#ADD8E6"
                                  else 
                                      stroke_text="#D3D3D3"
                                      fill_text="#EEEEEE"
                                  end if
                              else
                                  if fstype="1" then '유리라면
                                  stroke_text="#779ECB"
                                  fill_text="#ADD8E6"
              
                                  else 
                                      stroke_text="#A9A9A9"
                                      fill_text="white"
                                  end if 
                              end if

                            end if

                          if WHICHI_AUTO<>"" and WHICHI_FIX=0 then

                              If CInt(glassselect_auto) = 0 Then
                                  If CInt(WHICHI_AUTO) = 21 Then
                                      fill_text = "#FFC0CB" ' 재료분리대 우선
                                  Else
                                      fill_text = "#DCDCDC" ' 회색
                                  End If
                              ElseIf CInt(glassselect_auto) = 1 Then
                                  fill_text = "#cce6ff" ' 투명 파랑 외도어
                              ElseIf CInt(glassselect_auto) = 2 Then
                                  fill_text = "#ccff"   ' 파랑 양개도어 (코드 누락 있음: #ccccff 등으로 수정 권장)
                              ElseIf CInt(glassselect_auto) = 3 Then
                                  fill_text = "#FFFFE0" ' 유리
                              ElseIf CInt(glassselect_auto) = 4 Then
                                  fill_text = "#FFFF99" ' 상부남마유리
                              ElseIf CInt(WHICHI_AUTO) = 21 Then
                                  fill_text = "#FFC0CB" ' 재료분리대 보조조건
                              End If
                              
                          End If

                          if WHICHI_FIX<>"" and WHICHI_AUTO=0 then

                              If CInt(glassselect_fix) = 0 Then
                                  If CInt(WHICHI_FIX) = 24 Then
                                      fill_text = "#FFC0CB" ' 재료분리대 우선
                                  Else
                                      fill_text = "#DCDCDC" ' 회색
                                  End If
                              ElseIF CInt(glassselect_fix) = 1 Then
                                  fill_text = "#cce6ff" ' 투명 파랑 외도어
                              ElseIF CInt(glassselect_fix) = 2 Then
                                  fill_text = "#ccff" '  파랑 양개도어
                              ElseIF CInt(glassselect_fix) = 3 Then
                                  fill_text = "#FFFFE0" '  유리
                              ElseIF CInt(glassselect_fix) = 4 Then
                                  fill_text = "#FFFF99" '  상부남마유리 
                              ElseIF CInt(glassselect_fix) = 5 Then
                                  fill_text = "#CCFFCC" '  박스라인하부픽스유리   
                              ElseIF CInt(glassselect_fix) = 6 Then
                                  fill_text = "#CCFFCC" '  박스라인상부픽스유리  
                              End If

                          End If

                      if Cint(hi) > Cint(wi) then 
                      text_direction="writing-mode: vertical-rl; glyph-orientation-vertical: 0;"
                      else
                      text_direction=""
                      end if 
                      'Response.write (glassselect_auto)&"--   glassselect_auto<br>"
                      'response.write (glassselect_fix)&" ---  glassselect_fix<br>"
                      'response.write (door_w)&" ---  door_w<br>"
                      'Response.write (SQL)&"<br>"
                      %>
                      
                      <% if fstype="2" then %>
                          <defs>
                          <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                              <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
                          </pattern>
                          </defs>
                          <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" 
                          onclick="submitWithFksidx('<%=fksidx%>');"/> 
                      <% else %>
                      
                          <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" 
                          onclick="submitWithFksidx('<%=fksidx%>')"/>
                      <% end if %>
                      
                  <%
                      ' 중심 좌표 계산
                      centerX = xi + (wi / 2)
                      centerY = yi + (hi / 2)

                      ' 텍스트 라인 구성
                      text_line1 = ""
                      text_line2 = ""

                      ' door_w * door_h
                      If IsNumeric(door_w) And IsNumeric(door_h) Then
                          yblength = CStr(door_w) & "×" & CStr(door_h)
                      End If

                      ' glass_w * glass_h
                      If IsNumeric(glass_w) And IsNumeric(glass_h) Then
                          yblength = CStr(glass_w) & "×" & CStr(glass_h)
                      End If
                  %>
                  <%
                  y = yi + (hi / 2) + 4   ' 폰트 높이 보정용
                  centerX = xi + (wi / 2)
                  centerY = yi + (hi / 2) + 4 ' 폰트 높이에 따라 조정
                  %>
                      <% if whichi_auto = 21 or whichi_fix = 24 then %>
                      <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>">재료분리대</text>
                      <% else %>
                      <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>"><%=i%>/<%=fksidx%></text>
                      <% end if %>
                      <%
                      Rs.movenext
                      Loop
                      End if
                      Rs.close
                      %>   
                      
                  </g>    
                  </svg>
              </div>
          </div>
<!-- SVG 끝 -->
        </div>
        <div class="input-group mb-2">
              
        </div>
<!-- 하바분할 및 로비폰 추가 끝--> 



    </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%

ElseIf gubun="cmode" then 
  if roptions="1" then        '1:하바분할중간소대
    response.write "<br>1:하바분할중간소대<br>"
    '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" From tk_framekSub where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>분할대상 픽스유리<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        axi=Rs(0)
        ayi=Rs(1)
        awi=Rs(2)
        ahi=Rs(3)
        afkidx=Rs(4)
        afsidx=Rs(5)
        afidx=Rs(6)
        awhichi_fix=Rs(7)
        awhichi_auto=Rs(8)
        abfidx=Rs(9)
        afstype=Rs(10)
        aglasstype=Rs(11)
        agls=Rs(12)
        aopt=Rs(13)
        afl=Rs(14)
        abusok=Rs(15)
        abusoktype=Rs(16)
        adoorglass_t=Rs(17)
        afixglass_t=Rs(18)
       
      end If
      Rs.Close
                                          
    '2. 분할 대상 바의 하바 찾기
      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" From tk_framekSub where xi='"&axi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"'"
      Response.write (SQL)&"<br>분할대상 하바<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        bxi=Rs(0)
        byi=Rs(1)
        bwi=Rs(2)
        bhi=Rs(3)
        bfksidx=Rs(4)
        bfsidx=Rs(5)
        bfidx=Rs(6)
        bwhichi_fix=Rs(7)
        bwhichi_auto=Rs(8)
        bbfidx=Rs(9)
        bfstype=Rs(10)
        bglasstype=Rs(11)
        bgls=Rs(12)
        bopt=Rs(13)
        bfl=Rs(14)
        bbusok=Rs(15)
        bbusoktype=Rs(16)
        bdoorglass_t=Rs(17)
        bfixglass_t=Rs(18)
        
      end If
      Rs.Close

    '3. 복제할 중간소대 정보 찾기
    '3-1 양개일 경우 분할 하바 치수 적용 위치 선택을 위한 코드
      SQL="select min(xi) from tk_framekSub where fkidx='"&afkidx&"' and whichi_auto=13"
      Response.write (SQL)&"<br>문의 위치<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        wxi=Rs1(0)  '문의 x좌표
        if axi < wxi Then
          wpoint="L"  '하바치수 오른쪽 적용
        else
          wpoint="R"  '하바치수 왼쪽 적용
        end if 

      End If
      Rs.Close


      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t " 
      SQL=SQL&" From tk_framekSub where yi='"&ayi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"'"
      Response.write (SQL)&"<br>복제할 중간소대<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        cxi=Rs(0)
        cyi=Rs(1)
        cwi=Rs(2) '중간소대의 너비
        chi=Rs(3)
        cfksidx=Rs(4)
        cfsidx=Rs(5)
        cfidx=Rs(6)
        cwhichi_fix=Rs(7)
        cwhichi_auto=Rs(8)
        cbfidx=Rs(9)
        cfstype=Rs(10)
        cglasstype=Rs(11)
        cgls=Rs(12)
        copt=Rs(13)
        cfl=Rs(4)
        cbusok=Rs(15)
        cbusoktype=Rs(16)
        cdoorglass_t=Rs(17)
        cfixglass_t=Rs(18)
        
      end If
      Rs.Close

REsponse.end      
    '4. 선택된 픽스유리 분할 너비 줄이기 (좌표이동 없음 : 픽스유리 너비/2 - 중간소대 너비/2)
      dwi=round(awi/2-cwi/2)

      response.write dwi&"<br>"
      response.write awi&"<br>"
      response.write cwi&"<br>"


      SQL="Update tk_framekSub set wi='"&dwi&"' Where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>선택된 픽스유리 너비줄이기<br>/"
      Dbcon.Execute (SQL)

    '5. 픽스유리추가 (좌표 : 픽스유리 x좌표 + 중간소대 너비, y좌표 동일 : 너비는 줄여진 너비와 동일)
      exi=axi+dwi+cwi 'x좌표 : 픽스유리 x좌표 + 분할된 픽스유리너비 + 중간소대 너비
      eyi=ayi     'y좌표 : 픽스유리 x좌표와 동일
      ewi=awi-dwi-cwi     '너비 : 수정된 픽스유리와 동일
      ehi=ahi     '높이 : 픽스유리 높이와 동일
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t) "
      SQL=SQL&" values( '"&exi&"', '"&eyi&"', '"&ewi&"', '"&ehi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&afsidx&"', '"&afidx&"', '"&awhichi_fix&"', '"&awhichi_auto&"', '"&abfidx&"', '"&afstype&"', '"&aglasstype&"', '"&agls&"', '"&aopt&"', '"&afl&"', '"&abusok&"', '"&abusoktype&"', '"&adoorglass_t&"', '"&afixglass_t&"' )"
      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)

    '6. 하바분할 너비 줄이기(좌표이동 없음 : 하바 너비/2 - 중간소대 너비/2)
      fwi=bwi/2-cwi/2
      SQL="Update tk_framekSub set wi='"&fwi&"' Where fksidx='"&bfksidx&"' "
      Response.write (SQL)&"<br>분할된 하바 너비 줄이기<br>"
      Dbcon.Execute (SQL)

    '7. 하바추가 
      gxi=bxi+fwi+cwi 'x좌표 : 픽스유리 x좌표 + 중간소대 너비
      gyi=byi     'y좌표 : 픽스유리 x좌표와 동일
      gwi=bwi-fwi-cwi     '너비 : 수정된 픽스유리와 동일
      ghi=bhi     '높이 : 픽스유리 높이와 동일
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t) "
      SQL=SQL&" values( '"&gxi&"', '"&gyi&"', '"&gwi&"', '"&ghi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&bfsidx&"', '"&bfidx&"', '"&bwhichi_fix&"', '"&bwhichi_auto&"', '"&bbfidx&"', '"&bfstype&"', '"&bglasstype&"', '"&bgls&"', '"&bopt&"', '"&bfl&"', '"&bbusok&"', '"&bbusoktype&"', '"&bdoorglass_t&"', '"&bfixglass_t&"' )"
      Response.write (SQL)&"<br>하바추가<br>"
      Dbcon.Execute (SQL)
    '8. 중간소대 추가
      ixi=axi+dwi   'x좌표 : 수정된 픽스유리 x좌표+픽스유리 너비
      iyi=ayi       'y좌표는 수정된 픽스 유리의 y좌표와 동일
      iwi=cwi       '기존 중간소대의 너비
      ihi=chi       '기존 중간소대의 높이
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t) "
      SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&cfsidx&"', '"&cfidx&"', '"&cwhichi_fix&"', '"&cwhichi_auto&"', '"&cbfidx&"', '"&cfstype&"', '"&cglasstype&"', '"&cgls&"', '"&copt&"', '"&cfl&"', '"&cbusok&"', '"&cbusoktype&"', '"&cdoorglass_t&"', '"&cfixglass_t&"' )"
      Response.write (SQL)&"<br>중간소대추가<br>"
      Dbcon.Execute (SQL)

      response.write "<script>opener.location.replace('TNG1_B_suju.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"');window.close();</script>"

  elseif  roptions="2" then   '2:하바1개중간소대
    response.write "<br>2:하바1개중간소대<br>"
    response.write "<br>1:하바분할중간소대<br>"
    '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" From tk_framekSub where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>분할대상 픽스유리<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        axi=Rs(0)
        ayi=Rs(1)
        awi=Rs(2)
        ahi=Rs(3)
        afkidx=Rs(4)
        afsidx=Rs(5)
        afidx=Rs(6)
        awhichi_fix=Rs(7)
        awhichi_auto=Rs(8)
        abfidx=Rs(9)
        afstype=Rs(10)
        aglasstype=Rs(11)
        agls=Rs(12)
        aopt=Rs(13)
        afl=Rs(14)
        abusok=Rs(15)
        abusoktype=Rs(16)
        adoorglass_t=Rs(17)
        afixglass_t=Rs(18)
       
      end If
      Rs.Close
                                          
    '2. 분할 대상 바의 하바 찾기
      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" From tk_framekSub where xi='"&axi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"'"
      Response.write (SQL)&"<br>분할대상 하바<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        bxi=Rs(0)
        byi=Rs(1)
        bwi=Rs(2)
        bhi=Rs(3)
        bfksidx=Rs(4)
        bfsidx=Rs(5)
        bfidx=Rs(6)
        bwhichi_fix=Rs(7)
        bwhichi_auto=Rs(8)
        bbfidx=Rs(9)
        bfstype=Rs(10)
        bglasstype=Rs(11)
        bgls=Rs(12)
        bopt=Rs(13)
        bfl=Rs(14)
        bbusok=Rs(15)
        bbusoktype=Rs(16)
        bdoorglass_t=Rs(17)
        bfixglass_t=Rs(18)
       
      end If
      Rs.Close

    '3. 복제할 중간소대 정보 찾기
      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t " 
      SQL=SQL&" From tk_framekSub where yi='"&ayi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"'"
      Response.write (SQL)&"<br>복제할 중간소대<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        cxi=Rs(0)
        cyi=Rs(1)
        cwi=Rs(2) '중간소대의 너비
        chi=Rs(3)
        cfksidx=Rs(4)
        cfsidx=Rs(5)
        cfidx=Rs(6)
        cwhichi_fix=Rs(7)
        cwhichi_auto=Rs(8)
        cbfidx=Rs(9)
        cfstype=Rs(10)
        cglasstype=Rs(11)
        cgls=Rs(12)
        copt=Rs(13)
        cfl=Rs(4)
        cbusok=Rs(15)
        cbusoktype=Rs(16)
        cdoorglass_t=Rs(17)
        cfixglass_t=Rs(18)
      
      end If
      Rs.Close
    '4. 선택된 픽스유리 분할 너비 줄이기 (좌표이동 없음 : 픽스유리 너비/2 - 중간소대 너비/2)
      dwi=round(awi/2-cwi/2)

      response.write dwi&"<br>"
      response.write awi&"<br>"
      response.write cwi&"<br>"


      SQL="Update tk_framekSub set wi='"&dwi&"' Where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>선택된 픽스유리 너비줄이기<br>/"
      Dbcon.Execute (SQL)

    '5. 픽스유리추가 (좌표 : 픽스유리 x좌표 + 중간소대 너비, y좌표 동일 : 너비는 줄여진 너비와 동일)
      exi=axi+dwi+cwi 'x좌표 : 픽스유리 x좌표 + 분할된 픽스유리너비 + 중간소대 너비
      eyi=ayi     'y좌표 : 픽스유리 x좌표와 동일
      ewi=awi-dwi-cwi     '너비 : 수정된 픽스유리와 동일
      ehi=ahi     '높이 : 픽스유리 높이와 동일
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t ) "
      SQL=SQL&" values( '"&exi&"', '"&eyi&"', '"&ewi&"', '"&ehi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&afsidx&"', '"&afidx&"', '"&awhichi_fix&"', '"&awhichi_auto&"', '"&abfidx&"', '"&afstype&"', '"&aglasstype&"', '"&agls&"', '"&aopt&"', '"&afl&"', '"&abusok&"', '"&abusoktype&"', '"&adoorglass_t&"', '"&afixglass_t&"' )"
      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)

    '6. 중간소대 추가
      ixi=axi+dwi   'x좌표 : 수정된 픽스유리 x좌표+픽스유리 너비
      iyi=ayi       'y좌표는 수정된 픽스 유리의 y좌표와 동일
      iwi=cwi       '기존 중간소대의 너비
      ihi=ahi       '추가된 픽스유리의 높이와 동일
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t ) "
      SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&cfsidx&"', '"&cfidx&"', '"&cwhichi_fix&"', '"&cwhichi_auto&"', '"&cbfidx&"', '"&cfstype&"', '"&cglasstype&"', '"&cgls&"', '"&copt&"', '"&cfl&"', '"&cbusok&"', '"&cbusoktype&"', '"&cdoorglass_t&"', '"&cfixglass_t&"' )"
      Response.write (SQL)&"<br>중간소대추가<br>"
      Dbcon.Execute (SQL)

      response.write "<script>opener.location.replace('TNG1_B_suju.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"');window.close();</script>"


  elseif  roptions="3" then   '3:로비폰추가
    rlpheight=Request("lpheight")
    rlpdistance=Request("lpdistance")
    phoneh="40" '로비폰 가상의 높이
    response.write "<br>3:로비폰추가<br>"
    response.write rlpheight&"/"&rlpdistance&"<br><br>"

    '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" From tk_framekSub where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>분할대상 픽스유리<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        axi=Rs(0)
        ayi=Rs(1)
        awi=Rs(2)
        ahi=Rs(3)
        afkidx=Rs(4)
        afsidx=Rs(5)
        afidx=Rs(6)
        awhichi_fix=Rs(7)
        awhichi_auto=Rs(8)
        abfidx=Rs(9)
        afstype=Rs(10)
        aglasstype=Rs(11)
        agls=Rs(12)
        aopt=Rs(13)
        afl=Rs(14)
        abusok=Rs(15)
        abusoktype=Rs(16)
        adoorglass_t=Rs(17)
        afixglass_t=Rs(18)
        
      end If
      Rs.Close

    '4. 선택된 픽스유리 분할 높이 줄이기 
      
      dhi=round(ahi/2-phoneh/2)

      response.write dhi&"<br>"
      response.write ahi&"<br>"
      response.write rlpheight&"<br>"


      SQL="Update tk_framekSub set hi='"&dhi&"' Where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>선택된 픽스유리 높이 줄이기<br>/"
      Dbcon.Execute (SQL)

    '5. 픽스유리추가 
      exi=axi                   'x좌표 : 픽스유리 x좌표와 동일
      eyi=ayi+dhi+phoneh     'y좌표 : 픽스유리 y좌표+픽스유리 높이 + 로비폰 높이
      ewi=awi                   '너비 : 픽스유리 너비와 동일
      ehi=ahi-dhi-phoneh             '높이 : 추가된 픽스유리의 높이
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t) "
      SQL=SQL&" values( '"&exi&"', '"&eyi&"', '"&ewi&"', '"&ehi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&afsidx&"', '"&afidx&"', '"&awhichi_fix&"', '"&awhichi_auto&"', '"&abfidx&"', '"&afstype&"', '"&aglasstype&"', '"&agls&"', '"&aopt&"', '"&afl&"', '"&abusok&"', '"&abusoktype&"', '"&adoorglass_t&"', '"&afixglass_t&"' )"
      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)




    '6. 자동 /수동 알아내기
      fxi=axi
      fyi=ayi+dhi
      fwi=awi
      fhi=phoneh
      SQL="select sjb_fa from tng_sjb where sjb_idx='"&rsjb_idx&"' "
      Response.write (SQL)&"<br>분할대상 픽스유리<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        sjb_fa=Rs(0)
      End if
      Rs.Close

      if sjb_fa="1" then 
        abfidx=627
        awhichi_fix=25 '수동 로비폰 박스
      elseif  sjb_fa="2" then 
        abfidx=626
        awhichi_auto=23  '자동로비폰박스
      end if
       
      afstype="0"
      aglasstype="0"
      agls="0"
      aopt="0"
      afl=rlpdistance '하부기준 높이
      abusok="0"
      abusoktype="0"
      adoorglass_t="0"
      afixglass_t="0"

      aysize=rlpheight  '로비폰 높이

      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t, ysize) "
      SQL=SQL&" values( '"&fxi&"', '"&fyi&"', '"&fwi&"', '"&fhi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&afsidx&"', '"&afidx&"', '"&awhichi_fix&"', '"&awhichi_auto&"', '"&abfidx&"', '"&afstype&"', '"&aglasstype&"', '"&agls&"', '"&aopt&"', '"&rlpdistance&"', '"&abusok&"', '"&abusoktype&"', '"&adoorglass_t&"', '"&afixglass_t&"', '"&aysize&"')"
      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)


      response.write "<script>opener.location.replace('TNG1_B_suju.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"');window.close();</script>"

  end if

end if
%>
<%
set Rs=Nothing
call dbClose()
%>
