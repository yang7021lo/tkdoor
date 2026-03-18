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

ridx=Request("ridx")
ftype=Request("ftype")
clickacfidx=Request("clickacfidx")
clickaacfidx=Request("clickaacfidx")

Select case ftype

    case "1"
        ftype_text="프레임재질"
    case "2"
        ftype_text="간봉재질"  
    case "3"
        ftype_text="유리사양"
    case "4"
        ftype_text="유리상세"
    case "5"
        ftype_text="창호타입"
    case "6"
        ftype_text="depth"
    case "7"
        ftype_text="width"
    case "8"
        ftype_text="계폐방식"

End Select
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
<link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f8e7375b143214↩_fe6aacc29b2d266d396%7Emv2.png/v1/fill/w32%2Ch__32%2Clg_1%2Cusm0.661.00___0.01/76309f8e7375b143214↩_fe6aacc29b2d266d396%7Emv2.png" />
<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
<style>
    a:link {
        color: #070707;
        text-decoration: none;
    }
    a:visited{
        color: #070707;
        text-decoration: none;  
    }
    a:hover{
        color: #070707;
        text-decoration: none;         
    }
</style>
</head>
<body>
<!--화면시작-->
    <div class="py-3 container text-center">
        <!-- 제목 나오는 부분 시작-->
        <div class="input-group mb-3">
            <h3><%=ftype_text%></h3>
        </div>

        <div class="input-group mb-2">
            <div class="form-control text-start" style="padding:5 5 5 5;">   
                <input type="text" class="form-control" name="rrfname" value="" placeholder="등록할 옵션명을 입력해주십시오.">
            </div>
            <button type="button" class="btn btn-outline-primary" Onclick="location.replace('shrregdb.asp?ridx=<%=ridx%>&ftype=<%=ftype%>&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>');">등록</button>
        </div>        
        <!-- 제목 나오는 부분 끝-->

        <!-- 표 형식 시작-->
        <div class="input-group mb-3">

            <%
            SQL=" Select fidx, fname From tk_reportm"
            SQL=SQL&" Where fstatus=1 and ftype='"&ftype&"' and fidx NOT IN(Select rfidx from tk_reportsub where ridx='"&ridx&"')"
            'response.Write (SQL)

            Set Rs=dbcon.execute (SQL)
            If not (Rs.BOF or Rs.EOF) then
            Do while not Rs.EOF  
            rfidx=Rs(0)
            rfname=Rs(1)         
            %>

            <div class="btn">
                <button type="button" class="btn btn-primary" Onclick="location.replace('shrdb.asp?ridx=<%=ridx%>&rftype=<%=ftype%>&rfidx=<%=rfidx%>&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>')"><%=rfname%>&nbsp;추가</button>
            </div>

            <%
            Rs.MoveNext
            Loop
            End If
            Rs.Close
            %> 

        </div>   

        <div class="input-group mb-3">
            
            <%
            SQL=" Select A.rsidx, B.fidx, B.fname From tk_reportsub A"
            SQL=SQL&" Join tk_reportm B On A.rfidx=B.fidx "
            SQL=SQL&" Where A.ridx='"&ridx&"' and A.rftype='"&ftype&"'"
            'response.Write (SQL)

            Set Rs=dbcon.execute (SQL)
            If not (Rs.BOF or Rs.EOF) then
            Do while not Rs.EOF  
            rsidx=Rs(0)
            rfidx=Rs(1)
            fname=Rs(2)         
            %>

            <div class="btn">
                <button type="button" class="btn btn-danger" Onclick="location.replace('shrdeldb.asp?ridx=<%=ridx%>&rsidx=<%=rsidx%>&clickaacfidx=<%=clickaacfidx%>&clickacfidx=<%=clickacfidx%>')"><%=fname%>&nbsp;삭제</button>
            </div>

            <%
            Rs.MoveNext
            Loop
            End If
            Rs.Close
            %>      
        
        </div>
        <!-- 표 형식 끝-->
        <!-- 버튼 형식 시작-->
        <div class="btn">
            <button type="button" class="btn btn-outline-danger" Onclick="window.close();">창닫기</button>
        </div>
        <!-- 버튼 형식 끝-->
    </div>
<!--화면 끝-->
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>

</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>