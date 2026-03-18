
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

rcidx=request("cidx")
rsjidx=request("sjidx") '수주키 TB TNG_SJA
rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
rsjb_type_no=Request("sjb_type_no") '제품타입
rsjbsub_Idx=Request("sjbsub_Idx")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rsjsidx=Request("sjsidx") '수주주문품목키
rgreem_f_a=Request("greem_f_a")
rGREEM_BASIC_TYPE=Request("GREEM_BASIC_TYPE")
rgreem_o_type=Request("greem_o_type")
rGREEM_FIX_TYPE=Request("GREEM_FIX_TYPE")
rgreem_habar_type=Request("greem_habar_type")
rgreem_lb_type=Request("greem_lb_type")
rGREEM_MBAR_TYPE=Request("GREEM_MBAR_TYPE")

rmwidth=Request("mwidth") '검측가로
rmheight=Request("mheight") '검측세로
rblength=Request("blength") '바의 길이
rafksidx=Request("afksidx") '복제할 바의 키값
rtw=Request("tw") '검측가로
rth=Request("th") '검측세로
row=Request("ow") '오픈 가로 치수
roh = Request("oh")  ' 오픈 세로 치수
rfl = Request("fl")  ' 묻힘 치수
row_m=Request("ow_m") '자동_오픈지정
rdoorglass_t =Request("doorglass_t") '도어유리두께
rfixglass_t =Request("fixglass_t") '픽스유리두께
rdooryn=Request("dooryn") '도어같이 나중
rasub_wichi1=Request("asub_wichi1")
rasub_wichi2 =Request("asub_wichi2")
rasub_bigo1=Request("asub_bigo1")
rasub_bigo2=Request("asub_bigo2")
rasub_bigo3=Request("asub_bigo3")
rasub_meno1 =Request("asub_meno1")
rasub_meno2 =Request("asub_meno2")

mode =Request("mode")

'Response.Write "mode : " & mode & "<br>" 
'response.end
if rgreem_f_a = "" then rgreem_f_a=1 end if
if rGREEM_BASIC_TYPE = "" then rGREEM_BASIC_TYPE=0 end if
if rgreem_o_type = "" then rgreem_o_type=0 end if
if rGREEM_FIX_TYPE = "" then rGREEM_FIX_TYPE=0 end if
if rgreem_habar_type = "" then rgreem_habar_type=0 end if
if rgreem_lb_type = "" then rgreem_lb_type=0 end if
if rGREEM_MBAR_TYPE = "" then rGREEM_MBAR_TYPE=0 end if


if rgreem_f_a="2" then 
    rgreem_habar_type = "0"
    rgreem_lb_type = "0"
    rGREEM_MBAR_TYPE = "0"
    rgreem_basic_type = "5"
    rGREEM_O_TYPE = "0"
end if


'rfidx=Request("fidx") '도면 타입


    SQL = "SELECT qtyidx, quan , pidx "
    SQL = SQL & " FROM tng_sjaSub  "
    SQL = SQL & " WHERE sjidx = '" & rsjidx & "' AND sjsidx = '" & rsjsidx & "'"

    'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then

        rqtyidx        = Rs(0)   ' 재질
        rquan       = Rs(1)   ' 수량
        rpidx        = Rs(2)   ' 페인트 pidx

    End If
    Rs.Close

    If rqtyidx = 5 Then 
        rpidx = 0
    end if

    If rqtyidx = 7 Then 
        rqtyidx = 3
    end if





if rfkidx<>"" and row_m <> 0 then  

 '강제 오픈치수 입력시작----최종 DB에 반영될 값은 row_m이 있으면 그것을 사용
    If row_m > 0  Then
   
        SQL = "UPDATE tk_framek SET ow='" & row_m & "',  ow_m='" & row_m & "' "
        sql=sql&" WHERE fkidx='" & rfkidx & "' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute SQL
    Else
        ' 없으면 계산값
        SQL = "UPDATE tk_framek SET ow='" & row & "',  ow_m=0 "
        sql=sql&" WHERE fkidx='" & rfkidx & "' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute SQL
    End if
    'Response.Write "최종 반영될 final_row: " & final_row & "<br>"
    'Response.Write "최종 반영될 opt: " & opt & "<br>"

    'Response.Write "계산된 자동 row: " & row & "<br>"
    'Response.Write "수동입력 row_m: " & row_m & "<br>"
    'Response.Write "최종 반영될 final_row: " & final_row & "<br>"
    'Response.Write "최종 반영될 opt: " & opt & "<br>"
    'response.end
    '===================
end if
if rfkidx<>"" and ( row_m = 0 or row_m="" ) then  
    if row > 0 Then     '오픈가로
        sql="update tk_framek set ow='"&row&"',  ow_m=0 "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
end if
'response.end
if rfkidx<>"" then  

                    'cdlevel
                        '<option value="1" >10만(기본)</option>                        
                        '<option value="2" 9만</option>
                       ' <option value="3" 11만</option>
                       ' <option value="4" 12만</option>
                       ' <option value="5" 소비자</option>
                       ' <option value="5" >1000*2400</option>
                   
    '재질정보,프레임의 길이정보 입력 시작 
    '================================
    
    if  rdooryn <> "" then    '도어같이 구분 0 나중,1 같이 ,2 안함
        sql="update tk_framek set dooryn='"&rdooryn&"'  "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if  rdoorglass_t > 0 then   '도어유리 두께
        sql="update tk_framek set doorglass_t='"&rdoorglass_t&"'  "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if  rfixglass_t > 0  then   '픽스유리 두께
        sql="update tk_framek set fixglass_t='"&rfixglass_t&"' "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    
    if  rtw > 0 then  '가로
        sql="update tk_framek set tw='"&rtw&"' "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    if  rth > 0 then  '세로
        sql="update tk_framek set th='"&rth&"' "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    
    if roh <> "" Then     '오픈세로
        sql="update tk_framek set oh='"&roh&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if rfl <> "" Then   '묻힘
        sql="update tk_framek set fl='"&rfl&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if

    SQL = "SELECT a.tw, a.th ,b. sjb_barlist, c.sjb_type_name  " '전체 가로 세로 합계 sja_sub 업데이트
    SQL = SQL & " FROM tk_framek  a "
    SQL = SQL & " left outer join TNG_SJB b on a.sjb_idx= b.sjb_idx "
    SQL = SQL & " left outer join tng_sjbtype c on a.sjb_type_no= c.sjb_type_no "
    SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "'"
    'Response.write (SQL)&"222222<br>"
    Rs.open SQL, Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do While Not Rs.EOF

        ltw=rs(0) ' 가로
        lth=rs(1) ' 세로
        lsjb_barlist=rs(2) '바리스트
        lsjb_type_name=rs(3) '제품타입명

    If IsNumeric(ltw) Then 
        total_tw = total_tw + ltw
    end if    

    If total_framename = "" Then
        total_framename = lsjb_type_name & "|" & lsjb_barlist
    Else
        total_framename = total_framename & "+" & lsjb_type_name & "|" & lsjb_barlist
    End If

    Rs.MoveNext
    Loop
    End If
    Rs.Close
    
    total_mheight = lth
           
    sql="update tng_sjaSub set mwidth='"&total_tw&"' , mheight='"&total_mheight&"' , framename='"&total_framename&"'  "
    SQL=SQL&" Where sjsidx='"&rsjsidx&"' " 
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    '강제 오픈치수 입력끝

    'Response.Write "수동입력 row_m: " & row_m & "<br>"
    '=========================================
    '바의 실제 길이 계산 시작
    if  rqtyidx > 0 and  rtw > 0 and rth > 0 then 

        '자동/수동 오픈 구하기 GREEM_F_A=2(자동) , GREEM_F_A=1(수동)
        '================================
        serobar = 0
        junggan  = 0
        ytw = 0
                
        sql1 = "Select A.fidx, A.ow, A.oh, A.tw, A.th "
        sql1 = sql1 & " , B.fksidx "
        sql1 = sql1 & " , B.whichi_fix, B.whichi_auto, C.xsize, C.ysize "
        sql1 = sql1 & " from tk_framek A "
        sql1 = sql1 & " Left Outer Join tk_framekSub B On A.fkidx = B.fkidx "
        sql1 = sql1 & " Left Outer Join tk_barasiF C On B.bfidx = C.bfidx "
        sql1 = sql1 & " Where A.fkidx='"&rfkidx&"' "
        'Response.Write(sql1) & "<br>" 
        'response.end
        Rs1.Open sql1, Dbcon
        If Not (Rs1.BOF Or Rs1.EOF) Then 
            Do While Not Rs1.EOF
                yfidx        = Rs1(0)
                yow          = Rs1(1)
                yoh          = Rs1(2)
                ytw          = Rs1(3)
                yth          = Rs1(4)
                yfksidx      = Rs1(5)
                ywhichi_fix  = Rs1(6)
                ywhichi_auto = Rs1(7)
                yxsize       = Rs1(8)
                yysize       = Rs1(9)

                Select Case CInt(ywhichi_auto)
                    Case 1 ' 박스 ysize
                    box_yysize = yysize
                    Case 3 ' 가로남마 ysize
                    garonamma_ysize = yysize
                    Case 6, 7, 10  ' 세로바들
                        serobar_y = serobar_y + yysize
                        'Response.Write "yysize : " & yysize & "<br>"  
                    Case 5 '중간소대
                        junggan  = yysize
                    Case 8 '자동하바
                        jadonghaba_y  = yysize
                End Select

                Select Case CInt(ywhichi_fix)
                    Case 4 , 22 ' 롯트바높이
                        lot_yysize = yysize
                    Case 1 , 2 , 3 ,  21 ' 가로바높이
                        f_garonamma_ysize = f_garonamma_ysize + yysize
                    Case 6,  8, 9, 10  ' 세로바 보이는 치수들 정면폭
                        f_serobar_y = f_serobar_y + yysize
                        'Response.Write "yysize : " & yysize & "<br>"  
                    Case 7 '세로중간통바
                        f_junggan  = yysize
                    Case 5 '수동 하바높이
                        sudonghaba_y  = yysize
                End Select
            Rs1.MoveNext
            Loop

            ' 자동에 최종 box 계산 , 가로남마ysize 계산
            box = ytw - serobar_y 'box 박스 길이
            garonamma_ysize =  garonamma_ysize 'garonamma_ysize 가로남마 높이
            box_yysize = box_yysize 'box 박스 높이
            jadonghaba_y = jadonghaba_y '자동하바 높이

        End If
        Rs1.Close
        '================================
        '자동 박스 구하기 끝
        '오픈추가 시작
        '=======================================
        SQL = " select A.opa,A.opb,A.opc,A.opd,B.sjb_type_no ,A.greem_fix_type  "
        SQL = SQL & " from tk_frame A "
        SQL = SQL & " join tk_framek B on A.fidx = B.fidx "
        SQL = SQL & " where B.fkidx = '" & rfkidx & "' "
        'Response.write (SQL)&"<br>"
        Rs.open SQL, Dbcon
        If Not (Rs.bof or Rs.eof) Then 

            opa = Rs(0)
            opb = Rs(1)
            opc = Rs(2)
            opd = Rs(3)
            zsjb_type_no = Rs(4)
            zgreem_fix_type = Rs(5)
            If zsjb_type_no = 1 Or zsjb_type_no = 2 Or zsjb_type_no = 3 Or zsjb_type_no = 4 Then  ' 알자_단알자

                Select Case opa
                    Case "a1", "a3", "a7"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan) / 2
                        end if
                        opt_habar = box - junggan - opt 
                    Case "a2"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - junggan) / 2
                        end if
                        opt_habar = (box - junggan - junggan - opt) / 2
                    Case "a4", "a6", "a8"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - 20 - junggan - junggan) / 2
                        end if
                        opt_habar = (box - junggan - junggan - opt) / 2
                    Case "a5"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - 25) / 2
                        end if
                        opt_habar = box - junggan - opt 
                End Select

            ElseIf zsjb_type_no = 5 Then  ' 슬림자동 b3,b4 ,b7,(b8- 가능. 양개에 좌우 니깐~)(GREEM_BASIC_TYPE=2 인서트타입,4 자동홈바 없는 타입 제작불가)

                Select Case opb
                    Case "b1", "b3", "b7"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan) / 2
                        end if
                        opt_habar = box - junggan - opt 
                    Case "b2"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - junggan) / 2
                        end if
                        opt_habar = (box - junggan - junggan - opt) / 2
                    Case  "b5"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - 25) / 2
                        end if
                        opt_habar = box - junggan - opt 
                    Case   "b4", "b6" , "b8"  'b6,b8 는 양개의 좌우 니깐
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - 20 - junggan - junggan) / 2
                        end if
                        opt_habar = (box - junggan - junggan - opt) / 2
                End Select

            ElseIf zsjb_type_no = 8 Or zsjb_type_no = 9 Or zsjb_type_no = 15 Then  ' 단자_삼중단자

                Select Case opc
                    Case "c1", "c3", "c5", "c7"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - 25) / 2
                        end if
                        opt_habar = box - junggan - opt 
                    Case "c2", "c4", "c6", "c8"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - junggan - 20) / 2
                        end if
                        opt_habar = (box - junggan - junggan - opt) / 2
                End Select   
'response.Write "opt: " & opt & "<br>" 
'response.Write "row_m: " & row_m & "<br>" 
'response.Write "opt_habar: " & opt_habar & "<br>"
'response.end
            ElseIf zsjb_type_no = 10 Then  ' 이중슬라이딩

                Select Case opd  'd1 = 편개  d2= 양개 d3=인서트편개 d4=인서트양개  d5 = 픽스바 없는 편개  d6= 픽스바 없는 양개 d7  = 자동홈바 없는 편개 d8  = 자동홈바 없는 양개
                    Case "d1" , "d5"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - junggan - 27.5) / 1.5
                        end if
                        opt_habar = box - junggan - opt
                    Case "d2" , "d4" , "d6" , "d8"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (2 * box) / 3 + 30 - junggan - junggan
                        end if
                        opt_habar = (box - junggan - junggan - opt) / 2
                    Case "d3", "d7"
                        opt = 0
                        opt_habar = 0

                End Select
            
            End If
        End If
        Rs.close
        'Response.Write " opt_habar: " & opt_habar & " / "& zfksidx &"<br>" 
        '======================
        '계산된 오픈 소숫점 처리 시작 및 하바 치수 정리
        opt = Int(opt)'반내림 

        If opt_habar = Int(opt_habar) Then '반올림
            opt_habar = opt_habar
        Else
            opt_habar = Int(opt_habar) + 1
        End If
        '계산된 오픈 소숫점 처리 시작 및 하바 치수 정리
        '======================
        '======================
        '오픈치수 업데이트  시작
        if  opt > 0 and (row_m=0 or row_m="") then
            sql="update tk_framek set ow='"&opt&"' "
            sql=sql&" where fkidx='"&rfkidx&"' "
            'response.write (SQL)&"owow<br>"
            Dbcon.Execute (SQL)  
        row=opt   
        end if
        '오픈치수 업데이트  끝
        '======================

        '도어높이 계산 시작
        '=======================================

        SQL="Select A.greem_o_type , A.th, B.whichi_fix, B.whichi_auto, C.xsize, C.ysize, A.oh, a.ow, A.fl , A.greem_fix_type "
        SQL=SQL&" From tk_framek A "
        SQL=SQL&" Left Outer Join tk_framekSub B On A.fkidx = B.fkidx  "
        SQL=SQL&" Left Outer Join tk_barasiF C On B.bfidx = C.bfidx "
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"1111<br>"
        Rs.open SQL, Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            Do while not Rs.EOF

            qgreem_o_type = Rs(0)
            qth = Rs(1)
            qwhichi_fix = Rs(2)
            qwhichi_auto = Rs(3)
            qxsize = Rs(4)
            qysize = Rs(5) '박스높이 ' 롯트바 높이
            qoh = Rs(6) 
            qow = Rs(7)
            qfl = Rs(8)
            qgreem_fix_type = Rs(9)
                ' 자동 기준 계산 (whichi_auto)
                If qwhichi_auto = 1 Then
                    If qgreem_o_type = 1 Or qgreem_o_type = 4 Then  ' 편개 양개
                        If Not IsNull(qth) And Not IsNull(qysize) Then
                            box_ysize=qysize
                            door_high = qth - box_ysize - qfl
                        End If
                    Else ' 남마타입들
                        door_high = qoh
                    End If
                End If

                If (qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3) Then   ' 편개 
                    qow_single = qow
                Else '  양개
                    qow_double = qow /2 
                    qow_double = Int(qow_double)'반내림
                End If
            Rs.MoveNext
        Loop
        End If
        Rs.close

        if door_high > 0 then
            sql="update tk_framek set oh='"&door_high&"' "
            sql=sql&" where fkidx='"&rfkidx&"' "
            'response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)  
        roh=door_high   
        end if

        '=======================================
        '도어높이 계산 끝

        sql=" select  a.fksidx , a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.glass_w, a.glass_h, a.gls "
        sql=sql&" ,b.sjb_idx, b.sjb_type_no,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type  "
        sql=sql&" ,b.tw,b.th,b.ow,b.oh,b.fl,b.ow_m "
        sql=sql&" ,c.dwsize1, c.dhsize1, c.dwsize2, c.dhsize2, c.dwsize3, c.dhsize3 "
        sql=sql&" ,c.dwsize4, c.dhsize4, c.dwsize5, c.dhsize5, c.gwsize1, c.ghsize1 "
        sql=sql&" ,c.gwsize2, c.ghsize2, c.gwsize3, c.ghsize3, c.gwsize4, c.ghsize4 "
        sql=sql&" ,c.gwsize5, c.ghsize5, c.gwsize6, c.ghsize6 "
        sql=sql&" , d.xsize, d.ysize " 
        sql=sql&" ,e.opa,e.opb,e.opc,e.opd "
        sql=sql&" ,f.glassselect, g.glassselect ,a.sunstatus "
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" join tk_frame e on  b.fidx = e.fidx "
        SQL = SQL & " JOIN tng_whichitype f ON a.WHICHI_FIX = f.WHICHI_FIX "
        SQL = SQL & " JOIN tng_whichitype g ON a.WHICHI_AUTO = g.WHICHI_AUTO"
        sql=sql&" Where a.fkidx='"&rfkidx&"' "
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
            zsunstatus = rs(49)

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
                                alength = sudong_glass_w2  
                                blength = sudong_glass_h2
                        End Select

                    ' [7차] 편개 상부남마 중간통 계열 zsjb_type_no= 7(단알프프레임) 12(삼중단열프레임) 가로바 길게 할 경우 하부픽스 유리 가로는 -8 세로는 내경으로 
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

                        if zsjb_type_no =  7  then  'zsjb_type_no= 7(단알프프레임) 

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
                                Case 14                   ' ➤ 하부 픽스 유리 하부픽스 유리 가로는 -8 세로는 내경으로 
                                    glass_w = sudong_glass_w + zgwsize1 '유리 가로는 -8
                                    glass_h = sudong_glass_h            '세로는 내경으로 
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
                                    alength = sudong_glass_w2  
                                    blength = sudong_glass_h2
                            End Select

                        elseif  zsjb_type_no =  12 then   'zsjb_type_no= 12(삼중단열프레임)

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
                                Case 14                   ' ➤ 하부 픽스 유리 하부픽스 유리 가로는 -8 세로는 내경으로 
                                    glass_w = sudong_glass_w + zgwsize1 '유리 가로는 -8
                                    glass_h = sudong_glass_h            '세로는 내경으로 
                                    alength = sudong_glass_w  
                                    blength = sudong_glass_h
                                Case 19                   ' ➤ 박스라인 하부 픽스 유리  가로는 -8 세로는 내경으로 
                                    glass_w = sudong_glass_w + zgwsize2 '유리 가로는 -8
                                    glass_h = sudong_glass_h  '세로는 내경으로 
                                    alength = sudong_glass_w  
                                    blength = sudong_glass_h
                                Case 16, 23               ' ➤ 상부 픽스 유리
                                    glass_w = sudong_glass_w2 + zgwsize3
                                    glass_h = sudong_glass_h2 + zghsize3
                                    alength = sudong_glass_w2  
                                    blength = sudong_glass_h2
                            End Select    

                        else

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
                                    alength = sudong_glass_w2 
                                    blength = sudong_glass_h2
                            End Select
                        
                        end if

                End Select
                '수동에 길이 업데이트 끝
            else
                '자동에 길이 업데이트 시작
                Select Case zWHICHI_AUTO
                    Case 1, 3  ' 박스 / 가로 남마 절단
                        blength = box

                    Case 2   '박스커버
                        blength = box -1

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

                '==================== 자동도어치수 , 픽스유리 계산 시작 , 상부픽스 추가계산 ====================

                '픽스 상부 오사이 추가 구문.
                'rSJB_TYPE_NO 1,3 알자,단알자,슬림자동문은 상부남마 오사이가 없으므로 sunstatus = 0, 1
                'rSJB_TYPE_NO 2.4 복층알자,삼중단알자는 상부남마 오사이가 있음 sunstatus = 0, 1 ,2
                'rSJB_TYPE_NO 나머진 sunstatus = 0
                'sunstatus=1 은 픽스하부유리 위에 상부픽스 
                'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 
                'sunstatus=3 은 하부픽스위에 상부남마 에
                'sunstatus=4 은 양개 중앙에
                select case zsunstatus

                    case 1
                        blength = opt_habar    ' 하바 위에 상부픽스 절단
                    case 2
                        If zgreem_o_type = 2 or zgreem_o_type = 5 Then
                            blength = box    ' 박스 위에 상부픽스 절단
                        elseif zgreem_o_type = 3 Then
                            blength = zow    ' 도어 위에 상부남마 
                        elseif zgreem_o_type = 6 Then
                            blength = opt_habar    ' 하바 위에 상부픽스 절단
                        end if
                    case 3
                        blength = opt_habar    ' 하부픽스위에 상부남마 
                    case 4
                    blength = zow    ' 하바 위에 상부픽스 절단

                end select

                ' 🔽 추가 조건 ' 오사이 경우!
                If zWHICHI_AUTO = 24 Then
                    blength = blength - 1
                End If

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
                'response.write(SQL) & "<br>"
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
                    'Response.write (SQL)&"<br><br>"
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
                    'Response.write (SQL)&"<br><br>"
                    Dbcon.Execute SQL

                end if 

            end if 

        rs.movenext
        Loop
        end if
        rs.close

    end if 'if  rqtyidx > 0 and  rtw > 0 and rth > 0 then 
    '바의 실제 길이 계산 끝
    '=========================================
end if 'if rfkidx<>"" then  
'response.end

if Request("part")="choiceb" then 
response.write"<script>location.replace('TNG1_b_choiceframeb.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"');</script>"
elseif mode="quick" then 
response.write"<script>location.replace('TNG1_B_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"');</script>"
else
response.write"<script>location.replace('tng1_b_suju2.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"');</script>"
end if


set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>