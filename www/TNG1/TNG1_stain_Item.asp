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
%>
<%
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

listgubun="two"
subgubun="one2"
projectname="TNG 품목관리" %>
<%

rQTYIDX=Request("QTYIDX")
rsearchword=Request("SearchWord")

	if request("kgotopage")="" then
	kgotopage=1
	else
	kgotopage=request("kgotopage")
	end if
	page_name="TNG1_STAIN_Item.asp?SearchWord="&Request("SearchWord")&"&"

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
    /* 왼쪽 여백 제거 */
    body, html {
        zoom: 1;
        margin: 0; /* 기본 여백 제거 */
        padding: 0;
    }
     /* 부모 컨테이너를 꽉 채우기 */
    .container-full {
        width: 100%;
        margin: 0;
        padding: 0;
    }

    /* 테이블을 화면 전체로 늘리기 */
    table.full-width-table {
        width: 100%;
        border-collapse: collapse;
    }

    /* 필요하면 테이블 안쪽 패딩도 제거 */
    table.full-width-table th, table.full-width-table td {
        padding: 8px; /* 여백 조절 가능 */
        text-align: center; /* 텍스트 중앙 정렬 등 */
    }
    /* 🔹 버튼 크기 조정 */
    .btn-small {
        font-size: 12px; /* 글씨 크기 */
        padding: 2px 4px; /* 버튼 내부 여백 */
        height: 22px; /* 버튼 높이를 자동으로 */
        line-height: 1; /* 버튼 텍스트 정렬 */
        border-radius: 3px; /* 모서리를 조금 둥글게 */
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
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
            if (event.key === "Enter") {
                event.preventDefault();
                console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
                document.getElementById("hiddenSubmit").click();
            }
        }

        // Select 박스 변경(마우스 클릭/선택) 이벤트 핸들러
        function handleSelectChange(event, elementId1, elementId2) {
            console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }

        function handleChange(selectElement) {
            const selectedValue = selectElement.value;
            document.getElementById("hiddenSubmit").click();
        }

        // 폼 전체 Enter 이벤트 감지 (기본 방지 + 숨겨진 버튼 클릭)
        document.getElementById("dataForm").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault(); // 기본 Enter 동작 방지
                console.log("폼 전체에서 Enter 감지");
                document.getElementById("hiddenSubmit").click();
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_STAIN_Itemdb.asp?part=delete&searchWord=<%=rsearchword%>&QTYIDX="+sTR;
            }
        }
    </script>
</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">

        <div class="row justify-content-between">
            <div class="py-5 container text-center  card card-body">
      <div class="row">
        <div class="col-9"></div>
        <div class="col-3 text-start">
          <form id="Search" name="Search" action="tng1_pummok_item.asp" method="POST">   
          <!-- input 형식 시작--> 
                  <div class="input-group mb-3">
                      <span class="input-group-text">검색&nbsp;&nbsp;&nbsp;</span>
                      <input type="text" class="form-control" name="SearchWord" value="<%=Request("SearchWord")%>">
                        <button type="button" class="btn btn-outline-success" style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;" onclick="submit();">검색</button>
                        <button type="button" class="btn btn-outline-danger" style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;" 
                        onclick="location.replace('TNG1_STAIN_Item.asp?QTYIDX=0');">등록</button>
                  </div>
          <!-- input 형식 끝--> 
     
          </form>

        </div>
      </div>


            
        <div>
            <div style="width: 100%; margin: 0; padding: 0;">
                <table style="width: 100%; border-collapse: collapse;" id="datatablesSimple"  class="table table-hover">
                    <thead>
                        <tr>
                            <th align="center" width="80">순번</th>
                            <th align="center">품명</th>
                            <th align="center">업체명</th> 
                            <th align="center" width="100">자재등록</th> 
                            <th align="center">최종수정자</th>
                            <th align="center">최종수정일</th>

                        </tr>
                    </thead>
                    <tbody>
                        <form id="dataForm" name="dataForm" action="TNG1_STAIN_Itemdb.asp" method="POST" >   
                            <input type="hidden" name="QTYIDX" value="<%=rQTYIDX%>">
                            <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                            <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                            <% if rQTYIDX="0" then 
                            cccc="#800080"
                            %>
                            <tr bgcolor="<%=cccc%>" >
                                <th></th> <!-- 순번 -->
                                <td>
                                <select class="input-field" name="SJB_TYPE_NO" id="SJB_TYPE_NO"  onchange="handleChange(this)">
                                        <%

                                        sql="SELECT sjbtidx,SJB_TYPE_NO,SJB_TYPE_NAME from tng_sjbtype "
                                        sql=sql&" where sjbtstatus='1' "
                                        'response.write (SQL)&"<br>"
                                        Rs1.open Sql,Dbcon,1,1,1
                                        If Not (Rs1.bof or Rs1.eof) Then 
                                        Do until Rs1.EOF

                                            sjbtidx        = rs1(0)
                                            ySJB_TYPE_NO        = rs1(1)
                                            ySJB_TYPE_NAME        = rs1(2)

                                        %>
                                        <option value="<%=ySJB_TYPE_NO%>"  >
                                            <%=ySJB_TYPE_NAME%>
                                        </option>
                                        <%
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %>
                                    </select>
                                    <!-- 인서트용 팝업 버튼 -->
                                        <button type="button" class="btn btn-secondary btn-small" 
                                        onclick="window.open(
                                        'TNG1_SJB_TYPE_INSERTgl.asp?gotopage=<%=gotopage%>&QTYIDX=<%=QTYIDX%>&SearchWord=<%=rSearchWord%>#<%=QTYIDX%>', 
                                        'typeInsert', 
                                        'top=0,left=0,width=' + screen.availWidth + ',height=' + screen.availHeight + ',scrollbars=yes,resizable=yes'
                                        )">
                                        + 추가
                                    </button>
                                </td>
                                <td>
                                    <input class="input-field" type="text"  placeholder="규격" aria-label="규격" name="SJB_barlist" id="SJB_barlist" value="<%=SJB_barlist%>" onkeypress="handleKeyPress(event, 'SJB_barlist', 'SJB_barlist')"/>
                                </td> 
                                <td>
                                    <select class="input-field" name="SJB_FA" id="SJB_FA"  onchange="handleSelectChange(event, 'SJB_FA', 'SJB_FA')">
                                        <option value="0" <% If SJB_FA = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_FA = "1" Then Response.Write "selected" %> >수동</option>
                                        <option value="2" <% If SJB_FA = "2" Then Response.Write "selected" %> >자동</option>
                                    </select>
                                </td> 
                                <td></td>
                                <td>
                                    <select class="input-field" name="SJB_Paint" id="SJB_Paint"  onchange="handleSelectChange(event, 'SJB_Paint', 'SJB_Paint')">
                                        <option value="0" <% If SJB_Paint = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_Paint = "1" Then Response.Write "selected" %> >✅</option>
                                    </select>
                                </td> 
                                <td>
                                    <select class="input-field" name="SJB_St" id="SJB_St"  onchange="handleSelectChange(event, 'SJB_St', 'SJB_St')">
                                        <option value="0" <% If SJB_St = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_St = "1" Then Response.Write "selected" %> >✅</option>
                                    </select>
                                </td> 
                                <td>
                                    <select class="input-field" name="SJB_Al" id="SJB_Al"  onchange="handleSelectChange(event, 'SJB_Al', 'SJB_Al')">
                                        <option value="0" <% If SJB_Al = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_Al = "1" Then Response.Write "selected" %> >✅</option>
                                    </select>
                                </td> 
                                <td></td> <!-- 작성자 키 -->
                                <td></td> <!-- 최초 작성일 -->
                                <td></td> <!-- 최종 수정자 키 -->
                                <td></td> <!-- 최종 수정일시 -->
                            </tr>
                            <% end if %>
                            <% 
                                i=0
                                cccc=""
                                SQL = "SELECT A.QTYIDX, A.SJB_TYPE_NO, D.SJB_TYPE_NAME "
                                SQL = SQL & ", A.SJB_barlist, A.SJB_Paint, A.SJB_St, A.SJB_Al "
                                SQL = SQL & ", A.SJB_midx, Convert(varchar(10), A.SJB_mdate, 121) AS SJB_mdate "
                                SQL = SQL & ", A.SJB_meidx, Convert(varchar(10), A.SJB_medate, 121) AS SJB_medate "
                                SQL = SQL & ", B.mname, C.mname, A.SJB_FA "
                                SQL = SQL & " FROM TNG_SJB A "
                                SQL = SQL & " JOIN tk_member B ON A.SJB_midx = B.midx "
                                SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.SJB_meidx = C.midx "
                                SQL = SQL & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
                                SQL = SQL & " WHERE A.QTYIDX <> '' "
                                If Request("SearchWord") <> "" Then
                                    SQL = SQL & " AND ( A.SJB_barlist LIKE '%" & Request("SearchWord") & "%' "
                                    SQL = SQL & " OR D.SJB_TYPE_NAME LIKE '%" & Request("SearchWord") & "%' ) "
                                End If
                                SQL = SQL & " ORDER BY A.QTYIDX DESC"
                                'Response.write (SQL)&"<br>"
                                Rs.open Sql,Dbcon,1,1,1
                                Rs.PageSize = 10
                                If Not (Rs.EOF Or Rs.BOF) Then
                                no = Rs.recordcount - (Rs.pagesize * (kgotopage-1) ) + 1
                                totalpage=Rs.PageCount 
                                Rs.AbsolutePage =kgotopage
                                i=1
                                for j=1 to Rs.RecordCount 
                                if i>Rs.PageSize then exit for end if
                                if no-j=0 then exit for end if

                                QTYIDX        = Rs(0)
                                SJB_TYPE_NO    = Rs(1)
                                ySJB_TYPE_NAME = Rs(2)   ' 조인 결과로 바로 가져옴
                                SJB_barlist    = Rs(3)
                                SJB_Paint      = Rs(4)
                                SJB_St         = Rs(5)
                                SJB_Al         = Rs(6)
                                SJB_midx       = Rs(7)
                                SJB_mdate      = Rs(8)
                                SJB_meidx      = Rs(9)
                                SJB_medate     = Rs(10)
                                mname          = Rs(11)
                                mename         = Rs(12)
                                SJB_FA         = Rs(13)
                                i=i+1

                                

                                select case SJB_FA
                                    case "0"
                                        SJB_FA_text="❌"
                                    case "1"
                                        SJB_FA_text="수동"
                                    case "2"
                                        SJB_FA_text="자동"
                                end select

                                select case SJB_Paint
                                    case "0"
                                        SJB_Paint_text="❌"
                                    case "1"
                                        SJB_Paint_text="✅"
                                end select

                                select case SJB_St
                                    case "0"
                                        SJB_St_text="❌"
                                    case "1"
                                        SJB_St_text="✅"
                                end select

                                select case SJB_Al
                                    case "0"
                                        SJB_Al_text="❌"
                                    case "1"
                                        SJB_Al_text="✅"
                                end select
                            %>
                            
                            <% 
                            'response.write "QTYIDX : "&QTYIDX&"<br>"
                            'response.write "rQTYIDX : "&rQTYIDX&"<br>"
                            if int(QTYIDX)=int(rQTYIDX) then 
                            cccc="#E7E7E7"
                            %>
                            <tr bgcolor="<%=cccc%>">
                                <td align="center"><a name="<%=QTYIDX%>">-><button type="button" class="btn btn-outline-danger" Onclick="del('<%=QTYIDX%>');"><%=no-j%></button></td> <!-- 삭제  -->
                                <td>
                                    <select class="input-field" name="SJB_TYPE_NO" id="SJB_TYPE_NO"  onchange="handleChange(this)">
                                        <%
                                        If SJB_TYPE_NO = "" Then SJB_TYPE_NO = "14"

                                        sql="SELECT sjbtidx,SJB_TYPE_NO,SJB_TYPE_NAME from tng_sjbtype "
                                        sql=sql&" where sjbtstatus='1' "
                                        'response.write (SQL)&"<br>"
                                        Rs1.open Sql,Dbcon,1,1,1
                                        If Not (Rs1.bof or Rs1.eof) Then 
                                        Do until Rs1.EOF

                                            sjbtidx        = rs1(0)
                                            ySJB_TYPE_NO        = rs1(1)
                                            ySJB_TYPE_NAME        = rs1(2)

                                        %>
                                        <option value="<%=ySJB_TYPE_NO%>" <% If cint(SJB_TYPE_NO) = cint(ySJB_TYPE_NO) Then Response.Write "selected" End If %> >
                                            <%=ySJB_TYPE_NAME%>
                                        </option>
                                        <%
                                        Rs1.MoveNext
                                        Loop
                                        End If
                                        Rs1.close
                                        %>    
                                    </select>
                                </td>
                                <td>
                                    <input class="input-field" type="text" placeholder="규격" aria-label="규격" name="SJB_barlist" id="SJB_barlist" value="<%=SJB_barlist%>" onkeypress="handleKeyPress(event, 'SJB_barlist', 'SJB_barlist')"/>
                                </td> 
                                <td>
                                    <button class="btn btn-success btn-small" type="button" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?QTYIDX=<%=rQTYIDX%>#<%=rQTYIDX%>');">자재등록수정</button>
                                </td>
                                <td>
                                    <select class="input-field" name="SJB_FA" id="SJB_FA"  onchange="handleSelectChange(event, 'SJB_FA', 'SJB_FA')">
                                        <option value="0" <% If SJB_FA = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_FA = "1" Then Response.Write "selected" %> >수동</option>
                                        <option value="2" <% If SJB_FA = "2" Then Response.Write "selected" %> >자동</option>
                                    </select>
                                </td> 
                                <td>
                                    <select class="input-field" name="SJB_Paint" id="SJB_Paint"  onchange="handleSelectChange(event, 'SJB_Paint', 'SJB_Paint')">
                                        <option value="0" <% If SJB_Paint = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_Paint = "1" Then Response.Write "selected" %> >✅</option>
                                    </select>
                                </td> 
                                <td>
                                    <select class="input-field" name="SJB_St" id="SJB_St"  onchange="handleSelectChange(event, 'SJB_St', 'SJB_St')">
                                        <option value="0" <% If SJB_St = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_St = "1" Then Response.Write "selected" %> >✅</option>
                                    </select>
                                </td> 
                                <td>
                                    <select class="input-field" name="SJB_Al" id="SJB_Al"  onchange="handleSelectChange(event, 'SJB_Al', 'SJB_Al')">
                                        <option value="0" <% If SJB_Al = "0" Then Response.Write "selected" %> >❌</option>
                                        <option value="1" <% If SJB_Al = "1" Then Response.Write "selected" %> >✅</option>
                                    </select>
                                </td> 
                                <td><%=mename%></td> <!-- 최종 수정자 키 -->
                                <td><%=SJB_medate%></td> <!-- 최종 수정일시 -->
                            </tr>
                            <% else 
                            'cccc="#CCCCCC"
                            %>
                            <tr bgcolor="<%=cccc%>">
                                <td align="center"><%=no-j%><a name="<%=QTYIDX%>"></td><!-- 순번 -->
                                <td><input class="input-field" type="text" value="<%=ySJB_TYPE_NAME%>" onclick="location.replace('TNG1_STAIN_Item.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=rbfidx%>&QTYIDX=<%=QTYIDX%>');"/> </td>                           
                                <td style="white-space: nowrap;">
                                    <input class="input-field" type="text" value="<%=SJB_barlist%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');" />
                                </td>
                                <td>
                                    <button class="btn btn-success btn-small" type="button" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');">자재등록보기</button>
                                </td>
                                <td><input class="input-field" type="text" value="<%=SJB_FA_text%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');"/> </td>  
                                <td><input class="input-field" type="text" value="<%=SJB_Paint_text%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');"/> </td>  
                                <td><input class="input-field" type="text"  value="<%=SJB_St_text%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');"/> </td> 
                                <td><input class="input-field" type="text"  value="<%=SJB_Al_text%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');"/> </td> 
                                <td><input class="input-field" type="text"  value="<%=mename%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');"/></td> <!-- 최종 수정자 키 -->
                                <td><input class="input-field" type="text"  value="<%=SJB_medate%>" onclick="location.replace('TNG1_STAIN_Item.asp?kgotopage=<%=kgotopage%>&QTYIDX=<%=QTYIDX%>&searchWord=<%=rsearchword%>#<%=QTYIDX%>');"/></td> <!-- 최종 수정일시 -->
                            </tr>
                            <% end if %>
                            <%
                        
                            SJB_FA_text =""
                            SJB_Paint_text =""
                            SJB_St_text =""
                            SJB_Al_text =""
                            cccc=""
                            Rs.MoveNext 
                        
                            Next 
                            End If 
                            %>
                            <button type="submit" id="hiddenSubmit" style="display: none;"></button>
                        </form>    
                    </tbody>
                </table>
            </div>
                    <div class="row">
                      <div  class="col-10 py-3"> 
<!--#include Virtual = "/inc/kpaging.asp" -->
                      </div>
<%
Rs.Close
%>
        </div>
    </div>
            </div>
        </div>
        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
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