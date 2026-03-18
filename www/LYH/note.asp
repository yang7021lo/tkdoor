<div class="col text-end">
    <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="TNG1_B_doorpop.asp" name="form1">   
        <input type="hidden" name="sjidx" value="<%=rsjidx%>">
        <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
        <input type="hidden" name="fkidx" value="<%=rfkidx%>">
        <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
        <div style="display: flex; align-items: center; gap: 8px;"> 
        <% if zWHICHI_FIX <> 0 then %>
            <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px;">
                <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                    중간키
                </div>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <!-- O 버튼 -->
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="1"
                        <% If rjunggankey  <> "0" Then Response.Write "checked" %> > ✔
                    </label>
                    <!-- X 버튼 -->
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="0"
                        <% If rjunggankey = "0" Then Response.Write "checked" %> > ❌
                    </label>
                </div>
            </div>
            <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; margin-right: 10px;">
                <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                    다대타공
                </div>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="1"
                        <% If rtagong <> "0" Then Response.Write "checked" %> >  ✔
                    </label>
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="0"
                        <% If rtagong = "0" Then Response.Write "checked" %> > ❌
                    </label>
                </div>
            </div>
        <% else %> 
            <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px;">
                <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                    중간키
                </div>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <!-- O 버튼 -->
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="1"
                        <% If rjunggankey  = "1" Then Response.Write "checked" %> > ✔
                    </label>
                    <!-- X 버튼 -->
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="0"
                        <% If rjunggankey <> "1" Then Response.Write "checked" %> > ❌
                    </label>
                </div>
            </div>
            <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; margin-right: 10px;">
                <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                    다대타공
                </div>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="1"
                        <% If rtagong = "1"  Then Response.Write "checked" %> >  ✔
                    </label>
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="0"
                        <% If rtagong <> "1"  Then Response.Write "checked" %> > ❌
                    </label>
                </div>
            </div>
            <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; margin-right: 10px;">
                <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                    nf/하나로
                </div>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="1"
                        <% If rnf = "1"  Then Response.Write "checked" %> >  ✔
                    </label>
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="0"
                        <% If rnf <> "0"  Then Response.Write "checked" %> > ❌
                    </label>
                </div>
            </div>
        <% end if %>
            <!-- 다대무홈 -->
            <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px;">
                <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                    다대무홈
                </div>
                <div style="display: flex; justify-content: center; gap: 16px;">
                    <label>
                    <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="dademuhom" value="1"
                        <% If rdademuhom = "1" Then Response.Write "checked" %> > ✔
                    </label>
                    <label>
                    <input type="radio"  style="transform: scale(1.5); margin-right: 6px;" name="dademuhom" value="0"
                        <% If rdademuhom <> "1" Then Response.Write "checked" %> > ❌
                    </label>
                </div>
            </div>
            <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();">적용</button>
    </form> 
</div>
<form name="frmMain" action="TNG1_B_doorpop.asp" method="post">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="gubun" value="update">
            </div>
                <%
                SQL = "SELECT sidx, goidx, goname, baridx, barNAME, smidx, swdate, semidx, sewdate "
                SQL = SQL & ",standprice, barlistprice, barNAME1, barNAME2, barNAME3, barNAME4, barNAME5 "
                SQL = SQL & ",tongdojang, jadong, culmolbar,danyul,g_w,g_h"
                SQL = SQL & " FROM tk_stand "
                SQL = SQL & " WHERE sidx <> 0 "
                    If rjunggankey <>"" Then 
                    SQL=SQL&" AND  junggankey = '"&rjunggankey&"' "
                    End If 
                    If rdademuhom <>"" Then 
                    SQL=SQL&" AND  dademuhom = '"&rdademuhom&"' "
                    End If 
                    If rnf <>"" Then 
                    SQL=SQL&" AND  nf = '"&rnf&"' "
                    End If 
                    If glass <>"" Then 
                    SQL=SQL&" AND  glass = '"&glass&"' "
                    End If 
                    If zGREEM_F_A = 1 Then 
                    SQL=SQL&" AND  jadong = 0 "
                    else
                    SQL=SQL&" AND  jadong = 1 "
                    End If 
                    'If zqtyidx =5 or  zqtyidx =15 or  zqtyidx =30 Then  'zqtyidx 알미늄블랙 5 실버15 기타도장30  헤어도장(  zqtyidx = 1 ) or ( 갈바도장 zqtyidx = 3  )  
                    'SQL=SQL&" AND  tongdojang = 1 "
                    'else
                    'SQL=SQL&" AND  tongdojang = 0 "
                    'End If 
                    If zsjb_type_no = 1  Then  ' 알자
                    SQL=SQL&" AND  danyul = 0 and  jadong=1   AND tongdojang = 1 AND goname LIKE '%일반%'  "
                    End If 
                    If zsjb_type_no = 2  Then  ' 복층알자
                    SQL=SQL&" AND  danyul = 0 and  jadong=1   AND tongdojang = 1 AND goname LIKE '%일반%'  "
                    End If 
                    If zsjb_type_no = 3 or  zsjb_type_no = 4 or zsjb_type_no = 8 or zsjb_type_no = 9 or zsjb_type_no = 10 or zsjb_type_no = 15   Then  ' 단열알자3 삼중알자4 단자8 삼중단자9 이중슬라이딩10 포켓15
                    SQL=SQL&" AND danyul = 1 AND jadong = 1 AND goname LIKE '%매립단열자동%'  " 
                    End If 
                    If zsjb_type_no = 5  Then  ' 단열알자
                    SQL=SQL&" AND  danyul = 0 and  jadong=1   AND tongdojang = 1 AND goname LIKE '%인테%'   " 
                    End If 
                    If zsjb_type_no = 6  Then  ' 통도장 수동 일반
                    SQL=SQL&" and danyul = 0 and  jadong=0 AND tongdojang = 1 and goname  LIKE '%안전%'  and barname NOT LIKE '%100*90%' and  goname NOT LIKE '%한쪽안전%' " 
                    End If 
                    If zsjb_type_no = 7  Then  ' 통도장 수동 단열
                    SQL=SQL&" and danyul = 1 and  jadong=0 AND tongdojang = 1 and goname  LIKE '%안전%'  and barname NOT LIKE '%100*90%' and  goname NOT LIKE '%한쪽안전%' " 
                    End If 
                    If zsjb_type_no = 11  Then  ' 수동 단열
                    SQL=SQL&" and danyul = 1 and  jadong=0 AND tongdojang = 0 and goname  LIKE '%안전%'  and barname NOT LIKE '%100*90%' and  goname NOT LIKE '%한쪽안전%' " 
                    End If 
                    If zsjb_type_no = 11 or zsjb_type_no = 12 Then  ' 수동 단열
                    SQL=SQL&" and danyul = 1 and  jadong=0 AND tongdojang = 0 and goname  LIKE '%안전%'  and barname NOT LIKE '%100*90%' and  goname NOT LIKE '%한쪽안전%' " 
                    End If 

                Response.Write SQL & "<br>"

                    Rs1.Open SQL, Dbcon
                    If Not (Rs1.BOF Or Rs1.EOF) Then
                    Do While Not Rs1.EOF

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

                        i = i + 1
                                                
                        if rjunggankey = "1" then
                            junggankey_price = 25000
                        end if
                        if rdademuhom = "1" then
                            dademuhom_price = 5000
                        end if
                        if rtagong = "1" then
                            tagong_price = 3000
                        end if
                        If (zqtyidx =1 or  zqtyidx =3) and (pidx<>0) Then  '헤어도장(  zqtyidx = 1 ) or ( 갈바도장 zqtyidx = 3  )  
                            dojang_price=55000
                        elseif ( zqtyidx =15 or  zqtyidx =30)  Then '알미늄블랙 5 실버15 기타도장30
                            if danyul = 1 and tongdojang = 1 then
                                dojang_price=30000
                            else
                                dojang_price=20000  
                            end if
                        else
                            dojang_price=0
                        End If 

                        ' 도어 사이즈 추가 계산
                        If zdoor_w >= 1 And zdoor_w <= 910 Then
                            size_price_w = 1
                        ElseIf zdoor_w <= 960 Then
                            size_price_w = 2
                        ElseIf zdoor_w <= 1010 Then
                            size_price_w = 3
                        ElseIf zdoor_w <= 1060 Then
                            size_price_w = 4
                        ElseIf zdoor_w <= 1110 Then
                            size_price_w = 5
                        ElseIf zdoor_w <= 1160 Then
                            size_price_w = 6
                        ElseIf zdoor_w <= 1210 Then
                            size_price_w = 7
                        ElseIf zdoor_w <= 1260 Then
                            size_price_w = 8
                        ElseIf zdoor_w <= 1310 Then
                            size_price_w = 9
                        ElseIf zdoor_w <= 1360 Then
                            size_price_w = 10
                        ElseIf zdoor_w <= 1410 Then
                            size_price_w = 11
                        ElseIf zdoor_w <= 1460 Then
                            size_price_w = 12
                        ElseIf zdoor_w <= 1510 Then
                            size_price_w = 13
                        ElseIf zdoor_w <= 1560 Then
                            size_price_w = 14
                        ElseIf zdoor_w <= 1610 Then
                            size_price_w = 15
                        ElseIf zdoor_w <= 1660 Then
                            size_price_w = 16
                        ElseIf zdoor_w <= 1710 Then
                            size_price_w = 17
                        ElseIf zdoor_w <= 1760 Then
                            size_price_w = 18
                        ElseIf zdoor_w <= 1810 Then
                            size_price_w = 19
                        ElseIf zdoor_w <= 1860 Then
                            size_price_w = 20
                        ElseIf zdoor_w <= 1910 Then
                            size_price_w = 21
                        ElseIf zdoor_w <= 1960 Then
                            size_price_w = 22
                        ElseIf zdoor_w <= 2010 Then
                            size_price_w = 23
                        ElseIf zdoor_w <= 2060 Then
                            size_price_w = 24
                        ElseIf zdoor_w <= 2110 Then
                            size_price_w = 25
                        Else
                            size_price_w = 0
                        End If

                        If zdoor_h >= 1 And zdoor_h <= 2115 Then
                            size_price_h = 1
                        ElseIf zdoor_h <= 2165 Then
                            size_price_h = 2
                        ElseIf zdoor_h <= 2215 Then
                            size_price_h = 3
                        ElseIf zdoor_h <= 2265 Then
                            size_price_h = 4
                        ElseIf zdoor_h <= 2315 Then
                            size_price_h = 5
                        ElseIf zdoor_h <= 2365 Then
                            size_price_h = 6
                        ElseIf zdoor_h <= 2415 Then
                            size_price_h = 7
                        ElseIf zdoor_h <= 2465 Then
                            size_price_h = 8
                        ElseIf zdoor_h <= 2515 Then
                            size_price_h = 9
                        ElseIf zdoor_h <= 2565 Then
                            size_price_h = 10
                        ElseIf zdoor_h <= 2615 Then
                            size_price_h = 11
                        ElseIf zdoor_h <= 2665 Then
                            size_price_h = 12
                        ElseIf zdoor_h <= 2715 Then
                            size_price_h = 13
                        ElseIf zdoor_h <= 2765 Then
                            size_price_h = 14
                        ElseIf zdoor_h <= 2815 Then
                            size_price_h = 15
                        ElseIf zdoor_h <= 2865 Then
                            size_price_h = 16
                        ElseIf zdoor_h <= 2915 Then
                            size_price_h = 17
                        ElseIf zdoor_h <= 2965 Then
                            size_price_h = 18
                        ElseIf zdoor_h <= 3015 Then
                            size_price_h = 19
                        ElseIf zdoor_h <= 3065 Then
                            size_price_h = 20
                        ElseIf zdoor_h <= 3115 Then
                            size_price_h = 21
                        ElseIf zdoor_h <= 3165 Then
                            size_price_h = 22
                        ElseIf zdoor_h <= 3215 Then
                            size_price_h = 23
                        ElseIf zdoor_h <= 3265 Then
                            size_price_h = 24
                        ElseIf zdoor_h <= 3315 Then
                            size_price_h = 25
                        Else
                            size_price_h = 0
                        End If

                        ' 도어 사이즈 추가 가격 계산
                        if (zqtyidx => 1 and zqtyidx =< 7) or (zqtyidx => 12 and zqtyidx =< 15) or zqtyidx= 30 or zqtyidx=37  then 
                            doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                        else 
                            doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                        end if
                        
                        total_standprice=standprice+junggankey_price+dademuhom_price+tagong_price+dojang_price+doorsizechuga_price
                        door_price=total_standprice
                        Response.Write "barname : " & barname & "<br>"
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
                        if zdoor_w > 0 and zdoor_h > 0 then

                            kdoorglass_w = zdoor_w - g_w
                            kdoorglass_h = zdoor_h - g_h
                        
                        SQL="Update tk_framekSub  "  
                        SQL=SQL&" Set doorglass_w='"& kdoorglass_w &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & "AND door_w IS NOT NULL AND door_h IS NOT NULL"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                        SQL="Update tk_framekSub  "  
                        SQL=SQL&" Set doorglass_h='"& kdoorglass_h &"' "
                        SQL=SQL&" Where fkidx='"&rfkidx&"' "
                        SQL = SQL & "AND door_w IS NOT NULL AND door_h IS NOT NULL"
                        'response.write (SQL)&"<br>"
                        Dbcon.Execute (SQL)

                        end if
                %>
        <div class="d-flex flex-wrap gap-2 align-items-center mb-2">
            <!-- 번호 및 선택 -->
            <div>
                <label class="form-label small mb-1">선택</label><br>
                <input type="radio"  style="transform: scale(1.5); margin-right: 6px;"  name="afksidx" value="<%=zfksidx%>"> 
            </div>
            <!-- 품명 -->
            <div>
                <label class="form-label small mb-1">품명</label>
                <input type="text" name="goname" value="<%=goname%>" class="form-control form-control-sm" style="width: 200px;">
            </div>

            <!-- 규격 -->
            <div>
                <label class="form-label small mb-1">규격</label>
                <input type="text" name="barNAME" value="<%=barNAME%>" class="form-control form-control-sm" style="width: 70px;">
            </div>

            <!-- 재질 -->
            <div>
                <label class="form-label small mb-1">재질</label>
                <input type="text" name="zQTYNAME" value="<%=zQTYNAME %>" class="form-control form-control-sm" style="width: 80px;">
            </div>
            <!-- 도장 -->
            <div>
                <label class="form-label small mb-1">도장</label>
                <input type="text" name="zpname" value="<%=zpname %>" class="form-control form-control-sm" style="width: 100px;">
            </div>

            <!-- 자동:편개/양개 -->
            <div>
                <label class="form-label small mb-1">편개/양개</label>
                <input type="text" name="doortype" value="<%=doortype %>" class="form-control form-control-sm" style="width: 70px;">
            </div>

            <!-- 도어가로 -->
            <div>
                <label class="form-label small mb-1">도어W</label>
                <input type="number" name="zdoor_w" value="<%=zdoor_w%>" class="form-control form-control-sm" style="width: 70px;">
            </div>

            <!-- 도어세로 -->
            <div>
                <label class="form-label small mb-1">도어H</label>
                <input type="number" name="zdoor_h" value="<%=zdoor_h%>" class="form-control form-control-sm" style="width: 70px;">
            </div>

            <!-- 유리가로 -->
            <div>
                <label class="form-label small mb-1">도어유리W</label>
                <input type="number" name="zdoorglass_w" value="<%=zdoorglass_w%>" class="form-control form-control-sm" style="width: 70px;">
            </div>

            <!-- 유리세로 -->
            <div>
                <label class="form-label small mb-1">도어유리H</label>
                <input type="number" name="doorglass_h" value="<%=zdoorglass_h%>" class="form-control form-control-sm" style="width: 70px;">
            </div>

            <!-- 유리두께 -->
            <div>
                <label class="form-label small mb-1">유리T</label>
                <input type="number" name="zdoorglass_t_<%=zdoorglass_t%>" value="<%=zdoorglass_t%>" class="form-control form-control-sm" style="width: 60px;">
            </div>

            <!-- 도어가격 -->
            <div>
                <label class="form-label small mb-1">도어가</label>
                <input type="number" name="standprice_<%=total_standprice%>" value="<%=total_standprice%>" class="form-control form-control-sm" style="width: 90px;">
            </div>
        </div>

                <%
                Rs1.MoveNext
                Loop
                End if
                Rs1.close
                %>