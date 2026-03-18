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
    <title>로비폰 추가</title>
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

<form id="frmMain" method="POST" action="TNG1_B_lobbyphone.asp">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="gubun" value="cmode">
<input type="hidden" id="fksidx" name="fksidx" value="">
<!-- 로비폰 추가 시작-->
        <div class="input-group mb-2s">
            <h3>하부레일 추가</h3>
        </div> 
 
        <div >
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
                                      fill_text = "#ccccff"   ' 파랑 양개도어 (코드 누락 있음: #ccccff 등으로 수정 권장)
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
                                      fill_text = "#ccccff" '  파랑 양개도어
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

                              select case doortype
                                  case 0 
                                      doortype_text = "없음"
                                  case 1 
                                      doortype_text = "좌도어"
                                  case 2  
                                      doortype_text = "우도어"
                              end select 

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

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%

ElseIf gubun="cmode" then 
 


      response.write "<script>opener.location.replace('TNG1_B_suju.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"');window.close();</script>"


end if
%>
<%
set Rs=Nothing
call dbClose()
%>
