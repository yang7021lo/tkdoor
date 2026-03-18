
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

rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no")
rgreem_f_a=Request("greem_f_a")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")


SQL=" select A.fksidx, A.WHICHI_AUTO, A.WHICHI_FIX, A.door_w, A.door_h, A.glass_w, A.glass_h, A.gls "
SQL=SQL&" , B.sjb_idx, B.sjb_type_no, B.greem_o_type, B.GREEM_BASIC_TYPE, B.greem_fix_type  "
SQL=SQL&" , B.tw, B.th, B.ow, B.oh, B.fl, B.ow_m "
SQL=SQL&" , C.dwsize1, C.dhsize1, C.dwsize2, C.dhsize2, C.dwsize3, C.dhsize3 "
SQL=SQL&" , C.dwsize4, C.dhsize4, C.dwsize5, C.dhsize5, C.gwsize1, C.ghsize1 "
SQL=SQL&" , C.gwsize2, C.ghsize2, C.gwsize3, C.ghsize3, C.gwsize4, C.ghsize4 "
SQL=SQL&" , C.gwsize5, C.ghsize5, C.gwsize6, C.ghsize6 "
SQL=SQL&" , D.xsize, D.ysize " 
SQL=SQL&" , E.opa, E.opb, E.opc, E.opd "
SQL=SQL&" , F.glassselect, G.glassselect, A.xi, A.yi, A.wi, A.hi, A.alength, A.blength "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Join tk_framek B on A.fkidx = B.fkidx "
SQL=SQL&" Join tng_sjbtype C on B.sjb_type_no = C.SJB_TYPE_NO "
SQL=SQL&" Join tk_barasiF D on A.bfidx = D.bfidx "
SQL=SQL&" Join tk_frame E on A.fidx = E.fidx "
SQL=SQL&" Join tng_whichitype F on A.WHICHI_FIX = F.WHICHI_FIX "
SQL=SQL&" Join tng_whichitype G on A.WHICHI_AUTO = G.WHICHI_AUTO"
SQL=SQL&" Where B.sjsidx='"&rsjsidx&"' "
response.write (SQL)&"<br><br><br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF

  zfksidx = Rs(0)
  zWHICHI_AUTO = Rs(1)
  zWHICHI_FIX = Rs(2)
  zdoor_w = Rs(3)
  zdoor_h = Rs(4)
  zglass_w = Rs(5)
  zglass_h = Rs(6)
  zgls = Rs(7)
  zsjb_idx = Rs(8)
  zsjb_type_no = Rs(9)
  zgreem_o_type = Rs(10)
  zGREEM_BASIC_TYPE = Rs(11)
  zgreem_fix_type = Rs(12)
  ztw = Rs(13)
  zth = Rs(14)
  zow = Rs(15)
  zoh = Rs(16)
  zfl = Rs(17)
  zow_m = Rs(18)
  zdwsize1 = Rs(19) '외도어 가로 치수
  zdhsize1 = Rs(20) '외도어 세로 치수
  zdwsize2 = Rs(21) '양개도어 가로 치수
  zdhsize2 = Rs(22) '양개도어 가로 치수
  zdwsize3 = Rs(23) '도어임시3_w
  zdhsize3 = Rs(24) '도어임시3_h
  zdwsize4 = Rs(25) '도어임시4_w
  zdhsize4 = Rs(26) '도어임시4_h
  zdwsize5 = Rs(27) '도어임시5_w
  zdhsize5 = Rs(28) '도어임시5_h
  zgwsize1 = Rs(29) '하부픽스유리 가로 치수
  zghsize1 = Rs(30) '하부픽스유리 세로 치수
  zgwsize2 = Rs(31) '박스라인 경우 하부픽스유리2 가로 치수
  zghsize2 = Rs(32) '박스라인 경우 하부픽스유리2 세로 치수
  zgwsize3 = Rs(33) '상부픽스유리 1 가로 치수
  zghsize3 = Rs(34) '상부픽스유리 1 세로 치수
  zgwsize4 = Rs(35) '픽스유리3_w
  zghsize4 = Rs(36) '픽스유리3_h
  zgwsize5 = Rs(37) '픽스유리4_w
  zghsize5 = Rs(38) '픽스유리4_h
  zgwsize6 = Rs(39) '픽스유리5_w
  zghsize6 = Rs(40) '픽스유리5_h
  zxsize = Rs(41)
  zysize = Rs(42)
  zopa = Rs(43)
  zopb = Rs(44)
  zopc = Rs(45)
  zopd = Rs(46)
  zglassselect_fix   = Rs(47) '1= 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리 , 5 = 박스라인하부픽스유리 , 6 = 박스라인상부픽스유리
  zglassselect_auto   = Rs(48)  '1 = 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리
  xi = Rs(49)
  yi = Rs(50)
  zwi = Rs(51)
  zhi = Rs(52)
  ralength = Rs(53)
  rblength = Rs(54)
  i = i + 1

Response.write "zsjb_type_no:"&zsjb_type_no&"<br>"

    select case zWHICHI_FIX
      case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 21, 22 '1:가로바, 2:가로바 길게, 3:중간바, 4:롯트바, 5:하바, 21:박스라인, 22:박스라인롯트바,6:세로바,7:세로중간통바,8:180도 코너바,9:90도코너바,10:비규격코너바,20:상부남마세로중간통바
        zwhichi_fix_type="wb"
      case 12                 '수동도어유리1(편개)
        zwhichi_fix_type="sd" 
      case 13                '수동도어유리2(양개)
        zwhichi_fix_type="db" 
      Case 14, 15             '하부픽스 유리1, 2
        zwhichi_fix_type="bg" 
      Case 16, 17, 18         '상부남마픽스유리 1,2,3
        zwhichi_fix_type="hg" 
      Case 19 , 23            '박스라인 하부픽스 유리 ,  11
        zwhichi_fix_type="bl" 
      case 11, 24, 25         '기타
        zwhichi_fix_type="ec" 
    end select 


 '수동도어 계산
  If zsjb_type_no = 6 Or zsjb_type_no = 7 Or zsjb_type_no = 11 Or zsjb_type_no = 12 Then



  Response.write "zgreem_fix_type:"&zgreem_fix_type&"<br>"
  Response.write "zwhichi_fix:"&zwhichi_fix&"<br>"
  Response.write "zdwsize1:"&zdwsize1&"<br>"
  Response.write "zdhsize1:"&zdhsize1&"<br>"



          Select Case zwhichi_fix 
              Case 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  11, 20, 21, 22, 24, 25 ' 롯트바 = 4  박스라인롯트바 = 22 ,세로바=6 180도 코너바=8 90도 코너바=9 비규격 코너바=10 
                alength=0
                if zwhichi_fix_type="wb" then 
                    blength=rblength
                else
                    blength=ralength
                end if
                  door_w=0
                  door_h=0
                  glass_w=0
                  glass_h=0
                  Response.write "바<br>"
              Case 12 '외도어
                  if zwhichi_fix_type="wb" then 
                    ralength=int(rblength)
                    rblength=0
                  end if
                  alength=ralength
                  blength=rblength  '도어의 세로의 길이 
'=====                  
                  'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                    door_w=int(alength+zdwsize1)
                    door_h=int(blength+zdhsize1)
                    glass_w=0
                    glass_h=0
                  'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                  '  door_w=int(alength+zdwsize1)
                  '  door_h=int((zth-rblength-zfl-sysize)/scnt)
                  '  glass_w=0
                  '  glass_h=0
                  'end if
'=====  
                  Response.write "외도어<br>"
              Case 13 '양개도어
                  if zwhichi_fix_type="wb" then 
                    ralength=int(rblength)
                    rblength=0
                  end if
'=====              
                  alength=ralength  '도어의 가로의 길이
                  blength=rblength   '도어의 세로의 길이     
                  'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                    door_w=int(alength+zdwsize2)
                    door_h=int(blength+zdhsize2)
                    glass_w=0
                    glass_h=0
                  'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                  '  door_w=int(alength+zdwsize2)
                  '  door_h=int((zth-rblength-zfl-sysize)/scnt)
                  '  glass_w=0
                  '  glass_h=0
                  'end if
'=====  
                  Response.write "양개도어<br>"
              Case 14, 15 '하부픽스 유리1, 2
                  if zwhichi_fix_type="wb" then 
                    ralength=int(rblength)
                    rblength=0
                  end if
'=====    
response.write "zgwsize1:"&zgwsize1&"<br>"
response.write "zghsize1:"&zghsize1&"<br>"
                  alength=int(ralength)          '하부픽스 유리의 가로의 길이
                  blength=int(rblength)          '하부픽스 유리의 세로의 길이           
                  'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                    door_w=0
                    door_h=0
                    glass_w=int(alength+zgwsize1)   '하부픽스 유리의 가로의 길이
                    glass_h=int(blength+zghsize1)   '하부픽스 유리의 세로의 길이
                  'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                  '  door_w=0
                  '  door_h=0
                  '  glass_w=int(alength+zgwsize1)
                  '  glass_h=int((zth-rblength-zfl-sysize)/scnt)
                  '  response.write glass_h&"/<br>"

                  'end if
'===== 

                  Response.write "하부픽스 유리<br>"
              Case 19 , 23  '박스라인 하부픽스 유리 ,  11
                  if zwhichi_fix_type="wb" then 
                    ralength=int(rblength)
                    rblength=0
                  end if
'=====     
                  alength=int(ralength)          '박스라인 하부픽스 유리의 가로의 길이
                  blength=int(rblength)          '박스라인 하부픽스 유리의 세로의 길이              
                  'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우
                    door_w=0
                    door_h=0
                    glass_w=int(alength+zgwsize2)   '박스라인 하부픽스 유리의 가로의 길이
                    glass_h=int(blength+zghsize2)   '박스라인 하부픽스 유리의 가로의 길이

                  'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                  '  door_w=0
                  '  door_h=0
                  '  glass_w=int(alength+zgwsize2)
                  '  glass_h=int((zth-rblength-zfl-sysize)/scnt)

                  'end if
'===== 
                  Response.write "박스라인 하부픽스 유리<br>"
              Case 16, 17, 18 '상부남마픽스유리 1,2,3
                  if zwhichi_fix_type="wb" then 
                    ralength=int(rblength)
                    rblength=0
                  end if
'=====          
                  alength=int(ralength)          '상부남마픽스유리 유리의 가로의 길이
                  blength=int(rblength)          '상부남마픽스유리 유리의 세로의 길이         
                  'if Cint(zfksidx)=Cint(rfksidx) then '선택한 부속인경우

                    door_w=0
                    door_h=0
                    glass_w=int(alength+zgwsize3)   '상부남마픽스유리 유리의 가로의 길이
                    glass_h=int(blength+zghsize3)   '상부남마픽스유리 유리의 세로의 길이
                  'Else                                 '선택한 부속이 아닌경우 (검측세로-선택한 부속의 세로 길이-묻힘-가로바의세로합)/n으로
                  '  door_w=0
                  '  door_h=0
                  '  glass_w=int(alength+zgwsize3)
                  '  glass_h=int((zth-rblength-zfl-sysize)/scnt)

                  'end if
'===== 
                  Response.write "상부남마픽스유리<br>"
              case 11, 24, 25 '기타
                  if zwhichi_fix_type="wb" then 
                    ralength=int(rblength)
                    rblength=0
                  end if
                  alength=int(ralength)
                  blength=int(rblength)                  
                  door_w=0
                  door_h=0
                  glass_w=0 
                  glass_h=0   '
                  Response.write "기타<br>"
          End Select



  '선택한 해당 자재의 길이 적용

 
    SQL="Update tk_framekSub "
    SQL=SQL&" Set door_w='"&door_w&"', door_h='"&door_h&"'"
    SQL=SQL&" , glass_w='"&glass_w&"', glass_h='"&glass_h&"' "
    SQL=SQL&" Where fksidx='"&zfksidx&"' "
    Response.write (SQL)&"<br><br>"
    'Dbcon.Execute SQL


  end if


Rs.movenext
Loop
End if
Rs.close

response.write "<script>alert('계산값이 적용되었습니다.');opener.location.replace('inspector_v2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');window.close();</script>"
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>