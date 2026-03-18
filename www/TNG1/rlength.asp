
<%@ codepage="65001" language="vbscript"%>
<%
' -------------------------------
' 안전 나눗셈 함수 정의 (페이지 최상위)
' -------------------------------
Function SafeDivide(numerator, denominator)
    If IsNumeric(denominator) And CDbl(denominator) <> 0 Then
        SafeDivide = CDbl(numerator) / CDbl(denominator)
    Else
        SafeDivide = 0
    End If 
End Function
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()
Set RsC = Server.CreateObject ("ADODB.Recordset")
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")
Set Rs2 = Server.CreateObject ("ADODB.Recordset")
Set Rs3 = Server.CreateObject ("ADODB.Recordset")

gubun=Request("gubun")


rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no")
rgreem_f_a=Request("greem_f_a")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")



If gubun="" then 
  SQL="Select A.blength, A.alength, A.xsize, A.ysize, A.xi "
  SQL=SQL&" From tk_framekSub A "
  SQL=SQL&" Join tk_framek B On A.fkidx=B.fkidx "
  SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    blength=Rs(0)
    alength=Rs(1)
    xsize=Rs(2)
    ysize=Rs(3)
    xi=Rs(4)

  End if
  Rs.close
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Bar 길이 입력 (mm)</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .input-container {
      max-width: 500px;
      margin: 20px auto;
    }
    .d-inline-flex {
      gap: 10px;
      align-items: center;
    }
    input[type="text"] {
      text-align: right;
      width: 150px;
    }
  </style>
</head>
<body class="p-4">

<div class="container input-container">
  <h2 class="mb-4">Bar 길이 입력 <small class="text-muted">(단위: mm)</small></h2>
  
  <form id="lengthForm" name="lengthForm" action="rlength.asp" method="POST">
    <input type="hidden" name="gubun" value="up1date">
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
    <input type="hidden" name="greem_f_a" value="<%=rgreem_f_a%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
    <input type="hidden" name="xi" value="<%=xi%>">
    <div class="mb-3 d-inline-flex">
      <label for="rlength" class="form-label mb-0">길이 (mm):</label>
      <input type="text" id="rlength" name="rlength" class="form-control" placeholder="예: 12,345" value="<%=blength%>" required>
    </div>
    <div class="d-flex align-items-center gap-3">
      <label class="form-label mb-0">구분</label>
      
      <div class="form-check mb-0">
        <input class="form-check-input" type="radio" name="optionType" value="1" >
        <label class="form-check-label" for="singleOption">단독적용</label>
      </div>

      <div class="form-check mb-0">
        <input class="form-check-input" type="radio" name="optionType" value="2" checked>
        <label class="form-check-label" for="batchOption">일괄적용</label>
      </div>
    </div>

    <button type="submit" class="btn btn-primary">길이적용</button>
 
  </form>
</div>

<script>
  const rlengthInput = document.getElementById('rlength');

  // 천 단위 콤마 자동 적용, 최대 5자리 숫자 제한
  rlengthInput.addEventListener('input', function() {
    let value = this.value.replace(/[^0-9]/g, ''); // 숫자만 남김
    if (value.length > 7) value = value.slice(0, 7); // 5자리까지만 허용
    //this.value = value ? Number(value).toLocaleString() : '';   //천단위 콤마 표시는 오류배제를 위해 당분간 사용안함
  });


</script>

</body>
</html>
<%
ElseIf gubun="up1date" Then 
  rrlength=Request("rlength")
  roptionType=Request("optionType")
  rxi=Request("xi")
  response.write rrlength&"<br>"
  response.write roptionType&"<br>"
  response.write rxi&"<br>"

  sql=" select  a.fksidx , a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.glass_w, a.glass_h, a.gls "
  sql=sql&" ,b.sjb_idx, b.sjb_type_no,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type  "
  sql=sql&" ,b.tw,b.th,b.ow,b.oh,b.fl,b.ow_m "
  sql=sql&" ,c.dwsize1, c.dhsize1, c.dwsize2, c.dhsize2, c.dwsize3, c.dhsize3 "
  sql=sql&" ,c.dwsize4, c.dhsize4, c.dwsize5, c.dhsize5, c.gwsize1, c.ghsize1 "
  sql=sql&" ,c.gwsize2, c.ghsize2, c.gwsize3, c.ghsize3, c.gwsize4, c.ghsize4 "
  sql=sql&" ,c.gwsize5, c.ghsize5, c.gwsize6, c.ghsize6 "
  sql=sql&" , d.xsize, d.ysize " 
  sql=sql&" ,e.opa,e.opb,e.opc,e.opd "
  sql=sql&" ,f.glassselect, g.glassselect "
  sql=sql&" from tk_framekSub a "
  sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
  sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
  sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
  sql=sql&" join tk_frame e on  b.fidx = e.fidx "
  sql=sql&" JOIN tng_whichitype f ON a.WHICHI_FIX = f.WHICHI_FIX "
  sql=sql&" JOIN tng_whichitype g ON a.WHICHI_AUTO = g.WHICHI_AUTO"
  If roptionType="1" Then 
  sql=sql&" Where a.fksidx='"&rfksidx&"' "
  ElseIf  roptionType="2" Then 
  sql=sql&" Where a.fkidx='"&rfkidx&"' and A.xi='"&xi&"' "
  End If
  'response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF

  alength = ""
  blength = ""


    zfksidx = rs(0)
    zWHICHI_AUTO = rs(1)
    zWHICHI_FIX = rs(2)
    zdoor_w = rs(3)
    zdoor_h = rs(4)
    zglass_w = rs(5)
    zglass_h = rs(6)
    zgls = rs(7)
    zsjb_idx = rs(8)
    zsjb_type_no = rs(9)
    zgreem_o_type = rs(10)
    zGREEM_BASIC_TYPE = rs(11)
    zgreem_fix_type = rs(12)
    ztw = rs(13)
    zth = rs(14)
    zow = rs(15)
    zoh = rs(16)
    zfl = rs(17)
    zow_m = rs(18)
    zdwsize1 = rs(19) '외도어 가로 치수
    zdhsize1 = rs(20) '외도어 세로 치수
    zdwsize2 = rs(21) '양개도어 가로 치수
    zdhsize2 = rs(22)  '양개도어 가로 치수
    zdwsize3 = rs(23) 'x
    zdhsize3 = rs(24) 'x
    zdwsize4 = rs(25) 'x
    zdhsize4 = rs(26) 'x
    zdwsize5 = rs(27) 'x
    zdhsize5 = rs(28) 'x
    zgwsize1 = rs(29) '하부픽스유리 가로 치수
    zghsize1 = rs(30) '하부픽스유리 세로 치수
    zgwsize2 = rs(31) '상부남마픽스유리 1 가로 치수
    zghsize2 = rs(32) '상부남마픽스유리 1 세로 치수
    zgwsize3 = rs(33) '상부남마픽스유리 2 가로 치수
    zghsize3 = rs(34) '상부남마픽스유리 2 세로 치수
    zgwsize4 = rs(35)
    zghsize4 = rs(36)
    zgwsize5 = rs(37)
    zghsize5 = rs(38)
    zgwsize6 = rs(39)
    zghsize6 = rs(40)
    zxsize = rs(41)
    zysize = rs(42)
    zopa = rs(43)
    zopb = rs(44)
    zopc = rs(45)
    zopd = rs(46)
    zglassselect_fix   = Rs(47) '1= 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리 , 5 = 박스라인하부픽스유리 , 6 = 박스라인상부픽스유리
    zglassselect_auto   = Rs(48)  '1 = 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리
    '수동에 길이 업데이트 시작 
    If zsjb_type_no = 6 Or zsjb_type_no = 7 Or zsjb_type_no = 11 Or zsjb_type_no = 12 Then '수동도어 계산

      Select Case zgreem_fix_type

        ' [1차] 편개 계열
        Case 9, 16, 17, 28, 35, 36 ' 편개 ,좌_편개 ,우_편개,박스라인 편개 ,박스라인 좌_편개 ,박스라인 우_편개 

          sudong_door_w = ztw - f_serobar_y 
          sudong_door_h = zth - lot_yysize - zfl
          opt = ztw - f_serobar_y
          sudong_garo = ztw - f_serobar_y
          sudong_sero = zth

          Select Case zwhichi_fix 
              Case 4, 22  ' 롯트바 = 4  박스라인롯트바 = 22  
                  blength = sudong_garo
              Case 6, 8, 9, 10  ' 세로바=6 180도 코너바=8 90도 코너바=9 비규격 코너바=10
                  blength = sudong_sero
              case 12 '➤ 외도어 도어 계산 !!! 
                  door_w = sudong_door_w 
                  door_h = sudong_door_h + zdhsize1   
                  alength = sudong_garo  '수동도어유리1 =12 (도면 추출용으로 도어유리 가로 alength)
                  blength = sudong_door_h  '수동도어유리1 =12 (도면 추출용으로 도어유리 세로 blength)
          End Select

        ' [2차] 양개 계열 
        Case 10, 18, 19, 29, 37, 38 ' 양개 ,좌_양개 ,우_양개,박스라인 양개 ,박스라인 좌_양개 ,박스라인 우_양개 

            sudong_door_w = (ztw - f_serobar_y) / 2 '반내림
            sudong_door_h = zth - lot_yysize - zfl
            opt = rtw - f_serobar_y
            sudong_garo = ztw - f_serobar_y
            sudong_sero = zth

            Select Case zwhichi_fix
                Case 4, 22 '수동에  롯트바4  , 박스라인롯트바22 
                    blength = sudong_garo
                Case 6, 8, 9, 10 ' 세로바=6 180도 코너바=8 90도 코너바=9 비규격 코너바=10
                    blength = sudong_sero
                case 13 '➤ 양개 도어 계산 !!! 
                    door_w = sudong_door_w 
                    door_h = sudong_door_h + zdhsize2  
                    alength = sudong_garo  '수동도어유리1 =13 (도면 추출용으로 도어유리 가로 alength)
                    blength = sudong_door_h  '수동도어유리1 =13 (도면 추출용으로 도어유리 세로 blength)
            End Select

        ' [3차] 고정창 계열
        Case 11, 20, 21, 30, 39, 40  '고정창 ,좌_고정창 ,우_고정창,박스라인 고정창 ,박스라인 좌_고정창 ,박스라인 우_고정창 
        
            sudong_glass_w = ztw - f_serobar_y
            sudong_glass_h = zth - f_garonamma_ysize - sudonghaba_y - zfl
            sudong_garo = ztw - f_serobar_y
            sudong_sero = zth

            Select Case zwhichi_fix
                Case 1, 2, 3, 5, 21  ' 가로바1, 가로바길게2 , 중간바3  , 하바5  , 박스라인21
                    blength = sudong_garo
                Case 6, 8, 9, 10     ' 세로바6 180도 코너바8 90도 코너바9 비규격 코너바10
                    blength = sudong_sero
                Case 14              '➤ 하부 픽스 유리 수동픽스유리1=14
                    glass_w = sudong_glass_w + zgwsize1
                    glass_h = sudong_glass_h + zghsize1
                    alength = sudong_glass_w     '(도면 추출용으로 수동픽스유리1 alength 가로값 입력)
                    blength = sudong_glass_h     '(도면 추출용으로 수동픽스유리1 blength 새로값 입력)
                Case 19               '➤ 박스라인 하부 픽스유리 = 19
                    glass_w = sudong_glass_w + zgwsize2
                    glass_h = sudong_glass_h + zghsize2
                    alength = sudong_glass_w     '(도면 추출용으로 수동픽스유리1 alength 가로값 입력)
                    blength = sudong_glass_h     '(도면 추출용으로 수동픽스유리1 blength 새로값 입력)
            End Select

        ' [4차] 편개 상부남마 계열
        Case 12, 22, 23, 31, 41, 42 '편개_상부남마 ,좌_편개_상부남마 ,우_편개_상부남마,박스라인 편개_상부남마 ,박스라인 좌_편개_상부남마 ,박스라인 우_편개_상부남마 

            sudong_door_w = ztw - f_serobar_y
            sudong_door_h = zoh
            sudong_glass_w = ztw - f_serobar_y
            sudong_glass_h = zth - lot_yysize - f_garonamma_ysize - zoh - zfl
            opt = ztw - f_serobar_y
            sudong_garo = ztw - f_serobar_y
            sudong_sero = zth

            Select Case zwhichi_fix
                Case 1, 2, 3, 4, 21, 22     ' 가로바1, 가로바길게2 , 중간바3 , 하바4 , 박스라인21, 박스라인22
                    blength = sudong_garo
                Case 6, 8, 9, 10            ' 세로바6 180도 코너바8 90도 코너바9 비규격 코너바10
                    blength = sudong_sero
                Case 12                     '➤ 외도어 도어 계산
                    door_w = sudong_door_w 
                    door_h = sudong_door_h + zdhsize1
                    alength = sudong_garo  '수동도어유리1 =12 (도면 추출용으로 도어유리 가로 alength)
                    blength = sudong_door_h  '수동도어유리1 =12 (도면 추출용으로 도어유리 세로 blength)
                Case 16 , 23                 '➤ 상부 픽스 유리 16 박스라인 상부 픽스 유리 23
                    glass_w =  sudong_glass_w + zgwsize3
                    glass_h =  sudong_glass_h + zghsize3
                    alength = sudong_glass_w  '(도면 추출용으로 수동상부픽스유리1=16  박스라인 상부 픽스유리=23  alength 가로값 입력)
                    blength = sudong_glass_h  '(도면 추출용으로 수동상부픽스유리1=16  박스라인 상부 픽스유리=23  blength 새로값 입력)
            End Select

        ' [5차] 양개 상부남마 계열
        Case 13, 24, 25, 32, 43, 44  '양개_상부남마 ,좌_양개_상부남마 ,우_양개_상부남마,박스라인 양개_상부남마 ,박스라인 좌_양개_상부남마 ,박스라인 우_양개_상부남마
            sudong_door_w = (ztw - f_serobar_y) / 2 '반내림
            sudong_door_h = zoh
            sudong_glass_w = ztw - f_serobar_y
            sudong_glass_h = zth - lot_yysize - f_garonamma_ysize - zoh - zfl
            opt = ztw - f_serobar_y
            sudong_garo = ztw - f_serobar_y
            sudong_sero = zth

            Select Case zwhichi_fix
                Case 1, 2, 3, 4, 21, 22     ' 가로바1, 가로바길게2 , 중간바3 , 하바4 , 박스라인21, 박스라인22
                    blength = sudong_garo
                    
                Case 6, 8, 9, 10            ' 세로바6 180도 코너바8 90도 코너바9 비규격 코너바10
                    blength = sudong_sero
                Case 13                  ' ➤ 양개 도어 계산
                    door_w = sudong_door_w 
                    door_h = sudong_door_h + zdhsize2
                    alength = sudong_garo  '수동도어유리1 =13 (도면 추출용으로 도어유리 가로 alength)
                    blength = sudong_door_h  '수동도어유리1 =13 (도면 추출용으로 도어유리 세로 blength)
                Case 16, 23              ' ➤ 상부 픽스 유리 16 박스라인 상부 픽스 유리 23
                    glass_w = sudong_glass_w + zgwsize3
                    glass_h = sudong_glass_h + zghsize3
                    alength = sudong_glass_w  '(도면 추출용으로 수동상부픽스유리1=16  박스라인 상부 픽스유리=23  alength 가로값 입력)
                    blength = sudong_glass_h  '(도면 추출용으로 수동상부픽스유리1=16  박스라인 상부 픽스유리=23  blength 새로값 입력)
            End Select

        ' [6차] 고정창 상부남마 계열
        Case 14, 26, 27, 33, 45, 46

            sudong_glass_w = ztw - f_serobar_y
            sudong_glass_h = zoh - sudonghaba_y 
            sudong_glass_w2 = ztw - f_serobar_y
            sudong_glass_h2 = zth - f_garonamma_ysize - zoh - zfl
            sudong_garo = ztw - f_serobar_y
            sudong_sero = zth

            Select Case zwhichi_fix
                Case 1, 2, 3, 4, 5, 21, 22  ' 가로바1, 가로바길게2 , 중간바3 , 하바4 , 하바5 , 박스라인21, 박스라인22
                    blength = sudong_garo
                Case 6, 8, 9, 10            ' 세로바6 180도 코너바8 90도 코너바9 비규격 코너바10
                    blength = sudong_sero
                Case 14                    ' ➤ 하부 픽스 유리
                    glass_w = sudong_glass_w + zgwsize1
                    glass_h = sudong_glass_h + zghsize1
                    alength = sudong_glass_w  
                    blength = sudong_glass_h  
                Case 19                    ' ➤ 박스라인 하부 픽스 유리
                    glass_w = sudong_glass_w + zgwsize2
                    glass_h = sudong_glass_h + zghsize2
                    alength = sudong_glass_w  
                    blength = sudong_glass_h
                Case 16, 23                ' ➤ 상부 픽스 유리
                    glass_w = sudong_glass_w2 + zgwsize3
                    glass_h = sudong_glass_h2 + zghsize3
                    alength = sudong_glass_w  
                    blength = sudong_glass_h
            End Select

        ' [7차] 편개 상부남마 중간통 계열
        Case 15, 34

            sudong_door_w = zow
            sudong_door_h = zoh
            sudong_glass_w = ztw - zow - f_serobar_y - f_junggan
            sudong_glass_h = zoh - sudonghaba_y 
            sudong_glass_w2 = ztw - f_serobar_y
            sudong_glass_h2 = zth - lot_yysize - f_garonamma_ysize - zoh - zfl
            sudong_garo = ztw - f_serobar_y
            sudong_sero = zth
            sudong_serojungan = zoh + zfl
            sudong_habar = ztw - zow - f_serobar_y - f_junggan

            Select Case zwhichi_fix
                Case 1, 2, 3, 4, 21, 22     ' 가로바1, 가로바길게2 , 중간바3 , 하바4 , 박스라인21, 박스라인22
                    blength = sudong_garo
                Case 6, 8, 9, 10
                    blength = sudong_sero
                Case 7  ' 세로 중간통바
                    blength = sudong_serojungan
                Case 5  ' 하바
                    blength = sudong_habar
                Case 12                   ' ➤ 외도어 도어
                    door_w = sudong_door_w
                    door_h = sudong_door_h + zdhsize1
                    alength = sudong_garo  
                    blength = sudong_door_h  
                Case 14                   ' ➤ 하부 픽스 유리
                    glass_w = sudong_glass_w + zgwsize1
                    glass_h = sudong_glass_h + zghsize1
                    alength = sudong_glass_w  
                    blength = sudong_glass_h
                Case 19                   ' ➤ 박스라인 하부 픽스 유리
                    glass_w = sudong_glass_w + zgwsize2
                    glass_h = sudong_glass_h + zghsize2
                    alength = sudong_glass_w  
                    blength = sudong_glass_h
                Case 16, 23               ' ➤ 상부 픽스 유리
                    glass_w = sudong_glass_w2 + zgwsize3
                    glass_h = sudong_glass_h2 + zghsize3
                    alength = sudong_glass_w  
                    blength = sudong_glass_h
            End Select

      End Select
      '수동에 길이 업데이트 끝
    else
      '자동에 길이 업데이트 시작
      Select Case zWHICHI_AUTO
          Case 1, 3  ' 박스 / 가로 남마 절단
              blength = box

          Case 2  
              ' 박스커버 ※ 추후 필요시 계산식 추가

          Case 4  ' 상부남마 중간소대 절단
              sang_jgan = zth - garonamma_ysize - box_yysize - door_high - zfl
              blength = sang_jgan

          Case 5  ' 중간소대 절단
              jgan = door_high + zfl
              blength = jgan

          Case 6, 7, 10  ' 세로 다대바 절단
              blength = zth

          Case 8  ' 하바 절단
              blength = opt_habar

          Case Else
              blength = ""
      End Select
      '자동에 길이 업데이트 끝

      '==================== 자동도어치수 , 픽스유리 계산 시작 ====================
      Select Case zgreem_o_type

          Case 1, 2, 3  ' ☑ 편개 그룹 (기본/슬라이딩/남마 등)

              Select Case zWHICHI_AUTO
                  Case 12  ' ➤ 외도어 도어 계산 자동도어유리1=12
                      If zGREEM_BASIC_TYPE = 1 Or zGREEM_BASIC_TYPE = 3 Then ' 홈 있음
                          If zsjb_type_no = 10 Then
                              door_w = (zow + junggan + junggan + zdwsize1) / 2  '이중슬라이딩 자동홈값 ex 15
                          Else
                              door_w = zow + junggan + zdwsize1                 '자동홈값 ex 15
                          End If
                      ElseIf zGREEM_BASIC_TYPE = 2 Or zGREEM_BASIC_TYPE = 4 Then ' 홈 없음
                          If zsjb_type_no = 10 Then
                              door_w = (zow + junggan + junggan) / 2
                          Else
                              door_w = zow + junggan
                          End If
                      End If
                      door_h = door_high + zdhsize1
                      alength  = zow  ' 도면 추출용 길이
                      blength  = door_high  ' 도면 추출용 길이
                  
                  Case 14  ' ➤ 하부 픽스 유리
                      glass_w = opt_habar + zgwsize1
                      glass_h = door_high - jadonghaba_y + zghsize1
                      alength = opt_habar  ' 도면 추출용 길이
                      blength = door_high - jadonghaba_y  ' 도면 추출용 길이

                  Case 16  ' ➤ 상부 픽스 유리 (왼쪽)
                      If zgreem_o_type = 2 Then
                          glass_w = box + zgwsize3
                          glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                          alength = box  ' 도면 추출용 길이
                          blength = (zth - garonamma_ysize - box_yysize - door_high - zfl)
                      End If
                      If zgreem_o_type = 3 Then
                          glass_w = zow + zgwsize3
                          glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                          alength = zow  ' 도면 추출용 길이
                          blength = (zth - garonamma_ysize - box_yysize - door_high - zfl)
                      End If
                      
                  Case 17  ' ➤ 상부 픽스 유리 (중앙 또는 오른쪽)
                      If zgreem_o_type = 3 Then
                          glass_w = opt_habar + zgwsize3
                          glass_h = sang_jgan + zghsize3
                          alength = opt_habar  ' 도면 추출용 길이
                          blength = sang_jgan
                      End If
                      

              End Select
          Case 4, 5, 6  ' ☑ 양개 그룹

              Select Case zWHICHI_AUTO

                  Case 13  ' ➤ 양개 도어
                      If zsjb_type_no = 10 Then
                          door_w =  ((zow / 2) + junggan + junggan) / 2   ' 이중슬라이딩
                          door_h = door_high + zdhsize1
                          alength = zow / 2  ' 도면 추출용 길이
                          blength = door_high  ' 도면 추출용 길이
                      Else
                          door_w = (zow + junggan + junggan) / 2   ' 일반 양개
                          door_h = door_high + zdhsize2
                          alength = zow / 2
                          blength = door_high  ' 도면 추출용 길이
                      End If

                  Case 14, 15  ' ➤ 하부 픽스 유리 (공통)
                      glass_w = opt_habar + zgwsize1
                      glass_h = door_high - jadonghaba_y + zghsize1
                      alength = opt_habar  ' 도면 추출용 길이
                      blength = door_high - jadonghaba_y

                  Case 16, 18  ' ➤ 상부 픽스 유리 (opt_habar 기준)
                      If zgreem_o_type = 5 Then

                          glass_w = box + zgwsize3
                          glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                          alength = box  ' 도면 추출용 길이
                          blength = (zth - garonamma_ysize - box_yysize - door_high - zfl)

                      elseIf zgreem_o_type = 6 Then
                          glass_w = opt_habar + zgwsize3
                          glass_h = sang_jgan + zghsize3
                          alength = opt_habar  ' 도면 추출용 길이
                          blength = sang_jgan 
                      End If
                      
                              
                  Case 17      ' ➤ 상부 픽스 유리 중앙
                      glass_w = zow + zgwsize3
                      glass_h = sang_jgan + zghsize3
                      alength = zow  ' 도면 추출용 길이
                      blength = sang_jgan 

              End Select

      End Select
        
    end if
    
    ' ===================== 자동도어치수 , 픽스유리 계산 끝 =====================
    ' === blength 값 업데이트 ===
    if blength > "0" then
        SQL = "Update tk_framekSub "
        SQL = SQL & " Set alength='" & alength & "',blength='" & blength & "' "
        SQL = SQL & " Where fksidx='" & zfksidx & "' "
        response.write(SQL) & "<br>"
        Dbcon.Execute(SQL)
    end if 
    
        
        'Response.Write "glass_w: " & glass_w & "<br>"
        'Response.Write "glass_h: " & glass_h & "<br>"
        'Response.Write "blength: " & blength & "<br>"
        'Response.Write "zglassselect_fix: " & zglassselect_fix & "<br>"
        'Response.Write "zglassselect_auto: " & zglassselect_auto & "<br>"
    ' === 도어 가로 세로  업데이트 ===
    if door_w>0 or door_h>0 then
        door_w = int(door_w)
        door_h = int(door_h)
        if zglassselect_fix = 1 or zglassselect_fix = 2 or zglassselect_auto = 1 or zglassselect_auto = 2 then  '1= 외도어 , 2 = 양개도어 

            SQL = "UPDATE tk_framekSub SET door_w='" & door_w & "', door_h='" & door_h & "'  "
            SQL = SQL & " WHERE fksidx='" & zfksidx & "' "
            SQL = SQL & "  AND (whichi_fix IN (12,13) OR whichi_auto IN (12,13))"
            'Response.Write "door_w: " & door_w & "<br>"
            'Response.Write "door_w: " & door_w & "<br>"
            'Response.Write "zglassselect_auto: " & zglassselect_auto & "<br>"
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL
        end if 

    end if 
    ' === 픽스유리 가로 세로  업데이트 ===
    if glass_w>0 or glass_h>0 then
        glass_w = int(glass_w)
        glass_h = int(glass_h)
        if zglassselect_fix >= 3 or zglassselect_auto >= 3 then  ' 도어(1,2)는 제외, 유리(3~)만 포함

            SQL = "UPDATE tk_framekSub SET glass_w='" & glass_w & "', glass_h='" & glass_h & "' "
            SQL = SQL & " WHERE fksidx='" & zfksidx & "' "
            SQL = SQL & " and gls not in (0,1,2) "
            'Response.Write "glass_w: " & glass_w & "<br>"
            'Response.Write "glass_h: " & glass_h & "<br>"
            'Response.Write "zglassselect_auto: " & zglassselect_auto & "<br>"
            'Response.Write "zglassselect_auto: " & zglassselect_auto & "<br>"
            Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL

        end if 

    end if 

  rs.movenext
  Loop
  end if
  rs.close

        


End If
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>