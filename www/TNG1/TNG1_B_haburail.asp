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
Set RsC = Server.CreateObject ("ADODB.Recordset")
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")
Set Rs2 = Server.CreateObject ("ADODB.Recordset")
Set Rs3 = Server.CreateObject ("ADODB.Recordset")

rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rfkidx=Request("fkidx")
rsjb_idx=Request("sjb_idx")
gubun=Request("gubun")
roptions=request("options")
rfksidx=Request("fksidx")
rsjb_type_no=Request("SJB_TYPE_NO")
rjaebun=Request("jaebun")
rboyang=Request("boyang")
mode=Request("mode")


if roptions="" then 
  roptions="1"    '1:박스절단길이로 하부레일, 2:전체가로외경으로 하부레일, 
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
    <title>하부레일 추가하기</title>
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

 
</head>
<body>

<!--화면시작-->

    <div class="py-3 container text-center">
<form id="frmMain" method="POST" action="TNG1_B_haburail.asp">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
<input type="hidden" name="jaebun" value="rjaebun">
<input type="hidden" name="boyang" value="rboyang">
<input type="hidden" name="gubun" value="cmode">
<input type="hidden" name="mode" value="<%=mode%>">
<!-- 하바분할 및 로비폰 추가 시작-->
        <div class="input-group mb-2">
          <div class="d-flex gap-4">
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option1" value="1"  
              <% if roptions="1" then response.write "checked" end if %>>
              <label class="form-check-label" for="option1">
                박스절단길이로 하부레일
              </label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="options" id="option2" value="2" 
              <% if roptions="2" then response.write "checked" end if %>>
              <label class="form-check-label" for="option2">
                 전체 가로 외경으로 하부레일
              </label>
            </div>
          </div>
        </div>
        <input type="submit" class="btn btn-primary" value="하부레일 적용">
 </form>
 
        </div>


    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%

ElseIf gubun="cmode" then 

rsjb_type_no=Request("sjb_type_no") 
'chuga_jajae 추가자재 0 은 미터당 단가 계산
'chuga_jajae 추가자재 1 은 평당단가에서 제외하고 추가로 계산 
'rsjb_type_no 1~5가 평당 단가 제품 
'if rsjb_type_no>= 1 and rsjb_type_no <=5 then
 '   chuga_jajae=1 '평당단가 제품은 추가자재 1
'else
'    chuga_jajae=0 '평당단가 제품은 추가자재 0
'end if

  if roptions="1" then  '1=박스절단길이로 하부레일 / 2=전체 가로 외경으로 하부레일
    response.write "<br>1:박스절단길이로 하부레일<br>"
    '1. 분할 대상이되는 바(하부레일 whichi_auto=20)의 정보 불러오기
      SQL="Select  bfidx, whichi_auto, xsize,ysize,pcent "
      SQL=SQL&" From tk_barasif  "
      SQL=SQL&" where sjb_idx='"&rsjb_idx&"' "
      SQL=SQL&" and  whichi_auto = 20 "
      Response.write (SQL)&"<br>3복제할 tk_barasif 하부레일 <br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        qbfidx=Rs(0) '하부레일 bfidx
        qwhichi_auto=Rs(1) '하부레일 whichi_auto
        qxsize=Rs(2) '하부레일 xsize
        qysize=Rs(3) '하부레일 ysize
        qpcent=Rs(4) '하부레일 할증값
      End If
      rs.close

      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , alength, blength , glass_w , glass_h"
      SQL=SQL&" From tk_framekSub where whichi_auto=1 "
      SQL=SQL&" and fkidx='"&rfkidx&"' "
      Response.write (SQL)&"<br>1하부레일 그림 그리기 좌표 설정(기계박스(whichi_auto=1) 불러오기)<br>"
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
        aalength=Rs(19) 
        ablength=Rs(20) '가로길이
        aglass_w=Rs(21) '가로 유리치수
        aglass_h=Rs(22) '세로 유리치수
             
      end If
      Rs.Close
                                          
    '2. 하부레일 좌표 인서트 하기
      ixi= axi  'x좌표 
      iyi= 480         'y좌표
      iwi=awi       '
      ihi=20       '

      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx,   whichi_auto "
      SQL=SQL&" , bfidx,  gls, xsize, ysize, doorglass_t, fixglass_t, blength, pcent  ) "
      SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&qwhichi_auto&"' "
      SQL=SQL&" , '"&qbfidx&"', '"&agls&"' , '"&qxsize&"', '"&qysize&"' "
      SQL=SQL&" , '"&adoorglass_t&"', '"&afixglass_t&"'  , '"&ablength&"', '"&qpcent&"'  ) "
      Response.write (SQL)&"<br>하부레일 좌표 인서트 하기<br>"
      Dbcon.Execute (SQL)
    
    '3. 하부레일  단가 업데이트
    'greem_o_type 1, 2, 3  ' ☑ 편개 4, 5, 6  ' ☑ 양개 그룹
    SQL="Select greem_o_type from tk_framek where fkidx='"&rfkidx&"' "
    Response.write (SQL)&"<br>greem_o_type 가져오기<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then
        qgreem_o_type=Rs(0) '1, 2, 3 편개 / 4, 5, 6 양개
    End If
    Rs.Close

    ' 1. 이중 편개 먼저 체크
    If (qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3) And rsjb_type_no = 10 Then
        ' 이중 편개
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 3000
                whaburail_sjsprice = 60000
            Case ablength <= 4000
                whaburail_sjsprice = 90000
            Case ablength <= 5000
                whaburail_sjsprice = 120000
            Case Else
                whaburail_sjsprice = 0
        End Select

    ' 2. 이중 양개
    ElseIf (qgreem_o_type = 4 Or qgreem_o_type = 5 Or qgreem_o_type = 6) And rsjb_type_no = 10 Then
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 3000
                whaburail_sjsprice = 90000
            Case ablength <= 4000
                whaburail_sjsprice = 120000
            Case ablength <= 5000
                whaburail_sjsprice = 150000
            Case Else
                whaburail_sjsprice = 0
        End Select

    ' 3. 일반 편개
    ElseIf qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3 Then
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 2500
                whaburail_sjsprice = 40000
            Case ablength <= 3000
                whaburail_sjsprice = 60000
            Case ablength <= 4000
                whaburail_sjsprice = 90000
            Case ablength <= 5000
                whaburail_sjsprice = 120000
            Case Else
                whaburail_sjsprice = 0
        End Select

    ' 4. 일반 양개
    ElseIf qgreem_o_type = 4 Or qgreem_o_type = 5 Or qgreem_o_type = 6 Then
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 3000
                whaburail_sjsprice = 60000
            Case ablength <= 4000
                whaburail_sjsprice = 90000
            Case ablength <= 5000
                whaburail_sjsprice = 120000
            Case Else
                whaburail_sjsprice = 0
        End Select
    End If

    SQL="Select quan from tk_framek where fkidx='"&rfkidx&"' "
    Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then
        qquan=Rs(0)
    End If
    Rs.Close

    total_whaburail_sjsprice=whaburail_sjsprice * qquan

        SQL="Update tk_framek set whaburail='"&total_whaburail_sjsprice&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)

    '4. 중간소대 그림 업데이트  
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

        SQL="Select xi, yi, wi, hi ,fksidx ,blength "
        SQL=SQL&" From tk_framekSub  "
        SQL=SQL&" where  fkidx='"&afkidx&"' and whichi_auto=5 "
        SQL=SQL&" and  gls=0 "
        Response.write (SQL)&"<br>4중간소대 그림 업데이트<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        Do While Not Rs.EOF
            wxi=Rs(0)
            wyi=Rs(1)
            wwi=Rs(2) '중간소대의 너비
            whi=Rs(3)
            wfksidx=Rs(4)
            wblength=Rs(5) '중간소대의 길이

            wwhi = whi - wwi
            wwblength = wblength - cfl
            SQL="Update tk_frameksub set hi='"&wwhi&"' , blength='"&wwblength&"' "
            SQL=SQL&" Where fksidx='"&wfksidx&"' "
            'Response.write (SQL)&"<br>"
            'response.end
            Dbcon.Execute (SQL)

        Rs.MoveNext
        Loop
        end If
        Rs.Close

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



  elseif  roptions="2" then   '1=박스절단길이로 하부레일 / 2=가로 외경으로 하부레일

  response.write "<br>2:가로 외경으로 하부레일 <br>"
    '1. 분할 대상이되는 바(하부레일 whichi_auto=20)의 정보 불러오기
      SQL="Select  bfidx, whichi_auto, xsize,ysize,pcent "
      SQL=SQL&" From tk_barasif  "
      SQL=SQL&" where sjb_idx='"&rsjb_idx&"' "
      SQL=SQL&" and  whichi_auto = 20 "
      Response.write (SQL)&"<br>3복제할 tk_barasif 하부레일 <br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
        qbfidx=Rs(0) '하부레일 bfidx
        qwhichi_auto=Rs(1) '하부레일 whichi_auto
        qxsize=Rs(2) '하부레일 xsize
        qysize=Rs(3) '하부레일 ysize
        qpcent=Rs(4) '하부레일 할증값
      End If
      rs.close

      SQL="Select xi, yi, wi, hi, fkidx, fsidx, fidx, whichi_fix, whichi_auto "
      SQL=SQL&" , bfidx, fstype, glasstype, gls, opt, fl, busok, busoktype, doorglass_t, fixglass_t "
      SQL=SQL&" , alength, blength , glass_w , glass_h"
      SQL=SQL&" From tk_framekSub where whichi_auto=1 "
      SQL=SQL&" and fkidx='"&rfkidx&"' "
      Response.write (SQL)&"<br>1하부레일 그림 그리기 좌표 설정(기계박스(whichi_auto=1) 불러오기)<br>"
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
        aalength=Rs(19) 
        ablength=Rs(20) '가로길이
        aglass_w=Rs(21) '가로 유리치수
        aglass_h=Rs(22) '세로 유리치수
             
      end If
      Rs.Close
                                          
    '2. 하부레일 좌표 인서트 하기
      ixi= axi - 20  'x좌표 280 
      iyi= 500         'y좌표 500
      iwi=awi + 40      ' 440
      ihi=20       ' 20

        '전체외경 가져오기
        SQL="Select tw from tk_framek where fkidx='"&rfkidx&"' "
        Response.write (SQL)&"<br>전체외경 가져오기<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then
            qtw=Rs(0) 
        End If
        Rs.Close

      SQL="Insert into tk_framekSub (xi, yi, wi, hi, fmidx, fwdate, fkidx,   whichi_auto "
      SQL=SQL&" , bfidx,  gls, xsize, ysize, doorglass_t, fixglass_t, blength, pcent  ) "
      SQL=SQL&" values( '"&ixi&"', '"&iyi&"', '"&iwi&"', '"&ihi&"', '"&c_midx&"', getdate(), '"&afkidx&"', '"&qwhichi_auto&"' "
      SQL=SQL&" , '"&qbfidx&"', '"&agls&"' , '"&qxsize&"', '"&qysize&"' "
      SQL=SQL&" , '"&adoorglass_t&"', '"&afixglass_t&"'  , '"&qtw&"', '"&qpcent&"'  ) "
      Response.write (SQL)&"<br>하부레일 좌표 인서트 하기<br>"
      Dbcon.Execute (SQL)
    
        '도어유리 좌표 업데이트
        SQL="Select xi, yi, wi, hi, whichi_auto "
        SQL=SQL&" From tk_framekSub where fkidx='"&rfkidx&"' and whichi_auto in (12,13) "
        Response.write (SQL)&"<br>도어유리 좌표 업데이트<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then
            Do While Not Rs.EOF
                q1xi=Rs(0) '도어유리 x좌표
                q1yi=Rs(1) '도어유리 y좌표
                q1wi=Rs(2) '도어유리 너비
                q1hi=Rs(3) '도어유리 높이
                q1whichi_auto=Rs(4) '도어유리 whichi_auto

                q11hi = q1hi + 20

                    '왼쪽 도어유리 좌표 업데이트
                    SQL="Update tk_framekSub set hi='"&q11hi&"' "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' and whichi_auto='"&q1whichi_auto&"' "
                    Response.write (SQL)&"<br>도어업데이트 좌표<br>"
                    Dbcon.Execute (SQL)

                Rs.MoveNext
            Loop
        End If
        Rs.Close
        
        '픽스유리 좌표 업데이트
        SQL="Select xi, yi, wi, hi, whichi_auto "
        SQL=SQL&" From tk_framekSub where fkidx='"&rfkidx&"' and whichi_auto in (14,15) "
        Response.write (SQL)&"<br>도어유리 좌표 업데이트<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then
            Do While Not Rs.EOF
                q2xi=Rs(0) '도어유리 x좌표
                q2yi=Rs(1) '도어유리 y좌표
                q2wi=Rs(2) '도어유리 너비
                q2hi=Rs(3) '도어유리 높이
                q2whichi_auto=Rs(4) '도어유리 whichi_auto

                q22hi = q2hi + 20

                    SQL="Update tk_framekSub set hi='"&q22hi&"' "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' and whichi_auto='"&q2whichi_auto&"' "
                    Dbcon.Execute (SQL)

                Rs.MoveNext
            Loop
        End If
        Rs.Close
        '하바 좌표 업데이트
        SQL="Select xi, yi, wi, hi, whichi_auto "
        SQL=SQL&" From tk_framekSub where fkidx='"&rfkidx&"' and whichi_auto = 8 "
        Response.write (SQL)&"<br>도어유리 좌표 업데이트<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then
            Do While Not Rs.EOF
                q3xi=Rs(0) '도어유리 x좌표
                q3yi=Rs(1) '도어유리 y좌표
                q3wi=Rs(2) '도어유리 너비
                q3hi=Rs(3) '도어유리 높이
                q3whichi_auto=Rs(4) '도어유리 whichi_auto

                q33yi = q3yi + 20

                    '왼쪽 도어유리 좌표 업데이트
                    SQL="Update tk_framekSub set yi='"&q33yi&"' "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' and whichi_auto='"&q3whichi_auto&"' "
                    Dbcon.Execute (SQL)
          
                Rs.MoveNext
            Loop
        End If
        Rs.Close

    '3. 하부레일  단가 업데이트
    'greem_o_type 1, 2, 3  ' ☑ 편개 4, 5, 6  ' ☑ 양개 그룹
    SQL="Select greem_o_type from tk_framek where fkidx='"&rfkidx&"' "
    Response.write (SQL)&"<br>greem_o_type 가져오기<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then
        qgreem_o_type=Rs(0) '1, 2, 3 편개 / 4, 5, 6 양개
    End If
    Rs.Close

    ' 1. 이중 편개 먼저 체크
    If (qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3) And rsjb_type_no = 10 Then
        ' 이중 편개
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 3000
                whaburail_sjsprice = 60000
            Case ablength <= 4000
                whaburail_sjsprice = 90000
            Case ablength <= 5000
                whaburail_sjsprice = 120000
            Case Else
                whaburail_sjsprice = 0
        End Select

    ' 2. 이중 양개
    ElseIf (qgreem_o_type = 4 Or qgreem_o_type = 5 Or qgreem_o_type = 6) And rsjb_type_no = 10 Then
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 3000
                whaburail_sjsprice = 90000
            Case ablength <= 4000
                whaburail_sjsprice = 120000
            Case ablength <= 5000
                whaburail_sjsprice = 150000
            Case Else
                whaburail_sjsprice = 0
        End Select

    ' 3. 일반 편개
    ElseIf qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3 Then
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 2500
                whaburail_sjsprice = 40000
            Case ablength <= 3000
                whaburail_sjsprice = 60000
            Case ablength <= 4000
                whaburail_sjsprice = 90000
            Case ablength <= 5000
                whaburail_sjsprice = 120000
            Case Else
                whaburail_sjsprice = 0
        End Select

    ' 4. 일반 양개
    ElseIf qgreem_o_type = 4 Or qgreem_o_type = 5 Or qgreem_o_type = 6 Then
        Select Case True
            Case Not IsNumeric(ablength)
                whaburail_sjsprice = 0
            Case ablength <= 3000
                whaburail_sjsprice = 60000
            Case ablength <= 4000
                whaburail_sjsprice = 90000
            Case ablength <= 5000
                whaburail_sjsprice = 120000
            Case Else
                whaburail_sjsprice = 0
        End Select
    End If

    SQL="Select quan from tk_framek where fkidx='"&rfkidx&"' "
    Response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then
        qquan=Rs(0)
    End If
    Rs.Close

    total_whaburail_sjsprice=whaburail_sjsprice 
    update_whaburail_sjsprice=whaburail_sjsprice * qquan

        SQL="Update tk_framek set whaburail='"&total_whaburail_sjsprice&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)


    if mode="quick" then

        Response.Write "<script>opener.location.replace('TNG1_B_suju_quick.asp?sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & "&sjb_type_no=" & rsjb_type_no & "&mode=auto_enter');window.close();</script>"

    else

        Response.Write "<script>opener.location.replace('TNG1_B_suju2.asp?sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & "&sjb_type_no=" & rsjb_type_no & "&jaebun="&rjaebun&"&boyang="&rboyang&"');window.close();</script>"

    end if

  end if

end if
%>
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>