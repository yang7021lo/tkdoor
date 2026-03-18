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

rgreem_f_a=Request("greem_f_a")
rfidx=request("fidx")
rfkidx=request("fkidx")

rmode=Request("mode")
'Response.write rgreem_f_a&"<br>"
'Response.write rsjb_type_no&"<br>"

if  rfkidx<>"" then
  SQL="Select tw, th From tk_framek where fkidx='"&rfkidx&"' " 
  response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    rtw=Rs(0)
    rth=Rs(1)
  End If
  Rs.Close

end if 
%>

<!--rfkidx가 존재하는데 검측 가로 세로의 길이 값이 없을 경우 입력 받기 시작 -->
<% 
if rfkidx<>""  and rtw="0" and rmode<>"twth" then 
  response.write "걸려라<br>"
  response.write ""
%>
 

    <script>
      function sendDimensions(tw, th) {
        // 입력받은 가로 세로 값을 rfkidx와 함께 전달한다.
        const url = `TNG1_b_choiceframeb.asp?mode=twth&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&greem_f_a=<%=rgreem_f_a%>&sjb_type_no=<%=rsjb_type_no%>&tw=${encodeURIComponent(tw)}&th=${encodeURIComponent(th)}`;

        // GET 방식으로 이동
        window.location.href = url;
      }

      // 검측가로와 세로의 길이를 입력 받는다.
      function onSendButtonClick() {
        const tw = prompt("검측 가로 길이를 입력하세요:");
        const th = prompt("검측 세로 길이를 입력하세요:");
        sendDimensions(tw, th);
      }
    </script>
<script>onSendButtonClick();</script>
  <% end if %>
  <% if rfkidx<>""  and rmode="twth" then

      rtw=Request("tw") '검측 가로길이
      rth=Request("th") '검축 세로길이

      '검측길이업데이트
      if rtw<>"" then 
        SQL="Update tk_framek set tw='"&rtw&"', th='"&rth&"' where fkidx='"&rfkidx&"' " 
        Response.write (SQL)&"<br><br>"
        'Response.end
        Dbcon.Execute (SQL)

      end if
    end if
  %>

  <%

  if rfkidx<>"" then 

  SQL="Select tw, th From tk_framek where fkidx='"&rfkidx&"' " 
  response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    rtw=Rs(0)
    rth=Rs(1)
  End If
  Rs.Close

  response.write rtw&"/<br>"
      ' 갯수 찾기
      SQL="Select count(whichi_fix) From tk_framekSub where fkidx='"&rfkidx&"' and gls=0 "
      Response.write (SQL)&"<br><br>"
      Rs.open Sql,Dbcon
      If Not (Rs.bof or Rs.eof) Then 
      Do while not Rs.EOF
        count_whichi_fix=Rs(0)
        gcnt=gcnt+1 ' 갯수
        Response.write "#"&gcnt&"/<br>"

          SQL=" Select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.bfidx, A.blength, A.xsize, A.ysize , A.whichi_fix, A.whichi_auto ,a.gls "
          SQL=SQL&" From tk_FramekSub A "
          SQL=SQL&" Where A.fkidx='"&rfkidx&"' and A.gls=0 "
          Response.write (SQL)&"<br><br>"
          Rs1.open Sql,Dbcon
          If Not (Rs1.bof or Rs1.eof) Then 
          Do while not Rs1.EOF
            fksidx=Rs1(0)
            xi=Rs1(1)
            yi=Rs1(2)
            wi=Rs1(3)
            hi=Rs1(4)
            bfidx=Rs1(5)
            blength=Rs1(6)
            xsize=Rs1(7)
            ysize=Rs1(8)
            whichi_fix=Rs1(9)
            whichi_auto=Rs1(10)
            gls=rs1(11)
  

              ' 가로/세로바 알아내기 

            '세로바라면
            If WHICHI_FIX = 6 Or WHICHI_FIX = 7 Or WHICHI_FIX = 8 Or WHICHI_FIX = 9 Or WHICHI_FIX = 10 Or WHICHI_FIX = 20 Then 

                SQL="Update tk_FramekSub set blength='"&rth&"' Where fksidx='"&fksidx&"' "
                Response.write (SQL)&"<br><br>"
                'Response.end
                Dbcon.Execute (SQL)

            '가로바라면    
            ElseIf WHICHI_FIX = 1 Or WHICHI_FIX = 2 Or WHICHI_FIX = 3 Or WHICHI_FIX = 4 Or WHICHI_FIX = 5 Or WHICHI_FIX = 21 Or WHICHI_FIX = 22 Then
               
                ctw=ctw+1 '동일한 y좌표상의 가로바의 갯수
                If ctw="1" Then 
                  afksidx=fksidx
                Else
                  afksidx=fksidx&","&afksidx
                End If
                Response.write ctw&"/"&afksidx&"안녕<br>"
                  lfksidx=fksidx  '길이가 소수점 1자리가지 있을 경우 마지막 바에 몰아주기를 위한 fksidx설정

            End If

            '변수 초기화
            whrate=0

          Rs1.movenext
          Loop
          End if
          Rs1.close


          if ctw>1 then 
            SQL="Select wi, hi, blength, ysize "
            SQL=SQL&" From tk_framekSub Where fkidx='"&rfkidx&"' and yi<='"&yi&"' and hi>('"&yi&"'-yi)  "
            if ( gls >= 1 and  gls <= 6 ) then  'gls =1,2 도어 3,4,5,6 픽스유리 0=자재
            SQL=SQL&" and whichi_fix in (6,7,8,9,10,20) " ' 세로바 종류들만. 
            else
            SQL=SQL&" and whichi_fix not in (1,2,3,4,5,21,22)      " '가로바 종류만 제외하기
            end if 

            Response.write (SQL)&"<br><br>"
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
            Do while not Rs1.EOF
              xwi=Rs1(0)
              xhi=Rs1(1)
              xblength=Rs1(2)
              xysize=Rs1(3)

              if xwi > xhi then '가로바라면 
                xlblength=xblength
              else
                xlblength=xysize '세로바라면 ysize 가 xlblength
              end if 
              axlblength=xlblength+axlblength 

              Response.write "axlblength:"&axlblength&"/"&xlblength&"/"&rtw&"<br>"

            Rs1.movenext
            Loop
            End if
            Rs1.close


            '가로바 길이 업데이트
            atw=rtw-axlblength
            Response.write atw&"/"&rtw&"/"&axlblength&"/<br>"
            '가로바 하나의 길이
            'dtw=round(atw/ctw,0)  '1mm버림 문제*********
            dtw=atw/ctw ' 전체가로 값에서 추가입력 할때마다 1/2 나누게 되는부분

            idtw=int(dtw) '소수값 반내림

            diffdtw=dtw-idtw
            Response.write dtw&"/"&atw&"/"&ctw&"/"&diffdtw&"/"&lfksidx&"기본<br>"

            SQL="Update tk_FramekSub set blength='"&idtw&"' Where fkidx='"&rfkidx&"' and fksidx in ("&afksidx&") "
            Response.write (SQL)&"<br>"
            'Response.end
            Dbcon.Execute (SQL)
          end if

          '가로길이 소수점 이하시 마지막 바에 몰아주기
          axlblength=0
          xlblength=0
          axlblength=0

          if diffdtw<>"0" or ctw="1" then 
            SQL="Select wi, hi, blength, ysize , whichi_fix"
            SQL=SQL&" From tk_framekSub Where fkidx='"&rfkidx&"' and yi<='"&yi&"' and hi>'"&yi&"'-yi and fksidx<>'"&lfksidx&"' "
            Response.write (SQL)&"ㅁㅁ<br><br>"
            Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
            Do while not Rs1.EOF
              xwi=Rs1(0)
              xhi=Rs1(1)
              xblength=Rs1(2)
              xysize=Rs1(3)
              whichi_fix=Rs1(4)

              'if xwi > xhi then
              '  xlblength=xblength
              'else
              '  xlblength=xysize
              'end if 
              select case whichi_fix
              case "6"
                xlblength=xysize
              case "4", "12"
                xlblength=xblength
              end select
              
              axlblength=xlblength+axlblength

              Response.write "axlblength:"&axlblength&"/"&xlblength&"/"&whichi_fix&"/라스트<br>"

            Rs1.movenext
            Loop
            End if
            Rs1.close
            Response.write "axlblength:"&axlblength&"<br>"
            vddtw=rtw-axlblength  '검측가록에서 다른 바들의 가로길이를 제외한 값

            SQL="Update tk_FramekSub set blength='"&vddtw&"' Where fkidx='"&rfkidx&"' and fksidx='"&lfksidx&"' "
            Response.write (SQL)&"<br><br><br><br>"
            'Response.end
            Dbcon.Execute (SQL)
          end if 

        '변수초기화
        ctw=0
        atw=0
        dtw=0
        axlblength=0
        xlblength=0
        xblength=0
        xwi=0
        xhi=0
      Rs.movenext
      Loop
      End if
      Rs.close


 
end if


  %>


<!--rfkidx가 존재하는데 검측 가로 세로의 길이 값이 없을 경우 입력 받기 끝 -->
<%
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


'부속이 적용된 신규 입면도면 구성을 위한 코드 시작
'=======================================
if Request("part")="pummoksub" then 
'response.write rsjb_idx&"<br>"
'response.write rfidx&"<br>"


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
  SQL="Select fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fstatus "
  SQL=SQL&" From tk_frame "
  SQL=SQL&" Where fidx='"&rfidx&"' "
  Response.write (SQL)&"<br><br>"
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

    if rfkidx="" then   '프레임에서는 rfkidx가 없을 때만 만들고 존재 할 때는 동일한 rfkidx를 사용한다.
    'fkidx값 찾기
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
      SQL=SQL&" Values ('"&rfkidx&"', '"&fknickname&"', '"&rfidx&"', '"&rsjb_idx&"', '"&fname&"', '"&GREEM_F_A&"', '"&GREEM_BASIC_TYPE&"' "
      SQL=SQL&" , '"&GREEM_FIX_TYPE&"', '"&GREEM_HABAR_TYPE&"', '"&GREEM_LB_TYPE&"', '"&GREEM_O_TYPE&"', '"&GREEM_FIX_name&"', '"&GREEM_MBAR_TYPE&"' "
      SQL=SQL&" , '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '1', '"&rsjidx&"', '"&rsjb_type_no&"', '"&rsjsidx&"') "
      Response.write (SQL)&"<br><br>"
      Dbcon.Execute (SQL)
    Else  '첫번째 입력이 아니라면

      ' 최근에 입력한 바의 가장 우측에 있는 바의 x좌표와 wi(가로) 값을 알아내어 추가할 바의 x좌표에 적용한다.
      SQL="Select xi, wi from tk_framekSub where fkidx='"&rfkidx&"' and xi=(Select max(xi) From tk_framekSub where fkidx='"&rfkidx&"') "
      Rs2.Open SQL, Dbcon
      If not (Rs2.BOF Or Rs2.EOF) Then
        right_xi=Rs2(0)
        right_wi=Rs2(1)
        max_xi=right_xi+right_wi  '새로 입력할 바의 x좌표
      End If
      Rs2.Close

    end if


'입력 할 바의 최소값 x좌표 찾기 시작
'======================

'첫번째 추가라면 각 바들의 좌표를 왼쪽 정렬이 되도록 설정한다.
  SQL="Select min(xi) From tk_frameSub Where fidx = '"&rfidx&"'"
  Rs2.Open SQL, Dbcon
  If not (Rs2.BOF Or Rs2.EOF) Then
    min_xi=Rs2(0) '바들중 가장 좌측에 위치한 바의 x좌표

    response.write min_xi&"/줄여야 할 x좌표<br>"
  End if
  Rs2.Close

'======================
'입력 할 바의 최소값 x좌표 찾기 끝




    'tk_frameksub 입력 시작
    SQL = "SELECT a.fsidx, a.fidx, a.xi, a.yi, a.wi, a.hi, a.imsi"
    SQL = SQL & ", a.WHICHI_FIX, a.WHICHI_AUTO"
    SQL = SQL & ", b.glassselect , c.glassselect "
    SQL = SQL & ", c.WHICHI_FIXname, b.WHICHI_AUTOname"
    SQL = SQL & " FROM tk_frameSub a"
    SQL = SQL & " LEFT OUTER JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
    SQL = SQL & " LEFT OUTER JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
    SQL = SQL & " WHERE a.fidx = '" & rfidx & "'"
    Response.write (SQL)&"<br><br>"
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
response.write "glassselect_auto:"&glassselect_auto&"/<br>"
response.write "glassselect_fix:"&glassselect_fix&"/<br>"
'부속 기본값 자동으로 넣기 위한 코드 시작

' ▶ glassselect, whichi_auto, whichi_fix에 따른 barasiF 조회
    If glassselect_auto = 0 or glassselect_fix = 0 Then  '자재의경우
        SQL = "SELECT bfidx, xsize, ysize "
        SQL = SQL & "FROM tk_barasiF "
        SQL = SQL & "WHERE sjb_idx = '" & rsjb_idx & "'"
        
        If greem_f_a = "2" Then
            SQL = SQL & " AND whichi_auto = '" & whichi_auto & "'"
        ElseIf greem_f_a = "1" Then
            SQL = SQL & " AND whichi_fix = '" & whichi_fix & "'"
        End If

        Response.Write(SQL) & "  ---[glassselect = 0]<br><br>"
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

If whichi_auto > 0  Then
    gls = glassselect_auto
ElseIf  whichi_fix > 0 Then
    gls = glassselect_fix
End If


xi=xi-min_xi+max_xi


    SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx,xsize,ysize,gls) "
    SQL=SQL&" Values ('"&rfkidx&"', '"&fsidx&"', '"&fidx&"', '"&xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '"&C_midx&"' "
    SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"', '"&xsize&"', '"&ysize&"', '"&gls&"') "
    Response.write (SQL)&"  ---55555555555<br>"
    Dbcon.Execute (SQL)

    Rs1.movenext
    Loop
    End if
    Rs1.close
    'tk_frameksub 입력 끝
End If
Rs.Close

'tk_framk 만들기 끝  
'Response.end



response.write "<script>location.replace('TNG1_b_choiceframeb.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"&fkidx="&rfkidx&"&mode="&rmode&"');alert('추가되었습니다.');opener.location.replace('TNG1_B_suju2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&fkidx&"');</script>"
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

    function pummoksub(fidx){
        if (confirm("선택한 입면 도면을 추가하시겠습니까?"))
        {
            location.href="TNG1_b_choiceframeb.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&greem_f_a=<%=rgreem_f_a%>&fkidx=<%=rfkidx%>&mode=<%=rmode%>&fidx="+fidx;
        }
    }
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
<form name="frmMainsub" action="TNG1_b_choiceframeb.asp" method="POST">  

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
                                    SQL = SQL & " , b.glassselect,a.WHICHI_AUTO,a.WHICHI_FIX, c.glassselect"     
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

                                            if WHICHI_AUTO<>"" and WHICHI_FIX=0 then

                                                If CInt(glassselect_auto) = 0 Then
                                                    fillColor = "#DCDCDC" ' 회색
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
