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
if request("gotopage")="" then
gotopage=1
else
gotopage=request("gotopage")
end if 
page_name="paint_item.asp?"
%>

<% projectname="도장 관리" %>

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
    <script>

    </script>
 
  </head>
  <body>
  <!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_cyj.asp"-->
        <div class="container py-5 text-center">
            <div class="row">
                <div class="input-group mb-1">
                    <div class="col-11 text-start">
                    <h3>도장 관리</h3>
                    </div>
                    <div class="col-1 text-end">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">검색</button>
                    </div>
                </div>
            </div>
            <div class="text-end mb-1">
        <!--modal-->
                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                            <h1 class="modal-title fs-5" id="exampleModalLabel">검색</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="close"></button>
                            </div>
                            <div class="modal-body">
                                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="paint_item.asp" name="form1">
                                <div class="mb-3">
                                <input type="text" class="form-control" id="formGroupExampleInput" placeholder="검색어를 입력해주세요" name="SearchWord">
                                </div>
                                <div class="col-12">
                                <button type="button" onclick="submit();" class="btn btn-primary ">등록</button>
                                </div>
                                </form>
                            </div>
                        </div>
                     </div>
                </div>
        <!--modal end-->
            </div>

            <div class="card mb-4 card-body">
                <table class="table">
                    <thead>
                    <tr>
                        <th style="text-align: center;">#</th>
                        <th style="text-align: center;">제조사</th>
                        <th style="text-align: center;">색상타입</th>
                        <th style="text-align: center;">페인트 이름</th>
                        <th style="text-align: center;">도장 횟수</th>
                        <th style="text-align: center;">단가</th>
                        <th style="text-align: center;">할증비율</th>
                        <th style="text-align: center;">페인트 이미지</th>
                        <th style="text-align: center;">샘플 발주처</th>
                        <th style="text-align: center;">샘플명 </th>
                        <th style="text-align: center;">샘플 이미지</th>
                        <th style="text-align: center;">등록자</th>
                        <th style="text-align: center;">등록일</th>

                    </tr>
                    </thead>
                    <tbody class="table-group-divider">

                        <%
                        SQL = "SELECT a.pidx, a.pcode, a.pshorten, a.pname, a.pprice, a.pstatus, a.pmidx, a.pwdate, a.pemidx, a.pewdate "
                        SQL = SQL & ", a.pname_brand, a.p_percent, a.p_image, a.p_sample_image, a.p_sample_name "
                        SQL = SQL & ", a.cidx, a.sjidx, a.in_gallon, a.out_gallon, a.remain_gallon "
                        SQL = SQL & ", b.cname, c.mname ,a.paint_type ,a.coat "
                        SQL = SQL & " FROM tk_paint a "
                        SQL = SQL & " LEFT  join tk_customer b on  a.cidx= b.cidx "
                        SQL = SQL & " LEFT  join tk_member c on  a.pmidx= c.midx "
                        SQL = SQL & "  WHERE pidx <> 0 "
                        SQL = SQL & " order by a.pidx desc "
                        If Request("SearchWord")<>"" Then 
                        SQL=SQL&" Where(pcode like '%"&request("SearchWord")&"%'  or pshorten like '%"&request("SearchWord")&"%'  "
                        SQL=SQL&" or pname like '%"&request("SearchWord")&"%' or pname_brand like '%"&request("SearchWord")&"%'  "
                        SQL=SQL&" or p_sample_name like '%"&request("SearchWord")&"%' or cname like '%"&request("SearchWord")&"%' "
                        SQL=SQL&" or mname like '%"&request("SearchWord")&"%' ) "
                        End If 
                        Response.write (SQL)&"<br>"
                        Rs.Open SQL, Dbcon ,1,1,1
                        Rs.PageSize = 10
                        if not (Rs.EOF or Rs.BOF) then 
                        no = Rs.Recordcount - (Rs.pagesize * (gotopage-1) ) + 1
                        totalpage=Rs.PageCount
                        Rs.AbsolutePage=gotopage
                        i=1
                        for j=1 to Rs.RecordCount 
                        if i>Rs.PageSize then exit for end if 
                        if no-j=0 then exit for end if 
                            pidx           = Rs(0)  ' [pidx] 페인트 고유번호
                            pcode          = Rs(1)  ' [pcode] 코드
                            pshorten       = Rs(2)  ' [pshorten] 축약명
                            pname          = Rs(3)  ' [pname] 페인트 이름
                            pprice         = Rs(4)  ' [pprice] 단가
                            pstatus        = Rs(5)  ' [pstatus] 상태
                            pmidx          = Rs(6)  ' [pmidx] 등록자
                            pwdate         = Rs(7)  ' [pwdate] 등록일
                            pemidx         = Rs(8)  ' [pemidx] 수정자
                            pewdate        = Rs(9)  ' [pewdate] 수정일
                            pname_brand    = Rs(10) ' [pname_brand] 제조사 번호
                            p_percent      = Rs(11) ' [p_percent] 할증비율
                            p_image        = Rs(12) ' [p_image] 페인트 이미지
                            p_sample_image = Rs(13) ' [p_sample_image] 샘플 이미지
                            p_sample_name  = Rs(14) ' [p_sample_name] 샘플명
                            cidx           = Rs(15) ' [cidx] 수주처
                            sjidx          = Rs(16) ' [sjidx] 수주키
                            in_gallon       = Rs(17) ' [in_gallon] 입고량
                            out_gallon      = Rs(18) ' [out_gallon] 사용량
                            remain_gallon   = Rs(19) ' [remain_gallon] 남은량
                            cname          = Rs(20) ' [cname] 수주처 이름
                            mname          = Rs(21) ' [mname] 작성자 이름
                            paint_type     = Rs(22) ' [paint_type] 색상 타입
                            coat           = Rs(23) ' [coat] 도장 횟수

                        %>

                        <tr>
                            <th><%=no-j%></th>
                            <td><%=pname_brand%></td>
                            <td><%=paint_type%></td>
                            <td><%=pname%></td>
                            <td><%=pprice%></td>
                            <td><%=p_percent%></td>
                            <td><%=p_image%></td>   
                            <td><%=cname%></td>                           
                            <td><%=p_sample_name%></td>
                            <td><%=p_sample_image%></td>
                            <td><%=mname%></td>
                            <td><%=pewdate%></td>
                        </tr>
        
                        <%
                        Rs.MoveNext
                        i=i+1
                        Next 
                        End If

                        %>
                    </tbody>
                </table>
            </div>


            <div class="row col-12 py-3">
            <!--#include Virtual = "/inc/paging.asp"-->
            </div>
<%
rs.close
%>
        </div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs=Nothing
call dbClose()
%>