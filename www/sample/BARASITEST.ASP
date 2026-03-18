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
listgubun="one"
subgubun="one2"
projectname="샘플"
%>
 
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"

rSJst2_IDX=Request("rSJst2_IDX") 

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
    <script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
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
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="BARASITESTdb.asp?part=delete&SJst2_IDX="+sTR;
            }
        }
    </script>

    </head>
    <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between">
<!--화면시작-->
            <div class="py-5 container text-center  card card-body">


<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3><%=Year(date())%>.<%=Month(date())%>.<%=Day(date())%>&nbsp;절곡바라시</h3>
        </div>
<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="row mb-3">
            <div class="col text-end">
                <button type="button" class="btn btn-outline-danger" Onclick="location.replace('BARASITEST.asp?rSJst2_IDX=0');">등록</button>
            </div>
        </div>
<!-- 제목 나오는 부분 끝-->

<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">번호</th>
                        <th align="center">샤링값</th>
                        <th align="center">외경값</th>
                        <th align="center">vc값</th>
                        <th align="center">뒤집기1</th>
                        <th align="center">뒤집기2</th>
                    </tr>
                </thead>
                <tbody>
                    <form id="dataForm" action="BARASITESTdb.asp" method="POST">   
                    <input type="hidden" name="SJst2_IDX" value="<%=rSJst2_IDX%>">
                    <% if rSJst2_IDX="" or rSJst2_IDX="0" then %>
                    <tr>
                        <td></td>
                        <td><input class="input-field" type="text" size="3" placeholder="샤링값" aria-label="샤링값" name="SJst_vc_last" id="SJst_vc_last" value="<%=SJst_vc_last%>" onkeypress="handleKeyPress(event, 'SJst_vc_last', 'SJst_vc_last')"/></td>
                        <td><input class="input-field" type="text" size="16" placeholder="외경값" aria-label="외경값" name="SJst_wc_1" id="SJst_wc_1" value="<%=SJst_wc_1%>"  onkeypress="handleKeyPress(event, 'SJst_wc_1', 'SJst_wc_1')"/></td>
                        <td><input class="input-field" type="text" placeholder="vc값" aria-label="vc값" name="SJst_vc_1" id="SJst_vc_1" value="<%=SJst_vc_1%>"  onkeypress="handleKeyPress(event, 'SJst_vc_1', 'SJst_vc_1')"/></td>
                        <td><input class="input-field" type="text" placeholder="뒤집기1" aria-label="뒤집기1" name="SJst_r" id="SJst_r" value="<%=SJst_r%>"  onkeypress="handleKeyPress(event, 'SJst_r', 'SJst_r')"/></td>
                        <td><input class="input-field" type="text" placeholder="뒤집기2" aria-label="뒤집기2" name="SJst_l" id="SJst_l" value="<%=SJst_l%>"  onkeypress="handleKeyPress(event, 'SJst_l', 'SJst_l')"/></td>
                    </tr>
                    <% end if %>
                    <%
                    SQL=" select SJst2_IDX,SJst_vc_last,SJst_vc_1,SJst_wc_1,SJst_r,SJst_l "
                    SQL=SQL&" from TNG_SJst2  "
                    SQL=SQL&" order by SJst2_IDX desc "
                    Rs.open Sql,Dbcon,1,1,1
                    if not (Rs.EOF or Rs.BOF ) then
                    Do while not Rs.EOF
                        SJst2_IDX=Rs(0)
                        SJst_vc_last=Rs(1)
                        SJst_vc_1=Rs(2)
                        SJst_wc_1=Rs(3)
                        SJst_r=Rs(4)
                        SJst_l=Rs(5)
                        i=i+1
                    %>      
                    <% if int(SJst2_IDX)=int(rSJst2_IDX) then %>
                    <tr>
                        <td align="center"><button type="button" class="btn btn-outline-danger" Onclick="del('<%=SJst2_IDX%>');"><%=i%></button></td>
                        <td><input class="input-field" type="text" size="3" placeholder="샤링값" aria-label="샤링값" name="SJst_vc_last" id="SJst_vc_last" value="<%=SJst_vc_last%>" onkeypress="handleKeyPress(event, 'SJst_vc_last', 'SJst_vc_last')"/></td>
                        <td><input class="input-field" type="text" size="16" placeholder="외경값" aria-label="외경값" name="SJst_wc_1" id="SJst_wc_1" value="<%=SJst_wc_1%>"  onkeypress="handleKeyPress(event, 'SJst_wc_1', 'SJst_wc_1')"/></td>
                        <td><input class="input-field" type="text" placeholder="vc값" aria-label="vc값" name="SJst_vc_1" id="SJst_vc_1" value="<%=SJst_vc_1%>"  onkeypress="handleKeyPress(event, 'SJst_vc_1', 'SJst_vc_1')"/></td>
                        <td><input class="input-field" type="text" placeholder="뒤집기1" aria-label="뒤집기1" name="SJst_r" id="SJst_r" value="<%=SJst_r%>"  onkeypress="handleKeyPress(event, 'SJst_r', 'SJst_r')"/></td>
                        <td><input class="input-field" type="text" placeholder="뒤집기2" aria-label="뒤집기2" name="SJst_l" id="SJst_l" value="<%=SJst_l%>"  onkeypress="handleKeyPress(event, 'SJst_l', 'SJst_l')"/></td>
                    </tr>

                    <% else %>
                    <tr>
                        <td align="center"><%=i%></td>
                        <td><input class="input-field" type="text" size="8" value="<%=SJst_vc_last%>" onclick="location.replace('BARASITEST.asp?rSJst2_IDX=<%=SJst2_IDX%>');"/></td>
                        <td><input class="input-field" type="text" value="<%=SJst_wc_1%>" onclick="location.replace('BARASITEST.asp?rSJst2_IDX=<%=SJst2_IDX%>');"/></td>
                        <td><input class="input-field" type="text" value="<%=SJst_vc_1%>" onclick="location.replace('BARASITEST.asp?rSJst2_IDX=<%=SJst2_IDX%>');"/></td>
                        <td><input class="input-field" type="text" value="<%=SJst_r%>" onclick="location.replace('BARASITEST.asp?rSJst2_IDX=<%=SJst2_IDX%>');"/></td>
                        <td><input class="input-field" type="text" value="<%=SJst_l%>" onclick="location.replace('BARASITEST.asp?rSJst2_IDX=<%=SJst2_IDX%>');"/></td>
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
<!-- 표 형식 끝--> 


    </div>    

<!--화면 끝-->
  </div>
  </div>
</div>
</main>                          
 

<!-- footer 시작 -->    
 
Coded By 이름
 
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
