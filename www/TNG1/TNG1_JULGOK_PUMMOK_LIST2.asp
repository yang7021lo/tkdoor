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
subgubun="one2"
projectname="TNG 품목관리" 
%>
<%
	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function

rbfidx=Request("bfidx")
rSearchWord=Request("SearchWord")
rSJB_IDX = Request("SJB_IDX")
rSJB_TYPE_NO = Request("SJB_TYPE_NO")

'sql = "SELECT TNG_Busok_idx, T_Busok_name_f, TNG_Busok_comb_st, TNG_Busok_name1_Number,"
'sql = sql & " SJB_TYPE_NO, TNG_Busok_name_KR, TNG_Busok_name1, TNG_Busok_name2,"
'sql = sql & " TNG_Busok_comb_al1, TNG_Busok_comb_alBJ1, TNG_Busok_comb_al2, TNG_Busok_comb_alBJ2,"
'sql = sql & " TNG_Busok_comb_pa1, TNG_Busok_comb_pa2, TNG_Busok_length1, TNG_Busok_length2,"
'sql = sql & " TNG_Busok_BLACK, TNG_Busok_PAINT, TNG_Busok_comb_al3, TNG_Busok_comb_alBJ3,"
'sql = sql & " TNG_Busok_comb_pa3, TNG_Busok_images, TNG_Busok_CAD"
'sql = sql & " FROM TNG_Busok"
'sql = sql & "  WHERE TNG_Busok_idx = '" & rTNG_Busok_idx & "' "
'Rs.open Sql,Dbcon,1,1,1
'If Not (Rs.EOF Or Rs.BOF) Then

'    TNG_Busok_idx        = rs(0)
'    T_Busok_name_f       = rs(1)
'    TNG_Busok_comb_st    = rs(2)
'    TNG_Busok_name1_Number = rs(3)
'    SJB_TYPE_NO          = rs(4)
'    TNG_Busok_name_KR    = rs(5)
'    TNG_Busok_name1      = rs(6)
'    TNG_Busok_name2      = rs(7)
'    TNG_Busok_comb_al1   = rs(8)
'    TNG_Busok_comb_alBJ1 = rs(9)
'    TNG_Busok_comb_al2   = rs(10)
'    TNG_Busok_comb_alBJ2 = rs(11)
'    TNG_Busok_comb_pa1   = rs(12)
'    TNG_Busok_comb_pa2   = rs(13)
'    TNG_Busok_length1    = rs(14)
'    TNG_Busok_length2    = rs(15)
'    TNG_Busok_BLACK      = rs(16)
'    TNG_Busok_PAINT      = rs(17)
'    TNG_Busok_comb_al3   = rs(18)
'    TNG_Busok_comb_alBJ3 = rs(19)
'    TNG_Busok_comb_pa3   = rs(20)
'    TNG_Busok_images     = rs(21)
'    TNG_Busok_CAD        = rs(22)

'End If
'Rs.Close

SQL = "SELECT SJB_TYPE_NO, SJB_FA FROM TNG_SJB WHERE SJB_IDX = '" & rSJB_IDX & "' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
If Not (Rs.EOF Or Rs.BOF) Then
    SJB_TYPE_NO = Rs(0)
    SJB_FA = Rs(1)
    Select Case SJB_TYPE_NO
        Case "1"
            SJB_TYPE_NO_text = "일반 AL자동"
        Case "2"
            SJB_TYPE_NO_text = "복층 AL자동"
        Case "3"
            SJB_TYPE_NO_text = "단열 AL자동"
        Case "4"
            SJB_TYPE_NO_text = "삼중 AL자동"
        Case "5"
            SJB_TYPE_NO_text = "일반 100바 AL자동"
        Case "6"
            SJB_TYPE_NO_text = "일반 AL프레임"
        Case "7"
            SJB_TYPE_NO_text = "단열 AL프레임"
        Case "8"
            SJB_TYPE_NO_text = "단열 스텐자동"
        Case "9"
            SJB_TYPE_NO_text = "삼중 스텐자동"
        Case "10"
            SJB_TYPE_NO_text = "단열 이중스텐자동"
        Case "11"
            SJB_TYPE_NO_text = "단열 스텐프레임"
        Case "12"
            SJB_TYPE_NO_text = "삼중 스텐프레임"
        Case Else
            SJB_TYPE_NO_text = "선택 안됨"
    End Select

End If
'Response.Write "SJB_TYPE_NO : " & SJB_TYPE_NO & "<br>"

Rs.Close
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
            'padding: 20px;
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
      top: 50%;
      left: -50%;
      transform: translateY(-50%);
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
        function del(str){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_JULGOK_PUMMOK_LIST_DB.asp?SJB_IDX=<%=rSJB_IDX%>&SearchWord=<%=SearchWord%>&part=delete&bfidx="+str;
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
                    <h3><%=SJB_TYPE_NO_text%></h3>
                </div>
                <div class="input-group mb-3">
                    <button type="button"
                        class="btn btn-outline-danger"
                        style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                        onclick="location.replace('TNG1_PUMMOK_Item.asp?gotopage=<%=gotopage%>&SJB_IDX=<%=rSJB_IDX%>&SearchWord=<%=rSearchWord%>');">돌아가기
                    </button>
                </div>
            <div class="col text-end">
                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="TNG1_JULGOK_PUMMOK_LIST1.asp" name="form1">   
                  <input type="hidden" name="bfidx" value="<%=rbfidx%>">
                  <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">
                    <div style="display: flex; align-items: center; gap: 8px;"> 
                        <input class="form-control" type="text" placeholder="품명,규격 조회" aria-label="품명,규격 조회" aria-describedby="btnNavbarSearch" name="SearchWord" value="<%=rSearchWord%>"/>
                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();"><i class="fas fa-search"></i></button>
                </form> 
                    <button type="button"
                        class="btn btn-outline-danger"
                        style="writing-mode: horizontal-tb; letter-spacing: normal; white-space: nowrap;"
                        onclick="location.replace('TNG1_JULGOK_PUMMOK_LIST1.asp?bfidx=0&SJB_IDX=<%=rSJB_IDX%>');">등록
                    </button>
                </div>
            </div>
        <div>
        
<form id="dataForm" action="TNG1_JULGOK_PUMMOK_LIST_DB.asp" method="POST" >   
    <input type="hidden" name="bfidx" value="<%=rbfidx%>">
    <input type="hidden" name="SJB_IDX" value="<%=rSJB_IDX%>">

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
                <option value="0" <% If WHICHI_FIX = "0" Then Response.Write "selected" %> >없음</option>
                <option value="1" <% If WHICHI_FIX = "1" Then Response.Write "selected" %> >가로바</option>
                <option value="2" <% If WHICHI_FIX = "2" Then Response.Write "selected" %> >가로바 길게</option>
                <option value="3" <% If WHICHI_FIX = "3" Then Response.Write "selected" %> >중간바</option>
                <option value="4" <% If WHICHI_FIX = "4" Then Response.Write "selected" %> >롯트바</option>
                <option value="5" <% If WHICHI_FIX = "5" Then Response.Write "selected" %> >하바</option>
                <option value="6" <% If WHICHI_FIX = "6" Then Response.Write "selected" %> >세로바</option>
                <option value="7" <% If WHICHI_FIX = "7" Then Response.Write "selected" %> >세로중간통바</option>
                <option value="8" <% If WHICHI_FIX = "8" Then Response.Write "selected" %> >180도 코너바</option>
                <option value="9" <% If WHICHI_FIX = "9" Then Response.Write "selected" %> >90도 코너바</option>
                <option value="10" <% If WHICHI_FIX = "10" Then Response.Write "selected" %> >비규격 코너바</option>
              </select>
            </td>
            <td>
              <input class="input-field" type="text" size="" name="set_name_AUTO" id="set_name_AUTO" value="<%=set_name_AUTO%>" onkeypress="handleKeyPress(event, 'set_name_AUTO', 'set_name_AUTO')"/>
            </td> 
            <td>
              <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                <option value="0" <% If WHICHI_AUTO = "0" Then Response.Write "selected" %> >없음</option>
                <option value="1" <% If WHICHI_AUTO = "1" Then Response.Write "selected" %> >박스세트</option>
                <option value="2" <% If WHICHI_AUTO = "2" Then Response.Write "selected" %> >박스커버</option>
                <option value="3" <% If WHICHI_AUTO = "3" Then Response.Write "selected" %> >가로남마</option>
                <option value="4" <% If WHICHI_AUTO = "4" Then Response.Write "selected" %> >상부중간소대</option>
                <option value="5" <% If WHICHI_AUTO = "5" Then Response.Write "selected" %> >중간소대</option>
                <option value="6" <% If WHICHI_AUTO = "6" Then Response.Write "selected" %> >자동홈바</option>
                <option value="7" <% If WHICHI_AUTO = "7" Then Response.Write "selected" %> >세로픽스바</option>
                <option value="8" <% If WHICHI_AUTO = "8" Then Response.Write "selected" %> >픽스하바</option>
                <option value="9" <% If WHICHI_AUTO = "9" Then Response.Write "selected" %> >픽스상바</option>
                <option value="10" <% If WHICHI_AUTO = "10" Then Response.Write "selected" %> >코너바</option>
              </select>
            </td>
            <td>
              <input class="input-field" type="text" size="8" name="xsize" id="xsize" value="<%=xsize%>" onkeypress="handleKeyPress(event, 'xsize', 'xsize')"/>
            </td> 
            <td>
              <input class="input-field" type="text" size="8" name="ysize" id="ysize" value="<%=ysize%>" onkeypress="handleKeyPress(event, 'ysize', 'ysize')"/></td> 
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
SQL = SQL & " , A.ysize, A.bfimg1, A.bfimg2, A.sjb_idx, A.bfmidx, Convert(varchar(10), A.bfwdate, 121) "
SQL = SQL & " , A.bfemidx, Convert(varchar(10), A.bfewdate, 121), B.mname "
SQL=SQL&", C.mname , A.TNG_Busok_idx, D.T_Busok_name_f, A.bfimg3 "
SQL = SQL & " FROM tk_barasiF A "
SQL = SQL & " JOIN tk_member B ON A.bfmidx = B.midx "
SQL = SQL & " LEFT OUTER JOIN tk_member C ON A.bfemidx = C.midx "
SQL = SQL & " LEFT OUTER JOIN TNG_Busok D On A.TNG_Busok_idx=D.TNG_Busok_idx "
If rSJB_IDX <> "" Then
SQL = SQL & "WHERE A.sjb_idx = '" & rSJB_IDX & "' "
End If
If Request("SearchWord")<>"" Then 
SQL=SQL&" AND ( A.set_name_FIX like '%" & Request("SearchWord") & "%' or set_name_AUTO like '%"&Request("SearchWord")&"%') "
End If 
SQL = SQL & "ORDER BY A.bfidx asc"

'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF

  bfidx         = Rs(0)
  set_name_FIX  = Rs(1)
  set_name_AUTO = Rs(2)
  WHICHI_FIX    = Rs(3)
  WHICHI_AUTO   = Rs(4) ' ← 여기 추가!
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
  if isnull(Busok_idx) then 
    Busok_idx="0"
  end if
  T_Busok_name_f   = Rs(17)
  bfimg3   = Rs(18)
  i=i+1

  Select Case WHICHI_FIX
      Case "1"
          WHICHI_FIX_text = "가로바"
      Case "2"
          WHICHI_FIX_text = "가로바 길게"
      Case "3"
          WHICHI_FIX_text = "중간바"
      Case "4"
          WHICHI_FIX_text = "롯트바"
      Case "5"
          WHICHI_FIX_text = "하바"
      Case "6"
          WHICHI_FIX_text = "세로바"
      Case "7"
          WHICHI_FIX_text = "세로중간통바"
      Case "8"
          WHICHI_FIX_text = "180도 코너바"
      Case "9"
          WHICHI_FIX_text = "90도 코너바"
      Case "10"
          WHICHI_FIX_text = "비규격 코너바"
      Case Else
          WHICHI_FIX_text = "선택 안됨"
  End Select

  Select Case WHICHI_AUTO
      Case "1"
          WHICHI_AUTO_text = "박스세트"
      Case "2"
          WHICHI_AUTO_text = "박스커버"
      Case "3"
          WHICHI_AUTO_text = "가로남마"
      Case "4"
          WHICHI_AUTO_text = "상부중간소대"
      Case "5"
          WHICHI_AUTO_text = "중간소대"
      Case "6"
          WHICHI_AUTO_text = "자동홈바"
      Case "7"
          WHICHI_AUTO_text = "세로픽스바"
      Case "8"
          WHICHI_AUTO_text = "픽스하바"
      Case "9"
          WHICHI_AUTO_text = "픽스상바"
      Case "10"
          WHICHI_AUTO_text = "코너바"
      Case Else
          WHICHI_AUTO_text = "선택 안됨"
  End Select
%>

<% 
'response.write "bfidx : "&bfidx&"<br>"
'response.write "rbfidx : "&rbfidx&"<br>"
if int(bfidx)=int(rbfidx) then 
cccc="#E7E7E7"
%>
            <div class="col-2 custom-bg" >
                <div class="card card-body mb-1">
                  <div class="row">
                    <div class="col">
                      <% if bfimg3="" and bfimg1<>"" then %>
                        <img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="200" height="200"  border="0" onclick="window.open('TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD2.asp?sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>&bftype=bfimg3','bfimg3','top=10, left=10, width=700, height=600');">
                      <% else %>
                        <img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="200" height="200"  border="0" onclick="window.open('TNG1_JULGOK_PUMMOK_LIST_DB_UPLOAD2.asp?sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>&bftype=bfimg3','bfimg3','top=10, left=10, width=700, height=600');">
                      <% end if %>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col">
                      <table  class="table custom-table">
                        <tr>
                          <th>자재명</th>
                          <th>사용위치</th>
                        </tr>
                        <tr>
                        <% IF SJB_FA="1" then %>
                          <td><input class="input-field" type="text" size="" name="set_name_FIX" id="set_name_FIX" 
                          value="<%=set_name_FIX%>" onkeypress="handleKeyPress(event, 'set_name_FIX', 'set_name_FIX')"/> </td>
                          
                          <td>
                            <select class="input-field" name="WHICHI_FIX" id="WHICHI_FIX"  onchange="handleChange(this)">
                                <option value="0" <% If WHICHI_FIX = "0" Then Response.Write "selected" %> >없음</option>
                                <option value="1" <% If WHICHI_FIX = "1" Then Response.Write "selected" %> >가로바</option>
                                <option value="2" <% If WHICHI_FIX = "2" Then Response.Write "selected" %> >가로바 길게</option>
                                <option value="3" <% If WHICHI_FIX = "3" Then Response.Write "selected" %> >중간바</option>
                                <option value="4" <% If WHICHI_FIX = "4" Then Response.Write "selected" %> >롯트바</option>
                                <option value="5" <% If WHICHI_FIX = "5" Then Response.Write "selected" %> >하바</option>
                                <option value="6" <% If WHICHI_FIX = "6" Then Response.Write "selected" %> >세로바</option>
                                <option value="7" <% If WHICHI_FIX = "7" Then Response.Write "selected" %> >세로중간통바</option>
                                <option value="8" <% If WHICHI_FIX = "8" Then Response.Write "selected" %> >180도 코너바</option>
                                <option value="9" <% If WHICHI_FIX = "9" Then Response.Write "selected" %> >90도 코너바</option>
                                <option value="10" <% If WHICHI_FIX = "10" Then Response.Write "selected" %> >비규격 코너바</option>
                            </select>
                        </td>
                        <% else SJB_FA="2"  %>
                        <td><input class="input-field" type="text" size="" name="set_name_AUTO" id="set_name_AUTO" 
                          value="<%=set_name_AUTO%>" onkeypress="handleKeyPress(event, 'set_name_AUTO', 'set_name_AUTO')"/> </td>

                          <td>
                            <select class="input-field" name="WHICHI_AUTO" id="WHICHI_AUTO"  onchange="handleChange(this)">
                                <option value="0" <% If WHICHI_AUTO = "0" Then Response.Write "selected" %> >없음</option>
                                <option value="1" <% If WHICHI_AUTO = "1" Then Response.Write "selected" %> >박스세트</option>
                                <option value="2" <% If WHICHI_AUTO = "2" Then Response.Write "selected" %> >박스커버</option>
                                <option value="3" <% If WHICHI_AUTO = "3" Then Response.Write "selected" %> >가로남마</option>
                                <option value="4" <% If WHICHI_AUTO = "4" Then Response.Write "selected" %> >상부중간소대</option>
                                <option value="5" <% If WHICHI_AUTO = "5" Then Response.Write "selected" %> >중간소대</option>
                                <option value="6" <% If WHICHI_AUTO = "6" Then Response.Write "selected" %> >자동홈바</option>
                                <option value="7" <% If WHICHI_AUTO = "7" Then Response.Write "selected" %> >세로픽스바</option>
                                <option value="8" <% If WHICHI_AUTO = "8" Then Response.Write "selected" %> >픽스하바</option>
                                <option value="9" <% If WHICHI_AUTO = "9" Then Response.Write "selected" %> >픽스상바</option>
                                <option value="10" <% If WHICHI_AUTO = "10" Then Response.Write "selected" %> >코너바</option>
                            </select>
                          </td>
                          <% end if %>
                        </tr>
                        <tr>
                          <th>측정폭</th>
                          <th>정면폭</th>
                        </tr>
                        <tr>
                          <td><input class="input-field" type="text" size="8" name="xsize" id="xsize" value="<%=xsize%>" onkeypress="handleKeyPress(event, 'xsize', 'xsize')"/></td>
                          <td><input class="input-field" type="text" size="8" name="ysize" id="ysize" value="<%=ysize%>" onkeypress="handleKeyPress(event, 'ysize', 'ysize')"/></td>
                        </tr>
                        <tr>
                          <th colspan="2">알루미늄자재</th>
                        </tr>
                        <tr>
                          <td colspan="2">
                            <select class="input-field" name="TNG_Busok_idx" id="TNG_Busok_idx"  onchange="handleChange(this)">
<%
SQL=" select TNG_Busok_idx, T_Busok_name_f "
SQL=SQL&" from TNG_Busok "
SQL=SQL&" where SJB_TYPE_NO='"&SJB_TYPE_NO&"' and WHICHI_FIX='"&WHICHI_FIX&"'  and WHICHI_AUTO='"&WHICHI_AUTO&"' and SJB_FA='"&SJB_FA&"' "
Rs1.open Sql,Dbcon
If Not (Rs1.bof or Rs1.eof) Then 
Do until Rs1.EOF
TNG_Busok_idx=Rs1(0)
T_Busok_name_f=Rs1(1)
%>
                                <option value="<%=TNG_Busok_idx%>" <% if Cint(TNG_Busok_idx)=Cint(Busok_idx) then response.write "selected" end if %> ><%=T_Busok_name_f%></option>
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
                            <td><button class="btn btn-success btn-small" type="button" style="width: 80px;" onclick="window.open('TNG1_JULGOK_IN_SUB.asp?SJB_IDX=<%=SJB_IDX%>&bfidx=<%=bfidx%>#<%=bfidx%>', 'popupWindow', 'width=1200,height=800,scrollbars=yes,resizable=yes');">절곡바라시</button></td>
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
            <div class="col-2">
                <div class="card card-body mb-1">
                  <div class="row">
                    <div class="col">
    
                    <iframe src="iframeimg.asp?sjb_idx=<%=sjb_idx%>&bfidx=<%=bfidx%>" width="220" height="220" style="border: none; display: block;"></iframe>

                    </div>
                  </div>

                  <div class="row">
                    <div class="col">
                      <table  class="table custom-table">
                        <tr>
                          <th>자재명</th>
                          <th>사용위치</th>
                        </tr>
                        <% IF SJB_FA="1" then %>
                        <tr>
                          <td><%=set_name_FIX%></td>
                          <td><%=WHICHI_FIX_text%></td>
                        </tr>
                        <% ELSE SJB_FA="2"  %>
                        <tr>
                          <td><%=set_name_AUTO%></td>
                          <td><%=WHICHI_AUTO_text%></td>
                        </tr>
                        <% end if  %>
                        <tr>
                          <th>측면폭</th>
                          <th>정면폭</th>
                        </tr>
                        <tr>
                          <td><%=xsize%></td>
                          <td><%=ysize%></td>
                        </tr>
                        <tr>
                          <th colspan="2">알루미늄자재</th>
                        </tr>
                        <tr>
                          <td colspan="2" class="title-cell"><span class="title-text"><% if Busok_idx<>"" then %><%=T_Busok_name_f%><% else %>없음<% end if %></span>
                          <img src="/img/frame/bfimg/<%=bfimg1%>" class="hover-image" alt="미리보기">
                          </td>
                        </tr>

                        <tr>
                          <td colspan="2"><button class="btn btn-success btn-small" type="button" style="width: 80px;" onclick="window.open('TNG1_JULGOK_IN_SUB.asp?SJB_IDX=<%=SJB_IDX%>&bfidx=<%=bfidx%>#<%=bfidx%>', 'popupWindow', 'width=1200,height=800,scrollbars=yes,resizable=yes');">절곡바라시</button></td>
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
  WHICHI_FIX_text =""
  WHICHI_AUTO_text =""
  cccc=""
Rs.MoveNext
Loop
End If 
Rs.Close 
%>
        </div>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
 </form>
           
        </div>
    </div>


        
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>