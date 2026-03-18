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

Response.Write "hello"
 


projectname="도면선택"

gubun=Request("gubun")
rsjidx=request("sjidx")
rsjsidx=request("sjsidx")
rsjb_idx=request("sjb_idx")
rsjb_type_no=request("sjb_type_no")

rgreem_f_a=Request("greem_f_a")
rfidx=request("fidx")
'Response.write rgreem_f_a&"<br>"
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

    'fkidx값 찾기
    SQL="Select max(fkidx) from tk_frameK"
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
      fkidx=Rs1(0)+1
      if isnull(fkidx) then 
        fkidx=1
      end if 
    end if
    Rs1.Close

    fknickname=Request("fknickname")
    SQL=" Insert into tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE "
    SQL=SQL&" , GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, GREEM_MBAR_TYPE, fmidx, fwdate, fmeidx, fewdate,  fstatus, sjidx, sjb_type_no, sjsidx) "
    SQL=SQL&" Values ('"&fkidx&"', '"&fknickname&"', '"&rfidx&"', '"&rsjb_idx&"', '"&fname&"', '"&GREEM_F_A&"', '"&GREEM_BASIC_TYPE&"' "
    SQL=SQL&" , '"&GREEM_FIX_TYPE&"', '"&GREEM_HABAR_TYPE&"', '"&GREEM_LB_TYPE&"', '"&GREEM_O_TYPE&"', '"&GREEM_FIX_name&"', '"&GREEM_MBAR_TYPE&"' "
    SQL=SQL&" , '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '1', '"&rsjidx&"', '"&rsjb_type_no&"', '"&rsjsidx&"') "
    Response.write (SQL)&"<br><br>"
    Dbcon.Execute (SQL)


    'tk_frameksub 입력 시작
    SQL=" Select fsidx, fidx, xi, yi, wi, hi, imsi, whichi_fix, whichi_auto from tk_frameSub Where fidx='"&rfidx&"' "
    Response.write (SQL)&"<br><br>"
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

'부속 기본값 자동으로 넣기 위한 코드 시작
        SQL=" Select bfidx "
        SQL=SQL&" From tk_barasiF "
        SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
        if greem_f_a="2" then
        SQL=SQL&" and whichi_auto='"&WHICHI_AUTO&"' "
        Elseif  greem_f_a="1" then
        SQL=SQL&" and whichi_fix='"&WHICHI_FIX&"' "
        End if 
        Response.write (SQL)&"<br><br>"
        Rs2.open Sql,Dbcon
        If Not (Rs2.bof or Rs2.eof) Then 
            bfidx=Rs2(0)
        End If
        Rs2.Close
'부속 기본값 자동으로 넣기 위한 코드 끝




      SQL=" Insert into tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, WHICHI_FIX, WHICHI_AUTO, bfidx) "
      SQL=SQL&" Values ('"&fkidx&"', '"&fsidx&"', '"&fidx&"', '"&xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '"&C_midx&"' "
      SQL=SQL&" , getdate(), '"&imsi&"', '"&WHICHI_FIX&"', '"&WHICHI_AUTO&"', '"&bfidx&"') "
      Response.write (SQL)&"<br>"
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
response.write "<script>opener.location.replace('tng1b_suju2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&sjb_type_no="&rsjb_type_no&"&sjb_idx="&rsjb_idx&"&fkidx="&fkidx&"');window.close()</script>"
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
//    function pummoksub(fidx) {
//      const message = prompt("이 입면 도면을 기본으로 부속이 적용된 신규 부족적용 입면 도면 생성합니다. 입면도면의 이름을 입력하세요.");
//      if (message !== null && message.trim() !== "") {
//        const encodedMessage = encodeURIComponent(message.trim());
//        window.location.href = "choiceframe.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fidx="+fidx+"&fknickname="+encodedMessage;
//      }
//    }
    function pummoksub(fidx){
        if (confirm("선택한 입면 도면을 불러오시겠습니까?"))
        {
            location.href="choiceframe.asp?part=pummoksub&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_type_no=<%=rsjb_type_no%>&sjb_idx=<%=rsjb_idx%>&SearchWord=<%=SearchWord%>&fidx="+fidx;
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
<form name="frmMainsub" action="choiceframe.asp" method="POST">  

      <div class="card-body">
        <div >
                <div class="row ">
                    <%
                    sql = " SELECT fidx, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, fmidx, fwdate, fmeidx, fewdate ,greem_o_type, greem_habar_type, greem_lb_type, GREEM_MBAR_TYPE "
                    sql = sql & " FROM tk_frame "
                    sql = sql & " WHERE fidx <>'' "
                    sql = sql & " and greem_f_a= '"&rgreem_f_a&"'  "
                    if rgreem_f_a="2" then  '자동
                    sql = sql & " and GREEM_BASIC_TYPE = '1'  "
                    sql = sql & " and greem_fix_type = '0' "
                    sql = sql & " and greem_habar_type = '0' "
                    sql = sql & " and greem_lb_type = '0' "
                    sql = sql & " and GREEM_MBAR_TYPE = '0' "
                    elseif  rgreem_f_a="1" Then '수동

                    end if
                    'response.write (SQL)&"<br>"
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do while not Rs.EOF
                    fidx        = rs(0)
                    greem_f_a        = rs(1)
                    greem_basic_type = rs(2)
                    greem_fix_type   = rs(3)
                    fmidx       = rs(4)
                    fwdate      = rs(5)
                    fmeidx      = rs(6)
                    fewdate     = rs(7)
                    greem_o_type     = rs(8)
                    greem_habar_type     = rs(9)
                    greem_lb_type     = rs(10)
                    GREEM_MBAR_TYPE     = rs(11)

                    ' ▼ greem_f_a 변환
                    Select Case greem_f_a
                        Case "1"
                            greem_f_a_name = "자동"
                        Case "2"
                            greem_f_a_name = "수동"
                        Case Else
                            greem_f_a_name = "기타"
                    End Select

                    ' ▼ greem_basic_type 변환
                    Select Case greem_basic_type
                        Case "1"
                            greem_basic_type_name = "기본"
                        Case "2"
                            greem_basic_type_name = "인서트 타입(T형)"
                        Case "3"
                            greem_basic_type_name = "픽스바 없는 타입"
                        Case "4"
                            greem_basic_type_name = "자동홈바 없는 타입"
                        Case Else
                            greem_basic_type_name = "기타 타입"
                    End Select

                    ' ▼ greem_o_type 변환
                    Select Case greem_o_type
                        Case "1"
                            greem_o_type_name = "외도어"
                        Case "2"
                            greem_o_type_name = "외도어 상부남마"
                        Case "3"
                            greem_o_type_name = "외도어 상부남마 중간소대"
                        Case "4"
                            greem_o_type_name = "양개"
                        Case "5"
                            greem_o_type_name = "양개 상부남마"
                        Case "6"
                            greem_o_type_name = "양개 상부남마 중간소대"
                        Case Else
                            greem_o_type_name = "기타 타입"
                    End Select

                    ' ▼ greem_fix_type 변환
                    Select Case greem_fix_type
                        Case "0" 
                            greem_fix_type_name = "픽스없음"
                        Case "1"
                            greem_fix_type_name = "좌픽스"
                        Case "2"
                            greem_fix_type_name = "우픽스"
                        Case "3"
                            greem_fix_type_name = "좌+우 픽스"
                        Case "4"
                            greem_fix_type_name = "좌+좌 픽스"
                        Case "5"
                            greem_fix_type_name = "우+우 픽스"
                        Case "6"
                            greem_fix_type_name = "좌1+우2 픽스"
                        Case "7"
                            greem_fix_type_name = "좌2+우1 픽스"
                        Case "8"
                            greem_fix_type_name = "좌2+우2 픽스"
                        Case "9"
                            greem_fix_type_name = "편개"
                        Case "10"
                            greem_fix_type_name = "양개"
                        Case "11"
                            greem_fix_type_name = "고정창"
                        Case "12"
                            greem_fix_type_name = "편개_상부남마"
                        Case "13"
                            greem_fix_type_name = "양개_상부남마"
                        Case "14"
                            greem_fix_type_name = "고정창_상부남마"
                        Case "15"
                            greem_fix_type_name = "편개_상부남마_중"
                        Case Else
                            greem_fix_type_name = "기타 타입"
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
                                    SQL="select fsidx, xi, yi, wi, hi from tk_frameSub Where fidx='"&fidx&"' "
                                    Rs1.open Sql,Dbcon
                                    If Not (Rs1.bof or Rs1.eof) Then 
                                    Do while not Rs1.EOF
                                        i=i+1
                                        fsidx=Rs1(0)
                                        xi=Rs1(1)
                                        yi=Rs1(2)
                                        wi=Rs1(3)
                                        hi=Rs1(4)
                                    %>
                                    <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="#f1bcbc" stroke="#333333" stroke-width="" onclick="del('<%=fsidx%>');"/>
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
                                                    <%=greem_basic_type_name%>_<%=greem_o_type_name%>_<%=greem_fix_type_name%>
                                                <% elseif greem_f_a=2 then %>
                                                    수동 <%=GREEM_FIX_TYPE_name%>
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
