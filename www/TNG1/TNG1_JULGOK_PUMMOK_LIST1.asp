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
Set Rs1 = Server.CreateObject("ADODB.Recordset")
%>
<%
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

listgubun="one"

projectname="TNG 품목관리" 
%>
<%

kgotopage=Request("kgotopage")
gotopage=Request("gotopage")
rbfidx=Request("bfidx")
rksearchword=Request("ksearchword")
rsearchword=Request("SearchWord")
rSJB_IDX = Request("SJB_IDX")
'rSJB_TYPE_NO = Request("SJB_TYPE_NO")

'rWHICHI_FIX  = Request("WHICHI_FIX")
'rWHICHI_AUTO = Request("WHICHI_AUTO")

'Response.Write "rSJB_TYPE_NO : " & rSJB_TYPE_NO & "<br>"
'response.end
	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name = "TNG1_JULGOK_PUMMOK_LIST1.asp?kgotopage=" & kgotopage & "&rbfidx=" & rbfidx & "&sjb_idx=" & rsjb_idx & "&ksearchword=" & rksearchword & "&SearchWord=" & Request("SearchWord") & "&mode=" & Request("mode") & "&"

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
    <style>
        .custom-bg {
            background-color: #f8f8f8; /* Bootstrap danger background color */
            padding: 20px;
            border-radius: 5px;
        }
    </style>
<style>
    table {
      border-collapse: collapse;
      width: 80%;
      margin: 20px auto;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: left;
      position: relative;
    }

    .hover-image {
      display: none;
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateY(-100%);
      width: 250px;
      border: 1px solid #aaa;
      background-color: #fff;
      z-index: 100;
      box-shadow: 0px 0px 5px rgba(0,0,0,0.2);
    }

    .title-cell:hover .hover-image {
      display: block;
    }

    .title-cell {
      cursor: pointer;
    }
  </style>
    <script>
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
            var tag = event.target.tagName.toLowerCase();

            if (event.key === "Enter") {
                if (tag === "textarea") {
                    // textarea에서는 줄바꿈 방지 + submit 실행
                    event.preventDefault();
                    console.log(`Enter 눌림 (textarea): ${elementId1}, ${elementId2}`);
                    document.getElementById("hiddenSubmit").click();
                } else {
                    // input 등에서도 submit 실행
                    event.preventDefault();
                    console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
                    document.getElementById("hiddenSubmit").click();
                }
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
        function del(str){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_JULGOK_PUMMOK_LIST_DB.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=rSJB_IDX%>&part=delete&bfidx="+str;
            }
        }
    </script>
    <script>
        function validateForm() {
            {
                document.frmMain.submit();
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
                <div class="input-group mb-3">
                    <%
                    sql = "SELECT A.SJB_TYPE_NO, B.SJB_TYPE_NAME, A.SJB_barlist FROM TNG_SJB A"
                    sql = sql & " LEFT OUTER JOIN tng_sjbtype B ON A.SJB_TYPE_NO = B.SJB_TYPE_NO"
                    sql = sql & " WHERE A.SJB_IDX = '" & rSJB_IDX & "'"
                    'response.write (SQL)&"<br>"
                    'response.end
                        Rs.open Sql,Dbcon,1,1,1
                        If Not (Rs.bof or Rs.eof) Then 
                        ySJB_TYPE_NO = rs(0)
                        ySJB_TYPE_NAME = rs(1)
                        ySJB_barlist = rs(2)
                    End If
                    Rs.close
                    %>
                    <h3><%=ySJB_TYPE_NAME%>_<%=ySJB_barlist%></h3>
                </div>
                <div class="input-group mb-3">
                    <button type="button"
                        class="btn btn-outline-danger"
                        style="writing-mode: horizontal-tb; letter-spa
                        g: normal; white-space: nowrap;"
                        onclick="location.replace('TNG1_PUMMOK_Item.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=rSJB_IDX%>');">돌아가기
                    </button>
                </div>
            <div class="col text-end">
                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="TNG1_JULGOK_PUMMOK_LIST1.asp" id="form1"  name="form1">   
                    <!-- *검색 폼 form1에서는 이걸 완전히 제거해야 에러가 안남 -->
                    <!-- <input type="hidden" name="bfidx" value="<%=rbfidx%>"> -->
                    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                    <!-- *gotopage가 검색이 되면서 변수가 변경 -> totalpage=Rs.PageCount Rs.AbsolutePage =gotopage 매치가 안됨 -->
                    <!-- <input type="hidden" name="gotopage" value="<%=gotopage%>"> -->
                    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
                    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
                    <div style="display: flex; align-items: center; gap: 8px;"> 
                        <input class="form-control" type="text" placeholder="품명,규격 조회" aria-label="품명,규격 조회" aria-describedby="btnNavbarSearch" name="ksearchword" value="<%=rksearchword%>"/>
                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                </form> 
                </div>
            </div>
        <div>
<form id="dataForm" action="TNG1_JULGOK_PUMMOK_LIST_DB.asp" method="POST" >   
    <input type="hidden" name="bfidx" value="<%=rbfidx%>">
    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
    <input type="hidden" name="gotopage" value="<%=gotopage%>">
    <input type="hidden" name="kgotopage" value="<%=kgotopage%>">
    <input type="hidden" name="SearchWord" value="<%=rsearchword%>">
    <input type="hidden" name="ksearchword" value="<%=rksearchword%>">
<!-- 신규입력 폼 시작 -->
    <% if rbfidx="0" then 
    cccc="#E7E7E7"
    %>
      <div style="width: 100%; margin: 0; padding: 0;">
        <table style="width: 100%; border-collapse: collapse;" id="datatablesSimple"  class="table table-hover">
          <thead>
            <tr>
              <th style="text-align: center;">수동자재명</th>
              <th style="text-align: center;">수동사용위치</th>
              <th style="text-align: center;">자동자재명</th>                            
              <th style="text-align: center;">자동사용위치</th>
              <th style="text-align: center;">측면폭</th>
              <th style="text-align: center;">정면폭</th>
            </tr>
          </thead>
          <tbody>
            <tr bgcolor="<%=cccc%>" >
              <td><input class="input-field" type="text" size="" name="set_name_FIX" id="set_name_FIX" value="<%=set_name_FIX%>" onkeypress="handleKeyPress(event, 'set_name_FIX', 'set_name_FIX')"/></td> 
            <td>
                
              <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                <option value="0">없음</option>   
                <%
                sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                sql = sql & "FROM tng_whichitype "
                sql = sql & "WHERE bfwstatus = 1   "
                'response.write (sql)&"<br>"

                Rs1.open sql, Dbcon, 1, 1, 1
                If Not (Rs1.bof Or Rs1.eof) Then 
                    Do Until Rs1.EOF

                        bfwidx           = Rs1(0)
                        yWHICHI_FIX      = Rs1(1)
                        yWHICHI_FIXname  = Rs1(2)
                        yWHICHI_AUTO     = Rs1(3)
                        yWHICHI_AUTOname = Rs1(4)
                        bfwstatus        = Rs1(5)
                ' 🔹 NULL 또는 빈값이 아니면 출력
                If Not IsNull(yWHICHI_FIX)  Then
                %>
                <option value="<%=yWHICHI_FIX%>" >
                <%=yWHICHI_FIXname%>
                </option>
                <%
                End If
                Rs1.MoveNext
                Loop
                End If
                Rs1.close
                %>
              </select>
            </td>
            <td>
              <input class="input-field" type="text" size="" name="set_name_AUTO" id="set_name_AUTO" value="<%=set_name_AUTO%>" onkeypress="handleKeyPress(event, 'set_name_AUTO', 'set_name_AUTO')"/>
            </td> 
            <td>

              <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                <option value="0">없음</option>   
                <%
                sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                sql = sql & "FROM tng_whichitype "
                sql = sql & "WHERE bfwstatus = 1   "
                'response.write (sql)&"<br>"

                Rs1.open sql, Dbcon, 1, 1, 1
                If Not (Rs1.bof Or Rs1.eof) Then 
                    Do Until Rs1.EOF

                        bfwidx           = Rs1(0)
                        yWHICHI_FIX      = Rs1(1)
                        yWHICHI_FIXname  = Rs1(2)
                        yWHICHI_AUTO     = Rs1(3)
                        yWHICHI_AUTOname = Rs1(4)
                        bfwstatus        = Rs1(5)
                ' 🔹 NULL 또는 빈값이 아니면 출력
                If Not IsNull(yWHICHI_AUTO)  Then
                %>
                <option value="<%=yWHICHI_AUTO%>" >
                    <%=yWHICHI_AUTOname%>
                </option>
                <%
                End If
                Rs1.MoveNext
                Loop
                End If
                Rs1.close
                %>
              </select>
            </td>
              <td>
              <input class="input-field" type="text" size="8" name="xsize" id="xsize" value="<%=xsize%>" onkeypress="handleKeyPress(event, 'xsize', 'xsize')"/>
              </td> 
              <td>
                <input class="input-field" type="text" size="8" name="ysize" id="ysize" value="<%=ysize%>" onkeypress="handleKeyPress(event, 'ysize', 'ysize')"/>
              </td> 
            </tr>
          </body>
        </table>
      </div>   
<% end if %>    
<!-- 신규입력 폼 끝 -->
        <div class="row mt-1">
<% 
cccc=""
SQL = "SELECT A.bfidx, A.set_name_FIX, A.set_name_AUTO, A.WHICHI_FIX, A.WHICHI_AUTO, A.xsize "
SQL = SQL & ", A.ysize, A.bfimg1, A.bfimg2, A.sjb_idx, A.bfmidx, Convert(varchar(10), A.bfwdate, 121) "
SQL = SQL & ", A.bfemidx, Convert(varchar(10), A.bfewdate, 121), B.mname "
SQL = SQL & ", C.mname, A.TNG_Busok_idx, D.T_Busok_name_f, A.bfimg3, A.TNG_Busok_idx2, E.T_Busok_name_f "
SQL = SQL & ", F.WHICHI_FIXname, G.WHICHI_AUTOname "  ' 🔹 추가된 컬럼
SQL = SQL & ", A.gwsize, A.gysize, A.dwsize, A.dysize "  ' 🔹 추가된 컬럼
SQL = SQL & ", H.SJB_TYPE_NO, H.SJB_FA "   ' 🔹 추가된 컬럼 2
SQL = SQL & ", A.pcent  "  ' 🔹 새로 추가된 컬럼 3
SQL = SQL & ", A.TNG_Busok_idx3 , A.bfimg4 , I.T_Busok_name_f ,a.boyang "  ' 🔹 새로 추가된 컬럼 4
SQL = SQL & ", j.SJB_TYPE_NAME , h.SJB_barlist ,a.boyangtype "  ' 🔹 새로 추가된 컬럼 5
SQL = SQL & "FROM tk_barasiF A "
SQL = SQL & "JOIN tk_member B ON A.bfmidx = B.midx "
SQL = SQL & "LEFT OUTER JOIN tk_member C ON A.bfemidx = C.midx "
SQL = SQL & "LEFT OUTER JOIN TNG_Busok D ON A.TNG_Busok_idx = D.TNG_Busok_idx "
SQL = SQL & "LEFT OUTER JOIN TNG_Busok E ON A.TNG_Busok_idx2 = E.TNG_Busok_idx "
SQL = SQL & "LEFT OUTER JOIN TNG_Busok I ON A.TNG_Busok_idx3 = I.TNG_Busok_idx "
SQL = SQL & "LEFT OUTER JOIN tng_whichitype F ON A.WHICHI_FIX = F.WHICHI_FIX "
SQL = SQL & "LEFT OUTER JOIN tng_whichitype G ON A.WHICHI_AUTO = G.WHICHI_AUTO "
SQL = SQL & "LEFT OUTER JOIN TNG_SJB H ON A.SJB_IDX = H.SJB_IDX "  ' ✅ 이 줄 추가!
SQL = SQL & "LEFT OUTER JOIN tng_sjbtype j ON H.SJB_TYPE_NO = j.SJB_TYPE_NO "  ' ✅ 규격하고  SJB_TYPE_NAME  SJB_barlist 가져오기
    If rSJB_IDX <> "" Then
    SQL = SQL & "WHERE A.sjb_idx = '" & rSJB_IDX & "' "
    End If
    If rksearchword <>"" Then 
        SQL = SQL & "AND ( A.set_name_FIX LIKE '%" & rksearchword & "%' "
        SQL = SQL & "OR A.set_name_AUTO LIKE '%" & rksearchword & "%' "
        SQL = SQL & "OR A.xsize LIKE '%" & rksearchword & "%' "
        SQL = SQL & "OR A.ysize LIKE '%" & rksearchword & "%' "
        SQL = SQL & "OR E.T_Busok_name_f LIKE '%" & rksearchword & "%' "
        SQL = SQL & "OR F.WHICHI_FIXname LIKE '%" & rksearchword & "%' "
        SQL = SQL & "OR G.WHICHI_AUTOname LIKE '%" & rksearchword & "%' ) "
    End If 
SQL = SQL & "ORDER BY A.bfidx desc"
 
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
Rs.PageSize = 10
If Not (Rs.EOF Or Rs.BOF) Then
no = Rs.recordcount - (Rs.pagesize * (gotopage-1) ) + 1
totalpage=Rs.PageCount 
Rs.AbsolutePage =gotopage
i=1
for j=1 to Rs.RecordCount 
if i>Rs.PageSize then exit for end if
if no-j=0 then exit for end if

  bfidx         = Rs(0)
  set_name_FIX  = Rs(1)
  set_name_AUTO = Rs(2)
  WHICHI_FIX    = Rs(3)
' WHICHI_FIX 가 비어 있거나 이상한 값일 경우 대비
If isnull(WHICHI_FIX)  Then
    WHICHI_FIX = "0"
End If
  WHICHI_AUTO   = Rs(4) 
' WHICHI_AUTO 가 비어 있거나 이상한 값일 경우 대비
If isnull(WHICHI_AUTO)  Then
    WHICHI_AUTO = "0"
End If
  xsize         = Rs(5)
  ysize         = Rs(6)
  bfimg1        = Rs(7)
  bfimg2        = Rs(8)
  sjb_idx       = Rs(9)
  bfmidx        = Rs(10)
  bfwdate       = Rs(11)
  bfemidx       = Rs(12)
  bfewdate      = Rs(13)
  mname       = Rs(14)
  mename      = Rs(15)
  Busok_idx   = Rs(16)
  ' Busok_idx 가 비어 있거나 이상한 값일 경우 대비
  if isnull(Busok_idx) then 
    Busok_idx="0"
  end if
  T_Busok_name_f   = Rs(17)
  bfimg3        = Rs(18)
  Busok_idx2   = Rs(19)
  ' Busok_idx2 가 비어 있거나 이상한 값일 경우 대비
  if isnull(Busok_idx2) then 
    Busok_idx2="0"
  end if

  T_Busok_name_f2= rs(20)
  WHICHI_FIXname  = Rs(21)  ' F.WHICHI_FIXname
  WHICHI_AUTOname = Rs(22)  ' G.WHICHI_AUTOname
  gwsize          = Rs(23)
  gysize          = Rs(24)
  dwsize          = Rs(25)
  dysize          = Rs(26)
  SJB_TYPE_NO = Rs(27)  ' H.SJB_TYPE_NO
  SJB_FA      = Rs(28)  ' H.SJB_FA
  pcent_result = Rs(29)  ' A.pcent
    If IsNull(pcent_result) Or pcent_result = "" Then
    pcent_result = 0
    End If
  Busok_idx3   = Rs(30)
  ' Busok_idx2 가 비어 있거나 이상한 값일 경우 대비
  if isnull(Busok_idx3) then 
    Busok_idx3="0"
  end if
  bfimg4        = Rs(31)
  T_Busok_name_f3= rs(32)  
If IsNull(SJB_TYPE_NO) Then SJB_TYPE_NO = 0
If IsNull(SJB_FA) Then SJB_FA = 0

boyang = Rs(33)  ' 🔹 새로 추가된 컬럼 4
    aSJB_TYPE_NAME = Rs(34)  ' i.SJB_TYPE_NAME
    aSJB_barlist   = Rs(35)  ' h.SJB_barlist
    boyangtype = Rs(36)  ' 🔹 새로 추가된 컬럼 5
   
%>

<% 
'Response.Write "boyangtype : " & boyangtype & "<br>"
'Response.Write "WHICHI_AUTO : " & WHICHI_AUTO & "<br>"
'response.write "bfidx : "&bfidx&"<br>"
'response.write "rbfidx : "&rbfidx&"<br>"
if int(bfidx)=int(rbfidx) then 
cccc="#E7E7E7"
%>
            <div class="col-3 custom-bg" id="<%=bfidx%>">
                <div class="card card-body mb-1">          
                  <div class="row">
                    <div class="col">
                    <% if bfimg3<>"" then %>
                        <img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="200" height="200"  border="0"
                        onclick="window.open('TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD2.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>&bftype=bfimg3','bfimg3','top=10, left=10, width=700, height=600');">
                        <br>
                        <!-- 🔹 미리보기 버튼 추가 -->
                        <button type="button" onclick="window.open('/img/frame/bfimg/<%=bfimg3%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                        <a href="/img/frame/bfimg/<%=bfimg3%>" download="<%=bfimg3%>">
                            <button type="button">이미지 다운로드</button>
                        </a>   
                    <% elseif bfimg1<>"" then %>
                        <img src="/img/frame/bfimg/<%=bfimg1%>" loading="lazy" width="200" height="200"  border="0" 
                        onclick="window.open('TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD2.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>&bftype=bfimg3','bfimg3','top=10, left=10, width=700, height=600');">
                        <br>
                        <!-- 🔹 미리보기 버튼 추가 -->
                        <button type="button" onclick="window.open('/img/frame/bfimg/<%=bfimg1%>', 'previewImage', 'width=800,height=800,scrollbars=yes');">미리보기</button>
                        <a href="/img/frame/bfimg/<%=bfimg1%>" download="<%=bfimg1%>">
                            <button type="button">이미지 다운로드</button>
                        </a>    
                    <% else %>
                        <div class="card card-body text-start"><!-- *SVG 코드 시작 -->
                            <svg id="mySVG" viewbox="0 10 1000 1000"  fill="none" stroke="#000000" stroke-width="1"
                            style="cursor: pointer;" 
                            onclick="window.open('TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD2.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>&bftype=bfimg3','bfimg3','top=10, left=10, width=700, height=600');">
                                <%
                                SQL="select baidx from tk_barasi A where bfidx='"&rbfidx&"' "
                                Rs1.open Sql,Dbcon
                                    If Not (Rs1.bof or Rs1.eof) Then 
                                        rbaidx=Rs1(0)
                                    End If
                                Rs1.close
                                
                                SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc "
                                'response.write (SQL)&"<br>"
                                Rs1.open Sql,Dbcon
                                If Not (Rs1.bof or Rs1.eof) Then 
                                Do while not Rs1.EOF
                                basidx=Rs1(0)
                                bassize=Rs1(1)
                                basdirection=Rs1(2)
                                x1=Rs1(3)
                                y1=Rs1(4)
                                x2=Rs1(5)
                                y2=Rs1(6)
                                accsiz=Rs1(7)
                                idv=Rs1(8)
                                
                                textv=bassize+idv

                                'response.write  bassize&"/"&basdirection&"<br>"
                                if bassize>30 then 
                                    bojngv=-10
                                end if  

                                if basdirection="1" then 
                                    tx1=x1+(bassize/2)
                                    ty1=y1-1
                                elseif basdirection="2" then 
                                    tx1=x1-5
                                    ty1=y1+(bassize/2)+bojngv+10
                                elseif basdirection="3" then 
                                    tx1=x1-(bassize/2)
                                    ty1=y1+5
                                elseif basdirection="4" then 
                                    tx1=x1+5
                                    ty1=y1-(bassize/2)+bojngv+10
                                end if
                                %>
                                <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                                <%
                                if bassize=int(bassize) then
                                bassize_int=FormatNumber(bassize,0)
                                else 
                                bassize_int=FormatNumber(bassize,1)
                                end if
                                %>
                                <text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="12" text-anchor="middle"><%=bassize_int%></text>   
                                <%
                                Rs1.movenext
                                Loop
                                End if
                                Rs1.close
                                %> 
                            </svg>
                            <!-- 🔹 PNG 저장 버튼 (서버로 업로드) -->
                            <button type="button" onclick="uploadSVGasPNG('<%=rbfidx%>', '<%=rSJB_IDX%>', 'bfimg3')">서버로 업로드_미완성</button>
                                                        
                            <!-- 🔹 SVG 미리보기 버튼 추가 -->
                            <button type="button" onclick="previewHighResPNG()">SVG PNG 미리보기</button>

                            <!-- 🔹 PNG 다운로드 버튼 -->
                            <button type="button" onclick="downloadHighResPNG()">SVG PNG 다운로드</button>

                            
                            <script>
                            function downloadHighResPNG() {
                                const svg = document.getElementById("mySVG");
                                const bbox = svg.getBBox();

                                const serializer = new XMLSerializer();
                                const svgClone = svg.cloneNode(true);
                                svgClone.setAttribute("xmlns", "http://www.w3.org/2000/svg");

                                // 실제 크기
                                const svgWidth = bbox.width;
                                const svgHeight = bbox.height;

                                // ✅ 해상도 스케일 (2~4배 추천)
                                const scaleFactor = 4;

                                // 뷰박스 및 사이즈 조정
                                const newViewBox = `${bbox.x} ${bbox.y} ${bbox.width} ${bbox.height}`;
                                svgClone.setAttribute("viewBox", newViewBox);
                                svgClone.setAttribute("width", svgWidth);
                                svgClone.setAttribute("height", svgHeight);

                                const svgString = serializer.serializeToString(svgClone);
                                const svgBlob = new Blob([svgString], { type: "image/svg+xml;charset=utf-8" });
                                const url = URL.createObjectURL(svgBlob);

                                const img = new Image();
                                img.onload = function () {
                                    // ✅ 캔버스 크기 = 원본 * scaleFactor
                                    const canvas = document.createElement("canvas");
                                    canvas.width = svgWidth * scaleFactor + 200;
                                    canvas.height = svgHeight * scaleFactor + 200;

                                    const ctx = canvas.getContext("2d");

                                    // ✅ 흰 배경
                                    ctx.fillStyle = "#FFFFFF";
                                    ctx.fillRect(0, 0, canvas.width, canvas.height);

                                    // ✅ 이미지도 스케일에 맞게 확대해서 중앙 배치
                                    const offsetX = (canvas.width - svgWidth * scaleFactor) / 2;
                                    const offsetY = (canvas.height - svgHeight * scaleFactor) / 2;

                                    ctx.drawImage(img, offsetX, offsetY, svgWidth * scaleFactor, svgHeight * scaleFactor);

                                    const pngURL = canvas.toDataURL("image/png");

                                    const link = document.createElement("a");
                                    link.href = pngURL;
                                    link.download = "svg_highres.png";
                                    document.body.appendChild(link);
                                    link.click();
                                    document.body.removeChild(link);
                                    URL.revokeObjectURL(url);
                                };

                                img.src = url;
                            }
                            </script>
                            <script>
function previewHighResPNG() {
    const svg = document.getElementById("mySVG");
    const bbox = svg.getBBox();

    const serializer = new XMLSerializer();
    const svgClone = svg.cloneNode(true);
    svgClone.setAttribute("xmlns", "http://www.w3.org/2000/svg");

    const svgWidth = bbox.width;
    const svgHeight = bbox.height;
    const scaleFactor = 4;

    const newViewBox = `${bbox.x} ${bbox.y} ${bbox.width} ${bbox.height}`;
    svgClone.setAttribute("viewBox", newViewBox);
    svgClone.setAttribute("width", svgWidth);
    svgClone.setAttribute("height", svgHeight);

    const svgString = serializer.serializeToString(svgClone);
    const svgBlob = new Blob([svgString], { type: "image/svg+xml;charset=utf-8" });
    const url = URL.createObjectURL(svgBlob);

    const img = new Image();
    img.onload = function () {
        const canvas = document.createElement("canvas");
        canvas.width = svgWidth * scaleFactor + 200;
        canvas.height = svgHeight * scaleFactor + 200;

        const ctx = canvas.getContext("2d");
        ctx.fillStyle = "#FFFFFF";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        const offsetX = (canvas.width - svgWidth * scaleFactor) / 2;
        const offsetY = (canvas.height - svgHeight * scaleFactor) / 2;

        ctx.drawImage(img, offsetX, offsetY, svgWidth * scaleFactor, svgHeight * scaleFactor);

        const dataURL = canvas.toDataURL("image/png");

        // 팝업으로 보기
        const popup = window.open("", "previewWindow", "width=1200,height=900,resizable=yes,scrollbars=yes");
        popup.document.write(`
            <html>
            <head><title>미리보기</title></head>
            <body style="margin:0; background:#fff; display:flex; justify-content:center; align-items:center; height:100vh;">
                <img src="${dataURL}" style="max-width:100%; height:auto; border:1px solid #ccc;" />
            </body>
            </html>
        `);
        URL.revokeObjectURL(url);
    };

    img.src = url;
}
</script>

                        </div>
                    <% end if %>
                  </div>
                  </div>

                  <div class="row">
                    <div class="col">
                      <table  class="table custom-table">
                        <tr>
                            <th>
                                [복사하기]
                                <a href="TNG1_JULGOK_PUMMOK_LIST1_copy.asp?copy_bfidx=<%=bfidx%>&SJB_IDX=<%=rSJB_IDX%>">
                                    <button type="button" class="btn btn-sm btn-warning ms-2" title="전체 복사">
                                    <i class="fa-solid fa-copy"></i>
                                    </button>
                                </a>
                            </th>
                          <th>작성자 : <%=mename%></th>
                        </tr>
                        <tr>
                          <th>자재명</th>
                          <th>사용위치</th>
                          
                          <%
                            'Response.Write "set_name_FIX: " & set_name_FIX & "<br>"
                            'Response.Write "rWHICHI_FIX: " & rWHICHI_FIX & "<br>"
                            'Response.Write "Request(""WHICHI_FIX""): " & Request("WHICHI_FIX") & "<br>"
                          %>
                        </tr>
                        <tr>
                        <% IF SJB_FA="1" then %>
                            <td>
                            <textarea name="set_name_FIX" id="set_name_FIX" class="input-field"
                                onkeypress="handleKeyPress(event, 'set_name_FIX', 'set_name_FIX')"
                                style="width:180px; height:60px;"><%=set_name_FIX%></textarea>
                            </td>
                            <td>
                            <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                <%
                                    sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                    sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                    sql = sql & "FROM tng_whichitype "
                                    sql = sql & "WHERE bfwstatus = 1 "
                                    'response.write (sql)&"<br>"

                                    Rs1.open sql, Dbcon, 1, 1, 1
                                    If Not (Rs1.bof Or Rs1.eof) Then 
                                        Do Until Rs1.EOF

                                            bfwidx           = Rs1(0)
                                            yWHICHI_FIX      = Rs1(1)
                                            yWHICHI_FIXname  = Rs1(2)
                                            yWHICHI_AUTO     = Rs1(3)
                                            yWHICHI_AUTOname = Rs1(4)
                                            bfwstatus        = Rs1(5)
                                    ' 🔹 NULL 또는 빈값이 아니면 출력
                                    If Not IsNull(yWHICHI_FIX)  Then
                                    %>
                                    <option value="<%=yWHICHI_FIX%>" <% If cint(yWHICHI_FIX) = cint(WHICHI_FIX) Then Response.Write "selected" End If %> >
                                     <%'Response.Write " 케빈샘 루프됨 i=" & i & " / bfidx=" & bfidx & "<br>"%>    <%=yWHICHI_FIXname%>
                                    </option>
                                    <%
                                    End If
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.close
                                    %>
                            </select>
                                [가져오기]
                            <a href="TNG1_JULGOK_PUMMOK_LIST1_select_copy.asp?copy_bfidx=<%=bfidx%>&SJB_IDX=<%=rSJB_IDX%>&WHICHI_FIX=<%=WHICHI_FIX%>">
                                <button type="button" class="btn btn-sm btn-success" title="선택 복사">
                                    <i class="fa-solid fa-check-double"></i>
                                </button>
                            </a>
                        </td>
                        <tr>
                            <th>측면폭</th>
                            <th>
                                정면폭 / 할증
                                <button type="button" class="btn btn-sm btn-outline-danger"
                                    onclick="
                                        const pcentInput = document.getElementById('pcent');
                                        pcentInput.value = '0';  // 값 설정
                                        pcentInput.focus();      // 포커스
                                        handleKeyPress({ key: 'Enter', target: pcentInput, preventDefault: function(){} }, 'pcent', 'pcent');
                                    ">
                                    할증적용 무조건 엔터
                                </button>
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <input class="input-field" type="text" size="8" name="xsize" id="xsize" value="<%=xsize%>" onkeypress="handleKeyPress(event, 'xsize', 'xsize')"/>
                            </td>
                            <td>
                                <div style="display: flex; gap: 4px;">
                                <input class="input-field" type="text" size="6" name="ysize" id="ysize" value="<%=ysize%>" onkeypress="handleKeyPress(event, 'ysize', 'ysize')"/>
                                <% if pcent_result=0 then %>
                                <%
                                sql = "SELECT min_ysize, max_ysize, pcent "
                                sql = sql & "FROM tng_whichipcent "
                                sql = sql & "WHERE WHICHI_FIX='" & WHICHI_FIX & "' "
                                'Response.write sql & "<br>"
                                'Response.End
                                Rs1.open sql, Dbcon, 1, 1, 1
                                If Not (Rs1.bof Or Rs1.eof) Then 
                                    Do Until Rs1.EOF
                                        ymin_ysize  = Rs1(0)
                                        ymax_ysize  = Rs1(1)
                                        ypcent  = Rs1(2)
                                      If cint(ymin_ysize) <= cint(ysize) And cint(ysize) <= cint(ymax_ysize) Then
                                          pcent_result = ypcent
                                      End If
                                    %>
                                    <%
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.close
                                    %>
                                    <% end if %>
                                  <input class="input-field" type="text" size="6" name="pcent" id="pcent" value="<%=pcent_result%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/>
                                </div>
                            </td>
                        </tr>
                        <% ElseIf SJB_FA = "2" Then %>
                            <td>
                            <textarea name="set_name_AUTO" id="set_name_AUTO" class="input-field"
                                onkeypress="handleKeyPress(event, 'set_name_AUTO', 'set_name_AUTO')"
                                style="width:180px; height:60px;"><%=set_name_AUTO%></textarea>
                            </td>
                            <td>
                            <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                <%
                                sql = "SELECT bfwidx, WHICHI_FIX, WHICHI_FIXname "
                                sql = sql & ", WHICHI_AUTO, WHICHI_AUTOname, bfwstatus "
                                sql = sql & "FROM tng_whichitype "
                                sql = sql & "WHERE bfwstatus = 1 "
                                'response.write (sql)&"<br>"

                                Rs1.open sql, Dbcon, 1, 1, 1
                                If Not (Rs1.bof Or Rs1.eof) Then 
                                    Do Until Rs1.EOF

                                        bfwidx           = Rs1(0)
                                        yWHICHI_FIX      = Rs1(1)
                                        yWHICHI_FIXname  = Rs1(2)
                                        yWHICHI_AUTO     = Rs1(3)
                                        yWHICHI_AUTOname = Rs1(4)
                                        bfwstatus        = Rs1(5)
                                ' 🔹 NULL 또는 빈값이 아니면 출력
                                If Not IsNull(yWHICHI_AUTO)  Then
                                %>
                                
                                <option value="<%=yWHICHI_AUTO%>" <% If cint(yWHICHI_AUTO) = cint(WHICHI_AUTO) Then Response.Write "selected" End If %> >
                                    <%=yWHICHI_AUTOname%>
                                </option>
                                <%
                                End If
                                Rs1.MoveNext
                                Loop
                                End If
                                Rs1.close
                                %>
                            </select>
                                [가져오기]
                            <a href="TNG1_JULGOK_PUMMOK_LIST1_select_copy.asp?copy_bfidx=<%=bfidx%>&SJB_IDX=<%=rSJB_IDX%>&WHICHI_AUTO=<%=WHICHI_AUTO%>">
                                <button type="button" class="btn btn-sm btn-success" title="선택 복사">
                                    <i class="fa-solid fa-check-double"></i>
                                </button>
                            </a>
                        </td>
                        
                        </tr>
                        <tr>
                            <th>측면폭</th>
                            <th>
                                정면폭 / 할증
                                <button type="button" class="btn btn-sm btn-outline-danger"
                                    onclick="document.getElementById('pcent').value = '0';">
                                    초기화=0입력
                                </button>
                            </th>
                        </tr>
                        <tr>
                            <td>
                                <input class="input-field" type="text" size="8" name="xsize" id="xsize" value="<%=xsize%>" onkeypress="handleKeyPress(event, 'xsize', 'xsize')"/>
                            </td>
                            <td>
                                <div style="display: flex; gap: 4px;">
                                <input class="input-field" type="text" size="6" name="ysize" id="ysize" value="<%=ysize%>" onkeypress="handleKeyPress(event, 'ysize', 'ysize')"/>
                                <% if pcent_result=0 then %>
                                <%
                                sql = "SELECT min_ysize, max_ysize, pcent "
                                sql = sql & "FROM tng_whichipcent "
                                sql = sql & "WHERE WHICHI_AUTO='" & WHICHI_AUTO & "' "
                                'Response.write sql & "<br>"
                                'Response.End
                                Rs1.open sql, Dbcon, 1, 1, 1
                                If Not (Rs1.bof Or Rs1.eof) Then 
                                    Do Until Rs1.EOF
                                        ymin_ysize  = Rs1(0)
                                        ymax_ysize  = Rs1(1)
                                        ypcent  = Rs1(2)
                                      If cint(ymin_ysize) <= cint(ysize) And cint(ysize) <= cint(ymax_ysize) Then
                                          pcent_result = ypcent
                                      End If
                                    %>
                                    <%
                                    Rs1.MoveNext
                                    Loop
                                    End If
                                    Rs1.close
                                    %>
                                    <% end if %>
                                  <input class="input-field" type="text" size="6" name="pcent" id="pcent" value="<%=pcent_result%>" onkeypress="handleKeyPress(event, 'pcent', 'pcent')"/>
                                </div>
                            </td>
                        </tr>
                         <% end if %>
                         <tr>
                         <th colspan="2">보양재</th>
                         
                         </tr>
                          <tr>
                         
                         <th >
                         <select class="input-field" name="boyang" id="boyang"  onchange="handleChange(this)">
                                <option value="">-- 보양재 품목선택 --</option>
                                <%
                                SQL = "SELECT a.sjb_idx,D.SJB_TYPE_NAME, A.SJB_barlist "
                                SQL = SQL & " FROM TNG_SJB A "
                                SQL = SQL & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
                                SQL = SQL & " WHERE A.SJB_TYPE_NO <>'' "
                                SQL = SQL & " and a.sjb_fa = 2 "
                                SQL = SQL & " and a.sjb_idx not in ( 128,129) "
                                'response.write (sql)&"<br>"

                                Rs1.open sql, Dbcon, 1, 1, 1
                                If Not (Rs1.bof Or Rs1.eof) Then 
                                    Do Until Rs1.EOF

                                        usjb_idx           = Rs1(0)
                                        uSJB_TYPE_NAME      = Rs1(1)
                                        uSJB_barlist  = Rs1(2)
                                        boyangname = usjb_idx & "_" & uSJB_TYPE_NAME & "_" & uSJB_barlist & "_보양"
                                %>
                                <% if boyang <> ""  then %>
                                <option value="<%=usjb_idx%>" <% If cint(boyang) = cint(usjb_idx) Then Response.Write "selected" End If %> >
                                    <%=boyangname%>
                                </option>
                                <% end if %>
                                <%
                              
                                Rs1.MoveNext
                                Loop
                                End If
                                Rs1.close
                                %>
                            </select>
                        
                         </th>
                         
                         <td colspan="2">
                            <select class="input-field" name="boyangtype" id="boyangtype" onchange="handleChange(this)">
                                <option value="">-- 보양재 타입 --</option>
                                <option value="1" <% If boyangtype = "1" Then Response.Write "selected" %>>1 중간소대 보양</option>
                                <option value="2" <% If boyangtype = "2" Then Response.Write "selected" %>>2 자동홈바 보양</option>
                                <option value="3" <% If boyangtype = "3" Then Response.Write "selected" %>>3 재료분리대 보양</option>
                            </select>
                        </td>
                         </tr>

                        <tr>
                          <th colspan="2">알루미늄자재</th>
                        </tr>
                        <tr>
                          <td colspan="2">
<%
mode = Request("mode")
%>

<input type="hidden" name="mode" id="modeInput" value="<%=mode%>">  
<button class="btn btn-secondary " type="button" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=rbfidx%>&SJB_IDX=<%=rSJB_IDX%>&mode=mode#<%=rbfidx%>');">전체 자재 보기</button>
<button class="btn btn-secondary " type="button" onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=<%=rbfidx%>&SJB_IDX=<%=rSJB_IDX%>&mode=kmode#<%=rbfidx%>');">조건별  자재 보기</button>

                            <select class="input-field" name="TNG_Busok_idx" id="TNG_Busok_idx"  onchange="handleChange(this)">
                                <option value="0">없음</option>                            
<%

If mode = "mode" Then
    SQL = "SELECT DISTINCT TNG_Busok_idx, T_Busok_name_f FROM TNG_Busok"
ElseIf mode = "kmode" or mode = "0" or mode = "" or isNull(mode) Then
    SQL = "SELECT DISTINCT TNG_Busok_idx, T_Busok_name_f FROM TNG_Busok "
    SQL = SQL & "WHERE ( SJB_TYPE_NO='" & SJB_TYPE_NO & "' "
    if cint(WHICHI_FIX) <> cint(0)  then
    SQL = SQL & "AND WHICHI_FIX='" & WHICHI_FIX & "' "
    end if
    if cint(WHICHI_AUTO) <> cint(0) then
    SQL = SQL & "AND WHICHI_AUTO='" & WHICHI_AUTO & "' "
    end if
    SQL = SQL & "AND SJB_FA='" & SJB_FA & "') or (TNG_Busok_idx='"&Busok_idx&"')   "
End If
'Response.write (SQL)&"<br>"
'Response.end
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do until Rs1.EOF
TNG_Busok_idx=Rs1(0)
if isnull(TNG_Busok_idx) then  '내가 추가함

    TNG_Busok_idx="0"
  end if
T_Busok_name_f=Rs1(1)


%>
                              
                                <option value="<%=TNG_Busok_idx%>" <% if Cint(TNG_Busok_idx)=Cint(Busok_idx) then response.write "selected" end if %> >
                                <%=T_Busok_name_f%></option>
<%
Rs1.MoveNext
Loop
End If
Rs1.close
%>
                            </select>
                            <%
                            'Response.write (SQL)&"<br>"
                            'Response.Write "TNG_Busok_idx : " & TNG_Busok_idx & "<br>"   
                            'Response.Write "Busok_idx : " & Busok_idx & "<br>"   
                            'Response.Write "T_Busok_name_f : " & T_Busok_name_f & "<br>"            
                            %>
                          </td>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <select class="input-field" name="TNG_Busok_idx2" id="TNG_Busok_idx2"  onchange="handleChange(this)">
                                <option value="0">없음</option>

<%
If mode = "mode" Then
    SQL = "SELECT TNG_Busok_idx, T_Busok_name_f FROM TNG_Busok"
ElseIf mode = "kmode" or mode = "0" or mode = "" or isNull(mode) Then
    SQL = "SELECT TNG_Busok_idx, T_Busok_name_f FROM TNG_Busok "
    SQL = SQL & "WHERE ( SJB_TYPE_NO='" & SJB_TYPE_NO & "' "
    if cint(WHICHI_FIX) <> cint(0)  then
    SQL = SQL & "AND WHICHI_FIX='" & WHICHI_FIX & "' "
    end if
    if cint(WHICHI_AUTO) <> cint(0) then
    SQL = SQL & "AND WHICHI_AUTO='" & WHICHI_AUTO & "' "
    end if
    SQL = SQL & "AND SJB_FA='" & SJB_FA & "') or (TNG_Busok_idx='"&Busok_idx2&"')   "
End If
'Response.write (SQL)&"<br>"
'Response.END
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do until Rs1.EOF
TNG_Busok_idx2=Rs1(0)
if isnull(TNG_Busok_idx2) then  '내가 추가함
    TNG_Busok_idx2="0"
  end if
T_Busok_name_f2=Rs1(1)
%>
                                <option value="<%=TNG_Busok_idx2%>" <% if Cint(TNG_Busok_idx2)=Cint(Busok_idx2) then response.write "selected" end if %> ><%=T_Busok_name_f2%></option>
<%
Rs1.MoveNext
Loop
End If
Rs1.close
%>
                            </select>
                            </td>
                           
                        </tr>
<tr>
                          <td colspan="2">
                            <select class="input-field" name="TNG_Busok_idx3" id="TNG_Busok_idx3"  onchange="handleChange(this)">
                                <option value="0">없음</option>

<%
If mode = "mode" Then
    SQL = "SELECT TNG_Busok_idx, T_Busok_name_f FROM TNG_Busok"
ElseIf mode = "kmode" or mode = "0" or mode = "" or isNull(mode) Then
    SQL = "SELECT TNG_Busok_idx, T_Busok_name_f FROM TNG_Busok "
    SQL = SQL & "WHERE ( SJB_TYPE_NO='" & SJB_TYPE_NO & "' "
    if cint(WHICHI_FIX) <> cint(0)  then
    SQL = SQL & "AND WHICHI_FIX='" & WHICHI_FIX & "' "
    end if
    if cint(WHICHI_AUTO) <> cint(0) then
    SQL = SQL & "AND WHICHI_AUTO='" & WHICHI_AUTO & "' "
    end if
    SQL = SQL & "AND SJB_FA='" & SJB_FA & "') or (TNG_Busok_idx='"&Busok_idx3&"')   "
End If
'Response.write (SQL)&"<br>"
'Response.END
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do until Rs1.EOF
TNG_Busok_idx3=Rs1(0)
if isnull(TNG_Busok_idx3) then  '내가 추가함
    TNG_Busok_idx3="0"
  end if
T_Busok_name_f3=Rs1(1)
%>
                                <option value="<%=TNG_Busok_idx3%>" <% if Cint(TNG_Busok_idx3)=Cint(Busok_idx3) then response.write "selected" end if %> ><%=T_Busok_name_f3%></option>
<%
Rs1.MoveNext
Loop
End If
Rs1.close
%>
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td><button class="btn btn-success btn-small" type="button" style="width: 80px;" onclick="window.open('TNG1_JULGOK_IN_SUB3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=SJB_IDX%>&bfidx=<%=bfidx%>#<%=bfidx%>', 'popupWindow', 'width=1200,height=800,scrollbars=yes,resizable=yes');">절곡바라시</button></td>
                            <td>
                                <button type="button" class="btn btn-outline-danger btn-small" onclick="del('<%=bfidx%>');">삭제</button>
                            </td>
                        
                        
                        </tr>
                      </table>
                    </div>
                 </div>


                </div>
            </div>
<% else %>
            <div class="col-3 custom-bg" id="<%=bfidx%>">
                <div class="card card-body mb-1">
                  <div class="row">
                    <div class="col">
    
                    <iframe src="iframeimg.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=sjb_idx%>&bfidx=<%=bfidx%>#<%=bfidx%>" width="300" height="220" style="border: none; display: block;"></iframe>

                    </div>
                  </div>

                  <div class="row">
                    <div class="col">
                      <table  class="table custom-table">
                      <tr>
                          <th>작성자</th>
                          <th><%=mename%></th>
                        </tr>
                        <tr>
                          <th>자재명 </th>
                          <th>사용위치</th>
                        </tr>
                        <% IF SJB_FA="1" then %>
                        <tr>
                            <td>
                                <textarea style="width:180px; height:60px;"
                                        onkeydown="if(event.key === 'Enter'){event.preventDefault();}">
                                <%=set_name_FIX%></textarea>
                            </td>
                          <td><%=WHICHI_FIXname%></td>
                        </tr>
                        
                        <% elseIf SJB_FA = "2" Then %>
                        <tr>
                            <td>
                                <textarea style="width:180px; height:60px;"
                                        onkeydown="if(event.key === 'Enter'){event.preventDefault();}">
                                <%=set_name_AUTO%></textarea>
                            </td>
                          <td><%=WHICHI_AUTOname%></td>
                          
                        </tr>
                        <% end if  %>
                        <tr>
                          <th>측면폭</th>
                          <th>정면폭/할증%</th>
                        </tr>
                        <tr>
                          <td><%=xsize%></td>
                          <td><%=ysize%>/<%=pcent_result%></td>
                        </tr>
                        <tr>
                        <th  colspan="2">보양재</th>
                        
                        </tr>
                        <tr>
                        <td  >
                            <%
                                SQL = "SELECT a.sjb_idx,D.SJB_TYPE_NAME, A.SJB_barlist "
                                SQL = SQL & " FROM TNG_SJB A "
                                SQL = SQL & " LEFT OUTER JOIN tng_sjbtype D ON A.SJB_TYPE_NO = D.SJB_TYPE_NO AND D.sjbtstatus = 1 "
                                SQL = SQL & " WHERE A.sjb_idx='" & boyang & "' "
                                'response.write (sql)&"<br>"
                                Rs1.open sql, Dbcon, 1, 1, 1
                                If Not (Rs1.bof Or Rs1.eof) Then 
                                

                                        usjb_idx           = Rs1(0)
                                        uSJB_TYPE_NAME      = Rs1(1)
                                        uSJB_barlist  = Rs1(2)
                                        boyangname = usjb_idx & "_" & uSJB_TYPE_NAME & "_" & uSJB_barlist & "_보양"
                                %>
                                    <%=boyangname%>
                                <%
                                End If
                                Rs1.close
                                %>
                     
                        </td>
                        <td >
                        <%
                                        boyangtype_name = ""
                                        select case boyangtype
                                            case 1
                                                boyangtype_name = "1 중간소대 보양"
                                            case 2
                                                boyangtype_name = "2 자동홈바 보양"
                                            case 3
                                                boyangtype_name = "3 재료분리대 보양"
                                            case else
                                                boyangtype_name = "알수없음"
                                        end select
                                %>
                                    <%=boyangtype_name%>
                             
                   
                        </td>
                        </tr>
                        <tr>

                          <th colspan="2">알루미늄자재</th>
                        </tr>
                        <tr>
                            <td colspan="2" class="title-cell">
                            <span class="title-text"><% if Busok_idx<>"" then %><%=T_Busok_name_f%><% else %>없음<% end if %></span>
                            <img src="/img/frame/bfimg/<%=bfimg1%>" class="hover-image" alt="미리보기">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="title-cell">
                            <span class="title-text"><% if Busok_idx2<>"" then %><%=T_Busok_name_f2%><% else %>없음<% end if %></span>
                            <img src="/img/frame/bfimg/<%=bfimg2%>" class="hover-image" alt="미리보기">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="title-cell">
                            <span class="title-text"><% if Busok_idx3<>"" then %><%=T_Busok_name_f3%><% else %>없음<% end if %></span>
                            <img src="/img/frame/bfimg/<%=bfimg4%>" class="hover-image" alt="미리보기">
                            </td>
                        </tr>
                        <tr>
                          <td colspan="2"><button class="btn btn-success btn-small" type="button" style="width: 80px;" onclick="window.open('TNG1_JULGOK_IN_SUB3.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=SJB_IDX%>&bfidx=<%=bfidx%>#<%=bfidx%>', 'popupWindow', 'width=1200,height=800,scrollbars=yes,resizable=yes');">절곡바라시</button></td>
                        </tr>
                      </table>
                    </div>
                 </div>
              
                </div>
            </div>
<%
end if 
%>

<% 

  cccc=""
    i=i+1
Rs.MoveNext
Next 
End If 

%>
        </div>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
 </form>

        <div>
            <button type="button"
                class="btn btn-outline-danger"
                style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&bfidx=0&SJB_IDX=<%=rSJB_IDX%>');">등록
            </button>
        </div> 
<div  class="col-10 py-3"> 
<!--#include Virtual = "/inc/paging.asp" -->
</div>

        </div>
    </div>


        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script>
    // 페이지 로드 후 앵커로 이동
    window.addEventListener("DOMContentLoaded", function () {
        const hash = window.location.hash;
        if (hash) {
            const target = document.querySelector(hash);
            if (target) {
                target.scrollIntoView({ behavior: "smooth", block: "center" });
            }
        }
    });
</script>
<script>
    window.addEventListener("DOMContentLoaded", function () {
        const bfidx = "<%=rbfidx%>";
        if (bfidx && bfidx !== "0") {
            const target = document.getElementById(bfidx);
            if (target) {
                // 앵커 위치로 이동
                target.scrollIntoView({  block: "center" });

                // URL에 앵커 강제로 추가
                history.replaceState(null, null, "#" + bfidx);
            }
        }
    });
</script>

</body>
</html>

<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>