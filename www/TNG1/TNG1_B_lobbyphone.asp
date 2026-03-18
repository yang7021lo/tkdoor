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
rSJB_TYPE_NO=Request("SJB_TYPE_NO")
gubun=Request("gubun")
roptions=request("options")
rfksidx=Request("fksidx")
rjaebun=Request("jaebun")
rboyang=Request("boyang")
mode=Request("mode")


if roptions="" then 

    roptions="1"    '1:하바분할중간소대, 2:하바1개중간소대, 3:로비폰추가

end if
'response.write "rSJB_TYPE_NO:"&rSJB_TYPE_NO&"/<br>"
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
<body style="overflow-x:scroll; overflow-y: auto; "> <!-- 내용 넘치면 가로 스크롤 생김--> 

<!--화면시작-->

    <div class="py-3 container text-center">

<form id="frmMain" method="POST" action="TNG1_B_lobbyphone.asp">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="gubun" value="cmode">
<input type="hidden" name="jaebun" value="<%=rjaebun%>">
<input type="hidden" name="boyang" value="<%=rboyang%>">
<input type="hidden" name="mode" value="<%=mode%>">
<input type="hidden" id="fksidx" name="fksidx" value="">
<!-- 로비폰 추가 시작-->
    <div class="row">
        <div class="input-group mb-2s">
            <h3>로비폰 추가</h3>
        </div> 
    
        <div >
          <div class="d-flex align-items-center gap-3 my-3">
          <%
            SQL="select a.xsize from tk_framekSub a "
            sql=sql&" join tk_framek b on  a.fkidx = b.fkidx "
            sql=sql&" where b.fkidx='"&rfkidx&"' "
            sql=sql&" and (a.whichi_auto=8 or a.whichi_fix=5 )"
            'Response.write (SQL)&"<br>로비폰박스 depth 알아내기<br>"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then 
                robby_xsize=Rs(0) '로비폰박스높이
            End if
            Rs.Close

          %>
            <div>
                <label for="lpdepth" class="form-label mb-0 me-2">폭(두께):</label>
                <input type="number" class="form-control d-inline-block" id="lpdepth" name="lpdepth"
                        placeholder="" style="width: 120px;" value="<%=robby_xsize%>">
            </div>
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
    </div> 
    <div class="row">
        <div class="col text-start">
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
              <div class="svg-container" style="overflow-x:auto; overflow-y:auto; width:100%; height:100%;">
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
                          SQL = SQL & " WHERE A.sjidx = '" & rsjidx & "' AND A.sjsidx = '" & rsjsidx & "' AND A.fkidx = '" & rfkidx & "' "
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
        </div> 
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
    rSJB_TYPE_NO=Request("SJB_TYPE_NO")

    rlpheight=Request("lpheight") '로피폰 높이
    rlpdepth=Request("lpdepth") '로비폰 폭(두께)
    rlpdistance=Request("lpdistance") '로비폰 하부센터 기준 높이
    phoneh="40" '로비폰 가상의 높이
    'response.write "<br>3:로비폰추가<br>"
    'response.write rlpheight&"/"&rlpdistance&"<br><br>"

    '1. 분할 대상이되는 바(픽스유리)의 정보 불러오기
      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto, bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" ,glass_w, glass_h,blength ,alength"
      SQL=SQL&" From tk_framekSub where fksidx='"&rfksidx&"' "
      'Response.write (SQL)&"<br>분할대상 픽스유리<br>"
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
        aglass_w=Rs(19)
        aglass_h=Rs(20)
        ablength=Rs(21) '유리내경
        aalength=Rs(22) '유리가로내경

        
      end If
      Rs.Close

        '2. 픽스상바 불러오기
        If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then ' 픽스상바가 있는것만 받아오기

            SQL = "SELECT TOP 1 fksidx, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto, "
            SQL = SQL & " bfidx, fstype, glasstype, gls, blength, sunstatus, garo_sero, "
            SQL = SQL & " chuga_jajae, xsize, ysize, unitprice, pcent "
            SQL = SQL & "FROM tk_framekSub "
            SQL = SQL & "WHERE fkidx='" & rfkidx & "' AND whichi_auto=9 "
            SQL = SQL & "ORDER BY fksidx DESC"
            'garo_sero 0 = 가로 1= 세로
            'chuga_jajae 추가자재 0 은 미터당 단가 계산
            'chuga_jajae 추가자재 1 은 평당단가에서 제외하고 추가로 계산 
            Response.write (SQL)&"<br>픽스상바 가져오기 1개만 <br>"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then 
                fix_fksidx          = Rs(0)
                fix_hi              = Rs(1)
                fix_fkidx           = Rs(2)
                fix_fsidx           = Rs(3)
                fix_fidx            = Rs(4)
                fix_whichi_fix      = Rs(5)
                fix_whichi_auto     = Rs(6)
                fix_bfidx           = Rs(7)
                fix_fstype          = Rs(8)
                fix_glasstype       = Rs(9)
                fix_gls             = Rs(10)
                fix_blength         = Rs(11)
                fix_sunstatus       = Rs(12)
                fix_garo_sero       = Rs(13)
                fix_chuga_jajae     = Rs(14)
                fix_xsize           = Rs(15)
                fix_ysize           = Rs(16)
                fix_unitprice       = Rs(17)
                fix_pcent           = Rs(18) 
                
            end If
            Rs.Close

            SQL = "SELECT TOP 1 fksidx, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto, "
            SQL = SQL & " bfidx, fstype, glasstype, gls, blength, sunstatus, garo_sero, "
            SQL = SQL & " chuga_jajae, xsize, ysize, unitprice, pcent "
            SQL = SQL & "FROM tk_framekSub "
            SQL = SQL & "WHERE fkidx='" & rfkidx & "' AND whichi_auto=24 "
            SQL = SQL & "ORDER BY fksidx DESC"
            Response.write (SQL)&"<br>오사이 가져오기 1개만 <br>"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then 

                o42_fksidx          = Rs(0)
                o42_hi              = Rs(1)
                o42_fkidx           = Rs(2)
                o42_fsidx           = Rs(3)
                o42_fidx            = Rs(4)
                o42_whichi_fix      = Rs(5)
                o42_whichi_auto     = Rs(6)
                o42_bfidx           = Rs(7)
                o42_fstype          = Rs(8)
                o42_glasstype       = Rs(9)
                o42_gls             = Rs(10)
                o42_blength         = Rs(11)
                o42_sunstatus       = Rs(12)
                o42_garo_sero       = Rs(13)
                o42_chuga_jajae     = Rs(14)
                o42_xsize           = Rs(15)
                o42_ysize           = Rs(16)
                o42_unitprice       = Rs(17)
                o42_pcent           = Rs(18) 
                
            end If
            Rs.Close

        end if
    '4. 선택된 픽스유리 분할 높이 줄이기 
      
      If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then ' 픽스상바가 있는것만 받아오기
        dhi=round((ahi-10-phoneh)/2)
        ddhi=round((ahi-phoneh-10)/2)-5
      else
        dhi=round((ahi-10-phoneh)/2)
        ddhi=dhi
      end if
      response.write dhi&"<br>"
      response.write ahi&"<br>"
      response.write rlpheight&"<br>"

    '---busoktype=1 강제지정 (추후 유리계산에서 제외하기 위해)
      SQL="Update tk_framekSub set  hi='"&ddhi&"' , busoktype=1 Where fksidx='"&rfksidx&"' "
      Response.write (SQL)&"<br>선택된 픽스유리 높이 줄이기<br>/"
      Dbcon.Execute (SQL)

    '유리치수 가져와서 상부유리1번 높이 업데이트 하고 2번 가로 세로는 인서트 해야함
        '자동 /수동 알아내기
        SQL="select sjb_fa from tng_sjb where sjb_idx='"&rsjb_idx&"' "
        Response.write (SQL)&"<br>자동 /수동 알아내기<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            sjb_fa1=Rs(0) '1수동 2자동
        End if
        Rs.Close
    '하바높이 가져오는 쿼리
        sql=" select   a.WHICHI_AUTO, a.WHICHI_FIX  "
        sql=sql&" ,b.fl  "
        sql=sql&" , d.xsize, d.ysize " 
        sql=sql&" , a.blength ,b.qtyidx,b.pidx,b.quan " 
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" where a.fkidx='"&rfkidx&"' "
        if  sjb_fa1 = 1 then '수동
        sql=sql&" and  a.WHICHI_FIX=5 "
        elseif sjb_fa1 = 2 then '자동
        sql=sql&" and  a.WHICHI_AUTO=8 "
        end if
        response.write (SQL)&"<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            qwhichi_auto=Rs(0) 
            qwhichi_fix=Rs(1)  
            qfl=Rs(2)   
            qxsize=Rs(3)       
            qysize=Rs(4)       '하바높이 단 변수는 슬림자동 제외하고 100으로 고정 하바가 묻힐수도 있음
            qblength=Rs(5)     '하바가로
            qqtyidx=Rs(6)      '재질
            qpidx=Rs(7)        '도장
            qquan=Rs(8)        '수량

        End If
        Rs.Close
        '1번 rlpheight 로비폰세로 높이
        '2번 rlpdistance 로비폰 하부센터 기준 높이
        Response.Write "ablength: " & ablength & "<br>" 
        Response.Write "rlpheight: " & rlpheight & "<br>" 
        Response.Write "rlpdistance: " & rlpdistance & "<br>" 
        Response.Write "qysize: " & qysize & "<br>" 
        Response.Write "qblength: " & qblength & "<br>" 

    If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then '오사이 추가 발주 하면서 높이 계산 25오사이 높이 내경 +20 하면 10 여유 
        '상부픽스
        glass_h_1 =  ablength + 100 - Int(rlpheight / 2) - rlpdistance -25 + 20 
        qblength1 = ablength + 100  - Int(rlpheight / 2) - rlpdistance - 25 
        '하부픽스 = 로비폰 하부기준높이  - 박스높이/2-하바높이(whichi_auto=8)-묻힘제외
        glass_h_2 =  rlpdistance  - Int(rlpheight / 2) - 100 -25 + 20  
        qblength2 = rlpdistance   - Int(rlpheight / 2) - 100 -25

        '이부분에서 추가 오사이 인서트 해야함 !!!!!!!!!!!!!

    elseIf rsjb_type_no = 5 Then '인테리어 상하 5키움
        '상부픽스
        glass_h_1 =  ablength - Int(rlpheight / 2) - rlpdistance + 5
        qblength1 = ablength - Int(rlpheight / 2) - rlpdistance 
        '하부픽스 = 로비폰 하부기준높이  - 박스높이/2-하바높이(whichi_auto=8)-묻힘제외
        glass_h_2 =  rlpdistance - Int(rlpheight / 2) - 70 + 5 
        qblength2 = rlpdistance - Int(rlpheight / 2) - 70 
    elseIf (rsjb_type_no >= 8 And rsjb_type_no <= 10) or rsjb_type_no = 15 Then
        '상부픽스
        glass_h_1 =  ablength - Int(rlpheight / 2) - rlpdistance - 10
        qblength1 = ablength - Int(rlpheight / 2) - rlpdistance
        '하부픽스 = 로비폰 하부기준높이  - 박스높이/2-하바높이(whichi_auto=8)-묻힘제외
        glass_h_2 =  rlpdistance - Int(rlpheight / 2) - 100 - 10
        qblength2 = rlpdistance - Int(rlpheight / 2) - 100 
    elseIf rsjb_type_no = 6 or rsjb_type_no = 7 or rsjb_type_no = 11 or rsjb_type_no = 12 Then '수동프레임 
        '상부픽스
        glass_h_1 =  ablength - Int(rlpheight / 2) - rlpdistance + 15
        qblength1 = ablength - Int(rlpheight / 2) - rlpdistance 
        '하부픽스 = 로비폰 하부기준높이  - 박스높이/2-하바높이(whichi_auto=8)-묻힘제외
        glass_h_2 =  rlpdistance - Int(rlpheight / 2) - 100 + 15
        qblength2 = rlpdistance - Int(rlpheight / 2) - 100     
    End If
    
    'Response.Write "mode : " & mode & "<br>" 
     
       ' 상부픽스  = aglass_w , glass_h_1  qblength1 세로 내경 
       ' 하부픽스  = aglass_w , glass_h_2  qblength2 세로 내경 

    '5. 하부픽스유리추가 
    If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then ' 픽스상바가 있는것만 받아오기

      exi=axi                   'x좌표 : 픽스유리 x좌표와 동일
      eyi=ayi+dhi+phoneh +5    'y좌표 : 픽스유리 y좌표+픽스유리 높이 + 로비폰 높이 + 오사이 2개 
      ewi=awi                   '너비 : 픽스유리 너비와 동일
      ehi=ahi-dhi-phoneh -5            '높이 : 추가된 하부 픽스유리의 높이 + 오사이 1개 

    else

      exi=axi                   'x좌표 : 픽스유리 x좌표와 동일
      eyi=ayi+dhi+phoneh     'y좌표 : 픽스유리 y좌표+픽스유리 높이 + 로비폰 높이
      ewi=awi                   '너비 : 픽스유리 너비와 동일
      ehi=ahi-dhi-phoneh            '높이 : 추가된 하부 픽스유리의 높이 

    end if
        '---busoktype=1 강제지정 (추후 유리계산에서 제외하기 위해)
        SQL = "INSERT INTO tk_framekSub ("
        SQL = SQL & "xi, yi, wi, hi, fmidx, fwdate, "
        SQL = SQL & "fkidx, fsidx, fidx, whichi_fix, whichi_auto, "
        SQL = SQL & "bfidx, fstype, glasstype, gls, opt, fl, "
        SQL = SQL & "busok, busoktype, doorglass_t, fixglass_t,glass_w,glass_h,alength,blength) "
        SQL = SQL & "VALUES ("
        SQL = SQL & "'" & exi & "', '" & eyi & "', '" & ewi & "', '" & ehi & "', '" & c_midx & "', getdate(), "
        SQL = SQL & "'" & afkidx & "', '" & afsidx & "', '" & afidx & "', '" & awhichi_fix & "', '" & awhichi_auto & "', '" & abfidx & "', "
        SQL = SQL & "'" & afstype & "', '" & aglasstype & "', '" & agls & "', '" & aopt & "', '" & afl & "', '" & abusok & "', "
        SQL = SQL & " 1 , '" & adoorglass_t & "', '" & afixglass_t & "', '" & aglass_w & "', '" & glass_h_2 & "', '" & aalength & "', '" & qblength2 & "')"

      Response.write (SQL)&"<br>픽스유리추가<br>"
      Dbcon.Execute (SQL)

        '5_1. 상부픽스유리치수 업데이트
        SQL="Update tk_framekSub set glass_h='"&glass_h_1&"',  blength='"&qblength1&"' Where fksidx='"&rfksidx&"' "
        Response.write (SQL)&"<br>상부픽스유리치수 업데이트<br>/"
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

        SQL = "INSERT INTO tk_framekSub ("
        SQL = SQL & "xi, yi, wi, hi, fmidx, fwdate, "
        SQL = SQL & "fkidx, fsidx, fidx, whichi_fix, whichi_auto, "
        SQL = SQL & "bfidx, fstype, glasstype, gls, opt, "
        SQL = SQL & "fl, busok, busoktype, doorglass_t, fixglass_t, ysize,blength , xsize) "

        SQL = SQL & "VALUES ("
        SQL = SQL & "'" & fxi & "', '" & fyi & "', '" & fwi & "', '" & fhi & "', '" & c_midx & "', getdate(), "
        SQL = SQL & "'" & afkidx & "', '" & afsidx & "', '" & afidx & "', '" & awhichi_fix & "', '" & awhichi_auto & "', '" & abfidx & "', "
        SQL = SQL & "'" & afstype & "', '" & aglasstype & "', '" & agls & "', '" & aopt & "', '" & rlpdistance & "', "
        SQL = SQL & "'" & abusok & "', 1 , '" & adoorglass_t & "', '" & afixglass_t & "', '" & aysize & "', '" & qblength & "', '" & rlpdepth & "')"
      Response.write (SQL)&"<br>로비폰인서트<br>"
      Dbcon.Execute (SQL)
    
    If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then ' 픽스상바가 있는것만 인서트

        'fxi ,fwi 동일
        oyi_1= fyi-fix_hi 'fyi 는 로비폰yi-5 
        oyi_2= fyi+fhi
        ohi=fix_hi '
        'whichi_auto '픽스상바=9 오사이=24
        SQL = "INSERT INTO tk_framekSub ("
        SQL = SQL & " xi, yi, wi, hi, fmidx, fwdate"
        SQL = SQL & ", fkidx, fsidx, fidx, whichi_fix, whichi_auto"
        SQL = SQL & ", bfidx, fstype, glasstype, gls "
        SQL = SQL & ", ysize, blength, xsize, sunstatus"
        SQL = SQL & ", garo_sero, chuga_jajae, unitprice, pcent , busoktype "
        SQL = SQL & ") VALUES ("
        SQL = SQL & " '" & fxi & "', '" & oyi_1 & "', '" & fwi & "', '" & ohi & "', '" & c_midx & "', getdate()"
        SQL = SQL & ", '" & fix_fkidx & "', '" & fix_fsidx & "', '" & fix_fidx & "', '" & fix_whichi_fix & "', '" & fix_whichi_auto & "'"
        SQL = SQL & ", '" & fix_bfidx & "', '" & fix_fstype & "', '" & fix_glasstype & "', '" & fix_gls & "'"
        SQL = SQL & ", '" & fix_ysize & "', '" & qblength & "', '" & fix_xsize & "', '" & fix_sunstatus & "'"
        SQL = SQL & ", '" & fix_garo_sero & "', 1 , '" & fix_unitprice & "', '" & fix_pcent & "' , 1 "
        SQL = SQL & ")"
        Response.write (SQL)&"<br>픽스상바 인서트 로비폰박스 위에 1차 <br>"
        Dbcon.Execute (SQL)

        SQL = "INSERT INTO tk_framekSub ("
        SQL = SQL & " xi, yi, wi, hi, fmidx, fwdate"
        SQL = SQL & ", fkidx, fsidx, fidx, whichi_fix, whichi_auto"
        SQL = SQL & ", bfidx, fstype, glasstype, gls "
        SQL = SQL & ", ysize, blength, xsize, sunstatus"
        SQL = SQL & ", garo_sero, chuga_jajae, unitprice, pcent , busoktype "
        SQL = SQL & ") VALUES ("
        SQL = SQL & " '" & fxi & "', '" & oyi_2 & "', '" & fwi & "', '" & ohi & "', '" & c_midx & "', getdate()"
        SQL = SQL & ", '" & fix_fkidx & "', '" & fix_fsidx & "', '" & fix_fidx & "', '" & fix_whichi_fix & "', '" & fix_whichi_auto & "'"
        SQL = SQL & ", '" & fix_bfidx & "', '" & fix_fstype & "', '" & fix_glasstype & "', '" & fix_gls & "'"
        SQL = SQL & ", '" & fix_ysize & "', '" & qblength & "', '" & fix_xsize & "', '" & fix_sunstatus & "'"
        SQL = SQL & ", '" & fix_garo_sero & "', 1 , '" & fix_unitprice & "', '" & fix_pcent & "' ,1  "
        SQL = SQL & ")"
        Response.write (SQL)&"<br>픽스상바 인서트 로비폰박스 아래 2차 <br>"
        Dbcon.Execute (SQL)

        SQL = "INSERT INTO tk_framekSub ("
        SQL = SQL & "  fmidx, fwdate"
        SQL = SQL & ", fkidx, fsidx, fidx, whichi_fix, whichi_auto"
        SQL = SQL & ", bfidx, fstype, glasstype, gls "
        SQL = SQL & ", ysize, blength, xsize, sunstatus"
        SQL = SQL & ", garo_sero, chuga_jajae, unitprice, pcent , busoktype "
        SQL = SQL & ") VALUES ("
        SQL = SQL & "  '" & c_midx & "', getdate()"
        SQL = SQL & ", '" & o42_fkidx & "', '" & o42_fsidx & "', '" & o42_fidx & "', '" & o42_whichi_fix & "', '" & o42_whichi_auto & "'"
        SQL = SQL & ", '" & o42_bfidx & "', '" & o42_fstype & "', '" & o42_glasstype & "', '" & o42_gls & "'"
        SQL = SQL & ", '" & o42_ysize & "', '" & qblength & "', '" & o42_xsize & "', '" & o42_sunstatus & "'"
        SQL = SQL & ", '" & o42_garo_sero & "', 1 , '" & o42_unitprice & "', '" & o42_pcent & "' , 1"
        SQL = SQL & ")"
        Response.write (SQL)&"<br>오사이 인서트 로비폰박스 위에 1차 <br>"
        Dbcon.Execute (SQL)

        SQL = "INSERT INTO tk_framekSub ("
        SQL = SQL & "  fmidx, fwdate"
        SQL = SQL & ", fkidx, fsidx, fidx, whichi_fix, whichi_auto"
        SQL = SQL & ", bfidx, fstype, glasstype, gls "
        SQL = SQL & ", ysize, blength, xsize, sunstatus"
        SQL = SQL & ", garo_sero, chuga_jajae, unitprice, pcent, busoktype "
        SQL = SQL & ") VALUES ("
        SQL = SQL & "  '" & c_midx & "', getdate()"
        SQL = SQL & ", '" & o42_fkidx & "', '" & o42_fsidx & "', '" & o42_fidx & "', '" & o42_whichi_fix & "', '" & o42_whichi_auto & "'"
        SQL = SQL & ", '" & o42_bfidx & "', '" & o42_fstype & "', '" & o42_glasstype & "', '" & o42_gls & "'"
        SQL = SQL & ", '" & o42_ysize & "', '" & qblength & "', '" & o42_xsize & "', '" & o42_sunstatus & "'"
        SQL = SQL & ", '" & o42_garo_sero & "', 1 , '" & o42_unitprice & "', '" & o42_pcent & "' , 1 "
        SQL = SQL & ")"
        Response.write (SQL)&"<br>오사이 인서트 로비폰박스 아래 2차 <br>"
        Dbcon.Execute (SQL)
        

    end if
    '7. 로비폰 박스 단가 업데이트
    
        If (qqtyidx = 3 and qpidx <> 0)  or qqtyidx = 15  or qqtyidx = 30 Then  '15 실버 30 알미늄도장
            qqtyidx = 7 '로비폰 박스는 갈바도장 단가
        end if

        sql=" select robbyprice1,robbyprice2  "
        sql=sql&" from tk_qty "
        sql=sql&" where qtyidx='"&qqtyidx&"' "
        response.write (SQL)&"<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
                robbyprice1 = Rs(0) '길이 1175미만 로비폰 박스 단가
                robbyprice2 = Rs(1) '길이 1175이상 로비폰 박스 단가
        End If
        Rs.Close
                if qblength < 1175 then 
                    robby_box_sjsprice = robbyprice1  '길이 1175미만 로비폰 박스 단가
                else 
                    robby_box_sjsprice = robbyprice2  '길이 1175미만 로비폰 박스 단가
                end if

        if (qqtyidx =1 and qpidx<>0) or (qqtyidx=37 and qpidx<>0) then
        robby_box_sjsprice=robby_box_sjsprice*1.3
        end if

       update_robby_box_sjsprice = robby_box_sjsprice * qquan
       
        SQL="Update tk_framek set robby_box='"&robby_box_sjsprice&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)

    if mode="quick" then

        response.write "<script>opener.location.replace('TNG1_B_suju_quick.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&mode=auto_enter');window.close();</script>"

    else

        response.write "<script>opener.location.replace('TNG1_B_suju2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&jaebun="&rjaebun&"&boyang="&rboyang&"');window.close();</script>"

    end if
end if
%>
<%
set Rs=Nothing
call dbClose()
%>
