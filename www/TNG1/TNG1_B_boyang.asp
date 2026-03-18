
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
        
'~~~~~~~~~~~~~부속자재 업데이트 시작  재료분리대는 busok=1 보양재는 busok=2 로비폰은 busok=3 
rboyang=Request("boyang") ' 1 보양 2 없음

rjaebun=Request("jaebun")
rbusok=Request("busok") ' 1 재분 2보양 3로비폰
mode=Request("mode")

'Response.Write "rboyang : " & rboyang & "<br>" 
'Response.Write "rbusok : " & rbusok & "<br>"

'-------------------보양 시작


If rboyang <> "" Then

    SQL = "SELECT sjb_type_no,greem_o_type,fl,ow ,greem_f_a ,quan from tk_framek where fkidx = '" & rfkidx & "' "
    'Response.write (SQL)&"<br>"
    'response.end
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
        esjb_type_no=rs1(0)
        egreem_o_type=rs1(1) 
        efl=rs1(2) ' 묻힘값
        eow=rs1(3) '오픈
        egreem_f_a=rs1(4) ' 수동 1 자동 2
        equan=rs1(5) 
  
    End If
    Rs1.Close '2

    if egreem_f_a =1 then
    Response.Write "<script>"
    Response.Write "alert('수동프레임은 보양자재가 없습니다.');"
    Response.Write "location.replace('tng1_b_suju2.asp?cidx=" & rcidx & "&sjidx=" & rsjidx & "&sjb_idx=" & rsjb_idx & "&sjb_type_no=" & rsjb_type_no & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&qtyidx=" & rqtyidx & "&pidx=" & rpidx & "');"
    Response.Write "</script>"    
    end if 

        if rboyang = 1  then

            If egreem_o_type = 1 Or egreem_o_type = 2 Or egreem_o_type = 3  Then '편개
                boyangdoor = "single"
            Else 
                boyangdoor = "double"
            End If

            If boyangdoor = "single" Then
                Select Case esjb_type_no
                    Case 1, 2, 3, 4, 5, 8, 9, 10, 15
                        boyang1 = 1  '  1 중간소대 보양
                        boyang2 = 2  '  2 자동홈바 보양
                        boyang3 = 3  '  3 재료분리대 보양
                End Select
            Else
                Select Case esjb_type_no
                    Case 1, 2, 3, 4, 5, 8, 9, 10, 15
                        boyang1 = 1  '  1 중간소대 보양
                        boyang2 = 1  '  1 중간소대 보양
                        boyang3 = 3 '  3 재료분리대 보양
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

                SQL = "SELECT bfidx , set_name_auto ,boyang , boyangtype FROM tk_barasiF"
                SQL = SQL & " WHERE sjb_idx=128  "
                SQL = SQL & " AND boyangtype=" & bval & " "
                if  esjb_type_no = 2 then
                    SQL = SQL & " AND boyang=" & 1 & " "
                elseif  esjb_type_no = 4 then
                    SQL = SQL & " AND boyang=" & 3 & " "
                else
                    SQL = SQL & " AND boyang=" & rsjb_idx & " "
                end if
                'Response.Write SQL & "<br>"
                rs1.Open SQL, Dbcon
                If Not (rs1.BOF Or rs1.EOF) Then
                    Do While Not rs1.EOF
                        bbfidx_boyang = rs1(0)
                        bset_name_auto = rs1(1)
                        bboyang = rs1(2)
                        bboyangtype = rs1(3)

                        ' 단가 결정
                        Select Case bval
                            Case 1
                                unitprice_boyang = 10000
                                bfidx_blength = 1800
                            Case 2
                                unitprice_boyang = 10000
                                bfidx_blength = 1800
                            Case 3
                                unitprice_boyang = 10000
                                bfidx_blength = eow - 10
                        End Select

                        ' count
                        SQL = "SELECT COUNT(*) FROM tk_framekSub WHERE fkidx = '" & rfkidx & "' AND whichi_auto = 22 AND busok = 2 AND bfidx = " & bbfidx_boyang & " " '보양은 busok 2
                        rs3.Open SQL, Dbcon
                        'Response.Write SQL & "<br>"
                        If Not (rs3.BOF Or rs3.EOF) Then
                            count_boyang = rs3(0) ' busok = 2 인 경우     
                        End If
                        rs3.Close 
                        'Response.Write "count_boyang : " & count_boyang & "<br>"
                            If count_boyang >= 0 And count_boyang <= 2 Then
                                SQL = "INSERT INTO tk_framekSub (fkidx, whichi_fix, whichi_auto, bfidx, blength, unitprice, busok,gls ) "
                                SQL = SQL & "VALUES ('" & rfkidx & "', 0, 22, " & bbfidx_boyang & ", " & bfidx_blength & ", " & unitprice_boyang & ", 2 ,0 )"
                                'Response.Write SQL & "11111<br>"
                                Dbcon.Execute SQL

                            Elseif count_boyang = 3 then 

                                SQL = "UPDATE tk_framekSub SET "
                                SQL = SQL & "whichi_fix = 0 , "
                                SQL = SQL & "whichi_auto =  22 , "
                                SQL = SQL & "bfidx = '" & bbfidx_boyang & "', "
                                SQL = SQL & "blength = '" & bfidx_blength & "', "
                                SQL = SQL & "unitprice = '" & unitprice_boyang & "', "
                                SQL = SQL & "busok = 2 "
                                SQL = SQL & "WHERE fkidx = '" & rfkidx & "' AND whichi_fix = 0 AND whichi_auto = 22 and busok = 2 "
                                'Response.Write SQL & "11111<br>"
                                Dbcon.Execute SQL

                            End If
                    rs1.MoveNext
                    Loop
                End If
                Rs1.Close
            Next
            
            SQL = "SELECT COUNT(*) FROM tk_framekSub WHERE fkidx = '" & rfkidx & "' AND busok = 2  " '보양은 busok 2
            rs3.Open SQL, Dbcon
            'Response.Write SQL & "<br>"
            If Not (rs3.BOF Or rs3.EOF) Then
                count_boyang2 = rs3(0) ' busok = 2 인 경우     
            End If
            rs3.Close 
            
            if count_boyang2 > 4 then
                Response.Write "<script>"
                Response.Write "alert('보양자재가 중복되었습니다. 다시 입력해주세요!');"
                Response.Write "location.replace('TNG1_B_boyang.asp?cidx=" & rcidx & "&sjidx=" & rsjidx & "&sjb_idx=" & rsjb_idx & "&sjb_type_no=" & rsjb_type_no & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&qtyidx=" & rqtyidx & "&pidx=" & rpidx & "&jaebun="&rjaebun&"&boyang=0');"
                Response.Write "</script>"
            end if 

            SQL = "SELECT SUM(unitprice) "
            SQL = SQL & "FROM tk_framekSub "
            SQL = SQL & "WHERE fkidx ='" & rfkidx & "' "
            SQL = SQL & "AND busok = 2 "
            'Response.write (SQL)&"<br>"
            Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    boyang_sjsprice=Rs1(0)
                'Response.Write "boyang_sjsprice : " & boyang_sjsprice & "<br>"   
                End If
            Rs1.Close'1

            total_boyang_sjsprice = boyang_sjsprice 
            update_boyang_sjsprice = boyang_sjsprice * equan

            SQL="Update tk_framek set boyangjea='"&total_boyang_sjsprice&"' "
            SQL=SQL&" Where fkidx='"&rfkidx&"' "
            'Response.write (SQL)&"<br>"
            'response.end
            Dbcon.Execute (SQL)

        ElseIf rboyang = "0" Then

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
        
'~~~~~~~~~~~~~부속자재 업데이트 끝

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