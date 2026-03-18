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
Set Rs3 = Server.CreateObject("ADODB.Recordset")

if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 

rmidx=Request("rmidx")

rbaidx=Request("rbaidx")
rbasidx=Request("rbasidx")
part=Request("part")
baidx=225

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        body {
            zoom: 0.8;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
    <style>
        .header {
            text-align: center;
            font-size: 48px;
            font-weight: bold;
            margin-bottom: 20px;
            position: relative;
            display: inline-block;
        }
        .header::after {
            content: "";
            display: block;
            width: 100%;
            height: 3px;
            background-color: black;
            position: absolute;
            bottom: -5px;
            left: 0;
        }
        .table thead th { background-color: #f8f9fa; }
    </style>
    <script>
        function formatCurrency(input) {
            let value = input.value.replace(/[^0-9]/g, '');
            value = new Intl.NumberFormat('ko-KR').format(value);
            input.value = value;
        }
    </script>
    <style>
         /* 프린트 설정 */
        @page {
            size: A4 portrait; /* 기본값: 세로(A4) */
            margin: 0mm; /* 최소 여백 설정 */
        }
        @media print {
            .form-control {
                width: auto; /* 인쇄 시 너비 자동 조정 */
            }
            .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */
        }
    </style>
    <script>
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG6_JULGOK_DB.asp?part=delete&midx="+sTR;
            }
        }
    </script>
</head>
<body class="sb-nav-fixed">
    <div id="layoutSidenav_content">    
        <main>
            <div class="card card-body mb-1">  <!-- * 수주일자  -->
                <div class="row ">
                    <div class="col-md-1">
                        <label for="name">수주일자</label><p>
                        <input type="date" class="form-control" id="" name="" placeholder="" value="" >
                    </div>
                    <div class="col-md-1">
                        <label for="name">수주번호</label><p>
                        <select name="" class="form-control" id="" required>
                            <option value="">0001</option>
                            <option value="">0002</option>
                            <option value="">0003</option>
                            <option value="">0004</option>
                        </select>
                    </div> 
                    <div class="col-md-1">
                        <label for="name">출고일자</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_chulgodate"  readonly>
                    </div>
                    <div class="col-md-1">
                        <label for="name">도장출고일자</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_chulgodate"  readonly>
                    </div>  
                    <div class="col-md-1">
                        <label for="name">출고방식</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_chulgo"  readonly>
                    </div>
                    <div class="col-md-2">
                        <label for="name">현장명</label><p>
                        <input type="text" class="form-control" id="" name="" placeholder="" value="SJA_address" readonly>
                    </div>
                    <div class="col-md-2">
                        <label for="name">수정/저장/삭제</label><p>
                        <button class="btn btn-primary btn-small " type="submit" >수정</button>
                        <button class="btn btn-success btn-small " type="submit" >저장</button>
                        <button class="btn btn-danger btn-small " type="submit" >삭제</button>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col text-end">
                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG6_JULGOK.asp?rmidx=0');">등록</button>
                </div>
            </div>
            <div class="row">
                <div class="input-group mb-3">
                    <table id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                                <th align="center">번호</th>
                                <th align="center">절곡도</th>
                                <th align="center">바라시</th>
                                <th align="center">절단치수</th>
                                <th align="center">휴대폰</th>
                                <th align="center">팩스</th>
                                <th align="center">이메일</th> 
                                <th align="center">등록일</th>  
                            </tr>
                        </thead>
                        <tbody>
                            <form id="dataForm" action="TNG6_JULGOK_DB.asp" method="POST">   
                                <input type="hidden" name="midx" value="<%=rmidx%>">
                                <% if rmidx="0" then %>
                                <tr>
                                    <td></td>
                                    <td></td> 
                                    <td><input class="input-field" type="text" size="3" placeholder="이름" aria-label="이름" name="mname" id="mname" 
                                    value="<%=mname%>" onkeypress="handleKeyPress(event, 'mname', 'mname')"/></td>
                                    <td><input class="input-field" type="text" size="16" placeholder="전화번호" aria-label="전화번호" name="mtel" id="mtel" 
                                    value="<%=mtel%>"  onkeypress="handleKeyPress(event, 'mtel', 'mtel')"/></td>
                                    <td><input class="input-field" type="text" placeholder="휴대폰" aria-label="휴대폰" name="mhp" id="mhp" 
                                    value="<%=mhp%>"  onkeypress="handleKeyPress(event, 'mhp', 'mhp')"/></td>
                                    <td><input class="input-field" type="text" placeholder="팩스" aria-label="팩스" name="mfax" id="mfax" 
                                    value="<%=mfax%>"  onkeypress="handleKeyPress(event, 'mfax', 'mfax')"/></td>
                                    <td><input class="input-field" type="text" placeholder="이메일" aria-label="이메일" name="memail" id="memail" 
                                    value="<%=memail%>"  onkeypress="handleKeyPress(event, 'memail', 'memail')"/></td>
                                    <td><%=mwdate%></td>
                                </tr>
                                    <% end if %>
                                    <%
                                    SQL="select baname , bastatus, xsize, ysize, sx1, sx2, sy1, sy2, bachannel, baidx from tk_barasi where baidx='"&baidx&"' "
                                    'response.write (SQL)&"<br>"
                                            Rs.open Sql,Dbcon,1,1,1
                                        if not (Rs.EOF or Rs.BOF ) then
                                        Do while not Rs.EOF

                                        rbaname=Rs(0)
                                        rbastatus=Rs(1)
                                        xsize=Rs(2)
                                        ysize=Rs(3)
                                        sx1=Rs(4)
                                        sx2=Rs(5)
                                        sy1=Rs(6)
                                        sy2=Rs(7)
                                        bachannel=rs(8)
                                        tbaidx=rs(9)
                                        if xsize="0" then xsize="1" end if
                                        ratev=FormatNumber(300/xsize,0)
                                        i=i+1
                                    %>              
                                    <% if int(baidx)=int(rbaidx) then %>
                                <tr>
                                    <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=midx%>');"><%=i%></button></td>
                                    <td>
                                        <svg id="mySVG" width="200" height="200" viewBox="130 50 200 200" fill="none" stroke="#000000" stroke-width="1" >
                                            <%
                                            
                                            SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub " 
                                            SQL=SQL&"where baidx='"&baidx&"' order by basidx asc "
                                            ''response.write (SQL)&"<br>"
                                            Rs1.open Sql,Dbcon
                                            If Not (Rs1.bof or Rs1.eof) Then 
                                            Do while not Rs1.EOF
                                            basidx=Rs1(0)
                                            bassize=Rs1(1)
                                            basdirection=Rs1(2)
                                            x1=Rs1(3)
                                            y1=Rs1(4)
                                            x2=Rs1(5)
                                            y2=Rs1(6)
                                            accsiz=Rs1(7)
                                            idv=Rs1(8)
                                            textv=bassize+idv
                                            'response.write  bassize&"/"&basdirection&"<br>"
                                            if bassize>30 then 
                                                bojngv=-10
                                            end if  

                                            if basdirection="1" then 
                                                tx1=x1+(bassize/2)
                                                ty1=y1-1
                                            elseif basdirection="2" then 
                                                tx1=x1-5
                                                ty1=y1+(bassize/2)+bojngv+10
                                            elseif basdirection="3" then 
                                                tx1=x1-(bassize/2)
                                                ty1=y1+5
                                            elseif basdirection="4" then 
                                                tx1=x1+5
                                                ty1=y1-(bassize/2)+bojngv+10
                                            end if
                                            %>
                                            <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                                            <text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="20" text-anchor="middle"><%=FormatNumber(bassize,0)%></text>   
                                            <%
                                            Rs1.movenext
                                            Loop
                                            End if
                                            Rs1.close
                                            %> 
                                        </svg>
                                    </td>
                                    <td><input class="input-field" type="text" size="3" placeholder="이름" aria-label="이름" name="mname" id="mname" value="<%=rbaname%>" onkeypress="handleKeyPress(event, 'mname', 'mname')"/></td>
                                    <td><input class="input-field" type="text" size="16" placeholder="전화번홓" aria-label="전화번홓" name="mtel" id="mtel" value="<%=mtel%>"  onkeypress="handleKeyPress(event, 'mtel', 'mtel')"/></td>
                                    <td><input class="input-field" type="text" placeholder="휴대폰" aria-label="휴대폰" name="mhp" id="mhp" value="<%=mhp%>"  onkeypress="handleKeyPress(event, 'mhp', 'mhp')"/></td>
                                    <td><input class="input-field" type="text" placeholder="팩스" aria-label="팩스" name="mfax" id="mfax" value="<%=mfax%>"  onkeypress="handleKeyPress(event, 'mfax', 'mfax')"/></td>
                                    <td><input class="input-field" type="text" placeholder="이메일" aria-label="이메일" name="memail" id="memail" value="<%=memail%>"  onkeypress="handleKeyPress(event, 'memail', 'memail')"/></td>
                                    <td><%=mwdate%></td>
                                </tr>
                                    <% else %>
                                <tr>
                                    <td align="center"><%=i%></td>
                                    <td>
                                        <svg id="mySVG" width="100" height="100" viewBox="130 50 150 150" fill="none" stroke="#000000" stroke-width="1" >
                                            <%
                                            SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub " 
                                            SQL=SQL&"where baidx='"&baidx&"' order by basidx asc "
                                            ''response.write (SQL)&"<br>"
                                            Rs1.open Sql,Dbcon
                                            If Not (Rs1.bof or Rs1.eof) Then 
                                            Do while not Rs1.EOF
                                            basidx=Rs1(0)
                                            bassize=Rs1(1)
                                            basdirection=Rs1(2)
                                            x1=Rs1(3)
                                            y1=Rs1(4)
                                            x2=Rs1(5)
                                            y2=Rs1(6)
                                            accsiz=Rs1(7)
                                            idv=Rs1(8)
                                            textv=bassize+idv
                                            'response.write  bassize&"/"&basdirection&"<br>"
                                            if bassize>30 then 
                                                bojngv=-10
                                            end if  

                                            if basdirection="1" then 
                                                tx1=x1+(bassize/2)
                                                ty1=y1-1
                                            elseif basdirection="2" then 
                                                tx1=x1-5
                                                ty1=y1+(bassize/2)+bojngv+10
                                            elseif basdirection="3" then 
                                                tx1=x1-(bassize/2)
                                                ty1=y1+5
                                            elseif basdirection="4" then 
                                                tx1=x1+5
                                                ty1=y1-(bassize/2)+bojngv+10
                                            end if
                                            %>
                                            <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                                            <text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="20" text-anchor="middle"><%=FormatNumber(bassize,0)%></text>   
                                            <%
                                            Rs1.movenext
                                            Loop
                                            End if
                                            Rs1.close
                                            %> 
                                        </svg>
                                    </td>
                                    <td>
                                        <%
                                        SQL="Select basidx, bassize, basdirection, accsize, idv, final from tk_barasisub where baidx='"&baidx&"' order by basidx asc"
                                        'response.write(sql)
                                        Rs3.open Sql,Dbcon
                                        If Not (Rs3.bof or Rs3.eof) Then 
                                        Do while not Rs3.EOF
                                        basidx=Rs3(0)
                                        bassize=Rs3(1)
                                        basdirection=Rs3(2)
                                        accsize=Rs3(3)
                                        idv=Rs3(4)
                                        final=Rs3(5)
                                        g=g+1
                                        if basdirection="1" then
                                        basdirection_text="→"
                                        elseif basdirection="2" then
                                        basdirection_text="↓"
                                        elseif basdirection="3" then
                                        basdirection_text="←"
                                        elseif basdirection="4" then
                                        basdirection_text="↑"
                                        end if

                                        if idv="0" then 
                                            if g>"1" then 
                                            btn_text="btn-primary"
                                            end if
                                        else
                                            btn_text="btn-light"
                                        end if 

                                        if final="0" then 
                                            btn_text="btn-danger"
                                        end if
                                        %>
                                        <button type="button" class="btn <%=btn_text%> btn-sm"><%=accsize%></button>
                                        <%
                                        pba=basdirection
                                        Rs3.movenext
                                        Loop
                                        End if
                                        Rs3.close
                                        %>
                                    </td>
                                    <td><input class="input-field" type="text" value="<%=mhp%>" onclick="location.replace('TNG6_JULGOK.asp?rmidx=<%=midx%>');"/></td>
                                    <td><input class="input-field" type="text" value="<%=mfax%>" onclick="location.replace('TNG6_JULGOK.asp?rmidx=<%=midx%>');"/></td>
                                    <td><input class="input-field" type="text" value="<%=memail%>" onclick="location.replace('TNG6_JULGOK.asp?rmidx=<%=midx%>');"/></td>
                                    <td><input class="input-field" type="text" value="<%=mwdate%>" onclick="location.replace('TNG6_JULGOK.asp?rmidx=<%=midx%>');"/></td>
                                </tr>
                                    <% end if %>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End If 
                                    Rs.Close 
                                    %>
                                    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                            </form>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>    
    </div>    
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
