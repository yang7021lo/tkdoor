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


rpcent   = Request("pcent")
rSJB_IDX   = Request("SJB_IDX")
rSJB_TYPE_NAME   = Request("SJB_TYPE_NAME")
rsjbtidx   = Request("sjbtidx")
rSJB_barlist = Request("SJB_barlist")

If rSJB_IDX = "" OR isnull(rSJB_IDX) Then
    rSJB_IDX = "0"
End If
If runittype_qtyco_idx = "" OR isnull(runittype_qtyco_idx)  Then
    runittype_qtyco_idx = "0"
End If
If runittype_bfwidx = "" OR isnull(runittype_bfwidx) Then
    runittype_bfwidx = "0"
End If
'Response.Write "ruptidx : " & ruptidx & "<br>"
'Response.Write "ruptidx : " & ruptidx & "<br>"
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
	page_name="unittypeA.asp?SearchWord="&Request("SearchWord")&"&"

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
                location.href="unittypedb.asp?part=delete&searchWord=<%=rsearchword%>&uptidx="+sTR;
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
                            <h3>자동 프레임 단가 입력</h3>
                        </div>
                        
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                    <div class="row">
<form id="dataForm" action="unittypedb_pa.asp" method="POST">
    <div class="row justify-content-between  mt-2">
    <div class="col-4" style="border:1px solid #ccc; padding:5px; border-radius:4px;">
    <h5 class="text-primary">■ 1차 </h5>
    <div class="row justify-content-between mt-2">
        <div class="col-3"><strong>품명</strong></div>
        <div class="col-3"><strong>규격</strong></div>
        <div class="col-3"><strong>프로티지</strong></div>
        <div class="col-3"><strong>insert</strong></div>
    </div>
        <%
        '🔹 1차: X45만 가져오기
        SQL = "SELECT A.SJB_IDX, A.SJB_TYPE_NO, D.SJB_TYPE_NAME "
        SQL = SQL & ", A.SJB_barlist, A.SJB_Paint, A.SJB_St, A.SJB_Al "
        SQL = SQL & ", A.SJB_midx, Convert(varchar(10), A.SJB_mdate, 121) AS SJB_mdate "
        SQL = SQL & ", A.SJB_meidx, Convert(varchar(10), A.SJB_medate, 121) AS SJB_medate "
        SQL = SQL & ", B.mname, C.mname, A.SJB_FA "
        SQL = SQL & ", D.sjbtidx, A.pcent "  
        SQL = SQL & " FROM TNG_SJB A "
        SQL = SQL & " JOIN tk_member B ON A.SJB_midx = B.midx "
        SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.SJB_meidx = C.midx "
        SQL = SQL & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
        SQL = SQL & " WHERE A.SJB_FA = 2 "
        SQL = SQL & " AND right(A.SJB_barlist,3)='X45' "
        SQL = SQL & " AND A.SJB_TYPE_NO NOT IN ('8', '9') "
        SQL = SQL & " ORDER BY D.sjbtidx ASC, A.SJB_IDX aSC"
        'response.write (Sql)&"<br>"
        Rs.open Sql,Dbcon,1,1,1
        if not (Rs.EOF or Rs.BOF ) then
        Do while not Rs.EOF

        SJB_IDX        = Rs(0)
        SJB_TYPE_NO    = Rs(1)
        SJB_TYPE_NAME = Rs(2)   ' 조인 결과로 바로 가져옴
        SJB_barlist    = Rs(3)
        SJB_Paint      = Rs(4)
        SJB_St         = Rs(5)
        SJB_Al         = Rs(6)
        SJB_midx       = Rs(7)
        SJB_mdate      = Rs(8)
        SJB_meidx      = Rs(9)
        SJB_medate     = Rs(10)
        mname          = Rs(11)
        mename         = Rs(12)
        SJB_FA         = Rs(13)
        sjbtidx        = Rs(14)
        pcent          = Rs(15)

            bar = right(SJB_barlist,3)
        i=i+1
        %>
        <% if cint(SJB_IDX)=cint(rSJB_IDX)  then %>
            <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
            <input type="hidden" name="sjbtidx" value="<%=rsjbtidx%>">
            <input type="hidden" name="SJB_TYPE_NAME" value="<%=rSJB_TYPE_NAME%>">
            <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
            <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
            <input type="hidden" name="SJB_barlist" value="<%=SJB_barlist%>">      
            <input type="hidden" name="SJB_TYPE_No" value="<%=SJB_TYPE_No%>"> 
            <div class="row justify-content-between  mt-2">
                
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_TYPE_NAME%>" 
                    onclick="window.open('unittypeA_new.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'popup', 'width=1920,height=700,scrollbars=yes');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_barlist%>" 
                    onclick="window.open('unittypeA_new.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'popup', 'width=1920,height=700,scrollbars=yes');" />
                </div>
                <div class="col-3">    
                    <input class="input-field" type="text"  name="pcent" id="pripcentce" value="<%=pcent%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/>
                </div>
                <div class="col-3">
                <% if pcent=1 then %>
                    <button type="button" class="btn btn-primary btn-sm"
                        onclick="window.open('unittype_la.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'pcentWindow', 'width=1200,height=1200,scrollbars=yes');">
                        pcent_insert
                    </button>
                <% end if %> 
                <% if pcent=0 then %>
                    <button type="button" class="btn btn-dark btn-sm"> 기본값(insert X) </button>
                <% end if %>     
                </div>
            </div>    
        <% else %> 
            <div class="row justify-content-between  mt-2">  

                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_TYPE_NAME%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_barlist%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=pcent%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                <% if pcent=1 then %>
                    <button type="button" class="btn btn-primary btn-sm"
                        onclick="window.open('unittype_la.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>>&bar=<%=bar%>', 'pcentWindow', 'width=1200,height=1200,scrollbars=yes');">
                        pcent_insert
                    </button>
                <% end if %> 
                <% if pcent=0 then %>
                    <button type="button" class="btn btn-dark btn-sm"> 기본값(insert X) </button>
                <% end if %>    
                </div>
            </div>
        <% end if %>
        
        <%
        Rs.movenext
        Loop
        End If 
        Rs.Close 
        %>  
        </div>
        <div class="col-4" style="border:1px solid #ccc; padding:5px; border-radius:4px;">
            <h5 class="text-success">■ 2차 (스텐 단열자동 45)</h5>
            <div class="row justify-content-between mt-2">
                <div class="col-3"><strong>품명</strong></div>
                <div class="col-3"><strong>규격</strong></div>
                <div class="col-3"><strong>프로티지</strong></div>
                <div class="col-3"><strong>insert</strong></div>
            </div>
        <%
        '🔹 2차: X60만 가져오기                    
        SQL = "SELECT A.SJB_IDX, A.SJB_TYPE_NO, D.SJB_TYPE_NAME "
        SQL = SQL & ", A.SJB_barlist, A.SJB_Paint, A.SJB_St, A.SJB_Al "
        SQL = SQL & ", A.SJB_midx, Convert(varchar(10), A.SJB_mdate, 121) AS SJB_mdate "
        SQL = SQL & ", A.SJB_meidx, Convert(varchar(10), A.SJB_medate, 121) AS SJB_medate "
        SQL = SQL & ", B.mname, C.mname, A.SJB_FA "
        SQL = SQL & ", D.sjbtidx, A.pcent "  
        SQL = SQL & " FROM TNG_SJB A "
        SQL = SQL & " JOIN tk_member B ON A.SJB_midx = B.midx "
        SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.SJB_meidx = C.midx "
        SQL = SQL & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
        SQL = SQL & " WHERE A.SJB_FA = 2 "
        SQL = SQL & " AND A.SJB_TYPE_NO = 8 "

        SQL = SQL & " ORDER BY D.sjbtidx ASC, A.SJB_IDX aSC"
        'response.write (Sql)&"<br>"
        Rs.open Sql,Dbcon,1,1,1
        if not (Rs.EOF or Rs.BOF ) then
        Do while not Rs.EOF

        SJB_IDX        = Rs(0)
        SJB_TYPE_NO    = Rs(1)
        SJB_TYPE_NAME = Rs(2)   ' 조인 결과로 바로 가져옴
        SJB_barlist    = Rs(3)
        SJB_Paint      = Rs(4)
        SJB_St         = Rs(5)
        SJB_Al         = Rs(6)
        SJB_midx       = Rs(7)
        SJB_mdate      = Rs(8)
        SJB_meidx      = Rs(9)
        SJB_medate     = Rs(10)
        mname          = Rs(11)
        mename         = Rs(12)
        SJB_FA         = Rs(13)
        sjbtidx        = Rs(14)
        pcent          = Rs(15)

                    bar = right(SJB_barlist,3)

        i=i+1
        %>
        <% if cint(SJB_IDX)=cint(rSJB_IDX)  then %>
            <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
            <input type="hidden" name="sjbtidx" value="<%=rsjbtidx%>">
            <input type="hidden" name="SJB_TYPE_NAME" value="<%=rSJB_TYPE_NAME%>">
            <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
            <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
            <input type="hidden" name="SJB_barlist" value="<%=SJB_barlist%>">
            <input type="hidden" name="SJB_TYPE_No" value="<%=SJB_TYPE_No%>"> 
            <div class="row justify-content-between  mt-2">
                
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_TYPE_NAME%>" 
                    onclick="window.open('unittypeA_new.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'popup', 'width=1920,height=700,scrollbars=yes');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_barlist%>" 
                    onclick="window.open('unittypeA_new.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'popup', 'width=1920,height=700,scrollbars=yes');" />
                </div>
                <div class="col-3">    
                    <input class="input-field" type="text"  name="pcent" id="pripcentce" value="<%=pcent%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/>
                </div>
                <div class="col-3">
                <% if pcent=1 then %>
                    <button type="button" class="btn btn-primary btn-sm"
                        onclick="window.open('unittype_la.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'pcentWindow', 'width=1200,height=1200,scrollbars=yes');">
                        pcent_insert
                    </button>
                <% end if %> 
                <% if pcent=0 then %>
                    <button type="button" class="btn btn-dark btn-sm"> 기본값(insert X) </button>
                <% end if %>     
                </div>
            </div>    
        <% else %> 
            <div class="row justify-content-between  mt-2">  

                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_TYPE_NAME%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_barlist%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=pcent%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                <% if pcent=1 then %>
                    <button type="button" class="btn btn-primary btn-sm"
                        onclick="window.open('unittype_la.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>>&bar=<%=bar%>', 'pcentWindow', 'width=1200,height=1200,scrollbars=yes');">
                        pcent_insert
                    </button>
                <% end if %> 
                <% if pcent=0 then %>
                    <button type="button" class="btn btn-dark btn-sm"> 기본값(insert X) </button>
                <% end if %>    
                </div>
            </div>
        <% end if %>

        <%
        Rs.movenext
        Loop
        End If 
        Rs.Close 
        %>  
        </div>
        <div class="col-4" style="border:1px solid #ccc; padding:5px; border-radius:4px;">
                <h5 class="text-muted">■ 3차 (삼중&기타)</h5>
            <div class="row justify-content-between mt-2">
                <div class="col-3"><strong>품명</strong></div>
                <div class="col-3"><strong>규격</strong></div>
                <div class="col-3"><strong>프로티지</strong></div>
                <div class="col-3"><strong>insert</strong></div>
            </div>
        <%
        '🔹 3차: X45도 X60도 아닌 것           
        SQL = "SELECT A.SJB_IDX, A.SJB_TYPE_NO, D.SJB_TYPE_NAME "
        SQL = SQL & ", A.SJB_barlist, A.SJB_Paint, A.SJB_St, A.SJB_Al "
        SQL = SQL & ", A.SJB_midx, Convert(varchar(10), A.SJB_mdate, 121) AS SJB_mdate "
        SQL = SQL & ", A.SJB_meidx, Convert(varchar(10), A.SJB_medate, 121) AS SJB_medate "
        SQL = SQL & ", B.mname, C.mname, A.SJB_FA "
        SQL = SQL & ", D.sjbtidx, A.pcent "  
        SQL = SQL & " FROM TNG_SJB A "
        SQL = SQL & " JOIN tk_member B ON A.SJB_midx = B.midx "
        SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.SJB_meidx = C.midx "
        SQL = SQL & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
        SQL = SQL & " WHERE A.SJB_FA = 2 "
        SQL = SQL & " AND A.SJB_TYPE_NO = 9 "
        SQL = SQL & " ORDER BY D.sjbtidx ASC, A.SJB_IDX aSC"
        'response.write (Sql)&"<br>"
        Rs.open Sql,Dbcon,1,1,1
        if not (Rs.EOF or Rs.BOF ) then
        Do while not Rs.EOF

        SJB_IDX        = Rs(0)
        SJB_TYPE_NO    = Rs(1)
        SJB_TYPE_NAME = Rs(2)   ' 조인 결과로 바로 가져옴
        SJB_barlist    = Rs(3)
        SJB_Paint      = Rs(4)
        SJB_St         = Rs(5)
        SJB_Al         = Rs(6)
        SJB_midx       = Rs(7)
        SJB_mdate      = Rs(8)
        SJB_meidx      = Rs(9)
        SJB_medate     = Rs(10)
        mname          = Rs(11)
        mename         = Rs(12)
        SJB_FA         = Rs(13)
        sjbtidx        = Rs(14)
        pcent          = Rs(15)
        
                    bar = right(SJB_barlist,3)

        i=i+1
        %>

        <% if cint(SJB_IDX)=cint(rSJB_IDX)  then %>
        
            <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
            <input type="hidden" name="sjbtidx" value="<%=rsjbtidx%>">
            <input type="hidden" name="SJB_TYPE_NAME" value="<%=rSJB_TYPE_NAME%>">
            <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
            <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
            <input type="hidden" name="SJB_barlist" value="<%=SJB_barlist%>">
            <input type="hidden" name="SJB_TYPE_No" value="<%=SJB_TYPE_No%>"> 
            <div class="row justify-content-between  mt-2">
                
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_TYPE_NAME%>" 
                    onclick="window.open('unittypeA_new.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'popup', 'width=1920,height=700,scrollbars=yes');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_barlist%>" 
                    onclick="window.open('unittypeA_new.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'popup', 'width=1920,height=700,scrollbars=yes');" />
                </div>
                <div class="col-3">    
                    <input class="input-field" type="text"  name="pcent" id="pripcentce" value="<%=pcent%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/>
                </div>
                <div class="col-3">
                <% if pcent=1 then %>
                    <button type="button" class="btn btn-primary btn-sm"
                        onclick="window.open('unittype_la.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>', 'pcentWindow', 'width=1200,height=1200,scrollbars=yes');">
                        pcent_insert
                    </button>
                <% end if %> 
                <% if pcent=0 then %>
                    <button type="button" class="btn btn-dark btn-sm"> 기본값(insert X) </button>
                <% end if %>     
                </div>
            </div>    
        <% else %> 
            <div class="row justify-content-between  mt-2">  

                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_TYPE_NAME%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=SJB_barlist%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                    <input class="form-control" type="text" value="<%=pcent%>" onclick="location.replace('unittype_pa.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>&bar=<%=bar%>');" />
                </div>
                <div class="col-3">
                <% if pcent=1 then %>
                    <button type="button" class="btn btn-primary btn-sm"
                        onclick="window.open('unittype_la.asp?SJB_IDX=<%=SJB_IDX%>&SJB_TYPE_No=<%=SJB_TYPE_No%>&SJB_barlist=<%=SJB_barlist%>&pcent=<%=pcent%>>&bar=<%=bar%>', 'pcentWindow', 'width=1200,height=1200,scrollbars=yes');">
                        pcent_insert
                    </button>
                <% end if %> 
                <% if pcent=0 then %>
                    <button type="button" class="btn btn-dark btn-sm"> 기본값(insert X) </button>
                <% end if %>    
                </div>
            </div>
        <% end if %>

        <%
        Rs.movenext
        Loop
        End If 
        Rs.Close 
        %>  
        </div>
        <%
        'Response.Write "SJB_TYPE_NAME : " & rSJB_TYPE_NAME & "<br>"
        'Response.Write "SJB_barlist : " & rSJB_barlist & "<br>"
        %>
        </div>
    </div>    
<button type="submit" id="hiddenSubmit" style="display: none;"></button>

</form>        


    <!--화면 끝-->
        
</div>



                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 


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
