  <!DOCTYPE html>
<html lang="en">
<head>
<%@codepage="65001" Language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->

<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")
Set Rs2 = Server.CreateObject("ADODB.Recordset")
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

sjcidx=request("cidx") '발주처idx
rsjcidx=Request("sjcidx")
rsjmidx=Request("sjmidx")
rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")

rfkidx=Request("fkidx")

mode=Request("mode")

'Response.Write "rsjcidx: " & rsjcidx & "<br>"
'Response.Write "rsjmidx: " & rsjmidx & "<br>"
'Response.Write "rsjidx: " & rsjidx & "<br>"
'Response.Write "rsjsidx: " & rsjsidx & "<br>"

'Response.Write "mode: " & mode & "<br>"
'response.end
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
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
    /* 왼쪽 여백 제거 */
    body, html {
        zoom: 1;
        margin: 0; /* 기본 여백 제거 */
        padding: 0;
    }
     /* 부모 컨테이너를 꽉 채우기 */
    .container-full {
        width: 100%;
        margin: 0;
        padding: 0;
    }

    /* 테이블을 화면 전체로 늘리기 */
    table.full-width-table {
        width: 100%;
        border-collapse: collapse;
    }

    /* 필요하면 테이블 안쪽 패딩도 제거 */
    table.full-width-table th, table.full-width-table td {
        padding: 8px; /* 여백 조절 가능 */
        text-align: center; /* 텍스트 중앙 정렬 등 */
    }
    /* 🔹 버튼 크기 조정 */
    .btn-small {
        font-size: 12px; /* 글씨 크기 */
        padding: 2px 4px; /* 버튼 내부 여백 */
        height: 22px; /* 버튼 높이를 자동으로 */
        line-height: 1; /* 버튼 텍스트 정렬 */
        border-radius: 3px; /* 모서리를 조금 둥글게 */
    }
    </style>
        <style>
        /* 스타일 정의 */
        .input-field {
            width: 100%; /* 너비를 100%로 설정 */
            //padding: 10px; /* 안쪽 여백 */
            //margin-bottom: 15px; /* 아래 여백 */
            border: none; /* 테두리 제거 */
            //border-bottom: 2px solid #ccc; /* 하단 경계선만 추가 */
            //font-size: 16px; /* 글꼴 크기 */
            outline: none; /* 포커스 시 아웃라인 제거 */
        }

        .input-field:focus {
         //   border-bottom: 2px solid #007bff; /* 포커스 시 하단 경계선 강조 */
        }
    </style>
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
    </script>
</head>
<body>
<form id="dataForm" name="dataForm" action="TNG1_B_table_pop.asp" method="POST">   
    <input type="hidden" name="mode"    value="update">
    <input type="hidden" name="sjcidx"    value="<%=rsjcidx%>">
    <input type="hidden" name="sjmidx"    value="<%=rsjmidx%>">
    <input type="hidden" name="sjidx"    value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx"    value="<%=rsjsidx%>">
    <input type="hidden" name="fkidx"    value="<%=rfkidx%>">
        <table class="table table-bordered table-sm align-middle" style="width:100%;">
            <thead>
                <tr>
                    <th class="text-center">순번</th> 
                    <th class="text-center">수량</th> 
                    <th class="text-center">할인율</th> <!-- disrate -->
                    <th class="text-center">개당/할인금액</th> <!-- disprice -->
                    <th class="text-center">기본단가</th> <!-- sjsprice -->
                    <th class="text-center">납품가</th>  <!-- fprice -->

                </tr>
            </thead>
            <tbody>
            <%
            sql = "SELECT distinct a.fknickname, a.fidx, a.sjb_idx, a.fname, a.fmidx "
            sql = sql & ", a.fwdate, a.fstatus, a.GREEM_F_A, a.GREEM_BASIC_TYPE, a.GREEM_FIX_TYPE, a.GREEM_HABAR_TYPE "
            sql = sql & ", a.GREEM_LB_TYPE, a.GREEM_O_TYPE, a.GREEM_FIX_name, a.fmeidx, a.fewdate, a.GREEM_MBAR_TYPE "
            sql = sql & ", a.sjidx, a.sjb_type_no, a.setstd, a.sjsidx, a.ow, a.oh "
            sql = sql & ", a.tw, a.th, a.bcnt, a.FL, a.qtyidx, a.pidx "
            sql = sql & ", a.ow_m, a.framek_price, a.sjsprice, a.disrate, a.disprice, a.fprice "
            sql = sql & ", a.quan, a.taxrate, a.sprice, a.py_chuga, a.robby_box, a.jaeryobunridae "
            sql = sql & ", a.boyangjea, a.dooryn, a.doorglass_t, a.fixglass_t, a.doorchoice, a.whaburail "
            sql = sql & ", a.jaeryobunridae_type, a.door_price "
            sql = sql & ", f.sjb_type_name , g.qtyname , h.pname "
            sql = sql & ", b.sjb_barlist , e.mname  "
            sql = sql & " FROM tk_framek a "
            sql = sql & " left outer Join tng_sjb B On A.sjb_idx=B.sjb_idx "
            sql = sql & " left outer Join tk_qty C On A.qtyidx=C.qtyidx "
            sql = sql & " Join tk_member D On A.fmidx=D.midx "
            sql = sql & " Join tk_member E On A.fmeidx=E.midx "
            sql = sql & " Left Outer JOin tng_sjbtype F On a.sjb_type_no=F.sjb_type_no "
            sql = sql & " Left Outer JOin tk_qtyco g On c.qtyno=g.qtyno "
            sql = sql & " Left Outer JOin tk_paint h On a.pidx=h.pidx "
            sql = sql & " WHERE fkidx = '" & rfkidx & "'"

            'Response.write (SQL)&"<br>"
            rs.Open sql, Dbcon
            If Not (rs.BOF Or rs.EOF) Then
            Do While Not rs.EOF

                fknickname             = rs(0)
                fidx                   = rs(1)
                sjb_idx                = rs(2)
                fname                  = rs(3)
                fmidx                  = rs(4)
                fwdate                 = rs(5)
                fstatus                = rs(6)
                GREEM_F_A              = rs(7)
                GREEM_BASIC_TYPE       = rs(8)
                GREEM_FIX_TYPE         = rs(9)
                GREEM_HABAR_TYPE       = rs(10)
                GREEM_LB_TYPE          = rs(11)
                GREEM_O_TYPE           = rs(12)
                GREEM_FIX_name         = rs(13)
                fmeidx                 = rs(14)
                fewdate                = rs(15)
                GREEM_MBAR_TYPE        = rs(16)
                sjidx                  = rs(17)
                sjb_type_no            = rs(18)
                setstd                 = rs(19)
                sjsidx                 = rs(20)
                ow                     = rs(21)
                oh                     = rs(22)
                tw                     = rs(23)
                th                     = rs(24)
                bcnt                   = rs(25)
                FL                     = rs(26)
                qtyidx                 = rs(27)
                pidx                   = rs(28)
                ow_m                   = rs(29)
                framek_price           = rs(30) '프레임가격? 사용안함?
                sjsprice               = rs(31) '기본단가
                disrate                = rs(32) '할인율
                disprice               = rs(33) '할인금액
                fprice                 = rs(34) '납품가
                quan                   = rs(35) '수량
                taxrate                = rs(36) '세액
                sprice                 = rs(37) '최종가격
                py_chuga               = rs(38)
                robby_box              = rs(39)
                jaeryobunridae         = rs(40)
                boyangjea              = rs(41)
                dooryn                 = rs(42)
                doorglass_t            = rs(43)
                fixglass_t             = rs(44)
                doorchoice             = rs(45)
                whaburail              = rs(46)
                jaeryobunridae_type    = rs(47)
                door_price             = rs(48)
                sjb_type_name          = rs(49)
                qtyname                = rs(50)
                pname                  = rs(51)
                sjb_barlist            = rs(52)
                mname                  = rs(53)

                If CLng(quan) <> 0 Then
                  'disprice 비교
                  original_disprice = int(sjsprice / 10)
                  
                  if not ( CDbl(disprice)  = CDbl(original_disprice ))  Then
                    disprice_update = CDbl(disprice) / CDbl(quan)
                  Else 
                    disprice_update = CDbl(disprice) 
                  End if
                Else
                    disprice_update = 0
                End If

                i=i+1
            %>                                                                                                                                                        
            <tr>                                                                                                                   
                <td class="text-center"><%=i%></td>
                <td class="text-center">
                    <input  class="input-field" type="text" name="quan" value="<%=quan%>" readonly style="width:50px;text-align:right">ea
                </td> <!-- 수량 -->
                <td class="text-center">
                    <input class="input-field" type="text" name="disrate" id="disrate"
                        value="<%=FormatNumber(disrate,0)%>"
                        style="width:60px"
                        onkeypress="handleKeyPress(event,'disrate','disrate')" />%
                </td> <!-- 할인율 -->
                <td class="text-center">
                    <input class="input-field" type="text" name="disprice_update" id="disprice_update"
                        value="<%=FormatNumber(disprice_update,0)%>"
                        style="width:100px"
                        onkeypress="handleKeyPress(event,'disprice_update','disprice_update')" />원
                </td> <!-- 할인금액 -->
                <td class="text-center">
                    <input class="input-field" type="text" name="sjsprice" id="sjsprice"
                        value="<%=FormatNumber(sjsprice,0)%>"
                        style="width:100px"
                        readonly />
                원
                </td>  <!-- 기본단가 -->
                <td class="text-center">
                    <input class="input-field" type="text" name="fprice" id="fprice"
                        value="<%=FormatNumber(fprice,0)%>"
                        style="width:100px"
                        readonly />
                원
                </td> <!-- 납품가 -->
            </tr>
            <%

            Rs.movenext
            Loop
            End If
            Rs.Close
            %>
                
        </tbody>
    </table>  
    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
    <button type="button"
        class="btn btn-outline-danger"
        style="writing-mode: horizontal-tb; letter-spa
        g: normal; white-space: nowrap;"
        onclick="location.replace('TNG1_B_suju_finish_cal.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>');">완료
    </button>

    <!--
    <button type="button" class="btn btn-sm btn-outline-primary"
        onclick="if (window.opener && !window.opener.closed) { window.opener.location.reload(); } window.close();">
        닫기
    </button>
    -->
</form>  
<%
if mode = "update" then

qfkidx    = Request("fkidx")

    sql = "SELECT sjsprice,disrate,disprice,fprice,quan"
    sql = sql & " FROM tk_framek "
    sql = sql & " WHERE fkidx = '" & qfkidx & "'"
    'Response.write (SQL)&"<br>"
    rs.Open sql, Dbcon
    If Not (rs.BOF Or rs.EOF) Then

        asjsprice               = rs(0) '기본단가
        adisrate                = rs(1) '할인율
        adisprice               = rs(2) '할인금액
        afprice                 = rs(3) '납품가
        aquan                   = rs(4) '수량

        adisprice_update = adisprice/aquan

    End If
    Rs.Close

qdisrate  = Replace(Request("disrate"), ",", "") ' 할인율
qdisprice_update = Replace(Request("disprice_update"), ",", "")  ' 할인금액
qsjsprice = Replace(Request("sjsprice"), ",", "")  ' 기본단가(할인전 개당금액)
qfprice = Replace(Request("fprice"), ",", "")  ' 최종단가(할인반영금액)*틀
qquan = Request("quan")

'Response.Write "qdisprice_update: " & qdisprice_update & "<br>"
'Response.Write "adisprice_update: " & adisprice_update & "<br>"
'Response.Write "qdisrate: " & qdisrate & "<br>"
'Response.Write "adisrate: " & adisrate & "<br>"
'response.end
        ' 할인율 업데이트
    if (CStr(qdisrate) <> CStr(adisrate)) and (CStr(qdisprice_update) = CStr(adisprice_update)) then

        
        disprice_a = Round(qsjsprice * qdisrate / 100, 0)
        'disprice_a= -Int(-(qsjsprice * qdisrate / 100) / 1000) * 1000 ' 천 단위 올림
        'disprice_a =  Int( (qsjsprice * qdisrate / 100) / 1000) * 1000 ' 천 단위 내림
        disprice_final=disprice_a * quan '수량에 따른 최종 할인금액
        finalTotal = (qsjsprice - disprice_a) * quan '전체금액
    
    'Response.Write "adisrate: " & adisrate & "<br>"
    'Response.Write "qdisrate: " & qdisrate & "<br>"
    'Response.Write "disprice_a: " & disprice_a & "<br>"
    'Response.Write "disprice_final: " & disprice_final & "<br>"
    'Response.Write "finalTotal: " & finalTotal & "<br>"

    else
        '  할인금액 업데이트

        '할인율(%) = (1개당 할인금액 / 1개 단가) * 100
        qdisrate = Round((qdisprice_update / qsjsprice) * 100, 1) ' 소숫점 2째에서 반올림
        disprice_final=qdisprice_update * quan '수량에 따른 최종 할인금액
        finalTotal = (qsjsprice - qdisprice_update) * quan '전체금액

    'Response.Write "qdisrate: " & qdisrate & "<br>"
    'Response.Write "disprice_final: " & disprice_final & "<br>"
    'Response.Write "finalTotal: " & finalTotal & "<br>"

    end if

    SQL="Update tk_framek set disrate='"&qdisrate&"',disprice='"&disprice_final&"',fprice='"&finalTotal&"' "
    SQL=SQL&" Where fkidx='"&qfkidx&"' "
    'Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)


    '=================sjasub 업데이트 시작
    'SQL = "UPDATE tng_sjaSub SET "
    'SQL = SQL & " sjsprice = '" & sjsprice_update & "' , disprice = '" & total_disprice & "' , fprice = '" & fprice_update & "' "
    'SQL = SQL & " , taxrate = '" & total_taxrate & "' , sprice = '" & total_sprice & "', py_chuga = '" & total_py_chuga & "' "
    'SQL = SQL & " , robby_box = '" & total_robby_box & "' , jaeryobunridae = '" & total_jaeryobunridae & "', boyangjea = '" & total_boyangjea & "' "
    'SQL = SQL & " , whaburail = '" & total_whaburail & "' , door_price = '" & total_door_price & "' ,quan='"&quan&"' "
    'SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "' "
    'Response.write (SQL)&"<br>"
    'response.end
    'Dbcon.Execute (SQL)
    '=================sjasub 업데이트 끝

response.write "<script>location.replace('TNG1_B_table_pop.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&qfkidx&"');</script>"

end if



%>

<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
call dbClose()
%>




