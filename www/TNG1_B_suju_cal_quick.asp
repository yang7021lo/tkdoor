
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


  if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
  end if

rsjcidx=request("cidx")
rsjcidx=request("sjcidx")
rsjidx=request("sjidx") '수주키 TB TNG_SJA


rdoorglass_t = request("doorglass_t") '도어 유리
rfixglass_t  = request("fixglass_t") ' 픽스 유리
coat=request("coat") '코트
' response.write("rdoorglass_t = '" &rdoorglass_t & "' ")
' response.write("rfixglass_t =' " & rfixglass_t & "' ")
' response.end


    SQL = "SELECT a.sjcidx, b.cname,b.cgubun, b.cdlevel, b.cflevel, a.suju_kyun_status "
    SQL = SQL & "FROM TNG_SJA a "
    SQL = SQL & "JOIN tk_customer b ON b.cidx = a.sjcidx "
    SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "'"
    'Response.Write SQL & "<br>" 
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
        sjcidx    = Rs1(0)
        cname     = Rs1(1)
        cgubun   = Rs1(2)
        cdlevel   = Rs1(3) ' 1=10만(기본), 2=9만, 3=11만, 4=12만, 5=소비자, 6=1000*2400
        cflevel   = Rs1(4) ' 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=10% 업
        suju_kyun_status = Rs1(5) ' 0=수주, 1=견적
    End If
    Rs1.Close

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
' rdoorglass_t =Request("doorglass_t") '도어유리두께
' rfixglass_t =Request("fixglass_t") '픽스유리두께
rdooryn=Request("dooryn") '0=도어나중 1=도어같이 2=도어안함
rdoorchoice=Request("doorchoice") '0=도어포함 1=도어별도  2=도어제외
rasub_wichi1=Request("asub_wichi1")
rasub_wichi2 =Request("asub_wichi2")
rasub_bigo1=Request("asub_bigo1")
rasub_bigo2=Request("asub_bigo2")
rasub_bigo3=Request("asub_bigo3")
rasub_meno1 =Request("asub_meno1")
rasub_meno2 =Request("asub_meno2")
'rquan =Request("quan")
mode =Request("mode")
op_tw =Request("op_tw") '오픈으로_외경구하기
dh_th =Request("dh_th") '도어높이_외경구하기
opt_habar1 =Request("opt_habar1") ' 언발란스 양개의 하바 인풋값
If opt_habar1 = "" Then
    opt_habar1 = 0
End If

'Response.Write "opt_habar1 : " & opt_habar1 & "<br>" 
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
    'response.end
    Rs.open Sql,Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then

        rqtyidx        = Rs(0)   ' 재질
        rquan       = Rs(1)   ' 수량
        rpidx        = Rs(2)   ' 페인트 pidx

    End If
    Rs.Close

    If rqtyidx = 5 Then 
        'rpidx = 0
    end if

    If rqtyidx = 7 Then 
        rqtyidx = 3
    end if

    SQL="Select fidx From tk_framek Where fkidx='"&rfkidx&"'"
    Rs.open Sql,Dbcon
    response.write (SQL)&"<br>"
    If Not (Rs.bof or Rs.eof) Then 
        fix_fidx=Rs(0)
    End If
    
    
    Rs.Close



    if fix_fidx= 0 then
        Response.Write "<script>"
        Response.Write "location.replace('TNG1_B_suju_cal_fix.asp?" & _
            "cidx=" & rsjcidx & _
            "&sjidx=" & rsjidx & _
            "&sjb_idx=" & rsjb_idx & _

            "&tw=" & rtw & _
            "&th=" & rth & _
            "&ow=" & row & _
            "&oh=" & roh & _
            "&fl=" & rfl & _

            "&sjb_type_no=" & rsjb_type_no & _
            "&sjsidx=" & rsjsidx & _
             "&coat=" & Request("coat") & _
            "&fkidx=" & rfkidx & "');"
        Response.Write "</script>"
        ' Response.End
    end if



if rfkidx<>""  then  
    if rqtyidx > 0 Then     '재질
        sql="update tk_framek set qtyidx='"&rqtyidx&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if rquan > 0 Then     '수량
        sql="update tk_framek set quan='"&rquan&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if rpidx > 0 Then     '페인트
        sql="update tk_framek set pidx='"&rpidx&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if rdooryn <>""  Then     '도어 유무
        sql="update tk_framek set dooryn='"&rdooryn&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if rdoorglass_t <>""  Then     '도어유리
        sql="update tk_framek set doorglass_t='"&rdoorglass_t&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        ' response.write (SQL)&"<br>"
        ' response.end
        Dbcon.Execute (SQL)  
        
    end if
    if rfixglass_t <>""  Then     '픽스유리
        sql="update tk_framek set fixglass_t='"&rfixglass_t&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
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

    total_tw = 0
    total_framename = ""
    total_mheight = 0   ' 초기화
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

    ' 👉 가장 큰 세로값 찾기
    If IsNumeric(lth) Then
        If lth > total_mheight Then
            total_mheight = lth
        End If
    End If

    If total_framename = "" Then
        total_framename = lsjb_type_name & "|" & lsjb_barlist
    Else
        total_framename = total_framename & "+" & lsjb_type_name & "|" & lsjb_barlist
    End If

    Rs.MoveNext
    Loop
    End If
    Rs.Close
           
    sql="update tng_sjaSub set mwidth='"&total_tw&"' , mheight='"&total_mheight&"' , framename='"&total_framename&"'  "
    SQL=SQL&" Where sjsidx='"&rsjsidx&"' " 
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)


    '==========일반절곡 단가 구하기
    if sjb_type_no=13 then




    end if
    '==========일반절곡 단가 구하기 끝
    '강제 오픈치수 입력끝

    'Response.Write "수동입력 row_m: " & row_m & "<br>"
    '=========================================
    '바의 실제 길이 계산 시작
    if  rqtyidx > 0  then  'and  rtw > 0 and rth > 0

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
        SQL = " select A.opa,A.opb,A.opc,A.opd,B.sjb_type_no ,A.greem_fix_type,a.greem_o_type   "
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
            zgreem_o_type = Rs(6)

            '========================================================
            ' 수동 입력 op_tw → tw 역산 (정방향 아래에 위치)
            '========================================================
            If Not IsNull(Request("op_tw")) And Trim(Request("op_tw")) <> "" Then

                op_tw = CLng(Request("op_tw"))
                box = 0
                tw = 0

                Select Case zsjb_type_no
                    Case 1,2,3,4  ' 알자
                        Select Case opa
                            Case "a1","a3","a7"
                                box = (op_tw*2) + junggan
                            Case "a2"
                                box = (op_tw*2) + (junggan*2)
                            Case "a4","a6","a8"
                                box = (op_tw*2) + (junggan*2) + 20
                            Case "a5"
                                box = (op_tw*2) + junggan + 25
                        End Select

                    Case 5  ' 슬림자동
                        Select Case opb
                            Case "b1","b3","b7"
                                box = (op_tw*2) + junggan
                            Case "b2"
                                box = (op_tw*2) + (junggan*2)
                            Case "b5"
                                box = (op_tw*2) + junggan + 25
                            Case "b4","b6","b8"
                                box = (op_tw*2) + (junggan*2) + 20
                        End Select

                    Case 8,9,15  ' 단자/삼중단자
                        Select Case opc
                            Case "c1","c3","c5","c7"
                                box = (op_tw*2) + junggan + 25
                            Case "c2","c4","c6","c8"
                                box = (op_tw*2) + (junggan*2) + 20
                        End Select

                    Case 10  ' 이중슬라이딩
                        Select Case opd
                            Case "d1","d5"
                                box = (op_tw*1.5) + junggan + 27.5
                            Case "d2","d4","d6","d8"
                                box = ((op_tw + (junggan*2) - 30) * 3) / 2
                            Case "d3","d7"
                                box = 0
                        End Select
                End Select

                ' 최종 tw 역산
                tw = box + serobar_y

                ' DB 업데이트
                sql = "UPDATE tk_framek SET tw='" & tw & "', ow='" & op_tw & "' WHERE fkidx='" & rfkidx & "'"
                Dbcon.Execute(sql)

                'Response.Write "수동 op_tw=" & op_tw & " → tw=" & tw & "<br>"
            End If
            '========================================================

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
                        if  opt_habar1 <> 0  Then '언발란스 양개의 경우 각각의 하바를 입력. 
                            opt_habar2 = box - junggan - junggan - opt - opt_habar1
                        Else
                            opt_habar = (box - junggan - junggan - opt) / 2
                        End If
                    Case "a4", "a6", "a8"
                        If row_m > 0 Then
                            opt = row_m  ' 수동 입력을 opt로 대체
                        else
                            opt = (box - 20 - junggan - junggan) / 2
                        end if
                        if  opt_habar1 <> 0  Then '언발란스 양개의 경우 각각의 하바를 입력. 
                            opt_habar2 = box - junggan - junggan - opt - opt_habar1
                        Else
                            opt_habar = (box - junggan - junggan - opt) / 2
                        End If
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
                        if  opt_habar1 <> 0  Then '언발란스 양개의 경우 각각의 하바를 입력. 
                            opt_habar2 = box - junggan - junggan - opt - opt_habar1
                        Else
                            opt_habar = (box - junggan - junggan - opt) / 2
                        End If
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
                        if  opt_habar1 <> 0  Then '언발란스 양개의 경우 각각의 하바를 입력. 
                            opt_habar2 = box - junggan - junggan - opt - opt_habar1
                        Else
                            opt_habar = (box - junggan - junggan - opt) / 2
                        End If
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
                        if  opt_habar1 <> 0  Then '언발란스 양개의 경우 각각의 하바를 입력. 
                            opt_habar2 = box - junggan - junggan - opt - opt_habar1
                        Else
                            opt_habar = (box - junggan - junggan - opt) / 2
                        End If
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
                        if  opt_habar1 <> 0  Then '언발란스 양개의 경우 각각의 하바를 입력. 
                            opt_habar2 = box - junggan - junggan - opt - opt_habar1
                        Else
                            opt_habar = (box - junggan - junggan - opt) / 2
                        End If
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

        ' opt_habar 반올림 처리
        If opt_habar <> 0 Then
            If opt_habar = Int(opt_habar) Then
                opt_habar = opt_habar
            Else
                opt_habar = Int(opt_habar) + 1
            End If
        End If

        ' opt_habar2 반올림 처리
        If opt_habar2 <> 0 Then
            If opt_habar2 = Int(opt_habar2) Then
                opt_habar2 = opt_habar2
            Else
                opt_habar2 = Int(opt_habar2) + 1
            End If
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

                            '========================================================
                            ' 도어높이 역산 (수동입력 dh_th → th 구하기)
                            '========================================================
                            If Not IsNull(Request("dh_th")) And Trim(Request("dh_th")) <> "" Then

                                roh = CLng(Request("dh_th"))   ' 사용자가 입력한 도어높이
                                th  = 0

                                ' 박스높이, 묻힘값(fl)은 정방향 계산에서 이미 얻은 값 사용
                                ' (qysize = box_ysize, qfl = fl)
                                th = roh + box_ysize + qfl

                                ' DB 업데이트
                                sql = "UPDATE tk_framek SET th='" & th & "', oh='" & roh & "' WHERE fkidx='" & rfkidx & "'"
                                Dbcon.Execute(sql)

                                'Response.Write "수동 roh=" & roh & " → th=" & th & "<br>"
                            End If
                            '========================================================

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
        '=======================================
        '양개자동 언발란스 일때 하바 idx구하기 
        ' 하바(WHICHI_AUTO=8)만 따로 fksidx 최소/최대 구하기
        sql = " SELECT MIN(fksidx) AS minFksidx, MAX(fksidx) AS maxFksidx , MIN(xi) AS min_xi, MAX(xi) AS max_xi " 
        sql=sql&" FROM tk_framekSub WHERE fkidx='" & rfkidx & "' AND WHICHI_AUTO=8 "
        Rs1.open SQL, Dbcon
        'response.write (SQL)&"<br>"
        If Not (Rs1.BOF Or Rs1.EOF) Then
            minFksidx = Rs1("minFksidx")
            maxFksidx = Rs1("maxFksidx")
            min_xi = Rs1("min_xi")
            max_xi = Rs1("max_xi")
        End If
        Rs1.Close

        sql = " SELECT MIN(fksidx) AS minFksidx, MAX(fksidx) AS maxFksidx " 
        sql=sql&" FROM tk_framekSub WHERE fkidx='" & rfkidx & "' AND WHICHI_AUTO=9 "
        Rs1.open SQL, Dbcon
        'response.write (SQL)&"<br>"
        If Not (Rs1.BOF Or Rs1.EOF) Then
            minFksidx_fix_sangbar = Rs1("minFksidx")
            maxFksidx_fix_sangbar = Rs1("maxFksidx")
        End If
        Rs1.Close

        sql = " SELECT MIN(fksidx) AS minFksidx, MAX(fksidx) AS maxFksidx " 
        sql=sql&" FROM tk_framekSub WHERE fkidx='" & rfkidx & "' AND WHICHI_AUTO=24 "
        Rs1.open SQL, Dbcon
        'response.write (SQL)&"<br>"
        If Not (Rs1.BOF Or Rs1.EOF) Then
            minFksidx_542 = Rs1("minFksidx")
            maxFksidx_542 = Rs1("maxFksidx")
        End If
        Rs1.Close
        '=======================================


        sql=" select  a.fksidx , a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.glass_w, a.glass_h, a.gls "
        sql=sql&" ,b.sjb_idx, b.sjb_type_no,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type  "
        sql=sql&" ,b.tw,b.th,b.ow,b.oh,b.fl,b.ow_m "
        sql=sql&" ,c.dwsize1, c.dhsize1, c.dwsize2, c.dhsize2, c.dwsize3, c.dhsize3 "
        sql=sql&" ,c.dwsize4, c.dhsize4, c.dwsize5, c.dhsize5, c.gwsize1, c.ghsize1 "
        sql=sql&" ,c.gwsize2, c.ghsize2, c.gwsize3, c.ghsize3, c.gwsize4, c.ghsize4 "
        sql=sql&" ,c.gwsize5, c.ghsize5, c.gwsize6, c.ghsize6 "
        sql=sql&" , d.xsize, d.ysize " 
        sql=sql&" ,e.opa,e.opb,e.opc,e.opd "
        sql=sql&" ,f.glassselect, g.glassselect ,a.sunstatus , a.busoktype , a.xi "
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" join tk_frame e on  b.fidx = e.fidx "
        SQL = SQL & " JOIN tng_whichitype f ON a.WHICHI_FIX = f.WHICHI_FIX "
        SQL = SQL & " JOIN tng_whichitype g ON a.WHICHI_AUTO = g.WHICHI_AUTO"
        sql=sql&" Where a.fkidx='"&rfkidx&"' "
        'response.write (SQL)&"수동프레임 조건분기_fidx 가 존재하지 않음. <br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        Do while not Rs.EOF

        alength = 0
        blength = 0


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
            zbusoktype = rs(50) ' zbusoktype = 1 이면 로비폰 등에서 가공된 유리치수. 재계산 하면 안됨. 
            zxi= rs(51) ' 언발란스 하바의 비교를 위해. min_xi  max_xi 
            
            ' 일반절곡 단가 구하기 시작
            if zsjb_type_no=13 then

                response.write"<script>location.replace('TNG1_B_suju_cal_quick_st.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"

            end if
            ' 일반절곡 단가 구하기 끝
            '수동에 길이 업데이트 시작 
            if zbusoktype <> 1 then

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
                                    alength = sudong_garo / 2  '수동도어유리1 =13 (도면 추출용으로 도어유리 가로 alength)
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
                                    alength = sudong_garo / 2 '수동도어유리1 =13 (도면 추출용으로 도어유리 가로 alength)
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

                        Case 2  '박스커버
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

                            ' 언발란스 양개의 경우
                            If opt_habar1 > 0 And opt_habar2 > 0 Then
                                ' 언발란스 양개일 경우 fksidx 기준 분기
                                If zfksidx = minFksidx Then
                                    blength = opt_habar1   ' 첫 번째 하바
                                ElseIf zfksidx = maxFksidx Then
                                    blength = opt_habar2   ' 두 번째 하바
                                End If

                                'Response.Write "1zWHICHI_AUTO: " & zWHICHI_AUTO & "<br>"
                                'Response.Write "1minFksidx: " & minFksidx & "<br>"
                                'Response.Write "1maxFksidx: " & maxFksidx & "<br>"
                                'Response.Write "1blength: " & blength & "<br>"
                            Else
                                ' 편개 또는 단일 하바
                                blength = opt_habar
                            End If

                        Case 25  ' T형_자동홈바
                            jgan = door_high + zfl
                            blength = jgan

                        Case 30  ' 슬림알자 박스 오사이
                            
                            blength = zow-1

                    End Select
                    '자동에 길이 업데이트 끝

                    '==================== 자동도어치수 , 픽스유리 계산 시작 , 상부픽스 추가계산 ====================
                    response.write "rsjb_type_no="&rsjb_type_no &"<br>"
                    '픽스 상부 오사이 추가 구문.
                    'rSJB_TYPE_NO 1,3 알자,단알자,슬림자동문은 상부남마 오사이가 없으므로 sunstatus = 0, 1
                    'rSJB_TYPE_NO 2.4 복층알자,삼중단알자는 상부남마 오사이가 있음 sunstatus = 0, 1 ,2
                    'rSJB_TYPE_NO 나머진 sunstatus = 0
                    'sunstatus=1 은 픽스하부유리 위에 상부픽스 
                    'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 zgreem_o_type 6
                    'sunstatus=3 은 하부픽스위에 상부남마 에 (외도어 계열) zgreem_o_type 1,2,3 
                    'sunstatus=4 은 양개 중앙에
                    'sunstatus=5 은 t형_자동홈바
                    'sunstatus=6 은 박스커버
                    'sunstatus=7 은 마구리
                    'sunstatus=8 은 민자,자동 홈마개 whichi_auto = 26 자동홈마개 27=민자홈마개
                    'Response.Write "zWHICHI_AUTO: " & zWHICHI_AUTO & "<br>"
                    select case zsunstatus

                        Case 1  ' 하바 위에 상부픽스 절단    
                            If opt_habar1 > 0 And opt_habar2 > 0 Then
                                ' fksidx 기준 분기 (첫 번째 / 두 번째 하바 구분)
                                If zxi = min_xi Then
                                    blength = opt_habar1
                                ElseIf zxi = max_xi Then
                                    blength = opt_habar2
                                End If
                                'If zfksidx = minFksidx_542 Then
                                '    blength = opt_habar1
                                'ElseIf zfksidx = maxFksidx_542 Then
                                '    blength = opt_habar2
                                'End If
                                'If zfksidx = minFksidx_542+1 Then
                                '    blength = opt_habar1
                                'ElseIf zfksidx = maxFksidx_542-1 Then
                                '    blength = opt_habar2
                                'End If
                                'Response.Write "opt_habar1: " & opt_habar1 & "<br>"
                                'Response.Write "opt_habar2: " & opt_habar2 & "<br>"
                                'Response.Write "1zWHICHI_AUTO: " & zWHICHI_AUTO & "<br>"
                                'Response.Write "zfksidx: " & zfksidx & "<br>"
                                'Response.Write "1minFksidx: " & minFksidx & "<br>"
                                'Response.Write "1maxFksidx: " & maxFksidx & "<br>"
                                'Response.Write "minFksidx_fix_sangbar: " & minFksidx_fix_sangbar & "<br>"
                                'Response.Write "maxFksidx_fix_sangbar: " & maxFksidx_fix_sangbar & "<br>"
                                'Response.Write "minFksidx_542: " & minFksidx_542 & "<br>"
                                'Response.Write "maxFksidx_542: " & maxFksidx_542 & "<br>"
                                'Response.Write "1blength: " & blength & "<br>"
                            Else
                                blength = opt_habar
                            End If
                        
                        case 2 '도어위에 상부남마 에 , 그리고 양개 좌우에
                            If zgreem_o_type = 2 or zgreem_o_type = 5 Then
                                blength = box    ' 박스 위에 상부픽스 절단
                            elseif zgreem_o_type = 3 Then
                                blength = zow    ' 도어 위에 상부남마 
                            elseif zgreem_o_type = 6 Then ' 하바 위에 상부픽스 절단
                                If opt_habar1 > 0 And opt_habar2 > 0 Then
                                    If zxi = min_xi Then
                                        blength = opt_habar1
                                    ElseIf zxi = max_xi Then
                                        blength = opt_habar2
                                    End If
                                Else
                                    blength = opt_habar
                                End If
                            end if
                        
                        'Response.Write "zsunstatus: " & zsunstatus & "<br>"
                        'Response.Write "zgreem_o_type: " & zgreem_o_type & "<br>"
                        'Response.Write "zWHICHI_AUTO: " & zWHICHI_AUTO & "<br>"
                        'Response.Write "opt_habar: " & opt_habar & "<br>"
                        'Response.Write "opt_habar1: " & opt_habar1 & "<br>"
                        'Response.Write "opt_habar2: " & opt_habar2 & "<br>"
                        'Response.Write "zfksidx: " & zfksidx & "<br>"
                        'Response.Write "minFksidx_fix_sangbar: " & minFksidx_fix_sangbar & "<br>"
                        'Response.Write "maxFksidx_fix_sangbar: " & maxFksidx_fix_sangbar & "<br>"
                        'Response.Write "blength: " & blength & "<br>"

                        case 3
                            blength = opt_habar    ' 하부픽스위에 상부남마 
                        
                        case 4
                            blength = zow    ' 하바 위에 상부픽스 절단

                        case 8
                            hommagae = zth - garonamma_ysize - box_yysize - door_high - zfl + 10
                            blength = hommagae    'sunstatus=8 은 민자,자동 홈마개 whichi_auto = 26 자동홈마개 27=민자홈마개
                    end select
                    
                    ' 🔽 추가 조건 ' 오사이 경우!
                    
                    If zWHICHI_AUTO = 24 Then
                        blength = blength - 1
                    End If

                    ' 🔽 추가 조건 ' 이중 뚜껑마감!
                    
                    If zWHICHI_AUTO = 28 Then
                        blength =int((zow+65)-((zow+145)/2)-5)
                    End If
                    'Response.Write "zsunstatus: " & zsunstatus & "<br>"
                    'Response.Write "zgreem_o_type: " & zgreem_o_type & "<br>"
                    'Response.Write "zWHICHI_AUTO: " & zWHICHI_AUTO & "<br>"
                    'Response.Write "zfksidx: " & zfksidx & "<br>"
                    'Response.Write "minFksidx: " & minFksidx & "<br>"
                    'Response.Write "maxFksidx: " & maxFksidx & "<br>"
                    'Response.Write "blength: " & blength & "<br>"

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
                                    If rsjb_type_no >=1 and rsjb_type_no <= 4 Then '픽스하바에 상부오사이 있는경우

                                        glass_w = opt_habar + zgwsize1 '동일
                                        glass_h = door_high - jadonghaba_y + zghsize1 
                                        alength = opt_habar  ' 도면 추출용 길이
                                        blength = door_high - jadonghaba_y - 25  ' 도면 추출용 길이 25는 상부픽스 높이

                                    else

                                        glass_w = opt_habar + zgwsize1
                                        glass_h = door_high - jadonghaba_y + zghsize1
                                        alength = opt_habar  ' 도면 추출용 길이
                                        blength = door_high - jadonghaba_y  ' 도면 추출용 길이

                                    end if

                                Case 16  ' ➤ 상부 픽스 유리 (왼쪽)

                                    If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25

                                        If zgreem_o_type = 2 Then
                                            glass_w = box + zgwsize3
                                            glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                                            alength = box  ' 도면 추출용 길이
                                            blength = (zth - garonamma_ysize - box_yysize - door_high - zfl - 25 - 25) 
                                        End If
                                        If zgreem_o_type = 3 Then
                                            glass_w = zow + zgwsize3
                                            glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                                            alength = zow  ' 도면 추출용 길이
                                            blength = (zth - garonamma_ysize - box_yysize - door_high - zfl - 25 - 25 )
                                        End If

                                    else

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

                                    end if 
                                    
                                Case 17  ' ➤ 상부 픽스 유리 (중앙 또는 오른쪽)

                                    If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25

                                        If zgreem_o_type = 3 Then
                                            glass_w = opt_habar + zgwsize3
                                            glass_h = sang_jgan + zghsize3
                                            alength = opt_habar  ' 도면 추출용 길이
                                            blength = sang_jgan - 25 - 25
                                        End If

                                    else

                                        If zgreem_o_type = 3 Then
                                            glass_w = opt_habar + zgwsize3
                                            glass_h = sang_jgan + zghsize3
                                            alength = opt_habar  ' 도면 추출용 길이
                                            blength = sang_jgan
                                        End If

                                    end if
                                    

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

                                Case 14 ' ➤ 하부 픽스 유리 1

                                    If rsjb_type_no >=1 and rsjb_type_no <= 4 Then '픽스하바에 상부오사이 있는경우

                                        If opt_habar1 > 0 And opt_habar2 > 0 Then
                                            glass_w = opt_habar1 + zgwsize1
                                            alength = opt_habar1
                                        Else
                                            ' 단일 하바
                                            glass_w = opt_habar + zgwsize1
                                            alength = opt_habar
                                        End If

                                        glass_h = door_high - jadonghaba_y + zghsize1
                                        blength = door_high - jadonghaba_y - 25
                                    
                                    else

                                        If opt_habar1 > 0 And opt_habar2 > 0 Then
                                            glass_w = opt_habar1 + zgwsize1
                                            alength = opt_habar1
                                        Else
                                            ' 단일 하바
                                            glass_w = opt_habar + zgwsize1
                                            alength = opt_habar
                                        End If

                                        glass_h = door_high - jadonghaba_y + zghsize1
                                        blength = door_high - jadonghaba_y

                                    End If
                                
                                Case  15  ' ➤ 하부 픽스 유리 2

                                    If rsjb_type_no >=1 and rsjb_type_no <= 4 Then '픽스하바에 상부오사이 있는경우

                                        If opt_habar1 > 0 And opt_habar2 > 0 Then
                                            glass_w = opt_habar2  + zgwsize1
                                            alength = opt_habar2 
                                        Else
                                            ' 단일 하바
                                            glass_w = opt_habar + zgwsize1
                                            alength = opt_habar
                                        End If

                                        glass_h = door_high - jadonghaba_y + zghsize1
                                        blength = door_high - jadonghaba_y - 25
                                    
                                    else

                                        If opt_habar1 > 0 And opt_habar2 > 0 Then
                                            glass_w = opt_habar2  + zgwsize1
                                            alength = opt_habar2 
                                        Else
                                            ' 단일 하바
                                            glass_w = opt_habar + zgwsize1
                                            alength = opt_habar
                                        End If

                                        glass_h = door_high - jadonghaba_y + zghsize1
                                        blength = door_high - jadonghaba_y

                                    End If

                                Case 16  ' ➤ 상부 픽스 유리 (opt_habar 기준) 1
                                    If zgreem_o_type = 5 Then

                                        If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25
                                            
                                            glass_w = box + zgwsize3
                                            glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                                            alength = box  ' 도면 추출용 길이
                                            blength = (zth - garonamma_ysize - box_yysize - door_high - zfl-25-25)

                                        else

                                            glass_w = box + zgwsize3
                                            glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                                            alength = box  ' 도면 추출용 길이
                                            blength = (zth - garonamma_ysize - box_yysize - door_high - zfl)

                                        end if

                                    elseIf zgreem_o_type = 6 Then

                                        If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25

                                            If opt_habar1 > 0 And opt_habar2 > 0 Then
                                                ' 첫 번째 상부 픽스 (opt_habar1)
                                                glass_w = opt_habar1 + zgwsize3
                                                alength = opt_habar1
                                            Else
                                                ' 단일 하바
                                                glass_w = opt_habar + zgwsize3
                                                alength = opt_habar
                                            End If

                                            glass_h = sang_jgan + zghsize3
                                            blength = sang_jgan - 25 - 25

                                        else
                                            If opt_habar1 > 0 And opt_habar2 > 0 Then
                                                ' 첫 번째 상부 픽스 (opt_habar1)
                                                glass_w = opt_habar1 + zgwsize3
                                                alength = opt_habar1
                                            Else
                                                ' 단일 하바
                                                glass_w = opt_habar + zgwsize3
                                                alength = opt_habar
                                            End If
                                            
                                            glass_h = sang_jgan + zghsize3
                                            blength = sang_jgan

                                        End If
                                    End If
                                    
                                Case 18  ' ➤ 상부 픽스 유리 (opt_habar 기준) 3
                                    If zgreem_o_type = 5 Then

                                        If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25
                                            
                                            glass_w = box + zgwsize3
                                            glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                                            alength = box  ' 도면 추출용 길이
                                            blength = (zth - garonamma_ysize - box_yysize - door_high - zfl-25-25)

                                        else

                                            glass_w = box + zgwsize3
                                            glass_h = (zth - garonamma_ysize - box_yysize - door_high - zfl) + zghsize3
                                            alength = box  ' 도면 추출용 길이
                                            blength = (zth - garonamma_ysize - box_yysize - door_high - zfl)

                                        end if

                                    elseIf zgreem_o_type = 6 Then

                                        If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25

                                            If opt_habar1 > 0 And opt_habar2 > 0 Then
                                                ' 첫 번째 상부 픽스 (opt_habar1)
                                                glass_w = opt_habar2 + zgwsize3
                                                alength = opt_habar2
                                            Else
                                                ' 단일 하바
                                                glass_w = opt_habar + zgwsize3
                                                alength = opt_habar
                                            End If

                                            glass_h = sang_jgan + zghsize3
                                            blength = sang_jgan - 25 - 25

                                        else

                                            If opt_habar1 > 0 And opt_habar2 > 0 Then
                                                ' 첫 번째 상부 픽스 (opt_habar1)
                                                glass_w = opt_habar2 + zgwsize3
                                                alength = opt_habar2
                                            Else
                                                ' 단일 하바
                                                glass_w = opt_habar + zgwsize3
                                                alength = opt_habar
                                            End If
                                            
                                            glass_h = sang_jgan + zghsize3
                                            blength = sang_jgan

                                        End If
                                    End If
                                    
                                                      
                                Case 17      ' ➤ 상부 픽스 유리 중앙

                                    If rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then '복층과 삼중알자는 상부픽스에 오사이 있음 상 하부로. 25+25

                                        glass_w = zow + zgwsize3
                                        glass_h = sang_jgan + zghsize3
                                        alength = zow  ' 도면 추출용 길이
                                        blength = sang_jgan - 25 -25 

                                    else

                                        glass_w = zow + zgwsize3
                                        glass_h = sang_jgan + zghsize3
                                        alength = zow  ' 도면 추출용 길이
                                        blength = sang_jgan

                                    End If

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
                        'response.end
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
'=========================================
' 도어계산 시작

'도어옵션 자동으로 선택
if rsjb_type_no > 0  and rqtyidx > 0   and  rtw > 0 and rth > 0  then

        SQL = " SELECT sjb_type_no "
        SQL = SQL & " FROM tk_framek "
        SQL = SQL & " Where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            door_sjb_type_no=Rs(0)
        End If
        Rs.Close

        
        SQL="Update tk_framek "  
        SQL=SQL&" Set doorchoice='"& rdoorchoice &"'  "
        SQL=SQL&" Where fkidx in ("&rfkidx&") "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

        'SQL="Update tk_framekSub  "  
        'SQL=SQL&" Set door_price='"& door_price &"' , doorsizechuga_price='"& doorsizechuga_price &"' "
        'SQL=SQL&" , goname='" & goname & "', barNAME='" & barNAME & "' "
        'SQL=SQL&" , doorglass_w='"& kdoorglass_w &"' , doorglass_h='"& kdoorglass_h &"' , DOORTYPE='"& rDOORTYPE &"' "
        'SQL=SQL&" Where fksidx in ("&rfksidx&") "
        'response.write (SQL)&"<br>"
        'Dbcon.Execute (SQL)


'Response.Write "rsjb_type_no: " & rsjb_type_no & "<br>"
'Response.Write "rdoorchoice: " & rdoorchoice & "<br>"
'Response.Write "door_price: " & door_price & "<br>"
'Response.Write "doorsizechuga_price: " & doorsizechuga_price & "<br>"




        SQL = "SELECT sidx, goidx, goname, baridx, barNAME, smidx, swdate, semidx, sewdate "
        SQL = SQL & ",standprice, barlistprice, barNAME1, barNAME2, barNAME3, barNAME4, barNAME5 "
        SQL = SQL & ",tongdojang, jadong, culmolbar,danyul,g_w,g_h,price_level "
        SQL = SQL & ",junggankey ,dademuhom  "
        SQL = SQL & " FROM tk_stand "
        If door_sjb_type_no = ""  Then  
        SQL=SQL&"  WHERE sidx <>0  "
        End If 
        If door_sjb_type_no = 1  Then  ' 알자 sidx
        SQL=SQL&" WHERE sidx=31   "
        End If 
        If door_sjb_type_no = 2  Then  ' 복층알자
        SQL=SQL&" WHERE sidx=32  "
        End If 
        If door_sjb_type_no = 3 or  door_sjb_type_no = 4 or door_sjb_type_no = 8 or door_sjb_type_no = 9 or door_sjb_type_no = 10 or door_sjb_type_no = 15   Then  ' 단열알자3 삼중알자4 단자8 삼중단자9 이중슬라이딩10 포켓15
        SQL=SQL&" WHERE sidx=106  " 
        End If 
        If door_sjb_type_no = 5  Then  ' 인테
        SQL=SQL&" WHERE sidx=33   " 
        End If 
        If door_sjb_type_no = 6  Then  ' 통도장 수동 일반
        SQL=SQL&" WHERE sidx=303 " 
        End If 
        If door_sjb_type_no = 7  Then  ' 통도장 수동 단열
        SQL=SQL&" WHERE sidx=322 " 
        End If 
        If door_sjb_type_no = 11  Then  ' 수동 단열
        SQL=SQL&" WHERE sidx=376  " 
        End If 
        If door_sjb_type_no = 12 Then  ' 수동 단열
        SQL=SQL&" WHERE sidx=381  " 
        End If 
        'Response.Write SQL & "<br>"
            Rs1.Open SQL, Dbcon
            If Not (Rs1.BOF Or Rs1.EOF) Then

                sidx         = Rs1(0)
                goidx        = Rs1(1)
                goname       = Rs1(2)
                baridx       = Rs1(3)
                barNAME      = Rs1(4)
                smidx        = Rs1(5)
                swdate       = Rs1(6)
                semidx       = Rs1(7)
                sewdate      = Rs1(8)
                standprice   = Rs1(9)
                barlistprice = Rs1(10)
                barNAME1     = Rs1(11)
                barNAME2     = Rs1(12)
                barNAME3     = Rs1(13)
                barNAME4     = Rs1(14)
                barNAME5     = Rs1(15)
                tongdojang   = Rs1(16)
                jadong       = Rs1(17)
                culmolbar    = Rs1(18)
                danyul       = Rs1(19)
                g_w          = Rs1(20)
                g_h          = Rs1(21)
                price_level  = Rs1(22)
                junggankey   = Rs1(23)
                dademuhom    = Rs1(24)
'Response.Write "door_sjb_type_no: " & door_sjb_type_no & "<br>"
'Response.Write "rqtyidx: " & rqtyidx & "<br>" 
'Response.Write "g_w: " & g_w & "<br>"
'Response.Write "g_h: " & g_h & "<br>"

        End if
        Rs1.close      

                if junggankey = 1 then
                    junggankey_price = 25000
                end if
                if dademuhom = "1" then
                    dademuhom_price = 5000
                end if
                select case door_sjb_type_no
                    case 6,7,11,12
                        tagong_price = 3000
                    case else
                        tagong_price = 0
                end select

                If (rqtyidx =1 or  rqtyidx =3) and (rpidx<>0) Then  '헤어도장(  rqtyidx = 1 ) or ( 갈바도장 rqtyidx = 3  )  
                    dojang_price=55000
                elseif ( rqtyidx =15 or  rqtyidx =30)  Then '알미늄블랙 5 실버15 기타도장30
                    if door_sjb_type_no = 7  then
                        dojang_price=30000
                    elseif  door_sjb_type_no = 6  then
                        dojang_price=20000  
                    end if
                else
                    dojang_price=0
                End If 
                
                cnt = 0   ' 루프 시작 전에 초기화
                SQL = "select door_w, door_h, fksidx"
                SQL = SQL & " from tk_framekSub "
                SQL = SQL & " where fkidx='" & rfkidx & "' and door_w<>0 "
                Rs2.open SQL, Dbcon
                If Not (Rs2.bof or Rs2.eof) Then 
                Do While Not Rs2.EOF
                'response.write (SQL)&"<br>"
                    wdoor_w = Rs2(0)
                    wdoor_h = Rs2(1)
                    i_fksidx = Rs2(2) 'fksidx
                    cnt = cnt + 1   ' 루프 돌 때마다 +1  DOORTYPE=1은 좌 2는 우 인데. 루프 2번도니까 좌,우 입력하기

                ' 도어 사이즈 추가 계산
                Select Case cdlevel
                    Case 6
                        base_start_w = 1010  ' 폭 시작점
                        base_start_h = 2415  ' 높이 시작점
                    Case Else
                        base_start_w = 910   ' 기본 폭 시작점
                        base_start_h = 2115  ' 기본 높이 시작점
                End Select
                ' size_price_w 계산 (50mm 단위 등급)
                If wdoor_w > base_start_w Then
                    size_price_w = Int((wdoor_w - base_start_w + 49) / 50)
                Else
                    size_price_w = 0
                End If
                ' size_price_h 계산 (50mm 단위 등급)
                If wdoor_h > base_start_h Then
                    size_price_h = Int((wdoor_h - base_start_h + 49) / 50)
                Else
                    size_price_h = 0
                End If

                'Response.Write "size_price_w : " & size_price_w & "<br>"
                '스텐재질별 추가단가
                Select Case rqtyidx
                    Case 3, 7, 12, 13, 14, 17
                        price_level = -10000
                    Case 8, 9, 10, 11, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 31, 32, 33, 34, 35, 36
                        price_level = -20000
                    Case Else
                        price_level = 0
                End Select

                ' 도어 사이즈 추가 가격 계산
                if (rqtyidx >= 1 and rqtyidx <= 7) or (rqtyidx >= 12 and rqtyidx <= 15) or rqtyidx = 30 or rqtyidx = 37 then
                    doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                else 
                    doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                end if
                
                ' 도어 기본 가격 계산
                SQL = "select distinct b.qtyidx ,b.pidx ,e.doorbase_price "
                SQL = SQL & " from tk_framekSub a"
                SQL = SQL & "  join tk_framek b on a.fkidx = b.fkidx"
                'SQL = SQL & "  LEFT OUTER JOIN tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO"
                SQL = SQL & " LEFT OUTER JOIN tk_qty e ON b.qtyidx = e.qtyidx "
                SQL = SQL & " LEFT OUTER JOIN tk_qtyco d ON e.QTYNo = d.QTYNo "
                SQL = SQL & " LEFT OUTER JOIN tk_paint f ON f.pidx = b.pidx "
                SQL = SQL & " Where a.fkidx='"&rfkidx&"'  "
                SQL = SQL & " AND a.gls in (1,2) "
                'Response.Write SQL & "<br>"  
                Rs3.open SQL, Dbcon
                If Not (Rs3.bof or Rs3.eof) Then 
                    zqtyidx = Rs3(0)
                    zpidx = Rs3(1)
                    zdoorbase_price = Rs3(2)
                    'Response.Write "doorbase_price : " & zdoorbase_price & "<br>"
                    'response.end
                End if
                Rs3.close

                total_standprice=standprice+junggankey_price+dademuhom_price+tagong_price+dojang_price+doorsizechuga_price+zdoorbase_price+price_level
                
                ' 1=10만(기본), 2=-10000, 3= +10000, 4= +20000, 5= +30000 , 6= 9만에 1000*2400

                Select Case cdlevel
                    Case 1
                        cdlevel_price = 0
                    Case 2
                        IF danyul <> 0 THEN
                            cdlevel_price = 0
                        ELSE
                            cdlevel_price = -10000
                        END IF
                    Case 3
                        cdlevel_price = 10000
                    Case 4
                        cdlevel_price = 20000
                    Case 5
                        cdlevel_price = 30000
                    Case 6
                        IF danyul <> 0 THEN
                            cdlevel_price = 0
                        ELSE
                            cdlevel_price = -10000
                        END IF
                        cdlevel_price = -10000
                    Case Else
                        cdlevel_price = 0
                End Select

                door_price=total_standprice + cdlevel_price

                'Response.Write "i_fksidx : " & i_fksidx & "<br>"
                'Response.Write "cdlevel : " & cdlevel & "<br>"
                'Response.Write "cdlevel : " & cdlevel & "<br>"
                'Response.Write "cdlevel_price : " & cdlevel_price & "<br>"
                'Response.Write "wdoor_w : " & wdoor_w & "<br>"
                'Response.Write "wdoor_h : " & wdoor_h & "<br>"
                'Response.Write "barname : " & barname & "<br>"
                'Response.Write "sidx : " & sidx & "<br>"
                'Response.Write "rsidx : " & rsidx & "<br>"
                'Response.Write "standprice : " & standprice & "<br>"
                'Response.Write "junggankey_price : " & junggankey_price & "<br>"
                'Response.Write "dademuhom_price : " & dademuhom_price & "<br>"
                'Response.Write "tagong_price : " & tagong_price & "<br>"
                'Response.Write "dojang_price : " & dojang_price & "<br>"
                'Response.Write "size_price_w : " & size_price_w & "<br>"
                'Response.Write "size_price_h : " & size_price_h & "<br>"
                'Response.Write "doorsizechuga_price : " & doorsizechuga_price & "<br>"
                'Response.Write "total_standprice : " & total_standprice & "<br>"
                
                ' 도어 유리 계산
                if wdoor_w > 0 and wdoor_h > 0 then

                    kdoorglass_w = wdoor_w - g_w
                    kdoorglass_h = wdoor_h - g_h

                if door_sjb_type_no <> "" then

                    Select Case rdooryn  '0=도어나중 1=도어같이 2=도어안함
                        Case 0 '0=도어나중
                            Select Case rdoorchoice '1=도어포함 2=도어별도  3=도어제외
                                Case 1
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,3,4,5 '도어포함 견적
                                            door_price=0
                                            doorsizechuga_price=0
                                        Case Else            '별도 견적
                                            If door_price = 0 Then
                                                door_price = total_standprice + cdlevel_price
                                            End If
                                            If doorsizechuga_price = 0 Then
                                                If (rqtyidx >= 1 And rqtyidx <= 7) Or (rqtyidx >= 12 And rqtyidx <= 15) Or rqtyidx = 30 Or rqtyidx = 37 Then
                                                    doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                                                Else
                                                    doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                                                End If
                                            End If
                                    End Select
                                
                              
                                Case 2 '2=도어별도
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=100000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=200000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            If door_price = 0 Then
                                                door_price = total_standprice + cdlevel_price
                                            End If
                                            If doorsizechuga_price = 0 Then
                                                If (rqtyidx >= 1 And rqtyidx <= 7) Or (rqtyidx >= 12 And rqtyidx <= 15) Or rqtyidx = 30 Or rqtyidx = 37 Then
                                                    doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                                                Else
                                                    doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                                                End If
                                            End If
                                    End Select
                                Case 3 '3=도어제외
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=-80000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=-160000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            door_price = 0
                                            doorsizechuga_price = 0 
                                    End Select
                            End Select

                        Case 1 '1=도어같이
                            Select Case rdoorchoice '1=도어포함 2=도어별도  3=도어제외
                                Case 1
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,3,4,5 '도어포함 견적
                                            door_price=0
                                            doorsizechuga_price=0
                                        Case Else            '별도 견적
                                            If door_price = 0 Then
                                                door_price = total_standprice + cdlevel_price
                                            End If
                                            If doorsizechuga_price = 0 Then
                                                If (rqtyidx >= 1 And rqtyidx <= 7) Or (rqtyidx >= 12 And rqtyidx <= 15) Or rqtyidx = 30 Or rqtyidx = 37 Then
                                                    doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                                                Else
                                                    doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                                                End If
                                            End If
                                    End Select
                                Case 2 '2=도어별도
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=100000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=200000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            If door_price = 0 Then
                                                door_price = total_standprice + cdlevel_price
                                            End If
                                            If doorsizechuga_price = 0 Then
                                                If (rqtyidx >= 1 And rqtyidx <= 7) Or (rqtyidx >= 12 And rqtyidx <= 15) Or rqtyidx = 30 Or rqtyidx = 37 Then
                                                    doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                                                Else
                                                    doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                                                End If
                                            End If
                                    End Select
                                Case 3 '3=도어제외
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=-80000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=-160000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            door_price = 0
                                            doorsizechuga_price = 0 
                                    End Select
                            End Select

                        Case 2 ' 2=도어안함
                             '도어 안함이면 무조건 도어제외'
                             rdoorchoice = 3 '도어 제외로 변경'
                            Select Case rdoorchoice
                                Case 1
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=-80000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=-160000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            door_price = 0
                                            doorsizechuga_price = 0 
                                    End Select
                                Case 2
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=-80000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=-160000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            door_price = 0
                                            doorsizechuga_price = 0 
                                    End Select
                                Case 3
                                    Select Case CInt(door_sjb_type_no) '도어포함견적이냐 별도견적이냐 구분
                                        Case 1,2,5 '알자, 복층알자 ,일반 100바  AL자동
                                            door_price=-80000
                                            doorsizechuga_price=0
                                        Case 3,4 '단열알자 삼중알자 
                                            door_price=-160000
                                            doorsizechuga_price=0   
                                        Case Else            '별도 견적
                                            door_price = 0
                                            doorsizechuga_price = 0 
                                    End Select
                            End Select
                    End Select

                end if

                ' SQL="Update tk_framekSub  "
                ' SQL=SQL&" Set  doorglass_w='"& kdoorglass_w &"' , doorglass_h='"& kdoorglass_h &"' , DOORTYPE='"& cnt &"' "
                ' SQL=SQL&" ,door_price='"& door_price &"' , doorsizechuga_price='"& doorsizechuga_price &"' "
                ' SQL=SQL&" ,goname='" & goname & "', barNAME='" & barNAME & "' "
                ' SQL=SQL&" Where fksidx='"&i_fksidx&"' "
                ' Dbcon.Execute (SQL)
' 업데이트 시 좌도어 우도어 변경 수정
                 SQL="Update tk_framekSub  "
                SQL=SQL&" Set  doorglass_w='"& kdoorglass_w &"' , doorglass_h='"& kdoorglass_h &"' " 
                SQL=SQL&" ,door_price='"& door_price &"' , doorsizechuga_price='"& doorsizechuga_price &"' "
                SQL=SQL&" ,goname='" & goname & "', barNAME='" & barNAME & "' "
                SQL=SQL&" Where fksidx='"&i_fksidx&"' "
                Dbcon.Execute (SQL)

                '---------------------롯트바 업데이트 
                '1. 좌표 찾기 . 같은 xi를 가지고 있는 롯트바를 찾기 
                '2.  4 도면참조 경우 - 롯트바의 너비와 도어의 너비가 다를 경우  
                '3 rDOORTYPE 1 좌도어 2 우도어 . 양개를 추출하여라 좌표상 도어의 너비*2가 롯트바넓이와 동일하면 양개 
                '4.업데이트 하기 (WHICHI_FIX = 4 or  WHICHI_FIX = 22 ) 롯트바 rot_type 1 좌 2 우 3 양개 4 도면참조 

                    SQL = ""
                    SQL = SQL & "SELECT " 
                    SQL = SQL & "  xi, yi, wi, hi , DOORTYPE " 
                    SQL = SQL & "FROM tk_framekSub "
                    SQL = SQL & "Where fksidx in ("&i_fksidx&") "        ' 🔹 롯트바(도면참조) 대상
                    SQL = SQL & "  AND ISNULL(xi, '') <> '' "                       ' 🔹 xi 좌표 존재
                    'response.write (SQL)&"1. 좌표 찾기 <br>"
                    Rs.open SQL, Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                        d_xi = Rs(0)
                        d_yi = Rs(1)
                        d_wi = Rs(2)
                        d_hi = Rs(3) 
                        d_DOORTYPE = Rs(4)  '3 rDOORTYPE 1 좌도어 2 우도어 . 양개를 추출하여라 좌표상 도어의 너비*2가 롯트바넓이와 동일하면 양개 
                        'response.write ("xi : " & d_xi & "<br>")
                        'response.write ("yi : " & d_yi & "<br>")
                        'response.write ("wi : " & d_wi & "<br>")
                        'response.write ("hi : " & hi & "<br>")
                        'response.write ("DOORTYPE : " & d_DOORTYPE & "<br>")
                    end if
                    rs.close

                    SQL = ""
                    SQL = SQL & "SELECT " 
                    SQL = SQL & " fkidx, fksidx,WHICHI_FIX, xi, yi, wi, hi " 
                    SQL = SQL & "FROM tk_framekSub "
                    SQL = SQL & "WHERE xi IN (" & d_xi & ") "    
                    SQL = SQL & "  AND WHICHI_FIX IN (4,22) "   
                    SQL = SQL & "  AND fkidx IN (" & rfkidx & ") "                
                    'response.write (SQL)&"2.롯트바 찾기 4 도면참조 경우 - 롯트바의 너비와 도어의 너비가 다를 경우  <br>"
                    Rs.open SQL, Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                        rot_fkidx = Rs(0)
                        rot_fksidx = Rs(1)
                        rot_WHICHI_FIX = Rs(2)
                        rot_xi = Rs(3)
                        rot_yi = Rs(4)
                        rot_wi = Rs(5)
                        rot_hi = Rs(6)

                        'response.write ("rot_fkidx : " & rot_fkidx & "<br>")
                        'response.write ("rot_fksidx : " & rot_fksidx & "<br>")
                        'response.write ("rot_WHICHI_FIX : " & rot_WHICHI_FIX & "<br>")
                        'response.write ("rot_xi : " & rot_xi & "<br>")
                        'response.write ("rot_yi : " & rot_yi & "<br>")
                        'response.write ("rot_wi : " & rot_wi & "<br>")
                        'response.write ("rot_hi : " & rot_hi & "<br>")

                        if d_DOORTYPE = 1 then
                            rot_type = 1
                            rot_type_text = "좌도어"
                        elseif d_DOORTYPE = 2 then
                            rot_type = 2
                            rot_type_text = "우도어"
                        end if

                        if rot_wi = d_wi * 2 then
                            rot_type = 3
                            rot_type_text = "양개"
                        end if
                        if rot_wi <> d_wi * 2  and rot_wi > d_wi then
                            rot_type = 4
                            rot_type_text = "도면참조"
                        end if

                    end if
                    rs.close

                    'response.write ("rot_type : " & rot_type_text & "<br>")
                    'response.write ("rot_fksidx : " & rot_fksidx & "<br>")
                    if rot_fksidx<>"" then
                        SQL="Update tk_framekSub  "  
                        SQL=SQL&" Set rot_type='"& rot_type &"'  "
                        SQL=SQL&" Where fksidx in ("&rot_fksidx&") "
                        Dbcon.Execute (SQL)
                    end if
                '------------------------------------

                end if

                Rs2.MoveNext
                Loop
                End if
                Rs2.close
'response.end
end if                   

'response.end

' 도어계산 끝
'=========================================
'response.write "coat: " & coat & "<br>"



    ' sjb_type_no 변경시 단가가 변경 되는 오류 막기
    if not (CLng(rsjb_type_no)= CLng(zsjb_type_no)) Then

        response.write"<script>location.replace('tng1_b_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"        
        response.end
    End if

'=========================================
' al평당단가계산 시작
 'or ( request("meter_price") = "" )
if ( (rsjb_type_no >= 1 and rsjb_type_no <= 5)  and rqtyidx > 0   and  rtw > 0 and rth > 0 )  then
 '=================제품 가격 입력 시작
            SQL = "SELECT fidx,tw,th,greem_o_type ,quan from tk_framek where fkidx = '" & rfkidx & "' "
            'Response.write (SQL)&"<br>"
            'response.end
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then
                yfidx=rs1(0)
                ytw=rs1(1)
                yth=rs1(2)
                ygreem_o_type=rs1(3) '1,2,3 편개 4,5,6 양개
                yquan=rs1(4) '수량

                if yfidx >= 25 then
                    yfidx =  yfidx - 24   '(24개의 방향때문에 좌에서 우로 바뀌면서 생긴..)
                end if

            End If
            Rs1.Close '2

           

            SQL = "SELECT price_bk, price_etl FROM tng_unitprice_al "
            SQL = SQL & "WHERE SJB_IDX = '" & rsjb_idx & "' "
            SQL = SQL & "AND QTYIDX = '" & rqtyidx & "' "
            SQL = SQL & "AND fidx = '" & yfidx & "' "
            'SQL = SQL & "AND qtyco_idx = '" & rqtyco_idx & "' "
            'Response.write (SQL)&"<br>"
            'response.end
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 

                price_bk  = Rs1(0)
                price_etl = Rs1(1)
                    
                    If price_bk > 0 Then
                        sjsprice = price_bk
                    Else
                        if coat >=2 then
                            if ygreem_o_type = 1 or ygreem_o_type = 2 or ygreem_o_type = 3 then '1,2,3 편개 
                                sjsprice = price_etl+50000
                            else '4,5,6 양개
                                sjsprice = price_etl+100000
                            end if
                        else
                            sjsprice = price_etl
                        end if
                    End If
                

                'Response.Write "price_bk: " & price_bk & "<br>"
                'Response.Write "price_etl : " & price_etl & "<br>"
                'Response.Write "sjsprice : " & sjsprice & "<br>"
                'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"
            End If
            Rs1.Close '2
            
                py_size1 = ytw * yth / 90000 ' 면적 계산 (기본 면적: 90,000 기준)
                py_size2 = 0  ' 초기화
                py_chuga = 0
                Select Case ygreem_o_type ' 편개 / 양개 구분

                    Case 1, 2, 3  ' ☑ 편개 그룹  기준 초과 계산 (70을 초과한 면적만 추가)
                        If py_size1 > 70 Then
                            py_size2 = py_size1 - 70
                        Else
                            py_size2 = 0
                        End If
                    Case 4, 5, 6  ' ☑ 양개 그룹  기준 초과 계산 (112를 초과한 면적만 추가)
                        If py_size1 > 112 Then
                            py_size2 = py_size1 - 112
                        Else
                            py_size2 = 0
                        End If
                End Select
                
                py_size2 = -Int(-py_size2)  ' 소수점 있으면 무조건 올림

                If rsjb_idx = 3 Or rsjb_idx = 4 Then ' ▶ 단열/비단열 구분은 ygreem_o_type 기준으로 처리
                    py_chuga = py_size2 * 6000 ' 단열일 경우 
                ElseIf rsjb_idx = 1 Or rsjb_idx = 2 Or rsjb_idx = 5 Then
                    py_chuga = py_size2 * 5000 ' 비단열일 경우
                Else
                    py_chuga = 0
                End If

                'Response.Write "ytw: " & ytw & "<br>"
                'Response.Write "yth: " & yth & "<br>"
                'response.Write "py_size1: " & py_size1 & "<br>"
                'Response.Write "py_size2 (초과): " & py_size2 & "<br>"
                'Response.Write "py_chuga (추가비용): " & py_chuga & "<br>"
                'response.end

        
    '~~~~~~~~~~~~~부속자재 업데이트 끝
    'rsjb_type_no = 2 (복층알자) ,4 (삼중알자) 전용 픽스상바, 오사이 추가 금 계산
    if rsjb_type_no =2 or rsjb_type_no =4 then

        SQL="select A.fksidx "
        SQL=SQL&" , A.bfidx, B.pcent "
        SQL=SQL&" , A.blength, A.unitprice, A.sprice, A.whichi_fix, A.whichi_auto "
        SQL=SQL&" , A.door_price, A.doorsizechuga_price "
        SQL=SQL&" From tk_framekSub A "
        SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
        SQL=SQL&" and A.whichi_auto not in (11,20) " '11번 기타 20번 하부레일
        SQL=SQL&" and A.sunstatus  in (2,3,4) "

        'sunstatus=1 은 픽스하부유리 위에 상부픽스 
        'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 
        'sunstatus=3 은 하부픽스위에 상부남마 에
        'sunstatus=4 은 양개 중앙에
        'sunstatus=5 은 t형_자동홈바
        'sunstatus=6 은 박스커버
        'Response.write (SQL)&"<br>"
        'response.end
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        Do while not Rs.EOF

        bfksidx=Rs(0)
        bbfidx=Rs(1)
        bpcent=Rs(2)
        bblength=Rs(3)
        bunitprice=Rs(4)
        bsprice=Rs(5)
        bwhichi_fix=Rs(6)
        bwhichi_auto=Rs(7)
        bdoor_price=Rs(8)
        bdoorsizechuga_price=Rs(9)

            If bwhichi_fix > 0 Then
                SQL1="Select unittype_bfwidx from tng_whichitype where whichi_fix='"&bwhichi_fix&"'" 
            ElseIf bwhichi_auto > 0 Then
                SQL1="Select unittype_bfwidx from tng_whichitype where whichi_auto='"&bwhichi_auto&"'" 
            End If    
                'Response.write (SQL)&"<br>" 
                Rs1.open Sql1,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    unittype_bfwidx=Rs1(0)
                End If
            Rs1.Close
            'Response.Write "rqtyidx : " & rqtyidx & "<br>"   
            SQL = "SELECT TOP 1 B.qtyco_idx , b.unittype_qtyco_idx " 
            SQL = SQL & "FROM tk_qty A "
            SQL = SQL & "JOIN tk_qtyco B ON A.QTYNo = B.QTYNo "
            SQL = SQL & "WHERE A.qtyidx = '" & rqtyidx & "' "
            SQL = SQL & "AND (B.sheet_t = 0 OR B.sheet_h >= " & bblength & ") "
            SQL = SQL & "ORDER BY B.sheet_h ASC "
            'Response.write (SQL)&"<br><br>"
            'response.end
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                qtyco_idx=Rs1(0)
                unittype_qtyco_idx=Rs1(1)
            End If
            Rs1.Close
            'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"    
                original_rqtyidx = rqtyidx  ' rqtyidx가 15=AL/실버 일 경우, 임시로 30=AL/도장 으로 변경
                if rqtyidx = 15 then
                rqtyidx=30
                end if  
                    'SQL="Select price From tng_unitprice_F Where sjb_idx='"&rsjb_idx&"' and qtyidx='"&rqtyidx&"' and bfwidx='"&bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                    SQL="Select price From tng_unitprice_t Where sjb_idx='"&rsjb_idx&"' and unittype_qtyco_idx='"&unittype_qtyco_idx&"' and unittype_bfwidx='"&unittype_bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                    'Response.write (SQL)&"<br>"
                    'response.end
                    Rs1.open Sql,Dbcon
                    If Not (Rs1.bof or Rs1.eof) Then 
                        unitprice=Rs1(0)
                        'response.write "단가:"&unitprice&"<br>"
                    End If
                    Rs1.Close '2
                rqtyidx = original_rqtyidx ' rqtyidx 원래 값으로 복원
                
                'Response.Write "bwhichi_auto : " & bwhichi_auto & "<br>"
                'Response.Write "bfksidx : " & bfksidx & "<br>"
                'Response.Write "unitprice : " & unitprice & "<br>"
                'Response.Write "bpcent : " & bpcent & "<br>"  
                'Response.Write "bblength : " & bblength & "<br>"  
                'Response.Write "rpidx : " & rpidx & "<br>"  
                'Response.Write "rqtyidx : " & rqtyidx & "<br>"  
                
                If IsNumeric(rpidx) Then
                    if rpidx > 0 and ( rqtyidx = 1 or rqtyidx=37 ) then '헤어라인에 도장일 경우 
                        sprice = unitprice * bpcent * bblength / 1000 * 1.5 '할증적용 가격 blength    
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림

                    elseif rpidx > 0 and rqtyidx = 3 then '갈바도장 추가 ' 
                        sprice = unitprice * bpcent * bblength / 1000 * 1.5 '할증적용 가격 blength    
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                        
                    else
                        sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    end if
                Else
                    sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                    sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                End If
                SQL="Update tk_framekSub  "
                SQL=SQL&" Set unitprice='"&unitprice&"', pcent='"&bpcent&"', sprice='"&sprice&"' "
                SQL=SQL&" Where fksidx='"&bfksidx&"' "  'bfksidx<---------------
                'Response.write (SQL)&"<br>"
                Dbcon.Execute (SQL)
                        
        Rs.MoveNext
        Loop
        End If
        Rs.close

        ' 설정 품목 가격 등록 --------------------tk_framekSub 합계금액인데 부속자재는 뺴고
        SQL = "SELECT SUM(sprice) "
        SQL = SQL & "FROM tk_framekSub "
        SQL = SQL & "WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE fkidx='" & rfkidx & "') "
        SQL = SQL & "AND busok = 0 "
        SQL=SQL&" and sunstatus  in (2,3,4) "
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            sjsprice_fix542=Rs1(0)
            If IsNull(sjsprice_fix542) Or sjsprice_fix542 = "" Then
                sjsprice_fix542 = 0
            End If
        End If
        Rs1.Close'1

    end if
        'Response.Write "sjsprice_fix542 : " & sjsprice_fix542 & "<br>" 
        'Response.Write "sjsprice : " & sjsprice & "<br>"   
        'Response.Write "py_chuga : " & py_chuga & "<br>" 
    
    '==============추가자재 계산 chuga_jajae_cal
        '1. 추가자재를 불러온다
        SQL="select A.fksidx "
        SQL=SQL&" , A.bfidx, B.pcent "
        SQL=SQL&" , A.blength, A.unitprice, A.sprice, A.whichi_fix, A.whichi_auto ,a.chuga_jajae "
        SQL=SQL&" From tk_framekSub A "
        SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
        sql=sql&" and a.chuga_jajae <> 0 " '추가자재 (0:아님 1:추가자재) 
        'Response.write (SQL)&"<br>"
        'response.end
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        Do while not Rs.EOF

            bfksidx=Rs(0)
            bbfidx=Rs(1)
            bpcent=Rs(2)
            bblength=Rs(3)
            bunitprice=Rs(4)
            bsprice=Rs(5)
            bwhichi_fix=Rs(6)
            bwhichi_auto=Rs(7)
            bchuga_jajae = Rs(8)    
      
            If bwhichi_fix > 0 Then
                SQL1="Select unittype_bfwidx from tng_whichitype where whichi_fix='"&bwhichi_fix&"'" 
            ElseIf bwhichi_auto > 0 Then
                SQL1="Select unittype_bfwidx from tng_whichitype where whichi_auto='"&bwhichi_auto&"'" 
            End If    
                'Response.write (SQL)&"<br>" 
                Rs1.open Sql1,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    unittype_bfwidx=Rs1(0)
                End If
            Rs1.Close
            'Response.Write "rqtyidx : " & rqtyidx & "<br>"   
            SQL = "SELECT TOP 1 B.qtyco_idx , b.unittype_qtyco_idx " 
            SQL = SQL & "FROM tk_qty A "
            SQL = SQL & "JOIN tk_qtyco B ON A.QTYNo = B.QTYNo "
            SQL = SQL & "WHERE A.qtyidx = '" & rqtyidx & "' "
            SQL = SQL & "AND (B.sheet_t = 0 OR B.sheet_h >= " & bblength & ") "
            SQL = SQL & "ORDER BY B.sheet_h ASC "
            'Response.write (SQL)&"<br><br>"
            'response.end
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                qtyco_idx=Rs1(0)
                unittype_qtyco_idx=Rs1(1)
            End If
            Rs1.Close
            'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"    
                original_rqtyidx = rqtyidx  ' rqtyidx가 15일 경우, 임시로 30으로 변경
                if rqtyidx = 15 then
                rqtyidx=30
                end if  
                    '2. 미터당 단가를 적용한다 
                    'SQL="Select price From tng_unitprice_F Where sjb_idx='"&rsjb_idx&"' and qtyidx='"&rqtyidx&"' and bfwidx='"&bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                    SQL="Select price From tng_unitprice_t Where sjb_idx='"&rsjb_idx&"' and unittype_qtyco_idx='"&unittype_qtyco_idx&"' and unittype_bfwidx='"&unittype_bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                    'Response.write (SQL)&"<br>"
                    'response.end
                    Rs1.open Sql,Dbcon
                    If Not (Rs1.bof or Rs1.eof) Then 
                        unitprice=Rs1(0)
                        'response.write "단가:"&unitprice&"<br>"
                    End If
                    Rs1.Close '2
                rqtyidx = original_rqtyidx ' rqtyidx 원래 값으로 복원
                
                'Response.Write "bwhichi_auto : " & bwhichi_auto & "<br>"
                'Response.Write "bfksidx : " & bfksidx & "<br>"
                'Response.Write "unitprice : " & unitprice & "<br>"
                'Response.Write "bpcent : " & bpcent & "<br>"  
                'Response.Write "bblength : " & bblength & "<br>"  
                'Response.Write "rpidx : " & rpidx & "<br>"  
                'Response.Write "rqtyidx : " & rqtyidx & "<br>"  
                If IsNumeric(rpidx) Then
                    if rpidx > 0 and ( rqtyidx = 1 or rqtyidx=37) then '헤어라인에 도장비 추가 ' 추후 3코딩 추가해야함 rpidx로 구분
                        sprice = unitprice * bpcent * bblength / 1000 * 1.3 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    elseif rpidx > 0 and rqtyidx = 3 then '도장비 추가 ' 추후 3코딩 추가해야함 rpidx로 구분
                        sprice = unitprice * bpcent * bblength / 1000 * 1.5 '할증적용 가격 blength    
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    else
                        sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    end if
                Else
                    sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                    sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                End If
                '3. 단가를 업데이트 한다
                SQL="Update tk_framekSub  "
                SQL=SQL&" Set unitprice='"&unitprice&"', pcent='"&bpcent&"', sprice='"&sprice&"' "
                SQL=SQL&" Where fksidx='"&bfksidx&"' "  'bfksidx<---------------
                'Response.write (SQL)&"<br>"
                Dbcon.Execute (SQL)
                        
        Rs.MoveNext
        Loop
        End If
        Rs.close

        sql="select ISNULL(SUM(sprice),0) from tk_frameksub "
        sql=sql&" where fkidx='"&rfkidx&"' "
        sql=sql&" and chuga_jajae <> 0 " '도어 타입 (1:편개, 2:양개) 
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            chuga_jajae_price=Rs1(0)
        End If
        Rs1.Close 
    '==============추가자재 계산 끝 chuga_jajae_cal
        if rsjb_type_no >= 1 and rsjb_type_no <= 5 then
            sjsprice_total = sjsprice + py_chuga - bdoor_price + sjsprice_fix542 + chuga_jajae_price 'sjsprice는 모든 추가금이 합산된 최종금액. 새로운 컬럼 (평당추가건 py_chuga) 
        end if
        sjsprice_total = -Int(-sjsprice_total / 1000) * 1000 '무조건 천 단위로 올림
        
        'Response.Write "sjsprice_total : " & sjsprice_total & "<br>"   
        'Response.Write "py_chuga : " & py_chuga & "<br>"   

        '======= cflevel 전체 재적용 =======
        ' 0=기본, 1=A등급(전체 10%DC), 2=B등급(스텐 보급만 10%DC), 3=C등급(자동전체 10%DC), 4=D등급(알미늄자동만 10%DC), 5=E등급(전체 10% 업)
        '======= cflevel 분기 (수주일 때만 적용, 견적일 때는 적용 안 함) =======
        disrate = 0  '할인율 초기화 (기본값: 100% 즉, 할인 없음)

        ' 견적(suju_kyun_status = 1)일 때는 cflevel 적용 안 함
        ' 수주(suju_kyun_status = 0)일 때만 cflevel 적용
        If suju_kyun_status = "0" Or (IsNumeric(suju_kyun_status) And CInt(suju_kyun_status) = 0) Then
        Select Case cflevel
            ' 1. 기본
            Case 0
                disrate = 0  ' 할인 없음

            ' 2. A등급(전체 10%DC) - 100바자동 제외
            Case 1
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 4 Or rsjb_type_no = 6 Or rsjb_type_no = 7 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Or rsjb_type_no = 10 Or rsjb_type_no = 11 Or rsjb_type_no = 12 Or rsjb_type_no = 15 Then
                    disrate = 10 ' 전체 10% 할인 100바자동제외
                End If

            ' 3. B등급(스텐 보급만 10%DC)
            Case 2
                If rsjb_type_no = 11 Or rsjb_type_no = 12 Then
                    disrate = 10 ' 수동 스텐 보급만 10% 할인
                End If

            ' 4. C등급(자동전체 10%DC)
            Case 3
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Or rsjb_type_no = 10 Or rsjb_type_no = 15 Then
                    disrate = 10 ' 자동만 10% 할인
                End If

            ' 5. D등급(알미늄자동만 10%DC)
            Case 4
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Then
                    disrate = 10 ' 자동만 10% 할인 이중하고 포켓 슬림 제외
                End If

            ' 6. E등급(전체 10% 업)
            Case 5
                disrate = -10 ' 10% 증가 (업)
        End Select
        Else
            ' 견적일 때는 cflevel 적용 안 함 (disrate = 0 유지)
            disrate = 0
        End If

        '--- 기본 금액 계산 ---
        sjsprice_update = sjsprice_total * yquan '총 원가 (수량 반영)

        If disrate > 0 Then
            '할인
            disprice = sjsprice_total * (disrate / 100)
            disprice_update = ( Int(disprice / 1000) * 1000 ) * yquan
            fprice = sjsprice_update - disprice_update

        ElseIf disrate < 0 Then
            '업 (disrate는 음수라서 절대값으로 변환)
            disprice = sjsprice_total * (Abs(disrate) / 100)
            disprice_update = ( Int(disprice / 1000) * 1000 ) * yquan
            fprice = sjsprice_update + disprice_update

            'Response.Write "1sjsprice_total : " & sjsprice_total & "<br>"  
            'Response.Write "1disprice : " & disprice & "<br>"  
            'Response.Write "1disprice_update : " & disprice_update & "<br>"  
            'Response.Write "1sjsprice_update : " & sjsprice_update & "<br>"  
            'Response.Write "1fprice : " & fprice & "<br>" 

        Else
            '변동 없음
            disprice = 0
            disprice_update = 0
            fprice = sjsprice_update
        End If         

        '--- 부가세 ---
        taxrate = fprice * 0.1
        if taxrate < 0 then
            taxrate = Round(taxrate)
        end if

        '--- 최종 합계 ---
        sprice = fprice + taxrate
        If sprice = 0 Or IsNull(sprice) Then
            sprice = 0
        End If

        'Response.Write "cflevel : " & cflevel & "<br>"  
        'Response.Write "disrate : " & disrate & "<br>" 
        'Response.Write "sjsprice_update : " & sjsprice_update & "<br>" 
        'Response.Write "disprice : " & disprice & "<br>"  
        'Response.Write "disprice_update : " & disprice_update & "<br>"  
        'Response.Write "sjsprice_total : " & sjsprice_total & "<br>"   
        'Response.Write "sjsprice : " & sjsprice & "<br>"  
        'Response.Write "sprice : " & sprice & "<br>"   
        'Response.Write "fprice : " & fprice & "<br>"   
        'Response.Write "taxrate : " & taxrate & "<br>"  
        'response.end
        SQL="Update tk_framek set sjsprice='"&sjsprice_total&"', disrate='"&disrate&"',disprice='"&disprice_update&"', fprice='"&fprice&"', quan='"&yquan&"' "
        SQL=SQL&" , taxrate='"&taxrate&"', sprice='"&sprice&"', py_chuga='"&py_chuga&"' , chuga_jajae='"&chuga_jajae_price&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
 


' al평당단가계산 끝
'=========================================
'or ( request("meter_price") = meter_price )
elseif ( (rsjb_type_no >= 6 and rsjb_type_no <= 15)  and rqtyidx > 0   and  rtw > 0 and rth > 0 )  then               

'=========================================
' 스텐 미터당단가계산 시작

    '=================수량 가져오기
    SQL = "SELECT quan from tk_framek where fkidx = '" & rfkidx & "' "
    'Response.write (SQL)&"<br>"
    'response.end
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
     
        yquan=rs1(0) '수량

    End If
    Rs1.Close '2

    SQL="select A.fksidx "
    SQL=SQL&" , A.bfidx, B.pcent "
    SQL=SQL&" , A.blength, A.unitprice, A.sprice, A.whichi_fix, A.whichi_auto "
    SQL=SQL&" , A.door_price, A.doorsizechuga_price "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
    SQL=SQL&" and A.whichi_auto not in (11,20) " '11번 기타 20번 하부레일
    SQL=SQL&" and A.sunstatus not in (1,5,6) "

    'sunstatus=1 은 픽스하부유리 위에 상부픽스 
    'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 
    'sunstatus=3 은 하부픽스위에 상부남마 에
    'sunstatus=4 은 양개 중앙에
    'sunstatus=5 은 t형_자동홈바
    'sunstatus=6 은 박스커버
    'sunstatus=7 은 마구리
    'Response.write (SQL)&"<br>"
    'response.end
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF

    bfksidx=Rs(0)
    bbfidx=Rs(1)
    bpcent=Rs(2)
    bblength=Rs(3)
    bunitprice=Rs(4)
    bsprice=Rs(5)
    bwhichi_fix=Rs(6)
    bwhichi_auto=Rs(7)
    bdoor_price=Rs(8)
    bdoorsizechuga_price=Rs(9)

        If bwhichi_fix > 0 Then
            SQL1="Select unittype_bfwidx from tng_whichitype where whichi_fix='"&bwhichi_fix&"'" 
        ElseIf bwhichi_auto > 0 Then
            SQL1="Select unittype_bfwidx from tng_whichitype where whichi_auto='"&bwhichi_auto&"'" 
        End If    
            'Response.write (SQL)&"<br>" 
            'Response.write (SQL1)&"<br>"
            Rs1.open Sql1,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                unittype_bfwidx=Rs1(0)
            End If
        Rs1.Close
        'Response.Write "rqtyidx : " & rqtyidx & "<br>"   
        SQL = "SELECT TOP 1 B.qtyco_idx , b.unittype_qtyco_idx " 
        SQL = SQL & "FROM tk_qty A "
        SQL = SQL & "JOIN tk_qtyco B ON A.QTYNo = B.QTYNo "
        SQL = SQL & "WHERE A.qtyidx = '" & rqtyidx & "' "
        'SQL = SQL & "AND (B.sheet_t = 0 OR B.sheet_h >= " & bblength & ") "
        'SQL = SQL & "ORDER BY B.sheet_h ASC "
        'Response.write (SQL)&"<br><br>"
        'response.end
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            qtyco_idx=Rs1(0)
            unittype_qtyco_idx=Rs1(1)
        End If
        Rs1.Close
        'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"    
            original_rqtyidx = rqtyidx  ' rqtyidx가 15일 경우, 임시로 30으로 변경
            if rqtyidx = 15 then
            rqtyidx=30
            end if  
                'SQL="Select price From tng_unitprice_F Where sjb_idx='"&rsjb_idx&"' and qtyidx='"&rqtyidx&"' and bfwidx='"&bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                SQL="Select price From tng_unitprice_t Where sjb_idx='"&rsjb_idx&"' and unittype_qtyco_idx='"&unittype_qtyco_idx&"' and unittype_bfwidx='"&unittype_bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                'Response.write (SQL)&"<br>"
                'response.end
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    unitprice=Rs1(0)
                    'response.write "단가:"&unitprice&"<br>"
                End If
                Rs1.Close '2
            rqtyidx = original_rqtyidx ' rqtyidx 원래 값으로 복원
            
            'Response.Write "bwhichi_auto : " & bwhichi_auto & "<br>"
            'Response.Write "bfksidx : " & bfksidx & "<br>"
            'Response.Write "unitprice : " & unitprice & "<br>"
            'Response.Write "bpcent : " & bpcent & "<br>"  
            'Response.Write "bblength : " & bblength & "<br>"  
            'Response.Write "rpidx : " & rpidx & "<br>"  
            'Response.Write "rqtyidx : " & rqtyidx & "<br>"  
            'Response.Write "coat : " & coat & "<br>"  
            'response.end
            If IsNumeric(rpidx) Then
                if rpidx > 0 and ( rqtyidx = 1 or rqtyidx = 3 or rqtyidx = 37  )then '도장비 추가 ' 추후 3코딩 추가해야함 rpidx로 구분
                    if coat=0 or coat = 1 then '기본 2코딩
                        sprice = unitprice * bpcent * bblength / 1000 * 1.3 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    else coat=2  '3코딩
                        sprice = unitprice * bpcent * bblength / 1000 * 1.5 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림            

                    end if  
                elseif rpidx > 0 and ( rqtyidx = 15 or rqtyidx = 30  ) and coat = 2 then ''3코트일 경우( 알미늄에 )

                    sprice = unitprice * bpcent * bblength / 1000 * 1.2 '할증적용 가격 blength
                    sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                   
                else
                    sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                    sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                end if
            Else
                sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
            End If
            '====롯트바 8000원 추가비용 받기
            if zsjb_type_no=6 or zsjb_type_no=7 then '6=일반 al프레임 , 7=단열 al프레임 
                if bwhichi_fix=4 then '4=롯트바 22번 박스라인은 롯트바 가공안됨
                    sprice=sprice+8000
                end if
            end if

            SQL="Update tk_framekSub  "
            SQL=SQL&" Set unitprice='"&unitprice&"', pcent='"&bpcent&"', sprice='"&sprice&"' "
            SQL=SQL&" Where fksidx='"&bfksidx&"' "  'bfksidx<---------------
            'Response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)
                    
    Rs.MoveNext
    Loop
    End If
    Rs.close
    

       ' 설정 품목 가격 등록 --------------------tk_framekSub 합계금액인데 부속자재는 뺴고
        SQL = "SELECT SUM(sprice) "
        SQL = SQL & "FROM tk_framekSub "
        SQL = SQL & "WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE fkidx='" & rfkidx & "') "
        SQL = SQL & "AND busok = 0 "
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                sjsprice=Rs1(0)
            End If
            Rs1.Close'1

        sql="select SUM(door_price) from tk_frameksub "
        sql=sql&" where fkidx='"&rfkidx&"' "
        sql=sql&" and doortype in (1,2) " '도어 타입 (1:편개, 2:양개) 
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            bdoor_price=Rs1(0)
            If IsNull(bdoor_price) Then
                'Response.Write "<script>alert('❗ 도어 단가를 설정해주세요.'); history.back();</script>"
                'Response.End
            End If
        End If
        Rs1.Close 

        sjsprice_total = -Int(-sjsprice / 1000) * 1000 '무조건 천 단위로 올림

        



        'Response.Write "sjsprice_total : " & sjsprice_total & "<br>"   
        'Response.Write "py_chuga : " & py_chuga & "<br>"   
        'Response.Write "bdoor_price : " & bdoor_price & "<br>"
        '======= cflevel 전체 재적용 =======
        ' 0=기본, 1=A등급(전체 10%DC), 2=B등급(스텐 보급만 10%DC), 3=C등급(자동전체 10%DC), 4=D등급(알미늄자동만 10%DC), 5=E등급(전체 10% 업)
        '======= cflevel 분기 (수주일 때만 적용, 견적일 때는 적용 안 함) =======
        disrate = 0  '할인율 초기화 (기본값: 100% 즉, 할인 없음)

        ' 견적(suju_kyun_status = 1)일 때는 cflevel 적용 안 함
        ' 수주(suju_kyun_status = 0)일 때만 cflevel 적용
        If suju_kyun_status = "0" Or (IsNumeric(suju_kyun_status) And CInt(suju_kyun_status) = 0) Then
        Select Case cflevel
            ' 1. 기본
            Case 0
                disrate = 0  ' 할인 없음

            ' 2. A등급(전체 10%DC) - 100바자동 제외
            Case 1
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 4 Or rsjb_type_no = 6 Or rsjb_type_no = 7 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Or rsjb_type_no = 10 Or rsjb_type_no = 11 Or rsjb_type_no = 12 Or rsjb_type_no = 15 Then
                    disrate = 10 ' 전체 10% 할인 100바자동제외
                End If

            ' 3. B등급(스텐 보급만 10%DC)
            Case 2
                If rsjb_type_no = 11 Or rsjb_type_no = 12 Then
                    disrate = 10 ' 수동 스텐 보급만 10% 할인
                End If

            ' 4. C등급(자동전체 10%DC)
            Case 3
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Or rsjb_type_no = 10 Or rsjb_type_no = 15 Then
                    disrate = 10 ' 자동만 10% 할인
                End If

            ' 5. D등급(알미늄자동만 10%DC)
            Case 4
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Then
                    disrate = 10 ' 자동만 10% 할인 이중하고 포켓 슬림 제외
                End If

            ' 6. E등급(전체 10% 업)
            Case 5
                disrate = -10 ' 10% 증가 (업)
        End Select
        Else
            ' 견적일 때는 cflevel 적용 안 함 (disrate = 0 유지)
            disrate = 0
        End If

        '--- 기본 금액 계산 ---
        sjsprice_update = sjsprice_total * yquan '총 원가 (수량 반영)

        If disrate > 0 Then
            '할인
            disprice = sjsprice_total * (disrate / 100)
            disprice_update = ( Int(disprice / 1000) * 1000 ) * yquan
            fprice = sjsprice_update - disprice_update

        ElseIf disrate < 0 Then
            '업 (disrate는 음수라서 절대값으로 변환)
            disprice = sjsprice_total * (Abs(disrate) / 100)
            disprice_update = ( -Int(-disprice / 1000) * 1000 ) * yquan
            fprice = sjsprice_update + disprice_update

        Else
            '변동 없음
            disprice = 0
            disprice_update = 0
            fprice = sjsprice_update
        End If    

        '--- 부가세 ---
        taxrate = fprice * 0.1
        if taxrate < 0 then
            taxrate = Round(taxrate)
        end if

        '--- 최종 합계 ---
        sprice = fprice + taxrate
        If sprice = 0 Or IsNull(sprice) Then
            sprice = 0
        End If
        
        'Response.Write "cflevel : " & cflevel & "<br>"  
        'Response.Write "disrate : " & disrate & "<br>"  
        'Response.Write "sjsprice : " & sjsprice & "<br>"   
        'Response.Write "sprice : " & sprice & "<br>"   
        'Response.Write "taxrate : " & taxrate & "<br>"  
        'sjsprice = 원가 수량 곱하기 전
        'disprice 수량 곱한 할인금액
        'fprice 수량 곱한 프레임 금액(할인적용된것)
        SQL="Update tk_framek set sjsprice='"&sjsprice_total&"', disrate='"&disrate&"',disprice='"&disprice_update&"', fprice='"&fprice&"', quan='"&yquan&"' "
        SQL=SQL&" , taxrate='"&taxrate&"', sprice='"&sprice&"', py_chuga='"&py_chuga&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL) 

' 스텐 미터당단가계산  끝
'=========================================


end if  

'==============마지막 계산 final_cal
if rfkidx<>"" then  

    '=================tk_framek 도어업데이트 시작
        SQL = "" ' ✅ 반드시 초기화!!
        SQL = SQL & " select doorsizechuga_price,door_price "
        SQL = SQL & " from tk_framekSub "
        SQL=SQL&" Where fkidx = '"&rfkidx&"' and doortype>0 "
        'Response.write (SQL)&"<br>"
        Rs1.open SQL, Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
        Do While Not Rs1.EOF

            doorsizechuga_price = rs1(0)
            door_price = rs1(1)

            total_doorsizechuga_price         = total_doorsizechuga_price         + doorsizechuga_price '총 도어 추가금(별도 분리되서 계산)
            total_door_price          = total_door_price          + door_price '총 도어(도어추가금 포함되어있음) 단가

        rs1.MoveNext
        Loop
        End If
        Rs1.Close 

        SQL = "UPDATE tk_framek SET "
        SQL = SQL & " door_price = '" & total_door_price & "' "
        SQL = SQL & " WHERE fkidx = '"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
        
        '도어포함 , 제외, 별도 에 따라 기본 가격 업데이트 '
        '도어별도 인 경우
        if(rdoorchoice = 2 ) Then
            sjsprice_total = sjsprice_total - total_door_price '기본 단가 가격 수정
            disprice = sjsprice_total  / 10 '할인 금액 기본 값도 수정
            fprice = int(sjsprice_total * yquan) - disprice '납품가'
        '도어제외 인 경우
        Elseif(rdoorchoice = 3) Then
             sjsprice_total = sjsprice_total + total_door_price  ' 기본 단가 가격 수정 
             disprice = sjsprice_total  / 10 '할인 금액 기본 값도 수정 
             fprice = int(sjsprice_total * yquan) - disprice ' 납품가'
        End if 
        
        
        '기본 단가 와 기본 할인 금액, 납품가  업데이트
        SQL = " "
        SQL = "UPDATE tk_framek SET "
        SQL = SQL & " sjsprice = '" & sjsprice_total & "' ,"
        SQL = SQL & " disprice = '" & disprice & "' ,"
        SQL = SQL & " fprice = '" & fprice & "' ,"
        SQL = SQL & " doorchoice = '" & rdoorchoice & "' "
        SQL = SQL & " WHERE fkidx = '"&rfkidx&"' "
        Dbcon.Execute (SQL)
    
    '=================tk_framek 도어업데이트 끝


sjsprice = 0
disrate = 0
disprice = 0
fprice = 0
py_chuga= 0
robby_box= 0
jaeryobunridae= 0
boyangjea= 0
whaburail= 0
total_sjsprice         = 0
total_disrate          = 0
total_disprice         = 0
total_fprice           = 0
total_py_chuga         = 0
total_robby_box        = 0
total_jaeryobunridae   = 0
total_boyangjea        = 0
total_whaburail        = 0
total_door_price       = 0

    sql = "SELECT fkidx, fknickname, fidx, sjb_idx, fname, fmidx"
    sql = sql & ", fwdate, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE"
    sql = sql & ", GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, fmeidx, fewdate, GREEM_MBAR_TYPE"
    sql = sql & ", sjidx, sjb_type_no, setstd, sjsidx, ow, oh"
    sql = sql & ", tw, th, bcnt, FL, qtyidx, pidx"
    sql = sql & ", ow_m, framek_price, sjsprice, disrate, disprice, fprice"
    sql = sql & ", quan, taxrate, sprice, py_chuga, robby_box, jaeryobunridae"
    sql = sql & ", boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, whaburail"
    sql = sql & ", jaeryobunridae_type, door_price "
    sql = sql & " FROM tk_framek"
    sql = sql & " WHERE sjsidx = '" & rsjsidx & "'"
    'Response.write (SQL)&"<br>"
    rs.Open sql, Dbcon
    If Not (rs.BOF Or rs.EOF) Then
    Do While Not rs.EOF

        fkidx = rs(0)
        fknickname = rs(1)
        fidx = rs(2)
        sjb_idx = rs(3)
        fname = rs(4)
        fmidx = rs(5)
        fwdate = rs(6)
        fstatus = rs(7)
        GREEM_F_A = rs(8)
        GREEM_BASIC_TYPE = rs(9)
        GREEM_FIX_TYPE = rs(10)
        GREEM_HABAR_TYPE = rs(11)
        GREEM_LB_TYPE = rs(12)
        GREEM_O_TYPE = rs(13)
        GREEM_FIX_name = rs(14)
        fmeidx = rs(15)
        fewdate = rs(16)
        GREEM_MBAR_TYPE = rs(17)
        sjidx = rs(18)
        sjb_type_no = rs(19)
        setstd = rs(20)
        sjsidx = rs(21)
        ow = rs(22)
        oh = rs(23)
        tw = rs(24)
        th = rs(25)
        bcnt = rs(26)
        FL = rs(27)
        qtyidx = rs(28)
        pidx = rs(29)
        ow_m = rs(30)
        framek_price = rs(31)
        sjsprice = rs(32)  ' 프레임 원가 (도어  빼고 수량도 없고 할인 전 가격)
        disrate = rs(33)
        disprice = rs(34)
        fprice = rs(35)
        quan = rs(36)
        taxrate = rs(37)
        sprice = rs(38)
        py_chuga = rs(39)
        robby_box = rs(40)
        jaeryobunridae = rs(41)
        boyangjea = rs(42)
        dooryn = rs(43)
        doorglass_t = rs(44)
        fixglass_t = rs(45)
        doorchoice = rs(46)
        whaburail = rs(47)
        jaeryobunridae_type = rs(48)
        door_price = rs(49)

            total_sjsprice         = total_sjsprice         + sjsprice  '단가
            total_disrate          = disrate '할인율
            total_disprice         = total_disprice         + disprice '할인금액
            total_fprice           = total_fprice           + fprice '공급가 (tk_frmaek에서 단가에서 할인을 뺴서 계산되어 있음 . 수량도 곱해져 있음)
            'total_quan             = total_quan             + quan '수량
            'total_taxrate          = total_taxrate          + taxrate '세율
            'total_sprice           = total_sprice           + sprice '최종가
            total_py_chuga         = total_py_chuga         + py_chuga
            total_robby_box        = total_robby_box        + robby_box
            total_jaeryobunridae   = total_jaeryobunridae   + jaeryobunridae
            total_boyangjea        = total_boyangjea        + boyangjea
            total_whaburail        = total_whaburail        + whaburail
        
        'response.write "fkidx : " & fkidx & "<br>"
        'response.write "fprice : " & fprice & "<br>"
        'response.write "total_fprice : " & total_fprice & "<br>"

        total_door_price = total_door_price + door_price

        rs.MoveNext
        Loop
        End If
        Rs.Close 
        
        'total_robby_box
        'response.write "total_robby_box : " & total_robby_box & "<br>"
        'response.write "total_jaeryobunridae : " & total_jaeryobunridae & "<br>"
        'response.write "total_boyangjea : " & total_boyangjea & "<br>"
        'response.write "total_whaburail : " & total_whaburail & "<br>"
        'response.write "total_door_price : " & total_door_price & "<br>"
        'response.write "total_sjsprice : " & total_sjsprice & "<br>"
        'response.write "total_disprice : " & total_disprice & "<br>"
        'response.write "total_fprice : " & total_fprice & "<br>"
        'response.write "total_py_chuga : " & total_py_chuga & "<br>"
        'response.write "total_disrate : " & total_disrate & "<br>"
        'response.end
        '1. 프레임 개당 원가
        '2. 프레임 공급가 (할인된가격) * 수량 + 옵션들 추가 가격
        '추가 . 프레임 공급가 (할인된가격) * 수량 - 옵션제외 가격
        '3. 도어 공급가 * 수량
        '4. fprice_update 전체가 = (옵션 전체액 * 수량) + 프레임 공급가 * 수량 + 도어 공급가* 수량 
        '5  total_taxrate 세액
        '6  total_sprice 최종가 = 전체가 + 세액 
        frame_option_price =  total_fprice +  ((total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail ) * quan )'2번
        frame_price_update  = total_fprice
        'sjsprice_update =  total_sjsprice + total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail + total_door_price
        sjsprice_update=total_sjsprice '1번
        'total_door_price 3번
        fprice_update =  total_fprice + ((total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail + total_door_price) * quan ) '4번
        total_taxrate=(fprice_update * 0.1)  '5번
        total_sprice=(fprice_update+total_taxrate)   '6번
    
'response.write "sjsprice_update : " & sjsprice_update & "<br>"
'response.write "fprice_update : " & fprice_update & "<br>"
'response.write "total_taxrate : " & total_taxrate & "<br>"
'response.write "total_sprice : " & total_sprice & "<br>"
'response.write "frame_price_update : " & frame_price_update & "<br>"
'response.end
        '=================sjasub 업데이트 시작

        ' 도어 제외 일때 세액가 와 최종가 가격 부분이 도어가격 한번더 빠지므로 다시 더해주기'
        if(doorchoice = 3) Then
            ' 빠진 값 만큼 다시 더해주기'
             total_taxrate = total_taxrate + (Abs(total_door_price) / 10) '세액가
             total_sprice = frame_price_update + total_taxrate '최종가
        End if


        if quan = 0 then
            quan = 1
        end if
        SQL = "UPDATE tng_sjaSub SET "
        SQL = SQL & " sjsprice = '" & sjsprice_update & "' , disprice = '" & total_disprice & "' , fprice = '" & fprice_update & "' "
        SQL = SQL & " , taxrate = '" & total_taxrate & "' , sprice = '" & total_sprice & "', py_chuga = '" & total_py_chuga & "' "
        SQL = SQL & " , robby_box = '" & total_robby_box & "' , jaeryobunridae = '" & total_jaeryobunridae & "', boyangjea = '" & total_boyangjea & "' "
        SQL = SQL & " , whaburail = '" & total_whaburail & "' , door_price = '" & total_door_price & "' ,quan='"&quan&"',frame_price='"&frame_price_update&"' "
        SQL = SQL & " , frame_option_price='"&frame_option_price&"' "
        SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
        '=================sjasub 업데이트 끝

end if 'if rfkidx<>"" then  


'response.endquick



if Request("part")="choiceb" then 
response.write"<script>location.replace('TNG1_b_choiceframeb.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"');</script>"
elseif mode="quick" then 
response.write"<script>location.replace('tng1_b_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"
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