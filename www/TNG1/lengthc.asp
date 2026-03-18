<%@ codepage="65001" language="vbscript"%>

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

rsjidx=request("sjidx")
rsjsidx=request("sjsidx")
rfkidx=request("fkidx")
rsjb_idx=request("sjb_idx")
rfksidx=request("fksidx")
rjaebun=request("jaebun")
rboyang=request("rboyang")
rlengthc=request("lengthc")

SQL="Select "
SQL=SQL&" (Select count(distinct B.blength) From tk_framek A Join tk_framekSub B On A.fkidx=B.fkidx Where A.fkidx='"&rfkidx&"') "
SQL=SQL&" ,(Select max(distinct B.blength) From tk_framek A Join tk_framekSub B On A.fkidx=B.fkidx Where A.fkidx='"&rfkidx&"')"
Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  bar_cnt=Rs(0)
  bar_blength=Rs(1)

  If bar_cnt="1" and bar_blength="0" Then 'blength의 값이 동일하고 그 값이 0일 경우
    '프레임 정보 가져오기
    SQL="Select A.tw, A.th, A.ow, A.oh, A.fl FROM tk_framek A Where fkidx='"&rfkidx&"'"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
      tw=Rs1(0)  '검측가로
      th=Rs1(1)  '검측세로
      ow=Rs1(2)  '오픈도어가로
      oh=Rs1(3)  '오픈도어세로
      fl=Rs1(4)  '묻힘
    End if
    Rs1.close

    '프레임 좌표 정보 가져오기
    SQL="Select min(B.xi), max(B.xi), min(B.yi), max(B.yi) "
    SQL=SQL&" From tk_framek A "
    SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' and B.whichi_fix in (1, 2, 3 , 4, 5, 43, 44)  "
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
      min_xi=Rs1(0)  '프레임의 가장 왼쪽 x좌표
      max_xi=Rs1(1)  '프레임의 가장 오른쪽 x좌표
      min_yi=Rs1(2)  '프레임의 가장 위쪽 y좌표
      max_yi=Rs1(3)  '프레임의 가장 아래쪽 y좌표
    End if
    Rs1.close

    '가장 상단의 가로바와 세로바의 갯수 산출
    SQL="Select "
    SQL=SQL&" (Select count(*) From tk_framekSub B Where B.fkidx='"&rfkidx&"' and B.xi>='"&min_xi&"' and B.xi<='"&max_xi&"' and B.yi='"&min_yi&"' and B.whichi_fix='1')"
    SQL=SQL&" ,(Select count(*) From tk_framekSub B Where B.fkidx='"&rfkidx&"' and B.xi>='"&min_xi&"' and B.xi<='"&max_xi&"' and B.yi='"&min_yi&"' and B.whichi_fix='6')"
    REsponse.write (SQL)&"<br><br>"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
      top_wbar_cnt=Rs1(0)  '가장 상단의 가로바 갯수
      top_hbar_cnt=Rs1(1)  '가장 상단의 세로바 갯수
    End if
    Rs1.close

    '세로바들의 가로사이즈 합 구하기
    SQL="Select sum(D.ysize) "
    SQL=SQL&" From tk_framekSub B " 
    SQL=SQL&" Join tk_barasiF D on B.bfidx = D.bfidx "
    SQL=SQL&" Where B.fkidx='"&rfkidx&"' and B.xi>='"&min_xi&"' and B.xi<='"&max_xi&"' and B.yi='"&min_yi&"' "
    SQL=SQL&" and B.whichi_fix in (6, 7, 8, 9, 10) "
    Response.write (SQL)&"<br><br>"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
      top_hbar_xsize_sum=Rs1(0)  '가장 상단 세로바들의 가로사이즈 합
    End if
    Rs1.close

    '가로바들의 개별 가로사이즈 구하기
    wbar_blength= Int((tw - top_hbar_xsize_sum) / (top_wbar_cnt))
    Response.write "가로바길이:"&wbar_blength&"<br>"
    '가로바, 도어유리, 픽스유리 계열의 가로 길이를 업데이트하기 위한 대상 부속 찾기
    '==========================================
    SQL="Select B.fksidx, C.WHICHI_FIX, C.WHICHI_FIXname, D.WHICHI_AUTO, D.WHICHI_AUTOname, B.xi, B.yi, E.ysize, B.alength, B.blength "
    SQL=SQL&" From tk_framek A "
    SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
    SQL=SQL&" join tng_whichitype C on B.whichi_fix=C.whichi_fix "
    SQL=SQL&" Join tng_whichitype D on B.whichi_auto=D.whichi_auto "
    SQL=SQL&" Join tk_barasiF E on B.bfidx = E.bfidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
    SQL=SQL&" and B.whichi_fix in (1, 2, 3, 4, 5, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23) "
    Response.write (SQL)&"<br><br>"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
    Do while not Rs1.EOF
      fksidx=Rs1(0)
      whichi_fix=Rs1(1)
      whichi_fixname=Rs1(2)
      whichi_auto=Rs1(3)              
      whichi_autoname=Rs1(4)
      xi=Rs1(5)
      yi=Rs1(6)
      ysize=Rs1(7)
      alength=Rs1(8)
      blength=Rs1(9)
response.write "whichi_fix:"&whichi_fix&"<br>"
      Select case whichi_fix
        case 11 '기타
          alength=alength
          blength=blength 
        case 1, 2, 3, 5 '가로바 계열
          alength=ysize
          blength=wbar_blength 
        case 16,23  '16:수동상부픽스유리1, 23:박스라인 상부 픽스 유리
          alength=wbar_blength
          blength=blength
        case 21, 22 '21:박스라인 22:박스라인 롯트바
          alength=ysize
          blength=wbar_blength 
        case 14, 15, 16, 17, 18, 19 '픽스유리
          alength=wbar_blength
          blength=blength
        case 4, 21, 22, 23 '롯트바
          alength=ysize
          blength=wbar_blength 

        case 12, 13 '수동도어유리위치
          alength=wbar_blength
          blength=blength
        case else
          alength=alength
          blength=blength 
      end select  



      '가로바 길이 업데이트
      SQL="Update tk_framekSub Set alength='"&alength&"', blength='"&blength&"' Where fkidx='"&rfkidx&"' and fksidx='"&fksidx&"' "
      Response.write SQL&"<br>"
      Dbcon.Execute(SQL)

    Rs1.movenext
    Loop
    End if
    Rs1.close

    '세로바 계열의 세로 길이를 업데이트하기 위한 대상 부속 찾기
    '==========================================
    Response.write (SQL)&"<br><br>"
    SQL="Select B.fksidx, C.WHICHI_FIX, C.WHICHI_FIXname, D.WHICHI_AUTO, D.WHICHI_AUTOname, B.xi, B.yi, E.ysize, B.alength, B.blength "
    SQL=SQL&" From tk_framek A "
    SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
    SQL=SQL&" join tng_whichitype C on B.whichi_fix=C.whichi_fix "
    SQL=SQL&" Join tng_whichitype D on B.whichi_auto=D.whichi_auto "
    SQL=SQL&" Join tk_barasiF E on B.bfidx = E.bfidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
    SQL=SQL&" and B.whichi_fix in (6, 7, 8, 9, 10) "
    Response.write (SQL)&"<br><br>"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
    Do while not Rs1.EOF
      fksidx=Rs1(0)
      whichi_fix=Rs1(1)
      whichi_fixname=Rs1(2)
      whichi_auto=Rs1(3)              
      whichi_autoname=Rs1(4)
      xi=Rs1(5)
      yi=Rs1(6)
      ysize=Rs1(7)
      alength=Rs1(8)
      blength=Rs1(9)

      Select case whichi_fix
        case 6, 7, 8, 9, 10 '세로바 계열
          alength=ysize
          blength=th 
        case else
          alength=alength
          blength=blength 
      end select  

      '세로바 길이 업데이트
      SQL="Update tk_framekSub Set alength='"&alength&"', blength='"&blength&"' Where fkidx='"&rfkidx&"' and fksidx='"&fksidx&"' "
      Response.write SQL&"<br>"
      Dbcon.Execute(SQL)

    Rs1.movenext
    Loop
    End if
    Rs1.close
      Response.write "<br>"
    '도어유리와 픽스유리의 세로의 높이 데이터 넣기
    '==========================================

    '1.첫번째 열의 가로바 계열 바들의 세로길이 합 구하기1
    SQL="Select sum(B.ysize) "
    SQL=SQL&" From tk_framekSub B " 
    SQL=SQL&" Where B.fkidx='"&rfkidx&"' "
    SQL=SQL&" and B.xi='"&min_xi&"' and B.whichi_fix in (1, 2, 3, 4, 5, 43, 44) "
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
      first_col_wbar_ysize_sum=Rs1(0) '첫번째 열의 가로바 계열 바들의 세로길이 합
    End if
    Rs1.close

    '1-1.도어유리와 픽스유리의 갯수구하기
    SQL="Select count(*) "
    SQL=SQL&" From tk_framekSub B " 
    SQL=SQL&" Where B.fkidx='"&rfkidx&"' "
    SQL=SQL&" and B.xi='"&min_xi&"' and B.whichi_fix not in (1, 2, 3 , 4, 5, 43, 44) "
    response.write (SQL)&"<br><br>"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
      first_col_door_fix_cnt=Rs1(0) '첫번째 열의 도어유리와 픽스유리의 갯수
    End if
    Rs1.close

    'tw:검측가로 / th:검측세로 / ow:오픈도어가로 / oh:오픈도어세로 / fl:묻힘

    '2.첫번째 열의 도어유리와 픽스유리들의 세로길이 업데이트를 위한 대상 찾기
    SQL="Select B.fksidx, C.WHICHI_FIX, C.WHICHI_FIXname, D.WHICHI_AUTO, D.WHICHI_AUTOname, B.yi, B.hi, E.ysize, B.alength, B.blength "
    SQL=SQL&" From tk_framek A "
    SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx " 
    SQL=SQL&" Join tng_whichitype C on B.whichi_fix=C.whichi_fix " 
    SQL=SQL&" Join tng_whichitype D on B.whichi_auto=D.whichi_auto " 
    SQL=SQL&" Join tk_barasiF E on B.bfidx = E.bfidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
    SQL=SQL&" and B.xi='"&min_xi&"' and B.whichi_fix not in (1, 2, 3, 4, 5, 43, 44) "
    SQL=SQL&" Order by B.yi DESC "
    response.write (SQL)&"<br><br>"
    Rs1.open SQL,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
    Do while not Rs1.EOF
      fksidx=Rs1(0)
      whichi_fix=Rs1(1)
      whichi_fixname=Rs1(2)
      whichi_auto=Rs1(3)              
      whichi_autoname=Rs1(4)      
      ayi=Rs1(5)
      ahi=Rs1(6)
      ysize=Rs1(7)
      alength=Rs1(8)
      blength=Rs1(9)    
      k=k+1 '1:은 도어 또는 픽스유리, 이후는 픽스유리
      '도어유리와 픽스유리의 세로길이 계산
        Response.write "ayi:"&ayi&"<br>"
        Response.write "ahi:"&ahi&"<br>"        
      If k=1 then '도어유리 또는 픽스유리
      '도어/픽스유리세로(blength)=oh-하바의 세로
      '하바의 ysize 구하기
        SQL="Select sum(D.ysize) "
        SQL=SQL&" From tk_framekSub B "
        SQL=SQL&" Join tk_barasiF D on B.bfidx = D.bfidx "
        SQL=SQL&" Where B.fkidx='"&rfkidx&"' and B.xi='"&min_xi&"' and B.yi>'"&ayi&"' and B.whichi_fix='5' "
        Response.write SQL&"<br><br>"
        Rs2.open SQL,Dbcon
        If Not (Rs2.bof or Rs2.eof) Then
          ahabar_ysize=Rs2(0) '하바의 세로길이 합
        End if
        Rs2.close
        

        '유리가 1개일경우에는 도어높이를 자동계산한다.
        oh = th - first_col_wbar_ysize_sum + ahabar_ysize - fl

        blength=oh-ahabar_ysize
        first_blength=blength
        Response.write "oh:"&oh&"<br>"
        Response.write "ahabar_ysize:"&ahabar_ysize&"<br>"
        Response.write "blength:"&blength&"<br>"
        Response.write "first_blength:"&first_blength&"<br>"

      Else '픽스유리들
        '첫번재 픽스 도어/픽스유리 세로 길이 구


        blength= Int((th - first_col_wbar_ysize_sum - first_blength - fl) / (first_col_door_fix_cnt-1))

      End if 


      '도어유리와 픽스유리의 세로길이 업데이트/동일한 y좌표와 hi(높이)가진 유리에 적용
      SQL="Select fksidx "
      SQL=SQL&" From tk_framekSub "
      SQL=SQL&" Where yi='"&ayi&"' and hi='"&ahi&"' and fkidx='"&rfkidx&"' "
      Rs2.open SQL,Dbcon
      If Not (Rs2.bof or Rs2.eof) Then
        Do while not Rs2.EOF
          fksidx2=Rs2(0)
          SQL="Update tk_framekSub Set blength='"&blength&"' Where fkidx='"&rfkidx&"' and fksidx='"&fksidx2&"' "
          Response.write SQL&"<br>"
          Dbcon.Execute(SQL)
        Rs2.movenext
        Loop
      End if
      Rs2.close

    Rs1.movenext
    Loop
    End if
    Rs1.close

  ' Response.write"<script>window.opener.location.replace('TNG1_B_suju_quick.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"');location.replace('inspector_v4.asp?sjidx="&rsjidx&"&sjcidx="&rsjcidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');window.close();</script>"
    Response.write"<script>alert('자동길이적용 완료.');window.close();</script>"
  Else  ' 그렇지 않다면 종료
  'popup이면 window.close()
  'iframe이면 무시
    Response.write "<script>alert('길이 초기화 후 자동길이적용을 실행 할 수 있습니다.');window.close();</script>"
  End if
End if
Rs.close
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
