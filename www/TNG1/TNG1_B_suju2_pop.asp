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
        SQL="select xsize, ysize ,WHICHI_AUTO, WHICHI_FIX "
        SQL=SQL&" From tk_barasiF  "
        SQL=SQL&" Where bfidx='"&rbfidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then 
        bxsize=Rs(0)
        bysize=Rs(1)
        bWHICHI_AUTO=Rs(2)
        bWHICHI_FIX=Rs(3)
        End If
        Rs.close

    SQL=" Update tk_framekSub set bfidx='"&rbfidx&"' , xsize='"&bxsize&"', ysize='"&bysize&"' "
    SQL=SQL&" , WHICHI_AUTO='"&bWHICHI_AUTO&"', WHICHI_FIX='"&bWHICHI_FIX&"'"
    SQL=SQL&" where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    
    
response.write "<script>"
response.write "if (window.opener) {"
response.write "    window.opener.location.href = 'TNG1_B_suju2.asp?cidx=" & rcidx & _
    "&sjidx=" & rsjidx & _
    "&sjsidx=" & rsjsidx & _
    "&fkidx=" & fkidx & _
    "&sjb_idx=" & rsjb_idx & _
    "&sjb_type_no=" & rsjb_type_no & _
    "&fksidx=" & fksidx & _
    "&jaebun=" & rjaebun & _
    "&boyang=" & rboyang & "';"
response.write "}"
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
response.write "if (window.opener) {"
response.write "    window.opener.location.href = 'TNG1_B_suju2.asp?cidx=" & rcidx & _
    "&sjidx=" & rsjidx & _
    "&sjsidx=" & rsjsidx & _
    "&fkidx=" & fkidx & _
    "&sjb_idx=" & rsjb_idx & _
    "&sjb_type_no=" & rsjb_type_no & _
    "&fksidx=" & fksidx & _
    "&jaebun=" & rjaebun & _
    "&boyang=" & rboyang & "';"
response.write "}"
response.write "window.close();"
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
    swal.fire({
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
            location.href = "TNG1_B_suju2_pop.asp?part=chgbarasif_all&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&bfidx="+bfidx;
        } else if (result.isDenied) {
            location.href="TNG1_B_suju2_pop.asp?part=chgbarasif&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&bfidx="+bfidx;

        } else {
            Swal.fire('취소되었습니다.', '', 'info');
        }
        });
    }
    <% else %>
    function chgbarasif(bfidx){
        if (confirm("바의 품목을 변경 하시겠습니까?"))
        {
            location.href="TNG1_B_suju2_pop.asp?part=chgbarasif&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=rsjb_idx%>&fkidx=<%=rfkidx%>&fksidx=<%=rfksidx%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&bfidx="+bfidx;
        }
    }
    <% end if %>

  </script>
</head>
<body class="bg-light">

  <!-- 세 번째 줄 (200px 고정) -->
    <div class="third-row">
        <div class="third-inner">
            <div class="fixed-width">
                <!-- 세 번째 줄 첫 번째 칸 (300px) -->
                <div class="card card-custom">
                    <div class="card-header"><%=aset_name_AUTO%><%=aset_name_Fix%></div>
                    <div class="card-body">
                    <% if abfimg3<>"" then %>
                        <img src="/img/frame/bfimg/<%=abfimg3%>" loading="lazy" width="180" height="100"  border="0">
                    <% elseif abfimg1<>"" then %>
                        <img src="/img/frame/bfimg/<%=abfimg1%>" loading="lazy" width="180" height="100"  border="0">
                    <% elseif abfimg2<>"" then %>
                        <img src="/img/frame/bfimg/<%=abfimg2%>" loading="lazy" width="180" height="100"  border="0">
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
                SQL = SQL & " AND whichi_auto = '" & aWHICHI_AUTO & "' or  whichi_auto = 10 "
                End if
                If aWHICHI_FIX <> "0" Then 
                SQL = SQL & " AND whichi_fix = '" & aWHICHI_FIX & "' "
                End If
                'Response.write (SQL)&"<br>"
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
                bfidx=Rs(0)
                set_name_Fix=Rs(1)
                set_name_AUTO=Rs(2)
                whichi_auto=Rs(3)
                whichi_fix=Rs(4)
                xsize=Rs(5)
                ysize=Rs(6)
                bfimg1=Rs(7)
                bfimg2=Rs(8)
                bfimg3=Rs(9)
                tng_busok_idx=Rs(10)
                tng_busok_idx2=Rs(11)
                %>
            <div class="card card-custom">
                <div class="card-header"><%=set_name_AUTO%><%=set_name_Fix%></div>
                <div class="card-body">
                    <% if bfimg3<>"" then %>
                    <a onclick="chgbarasif('<%=bfidx%>');"><img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="180" height="100"  border="0"></a>
                    <% elseif bfimg1<>"" then %>
                    <img src="/img/frame/bfimg/<%=bfimg1%>" loading="lazy" width="180" height="100"  border="0">
                    <% elseif bfimg2<>"" then %>
                    <img src="/img/frame/bfimg/<%=bfimg2%>" loading="lazy" width="180" height="100"  border="0">
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
