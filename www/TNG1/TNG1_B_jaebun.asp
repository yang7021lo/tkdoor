
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
rsjsidx=Request("sjsidx") '수주주문품목키
rpidx=Request("pidx") '도장 페인트키  
rqtyidx=Request("qtyidx") '재질키
'Response.Write "rqtyidx: " & rqtyidx & "<br>" 
    If rqtyidx = 5 Then 
        rpidx = 0
    end if
    If rqtyidx = 7 Then 
        rqtyidx = 3
    end if
rqtyco_idx=Request("qtyco_idx") '재질키서브
    If rqtyco_idx = 77 Then 
        rpidx = 0
    end if
rjaebun=Request("jaebun") ' 1 재분 2재분보강 0삭제   // busok 1 재분 2보양 3로비폰
rboyang=Request("boyang")
rbusok=Request("busok") ' 1 재분 2보양 3로비폰
mode=Request("mode")
'Response.Write "mode " & mode & "<br>" 
'response.end
            'Response.Write "rjaebun 재료분리대: " & rjaebun & "<br>" 
'▣ 편개 (공통 / 좌우 아님)
' 9   편개
' 12  편개_상부남마
' 15  편개_상부남마_중
' 28  편개_박스라인
' 31  편개_상부남마_박스라인
' 34  편개_상부남마_중_박스라인
'▣ 편개_좌
' 16  좌_편개
' 22  좌_편개_남마
' 35  좌_편개_박스라인
' 41  좌_편개_남마_박스라인
'▣ 편개_우
' 17  우_편개
' 23  우_편개_남마
' 36  우_편개_박스라인
' 42  우_편개_남마_박스라인
'▣ 양개 (공통 / 좌우 아님)
' 10  양개
' 13  양개_상부남마
' 29  양개_박스라인
' 32  양개_상부남마_박스라인
'▣ 양개_좌
' 18  좌_양개
' 24  좌_양개_남마
' 37  좌_양개_박스라인
' 43  좌_양개_남마_박스라인
'▣ 양개_우
' 19  우_양개
' 25  우_양개_남마
' 38  우_양개_박스라인
' 44  우_양개_남마_박스라인
'▣ 고정창 (공통 / 좌우 아님)
' 11  고정창
' 14  고정창_상부남마
' 30  고정창_박스라인
' 33  고정창_상부남마_박스라인
'▣ 픽스_좌
' 20  좌_픽스
' 26  좌_픽스_남마
' 39  좌_픽스_박스라인
' 45  좌_픽스_남마_박스라인
'▣ 픽스_우
' 21  우_픽스
' 27  우_픽스_남마
' 40  우_픽스_박스라인
' 46  우_픽스_남마_박스라인

If rjaebun  <> "" Then

    SQL = "SELECT sjb_type_no,greem_o_type,fl,ow,greem_f_a,greem_fix_type ,quan "
    sql=sql&" from tk_framek "
    sql=sql&" where fkidx = '" & rfkidx & "'  "
    'Response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then

        qsjb_type_no=rs1(0)
        qgreem_o_type=rs1(1) 
        qfl=rs1(2) ' 묻힘값
        qow=rs1(3) '오픈 
        qgreem_f_a=rs1(4) ' 수동 1 자동 2
        qgreem_fix_type=rs1(5) 
        qquan=rs1(6) 

    End If
    Rs1.Close '2

    SQL = "SELECT b.blength, b.whichi_fix  "
    sql=sql&" from tk_framek a "
    sql=sql&" join tk_frameksub b on a.fkidx = b.fkidx "
    sql=sql&" where a.fkidx = '" & rfkidx & "'  "
    sql=sql&" and a.greem_f_a = 1  "
    sql=sql&" and b.whichi_fix in (4,22)  "
    'Response.write (SQL)&"<br>"
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then

        qblength=rs1(0) ' 길이

    End If
    Rs1.Close '2

    if rjaebun = 1 or rjaebun = 2 then
        Select Case qsjb_type_no
            Case 1, 2:         sch_xsize = 43
            Case 3, 4:         sch_xsize = 53
            Case 5:            sch_xsize = 34
            Case 8, 10, 15:    sch_xsize = 51
            Case 9:            sch_xsize = 63
            Case 6,7,11,12:    sch_xsize = 40
            Case Else:         sch_xsize = 0
        End Select
        sch_ysize = qfl ' 묻힘값
        If sch_xsize > 0 Then
            ' 조건에 따라 갈바보강 포함 여부로 bfidx 조회
            If rjaebun = 1 Then
                SQL = "SELECT  bfidx FROM tk_barasiF "
                SQL = SQL & " WHERE ( sjb_idx=127 or sjb_idx=128 ) "
                SQL = SQL & " AND xsize=" & sch_xsize & " AND ysize=" & sch_ysize & " "
                SQL = SQL & " AND (set_name_AUTO NOT LIKE '%갈바보강%' or  set_name_fix NOT LIKE '%갈바보강%') "
                    'Response.Write SQL & "<br>"
            ElseIf rjaebun = 2 Then
                SQL = "SELECT  bfidx FROM tk_barasiF "
                SQL = SQL & " WHERE ( sjb_idx=127 or sjb_idx=128 ) "
                SQL = SQL & " AND xsize=" & sch_xsize & " AND ysize=" & sch_ysize & " "
                SQL = SQL & " AND (set_name_AUTO  LIKE '%갈바보강%' or  set_name_fix  LIKE '%갈바보강%') "
                    'Response.Write SQL & "<br>"
            End If
            'Response.Write SQL & "<br>"
            rs1.Open SQL, Dbcon
            If Not (rs1.BOF Or rs1.EOF) Then
                bfidx_val = rs1(0)
                'Response.Write "bfidx_val : " & bfidx_val & "<br>"
            End If
            rs1.Close    
            
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
                zfix = rs2(4)  ' 롯트바 = 4  박스라인롯트바 = 22 
                zauto = rs2(5)
                if qgreem_f_a = 2 then  ' 자동

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
                    
                    ' 단가 결정 (자동일 경우)
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

                    'Response.Write "qow : " & qow & "<br>"
                    
                    'Response.Write "unitprice_jaebun : " & unitprice_jaebun & "<br>"

                elseif qgreem_f_a = 1 then ' 수동

                    Select Case qgreem_fix_type
                        '▣ 편개 (공통 / 좌우 아님)
                        Case 9, 12, 15, 28, 31, 34 , 6, 22, 35, 41 , 17, 23, 36, 42
                            xi= xi
                            yi= 480 
                            wi= wi
                            hi= 10
                        '▣ 양개 (공통 / 좌우 아님)
                        Case 10, 13, 29, 32 , 18, 24, 37, 43, 19, 25, 38, 44
                            xi= xi 
                            yi= 480
                            wi= wi *2 
                            hi= 10
                        Case Else
                            ' ☑ 예외 처리
                    End Select
                    ' 단가 결정
                    ' 롯트바 = 4  박스라인롯트바 = 22 
                    If qblength > 0 And qblength <= 1250 Then
                        If rjaebun = 2 Then
                            unitprice_jaebun = 20000
                        Else
                            unitprice_jaebun = 15000
                        End If
                    ElseIf qblength > 1250 Then
                        If rjaebun = 2 Then
                            unitprice_jaebun = 25000
                        Else
                            unitprice_jaebun = 20000
                        End If
                    End If

                    Response.Write "qblength : " & qblength & "<br>"
                    Response.Write "unitprice_jaebun : " & unitprice_jaebun & "<br>"
                end if    
                
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
            End If
            rs2.Close

            total_unitprice_jaebun = unitprice_jaebun 
            update_unitprice_jaebun = unitprice_jaebun * qquan

            SQL="select count(busok) from tk_framekSub where fkidx = '" & rfkidx & "'  and busok = 1 "
            rs3.Open SQL, Dbcon
            'Response.Write SQL & "<br>"
            If Not (rs3.BOF Or rs3.EOF) Then
                count_jaebun = rs3(0) ' busok = 1 인 경우     
            End If
            rs3.Close 
            'Response.Write "count_jaebun : " & count_jaebun & "<br>"
            
            if qgreem_f_a = 1 then
            jaebun_blength = qblength
            else
            jaebun_blength = qow
            end if

            if count_jaebun=0 then
                SQL = "INSERT INTO tk_framekSub (fkidx, whichi_fix, whichi_auto, bfidx, blength, unitprice, xi, yi, wi, hi,busok,xsize,ysize ,gls) "
                SQL = SQL & "VALUES ('" & rfkidx & "', '" & whichi_fix_val & "', '" & whichi_auto_val & "', '" & bfidx_val & "' "
                SQL = SQL & ", '" & jaebun_blength & "' , '" & total_unitprice_jaebun & "', '" & xi & "', '" & yi & "'  "
                SQL = SQL & ", '" & wi & "', '" & hi & "',  1 , '" & sch_xsize & "', '" & sch_ysize & "', 0 )"
                'Response.Write SQL & "11111<br>"
                Dbcon.Execute SQL
            ElseIf count_jaebun = 1 Then
                SQL = "UPDATE tk_framekSub SET "
                SQL = SQL & "whichi_fix = '" & whichi_fix_val & "', "
                SQL = SQL & "whichi_auto = '" & whichi_auto_val & "', "
                SQL = SQL & "bfidx = '" & bfidx_val & "', "
                SQL = SQL & "blength = '" & jaebun_blength & "', "
                SQL = SQL & "unitprice = '" & total_unitprice_jaebun & "', "
                SQL = SQL & "xi = '" & xi & "', "
                SQL = SQL & "yi = '" & yi & "', "
                SQL = SQL & "wi = '" & wi & "', "
                SQL = SQL & "hi = '" & hi & "', "
                SQL = SQL & "xsize = '" & sch_xsize & "', "
                SQL = SQL & "ysize = '" & sch_ysize & "', "
                SQL = SQL & "busok = 1 "
                SQL = SQL & "WHERE fkidx = '" & rfkidx & "' AND whichi_fix = '" & whichi_fix_val & "' AND whichi_auto = '" & whichi_auto_val & "' and busok = 1 "
                'Response.Write SQL & "11111<br>"
                Dbcon.Execute SQL
            End If

        jaebun_blength = ""

        SQL="Update tk_framek set jaeryobunridae='"&total_unitprice_jaebun&"', jaeryobunridae_type='"&rjaebun&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)    
        End If

    ElseIf rjaebun = "0"  Then
        ' ✅ DELETE
        SQL = "DELETE FROM tk_framekSub WHERE fkidx = '" & rfkidx & "' AND busok = 1 "
        'Response.Write SQL & "<br>"
        Dbcon.Execute SQL

        SQL="Update tk_framek set jaeryobunridae=0 , jaeryobunridae_type=0 "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)    

    End If
End If
'Response.Write "mode " & mode & "<br>" 
'response.end
if mode="quick" then

response.write"<script>location.replace('TNG1_B_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"

else

response.write"<script>location.replace('tng1_b_suju2.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"

end if

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>