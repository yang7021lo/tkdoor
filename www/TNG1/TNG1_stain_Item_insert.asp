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
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

part=Request("part")

' 파일 및 폼 데이터 읽기
rSearchWord    = Request("SearchWord")
kgotopage    = Request("kgotopage")
' 🔹 추가된 컬럼들 - 모두 r 접두어 적용
' 🔹 tk_qty 테이블 기준 변수
rqtyidx     = Request("qtyidx")



'Response.Write "rqtyidx : " & rqtyidx & "<br>"
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

	if request("kgotopage")="" then
	kgotopage=1
	else
	kgotopage=request("kgotopage")
	end if
	page_name="TNG1_stain_Item_insert.asp?SearchWord="&Request("SearchWord")&"&"

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
                location.href="TNG1_STAIN_ITEM_Insertdb.asp?part=delete&searchWord=<%=rsearchword%>&qtyidx="+sTR;
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
                            <form id="Search" name="Search" action="TNG1_stain_Item_insert.asp" method="POST">
                                <div class="input-group mb-3">
                                    <button type="button"
                                        class="btn btn-outline-danger"
                                        onclick="location.replace('TNG1b.asp');">돌아가기
                                    </button>
                                    <input type="text" class="form-control"   style="height: 36px;" name="SearchWord" value="<%=Request("SearchWord")%>">
                                    <button type="button" class="btn btn-outline-success"  onclick="submit();">검색</button>
                                    <button type="button" class="btn btn-outline-danger" Onclick="location.replace('TNG1_stain_Item_insert.asp?qtyidx=0');">등록</button>
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
                                    <th width="40" style="text-align:center; vertical-align:middle;">번호</th>
                                    <th width="160"  style="text-align:center; vertical-align:middle;">판재명</th>
                                    
                                    <th width="40"  style="text-align:center; vertical-align:middle;">✅사용<br>❌안함</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">도어기본단가</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">판재/코일 단가/Kg</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">판재/코일 두께</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">로비폰단가(1175)</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">로비폰단가(1175↑)</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">단가</th>
                                    <th width="40" style="text-align:center; vertical-align:middle;">수정자</th>
                                    <th width="40"  style="text-align:center; vertical-align:middle;">수정일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <form id="dataForm" action="TNG1_STAIN_ITEM_Insertdb.asp" method="POST">   
                                    <input type="hidden" name="qtyidx" value="<%=rqtyidx%>">
                                    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                                    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">

                                    <% if rqtyidx="0" then
                                    cccc="#800080"
                                    %>
                                        <tr>
                                            
                                            <%
                                            ' 🔹 새로운 QTYNo 번호 구하기
                                                SQL = "SELECT ISNULL(MAX(QTYNo), 0) + 1 FROM tk_qty"
                                                Rs.Open SQL, Dbcon
                                                If Not (Rs.EOF Or Rs.BOF) Then
                                                    rQTYNo = Rs(0)
                                                End If
                                                Rs.Close
                                            %>
                                            <td>
                                            <input class="input-field" type="text" size="3"  name="QTYNo" id="QTYNo" value="<%=rQTYNo%>" onkeypress="handleKeyPress(event, 'QTYNo', 'QTYNo')"/>
                                            </td> 

                                            <td>
                                            
                                                <select class="input-field" name="QTYNAME" id="QTYNAME"  onchange="handleChange(this)">
                                                        <%

                                                        sql = "SELECT a.qtyco_idx, a.QTYNo, a.QTYNAME, a.QTYcoNAME, a.QTYcostatus from tk_qtyco a "
                                                        sql = sql & "JOIN (SELECT MIN(qtyco_idx) AS min_idx FROM tk_qtyco WHERE QTYcostatus='1' GROUP BY QTYNo) b "
                                                        sql = sql & "ON a.qtyco_idx = b.min_idx "

                                                        'response.write (Sql)&"<br>"
                                                        Rs1.open Sql,Dbcon,1,1,1
                                                        If Not (Rs1.bof or Rs1.eof) Then 
                                                        Do until Rs1.EOF

                                                            qtyco_idx        = rs1(0)
                                                            kqtyno        = rs1(1)
                                                            kQTYNAME        = rs1(2)

                                                        %>
                                                        <option value="<%=kqtyno%>"  >
                                                            <%=kQTYNAME%>
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
                                                        'TNG1_stain_Item_insertsub.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&SearchWord=<%=rSearchWord%>#<%=QTYIDX%>', 
                                                        'typeInsert', 
                                                        'top=0,left=0,width=' + screen.availWidth + ',height=' + screen.availHeight + ',scrollbars=yes,resizable=yes'
                                                        )">
                                                        + 추가
                                                    </button>
                                                </td>
                                            <td></td>
                                            <td>
                                                <select class="input-field" name="qtystatus" id="qtystatus"  onchange="handleSelectChange(event, 'qtystatus', 'qtystatus')">
                                                    <option value="1" <% If qtystatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td> 
                                            <!-- kg당 단가 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input type="text" name="kg" id="kg"
                                                        value="<%=kg%>"
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'kg', 'kg')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>

                                        </tr>
                                    <% end if %>
                                            <%
                                            i=0
                                            cccc=""
                                            sql = "SELECT A.QTYIDX, A.QTYNo, D.QTYNAME, D.QTYcoNAME, D.QTYcostatus "
                                            sql = sql & ", A.QTYSTATUS, A.QTYPAINT, A.QTYINS, A.QTYLABEL, A.QTYPAINTW "
                                            sql = sql & ", A.QTYmidx, Convert(varchar(10), A.QTYwdate, 121) "
                                            sql = sql & ", A.QTYemidx, Convert(varchar(10), A.QTYewdate, 121) "
                                            sql = sql & ", A.qtype, A.taidx, A.ATYPE, A.qtyprice "
                                            sql = sql & ", B.mname, C.mname , A.kg , A.sheet_t ,a.robbyprice1 , a.robbyprice2,a.doorbase_price "
                                            sql = sql & "FROM tk_qty A "
                                            sql = sql & "JOIN tk_member B ON A.QTYmidx = B.midx "
                                            sql = sql & "LEFT OUTER JOIN tk_member C ON A.QTYemidx = C.midx "
                                            sql = sql & "LEFT OUTER JOIN ( "
                                            sql = sql & "    SELECT D.* FROM tk_qtyco D "
                                            sql = sql & "    INNER JOIN ( "
                                            sql = sql & "        SELECT QTYNo, MIN(qtyco_idx) AS min_idx "
                                            sql = sql & "        FROM tk_qtyco "
                                            sql = sql & "        WHERE QTYcostatus = 1 "
                                            sql = sql & "        GROUP BY QTYNo "
                                            sql = sql & "    ) AS Dsub ON D.qtyco_idx = Dsub.min_idx "
                                            sql = sql & ") AS D ON A.QTYNo = D.QTYNo "
                                            sql = sql & "WHERE A.QTYIDX <> '' "
                                            If Request("SearchWord") <> "" Then
                                                sql = sql & "AND ( D.QTYNAME LIKE '%" & Request("SearchWord") & "%' "
                                                sql = sql & "OR D.QTYcoNAME LIKE '%" & Request("SearchWord") & "%' ) "
                                            End If
                                            sql = sql & "ORDER BY A.QTYIDX DESC"
                                            'response.write (SQL)&"<br>"
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
                                            qtyidx     = Rs(0)
                                            QTYNo      = Rs(1)
                                            yQTYNAME   = Rs(2)  ' tk_qtyco에서 가져온 이름
                                            yQTYcoNAME = Rs(3)
                                            yQTYcostatus = Rs(4)
                                            QTYSTATUS  = Rs(5)
                                            QTYPAINT   = Rs(6)
                                            QTYINS     = Rs(7)
                                            QTYLABEL   = Rs(8)
                                            QTYPAINTW  = Rs(9)
                                            QTYmidx    = Rs(10)
                                            QTYwdate   = Rs(11)
                                            QTYemidx   = Rs(12)
                                            QTYewdate  = Rs(13)
                                            qtype      = Rs(14)
                                            taidx      = Rs(15)
                                            ATYPE      = Rs(16)
                                            qtyprice   = Rs(17)
                                            mname      = Rs(18)
                                            mename     = Rs(19)
                                            kg         = Rs(20)
                                            sheet_t    = Rs(21)
                                            robbyprice1= Rs(22)
                                            robbyprice2= Rs(23)
                                            doorbase_price=Rs(24)


                                                select case qtystatus
                                                    case "0"
                                                        qtystatus_text="❌"
                                                    case "1"
                                                        qtystatus_text="✅"
                                                end select
                                                select case sheet_t
                                                    case "0"
                                                        sheet_t_text="없음"                                                
                                                    case "1"
                                                        sheet_t_text="0.6t"
                                                    case "2"
                                                        sheet_t_text="0.8t"
                                                    case "3"
                                                        sheet_t_text="1.2t"
                                                    case "4"
                                                        sheet_t_text="1.5t"

                                                end select
                                                i=i+1
                                            %>
                                                          
                                            <% 
                                            'Response.Write "rqtyidx : " & rqtyidx & "<br>"
                                            if int(qtyidx)=int(rqtyidx) then 
                                            cccc="#E7E7E7"
                                            
                                            %>
                                        <tr>
                                            <!-- 번호 + 삭제 버튼 + 번호 입력 -->

                                            <td align="center"><a name="<%=qtyidx%>">-><button type="button" class="btn btn-outline-danger" Onclick="del('<%=qtyidx%>');"><%=qtyidx%></button></td> 
                                           
                                            <!-- 판재번로를 받아서 판재명 -->
                                            <td>
                                            

                                                <select class="input-field" name="qtyno" id="qtyno"  onchange="handleChange(this)">
                                                        <%
                                                        sql = "SELECT a.qtyco_idx, a.QTYNo, a.QTYNAME, a.QTYcoNAME, a.QTYcostatus from tk_qtyco a "
                                                        sql = sql & "JOIN (SELECT MIN(qtyco_idx) AS min_idx FROM tk_qtyco WHERE QTYcostatus='1' GROUP BY QTYNo) b "
                                                        sql = sql & "ON a.qtyco_idx = b.min_idx "
                                                        'response.write (Sql)&"<br>"
                                                        Rs1.open Sql,Dbcon,1,1,1
                                                        If Not (Rs1.bof or Rs1.eof) Then 
                                                        Do until Rs1.EOF

                                                            qtyco_idx        = rs1(0)
                                                            yqtyno        = rs1(1)
                                                            yQTYNAME        = rs1(2)

                                                        %>
                                                        <option value="<%=yqtyno%>" <% If cint(qtyno) = cint(yqtyno) Then Response.Write "selected" End If %> >
                                                            <%=yQTYNAME%> 
                                                            <%
                                                            'response.write "qtyno : "&qtyno&"<br>"
                                                            'response.write "yqtyno : "&yqtyno&"<br>"
                                                            %>
                                                        </option>
                                                        <%
                                                        Rs1.MoveNext
                                                        Loop
                                                        End If
                                                        Rs1.close
                                                        %>
                                                    </select>
                                                </td> 

                                            <!-- ✅❌ -->
                                            <td>
                                                <select class="input-field" name="qtystatus" id="qtystatus" onchange="handleSelectChange(event, 'qtystatus', 'qtystatus')">
                                                    <option value="0" <% If qtystatus = "0" Then Response.Write "selected" %> >❌</option>
                                                    <option value="1" <% If qtystatus = "1" Then Response.Write "selected" %> >✅</option>
                                                </select>
                                            </td>
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input type="number" name="doorbase_price" id="doorbase_price"
                                                        value="<%=doorbase_price%>"
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'doorbase_price', 'doorbase_price')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>
                                            <!-- kg당 단가 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input type="text" name="kg" id="kg"
                                                        value="<%=kg%>"
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'kg', 'kg')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
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
                                            <!-- 로비폰단가 1 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input class="input-field" type="text" name="robbyprice1" id="robbyprice1"
                                                        value="<%=robbyprice1%>" 
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'robbyprice1', 'robbyprice1')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>
                                            <!-- 로비폰단가 2 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input class="input-field" type="text" name="robbyprice2" id="robbyprice2"
                                                        value="<%=robbyprice2%>" 
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'robbyprice2', 'robbyprice2')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>
                                            <!-- 단가 -->
                                            <td>
                                                <div style="display:flex; align-items:center;">
                                                    <input class="input-field" type="text" name="qtyprice" id="qtyprice"
                                                        value="<%=qtyprice%>" 
                                                        style="width:80px; text-align:right;"
                                                        onkeypress="handleKeyPress(event, 'qtyprice', 'qtyprice')" />
                                                    <span style="margin-left:4px;">원</span>
                                                </div>
                                            </td>

                                            <!-- 수정자 -->
                                            <td style="text-align:center; vertical-align:middle;"><%=mename%></td>

                                            <!-- 수정일 -->
                                            <td style="text-align:center; vertical-align:middle;"><%=QTYewdate%></td>
                                        </tr>


                                            <% else %>
                                        <tr> 
                                            <!--  <td style="text-align:center; vertical-align:middle;"><%=i%></td> -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=qtyno%>" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 판재명 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=yqtyname%>" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 상태 (✅ / ❌) -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=qtystatus_text%>" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=doorbase_price%>원" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 판재/코일 kg단가 -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=kg%>원" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 판재/코일 두께 -->
                                            <td>
                                                <input class="input-field" type="text" readonly 
                                                    value="<%=sheet_t_text%>" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>
                                            <!-- 로비폰1 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=robbyprice1%>원" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>
                                            <!-- 로비폰2 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=robbyprice2%>원" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 단가 -->
                                            <td>
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=qtyprice%>원" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 수정자 -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=mename%>" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>

                                            <!-- 수정일 -->
                                            <td style="text-align:center; vertical-align:middle;">
                                                <input class="input-field" type="text"  readonly 
                                                    value="<%=QTYewdate%>" 
                                                    onclick="location.replace('tng1_stain_item_insert.asp?kgotopage=<%=kgotopage%>&qtyidx=<%=qtyidx%>&searchword=<%=rsearchword%>#<%=qtyidx%>');" />
                                            </td>                                            
                                            <% end if %>
                                            <%
                                            qtystatus_text =""
                                            cccc=""
                                            Rs.movenext
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
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
