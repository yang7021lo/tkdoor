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

snidx=request("snidx")
SearchWord=request("SearchWord")
'response.write keyWord&"<br>"
'response.write rgidx&"<br>"

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

    <script>


    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">

<!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3>거래처 선택</h3>
        </div>
<!-- 제목 나오는 부분 끝-->
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="window.close();">창닫기</button>      
        </div>
<!-- input 형식 시작--> 

<input type="text" class="form-control" id="search-input" placeholder="검색어를 입력해 주세요." name="SearchWord" value="<%=SearchWord%>">

<!-- input 형식 끝--> 
            
<!-- 검색된 목록 나오기 시작 -->
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th align="center">거래처명</th>
                      <th align="center" width="100px">선택</th>
                  </tr>
              </thead>

            
<%
Response.ContentType = "application/json"
Response.charset = "utf-8"

Dim snidxParam
snidxParam = Request.QueryString("snidx") ' snidx는 여전히 필요할 수 있음

Dim SQL_JSON
SQL_JSON = "SELECT A.cname, A.cidx from tk_customer A " 
SQL_JSON = SQL_JSON & " Where A.cidx not in (Select C.cidx From tk_reportsendcorpSub C where C.snidx='"&snidxParam&"') "

'Dbcon 및 Rs 객체는 기존 ASP 환경에 맞게 설정되어 있다고 가정
'Set Dbcon = Server.CreateObject("ADODB.Connection")
'Dbcon.Open "YourConnectionString" ' 실제 DB 연결 문자열로 변경

Dim Rs_JSON
Set Rs_JSON = Server.CreateObject("ADODB.Recordset")
Rs_JSON.Open SQL_JSON, Dbcon

Dim dataArray
Set dataArray = Server.CreateObject("Scripting.Dictionary")
Dim i

i = 0
If Not (Rs_JSON.bof or Rs_JSON.eof) Then 
    Do While not Rs_JSON.EOF
        dataArray.Add i, "{""cname"": """ & Replace(Rs_JSON("cname"), """", "\""") & """, ""cidx"": """ & Rs_JSON("cidx") & """}"
        Rs_JSON.movenext
        i = i + 1
    Loop
End If
Rs_JSON.close

' JSON 배열 형태로 출력
Response.Write "[" & Join(dataArray.Items, ",") & "]"

'Dbcon.Close
'Set Dbcon = Nothing
%>



              <tbody>
              </tbody>  
          </table> 
        </div>
<!-- 검색된 목록 나오기 끝-->
    </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// 검색 필터
    function filterTable() {
        const searchInput = document.getElementById('search-input').value.toLowerCase().replace(/\s+/g, '');
        const filteredData = data.entries.filter(item => {
            const title = item.title.toLowerCase().replace(/\s+/g, '');
            return title.includes(searchInput);
        });
        renderTable(filteredData);
    }
</script>

<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>
