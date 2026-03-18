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

' cdlevel 가져오기 (도어 할인 계산용)
cdlevel = 1 ' 기본값
If rsjidx <> "" Then
    SQL = "SELECT b.cdlevel FROM TNG_SJA a JOIN tk_customer b ON b.cidx = a.sjcidx WHERE a.sjidx = '" & rsjidx & "'"
    Set Rs1 = Server.CreateObject("ADODB.Recordset")
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
        cdlevel = Rs1(0)
    End If
    Rs1.Close
    Set Rs1 = Nothing
End If

Function CleanPercent(v)
    If IsNull(v) Then
        CleanPercent = ""
        Exit Function
    End If

    v = Trim(v & "")
    v = Replace(v, "%", "")
    v = Replace(v, ",", "")
    
    CleanPercent = v
End Function

Function CleanMoneyToInt(v)
    If IsNull(v) Then
        CleanMoneyToInt = 0
        Exit Function
    End If

    v = Trim(v & "")
    If v = "" Then
        CleanMoneyToInt = 0
        Exit Function
    End If

    ' 괄호형 음수 → - 로 변환
    If Left(v, 1) = "(" And Right(v, 1) = ")" Then
        v = "-" & Mid(v, 2, Len(v) - 2)
    End If

    ' 콤마 제거
    v = Replace(v, ",", "")

    ' % 제거 (혹시 섞여 들어올 경우 대비)
    v = Replace(v, "%", "")

    If IsNumeric(v) Then
        CleanMoneyToInt = CLng(v)   ' 또는 CDbl
    Else
        CleanMoneyToInt = 0
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
<form id="dataForm" name="dataForm" action="TNG1_B_table_pop_door.asp" method="POST">   
    <input type="hidden" name="mode"    value="update">
    <input type="hidden" name="sjcidx"    value="<%=rsjcidx%>">
    <input type="hidden" name="sjmidx"    value="<%=rsjmidx%>">
    <input type="hidden" name="sjidx"    value="<%=rsjidx%>">
    <input type="hidden" name="sjsidx"    value="<%=rsjsidx%>">
    <input type="hidden" name="fkidx"    value="<%=rfkidx%>">
    <input type="hidden" name="dis_calc_type" id="dis_calc_type" value="">
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
                        k = 0
                        Dim arrDisrate, hasDisrate, arrDisprice, hasDiprice
                       
                        
                        If Trim(Request("disrate")) <> "" Then
                            ' "10,0" → Array("10","0")
                            arrDisrate = Split(Trim(Request("disrate")), ",")
                            hasDisrate = True
                        End If
                        
                        If Trim(Request("disprice")) <> "" Then
                            ' "10,0" → Array("10","0")
                            arrDisprice = Split(Trim(Request("disprice")), ",")
                            hasDisprice = True
                        End If

                        rdisrate_sign = Request("disrate_sign")

                        SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
                        SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
                        SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
                        SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A "
                        SQL = SQL & " ,a.doorsizechuga_price,a.door_price ,a.goname,a.barNAME ,a.doortype , b.doorchoice "
                        SQL = SQL & " ,b.quan, a.fksidx, a.door_disrate, a.door_disprice "
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
                            kfksidx               = rs2(26)
                            kdoor_disrate          = rs2(27)
                            kdoor_disprice         = rs2(28)


                            ' 🔒 DB 값 안전 정규화 (VBScript용)
                            If IsNull(kdoor_disrate) Or Trim(kdoor_disrate & "") = "" Then
                                kdoor_disrate = 0
                            Else
                                kdoor_disrate = Replace(Trim(kdoor_disrate & ""), ",", ".")
                                If IsNumeric(kdoor_disrate) Then
                                    kdoor_disrate = CDbl(kdoor_disrate)
                                Else
                                    kdoor_disrate = 0
                                End If
                            End If

                            If IsNull(kdoor_disprice) Or Trim(kdoor_disprice & "") = "" Then
                                kdoor_disprice = 0
                            Else
                                kdoor_disprice = Replace(Trim(kdoor_disprice & ""), ",", "")
                                If IsNumeric(kdoor_disprice) Then
                                    kdoor_disprice = CDbl(kdoor_disprice)
                                Else
                                    kdoor_disprice = 0
                                End If
                            End If
                                                                                    

                            ' 도어 할인율과 할인금액 계산 (cdlevel 기반, door_price 기준)
                            ' 디버깅용 (필요시 주석 해제)
                            'Response.Write "cdlevel: " & cdlevel & "<br>"
                            'Response.Write "kDOOR_PRICE: " & kDOOR_PRICE & "<br>"
                            'Response.Write "quan: " & quan & "<br>"
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
                            
                            ' ==============================
                            ' 기준단가 계산
                            ' ==============================
                            total_standprice = 0
                            If IsNumeric(kDOOR_PRICE) Then
                                total_standprice = CDbl(kDOOR_PRICE) - CDbl(cdlevel_price)
                            End If

                            ' ==============================
                            ' 사용자 입력값 (k번째)
                            ' ==============================
                            curDisrate  = 0
                            curDisprice = 0

                            If hasDisrate Then
                                If k <= UBound(arrDisrate) Then
                                    If Trim(arrDisrate(k)) <> "" Then
                                        curDisrate = CDbl(arrDisrate(k))
                                        hasDisrate = True

                                    End If
                                End If
                            End If

                            If hasDisprice Then
                                If k <= UBound(arrDisprice) Then
                                    If Trim(arrDisprice(k)) <> "" Then
                                        curDisprice = CDbl(arrDisprice(k))
                                        hasDisprice = True
                                    End If
                                End If
                            End If

                            ' ==============================
                            ' 부호 처리
                            ' ==============================
                            signMul = 1
                            If Request("dis_sign_" & k) = "-" Then signMul = -1

                            calcType = Request("dis_calc_type")
                            

                            ' ==============================
                            ' 할인 계산 (단건 로직과 동일)
                            ' ==============================
                            If total_standprice > 0 Then
                           
                                ' 1️⃣ 할인율 입력 → 할인금액 계산
                                If calcType = "rate"  Then
                                
                                    kDOOR_DISRATE  = curDisrate * signMul
                                    one_disprice   = Round(total_standprice * curDisrate / 100, 0)
                                    kDOOR_DISPRICE = one_disprice * signMul
                                    
                                    
                                ' 2️⃣ 할인금액 입력 → 할인율 계산
                                ElseIf calcType = "price" Then
                                
                                    kDOOR_DISPRICE = curDisprice * signMul
                                    kDOOR_DISRATE  = Round((curDisprice / total_standprice) * 100, 1) * signMul

                                ' 3️⃣ 입력 없음 → DB 값 유지
                                Else
                                    kDOOR_DISRATE  = kdoor_disrate
                                    kDOOR_DISPRICE = kdoor_disprice
                                End If

                            Else
                                kDOOR_DISRATE  = 0
                                kDOOR_DISPRICE = 0
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

                            ' ==============================
                            ' 도어 타입 텍스트
                            ' ==============================
                            Select Case kDOORTYPE
                                Case 0: kdoortype_text = "없음"
                                Case 1: kdoortype_text = "좌도어"
                                Case 2: kdoortype_text = "우도어"
                            End Select

                            Select Case kDOORCHOICE
                                Case 1: kDOORCHOICE_text = "도어 포함가"
                                Case 2: kDOORCHOICE_text = "도어 별도가"
                                Case 3: kDOORCHOICE_text = "도어 제외가"
                                Case Else: kDOORCHOICE_text = "선택되지 않음"
                            End Select
                            
                            If IsNumeric(kDOOR_DISRATE) Then
                                rateVal = CDbl(kDOOR_DISRATE)
                            End If

                            If IsNumeric(kDOOR_DISPRICE) Then
                                priceVal = CDbl(kDOOR_DISPRICE)
                            End If

                            ' ==============================
                            ' 출력용 (부호 제거)
                            ' ==============================
                            dispRate  = Abs(kDOOR_DISRATE)
                            dispPrice = Abs(kDOOR_DISPRICE)


                           

                            
                            
                            
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
                                    <%
                                    If kDOOR_DISRATE = "0" Then
                                        kDOOR_DISRATE = "0"
                                    End If
                                    ' 출력용
                                    
                                    %>
                                    <input class="input-field" type="text" name="disrate" id="disrate_<%=k%>"
                                    value="<%=dispRate%>"
                                    style="width:60px"
                                     onfocus="setCalcType('rate')"/>%
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="window.open(
                                                'TNG1_B_table_pop_door.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>',
                                                'TNG1_B_table_pop_door',
                                                'top=100,left=100,width=700,height=200'
                                            );"
                                            style="margin-left: 5px;">
                                       상세
                                    </button>
                                 
                                </td>    
                                <!-- 할인금액 -->                       
                                <td class="text-end">
                                    <%
                                    If kDOOR_DISPRICE = "0" Then
                                        kDOOR_DISPRICE = "0"
                                    End If
                                    
                                    %>
                                    
                                    <input class="input-field" type="text" name="disprice" id="disprice_<%=k%>"
                                    value="<%=dispPrice%>"
                                    style="width:100px"
                                    onfocus="setCalcType('price')"/>원 
                                    <select name="dis_sign_<%=k%>">
                                        <option value="+"
                                            <% If kdoor_disprice >= 0 Then Response.Write "selected" %>>
                                            할인
                                        </option>
                                        <option value="-"
                                            <% If kdoor_disprice < 0 Then Response.Write "selected" %>>
                                            할증
                                        </option>
                                    </select>
                                    <button type="button"
                                            class="btn btn-sm btn-outline-primary"
                                            onclick="window.open(
                                                'TNG1_B_table_pop_door.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>',
                                                'TNG1_B_table_pop_door',
                                                'top=100,left=100,width=700,height=200'
                                            );"
                                            st
                                            yle="margin-left: 5px;">
                                        상세
                                    </button>
                                </td> 
                                <td class="text-end" ><%=FormatNumber(kdoor_price, 0, -1, -1, -1) & " 원"%></td>
                                <td class="text-end" ><%=FormatNumber(total_kDOOR_PRICE, 0, -1, -1, -1) & " 원"%></td>
                            </tr>
                            </tbody>
                            
                    <%
                    if mode = "update" then
                        
                        If kDOOR_DISRATE <> "" Or kDOOR_DISPRICE <> "" Then
                            SQL_UPD = ""
                            SQL_UPD = SQL_UPD & "UPDATE tk_framekSub SET "
                            SQL_UPD = SQL_UPD & " door_disrate = " & kDOOR_DISRATE & ", "
                            SQL_UPD = SQL_UPD & " door_disprice = " & kDOOR_DISPRICE & " "
                            SQL_UPD = SQL_UPD & " WHERE fksidx = " & kFKSIDX

                            'response.Write "SQL_UPD: " & SQL_UPD & "<br>    "
                            Dbcon.Execute SQL_UPD
                        End If
                    end if
                    k = k+1
                    Rs2.MoveNext
                    Loop
                    End if
                    Rs2.close
                    %>
                    </table>
    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
    <button type="button" class="btn btn-sm btn-outline-primary"
        onclick="if (window.opener && !window.opener.closed) { window.opener.location.reload(); } window.close();">
        닫기
    </button>
</form>  
<script>
function setCalcType(type) {
    document.getElementById("dis_calc_type").value = type;
}
</script>

<%
if mode = "update" then


response.write "<script>location.replace('TNG1_B_table_pop_door.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"');</script>"

end if

%>

<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
call dbClose()
%>




