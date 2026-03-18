
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
        cflevel   = Rs1(4) ' 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=E
    End If
    Rs1.Close


rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
rsjb_type_no=Request("sjb_type_no") '제품타입
rsjbsub_Idx=Request("sjbsub_Idx")
rfkidx=Request("fkidx")
rsjsidx=Request("sjsidx") '수주주문품목키
rpidx=Request("pidx") '도장 페인트키  

'Response.Write "rsjb_type_no 도장칼라: " & rsjb_type_no & "<br>" 

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
        
        '=================제품 가격 입력 시작
            SQL = "SELECT fidx,tw,th,greem_o_type ,quan from tk_framek where fkidx = '" & rfkidx & "' "
            'Response.write (SQL)&"<br>"
            'response.end
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then
                yfidx=rs1(0)
                ytw=rs1(1)
                yth=rs1(2)
                ygreem_o_type=rs1(3)
                yquan=rs1(4) '수량

                if yfidx >= 25 then
                    yfidx =  yfidx - 24   '(24개의 방향때문에 좌에서 우로 바뀌면서 생긴..)
                end if

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
                        'response.write "단가:"&unitprice&"<br>"
                    End If
                    Rs1.Close '2
                rqtyidx = original_rqtyidx ' rqtyidx 원래 값으로 복원
                
                Response.Write "bwhichi_auto : " & bwhichi_auto & "<br>"
                Response.Write "bfksidx : " & bfksidx & "<br>"
                Response.Write "unitprice : " & unitprice & "<br>"
                Response.Write "bpcent : " & bpcent & "<br>"  
                Response.Write "bblength : " & bblength & "<br>"  
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
        End If
        Rs1.Close'1

    end if










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

        
        'Response.Write "sjsprice : " & sjsprice & "<br>"   
        'Response.Write "py_chuga : " & py_chuga & "<br>"   
        'Response.Write "bdoor_price : " & bdoor_price & "<br>"  
        if rsjb_type_no >= 1 and rsjb_type_no <= 5 then
            sjsprice_total = sjsprice + py_chuga - bdoor_price + sjsprice_fix542 'sjsprice는 모든 추가금이 합산된 최종금액. 새로운 컬럼 (평당추가건 py_chuga) 
        end if
        sjsprice_total = -Int(-sjsprice_total / 1000) * 1000 '무조건 천 단위로 올림
        
        'Response.Write "sjsprice_total : " & sjsprice_total & "<br>"   
        'Response.Write "py_chuga : " & py_chuga & "<br>"   
        'Response.Write "bdoor_price : " & bdoor_price & "<br>"

        '======= 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=E=======

        disrate = 0 '할인율 초기화 (기본값: 100% 즉, 할인 없음)

        If rsjb_type_no >= 1 And rsjb_type_no <= 4 Then
            If cflevel = 3 Then ' 알자, 단알자, 삼중단알자만 10% DC
                disrate = 10
            End If

        ElseIf rsjb_type_no = 11 Or rsjb_type_no = 12 Then
            If cflevel = 2 Then ' 수동 스텐 보급만 10% DC
                disrate = 10
            End If
        End If

        ' cflevel이 1이면 무조건 DC 적용 (최우선)
        If cflevel = 1 Then
            disrate = 10
        elseIf rsjb_type_no = 5 Then

            disrate = 0 ' 슬림자동 제품은 할인 없음
            
        End If

        sjsprice_update = sjsprice_total * yquan '수량에 따른 최종 단가


        disprice = sjsprice_total * (disrate / 100)   '할인금액

        'disprice = -Int(-disprice / 1000) * 1000 '무조건 천 단위로 올림

        disprice_update = ( Int(disprice / 1000) * 1000 ) * yquan ' 수량에 따른 최종 할인금액 / 무조건 천 단위 내림

        fprice=sjsprice_update-disprice_update        '납품금액

        taxrate=fprice * 0.1                        '세액
        if taxrate < 0 then
            taxrate=round(taxrate)
        end if

        sprice=(fprice+taxrate) * yquan  '최종금액
        if sprice = 0  or isnull(sprice) then
            sprice = 0  
        end if

        
        'Response.Write "sjsprice : " & sjsprice & "<br>"   
        'Response.Write "sprice : " & sprice & "<br>"   
        'Response.Write "taxrate : " & taxrate & "<br>"  
        '===============화면에 적용버튼이 있다 할인율이라던지 어떤 고정데이터가 디폴트로 있고 상황에 따라서 바꿀수 있어야한다
        ' 적용버튼을 만들어라(견적시에는 할인율을 적용하지 않음) . 
        SQL="Update tk_framek set sjsprice='"&sjsprice_total&"', disrate='"&disrate&"',disprice='"&disprice_update&"', fprice='"&fprice&"', quan='"&yquan&"' "
        SQL=SQL&" , taxrate='"&taxrate&"', sprice='"&sprice&"', py_chuga='"&py_chuga&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
        '=================sjasub 업데이트 시작
        'SQL = "UPDATE tng_sjaSub SET "
        'SQL = SQL & " sjsprice = '" & sjsprice_total & "' , disrate = '" & disrate & "' , disprice = '" & disprice & "' , fprice = '" & fprice & "' "
        'SQL = SQL & " , quan = '" & yquan & "' , taxrate = '" & taxrate & "' , sprice = '" & sprice & "', py_chuga = '" & py_chuga & "' "
        'SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "' "
        'Response.write (SQL)&"<br>"
        'response.end
        'Dbcon.Execute (SQL)
        '=================sjasub 업데이트 끝


response.write"<script>location.replace('tng1_b_suju2.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"


set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>