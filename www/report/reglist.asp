<!--
주요 테이블
tk_reportm (성적서 품목 DB)

fidx:성적서 품목 idx
fname:성적서 품목명
fstatus:성적서 품목 사용유무
ftype:성적서 품목 타입
1-프레임재질
2-간봉재질
3-유리사양
4-유리상세
5-창호타입
6-깊이
7-너비
8-개폐방식

fmidx:성적서 품목 등록자(수정자)
fdate:성적서 품목 등록일자(수정일자)


-----------------------------------중요한 내용-----------------------------------------------------------                               
성적서 수정시, 깊이, 너비, 개폐방식, 프레임재질, 유리사양, 유리상세, 창호타입, 간봉재질을 선택하는데, 
이를 선택할때 뜨는 항목들을 "성적서 품목"이라고 명칭하고 tk_reportm이라는 테이블에 값들을 저장해줌.


-->


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
    projectname="성적서품목 관리"
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

    page_name="reglist.asp?"
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
<script>
    function del(fidx){
        if(confirm("정말로 삭제하시겠습니까?")){
            location.href="regdeldb.asp?fidx="+fidx;
        }
    }
</script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG2.asp"-->

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 container text-center">
                        <div class="input-group mb-1">
                            <div class="col-10 text-end">
                            </div>

                            <div class="col-12 text-end">
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">성적서 품목 검색</button>
                                <button type="button" class="btn btn-success" onclick="location.replace('reg.asp');">성적서 품목 등록</button>
                            </div>
                        </div>
                        <div class="text-end mb-1">
                        <!--Modal, 새로운 주소를 가진 페이지가 열리는 것이 아닌, 현재 페이지에서 새로운 섹션이 생기는것(반응형)-->
                        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>

                                    <div class="modal-body">  
                                        <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="reglist.asp" name="form1">
                                            <div class="mb-3">
                                                <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해 주세요." name="SearchWord">
                                            </div>

                                            <div class="col-12">
                                                <button type="submit" class="btn btn-primary" onclick="submit();">검색</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--Modal End-->
                    </div>
                    
                    <div class="card mb-0 card-body">
                    <!--게시판 테이블 시작-->
                        <table class="table">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">구분</th>
                                    <th scope="col">품목</th>
                                    <th scope="col">상태</th>
                                    <th scope="col">등록자</th>
                                    <th scope="col">등록일</th>
                                    <th scope="col">관리</th>
                                </tr>
                            </thead>

                            <tbody class="table-group-divider">

                                <%
                                SQL=" Select A.fidx, A.fname, A.fstatus, A.ftype, A.fmidx, Convert(varchar(10),A.fdate,102), B.mname "
                                SQL=SQL&" From tk_reportm A "
                                SQL=SQL&" Join tk_member B On A.fmidx=B.midx "

                                if Request("SearchWord")<>"" then
                                    SQL=SQL&" Where (A.fname like '%"&request("SearchWord")&"%') "
                                end if

                                SQL=SQL&" Order by A.fidx desc "
                                'Response.write (SQL)& "<br>"
                                'Response.End

                                Rs.Open Sql,Dbcon,1,1,1
                                Rs.PageSize=10

                                if not (Rs.EOF or Rs.BOF) then
                                no = Rs.recordcount - (Rs.pagesize * (gotopage-1))+1
                                totalpage=Rs.PageCount
                                Rs.AbsolutePage=gotopage
                                i=1

                                for j=1 to Rs.RecordCount
                                if i>Rs.PageSize then exit for end if
                                if no-j=0 then exit for end if

                                fidx=Rs(0)
                                fname=Rs(1)
                                fstatus=Rs(2)
                                ftype=Rs(3)
                                fmidx=Rs(4)
                                fdate=Rs(5)
                                mname=Rs(6)


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
                                        ftype_text="깊이"
                                    case "7"
                                        ftype_text="너비"
                                    case "8"
                                        ftype_text="개폐방식"

                                end Select

                                if fstatus="0" then
                                    fstatus_text="미사용"
                                elseif fstatus="1" then
                                    fstatus_text="사용중"
                                end if
                                %>

                                <tr>
                                    <th scope="row"><%=no-j%></th>  <!--#-->
                                    <td><%=ftype_text%></td>        <!--구분-->
                                    <td><%=fname%></td>             <!--품목-->
                                    <td><%=fstatus_text%></td>      <!--상태-->
                                    <td><%=mname%></td>             <!--등록자-->
                                    <td><%=fdate%></td>             <!--등록일-->
                                    <td>
                                        <button type="button" class="btn btn-light" onclick="location.replace('regudt.asp?fidx=<%=fidx%>&gotopage=<%=gotopage%>');">수정</button>
                                    </td>
                                </tr>

                                <%
                                i=i+1
                                Rs.MoveNext
                                Next
                                End If
                                %>
                            </tbody>
                        </table>
                    </div>
                    <!--게시판 테이블 끝-->
                </div>

                <div class="row col-12 py-0">    
                    <!--#include virtual = "/inc/paging.asp"-->
                </div>
            </div>
            <!--입력종료-->

            <%
            Rs.Close
            %>
            
            <!--Footer 시작-->
            Coded By 림 
            <!--Footer 끝-->

        </main>
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
