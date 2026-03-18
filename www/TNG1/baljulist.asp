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
  projectname="발주목록"

  rsjcidx=request("sjcidx")
  rsjmidx=request("sjmidx")
  rsjidx=request("sjidx")
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
	page_name="tng1b.asp?listgubun="&listgubun&"&"

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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
        document.getElementById("dataForm").addEventListener("keypress", function (event) {
            if (event.key === "Enter") { // Enter 키를 감지
                event.preventDefault(); // 기본 Enter 동작 방지
                document.getElementById("hiddenSubmit").click(); // 폼 제출
            }
        });
        function del(sTR){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="test0123db.asp?part=delete&midx="+sTR;
            }
        }
    </script>
</head>
<body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  

    <div class="py-5 container text-center">
      <div class="row">
        <div class="col-10"></div>
        <div class="col-2 text-start">
          <form id="dataForm" action="baljulist.asp" method="POST">   
          <!-- input 형식 시작--> 
                  <div class="input-group mb-3">
                      <span class="input-group-text">검색&nbsp;&nbsp;&nbsp;</span>
                      <input type="text" class="form-control" name="cname" value="<%=Request("cname")%>">
                  </div>
          <!-- input 형식 끝--> 
          <button type="submit" id="hiddenSubmit" style="display: none;"></button>
          </form>
        </div>
      </div>
<!-- 표 형식 시작--> 
        <div class="input-group mb-3">
          <table id="datatablesSimple"  class="table table-hover">
              <thead>
                  <tr>
                      <th class="text-center">수주번호</th>
                      <th class="text-center">거래처</th>
                      <th class="text-center">출고일</th>
                      <th class="text-center">도장출고일</th> 
                      <th class="text-center">출고방식</th>  
                      <th class="text-center">현장명</th> 
                      <th class="text-center">설정</th> 
                      <th class="text-center">거래처담당자</th> 
                      <th class="text-center">작성자</th> 
                      <th class="text-center">작성일</th> 
                      <th class="text-center">수정자</th> 
                      <th class="text-center">수정일</th> 
                  </tr>
              </thead>
              <tbody>
<form id="dataForm" action="test0123db.asp" method="POST">   
<input type="hidden" name="midx" value="<%=rmidx%>">

<%
SQL=" Select A.sjidx, A.sjdate, A.sjnum, Convert(Varchar(10),A.cgdate,121), Convert(Varchar(10),A.djcgdate,121) "
SQL=SQL&" , A.cgtype, A.cgaddr, A.cgset, A.sjmidx, A.sjcidx "
SQL=SQL&" , A.midx, Convert(Varchar(10),A.wdate,121), A.meidx, Convert(Varchar(10),A.mewdate,121) "
SQL=SQL&" , B.cname, C.mname, D.mname, E.mname "
SQL=SQL&" From tng_sja A "
SQL=SQL&" Join tk_customer B On A.sjcidx=B.cidx "
SQL=SQL&" Join tk_member C On A.sjmidx=C.midx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "

SQL=SQL&" Where B.cname like '%"&Request("cname")&"%' or B.cnumber like '%"&Request("cname")&"%' or B.cceo like '%"&Request("cname")&"%' "
SQl=SQL&" or  B.cmemo like '%"&Request("cname")&"%' or  B.caddr1 like '%"&Request("cname")&"%' "
SQL=SQL&"  Order by A.sjidx desc "

Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
  sjidx=Rs(0) '발주키
  sjdate=Rs(1)  '발주일
  sjnum=Rs(2) '발주번호
  cgdate=Rs(3)  '출고일
  djcgdate=Rs(4)  '도장출고일
  cgtype=Rs(5)  '출고방식
  select case cgtype
  case "1"
    cgtype_text="A타입"
  case "2"
    cgtype_text="B타입"
  case "3"
    cgtype_text="C타입"
  case "4"
    cgtype_text="D타입"
  end select                         

  cgaddr=Rs(6)  '출고현장
  cgset=Rs(7) '입금후출고설정
  select case cgset
  case "0"
    cgset_text="해당없음"
  case "1"
    cgset_text="적용"
  end select    


  sjmidx=Rs(8)  '거래처담당자키
  sjcidx=Rs(9)  '거래처 키
  midx=Rs(10) '작성자키
  wdate=Rs(11)  '작성일
  meidx=Rs(12)  '수정자키
  mewdate=Rs(13)  '수정일
  cname=Rs(14)  '거래처명
  amname=Rs(15) '거래처담당자명
  bmname=Rs(16) '작성자명
  cmname=Rs(17) '수정자명


%>              

                  <tr>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=Left(sjdate,4)%><%=Mid(sjdate,6,2)%><%=Right(sjdate,2)%>-<%=sjnum%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=cname%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=cgdate%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=djcgdate%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=cgtype_text%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=cgaddr%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=cgset_text%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=amname%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=bmname%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=wdate%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=cmname%></a></td>
                      <td class="text-center"><a href="tng1b.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=sjmidx%>&sjidx=<%=sjidx%>"><%=mewdate%></a></td>
                  </tr>

<%
Rs.movenext
Loop
End If 
Rs.Close 
%>
<button type="submit" id="hiddenSubmit" style="display: none;"></button>
</form>
              </tbody>
          </table>
        </div>
<!-- 표 형식 끝--> 

 
    </div>    

<!-- 내용 입력 끝 --> 
        </div>
    </div>
</main>                          
<!-- footer 시작 -->    
Coded By 양양
<!-- footer 끝 --> 
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
