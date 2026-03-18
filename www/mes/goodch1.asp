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
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")

rgoidx=Request("goidx")
rcidx=Request("cidx")
rsjaidx=Request("sjaidx") 
rsjbidx=Request("sjbidx") 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
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

        .btn {
            writing-mode: horizontal-tb;  /* Ensures the text inside the button is horizontal */
            transform: none;              /* Resets any transform that may have caused rotation */
            text-align: center;           /* Centers the text inside the button */
            white-space: nowrap;          /* Prevents text from wrapping */
        }

        td {
            text-align: center;           /* Centers the content inside the <td> cell */
        }
        body {
            zoom: 0.7;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
</head>
<body>

<!--화면시작-->

    <div class="py-2 container text-center">
        <!-- 표 형식 시작--> 
        <div class="input-group mb-3">
            <table id="datatablesSimple" class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">품목</th>
                        <th align="center">선택</th>
                    </tr>
                </thead>
                <tbody>
                <%
                SQL = "SELECT goidx, gotype, gocode, gocword, goname, gopaint, gosecfloor, gomidkey, gounit, gostatus, gomidx, gowdate, goemidx,goname2,goname3,goname4,goname5,goname6 "
                SQL = SQL & "FROM tk_goods "
                SQL = SQL & "WHERE gotype = 1 AND goname LIKE '%통도장%' AND goname NOT LIKE '%자동%' "
                SQL = SQL & "ORDER BY CASE "
                SQL = SQL & "  WHEN goname4 = '안전' and goname5 is null THEN 1 "
                SQL = SQL & "  WHEN goname4 = '단열안전' and goname5 is null THEN 2 "
                SQL = SQL & "  WHEN goname6 = '중간키' and goname5 is null THEN 3 "
                SQL = SQL & "  WHEN goname4 = '복층안전'  and goname5 is null THEN 4 "
                SQL = SQL & "  WHEN goname4 = '일반'  and goname5 is null THEN 5 "
                SQL = SQL & "  WHEN goname4 = '단열일반' and goname5 is null THEN 6 "
                SQL = SQL & "  WHEN goname4 = '복층일반'  and goname5 is null THEN 7 "
                SQL = SQL & "  WHEN goname4 = '한쪽안전' and goname5 is null THEN 8 "
                SQL = SQL & "  WHEN goname4 = '단열한쪽안전' and goname5 is null THEN 9 "
                SQL = SQL & "  WHEN goname4 = '복층한쪽안전' and goname5 is null THEN 10 "                
                SQL = SQL & "  WHEN goname6 = '중간키' and goname5 is null THEN 11 "
                SQL = SQL & "  WHEN goname5 = '다대무홈' and goname6 is null THEN 12 "
                SQL = SQL & "  WHEN goname6 = '중간키' and goname5 = '다대무홈' THEN 13 "
                SQL = SQL & "END , goname"
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                        goidx=Rs(0)
                        gotype=Rs(1)
                        gocode=Rs(2)
                        gocword=Rs(3)
                        goname=Rs(4)
                        gopaint=Rs(5)
                        gosecfloor=Rs(6)
                        gomidkey=Rs(7)
                        gounit=Rs(8)
                        gostatus=Rs(9)
                        gomidx=Rs(10)
                        gowdate=Rs(11)
                        goemidx=Rs(12)
                        i=i+1
                %>                 
                    <tr>
                        <td><%=goname%></td>
                        <td><button type="button" class="btn btn-info btn-sm" onclick="opener.location.replace('sujuin.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>&goidx=<%=goidx%>');window.close();">선 택</button></td>
                    </tr>
                <%
                    Rs.MoveNext
                    Loop
                End If
                Rs.close
                %>
                </tbody>
            </table>
        </div>
        <!-- 표 형식 끝--> 
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
