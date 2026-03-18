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

kidx=Request("kidx")
ksidx=Request("ksidx")
odrv=Request("odrv")
SQL="select kidate, kmidx FRom tk_korder where kidx='"&kidx&"' "
Rs.open SQL,Dbcon,1,1,1
If Not (Rs.bof or Rs.eof) Then 
    kidate=Rs(0)
    kmidx=Rs(1)

    if Isnull(kidate) then 
    SQL="update tk_korder set kidate=getdate(), kstatus=1, imidx='"&kmidx&"' Where kidx='"&kidx&"' "
    Dbcon.Execute (SQL)
    end if
End if
Rs.close

if ksidx<>"" then
    SQL="update tk_korderSub set odrstatus='"&odrv&"', cmidx='"&kmidx&"', cdate=getdate() where ksidx='"&ksidx&"' "
    Dbcon.Execute (SQL)
end if

if request("gotopage")="" then
gotopage=1
else
gotopage=request("gotopage")
end if
page_name="/khy/korder.asp?"
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자재발주리스트</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .table-responsive {
            overflow-x: auto;
        }
        .table th, .table td {
            vertical-align: middle;
            border: 1px solid #dee2e6; /* 테두리 추가 */
        }
        .table thead {
            background-color: #343a40;
            color: #ffffff;
        }
        .btn-custom-primary {
            background-color: #007bff;
            color: #ffffff;
            border: none;
        }
        .btn-custom-primary:hover {
            background-color: #0056b3;
        }
        @media (max-width: 768px) {
            .card-header {
                font-size: 1.2rem;
            }
            .input-group-text {
                font-size: 0.9rem;
            }
            .form-control {
                font-size: 0.9rem;
            }
        }
    </style>
    <script>
        function del(ksidx) {
            if (confirm("이 항목을 삭제하시겠습니까?")) {
                location.href = "odrlistdel_db.asp?ksidx=" + ksidx;
            }
        }
    </script>
</head>
<body>

<div class="container-fluid py-3 text-center">

<%
SQL=" Select A.kidx, A.kcidx, B.cname, A.kmidx, C.mname, A.midx, D.mname "
SQL=SQL&" , Convert(varchar(10),A.kwdate,121), Convert(varchar(10),A.kidate,121), Convert(varchar(10),A.krdate,121) "
SQL=SQL&", A.kstatus, C.mpos, C.mhp, D.mpos, D.mhp "
SQL=SQL&" From tk_korder A "
SQL=SQL&" Join tk_customer B On A.kcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.kmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Where A.kidx='"&kidx&"' "
Rs.open Sql,dbcon
if not (Rs.EOF or Rs.BOF ) then
    kidx=Rs(0)
    kcidx=Rs(1)
    cname=Rs(2)
    kmidx=Rs(3)
    fmname=Rs(4)
    midx=Rs(5)
    smname=Rs(6)
    kwdate=Rs(7)
    kidate=Rs(8)
    krdate=Rs(9)
    kstatus=Rs(10)
    fmpos=Rs(11)
    fmhp=Rs(12)
    smpos=Rs(13)
    smhp=Rs(14)

select case kstatus
    case "0"
        kstatus_text="발주중"
    case "1"
        kstatus_text="납품처확인"
    case "2"
        kstatus_text="입고완료"
end select
end if
Rs.close
%>

<div class="row">
    <div class="col-12 text-start">
        <h4><%=Year(kwdate)%>년 <%=Month(kwdate)%>월 <%=Day(kwdate)%>일</h4>
        <h5><%=cname%> 자재발주</h5>
    </div>
</div>

<div class="row mb-3">
    <div class="col-12 col-md-6">
        <div class="input-group">
            <span class="input-group-text">담당자</span>
            <input type="text" class="form-control" value="<%=smname%><%=smpos%>" disabled>
        </div>
    </div>
    <div class="col-12 col-md-6">
        <div class="input-group">
            <span class="input-group-text">연락처</span>
            <input type="text" class="form-control text-truncate" value="<%=smhp%>" disabled>
        </div>
    </div>
</div>

<style>
    .text-truncate {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    @media (max-width: 768px) {
        .input-group-text {
            font-size: 0.8rem;
        }
        .form-control {
            font-size: 0.8rem;
        }
    }
</style>

<div class="card mb-4">
    <div class="card-header">자재발주 리스트</div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th rowspan="2">순번</th>
                        <th>구분</th>
                        <th colspan="4">자재명</th>
                    </tr>
                    <tr>
                        <th>길이</th>
                        <th>중량</th>
                        <th>수량</th>
                        <th>파일</th>
                        <th>상태</th>
                    </tr>
                </thead>
                <tbody>
<%
    SQL=" Select A.odrdate, A.odrstatus, A.midx, A.odrkkg, A.odrea, A.odridx, B.mname, B.mpos, B.mhp, C.Order_name, C.Order_length, C.order_type, A.ksidx, A.filedet "
    SQL=SQL&" From tk_korderSub A "
    SQL=SQL&" Join tk_member B On A.midx=B.midx "
    SQL=SQL&" Join tk_khyorder C On A.odridx=C.order_idx "
    SQL=SQL&" Where A.kidx='"&kidx&"' "
    SQL=SQL&" Order by Order_name asc "

    Rs.open SQL,Dbcon,1,1,1
        If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF
        khy=khy+1
        odrkkg=Rs(3)
        odrea=Rs(4)
        filedet=Rs(13)
        odrstatus=Rs(1)
        Order_name=Rs(9)
        Order_length=Rs(10)
        order_type=Rs(11)
        ksidx=Rs(12)

        select case order_type
            case "1"
                order_type_text="무피"
            case "2"
                order_type_text="백피"
            case "3"
                order_type_text="블랙"
        end select

        select case Order_length
            case "1"
                Order_length_text="2,200mm"
            case "2"
                Order_length_text="2,400mm"
            case "3"
                Order_length_text="2,500mm"
            case "4"
                Order_length_text="2,800mm"
            case "5"
                Order_length_text="3,000mm"
            case "6"
                Order_length_text="3,200mm"
        end select

        if odrstatus="1" then 
            classname="btn btn-primary btn-sm"
            status_text="확인"
            odrv="2"
        elseif odrstatus="2"  then 
            classname="btn btn-danger btn-sm"
            status_text="확인완료"
            odrv="1"
        end if
%>
    <tr>
        <td rowspan="2"><%=khy%>/<%=ksidx%></td>
        <td ><%=order_type_text%></td>
        <td colspan="4"><%=Order_name%></td>
    </tr>
    <tr>

        <td><%=Order_length_text%></td>
        <td><%=odrkkg%></td>
        <td><%=odrea%></td>
        <td>
        <% if not isnull(filedet) and filedet <> "" then %>
            <button class="btn btn-danger" type="button" onclick="window.open('odrlistimg.asp??kidx=<%=kidx%>&ksidx=<%=ksidx%>&odrv=<%=odrv%>');">파일 보기</button>
        <% else %>
            없음
        <% end if %>
        </td>
               
        <td>
            <button class="<%=classname%> w-100" onclick="location.replace('odrlist.asp?kidx=<%=kidx%>&ksidx=<%=ksidx%>&odrv=<%=odrv%>');">
                <%=status_text%>
            </button>
        </td>
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
</div>

Coded By 호영

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
set Rs=Nothing
call dbClose()
%>
