<%@ codepage="65001" language="vbscript"%>
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

rsjidx=Request("sjidx")
    SQL = "SELECT a.sjcidx, b.cname,b.cgubun, b.cdlevel, b.cflevel "
    SQL = SQL & "FROM TNG_SJA a "
    SQL = SQL & "JOIN tk_customer b ON b.cidx = a.sjcidx "
    SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "'"
    'Response.Write SQL & "<br>" 
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
        sjcidx    = Rs1(0)
        cname     = Rs1(1)
        cgubun   = Rs1(2)
        cdlevel   = Rs1(3) ' 1=10만(기본), 2=-10000, 3= +10000, 4= +20000, 5= +30000 , 6= 9만에 1000*2400
        cflevel   = Rs1(4) ' 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=E
    End If
    Rs1.Close
rsjsidx=Request("sjsidx")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no") '제품타입
rqtyidx       = Request("qtyidx")
rpidx         = Request("pidx")
rjaebun       = Request("jaebun")
rboyang       = Request("boyang")
gubun=Request("gubun")
rSearchWord=Request("SearchWord")
mode=Request("mode")

'Response.Write "rsjb_type_no : " & rsjb_type_no & "<br>"
'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"
'Response.Write "rdoortype : " & rdoortype & "<br>"
'Response.Write "rnf : " & rnf & "<br>"
'Response.Write "rsidx : " & rsidx & "<br>"
'Response.Write "rjunggankey : " & rjunggankey & "<br>"
'Response.Write "rdademuhom : " & rdademuhom & "<br>"
'Response.Write "rtagong : " & rtagong & "<br>"
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
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
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">
        <div class="row">
            <div class="col-6">
                        <%
                            if mode="all" then
                        %>    
                    <div class="mb-2">
                        <table class="table table-bordered table-sm align-middle" style="width:100%;">

                            <!-- no:품명 (1:3) -->
                   

                            <!-- 2:2 -->
                            <tr>
                            <td class="text-center" style="width: 10%;">no</td>
                            <th class="text-center" colspan="3">품명</th>
                            <th class="text-center" colspan="2">규격</th>
                            <!--
                            <th class="text-center" colspan="2">편/양</th>
                            -->
                            <th class="text-center" colspan="2">도어W</th>
                            <th class="text-center" colspan="2">도어H</th>
                            <th class="text-center" colspan="2">도어유리W</th>
                            <th class="text-center" colspan="2">도어유리H</th>
                            <th class="text-center" colspan="2">수량</th>
                            </tr>
                        <%
                        SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
                        SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
                        SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
                        SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A "
                        SQL = SQL & " ,a.doorsizechuga_price,a.door_price ,a.goname,a.barNAME ,a.doortype , b.doorchoice ,b.quan "
                        SQL = SQL & " from tk_framekSub a"
                        SQL = SQL & " join tk_framek b on a.fkidx = b.fkidx "
                        SQL=SQL&" Where b.sjidx = '"&rsjidx&"' and DOOR_W >0 "
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
                            kQUAN                 = rs2(25)

                            select case kDOORTYPE
                                case 0 
                                    kdoortype_text = "없음"
                                case 1 
                                    kdoortype_text = "편개"
                                case 2  
                                    kdoortype_text = "편개"
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
                                    <td class="text-center" colspan="3"><%=kgoname%></td>
                                    <td class="text-center" colspan="2"><%=kbarNAME%></td>
                                    <!--
                                    <td class="text-center" colspan="2"><%=kDOORTYPE_text%></td>
                                    -->
                                    <td class="text-center" colspan="2"><%=kdoor_w%></td>
                                    <td class="text-center" colspan="2"><%=kdoor_h%></td>
                                    <td class="text-center" colspan="2"><%=kdoorglass_w%></td>
                                    <td class="text-center" colspan="2"><%=kdoorglass_h%></td>
                                    <td class="text-center" colspan="2"><%=kQUAN%>장</td>
                                    

                                </tr>
                            </tbody>

                            <!--
                            <tr>
                            <th class="text-center" colspan="2">도어 사이즈 추가 가격</th>
                            <th class="text-center" colspan="2">도어 가격</th>
                            </tr>
                            <tr>
                            <td class="text-center" colspan="2"><%=FormatNumber(kdoorsizechuga_price, 0, -1, -1, -1) & " 원"%></td>
                            <td class="text-center" colspan="2"><%=FormatNumber(kdoor_price, 0, -1, -1, -1) & " 원"%></td>
                            </tr>
                            -->
                            

                            <%
                            Rs2.MoveNext
                            Loop
                            End if
                            Rs2.close
                            %>
                            </table>
                    </div>
                        <%
                            else
                        %> 
                    <div class="mb-2">
                        <%
                        SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
                        SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
                        SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
                        SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A "
                        SQL = SQL & " ,a.doorsizechuga_price,a.door_price ,a.goname,a.barNAME ,a.doortype , b.doorchoice "
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
                        <table class="table table-bordered table-sm align-middle" style="width:100%;">
                            <tr>
                                <th colspan="4" class="text-center"><%=kDOORCHOICE_text%></th>
                            </tr> 
                            <!-- no:품명 (1:3) -->
                            <tr>
                            <td class="text-center" style="width: 10%;">no</td>
                            <th class="text-center" colspan="3">품명</th>
                            </tr>
                            <tr>
                            <td class="text-center"><%=k%></td>
                            <td class="text-center" colspan="3"><%=kgoname%></td>
                            </tr>

                            <!-- 2:2 -->
                            <tr>
                            <th class="text-center" colspan="2">규격</th>
                            <th class="text-center" colspan="2">편개/양개</th>
                            </tr>
                            <tr>
                            <td class="text-center" colspan="2"><%=kbarNAME%></td>
                            <td class="text-center" colspan="2"><%=kDOORTYPE_text%></td>
                            </tr>

                            <tr>
                            <th class="text-center" colspan="2">도어W</th>
                            <th class="text-center" colspan="2">도어H</th>
                            </tr>
                            <tr>
                            <td class="text-center" colspan="2"><%=kdoor_w%></td>
                            <td class="text-center" colspan="2"><%=kdoor_h%></td>
                            </tr>

                            <tr>
                            <th class="text-center" colspan="2">도어유리W</th>
                            <th class="text-center" colspan="2">도어유리H</th>
                            </tr>
                            <tr>
                            <td class="text-center" colspan="2"><%=kdoorglass_w%></td>
                            <td class="text-center" colspan="2"><%=kdoorglass_h%></td>
                            </tr>

                            <tr>
                            <th class="text-center" colspan="2">도어 사이즈 추가 가격</th>
                            <th class="text-center" colspan="2">도어 가격</th>
                            </tr>
                            <tr>
                            <td class="text-center" colspan="2"><%=FormatNumber(kdoorsizechuga_price, 0, -1, -1, -1) & " 원"%></td>
                            <td class="text-center" colspan="2"><%=FormatNumber(kdoor_price, 0, -1, -1, -1) & " 원"%></td>
                            </tr>
                            </table>

                            <%
                            Rs2.MoveNext
                            Loop
                            End if
                            Rs2.close
                            %>
                    </div>
                        <%
                            end if
                        %>         
                </div>
                <div class="col-6">    
                    <div class="mb-2">
                            <%
                                if mode="all" then
                            %>  
                        <table class="table table-bordered mb-3">
                            <tr>
                                <th>번 호/유리no</th>
                                <th>픽스유리 가로</th>
                                <th>픽스유리 세로</th>
                                <th>수량</th>
                            </tr>
                            <%
                            prev_fkidx = -1
                            j = 0    

                            SQL = "SELECT a.glass_w, a.glass_h, b.fkidx , b.quan "
                            SQL = SQL & " FROM tk_framekSub a"
                            SQL = SQL & " JOIN tk_framek b ON a.fkidx = b.fkidx"
                            SQL = SQL & " WHERE b.sjidx = '" & rsjidx & "' AND gls>=3 "
                            SQL = SQL & " ORDER BY b.fkidx"
                            Rs.Open SQL, Dbcon

                            If Not (Rs.BOF Or Rs.EOF) Then
                                Do While Not Rs.EOF
                                    now_fkidx = Rs("fkidx")

                                    ' fkidx 바뀌면 그룹 번호 증가 + 유리no 리셋
                                    If prev_fkidx <> now_fkidx Then
                                        j = j + 1
                                        glassNo = 0
                                        prev_fkidx = now_fkidx
                                    End If

                                    glass_w = Rs("glass_w")
                                    glass_h = Rs("glass_h")
                                    quan = Rs("quan")
                                    glassNo = glassNo + 1
                            %>
                                <tr>
                                    <td class="text-center align-middle"><%=j & "_" & glassNo%></td>
                                    <td class="text-center align-middle"><%=glass_w%></td>
                                    <td class="text-center align-middle"><%=glass_h%></td>
                                    <td class="text-center align-middle"><%=quan%>장</td>
                                </tr>
                            <%
                                    Rs.MoveNext
                                Loop
                            End If
                            Rs.Close

                            %>
                        </table>
                            <%
                                else
                            %> 
                        <table class="table table-bordered mb-3">
                            <tr>
                                <th>번 호/유리no</th>
                                <th>픽스유리 가로</th>
                                <th>픽스유리 세로</th>
                                <th>수량</th>
                            </tr>
                            <%
                            prev_fkidx = -1
                            j = 0    

                            SQL = "SELECT a.glass_w, a.glass_h, b.fkidx"
                            SQL = SQL & " FROM tk_framekSub a"
                            SQL = SQL & " JOIN tk_framek b ON a.fkidx = b.fkidx"
                            SQL = SQL & " WHERE b.sjsidx = '" & rsjsidx & "' AND gls>=3 "
                            SQL = SQL & " ORDER BY b.fkidx"
                            Rs.Open SQL, Dbcon

                            If Not (Rs.BOF Or Rs.EOF) Then
                                Do While Not Rs.EOF
                                    now_fkidx = Rs("fkidx")

                                    ' fkidx 바뀌면 그룹 번호 증가 + 유리no 리셋
                                    If prev_fkidx <> now_fkidx Then
                                        j = j + 1
                                        glassNo = 0
                                        prev_fkidx = now_fkidx
                                    End If

                                    glass_w = Rs("glass_w")
                                    glass_h = Rs("glass_h")
                                    glassNo = glassNo + 1
                            %>
                                <tr>
                                    <td class="text-center align-middle"><%=j & "_" & glassNo%></td>
                                    <td class="text-center align-middle"><%=glass_w%></td>
                                    <td class="text-center align-middle"><%=glass_h%></td>
                                    <td class="text-center align-middle">1장</td>
                                </tr>
                            <%
                                    Rs.MoveNext
                                Loop
                            End If
                            Rs.Close

                            %>
                        </table>
                            <%
                                end if
                            %>  
                    </div>
                </div>
            </div>
        <div class="text-end my-3">
            <button class="btn btn-danger" type="button" onclick="window.close();">창 닫기</button>
        </div>
</div>
    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>


<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
call dbClose()
%>
