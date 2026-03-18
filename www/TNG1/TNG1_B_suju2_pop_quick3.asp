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
mode=Request("mode")

whichi_val = Request("whichi_val")


rjaebun=Request("jaebun") ' 1 재분 2재분보강 0삭제
rboyang=Request("boyang") '보양
if rjaebun = "" then rjaebun = 0 end if 
if rboyang = "" then rboyang = 0 end if 
'Response.Write "rjaebun : " & rjaebun & "<br>"   
'Response.Write "rboyang : " & rboyang & "<br>"   
rdoorchangehigh=Request("doorchangehigh") 
'Response.Write "mode : " & mode & "<br>"   
'Response.Write "mode1 : " & mode1 & "<br>"   
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

%>
<%

if rfksidx<>"" then

    'Response.Write "rfkidx : " & rfkidx & "<br>"
        SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
        SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO, B.bfimg1, B.bfimg2, B.bfimg3, B.tng_busok_idx, B.tng_busok_idx2  "
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


'품목변경 시작
'=======================================
if Request("part")="chgbarasif" then '선택된 자재만 바꿈

    rbfidx=Request("bfidx")  ' '"&xsize&"', '"&ysize&"',
        SQL="select a.xsize, a.ysize ,a.WHICHI_AUTO, a.WHICHI_FIX "
        SQL = SQL & ", b.glassselect , c.glassselect "
        SQL = SQL & ", c.WHICHI_FIXname, b.WHICHI_AUTOname "
        SQL=SQL&" From tk_barasiF a  "
        SQL = SQL & " LEFT OUTER JOIN tng_whichitype b ON a.WHICHI_AUTO = b.WHICHI_AUTO  "
        SQL = SQL & " LEFT OUTER JOIN tng_whichitype c ON a.WHICHI_FIX = c.WHICHI_FIX  "
        SQL=SQL&" Where a.bfidx='"&rbfidx&"' "
        Response.write (SQL)&"<br>"
        'response.end
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        bxsize=Rs(0)
        bysize=Rs(1)
        bWHICHI_AUTO=Rs(2)
        bWHICHI_FIX=Rs(3)
        bglassselect_auto = Rs(4)
        bglassselect_fix  = Rs(5)
        bWHICHI_FIXname   = Rs(6)
        bWHICHI_AUTOname  = Rs(7)
        'bsunstatus_auto   = Rs(8)
        'bsunstatus_fix    = Rs(9)
        End If
        Rs.close

        If bWHICHI_AUTO > 0  Then

            gls = bglassselect_auto

            Select Case bWHICHI_AUTO
                Case 4,5,6,7,10,25
                    garo_sero = 1   ' 세로 
                Case 1,2,3,8,9,20,21,23
                    garo_sero = 0   ' 가로
                Case else
                    garo_sero = 1      
            End Select

            'sunstatus = bsunstatus_auto

        ElseIf  bWHICHI_FIX > 0 Then

            gls = bglassselect_fix

            Select Case bWHICHI_FIX
                Case 6,7,8,9,10,20
                    garo_sero = 1   ' 세로
                Case 1,2,3,4,5,21,22,24,25
                    garo_sero = 0   ' 가로
                Case else
                    garo_sero = 1 
            End Select

            'sunstatus = bsunstatus_fix

        End If
    
    SQL=" Update tk_framekSub set bfidx='"&rbfidx&"' , xsize='"&bxsize&"', ysize='"&bysize&"' , gls='"&gls&"' "
    SQL=SQL&" , garo_sero='"&garo_sero&"' "
    SQL=SQL&" where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    
'Response.Write "fkidx : " & rfkidx & "<br>"
'Response.Write "rsjb_type_no : " & rsjb_type_no & "<br>"
'response.end   
response.write "<script>"

' -----------------------------
' 팝업1 핸들
' window.opener는 팝업2를 연 팝업1(inspector_v4.asp)을 가리킵니다.
response.write "var popup1 = window.opener;"

' -----------------------------
' 메인 페이지 핸들
' 팝업1을 연 메인 페이지(tng1_b_suju_quick.asp)를 가리킵니다.
response.write "var main = (popup1 && popup1.opener) ? popup1.opener : null;"

' -----------------------------
' 메인 페이지 새로고침 / URL 이동
' 메인 페이지가 열려 있을 때만 이동
response.write "if (main && !main.closed) {"
response.write "    main.location.href = 'TNG1_B_suju_quick.asp?cidx=" & rcidx & _
               "&sjidx=" & rsjidx & _
               "&sjsidx=" & rsjsidx & _
               "&fkidx=" & rfkidx & _
               "&sjb_idx=" & rsjb_idx & _
               "&sjb_type_no=" & rsjb_type_no & _
               "&fksidx=" & rfksidx & _
               "&mode=auto_enter';" '자동 폼 코드로 검측 입력값이 suju_cal 폼에 반영됨
response.write "}"

' -----------------------------
' 팝업1 닫기
' inspector_v4.asp 팝업 창 닫기
response.write "if (popup1 && !popup1.closed) {"
response.write "    popup1.close();"
response.write "}"

' -----------------------------
' 현재 팝업2 닫기
' TNG1_B_suju2_pop_quick.asp 팝업 창 닫기
response.write "window.close();"

response.write "</script>"


end if

if Request("part")="chgbarasif_all" then '세로바 전체 자재 바꿈

    rbfidx=Request("bfidx")  

    sql="select b.fksidx from tk_framek a "
    sql=sql&" join tk_frameksub b on a.fkidx=b.fkidx "
    sql=sql&" where  a.fkidx='"&rfkidx&"' and b.whichi_fix = 6 "
    'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        if not (Rs1.EOF or Rs1.BOF ) then
        Do while not Rs1.EOF

            fksidx_all=Rs1(0)    

            SQL=" Update tk_framekSub set bfidx='"&rbfidx&"' where fksidx in ('"&fksidx_all&"') "
            'Response.write (SQL)&"<br>"
            'Response.end
            Dbcon.Execute (SQL)

        Rs1.movenext
        Loop
        end if
        Rs1.Close


response.write "<script>"

' 팝업1 핸들
response.write "var popup1 = window.opener;" & vbCrLf

' 메인 페이지 핸들
response.write "var main = (popup1 && popup1.opener) ? popup1.opener : null;" & vbCrLf

' 메인 페이지 새로고침 (파라미터 포함)
response.write "if (main && !main.closed) {" & vbCrLf
response.write "    main.location.href = 'TNG1_B_suju_quick.asp?cidx=" & rcidx & _
               "&sjidx=" & rsjidx & _
               "&sjsidx=" & rsjsidx & _
               "&fkidx=" & rfkidx & _
               "&sjb_idx=" & rsjb_idx & _
               "&sjb_type_no=" & rsjb_type_no & _
               "&fksidx=" & rfksidx & _
               "&mode=auto_enter';" & vbCrLf
response.write "}" & vbCrLf

' 팝업1 닫기
response.write "if (popup1 && !popup1.closed) {" & vbCrLf
response.write "    popup1.close();" & vbCrLf
response.write "}" & vbCrLf

' 현재 팝업2 닫기
response.write "window.close();" & vbCrLf

response.write "</script>"

end if

'=======================================
'품목변경 끝

%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><%=projectname%></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/tng1/TNG1_B_suju.css"  rel="stylesheet">
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
    <% 
        sql=" select sjb_fa from tng_sjb where sjb_idx='"&rsjb_idx&"' "
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            qsjb_fa=Rs1(0) '1 수동 2 자동
        End if
        Rs1.close

        if qsjb_fa = 1 then 
    %>
    function chgbarasif(bfidx) {
    Swal.fire({
        title: '전체 세로바를 변경하시겠습니까?',
        text: '확인을 누르면 모든 세로바 품목이 변경됩니다.',
        // icon: 'question',
        showDenyButton: true,
        showCancelButton: true,
        confirmButtonText: '전체 변경',
        denyButtonText: '선택만 변경',
        cancelButtonText: '취소'
        }).then((result) => {
        if (result.isConfirmed) {
            location.href = "TNG1_B_suju2_pop_quick.asp?part=chgbarasif_all&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&sjb_type_no=<%=rsjb_type_no%>&bfidx="+bfidx;
        } else if (result.isDenied) {
            location.href="TNG1_B_suju2_pop_quick.asp?part=chgbarasif&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&bfidx="+bfidx;

        } else {
            Swal.fire('취소되었습니다.', '', 'info');
        }
        });
    }
    <% else %>
    function chgbarasif(bfidx){
        if (confirm("바의 품목을 변경 하시겠습니까?"))
        {
            location.href="TNG1_B_suju2_pop_quick.asp?part=chgbarasif&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&sjb_type_no=<%=rsjb_type_no%>&bfidx="+bfidx;
        }
    }
    <% end if %>

    function changeMode(selectedMode) {
        const url = "TNG1_B_suju2_pop_quick.asp"
            + "?mode=" + selectedMode
            + "&sjidx=<%=rsjidx%>"
            + "&sjsidx=<%=rsjsidx%>"
            + "&sjb_idx=<%=rsjb_idx%>"
            + "&fkidx=<%=rfkidx%>"
            + "&sjb_type_no=<%=rsjb_type_no%>"
            + "&fksidx=<%=rfksidx%>";
        
        window.location.href = url;
        }
  </script>
    <script>
    function choose1(whichiVal) {
        const selectedMode = document.querySelector('input[name="modeSelect"]:checked').value;

        // 클릭 시 현재 모드와 whichi 값을 함께 전달
        location.href = "TNG1_B_suju2_pop_quick.asp?" +
            "mode=" + selectedMode +
            "&sjidx=<%=rsjidx%>" +
            "&sjsidx=<%=rsjsidx%>" +
            "&sjb_idx=<%=rsjb_idx%>" +
            "&fkidx=<%=rfkidx%>" +
            "&fksidx=<%=rfksidx%>" +
            "&whichi_val=" + whichiVal;
    }
    </script>
    
</head>
<body class="bg-light">
    <!-- 세 번째 줄 (200px 고정) -->
    <style>
        .image-preview-popup {
        display: none;
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 9999;
        background: rgba(0, 0, 0, 0.8);
        padding: 10px;
        border-radius: 8px;
        }
        .image-preview-popup img {
        max-width: 80vw;
        max-height: 80vh;
        border-radius: 5px;
        }
    </style>

<div class="third-row">
    <div class="third-inner">
        <div class="fixed-width">
            <!-- 세 번째 줄 첫 번째 칸 -->
            <div class="card card-custom">
                <div class="card-header"><%=aset_name_AUTO%><%=aset_name_Fix%></div>
                <div class="card-body">
                <% 
                dim imgMain
                if abfimg3<>"" then 
                    imgMain = "/img/frame/bfimg/" & abfimg3
                elseif abfimg1<>"" then 
                    imgMain = "/img/frame/bfimg/" & abfimg1
                elseif abfimg2<>"" then 
                    imgMain = "/img/frame/bfimg/" & abfimg2
                else
                    imgMain = ""
                end if

                if imgMain<>"" then
                %>
                    <img src="<%=imgMain%>" loading="lazy" width="180" height="100" border="0"
                        onmouseover="showPreview('<%=imgMain%>')" 
                        onmouseout="hidePreview()">
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
                SQL = SQL & " AND (whichi_auto = '" & aWHICHI_AUTO & "' or  whichi_auto = 10)"
                End if
                If aWHICHI_FIX <> "0" Then 
                if aWHICHI_FIX=6 then
                    SQL = SQL & " AND whichi_fix in (6,7,8,9,10)"
                else    
                    SQL = SQL & " AND whichi_fix = '" & aWHICHI_FIX & "' "
                end if
                End If
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                    bfidx=Rs(0)
                    set_name_Fix=Rs(1)
                    set_name_AUTO=Rs(2)
                    bfimg1=Rs(7)
                    bfimg2=Rs(8)
                    bfimg3=Rs(9)
                %>
                <div class="card card-custom">
                    <div class="card-header"><%=set_name_AUTO%><%=set_name_Fix%></div>
                    <div class="card-body">
                    <% 
                    dim imgSub
                    if bfimg3<>"" then 
                        imgSub="/img/frame/bfimg/" & bfimg3
                    elseif bfimg1<>"" then 
                        imgSub="/img/frame/bfimg/" & bfimg1
                    elseif bfimg2<>"" then 
                        imgSub="/img/frame/bfimg/" & bfimg2
                    else
                        imgSub=""
                    end if
                    if imgSub<>"" then
                    %>
                        <a onclick="chgbarasif('<%=bfidx%>');">
                        <img src="<%=imgSub%>" loading="lazy" width="180" height="100" border="0"
                            onmouseover="showPreview('<%=imgSub%>')" 
                            onmouseout="hidePreview()">
                        </a>
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
<div class="row">
    <div class="third-inner">
        <div class="fixed-width">
            <div class="input-group mb-3">
                <div style="padding:10px; text-align:center;">
                    <label style="margin-right:20px;">
                        <input type="radio" name="modeSelect" value="sudong" onclick="changeMode('sudong')" <% If mode="sudong" Then Response.Write("checked") %> />
                        수동 
                    </label>
                    <label>
                        <input type="radio" name="modeSelect" value="auto" onclick="changeMode('auto')" <% If mode="auto" Then Response.Write("checked") %> />
                        자동 
                    </label>
                </div>
                <table id="datatablesSimple"  class="table table-hover">
                    <thead>
                        <tr>
                            <% if mode="sudong" then %>
                            <th style="width:40px; text-align:center;">수동<br>번호</th>
                            <th style="width:120px; text-align:center;">수동위치명</th>
                            <% elseif mode="auto" then %>
                            <th style="width:40px; text-align:center;">자동<br>번호</th>
                            <th style="width:120px; text-align:center;">자동위치명</th>
                            <% end if %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                            sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus ,glassselect, unittype_bfwidx "
                            sql = sql & "FROM tng_whichitype "
                                if mode="sudong" then 
                                sql = sql & "WHERE WHICHI_FIX <> '' "
                                elseif mode="auto" then
                                sql = sql & "WHERE WHICHI_AUTO <> '' "
                                end if
                            sql = sql & "ORDER BY bfwidx ASC "
                            Rs.open Sql,Dbcon,1,1,1
                            'Response.write sql & "<br>"
                            'Response.End
                            if not (Rs.EOF or Rs.BOF ) then
                            Do while not Rs.EOF
                                bfwidx           = Rs(0)
                                WHICHI_FIX       = Rs(1)
                                WHICHI_FIXname   = Rs(2)
                                WHICHI_AUTO      = Rs(3)
                                WHICHI_AUTOname  = Rs(4)
                                bfwstatus        = Rs(5)
                                glassselect        = Rs(6)
                                unittype_bfwidx    = Rs(7)
                                select case bfwstatus
                                    case "0"
                                        bfwstatus_text="❌"
                                    case "1"
                                        bfwstatus_text="✅"
                                end select

                                select case glassselect
                                    case "0"
                                        glassselect_text="❌"
                                    case "1"
                                        glassselect_text="외도어"
                                    case "2"
                                        glassselect_text="양개도어"
                                    case "3"
                                        glassselect_text="하부픽스유리"     
                                    case "4"
                                        glassselect_text="상부남마픽스유리"    
                                    case "5"
                                        glassselect_text="박스라인하부픽스유리"  
                                    case "6"
                                        glassselect_text="박스라인상부픽스유리"  
                                end select
                                if mode="sudong" then 
                                    select case unittype_bfwidx
                                        case "0"
                                            unittype_bfwidx_text="❌"
                                        Case "1"
                                        unittype_bfwidx_text = "45바"
                                        Case "2"
                                            unittype_bfwidx_text = "60~100바"
                                        Case "3"
                                            unittype_bfwidx_text = "코너바"
                                        case else
                                            unittype_bfwidx_text="(없음)"
                                    end select    

                                elseif mode="auto" then
                                    select case unittype_bfwidx
                                        case "0"
                                            unittype_bfwidx_text="❌"
                                        Case "1"
                                        unittype_bfwidx_text = "기계박스"
                                        Case "2"
                                            unittype_bfwidx_text = "박스커버"
                                        Case "3"
                                            unittype_bfwidx_text = "가로남마"
                                        Case "4"
                                            unittype_bfwidx_text = "중간소대"
                                        Case "5"
                                            unittype_bfwidx_text = "자동&픽스바"
                                        Case "6"
                                            unittype_bfwidx_text = "픽스하바"
                                        Case "7"
                                            unittype_bfwidx_text = "픽스상바"
                                        Case "8"
                                            unittype_bfwidx_text = "코너바"
                                        Case "9"
                                            unittype_bfwidx_text = "하부레일"
                                        Case "10"
                                            unittype_bfwidx_text = "T형_자동홈바"
                                        Case "11"
                                            unittype_bfwidx_text = "오사이"
                                        Case "12"
                                            unittype_bfwidx_text = "자동홈마개"
                                        Case "13"
                                            unittype_bfwidx_text = "민자홈마개"
                                        Case "14"
                                            unittype_bfwidx_text = "이중_뚜껑마감"
                                        Case "15"
                                            unittype_bfwidx_text = "마구리"    
                                        case else
                                            unittype_bfwidx_text="(없음)"
                                    end select    
                                end if
                                i=i+1
                        %> 
                        <tr>
                        <% if mode="sudong" then %>
                            <td style='width:40px; text-align:center;'>
                                <input class="input-field" type="text" value="<%=WHICHI_FIX%>" onclick="choose1('<%=WHICHI_FIX%>')" style="width:100%; text-align:center;">
                            </td>
                            <td style="width:120px;">
                                <input class="input-field" type="text" value="<%=WHICHI_FIXname%>" onclick="choose1('<%=WHICHI_FIX%>')" style="width:100%;">
                            </td>
                        <% elseif mode="auto" then %>
                            <td style="width:40px; text-align:center;">
                                <input class="input-field" type="text" value="<%=WHICHI_AUTO%>" onclick="choose1('<%=WHICHI_AUTO%>')" style="width:100%; text-align:center;">
                            </td>
                            <td style="width:120px;">
                                <input class="input-field" type="text" value="<%=WHICHI_AUTOname%>" onclick="choose1('<%=WHICHI_AUTO%>')" style="width:100%;">
                            </td>
                        <% end if %>
                        </tr>
                        <%
                        Rs.movenext
                        Loop
                        End If 
                        Rs.Close 
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="flex-grow">
            <div class="scroll-container">
                    <style>
                    .scroll-container {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr); /* 🔹 가로 4개씩 */
                        gap: 10px; /* 카드 간격 */
                        padding: 10px;
                        overflow-y: auto;
                        max-height: 80vh; /* 필요 시 스크롤 제한 */
                    }

                    .card-custom {
                        border: 1px solid #ccc;
                        border-radius: 10px;
                        text-align: center;
                        background-color: #fff;
                        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                        transition: transform 0.2s;
                    }

                    .card-custom:hover {
                        transform: scale(1.03);
                        box-shadow: 0 3px 8px rgba(0,0,0,0.15);
                    }

                    .card-header {
                        font-weight: bold;
                        font-size: 13px;
                        padding: 5px;
                        background-color: #f8f9fa;
                        border-bottom: 1px solid #ddd;
                    }

                    .card-body img {
                        width: 100%;
                        height: 100px;
                        object-fit: cover;
                        border-radius: 6px;
                    }
                    </style>
                <%
                SQL=" Select bfidx, set_name_Fix, set_name_AUTO, whichi_auto, whichi_fix, xsize, ysize, bfimg1, bfimg2, bfimg3 "
                SQL=SQL&" , tng_busok_idx, tng_busok_idx2 "
                SQL=SQL&" From tk_barasiF "
                If mode = "sudong" Then
                    SQL = SQL & "WHERE WHICHI_FIX = '" & whichi_val & "'"
                ElseIf mode = "auto" Then
                    SQL = SQL & "WHERE WHICHI_AUTO = '" & whichi_val & "'"
                End If
                'SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' and bfidx<>'"&abfidx&"'"

                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                    bfidx=Rs(0)
                    set_name_Fix=Rs(1)
                    set_name_AUTO=Rs(2)
                    bfimg1=Rs(7)
                    bfimg2=Rs(8)
                    bfimg3=Rs(9)
                %>
                <div class="card card-custom">
                    <div class="card-header" 
                        style="cursor:pointer;"
                        onclick="chgbarasif('<%=bfidx%>');">
                        <%=set_name_AUTO%><%=set_name_Fix%>
                    </div>
                    <div class="card-body">
                    <% 
                    'dim imgSub
                    if bfimg3<>"" then 
                        imgSub="/img/frame/bfimg/" & bfimg3
                    elseif bfimg1<>"" then 
                        imgSub="/img/frame/bfimg/" & bfimg1
                    elseif bfimg2<>"" then 
                        imgSub="/img/frame/bfimg/" & bfimg2
                    else
                        imgSub=""
                    end if
                    if imgSub<>"" then
                    %>
                        <a onclick="chgbarasif('<%=bfidx%>');">
                        <img src="<%=imgSub%>" loading="lazy" width="180" height="100" border="0"
                            onmouseover="showPreview('<%=imgSub%>')" 
                            onmouseout="hidePreview()">
                        </a>
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

<!-- 공통 팝업 -->
<div id="imagePreviewPopup" class="image-preview-popup">
  <img id="previewImg" src="" alt="미리보기">
</div>

<script>
function showPreview(src) {
  const popup = document.getElementById('imagePreviewPopup');
  const img = document.getElementById('previewImg');
  img.src = src;
  popup.style.display = 'block';
}
function hidePreview() {
  document.getElementById('imagePreviewPopup').style.display = 'none';
}
</script>
<script>
let previewTimer;

function showPreview(src) {
  clearTimeout(previewTimer);
  previewTimer = setTimeout(() => {
    const popup = document.getElementById('imagePreviewPopup');
    const img = document.getElementById('previewImg');
    img.src = src;
    popup.style.display = 'block';
  }, 1000); // 150ms 지연 (깜빡임 방지)
}

function hidePreview() {
  clearTimeout(previewTimer);
  previewTimer = setTimeout(() => {
    document.getElementById('imagePreviewPopup').style.display = 'none';
  }, 1300); // 살짝 늦게 닫기
}
</script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
