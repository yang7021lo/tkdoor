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
Set Rs = Server.CreateObject("ADODB.Recordset")
%>
<%
rqtyidx=Request("rqtyidx")
%>
<% projectname="판재자재 관리" %>
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3>판재 자재관리</h3>
        </div>
<!-- 제목 나오는 부분 끝-->

<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">번호</th>
                      <th align="center">판재이름</th>
                      <th align="center">판재가격</th>
                      <th align="center">사용유무</th>
                      <th align="center">도장유무</th>
                      <th align="center">입력자</th>
                      <th align="center">입력일</th>
                      <th align="center">수정자</th>
                      <th align="center">수정일</th>
                  </tr>
              </thead>
              <tbody>
<form id="dataForm" action="Qty_itemdb.asp" method="POST">   
<input type="hidden" name="qtyidx" value="<%=rqtyidx%>">
<%
SQL = "SELECT QTYIDX, QTYCODE, QTYNAME, QTYSTATUS, QTYPAINT ,QTYmidx,QTYwdate,QTYewdate,qtyprice" 
SQL = SQL & " FROM tk_qty " 
SQL=SQL&" order by QTYIDX desc "
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    QTYIDX     = Rs(0)   ' QTYIDX 값
    qtycode   = Rs(1)   ' QTYCODE 값
    qtyname   = Rs(2)   ' QTYNAME 값
    qtypstatus = Rs(3)  ' QTYSTATUS 값
    qtypaint  = Rs(4)   ' QTYPAINT 값
    QTYmidx = Rs(5)
    QTYwdate = Rs(6)
    QTYewdate = Rs(7)
    qtyprice = Rs(8)

    i=i+1
%>              
<% if int(QTYIDX)=int(rQTYIDX) then %>
                  <tr>
                      <td><%=i%></td>
                      <td><input class="input-field" type="text" placeholder="판재이름" aria-label="판재이름" name="QTYNAME" id="QTYNAME" value="<%=QTYNAME%>" onkeypress="handleKeyPress(event, 'QTYNAME', 'QTYNAME')"/></td>
                      <td><input class="input-field" type="text" placeholder="판재가격" aria-label="판재가격" name="qtyprice" id="qtyprice" value="<%=qtyprice%>"  onkeypress="handleKeyPress(event, 'qtyprice', 'qtyprice')"/></td>
                      <td><input class="input-field" type="text" placeholder="사용유무" aria-label="사용유무" name="qtypstatus" id="qtypstatus" value="<%=qtypstatus%>"  onkeypress="handleKeyPress(event, 'qtypstatus', 'qtypstatus')"/></td>
                      <td><input class="input-field" type="text" placeholder="도장유무" aria-label="도장유무" name="qtypaint" id="qtypaint" value="<%=qtypaint%>"  onkeypress="handleKeyPress(event, 'qtypaint', 'qtypaint')"/></td>
                      <td><input class="input-field" type="text" placeholder="입력자" aria-label="입력자" name="QTYmidx" id="QTYmidx" value="<%=QTYmidx%>"  onkeypress="handleKeyPress(event, 'QTYmidx', 'QTYmidx')"/></td>
                      <td><%=QTYwdate%></td>

                  </tr>

<% else %>
                  <tr>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=i%></a></td>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=QTYNAME%></a></td>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=qtyprice%></a></td>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=qtypstatus%></a></td>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=qtypaint%></a></td>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=QTYmidx%></a></td>
                      <td><a href="Qty_item.asp?rQTYIDX=<%=QTYIDX%>"><%=QTYwdate%></a></td>
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
<!-- 버튼 형식 시작--> 
   
<!-- 버튼 형식 끝--> 
 
    </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>
