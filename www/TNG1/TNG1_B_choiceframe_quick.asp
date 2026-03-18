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

projectname="도면선택"

mode=Request("mode")
gubun=Request("gubun")
rsjidx=request("sjidx")
rsjsidx=request("sjsidx")
rsjb_idx=request("sjb_idx")
rsjb_type_no=request("sjb_type_no")
rcidx=request("cidx")
rgreem_f_a=Request("greem_f_a")
rfidx=request("fidx")
'Response.write rsjsidx&"<br>"
'Response.write rsjb_idx&"<br>"
'response.end
if rgreem_f_a = "" then rgreem_f_a=2 end if
 
SQL = " SELECT  B.sjb_type_name, A.SJB_barlist, A.sjb_type_no "
SQL = SQL & " FROM TNG_SJB A "
SQL = SQL & " LEFT OUTER JOIN tng_sjbtype B ON A.sjb_type_no = B.sjb_type_no AND B.sjbtstatus = 1 "
SQL = SQL & " Where A.sjb_idx='"&rsjb_idx&"' "
'response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
     sjb_type_name=Rs(0)
     SJB_barlist=Rs(1)
     sjb_type_no=Rs(2)
End If
Rs.Close

'도장색상,수량  가져오기
SQL = " SELECT  qtyidx , pidx , quan "
SQL = SQL & " FROM tng_sjaSub  "
SQL = SQL & " Where sjsidx='"&rsjsidx&"' "
'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        sja_qtyidx=Rs(0)
        sja_pidx=Rs(1)
        sja_quan=Rs(2)
End If
Rs.Close
'Response.write sja_qtyidx&"<br>"

'부속이 적용된 신규 입면도면 구성을 위한 코드 시작
'=======================================
if Request("part")="pummoksub" then 

Response.write rsjsidx&"<br>"
Response.write rsjb_idx&"<br>"
'response.end

'메인프레임으로 설정 시작
'==================

'SQL="Select sjb_idx From tng_sjaSub Where sjsidx='"&rsjsidx&"' "
'Rs.open Sql,Dbcon
'if not (Rs.EOF or Rs.BOF ) then
'    sjb_idx=Rs(0)
'        if sjb_idx="0" Then 
'        SQL="Update tng_sjaSub set sjb_idx='"&rsjb_idx&"' where sjsidx='"&rsjsidx&"' "
'        'Response.write (SQL)&"<br>"
'        Dbcon.Execute (SQL)
'        end if
'    end if
'Rs.Close

 
'==================
'메인프레인으로 설정 끝

'tng_sjaSub/tk_framek 만들기 시작
  SQL="Select fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fstatus "
  SQL=SQL&" From tk_frame "
  SQL=SQL&" Where fidx='"&rfidx&"' "
  'Response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon,1,1,1
  if not (Rs.EOF or Rs.BOF ) then
    fname=Rs(0)
    GREEM_F_A=Rs(1)
    GREEM_BASIC_TYPE=Rs(2)
    GREEM_FIX_TYPE=Rs(3)
    GREEM_HABAR_TYPE=Rs(4)
    GREEM_LB_TYPE=Rs(5)
    GREEM_O_TYPE=Rs(6)
    GREEM_FIX_name=Rs(7)
    GREEM_MBAR_TYPE=Rs(8)
    fstatus=Rs(9)

    'sjsidx 찾기는 안함 _자동증가

    fknickname=Request("fknickname")
    
    if rsjsidx="" or rsjsidx="0" then

        sql = "INSERT INTO tng_sjaSub (sjidx, midx, mwdate, meidx, mewdate, mwidth,"
        sql = sql & " mheight, qtyidx, sjsprice, disrate, disprice, fprice,"
        sql = sql & " sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2,"
        sql = sql & " asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2,"
        sql = sql & " astatus, py_chuga, door_price, whaburail, robby_box,"
        sql = sql & " jaeryobunridae, boyangjea) "

        sql = sql & "VALUES ("
        sql = sql & " '" & rsjidx & "', '" & C_midx & "', getdate(),"
        sql = sql & " '" & C_midx & "', getdate(), '" & mwidth & "',"
        sql = sql & " '" & mheight & "', '" & qtyidx & "', '" & sjsprice & "',"
        sql = sql & " '" & disrate & "', '" & disprice & "', '" & fprice & "',"
        sql = sql & " '" & rsjb_idx & "', '" & quan & "', '" & taxrate & "',"
        sql = sql & " '" & sprice & "', '" & asub_wichi1 & "', '" & asub_wichi2 & "',"
        sql = sql & " '" & asub_bigo1 & "', '" & asub_bigo2 & "', '" & asub_bigo3 & "',"
        sql = sql & " '" & asub_meno1 & "', '" & asub_meno2 & "',"
        sql = sql & " '1', '" & py_chuga & "', '" & door_price & "',"
        sql = sql & " '" & whaburail & "', '" & robby_box & "',"
        sql = sql & " '" & jaeryobunridae & "', '" & boyangjea & "'"
        sql = sql & ")"
        Response.write (SQL)&"<br><br>"
        Dbcon.Execute (SQL)
        'response.end  

        SQL="Select max(sjsidx) from tng_sjaSub" 'rsjsidx 찾기
        Response.write (SQL)&"<br><br>"
        Rs1.open Sql,Dbcon,1,1,1
        if not (Rs1.EOF or Rs1.BOF ) then
            rsjsidx=Rs1(0)
        end if
        Rs1.Close

    end if
    
    'fkidx값 최대값찾기
    SQL="Select max(fkidx) from tk_frameK  "
    Response.write (SQL)&"1111<br><br>"
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
        max_fkidx=Rs1(0)
        fkidx=max_fkidx + 1
        if isnull(fkidx) then 
            fkidx=1
        end if 
    end if
    Rs1.Close

    'fkidx값 최대값인데 sjsidx가 다른곳에서 추가되었다면.. 원래값 fkidx값 찾기
    SQL="Select max(fkidx) from tk_frameK where sjsidx='"&rsjsidx&"' "
    Response.write (SQL)&"1111<br><br>"
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
        origin_fkidx=Rs1(0)
    end if
    Rs1.Close

    if fkidx=1 then

        SQL="Select max(fkidx) from tk_frameK "
        Response.write (SQL)&"2222<br><br>"
        Rs1.open Sql,Dbcon,1,1,1
        if not (Rs1.EOF or Rs1.BOF ) then
            max_fkidx=Rs1(0)
            fkidx=max_fkidx + 1
        end if
        Rs1.Close

    end if
    ' 현재 fidx 안에서의 MAX(xi) 가져오기
    SQL = " SELECT TOP 1 b.xi, b.wi " 
    SQL = SQL & " FROM tk_framek a "
    SQL = SQL & " left outer join tk_framekSub b on a.fkidx = b.fkidx " 
    SQL = SQL & " where b.fkidx='"&origin_fkidx&"' and a.sjsidx='"&rsjsidx&"' "
    SQL = SQL & " ORDER BY a.fkidx DESC, b.xi DESC "
    Response.write (SQL)&"<br><br>"
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
        maxxi = Rs1(0)
        maxwi = Rs1(1)
    end if
    Rs1.Close

    plus_xi = maxxi + maxwi 
    
    response.write "fkidx: " & fkidx & "<br>"
    response.write "max_fkidx: " & max_fkidx & "<br>"
    Response.Write "c_fkidx : " & c_fkidx & "<br>"  
    Response.Write "maxxi : " & maxxi & "<br>"  
    Response.Write "maxwi : " & maxwi & "<br>"  
    Response.Write "plus_xi : " & plus_xi & "<br>"  
    
    ' 현재 fidx 안에서의 (xi) 초기화 하기

    SQL = "SELECT min(xi) "
    SQL = SQL & " FROM tk_frameSub "
    SQL = SQL & " WHERE fidx = '" & rfidx & "'"
    SQL = SQL & " and sunstatus=0 "
    SQL = SQL & " and xi <> 0 "
    Response.write (SQL)&"<br><br>"
    Rs1.open Sql,Dbcon
    if not (Rs1.EOF or Rs1.BOF ) then
        minxi = Rs1(0)
        '기존 xi 고정값 280으로 설정
        if minxi > 280 then
            minus_xi = minxi - 280
        else
            minus_xi = minxi 
        end if
    end if
    Rs1.Close

    'response.end

    SQL=" Insert into tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE "
    SQL=SQL&" , GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fmidx, fwdate, fmeidx, fewdate,  fstatus, sjidx, sjb_type_no, sjsidx "
    SQL=SQL&" , qtyidx, pidx , quan ) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fknickname&"', '"&rfidx&"', '"&rsjb_idx&"', '"&fname&"', '"&GREEM_F_A&"', '"&GREEM_BASIC_TYPE&"' "
    SQL=SQL&" , '"&GREEM_FIX_TYPE&"', '"&GREEM_HABAR_TYPE&"', '"&GREEM_LB_TYPE&"', '"&GREEM_O_TYPE&"', '"&GREEM_FIX_name&"', '"&GREEM_MBAR_TYPE&"' "
    SQL=SQL&" , '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '1', '"&rsjidx&"', '"&rsjb_type_no&"', '"&rsjsidx&"' "
    SQL=SQL&" , '"&sja_qtyidx&"' , '"&sja_pidx&"' , '"&sja_quan&"' ) "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL)


    'sjasub에 추가된 fkidx값 찾기
    SQL="Select count(fkidx) from tk_frameK where sjsidx='"&rsjsidx&"' "
    'Response.write (SQL)&"<br><br>"
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
        c_fkidx=Rs1(0)
    end if
    Rs1.Close

    

    'tk_frameksub 입력 시작

    SQL = "SELECT a.fsidx, a.fidx, a.xi, a.yi, a.wi, a.hi, a.imsi"
    SQL = SQL & ", a.WHICHI_FIX, a.WHICHI_AUTO"
    SQL = SQL & ", b.glassselect , c.glassselect "
    SQL = SQL & ", c.WHICHI_FIXname, b.WHICHI_AUTOname ,a.sunstatus "
    SQL = SQL & " FROM tk_frameSub a"
    SQL = SQL & " LEFT OUTER JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
    SQL = SQL & " LEFT OUTER JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
    SQL = SQL & " WHERE a.fidx = '" & rfidx & "'"

    '픽스 상부 오사이 추가 구문.
    'rSJB_TYPE_NO 1,3,5 알자,단알자,슬림자동문은 상부남마 오사이가 없으므로 sunstatus = 0, 1
    'rSJB_TYPE_NO 2.4 복층알자,삼중단알자는 상부남마 오사이가 있음 sunstatus = 0, 1 ,2
    'rSJB_TYPE_NO 나머진 sunstatus = 0

    '픽스 상부 오사이 추가 구문.
    'rSJB_TYPE_NO 1,3 알자,단알자,슬림자동문은 상부남마 오사이가 없으므로 sunstatus = 0, 1
    'rSJB_TYPE_NO 2.4 복층알자,삼중단알자는 상부남마 오사이가 있음 sunstatus = 0, 1 ,2
    'rSJB_TYPE_NO 나머진 sunstatus = 0
    'sunstatus=1 은 픽스하부유리 위에 상부픽스 
    'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 
    'sunstatus=3 은 하부픽스위에 상부남마 에
    'sunstatus=4 은 양개 중앙에
    'sunstatus=5 은 t형_자동홈바
    'sunstatus=6 은 박스커버
    'sunstatus=7 은 마구리
    'sunstatus=8 은 민자,자동 홈마개 whichi_auto = 26 자동홈마개 27=민자홈마개
    If rSJB_TYPE_NO = 1 Or rSJB_TYPE_NO = 3 Then
        SQL = SQL & " AND a.sunstatus IN (0,1,5,6,7,8)"
    elseIf rSJB_TYPE_NO = 2 Or rSJB_TYPE_NO = 4 Then
        SQL = SQL & " AND a.sunstatus IN (0,1,2,3,4,5,6,7,8)"
    elseIf rSJB_TYPE_NO = 5 Then
        SQL = SQL & " AND a.sunstatus IN (0,5,6,7,8)"
    else
        SQL = SQL & " AND a.sunstatus IN (0,6,7,8)"
    end if
    '픽스 상부 오사이 추가 구문 끝
    Response.write (SQL)&"<br>메인 루프 쿼리 <br>"
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then 
    Do while not Rs1.EOF
        fsidx        = Rs1(0)
        fidx         = Rs1(1)
        xi           = Rs1(2)
        yi           = Rs1(3)
        wi           = Rs1(4)
        hi           = Rs1(5)
        imsi         = Rs1(6)
        whichi_fix   = Rs1(7)
        whichi_auto  = Rs1(8)
        glassselect_auto = Rs1(9)
        glassselect_fix  = Rs1(10)
        WHICHI_FIXname   = Rs1(11)
        WHICHI_AUTOname  = Rs1(12)
        sunstatus = Rs1(13)

        if c_fkidx > 1 then '추가된것이라면 

 
            'if maxxi >= 920 then
                'total_xi = xi + maxxi + maxwi - 220 -440 -280 '초기값 280은 여유분으로 넣음
            'else
                total_xi = xi + plus_xi - minxi '초기값 280은 여유분으로 넣음
            'end if
            

        Else '기존에 있는 것이라면

            total_xi = xi

        end if

'Response.Write "total_xi : " & total_xi & "<br>"  
'Response.Write "glassselect_auto : " & glassselect_auto & "<br>"  
'Response.Write "glassselect_fix : " & glassselect_fix & "<br>"  


'부속 기본값 자동으로 넣기 위한 코드 시작

' ▶ glassselect, whichi_auto, whichi_fix에 따른 barasiF 조회
    If glassselect_auto = 0 or glassselect_fix = 0 Then  '자재의경우

        SQL = "SELECT bfidx, xsize, ysize "
        SQL = SQL & "FROM tk_barasiF "
        SQL = SQL & "WHERE sjb_idx = '" & rsjb_idx & "'"
        
        If greem_f_a = "2" Then
            '-------민자홈마개
            '민자홈마개 추가 구문. whichi_auto = 26 자동홈마개 27=민자홈마개
            'rSJB_TYPE_NO 1~5 민자홈마개가 없으므로 자동홈마개로 교체
            'rSJB_TYPE_NO 8,9,10,15는 변경 없음
            if rSJB_TYPE_NO >= 1 and rSJB_TYPE_NO <= 5  then
                if whichi_auto = 27 then
                    whichi_auto = 26
                end if
            end if
            SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
        ElseIf greem_f_a = "1" Then
            SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
        End If

        Response.Write(SQL) & "<br>---[glassselect = 0] ---1번 <br><br>"

    Else

        If whichi_auto > 0 Then ' glassselect ≠ 0일 때 자동유리
            SQL = "SELECT bfidx, xsize, ysize "
            SQL = SQL & "FROM tk_barasiF "
            SQL = SQL & "WHERE sjb_idx = '129'"
            SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
            Response.Write(SQL) & "  ---[glassselect ≠ 0 and whichi_auto]<br><br>"
        ElseIf whichi_fix > 0 Then ' glassselect ≠ 0일 때 수동유리
            SQL = "SELECT bfidx, xsize, ysize "
            SQL = SQL & "FROM tk_barasiF "
            SQL = SQL & "WHERE sjb_idx = '134'"
            SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
            Response.Write(SQL) & "  ---[glassselect ≠ 0 and whichi_fix]<br><br>"
        End If

    End If

            Rs2.Open SQL, Dbcon
            If Not (Rs2.BOF Or Rs2.EOF) Then
                bfidx = Rs2(0)
                xsize = Rs2(1)
                ysize = Rs2(2)
            End If
            Rs2.Close
        
'부속 기본값 자동으로 넣기 위한 코드 끝
    ' AUTO 기준: 세로/가로 구분 (세로 우선)
    ' 세로: 4,5,6,7,10
    ' 가로: 1,2,3,4,8,9,20,21,23   
    ' FIX 기준: 세로/가로 구분
    ' 세로: 6,7,8,9,10,20
    ' 가로: 1,2,3,4,5,21,22,24,25
    If whichi_auto > 0  Then

        gls = glassselect_auto

        Select Case whichi_auto
            Case 4,5,6,7,10,25
                garo_sero = 1   ' 세로 
            Case 1,2,3,8,9,20,21,23
                garo_sero = 0   ' 가로
        End Select

    ElseIf  whichi_fix > 0 Then

        gls = glassselect_fix

        Select Case whichi_fix
            Case 6,7,8,9,10,20
                garo_sero = 1   ' 세로
            Case 1,2,3,4,5,21,22,24,25
                garo_sero = 0   ' 가로
        End Select

    End If
    
        '--------------------------------------
        ' sunstatus=0일 때 단순 보정
        '--------------------------------------
        If rSJB_TYPE_NO = 1 or rSJB_TYPE_NO = 3  Then
            If whichi_auto = 16 Or whichi_auto = 17 Or whichi_auto = 18 Or whichi_auto = 19 Then '자동상부남마만 보정 픽스유리
                yi = yi - 5
                hi = hi + 10
            End If
        End If

        If  rSJB_TYPE_NO >= 5 Then
            If whichi_auto = 14 Or whichi_auto = 15 Then '자동하부픽스유리
                yi = yi - 5
                hi = hi + 5
            ElseIf whichi_auto = 16 Or whichi_auto = 17 Or whichi_auto = 18 Or whichi_auto = 19 Then
                yi = yi - 5
                hi = hi + 10
            End If
        End If

        '--------------------------------------
        ' sunstatus=5일 때 단순 보정
        '--------------------------------------
        
        if rSJB_TYPE_NO=8 or rSJB_TYPE_NO=9 or rSJB_TYPE_NO=10 or rSJB_TYPE_NO=15 then
            If whichi_auto = 12 and xi=310 Then
                total_xi = total_xi - 10
                wi = wi + 10
        
            ElseIf whichi_auto = 12 and xi=510 Then 
                wi = wi + 10
            End If
        End If
        
    'response.write "rSJB_TYPE_NO:"&rSJB_TYPE_NO&"/<br>"
    'response.write "whichi_auto:"&whichi_auto&"/<br>"
    'response.write "xi:"&xi&"/<br>"
    'response.write "wi:"&wi&"/<br>"
    'Response.Write "gls: " & gls & "<br>"
    SQL = ""
    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx,xsize,ysize,gls,garo_sero,sunstatus) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fsidx&"', '"&fidx&"', '"&total_xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"', '"&xsize&"', '"&ysize&"', '"&gls&"', '"&garo_sero&"', '"&sunstatus&"') "
    Response.write (SQL)&"  <br><br>---tk_framekSub----<br><br>"
    Dbcon.Execute (SQL)

'response.write "rSJB_TYPE_NO:"&rSJB_TYPE_NO&"/<br>"
    'response.write "whichi_auto:"&whichi_auto&"/<br>"
    
    Rs1.movenext
    Loop
    End if
    Rs1.close
    'tk_frameksub 입력 끝

End If
Rs.Close

' 이중슬라이딩일 경우 도어 1개 더 만드는 쿼리 시작
        if rSJB_TYPE_NO = 10 then 

            'gls 1 ' ☑ 편개 gls 2 ' ☑ 양개 그룹
            SQL="Select gls from tk_frameksub where fkidx='"&fkidx&"' and gls in (1,2) "
            Response.write (SQL)&"<br>gls 가져오기<br>"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then
                ugls=Rs(0) '1, 2, 3 편개 / 4, 5, 6 양개
            End If
            Rs.Close

            response.write "ugls:"&ugls&"/<br>"
        
                'count  ☑ 편개 = 1장  ☑ 양개 = 2장
                SQL="Select count(fksidx) from tk_frameksub where fkidx='"&fkidx&"' and gls in (1,2) "
                Response.write (SQL)&"<br>도어수량 카운트<br>"
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then
                    count_fksidx=Rs(0) '1 편개 / 2 양개
                End If
                Rs.Close

            If ( ugls = 1  And count_fksidx = 1 ) or (ugls = 2 And count_fksidx = 2 ) Then

                SQL = " select fksidx, fkidx, fsidx, fidx, xi, yi "
                SQL = SQL & " ,wi, hi, fmidx, fwdate, imsi, WHICHI_FIX "
                SQL = SQL & " ,WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize "
                SQL = SQL & " ,fstype, glasstype, blength, unitprice, pcent, sprice "
                SQL = SQL & " ,xsize, ysize, gls, OPT, FL, door_W "
                SQL = SQL & " , door_h, glass_w, glass_h, busok, busoktype, doorglass_t "
                SQL = SQL & " ,fixglass_t, doortype, doorglass_w, doorglass_h, doorsizechuga_price "
                SQL = SQL & " ,door_price, goname, barNAME, alength "
                SQL = SQL & " FROM tk_framekSub "
                SQL = SQL & " WHERE fkidx = '" & fkidx & "' "
                SQL = SQL & " and  gls in (1,2) "
                Response.write (SQL)&"<br> 도어 조회하기 <br>"
                'response.end
                Rs.open SQL, Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do While Not Rs.EOF

                    tfksidx              = Rs(0)
                    tfkidx               = Rs(1)
                    tfsidx               = Rs(2)
                    tfidx                = Rs(3)
                    txi                  = Rs(4)
                    tyi                  = Rs(5)
                    twi                  = Rs(6)
                    thi                  = Rs(7)
                    tfmidx               = Rs(8)
                    tfwdate              = Rs(9)
                    timsi                = Rs(10)
                    tWHICHI_FIX          = Rs(11)
                    tWHICHI_AUTO         = Rs(12)
                    tbfidx               = Rs(13)
                    tbwsize              = Rs(14)
                    tbhsize              = Rs(15)
                    tgwsize              = Rs(16)
                    tghsize              = Rs(17)
                    tfstype              = Rs(18)
                    tglasstype           = Rs(19)
                    tblength             = Rs(20)
                    tunitprice           = Rs(21)
                    tpcent               = Rs(22)
                    tsprice              = Rs(23)
                    txsize               = Rs(24)
                    tysize               = Rs(25)
                    tgls                 = Rs(26)
                    tOPT                 = Rs(27)
                    tFL                  = Rs(28)
                    tdoor_W              = Rs(29)
                    tdoor_h              = Rs(30)
                    tglass_w             = Rs(31)
                    tglass_h             = Rs(32)
                    tbusok               = Rs(33)
                    tbusoktype           = Rs(34)
                    tdoorglass_t         = Rs(35)
                    tfixglass_t          = Rs(36)
                    tdoortype            = Rs(37)
                    tdoorglass_w         = Rs(38)
                    tdoorglass_h         = Rs(39)
                    tdoorsizechuga_price = Rs(40)
                    tdoor_price          = Rs(41)
                    tgoname              = Rs(42)
                    tbarNAME             = Rs(43)
                    talength             = Rs(44)

                    '기존도어 업데이트

                    wi1 = twi/2 ' /2

                    SQL="Update tk_frameksub set  wi='"&wi1&"'  "
                    SQL=SQL&" Where fksidx='"&tfksidx&"' "
                    'Response.write (SQL)&"<br>"
                    Dbcon.Execute (SQL)


                    '새로운 인서트
                    xi2 =  txi + (twi/2) ' 추가  
                    wi2 = twi/2 ' /2 

                    SQL = SQL & "INSERT INTO tk_framekSub ("
                    SQL = SQL & " fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate,"
                    SQL = SQL & "imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, "
                    SQL = SQL & "blength, unitprice, pcent, sprice, xsize, ysize, gls, door_W,"
                    SQL = SQL & "door_h, busok, busoktype, doorglass_t, fixglass_t, doortype,"
                    SQL = SQL & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength )"

                    SQL = SQL & "VALUES ( '" & tfkidx & "', '" & tfsidx & "', '" & tfidx & "', '" & xi2 & "', '" & tyi & "', '" & wi2 & "', '" & thi & "' "       
                    SQL = SQL & ", '" & tfmidx & "', getdate() , '" & timsi & "', '" & tWHICHI_FIX & "', '" & tWHICHI_AUTO & "', '" & tbfidx & "', '" & tbwsize & "', '" & tbhsize & "' "   
                    SQL = SQL & ", '" & tgwsize & "', '" & tghsize & "', '" & tfstype & "', '" & tblength & "', '" & tunitprice & "', '" & tpcent & "', '" & tsprice & "' "   
                    SQL = SQL & ", '" & txsize & "', '" & tysize & "', '" & tgls & "', '" & tdoor_W & "', '" & tdoor_h & "' "  
                    SQL = SQL & ", '" & tbusok & "', '" & tbusoktype & "', '" & tdoorglass_t & "', '" & tfixglass_t & "', '" & tdoortype & "', '" & tdoorglass_w & "', '" & tdoorglass_h & "' "   
                    SQL = SQL & ", '" & tdoorsizechuga_price & "', '" & tdoor_price & "', '" & tgoname & "', '" & tbarNAME & "', '" & talength & "' )"
                    Response.write (SQL)&"<br> 좌표 인서트 하기<br>"
                    Dbcon.Execute (SQL)

                '변수 초기화
                wi1=0
                xi2=0
                wi2=0

                Rs.MoveNext
                Loop
                end If
                Rs.Close

            end if

            '--- 이중뚜껑마감 인서트 하기---
            SQL = ""
            SQL = SQL & "INSERT INTO tk_framekSub ("
            SQL = SQL & " fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate,"
            SQL = SQL & "imsi, WHICHI_FIX, WHICHI_AUTO, gls , bfidx)"

            SQL = SQL & "VALUES ( '" & tfkidx & "', '" & tfsidx & "', '" & tfidx & "', '" & xi2 & "', '" & tyi & "', '" & wi2 & "', '" & thi & "' "       
            SQL = SQL & ", '" & tfmidx & "', getdate() , '" & timsi & "', '" & tWHICHI_FIX & "',  28 , 0 ,850 )"
            Response.write (SQL)&"<br> 이중뚜껑마감<br>"
            Dbcon.Execute (SQL)

        end if
        ' 이중슬라이딩일 경우 도어 1개 더 만드는 쿼리 끝

        if rSJB_TYPE_NO = 5 then '슬림알자 박스 오사이 끼워넣지 ㅋㅋ tWHICHI_auto=30
            '--- 슬림알자 인서트 하기---
            SQL = ""
            SQL = SQL & "INSERT INTO tk_framekSub ("
            SQL = SQL & " fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate,"
            SQL = SQL & "imsi, WHICHI_FIX, WHICHI_AUTO, gls , bfidx)"

            SQL = SQL & "VALUES ( '" & fkidx & "', '" & fsidx & "', '" & fidx & "', 0, 0, 0, 0 "       
            SQL = SQL & ", '" & C_midx & "', getdate() , '" & imsi & "', '" & WHICHI_FIX & "',  30 , 0 ,878 )"
            Response.write (SQL)&"<br> 슬림알자 박스 오사이<br>"
            Dbcon.Execute (SQL)

        end if
'response.end
'tk_framk 만들기 끝  
'Response.end
    if mode="quick" then
    response.write "<script>opener.location.replace('TNG1_B_suju_quick.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&fkidx&"');window.close()</script>"
    else
    response.write "<script>opener.location.replace('TNG1_B_suju2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&fkidx&"');window.close()</script>"
    end if
    
End If
'=======================================
'부속이 적용된 신규 입면도면 구성을 위한 코드 끝

%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        a:link {
        color: #070707;
        text-decoration: none;
        }
        a:visited {
        color: #070707;
        text-decoration: none;
        }
        a:hover {
        color: #070707;
        text-decoration: none;
        }
    </style>
  <style>
    .box {
      border: 0px solid #ccc;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #ffffff;
    }

    .row-border {
      border-bottom: 1px solid #999;
      margin-bottom: 5px;
      padding-bottom: 5px;
    }

  .card-title-bg {
    background-color: #f1f1f1;
    padding: 10px;
    margin: -1rem -1rem 0 -1rem; /* 카드 내부 여백을 덮기 위해 마이너스 마진 */
    border-bottom: 1px solid #ddd;
  }
      .btn-spacing > .btn {
      margin-right: 1px;
    }

    /* 마지막 버튼 오른쪽 여백 제거 */
    .btn-spacing > .btn:last-child {
      margin-right: 0;
    }
  </style>
    <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
 
    }

    iframe {
      width: 100%;
      height: 100%;
      border: none;
      overflow: hidden;
    }

    .full-height-card {
      height: 100vh; /* Viewport 전체 높이 */
      display: flex;
      flex-direction: column;
    }    
  </style>
  <script>
 //   function pummoksub(fidx) {
 //   const message = prompt("이 입면 도면을 기본으로 부속이 적용된 신규 부족적용 입면 도면 생성합니다. 입면도면의 이름을 입력하세요.");
  //      if (message !== null && message.trim() !== "") {
   //     const encodedMessage = encodeURIComponent(message.trim());
    //    window.location.href = "TNG1_B_choiceframe_quick.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&cidx=<%=rcidx%>&fidx="+fidx+"&fknickname="+encodedMessage;
     //   }
 //   }
    <% if mode="quick" then %>
      function pummoksub(fidx){
      
            location.href="TNG1_B_choiceframe_quick.asp?mode=quick&part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fidx="+fidx;
        
    }
    <% else %>
    function pummoksub(fidx){
        if (confirm("선택한 입면 도면을 불러오시겠습니까?"))
        {
            location.href="TNG1_B_choiceframe_quick.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fidx="+fidx;
        }
    }
    <% end if %>
  </script>
  
</head>
<body class="sb-nav-fixed">

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
 
    <div class="card">
    
      <div class="card-header">
        <%=sjb_type_name%>&nbsp;<%=SJB_barlist%>
      </div>
<form name="frmMainsub" action="TNG1_B_choiceframe_quick.asp" method="POST">  

      <div class="card-body">
        <div >
                <div class="row ">
                    <%
                    sql = " SELECT DISTINCT A.GREEM_F_A, A.GREEM_BASIC_TYPE, A.GREEM_FIX_TYPE, A.fmidx, A.fwdate, A.fmeidx, A.fewdate,"  
                    sql = sql & " A.greem_o_type, A.greem_habar_type, A.greem_lb_type, A.GREEM_MBAR_TYPE,"  
                    sql = sql & " B.GREEM_BASIC_TYPEname, C.GREEM_FIX_TYPEname, D.greem_o_typename , a.fidx , a.fname"  
                    sql = sql & " FROM tk_frame A"  
                    sql = sql & " LEFT outer JOIN tk_frametype B ON A.GREEM_BASIC_TYPE = B.GREEM_BASIC_TYPE"  
                    sql = sql & " LEFT outer JOIN tk_frametype C ON A.GREEM_FIX_TYPE = C.GREEM_FIX_TYPE"  
                    sql = sql & " LEFT outer JOIN tk_frametype D ON A.greem_o_type = D.greem_o_type"  
                    sql = sql & " WHERE greem_f_a= '"&rgreem_f_a&"'  "
                    if rgreem_f_a="2" then  '자동
                    sql = sql & " AND fidx BETWEEN 1 AND 45 "  ' ✅ fidx 1~24 제한
                    elseif  rgreem_f_a="1" Then '수동
                    sql = sql & " AND fidx >=  217 "  ' ✅ fidx 217> 제한
                    end if
                    sql = sql & " order by a.fidx asc "
                    'response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    
                    greem_f_a         = Rs(0)
                    greem_basic_type  = Rs(1)
                    greem_fix_type    = Rs(2)
                    fmidx             = Rs(3)
                    fwdate            = Rs(4)
                    fmeidx            = Rs(5)
                    fewdate           = Rs(6)
                    greem_o_type      = Rs(7)
                    greem_habar_type  = Rs(8)
                    greem_lb_type     = Rs(9)
                    greem_mbar_type   = Rs(10)
                    
                    GREEM_BASIC_TYPEname = Rs(11)
                    GREEM_FIX_TYPEname   = Rs(12)
                    greem_o_typename     = Rs(13)
                    fidx        = rs(14)
                    fname       = rs(15)

                    ' ▼ greem_f_a 변환
                    Select Case greem_f_a
                        Case "1"
                            greem_f_a_name = "수동"
                        Case "2"
                            greem_f_a_name = "자동"
                        Case Else
                            greem_f_a_name = "기타"
                    End Select


                    ' ▼ greem_habar_type 변환
                    Select Case greem_habar_type
                        Case "0"
                            greem_habar_type_name = "하바분할 없음"
                        Case "1"
                            greem_habar_type_name = "하바분할"
                    End Select
                    ' ▼ greem_lb_type 변환
                    Select Case greem_lb_type
                        Case "0"
                            greem_lb_type_name = "로비폰 없음"
                        Case "1"
                            greem_lb_type_name = "로비폰"
                    End Select
                    ' ▼ GREEM_MBAR_TYPE 변환
                    Select Case GREEM_MBAR_TYPE
                        Case "0"
                            GREEM_MBAR_TYPE_name = "중간소대 추가 없음"
                        Case "1"
                            GREEM_MBAR_TYPE_name = "중간소대 추가"
                    End Select

                    %> 

                    <div class="col-4">
                        <div class="card card-body mb-1">
                            <div class="canvas-container">
                                <svg id="canvas" onclick="pummoksub('<%=fidx%>');" viewBox="0 100 1000 500" class="d-block">
                                
                                <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                                <text id="width-label" class="dimension-label"></text>
                                <text id="height-label" class="dimension-label"></text>
                                
                                    <%
                                    SQL = "SELECT a.fsidx, a.xi, a.yi, a.wi, a.hi"
                                    SQL = SQL & " , b.glassselect,a.WHICHI_AUTO,a.WHICHI_FIX, c.glassselect, a.sunstatus "        
                                    SQL = SQL & " FROM tk_frameSub a"
                                    SQL = SQL & " LEFT OUTER JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
                                    SQL = SQL & " LEFT OUTER JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
                                    SQL = SQL & " WHERE a.fidx = '" & fidx & "'"
                                    'Response.write (SQL)&"<br>"
                                    'Response.End
                                    Rs1.open SQL, Dbcon
                                    If Not (Rs1.BOF Or Rs1.EOF) Then
                                        Do While Not Rs1.EOF
                                            i            = i + 1
                                            fsidx        = Rs1(0)
                                            xi           = Rs1(1)
                                            yi           = Rs1(2)
                                            wi           = Rs1(3)
                                            hi           = Rs1(4)
                                            glassselect_auto       = Rs1(5)
                                            WHICHI_AUTO = Rs1(6)
                                            WHICHI_FIX = Rs1(7)
                                            glassselect_fix       = Rs1(8)
                                            sunstatus = Rs1(9)

                                            if WHICHI_AUTO<>"" and WHICHI_FIX=0 then

                                                If CInt(glassselect_auto) = 0 Then
                                                    fillColor = "#DCDCDC" ' 회색
                                                    if sunstatus = 5 then
                                                        fillColor = "#FA8072" '  t형_자동홈바
                                                    end if
                                                ElseIF CInt(glassselect_auto) = 1 Then
                                                    fillColor = "#cce6ff" ' 투명 파랑 외도어
                                                ElseIF CInt(glassselect_auto) = 2 Then
                                                    fillColor = "#ccff" '  파랑 양개도어
                                                ElseIF CInt(glassselect_auto) = 3 Then
                                                    fillColor = "#FFFFE0" '  유리
                                                End If

                                            end if
                                            if WHICHI_FIX<>"" and WHICHI_AUTO=0 then
                                                If CInt(glassselect_fix) = 0 Then
                                                    fillColor = "#FFFFFF" ' 기본 흰색
                                                ElseIF CInt(glassselect_fix) = 1 Then
                                                    fillColor = "#cce6ff" ' 투명 파랑 외도어
                                                ElseIF CInt(glassselect_fix) = 2 Then
                                                    fillColor = "#ccff" '  파랑 양개도어
                                                ElseIF CInt(glassselect_fix) = 3 Then
                                                    fillColor = "#FFFFE0" '  유리
                                                ElseIF CInt(glassselect_fix) = 4 Then
                                                    fillColor = "#FFFF99" '  상부남마유리 
                                                ElseIF CInt(glassselect_fix) = 5 Then
                                                    fillColor = "#CCFFCC" '  박스라인하부픽스유리   
                                                ElseIF CInt(glassselect_fix) = 6 Then
                                                    fillColor = "#CCFFCC" '  박스라인상부픽스유리  
                                                End If
                                            end if
                                    %>
                                    <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fillColor%>" stroke="#333333" stroke-width="" onclick="del('<%=fsidx%>');"/>
                                    <text x="<%=xi+5%>" y="<%=yi+20%>" font-family="Arial" font-size="14" fill="#000000"><%=i%></text>
                                    <%
                                    Rs1.movenext
                                    Loop
                                    End if
                                    Rs1.close
                                    %>          
                                </svg>
                                   
                                            <div style="text-align: center;">
                                                <p>
                                                <% if greem_f_a=1 then %>
                                                    [수동프레임] <br> <%=fname%> <br> <%=GREEM_FIX_TYPEname%>
                                                <% elseif greem_f_a=2 then %>
                                                    [자동프레임] <br> <%=fname%> <br> <%=GREEM_BASIC_TYPEname%> / <%=greem_o_typename%> / <%=GREEM_FIX_TYPEname%>
                                                <% end if %>
                                                </p>
                                            </div>
                              
                            </div>
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

</form>


      </div>
    <div>
      <!-- footer 시작 -->    
      Coded By 양양
      <!-- footer 끝 --> 
    </div>
<!-- 내용 입력 끝 -->  
        </div>
    </div>

</main>                          

</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="/js/scripts.js"></script>

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
