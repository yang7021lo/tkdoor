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

    listgubun="four"
    projectname="자재등록"
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
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px 30px;
            width: 400px;
        }
        h3 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        .input-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        .input-group span {
            flex-shrink: 0;
            width: 100px;
            text-align: right;
            margin-right: 10px;
            font-weight: bold;
            color: #555;
        }
        .input-group select, .input-group input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: 0.3s;
        }
        .input-group select:focus, .input-group input:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            outline: none;
        }
        .button-group {
            display: flex;
            justify-content: space-between;
        }
        .button-group button {
    flex: 1;
    margin: 0 5px;
    padding: 10px 15px;
    border: none;
    border-radius: 5px;
    color: #fff;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
    background-color: #007bff; /* 기본 배경색 추가 (파란색) */
    opacity: 1; /* 기본 상태에서 버튼을 보이게 설정 */
}

.button-group button:hover {
    background-color: #0056b3; /* 마우스를 올렸을 때 배경색 변경 */
}

.button-group .btn-danger {
    background-color: #dc3545; /* 빨간색 배경 */
}

.button-group .btn-danger:hover {
    background-color: #a71d2a; /* 마우스를 올렸을 때 더 진한 빨간색 */
}


    </style>
        <script>
            function validateForm() {
                if (document.frmMain.order_name.value == "") {
                    alert("자재명을 입력하세요.");
                    return false;
                }
                if (document.frmMain.order_type.value == "") {
                    alert("자재 재질을 선택하세요.");
                    return false;
                }
                if (document.frmMain.order_length.value == "") {
                    alert("자재 길이를 선택하세요.");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <div class="container">
            <h3>자재등록</h3>
            <form method="post" name="frmMain" action="khorderdb.asp" onsubmit="return validateForm();">
                <div class="input-group">
                    <span>부서</span>
                    <select name="order_dept">
                        <option value="1">도어</option>
                        <option value="2">프레임</option>
                        <option value="3">시스템도어</option>
                        <option value="4">자동문</option>
                        <option value="5">보호대</option>
                        <option value="6">기타</option>
                    </select>
                </div>
                <div class="input-group">
                    <span>자재명</span>
                    <input type="text" name="order_name" placeholder="자재명을 입력하세요">
                </div>
                <div class="input-group">
                    <span>자재길이</span>
                    <select name="order_length">
                        <option value="0">없음</option>
                        <option value="1">2,200mm</option>
                        <option value="2">2,400mm</option>
                        <option value="3">2,500mm</option>
                        <option value="4">2,800mm</option>
                        <option value="5">3,000mm</option>
                        <option value="6">3,200mm</option>
                    </select>
                </div>
                <div class="input-group">
                    <span>자재재질</span>
                    <select name="order_type">
                        <option value="0">없음</option>
                        <option value="1">무피</option>
                        <option value="2">백피</option>
                        <option value="3">블랙</option>
                    </select>
                </div>
                <div class="button-group">
                    <button type="submit" class="btn btn-outline-primary">등록</button>
                    <button type="button" class="btn btn-outline-danger" onclick="location.replace('khorderlist.asp');">리스트</button>
                </div>
            </form>
        Coded By 호영
    </div>

  </div>

                         
 
<!-- footer 시작 -->    
 

 
<!-- footer 끝 --> 

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
 
    </body>
</html>

<%
 
%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
