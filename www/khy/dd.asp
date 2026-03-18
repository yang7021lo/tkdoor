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

kidx = Request("kidx")
ksidx = Request("ksidx")
odrv = Request("odrv")

' 발주 상태 업데이트 로직
if ksidx <> "" then
    SQL = "UPDATE tk_korderSub SET odrstatus='" & odrv & "', cmidx='" & c_midx & "', cdate=GETDATE() WHERE ksidx='" & ksidx & "' "
    Dbcon.Execute(SQL)
end if

' 페이지 초기화
if request("gotopage") = "" then
    gotopage = 1
else
    gotopage = request("gotopage")
end if
page_name = "/khy/korder.asp?"

' 오늘 날짜 구하기
todayDate = Date()
todayDateString = FormatDateTime(todayDate, 2) ' "yyyy-mm-dd" 형식으로 날짜 포맷
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자재발주리스트</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script>
        function del(ksidx) {
            if (confirm("이 항목을 삭제하시겠습니까?")) {
                location.href = "odrlistdel_db.asp?ksidx=" + ksidx;
            }
        }
    </script>
</head>
<body>

<div class="py-5 container text-center">
    <div class="col-12 text-start">
        <h3>자재발주 리스트</h3>
    </div>

<%
' 오늘 날짜의 발주만 선택하여 표시하기 위한 SQL 구문
SQL = "SELECT DISTINCT C.cname, B.mname, B.mpos, B.mhp, CONVERT(varchar(10), A.odrdate, 121) AS odrdate "
SQL = SQL & "FROM tk_korderSub A "
SQL = SQL & "JOIN tk_member B ON A.midx = B.midx "
SQL = SQL & "JOIN tk_customer C ON B.cidx = C.cidx "
SQL = SQL & "WHERE A.kidx <> '' AND CONVERT(varchar(10), A.odrdate, 121) = '" & todayDateString & "'"

Rs.open SQL, Dbcon
If Not (Rs.bof or Rs.eof) Then 
    cname = Rs("cname")
    mname = Rs("mname")
    mpos = Rs("mpos")
    mhp = Rs("mhp")
    odrdate = Rs("odrdate")
End if
Rs.close
%>

    <!-- 발주처 정보와 발주일 표시 -->
    <div class="col-12 text-start">
        <div class="input-group mb-3">
            <span class="input-group-text">발주처</span>
            <div class="card text-start" style="width:30%; padding:5px;"><%= cname %></div>
        </div>
        <div class="input-group mb-3">
            <span class="input-group-text">발주일</span>
            <div class="card text-start" style="width:30%; padding:5px;"><%= odrdate %></div>
        </div>
    </div>

    <div class="card mb-4 card-body">
        <table class="table">
            <thead>
                <tr>
                    <th scope="col">순번</th>
                    <th scope="col">주문번호</th>
                    <th scope="col">구분</th>
                    <th scope="col">자재명</th>
                    <th scope="col">길이</th>
                    <th scope="col">중량</th>
                    <th scope="col">상태</th>
                    <th scope="col">삭제</th>
                </tr>
            </thead>
            <tbody class="table-group-divider">
<%
Dim rowIndex
rowIndex = 1

SQL = "SELECT A.odrdate, A.odrstatus, A.midx, A.odrkkg, A.odridx, B.mname, B.mpos, B.mhp, C.Order_name, C.Order_length, C.order_type, A.ksidx "
SQL = SQL & "FROM tk_korderSub A "
SQL = SQL & "JOIN tk_member B ON A.midx = B.midx "
SQL = SQL & "JOIN tk_khyorder C ON A.odridx = C.order_idx "
SQL = SQL & "WHERE A.kidx <> '' AND CONVERT(varchar(10), A.odrdate, 121) = '" & todayDateString & "' "
SQL = SQL & "ORDER BY Order_name ASC "

Rs.open SQL, Dbcon, 1, 1, 1

If Not (Rs.bof or Rs.eof) Then 
    Do while Not Rs.EOF
        order_type = Rs("order_type")
        select case order_type
            case "1": order_type_text = "무피"
            case "2": order_type_text = "백피"
            case "3": order_type_text = "블랙"
        end select

        Order_length = Rs("Order_length")
        select case Order_length
            case "1": Order_length_text = "2,200mm"
            case "2": Order_length_text = "2,400mm"
            case "3": Order_length_text = "2,500mm"
            case "4": Order_length_text = "2,800mm"
            case "5": Order_length_text = "3,000mm"
            case "6": Order_length_text = "3,200mm"
        end select

        odrstatus = Rs("odrstatus")
        if odrstatus = "1" then 
            classname = "btn btn-primary"
            status_text = "확인"
            odrv = "2"
        elseif odrstatus = "2" then 
            classname = "btn btn-danger"
            status_text = "확인완료"
            odrv = "1"
        end if
%>
                <tr>
                    <th><%= rowIndex %></th>
                    <td><%= Rs("ksidx") %></td>
                    <td><%= order_type_text %></td>
                    <td><%= Rs("Order_name") %></td>
                    <td><%= Order_length_text %></td>
                    <td class="text-start"><%= Rs("odrkkg") %>kg</td>
                    <td><button class="<%=classname%>" type="button" onclick="location.replace('odrlist.asp?kidx=<%=kidx%>&ksidx=<%=ksidx%>&odrv=<%=odrv%>');"><%=status_text%></button></td>        
                </tr>
<%
        Rs.movenext
        rowIndex = rowIndex + 1
    Loop
End If
Rs.close
%>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%
set Rs = Nothing
call dbClose()
%>
