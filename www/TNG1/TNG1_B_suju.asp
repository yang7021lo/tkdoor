
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

  listgubun="one" 
  projectname="수주"

'SQL="Select ow,oh,tw,th,fl "
'SQL=SQL&" From tk_framek  "
'SQL=SQL&" Where fkidx='"&rfkidx&"' "
'Response.write (SQL)&"222222<br>"
'Rs.open SQL, Dbcon
'If Not (Rs.bof or Rs.eof) Then 

 '   row=rs(0) '오픈 가로
  '  roh=rs(1) '오픈 세로  
   ' rtw=rs(2) '전체 가로
    'rth=rs(3) '전체 세로
    'rfl=rs(4) '묻힘 치수

'End If
'Rs.close



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
    rpidx=Request("pidx") '도장 페인트키  
    If Trim(rpidx) = "" Or IsNull(rpidx) Or Not IsNumeric(rpidx) Then
        rpidx = 0
    End If
    'Response.Write "rpidx 도장칼라: " & rpidx & "<br>" 

    rqtyidx=Request("qtyidx") '재질키
        If rqtyidx = 5 Then 
            rpidx = 0
        end if
        If rqtyidx = 7 Then 
            rqtyidx = 3
        end if
    'rfidx=Request("fidx") '도면 타입
  rqtyco_idx=Request("qtyco_idx") '재질키서브
        If rqtyco_idx = 77 Then 
            rpidx = 0
        end if
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

rquan=Request("quan") '수량
If Trim(rquan) = "" Or IsNull(rquan) Or Not IsNumeric(rquan) Then
    rquan = 1
End If
mode=Request("mode")
mode1=Request("mode1") '재분
mode2=Request("mode2") 'dchangeh 도어높이 수정
mode3=Request("mode3") '보양
mode4=Request("mode4") '로비폰
rdoorchangehigh=Request("doorchangehigh") 
Response.Write "mode : " & mode & "<br>"   
Response.Write "mode1 : " & mode1 & "<br>"   
'Response.Write "mode2 : " & mode2 & "<br>"   
'Response.Write "rdoorchangehigh : " & rdoorchangehigh & "<br>"  
'Response.Write "rdooryn : " & rdooryn & "<br>"   
'Response.Write "rdoorglass_t : " & rdoorglass_t & "<br>"  
'Response.Write "rfixglass_t : " & rfixglass_t & "<br>"  
'Response.Write "rpidx 도장칼라: " & rpidx & "<br>"   
'Response.Write "rtw 전체가로: " & rtw & "<br>"
'Response.Write "rth 전체세로: " & rth & "<br>"
'Response.Write "row 오픈가로: " & row & "<br>"
'Response.Write "roh 오픈세로: " & roh & "<br>"
'Response.Write "rfl 묻힘: " & rfl & "<br>"
'Response.Write "row_m : " & row_m & "<br>"
'response.write rfidx&"/<br>"
'response.write rqtyco_idx&"/<br>"
'Response.Write "rqtyidx 재질: " & rqtyidx & "<br>"
'Response.Write "rfl : " & rfl & "<br>"  
'Response.Write "rafksidx : " & rafksidx & "<br>"   
'Response.Write "rgreem_o_type : " & rgreem_o_type & "<br>"   
'Response.Write "rfksidx : " & rfksidx & "<br>"  
'Response.Write "rfkidx : " & rfkidx & "<br>"   
'Response.Write "rfidx : " & rfidx & "<br>"   
'Response.Write "mode : " & mode & "<br>"   
'Response.Write "rblength : " & rblength & "<br>"   
'Response.Write "rasub_wichi1 : " & rasub_wichi1 & "<br>"    
'Response.Write "rsjb_type_no : " & rsjb_type_no & "<br>"
'Response.Write "rgreem_f_a : " & rgreem_f_a & "<br>"
  'response.write rmwidth&"/<br>"
  'response.write rmheight&"/<br>"

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

if rfkidx="" then
    rfkidx=0
end if 


SearchWord=Request("SearchWord")
gubun=Request("gubun")

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="tng1_greemlist3.asp?listgubun="&listgubun&"&"

'재질정보,프레임의 길이정보 입력 시작 
'================================
if rfkidx<>"" and rsjidx<>"" and rsjsidx<>"" then  
    if  rdooryn <> "" then   
        sql="update tk_framek set dooryn='"&rdooryn&"'  "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if  rdoorglass_t <> "" then   
        sql="update tk_framek set doorglass_t='"&rdoorglass_t&"'  "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if  rfixglass_t <> "" then   
        sql="update tk_framek set fixglass_t='"&rfixglass_t&"' "
        sql=sql&" where fkidx='"&rfkidx&"'  "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    if  rqtyidx <> "" then   
        sql="update tk_framek set qtyidx='"&rqtyidx&"'  "
        sql=sql&" where fkidx='"&rfkidx&"' and sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if  rpidx <> "" then   
        sql="update tk_framek set pidx='"&rpidx&"' "
        sql=sql&" where fkidx='"&rfkidx&"' and sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    if  rtw <> "" then  
        sql="update tk_framek set tw='"&rtw&"' "
        sql=sql&" where fkidx='"&rfkidx&"' and sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    if  rth <> "" then  
        sql="update tk_framek set th='"&rth&"' "
        sql=sql&" where fkidx='"&rfkidx&"' and sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL) 
    end if
    'Response.Write "수동입력 row_m: " & row_m & "<br>"

    '강제 오픈치수 입력시작----최종 DB에 반영될 값은 row_m이 있으면 그것을 사용
    If row_m > 0  Then
        final_row = row_m   ' 수동입력 우선
        opt = final_row  ' 수동 입력을 opt로 대체
    Else
        final_row = row           ' 없으면 계산값
    End if
    'Response.Write "최종 반영될 final_row: " & final_row & "<br>"
    'Response.Write "최종 반영될 opt: " & opt & "<br>"
    If final_row > 0  Then
        SQL = "UPDATE tk_framek SET ow='" & final_row & "',  ow_m='" & final_row & "' "
        sql=sql&" WHERE fkidx='" & rfkidx & "' and sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
        Dbcon.Execute SQL
    End If
    'Response.Write "계산된 자동 row: " & row & "<br>"
    'Response.Write "수동입력 row_m: " & row_m & "<br>"
    'Response.Write "최종 반영될 final_row: " & final_row & "<br>"
    'Response.Write "최종 반영될 opt: " & opt & "<br>"
    '===================
    '강제 오픈치수 입력끝
    if row > 0 then
        sql="update tk_framek set ow='"&final_row&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if roh <> "" then
        sql="update tk_framek set oh='"&roh&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    if rfl > 0 then
        sql="update tk_framek set fl='"&rfl&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)  
    end if
    
end if
'================================
if rtw>0 and rth>0 then
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
    'sql1 = sql1 & " and A.greem_f_a = '2' "
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
'Response.Write "yysize : " & yysize & "<br>"  
'Response.Write "ywhichi_fix : " & ywhichi_fix & "<br>"  
'Response.Write "ywhichi_auto : " & ywhichi_auto & "<br>"  
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
        box = ytw - serobar_y
        garonamma_ysize =  garonamma_ysize 
        box_yysize = box_yysize
        jadonghaba_y = jadonghaba_y
        ' 수동에 최종 롯트바 계산 , 가로남마ysize 계산
        'f_garonamma_ysize = f_garonamma_ysize
        'f_serobar_y = ytw - f_serobar_y '가로바 치수계산
        'f_garolot_size = f_garosize '롯트바 가로 치수계산
        'lot_yysize = lot_yysize
        'jadonghaba_y = jadonghaba_y

'Response.Write "ytw : " & ytw & "<br>"  
'Response.Write "ywhichi_fix : " & ywhichi_fix & "<br>"  
'Response.Write "yysize : " & yysize & "<br>"  
'Response.Write "lot_yysize : " & lot_yysize & "<br>"  
'Response.Write "f_serobar_y : " & f_serobar_y & "<br>"  
'Response.Write "f_junggan : " & f_junggan & "<br>"  
'Response.Write "f_garonamma_ysize : " & f_garonamma_ysize & "<br>"
'Response.Write "sudonghaba_y : " & sudonghaba_y & "<br>"
'Response.Write "f_garolot_size : " & f_garolot_size & "<br>"  
'Response.Write "jadonghaba_y : " & jadonghaba_y & "<br>"  
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
    Do while not Rs.EOF

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
                        opt = final_row  ' 수동 입력을 opt로 대체
                    else
                        opt = (box - junggan) / 2
                    end if
                    opt_habar = box - junggan - opt 
                Case "a2"
                    If row_m > 0 Then
                        opt = final_row  ' 수동 입력을 opt로 대체
                    else
                        opt = (box - junggan - junggan) / 2
                    end if
                    opt_habar = (box - junggan - junggan - opt) / 2
                Case "a4", "a6", "a8"
                    If row_m > 0 Then
                        opt = final_row  ' 수동 입력을 opt로 대체
                    else
                        opt = (box - 20 - junggan - junggan) / 2
                    end if
                    opt_habar = (box - junggan - junggan - opt) / 2
                Case "a5"
                    If row_m > 0 Then
                        opt = final_row  ' 수동 입력을 opt로 대체
                    else
                        opt = (box - junggan - 25) / 2
                    end if
                    opt_habar = box - junggan - opt 
            End Select

        ElseIf zsjb_type_no = 5 Then  ' 슬림자동

            Select Case opb
                Case "b1"
                    opt = (box - junggan) / 2
                    opt_habar = box - junggan - opt 
                Case "b2"
                    opt = (box - junggan - junggan) / 2
                    opt_habar = (box - junggan - junggan - opt) / 2
                Case "b3", "b4", "b5", "b6", "b7", "b8"
                    opt = 0
                    opt_habar = 0
            End Select

        ElseIf zsjb_type_no = 8 Or zsjb_type_no = 9 Or zsjb_type_no = 15 Then  ' 단자_삼중단자

            Select Case opc
                Case "c1", "c3", "c5", "c7"
                    If row_m > 0 Then
                        opt = final_row  ' 수동 입력을 opt로 대체
                    else
                        opt = (box - junggan - 25) / 2
                    end if
                    opt_habar = box - junggan - opt 
                Case "c2", "c4", "c6", "c8"
                    opt = (box - junggan - junggan) / 2
                    opt_habar = (box - junggan - junggan - opt) / 2
            End Select    

        ElseIf zsjb_type_no = 10 Then  ' 이중슬라이딩

            Select Case opd
                Case "d1"
                    opt = (box - junggan - 27.5) / 1.5
                    opt_habar = box - junggan - opt
                Case "d2"
                    opt = (2 * box) / 3 + 30 - junggan - junggan
                    opt_habar = (box - junggan - junggan - opt) / 2
                Case "d3", "d4", "d5", "d6", "d7", "d8"
                    opt = 0
                    opt_habar = 0
            End Select

        ElseIf zsjb_type_no = 6 Or zsjb_type_no = 7 Or zsjb_type_no = 11 Or zsjb_type_no = 12 Then '수동도어 계산

            Select Case zgreem_fix_type
                Case 9 , 16 , 17 , 28 , 35 , 36 ' 편개 ,좌_편개 ,우_편개,박스라인 편개 ,박스라인 좌_편개 ,박스라인 우_편개 
                    sudong_door_w = rtw - f_serobar_y
                    sudong_door_h = rth - lot_yysize - rfl 
                    opt = rtw - f_serobar_y
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth

                        SQL="Update tk_framekSub  "  '수동에  롯트바4  , 박스라인롯트바22
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL=SQL&" AND whichi_fix IN (4, 22)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                        SQL="Update tk_framekSub  "  ' 세로바=6 180도 코너바=8 90도 코너바=9 비규격 코너바=10
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                Case 10 , 18 , 19 , 29 , 37 , 38 ' 양개 ,좌_양개 ,우_양개,박스라인 양개 ,박스라인 좌_양개 ,박스라인 우_양개 
                    sudong_door_w = (rtw - f_serobar_y) / 2
                    sudong_door_w = Int(sudong_door_w)'반내림
                    sudong_door_h = rth - lot_yysize - rfl 
                    opt = rtw - f_serobar_y
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth
                        
                        SQL="Update tk_framekSub  "  '수동에  롯트바4  , 박스라인롯트바22 
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL=SQL&" AND whichi_fix IN (4, 22)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                        
                        SQL="Update tk_framekSub  "  '수동에 세로바
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                Case 11 , 20 , 21 , 30 , 39 , 40  '고정창 ,좌_고정창 ,우_고정창,박스라인 고정창 ,박스라인 좌_고정창 ,박스라인 우_고정창 
                    sudong_glass_w = rtw - f_serobar_y
                    sudong_glass_h = rth - f_garonamma_ysize - sudonghaba_y - rfl 
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth

                        SQL="Update tk_framekSub  "  '수동에  가로바1, 가로바길게2 , 중간바3  , 하바5  , 박스라인21
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (1 , 2 , 3 , 5 , 21)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                        
                        SQL="Update tk_framekSub  "  '수동에 세로바
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                Case 12 , 22 , 23 , 31 , 41 , 42   '편개_상부남마 ,좌_편개_상부남마 ,우_편개_상부남마,박스라인 편개_상부남마 ,박스라인 좌_편개_상부남마 ,박스라인 우_편개_상부남마 
                    sudong_door_w = rtw - f_serobar_y
                    sudong_door_h = roh
                    sudong_glass_w =  rtw - f_serobar_y 
                    sudong_glass_h =  rth - lot_yysize - f_garonamma_ysize - roh - rfl 
                    opt = rtw - f_serobar_y
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth

                        SQL="Update tk_framekSub  "  '수동에  가로바1, 가로바길게2 ,중간바3 , 롯트바4 , 박스라인21 , 박스라인롯트바22 
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (1 , 2 , 3 , 4 , 21 , 22)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                        
                        SQL="Update tk_framekSub  "  '수동에 세로바
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                Case 13 , 24 , 25 , 32 , 43 , 44 '양개_상부남마 ,좌_양개_상부남마 ,우_양개_상부남마,박스라인 양개_상부남마 ,박스라인 좌_양개_상부남마 ,박스라인 우_양개_상부남마 
                    sudong_door_w = (rtw - f_serobar_y) / 2
                    sudong_door_w = Int(sudong_door_w)'반내림
                    sudong_door_h = roh
                    sudong_glass_w =  rtw - f_serobar_y 
                    sudong_glass_h =  rth - lot_yysize - f_garonamma_ysize - roh - rfl 
                    opt = rtw - f_serobar_y
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth

                        SQL="Update tk_framekSub  "  '수동에  가로바1 ,가로바길게2, 중간바3 , 롯트바4 , 박스라인21 , 박스라인롯트바22 
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (1 , 2 , 3 , 4 , 21 , 22)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                        
                        SQL="Update tk_framekSub  "  '수동에 세로바
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                Case 14 , 26 , 27 , 33 , 45 , 46 '고정창_상부남마 ,좌_고정창_상부남마 ,우_고정창_상부남마,박스라인 고정창_상부남마 ,박스라인 좌_고정창_상부남마 ,박스라인 우_고정창_상부남마  
                    sudong_glass_w = rtw - f_serobar_y
                    sudong_glass_h = roh - sudonghaba_y - rfl 
                    sudong_glass_w2 = rtw - f_serobar_y 
                    sudong_glass_h2 = rth - f_garonamma_ysize - roh - rfl 
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth

                        SQL="Update tk_framekSub  "  '수동에  가로바1, 가로바길게2 , 중간바3 , 롯트바4  , 하바5  , 박스라인21 , 박스라인롯트바22 
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (1 , 2 , 3 , 4 , 5 , 21 , 22)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                        
                        SQL="Update tk_framekSub  "  '수동에 세로바
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                Case 15 , 34 ' 편개_상부남마_중 , 편개_상부남마_중_박스라인
                    sudong_door_w = row
                    sudong_door_h = roh
                    sudong_glass_w = rtw - row - f_serobar_y - f_junggan 
                    sudong_glass_h = roh - sudonghaba_y - rfl 
                    sudong_glass_w2 = rtw - f_serobar_y 
                    sudong_glass_h2 = rth - lot_yysize - f_garonamma_ysize - roh - rfl 
                    sudong_garo = rtw - f_serobar_y
                    sudong_sero = rth
                    sudong_serojungan = roh
                    sudong_habar = rtw - row - f_serobar_y - f_junggan  

                        SQL="Update tk_framekSub  "  '수동에  가로바1, 가로바길게2 , 중간바3 , 롯트바4  , 박스라인21 , 박스라인롯트바22 
                        SQL=SQL&" Set blength='"& sudong_garo &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (1 , 2 , 3 , 4 , 21 , 22)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                        
                        SQL="Update tk_framekSub  "  '수동에 세로바
                        SQL=SQL&" Set blength='"& sudong_sero &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix IN (6, 8, 9, 10)"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                        SQL="Update tk_framekSub  "  '수동에 세로중간통바
                        SQL=SQL&" Set blength='"& sudong_serojungan &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix = 7 "
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                        SQL="Update tk_framekSub  "  '수동에 하바
                        SQL=SQL&" Set blength='"& sudong_habar &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & " AND whichi_fix = 5 "
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)
                    
            End Select

        End If


        Rs.MoveNext
    Loop
End If
Rs.close


'Response.Write "RTW : " & RTW & "<br>"
'Response.Write "rth : " & rth & "<br>"
'Response.Write "row : " & row & "<br>"
'Response.Write "roh : " & roh & "<br>"
'Response.Write "rfl : " & rfl & "<br>"
'Response.Write "f_serobar_y : " & f_serobar_y & "<br>"
'Response.Write "lot_yysize : " & lot_yysize & "<br>"
'Response.Write "sudonghaba_y : " & sudonghaba_y & "<br>"
'Response.Write "f_garonamma_ysize : " & f_garonamma_ysize & "<br>"
'Response.Write "zgreem_fix_type : " & zgreem_fix_type & "<br>"
'Response.Write "sudong_door_w : " & sudong_door_w & "<br>"
'Response.Write "sudong_door_h : " & sudong_door_h & "<br>"
'Response.Write "sudong_glass_w : " & sudong_glass_w & "<br>"
'Response.Write "sudong_glass_h : " & sudong_glass_h & "<br>"
'Response.Write "sudong_glass_w2 : " & sudong_glass_w2 & "<br>"
'Response.Write "sudong_glass_h2 : " & sudong_glass_h2 & "<br>"
'Response.Write "sudong_garo : " & sudong_garo & "<br>"
'Response.Write "sudong_sero : " & sudong_sero & "<br>"
'Response.Write "sudong_serojungan : " & sudong_serojungan & "<br>"
'Response.Write "sudong_habar : " & sudong_habar & "<br>"
'Response.Write "opt반내림 : " & opt & "<br>"
opt = Int(opt)'반내림

If opt_habar = Int(opt_habar) Then '반올림
    opt_habar = opt_habar
Else
    opt_habar = Int(opt_habar) + 1
End If

'Response.Write "opt반내림 : " & opt & "<br>"
'Response.Write "opt_habar반올림 : " & opt_habar & "<br>"

    if  opt > 0  then    
        SQL="Update tk_framekSub  "
        SQL=SQL&" Set xsize='"&opt&"' "
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    end if
    if  opt > 0 then
        sql="update tk_framek set ow='"&opt&"' "
        sql=sql&" where fkidx='"&rfkidx&"' "
        'response.write (SQL)&"owow<br>"
        Dbcon.Execute (SQL)  
    row=opt   
    end if

'=======================================
'오픈추가 끝
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
'가로 세로 오픈 하바 등 계산된 치수 불러오기 시작
'=======================================

'box 박스 / jgan 중간소대 / opt_habar 하바 /  rfl 묻힘
'Response.Write "qgreem_o_type : " & qgreem_o_type & "<br>"
'Response.Write "qth 전체높이: " & qth & "<br>"
'Response.Write "qoh : " & qoh & "<br>"
'Response.Write "box_ysize : " & box_ysize & "<br>"
'Response.Write "door_high 도어높이: " & door_high & "/qth=" & qth & "/box_ysize=" & box_ysize & "/qfl=" & qfl & "<br>"  
'Response.Write "중간소대 : " & qow_single & "<br>"
'Response.Write "FIXGLS_h 픽스유리높이: " & door_high & "/qth=" & qth & "/box_ysize=" & box_ysize & "/qfl=" & qfl & "<br>"  
'Response.Write "qow_single 외도어 가로 : " & qow_single & "<br>"
'Response.Write "qow_double 양개도어 가로 : " & qow_double & "<br>"
'Response.Write "opt_habar 하바 : " & opt_habar & "<br>"
'Response.Write "qfl 묻힘 : " & qfl & "<br>"
'=======================================
'가로 세로 오픈 하바 등 계산된 치수 불러오기 끝
'frameksub에 위치별 길이 값 입력하기 시작
'=======================================
'gls = 0  자재 blength / gls = 1 외도어  door_W ,door_high / gls = 2 양개도어 door_W ,door_high / gls = 3 유리 glass_w ,glass_h

'자동에 길이 업데이트 시작
'----------------------------------------------
if rtw > 0 and rth > 0  then
    SQL="Update tk_framekSub  "  '박스,가로남마 절단
    SQL=SQL&" Set blength='"&box&"' "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    SQL=SQL&" and (whichi_auto=1 or whichi_auto=3)"
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    jgan=door_high + rfl '중간소대 절단

    SQL="Update tk_framekSub  "
    SQL=SQL&" Set blength='"&jgan&"' "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    SQL=SQL&" and whichi_auto=5 "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    sang_jgan=rth - garonamma_ysize - box_yysize - door_high - rfl '상부남마중간소대 절단

    SQL="Update tk_framekSub  "
    SQL=SQL&" Set blength='"&sang_jgan&"' "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    SQL=SQL&" and whichi_auto=4 "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    'opt_habar 하바 절단

    SQL="Update tk_framekSub  "
    SQL=SQL&" Set blength='"&opt_habar&"' "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    SQL=SQL&" and whichi_auto=8 "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    'rth 세로다대바 절단

    SQL="Update tk_framekSub  "
    SQL=SQL&" Set blength='"&rth&"' "
    SQL=SQL&" Where fkidx='"&rfkidx&"' "
    SQL=SQL&" and (whichi_auto=6 or whichi_auto=7 or whichi_auto=10) "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'----------------------------------------------
'자동에 길이 업데이트 끝

'Response.Write "ytw : " & ytw & "<br>"   
'Response.Write "box : " & box & "<br>"   
'Response.Write "rfkidx : " & rfkidx & "<br>"   
'Response.Write "serobar_y : " & serobar_y & "<br>"   

SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.glass_w, a.glass_h, a.gls"
SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
SQL = SQL & " ,c.dwsize1, c.dhsize1, c.dwsize2, c.dhsize2, c.dwsize3, c.dhsize3"
SQL = SQL & " ,c.dwsize4, c.dhsize4, c.dwsize5, c.dhsize5, c.gwsize1, c.ghsize1"
SQL = SQL & " ,c.gwsize2, c.ghsize2, c.gwsize3, c.ghsize3, c.gwsize4, c.ghsize4"
SQL = SQL & " ,c.gwsize5, c.ghsize5, c.gwsize6, c.ghsize6"
SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
SQL = SQL & " from tk_framekSub a"
SQL = SQL & " left outer join tk_framek b on a.fkidx = b.fkidx"
SQL = SQL & " left outer join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO"
SQL=SQL&" Where a.fkidx='"&rfkidx&"' "
Rs.open SQL, Dbcon
If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF

    zWHICHI_AUTO  = rs(0) ' 자동 도어/유리 타입
    zWHICHI_FIX   = rs(1)
    zdoor_w       = rs(2)
    zdoor_h       = rs(3)
    zglass_w      = rs(4)
    zglass_h      = rs(5)
    zgls          = rs(6)
    zsjb_idx      = rs(7)
    zsjb_type_no  = rs(8)  ' 제품 타입 번호 (10이면 슬라이딩)
    zdwsize1      = rs(9)  ' 외도어제작 가로 whichi_auto = 12 whichi_fix = 12 
    zdhsize1      = rs(10) ' 외도어제작 세로 whichi_auto = 12 whichi_fix = 12
    zdwsize2      = rs(11) ' 양개도어제작 가로 whichi_auto = 13 whichi_fix = 13
    zdhsize2      = rs(12) ' 양개도어제작 세로 whichi_auto = 13 whichi_fix = 13
    zdwsize3      = rs(13)
    zdhsize3      = rs(14)
    zdwsize4      = rs(15)
    zdhsize4      = rs(16)
    zdwsize5      = rs(17)
    zdhsize5      = rs(18)
    zgwsize1      = rs(19) ' 하부픽스유리 가로 whichi_auto = 14,15
    zghsize1      = rs(20) ' 하부픽스유리 세로 whichi_auto = 14,15
    zgwsize2      = rs(21) ' 박스라인일 경우 하부픽스유리 가로
    zghsize2      = rs(22) ' 박스라인일 경우 하부픽스유리 세로
    zgwsize3      = rs(23) ' 상부남마 픽스 가로 whichi_auto = 16,17,18
    zghsize3      = rs(24) ' 상부남마 픽스 세로 whichi_auto = 16,17,18
    zgwsize4      = rs(25)
    zghsize4      = rs(26)
    zgwsize5      = rs(27)
    zghsize5      = rs(28)
    zgwsize6      = rs(29)
    zghsize6      = rs(30)
    zfksidx        = rs(31)
    zgreem_o_type  = rs(32) ' 추가된 항목
    zGREEM_BASIC_TYPE  = rs(33) ' 홈 유무 (1~4)
    zgreem_fix_type = rs(34) ' 수동도어 타입 (9~15)
 
    ' --- 계산용 변수 초기화 ---
        door_w = ""
        door_h = ""
        glass_w = ""
        glass_h = ""
'Response.Write "zWHICHI_AUTO : " & zWHICHI_AUTO & "<br>"
'Response.Write "WHICHI_AUTO : " & WHICHI_AUTO & "<br>"
'Response.Write "zWHICHI_FIX : " & zWHICHI_FIX & "<br>"
'Response.Write "zgreem_o_type : " & zgreem_o_type & "<br>"
'Response.Write "zdoor_w : " & zdoor_w & "<br>"
'Response.Write "zdoor_h : " & zdoor_h & "<br>"
'Response.Write "zglass_w : " & zglass_w & "<br>"
'Response.Write "zglass_h : " & zglass_h & "<br>"
'Response.Write "zgls : " & zgls & "<br>"
'Response.Write "zsjb_idx : " & zsjb_idx & "<br>"
'Response.Write "zsjb_type_no : " & zsjb_type_no & "<br>"
'Response.Write "zdwsize1 : " & zdwsize1 & "<br>"
'Response.Write "zdhsize1 : " & zdhsize1 & "<br>"
'Response.Write "zdwsize2 : " & zdwsize2 & "<br>"
'Response.Write "zdhsize2 : " & zdhsize2 & "<br>"
'Response.Write "zgwsize1 : " & zgwsize1 & "<br>"
'Response.Write "zghsize1 : " & zghsize1 & "<br>"
'Response.Write "zgwsize2 : " & zgwsize2 & "<br>"
'Response.Write "zghsize2 : " & zghsize2 & "<br>"
'Response.Write "zgwsize3 : " & zgwsize3 & "<br>"
'Response.Write "zghsize3 : " & zghsize3 & "<br>"
'Response.Write "zfksidx : " & zfksidx & "<br>"
    Select Case zgreem_o_type
        Case 1, 2, 3  ' ☑ 편개 그룹 (기본/슬라이딩/남마 등)
                Select Case zWHICHI_AUTO
                    Case 12  ' ➤ 외도어 도어 계산
                        If zGREEM_BASIC_TYPE = 1 Or zGREEM_BASIC_TYPE = 3 Then ' 홈 있음
                            If zsjb_type_no = 10 Then
                                door_w = (row + junggan + junggan + zdwsize1) / 2  '이중슬라이딩 자동홈값 ex 15
                            Else
                                door_w = row + junggan + zdwsize1                 '자동홈값 ex 15
                                'Response.Write "door_w111 : " & door_w & "<br>"
                                'Response.Write "junggan : " & junggan & "<br>"
                                'Response.Write "row : " & row & "<br>"
                                'Response.Write "zdwsize1 : " & zdwsize1 & "<br>"
                            End If
                        ElseIf zGREEM_BASIC_TYPE = 2 Or zGREEM_BASIC_TYPE = 4 Then ' 홈 없음
                            If zsjb_type_no = 10 Then
                                door_w = (row + junggan + junggan) / 2
                            Else
                                door_w = row + junggan
                            End If
                        End If
                        door_h = door_high + zdhsize1
                    Case 14  ' ➤ 하부 픽스 유리
                        glass_w = opt_habar + zgwsize1
                        glass_h = door_high - jadonghaba_y + zghsize1
                    Case 16  ' ➤ 상부 픽스 유리 (왼쪽)
                        If zgreem_o_type = 2 Then
                            glass_w = box + zgwsize3
                        Else
                            glass_w = opt_habar + zgwsize3
                        End If
                        glass_h = sang_jgan + zghsize3
                    Case 17  ' ➤ 상부 픽스 유리 (중앙 또는 오른쪽)
                        If zgreem_o_type = 3 Then
                            glass_w = row + zgwsize3
                        Else
                            glass_w = opt_habar + zgwsize3
                        End If
                        glass_h = sang_jgan + zghsize3

                End Select
        Case 4, 5, 6  ' ☑ 양개 그룹
                Select Case zWHICHI_AUTO

                    Case 13  ' ➤ 양개 도어
                        If zsjb_type_no = 10 Then
                            door_w = ((row / 2) + junggan + junggan) / 2  ' 이중슬라이딩
                            door_h = door_high + zdhsize1
                        Else
                            door_w = Int((row + junggan + junggan) / 2)   ' 일반 양개
                            door_h = door_high + zdhsize2
                        End If

                    Case 14, 15  ' ➤ 하부 픽스 유리 (공통)
                        glass_w = opt_habar + zgwsize1
                        glass_h = door_high - jadonghaba_y + zghsize1

                    Case 16, 18  ' ➤ 상부 픽스 유리 (opt_habar 기준)
                        glass_w = opt_habar + zgwsize3
                        glass_h = sang_jgan + zghsize3

                    Case 17      ' ➤ 상부 픽스 유리 중앙
                        glass_w = row + zgwsize3
                        glass_h = sang_jgan + zghsize3

                End Select

        End Select

        ' ===================== 도어 유형 분기 끝 =====================

    If zsjb_type_no = 6 Or zsjb_type_no = 7 Or zsjb_type_no = 11 Or zsjb_type_no = 12 Then '수동도어 계산

            Select Case zgreem_fix_type
                Case 9 , 16 , 17 , 28 , 35 , 36 ' 편개 ,좌_편개 ,우_편개,박스라인 편개 ,박스라인 좌_편개 ,박스라인 우_편개 
                    if zWHICHI_FIX = 12 then   '➤ 외도어 도어 계산
                        door_w = sudong_door_w 
                        door_h = sudong_door_h + zdhsize1
                    end if
                Case 10 , 18 , 19 , 29 , 37 , 38 ' 양개 ,좌_양개 ,우_양개,박스라인 양개 ,박스라인 좌_양개 ,박스라인 우_양개 
                    if zWHICHI_FIX = 13 then   '➤ 양개 도어 계산
                        door_w = sudong_door_w 
                        door_h = sudong_door_h + zdhsize2
                    end if
                Case 11 , 20 , 21 , 30 , 39 , 40  '고정창 ,좌_고정창 ,우_고정창,박스라인 고정창 ,박스라인 좌_고정창 ,박스라인 우_고정창 
                    if zWHICHI_FIX = 14 then   '➤ 하부 픽스 유리
                        glass_w = sudong_glass_w + zgwsize1
                        glass_h = sudong_glass_h + zghsize1
                    elseif zWHICHI_FIX = 19 then   '➤ 박스라인 하부 픽스 유리
                        glass_w = sudong_glass_w + zgwsize2
                        glass_h = sudong_glass_h + zghsize2
                    end if
                Case 12 , 22 , 23 , 31 , 41 , 42   '편개_상부남마 ,좌_편개_상부남마 ,우_편개_상부남마,박스라인 편개_상부남마 ,박스라인 좌_편개_상부남마 ,박스라인 우_편개_상부남마 
                    if zWHICHI_FIX = 12 then   '➤ 외도어 도어 계산
                        door_w = sudong_door_w 
                        door_h = sudong_door_h + zdhsize1
                    end if
                    if zWHICHI_FIX = 16 Or zWHICHI_FIX = 23 then  ' ➤ 상부 픽스 유리 16 박스라인 상부 픽스 유리 23
                        glass_w =  sudong_glass_w + zgwsize3
                        glass_h =  sudong_glass_h + zghsize3
                    end if  
                Case 13 , 24 , 25 , 32 , 43 , 44 '양개_상부남마 ,좌_양개_상부남마 ,우_양개_상부남마,박스라인 양개_상부남마 ,박스라인 좌_양개_상부남마 ,박스라인 우_양개_상부남마
                    if zWHICHI_FIX = 13 then   '➤ 양개 도어 계산
                        door_w = sudong_door_w 
                        door_h = sudong_door_h + zdhsize2
                    end if
                    if zWHICHI_FIX = 16 Or zWHICHI_FIX = 23 then  ' ➤ 상부 픽스 유리 16 박스라인 상부 픽스 유리 23
                        glass_w =  sudong_glass_w + zgwsize3
                        glass_h =  sudong_glass_h + zghsize3
                    end if 

                Case 14 , 26 , 27 , 33 , 45 , 46 '고정창_상부남마 ,좌_고정창_상부남마 ,우_고정창_상부남마,박스라인 고정창_상부남마 ,박스라인 좌_고정창_상부남마 ,박스라인 우_고정창_상부남마
                    if zWHICHI_FIX = 14 then   '➤ 하부 픽스 유리
                        glass_w = sudong_glass_w + zgwsize1
                        glass_h = sudong_glass_h + zghsize1
                    elseif zWHICHI_FIX = 19 then   '➤ 박스라인 하부 픽스 유리
                        glass_w = sudong_glass_w + zgwsize2
                        glass_h = sudong_glass_h + zghsize2
                    end if
                    if zWHICHI_FIX = 16 Or zWHICHI_FIX = 23 then  ' ➤ 상부 픽스 유리 16 박스라인 상부 픽스 유리 23
                        glass_w =  sudong_glass_w2 + zgwsize3
                        glass_h =  sudong_glass_h2 + zghsize3
                    end if 
                        
                Case 15 , 34 ' 편개_상부남마_중 , 편개_상부남마_중_박스라인
                    if zWHICHI_FIX = 12 then   '➤ 외도어 도어 계산
                        door_w = sudong_door_w 
                        door_h = sudong_door_h + zdhsize1
                    end if
                    if zWHICHI_FIX = 14 then   '➤ 하부 픽스 유리
                        glass_w = sudong_glass_w + zgwsize1
                        glass_h = sudong_glass_h + zghsize1
                    elseif zWHICHI_FIX = 19 then   '➤ 박스라인 하부 픽스 유리
                        glass_w = sudong_glass_w + zgwsize2
                        glass_h = sudong_glass_h + zghsize2
                    end if
                    if zWHICHI_FIX = 16 Or zWHICHI_FIX = 23 then  ' ➤ 상부 픽스 유리 16 박스라인 상부 픽스 유리 23
                        glass_w =  sudong_glass_w2 + zgwsize3
                        glass_h =  sudong_glass_h2 + zghsize3
                    end if 

            End Select

        End If

        ' ===================== DB 업데이트 =====================
        If IsNumeric(door_w) And IsNumeric(door_h) Then
            SQL = "UPDATE tk_framekSub SET door_w='" & door_w & "', door_h='" & door_h & "' WHERE fksidx='" & zfksidx & "'"
            'Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL
        End If

        If IsNumeric(glass_w) And IsNumeric(glass_h) Then
            SQL = "UPDATE tk_framekSub SET glass_w='" & glass_w & "', glass_h='" & glass_h & "' WHERE fksidx='" & zfksidx & "'"
            'Response.write (SQL)&"<br><br>"
            Dbcon.Execute SQL
        End If

        Rs.MoveNext
    Loop
End If
Rs.Close

end if             '<------------------------전체 외경 가로 세로가 있을떄만 업데이트 하기 end if
'Response.Write "zfskidx : " & zfskidx & "<br>"
'Response.Write "zgreem_o_type : " & zgreem_o_type & "<br>"
'Response.Write "zGREEM_BASIC_TYPE : " & zGREEM_BASIC_TYPE & "<br>"
'=======================================
'frameksub에 위치별 길이 값 입력하기 끝
'프레임의 길이정보 입력 끝 



'바 추가 복제하기 시작
'===================
if rafksidx<>"" then 
  '증가된 높이 찾기 시작
  SQL=" select distinct yi ,hi From tk_frameksub where fksidx in ("&rafksidx&") "
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
  Do while not Rs1.EOF
    ayi=Rs1(0)
    ahi=Rs1(1)
    sahi=ahi+sahi
  Rs1.movenext
  Loop
  End if
  Rs1.close
  '증가된 높이 찾기 끝
  'Response.write sahi&"<br><br>"

  '바추가 하기 시작
  SQL=" Select fsidx, fidx, xi, yi, wi, hi, imsi, whichi_fix, whichi_auto, bfidx,fkidx  "
  SQL=SQL&" From tk_frameksub "
  SQL=SQL&" where fksidx in ("&rafksidx&") "
  'Response.write (SQL)&"<br><br>"
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
  Do while not Rs1.EOF
    fsidx=Rs1(0)
    fidx=Rs1(1)
    xi=Rs1(2)
    yi=Rs1(3)
    wi=Rs1(4)
    hi=Rs1(5)
    imsi=Rs1(6)
    whichi_fix=Rs1(7)
    whichi_auto=Rs1(8)
    bfidx=Rs1(9)
    fkidx=Rs1(10)


    yi=yi-sahi

    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fsidx&"', '"&fidx&"', '"&xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"') "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

  Rs1.movenext
  Loop
  End if
  Rs1.close
  '바추가하기 끝

  '가장 상단의 바와 위치가 같은 바들의 위치를 높이고 길이를 늘리기 시작
  SQL="Select min(yi) from tk_frameksub where fksidx in ("&rafksidx&") "
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
    ayi=Rs1(0)  '선택된 바중 가장 상단 바의 y좌표값
  End if
  Rs1.Close

  SQL=" Select fksidx, yi, hi from tk_frameksub where fkidx='"&fkidx&"' and yi='"&ayi&"' and fksidx not in ("&rafksidx&") "
  'Response.write (SQL)&"<br><br>"
  Rs1.open Sql,Dbcon
  If Not (Rs1.bof or Rs1.eof) Then 
  Do while not Rs1.EOF
    fksidx=Rs1(0)
    yi=Rs1(1)
    hi=Rs1(2)

    chg_yi=yi-sahi
    chg_hi=hi+sahi

    SQL="Update tk_frameksub set yi='"&chg_yi&"', hi='"&chg_hi&"' Where fksidx='"&fksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
  Rs1.movenext
  Loop
  End if
  Rs1.close
  '가장 상단의 바와 위치가 같은 바들의 위치를 높이고 길이를 늘리기 끝

  '유리추가하기 시작

  '유리추가하기 끝

  response.write "<script>location.replace('TNG1_B_suju.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"')</script>"
end if
'===================
'바 추가 복제하기 끝
'개별 바의 길이 입력시작
'===================
If mode= "kblength" Then
    SQL="Update tk_framekSub  "  
    SQL=SQL&" Set blength='"&kblength&"' "
    SQL=SQL&" Where fksidx='"&rfksidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'===================
'개별 바의 길이 입력끝

'바의 길이 입력하면 단가===================와 할증 그리고 가격 입력하기 시작
'=========================================================
If rfkidx<>"" Then 
'Response.Write "rfkidx : " & rfkidx & "<br>"
    SQL="select A.fksidx "
    SQL=SQL&" , A.bfidx, B.pcent "
    SQL=SQL&" , A.blength, A.unitprice, A.sprice, A.whichi_fix, A.whichi_auto "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
    SQL=SQL&" and A.whichi_fix not in (12,13,14,15,16,17,18,19,23,24,25 ) "
    SQL=SQL&" and A.whichi_auto not in (12,13,14,15,16,17,18,19,20,21,22,23 ) "
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

        If bwhichi_fix > 0 Then
            SQL1="Select unittype_bfwidx from tng_whichitype where whichi_fix='"&bwhichi_fix&"'" 
        ElseIf bwhichi_auto > 0 Then
            SQL1="Select unittype_bfwidx from tng_whichitype where whichi_auto='"&bwhichi_auto&"'" 
        End If    
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
        SQL = SQL & "AND (B.sheet_t = 0 OR B.sheet_h >= '" & bblength & "') "
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
            'Response.Write "unitprice : " & unitprice & "<br>"
            'Response.Write "bpcent : " & bpcent & "<br>"  
            'Response.Write "bblength : " & bblength & "<br>"  
            'Response.Write "rpidx : " & rpidx & "<br>"  
            'Response.Write "rqtyidx : " & rqtyidx & "<br>"  
            If IsNumeric(rpidx) Then
                if rpidx > 0 and rqtyidx = 1 then '도장비 추가 ' 추후 3코딩 추가해야함 rpidx로 구분
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
            SQL="Update tk_framekSub  "
            SQL=SQL&" Set unitprice='"&unitprice&"', pcent='"&bpcent&"', sprice='"&sprice&"' "
            SQL=SQL&" Where fksidx='"&bfksidx&"' "  'bfksidx<---------------
            'Response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)
                    
    Rs.MoveNext
    Loop
    End If
    Rs.close

        '=================제품 가격 입력 시작
        If mode = "alprice" Then
            SQL = "SELECT fidx,tw,th,greem_o_type from tk_framek where fkidx = '" & rfkidx & "' "
            'Response.write (SQL)&"<br>"
            'response.end
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then
                yfidx=rs1(0)
                ytw=rs1(1)
                yth=rs1(2)
                ygreem_o_type=rs1(3)
            End If
            Rs1.Close '2

            ' 설정 품목 가격 등록 
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
                        sjsprice = price_etl
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
                py_size2= Int(py_size2) + 1 ' 소수점 제거

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

        else

            'Response.Write "rsjsidx : " & rsjsidx & "<br>"   
            ' 설정 품목 가격 등록 --------------------tk_framekSub 합계금액인데 부속자재는 뺴고
            SQL = "SELECT SUM(sprice) "
            SQL = SQL & "FROM tk_framekSub "
            SQL = SQL & "WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE fkidx='" & rfkidx & "') "
            SQL = SQL & "AND busok = 0 "
            'Response.write (SQL)&"<br>"
            Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    sjsprice=Rs1(0)
                    'response.write "단가:"&unitprice&"<br>"
                End If
                Rs1.Close'1
        
        End If
        
            
            '~~~~~~~~~~~~~부속자재 업데이트 시작  재료분리대는 busok=1 보양재는 busok=2 로비폰은 busok=3 
            ' busoktype  0삭제 1=재분 2=재분갈바보강 3=보양 4=로비폰
            rjaebun=Request("jaebun") ' 1 재분 2재분보강 0삭제
            rbusok=Request("busok") ' 1 재분 2재분보강 0삭제
            rbusoktype=Request("busoktype") ' 1 재분 2재분보강 0삭제

            'Response.Write "rjaebun 재료분리대: " & jaebun & "<br>" 
            'Response.Write "rbusok : " & rbusok & "<br>"
            'Response.Write "rbusoktype : " & rbusoktype & "<br>"
            'Response.Write "mode : " & mode & "<br>"
            If mode1 = "jaebun" Then
                SQL = "SELECT sjb_type_no,greem_o_type,fl,ow from tk_framek where fkidx = '" & rfkidx & "' "
                'Response.write (SQL)&"<br>"
                'response.end
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then
                    qsjb_type_no=rs1(0)
                    qgreem_o_type=rs1(1) 
                    qfl=rs1(2) ' 묻힘값
                    qow=rs1(3) '오픈 
                End If
                Rs1.Close '2
                'Response.Write "qsjb_type_no : " & qsjb_type_no & "<br>"
                'Response.Write "qgreem_o_type : " & qgreem_o_type & "<br>"
                if rjaebun = 1 or rjaebun = 2 then
                    Select Case qsjb_type_no
                        Case 1, 2:         sch_xsize = 43
                        Case 3, 4:         sch_xsize = 53
                        Case 5:            sch_xsize = 34
                        Case 8, 10, 15:    sch_xsize = 51
                        Case 9:            sch_xsize = 63
                        Case Else:         sch_xsize = 0
                    End Select
                    sch_ysize = qfl ' 묻힘값
                    If sch_xsize > 0 Then
                        ' 조건에 따라 갈바보강 포함 여부로 bfidx 조회
                        If rjaebun = 1 Then
                            SQL = "SELECT  bfidx FROM tk_barasiF WHERE sjb_idx=128 AND xsize=" & sch_xsize & _
                                " AND ysize=" & sch_ysize & " AND set_name_AUTO NOT LIKE '%갈바보강%'"
                                'Response.Write SQL & "<br>"
                        ElseIf rjaebun = 2 Then
                            SQL = "SELECT  bfidx FROM tk_barasiF WHERE sjb_idx=128 AND xsize=" & sch_xsize & _
                                " AND ysize=" & sch_ysize & " AND set_name_AUTO LIKE '%갈바보강%'"
                                'Response.Write SQL & "<br>"
                        End If
                        Response.Write SQL & "<br>"
                        rs1.Open SQL, Dbcon
                        If Not (rs1.BOF Or rs1.EOF) Then
                            bfidx_val = rs1(0)
                            'Response.Write "bfidx_val : " & bfidx_val & "<br>"
                            ' 단가 결정
                            If qow > 0 And qow <= 1250 Then
                                If rjaebun = 2 Then
                                    unitprice_jaebun = 20000
                                Else
                                    unitprice_jaebun = 15000
                                End If
                            ElseIf qow > 1250 Then
                                If rjaebun = 2 Then
                                    unitprice_jaebun = 25000
                                Else
                                    unitprice_jaebun = 20000
                                End If
                            End If
                            'Response.Write "unitprice_jaebun : " & unitprice_jaebun & "<br>"
                                ' ➤ 12,13 바 기준 좌표 찾아서 xi, yi, wi, hi 값 세팅
                                SQL = "SELECT xi, yi, wi, hi, whichi_fix, whichi_auto FROM tk_framekSub "
                                SQL = SQL & "WHERE fkidx='" & rfkidx & "' AND (whichi_fix IN (12,13) OR whichi_auto IN (12,13))"
                                rs2.Open SQL, Dbcon
                                'Response.Write SQL & "<br>"
                                If Not (rs2.BOF Or rs2.EOF) Then
                                    xi = rs2(0)
                                    yi = rs2(1) 
                                    wi = rs2(2)
                                    hi = rs2(3)
                                    zfix = rs2(4)
                                    zauto = rs2(5)
                                    If qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3  Then '편개
                                        wi = wi 
                                    Else
                                        xi = 410
                                        wi = wi + 90
                                    End If

                                    If qgreem_o_type = 1 Or qgreem_o_type = 4 Then
                                        yi = yi + 240
                                    Else
                                        yi = yi + 190
                                    End If
                                    hi = 10 ' 높이는 10으로 고정

                                    ' ➤ 삽입할 whichi 값 결정
                                    If zfix <> 0 And zauto = 0 Then
                                        whichi_fix_val = 24
                                        whichi_auto_val = 0
                                    ElseIf zfix = 0 And zauto <> 0 Then
                                        whichi_fix_val = 0
                                        whichi_auto_val = 21
                                    Else
                                        whichi_fix_val = 0
                                        whichi_auto_val = 0
                                    End If
                                        ' count
                                        SQL="select count(busok) from tk_framekSub where fkidx = '" & rfkidx & "'  and busok = 1 "
                                        rs3.Open SQL, Dbcon
                                        'Response.Write SQL & "<br>"
                                        If Not (rs3.BOF Or rs3.EOF) Then
                                            count_jaebun = rs3(0) ' busok = 1 인 경우     
                                        End If
                                        rs3.Close 
                                            'Response.Write "count_jaebun : " & count_jaebun & "<br>"
                                            if count_jaebun=0 then
                                                SQL = "INSERT INTO tk_framekSub (fkidx, whichi_fix, whichi_auto, bfidx, blength, unitprice, xi, yi, wi, hi,busok,busoktype ) "
                                                SQL = SQL & "VALUES ('" & rfkidx & "', '" & whichi_fix_val & "', '" & whichi_auto_val & "', '" & bfidx_val & "' "
                                                SQL = SQL & ", '" & row & "' , '" & unitprice_jaebun & "', '" & xi & "', '" & yi & "' "
                                                SQL = SQL & ", '" & wi & "', '" & hi & "', '" & rbusok & "', '" & rbusoktype & "' )"
                                                Response.Write SQL & "11111<br>"
                                                Dbcon.Execute SQL
                                            ElseIf count_jaebun = 1 Then
                                                SQL = "UPDATE tk_framekSub SET "
                                                SQL = SQL & "whichi_fix = '" & whichi_fix_val & "', "
                                                SQL = SQL & "whichi_auto = '" & whichi_auto_val & "', "
                                                SQL = SQL & "bfidx = '" & bfidx_val & "', "
                                                SQL = SQL & "blength = '" & row & "', "
                                                SQL = SQL & "unitprice = '" & unitprice_jaebun & "', "
                                                SQL = SQL & "xi = '" & xi & "', "
                                                SQL = SQL & "yi = '" & yi & "', "
                                                SQL = SQL & "wi = '" & wi & "', "
                                                SQL = SQL & "hi = '" & hi & "', "
                                                SQL = SQL & "busoktype = '" & rbusoktype & "', "
                                                SQL = SQL & "busok = '" & rbusok & "' "
                                                SQL = SQL & "WHERE fkidx = '" & rfkidx & "' AND whichi_fix = '" & whichi_fix_val & "' AND whichi_auto = '" & whichi_auto_val & "' and busok = 1 "
                                                Response.Write SQL & "11111<br>"
                                                Dbcon.Execute SQL
                                            End If
                                End If
                                rs2.Close
                        End If
                        rs1.Close
                    SQL = "SELECT unitprice " ' 설정 품목 가격 등록 --------------------tk_framekSub 합계금액인데 재분만 합계
                    SQL = SQL & "FROM tk_framekSub "
                    SQL = SQL & "WHERE fkidx ='" & rfkidx & "' "
                    SQL = SQL & "AND busoktype ='" & rbusoktype & "' "
                    'Response.write (SQL)&"<br>"
                    Rs1.open Sql,Dbcon
                        If Not (Rs1.bof or Rs1.eof) Then 
                            jaebun_sjsprice=Rs1(0)
                            'Response.Write "jaebun_sjsprice : " & jaebun_sjsprice & "<br>" 
                        End If
                    Rs1.Close'1
                    SQL="Update tk_framek set jaeryobunridae='"&jaebun_sjsprice&"' "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' "
                    'Response.write (SQL)&"<br>"
                    'response.end
                    Dbcon.Execute (SQL)    
                    End If
                ElseIf rbusoktype = "0"  Then
                    ' ✅ DELETE
                    SQL = "DELETE FROM tk_framekSub WHERE fkidx = '" & rfkidx & "' AND busok = 1 "
                    'Response.Write SQL & "<br>"
                    Dbcon.Execute SQL

                    SQL="Update tk_framek set jaeryobunridae=0 "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' "
                    'Response.write (SQL)&"<br>"
                    'response.end
                    Dbcon.Execute (SQL)    

                End If
            End If
            '-------------------보양 시작
                rboyang=Request("boyang")
                If IsNull(rboyang)  = "" Then 
                rboyang = 0
                End If
            If mode3 = "boyang" Then
                SQL = "SELECT sjb_type_no,greem_o_type,fl,ow from tk_framek where fkidx = '" & rfkidx & "' "
                'Response.write (SQL)&"<br>"
                'response.end
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then
                    esjb_type_no=rs1(0)
                    egreem_o_type=rs1(1) 
                    efl=rs1(2) ' 묻힘값
                    eow=rs1(3) '오픈 
                End If
                Rs1.Close '2
                'Response.Write "rboyang 갈바보양: " & rboyang & "<br>" 
                'Response.Write "esjb_type_no : " & esjb_type_no & "<br>"
                'Response.Write "eow : " & qow_single & "<br>"
                'Response.Write "qow_double : " & qow_double & "<br>"
                if rboyang = 1  then
                    If egreem_o_type = 1 Or egreem_o_type = 2 Or egreem_o_type = 3  Then '편개
                        boyangdoor = "single"
                    Else 
                        boyangdoor = "double"
                    End If

                    If boyangdoor = "single" Then
                        Select Case esjb_type_no
                            Case 1, 2
                                boyang1 = 1
                                boyang2 = 2
                                boyang3 = 3
                            Case 3, 4
                                boyang1 = 4
                                boyang2 = 5
                                boyang3 = 6
                            Case 5
                                boyang1 = 7
                                boyang2 = 8
                                boyang3 = 9
                            Case 8, 10, 15
                                boyang1 = 10
                                boyang2 = 11
                                boyang3 = 12
                            Case 9
                                boyang1 = 13
                                boyang2 = 14
                                boyang3 = 15
                        End Select
                    Else
                        Select Case esjb_type_no
                            Case 1, 2
                                boyang1 = 1
                                boyang2 = 1
                                boyang3 = 3
                            Case 3, 4
                                boyang1 = 4
                                boyang2 = 4
                                boyang3 = 6
                            Case 5
                                boyang1 = 7
                                boyang2 = 7
                                boyang3 = 9
                            Case 8, 10, 15
                                boyang1 = 10
                                boyang2 = 10
                                boyang3 = 12
                            Case 9
                                boyang1 = 13
                                boyang2 = 13
                                boyang3 = 15
                        End Select
                    End If


                    'Response.Write "boyang1 : " & boyang1 & "<br>"
                    'Response.Write "boyang2 : " & boyang2 & "<br>"
                    'Response.Write "boyang3 : " & boyang3 & "<br>"
                    ' 조건에 따라 갈바보강 포함 여부로 bfidx 조회
                    For i = 1 To 3
                        If i = 1 Then bval = boyang1
                        If i = 2 Then bval = boyang2
                        If i = 3 Then bval = boyang3

                        SQL = "SELECT bfidx FROM tk_barasiF WHERE sjb_idx=128 AND boyang=" & bval & " "
                        'Response.Write SQL & "<br>"
                        rs1.Open SQL, Dbcon
                        If Not (rs1.BOF Or rs1.EOF) Then
                            Do While Not rs1.EOF
                                bfidx_boyang = rs1(0)

                                ' 단가 결정
                                Select Case bval
                                    Case 1, 4, 7, 10, 13
                                        unitprice_boyang = 10000
                                        bfidx_blength = 1800
                                    Case 2, 5, 8, 11, 14
                                        unitprice_boyang = 10000
                                        bfidx_blength = 1800
                                    Case 3, 6, 9, 12, 15
                                        unitprice_boyang = 10000
                                        bfidx_blength = row - 10
                                End Select

                                ' count
                                SQL = "SELECT COUNT(*) FROM tk_framekSub WHERE fkidx = '" & rfkidx & "' AND whichi_auto = 22 AND busok = 2 AND bfidx = " & bfidx_boyang & " " '보양은 busok 2
                                rs3.Open SQL, Dbcon
                                'Response.Write SQL & "<br>"
                                If Not (rs3.BOF Or rs3.EOF) Then
                                    count_boyang = rs3(0) ' busok = 1 인 경우     
                                End If
                                rs3.Close 
                                'Response.Write "count_boyang : " & count_boyang & "<br>"
                                    if  count_boyang = 0 or count_boyang = 1 or count_boyang = 2 then
                                        SQL = "INSERT INTO tk_framekSub (fkidx, whichi_fix, whichi_auto, bfidx, blength, unitprice, busok , busoktype) "
                                        SQL = SQL & "VALUES ('" & rfkidx & "', 0, 22, " & bfidx_boyang & ", " & bfidx_blength & ", " & unitprice_boyang & ", " & rbusok & ", " & rbusoktype & " )"
                                        'Response.Write SQL & "11111<br>"
                                        Dbcon.Execute SQL
                                    Elseif count_boyang = 3 then 
                                        SQL = "UPDATE tk_framekSub SET "
                                        SQL = SQL & "whichi_fix = 0 , "
                                        SQL = SQL & "whichi_auto =  22 , "
                                        SQL = SQL & "bfidx = '" & bfidx_boyang & "', "
                                        SQL = SQL & "blength = '" & bfidx_blength & "', "
                                        SQL = SQL & "unitprice = '" & unitprice_boyang & "', "
                                        SQL = SQL & "busoktype = '" & rbusoktype & "', "
                                        SQL = SQL & "busok = '" & rbusok & "' "
                                        SQL = SQL & "WHERE fkidx = '" & rfkidx & "' AND whichi_fix = 0 AND whichi_auto = 22 and busok = 2 "
                                        'Response.Write SQL & "11111<br>"
                                        Dbcon.Execute SQL
                                    End If

                            rs1.MoveNext
                            Loop
                        End If
                        Rs1.Close
                    Next
                    SQL = "SELECT SUM(unitprice) "
                    SQL = SQL & "FROM tk_framekSub "
                    SQL = SQL & "WHERE fkidx ='" & rfkidx & "' "
                    SQL = SQL & "AND busoktype ='" & rbusoktype & "' "
                    'Response.write (SQL)&"<br>"
                    Rs1.open Sql,Dbcon
                        If Not (Rs1.bof or Rs1.eof) Then 
                            boyang_sjsprice=Rs1(0)
                        'Response.Write "boyang_sjsprice : " & boyang_sjsprice & "<br>"   
                        End If
                    Rs1.Close'1
                    SQL="Update tk_framek set boyangjea='"&boyang_sjsprice&"' "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' "
                    'Response.write (SQL)&"<br>"
                    'response.end
                    Dbcon.Execute (SQL)
                ElseIf rbusoktype = "0" Then
                    ' ✅ DELETE
                    SQL = "DELETE FROM tk_framekSub WHERE fkidx = '" & rfkidx & "' AND busok = 2 "
                    'Response.Write SQL & "<br>"
                    Dbcon.Execute SQL

                    SQL="Update tk_framek set boyangjea=0 "
                    SQL=SQL&" Where fkidx='"&rfkidx&"' "
                    'Response.write (SQL)&"<br>"
                    'response.end
                    Dbcon.Execute (SQL)
                End If
            End If
            '~~~~~~~~~~~~~~~~~~로비폰시작
            rrobby=Request("robby")
            If IsNull(rrobby)  = "" Then 
            rrobby = 0
            End If
            If mode4 = "robby" Then
                Response.Write "rrobby 로비폰박스: " & rrobby & "<br>" 
            
                ' 설정 품목 가격 등록 --------------------tk_framekSub 합계금액인데 로비폰만 합계
                SQL = "SELECT SUM(unitprice) "
                SQL = SQL & "FROM tk_framekSub "
                SQL = SQL & "WHERE fkidx='" & rfkidx & "' "
                SQL = SQL & "AND busok = 3 "
                'Response.write (SQL)&"<br>"
                Rs1.open Sql,Dbcon
                    If Not (Rs1.bof or Rs1.eof) Then 
                        robby_sjsprice=Rs1(0)
                        'Response.Write "robby_sjsprice : " & robby_sjsprice & "<br>"  
                    End If
                Rs1.Close'1
                SQL="Update tk_framek set robby_box='"&robby_sjsprice&"' "
                SQL=SQL&" Where fkidx='"&rfkidx&"' "
                'Response.write (SQL)&"<br>"
                'response.end
                Dbcon.Execute (SQL)
            End If
    '~~~~~~~~~~~~~부속자재 업데이트 끝

        if sprice = 0  or isnull(sprice) then
            sprice = 0    
        end if
        if disprice = 0  or isnull(disprice) then
            disprice = 0    
        end if
        if taxrate = 0  or isnull(taxrate) then
            taxrate = 0    
        end if
        'sjsprice는 모든 추가금이 합산된 최종금액. 새로운 컬럼 (평당추가건 py_chuga) 
        sjsprice= sjsprice + py_chuga                '품목의 산출 가격
        sjsprice = -Int(-sjsprice / 1000) * 1000 '무조건 천 단위로 올림
        disrate=0                         '할인율

        disprice=0                        '할인금액
        disprice = -Int(-disprice / 1000) * 1000 '무조건 천 단위로 올림
        fprice=sjsprice-disprice          '납품금액

        taxrate=fprice * 0.1                        '세액
        if taxrate < 0 then
            taxrate=round(taxrate)
        end if

        sprice=(fprice+taxrate) * rquan  '최종금액
        if sprice = 0  or isnull(sprice) then
            sprice = 0  
        end if

        
        'Response.Write "sjsprice : " & sjsprice & "<br>"   
        'Response.Write "sprice : " & sprice & "<br>"   
        'Response.Write "taxrate : " & taxrate & "<br>"  
        '===============화면에 적용버튼이 있다 할인율이라던지 어떤 고정데이터가 디폴트로 있고 상황에 따라서 바꿀수 있어야한다
        ' 적용버튼을 만들어라(견적시에는 할인율을 적용하지 않음) . 
        SQL="Update tk_framek set sjsprice='"&sjsprice&"', disrate='"&disrate&"',disprice='"&disprice&"', fprice='"&fprice&"', quan='"&quan&"' "
        SQL=SQL&" , taxrate='"&taxrate&"', sprice='"&sprice&"', py_chuga='"&py_chuga&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
End If 

If rfkidx<>"" Then 
'Response.Write "rfkidx : " & rfkidx & "<br>"
    SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
    SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO, B.bfimg1, B.bfimg2, B.bfimg3, B.tng_busok_idx, B.tng_busok_idx2 "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
    SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    'response.end
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 

    afksidx=Rs(0)
    axi=Rs(1)
    ayi=Rs(2)
    awi=Rs(3)
    ahi=Rs(4)
    aWHICHI_AUTO=Rs(5)
    aWHICHI_FIX=Rs(6)
    abfidx=Rs(7)
    aset_name_Fix=Rs(8)
    aset_name_AUTO=Rs(9)
    abfimg1=Rs(10)
    abfimg2=Rs(11)
    abfimg3=Rs(12)
    atng_busok_idx=Rs(13)
    atng_busok_idx2=Rs(14)

    If abfidx="0" or isnull(abfidx) then 
    aset_name_AUTO="없음"
    aset_name_Fix="없음"
    end if 

End If
Rs.close
End If
'Response.Write "aset_name_AUTO : " & aset_name_AUTO & "<br>"
'===================
'바의 길이 입력하면 단가와 할증 그리고 가격 입력하기 끝



'품목정보가 없을 경우 생성 시작
'===================
if rsjsidx<>"" then 
 
  if rqtyidx<>"0" then 
  SQL="Update tng_sjaSub set qtyidx='"&rqtyidx&"' "
  SQL=SQL&" ,asub_wichi1='"&rasub_wichi1&"',asub_wichi2='"&rasub_wichi2&"',asub_bigo1='"&rasub_bigo1&"',asub_bigo2='"&rasub_bigo1&"'"
  SQL=SQL&" ,asub_bigo3='"&rasub_bigo3&"',asub_meno1='"&rasub_meno1&"',asub_meno2='"&rasub_meno2&"' " 
  SQL=SQL&" Where sjsidx='"&rsjsidx&"'" 
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  end If

  SQL="select mwidth, mheight, qtyidx, sjsprice, disrate, disprice, fprice, sjb_idx "
  SQL=SQL&",asub_wichi1,asub_wichi2,asub_bigo1,asub_bigo2,asub_bigo3,asub_meno1,asub_meno2 "
  SQL=SQL&" From tng_sjaSub  "
  SQL=SQL&" Where sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
  'response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    rmwidth=Rs(0)  '검측가로
    rmheight=Rs(1)  '검측세로
    rqtyidx=Rs(2)  '재질
    rsjsprice=Rs(3)  '주문품목가격
    rdisrate=Rs(4)  '주문품목할인율
    rdisprice=Rs(5)  '주문품목할인가격
    rfprice=Rs(6)  '주문품목 최종가격
    msjb_idx=Rs(7)  '메인여부
    asub_wichi1=Rs(8)
    asub_wichi2 =Rs(9)
    asub_bigo1=Rs(10)
    asub_bigo2=Rs(11)
    asub_bigo3=Rs(12)
    asub_meno1 =Rs(13)
    asub_meno2 =Rs(14)
  End If
  Rs.Close

else
  response.write"<script>window.open('totalsize.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"','totalsize','top=100 left=100 width=400 height=250');</script>"

End if
'===================
'품목정보가 없을 경우 생성 끝


'수주 기본 정보불러오기
'===================
SQL="Select Convert(Varchar(10),A.sjdate,121), A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121) "
SQL=SQL&" , A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx, A.midx, A.wdate, A.meidx, A.mewdate  "
SQL=SQL&" , B.cname, C.mname, C.mtel, C.mhp, C.mfax, C.memail, D.mname, E.mname, A.su_kjtype "
SQL=SQL&" From TNG_SJA A "
SQL=SQL&" Join tk_customer B On A.sjcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.sjmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Where sjidx='"&rsjidx&"' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
  sjdate=Rs(0)    '수주일
  sjnum=Rs(1)     '수주번호
  cgdate=Rs(2)    '출고일자
  djcgdate=Rs(3)  '도장출고일자
  cgtype=Rs(4)    '출고방식
  cgaddr=Rs(5)    '현장명
  cgset=Rs(6)     '입금후 출고 설정
  sjmidx=Rs(7)    '거래처 담당자키
  sjcidx=Rs(8)    '거래처 키
  midx=Rs(9)      '등록자키
  wdate=Rs(10)    '등록일시
  meidx=Rs(11)    '수정자키
  mewdate=Rs(12)  '수정일시
  cname=Rs(13)    '거래처명
  mname=Rs(14)    '거래처 담당자명
  mtel=Rs(15)     '거래처 담당자 전화번호
  mhp=Rs(16)      '거래처 담당자 휴대폰
  mfax=Rs(17)     '거래처 담당자 팩스
  memail=Rs(18)   '거래처 담당자 이메일
  amname=Rs(19)   '등록자명
  bmname=Rs(20)   '수정자명
  su_kjtype=Rs(21) '견적이냐 수주냐냐. 견적이 1 수주주가 2
End If
Rs.Close

if rsjb_type_no="" then 

  SQL=" Select sjb_type_name, SJB_barlist, sjb_type_no "
  SQL=SQL&" From TNG_SJB "
  SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon,1,1,1
  if not (Rs.EOF or Rs.BOF ) then
    sjb_type_name=Rs(0)
    sjb_barlist=Rs(1)
    rsjb_type_no=Rs(2)
  'Response.write rsjb_type_no&"<br>"
  End If
  Rs.Close
end if



'부속 적용하기 시작
'=======================================
if Request("part")="bfinsert" then 
    rsbfidx=Request("sbfidx")
    SQL=" Update tk_framekSub set bfidx='"&rsbfidx&"' where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'=======================================
'부속적용하기 끝

'프레임 삭제 시작
'=======================================
if Request("part")="framedel" then 

    SQL=" Delete From  tk_framek where fkidx='"&rfkidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    SQL=" Delete From  tk_framekSub where fkidx='"&rfkidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'=======================================
'프레임 삭제 끝
'바 삭제 시작
'=======================================
if Request("part")="bardel" then 

    SQL=" Delete From  tk_framekSub where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
end if
'=======================================
'바 삭제 끝

'기준프레임 우측으로 이동 시작
'=======================================
if Request("part")="raction" then 
  '기준프레임 찾기
  SQL="Select fkidx From tk_framek Where  setstd='1' and sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    stdfkidx=Rs(0)  

    '이동하는 프레임의 기준점 찾기
    SQL="Select xi, wi, yi from tk_frameksub where fkidx='"&stdfkidx&"' and xi=(select max(xi) from tk_frameksub where fkidx='"&stdfkidx&"') "
    'Response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    if not (Rs1.EOF or Rs1.BOF ) then
      xi=Rs1(0)
      wi=Rs1(1)
      yi=Rs1(2)

      sxi=xi+wi
      syi=yi
      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' and xi=(select min(xi) from tk_frameksub where fkidx='"&rfkidx&"') "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        dxi=sxi-mxi '이동해야하는 x좌표값
        dyi=syi-myi '이동해야하는 y좌표값
        'response.write dxi&"<br>"
        'response.write dyi&"<br>"
      End If
      Rs2.Close

      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
      Do while not Rs2.EOF
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        mnxi=mxi+dxi
        mnyi=myi+dyi
        SQL="Update tk_frameksub set xi='"&mnxi&"', yi='"&mnyi&"' Where fksidx='"&mfksidx&"' "
        'Response.write (SQL)&"<br>"
        'Dbcon.Execute (SQL)

      Rs2.movenext
      Loop
      End If
      Rs2.Close

    End If
    Rs1.Close
  End If
  Rs.Close

end if
'=======================================
'기준프레임 우측으로 이동 끝
'기준프레임 설정 시작
'=======================================
if Request("part")="setstd" then 
  rni=request("ni")
  'response.write rni&"/<br>"

  SQL=" Update tk_framek set setstd='"&rni&"' where fkidx='"&rfkidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  '1번정렬 처리 시작
  '=============
  if rni="1" then 
    SQL="Select xi, yi from tk_framekSub where fkidx='"&rfkidx&"' and xi=(select min(xi) From tk_framekSub Where fkidx='"&rfkidx&"') "
    Rs.open Sql,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
      dxi=Rs(0)
      dyi=Rs(1)

      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' "
      'Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      if not (Rs1.EOF or Rs1.BOF ) then
      Do while not Rs1.EOF
        mfksidx=Rs1(0)
        mxi=Rs1(1)
        myi=Rs1(2)

        mnxi=mxi-dxi
        mnyi=myi
        SQL="Update tk_frameksub set xi='"&mnxi&"', yi='"&mnyi&"' Where fksidx='"&mfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

      Rs1.movenext
      Loop
      End If
      Rs1.Close
    end if
    Rs.Close
  end if
  '=============
  '1번정렬 처리 끝
  'n번 정렬 처리 시작
  '=============
  '기준프레임 찾기
  setstd=rni-1  '바로앞 프레임 키 찾기
  SQL="Select fkidx From tk_framek Where  setstd='"&setstd&"' and sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    stdfkidx=Rs(0)  

    '이동하는 프레임의 기준점 찾기
    SQL="Select xi, wi, yi from tk_frameksub where fkidx='"&stdfkidx&"' and xi=(select max(xi) from tk_frameksub where fkidx='"&stdfkidx&"') "
    'Response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    if not (Rs1.EOF or Rs1.BOF ) then
      xi=Rs1(0)
      wi=Rs1(1)
      yi=Rs1(2)

      sxi=xi+wi
      syi=yi
      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' and xi=(select min(xi) from tk_frameksub where fkidx='"&rfkidx&"') "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        dxi=sxi-mxi '이동해야하는 x좌표값
        dyi=syi-myi '이동해야하는 y좌표값
        'response.write dxi&"<br>"
        'response.write dyi&"<br>"
      End If
      Rs2.Close

      SQL="select fksidx, xi, yi from tk_frameksub where fkidx='"&rfkidx&"' "
      'Response.write (SQL)&"<br>"
      Rs2.open Sql,Dbcon
      if not (Rs2.EOF or Rs2.BOF ) then
      Do while not Rs2.EOF
        mfksidx=Rs2(0)
        mxi=Rs2(1)
        myi=Rs2(2)

        mnxi=mxi+dxi
        mnyi=myi+dyi
        SQL="Update tk_frameksub set xi='"&mnxi&"', yi='"&mnyi&"' Where fksidx='"&mfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

      Rs2.movenext
      Loop
      End If
      Rs2.Close

    End If
    Rs1.Close
  End If
  Rs.Close
  '=============
  'n번 정렬 처리 끝

end if

'=======================================
'기준 프레임 설정 끝

'선택된 가로바 줄이기/늘이기 시작
'=======================================
if Request("part")="wresize" then 
  order=Request("order")  'plus 가로늘리기 minus 가로줄이기
  SQL="select wi from tk_framekSub where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    wi=Rs(0)
    
      if order="plus" then 
        cwi=wi+10 '20씩 늘인다.
      elseif order="minus" then 
        cwi=wi-10 '20씩 줄인다.
      end if
      if cwi < 0 then 
        cwi=0
      end if
      SQL=" Update tk_framekSub set wi='"&cwi&"' where fksidx='"&rfksidx&"' "
      'Response.write (SQL)&"<br>"
      Dbcon.Execute (SQL)

  end if
  Rs.Close
end if
'=======================================
'선택된 가로바 줄이기/늘이기 끝


'선택된 세로바 줄이기/늘이기 시작
'=======================================
if Request("part")="hresize" then 
  order=Request("order")  'plus 가로늘리기 minus 가로줄이기
  SQL="select hi from tk_framekSub where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    hi=Rs(0)
    
      if order="plus" then 
        chi=hi+10 '10씩 늘인다.
      elseif order="minus" then 
        chi=hi-10 '10씩 줄인다.
      end if
      if chi < 0 then 
        chi=0
      end if
      SQL=" Update tk_framekSub set hi='"&chi&"' where fksidx='"&rfksidx&"' "
      'Response.write (SQL)&"<br>"
      Dbcon.Execute (SQL)

  end if
  Rs.Close
end if
'=======================================
'선택된 세로바 줄이기/늘이기 끝

'방향 이동 시작
'=======================================
if Request("part")="converge" then 
  direction=Request("direction")    '방향
  SQL="Select xi, wi, yi, hi from tk_framekSub where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    xi=Rs(0)
    wi=Rs(1)
    yi=Rs(2)
    hi=Rs(3)

    if direction="left" then 
      SQL="select distinct xi, wi from tk_framekSub where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"' and xi<'"&xi&"' order by xi desc"
      'Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      if not (Rs1.EOF or Rs1.BOF ) then
        axi=Rs1(0)
        awi=Rs1(1)
        cwi=axi+awi
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
      end if
      Rs1.Close
    elseif  direction="right" then
      xi=xi+wi
      SQL="select distinct xi, wi from tk_framekSub where fkidx='"&rfkidx&"' and fksidx<>'"&rfksidx&"' and xi>'"&xi&"' order by xi asc"
      'Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      if not (Rs1.EOF or Rs1.BOF ) then
        axi=Rs1(0)
        awi=Rs1(1)
        cwi=axi-xi
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

      end if
      Rs1.Close

    elseif direction="movel" then
        cwi=xi-10
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    elseif  direction="mover" then
        cwi=xi+10
        SQL=" Update tk_framekSub set xi='"&cwi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    elseif direction="moveu" then
        cyi=yi-10
        SQL=" Update tk_framekSub set yi='"&cyi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    elseif  direction="moved" then
        cyi=yi+10
        SQL=" Update tk_framekSub set yi='"&cyi&"' where fksidx='"&rfksidx&"' "
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    end if
  end if
  Rs.Close

end if
'=======================================
'방향이동 끝
'품목변경 시작
'=======================================
if Request("part")="chgbarasif" then 
  rbfidx=Request("bfidx")  'plus 가로늘리기 minus 가로줄이기
 
  SQL=" Update tk_framekSub set bfidx='"&rbfidx&"' where fksidx='"&rfksidx&"' "
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
 
end if
'=======================================
'품목변경 끝
'유리추가 시작
'=======================================
if Request("part")="addglass" then 

'bwsize : 바 가로 실사이즈
'bhsize : 바 세로 실사이즈
fstype = "1" ' : 바의 타임(0:바/1:유리/2:묻힘
rwsize = Request("wsize") '유리 가로 실사이즈
rhsize = Request("hsize") '유리 세로 실사이즈
glasstype = Request("glasstype") '유리의 타입 d1:외도어편개 d2:외도어양개, d3:언밸런스, d4~d5:여분/g1:하부픽스유리, g2:박스라인 하부픽스유리2,d3:상부픽스유리1, d4:상부픽스유리2, d5:상부픽스유리3, d6:상부픽스유리4

fsidx="0" 'framesub의 키값은 없어서 0으로 넣는다.

  SQL="Select top 1 A.fidx, B.xi, B.yi "
  SQL=SQL&" From tk_framek A "
  SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
  SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
  SQL=SQL&" Order by B.xi asc "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    fidx=Rs(0)
    xi=Rs(1)
    yi=Rs(2)

    axi=xi+40
    ayi=yi+40
    awi=200
    ahi=200
    WHICHI_FIX=""
    WHICHI_AUTO=""
    bfidx=""

    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, gwsize, ghsize, fstype, glasstype) "
    SQL=SQL&" Values ('"&rfkidx&"', '"&fsidx&"', '"&fidx&"', '"&axi&"', '"&ayi&"', '"&awi&"', '"&ahi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"', '"&rwsize&"', '"&rhsize&"', '"&fstype&"', '"&glasstype&"') "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

  End If
  Rs.Close
end if
'=======================================
'유리추가 끝
'묻힘추가 시작
'=======================================
If Request("part")="addcovered" Then

  alocation=Request("alocation")  '묻힘방향
  fsidx="0" 'framesub의 키값은 없어서 0으로 넣는다.
  fstype = "2" ' : 바의 타임(0:바/1:유리/2:묻힘
  SQL="Select  A.fidx, B.xi, B.yi, B.wi, B.hi "
  SQL=SQL&" From tk_framek A "
  SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
  SQL=SQL&" Where B.fksidx='"&rfksidx&"' "
  SQL=SQL&" Order by B.xi asc "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    fidx=Rs(0)
    xi=Rs(1)
    yi=Rs(2)
    wi=Rs(3)
    hi=Rs(4)

    if alocation="top" then 
      axi=xi
      ayi=yi
      awi=wi
      ahi=40
    end if
    if alocation="bottom" then 
      axi=xi
      ayi=yi+hi-40
      awi=wi
      ahi=40
    end if
    
    WHICHI_FIX="0"
    WHICHI_AUTO="0"
    bfidx=""

    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, gwsize, ghsize, fstype, glasstype) "
    SQL=SQL&" Values ('"&rfkidx&"', '"&fsidx&"', '"&fidx&"', '"&axi&"', '"&ayi&"', '"&awi&"', '"&ahi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"', '"&rwsize&"', '"&rhsize&"', '"&fstype&"', '"&glasstype&"') "
    'Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)

  End If
  Rs.Close
End If
'=======================================
'묻힘추가 끝


%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><%=projectname%></title>
  <!-- 도면 수치 표현 모듈 - 엣지 주석기 -->
  <link href="http://tkdr006.cafe24.com/TNG1/schema_도형형/assets/css/index.css" rel="stylesheet" type="text/css" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!--#include virtual="/tng1/TNG1_B_suju.css"-->
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
  <script>
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
            if (event.key === "Enter") {
                event.preventDefault();
                console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
                document.getElementById("hiddenSubmit").click();
            }
        }

        // Select 박스 변경(마우스 클릭/선택) 이벤트 핸들러
        function handleSelectChange(event, elementId1, elementId2) {
            console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }

        function handleChange(selectElement) {
            const selectedValue = selectElement.value;
            document.getElementById("hiddenSubmit").click();
        }

        // 폼 전체 Enter 이벤트 감지 (기본 방지 + 숨겨진 버튼 클릭)
        document.getElementById("dataForm").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault(); // 기본 Enter 동작 방지
                console.log("폼 전체에서 Enter 감지");
                document.getElementById("hiddenSubmit").click();
            }
        });

    function pummoksub(sjb_idx) {
      const message = prompt("이 입면 도면을 기본으로 부속이 적용된 신규 부족적용 입면 도면 생성합니다. 입면도면의 이름을 입력하세요.");
      if (message !== null && message.trim() !== "") {
        const encodedMessage = encodeURIComponent(message.trim());
        window.location.href = "TNG1_B_suju.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx="+sjb_idx+"&fknickname="+encodedMessage;
      }
    }
    function framedel(fkidx){
        if (confirm("프레임을 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju.asp?part=framedel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx;
        }
    }
    function bardel(fksidx){
        if (confirm("바를 삭제 하시겠습니까?"))
        {
            location.href="TNG1_B_suju.asp?part=bardel&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx="+fksidx;
        }
    }
    function setstd(ni,fkidx){

        {
            location.href="TNG1_B_suju.asp?part=setstd&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx="+fkidx+"&ni="+ni;
        }
    }
    function wresize(order){
        {
            location.href="TNG1_B_suju.asp?part=wresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
        }
    }
    function hresize(order){
        {
            location.href="TNG1_B_suju.asp?part=hresize&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&order="+order;
        }
    }
    function converge(direction){
        {
            location.href="TNG1_B_suju.asp?part=converge&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&direction="+direction;
        }
    }
    function chgbarasif(bfidx){
        if (confirm("바의 품목을 변경 하시겠습니까?"))
        {
            location.href="TNG1_B_suju.asp?part=chgbarasif&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&bfidx="+bfidx;
        }
    }
    function addglass(glasstype, wsize, hsize){
        {
            location.href="TNG1_B_suju.asp?part=addglass&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&gubun=glass&glasstype="+glasstype+"&wsize="+wsize+"&hsize="+hsize;
        }
    }
 
    function addcovered(alocation){
        {
            location.href="TNG1_B_suju.asp?part=addcovered&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&gubun=covered&alocation="+alocation;
        }
    }
    function wincopy(){
        if (confirm("바를 추가하시겠습니까?"))
        {
            document.dataForm.submit();
        }
    }
  </script>
</head>
<body>
<form id="dataForm" name="dataForm"  action="TNG1_B_suju.asp" method="POST" >   
    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
    <input type="hidden" name="mode" value="kblength">

<div class="container-fluid">
    <!-- 첫 번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
            <span class="input-group-text">수주번호</span>
            <input type="text" class="form-control" value="<%=sjdate%>_<%=sjnum%>">
            <span class="input-group-text">거래처</span>
            <input type="text" class="form-control" value="<%=cname%>">
            <span class="input-group-text">담당자</span>
            <input type="text" class="form-control" value="<%=mname%>">
            <span class="input-group-text">전화</span>
            <input type="text" class="form-control" value="<%=mtel%>">
            <span class="input-group-text">휴대폰</span>
            <input type="text" class="form-control" value="<%=mhp%>">
            <span class="input-group-text">팩스</span>
            <input type="text" class="form-control" value="<%=mfax%>">
            <span class="input-group-text">이메일</span>
            <input type="text" class="form-control" value="<%=memail%>">
            </div>
        </div>
    </div>
    <!-- 중간에 끼어진 두번째 줄 -->
    <div class="first-row">
        <div class="row px-3 w-100">
            <div class="input-group mb-0">
            <span class="input-group-text">전체가로</span>
            <input type="text" class="form-control" name="rmwidth" value="<%=rmwidth%>" onclick="window.open('totalsize.asp?cidx=<%=rcidx%>&sjidx=<%=rsjidx%>&sjb_type_no=<%=rsjb_type_no%>&sjsidx=<%=rsjsidx%>','totalsize','top=100 left=100 width=400 height=250');">
            <span class="input-group-text">전체세로</span>
            <input type="text" class="form-control"  name="rmheight" value="<%=rmheight%>"  onclick="window.open('totalsize.asp?cidx=<%=rcidx%>&sjidx=<%=rsjidx%>&sjb_type_no=<%=rsjb_type_no%>&sjsidx=<%=rsjsidx%>','totalsize','top=100 left=100 width=400 height=250');">
            <span class="input-group-text">위치1</span>
            <input type="text" class="form-control" name="asub_wichi1" value="<%=rasub_wichi1%>">
            <span class="input-group-text">위치2</span>
            <input type="text" class="form-control"  name="asub_wichi2" value="<%=rasub_wichi2%>">
            <span class="input-group-text">비고1</span>
            <input type="text" class="form-control" name="asub_bigo1" value="<%=rasub_bigo1%>">
            <span class="input-group-text">비고2</span>
            <input type="text" class="form-control" name="asub_bigo2" value="<%=rasub_bigo2%>">
            <span class="input-group-text">비고3</span>
            <input type="text" class="form-control" name="asub_bigo3" value="<%=rasub_bigo3%>">
            <span class="input-group-text">추가사항1</span>
            <input type="text" class="form-control" name="asub_meno1" value="<%=rasub_meno1%>">
            <span class="input-group-text">추가사항2</span>
            <input type="text" class="form-control" name="asub_meno2" value="<%=rasub_meno2%>">
            </div>
        </div>
    </div>
    <!-- 두 번째 줄 (가변 높이 3칸) 시작-->
    <div class="second-row">
        <div class="second-left-1"> <!-- 첫 번째 영역 -->
            <div class="mb-2">
                <select name="sjb_type_no" class="form-control" id="sjb_type_no"  onchange="handleChange(this)">
                <option value="0" >선택</option>
                <%
                SQL=" Select sjbtidx, sjb_type_no, sjb_type_name "
                SQL=SQL&" From tng_sjbtype "
                SQL=SQL&" Where sjbtstatus=1 "
                Response.write (SQL)&"<br><br>"
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                sjbtidx=Rs(0)
                sjb_type_no=Rs(1)
                sjb_type_name=Rs(2)


                if rsjidx<>"" then 
                    class_text="btn btn-secondary btn-small"
                else
                    class_text="btn btn-outline-secondary btn-small"
                end if
                %>
                <option value="<%=sjb_type_no%>" <% if Cint(sjb_type_no)=Cint(rsjb_type_no) then response.write "selected" end if %>><%=sjb_type_name%>/<%=sjb_type_no%></option>
                <%
                Rs.movenext
                Loop
                End if
                Rs.close
                '
                %>
                </select>
            </div>
            <div class="mb-2 d-flex align-items-center justify-content-between" style="gap: 10px;">
                <!-- 드롭다운 버튼 시작-->
                <% if rsjb_type_no<>"" then %> 
                <div class="dropdown">
                    <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                        품목선택
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                        <% 
                        SQL = " SELECT A.sjb_idx, B.sjb_type_name, A.SJB_barlist, A.sjb_type_no, A.sjb_fa "
                        SQL = SQL & " FROM TNG_SJB A "
                        SQL = SQL & " LEFT OUTER JOIN tng_sjbtype B ON A.sjb_type_no = B.sjb_type_no AND B.sjbtstatus = 1 "
                        SQL = SQL & " Where A.sjb_type_no='"&rsjb_type_no&"' "
                        SQL = SQL & " and (B.sjb_type_name  like '%" & Request("SearchWord") & "%' or  A.SJB_barlist  like '%" & Request("SearchWord") & "%') "
                        'response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF

                        sjb_idx=Rs(0)
                        sjb_type_name=Rs(1)
                        SJB_barlist=Rs(2)
                        sjb_type_no=Rs(3)
                        sjb_fa=Rs(4)
                        'if right(sjb_type_name,2)="자동" then 
                        '  greem_f_a="1"
                        'elseif  right(sjb_type_name,3)="프레임" then 
                        '  greem_f_a="2"
                        'end if 
                        %>
                        <li><a class="dropdown-item" onclick="window.open('TNG1_B_choiceframe.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&sjb_type_no=<%=sjb_type_no%>&greem_f_a=<%=sjb_fa%>','choice','top=0 left=0 width=800, height=700');"><%=sjb_type_name%>&nbsp;<%=SJB_barlist%></a></li>
                        <%
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                        %>    
                    </ul>
                </div>
                <%
                end if
                %>
                <!-- 드롭다운 버튼 끝-->
                <div style="display: flex; align-items: center; gap: 6px;">
                    <label class="form-label mb-0">수량 :</label>
                    <input type="number" class="form-control" name="quan" value="<%=rquan%>" placeholder="수량" style="width: 80px;" 
                    onkeypress="handleKeyPress(event, 'quan', 'quan')">
                </div>
            </div>
                <!-- 생성된 도면 정보 시작 -->
                <div>
                    <div class="mb-2">
                        <%
                        SQL = " Select fkidx, fknickname, fname, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE "
                        SQL = SQL & " ,GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, setstd, sjb_idx, fidx , qtyidx , pidx   "
                        SQL = SQL & " From tk_framek "
                        SQL = SQL & " Where sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"' "
                        'response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            fkidx=Rs(0)
                            fknickname=Rs(1)
                            fname=Rs(2)
                            fstatus=Rs(3)
                            GREEM_F_A=Rs(4)
                            GREEM_BASIC_TYPE=Rs(5)
                            GREEM_FIX_TYPE=Rs(6)
                            GREEM_HABAR_TYPE=Rs(7)
                            GREEM_LB_TYPE=Rs(8)
                            GREEM_O_TYPE=Rs(9)
                            GREEM_FIX_name=Rs(10)
                            GREEM_MBAR_TYPE=Rs(11)
                            setstd=Rs(12)
                            sjb_idx=Rs(13)
                            fidx=Rs(14)
                            zqtyidx=Rs(15) 
                            zpidx=Rs(16)    
                     
                            if Cint(msjb_idx)=Cint(sjb_idx) then maintext="[m]" end if
                        %>
                        <div class="input-group mb-1">     
                            <input type="text" class="form-control" value="<%=maintext%><%=fname%>_<%=setstd%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>');" <% if Cint(fkidx)=Cint(rfkidx) then %>style="background-color: #D3D3D3;" <% end if %>>  
                        </div>
                        <%
                            maintext=""
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                        %>   
                    </div>
                        <%
                        SQL = " Select doorglass_t , fixglass_t , dooryn  "
                        SQL = SQL & " From tk_framek"
                        SQL = SQL & " Where fkidx='"&rfkidx&"'  "
                        'response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 

                            zdoorglass_t=Rs(0)
                            zfixglass_t=Rs(1)
                            zdooryn=Rs(2)
                        End if
                        Rs.close
                        %>
                    <div class="input-group mb-2">  
                        <span for="bendName" class="input-group-text">도어 🔵 ❌</span>
                        <select name="dooryn" class="form-control" id="dooryn"  onchange="handleChange(this)">
                            <option value="0" <% If Cint(zdooryn) = "0" Or Trim(zdooryn) = "" Then Response.Write "selected" %>>도어나중</option>
                            <option value="1" <% If Cint(zdooryn) = "1" Then Response.Write "selected" %>>도어같이</option>
                            <option value="2" <% If Cint(zdooryn) = "2" Then Response.Write "selected" %>>도어안함</option>
                        </select>
                    </div>
                    <div class="input-group mb-2" style="gap: 8px; align-items: center;">
                        <span class="input-group-text py-0 px-1 small">도어유리</span>
                        <select name="doorglass_t" class="form-control" id="doorglass_t"  onchange="handleChange(this)">
                        <option value="0" <% if zdoorglass_t="" then %>selected<% end if %>>t</option>
                        <%
                        SQL=" Select glidx, glcode, glsort, glvariety, gldepth, glprice, glwdate "
                        SQL=SQL&" From tk_glass "
                        SQL=SQL&" Order by gldepth asc "
                        'response.write(sql)
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            glidx=Rs(0)
                            glcode=Rs(1)
                            glsort=Rs(2)
                            glvariety=Rs(3)
                            gldepth=Rs(4)
                            glprice=Rs(5)
                            glwdate=Rs(6)
                        %>
                                        <option value="<%=gldepth%>" <% if Cint(gldepth)=Cint(zdoorglass_t) then %> selected <% end if %> ><%=gldepth%></option>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>
                        </select>
                        <span class="input-group-text py-0 px-1 small">픽스유리</span>
                        <select name="fixglass_t" class="form-control" id="fixglass_t"  onchange="handleChange(this)">
                        <option value="0" <% if zfixglass_t="" then %>selected<% end if %>>t</option>
                        <%
                        SQL=" Select glidx, glcode, glsort, glvariety, gldepth, glprice, glwdate "
                        SQL=SQL&" From tk_glass "
                        SQL=SQL&" Order by gldepth asc "
                        'response.write(sql)
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            glidx=Rs(0)
                            glcode=Rs(1)
                            glsort=Rs(2)
                            glvariety=Rs(3)
                            gldepth=Rs(4)
                            glprice=Rs(5)
                            glwdate=Rs(6)
                        %>
                                        <option value="<%=gldepth%>" <% if Cint(gldepth)=Cint(zfixglass_t) then %> selected <% end if %> ><%=gldepth%></option>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>
                        </select>
                    </div>   
                    <div class="input-group mb-2">
                        <% if  sjb_type_no >= 1 And sjb_type_no <= 5 then %>
                                <span for="bendName" class="input-group-text">도장재질</span>
                                <select name="qtyidx" class="form-control" id="qtyidx" onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>선택</option>
                                    <%

                                    sql = "SELECT DISTINCT A.QTYIDX, B.QTYNo, B.QTYNAME"
                                    sql = sql & " FROM tng_unitprice_al A"
                                    sql = sql & " LEFT OUTER JOIN tk_qtyco B ON A.qtyco_idx = B.qtyco_idx"
                                    sql = sql & " WHERE B.QTYcostatus = '1'"
                                    sql = sql & " Order by B.QTYNo ASC  "
                                    'response.write(sql)
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do while not Rs.EOF
                                    qtyidx=Rs(0)
                                    QTYNo=Rs(1)
                                    qtyname=Rs(2)
                                    %>
                                                    <option value="<%=qtyidx%>" <% if Cint(qtyidx)=Cint(zqtyidx) then %> selected <% end if %> ><%=qtyname%></option>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End if
                                    Rs.close
                                    %>
                                </select>
                            </div>
                            <% if zqtyidx = 15 then %>
                            <div class="input-group mb-2">  
                                <select name="pidx" class="form-control" id="pidx"  onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>메탈릭실버</option>
                                <%
                                sql = "SELECT pidx, pname FROM tk_paint WHERE pidx=36 ORDER BY pidx ASC"
                                'response.write(sql)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                pidx=Rs(0)
                                pname=Rs(1) 
                                %>
                                                <option value="<%=pidx%>" <% if Cint(pidx)=Cint(zpidx) then %> selected <% end if %> ><%=pname%></option>
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %>
                                </select>
                            </div>   
                            <% elseif  zqtyidx = 30   then %> <!-- rqtyidx = 30 기타도장 -->
                            <div class="input-group mb-2">  
                                <select name="pidx" class="form-control" id="pidx"  onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>도장칼라 선택</option>
                                <%

                                sql = "SELECT pidx, pname FROM tk_paint WHERE pstatus = 1 ORDER BY pidx ASC"
                                'response.write(sql)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                pidx=Rs(0)
                                pname=Rs(1) 
                                %>
                                                <option value="<%=pidx%>" <% if Cint(pidx)=Cint(zpidx) then %> selected <% end if %> ><%=pname%></option>
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %>
                                </select>
                            </div>  
                            <% end if %>  
                        <% elseif  sjb_type_no >= 6 And sjb_type_no <= 7  then %>
                                <div class="input-group mb-2">
                                <span for="bendName" class="input-group-text">도장재질</span>
                                <select name="qtyidx" class="form-control" id="qtyidx" onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>선택</option>
                                    <%

                                    sql = "SELECT DISTINCT A.QTYIDX, B.QTYNo, B.QTYNAME"
                                    sql = sql & " FROM tng_unitprice_al A"
                                    sql = sql & " LEFT OUTER JOIN tk_qtyco B ON A.qtyco_idx = B.qtyco_idx"
                                    sql = sql & " WHERE B.QTYcostatus = '1'"
                                    sql = sql & " and a.qtyidx <> 15 "
                                    sql = sql & " Order by B.QTYNo ASC  "
                                    'response.write(sql)
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do while not Rs.EOF
                                    qtyidx=Rs(0)
                                    QTYNo=Rs(1)
                                    qtyname=Rs(2)
                                    %>
                                                    <option value="<%=qtyidx%>" <% if Cint(qtyidx)=Cint(zqtyidx) then %> selected <% end if %> ><%=qtyname%></option>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End if
                                    Rs.close
                                    %>
                                </select>
                            </div>
                            <% if zqtyidx = 15 then %>
                            <div class="input-group mb-2">  
                                <select name="pidx" class="form-control" id="pidx"  onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>메탈릭실버</option>
                                <%
                                sql = "SELECT pidx, pname FROM tk_paint WHERE pidx=36 ORDER BY pidx ASC"
                                'response.write(sql)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                pidx=Rs(0)
                                pname=Rs(1) 
                                %>
                                                <option value="<%=pidx%>" <% if Cint(pidx)=Cint(zpidx) then %> selected <% end if %> ><%=pname%></option>
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %>
                                </select>
                            </div>   
                            <% elseif  zqtyidx = 30   then %> <!-- rqtyidx = 30 기타도장 -->
                            <div class="input-group mb-2">  
                                <select name="pidx" class="form-control" id="pidx"  onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>도장칼라 선택</option>
                                <%

                                sql = "SELECT pidx, pname FROM tk_paint WHERE pstatus = 1 ORDER BY pidx ASC"
                                'response.write(sql)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                pidx=Rs(0)
                                pname=Rs(1) 
                                %>
                                                <option value="<%=pidx%>" <% if Cint(pidx)=Cint(zpidx) then %> selected <% end if %> ><%=pname%></option>
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %>
                                </select>
                            </div>  
                            <% end if %>   
                    </div>
                        <% else %>
                        <span for="bendName" class="input-group-text">스텐재질</span>
                        <select name="qtyidx" class="form-control" id="qtyidx"  onchange="handleChange(this)">
                        <option value="0" <% if zqtyidx="" then %>selected<% end if %>없음</option>
                            <%

                            SQL=" Select DISTINCT A.qtyidx, B.QTYNo ,B.qtyname " 
                            SQL=SQL&" From tk_qty A   "
                            SQL=SQL&" join tk_qtyco B on A.QTYNo=B.QTYNo  "
                            SQL=SQL&" Where B.qtyname<>'' and A.qtystatus='1' "
                            SQL=SQL&" Order by B.QTYNo ASC  "
                            'response.write(sql)
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            Do while not Rs.EOF
                            qtyidx=Rs(0)
                            QTYNo=Rs(1)
                            qtyname=Rs(2)
                            %>
                                            <option value="<%=qtyidx%>" <% if Cint(qtyidx)=Cint(zqtyidx) then %> selected <% end if %> ><%=qtyname%></option>
                            <%
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                            %>
                        </select> 
                        <% if (  zqtyidx = 1 ) or (  zqtyidx = 3  )  then %>
                            <div class="input-group mb-2">  
                                <select name="pidx" class="form-control" id="pidx"  onchange="handleChange(this)">
                                <option value="0" <% if zqtyidx="" then %>selected<% end if %>>도장칼라 선택</option>
                                <%
                                sql = "SELECT pidx, pname FROM tk_paint WHERE pstatus = 1 ORDER BY pidx ASC"
                                'response.write(sql)
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do while not Rs.EOF
                                pidx=Rs(0)
                                pname=Rs(1) 
                                %>
                                                <option value="<%=pidx%>" <% if Cint(pidx)=Cint(zpidx) then %> selected <% end if %> ><%=pname%></option>
                                <%
                                Rs.movenext
                                Loop
                                End if
                                Rs.close
                                %>
                                </select>
                            </div>  
                            <% end if %> 
                </div> 
                <% end if %> 
                <div class="mb-2">
                    <%
                    SQL = " Select tw,th,ow,oh,fl,ow_m,fkidx "
                    SQL = SQL & " From tk_framek "
                    SQL = SQL & " Where fkidx='"&rfkidx&"' "
                    'response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                        tw=Rs(0)
                        th=Rs(1)
                        ow=Rs(2)
                        oh=Rs(3)
                        fl=Rs(4)
                        ow_m=Rs(5)
                        fkidx=Rs(6)
                        if fl="" or isnull(fl) then 
                            fl = 0
                        end if
                    %>
                    <div class="input-group mb-1">     
                        <% 
                        if Cint(fkidx)=Cint(rfkidx) then 
                        %>
                            <div style="display: flex; flex-wrap: wrap;">
                                <div style="flex: 0 0 50%; padding-right: 8px;">
                                    <label>검측가로</label>
                                    <input type="number" class="form-control" name="tw" value="<%=tw%>" placeholder="가로" onkeypress="handleKeyPress(event, 'tw', 'tw')">
                                </div>
                                <div style="flex: 0 0 50%; padding-left: 8px;">
                                    <label>검측세로</label>
                                    <input type="number" class="form-control" name="th" value="<%=th%>" placeholder="세로" onkeypress="handleKeyPress(event, 'th', 'th')">
                                </div>

                                <div style="flex: 0 0 50%; padding-right: 8px; margin-top: 12px;">
                                    <label>오픈가로</label>
                                    <input type="number" class="form-control" name="ow" value="<%=ow%>" placeholder="오픈가로" onkeypress="handleKeyPress(event, 'ow', 'ow')">
                                </div>
                                <div style="flex: 0 0 50%; padding-left: 8px; margin-top: 12px;">
                                    <label>도어높이</label>
                                    <input type="number" class="form-control" name="oh" value="<%=oh%>" placeholder="오픈세로" onkeypress="handleKeyPress(event, 'oh', 'oh')">
                                </div>

                                <div style="flex: 0 0 50%; padding-right: 8px; margin-top: 12px;">
                                    <label>묻힘</label>
                                    <input type="number" class="form-control" name="fl" value="<%=fl%>" placeholder="묻힘" onkeypress="handleKeyPress(event, 'fl', 'fl')">
                                </div>   

                                <div style="flex: 0 0 50%; padding-right: 8px; margin-top: 12px;">
                                    <label>자동_오픈지정</label>
                                    <input type="number" class="form-control" name="ow_m" value="<%=ow_m%>" placeholder="수기!!" onkeypress="handleKeyPress(event, 'ow_m', 'ow_m')">
                                </div>  
                            </div>   
                        <% else %>
                            <input class="form-control" type="number" value="<%=tw%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                            
                            <input class="form-control" type="number" value="<%=th%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                        
                            <input class="form-control" type="number" value="<%=ow%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                          
                            <input class="form-control" type="number" value="<%=oh%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                            <input class="form-control" type="number" value="<%=fl%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                            <input class="form-control" type="number" value="<%=ow_m%>" onclick="location.replace('TNG1_B_suju.asp?sjsidx=<%=rsjsidx%>&sjidx=<%=rsjidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>#<%=fkidx%>');"/>                      
                        <% end if %>
                    </div>
                        <%
                            tw=""
                            th=""
                            ow=""
                            oh=""
                            fl=""
                            ow_m=""
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                        %>   
                </div>
                <div class="input-group mb-2">
                    <table class="table">
                        <thead>
                            <th class="text-center"></th>
                            <th class="text-center">기본</th>
                            <th class="text-center">평 추가</th>
                            <th class="text-center">총합계</th>
                        </thead>
                        <tbody  class="table-group-divider">
                            <%
                            SQL="Select fkidx,sjsprice,py_chuga"
                            SQL=SQL&" from tk_framek  "
                            SQL=SQL&" Where fkidx='"&rfkidx&"' "
                            'Response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                           
                                tfkidx=Rs(0)
                                sjsprice=Rs(1)
                                py_chuga=Rs(2)
                                i=i+1 
                                gibonprice = sjsprice -  py_chuga              
                            %>
                        <tr <% if Cint(tfkidx)=Cint(rfkidx) then %>class="table-warning" <% end if %>>
                            <td class="text-center"><%=i%></td> 
                            <td class="text-center"><%=FormatNumber(gibonprice, 0, -1, -1, -1)%></td>
                            <td class="text-center"><%=FormatNumber(py_chuga, 0, -1, -1, -1)%></td>
                            <td class="text-center"><%=FormatNumber(sjsprice, 0, -1, -1, -1)%></td>  
                        </tr>
                            <%
                           
                            End if
                            Rs.close
                            %> 
                        </tbody>
                    </table>
                </div>
                <div class="input-group mb-2">
                    <table class="table">
                        <thead>
                            <th class="text-center"></th>
                            <th class="text-center">재분</th>
                            <th class="text-center">로비폰</th>
                            <th class="text-center">보양재</th>
                        </thead>
                        <tbody  class="table-group-divider">
                            <%
                            SQL="Select jaeryobunridae,robby_box,boyangjea,fkidx"
                            SQL=SQL&" from tk_framek  "
                            SQL=SQL&" Where fkidx='"&rfkidx&"' "
                            'Response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                           
                                jaeryobunridae=Rs(0)
                                robby_box=Rs(1)
                                boyangjea=Rs(2)
                                ufkidx=Rs(3)
                                i=i+1               
                            %>
                        <tr <% if Cint(ufkidx)=Cint(rfkidx) then %>class="table-warning" <% end if %>>
                            <td class="text-center"><%=i%></td> 
                            <td class="text-center"><%=FormatNumber(jaeryobunridae, 0, -1, -1, -1)%></td> 
                            <td class="text-center"><%=FormatNumber(robby_box, 0, -1, -1, -1)%></td>
                            <td class="text-center"><%=FormatNumber(boyangjea, 0, -1, -1, -1)%></td>   
                        </tr>
                            <%
                           
                            End if
                            Rs.close
                            %> 
                        </tbody>
                    </table>
                </div>
                <div style="display: flex; gap: 8px; margin-top: 10px;">
                    <a href="TNG1_B_suju.asp?mode=alprice&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>"     
                        onmouseover="this.style.backgroundColor='#d5d5d5'; this.style.color='black';"
                        onmouseout="this.style.backgroundColor='#e0e0e0'; this.style.color='#333';"
                        style="flex: 1; text-align: center; padding: 4px 8px; background-color: #e0e0e0; color: #333; text-decoration: none; border: 1px solid #ccc; border-radius: 4px; transition: all 0.2s;">
                        AL_도장 <br>  단가 적용
                    </a>
                    <a href="TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>" 
                        onmouseover="this.style.backgroundColor='#d5d5d5'; this.style.color='black';"
                        onmouseout="this.style.backgroundColor='#e0e0e0'; this.style.color='#333';"
                        style="flex: 1; text-align: center; padding: 4px 8px; background-color: #e0e0e0; color: #333; text-decoration: none; border: 1px solid #ccc; border-radius: 4px; transition: all 0.2s;">
                        미터 당  <br>  단가 적용
                    </a>
                </div>
                <div class="input-group mb-2">
                        <span for="bendName" class="input-group-text">바의길이</span>
                        <input type="number" class="form-control" name="kblength" id="kblength" placeholder="숫자"  value="<%=blength%>" onkeypress="handleKeyPress(event, 'blength', 'blength')">
                    </div>
                <!-- 생성된 도면정보 끝 -->
            </div>    
        <!-- 두 번째 줄 (가변 높이 3칸) 끝--> 
    </div>  
    <div class="second-row">    
        <!-- 두 번째 줄 bbbbbb (가변 높이 3칸) 시작-->
        <div class="second-left-2"> <!-- 두 번째 영역 -->
                <div class="mb-2">
                <%
                SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
                SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
                SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
                SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A "
                SQL = SQL & " ,a.doorsizechuga_price,a.door_price ,a.goname,a.barNAME ,a.doortype"
                SQL = SQL & " from tk_framekSub a"
                SQL = SQL & " join tk_framek b on a.fkidx = b.fkidx "
                SQL=SQL&" Where a.fkidx = '"&rfkidx&"' and door_w<>0 and door_h<>0 and door_price<>0 "
                Rs2.open SQL, Dbcon
                If Not (Rs2.bof or Rs2.eof) Then 
                Do While Not Rs2.EOF
                'response.write (Sql)&"<br>"
                    kWHICHI_AUTO          = rs2(0)
                    kWHICHI_FIX           = rs2(1)
                    kDOOR_W               = rs2(2)
                    kDOOR_H               = rs2(3)
                    kDOORGLASS_W          = rs2(4)
                    kDOORGLASS_H          = rs2(5)
                    kGLS                  = rs2(6)
                    kSJB_IDX              = rs2(7)
                    kSJB_TYPE_NO          = rs2(8)
                    kFKSIDX               = rs2(9)
                    kGREEM_O_TYPE         = rs2(10)
                    kGREEM_BASIC_TYPE     = rs2(11)
                    kGREEM_FIX_TYPE       = rs2(12)
                    kQTYIDX               = rs2(13)
                    kPIDX                 = rs2(14)
                    kDOORGLASS_T          = rs2(15)
                    kFIXGLASS_T           = rs2(16)
                    kDOORYN               = rs2(17)
                    kGREEM_F_A            = rs2(18)
                    kDOORSIZECHUGA_PRICE  = rs2(19)
                    kDOOR_PRICE           = rs2(20)
                    kGONAME               = rs2(21)
                    kBARNAME              = rs2(22)
                    kDOORTYPE             = rs2(23)

                        select case kDOORTYPE
                            case 0 
                                kdoortype_text = "없음"
                            case 1 
                                kdoortype_text = "좌도어"
                            case 2  
                                kdoortype_text = "우도어"
                        end select
                        k=k+1
                        %>
                    <table class="table table-bordered table-sm align-middle" style="width:100%;">
                        <!-- no:품명 (1:3) -->
                        <tr>
                        <td class="text-center" style="width: 10%;">no</td>
                        <th class="text-center" colspan="3">품명</th>
                        </tr>
                        <tr>
                        <td class="text-center"><%=k%></td>
                        <td class="text-center" colspan="3"><%=kgoname%></td>
                        </tr>

                        <!-- 2:2 -->
                        <tr>
                        <th class="text-center" colspan="2">규격</th>
                        <th class="text-center" colspan="2">편개/양개</th>
                        </tr>
                        <tr>
                        <td class="text-center" colspan="2"><%=kbarNAME%></td>
                        <td class="text-center" colspan="2"><%=kDOORTYPE_text%></td>
                        </tr>

                        <tr>
                        <th class="text-center" colspan="2">도어W</th>
                        <th class="text-center" colspan="2">도어H</th>
                        </tr>
                        <tr>
                        <td class="text-center" colspan="2"><%=kdoor_w%></td>
                        <td class="text-center" colspan="2"><%=kdoor_h%></td>
                        </tr>

                        <tr>
                        <th class="text-center" colspan="2">도어유리W</th>
                        <th class="text-center" colspan="2">도어유리H</th>
                        </tr>
                        <tr>
                        <td class="text-center" colspan="2"><%=kdoorglass_w%></td>
                        <td class="text-center" colspan="2"><%=kdoorglass_h%></td>
                        </tr>

                        <tr>
                        <th class="text-center" colspan="2">도어 사이즈 추가 가격</th>
                        <th class="text-center" colspan="2">도어 가격</th>
                        </tr>
                        <tr>
                        <td class="text-center" colspan="2"><%=FormatNumber(kdoorsizechuga_price, 0, -1, -1, -1) & " 원"%></td>
                        <td class="text-center" colspan="2"><%=FormatNumber(kdoor_price, 0, -1, -1, -1) & " 원"%></td>
                        </tr>
                        </table>

                        <%
                        Rs2.MoveNext
                        Loop
                        End if
                        Rs2.close
                        %>
                </div>
                <div class="mb-2">
                    <table class="table table-bordered mb-3">
                        <tr>
                            <th>픽스유리 가로</th>
                            <th>픽스유리 세로</th>
                        </tr>
                    <%
                    SQL = "SELECT a.glass_w, a.glass_h"
                    SQL = SQL & " FROM tk_framekSub a"
                    SQL = SQL & " WHERE a.fkidx='" & rfkidx & "'"
                    SQL = SQL & " AND gls<>0"
                    'Response.write (SQL)&"<br>"
                    Rs.Open SQL, Dbcon
                    If Not (Rs.BOF Or Rs.EOF) Then
                        Do While Not Rs.EOF
                            glass_w = Rs(0)
                            glass_h = Rs(1)
                    If Not IsNull(glass_w) And Not IsNull(glass_h) Then
                    %>
                        <tr>
                            <td><input type="number" class="form-control" name="door_w" value="<%=glass_w%>" readonly></td>
                            <td><input type="number" class="form-control" name="door_h" value="<%=glass_h%>" readonly></td>
                        </tr>
                    <%
                    End If
                            Rs.MoveNext
                        Loop
                    End If
                    Rs.Close
                    %>
                    </table>
                </div>
                <div class="input-group mb-2">
                    <table class="table">
                        <thead>
                            <th class="text-center"><i class="fa-solid fa-clone" style="color: #74C0FC;" onclick="wincopy();"></i></th>
                            <th class="text-center"></th>
                            <th class="text-center">길이</th>
                            <th class="text-center">단가</th>
                            <th class="text-center">할증</th>
                            <th class="text-center">가격</th>
                        </thead>
                        <tbody  class="table-group-divider">
                            <%
                            SQL="Select B.fksidx, B.unitprice, c.pcent, B.sprice, B.blength"
                            SQL=SQL&" from tk_framek A "
                            SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
                            SQL=SQL&" Left OUter Join tk_barasiF C On B.bfidx=C.bfidx "
                            SQL=SQL&" Where A.sjidx='"&rsjidx&"' and A.sjsidx='"&rsjsidx&"' "
                            'Response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            Do while not Rs.EOF
                                fksidx=Rs(0)
                                unitprice=Rs(1)
                                pcent=Rs(2)
                                sprice=Rs(3)
                                blength=Rs(4)
                                if rfksidx="" then rfksidx="0" end if
                                lbn=lbn+1
                            %>
                        <tr <% if Cint(fksidx)=Cint(rfksidx) then %>class="table-warning" <% end if %>>
                            <td class="text-center"><input type="checkbox" class="form-check-input" name="afksidx" value="<%=fksidx%>"></td> 
                            <td class="text-center"><%=lbn%></td> 
                            <td class="text-center"><%=blength%></td>      
                            <td class="text-center"><%=unitprice%></td>
                            <td class="text-center"><%=pcent%></td>
                            <td class="text-center"><%=sprice%></td>
                        </tr>
                            <%
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                            %> 
                        </tbody>
                    </table>
                </div>
                <%
                'Response.Write "sjb_idx: " & sjb_idx & "<br>"
                'Response.Write "rqtyidx: " & rqtyidx & "<br>"
                'Response.Write "yfidx: " & yfidx & "<br>"
                'Response.Write "rqtyco_idx: " & rqtyco_idx & "<br>"
                'Response.Write "qtyco_idx: " & qtyco_idx & "<br>"
                %>
        </div>
        <div class="second-flex-grow"> <!-- 가운데 SVG 영역 -->  
            <!-- 두번째 줄 두 번째 칸 시작 -->
                <div class="canvas-container" id="svgCanvas" style="width: 100%; height: 100%; padding: 0px;">
                    <div class="svg-container">
                        <svg id="canvas" width="100%" height="100%" class="d-block">
                        <g id="viewport" transform="translate(0, 0) scale(1)">
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

                        Dim real_ratio, svg_ratio
If ysize <> 0 Then
    real_ratio = CDbl(yblength) / CDbl(ysize)
Else
    real_ratio = 1
End If

If hi <> 0 Then
    svg_ratio = CDbl(wi) / CDbl(hi)
Else
    svg_ratio = 1
End If

' 중간에 CInt나 CByte 대신 CLng 사용
Dim temp
If svg_ratio > 1 Then
    If real_ratio > 1 Then
        sub_yblength = CLng(yblength)
        sub_ysize   = CLng(ysize)
    Else
        temp         = CLng(yblength)
        sub_yblength = CLng(ysize)
        sub_ysize   = temp
    End If
Else
    If real_ratio > 1 Then
        temp         = CLng(yblength)
        sub_yblength = CLng(ysize)
        sub_ysize   = temp
    Else
        sub_yblength = CLng(yblength)
        sub_ysize   = CLng(ysize)
    End If
End If
                        
                        if fstype="2" then %>
                            <defs>
                            <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
                                <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
                            </pattern>
                            </defs>
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" 
                            onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&fksidx=<%=fksidx%>');" data-value="id=<%=fksidx%>;width=<%=sub_yblength%>;height=<%=sub_ysize%>;"/> 
                        <% else 
                        
                

                        %>
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" 
                            onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>&fksidx=<%=fksidx%>');" data-value="id=<%=fksidx%>;width=<%=sub_yblength%>;height=<%=sub_ysize%>;"/>
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
                <!-- 두번째 줄 두 번째 칸 끝 -->
            </div>  
    </div>    
        <div class="second-right">
            <!-- 두번째 줄 세 번째 칸 시작 -->
                <% if rfkidx<>"" then %>
                    <div><button class="btn btn-success btn-small" type="button" Onclick="window.open('TNG1_B_doorhchg.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>','doorchg','top=100 left=400 width=500 height=400');">기타옵션</button></div>
                <% end if%>
                <% if rfkidx<>"" and zdooryn=1 then %>
                    <div><button class="btn btn-secondary  btn-small" type="button" Onclick="window.open('TNG1_B_doorpop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>','TNG1_B_doorpop','top=100 left=400 width=1000 height=800');">도어수주</button></div>
                <% end if%>
                <div style="border: 1px solid black; padding: 0px;"> 
                    <div class="input-group mb-2"> 
                        <label class="form-check-label" for="jaebun">재분</label>
                        <input class="form-check-input me-2" type="radio" name="jaebun" value="1" id="jaebun" style="width: 30px; height: 30px;" 
                        <% If cint(rjaebun) = 1 Then Response.Write "checked" end if %>
                        onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>&mode=<%=mode%>&mode1=jaebun&busok=1&busoktype=1&jaebun=1');">
                        <label class="form-check-label" for="jaebun">재분없음</label>
                        <input class="form-check-input me-2" type="radio" name="jaebun" value="0" id="jaebun" style="width: 30px; height: 30px;" 
                        <% If cint(rjaebun) = 0 Then Response.Write "checked" end if %>
                        onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>&mode=<%=mode%>&mode1=jaebun&busok=1&busoktype=0&jaebun=0');">
                        <label class="form-check-label" for="jaebun">재분_갈바보강</label>
                        <input class="form-check-input me-2" type="radio" name="jaebun" value="2" id="jaebun" style="width: 30px; height: 30px;" 
                        <% If cint(rjaebun) = 2 Then Response.Write "checked" end if %>
                        onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>&mode=<%=mode%>&mode1=jaebun&busok=1&busoktype=2&jaebun=2');">
                    </div>
                </div>  
                <div style="border: 1px solid black; padding: 0px;">  
                    <div class="input-group mb-2">
                        <label class="form-check-label" for="boyang">보양</label>
                        <input class="form-check-input me-2" type="radio" name="boyang" value="1" id="boyang" style="width: 30px; height: 30px;" 
                        <% If cint(rboyang) = 1 Then Response.Write "checked" End If %>
                        onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>&mode=<%=mode%>&mode1=jaebun&mode3=boyang&busok=2&busoktype=3&boyang=1');">
                    </div>
                    <div class="input-group mb-2">
                        <label class="form-check-label" for="boyang">보양없음</label>
                        <input class="form-check-input me-2" type="radio" name="boyang" value="0" id="boyang" style="width: 30px; height: 30px;" 
                        <% If cint(rboyang) = 0 Then Response.Write "checked" End If  %>
                        onclick="location.replace('TNG1_B_suju.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>&mode=<%=mode%>&mode1=boyang&busok=2&busoktype=0&boyang=0');">
                    </div>
                </div>

            <div class="container mt-2" style="padding:2px;" >
                <div class="button-grid">

                <%
                if rfksidx<>"" then 
                %>
                    <button type="button" class="btn btn-secandary" onclick="wresize('minus');">가로바줄이기</button> 
                    <button type="button" class="btn btn-secandary" onclick="wresize('plus');">가로바늘이기</button> 
                    <button type="button" class="btn btn-secandary" onclick="hresize('minus');">세로바줄이기</button> 
                    <button type="button" class="btn btn-secandary" onclick="hresize('plus');">세로바늘이기</button> 
                    <button type="button" class="btn btn-secandary" onclick="converge('movel');">좌측이동</button> 
                    <button type="button" class="btn btn-secandary" onclick="converge('mover');">우측이동</button> 
                    <button type="button" class="btn btn-secandary" onclick="converge('moveu');">위로이동</button> 
                    <button type="button" class="btn btn-secandary" onclick="converge('moved');">아래로이동</button> 
                <%
                end if
                %>    
                <!--    
                    <button type="button" class="btn btn-secandary" onclick="converge('left');">좌측붙이기</button> 
                    <button type="button" class="btn btn-secandary" onclick="converge('right');">우측붙히기</button> 
                -->
                </div>
            </div>
            <div class="container mt-2" style="padding:2px;" >
                <div class="button-grid">
                    <%
                    'if rni="" then rni="0" end if '오류방지를 위해 수신된 순번값 rni변수 0으로 초기화
                    SQL="Select setstd from tk_framek where fkidx='"&rfkidx&"' "
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    setstd=Rs(0)
                    End if
                    Rs.Close
                    

                    SQL="select count(*) from tk_framek where sjidx='"&rsjidx&"' and sjsidx='"&rsjsidx&"'"
                    Rs.open Sql,Dbcon
                    cntni=Rs(0)
                    Rs.close

                    For ni = 1 to cntni
                    
                    if Cint(setstd)=Cint(ni) then 
                        class_text="<u>정렬["&ni&"]번</u>"
                    else
                        class_text="정렬["&ni&"]번"
                    end if
                    %>  
                        <button type="button" class="btn btn-secandary" onclick="setstd('<%=ni%>','<%=rfkidx%>');"><%=class_text%></button>
                    <%
                    Next
                    %> 
                    <button type="button" class="btn btn-secandary" onclick="framedel('<%=rfkidx%>');">프레임삭제</button> 
                    <button type="button" class="btn btn-secandary" onclick="bardel('<%=rfksidx%>');">바삭제</button> 
                </div>
            </div>
            <% if rfkidx<>"" then %>
            <div class="container mt-2" style="padding:2px;" >
                <div class="button-grid">
                    <button type="button" class="btn btn-secandary" onclick="location.replace('TNG1_B_suju.asp?gubun=glass&sjidx=<%=rsjidx%>&sjb_idx=<%=rsjb_idx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>');">유리추가</button>
                <% if rfksidx<>"" then %>
                    <button type="button" class="btn btn-secandary" onclick="location.replace('TNG1_B_suju.asp?gubun=covered&sjidx=<%=rsjidx%>&sjb_idx=<%=rsjb_idx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>');">묻힘추가</button>
                <% else %>
                <button type="button" class="btn btn-secandary" onclick="alert('적용 할 세로바를 먼전 선택 하세요.');">묻힘추가</button>
                <% end if%>
                </div>
            </div>
            <% if Request("gubun")="glass" then %>
                <div class="container mt-0" style="padding:2px;" >
                <div class="button-grid">
                    <%
                    sql = "SELECT sjbtidx, SJB_TYPE_NO, SJB_TYPE_NAME , sjbtstatus"
                    sql = sql & " , dwsize1, dhsize1, dwsize2, dhsize2, dwsize3, dhsize3, dwsize4, dhsize4, dwsize5, dhsize5"
                    sql = sql & " , gwsize1, ghsize1, gwsize2, ghsize2, gwsize3, ghsize3, gwsize4, ghsize4, gwsize5, ghsize5, gwsize6, ghsize6 "
                    sql = sql & " , SJB_FA "
                    sql = sql & " FROM tng_sjbtype "
                    sql = sql & " WHERE sjbtstatus = 1 and SJB_TYPE_NO='"&rsjb_type_no&"' "
                    'Response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon,1,1,1
                    if not (Rs.EOF or Rs.BOF ) then
                        sjbtidx       = Rs(0)
                        SJB_TYPE_NO   = Rs(1)
                        SJB_TYPE_NAME = Rs(2)
                        sjbtstatus    = Rs(3)

                        dwsize1       = Rs(4)
                        dhsize1       = Rs(5)
                        dwsize2       = Rs(6)
                        dhsize2       = Rs(7)
                        dwsize3       = Rs(8)
                        dhsize3       = Rs(9)
                        dwsize4       = Rs(10)
                        dhsize4       = Rs(11)
                        dwsize5       = Rs(12)
                        dhsize5       = Rs(13)

                        gwsize1       = Rs(14)
                        ghsize1       = Rs(15)
                        gwsize2       = Rs(16)
                        ghsize2       = Rs(17)
                        gwsize3       = Rs(18)
                        ghsize3       = Rs(19)
                        gwsize4       = Rs(20)
                        ghsize4       = Rs(21)
                        gwsize5       = Rs(22)
                        ghsize5       = Rs(23)
                        gwsize6       = Rs(24)
                        ghsize6       = Rs(25)

                        SJB_FA        = rs(26)
                        %>
                        <% if dwsize1<>"0" or dhsize1<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('d1','<%=dwsize1%>','<%=dhsize1%>');">외도어편개</button>
                        <% end if %>
                        <% if dwsize2<>"0" or dhsize2<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('d2','<%=dwsize2%>','<%=dhsize2%>');">양개</button>
                        <% end if %>
                        <% if dwsize3<>"0" or dhsize3<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('d3','<%=dwsize3%>','<%=dhsize3%>');">언밸런스</button>
                        <% end if %>
                        <% if dwsize4<>"0" or dhsize4<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('d4','<%=dwsize4%>','<%=dhsize4%>');">도어4</button>
                        <% end if %>
                        <% if dwsize5<>"0" or dhsize5<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('d5','<%=dwsize5%>','<%=dhsize5%>');">도어5</button>
                        <% end if %>

                        <% if gwsize1<>"0" or ghsize1<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('g1','<%=gwsize1%>','<%=ghsize1%>');">하부픽스1</button>
                        <% end if %>
                        <% if gwsize2<>"0" or ghsize2<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('g2','<%=gwsize2%>','<%=ghsize2%>');">박스라인하부픽스2</button>
                        <% end if %>
                        <% if gwsize3<>"0" or ghsize3<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('g3','<%=gwsize3%>','<%=ghsize3%>');">상부픽스1</button>
                        <% end if %>
                        <% if gwsize4<>"0" or ghsize4<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('g4','<%=gwsize4%>','<%=ghsize4%>');">상부픽스2</button>
                        <% end if %>
                        <% if gwsize5<>"0" or ghsize5<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('g5','<%=gwsize5%>','<%=ghsize5%>');">상부픽스3</button>
                        <% end if %>
                        <% if gwsize6<>"0" or ghsize6<>"0" then %>
                            <button type="button" class="btn btn-secandary" onclick="addglass('g6','<%=gwsize6%>','<%=ghsize6%>');">상부픽스4</button>
                        <% end if %>
                        <%
                        End If 
                        Rs.Close 
                        %>   
                </div>
                </div> 
                <% end if %>
                <% if Request("gubun")="covered" then %>
                    <div class="container mt-0" style="padding:2px;" >
                        <div class="button-grid">
                        <button type="button" class="btn btn-secandary" onclick="addcovered('top');">상단묻힘</button>
                        <button type="button" class="btn btn-secandary" onclick="addcovered('bottom');">하단묻힘</button>
                        </div>
                    </div> 
                <% end if %>


                <% end if %> 
            <!-- 두번째 줄 세 번째 칸 끝 -->
        </div>
    </div>
    </div>
    <!-- 세 번째 줄 (200px 고정) -->
    <div class="third-row">
        <div class="third-inner">
            <div class="fixed-width">
                <!-- 세 번째 줄 첫 번째 칸 (300px) -->
                <div class="card card-custom">
                    <div class="card-header"><%=aset_name_AUTO%><%=aset_name_Fix%></div>
                    <div class="card-body">
                    <% if abfimg3<>"" then %>
                        <img src="/img/frame/bfimg/<%=abfimg3%>" loading="lazy" width="180" height="100"  border="0">
                    <% elseif abfimg1<>"" then %>
                        <img src="/img/frame/bfimg/<%=abfimg1%>" loading="lazy" width="180" height="100"  border="0">
                    <% elseif abfimg2<>"" then %>
                        <img src="/img/frame/bfimg/<%=abfimg2%>" loading="lazy" width="180" height="100"  border="0">
                    <% end if %>
                    </div>
                </div>
            </div>
            <div class="flex-grow">
            <div class="scroll-container">
                <%
                SQL=" Select bfidx, set_name_Fix, set_name_AUTO, whichi_auto, whichi_fix, xsize, ysize, bfimg1, bfimg2, bfimg3 "
                SQL=SQL&" , tng_busok_idx, tng_busok_idx2 "
                SQL=SQL&" From tk_barasiF "
                SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' and bfidx<>'"&abfidx&"'"
                If aWHICHI_AUTO <> "0" Then 
                SQL = SQL & " AND whichi_auto = '" & aWHICHI_AUTO & "' "
                End if
                If aWHICHI_FIX <> "0" Then 
                SQL = SQL & " AND whichi_fix = '" & aWHICHI_FIX & "' "
                End If
                'Response.write (SQL)&"<br>"
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                bfidx=Rs(0)
                set_name_Fix=Rs(1)
                set_name_AUTO=Rs(2)
                whichi_auto=Rs(3)
                whichi_fix=Rs(4)
                xsize=Rs(5)
                ysize=Rs(6)
                bfimg1=Rs(7)
                bfimg2=Rs(8)
                bfimg3=Rs(9)
                tng_busok_idx=Rs(10)
                tng_busok_idx2=Rs(11)
                %>
            <div class="card card-custom">
                <div class="card-header"><%=set_name_AUTO%><%=set_name_Fix%></div>
                <div class="card-body">
                    <% if bfimg3<>"" then %>
                    <a onclick="chgbarasif('<%=bfidx%>');"><img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="180" height="100"  border="0"></a>
                    <% elseif bfimg1<>"" then %>
                    <img src="/img/frame/bfimg/<%=bfimg1%>" loading="lazy" width="180" height="100"  border="0">
                    <% elseif bfimg2<>"" then %>
                    <img src="/img/frame/bfimg/<%=bfimg2%>" loading="lazy" width="180" height="100"  border="0">
                    <% end if %>
                </div>
            </div>
                <%
                Rs.movenext
                Loop
                End if
                Rs.close
                %> 
            </div>
            </div>
        </div>
    </div>
</div>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>
  <!-- 드롭다운 스크립트 -->
  <script>
    let currentOpen = null;
    function toggleDropdown(num) {
      const selected = document.getElementById(`dropdown-${num}`);
      if (currentOpen === num) {
        selected.style.display = 'none';
        currentOpen = null;
      } else {
        for (let i = 1; i <= 6; i++) {
          const el = document.getElementById(`dropdown-${i}`);
          if (el) el.style.display = 'none';
        }
        selected.style.display = 'block';
        currentOpen = num;
      }
    }
  </script>
<script>
  const svg = document.getElementById("svgCanvas");
  const viewport = document.getElementById("viewport");

  let scale = 1;
  let translateX = 0;
  let translateY = 0;

  // 마우스 휠 확대/축소
  svg.addEventListener("wheel", function (event) {
    event.preventDefault();
    const zoomSpeed = 0.1;
    const delta = event.deltaY > 0 ? -1 : 1;
    scale += delta * zoomSpeed;
    scale = Math.min(Math.max(scale, 0.2), 5);
    updateTransform();
  });

  // 드래그 이동
  let isDragging = false;
  let startX, startY;

  svg.addEventListener("mousedown", function (event) {
    if (event.button === 0) { // 왼쪽 버튼
      isDragging = true;
      startX = event.clientX;
      startY = event.clientY;
    }
  });

  svg.addEventListener("mousemove", function (event) {
    if (isDragging) {
      const dx = event.clientX - startX;
      const dy = event.clientY - startY;
      translateX += dx;
      translateY += dy;
      startX = event.clientX;
      startY = event.clientY;
      updateTransform();
    }
  });

  svg.addEventListener("mouseup", function () {
    isDragging = false;
  });

  svg.addEventListener("mouseleave", function () {
    isDragging = false;
  });

  function updateTransform() {
    viewport.setAttribute("transform", `translate(${translateX}, ${translateY}) scale(${scale})`);
  }
</script>  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- 도면 수치 표현 모듈 - 엣지 주석기 -->
<script src="http://tkd001.cafe24.com/schema/horizontal.js"></script>
<script src="http://tkd001.cafe24.com/schema/vertical.js"></script>
</body>
</html>
<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
