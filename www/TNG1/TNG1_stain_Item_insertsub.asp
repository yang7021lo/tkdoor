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

part=Request("part")

' 파일 및 폼 데이터 읽기
kgotopage = Request("kgotopage")
gotopage = Request("gotopage")
rSearchWord    = Request("SearchWord")

' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
rqtyco_idx     = Request("qtyco_idx")
rQTYNo         = Request("QTYNo")
rQTYNAME       = Request("QTYNAME")
rQTYcoNAME     = Request("QTYcoNAME")
rQTYcostatus   = Request("QTYcostatus")
rQTYcomidx     = Request("QTYcomidx")
rQTYcowdate    = Request("QTYcowdate")
rQTYcoemidx    = Request("QTYcoemidx")
rQTYcoewdate   = Request("QTYcoewdate")
rsheet_w       = Request("sheet_w")
rsheet_h       = Request("sheet_h")
rsheet_t       = Request("sheet_t")
rcoil_cut      = Request("coil_cut")
rcoil_t        = Request("coil_t")
runittype_qtyco_idx        = Request("unittype_qtyco_idx")
'Response.Write "rqtyco_idx : " & rqtyco_idx & "<br>"
'Response.Write "rQTYNo : " & rQTYNo & "<br>"
'Response.Write "rQTYNAME : " & rQTYNAME & "<br>"
'Response.Write "rQTYcoNAME : " & rQTYcoNAME & "<br>"
'Response.Write "rQTYcostatus : " & rQTYcostatus & "<br>"
'Response.Write "rQTYcomidx : " & rQTYcomidx & "<br>"
'Response.Write "rQTYcowdate : " & rQTYcowdate & "<br>"
'Response.Write "rQTYcoemidx : " & rQTYcoemidx & "<br>"
'Response.Write "rQTYcoewdate : " & rQTYcoewdate & "<br>"
'Response.Write "rsheet_w : " & rsheet_w & "<br>"
'Response.Write "rsheet_h : " & rsheet_h & "<br>"
'Response.Write "rsheet_t : " & rsheet_t & "<br>"
'Response.Write "rcoil_cut : " & rcoil_cut & "<br>"
'Response.Write "rcoil_t : " & rcoil_t & "<br>"
'Response.end

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="TNG1_stain_Item_insertsub.asp?SearchWord="&Request("SearchWord")&"&"
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
        body {
            zoom: 1;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 카드 전체 크기 조정 */
        .card.card-body {
            padding: 1px; /* 내부 여백 줄이기 */
            margin-bottom: 0.5rem; /* 하단 여백 줄이기 */
        }

        /* 글씨 크기 및 입력 필드 크기 조정 */
        .form-control {
            font-size: 12px; /* 글씨 크기 줄이기 */
            height: 25px; /* 입력 필드 높이 줄이기 */
            padding: 1px 1px; /* 내부 여백 줄이기 */
        }

        /* 레이블 크기 조정 */
        label {
            font-size: 12px;
            margin-bottom: 0px; /* 레이블과 입력 필드 간격 최소화 */
        }

        /* 행(row) 간격 줄이기 */
        .row {
            margin-bottom: 0px; /* 행 간격 줄이기 */
        }
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
        .svg-container {
            width: 250px;
        }
        svg {
            width: 100%;
            height: auto;
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
                location.href="TNG1_stain_Item_insertdbsub.asp?part=delete&searchWord=<%=rsearchword%>&qtyco_idx="+sTR;
            }
        }
    </script>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
            <div class="py-5 container text-center">
                    <!-- 제목 나오는 부분 시작-->
                    <div class="row mb-3">
                        <div class="col text-start">
                            <h3>품목명 추가</h3>
                        </div>
                        <div class="col-3 text-start">
                            <form id="Search" name="Search" action="TNG1_stain_Item_insertsub.asp" method="POST">
                                <div class="input-group mb-3">
                                    <button type="button"
                                        class="btn btn-outline-danger"
                                        onclick="location.replace('TNG1_stain_Item_insert.asp');">돌아가기
                                    </button>
                                    <input type="text" class="form-control"   style="height: 36px;" name="SearchWord" value="<%=Request("SearchWord")%>">
                                    <button type="button" class="btn btn-outline-success"  onclick="submit();">검색</button>
                                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_stain_Item_insertsub.asp?qtyco_idx=0');">등록</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                        
                    <!-- 표 형식 시작--> 
                    <div class="input-group mb-3">
                        <table id="datatablesSimple"  class="table table-hover">
                            <thead>
                                <tr>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">번호</th>
                                    <th width="160" rowspan="2" style="text-align:center; vertical-align:middle;">판재명</th>
                                    <th width="160" rowspan="2" style="text-align:center; vertical-align:middle;">판재회사명</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">unittype</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">✅<br>❌</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">판재/코일 단가/Kg</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">판재/코일 두께</th>
                                    <th colspan="2" style="text-align:center; vertical-align:middle;">판재규격</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">코일규격</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">수정자</th>
                                    <th width="40" rowspan="2" style="text-align:center; vertical-align:middle;">수정일</th>
                                </tr>
                                <tr>
                                    <th width="40" style="text-align:center; vertical-align:middle;">판재<br>:가로</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">판재<br>:세로</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" action="TNG1_stain_Item_insertdbsub.asp" method="POST">   
                                    <input type="hidden" name="qtyco_idx" value="<%=rqtyco_idx%>">
                                    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                                    <input type="hidden" name="gotopage" value="<%=gotopage%>">
                                    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                                    <% if rqtyco_idx="0" then %>
                                        <tr>
                                            <%
                                            ' 🔹 새로운 qtyco_idx 번호 구하기
                                                SQL = "SELECT ISNULL(MAX(QTYNo), 0) + 1 FROM tk_qtyco"
                                                Rs.Open SQL, Dbcon
                                                If Not (Rs.EOF Or Rs.BOF) Then
                                                    yQTYNo = Rs(0)
                                                End If
                                                Rs.Close
                                            %>
                                            <td><input class="input-field" type="text" size="3" name="QTYNo" id="qtyno" value="<%=yQTYNo%>" onkeypress="handleKeyPress(event, 'qtyno', 'qtyno')"/></td> 
                                            <td><input class="input-field" type="text" size="16" name="qtyname" id="qtyname" value="<%=rqtyname%>"  onkeypress="handleKeyPress(event, 'qtyname', 'qtyname')"/></td>
                                            <td></td>
                                            <td>
                                                <select class="input-field" name="qtycostatus" id="qtycostatus"  onchange="handleSelectChange(event, 'qtycostatus', 'qtycostatus')">
                                                    <option value="1" <% If qtycostatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td> 
                                        </tr>
                                    <% end if %>
                                            <%
                                            sql = "SELECT A.qtyco_idx, A.QTYNo, A.QTYNAME, A.QTYcoNAME, A.QTYcostatus "
                                            sql = sql & ", A.QTYcomidx,Convert(varchar(10), A.QTYcowdate, 121)  "
                                            sql = sql & ", A.QTYcoemidx, Convert(varchar(10), A.QTYcoewdate, 121) "
                                            sql = sql & ", A.sheet_w, A.sheet_h, A.sheet_t, A.coil_cut, A.coil_t "
                                            sql = sql & ", B.mname , C.mname ,A.kg ,A.unittype_qtyco_idx "
                                            sql = sql & "FROM tk_qtyco A "
                                            sql = sql & "JOIN tk_member B ON A.QTYcomidx = B.midx "
                                            sql = sql & "LEFT OUTER JOIN tk_member C ON A.QTYcoemidx = C.midx "
                                            SQL = SQL & " WHERE A.qtyco_idx <> '' "
                                            If Request("SearchWord") <> "" Then
                                                SQL = SQL & " AND ( A.QTYNAME LIKE '%" & Request("SearchWord") & "%' "
                                                SQL = SQL & " OR A.sheet_t LIKE '%" & Request("SearchWord") & "%'  "
                                                SQL = SQL & " OR A.QTYNAME LIKE '%" & Request("SearchWord") & "%' ) "
                                            End If
                                            sql = sql & "ORDER BY A.qtyco_idx DESC "
                                            'Response.write (SQL)&"<br>"
                                            Rs.open Sql,Dbcon,1,1,1
                                            Rs.PageSize = 10
                                            If Not (Rs.EOF Or Rs.BOF) Then
                                            no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                                            totalpage=Rs.PageCount 
                                            Rs.AbsolutePage =gotopage
                                            i=1
                                            for j=1 to Rs.RecordCount 
                                            if i>Rs.PageSize then exit for end if
                                            if no-j=0 then exit for end if

                                                qtyco_idx   = Rs(0)
                                                QTYNo       = Rs(1)
                                                QTYNAME     = Rs(2)
                                                QTYcoNAME   = Rs(3)
                                                QTYcostatus = Rs(4)
                                                QTYcomidx   = Rs(5)
                                                QTYcowdate  = Rs(6)
                                                QTYcoemidx  = Rs(7)
                                                QTYcoewdate = Rs(8)
                                                sheet_w     = Rs(9)
                                                sheet_h     = Rs(10)
                                                sheet_t     = Rs(11)
                                                coil_cut    = Rs(12)
                                                coil_t      = Rs(13)
                                                mname          = Rs(14)
                                                mename         = Rs(15)
                                                kg         = Rs(16)
                                                unittype_qtyco_idx = Rs(17)
                                                select case qtycostatus
                                                    case "0"
                                                        qtycostatus_text="❌"
                                                    case "1"
                                                        qtycostatus_text="✅"
                                                end select
                                                select case sheet_t
                                                    case "0"
                                                        sheet_t_text="❌"                                                
                                                    case "1"
                                                        sheet_t_text="0.6t"
                                                    case "2"
                                                        sheet_t_text="0.8t"
                                                    case "3"
                                                        sheet_t_text="1.2t"
                                                    case "4"
                                                        sheet_t_text="1.5t"
                                                end select
                                                select case sheet_w
                                                    case "0"
                                                        sheet_w_text="1000(1)"
                                                    case "1"
                                                        sheet_w_text="1219(4)"
                                                end select
                                                select case unittype_qtyco_idx
                                                    case "0"
                                                        unittype_qtyco_idx_text="❌"
                                                    case "1"
                                                        unittype_qtyco_idx_text="H/L"
                                                    case "2"
                                                        unittype_qtyco_idx_text="P/L"
                                                    case "3"
                                                        unittype_qtyco_idx_text="갈바"    
                                                    case "4"
                                                        unittype_qtyco_idx_text="블랙H/L"
                                                    case "5"
                                                        unittype_qtyco_idx_text="블랙,골드"
                                                    case "6"
                                                        unittype_qtyco_idx_text="바이브_등"
                                                    case "7"
                                                        unittype_qtyco_idx_text="브론즈_등"
                                                    case "8"
                                                        unittype_qtyco_idx_text="지급판"
                                                    case "9"
                                                        unittype_qtyco_idx_text="AL/도장"
                                                    case "10"
                                                        unittype_qtyco_idx_text="AL/블랙"
                                                    case "11"
                                                        unittype_qtyco_idx_text="헤어1.5"    
                                                    case else
                                                        unittype_qtyco_idx_text="(없음)"
                                                end select 


                                                i=i+1
                                            %>              
                                            <% if int(qtyco_idx)=int(rqtyco_idx) then %>
                                        <tr>
                                            <!-- 번호 + 삭제 버튼 + 번호 입력 -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <div>
                                                    <button type="button" class="btn btn-outline-danger btn-sm" onclick="del('<%=qtyco_idx%>');">삭제</button>
                                                </div>
                                                <div>
                                                    <input class="input-field" type="text"  name="qtyno" id="qtyno" 
                                                        value="<%=qtyno%>" 
                                                        onkeypress="handleKeyPress(event, 'qtyno', 'qtyno')"/>
                                                </div>
                                            </td>

                                            <!-- 판재명 -->
                                            <td>
                                                <input class="input-field" type="text"  name="qtyname" id="qtyname" 
                                                    value="<%=qtyname%>"  
                                                    onkeypress="handleKeyPress(event, 'qtyname', 'qtyname')"/>
                                            </td>

                                            <!-- 판재회사명 -->
                                            <td>
                                                <input class="input-field" type="text"  name="QTYcoNAME" id="QTYcoNAME" 
                                                    value="<%=QTYcoNAME%>"  
                                                    onkeypress="handleKeyPress(event, 'QTYcoNAME', 'QTYcoNAME')"/>
                                            </td>
                                            
                                            <!-- unittype -->
                                            <td>
                                                <select class="input-field" name="unittype_qtyco_idx" id="unittype_qtyco_idx" onchange="handleSelectChange(event, 'unittype_qtyco_idx', 'unittype_qtyco_idx')">
                                                    <option value="0" <% If unittype_qtyco_idx = "0" Then Response.Write "selected" %> >❌</option>
                                                    <option value="1" <% If unittype_qtyco_idx = "1" Then Response.Write "selected" %> >H/L</option>
                                                    <option value="2" <% If unittype_qtyco_idx = "2" Then Response.Write "selected" %> >P/L</option>
                                                    <option value="3" <% If unittype_qtyco_idx = "3" Then Response.Write "selected" %> >갈바</option>
                                                    <option value="4" <% If unittype_qtyco_idx = "4" Then Response.Write "selected" %> >블랙H/L</option>
                                                    <option value="5" <% If unittype_qtyco_idx = "5" Then Response.Write "selected" %> >블랙,골드</option>
                                                    <option value="6" <% If unittype_qtyco_idx = "6" Then Response.Write "selected" %> >바이브_등</option>
                                                    <option value="7" <% If unittype_qtyco_idx = "7" Then Response.Write "selected" %> >브론즈_등</option>
                                                    <option value="8" <% If unittype_qtyco_idx = "8" Then Response.Write "selected" %> >지급판</option>
                                                    <option value="9" <% If unittype_qtyco_idx = "9" Then Response.Write "selected" %> >AL/도장</option>
                                                    <option value="10" <% If unittype_qtyco_idx = "10" Then Response.Write "selected" %> >AL/블랙</option>
                                                    <option value="11" <% If unittype_qtyco_idx = "11" Then Response.Write "selected" %> >헤어1.5</option>
                                                </select>
                                            </td>

                                            <!-- ✅❌ -->
                                            <td>
                                                <select class="input-field" name="qtycostatus" id="qtycostatus" onchange="handleSelectChange(event, 'qtycostatus', 'qtycostatus')">
                                                    <option value="0" <% If qtycostatus = "0" Then Response.Write "selected" %> >❌</option>
                                                    <option value="1" <% If qtycostatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td>
                                            
                                            <!-- 판재/코일 kg 단가 -->
                                            <td>
                                                <input class="input-field" type="text"  name="kg" id="kg" 
                                                    value="<%=kg%>"  
                                                    onkeypress="handleKeyPress(event, 'kg', 'kg')"/>
                                            </td>

                                            <!-- 판재/코일 두께 -->
                                            <td>
                                                <select class="input-field" name="sheet_t" id="sheet_t" onchange="handleSelectChange(event, 'sheet_t', 'sheet_t')">
                                                    <option value="0" <% If sheet_t = "0" Then Response.Write "selected" %> >❌</option>
                                                    <option value="1" <% If sheet_t = "1" Then Response.Write "selected" %> >0.6t</option>
                                                    <option value="2" <% If sheet_t = "2" Then Response.Write "selected" %> >0.8t</option>
                                                    <option value="3" <% If sheet_t = "3" Then Response.Write "selected" %> >1.2t</option>
                                                    <option value="4" <% If sheet_t = "4" Then Response.Write "selected" %> >1.5t</option>
                                                </select>
                                            </td>

                                            <!-- 판재:가로 -->
                                            <td>
                                                <select class="input-field" name="sheet_w" id="sheet_w" onchange="handleSelectChange(event, 'sheet_w', 'sheet_w')">
                                                    <option value="0" <% If sheet_w = "0" Then Response.Write "selected" %> >1000(1)</option>
                                                    <option value="1" <% If sheet_w = "1" Then Response.Write "selected" %> >1219(4)</option>
                                                </select>
                                            </td>

                                            <!-- 판재:세로 -->
                                            <td>
                                                <input class="input-field" type="text" name="sheet_h" id="sheet_h" 
                                                    value="<%=sheet_h%>" 
                                                    onkeypress="handleKeyPress(event, 'sheet_h', 'sheet_h')" />
                                            </td>

                                            <!-- 코일규격 -->
                                            <td>
                                                <input class="input-field" type="text" name="coil_cut" id="coil_cut" 
                                                    value="<%=coil_cut%>" 
                                                    onkeypress="handleKeyPress(event, 'coil_cut', 'coil_cut')" />
                                            </td>

                                            <!-- 수정자 -->
                                            <td style="text-align:center; vertical-align:middle;"><%=mename%></td>

                                            <!-- 수정일 -->
                                            <td style="text-align:center; vertical-align:middle;"><%=QTYcoewdate%></td>
                                        </tr>


                                            <% else %>
                                        <tr> 
                                            <!--  <td style="text-align:center; vertical-align:middle;"><%=i%></td> -->
                                            <!-- 번호 -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=qtyno%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 판재명 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=qtyname%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 판재회사명 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=QTYcoNAME%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>
                                            <%
                                            'Response.Write "unittype_qtyco_idx=" & unittype_qtyco_idx & "<br>"
                                            %>
                                            <!-- unittype -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=unittype_qtyco_idx_text%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>
                                             
                                            <!-- 상태 (✅ / ❌) -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=qtycostatus_text%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 판재/코일 kg단가 -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=kg%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 판재/코일 두께 -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=sheet_t_text%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 판재:가로 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=sheet_w_text%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 판재:세로 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=sheet_h%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 코일규격 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=coil_cut%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 수정자 -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=mename%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>

                                            <!-- 수정일 -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=QTYcoewdate%>" 
                                                    onclick="location.replace('tng1_stain_item_insertsub.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&qtyco_idx=<%=qtyco_idx%>&searchword=<%=rsearchword%>#<%=qtyco_idx%>');" />
                                            </td>                                            <% end if %>
                                            <%
                                            qtycostatus_text =""
                                            sheet_t_text =""
                                            sheet_w_text =""
                                            cccc=""
                                            Rs.movenext
                                            next
                                            End If 
                                             
                                            %>
                                        <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                                </form>
                            </tbody>
                        </table>
                    </div>
                                        <div class="row">
                      <div  class="col-10 py-3"> 
<!--#include Virtual = "/inc/paging.asp" -->
                      </div>
<%
Rs.Close
%>
<!-- 표 형식 끝--> 

 
    </div>    

    <!--화면 끝-->
        
</div>
</div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs = Nothing
call dbClose()
%>
