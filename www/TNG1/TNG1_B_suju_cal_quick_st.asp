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

    SQL = "SELECT a.sjcidx, b.cname,b.cgubun, b.cdlevel, b.cflevel "
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
rdoorglass_t =Request("doorglass_t") '도어유리두께
rfixglass_t =Request("fixglass_t") '픽스유리두께
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
    If Not (Rs.bof or Rs.eof) Then 
        fix_fidx=Rs(0)
    End If
    Rs.Close

    if fix_fidx=0 then
        Response.Write "<script>"
        Response.Write "location.replace('TNG1_B_suju_cal_fix.asp?" & _
            "cidx=" & rsjcidx & _
            "&sjidx=" & rsjidx & _
            "&sjb_idx=" & rsjb_idx & _
            "&sjb_type_no=" & rsjb_type_no & _
            "&sjsidx=" & rsjsidx & _
            "&fkidx=" & rfkidx & "');"
        Response.Write "</script>"
        Response.End
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
        'response.write (SQL)&"<br>"
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
    'Response.write (SQL)&"<br>11111<br>"
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

end if

    '==========일반절곡 단가 구하기
    if rsjb_type_no=13 then

    ' 스텐 미터당단가계산 시작

    '=================수량 가져오기
    SQL = "SELECT quan from tk_framek where fkidx = '" & rfkidx & "' "
    Response.write (SQL)&"<br>"
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
    Response.write (SQL)&"<br>"
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
            Response.write (SQL1)&"<br>" 
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
        Response.write (SQL)&"<br><br>"
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
                Response.write (SQL)&"<br>"
                'response.end
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    unitprice=Rs1(0)
                    response.write "단가:"&unitprice&"<br>"
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
            Response.write (SQL)&"<br>"
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
        Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                sjsprice=Rs1(0)
            End If
            Rs1.Close'1

        sql="select SUM(door_price) from tk_frameksub "
        sql=sql&" where fkidx='"&rfkidx&"' "
        sql=sql&" and doortype in (1,2) " '도어 타입 (1:편개, 2:양개) 
        Response.write (SQL)&"<br>"
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
        '======= 0=기본 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D 10% 업 , 5=E=======
        '======= cflevel 분기 =======
        disrate = 0  '할인율 초기화 (기본값: 100% 즉, 할인 없음)

        Select Case cflevel
            Case 0
                disrate = 0  ' 할인 없음

            Case 1
                disrate = 10 ' 무조건 10% 할인

            Case 2
                If rsjb_type_no = 11 Or rsjb_type_no = 12 Then
                    disrate = 10 ' 수동 스텐 보급만 10% 할인
                End If

            Case 3
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 4 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Then
                    disrate = 10 ' 자동만 10% 할인 이중하고 포켓 슬림 제외
                End If

            Case 4
                disrate = -10 ' 10% 증가 (업)
        End Select

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



    end if



response.write"<script>location.replace('tng1_b_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>