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

%>
<%

kw = Request("keyword")

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
<div class="container-fluid px-4">
<div class="row justify-content-between">
<div class="py-5 container text-center  card card-body">
<div class="row">
<div class="col-md-9">
    <form id="Search" name="Search" method="get" class="search">
    <input type="text" name="keyword" value="<%=kw%>" placeholder="검색어">
    <button type="submit">검색</button>
    </form>
</div>
<div class="col-md-3">
    <!-- 우측 상단 링크 -->
    <a href="http://tkd001.cafe24.com/paint_itemin.asp" target="_blank" class="btn btn-success">
        색상등록 바로가기
    </a>
</div>


<table class="table table-bordered">
    <tr>
        <td>
            <div class="item text-danger" onclick="pick('0','없음')">
                0. 없음
            </div>
        </td>
        <td class="text-muted">색상 선택하지 않음</td>
    </tr>

<%

sql = "SELECT pidx, pname ,coat ,p_image ,paint_type FROM tk_paint WHERE pstatus=1"
If kw<>"" Then 
sql = sql & " AND pname LIKE '%" & Replace(kw,"'","''") & "%'"
end if
sql = sql & " ORDER BY "
sql = sql & " CASE "
sql = sql & " WHEN pname LIKE '%지정색%' THEN 0 "
sql = sql & " WHEN pname LIKE '%DJK-051%' THEN 1 "
'sql = sql & " WHEN pname LIKE '%기본%' THEN 2 "
sql = sql & " ELSE 2 END, "
sql = sql & " pidx DESC"
Rs.Open sql, Dbcon
'response.write (SQL)&"<br>"
If Not (Rs.bof or Rs.eof) Then 
Do Until Rs.EOF

    pidx= Rs(0)
    pname= Rs(1)
    coat= Rs(2)
    p_image= Rs(3)
    paint_type= Rs(4)

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
<tr>
    <td>
        <div class="item" onclick="pick('<%=pidx%>','<%=pname%>','<%=coat%>')">
        <%=pname%>
    </td>   
    <td>
        <%=paint_type_text%>, <%=coat_text%>,<img src="/img/paint/<%=p_image%>" loading="lazy" width="170" height="50"  border="0">
    </td> 
    </div>

</tr>
    
<%
Rs.MoveNext
Loop
End If
Rs.close
%>
</table>
</div>
</div>
</div>
</div>

<script>
    function pick(pidx, pname, coat){
        if (window.opener && !window.opener.closed) {
            window.opener.setPaint(pidx, pname, coat);
            window.close();
        }
    }
</script>
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