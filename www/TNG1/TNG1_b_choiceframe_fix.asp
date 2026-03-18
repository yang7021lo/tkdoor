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

gubun=Request("gubun")
rsjidx=request("sjidx")
rsjsidx=request("sjsidx")
rsjb_idx=request("sjb_idx")
rsjb_type_no=request("sjb_type_no")
rcidx=request("cidx")
rgreem_f_a=Request("greem_f_a")
rfidx=request("fidx")
rmode=Request("mode")
rw_frame=Request("w_frame") 
rh_frame=Request("h_frame") 
rfkidx=Request("fkidx") 


Response.Write "rsjidx : " & rsjidx & "<br>" 
Response.Write "rsjsidx : " & rsjsidx & "<br>" 
Response.Write "rsjb_idx : " & rsjb_idx & "<br>" 
Response.Write "rsjb_type_no : " & rsjb_type_no & "<br>" 
Response.Write "rgreem_f_a : " & rgreem_f_a & "<br>" 
Response.Write "rfidx : " & rfidx & "<br>" 

'Response.write rsjsidx&"<br>"
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

'메인프레임으로 설정 시작
'==================

SQL="Select sjb_idx From tng_sjaSub Where sjsidx='"&rsjsidx&"' "
  Rs.open Sql,Dbcon
  if not (Rs.EOF or Rs.BOF ) then
    sjb_idx=Rs(0)
    if sjb_idx="0" Then 
    SQL="Update tng_sjaSub set sjb_idx='"&rsjb_idx&"' where sjsidx='"&rsjsidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    end if
  end if
  Rs.Close


'==================
'메인프레인으로 설정 끝

'tk_framek 만들기 시작

'fidx=219 고정창
'fidx=222 상부남마 고정창
'선택먼저 하기.
'제작하실 프레임 타입을 고르세요.
'1.고정창 2.상부남마 고정창

%>    
<% 
    if rfidx = "" then
    
%>
<script>
function frameselect() {
    Swal.fire({
        title: '제작하실 프레임 타입을 선택하세요.',
        text: '원하시는 고정창 유형을 선택해 주세요.',
        icon: 'question',
        showCancelButton: true,
        showDenyButton: true,
        confirmButtonText: '고정창',
        denyButtonText: '상부남마 고정창',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            location.href = 'TNG1_b_choiceframe_fix.asp?mode=wh&fidx=219&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&greem_f_a=<%=rgreem_f_a%>&sjb_type_no=<%=rsjb_type_no%>';
        } else if (result.isDenied) {
            location.href = 'TNG1_b_choiceframe_fix.asp?mode=wh&fidx=222&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&greem_f_a=<%=rgreem_f_a%>&sjb_type_no=<%=rsjb_type_no%>';
        }
    });
}
</script>

<script>
window.onload = function() {
    frameselect();
}
</script>
<% 

    end if
%>
<% 

    if rmode = "wh" then

        if rfkidx="" then   

            'tk_framek 만들기 시작
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
                    '==============================
                    'tng_sjaSub 만들기 시작
                    if rsjsidx="" then

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
                        'Response.write (SQL)&"<br><br>"
                        Dbcon.Execute (SQL)
                        'response.end  

                        SQL="Select max(sjsidx) from tng_sjaSub" 'rsjsidx 찾기
                        Rs1.open Sql,Dbcon,1,1,1
                        if not (Rs1.EOF or Rs1.BOF ) then
                            rsjsidx=Rs1(0)
                        end if
                        Rs1.Close

                    end if
                    'tng_sjaSub 만들기 완료
                    '==============================

                    'fkidx값 찾기 '프레임에서는 rfkidx가 없을 때만 만들고 존재 할 때는 동일한 rfkidx를 사용한다.
                    SQL="Select max(fkidx) from tk_frameK"
                    Rs1.open Sql,Dbcon,1,1,1
                    if not (Rs1.EOF or Rs1.BOF ) then
                        rfkidx=Rs1(0)+1
                        if isnull(rfkidx) then 
                        rfkidx=1
                        end if 
                    end if
                    Rs1.Close

                    'fknickname=Request("fknickname")  '이제는 사용하지 않음

                    SQL=" Insert into tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE "
                    SQL=SQL&" , GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fmidx, fwdate, fmeidx, fewdate,  fstatus, sjidx, sjb_type_no, sjsidx) "
                    SQL=SQL&" Values ('"&rfkidx&"', '"&fknickname&"', '"&wfidx&"', '"&rsjb_idx&"', '"&fname&"', '"&GREEM_F_A&"', '"&GREEM_BASIC_TYPE&"' "
                    SQL=SQL&" , '"&GREEM_FIX_TYPE&"', '"&GREEM_HABAR_TYPE&"', '"&GREEM_LB_TYPE&"', '"&GREEM_O_TYPE&"', '"&GREEM_FIX_name&"', '"&GREEM_MBAR_TYPE&"' "
                    SQL=SQL&" , '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '1', '"&rsjidx&"', '"&rsjb_type_no&"', '"&rsjsidx&"') "
                    'Response.write (SQL)&"<br><br>"
                    Dbcon.Execute (SQL)

            
            end if
            rs.close
            
        response.write "<script>location.replace('TNG1_b_choiceframe_fix.asp?mode=wh1&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&rfkidx&"&fidx="&rfidx&"&greem_f_a="&rgreem_f_a&"');</script>"
     
        end if

    end if
%>
<% 
    if rmode = "wh1" then

%>   
<script>
    function sendDimensions(w_frame, h_frame) {
        const url = `TNG1_b_choiceframe_fix.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fidx=<%=rfidx%>&greem_f_a=<%=rgreem_f_a%>&sjb_type_no=<%=rsjb_type_no%>&w_frame=${encodeURIComponent(w_frame)}&h_frame=${encodeURIComponent(h_frame)}`;
        window.location.href = url;
    }

    function onSendButtonClick() {
        let w_frame, h_frame;

        <% If rfidx="219" Then %>
        // 가로 2줄 고정
        w_frame = 2;
        alert('가로줄 수량은 2로 고정됩니다.');
        h_frame = prompt('세로줄 수량을 입력하세요:');
        if (h_frame === null) return;
        h_frame = parseInt(h_frame, 10);
        if (isNaN(h_frame) || h_frame < 2) { alert('세로줄 수량을 2 이상으로 입력하세요.'); return; }
        <% ElseIf rfidx="222" Then %>
        w_frame = prompt('가로줄 수량(최소 3)을 입력하세요:');
        if (w_frame === null) return;
        h_frame = prompt('세로줄 수량을 입력하세요:');
        if (h_frame === null) return;

        w_frame = parseInt(w_frame, 10);
        h_frame = parseInt(h_frame, 10);
        if (isNaN(w_frame) || w_frame < 3) { alert('가로줄 수량은 3 이상이어야 합니다.'); return; }
        if (isNaN(h_frame) || h_frame < 2) { alert('세로줄 수량을 2 이상으로 입력하세요.'); return; }
        <% Else %>
        // 기타: 자유 입력
        w_frame = prompt('가로줄 수량을 입력하세요:');
        if (w_frame === null) return;
        h_frame = prompt('세로줄 수량을 입력하세요:');
        if (h_frame === null) return;

        w_frame = parseInt(w_frame, 10);
        h_frame = parseInt(h_frame, 10);
        if (isNaN(w_frame) || isNaN(h_frame)) { alert('숫자를 입력하세요.'); return; }
        <% End If %>

        sendDimensions(w_frame, h_frame);
    }
</script>
<script>onSendButtonClick();</script>

<% 
    end if
%>
<%

    


If rfidx="219"  and rw_frame<>"" and rh_frame<>"" Then 'fidx=219 고정창
    'response.write "w_frame"&rw_frame&"//"&rh_frame
    'response.end
    ' 가로줄은 무조건 2줄로 고정
    rw_frame = 2
 


      '삽입 직전, 첫 생성 여부 확인
    '======================
    SQL = "SELECT COUNT(*) FROM tk_framek WHERE sjsidx = " & rsjsidx
       Response.write (SQL)&"<br><br>"
 
    Rs.Open SQL, Dbcon
    response.write (Rs(0))&"<br><br>"
    If Rs(0) = 1 Then
        isFirstCreate = True   ' 이번이 첫 프레임 생성
    Else
        isFirstCreate = False
    End If
        response.write "(3) isFirstCreate "&isFirstCreate&"::::"&base_y_offset&"/<br>"
    Rs.Close
 
    '========================================================
    ' 1️⃣ 기존 프레임의 오른쪽 끝(lastxi) 구하기
    '========================================================
    SQL = "SELECT fkidx FROM tk_framek WHERE sjsidx='" & rsjsidx & "' ORDER BY fkidx"
   
    Rs.Open SQL, Dbcon

    lastxi = 0
    Do While Not Rs.EOF
        fk = Rs("fkidx")

        SQL2 = "SELECT TOP 1 xi, wi FROM tk_framekSub " & _
               "WHERE fkidx = " & fk & " AND wi <> '0' ORDER BY xi DESC"
        Rs2.Open SQL2, Dbcon

        If Not Rs2.EOF Then
            xiVal = CLng(Rs2("xi")) 
            wiVal = CLng(Rs2("wi"))
            lastxi = xiVal + wiVal   ' ← 오른쪽 끝 업데이트
        End If

        Rs2.Close
        Rs.MoveNext
    Loop
    Rs.Close



       '========================================================
    ' 2️⃣ 이번에 복제할 fidx=219 프레임의 최좌측 xi(min_xi) 구하기
    '========================================================
    SQL = "SELECT MIN(xi) FROM tk_frameSub WHERE fidx = 219"
    Rs2.Open SQL, Dbcon

    If Not (Rs2.BOF Or Rs2.EOF) Then
        min_xi = CLng(Rs2(0))
    Else
        min_xi = 0
    End If
    Rs2.Close



    ' =============== 템플릿 로드 (fidx=219) ===============
    SQL = "SELECT a.fsidx, a.fidx, a.xi, a.yi, a.wi, a.hi, a.imsi"
    SQL = SQL & ", a.WHICHI_FIX, a.WHICHI_AUTO"
    SQL = SQL & ", b.glassselect , c.glassselect "
    SQL = SQL & ", c.WHICHI_FIXname, b.WHICHI_AUTOname"
    SQL = SQL & " FROM tk_frameSub a"
    SQL = SQL & " JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
    SQL = SQL & " JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
    SQL = SQL & " WHERE a.fidx = 219 "
    'Response.Write SQL & "<br><br>"
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
    Do While Not Rs1.EOF
        fsidx              = Rs1(0)
        fidx               = Rs1(1)
        xi                 = Rs1(2)
        yi                 = Rs1(3)
        wi                 = Rs1(4)
        hi                 = Rs1(5)
        imsi               = Rs1(6)
        whichi_fix         = Rs1(7)
        whichi_auto        = Rs1(8)
        glassselect_auto   = Rs1(9)
        glassselect_fix    = Rs1(10)
        WHICHI_FIXname     = Rs1(11)
        WHICHI_AUTOname    = Rs1(12)

            ' ---- base_xi 설정(첫 세로바를 기준으로) ----
            If whichi_fix = 6 And xi = 700 Then 
                base_xi = xi
            end if

            k = k + 1

            ' ▼ 자재 정보 초기화
            bfidx = ""
            xsize = ""
            ysize = ""
            gls = ""

            response.write "(========)"&k&"(========)"&"<br>"
            response.write "(1)"&WHICHI_FIXname&"::::"&whichi_fix&"/<br>"
            response.write "(2) 세로값 "&yi&"::::"&base_y_offset&"/<br>"
            
            'response.write "glassselect_auto:"&glassselect_auto&"/<br>"
            'response.write "glassselect_fix:"&glassselect_fix&"/<br>"
            '부속 기본값 자동으로 넣기 위한 코드 시작

            ' ▶ glassselect, whichi_auto, whichi_fix에 따른 barasiF 조회
            If glassselect_auto = 0 or glassselect_fix = 0 Then  '자재의경우
                SQL = "SELECT bfidx, xsize, ysize "
                SQL = SQL & "FROM tk_barasiF "
                SQL = SQL & "WHERE sjb_idx = '" & rsjb_idx & "'"
                
                If rgreem_f_a = "2" Then
                    SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
                ElseIf rgreem_f_a = "1" Then
                    SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
                End If

                'Response.Write(SQL) & "  ---[glassselect = 0]<br><br>"
            Else
                If whichi_auto > 0 Then ' glassselect ≠ 0일 때 자동유리
                    SQL = "SELECT bfidx, xsize, ysize "
                    SQL = SQL & "FROM tk_barasiF "
                    SQL = SQL & "WHERE sjb_idx = '129'"
                    SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
                    'Response.Write(SQL) & "  ---[glassselect ≠ 0 and whichi_auto]<br><br>"
                ElseIf whichi_fix > 0 Then ' glassselect ≠ 0일 때 수동유리
                    SQL = "SELECT bfidx, xsize, ysize "
                    SQL = SQL & "FROM tk_barasiF "
                    SQL = SQL & "WHERE sjb_idx = '134'"
                    SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
                    'Response.Write(SQL) & "  ---[glassselect ≠ 0 and whichi_fix]<br><br>"
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
                        Case 4,5,6,7,10
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

            ' ▶ tk_framekSub 1차 인서트 (fidx=219)

            imsi = 1

            '========================================================
            ' 4️⃣ xi 좌표를 오른쪽으로 이동시키는 핵심 코드
            '========================================================
                If isFirstCreate = True Then
                    new_xi = (xi - min_xi) + 280   ' ★ 첫 생성은 무조건 280
                    response.write "11"
                Else
                    new_xi = (xi - min_xi) + lastxi   ' ★ 이후부터 오른쪽에 붙임

                    response.write "22"
                End If

            SQL1 = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
            SQL1 = SQL1 & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls, garo_sero) "
            SQL1 = SQL1 & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & yi & "', '" & wi & "', '" & hi & "'"
            SQL1 = SQL1 & ", '" & C_midx & "', getdate(), '" & imsi & "', '" & whichi_fix & "', '" & whichi_auto & "'"
            SQL1 = SQL1 & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '" & gls & "', '"&garo_sero&"' )"
            Response.Write(SQL1)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (3)(fidx=222) 인서트 수행<br><br>"
            Dbcon.Execute(SQL1)


            ' ---- 세로바 복제: rh_frame(세로줄 수) 기준, 열(컬럼) 늘리기 ----
            If rh_frame > 2 Then
                ' 세로바 기준으로 열을 우측으로 복제(간격 420)
                If whichi_fix = 6 And xi = base_xi Then
                    repeat_count = rh_frame - 2
                    For i = 1 To repeat_count
                        'new_xi = base_xi + (420 * i)
                    
                        If isFirstCreate = True Then
                            new_xi = (xi - min_xi) + (420 * i) + 280   ' ★ 첫 생성은 무조건 280
                            response.write "11 + "&new_xi&""
                        Else
                            new_xi = (xi - min_xi) + lastxi + (420 * i)   ' ★ 이후부터 오른쪽에 붙임
                        
                        End If
                        
                        
                        imsi = 1

                        SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx,  xi, yi, wi, hi, fmidx, fwdate"
                        SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls, garo_sero) "
                        SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & yi & "', '" & wi & "', '" & hi & "'"
                        SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi & "', '6', '" & whichi_auto & "'"
                        SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '" & gls & "', '"&garo_sero&"' )"
                        Response.Write(SQL)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (4)세로바 추가 인서트 (" & i & "/" & repeat_count & ")<br><br>"
                        Dbcon.Execute(SQL)

                    Next
                
                End If
            
                ' 가로/픽스바들도 각 컬럼 위치(xi + 420*row)로 복제
                If (whichi_fix = 1 Or whichi_fix = 3 Or whichi_fix = 5 Or whichi_fix = 14 Or whichi_fix = 16) Then
                    For row = 1 To (rh_frame - 2)
                        'new_xi = xi + (420 * row)
                    If isFirstCreate = True Then
                        new_xi = (xi - min_xi) + 280 + (420 * row)  ' ★ 첫 생성은 무조건 280

                    Else
                        new_xi = (xi - min_xi) + lastxi + (420 * row)  ' ★ 이후부터 오른쪽에 붙임  
                    End If    
                        
                        imsi = 1
                        SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                        SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls, garo_sero) "
                        SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & yi & "', '" & wi & "', '" & hi & "'"
                        SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                        SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '" & gls & "' , '"&garo_sero&"' )"
                        Response.Write (SQL)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (5)가로바 추가 인서트 (Row: " & row & ")<br><br>"
                        Dbcon.Execute(SQL)
                    Next
                End If
            End If

         ' ▶ 4차 인서트: 가로 픽스바 추가 (rw_frame >= 4 )

                    If rw_frame > 3  And (whichi_fix = 6 ) Then
 
                        new_hi = hi + ((rw_frame - 3) * 50)

                        SQL = "UPDATE tk_framekSub SET hi = '" & new_hi & "'"
                        SQL = SQL & " WHERE fkidx = '" & rfkidx & "'"
                        SQL = SQL & " AND whichi_fix = 6 "
                        SQL = SQL & " AND imsi = 1 "
                        Response.Write SQL & "  ▶ (6) 세로바 hi증가 업데이트 수행<br><br>"
                        Dbcon.Execute(SQL)

                    end if

                    If rw_frame > 3  And ( whichi_fix = 1 or whichi_fix = 3 Or whichi_fix = 5 Or whichi_fix = 14 Or whichi_fix = 16 ) Then

                        new_yi1 = yi + ((rw_frame - 3) * 50)

                            SQL = "UPDATE tk_framekSub SET yi = '" & new_yi1 & "'"
                            SQL = SQL & " WHERE fkidx = '" & rfkidx & "'"
                            SQL = SQL & " AND whichi_fix = '"&whichi_fix&"' "
                            SQL = SQL & " AND imsi = 1 "
                            Response.Write SQL & "  ▶ (7) yi --> imsi = 1 가로바 50 증가(아래로 내림) 업데이트 수행<br><br>"
                            Dbcon.Execute(SQL)

                    end if

                    If rw_frame > 3 And (whichi_fix = 1 Or whichi_fix = 16) Then

                        ' 200 220 250 270 460 
                        ' 200 220 250 270 300 320 510 

                        imsi = 0

                        For col = 1 To (rw_frame - 3) 

                            new_yi = yi + 50 * ((rw_frame - 3) - col) ' 역순 누적증가~

                                If col = (rw_frame - 3) Then
                                    imsi_insert = 0
                                Else
                                    imsi_insert = 1
                                End If
                                        ' ★ 첫 xi 정렬 보정
                                If isFirstCreate = True Then
                                    new_xi = (xi - min_xi) + 280
                                Else
                                    new_xi = (xi - min_xi) + lastxi
                                End If


                            SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                            SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                            SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & new_yi & "', '" & wi & "', '" & hi & "'"
                            SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi_insert & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                            SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "
                            Response.Write (SQL)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (8)가로 픽스바 추가 인서트 (imsi_insert: " & imsi_insert & ", new_yi: " & new_yi & ", Row: " & row & ", Col: " & col & ")<br><br>"
                            Dbcon.Execute(SQL)

                        Next

                        For row = 1 To (rh_frame - 2)

                            ' ★ xi 보정
                            If isFirstCreate = True Then
                                new_xi = (xi - min_xi) + 280 + (420 * row)
                            Else
                                new_xi = (xi - min_xi) + lastxi + (420 * row)
                            End If


                            For col = 1 To (rw_frame - 3)

                                new_yi = yi + 50 * ((rw_frame - 3) - col)

                                ' 마지막 픽스바는 imsi = 0
                                If col = (rw_frame - 3) Then
                                    imsi_insert = 0
                                Else
                                    imsi_insert = 1
                                End If

                                SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                                SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                                SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & new_yi & "', '" & wi & "', '" & hi & "'"
                                SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi_insert & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                                SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "

                                Response.Write SQL & " ▶ (9)세로픽스 추가 (xi: " & new_xi & ", yi: " & new_yi & ", imsi: " & imsi_insert & ", row: " & row & ", col: " & col & ")<br><br>"
                                Dbcon.Execute(SQL)
                            Next
                        Next

                    End If

    Rs1.MoveNext
    Loop
    End If
    Rs1.Close
response.write "<script>window.close();opener.location.replace('TNG1_B_suju_quick.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&rfkidx&"');</script>"

elseif  rfidx="222" and rw_frame<>"" and rh_frame<>"" Then 'fidx=222 상부남마 고정창
   
    '입력 할 바의 최소값 x좌표 찾기 시작
    
    '삽입 직전, 첫 생성 여부 확인
    '======================
    SQL = "SELECT COUNT(*) FROM tk_framek WHERE sjsidx = " & rsjsidx
       Response.write (SQL)&"<br><br>"
 
    Rs.Open SQL, Dbcon
    response.write (Rs(0))&"<br><br>"
    If Rs(0) = 1 Then
        isFirstCreate = True   ' 이번이 첫 프레임 생성
    Else
        isFirstCreate = False
    End If
        response.write "(3) isFirstCreate "&isFirstCreate&"::::"&base_y_offset&"/<br>"
    Rs.Close
 
    '========================================================
    ' 1️⃣ 기존 프레임의 오른쪽 끝(lastxi) 구하기
    '========================================================
    SQL = "SELECT fkidx FROM tk_framek WHERE sjsidx='" & rsjsidx & "' ORDER BY fkidx"
   
    Rs.Open SQL, Dbcon

    lastxi = 0
    Do While Not Rs.EOF
        fk = Rs("fkidx")

        SQL2 = "SELECT TOP 1 xi, wi FROM tk_framekSub " & _
               "WHERE fkidx = " & fk & " AND wi <> '0' ORDER BY xi DESC"
        Rs2.Open SQL2, Dbcon

        If Not Rs2.EOF Then
            xiVal = CLng(Rs2("xi"))
            wiVal = CLng(Rs2("wi"))
            lastxi = xiVal + wiVal   ' ← 오른쪽 끝 업데이트
        End If

        Rs2.Close
        Rs.MoveNext
    Loop
    Rs.Close



    '========================================================
    ' 2️⃣ 이번에 복제할 fidx=222 프레임의 최좌측 xi(min_xi) 구하기
    '========================================================
    SQL = "SELECT MIN(xi) FROM tk_frameSub WHERE fidx = 222"
    Rs2.Open SQL, Dbcon

    If Not (Rs2.BOF Or Rs2.EOF) Then
        min_xi = CLng(Rs2(0))
    Else
        min_xi = 0
    End If
    Rs2.Close

    '첫번째 추가라면 각 바들의 좌표를 왼쪽 정렬이 되도록 설정한다.
    'SQL="Select min(xi) From tk_frameSub Where fidx = 222 "
    'Rs2.Open SQL, Dbcon
    'If not (Rs2.BOF Or Rs2.EOF) Then
    '    min_xi=Rs2(0) '바들중 가장 좌측에 위치한 바의 x좌표

        'response.write min_xi&"/줄여야 할 x좌표<br>"
    'End if
    'Rs2.Close
    


    '입력 할 바의 최소값 x좌표 찾기 끝

    'tk_frameksub 입력 시작
    SQL = "SELECT a.fsidx, a.fidx, a.xi, a.yi, a.wi, a.hi, a.imsi"
    SQL = SQL & ", a.WHICHI_FIX, a.WHICHI_AUTO"
    SQL = SQL & ", b.glassselect , c.glassselect "
    SQL = SQL & ", c.WHICHI_FIXname, b.WHICHI_AUTOname"
    SQL = SQL & " FROM tk_frameSub a"
    SQL = SQL & " JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
    SQL = SQL & " JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
    SQL = SQL & " WHERE a.fidx = 222 "
    Response.write (SQL)&"<br><br>"
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then 
        maxxi = 0
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

            If whichi_fix = 6 And xi = 700 Then 
                base_xi = xi
            end if



        k = k + 1
        ' ▼ 자재 정보 초기화
        bfidx = ""
        xsize = ""
        ysize = ""
        gls = ""

        response.write "(========)"&k&"(========)"&"<br>"
        response.write "(1)"&WHICHI_FIXname&"::::"&whichi_fix&"/<br>"
        response.write "(2) 세로값 "&yi&"::::"&base_y_offset&"/<br>"
        response.write "(3) isFirstCreate "&isFirstCreate&"::::"&base_y_offset&"/<br>"
        response.write "(3) rsjsidx "&rsjsidx&"::::"&base_y_offset&"/<br>"
                        
        'response.write "glassselect_auto:"&glassselect_auto&"/<br>"
        'response.write "glassselect_fix:"&glassselect_fix&"/<br>"
        '부속 기본값 자동으로 넣기 위한 코드 시작

            ' ▶ glassselect, whichi_auto, whichi_fix에 따른 barasiF 조회
            If glassselect_auto = 0 or glassselect_fix = 0 Then  '자재의경우
                SQL = "SELECT bfidx, xsize, ysize "
                SQL = SQL & "FROM tk_barasiF "
                SQL = SQL & "WHERE sjb_idx = '" & rsjb_idx & "'"
                
                If rgreem_f_a = "2" Then
                    SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
                ElseIf rgreem_f_a = "1" Then
                    SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
                End If

                'Response.Write(SQL) & "  ---[glassselect = 0]<br><br>"
            Else
                If whichi_auto > 0 Then ' glassselect ≠ 0일 때 자동유리
                    SQL = "SELECT bfidx, xsize, ysize "
                    SQL = SQL & "FROM tk_barasiF "
                    SQL = SQL & "WHERE sjb_idx = '129'"
                    SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
                    'Response.Write(SQL) & "  ---[glassselect ≠ 0 and whichi_auto]<br><br>"
                ElseIf whichi_fix > 0 Then ' glassselect ≠ 0일 때 수동유리
                    SQL = "SELECT bfidx, xsize, ysize "
                    SQL = SQL & "FROM tk_barasiF "
                    SQL = SQL & "WHERE sjb_idx = '134'"
                    SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
                    'Response.Write(SQL) & "  ---[glassselect ≠ 0 and whichi_fix]<br><br>"
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
                        Case 4,5,6,7,10
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
                
                'xi=xi-min_xi+max_xi

                ' ▶ tk_framekSub 1차 인서트 (fidx=222)

                    imsi = 1
                '========================================================
                ' 4️⃣ xi 좌표를 오른쪽으로 이동시키는 핵심 코드
                '========================================================
                    If isFirstCreate = True Then
                        new_xi = (xi - min_xi) + 280   ' ★ 첫 생성은 무조건 280
                        response.write "11"
                    Else
                        new_xi = (xi - min_xi) + lastxi   ' ★ 이후부터 오른쪽에 붙임

                        response.write "22"
                    End If
                    


                    SQL1 = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                    SQL1 = SQL1 & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                    SQL1 = SQL1 & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & yi & "', '" & wi & "', '" & hi & "'"
                    SQL1 = SQL1 & ", '" & C_midx & "', getdate(), '" & imsi & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                    SQL1 = SQL1 & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "
                    Response.Write(SQL1)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (3)(fidx=222) 인서트 수행<br><br>"
                    Dbcon.Execute(SQL1)
                    'response.end
                    If whichi_fix = 6 And xi = base_xi And rw_frame >= 3 Then

                        repeat_count = rh_frame - 2

                        For i = 1 To repeat_count

                            
                            If isFirstCreate = True Then
                                new_xi = (xi - min_xi) + (420 * i) + 280   ' ★ 첫 생성은 무조건 280
                                response.write "11 + "&new_xi&""
                            Else
                                new_xi = (xi - min_xi) + lastxi + (420 * i)   ' ★ 이후부터 오른쪽에 붙임
                               
                                
                            End If
                          
                          
                            imsi = 1
                            

                            SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx,  xi, yi, wi, hi, fmidx, fwdate"
                            SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                            SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & yi & "', '" & wi & "', '" & hi & "'"
                            SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi & "', '6', '" & whichi_auto & "'"
                            SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "
                            Response.Write(SQL)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (4)세로바 추가 인서트 (" & i & "/" & repeat_count & ")<br><br>"
                            Dbcon.Execute(SQL)

                        Next

                    End If
                    
                    ' ▶ 3차 인서트: 가로 픽스바 추가 (rh_frame > 2)
                    If rh_frame > 2 And (whichi_fix = 1 Or whichi_fix = 3 Or whichi_fix = 5 Or whichi_fix = 14 Or whichi_fix = 16) Then

                        For row = 1 To (rh_frame - 2)

                        If isFirstCreate = True Then
                            new_xi = (xi - min_xi) + 280 + (420 * row)  ' ★ 첫 생성은 무조건 280

                        Else
                            new_xi = (xi - min_xi) + lastxi + (420 * row)  ' ★ 이후부터 오른쪽에 붙임  
                        End If
                            
                            imsi = 1

                            SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                            SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                            SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & yi & "', '" & wi & "', '" & hi & "'"
                            SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                            SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "
                            Response.Write (SQL)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (5)가로바 추가 인서트 (Row: " & row & ")<br><br>"
                            Dbcon.Execute(SQL)
                        
                        Next

                    End If

                    ' ▶ 4차 인서트: 가로 픽스바 추가 (rw_frame >= 4 )

                    If rw_frame > 3  And (whichi_fix = 6 ) Then
 
                        new_hi = hi + ((rw_frame - 3) * 50)

                        SQL = "UPDATE tk_framekSub SET hi = '" & new_hi & "'"
                        SQL = SQL & " WHERE fkidx = '" & rfkidx & "'"
                        SQL = SQL & " AND whichi_fix = 6 "
                        SQL = SQL & " AND imsi = 1 "
                        Response.Write SQL & "  ▶ (6) 세로바 hi증가 업데이트 수행<br><br>"
                        Dbcon.Execute(SQL)

                    end if

                    If rw_frame > 3  And ( whichi_fix = 1 or whichi_fix = 3 Or whichi_fix = 5 Or whichi_fix = 14 Or whichi_fix = 16 ) Then

                        new_yi1 = yi + ((rw_frame - 3) * 50)

                            SQL = "UPDATE tk_framekSub SET yi = '" & new_yi1 & "'"
                            SQL = SQL & " WHERE fkidx = '" & rfkidx & "'"
                            SQL = SQL & " AND whichi_fix = '"&whichi_fix&"' "
                            SQL = SQL & " AND imsi = 1 "
                            Response.Write SQL & "  ▶ (7) yi --> imsi = 1 가로바 50 증가(아래로 내림) 업데이트 수행<br><br>"
                            Dbcon.Execute(SQL)

                    end if

                    If rw_frame > 3 And (whichi_fix = 1 Or whichi_fix = 16) Then

                        ' 200 220 250 270 460 
                        ' 200 220 250 270 300 320 510 

                        imsi = 0

                        For col = 1 To (rw_frame - 3) 

                            new_yi = yi + 50 * ((rw_frame - 3) - col) ' 역순 누적증가~

                                If col = (rw_frame - 3) Then
                                    imsi_insert = 0
                                Else
                                    imsi_insert = 1
                                End If
                                        ' ★ 첫 xi 정렬 보정
                                If isFirstCreate = True Then
                                    new_xi = (xi - min_xi) + 280
                                Else
                                    new_xi = (xi - min_xi) + lastxi
                                End If


                            SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                            SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                            SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & new_yi & "', '" & wi & "', '" & hi & "'"
                            SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi_insert & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                            SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "
                            Response.Write (SQL)&WHICHI_FIXname&"=" & WHICHI_FIX &"/"&"  ▶ (8)가로 픽스바 추가 인서트 (imsi_insert: " & imsi_insert & ", new_yi: " & new_yi & ", Row: " & row & ", Col: " & col & ")<br><br>"
                            Dbcon.Execute(SQL)

                        Next

                        For row = 1 To (rh_frame - 2)

                            ' ★ xi 보정
                            If isFirstCreate = True Then
                                new_xi = (xi - min_xi) + 280 + (420 * row)
                            Else
                                new_xi = (xi - min_xi) + lastxi + (420 * row)
                            End If


                            For col = 1 To (rw_frame - 3)

                                new_yi = yi + 50 * ((rw_frame - 3) - col)

                                ' 마지막 픽스바는 imsi = 0
                                If col = (rw_frame - 3) Then
                                    imsi_insert = 0
                                Else
                                    imsi_insert = 1
                                End If

                                SQL = "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate"
                                SQL = SQL & ", imsi, WHICHI_FIX, WHICHI_AUTO, bfidx, xsize, ysize, gls ,garo_sero) "
                                SQL = SQL & "VALUES ('" & rfkidx & "', '" & fsidx & "', '" & fidx & "', '" & new_xi & "', '" & new_yi & "', '" & wi & "', '" & hi & "'"
                                SQL = SQL & ", '" & C_midx & "', getdate(), '" & imsi_insert & "', '" & whichi_fix & "', '" & whichi_auto & "'"
                                SQL = SQL & ", '" & bfidx & "', '" & xsize & "', '" & ysize & "', '"&gls&"', '"&garo_sero&"' ) "

                                Response.Write SQL & " ▶ (9)세로픽스 추가 (xi: " & new_xi & ", yi: " & new_yi & ", imsi: " & imsi_insert & ", row: " & row & ", col: " & col & ")<br><br>"
                                Dbcon.Execute(SQL)
                            Next
                        Next

                    End If

    Rs1.MoveNext
    Loop
    End If
    Rs1.Close

    'tk_frameksub 입력 끝

'tk_framk 만들기 끝 
'내일 출근하면 sjs만들기!!!!!!!!!!!!!
'Response.end


response.write "<script>window.close();opener.location.replace('TNG1_B_suju_quick.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&rfkidx&"');</script>"
End If
'Response.end

               
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
    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

</head>
<body class="sb-nav-fixed">


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
