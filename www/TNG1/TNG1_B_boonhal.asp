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
rsjb_type_no=Request("SJB_TYPE_NO")
size_habar=request("size_habar")
mode=request("mode")
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
    <title>하바분할 중간소대 추가</title>
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
    function validateform() {
            if(document.frmMain1.size_habar.value == "" ) {
                alert("가로 내경을 입력해주세요.");
            return
            }
            else {
                document.frmMain1.submit();
            }
        }
    </script>
    <script>

    function submitWithFksidx(fksidxValue) {
        document.getElementById('fksidx').value = fksidxValue;
        document.getElementById('frmMain').submit();
    }


    </script>



</head>
<body>

<!--화면시작-->

    <div class="py-3 container text-center">
<form id="frmMain1" method="POST" action="TNG1_B_boonhal.asp">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="mode" value="<%=mode%>">
<div class="input-group mb-2s">
            <h3>중간소대 추가</h3>
        </div> 
        <div>
            <input type="number" class="form-control" id="size_habar" name="size_habar" value="<%=size_habar%>" placeholder="하바치수or하부기준 높이입력하기" style="width: 330px;">
        </div>
</form> 
<% if size_habar<>"" then %>       
<form id="frmMain" method="POST" action="TNG1_B_boonhal.asp">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="gubun" value="cmode">
<input type="hidden" id="fksidx" name="fksidx" value="">
<input type="hidden" name="size_habar" value="<%=size_habar%>">
<input type="hidden" name="mode" value="<%=mode%>">
<!-- 하바분할 및 로비폰 추가 시작-->
        <div class="input-group mb-2">
          <div class="d-flex gap-4">
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option1" value="1" onclick="toggleInputs(this.value)" 
              <% if roptions="1" then response.write "checked" end if %>>
              <label class="form-check-label" for="option1">
                하바분할 중간소대
              </label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option2" value="2" onclick="toggleInputs(this.value)" 
              <% if roptions="2" then response.write "checked" end if %>>
              <label class="form-check-label" for="option2">
                하바1개 중간소대
              </label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option3" value="3" onclick="toggleInputs(this.value)" 
              <% if roptions="3" then response.write "checked" end if %>>
              <label class="form-check-label" for="option3">
                가로 분할 중간소대
              </label>
            </div>
    
          </div>
        </div>
       
 </form>

        <div class="input-group mb-2s">
            <h3>위치선택</h3>
        </div> 

        <div class="input-group mb-2">
<!-- SVG 시작 -->
                    <%
                      SQL=" Select min(B.xi), min(B.yi) "
                      SQL=SQL&" From tk_framek A "
                      SQL=SQL&" JOIN tk_framekSub B ON A.fkidx = B.fkidx "
                      SQL=SQL&" WHERE A.sjidx = '" & rsjidx & "'  AND A.sjsidx = '" & rsjsidx & "' AND A.fkidx = '" & rfkidx & "' "
                      SQL=SQL&" and B.xi <>0 and B.yi <>0 "
                      'SQL=SQL&" and B.xi in "
                      'SQL=SQL&" (select min(D.xi) From tk_framek C "
                      'SQL=SQL&" JOIN tk_framekSub D ON C.fkidx = D.fkidx "
                      'SQL=SQL&" WHERE C.sjidx = '" & rsjidx & "'  AND C.sjsidx = '" & rsjsidx & "' ) "      
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
                          SQL = SQL & ", B.door_w, B.door_h , B.glass_w, B.glass_h, B.ysize,b.doortype "
                          SQL = SQL & " FROM tk_framek A"
                          SQL = SQL & " LEFT OUTER JOIN tk_framekSub B ON A.fkidx = B.fkidx"
                          SQL = SQL & " LEFT OUTER JOIN tk_barasiF C ON B.bfidx = C.bfidx"
                          SQL = SQL & " LEFT OUTER JOIN tng_whichitype D ON B.WHICHI_FIX = D.WHICHI_FIX "
                          SQL = SQL & " LEFT OUTER JOIN tng_whichitype E ON B.WHICHI_AUTO = E.WHICHI_AUTO"
                          SQL = SQL & " WHERE A.sjidx = '" & rsjidx & "' AND A.sjsidx = '" & rsjsidx & "'"
                          'Response.write (SQL)&"<br>"
                          'response.end
                          Rs.open Sql,Dbcon
                          If Not (Rs.bof or Rs.eof) Then 
                          Do while not Rs.EOF
                              i = i + 1
                              fkidx         = Rs(0)
                              fksidx        = Rs(1)
                              xi            = Rs(2)-bxi
                              yi            = Rs(3)-byi
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
                              ysize = Rs(19)
                              doortype = Rs(20)

                              if rfksidx="" then rfksidx="0" end if
                              if clng(fksidx)=clng(rfksidx) then 
                              stroke_text="#696969"
                              fill_text="#BEBEBE"
                              else
                              if clng(fkidx)=clng(rfkidx) then 
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

                                If clng(glassselect_auto) = 0 Then '자재는 ysize, blength 이게 A.length 구분 반전 0이 디폴트
                                                                        'a= 가로 b= 세로
                                    If clng(WHICHI_AUTO) = 21 Then
                                        fill_text = "#FFC0CB" ' 재료분리대 우선
                                    ElseIf clng(WHICHI_AUTO) = 20 Then
                                        fill_text = "#FA8072" ' 하부레일        
                                    Else
                                        fill_text = "#DCDCDC" ' 회색
                                    End If

                                    if WHICHI_FIX<>"" and WHICHI_AUTO=9 then
                                        fill_text = "#FA8072" ' 픽스상부오사이
                                    end if
                                    
                                ElseIf clng(glassselect_auto) = 1 Then
                                    fill_text = "#cce6ff" ' 투명 파랑 외도어
                                ElseIf clng(glassselect_auto) = 2 Then
                                    fill_text = "#ccccff"   ' 파랑 양개도어 (코드 누락 있음: #ccccff 등으로 수정 권장)
                                ElseIf clng(glassselect_auto) = 3 Then
                                    fill_text = "#FFFFE0" ' 유리
                                ElseIf clng(glassselect_auto) = 4 Then
                                    fill_text = "#FFFF99" ' 상부남마유리
                                ElseIf clng(WHICHI_AUTO) = 21 Then
                                    fill_text = "#FFC0CB" ' 재료분리대 보조조건
                                End If
                                
                            End If
    
                            if WHICHI_FIX<>"" and WHICHI_AUTO=0 then

                                If clng(glassselect_fix) = 0 Then
                                    If clng(WHICHI_FIX) = 24 Then
                                        fill_text = "#FFC0CB" ' 재료분리대 우선
                                    Else
                                        fill_text = "#DCDCDC" ' 회색
                                    End If
                                ElseIF clng(glassselect_fix) = 1 Then
                                    fill_text = "#cce6ff" ' 투명 파랑 외도어
                                ElseIF clng(glassselect_fix) = 2 Then
                                    fill_text = "#ccccff" '  파랑 양개도어
                                ElseIF clng(glassselect_fix) = 3 Then
                                    fill_text = "#FFFFE0" '  유리
                                ElseIF clng(glassselect_fix) = 4 Then
                                    fill_text = "#FFFF99" '  상부남마유리 
                                ElseIF clng(glassselect_fix) = 5 Then
                                    fill_text = "#CCFFCC" '  박스라인하부픽스유리   
                                ElseIF clng(glassselect_fix) = 6 Then
                                    fill_text = "#CCFFCC" '  박스라인상부픽스유리  
                                End If

                            End If

                            select case doortype
                                case 0 
                                    doortype_text = "없음"
                                case 1 
                                    doortype_text = "좌도어"
                                case 2  
                                    doortype_text = "우도어"
                            end select 

                          if clng(hi) > clng(wi) then 
                          text_direction="writing-mode: vertical-rl; glyph-orientation-vertical: 0;"
                          else
                          text_direction=""
                          end if 
                          'Response.write (glassselect_auto)&"--   glassselect_auto<br>"
                          'response.write (glassselect_fix)&" ---  glassselect_fix<br>"
                          'response.write (door_w)&" ---  door_w<br>"
                          'Response.write (SQL)&"<br>"
                          %>
                      <% 

                      
                      
                      if fstype="2" then %>
                          <defs>
                          <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                              <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
                          </pattern>
                          </defs>
                          <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" 
                          onclick="submitWithFksidx('<%=fksidx%>');"/> 
                      <% else 
                      
              

                      %>
                          <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" 
                          onclick="submitWithFksidx('<%=fksidx%>');"/> 
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
                          <text x="<%=centerX%>" y="<%=centerY%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="15" fill="#000000" style="<%=text_direction%>"><%=yblength%></text>
                          <% end if %>
                          <% if whichi_auto = 12 or whichi_fix = 13 or whichi_fix = 12 or  whichi_fix = 13 then %>
                              <text x="<%=centerX%>" y="<%=centerY-70%>" text-anchor="middle" alignment-baseline="middle" font-family="Arial" font-size="30" fill="#000000" font-weight="bold" style="writing-mode: horizontal-tb;"><%=doortype_text%></text>
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
 <% end if %>
    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%

ElseIf gubun="cmode" then 

size_habar=Request("size_habar") '하바 치수 받기
rsjb_type_no=Request("sjb_type_no") 
'chuga_jajae 추가자재 0 은 미터당 단가 계산
'chuga_jajae 추가자재 1 은 평당단가에서 제외하고 추가로 계산 
'rsjb_type_no 1~5가 평당 단가 제품
if rsjb_type_no>= 1 and rsjb_type_no <=5 then
    chuga_jajae=1 '평당단가 제품은 추가자재 1
else
    chuga_jajae=0 '평당단가 제품은 추가자재 0
end if

  if roptions="1" then        '1:하바분할중간소대
    response.write "<br>1:하바분할 중간소대 작업시작 <br>"
    '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , alength, blength , glass_w , glass_h , garo_sero , sunstatus " 
      SQL=SQL&" From tk_framekSub where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>1분할대상 픽스유리<br>"
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
        aalength=Rs(19) '가로내경
        ablength=Rs(20) '세로내경 
        aglass_w=Rs(21) '가로 유리치수
        aglass_h=Rs(22) '세로 유리치수
        agaro_sero=Rs(23) '가로 선정리
        asunstatus=Rs(24) '상부픽스바 구분
             
      end If
      Rs.Close
                                          
    '2. 분할 대상 바의 하바 찾기
      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls "
      SQL=SQL&" , opt, fl, busok, busoktype, doorglass_t, fixglass_t , blength , pcent , garo_sero , sunstatus "
      SQL=SQL&" From tk_framekSub "
      SQL=SQL&" where xi='"&axi&"' and fkidx='"&afkidx&"' "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and (whichi_auto= 8 or whichi_fix=5 )" 'whichi_auto= 8 자동하바  whichi_fix=5 수동하바
      Response.write (SQL)&"<br>2분할대상 하바<br>"
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
        bblength=Rs(19) '하바의 길이
        bpcent=Rs(20) '하바 할증값
        bgaro_sero=Rs(21) '가로 선정리
        bsunstatus=Rs(22) '상부픽스바 구분
        
      end If
      Rs.Close
    if bwhichi_auto = 8 then '자동 하바라면.
    '3. 복제할 중간소대 정보 찾기

    '3-1 양개일 경우 분할 하바 치수 적용 위치 선택을 위한 코드
      SQL="select min(xi) from tk_framekSub where fkidx='"&afkidx&"' and whichi_auto=13"
      Response.write (SQL)&"<br>문의 위치<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        wxi=Rs(0)  '문의 x좌표
        if axi < wxi Then
          wpoint="L"  '하바치수 오른쪽 적용
        else
          wpoint="R"  '하바치수 왼쪽 적용
        end if 

      End If
      Rs.Close
      response.write wpoint&"<br>"
      'response.end

      '픽스유리 yi 오사이떄문에 조건변경
      '대신 도어컬럼 가져옴

        SQL="select max(yi) from tk_framekSub where fkidx='"&afkidx&"' and( whichi_auto in (12,13) or whichi_fix in (12,13))"
        Response.write (SQL)&"<br>문의 위치<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            door_yi=Rs(0)  '문의 y좌표
        End If
        Rs.Close

      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype "
      SQL=SQL&" , glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t ,ysize ,blength , pcent , garo_sero , sunstatus ,xsize " 
      SQL=SQL&" From tk_framekSub  "
      SQL=SQL&" where yi='"&door_yi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and sunstatus=0"
      if wpoint="L" then
        SQL=SQL&" and xi=(select min(xi) from tk_frameksub where yi='"&door_yi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and xi<>0 and sunstatus=0 ) "
      elseif wpoint="R" then
        SQL=SQL&" and xi=(select max(xi) from tk_frameksub where yi='"&door_yi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and xi<>0 and sunstatus=0 ) "
      end if
      Response.write (SQL)&"<br>3복제할 중간소대<br>"
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
        cysize=Rs(19) '중간소대의 보이는 폭:가로 길이
        cblength=Rs(20) '중간소대의 길이
        cpcent=Rs(21) '중간소대 할증값
        cgaro_sero=Rs(22)
        csunstatus=Rs(23)
        cxsize=Rs(24) '중간소대의 보이는 깊이 

      end If
      Rs.Close

    elseif bwhichi_fix = 5 then '중간소대 라면. 수동에 중간소대. 

        '3. 복제할 세로중간통바 정보 찾기

        'ixi 유리의 x+w/2 
        'iyi
        ' iwi = 20 혹은 세로바의 w 가져오기
        ' ihi = 수동픽스유리의 h 가져오기
        ' tk_barasif 세로중간통바 찾기
        ' tk_framek 세로중간통바 도어높이 묻힘 가져오기
        SQL="Select  oh, fl "
        SQL=SQL&" From tk_framek  "
        SQL=SQL&" where fkidx='"&rfkidx&"' "
        Response.write (SQL)&"<br>세로중간통바 도어높이 묻힘 가져오기<br>"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then
                coh=Rs(0) '세로중간통바 도어높이 
                cfl=Rs(1) '세로중간통바 묻힘
                End If
            Rs.close

        SQL="Select  bfidx, whichi_fix, xsize,ysize,pcent "
        SQL=SQL&" From tk_barasif  "
        SQL=SQL&" where sjb_idx='"&rsjb_idx&"' "
        SQL=SQL&" and  WHICHI_FIX = 7 "
        Response.write (SQL)&"<br>3복제할 tk_barasif 세로중간통바 <br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            cbfidx=Rs(0) '세로중간통바 bfidx
            cwhichi_fix=Rs(1) '세로중간통바 whichi_fix
            cxsize=Rs(2) '세로중간통바 xsize
            cysize=Rs(3) '세로중간통바 ysize
            cpcent=Rs(4) '세로중간통바 할증값
        End If
        rs.close

        ixi=int( axi+(awi/2) ) - (bhi/2)  'x좌표 : 유리시작+ 유리가로/2 - 세로통바 보이는면20  /2
        iyi=ayi         'y좌표는 선택된 픽스유리 y좌표 동일
        iwi=bhi       '선택된 하바높이(20) 세로통바 보이는 20  동일
        ihi=ahi +  bhi +  bhi      '선택된 픽스유리  + 하바 + 묻힘
        cblength_chuga = coh + cfl '중간소대의 길이

        SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix "
        SQL=SQL&" , bfidx,  gls, xsize, ysize, doorglass_t, fixglass_t, blength, pcent ,chuga_jajae , garo_sero, sunstatus ,busoktype ) "
        SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"', 0, '"&bfidx&"', '"&cwhichi_fix&"' "
        SQL=SQL&" , '"&cbfidx&"', '0' , '"&cxsize&"', '"&cysize&"' "
        SQL=SQL&" , '"&bdoorglass_t&"', '"&bfixglass_t&"'  , '"&cblength_chuga&"', '"&cpcent&"' , '"&chuga_jajae&"' "
        SQL=SQL&" , '"&cgaro_sero&"', '"&csunstatus&"' , 1   ) "
        Response.write (SQL)&"<br>세로중간통바추가<br>"
        Dbcon.Execute (SQL)

        SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype "
        SQL=SQL&" , glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t ,ysize ,blength " 
        SQL=SQL&" From tk_framekSub  "
        SQL=SQL&" where WHICHI_FIX = 7 and fkidx='"&afkidx&"' "
        SQL=SQL&" and  gls=0 "
        Response.write (SQL)&"<br>3복제할 세로중간통바<br>"
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
            cysize=Rs(19) '중간소대의 보이는 폭:가로 길이
            cblength=Rs(20) '중간소대의 길이
        end If
        Rs.close

    end if  

    '4. 선택된 픽스유리 분할 너비 줄이기 (좌표이동 없음 : 픽스유리 너비/2 - 중간소대 너비/2)
        'aalength '가로내경 --?변경 size_habar 가로내경  ablength '세로내경 aglass_w '가로 유리치수 aglass_h '세로 유리치수


            alength_cal_1 = Int(size_habar)  '가로내경 재계산
            blength_cal_1 = ablength    '세로내경은 그대로      
            alength_cal_2 = Int(aalength - cysize - size_habar)  '가로내경 재계산
            blength_cal_2 = ablength    '세로내경은 그대로  

            '픽스유리 뺴는 공식 테이블 가져와서 적용하기.

        '좌측일 경우 값 변경 
        If wpoint="L" then 
          talength_cal_1=alength_cal_1
          tblength_cal_1=blength_cal_1

          alength_cal_1=alength_cal_2
          blength_cal_1=blength_cal_2
          alength_cal_2=talength_cal_1
          blength_cal_2=tblength_cal_1
        End If

        sql=" select  c.gwsize1, c.ghsize1 ,c.gwsize2, c.ghsize2 ,a.whichi_fix,a.whichi_auto "
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" join tk_frame e on  b.fidx = e.fidx "
        sql=sql&" Where a.fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br>---<<유리뺴는 공식 가져오기>>-----<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 

            gwsize1 = Rs(0) '유리 너비
            ghsize1 = Rs(1) '유리 높이
            gwsize2 = Rs(2) '유리 너비 '박스라인경우
            ghsize2 = Rs(3) '유리 높이 '박스라인경우
            gwhichi_fix = Rs(4) '픽스유리 whichi_fix 
            gwhichi_auto = Rs(5) '픽스유리 whichi_auto
        end If
        Rs.Close
        '수동 whichi_fix 14,15 일때 하부픽스유리 19일떄 박스라인하부픽스유리
        '자동 whichi_auto 14,15 일때 하부픽스유리 
        if ( gwhichi_fix=14 or  gwhichi_fix=15 ) or ( gwhichi_auto=14 or  gwhichi_auto=15 ) then
          If rsjb_type_no >=1 and rsjb_type_no <= 4 Then '픽스하바에 상부오사이 있는경우
            glass_w_cal_1 = alength_cal_1 + gwsize1 
            glass_h_cal_1 = blength_cal_1 + ghsize1 + 25
            glass_w_cal_2 = alength_cal_2 + gwsize1
            glass_h_cal_2 = blength_cal_2 + ghsize1 + 25 
          else
            glass_w_cal_1 = alength_cal_1 + gwsize1 
            glass_h_cal_1 = blength_cal_1 + ghsize1 
            glass_w_cal_2 = alength_cal_2 + gwsize1
            glass_h_cal_2 = blength_cal_2 + ghsize1
          End if

        elseif ( gwhichi_fix=19 )  then

          glass_w_cal_1 = alength_cal_1 + gwsize2
          glass_h_cal_1 = blength_cal_1 + ghsize2
          glass_w_cal_2 = alength_cal_2 + gwsize2
          glass_h_cal_2 = blength_cal_2 + ghsize2

        else

        end if
        dwi=round(awi/2-cwi/2)  'awi 픽스유리가로 - cwi 중간소대가로 20
           
        response.write dwi&"<br>"
        response.write awi&"<br>"
        response.write cwi&"<br>"
        Response.Write "aglass_w: " & aglass_w & "<br>"
        Response.Write "cysize: " & cysize & "<br>"
        Response.Write "aglass_h: " & aglass_h & "<br>"
        Response.Write "alength_cal_1: " & alength_cal_1 & "<br>"
        Response.Write "blength_cal_1: " & blength_cal_1 & "<br>"
        Response.Write "glass_w_cal_1: " & glass_w_cal_1 & "<br>"
        Response.Write "glass_h_cal_1: " & glass_h_cal_1 & "<br>"
        Response.Write "alength_cal_2: " & alength_cal_2 & "<br>"
        Response.Write "blength_cal_2: " & blength_cal_2 & "<br>"
        Response.Write "glass_w_cal_2: " & glass_w_cal_2 & "<br>"
        Response.Write "glass_h_cal_2: " & glass_h_cal_2 & "<br>"
        

      SQL="Update tk_framekSub set wi='"&dwi&"' "
      SQL=SQL&" , alength='"&alength_cal_1&"' ,blength='"&blength_cal_1&"' "
      SQL=SQL&" ,glass_w='"&glass_w_cal_1&"' ,glass_h='"&glass_h_cal_1&"' , busoktype=1 "
      SQL=SQL&" Where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>선택된 픽스유리 너비줄이기<br>/"
      Dbcon.Execute (SQL)

    '5. 픽스유리추가 (좌표 : 픽스유리 x좌표 + 중간소대 너비, y좌표 동일 : 너비는 줄여진 너비와 동일)
    
      exi=axi+dwi+cwi 'x좌표 : 픽스유리 x좌표 + 분할된 픽스유리너비 + 중간소대 너비
      eyi=ayi     'y좌표 : 픽스유리 x좌표와 동일
      ewi=awi-dwi-cwi     '너비 : 수정된 픽스유리와 동일
      ehi=ahi     '높이 : 픽스유리 높이와 동일
        'size_habar 입력하바치수

      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , alength, blength, glass_w, glass_h ) "
      SQL=SQL&" values( '"&exi&"', '"&eyi&"', '"&ewi&"', '"&ehi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&afsidx&"', '"&afidx&"', '"&awhichi_fix&"' "
      SQL=SQL&" , '"&awhichi_auto&"', '"&abfidx&"', '"&afstype&"', '"&aglasstype&"', '"&agls&"', '"&aopt&"', '"&afl&"', '"&abusok&"', 1 "
      SQL=SQL&" , '"&adoorglass_t&"', '"&afixglass_t&"' , '"&alength_cal_2&"', '"&blength_cal_2&"', '"&glass_w_cal_2&"', '"&glass_h_cal_2&"' )"
      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)

    '6. 하바분할 너비 줄이기(좌표이동 없음 : 하바 너비/2 - 중간소대 너비/2)
      fwi=bwi/2-cwi/2

      if wpoint = "L" then '하바 값 변경
        size_habar = alength_cal_1
      end if

      SQL="Update tk_framekSub set wi='"&fwi&"',blength='"&size_habar&"',busoktype=1 Where fksidx='"&bfksidx&"' "
      Response.write (SQL)&"<br>분할된 하바 너비 줄이기<br>"
      Dbcon.Execute (SQL)

    '7. 하바추가 
      gxi=bxi+fwi+cwi 'x좌표 : 픽스유리 x좌표 + 중간소대 너비
      gyi=byi     'y좌표 : 픽스유리 x좌표와 동일
      gwi=bwi-fwi-cwi     '너비 : 수정된 픽스유리와 동일
      ghi=bhi     '높이 : 픽스유리 높이와 동일
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , blength , pcent, chuga_jajae ) "
      SQL=SQL&" values( '"&gxi&"', '"&gyi&"', '"&gwi&"', '"&ghi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&bfsidx&"', '"&bfidx&"', '"&bwhichi_fix&"' "
      SQL=SQL&" , '"&bwhichi_auto&"', '"&bbfidx&"', '"&bfstype&"', '"&bglasstype&"', '"&bgls&"', '"&bopt&"', '"&bfl&"', '"&bbusok&"' "
      SQL=SQL&" , 1 , '"&bdoorglass_t&"', '"&bfixglass_t&"' , '"&alength_cal_2&"' , '"&bpcent&"' , '"&chuga_jajae&"' )"
      Response.write (SQL)&"<br>하바추가<br>"
      Dbcon.Execute (SQL)


  
    if bwhichi_auto = 8 then '자동 하바라면.

        '8. 중간소대 추가 
        ixi=axi+dwi   'x좌표 : 수정된 픽스유리 x좌표+픽스유리 너비
        iyi=door_yi       'y좌표는 도어의 yi좌표 . 오사이때문
        iwi=cwi       '기존 중간소대의 너비
        ihi=chi       '기존 중간소대의 높이
        SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
        SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t, blength , pcent , chuga_jajae ,garo_sero ,sunstatus ,xsize, ysize ) "
        SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&cfsidx&"', '"&cfidx&"', '"&cwhichi_fix&"' "
        SQL=SQL&" , '"&cwhichi_auto&"', '"&cbfidx&"', '"&cfstype&"', '"&cglasstype&"', '"&cgls&"', '"&copt&"', '"&cfl&"', '"&cbusok&"', 1 "
        SQL=SQL&" , '"&cdoorglass_t&"', '"&cfixglass_t&"' , '"&cblength&"', '"&cpcent&"' , '"&chuga_jajae&"', '"&cgaro_sero&"' , '"&csunstatus&"' , '"&cxsize&"', '"&cysize&"' ) "
        Response.write (SQL)&"<br>중간소대추가<br>"
        Dbcon.Execute (SQL)

        '9. 1.픽스상바 업데이트 ,2.오사이 업데이트 ,3 픽스상바 추가 4 오사이 추가 

                'rSJB_TYPE_NO 1,3 알자,단알자,슬림자동문은 상부남마 오사이가 없으므로 sunstatus = 0, 1
                'rSJB_TYPE_NO 2.4 복층알자,삼중단알자는 상부남마 오사이가 있음 sunstatus = 0, 1 ,2
                'rSJB_TYPE_NO 나머진 sunstatus = 0
                'sunstatus=1 은 픽스하부유리 위에 상부픽스 
                'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 
                'sunstatus=3 은 하부픽스위에 상부남마 에
                'sunstatus=4 은 양개 중앙에
                'sunstatus=5 은 t형_자동홈바
                'sunstatus=6 은 박스커버

        if rsjb_type_no >= 1 and rsjb_type_no <= 4 then '알자, 복층알자 ,단알자 삼중단알자  
            'whichi_auto 픽스상바 9 오사이 24
            '1.픽스상바 wi 업데이트 하고. blength 업데이트
            SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls "
            SQL=SQL&" , opt, fl, busok, busoktype, doorglass_t, fixglass_t , blength , pcent, garo_sero ,sunstatus"
            SQL=SQL&" From tk_framekSub "
            SQL=SQL&" where xi='"&axi&"' and fkidx='"&afkidx&"' and sunstatus=1 " '선택한 픽스하부유리의 x좌표axi ,sunstatus=1 은 픽스하부유리 위에 상부픽스
            SQL=SQL&" and fksidx<>'"&rfksidx&"' "
            SQL=SQL&" and (whichi_auto= 9 )" '픽스상바 whichi_auto=9 
            Response.write (SQL)&"<br>픽스상바 불러오기<br>"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then 
                fix_sangbar_xi        = Rs(0)
                fix_sangbar_yi        = Rs(1)
                fix_sangbar_wi        = Rs(2)
                fix_sangbar_hi        = Rs(3)
                fix_sangbar_fksidx    = Rs(4)
                fix_sangbar_fsidx     = Rs(5)
                fix_sangbar_fidx      = Rs(6)
                fix_sangbar_whichi_fix= Rs(7)
                fix_sangbar_whichi_auto= Rs(8)
                fix_sangbar_bfidx     = Rs(9)
                fix_sangbar_fstype    = Rs(10)
                fix_sangbar_glasstype = Rs(11)
                fix_sangbar_gls       = Rs(12)
                fix_sangbar_opt       = Rs(13)
                fix_sangbar_fl        = Rs(14)
                fix_sangbar_busok     = Rs(15)
                fix_sangbar_busoktype = Rs(16)
                fix_sangbar_doorglass_t = Rs(17)
                fix_sangbar_fixglass_t  = Rs(18)
                fix_sangbar_blength   = Rs(19) '픽스상바 길이
                fix_sangbar_pcent     = Rs(20) '픽스상바 할증값
                fix_sangbar_garo_sero = Rs(21)
                fix_sangbar_sunstatus = Rs(22) '픽스상바 sunstatus
            end If
            Rs.Close 

            SQL="Update tk_framekSub set wi='"&fwi&"',blength='"&size_habar&"' , busoktype=1 Where fksidx='"&fix_sangbar_fksidx&"' "
            Response.write (SQL)&"<br>픽스상바 wi 업데이트 하고. blength 업데이트<br>"
            Dbcon.Execute (SQL)

            '2.오사이 wi 업데이트 하고. blength 업데이트
            SQL="Select top 2 fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls "
            SQL=SQL&" , opt, fl, busok, busoktype, doorglass_t, fixglass_t , blength , pcent, garo_sero ,sunstatus"
            SQL=SQL&" From tk_framekSub "
            SQL=SQL&" where fkidx='"&afkidx&"' and sunstatus=1 and xi='"&axi&"' " '선택한 픽스하부유리의 x좌표axi ,sunstatus=1 은 픽스하부유리 위에 상부픽스
            'SQL=SQL&" and blength='"&rfksidx&"' "
            SQL=SQL&" and fksidx<>'"&rfksidx&"' "
            SQL=SQL&" and (whichi_auto=24) " '오사이 whichi_auto=24 
            SQL=SQL&" order by fksidx desc " '여러개중 2개만.
            Response.write (SQL)&"<br>픽스상바_오사이 불러오기<br>"
            Rs.open Sql,Dbcon

            cnt = 0

            Do Until Rs.EOF Or cnt >= 2   '2개까지만 담기

                cnt = cnt + 1
                
                If cnt = 1 Then
                    sang_542_fksidx1      = Rs(0)
                    sang_542_fsidx1       = Rs(1)
                    sang_542_fidx1        = Rs(2)
                    sang_542_whichi_fix1  = Rs(3)
                    sang_542_whichi_auto1 = Rs(4)
                    sang_542_bfidx1       = Rs(5)
                    sang_542_fstype1      = Rs(6)
                    sang_542_glasstype1   = Rs(7)
                    sang_542_gls1         = Rs(8)
                    sang_542_opt1         = Rs(9)
                    sang_542_fl1          = Rs(10)
                    sang_542_busok1       = Rs(11)
                    sang_542_busoktype1   = Rs(12)
                    sang_542_doorglass_t1 = Rs(13)
                    sang_542_fixglass_t1  = Rs(14)
                    sang_542_blength1     = Rs(15)
                    sang_542_pcent1       = Rs(16)
                    sang_542_garo_sero1   = Rs(17)
                    sang_542_sunstatus1   = Rs(18)
                ElseIf cnt = 2 Then
                    sang_542_fksidx2      = Rs(0)
                    sang_542_fsidx2       = Rs(1)
                    sang_542_fidx2        = Rs(2)
                    sang_542_whichi_fix2  = Rs(3)
                    sang_542_whichi_auto2 = Rs(4)
                    sang_542_bfidx2       = Rs(5)
                    sang_542_fstype2      = Rs(6)
                    sang_542_glasstype2   = Rs(7)
                    sang_542_gls2         = Rs(8)
                    sang_542_opt2         = Rs(9)
                    sang_542_fl2          = Rs(10)
                    sang_542_busok2       = Rs(11)
                    sang_542_busoktype2   = Rs(12)
                    sang_542_doorglass_t2 = Rs(13)
                    sang_542_fixglass_t2  = Rs(14)
                    sang_542_blength2     = Rs(15)
                    sang_542_pcent2       = Rs(16)
                    sang_542_garo_sero2   = Rs(17)
                    sang_542_sunstatus2   = Rs(18)
                End If
                
                Rs.MoveNext
            Loop

            Rs.Close

            size_habar_542 = size_habar - 1

            SQL="Update tk_framekSub set blength='"&size_habar_542&"' Where fksidx='"&sang_542_fksidx1&"' "
            Response.write (SQL)&"<br>픽스상바 wi 업데이트 하고. blength 업데이트<br>"
            Dbcon.Execute (SQL)

            '3.하바픽스의 오사이  blength 업데이트

            SQL="Update tk_framekSub set blength='"&size_habar_542&"' Where fksidx='"&sang_542_fksidx2&"' "
            Response.write (SQL)&"<br>픽스상바 wi 업데이트 하고. blength 업데이트<br>"
            Dbcon.Execute (SQL)
            
            '4.픽스상바 인서트 추가유리의 xi 가져오고 yi 입데이트값동일 wi 입데이트값동일 hi 기존값동일
            gxi=bxi+fwi+cwi 'x좌표 : 픽스유리 x좌표 + 중간소대 너비 
            'iyi=door_yi  y좌표는 도어의 yi좌표 . 오사이때문
            'gwi=bwi-fwi-cwi     너비 : 수정된 픽스유리와 동일
            'fix_sangbar_hi 기존 픽스상바의 높이
            SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
            SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t, blength , pcent , chuga_jajae "
            SQL=SQL&" , garo_sero , sunstatus ) "
            SQL=SQL&" values( '"&gxi&"', '"&iyi&"', '"&gwi&"', '"&fix_sangbar_hi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&cfsidx&"', '"&cfidx&"', '"&fix_sangbar_whichi_fix&"' "
            SQL=SQL&" , '"&fix_sangbar_whichi_auto&"', '"&fix_sangbar_bfidx&"', '"&fix_sangbar_fstype&"', '"&fix_sangbar_glasstype&"', '"&fix_sangbar_gls&"', '"&fix_sangbar_opt&"', '"&fix_sangbar_fl&"', '"&fix_sangbar_busok&"', 1 "
            SQL=SQL&" , '"&fix_sangbar_doorglass_t&"', '"&fix_sangbar_fixglass_t&"' , '"&alength_cal_2&"', '"&fix_sangbar_pcent&"' , '"&chuga_jajae&"' "
            SQL=SQL&" , '"&fix_sangbar_garo_sero&"' , '"&fix_sangbar_sunstatus&"' )"
            Response.write (SQL)&"<br>픽스상바 인서트<br>"
            Dbcon.Execute (SQL)

            '5.오사이 인서트 추가유리의 blength 인서트 (픽스값과 -1 차이 )
            alength_542_cal_2 = alength_cal_2 - 1
            SQL="Insert into tk_framekSub (fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
            SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t, blength , pcent , chuga_jajae , garo_sero , sunstatus ) "
            SQL=SQL&" values( '"&c_midx&"', getdate(), '"&afkidx&"','"&sang_542_fsidx1&"', '"&sang_542_fidx1&"', '"&sang_542_whichi_fix1&"' "
            SQL=SQL&" , '"&sang_542_whichi_auto1&"', '"&sang_542_bfidx1&"', '"&sang_542_fstype1&"', '"&sang_542_glasstype1&"', '"&sang_542_gls1&"', '"&sang_542_opt1&"', '"&sang_542_fl1&"', '"&sang_542_busok1&"', 1  "
            SQL=SQL&" , '"&sang_542_doorglass_t1&"', '"&sang_542_fixglass_t1&"' , '"&alength_542_cal_2&"', '"&sang_542_pcent1&"' , '"&chuga_jajae&"' , '"&sang_542_garo_sero1&"', '"&sang_542_sunstatus1&"' )"
            Response.write (SQL)&"<br>오사이 인서트_상부오사이<br>"
            Dbcon.Execute (SQL)
            SQL="Insert into tk_framekSub (fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
            SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t, blength , pcent , chuga_jajae , garo_sero , sunstatus ) "
            SQL=SQL&" values( '"&c_midx&"', getdate(), '"&afkidx&"','"&sang_542_fsidx1&"', '"&sang_542_fidx1&"', '"&sang_542_whichi_fix1&"' "
            SQL=SQL&" , '"&sang_542_whichi_auto1&"', '"&sang_542_bfidx1&"', '"&sang_542_fstype1&"', '"&sang_542_glasstype1&"', '"&sang_542_gls1&"', '"&sang_542_opt1&"', '"&sang_542_fl1&"', '"&sang_542_busok1&"', 1 "
            SQL=SQL&" , '"&sang_542_doorglass_t1&"', '"&sang_542_fixglass_t1&"' , '"&alength_542_cal_2&"', '"&sang_542_pcent1&"' , '"&chuga_jajae&"'  ,'"&sang_542_garo_sero2&"', '"&sang_542_sunstatus1&"' )"
            Response.write (SQL)&"<br>오사이 인서트_하부오사이<br>"
            Dbcon.Execute (SQL)

        end if

    end if

        Response.Write "size_habar_542 : " & size_habar_542 & "<br>"  
        Response.Write "alength_542_cal_2 : " & alength_542_cal_2 & "<br>"  
        response.write awi&"<br>"
        response.write bwi&"<br>"
        response.write cwi&"<br>"
        response.write dwi&"<br>"
        response.write ewi&"<br>"
        response.write fwi&"<br>"
        response.write gwi&"<br>"
'response.end

    if mode="quick" then

        Response.Write "<script>opener.location.replace('TNG1_B_suju_quick.asp?sjidx=" & rsjidx & _
                        "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & _
                        "&sjb_type_no=" & rsjb_type_no & "');window.close();</script>"

    else
        Response.Write "<script>opener.location.replace('TNG1_B_suju2.asp?sjidx=" & rsjidx & _
                        "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & _
                        "&sjb_type_no=" & rsjb_type_no & "');window.close();</script>"
    end if

  elseif  roptions="2" then   '2:하바1개중간소대
    response.write "<br>2:하바1개중간소대<br>"
    response.write "<br>1:하바분할중간소대<br>"
    '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , alength, blength , glass_w , glass_h, garo_sero , sunstatus " 
      SQL=SQL&" From tk_framekSub where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>1분할대상 픽스유리<br>"
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
        aalength=Rs(19) '가로내경
        ablength=Rs(20) '세로내경
        aglass_w=Rs(21) '가로 유리치수
        aglass_h=Rs(22) '세로 유리치수
        agaro_sero=Rs(23) '가로 선정리
        asunstatus=Rs(24) '상부픽스바 구분
       
      end If
      Rs.Close
                                          
    '2. 분할 대상 바의 하바 찾기
      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls "
      SQL=SQL&" , opt, fl, busok, busoktype, doorglass_t, fixglass_t , blength , pcent , garo_sero , sunstatus , ysize "
      SQL=SQL&" From tk_framekSub "
      SQL=SQL&" where xi='"&axi&"' and fkidx='"&afkidx&"' "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and (whichi_auto= 8 or whichi_fix=5 )" 'whichi_auto= 8 자동하바  whichi_fix=5 수동하바
      Response.write (SQL)&"<br>2분할대상 하바<br>"
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
        bblength=Rs(19) '하바의 길이
        bpcent=Rs(20) '하바 할증값
        bgaro_sero=Rs(21) '가로 선정리
        bsunstatus=Rs(22) '상부픽스바 구분
        bysize=Rs(23)
       
      end If
      Rs.Close
    if bwhichi_auto = 8 then '자동이라면.
    '3. 복제할 중간소대 정보 찾기

    '3-1 양개일 경우 분할 하바 치수 적용 위치 선택을 위한 코드
      SQL="select min(xi) from tk_framekSub where fkidx='"&afkidx&"' and whichi_auto=13"
      Response.write (SQL)&"<br>문의 위치<br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        wxi=Rs(0)  '문의 x좌표
        if axi < wxi Then
          wpoint="L"  '하바치수 오른쪽 적용
        else
          wpoint="R"  '하바치수 왼쪽 적용
        end if 

      End If
      Rs.Close
      response.write wpoint&"<br>"
      'response.end

      '픽스유리 yi 오사이떄문에 조건변경
      '대신 도어컬럼 가져옴

        SQL="select max(yi) from tk_framekSub where fkidx='"&afkidx&"' and( whichi_auto in (12,13) or whichi_fix in (12,13))"
        Response.write (SQL)&"<br>문의 위치<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            door_yi=Rs(0)  '문의 y좌표
        End If
        Rs.Close

      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype "
      SQL=SQL&" , glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t ,ysize ,blength , pcent , garo_sero , sunstatus " 
      SQL=SQL&" From tk_framekSub  "
      SQL=SQL&" where yi='"&door_yi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and sunstatus=0"
      if wpoint="L" then
        SQL=SQL&" and xi=(select min(xi) from tk_frameksub where yi='"&door_yi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and xi<>0 and sunstatus=0 ) "
      elseif wpoint="R" then
        SQL=SQL&" and xi=(select max(xi) from tk_frameksub where yi='"&door_yi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and xi<>0 and sunstatus=0 ) "
      end if
      Response.write (SQL)&"<br>3복제할 중간소대<br>"
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
        cfl=Rs(14)
        cbusok=Rs(15)
        cbusoktype=Rs(16)
        cdoorglass_t=Rs(17)
        cfixglass_t=Rs(18)
        cysize=Rs(19) '중간소대의 보이는 폭:가로 길이
        cblength=Rs(20) '중간소대의 길이
        cpcent=Rs(21) '중간소대 할증값
        cgaro_sero=Rs(22)
        csunstatus=Rs(23)
      
      end If
      Rs.Close

    elseif bwhichi_fix = 5 then '수동이라면.

      '3. 복제할 세로중간통바 정보 찾기

        'ixi 유리의 x+w/2 
        'iyi
        ' iwi = 20 혹은 세로바의 w 가져오기
        ' ihi = 수동픽스유리의 h 가져오기
        ' tk_barasif 세로중간통바 찾기
        ' tk_framek 세로중간통바 도어높이 묻힘 가져오기
      SQL="Select  oh, fl "
      SQL=SQL&" From tk_framek  "
      SQL=SQL&" where fkidx='"&rfkidx&"' "
      Response.write (SQL)&"<br>세로중간통바 도어높이 묻힘 가져오기<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then
            coh=Rs(0) '세로중간통바 도어높이 
            cfl=Rs(1) '세로중간통바 묻힘
            End If
        Rs.close

      SQL="Select  bfidx, whichi_fix, xsize,ysize,pcent "
      SQL=SQL&" From tk_barasif  "
      SQL=SQL&" where sjb_idx='"&rsjb_idx&"' "
      SQL=SQL&" and  WHICHI_FIX = 7 "
      Response.write (SQL)&"<br>3복제할 tk_barasif 세로중간통바 <br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        cbfidx=Rs(0) '세로중간통바 bfidx
        cwhichi_fix=Rs(1) '세로중간통바 whichi_fix
        cxsize=Rs(2) '세로중간통바 xsize
        cysize=Rs(3) '세로중간통바 ysize
        cpcent=Rs(4) '세로중간통바 할증값
      End If
      rs.close

      ixi=int( axi+(awi/2) ) - (bhi/2)  'x좌표 : 유리시작+ 유리가로/2 - 세로통바 보이는면20  /2
      iyi=ayi         'y좌표는 선택된 픽스유리 y좌표 동일
      iwi=bhi       '선택된 하바높이(20) 세로통바 보이는 20  동일
      ihi=ahi      '선택된 픽스유리  
      cblength_chuga =  ablength '중간소대의 길이

      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix "
      SQL=SQL&" , bfidx,  gls, xsize, ysize, doorglass_t, fixglass_t, blength, pcent ,chuga_jajae , garo_sero, sunstatus ,busoktype ) "
      SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"', 0, '"&bfidx&"', '"&cwhichi_fix&"' "
      SQL=SQL&" , '"&cbfidx&"', '0' , '"&cxsize&"', '"&cysize&"' "
      SQL=SQL&" , '"&bdoorglass_t&"', '"&bfixglass_t&"'  , '"&cblength_chuga&"', '"&cpcent&"' , '"&chuga_jajae&"' "
      SQL=SQL&" , '"&cgaro_sero&"', '"&csunstatus&"' , 1   ) "
      Response.write (SQL)&"<br>세로중간통바추가<br>"
      Dbcon.Execute (SQL)

      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype "
      SQL=SQL&" , glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t ,ysize ,blength " 
      SQL=SQL&" From tk_framekSub  "
      SQL=SQL&" where WHICHI_FIX = 7 and fkidx='"&afkidx&"' "
      SQL=SQL&" and  gls=0 "
      Response.write (SQL)&"<br>3복제할 세로중간통바<br>"
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
        cysize=Rs(19) '중간소대의 보이는 폭:가로 길이
        cblength=Rs(20) '중간소대의 길이
      end If
      Rs.close

    end if  

    '4. 선택된 픽스유리 분할 너비 줄이기 (좌표이동 없음 : 픽스유리 너비/2 - 중간소대 너비/2)
        'aalength '가로내경 --?변경 size_habar 가로내경  ablength '세로내경 aglass_w '가로 유리치수 aglass_h '세로 유리치수

        alength_cal_1 = Int(size_habar)  '가로내경 재계산
        blength_cal_1 = ablength    '세로내경은 그대로      
        alength_cal_2 = Int(aalength - cysize - size_habar)  '가로내경 재계산
        blength_cal_2 = ablength    '세로내경은 그대로        
        '픽스유리 뺴는 공식 테이블 가져와서 적용하기.

        If wpoint="L" then 
          talength_cal_1=alength_cal_1
          tblength_cal_1=blength_cal_1

          alength_cal_1=alength_cal_2
          blength_cal_1=blength_cal_2
          alength_cal_2=talength_cal_1
          blength_cal_2=tblength_cal_1
        End If
        
        sql=" select  c.gwsize1, c.ghsize1 ,c.gwsize2, c.ghsize2 ,a.whichi_fix,a.whichi_auto "
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" join tk_frame e on  b.fidx = e.fidx "
        sql=sql&" Where a.fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br>---<<유리뺴는 공식 가져오기>>-----<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 

            gwsize1 = Rs(0) '유리 너비
            ghsize1 = Rs(1) '유리 높이
            gwsize2 = Rs(2) '유리 너비 '박스라인경우
            ghsize2 = Rs(3) '유리 높이 '박스라인경우
            gwhichi_fix = Rs(4) '픽스유리 whichi_fix 
            gwhichi_auto = Rs(5) '픽스유리 whichi_auto
        end If
        Rs.Close
        '수동 whichi_fix 14,15 일때 하부픽스유리 19일떄 박스라인하부픽스유리
        '자동 whichi_auto 14,15 일때 하부픽스유리 
        if ( gwhichi_fix=14 or  gwhichi_fix=15 ) or ( gwhichi_auto=14 or  gwhichi_auto=15 ) then
          If rsjb_type_no >=1 and rsjb_type_no <= 4 Then '픽스하바에 상부오사이 있는경우
            glass_w_cal_1 = alength_cal_1 + gwsize1 
            glass_h_cal_1 = blength_cal_1 + ghsize1 + 25
            glass_w_cal_2 = alength_cal_2 + gwsize1
            glass_h_cal_2 = blength_cal_2 + ghsize1 + 25 
          else
            glass_w_cal_1 = alength_cal_1 + gwsize1 
            glass_h_cal_1 = blength_cal_1 + ghsize1 
            glass_w_cal_2 = alength_cal_2 + gwsize1
            glass_h_cal_2 = blength_cal_2 + ghsize1
          End if

        elseif ( gwhichi_fix=19 )  then

          glass_w_cal_1 = alength_cal_1 + gwsize2
          glass_h_cal_1 = blength_cal_1 + ghsize2
          glass_w_cal_2 = alength_cal_2 + gwsize2
          glass_h_cal_2 = blength_cal_2 + ghsize2

        else

        end if

      dwi=round(awi/2-cwi/2) 'awi 픽스유리가로 - cwi 중간소대가로 20

      response.write dwi&"<br>"
      response.write awi&"<br>"
      response.write cwi&"<br>"
      Response.Write "aglass_w: " & aglass_w & "<br>"
        Response.Write "cysize: " & cysize & "<br>"
        Response.Write "aglass_h: " & aglass_h & "<br>"
        Response.Write "alength_cal_1: " & alength_cal_1 & "<br>"
        Response.Write "blength_cal_1: " & blength_cal_1 & "<br>"
        Response.Write "glass_w_cal_1: " & glass_w_cal_1 & "<br>"
        Response.Write "glass_h_cal_1: " & glass_h_cal_1 & "<br>"
        Response.Write "alength_cal_2: " & alength_cal_2 & "<br>"
        Response.Write "blength_cal_2: " & blength_cal_2 & "<br>"
        Response.Write "glass_w_cal_2: " & glass_w_cal_2 & "<br>"
        Response.Write "glass_h_cal_2: " & glass_h_cal_2 & "<br>"


      SQL="Update tk_framekSub set wi='"&dwi&"' "
      SQL=SQL&" , alength='"&alength_cal_1&"' ,blength='"&blength_cal_1&"' "
      SQL=SQL&" ,glass_w='"&glass_w_cal_1&"' ,glass_h='"&glass_h_cal_1&"' , busoktype=1 "
      SQL=SQL&" Where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>선택된 픽스유리 너비줄이기<br>/"
      Dbcon.Execute (SQL)

    '5. 픽스유리추가 (좌표 : 픽스유리 x좌표 + 중간소대 너비, y좌표 동일 : 너비는 줄여진 너비와 동일)
      exi=axi+dwi+cwi 'x좌표 : 픽스유리 x좌표 + 분할된 픽스유리너비 + 중간소대 너비
      eyi=ayi     'y좌표 : 픽스유리 x좌표와 동일
      ewi=awi-dwi-cwi     '너비 : 수정된 픽스유리와 동일
      ehi=ahi     '높이 : 픽스유리 높이와 동일
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , alength, blength, glass_w, glass_h ) "
      SQL=SQL&" values( '"&exi&"', '"&eyi&"', '"&ewi&"', '"&ehi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&afsidx&"', '"&afidx&"', '"&awhichi_fix&"' "
      SQL=SQL&" , '"&awhichi_auto&"', '"&abfidx&"', '"&afstype&"', '"&aglasstype&"', '"&agls&"', '"&aopt&"', '"&afl&"', '"&abusok&"', 1 "
      SQL=SQL&" , '"&adoorglass_t&"', '"&afixglass_t&"' , '"&alength_cal_2&"', '"&blength_cal_2&"', '"&glass_w_cal_2&"', '"&glass_h_cal_2&"' )"
      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)

    if bwhichi_auto = 8 then '자동이라면.

    '6. 중간소대 추가
      ixi=axi+dwi   'x좌표 : 수정된 픽스유리 x좌표+픽스유리 너비
      iyi=ayi       'y좌표는 수정된 픽스 유리의 y좌표와 동일
      iwi=cwi       '기존 중간소대의 너비
      ihi=ahi       '추가된 픽스유리의 높이와 동일
      cblength_chuga1 = cblength - bysize
      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t, blength , pcent ,chuga_jajae ,garo_sero ,sunstatus ) "
      SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"','"&cfsidx&"', '"&cfidx&"', '"&cwhichi_fix&"' "
      SQL=SQL&" , '"&cwhichi_auto&"', '"&cbfidx&"', '"&cfstype&"', '"&cglasstype&"', '"&cgls&"', '"&copt&"', '"&cfl&"', '"&cbusok&"', '"&cbusoktype&"' "
      SQL=SQL&" , '"&cdoorglass_t&"', '"&cfixglass_t&"' , '"&cblength_chuga1&"', '"&cpcent&"' , '"&chuga_jajae&"', '"&cgaro_sero&"' , '"&csunstatus&"' )"
      Response.write (SQL)&"<br>중간소대추가<br>"
      Dbcon.Execute (SQL)

    end if

    if mode="quick" then

        Response.Write "<script>opener.location.replace('TNG1_B_suju_quick.asp?sjidx=" & rsjidx & _
                        "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & _
                        "&sjb_type_no=" & rsjb_type_no & "');window.close();</script>"

    else
        Response.Write "<script>opener.location.replace('TNG1_B_suju2.asp?sjidx=" & rsjidx & _
                        "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & _
                        "&sjb_type_no=" & rsjb_type_no & "');window.close();</script>"
    end if
response.end
elseif  roptions="3" then   '3:가로 분할 중간소대

    response.write "<br>1:하바분할중간소대<br>"
    response.write "<br>2:하바1개중간소대<br>"
    response.write "<br>3:가로 분할 중간소대<br>"
    
        '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
        SQL="SELECT xi, yi, wi, hi, fkidx, fsidx, fidx, "
        SQL=SQL&" WHICHI_FIX, WHICHI_AUTO, "
        SQL=SQL&" bfidx, bwsize, bhsize, gwsize, ghsize, "
        SQL=SQL&" fstype, glasstype, blength, unitprice, pcent, sprice, "
        SQL=SQL&" xsize, ysize, gls, OPT, FL, "
        SQL=SQL&" door_w, door_h, glass_w, glass_h, "
        SQL=SQL&" busok, busoktype, doorglass_t, fixglass_t, "
        SQL=SQL&" doortype, doorglass_w, doorglass_h, "
        SQL=SQL&" doorsizechuga_price, door_price, "
        SQL=SQL&" goname, barNAME, alength, chuga_jajae, "
        SQL=SQL&" rstatus, rstatus2, garo_sero, groupcode, sunstatus "
        SQL=SQL&" FROM tk_framekSub WHERE fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br>1분할대상 픽스유리<br>"
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
            abwsize=Rs(10)
            abhsize=Rs(11)
            agwsize=Rs(12)
            aghsize=Rs(13)
            afstype=Rs(14)
            aglasstype=Rs(15)
            ablength=Rs(16)
            aunitprice=Rs(17)
            apcent=Rs(18)
            asprice=Rs(19)
            axsize=Rs(20)
            aysize=Rs(21)
            agls=Rs(22)
            aopt=Rs(23)
            afl=Rs(24)
            adoor_w=Rs(25)
            adoor_h=Rs(26)
            aglass_w=Rs(27)
            aglass_h=Rs(28)
            abusok=Rs(29)
            abusoktype=Rs(30)
            adoorglass_t=Rs(31)
            afixglass_t=Rs(32)
            adoortype=Rs(33)
            adoorglass_w=Rs(34)
            adoorglass_h=Rs(35)
            adoor_chuga_price=Rs(36)
            adoor_price=Rs(37)
            agoname=Rs(38)
            abarnane=Rs(39)
            aalength=Rs(40)
            achuga_jajae=Rs(41)
            arstatus=Rs(42)
            arstatus2=Rs(43)
            agaro_sero=Rs(44)
            agroupcode=Rs(45)
            asunstatus=Rs(46)
       
        end If
        Rs.Close
                                          
    '2. 분할 대상 바의 하바 찾기
      SQL="Select xi, yi, wi, hi, fksidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls "
      SQL=SQL&" , opt, fl, busok, busoktype, doorglass_t, fixglass_t , blength, pcent ,ysize "
      SQL=SQL&" From tk_framekSub "
      SQL=SQL&" where xi='"&axi&"' and fkidx='"&afkidx&"' "
      SQL=SQL&" and fksidx<>'"&rfksidx&"' "
      SQL=SQL&" and (whichi_auto= 8 or whichi_fix=5 )" 'whichi_auto= 8 자동하바  whichi_fix=5 수동하바
      Response.write (SQL)&"<br>2분할대상 하바<br>"
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
        bblength=Rs(19) '하바의 길이
        bpcent=Rs(20) '하바 할증값
        bysize=Rs(21) '하바 보이는 폭 높이:
       
      end If
      Rs.Close
    'if bwhichi_auto = 8 then '자동이라면 하바를 선택했다면

        '3. 복제할 중간소대 정보 찾기

        '3-1 양개일 경우 분할 하바 치수 적용 위치 선택을 위한 코드
        SQL="select min(xi) from tk_framekSub where fkidx='"&afkidx&"' and whichi_auto=13"
        Response.write (SQL)&"<br>문의 위치<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            wxi=Rs(0)  '문의 x좌표
            if axi < wxi Then
            wpoint="L"  '하바치수 오른쪽 적용
            else
            wpoint="R"  '하바치수 왼쪽 적용
            end if 

        End If
        Rs.Close
        response.write wpoint&"<br>"
        'response.end

        '3-2. 복제할 중간소대 정보 찾기
        SQL = "SELECT xi, yi, wi, hi, fksidx, fsidx, fidx, "
        SQL = SQL & " WHICHI_FIX, WHICHI_AUTO, "
        SQL = SQL & " bfidx, bwsize, bhsize, gwsize, ghsize, "
        SQL = SQL & " fstype, glasstype, blength, unitprice, pcent, sprice, "
        SQL = SQL & " xsize , ysize, gls, OPT, FL, "
        SQL = SQL & " door_w, door_h, glass_w, glass_h, "
        SQL = SQL & " busok, busoktype, doorglass_t, fixglass_t, "
        SQL = SQL & " doortype, doorglass_w, doorglass_h, "
        SQL = SQL & " doorsizechuga_price, door_price, "
        SQL = SQL & " goname, barNAME, alength, chuga_jajae, "
        SQL = SQL & " rstatus, rstatus2, garo_sero, groupcode, sunstatus "
        SQL = SQL & " FROM tk_framekSub "
        SQL=SQL&" where yi='"&ayi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and ( whichi_auto=5 or whichi_fix in (6,7,8,9,10) ) "
        if wpoint="L" then
            SQL = SQL & " AND xi = ( SELECT MIN(xi) FROM tk_framekSub WHERE  yi='"&ayi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and ( whichi_auto=5 or whichi_fix in (6,7,8,9,10) ) )" 
        elseif wpoint="R" then
            SQL = SQL & " AND xi = ( SELECT Max(xi) FROM tk_framekSub WHERE  yi='"&ayi&"' and fkidx='"&afkidx&"' and fksidx<>'"&rfksidx&"' and gls=0 and ( whichi_auto=5 or whichi_fix in (6,7,8,9,10) ) )" 
        end if
        Response.write (SQL)&"<br>3복제할 중간소대<br>"
        'response.end
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            cxi = Rs(0)
            cyi = Rs(1)
            cwi = Rs(2)
            chi = Rs(3)
            cfksidx = Rs(4) '→ PK라 복제 시 제외
            cfsidx = Rs(5)
            cfidx = Rs(6)
            cwhichi_fix = Rs(7)
            cwhichi_auto = Rs(8)
            cbfidx = Rs(9)
            cbwsize = Rs(10)
            cbhsize = Rs(11)
            cgwsize = Rs(12)
            cghsize = Rs(13)
            cfstype = Rs(14)
            cglasstype = Rs(15)
            cblength = Rs(16)
            cunitprice = Rs(17)
            cpcent = Rs(18)
            csprice = Rs(19)
            cxsize = Rs(20)
            cysize = Rs(21)
            cgls = Rs(22)
            copt = Rs(23)
            cfl = Rs(24)
            cdoor_w = Rs(25)
            cdoor_h = Rs(26)
            cglass_w = Rs(27)
            cglass_h = Rs(28)
            cbusok = Rs(29)
            cbusoktype = Rs(30)
            cdoorglass_t = Rs(31)
            cfixglass_t = Rs(32)
            cdoortype = Rs(33)
            cdoorglass_w = Rs(34)
            cdoorglass_h = Rs(35)
            cdoorsizechuga_price = Rs(36)
            cdoor_price = Rs(37)
            cgoname = Rs(38)
            cbarname = Rs(39)
            calength = Rs(40)
            cchuga_jajae = Rs(41)
            crstatus = Rs(42)
            crstatus2 = Rs(43)
            cgaro_sero = Rs(44)
            cgroupcode = Rs(45)
            csunstatus = Rs(46)
        
        end If
        Rs.Close
        '3_3 상부남마  중간소대 찾아오기

        if bwhichi_auto = 8 then '자동이라면 하바를 선택했다면
            
            SQL = "SELECT top 1 bfidx, WHICHI_FIX, WHICHI_AUTO, xsize ,ysize ,pcent "
            SQL = SQL & " FROM tk_barasiF "
            SQL=SQL&" where sjb_idx='"&rsjb_idx&"' and whichi_auto=4 "
            SQL = SQL & " ORDER BY bfidx ASC "
            'Response.write (SQL)&"<br> 도어 조회하기 <br>"
            Rs.open SQL, Dbcon
            If Not (Rs.bof or Rs.eof) Then 
                chuga_bfidx = Rs(0)
                chuga_whichi_fix = Rs(1)
                chuga_whichi_auto = Rs(2)
                chuga_xsize = Rs(3)
                chuga_ysize = Rs(4)
                chuga_pcent = Rs(5)
            End If
            Rs.Close 
            
        else '수동이라면 하바를 선택했다면
            
            SQL = "SELECT top 1 bfidx, WHICHI_FIX, WHICHI_AUTO, xsize ,ysize ,pcent "
            SQL = SQL & " FROM tk_barasiF "
            SQL=SQL&" where sjb_idx='"&rsjb_idx&"' and WHICHI_FIX=1 "
            SQL = SQL & " ORDER BY bfidx ASC "
            'Response.write (SQL)&"<br> 도어 조회하기 <br>"
            Rs.open SQL, Dbcon
            If Not (Rs.bof or Rs.eof) Then 
                chuga_bfidx = Rs(0)
                chuga_whichi_fix = Rs(1)
                chuga_whichi_auto = Rs(2)
                chuga_xsize = Rs(3)
                chuga_ysize = Rs(4)
                chuga_pcent = Rs(5)
            End If
            Rs.Close 

        end if
        '4. 선택된 픽스유리 분할 높이 줄이기 

        'aalength '가로내경 --?변경 size_habar 가로내경  ablength '세로내경 aglass_w '가로 유리치수 aglass_h '세로 유리치수
        'alength_cal_1 선택된 상부유리
        'alength_cal_2 추가된 하부유리

        alength_cal_1 = aalength  '가로내경 재계산  
        blength_cal_1 = Int( ablength - size_habar - chuga_ysize + bysize )    '세로내경은 세로내경-입력높이 -상부남마중간소대의 ysize   
        alength_cal_2 = aalength  '가로내경 재계산
        blength_cal_2 = Int(size_habar - bysize - bfl )    '입력높이-하바높이-묻힘 
               
        '픽스유리 뺴는 공식 테이블 가져와서 적용하기.
        

        Response.Write "aalength : " & aalength & "<br>"  
        Response.Write "ablength : " & ablength & "<br>"  
        Response.Write "alength_cal_2 : " & alength_cal_2 & "<br>"  
        Response.Write "blength_cal_2 : " & blength_cal_2 & "<br>"  
        Response.Write "size_habar : " & size_habar & "<br>"  
        Response.Write "bysize : " & bysize & "<br>"  
        Response.Write "bfl : " & bfl & "<br>"  
        'response.end

        sql=" select  c.gwsize1, c.ghsize1 ,c.gwsize2, c.ghsize2 ,a.whichi_fix,a.whichi_auto "
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" join tk_frame e on  b.fidx = e.fidx "
        sql=sql&" Where a.fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br>---<<유리뺴는 공식 가져오기>>-----<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 

            gwsize1 = Rs(0) '유리 너비
            ghsize1 = Rs(1) '유리 높이
            gwsize2 = Rs(2) '유리 너비 '박스라인경우
            ghsize2 = Rs(3) '유리 높이 '박스라인경우
            gwhichi_fix = Rs(4) '픽스유리 whichi_fix 
            gwhichi_auto = Rs(5) '픽스유리 whichi_auto
        end If
        Rs.Close
        '수동 whichi_fix 14,15 일때 하부픽스유리 19일떄 박스라인하부픽스유리
        '자동 whichi_auto 14,15 일때 하부픽스유리 
        if ( gwhichi_fix=14 or  gwhichi_fix=15 ) or ( gwhichi_auto=14 or  gwhichi_auto=15 ) then
            
            glass_w_cal_1 = alength_cal_1 + gwsize1
            glass_h_cal_1 = blength_cal_1 + ghsize1
            glass_w_cal_2 = alength_cal_2 + gwsize1
            glass_h_cal_2 = blength_cal_2 + ghsize1

            If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then 
                '오사이 없으므로 상부는 상부오사이만. 하부는 하바오사이만. 내경 15이니 
                '상부 + 5 만 걸리게 설정 
                '하부 + 10 만 걸리게 설정
                '가로동일 glass_w_cal_1 = alength_cal_1 + gwsize1 
                glass_h_cal_1 = blength_cal_1 + 5 '선택된 상부유리
                '가로동일  glass_w_cal_2 = alength_cal_2 + gwsize1
                glass_h_cal_2 = blength_cal_2 + 10  '추가 인서트될 하부유리
            end if



        elseif ( gwhichi_fix=19 )  then

            glass_w_cal_1 = alength_cal_1 + gwsize2
            glass_h_cal_1 = blength_cal_1 + ghsize2
            glass_w_cal_2 = alength_cal_2 + gwsize2
            glass_h_cal_2 = blength_cal_2 + ghsize2

        end if
 
        'dxi=axi   'x좌표 : 수정된 픽스유리 x좌표
        'dyi=ayi      'y좌표는 수정된 픽스 유리의 y좌표 + ((픽스 유리의 h좌표-중간소대 wi(20)) / 2
        'dwi=awi       '유리의 길이
        dhi=int((ahi-cwi)/2)        '유리의 높이 ((픽스 유리의 h좌표-중간소대 wi(20)) / 2
        
        SQL="Update tk_framekSub set hi='"&dhi&"' "
        SQL=SQL&" , alength='"&alength_cal_1&"' ,blength='"&blength_cal_1&"' "
        SQL=SQL&" ,glass_w='"&glass_w_cal_1&"' ,glass_h='"&glass_h_cal_1&"' "
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br>선택된 픽스유리 너비줄이기<br>/"
        Dbcon.Execute (SQL)

        '5. 픽스유리추가 (좌표 : 픽스유리 x좌표 + 중간소대 너비, y좌표 동일 : 너비는 줄여진 너비와 동일)
        exi=axi   'x좌표 : 수정된 픽스유리 x좌표
        eyi=ayi+int((ahi-cwi)/2)  + bhi      'y좌표는 수정된 픽스 유리의 y좌표 + ((픽스 유리의 h좌표-중간소대 wi(20)) / 2 - 신규 중간소대의 hi=bhi
        ewi=awi       '유리의 길이
        ehi=ahi-int((ahi-cwi)/2) -  bhi    '유리의 높이 (기존픽스유리의 높이 - (픽스 유리의 h좌표-중간소대 wi(20)) / 2) - 하바높이
        


        Response.Write "exi : " & exi & "<br>"  
        Response.Write "eyi : " & eyi & "<br>"  
        Response.Write "ewi : " & ewi & "<br>"  
        Response.Write "ehi : " & ehi & "<br>"  
        Response.Write "size_habar : " & size_habar & "<br>"  
        Response.Write "bysize : " & bysize & "<br>"  
        Response.Write "bfl : " & bfl & "<br>"  
        'response.end
        
        SQL="INSERT INTO tk_framekSub ("
        SQL=SQL&" xi, yi, wi, hi, fmidx, fwdate, "
        SQL=SQL&" fkidx, fsidx, fidx, "
        SQL=SQL&" WHICHI_FIX, WHICHI_AUTO, "
        SQL=SQL&" bfidx, bwsize, bhsize, gwsize, ghsize, "
        SQL=SQL&" fstype, glasstype, blength, unitprice, pcent, sprice, "
        SQL=SQL&" xsize, ysize, gls, OPT, FL, "
        SQL=SQL&" door_w, door_h, glass_w, glass_h, "
        SQL=SQL&" busok, busoktype, doorglass_t, fixglass_t, "
        SQL=SQL&" doortype, doorglass_w, doorglass_h, "
        SQL=SQL&" doorsizechuga_price, door_price, "
        SQL=SQL&" goname, barNAME, alength, chuga_jajae, "
        SQL=SQL&" rstatus, rstatus2, garo_sero, groupcode, sunstatus "
        SQL=SQL&") VALUES ("
        SQL=SQL&" '"&exi&"', '"&eyi&"', '"&ewi&"', '"&ehi&"', '"&c_midx&"', getdate(), "
        SQL=SQL&" '"&afkidx&"', '"&afsidx&"', '"&afidx&"', "
        SQL=SQL&" '"&awhichi_fix&"', '"&awhichi_auto&"', "
        SQL=SQL&" '"&abfidx&"', '"&abwsize&"', '"&abhsize&"', '"&agwsize&"', '"&aghsize&"', "
        SQL=SQL&" '"&afstype&"', '"&aglasstype&"', '"&blength_cal_2&"', '"&aunitprice&"', '"&apcent&"', '"&asprice&"', "
        SQL=SQL&" '"&axsize&"', '"&aysize&"', '"&agls&"', '"&aopt&"', '"&afl&"', "
        SQL=SQL&" '"&adoor_w&"', '"&adoor_h&"', '"&glass_w_cal_2&"', '"&glass_h_cal_2&"', "
        SQL=SQL&" '"&abusok&"', 1 , '"&adoorglass_t&"', '"&afixglass_t&"', "
        SQL=SQL&" '"&adoortype&"', '"&adoorglass_w&"', '"&adoorglass_h&"', "
        SQL=SQL&" '"&adoor_chuga_price&"', '"&adoor_price&"', "
        SQL=SQL&" '"&agoname&"', '"&abarnane&"', '"&alength_cal_2&"', '"&achuga_jajae&"', "
        SQL=SQL&" '"&arstatus&"', '"&arstatus2&"', '"&agaro_sero&"', '"&agroupcode&"', '"&asunstatus&"' "
        SQL=SQL&")"
        Response.write (SQL)&"<br>하부에 픽스유리추가<br>"
        Dbcon.Execute (SQL)

        '6. 중간소대 추가
        ixi=axi   'x좌표 : 수정된 픽스유리 x좌표
        iyi=ayi+int((ahi-cwi)/2)       'y좌표는 수정된 픽스 유리의 y좌표 + ((픽스 유리의 h좌표-중간소대 wi(20)) / 2
        iwi=bwi       '하바의 길이
        ihi=bhi       '하바의 높이
        Response.Write "axi : " & axi & "<br>"  
        Response.Write "ayi : " & ayi & "<br>"  
        Response.Write "cwi : " & cwi & "<br>"  
        Response.Write "bwi : " & bwi & "<br>"  
        Response.Write "bhi : " & bhi & "<br>"  
        Response.Write "iyi : " & iyi & "<br>"  
        'response.end
        SQL="INSERT INTO tk_framekSub ("
        SQL=SQL&" xi, yi, wi, hi, fmidx, fwdate, fkidx, fsidx, fidx, "
        SQL=SQL&" WHICHI_FIX, WHICHI_AUTO, "  'WHICHI_AUTO=4 상부중간소대로 변경
        SQL=SQL&" bfidx, bwsize, bhsize, gwsize, ghsize, "
        SQL=SQL&" fstype, glasstype, blength, unitprice, pcent, sprice, "
        SQL=SQL&" xsize, ysize, gls, OPT, FL, "
        SQL=SQL&" door_w, door_h, glass_w, glass_h, "
        SQL=SQL&" busok, busoktype, doorglass_t, fixglass_t, " 'busoktype=1
        SQL=SQL&" doortype, doorglass_w, doorglass_h, "
        SQL=SQL&" doorsizechuga_price, door_price, "
        SQL=SQL&" goname, barNAME, alength, chuga_jajae, " 'alength=0 chuga_jajae=1
        SQL=SQL&" rstatus, rstatus2, garo_sero, groupcode, sunstatus " 'cgaro_sero = 0 '0 = 가로 1= 세로
        SQL=SQL&") VALUES ("
        SQL=SQL&" '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&cfsidx&"', '"&cfidx&"', "
        SQL=SQL&" '"&chuga_whichi_fix&"', '"&chuga_whichi_auto&"' , "
        SQL=SQL&" '"&chuga_bfidx&"', '"&cbwsize&"', '"&cbhsize&"', '"&cgwsize&"', '"&cghsize&"', "
        SQL=SQL&" '"&cfstype&"', '"&cglasstype&"', '"&bblength&"', '"&cunitprice&"', '"&chuga_pcent&"', '"&csprice&"', "
        SQL=SQL&" '"&chuga_xsize&"', '"&chuga_ysize&"', '"&cgls&"', '"&copt&"', '"&cfl&"', "
        SQL=SQL&" '"&cdoor_w&"', '"&cdoor_h&"', '"&cglass_w&"', '"&cglass_h&"', "
        SQL=SQL&" '"&cbusok&"', 1 , '"&cdoorglass_t&"', '"&cfixglass_t&"', "
        SQL=SQL&" '"&cdoortype&"', '"&cdoorglass_w&"', '"&cdoorglass_h&"', "
        SQL=SQL&" '"&cdoorsizechuga_price&"', '"&cdoor_price&"', "
        SQL=SQL&" '"&cgoname&"', '"&cbarname&"', 0 , '"&chuga_jajae&"', "
        SQL=SQL&" '"&crstatus&"', '"&crstatus2&"', 0 , '"&cgroupcode&"', '"&csunstatus&"' "
        SQL=SQL&")"
        Response.write (SQL)&"<br>중간소대추가<br>"
        'response.end
        Dbcon.Execute (SQL)

    'end if  

    if mode="quick" then

        Response.Write "<script>opener.location.replace('TNG1_B_suju_quick.asp?sjidx=" & rsjidx & _
                        "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & _
                        "&sjb_type_no=" & rsjb_type_no & "');window.close();</script>"

    else
        Response.Write "<script>opener.location.replace('TNG1_B_suju2.asp?sjidx=" & rsjidx & _
                        "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & _
                        "&sjb_type_no=" & rsjb_type_no & "');window.close();</script>"
    end if

  end if

end if
%>
<%
set Rs=Nothing
call dbClose()
%>
