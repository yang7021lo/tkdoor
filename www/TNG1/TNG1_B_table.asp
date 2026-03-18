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

' cdlevel 가져오기 (도어 할인 계산용) - 수주/견적 구분 없이 항상 적용
cdlevel = 1 ' 기본값
If rsjidx <> "" Then
    SQL = "SELECT b.cdlevel FROM TNG_SJA a JOIN tk_customer b ON b.cidx = a.sjcidx WHERE a.sjidx = '" & rsjidx & "'"
    Set Rs1 = Server.CreateObject("ADODB.Recordset")
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
        If Not IsNull(Rs1(0)) Then
            cdlevel = Rs1(0)
        End If
    End If
    Rs1.Close
    Set Rs1 = Nothing
End If

Function SafeDbl(v)
    Dim s
    If IsNull(v) Then
        SafeDbl = 0
        Exit Function
    End If

    s = Trim(CStr(v))

    If s = "" Then
        SafeDbl = 0
        Exit Function
    End If

    ' (12345) → -12345
    If Left(s,1) = "(" And Right(s,1) = ")" Then
        s = "-" & Mid(s, 2, Len(s)-2)
    End If

    ' 콤마, 퍼센트 제거
    s = Replace(s, ",", "")
    s = Replace(s, "%", "")

    If IsNumeric(s) Then
        SafeDbl = CDbl(s)
    Else
        SafeDbl = 0
    End If
End Function

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
<form id="dataForm" name="dataForm" action="TNG1_B_table.asp" method="POST">   
    <input type="hidden" name="mode"    value="update">
<table class="table table-bordered table-sm align-middle" style="width:100%;">
    <thead>
        <tr>
            <th class="text-center">순번</th>
            <th class="text-center">기본품목</th>
            <th class="text-center">수량</th>
            <th class="text-center">재질</th>
            <th class="text-center">도장</th>
            <th class="text-center">검측가로</th>
            <th class="text-center">검측세로</th>
            <th class="text-center">오픈</th>
            <th class="text-center">도어높이</th>
            <th class="text-center">묻힘</th>
            
            <th class="text-center">기본단가</th> <!-- sjsprice -->
            <th class="text-center">납품가</th>  <!-- fprice -->
            <th class="text-center">할인율</th> <!-- disrate -->
            <th class="text-center">할인금액</th> <!-- disprice -->
            <!-- <th class="text-center">세액</th> --><!-- taxrate -->
            <!-- <th class="text-center">최종가격</th> --><!-- sprice -->
            <th class="text-center">등록자</th>
            <th class="text-center">등록일</th>
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
    sql = sql & ", b.sjb_barlist , e.mname , a.fkidx "
    sql = sql & " FROM tk_framek a "
    sql = sql & " left outer Join tng_sjb B On A.sjb_idx=B.sjb_idx "
    sql = sql & " left outer Join tk_qty C On A.qtyidx=C.qtyidx "
    sql = sql & " Join tk_member D On A.fmidx=D.midx "
    sql = sql & " Join tk_member E On A.fmeidx=E.midx "
    sql = sql & " Left Outer JOin tng_sjbtype F On a.sjb_type_no=F.sjb_type_no "
    sql = sql & " Left Outer JOin tk_qtyco g On c.qtyno=g.qtyno "
    sql = sql & " Left Outer JOin tk_paint h On a.pidx=h.pidx "
    sql = sql & " WHERE sjsidx = '" & rsjsidx & "'"

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
        fkidx                  = rs(54)
        i=i+1
%>                                                                                                                                                        
                            <tr>                                                                                                                       
                                
                        
                                <td class="text-center"><%=i%></td>
                                <td class="text-center"><%=sjb_type_name &" "& sjb_barlist%></td>
                                <td class="text-end"><%=formatnumber(quan,0)%>EA</td> 
                                <td class="text-center"><%=qtyname%></td>
                                <td class="text-center"><%=pname%></td>
                                <td class="text-center"><%=formatnumber(tw,0)%>mm</td>
                                <td class="text-center"><%=formatnumber(th,0)%>mm</td>
                                <td class="text-center"><%=ow%>mm</td>
                                <td class="text-center"><%=oh%>mm</td>
                                <td class="text-center"><%=fl%>mm</td>
                                <td class="text-end"><%=formatnumber(sjsprice,0)%>원</td>  <!-- 기본단가 -->
                                <td class="text-end"><%=formatnumber(fprice,0)%>원</td> <!-- 납품가 -->
                                <!-- 할인율 -->
                                <td class="text-end">
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="window.open(
                                                'TNG1_B_table_pop.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>',
                                                'TNG1_B_table_pop',
                                                'top=100,left=100,width=700,height=200'
                                            );">
                                        <%=FormatNumber(disrate, 0)%>%
                                    </button>
                                </td>    
                                <!-- 할인금액 -->                       
                                <td class="text-end">
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="window.open(
                                                'TNG1_B_table_pop.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>',
                                                'TNG1_B_table_pop',
                                                'top=100,left=100,width=700,height=200'
                                            );">
                                        <%=FormatNumber(disprice, 0)%>원
                                    </button>
                                </td>         
                                <!-- <td class="text-end"><%=formatnumber(taxrate,0)%>원</td>  -->              <!-- 세액 -->
                                <!-- <td class="text-end"><%=formatnumber(sprice,0)%>원</td>   -->            <!-- 최종가격 -->
                                <td class="text-center"><%=mname%></td>
                                <td class="text-center"><%=left(fewdate,10)%></td>
                            </tr>
<%

Rs.movenext
Loop
End If
Rs.Close
%>
    
        </tbody>
</table>  

                        <table class="table table-bordered table-sm align-middle" style="width:100%;">
                                <td class="text-center" >순번</td>
                                <th class="text-center" >가격여부</th>
                                <th class="text-center" >품명</th>
                                <th class="text-center" >규격</th>
                                <th class="text-center" >수량</th>
                                <th class="text-center" >편개/양개</th>
                                <th class="text-center" >도어W</th>
                                <th class="text-center" >도어H</th>
                                <th class="text-center" >도어유리W</th>
                                <th class="text-center" >도어유리H</th>
                                <th class="text-center" >도어 사이즈 추가 가격</th>
                                <th class="text-center" >할인율</th>
                                <th class="text-center" >할인금액</th>
                                <th class="text-center" >도어 단가</th>
                                <th class="text-center" >도어 공급가</th>
<%
                        SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
                        SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
                        SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
                        SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A "
                        SQL = SQL & " ,a.doorsizechuga_price,a.door_price ,a.goname,a.barNAME ,a.doortype , b.doorchoice "
                        SQL = SQL & " ,b.quan,a.door_disrate, a.door_disprice "
                        SQL = SQL & " from tk_framekSub a"
                        SQL = SQL & " join tk_framek b on a.fkidx = b.fkidx "
                        SQL=SQL&" Where b.sjsidx = '"&rsjsidx&"' and DOOR_W >0 "
                        Rs2.open SQL, Dbcon
                        If Not (Rs2.bof or Rs2.eof) Then 
                        Do While Not Rs2.EOF
                        'response.write (Sql)&"<br>"
                            kWHICHI_AUTO          = rs2(0)
                            kWHICHI_FIX           = rs2(1)
                            kDOOR_W               = rs2(2)
                            kDOOR_H               = rs2(3)
                            kDOORGLASS_W          = rs2(4)
                            kDOORGLASS_H          = rs2(5)
                            kGLS                  = rs2(6)
                            kSJB_IDX              = rs2(7)
                            kSJB_TYPE_NO          = rs2(8)
                            kFKSIDX               = rs2(9)
                            kGREEM_O_TYPE         = rs2(10)
                            kGREEM_BASIC_TYPE     = rs2(11)
                            kGREEM_FIX_TYPE       = rs2(12)
                            kQTYIDX               = rs2(13)
                            kPIDX                 = rs2(14)
                            kDOORGLASS_T          = rs2(15)
                            kFIXGLASS_T           = rs2(16)
                            kDOORYN               = rs2(17)
                            kGREEM_F_A            = rs2(18)
                            kDOORSIZECHUGA_PRICE  = rs2(19)
                            kDOOR_PRICE           = rs2(20)
                            kGONAME               = rs2(21)
                            kBARNAME              = rs2(22)
                            kDOORTYPE             = rs2(23)
                            kDOORCHOICE           = rs2(24) '1도어 포함가 2도어 별도가 3도어 제외가
                            quan                  = rs2(25) '수량
                            kDOOR_DISRATE         = rs2(26)
                            kDOOR_DISPRICE        = rs2(27)

                                ' ===============================
                                ' 🔒 Type mismatch 방지 + 부호 판별
                                ' ===============================
                                rateVal  = SafeDbl(kDOOR_DISRATE)
                                priceVal = SafeDbl(kDOOR_DISPRICE)

                                If rateVal < 0 Or priceVal < 0 Then
                                    dispTypeText = "할증"
                                Else
                                    dispTypeText = "할인"
                                End If

                                dispRate  = Abs(rateVal)
                                dispPrice = Abs(priceVal)

                            ' 도어 할인율과 할인금액 계산 (cdlevel 기반, door_price 기준)
                            ' cdlevel_price 계산
                            Select Case cdlevel
                                Case 1
                                    cdlevel_price = 0
                                Case 2
                                    cdlevel_price = 10000
                                Case 3
                                    cdlevel_price = -10000
                                Case 4
                                    cdlevel_price = -20000
                                Case 5
                                    cdlevel_price = -30000
                                Case 6
                                    cdlevel_price = 10000
                                Case Else
                                    cdlevel_price = 0
                            End Select
                            
                            ' door_price를 기준으로 할인율 계산
                            ' door_price = total_standprice + cdlevel_price
                            ' total_standprice = door_price - cdlevel_price
                            ' 할인율 = (cdlevel_price / total_standprice) * 100
                                                    
                            total_standprice = 0
                            
                            ' ==============================
                            ' 리스트 표시용 계산 (cdlevel 유지)
                            ' ==============================
                            If IsNumeric(kDOOR_PRICE) And CDbl(kDOOR_PRICE) > 0 Then

                                ' 1️⃣ 기준단가 (cdlevel 반영 전 기준)
                                total_standprice = CDbl(kDOOR_PRICE) - CDbl(cdlevel_price)

                                ' 2️⃣ 할인값은 DB 저장값만 사용
                                If IsNumeric(kdoor_disprice) Then
                                    kDOOR_DISPRICE = CDbl(kdoor_disprice)
                                Else
                                    kDOOR_DISPRICE = 0
                                End If

                                If IsNumeric(kdoor_disrate) Then
                                    kDOOR_DISRATE = CDbl(kdoor_disrate)
                                Else
                                    kDOOR_DISRATE = 0
                                End If

                            Else
                                total_standprice = 0
                                kDOOR_DISPRICE = 0
                                kDOOR_DISRATE  = 0
                            End If
                            
                            ' ==============================
                            ' 공급가 계산
                            ' ==============================
                              
                            If IsNumeric(kDOOR_PRICE) Then
                                door_supply_price = CDbl(kDOOR_PRICE) - CDbl(kDOOR_DISPRICE)
                                total_kDOOR_PRICE = door_supply_price * quan
                            Else
                                total_kDOOR_PRICE = 0
                            End If
                            
                            select case kDOORTYPE
                                case 0 
                                    kdoortype_text = "없음"
                                case 1 
                                    kdoortype_text = "좌도어"
                                case 2  
                                    kdoortype_text = "우도어"
                            end select

                            Select Case kDOORCHOICE
                                Case 1
                                    kDOORCHOICE_text = "도어 포함가"
                                Case 2
                                    kDOORCHOICE_text = "도어 별도가"
                                Case 3
                                    kDOORCHOICE_text = "도어 제외가"
                                Case Else
                                    kDOORCHOICE_text = "선택되지 않음"
                            End Select

                            k=k+1
                            %>
                        
                            <tbody>
                            <tr>
                                <td class="text-center"><%=k%></td>
                                <th class="text-center"><%=kDOORCHOICE_text%></th>
                                <td class="text-center" ><%=kgoname%></td>
                                <td class="text-center" ><%=kbarNAME%></td>
                                <td class="text-end"><%=formatnumber(quan,0)%>EA</td> 
                                <td class="text-center" ><%=kDOORTYPE_text%></td>
                       
                                <td class="text-center" ><%=kdoor_w%></td>
                                <td class="text-center" ><%=kdoor_h%></td>
                           
                                <td class="text-center" ><%=kdoorglass_w%></td>
                                <td class="text-center" ><%=kdoorglass_h%></td>
                            
                                <td class="text-end" ><%=FormatNumber(kdoorsizechuga_price, 0, -1, -1, -1) & " 원"%></td>
                                <!-- 할인율 -->
                                <td class="text-end">
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="window.open(
                                                'TNG1_B_table_pop_door.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>',
                                                'TNG1_B_table_pop_door',
                                                'top=100,left=100,width=700,height=200'
                                            );">

                                            <%= FormatNumber(dispRate, 1, -1, 0, -1) %>%

                                    </button>
                                </td>    
                                <!-- 할인금액 -->                       
                                <td class="text-end">
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="window.open(
                                                'TNG1_B_table_pop_door.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>',
                                                'TNG1_B_table_pop_door',
                                                'top=100,left=100,width=700,height=200'
                                            );">
                                            <%=dispTypeText%><br>
                                        <%= FormatNumber(dispPrice, 0, -1, -1, -1) & " 원" %>
                                    </button>
                                </td> 
                                <td class="text-end" ><%=FormatNumber(kdoor_price, 0, -1, -1, -1) & " 원"%></td>
                                <td class="text-end" ><%=FormatNumber(total_kDOOR_PRICE, 0, -1, -1, -1) & " 원"%></td>
                            </tr>
                            </tbody>
                        
                    <%
                    Rs2.MoveNext
                    Loop
                    End if
                    Rs2.close
                    %>
                    </table>
                        <table class="table table-bordered table-sm align-middle" style="width:100%;">
                            <tbody >
                                <%
                                SQL="Select a.jaeryobunridae, a.robby_box,boyangjea, a.fkidx, a.whaburail, a.jaeryobunridae_type "
                                SQL=SQL&" , b.whichi_fix, b.whichi_auto ,b.bfidx ,b.busok,b.xsize,b.ysize,b.blength "
                                SQL=SQL&" , c.whichi_fixname, d.whichi_autoname "
                                SQL=SQL&" from tk_framek a "
                                SQL=SQL&" left outer join  tk_frameksub b on  a.fkidx=b.fkidx and ( b.whichi_auto in (23) or  b.whichi_fix in (25) ) "
                                SQL=SQL&" left outer join  tng_whichitype c on  c.whichi_fix=b.whichi_fix "
                                SQL=SQL&" left outer join  tng_whichitype d on  d.whichi_auto=b.whichi_auto "
                                SQL=SQL&" Where a.sjsidx='"&rsjsidx&"' "
                                'Response.write (SQL)&"<br>"
                                Rs.open Sql,Dbcon
                                If Not (Rs.bof or Rs.eof) Then 

                                o = 0 '--- 열 타이틀은 첫 번째 행에서만 출력

                                Do While Not Rs.EOF

                                o=o+1  

                                    jaeryobunridae=Rs(0)
                                    robby_box=Rs(1)
                                    boyangjea=Rs(2)
                                    ufkidx=Rs(3)
                                    whaburail=Rs(4)
                                    jaeryobunridae_type=Rs(5)
                                    whichi_fix=Rs(6)
                                    whichi_auto=Rs(7)
                                    bfidx=Rs(8)
                                    busok=Rs(9)
                                    xsize=Rs(10)
                                    ysize=Rs(11)
                                    blength=Rs(12)
                                    whichi_fixname=Rs(13)
                                    whichi_autoname=Rs(14)

                                    total_jaeryobunridae = jaeryobunridae * quan
                                    total_robby_box = robby_box * quan
                                    total_boyangjea = boyangjea * quan
                                    total_whaburail = whaburail * quan



                                    select case jaeryobunridae_type
                                        case 0 
                                            jaeryobunridae_text = "재분"
                                        case 1 
                                            jaeryobunridae_text = "재료분리대"
                                        case 2  
                                            jaeryobunridae_text = "재료분리대(갈바보강)"
                                    end select
                                
                                    ' 우선순위명
                                    if whichi_fix > 0 then
                                        whichi_text = whichi_fixname
                                    else
                                        whichi_text = whichi_autoname
                                    end if

                                    ' 수동로비폰 whichi_fix =25 자동로비폰 whichi_auto =23
                                    if whichi_auto = 23 then
                                        robby_box_text = "자동_로비폰박스"
                                    elseif whichi_fix = 25 then
                                        robby_box_text = "수동_로비폰박스"
                                    else
                                        robby_box_text = "로비폰박스"
                                    end if
                                %>      
                                <%  If o = 1 Then  %>
                                    <tr style="background-color:#f2f2f2; font-weight:bold;">

                                        <td class="text-center">순번</td>

                                        <td class="text-center"><%=jaeryobunridae_text%>_단가</td>
                                        <td class="text-center">수량</td>
                                        <td class="text-center">재분 공급가</td>
                                        
                                        <td class="text-center">로비폰박스_단가</td>
                                        <td class="text-center">수량</td>
                                        <td class="text-center">로비폰박스 공급가</td>
                                        
                                        <td class="text-center">보양재_단가</td>
                                        <td class="text-center">보양재세트수량</td>
                                        <td class="text-center">보양재 공급가</td>

                                        <td class="text-center">하부레일_단가</td>
                                        <td class="text-center">수량</td>
                                        <td class="text-center">하부레일 공급가</td>
                                    </tr>
                                <% End If %>
      
                                <tr>
                                    <td class="text-center"><%=o%></td>

                                    <% ' 재분리대 출력 %>
                                    <% If jaeryobunridae = 0 Then %>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                    <% Else %>
                                        <td class="text-end"><%=FormatNumber(jaeryobunridae, 0, -1, -1, -1)%>원</td>
                                        <td class="text-end"><%=formatnumber(quan,0)%>EA</td> 
                                        <td class="text-end"><%=FormatNumber(total_jaeryobunridae, 0, -1, -1, -1)%>원</td>
                                        
                                    <% End If %>

                                    <% ' 로비폰 출력 %>
                                    <% If robby_box = 0 Then %>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                    <% Else %>
                                        <td>
                                            <div style="display:flex; justify-content:space-between;">
                                                <div style="text-align:left;">
                                                <%= xsize & "×" & ysize & " " & robby_box_text %>
                                                </div>
                                                <div style="text-align:right;">
                                                <%= FormatNumber(robby_box, 0, -1, -1, -1) & "원" %>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-end"><%=formatnumber(quan,0)%>EA</td> 
                                        <td class="text-end"><%=FormatNumber(total_robby_box, 0, -1, -1, -1)%>원</td>
                                    <% End If %>

                                    <% ' 보양재 출력 %>
                                    <% If boyangjea = 0 Then %>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                    <% Else %>
                                        <td class="text-end"><%=FormatNumber(boyangjea, 0, -1, -1, -1)%>원</td>
                                        <td class="text-end"><%=formatnumber(quan,0)%>EA</td> 
                                        <td class="text-end"><%=FormatNumber(total_boyangjea, 0, -1, -1, -1)%>원</td>
                                    <% End If %>

                                    <% ' 하부레일 출력 %>
                                    <% If whaburail = 0 Then %>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                        <td class="text-end">-</td>
                                    <% Else %>
                                        <td class="text-end">하부레일</td>
                                        <td class="text-end"><%=formatnumber(quan,0)%>EA</td> 
                                        <td class="text-end"><%=FormatNumber(whaburail, 0, -1, -1, -1)%>원</td>
                                        
                                    <% End If %>
                                </tr>
                                </tbody>
                                <%
                                Rs.MoveNext
                                Loop
                                End if
                                Rs.close
                                %> 
                            
                        </table>
    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>  
<%

response.write "<script>location.replace('tng1_b.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"');</script>"

%>
<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
call dbClose()
%>




