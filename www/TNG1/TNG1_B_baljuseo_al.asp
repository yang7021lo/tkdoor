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
%>
<%
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

listgubun="one"

projectname="TNG 발주서 알루미늄 자동" 
%>
<%

    rsjidx=request("sjidx")
    rcidx=Request("cidx")
 
	
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
      #text {
        color: #070707;
      }
      #mmaintext {
        height: 200px;
      }      
      #download {
        width: 100px;
      }
      .container {
      display: flex;
      flex-direction: row; /* side by side */
      flex-wrap: wrap; /* allows wrapping if too narrow */
      gap: 10px;
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
    <style>
        .custom-bg {
            background-color: #f8f8f8; /* Bootstrap danger background color */
            'padding: 20px;
            border-radius: 5px;
        }
    </style>
<style>
    table {
      border-collapse: collapse;
      width: 80%;
      margin: 20px auto;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: left;
      position: relative;
    }

    .hover-image {
      display: none;
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateY(-100%);
      width: 250px;
      border: 1px solid #aaa;
      background-color: #fff;
      z-index: 100;
      box-shadow: 0px 0px 5px rgba(0,0,0,0.2);
    }

    .title-cell:hover .hover-image {
      display: block;
    }

    .title-cell {
      cursor: pointer;
    }
  </style>
  <style>
  .image-card-fixed {
    height: 280px; /* 원하는 높이로 조절 */
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .image-card-fixed img {
    max-height: 150px;
    object-fit: contain;
  }
</style>

</head>
<body class="sb-nav-fixed">
    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                    <!--내용입력시작-->
                    <div class=" py-5 text-center card-body">
                        <div class="input-group mb-3">
                            <h6>알루미늄자동 발주서</h6>
                        </div>
                        <div class="row">
                        </div>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>
        <!--Footer 시작-->
        Coded By 양양
        <!--Footer 끝-->
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
