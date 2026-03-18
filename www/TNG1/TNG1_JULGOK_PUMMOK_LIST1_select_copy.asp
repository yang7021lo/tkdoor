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

copy_bfidx = Request("copy_bfidx")
rSJB_IDX = Request("SJB_IDX")
rWHICHI_AUTO = Request("WHICHI_AUTO")
rWHICHI_FIX = Request("WHICHI_FIX")
'Response.Write "copy_bfidx : " & copy_bfidx & "<br>"
'Response.Write "rSJB_IDX : " & rSJB_IDX & "<br>"
'Response.Write "rWHICHI_AUTO : " & rWHICHI_AUTO & "<br>"
'Response.Write "rWHICHI_FIX : " & rWHICHI_FIX & "<br>"
'response.end

if copy_bfidx = "" then
    response.write "<script>alert('잘못된 접근입니다.');history.back();</script>"
    response.end
end if

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
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_STAIN_Itemdb.asp?part=delete&searchWord=<%=rsearchword%>&QTYIDX="+sTR;
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
    </div>
        <h2>품목가져와서  선택 복사</h2>
            <table  class="table custom-table">
                <tr>
                    <th>타입</th>
                    <th>규격</th>
                    <th>사용위치</th>
                    <th>자재명</th>
                    <th>측면폭</th>
                    <th>정면폭</th>
                    <th>도면</th>
                </tr>

                <%
                sql = "SELECT A.bfidx, A.sjb_idx, A.WHICHI_FIX, A.WHICHI_AUTO"
                sql = sql & ", A.set_name_FIX, A.set_name_AUTO"
                sql = sql & ", A.xsize, A.ysize"
                sql = sql & ", B.SJB_TYPE_NO"
                sql = sql & ", D.WHICHI_FIXname, E.WHICHI_AUTOname"
                sql = sql & ", A.bfimg1, A.bfimg2, A.bfimg3"
                sql = sql & ", C.SJB_TYPE_NAME,B.SJB_barlist"
                sql = sql & " FROM tk_barasiF A"
                sql = sql & " LEFT OUTER JOIN TNG_SJB B ON A.sjb_idx = B.sjb_idx"
                sql = sql & " LEFT OUTER JOIN tng_sjbtype C ON B.SJB_TYPE_NO = C.SJB_TYPE_NO"
                sql = sql & " LEFT OUTER JOIN tng_whichitype D ON A.WHICHI_FIX = D.WHICHI_FIX"
                sql = sql & " LEFT OUTER JOIN tng_whichitype E ON A.WHICHI_AUTO = E.WHICHI_AUTO"

                If rWHICHI_FIX <> "" And rWHICHI_AUTO = "" Then
                    sql = sql & " WHERE A.WHICHI_FIX = '" & rWHICHI_FIX & "'"
                End If

                If rWHICHI_AUTO <> "" And rWHICHI_FIX = ""  Then
                    sql = sql & " WHERE A.WHICHI_AUTO = '" & rWHICHI_AUTO & "'"
                End If

                    sql = sql & " and A.bfidx <> '" & copy_bfidx & "'"
                
                sql = sql & " ORDER BY A.bfidx DESC"
                'response.write (SQL)&"<br>"
                'response.end
                Rs.Open sql, Dbcon, 1, 1
                If Not (Rs.EOF Or Rs.BOF) Then
                    Do Until Rs.EOF
                        bfidx           = Rs(0)
                        sjb_idx         = Rs(1)
                        whichi_fix      = Rs(2)
                        whichi_auto     = Rs(3)
                        set_name_fix    = Rs(4)
                        set_name_auto   = Rs(5)
                        xsize           = Rs(6)
                        ysize           = Rs(7)
                        sjb_type_no     = Rs(8)
                        whichi_fixname  = Rs(9)
                        whichi_autoname = Rs(10)
                        bfimg1          = Rs(11)
                        bfimg2          = Rs(12)
                        bfimg3          = Rs(13)
                        sjb_type_name   = Rs(14)
                        SJB_barlist     = Rs(15)
                %>
                    <tr>
                        <td><%=sjb_type_name%></td>
                        <td><%=SJB_barlist%></td>
                        <% If rWHICHI_FIX <> "" And rWHICHI_AUTO = "" Then %>
                           <td><%=whichi_fixname%></td>
                           <td><%=set_name_fix%></td>
                        <% End If %>
                        <% If rWHICHI_AUTO <> "" And rWHICHI_FIX = "" Then %>
                           <td><%=whichi_autoname%></td>
                           <td><%=set_name_auto%></td>
                        <% End If %>
                        <td>
                            <%=xsize%>
                        </td>
                        <td>
                            <%=ysize%> 
                            <a href="TNG1_JULGOK_PUMMOK_LIST1_select_copy_process.asp?copy_bfidx=<%=copy_bfidx%>&selected_bfidx=<%=bfidx%>&SJB_IDX=<%=rSJB_IDX%>">
                                <button type="button" class="btn btn-sm btn-primary btn-small">
                                    <i class="fa-solid fa-copy"></i> 복사
                                </button>
                            </a>
                        </td>
                        <td>
                            <iframe src="iframeimg.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=sjb_idx%>&bfidx=<%=bfidx%>#<%=bfidx%>" width="300" height="220" style="border: none; display: block;"></iframe>
                        </td>
                        <td>
                            
                        </td>
                    </tr>
                <%
                        Rs.MoveNext
                    Loop
                End If
                Rs.Close
                %>
            </table>


  
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
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









