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

rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rfkidx=Request("fkidx")
rsjb_idx=Request("sjb_idx")
rSJB_TYPE_NO=Request("SJB_TYPE_NO")
rjaebun=Request("jaebun")
rboyang=Request("boyang")
gubun=Request("gubun")
mode=Request("mode")

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기타옵션</title>
    <link rel="icon" type="image/x-icon" href="/taekwang_logo.svg">
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
    </style>

</head>
<body style="overflow-x:scroll;"> <!-- 내용 넘치면 가로 스크롤 생김--> 
 
<!--화면시작-->

    <div class="py-3 container text-center">



      <div class="d-flex gap-3">
        <button type="button" class="btn btn-success" Onclick="location.replace('TNG1_B_lobbyphone.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&mode=<%=mode%>');">로비폰 추가</button>
        <button type="button" class="btn btn-primary" Onclick="location.replace('TNG1_B_boonhal.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&mode=<%=mode%>');">중간소대 추가</button>
        <% 
        sql="SELECT greem_f_a ,fl from tk_framek  Where fkidx='"&rfkidx&"' " 
        'Response.write (SQL)&"<br>수동/자동 알아보기 GREEM_F_A=2(자동) , GREEM_F_A=1(수동) <br>"
        Rs.open Sql,Dbcon
        If Not (Rs.bof or Rs.eof) Then
            zgreem_f_a=Rs(0) 
            zfl=Rs(1)
        End If
        Rs.close
        %>

        <% if zgreem_f_a = 2 and zfl=30 then %>
        <button type="button" class="btn btn-warning" Onclick="location.replace('TNG1_B_haburail.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&SJB_TYPE_NO=<%=rSJB_TYPE_NO%>&jaebun=<%=rjaebun%>&boyang=<%=rboyang%>&mode=<%=mode%>');">하부레일 추가</button>
        <% end if %>
      </div>
      </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%

%>
<%
set Rs=Nothing
call dbClose()
%>
