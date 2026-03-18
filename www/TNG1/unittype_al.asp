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



rualidx   = Request("ualidx")

If rualidx = "" OR isnull(rualidx) Then
    rualidx = "0"
End If

Response.Write "rualidx : " & rualidx & "<br>"
'Response.end

	if request("kgotopage")="" then
	kgotopage=1
	else
	kgotopage=request("kgotopage")
	end if
	page_name="unittype_al.asp?SearchWord="&Request("SearchWord")&"&"

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
        .form-control text-center {
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
                location.href="unittype_aldb.asp?part=delete&searchWord=<%=rsearchword%>&ualidx="+sTR;
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
                            <h3>알루미늄자동 프레임 평당 단가 입력</h3>
                        </div>
                        
                    </div>
                    <!-- 제목 나오는 부분 끝-->
                    <div class="row">
<form id="dataForm" action="unittype_aldb.asp" method="POST">
    <div class="row">  
    <div class="col-8" style="border:1px solid #ccc; padding:5px; border-radius:4px;">
    <div class="row">  
        <div class="col-1"><strong>번호</strong></div>
        <div class="col-2"><strong>품명</strong></div>
        <div class="col-1"><strong>규격</strong></div>
        <div class="col-1"><strong>재질</strong></div>
        <div class="col-4"><strong>도면타입</strong></div>
        <div class="col-1"><strong>단가</strong></div>
        <div class="col-1"><strong>단가</strong></div>
    </div>
        <%
        SQL = "SELECT A.ualidx"
        SQL = SQL & ", A.SJB_IDX, A.sjbtidx, B.SJB_TYPE_NO, B.SJB_TYPE_NAME"
        SQL = SQL & ", A.QTYIDX, A.qtyco_idx, C.QTYNo, C.QTYNAME"
        SQL = SQL & ", A.fidx, D.fname"
        SQL = SQL & ", A.price_bk, A.price_etl, A.upstatus"
        SQL = SQL & ", E.mname, F.mname"
        SQL = SQL & ", S.SJB_barlist"
        SQL = SQL & " FROM tng_unitprice_al A"
        SQL = SQL & " LEFT JOIN tng_sjbtype B ON A.sjbtidx = B.sjbtidx"
        SQL = SQL & " LEFT JOIN tk_qtyco C ON A.qtyco_idx = C.qtyco_idx"
        SQL = SQL & " LEFT JOIN tk_frame D ON A.fidx = D.fidx"
        SQL = SQL & " LEFT JOIN TNG_SJB S ON A.SJB_IDX = S.SJB_IDX"
        SQL = SQL & " LEFT JOIN tk_member E ON S.SJB_midx = E.midx"
        SQL = SQL & " LEFT JOIN tk_member F ON S.SJB_meidx = F.midx"
        SQL = SQL & " WHERE A.upstatus = 1"
        SQL = SQL & " ORDER BY A.ualidx ASC, A.fidx ASC"
        'response.write (Sql)&"<br>"
        Rs.open Sql,Dbcon,1,1,1
        if not (Rs.EOF or Rs.BOF ) then
        Do while not Rs.EOF

        ualidx        = Rs(0)
        SJB_IDX       = Rs(1)
        sjbtidx       = Rs(2)
        SJB_TYPE_NO   = Rs(3)
        SJB_TYPE_NAME = Rs(4)
        QTYIDX        = Rs(5)
        qtyco_idx     = Rs(6)
        QTYNo         = Rs(7)
        QTYNAME       = Rs(8)
        fidx          = Rs(9)
        fname         = Rs(10)
        price_bk      = Rs(11)
        price_etl     = Rs(12)
        upstatus      = Rs(13)
        mname         = Rs(14)
        mename        = Rs(15)
        SJB_barlist   = Rs(16)

        i=i+1
        %>
        <% if cint(ualidx)=cint(rualidx)  then %>
            <input type="hidden" name="ualidx" value="<%=ualidx%>">
            <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
            <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
            <div class="row">  
                
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=ualidx%>" />
                </div>
                <div class="col-2">
                    <input class="form-control text-center" type="text" value="<%=SJB_TYPE_NAME%>" />
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=SJB_barlist%>" />                
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=QTYNAME%>" />                
                </div>
                <div class="col-4">
                    <input class="form-control text-center" type="text" value="<%=fname%>" />                
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="number" name="price_bk" id="price_bk" value="<%=price_bk%>" 
                    onkeypress="handleKeyPress(event, 'price_bk', 'price_bk')"/>
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="number" name="price_etl" id="price_etl" value="<%=price_etl%>" 
                    onkeypress="handleKeyPress(event, 'price_etl', 'price_etl')"/>
                </div>
            </div>    
        <% else %> 
            <div class="row">  

                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=ualidx%>" 
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>
                </div>
                <div class="col-2">
                    <input class="form-control text-center" type="text" value="<%=SJB_TYPE_NAME%>"  
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=SJB_barlist%>"   
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>               
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=QTYNAME%>"   
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>               
                </div>
                <div class="col-4">
                    <input class="form-control text-center" type="text" value="<%=fname%>"   
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>             
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=price_bk%>"   
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>               
                </div>
                <div class="col-1">
                    <input class="form-control text-center" type="text" value="<%=price_etl%>"   
                    onclick="location.replace('unittype_al.asp?kgotopage=<%=kgotopage%>&ualidx=<%=ualidx%>&searchWord=<%=rsearchword%>#<%=ualidx%>');"/>                
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

        <div class="col-4" style="border:1px solid #aaa; padding:5px; border-radius:4px; background:#f9f9f9;">
            <!-- ✅ 여기가 추가 4칸 영역입니다 -->
            <div class="mb-2"><strong>추가 정보</strong></div>
            <div class="mb-2">
                <label>추가필드1</label>
                <input type="text" class="form-control form-control-sm" name="extra1">
            </div>
            <div class="mb-2">
                <label>추가필드2</label>
                <input type="text" class="form-control form-control-sm" name="extra2">
            </div>
        </div>
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
