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
 
projectname="발주 및 견적"
%>
 
<%


part = Request("part")

If part = "edit" Then
    edit = part
ElseIf part = "balju" Then
    balju = part
End If

SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="order.asp?listgubun="&listgubun&"&subgubun="&subgubun&"&"


  rsjcidx=request("sjcidx")
  rsjmidx=request("sjmidx")
  rsjidx=request("sjidx")
  rTIDX=request("TIDX")

%>
<%
'=============
'SELECT  TNG_T 쿼리 만들어 놓은것
sql = "SELECT T_QY, T_YN, T_GLASS_DOOR, T_GLASS_FIX, T_FW "
sql = sql & ", T_FH, T_FL, T_OP, T_DFL, T_BOXFL, T_up "
sql = sql & ", T_D_W, T_D_H, T_H_2, T_D_HD, T_LR "
sql = sql & "FROM TNG_T "
'sql = sql & " WHERE TIDX = " & rTIDX & " "
Response.write (SQL)
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 

    T_QY         = rs(0)
    T_YN         = rs(1)
    T_GLASS_DOOR = rs(2)
    T_GLASS_FIX  = rs(3)
    T_FW         = rs(4)
    T_FH         = rs(5)
    T_FL         = rs(6)
    T_OP         = rs(7)
    T_DFL        = rs(8)
    T_BOXFL      = rs(9)
    T_up         = rs(10)
    T_D_W        = rs(11)
    T_D_H        = rs(12)
    T_H_2        = rs(13)
    T_D_HD       = rs(14)
    T_LR         = rs(15)
    
    End if
    Rs.Close
%>
<%

SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnumber,B.mname, B.mhp "
SQL=SQL&" From tk_customer A "
SQL=SQL&" Left outer Join tk_member B On A.cidx=B.cidx "
SQL=SQL&" Where B.midx='"&rsjmidx&"' "
SQL=SQL&"  Order by A.cname asc "
'Response.write (SQL)
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  cidx=Rs(0)
  cstatus=Rs(1)
    select case cstatus
      case "0"
        cstatus_text="미사용"
      case "1"
        cstatus_text="사용"
    end select
  cname=Rs(2)
  cceo=Rs(3)
  ctkidx=Rs(4)
    If ctkidx="1" then 
      ctkidx_text="태광도어"
    Elseif ctkidx="2" then 
      ctkidx_text="티엔지단열프레임"
    Elseif ctkidx="3" then
      ctkidx_text="태광인텍"
    End If 

  caddr1=Rs(5)
  cmemo=Rs(6)
  cwdate=Rs(7)
  ctel=Rs(8)
  cfax=Rs(9)
  cnumber=Rs(10)
  cnumtext=Left(cnumber,3)&"-"&Mid(cnumber,4,2)&"-"&Right(cnumber,5)
  mname=Rs(11)
  mhp=Rs(12)
  if cmemo<>"" then cmemo=replace(cmemo, chr(13)&chr(10),"<br>")

End If
Rs.Close

'=============
'수주정보 시작
sjdate=Request("sujudate")
if sjdate="" then sjdate=date() end if 

if rsjidx="" then '수주정보가 없다면
  'response.write "<br><br><br><br><br><br><br><br>"
  SQL="select max(sjnum) from TNG_SJA where Convert(varchar(10),sjdate,121)='"&sjdate&"' "
  'response.write (SQL)&"<br><br><br><br><br><br><br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    sjnum=Rs(0)
    If Isnull(sjnum) then
      sjnum="1"
    else
      sjnum=sjnum+1
    End If

  End if
  RS.Close

else    '수주정보가 있다면
  SQL="select sjdate, sjnum, Convert(Varchar(10),cgdate,121), Convert(Varchar(10),djcgdate,121), cgtype, cgaddr, cgset, sjmidx, sjcidx "
  SQL=SQL&" , midx, Convert(Varchar(10),wdate,121), meidx, Convert(Varchar(10),mewdate,121) "
  SQL=SQL&" From tng_sja where sjidx='"&rsjidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      sjdate=Rs(0)
      sjnum=Rs(1)
      cgdate=Rs(2)
      djcgdate=Rs(3)
      cgtype=Rs(4)
      cgaddr=Rs(5)
      cgset=Rs(6)
      sjmidx=Rs(7)
      sjcidx=Rs(8)
      midx=Rs(9)
      wdate=Rs(10)
      meidx=Rs(11)
      mewdate=Rs(12)
    End if
    RS.Close

end if
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
        body {
            zoom: 1;
            /* margin: 0; /* 기본 여백 제거 */
        /* transform: scale(0.8); /* 크기를 줄임 */
        /* transform-origin: top center; /* 축 기준을 화면 상단 중앙으로 설정 */
        /* width: calc(100% / 1); /* 축소 배율에 맞춰 전체 너비를 설정 */
        /* height: calc(100% / 1); /* 축소 배율에 맞춰 전체 높이를 설정 */
        /* overflow: hidden; /* 스크롤 방지 */
        }
    </style>
    <style>
        /* 카드 전체 크기 조정 */
        .card.card-body {
            padding: 1px; /* 내부 여백 줄이기 */
            margin-bottom: 0.5rem; /* 하단 여백 줄이기 */
        }

        /* 글씨 크기 및 입력 필드 크기 조정 */
        .form-control {
            font-size: 12px; /* 글씨 크기 줄이기 */
            height: 25px; /* 입력 필드 높이 줄이기 */
            padding: 1px 1px; /* 내부 여백 줄이기 */
        }

        /* 레이블 크기 조정 */
        label {
            font-size: 12px;
            margin-bottom: 0px; /* 레이블과 입력 필드 간격 최소화 */
        }

        /* 행(row) 간격 줄이기 */
        .row {
            margin-bottom: 0px; /* 행 간격 줄이기 */
        }
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 18px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }
    </style>
    <style>
        .left {
        background-color: #f8f9fa;
        }

        .right {
        background-color: #e0f7fa;
        }
    </style>
    <style>
    .button-container {
        position: relative;
        display: inline-block;
    }

    .label-text {
        position: static;
        top: 0px;
        left: 0%;
        transform: translateX(0%);
        /* background-color: rgba(0, 0, 0, 0.7); */
        color: #ff; /* 더 선명한 흰색 */
        padding: 0px 0px;
        border-radius: 5px;
        font-weight: 900; /* bold보다 더 두꺼움 */
        font-size: 15px;
        white-space: nowrap;
        /* text-shadow: 1px 1px 2px rgba(0,0,0,0.5); */ /* 글자 외곽 또렷하게 */
    }
    .font-strong-large {
        font-weight: 700;
        font-size: 15px;
        color: #222; /* 글씨 색도 더 진하게 */
        text-align: right; /* 숫자 정렬에 좋음 */
    }
    </style>
    <script>
        function validateForm() {
            {
                document.frmMain2.submit();
            }
        }
    </script>
</head>
<body class="sb-nav-fixed">
    <div class="row" style="height: 100vh; margin: 0;">
            <div class="col-md-4 left" style="height: 100%; padding: 0;"><!-- *  11111111111  -->
                <div class="card card-body" style="height: 100%; overflow: auto;">
                    <button class="btn btn-outline-primary btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#corpCollapse">
                        거래처 정보 보기/숨기기
                    </button>
                    <div class="collapse mt-2" id="corpCollapse">
                        <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <div class="row ">
                                <div class="col-md-2">
                                <label for="name" class="label-text">거래처</label><p>
                                <input type="text" class="form-control font-strong-large" id="cname" name="cname" placeholder="" value="<%=cname%>" onclick="window.open('choicecorp.asp','cho','top=100, left=400, width=800, height=600');">
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">사업장</label><p>
                                <input type="text" class="form-control font-strong-large" id="ctkidx_text" name="ctkidx_text" placeholder="" value="<%=ctkidx_text%>" readonly>
                                </div> 
                                <div class="col-md-1">
                                <label for="name" class="label-text">TEL</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="ctel" placeholder="" value="<%=ctel%>" readonly>
                                </div> 
                                <div class="col-md-1">
                                <label for="name" class="label-text">FAX</label><p>
                                <input type="text" class="form-control font-strong-large" id="cfax" name="cfax" placeholder="" value="<%=cfax%>" readonly>
                                </div> 
                                <div class="col-md-2">
                                <label for="name" class="label-text">비고</label><p>
                                <input type="text" class="form-control font-strong-large" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">참고사항</label><p>
                                <input type="text" class="form-control font-strong-large" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">관리등급</label><p>
                                <input type="text" class="form-control font-strong-large" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                                </div>
                            </div>
                        </div>
                        <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <div class="row ">
                                <div class="col-md-2">
                                    <label for="name" class="label-text">수주일자</label><p>
                                    <input type="date" class="form-control" id="sjdate" name="sjdate" placeholder="<%=sjdate%>" value="<%=sjdate%>" >
                                </div>
                                <div class="col-md-2">
                                    <label for="name" class="label-text">수주번호</label><p>
                                    <input type="number" class="form-control" id="sjnum" name="sjnum" placeholder="<%=sjnum%>" value="<%=sjnum%>" readonly>
                                </div> 
                                <div class="col-md-2">
                                    <label for="name" class="label-text">출고일자</label><p>
                                    <input type="date" class="form-control" id="cgdate" name="cgdate" placeholder="" value="<%=cgdate%>" >
                                </div>
                                <div class="col-md-2">
                                    <label for="name" class="label-text">도장출고일자</label><p>
                                    <input type="date" class="form-control" id="djcgdate" name="djcgdate" placeholder="" value="<%=djcgdate%>" >
                                </div>  
                                <div class="col-md-4">
                                    <label for="name" class="label-text">출고방식</label><p>
                                    <select name="cgtype" class="form-control" id="cgtype" required>
                                        <option value="1">A타입</option>
                                        <option value="2">B타입</option>
                                        <option value="3">C타입</option>
                                        <option value="4">D타입</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <div class="row ">
                                <div class="col-md-4">
                                    <label for="name" class="label-text">현장명</label><p>
                                    <input type="text" class="form-control font-strong-large" id="cgaddr" name="cgaddr" placeholder="" value="<%=cgaddr%>" >
                                </div>
                                <div class="col-md-2">
                                    <label for="name" class="label-text">입금후출고 설정</label><p>
                                    <select name="cgset" class="form-control" id="cgtype" required>
                                        <option value="0">해당없음</option>
                                        <option value="1">적용</option>

                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="name" class="label-text"> 업체담당자명</label><p>
                                    <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="<%=mname%>" readonly>
                                </div>
                                <div class="col-md-3">
                                    <label for="name" class="label-text">업체담당자 TEL</label><p>
                                    <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="<%=mhp%>"  readonly>
                                </div>
                            </div>
                        </div>    
                        <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <div class="row ">
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차받는분</label><p>
                                <input type="text" class="form-control font-strong-large" id="yname" name="yname" placeholder="" value="<%=yname%>">
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차받는전화</label><p>
                                <input type="tel" class="form-control" id="ytel" name="ytel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ytel%>">
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">하차지주소</label><p>
                                <input type="text" class="form-control font-strong-large" id="yaddr" name="yaddr" placeholder="" value="<%=yaddr%>">
                                </div> 
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차도착일</label><p>
                                <input type="date" class="form-control" id="ydate" name="ydate" placeholder="" value="<%=Left(ydate,10)%>">
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차도착시간</label><p>
                                <input type="time" class="form-control" id="ydateh" name="ydateh" placeholder="" value="<%=hour(ydate)%>:<%=minute(ydate)%>">
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차당부사항</label><p>
                                <input type="text" class="form-control font-strong-large" id="ymemo" name="ymemo" placeholder="" value="<%=ymemo%>">
                                </div>
                            </div>
                        </div>
                        <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                            <div class="row ">    
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차차량번호</label><p>
                                <input type="tel" class="form-control" id="ycarnum" name="ycarnum"  placeholder="" value="<%=ycarnum%>">
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">운전자명</label><p>
                                <input type="text" class="form-control font-strong-large" id="ygisaname" name="ygisaname" placeholder="" value="<%=ygisaname%>">
                                </div> 
                                <div class="col-md-2">
                                <label for="name" class="label-text">배차차량전번</label><p>
                                <input type="text" class="form-control font-strong-large" id="ygisatel" name="ygisatel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ygisatel%>">
                                </div> 
                                <div class="col-md-2">
                                <label for="name" class="label-text">용차착불여부</label><p>
                                    <select name="ycostyn" class="form-control" id="ycostyn" required>
                                        <option value="0">해당없음</option>
                                        <option value="1">착불</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                <label for="name" class="label-text">선불금액</label><p>
                                <input type="text" class="form-control font-strong-large" id="yprepay" name="yprepay" placeholder="" value="<%=yprepay%>">
                                </div> 
                                <div class="col-md-1">
                                <% if rsjidx<>"" then %>
                                    <label for="name" class="label-text">저장/삭제</label><p>
                                    <% if yidx="" then %>
                                    <button class="btn btn-success btn-small" type="button" Onclick="yong();">저장</button>
                                    <% else %>
                                    <button class="btn btn-success btn-small" type="button" Onclick="yong();">수정</button>
                                    <button class="btn btn-danger btn-small" type="button" Onclick="delyong();">삭제</button>
                                    
                                    <% end if %>
                                <% end if %>
                                </div>
                            </div>
                        </div>
                    </div>    
                    <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                        <div class="row ">
                            <div class="col-md-3">
                            <label for="name" class="label-text">단가</label><p>
                            <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_P_DANGA" >
                            </div>
                            <div class="col-md-3">
                            <label for="name" class="label-text">단가할인율</label><p>
                            <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_P_DC" >
                            </div>
                            <div class="col-md-3">
                            <label for="name" class="label-text">도어제외금액</label><p>
                            <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_P_DANGA_DX" >
                            </div>
                            <div class="col-md-3">
                            <label for="name" class="label-text">총금액(부가세별도)</label><p>
                            <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_P_CHONG" >
                            </div>
                            <div class="col-md-4">
                                <label for="name" class="label-text" style="font-size: 20px; font-weight: bold;">가격전송</label>
                            </div>
                        </div>
                    </div>
                    <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                        <div class="row ">
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">수량</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_QY" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어같이_유무</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_YN" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어유리두께</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_GLASS_DOOR" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">픽스유리두께</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_GLASS_FIX" >
                                </div>
                            </div>
                            <div class="row">    
                                <div class="col-md-3">
                                <label for="name" class="label-text">검측가로</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_FW" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">검측세로</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_FH" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">바닥묻힘(FL)</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_FL" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">오픈</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_OP" >
                                </div> 
                            </div>
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어 검측 높이</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_DFL" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">박스 위 라인</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_BOXFL" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">상부 남마 내경</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_up" >
                                </div>      
                            </div>
                            <div class="row ">
                                <div class="col-md-4">
                                    <label for="name" class="label-text" style="font-size: 20px; font-weight: bold;">자동 필수입력</label>
                                </div>
                            </div>
                        </div>
                    </div>  
                    <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                        <div class="row ">
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어_가로줄이기</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_D_W" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어_높이줄이기</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_D_H" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">하바분할픽스내경</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_H_2" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">양개언발란스_하바치수</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_D_HD" >
                                </div>
                            </div>
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">외부방향(좌/우)</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_LR" >
                                </div>
                            </div>
                            <div class="row ">
                                <div class="col-md-4">
                                    <label for="name" class="label-text" style="font-size: 20px; font-weight: bold;">자동추가옵션</label>
                                </div>
                            </div>
                        </div>
                    </div> 
                    <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                        <div class="row ">
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">수동 도어같이_유무</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_YN" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">수동도어유리두께</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_GLASS_DOOR" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">수동픽스유리두께</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_GLASS_FIX" >
                                </div>
                            </div>
                            <div class="row">    
                                <div class="col-md-3">
                                <label for="name" class="label-text">전체 검측가로</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_FW" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">전체 검측세로</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_FH" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">수동 바닥묻힘(FL)</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_FL" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">오픈</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_OP" >
                                </div> 
                            </div>
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어 검측 높이</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_DFL" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">박스 위 라인</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_BOXFL" >
                                </div>
                                <div class="col-md-3">
                                <label for="name" class="label-text">상부 남마 내경</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_up" >
                                </div>      
                            </div>
                            <div class="row ">
                                <div class="col-md-4">
                                    <label for="name" class="label-text" style="font-size: 20px; font-weight: bold;">수동 필수입력</label>
                                </div>
                            </div>
                        </div>
                    </div>  
                    <div style="border: 2px solid #555555; padding: 1px; border-radius: 5px; margin-bottom: 2px;">
                        <div class="row ">
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어_가로줄이기</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_D_W" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">도어_높이줄이기</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_D_H" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">하바분할픽스내경</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_H_2" >
                                </div> 
                                <div class="col-md-3">
                                <label for="name" class="label-text">롯트센터</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="Tf_lc" >
                                </div>
                            </div>
                            <div class="row ">
                                <div class="col-md-3">
                                <label for="name" class="label-text">수동 외부방향(좌/우)</label><p>
                                <input type="text" class="form-control font-strong-large" id="" name="" placeholder="" value="T_LR" >
                                </div>
                            </div>
                            <div class="row ">
                                <div class="col-md-4">
                                    <label for="name" class="label-text" style="font-size: 20px; font-weight: bold;">수동추가옵션</label>
                                </div>
                            </div>
                        </div>
                    </div> 
                    <div style="margin-bottom: 10px;">
                        <button onclick="history.back();" class="btn btn-danger">이전 화면으로</button>
                    </div>
                </div>
            </div>
                <% If part = "edit"  Then %>
            <div class="col-md-8 right" style="height: 100%; padding: 0;"><!-- *  2222222 -->
                <div class="card card-body" style="height: 100%; border: 2px solid black; overflow: auto;">
                    <div class="row">
                        <div class="col">
                            <iframe src="TNG1_GREEMLIST_edit.asp?&part=edit" width="100%" height="1200" style="border: none; display: block;"></iframe>
                        </div>
                    </div>
                </div>
            </div>
                <% elseif part = "balju" then %>
            <div class="col-md-8 right" style="height: 100%; padding: 0;"><!-- *  2222222 -->
                <div class="card card-body" style="height: 100%; border: 2px solid black; overflow: auto;">
                    <form name="frmMain2" method="post" action="TNG1_FRAME_A_BAJU.asp" >
                        <input type="hidden" name="rfidx" value="<%=fidx%>">
                        <input type="hidden" name="part" value="balju">
                        <div class="row">
                            <div class="col">
                            <iframe name="frmMain2" src="TNG1_FRAME_A_BAJU.asp" width="700" height="1200" style="border: none; display: block;"></iframe>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <% End If %>
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
