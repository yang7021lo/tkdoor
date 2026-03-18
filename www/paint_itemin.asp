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

if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 



rpidx=Request("pidx")
rsearchword=Request("SearchWord")
part=Request("part")

midx = c_midx 
cidx = c_cidx 

if request("kgotopage")="" then
kgotopage=1
else
kgotopage=request("kgotopage")
end if 

page_name="paint_itemin.asp?SearchWord="&Request("SearchWord")&"&"
'Response.Write "rpidx : " & rpidx & "<br>"
'Response.Write "rsearchword : " & rsearchword & "<br>"



%>

<% projectname="도장 등록" %>

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
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="paint_itemdb.asp?part=delete&kgotopage=<%=kgotopage%>&searchWord=<%=rsearchword%>&pidx="+sTR;
            }
        }
    </script>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_cyj.asp"-->
 
    
<div id="layoutSidenav_content">            
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
            <div class="py-5 container text-center  card card-body">
                <div class="row">
                    <div class="col-9">
                        <div data-bs-toggle="collapse" data-bs-target="#sampleSection" style="cursor:pointer; font-weight:bold;">
                            ▶ 칼라견본
                        </div>
                        <div class="row">
                            <div class="collapse" id="sampleSection">
                                <div class="container mt-4">
                                    <!-- 헤더 -->
                                    <div class="row fw-bold border-bottom py-2 text-center">
                                        <div class="col">구분</div>
                                        <div class="col">ppg_korea 2016</div>
                                        <div class="col">ppg_korea 2018</div>
                                        <div class="col">ppg_korea 2020</div>
                                        <div class="col">애경 2017</div>
                                        <div class="col">애경 2019</div>
                                        <div class="col">KCC</div>
                                        <div class="col">조광</div>
                                    </div>

                                    <!-- 보기 -->
                                    <div class="row py-2 text-center align-items-center border-bottom">
                                        <div class="col">보기</div>

                                        <!-- dc2016 -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/dc2016_1.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2016_2.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2016_3.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">3</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2016_4.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">4</a>
                                        </div>

                                        <!-- dc2018 -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/dc2018_1.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2018_2.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2018_3.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">3</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2018_4.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">4</a>
                                        </div>

                                        <!-- dc2020 -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/dc2020_1.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2020_2.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2020_3.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">3</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/dc2020_4.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">4</a>
                                        </div>

                                        <!-- 애경 2017 -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/애경2017_1.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/애경2017_2.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/애경2017_3.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">3</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/애경2017_4.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">4</a>
                                        </div>

                                        <!-- 애경 2019 -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/애경2019_1.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/애경2019_2.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/애경2019_3.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">3</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/애경2019_4.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">4</a>
                                        </div>

                                        <!-- KCC -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/kcc_1.jpg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/kcc_2.jpg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>
                                        </div>

                                        <!-- 조광 -->
                                        <div class="col">
                                            <a href="#" onclick="let p=window.open('img/paint/조광1.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">1</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/조광2.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">2</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/조광3.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">3</a>,
                                            <a href="#" onclick="let p=window.open('img/paint/조광4.jpeg','_blank','width=740,height=1046,resizable=yes'); setTimeout(()=>{ if(p && !p.closed) p.close(); },60000); return false;">4</a>
                                        </div>
                                    </div>


                                    <!-- 다운로드 -->
                                    <div class="row py-2 text-center align-items-center">
                                        <div class="col">다운로드</div>
                                        <div class="col">
                                        <a href="img/paint/dc2016_1.jpeg" download>1</a>,
                                        <a href="img/paint/dc2016_2.jpeg" download>2</a>,
                                        <a href="img/paint/dc2016_3.jpeg" download>3</a>,
                                        <a href="img/paint/dc2016_4.jpeg" download>4</a>
                                        </div>
                                        <div class="col">
                                        <a href="img/paint/dc2018_1.jpeg" download>1</a>,
                                        <a href="img/paint/dc2018_2.jpeg" download>2</a>,
                                        <a href="img/paint/dc2018_3.jpeg" download>3</a>,
                                        <a href="img/paint/dc2018_4.jpeg" download>4</a>
                                        </div>
                                        <div class="col">
                                        <a href="img/paint/dc2020_1.jpeg" download>1</a>,
                                        <a href="img/paint/dc2020_2.jpeg" download>2</a>,
                                        <a href="img/paint/dc2020_3.jpeg" download>3</a>,
                                        <a href="img/paint/dc2020_4.jpeg" download>4</a>
                                        </div>
                                        <div class="col">
                                        <a href="img/paint/애경2017_1.jpeg" download>1</a>,
                                        <a href="img/paint/애경2017_2.jpeg" download>2</a>,
                                        <a href="img/paint/애경2017_3.jpeg" download>3</a>,
                                        <a href="img/paint/애경2017_4.jpeg" download>4</a>
                                        </div>
                                        <div class="col">
                                        <a href="img/paint/애경2019_1.jpeg" download>1</a>,
                                        <a href="img/paint/애경2019_2.jpeg" download>2</a>,
                                        <a href="img/paint/애경2019_3.jpeg" download>3</a>,
                                        <a href="img/paint/애경2019_4.jpeg" download>4</a>
                                        </div>
                                        <div class="col">
                                        <a href="img/paint/kcc_1.jpg" download>1</a>,
                                        <a href="img/paint/kcc_2.jpg" download>2</a>
                                        </div>
                                        <div class="col">
                                        <a href="img/paint/조광1.jpeg" download>1</a>,
                                        <a href="img/paint/조광2.jpeg" download>2</a>,
                                        <a href="img/paint/조광3.jpeg" download>3</a>,
                                        <a href="img/paint/조광4.jpeg" download>4</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-3 text-start">
                        <form id="Search" name="Search" action="paint_itemin.asp" method="POST">  
                            <div class="input-group mb-3">
                                <span class="input-group-text">검색&nbsp;&nbsp;&nbsp;</span>
                                <input type="text" class="form-control" name="SearchWord" value="<%=rsearchword%>">
                                    <button type="button" class="btn btn-outline-success" style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                                    onclick="submit();">검색</button>
                                    <button type="button" class="btn btn-outline-danger" style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;" 
                                    onclick="location.replace('paint_itemin.asp?pidx=0');">등록</button>
                            </div>
                        </form>
                    </div>
                </div> 
                <div> 
                    <div style="width: 100%; margin: 0; padding: 0;">
                        <table style="width: 100%; border-collapse: collapse;" id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th style="text-align: center;" size="3" >#</th>
                                    <th style="text-align: center;" size="3" >제조사</th>
                                    <th style="text-align: center;" size="3" >색상타입</th>
                                    <th style="text-align: center;" size="3" >페인트 이름</th>
                                    <th style="text-align: center;" size="3">도장 횟수</th>
                                    <th style="text-align: center;" size="3">단가</th>
                                    <th style="text-align: center;" size="3">할증</th>
                                    <th style="text-align: center;" size="3">페인트 이미지</th>
                                    <th style="text-align: center;" size="3">샘플 발주처</th>
                                    <th style="text-align: center;" size="3">샘플명 </th>
                                    <th style="text-align: center;" size="3">샘플 이미지</th>
                                    <th style="text-align: center;" size="3">등록자</th>
                                    <th style="text-align: center;" size="3">등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" name="dataForm" action="paint_itemdb.asp" method="POST" >   
                                    <input type="hidden" name="pidx" value="<%=rpidx%>">
                                    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                                    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                                    <% 
                                    if rpidx="0" then 
                                        cccc="#404040"
                                    %>
                                    <tr bgcolor="<%=cccc%>" >
                                        <th></th> <!-- 순번 -->
                                        <td>
                                            <select  style="width: 150px;" class="input-field" name="pname_brand" id="pname_brand"  onchange="handleChange(this)">
                                                <%
                                                sql="SELECT pbidx,pname_brand from tk_paint_brand "
                                                sql=sql&" where pbidx > 0 "
                                                'response.write (SQL)&"<br>"
                                                Rs1.open Sql,Dbcon
                                                If Not (Rs1.bof or Rs1.eof) Then 
                                                Do until Rs1.EOF

                                                    apbidx        = rs1(0) '제조사 번호 1.조광 2.애경(플랙스폰) 3.KCC(코푸럭스) 4.PPG 5.신양금속 6.기타  7.미정
                                                    apname_brand        = rs1(1)
                                            
                                                %>
                                                
                                                <option value="<%=apbidx%>" <% If cint(pname_brand) = cint(apbidx) Then Response.Write "selected" End If %> >
                                                    <%=apname_brand%>
                                                </option>
                                                <%
                                                Rs1.MoveNext
                                                Loop
                                                End If
                                                Rs1.close
                                                %>    
                                            </select>
                                            <!-- 인서트용 팝업 버튼 -->
                                            <button type="button" class="btn btn-secondary btn-small" 
                                            onclick="window.open(
                                            'paint_item_insert.asp?kgotopage=<%=kgotopage%>&pidx=<%=rpidx%>&SearchWord=<%=rSearchWord%>#<%=rpidx%>', 
                                            'typeInsert', 
                                            'top=0,left=0,width=' + screen.availWidth + ',height=' + screen.availHeight + ',scrollbars=yes,resizable=yes'
                                            )">
                                            + 추가
                                        </button>
                                        </td>
                                        <th></th> <!-- 색상타입 -->
                                        <td>
                                            <input class="input-field" type="text"  placeholder="페인트 이름"  name="pname" id="pname" value="<%=pname%>" onkeypress="handleKeyPress(event, 'pname', 'pname')"/>
                                        </td> 
                                        <th></th> <!-- 도장 횟수 -->
                                        <th></th> <!-- 단가 -->
                                        <th></th> <!-- 할증비율 -->
                                        <th></th> <!-- 페인트 이미지 -->
                                        <th></th> <!-- 샘플 발주처 -->
                                        <th></th> <!-- 샘플명 -->
                                        <th></th> <!-- 샘플 이미지 -->
                                        <th></th> <!-- 등록자 -->
                                        <th></th> <!-- 등록일 -->
                                    </tr>
                                    <% end if %>
                                    <%
                                    cccc=""
                                    SQL = "SELECT a.pidx, a.pcode, a.pshorten, a.pname, a.pprice, a.pstatus, a.pmidx, a.pwdate, a.pemidx, a.pewdate "
                                    SQL = SQL & ", a.pname_brand, a.p_percent, a.p_image, a.p_sample_image, a.p_sample_name "
                                    SQL = SQL & ", a.cidx, a.sjidx, a.in_gallon, a.out_gallon, a.remain_gallon "
                                    SQL = SQL & ", b.cname, c.mname ,a.paint_type ,a.coat,d.pname_brand "
                                    SQL = SQL & " FROM tk_paint a "
                                    SQL = SQL & " LEFT OUTER JOIN tk_customer b on  a.cidx = b.cidx "
                                    SQL = SQL & " LEFT OUTER JOIN  tk_member c on  a.pmidx = c.midx "
                                    SQL = SQL & " LEFT OUTER JOIN tk_paint_brand D ON A.pname_brand = D.pbidx "
                                    SQL = SQL & "  WHERE 1=1  "

                                    If rpidx <> "" Then
                                        SQL = SQL & " AND a.pidx > 0 "
                                    End If

                                    If rsearchword <> "" Then

                                        SQL = SQL & " AND ("
                                        SQL = SQL & " a.pcode LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & " OR a.pshorten LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & " OR a.pname LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & " OR a.p_sample_name LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & " OR b.cname LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & " OR c.mname LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & " OR d.pname_brand LIKE '%" & rsearchword & "%' "
                                        SQL = SQL & ") "
                                    End If

                                    SQL = SQL & " order by a.pidx desc "
                                    'Response.write (SQL)&"<br>"
                                    Rs.open Sql,Dbcon,1,1,1
                                    Rs.PageSize = 10
                                    If Not (Rs.EOF Or Rs.BOF) Then
                                    no = Rs.recordcount - (Rs.pagesize * (kgotopage-1) ) + 1
                                    totalpage=Rs.PageCount 
                                    Rs.AbsolutePage =kgotopage
                                    i=1
                                    for j=1 to Rs.RecordCount 
                                    if i>Rs.PageSize then exit for end if
                                    if no-j=0 then exit for end if

                                        pidx           = Rs(0)  ' [pidx] 페인트 고유번호
                                        pcode          = Rs(1)  ' [pcode] 코드
                                        pshorten       = Rs(2)  ' [pshorten] 축약명
                                        pname          = Rs(3)  ' [pname] 페인트 이름
                                        pprice         = Rs(4)  ' [pprice] 단가
                                        pstatus        = Rs(5)  ' [pstatus] 상태
                                        pmidx          = Rs(6)  ' [pmidx] 등록자
                                        pwdate         = Rs(7)  ' [pwdate] 등록일
                                        pemidx         = Rs(8)  ' [pemidx] 수정자
                                        pewdate        = Rs(9)  ' [pewdate] 수정일
                                        pname_brand    = Rs(10) ' [pname_brand] 제조사 번호 1.조광 2.애경(플랙스폰) 3.KCC(코푸럭스) 4.PPG 5.신양금속 6.기타 7.미정
                                        p_percent      = Rs(11) ' [p_percent] 할증비율
                                        p_image        = Rs(12) ' [p_image] 페인트 이미지
                                        p_sample_image = Rs(13) ' [p_sample_image] 샘플 이미지
                                        p_sample_name  = Rs(14) ' [p_sample_name] 샘플명
                                        cidx           = Rs(15) ' [cidx] 수주처
                                        sjidx          = Rs(16) ' [sjidx] 수주키
                                        in_gallon       = Rs(17) ' [in_gallon] 입고량
                                        out_gallon      = Rs(18) ' [out_gallon] 사용량
                                        remain_gallon   = Rs(19) ' [remain_gallon] 남은량
                                        cname          = Rs(20) ' [cname] 수주처 이름
                                        mname          = Rs(21) ' [mname] 작성자 이름
                                        paint_type     = Rs(22) ' [paint_type] 색상 타입 1.기본(블랙,화이트,그레이,실버계열) 2.원색 3.브라운(갈색) 4.메탈릭 
                                        coat           = Rs(23) ' [coat] 도장 횟수
                                        pname_brand_text = Rs(24) ' [pname_brand_text] 제조사 이름

                                        If IsNull(pname_brand) Or Trim(pname_brand) = "" Or pname_brand = "0" Then
                                            pname_brand = 7 ' 7.미정
                                        end if

                                        i=i+1
                                        
                                        select case paint_type '1.기본(블랙,화이트,그레이,실버계열) 2.원색 3.브라운(갈색) 4.메탈릭 
                                            case "0"
                                                paint_type_text="❌"
                                            case "1"
                                                paint_type_text="기본(블랙,화이트,그레이,실버계열)"
                                            case "2"
                                                paint_type_text="원색"
                                            case "3"
                                                paint_type_text="브라운(갈색)"
                                            case "4"
                                                paint_type_text="메탈릭(펄 추가)"
                                        end select     
                                        select case coat '1.기본(2코트) 2.3코트
                                            case "0"
                                                coat_text="❌"
                                            case "1"
                                                coat_text="기본(2코트)"
                                            case "2"
                                                coat_text="필수(3코트)"
                                            case "3"
                                                coat_text="선택가능(2 or 3코트)"
                                            case "4"
                                                coat_text="기타"    
                                        end select   
                                    %>
                                    <% 
                                    'response.write "pidx : "&pidx&"<br>"
                                    'response.write "rpidx : "&rpidx&"<br>"
                                    'response.write "pname_brand : "&pname_brand&"<br>"
                                    if int(pidx)=int(rpidx) then 
                                    cccc="#E7E7E7"
                                    %>
                                    <tr bgcolor="<%=cccc%>">
                                        <td style="text-align: center;"><a name="<%=pidx%>">-><button type="button" class="btn btn-outline-danger" Onclick="del('<%=pidx%>');"><%=no-j%></button></td> <!-- 삭제  -->
                                        <td>
                                            <select  style="width: 150px;" class="input-field" name="pname_brand" id="pname_brand"  onchange="handleChange(this)">
                                                <%
                                                sql="SELECT pbidx,pname_brand from tk_paint_brand "
                                                sql=sql&" where pbidx > 0 "
                                                'response.write (SQL)&"<br>"
                                                Rs1.open Sql,Dbcon
                                                If Not (Rs1.bof or Rs1.eof) Then 
                                                Do until Rs1.EOF

                                                    apbidx        = rs1(0) '제조사 번호 1.조광 2.애경(플랙스폰) 3.KCC(코푸럭스) 4.PPG 5.신양금속 6.기타  7.미정
                                                    apname_brand        = rs1(1)
                                            
                                                %>
                                                
                                                <option value="<%=apbidx%>" <% If cint(pname_brand) = cint(apbidx) Then Response.Write "selected" End If %> >
                                                    <%=apname_brand%>
                                                </option>
                                                <%
                                                Rs1.MoveNext
                                                Loop
                                                End If
                                                Rs1.close
                                                %>    
                                            </select>
                                        </td>  
                                        <td>
                                            <select  style="width: 300px;" class="input-field" name="paint_type" id="paint_type"  onchange="handleSelectChange(event, 'paint_type', 'paint_type')">
                                                <option value="0" <% If paint_type = "0" Then Response.Write "selected" %> >❌</option>
                                                <option value="1" <% If paint_type = "1" Then Response.Write "selected" %> >기본(블랙,화이트,그레이,실버계열)</option>
                                                <option value="2" <% If paint_type = "2" Then Response.Write "selected" %> >원색(빨,주,노,초,파)</option>
                                                <option value="3" <% If paint_type = "3" Then Response.Write "selected" %> >브라운(갈색)</option>
                                                <option value="4" <% If paint_type = "4" Then Response.Write "selected" %> >메탈릭(펄 추가)</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input style="width: 300px;" class="input-field" type="text"  placeholder="페인트 이름"  name="pname" id="pname" value="<%=pname%>" 
                                            onkeypress="handleKeyPress(event, 'pname', 'pname')"/>
                                        </td>  
                                        <td>
                                            <select style="width: 200px;" class="input-field" name="coat" id="coat"  onchange="handleSelectChange(event, 'coat', 'coat')">
                                                <option value="0" <% If coat = "0" Then Response.Write "selected" %> >❌</option>
                                                <option value="1" <% If coat = "1" Then Response.Write "selected" %> >기본(2코트)</option>
                                                <option value="2" <% If coat = "2" Then Response.Write "selected" %> >필수(3코트)</option>
                                                <option value="3" <% If coat = "3" Then Response.Write "selected" %> >선택가능(2 or 3코트)</option>
                                                <option value="4" <% If coat = "4" Then Response.Write "selected" %> >기타</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input style="width: 100px;" class="input-field" type="number" placeholder="단가" name="pprice" id="pprice" value="<%=pprice%>" 
                                            onkeypress="handleKeyPress(event, 'pprice', 'pprice')"/>
                                        </td> 
                                        <td>
                                            <input style="width: 50px;" class="input-field" type="number" placeholder="할증비율" name="p_percent" id="p_percent" value="<%=p_percent%>"
                                            onkeypress="handleKeyPress(event, 'p_percent', 'p_percent')"/>
                                        </td> 
                                        <td> <!-- 페인트 이미지 p_image -->
                                            <img src="/img/paint/<%=p_image%>" loading="lazy" width="170" height="50"  border="0"
                                            onclick="window.open('paint_itemdb_upload.asp?kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&pidx=<%=pidx%>&type=p_image','p_image','top=10, left=10, width=700, height=600');">
                                            <br>
                                            <!-- 🔹 미리보기 버튼 추가 -->
                                            <button type="button" onclick="window.open('/img/paint/<%=p_image%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                                            <a href="/img/paint/<%=p_image%>" download="<%=p_image%>">
                                                <button type="button">다운로드</button>
                                            </a>  
                                        </td>  
                                        <td>
                                            <input class="input-field" type="text" placeholder="샘플 발주처" name="cidx" id="cidx" value="<%=cidx%>" 
                                            onkeypress="handleKeyPress(event, 'cidx', 'cidx')"/>
                                        </td>
                                        <td>
                                            <input class="input-field" type="text" placeholder="샘플명" name="p_sample_name" id="p_sample_name" value="<%=p_sample_name%>" 
                                            onkeypress="handleKeyPress(event, 'p_sample_name', 'p_sample_name')"/>
                                        </td>    
                                        <!-- 샘플 이미지 -->
                                        <td> <!-- 샘플 이미지 p_sample_image -->
                                            <img src="/img/paint/<%=p_sample_image%>" loading="lazy" width="170" height="50"  border="0"
                                            onclick="window.open('paint_itemdb_upload.asp?kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&pidx=<%=pidx%>&type=p_sample_image','p_sample_image','top=10, left=10, width=700, height=600');">
                                            <br>
                                            <!-- 🔹 미리보기 버튼 추가 -->
                                            <button type="button" onclick="window.open('/img/paint/<%=p_sample_image%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                                            <a href="/img/paint/<%=p_sample_image%>" download="<%=p_sample_image%>">
                                                <button type="button">다운로드</button>
                                            </a>  
                                        </td> 
                                        <td><%=mname%></td> <!-- 등록자-->
                                        <td><%=pewdate%></td> <!-- 등록일 -->
                                    <% else 
                                    'cccc="#CCCCCC"
                                    %>
                                    <tr bgcolor="<%=cccc%>">
                                        <td style="text-align: center;"><%=no-j%><a name="<%=pidx%>"></td><!-- 순번 -->
                                        <td style="text-align: center;">
                                            <input style="width: 150px;" class="input-field" type="text" value="<%=pname_brand_text%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&pidx=<%=pidx%>');"/> 
                                        </td>                           
                                        <td style="text-align: center;">
                                            <input style="width: 300px;" class="input-field" type="text" value="<%=paint_type_text%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td>  
                                        <td style="text-align: center;">
                                            <input style="width: 300px;" class="input-field" type="text" value="<%=pname%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td> 
                                        <td style="text-align: center;">
                                            <input  style="width: 200px;" class="input-field" type="text" value="<%=coat_text%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td> 
                                        <td style="text-align: center;">
                                            <input style="width: 100px;" class="input-field" type="text" value="<%=pprice%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td>
                                        <td style="text-align: center;">
                                            <input style="width: 50px;" class="input-field" type="text" value="<%=p_percent%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td>
                                        <td style="text-align: center;">
                                            <img src="/img/paint/<%=p_image%>" loading="lazy" width="170" height="50"  border="0"
                                            onclick="window.open('paint_itemdb_upload.asp?kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&pidx=<%=pidx%>');">
                                        </td>
                                        <td style="text-align: center;">
                                            <input class="input-field" type="text" value="<%=cidx%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td> 
                                        <td style="text-align: center;">
                                            <input class="input-field" type="text" value="<%=p_sample_name%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td> 
                                        <td style="text-align: center;">
                                            <img src="/img/frame/<%=p_sample_image%>"  loading="lazy" width="170" height="50"  border="0"
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td>
                                        <td style="text-align: center;">
                                            <input class="input-field" type="text" value="<%=mname%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td> 
                                        <td style="text-align: center;">
                                            <input class="input-field" type="text" value="<%=pewdate%>" 
                                            onclick="location.replace('paint_itemin.asp?kgotopage=<%=kgotopage%>&pidx=<%=pidx%>&searchWord=<%=rsearchword%>#<%=pidx%>');"/> 
                                        </td> 
                                    </tr>
                                    <% end if %>
                                    <%
                                    paint_type_text =""
                                    coat_text =""
                                    cccc=""

                                    Rs.MoveNext 
                                    Next 
                                    End If 
                                    %>
                                    <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                </form>    
                            </tbody>
                        </table>
                    </div>
                    <div class="row">
                        <div  class="col-10 py-3"> 
                            <!--#include Virtual = "/inc/kpaging.asp" -->
                        </div>
                    <%
                    Rs.Close
                    %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384- YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    
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


