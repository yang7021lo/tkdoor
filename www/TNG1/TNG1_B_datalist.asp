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

projectname="원본 파일 리스트" 
%>
<%

    rsjidx=request("sjidx")
    rcidx=Request("cidx")
 
	page_name="TNG1_B_datalist.asp?"
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
    height: 350px; /* 원하는 높이로 조절 */
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .image-card-fixed img {
    max-height: 400px;
    object-fit: contain;
  }
</style>
    <script>
        function confirmDelete(puidx) {
            if (confirm("사진을 삭제하시겠습니까?")) {
                location.replace("picdelete.asp?puidx=" + puidx + "&cidx=<%=rcidx%>&sjidx=<%=rsjidx%>");
            }
        }

        function confirmDelete2(fpfidx) {
            if (confirm("사진을 삭제하시겠습니까?")) {
                location.replace("picdelete.asp?pfidx=" + fpfidx + "&cidx=<%=rcidx%>&sjidx=<%=rsjidx%>");
            }
        }

        function confirmDelete3(pdfpfidx) {
            if (confirm("사진을 삭제하시겠습니까?")) {
                location.replace("picdelete.asp?pfidx=" + pdfpfidx + "&cidx=<%=rcidx%>&sjidx=<%=rsjidx%>");
            }
        }

        function confirmDelete4(pfidx) {
            if (confirm("파일을 삭제하시겠습니까?")) {
                location.replace("picdelete.asp?pfidx=" + pfidx + "&cidx=<%=rcidx%>&sjidx=<%=rsjidx%>");
            }
        }

    function smwindow(str){
        newwin=window.open(str,'win1', 'scrollbars=yes,menubar=no,statusbar=no,status=no,width=990,height=800,top=200,left=200');
        newwin.focus();
    }
    </script>
</head>
<body class="sb-nav-fixed">
    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                    <!--내용입력시작-->
                    <div class=" py-5 text-center card-body">
                        <div class="input-group mb-3">
                            <h6>원본 리스트</h6>
                        </div>
                        <div class="input-group mb-2">
                                <div class="card form-control">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th class="text-center">첨부된 파일</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                            SQL="SELECT pfname, pfidx from tk_picfiles Where sjidx='"&rsjidx&"' and pfstatus='1' "
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                pfname=RS(0)
                                                pfidx=Rs(1)
                                            %>
                                                <tr>
                                                    <td><p onclick="window.open('/img/frame/pufile/<%=rsjidx%>/<%=pfname%>', 'previewImage', 'width=800,height=800,scrollbars=yes');"><%=pfname%></p>&nbsp;<button type="button" onclick="confirmDelete4(<%=pfidx%>)">삭제</button></td>
                                                </tr>
                                            <%
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %>
                                        </tbody>  
                                        </table> 
                                    </div>
                            </div>                         
                        <div class="input-group mb-2">
                                <span class="input-group-text">메모</span>
                                    <div class="form-control text-start" style="width:15%;padding:5 5 5 5;">
                                        <div class="form-control text-start " style="width:100%;height:100%;padding:5 5 5 5;">
                                            <%
                                            SQL="SELECT pmemo from Tk_picmemo Where sjidx='"&rsjidx&"' "
                                            
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                                pmemo=RS(0)
                                            %>
                                            
                                                <%=pmemo%> &nbsp;

                                            <%
                                            End If
                                            Rs.Close
                                            %>
                                        </div>
                                    </div>
                            </div>

                        <div class="row mt-1">
                            <%
                            SQL = "SELECT a.puidx, a.pufile, a.pumemo, a.pumidx, a.pudate, a.pustatus "
                            SQL = SQL & " FROM tk_picupload a "
                            SQL = SQL & " WHERE a.sjidx='"&rsjidx&"' and pustatus='1' "
                            Rs.Open SQL, Dbcon

                            If Not (Rs.BOF Or Rs.EOF) Then
                            Do while not Rs.EOF
                                puidx     = Rs(0)
                                pufile     = Rs(1)
                                pumemo    = Rs(2)
                                pumidx    = Rs(3)
                                pudate    = Rs(4)
                                pustatus    = Rs(5)
                                
                                i=i+1

                            %>
                            <div class="col-3 custom-bg" id="<%=sjidx%>">
                                <div class="card card-body image-card-fixed mb-1" style="height:500px;">
                                    <div class="row">
                                        <div class="col text-center">
                                            <div class="row">
                                                <%=i%>
                                            </div>
                                            
                                                <div class="row" style="height:350px;">
                                                    <img src="/img/frame/pufile/<%=rsjidx%>/<%=pufile%>" width="280" height="350">
                                                </div>
                                                <div class="row">
                                                    <button type="button" onclick="window.open('/img/frame/pufile/<%=rsjidx%>/<%=pufile%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                                                    <a href="/img/frame/pufile/<%=rsjidx%>/<%=pufile%>" download="<%=pufile%>">
                                                    <button type="button" style="width:100%">다운로드</button>
                                                    </a>
                                                    <button type="button" onclick="confirmDelete(<%=puidx%>)">삭제</button>
                                                </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                            Rs.movenext
                            Loop
                            End If
                            Rs.Close
                            %>

                            <%
                            SQL = "SELECT pfidx, pfname "
                            SQL = SQL & " FROM tk_picfiles "
                            SQL = SQL & " WHERE pffiletype='0' and sjidx='"&rsjidx&"' and pfstatus='1' "
                            Rs.Open SQL, Dbcon

                            If Not (Rs.BOF Or Rs.EOF) Then
                            Do while not Rs.EOF
                                fpfidx       = Rs(0)
                                pfname      = Rs(1)
                                
                                i=i+1

                            %>
                            <div class="col-3 custom-bg" id="<%=sjidx%>">
                                <div class="card card-body image-card-fixed mb-1" style="height:500px;">
                                    <div class="row">
                                        <div class="col text-center">
                                            <div class="row">
                                                <%=i%>
                                            </div>
                                            
                                                <div class="row" style="height:350px;">
                                                    <img src="/img/frame/pufile/<%=rsjidx%>/<%=pfname%>" width="280" height="350">
                                                </div>
                                                <div class="row">
                                                    <button type="button" onclick="window.open('/img/frame/pufile/<%=rsjidx%>/<%=pfname%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                                                    <a href="/img/frame/pufile/<%=rsjidx%>/<%=pfname%>" download="<%=pfname%>">
                                                    <button type="button" style="width:100%">다운로드</button>
                                                    </a>
                                                    <button type="button" onclick="confirmDelete2(<%=fpfidx%>)">삭제</button>
                                                </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                            Rs.movenext
                            Loop
                            End If
                            Rs.Close
                            %>

                            <%
                            SQL = "SELECT pfidx, pfname "
                            SQL = SQL & " FROM tk_picfiles "
                            SQL = SQL & " WHERE pffiletype='1' and sjidx='"&rsjidx&"' and pfstatus='1' "
                            Rs.Open SQL, Dbcon

                            If Not (Rs.BOF Or Rs.EOF) Then
                            Do while not Rs.EOF
                                pdfpfidx     = Rs(0)
                                pdfpfname    = Rs(1)
                                
                                i=i+1

                            %>
                            <div class="col-3 custom-bg" id="<%=sjidx%>">
                                <div class="card card-body image-card-fixed mb-1" style="height:500px;">
                                        <div class="col text-center">
                                            <div class="row">
                                                <%=i%>
                                            </div>
                                            <div class="row" style="height:350px;">
                                                <iframe src="/img/frame/pufile/<%=rsjidx%>/<%=pdfpfname%>"></iframe>
                                            </div>
                                            <div class="row">
                                                    <button type="button" onclick="window.open('/img/frame/pufile/<%=rsjidx%>/<%=pdfpfname%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                                                    <a href="/img/frame/pufile/<%=rsjidx%>/<%=pdfpfname%>" download="<%=pdfpfname%>">
                                                    <button type="button" style="width:100%">다운로드</button>
                                                    </a>
                                                    <button type="button" onclick="confirmDelete3(<%=pdfpfidx%>)">삭제</button>
                                            </div>
                                        </div>
                                </div>
                            </div>
                            <%
                            Rs.movenext
                            Loop
                            End If
                            Rs.Close
                            %>                            
                        </div>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>
        <!--Footer 시작-->
        Coded By 원준
        <!--Footer 끝-->
    </div>
</div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>

<script>
    // 페이지 로드 후 앵커로 이동
    window.addEventListener("DOMContentLoaded", function () {
        const hash = window.location.hash;
        if (hash) {
            const target = document.querySelector(hash);
            if (target) {
                target.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        }
    });
</script>
<script>
    window.addEventListener("DOMContentLoaded", function () {
        const sjidx = "<%=rsjidx%>";
        if (sjidx && sjidx !== "0") {
            const target = document.getElementById(sjidx);
            if (target) {
                // 앵커 위치로 이동
                target.scrollIntoView({  block: "center" });

                // URL에 앵커 강제로 추가
                history.replaceState(null, null, "#" + sjidx);
            }
        }
    });
</script>
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
