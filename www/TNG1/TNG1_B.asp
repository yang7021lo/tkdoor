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
  rsjcidx=request("cidx") '발주처idx
  rsjcidx=request("sjcidx") '발주처idx 
  rsjmidx=request("sjmidx") '거래처담당자idx
  rsjidx=request("sjidx") '수주idx
  rsjsidx=request("sjsidx") '품목idx
  rsuju_kyun_status=request("suju_kyun_status") '0은 수주 1은 견적
  money_reset = request("money_reset")
  SearchWord=Request("SearchWord")
  gubun=Request("gubun")
  retc_idx=request("etc_idx") '
  
'TNG1_B 페이지에서 복사 버튼 누를시 작동
'복사 하기
%>
<script type="text/javascript">
    function frame_copy(sjsidx,midx,sprice,framename){


      var copyQty = prompt("복사할 수량을 입력하세요", "1");
       if(copyQty === null) return;

      console.log("sjsidx = "+ sjsidx)
      console.log("sjidx = "+ sjidx)    
      console.log("midx= "+ midx)
            fetch("TNG1_B_DB.asp", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body:
                "gubun=copys" +
                "&sjsidx=" + encodeURIComponent(sjsidx) +
                "&copyQty=" + encodeURIComponent(copyQty) +
                "&sjidx=" + encodeURIComponent(sjidx) +
                "&midx=" + encodeURIComponent(midx) +
                "&sprice=" + encodeURIComponent(sprice) +
                "&framename=" + encodeURIComponent(framename)
        })
        .then(res => res.text())
        .then(msg => {
            console.log("서버 응답:", msg);
            alert("복사 완료");
            location.reload();
        })
        .catch(err => {
            console.error(err);
            alert("복사 실패");
        });
        
    
    
    }
</script>

<% 
'TNG1_B 페이지에서 제거 버튼 누를시 작동 '제거하기 
%>
<script type="text/javascript">
    function frame_delete(sjsidx,midx,sprice,framename){


      var deleteQty = prompt("제거할 수량을 입력하세요", "1");
       if(deleteQty === null) return;

      console.log("sjsidx = "+ sjsidx)
      console.log("sjidx = "+ sjidx)    
      console.log("midx= "+ midx)
            fetch("TNG1_B_DB.asp", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body:
                "gubun=frame_delete" +
                "&sjsidx=" + encodeURIComponent(sjsidx) +
                "&deleteQty=" + encodeURIComponent(deleteQty) +
                "&sjidx=" + encodeURIComponent(sjidx) +
                "&midx=" + encodeURIComponent(midx) +
                "&sprice=" + encodeURIComponent(sprice) +
                "&framename=" + encodeURIComponent(framename)
        })
        .then(res => res.text())
        .then(msg => {
            console.log("서버 응답:", msg);
            alert("제거 완료");
            location.reload();
        })
        .catch(err => {
            console.error(err);
            alert("제거 실패");
        });
        
    
    
    }
</script>

<%
   ' If Request("mode") = "suju_kyun_status" Then 'suju_kyun_status= 0은 수주 1은 견적
        'rsuju_kyun_status = 1
    'Else
        'rsuju_kyun_status = 0
    'End If
    'Session("rsuju_kyun_status") = rsuju_kyun_status
'Response.Write "rsuju_kyun_status: " & rsuju_kyun_status & "<br>"

  if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
  end if

	page_name="tng1_b.asp?listgubun="&listgubun&"&"

' ===== 출력상태 업데이트 (모달 열릴 때 호출) =====
If LCase(Trim(Request("action"))) = "set_print_status" Then

  Dim ptype, sjidx, sql
  ptype = LCase(Trim(Request("ptype")))
  sjidx = Trim(Request("sjidx"))

  If c_midx = "" Then
    Response.Write "NO_LOGIN"
    Response.End
  End If

  If sjidx = "" Or Not IsNumeric(sjidx) Then
    Response.Write "INVALID_SJIDX"
    Response.End
  End If

  sql = ""
  Select Case ptype
    Case "order"
      sql = "UPDATE tng_sja SET balju_status = 1 WHERE sjidx = " & CLng(sjidx)
    Case "sticker"
      sql = "UPDATE tng_sja SET sticker_status = 1 WHERE sjidx = " & CLng(sjidx)
    Case Else
      Response.Write "INVALID_TYPE"
      Response.End
  End Select

  Dbcon.Execute sql
  Response.Write "OK"
  Response.End
End If

<!-- 수주에서 견적으로 변경 -->
if Request("action") = "suju_to_estimate" then
    SQL = "UPDATE tng_sja SET suju_kyun_status = 1 WHERE sjidx='" & rsjidx & "'"
    Dbcon.Execute (SQL)
    Response.Redirect "TNG1_B.asp?sjcidx=" & rsjcidx & "&sjmidx=" & rsjmidx & _
                  "&sjidx=" & rsjidx & "&suju_kyun_status=1"
end if
'=============
'품목삭제 시작 
if Request("gubun")="udt1" then 

    SQL = "DELETE FROM tng_sjaSub WHERE sjsidx='" & rsjsidx & "'"
    'SQL=" update tng_sjaSub set astatus=0 where sjsidx='"&rsjsidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

  sql = "update TNG_SJA set meidx = '"&c_midx&"' where sjidx='"&rsjidx&"'"
  Dbcon.Execute(sql)
  
end if
'품목삭제 끝
'=============
  SQL="select tsprice, trate, tdisprice, tfprice, taxprice, tzprice ,money_status,suju_kyun_status  "
  SQL=SQL&" From tng_sja where sjidx='"&rsjidx&"' "
  'SQL=SQL&" and suju_kyun_status='"&rsuju_kyun_status&"' " 'suju_kyun_status= 0은 수주 1은 견적
  'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      btsprice=Rs(0)
      btrate=Rs(1)
      btdisprice=Rs(2)
      btfprice=Rs(3)
      btaxprice=Rs(4)
      btzprice=Rs(5)
      money_status=Rs(6) '수주금액 상태
      suju_kyun_status=Rs(7)
      ' URL 파라미터가 없으면 DB에서 읽은 값 사용
      If rsuju_kyun_status = "" Then
        rsuju_kyun_status = suju_kyun_status
      End If
    End if
    RS.Close

'기타자재 입력 시작
'=============
'삭제
    if Request("gubun")="etc1" then 

        retc_idx = Request("etc_idx") 
        'Response.Write "retc_idx: " & retc_idx & "<br>"
        SQL=" delete from tk_etc where etc_idx='"&retc_idx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

    end if
'인서트
    if Request("gubun")="etc2" then
        'retc_idx   = Request("etc_idx")
        'retc_name=request("etc_name") '제품명
        'retc_price=replace(Request("etc_price"),",","")  
        'If IsNumeric(retc_price) Then
        '  retc_price = CLng(retc_price)   ' 정수 변환
        'Else
        '  retc_price = 0
        'End If
        'retc_qty=request("etc_qty") '수량
        ' Response.Write "retc_qty: " & retc_qty & "<br>"
        rsjcidx     = Request("sjcidx")
        rsjmidx      = Request("sjmidx")
        rsjidx     = Request("sjidx")
        rsjsidx      = Request("sjsidx")
        retc_idx=0
  
        sql = "INSERT INTO tk_etc (etc_name, etc_qty, midx, mdate, etc_price, sjidx) "
        sql = sql & "VALUES ("
        sql = sql & "'" & retc_name & "', "
        sql = sql & "'" & retc_qty & "', "
        sql = sql & "'" & rsjmidx & "', "
        sql = sql & "GETDATE(), "
        sql = sql & "'" & retc_price & "', "
        sql = sql & "'" & rsjidx & "')"
        'Response.write (SQL)&"<br><br>"
        Dbcon.Execute (SQL)
        'response.end  
    end if
' 수정
if Request("gubun")="etc3" then
    retc_idx   = Request("etc_idx")
    retc_name=request("etc_name") '제품명
    retc_price=replace(Request("etc_price"),",","")  
    If IsNumeric(retc_price) Then
      retc_price = CLng(retc_price)   ' 정수 변환
    Else
      retc_price = 0
    End If
    retc_qty=request("etc_qty") '수량
      Response.Write "retc_qty: " & retc_qty & "<br>"
    rsjcidx     = Request("sjcidx")
    rsjmidx      = Request("sjmidx")
    rsjidx     = Request("sjidx")
    rsjsidx      = Request("sjsidx")

    etc_total_price = retc_price * retc_qty



etc_tsprice = btsprice+etc_total_price  '최종_공급가합 + 기타자재금액
etc_fprice = btfprice+etc_total_price  '최종공급가액의 합 (공급가+세액)
etc_taxprice = etc_fprice * 0.1 '세액 10% 계산
etc_tzprice = etc_fprice + etc_taxprice

    SQL="Update tng_sja set tsprice='"&etc_tsprice&"' , tfprice='"&etc_fprice&"', taxprice='"&etc_taxprice&"', tzprice='"&etc_tzprice&"', money_status=1 Where sjidx='"&rsjidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    SQL="Update tk_etc set etc_name='"&retc_name&"', etc_price='"&retc_price&"', etc_qty='"&retc_qty&"', sjidx='"&rsjidx&"' Where etc_idx='"&retc_idx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    'response.end



end if

'=============
'기타자재 끝

'수주금액 입력 시작
'=============
if gubun="supriceinput" then 

atsprice   = replace(Request("tsprice"),",","")         '🧮 화면상의 최종_공급가합
atrate     = replace(Request("trate"),",","")           '📉 추가_할인율
atdisprice = replace(Request("tdisprice"),",","")       '📉 추가_할인금액
atfprice   = replace(Request("tfprice"),",","")         '💸 최종_공급가액
ataxprice  = replace(Request("taxprice"),",","")        '📌 최종_세액
atzprice   = replace(Request("tzprice"),",","")         '✅ 최종_금액

redirect_type = Request("redirect_type")                ' 간이견적/등 출력용 플래그

' btsprice는 DB에 저장된 이전 tsprice, atsprice는 화면 계산 값
if atsprice = "" then atsprice = btsprice

'할인율/할인금액 동기화
  if (CStr(atrate) <> CStr(btrate)) and (CStr(atdisprice) = CStr(btdisprice)) then

    ' 추가_할인율 기준으로 할인금액 재계산 (기준은 화면상의 최종_공급가합)
    atdisprice = Round(atsprice * atrate / 100, 0)

else

    ' 추가_할인금액 기준으로 할인율 재계산
    if atsprice <> "0" and atsprice <> "" then
        atrate = Round((atdisprice / atsprice) * 100, 1) ' 소숫점 1자리
    else
        atrate = 0
    end if

  end if

' 최종_공급가액 = 최종_공급가합 - 추가_할인금액
atfprice = atsprice - atdisprice

' 최종_세액 = 최종_공급가액 * 0.1
ataxprice = atfprice * 0.1
atzprice  = atfprice + ataxprice

' DB 반영
SQL="Update tng_sja set trate='"&atrate&"', tdisprice='"&atdisprice&"', tsprice='"&atsprice&"', tfprice='"&atfprice&"', taxprice='"&ataxprice&"', tzprice='"&atzprice&"', money_status=1  Where sjidx='"&rsjidx&"' "
  'response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

' 간이 견적서로 바로 이동하는 경우
if redirect_type = "simpleOrder" then
    Response.Write "<script>" & _
                   "window.open('/documents/simpleOrder?sjidx=" & rsjidx & "','_blank');" & _
                   "location.href='TNG1_B.asp?sjcidx=" & rsjcidx & "&sjmidx=" & rsjmidx & "&sjidx=" & rsjidx & "';" & _
                   "</script>"
    Response.End
end if

end if
'=============
'수주금액 입력 끝

'=============
'수주정보 시작
sjdate=Request("sujudate")
if sjdate="" then sjdate=date() end if 

if rsjidx="" then '수주정보가 없다면
  'response.write "<br><br><br><br><br><br><br><br>"

  fix_date = Mid(Replace(sjdate, "-", ""), 3)  'sjdate = "2025-07-28" → 250728  
  SQL="select max(sjnum) from TNG_SJA where CAST(sjdate AS DATE)='"&sjdate&"' "
  ' 또는: Convert(varchar(10), sjdate, 121) → yyyy-mm-dd / 112 → yyyymmdd
  'response.write (SQL)&"<br><br><br><br><br><br><br><br>"
 ' response.end
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    new_sjnum=Rs(0)
    If IsNull(new_sjnum) Or new_sjnum = "" Then
        sjnum = fix_date & "0001"
    Else
        sjnum = new_sjnum + 1
    End If

  End if
  RS.Close

    if cgdate="" Then
        cgdate= Date()
    end if
    If djcgdate = "" Then
        djcgdate = DateAdd("d", 1, Date())   ' 기본 내일 날짜
        ' 주말 체크
        Select Case Weekday(djcgdate, 1)
            Case vbSaturday   ' 토요일이면 +2일 (월요일)
                djcgdate = DateAdd("d", 2, djcgdate)
            Case vbSunday     ' 일요일이면 +1일 (월요일)
                djcgdate = DateAdd("d", 1, djcgdate)
        End Select
    End If

else    '수주정보가 있다면
  SQL="select sjdate, sjnum, Convert(Varchar(10),cgdate,121), Convert(Varchar(10),djcgdate,121), cgtype, cgaddr, cgset, sjmidx, sjcidx "
  SQL=SQL&" , midx, Convert(Varchar(10),wdate,121), meidx, Convert(Varchar(10),mewdate,121) "
  SQL=SQL&" , tsprice, trate, tdisprice, tfprice, taxprice, tzprice,suju_kyun_status, move "
  SQL=SQL&" From tng_sja where sjidx='"&rsjidx&"' "
  'SQL=SQL&" and suju_kyun_status='"&rsuju_kyun_status&"' " 'suju_kyun_status= 0은 수주 1은 발주
  'response.write (SQL)&"<br>"
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      sjdate=Rs(0)
      sjnum=Rs(1)
      cgdate=Rs(2)
      djcgdate=Rs(3)
      cgtype=Rs(4)
      cgaddr=Rs(5)
      cgset=Rs(6)
      rsjmidx=Rs(7)
      rsjcidx=Rs(8)
      midx=Rs(9)
      wdate=Rs(10)
      meidx=Rs(11)
      mewdate=Rs(12)
      tsprice=Rs(13)
      trate=Rs(14)
      tdisprice=Rs(15)
      tfprice=Rs(16)
      taxprice=Rs(17)
      tzprice=Rs(18)
      suju_kyun_status=Rs(19)
      move=Rs(20)
      ' URL 파라미터가 없으면 DB에서 읽은 값 사용
      If rsuju_kyun_status = "" Then
        rsuju_kyun_status = suju_kyun_status
      End If
      
    End if
    RS.Close

end if

SQL=" Select A.cidx, A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnumber,B.mname, B.mhp , A.cbran ,A.cmove ,A.cgetmoney "
SQL=SQL&" From tk_customer A "
SQL=SQL&" Left outer Join tk_member B On A.cidx=B.cidx "
if rsjmidx<>"" then
SQL=SQL&" Where B.midx='"&rsjmidx&"' "
else
SQL=SQL&" Where B.midx='"&sjmidx&"' "
end if
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
  cbran=Rs(13)
  cmove=Rs(14)
  cgetmoney=Rs(15)

End If
Rs.Close

if cint(cmove)=cint(cgtype) then
  cgtype=cmove
else 
  cmove=cgtype
end if

if cint(cgetmoney)=cint(cgset) then
  cgset=cgetmoney
else 
  cgetmoney=cgset
end if

'=============
'수중정보 끝


' response.Write "btzprice: " & btzprice & "<br>"
' response.Write "tzprice: " & tzprice & "<br>"
' response.Write "rsjidx: " & rsjidx & "<br>"
' response.Write "cname: " & cname & "<br>"
' response.Write "cgset: " & cgset & "<br>"
' response.Write "cgetmoney: " & cgetmoney & "<br>"
' response.end

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
    <link rel="icon" sizes="image/x-icon" href="/taekwang_logo.svg">
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
            /zoom: 0.8;
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
            padding: 10px; /* 내부 여백 줄이기 */
            margin-bottom: 0.5rem; /* 하단 여백 줄이기 */
        }

        /* 글씨 크기 및 입력 필드 크기 조정 */
        .form-control {
            font-size: 14px; /* 글씨 크기 줄이기 */
            height: 25px; /* 입력 필드 높이 줄이기 */
            padding: 1px 1px; /* 내부 여백 줄이기 */
        }

        /* 레이블 크기 조정 */
        label {
            font-size: 14px;
            margin-bottom: 0px; /* 레이블과 입력 필드 간격 최소화 */
        }

        /* 행(row) 간격 줄이기 */
        .row {
            margin-bottom: 0px; /* 행 간격 줄이기 */
        }
        /* 🔹 버튼 크기 조정 */
        .btn-small {
            font-size: 14px; /* 글씨 크기 */
            padding: 2px 4px; /* 버튼 내부 여백 */
            height: 22px; /* 버튼 높이를 자동으로 */
            line-height: 1; /* 버튼 텍스트 정렬 */
            border-radius: 3px; /* 모서리를 조금 둥글게 */
        }

    .row-card {
      display: flex;
      align-items: center;
      padding: 15px 20px;
      border: 1px solid #ccc;
      border-radius: 3px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.05);
      background-color: #fff;
      font-family: Arial, sans-serif;
      gap: 16px;
      overflow-x: auto;
      white-space: nowrap;
    }
    .field {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .field span {
      font-weight: bold;
      font-size: 13px;
      color: #333;
      border: 1px solid #ccc;
      background-color: #f0f0f0;
      border-radius: 6px;
      padding: 4px 8px;
    }

    .field input {
      border: 1px solid #ccc;
      border-radius: 6px;
      padding: 4px 8px;
      font-size: 14px;
      width: 120px;
      text-align: right;
    }
    .button {
      padding: 8px 14px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 6px;
      font-size: 14px;
      cursor: pointer;
    }

    .button:hover {
      background-color: #0056b3;
    }
    </style>
    <script>
        // 공용: 출력상태 업데이트 (POST)
        function updatePrintStatus(ptype) {
            // ptype: "order" | "sticker"
            const sjidx = "<%=rsjidx%>";

            // postForm 공용함수 있으면 그거 써도 됨
            return fetch("TNG1_B.asp", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
            body: new URLSearchParams({
                action: "set_print_status",
                ptype: ptype,
                sjidx: sjidx
            }).toString(),
            cache: "no-store",
            credentials: "same-origin"
            })
            .then(r => r.text())
            .then(t => (t || "").trim());
        }

        // 발주서 모달 열릴 때
        document.addEventListener("DOMContentLoaded", function () {
            const poModalEl = document.getElementById("poModal");
            if (poModalEl) {
            poModalEl.addEventListener("shown.bs.modal", function () {
                updatePrintStatus("order").then(function(res){
                if(res !== "OK") console.log("발주서 출력상태 업데이트 실패:", res);
                });
            });
            }

            const stickerModalEl = document.getElementById("stickerSizeModal");
            if (stickerModalEl) {
            stickerModalEl.addEventListener("shown.bs.modal", function () {
                updatePrintStatus("sticker").then(function(res){
                if(res !== "OK") console.log("스티커 출력상태 업데이트 실패:", res);
                });
            });
            }
        });

        function validateform() {
          
            if(document.frmMain.sjcidx.value == "" ) {
                alert("거래처를 선택하세요.");
            return
            }
            /*
            if(document.frmMain.cgdate.value == "" ) {
                alert("출고 날짜를 입력해주세요.");
            return
            }
            if(document.frmMain.djcgdate.value == "" ) {
                alert("도장출고 날짜를 입력해주세요.");
            return
            }
            if(document.frmMain.cgaddr.value == "" ) {
                alert("현장명을 입력해주세요.");
            return
            }
            */
            else {
                document.frmMain.gubun.value = "";  // 일반 저장
                document.frmMain.submit();
            }
        }
        
        function issueSuju() {
            if(document.frmMain.sjcidx.value == "" ) {
                alert("거래처를 선택하세요.");
                return;
            }
            if(confirm("견적을 수주로 발행하시겠습니까?")) {
                // 수주 발행 모드로 전환
                document.frmMain.gubun.value = "issue_suju";
                // 수주로 저장
                document.frmMain.suju_kyun_status.value = "0";
                document.frmMain.submit();
            }
        }

        function yong() {
            if(document.fyong.yname.value == "" ) {
                alert("용차 받는분 이름을 입력하세요.");
            return
            }
            if(document.fyong.ytel.value == "" ) {
                alert("용차 받는분 전화번호를 입력하세요.");
            return
            }
            if(document.fyong.yaddr.value == "" ) {
                alert("하차지 주소를 입력하세요.");
            return
            }
            if(document.fyong.ydate.value == "" ) {
                alert("용차 도착일시를 입력해주세요.");
            return
            }
            
            if(document.fyong.ymemo.value == "" ) {
                alert("당부사항을 입력해 주세요.");
            return
            }
            if(document.fyong.ycarnum.value == "" ) {
                alert("용차 차량번호를 입력해 주세요.");
            return
            }
            if(document.fyong.ygisaname.value == "" ) {
                alert("용차 운전자명을 입력해 주세요.");
            return
            }
            if(document.fyong.ygisatel.value == "" ) {
                alert("배차차량(운전자) 전화번호를 입력해 주세요.");
            return
            }
            if(document.fyong.ycostyn.value == "" ) {
                alert("착불여부을 선택해 주세요.");
            return
            }
            if(document.fyong.yprepay.value == "" ) {
                alert("선불금액을 입력해 주세요.");
            return
            }
            else {
                document.fyong.submit();
            }
        } 
        function daesin() {
            if(document.fdaesin.ds_to_name.value == "" ) {
                alert("택배/화물 받는분 이름을 입력하세요.");
            return
            }
            if(document.fdaesin.ds_to_tel.value == "" ) {
                alert("택배/화물 받는분 전화번호를 입력하세요.");
            return
            }
            if(document.fdaesin.ds_to_addr.value == "" ) {
                alert("택배/화물 받는 주소를 입력하세요.");
            return
            }
            if(document.fdaesin.dsdate.value == "" ) {
                alert("택배 도착일을 입력해주세요.");
            return
            }
            else {
                document.fdaesin.submit();
            }
        }   
        function del(sTR){
            if (confirm("삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_db.asp?gubun=delete&sjcidx=<%=sjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
            }
        }
        function udt1(rsjsidx){
            if (confirm("삭제 하시겠습니까?"))
            {
               
                location.href="TNG1_B.asp?gubun=udt1&sjcidx=<%=sjcidx%>&sjidx=<%=rsjidx%>&sjmidx=<%=rsjmidx%>&sjsidx="+rsjsidx;
            }
        }
        function etc1(retc_idx){
            if (confirm("삭제 하시겠습니까?"))
            {
               
                location.href="TNG1_B.asp?gubun=etc1&sjcidx=<%=sjcidx%>&sjidx=<%=rsjidx%>&sjmidx=<%=sjmidx%>&sjsidx=<%=rsjsidx%>&etc_idx="+retc_idx;
            }
        }
        function etc2() {
            if (confirm("신규 등록 하시겠습니까?")) {
                document.etc_input.gubun.value = "etc2";
                document.etc_input.submit();
            }
        }
        function etc3(etc_idx) {
            if (confirm("수정 하시겠습니까?")) {
                document.etc_input.gubun.value = "etc3";
                document.etc_input.etc_idx.value = etc_idx;
                document.etc_input.submit();
            }
        }
        
        function delyong(sTR){
            if (confirm("용차정보를 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_dbyong.asp?gubun=delete&sjcidx=<%=sjcidx%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
            }
        }
        function deldaesin(sTR){
            if (confirm("화물/택바 정보를 삭제 하시겠습니까?"))
            {
                location.href="TNG1_B_dbDaesin.asp?gubun=delete&sjcidx=<%=sjcidx%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>";
            }
        }
        function inputPhoneNumber(obj){
            var number = obj.value.replace(/[^0-9]/g,"");
            var phone = "";

            if(number.length < 4) {
                return number;
            }else if(number.length < 7) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3);
            }else if(number.length < 11) {
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,3);
                phone += "-";
                phone += number.substr(6);
            }else{
                phone += number.substr(0,3);
                phone += "-";
                phone += number.substr(3,4);
                phone += "-";
                phone += number.substr(7);
            }
            obj.value = phone;
        }
    </script>

</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->

<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">
        <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
<!-- 거래처 정보 선택 시작  -->
        <div style="font-size:50px; font-weight:bold;">
        <%
        ' rsuju_kyun_status가 빈 문자열이거나 NULL일 수 있으므로 안전하게 처리
        If rsuju_kyun_status = "0" Then
            Response.Write "수주"
        ElseIf rsuju_kyun_status = "1" Then
            Response.Write "견적"
        ElseIf IsNumeric(rsuju_kyun_status) Then
            If CInt(rsuju_kyun_status) = 0 Then
                Response.Write "수주"
            ElseIf CInt(rsuju_kyun_status) = 1 Then
                Response.Write "견적"
            End If
        End If
        %>
        </div>
        <div class="card card-body mb-1">  
          <div class="row ">
            <div class="col-md-9" >
              <div class="row ">
                <div class="col-md-2">
                    <label for="name">거래처</label><p>
                    <input type="text" class="form-control" id="cname" name="cname"
                        value="<%=cname%>"
                        onclick="window.open('choicecorp.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&suju_kyun_status=<%=rsuju_kyun_status%>', 'cho', 'top=0,left=0,width=800,height=600');">
                </div>
                <div class="col-md-2">
                <label for="name">사업장</label><p>
                <input type="text" class="form-control" id="ctkidx_text" name="ctkidx_text" placeholder="" value="<%=ctkidx_text%>" readonly>
                </div> 
                <div class="col-md-1">
                <label for="name">관리등급</label><p>
                <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                </div>
                <div class="col-md-1">
                <label for="name">TEL</label><p>
                <input type="text" class="form-control" id="" name="ctel" placeholder="" value="<%=ctel%>" readonly>
                </div> 
                <div class="col-md-1">
                <label for="name">FAX</label><p>
                <input type="text" class="form-control" id="cfax" name="cfax" placeholder="" value="<%=cfax%>" readonly>
                </div> 
                <div class="col-md-2">
                <label for="name">비고</label><p>
                <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                </div>
                <div class="col-md-3">
                <label for="name">참고사항</label><p>
                <input type="text" class="form-control" id="cmemo" name="cmemo" placeholder="" value="<%=cmemo%>" readonly>
                </div>
                
              </div>  <!-- 거래처 정보 선택 끝  -->
                      <!-- 수주정보 선택 시작  -->
              <form name="frmMain" action="TNG1_B_db.asp" method="post" enctype="multipart/form-data">
                <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
                <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
                <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                <input type="hidden" name="gubun" value="">
                <input type="hidden" name="suju_kyun_status" value="<%=rsuju_kyun_status%>">
                <div class="row ">
                  <div class="col-md-12">
                    <div class="row ">
                      <div class="col-md-1">
                          <label for="name">수주일자</label><p>
                          <input type="date" class="form-control" id="sjdate" name="sjdate" placeholder="<%=sjdate%>" value="<%=sjdate%>" >
                      </div>
                      <div class="col-md-1">
                          <label for="name">수주번호</label><p>
                          <input type="number" class="form-control" id="sjnum" name="sjnum" placeholder="<%=sjnum%>" value="<%=sjnum%>" readonly>
                      </div> 
                      <div class="col-md-1">
                          <label for="name">출고일자</label><p>
                          <input type="date" class="form-control" id="cgdate" name="cgdate" placeholder="" value="<%=cgdate%>" >
                      </div>
                      <div class="col-md-1">
                          <label for="name">도장출고일자</label><p>
                          <input type="date" class="form-control" id="djcgdate" name="djcgdate" placeholder="" value="<%=djcgdate%>" >
                      </div>  
                      <div class="col-md-1">
                          <label for="name">기본출고방식</label><p>
                          <select name="cgtype" class="form-control" id="cgtype" required>
                                <option value="1" <% if cmove="1" then Response.write "selected" end if %>>화물</option>                        
                                <option value="2" <% if cmove="2" then Response.write "selected" end if %>>낮1배달_신두영(인천,고양)</option>
                                <option value="3" <% if cmove="3" then Response.write "selected" end if %>>낮2배달_최민성(경기)</option>
                                <option value="4" <% if cmove="4" then Response.write "selected" end if %>>밤1배달_윤성호(수원,천안,능력)</option>
                                <option value="5" <% if cmove="5" then Response.write "selected" end if %>>밤2배달_김정호(하남)</option>
                                <option value="6" <% if cmove="6" then Response.write "selected" end if %>>대구창고</option>
                                <option value="7" <% if cmove="7" then Response.write "selected" end if %>>대전창고</option>
                                <option value="8" <% if cmove="8" then Response.write "selected" end if %>>부산창고</option>
                                <option value="9" <% if cmove="9" then Response.write "selected" end if %>>양산창고</option>
                                <option value="10" <% if cmove="10" then Response.write "selected" end if %>>익산창고</option>
                                <option value="11" <% if cmove="11" then Response.write "selected" end if %>>원주창고</option>
                                <option value="12" <% if cmove="12" then Response.write "selected" end if %>>제주창고</option>
                                <option value="13" <% if cmove="13" then Response.write "selected" end if %>>용차</option>
                                <option value="14" <% if cmove="14" then Response.write "selected" end if %>>방문</option>
                                <option value="15" <% if cmove="15" then Response.write "selected" end if %>>1공장</option>
                                <option value="16" <% if cmove="16" then Response.write "selected" end if %>>인천항</option>
                          </select>
                      </div>
                      <div class="col-md-2">
                          <label for="name">현장명</label><p>
                          <input type="text" class="form-control" id="cgaddr" name="cgaddr" placeholder="" value="<%=cgaddr%>" >
                      </div>
                      <div class="col-md-1">
                          <label for="name">입금후출고 설정</label><p>
                            <select class="form-select" id="cgset" name="cgset">
                                <option value="0" <% if cgset="0" then Response.write "selected" end if %>>x</option>                        
                                <option value="1" <% if cgset="1" then Response.write "selected" end if %>>o</option>
                            </select>
                      </div>
                      <div class="col-md-1">
                          <label for="name">업체담당자명</label><p>
                          <input type="text" class="form-control" id="" name="" placeholder="" value="<%=mname%>" readonly>
                      </div>
                      <div class="col-md-1">
                          <label for="name">업체담당자 TEL</label><p>
                          <input type="text" class="form-control" id="" name="" placeholder="" value="<%=mhp%>"  readonly>
                      </div>
                      <div class="col-md-2">
                            <button class="btn btn-success btn-small" type="button" Onclick="validateform();"><% if rsjidx="" then %>저장<% else %>수정<% end if %></button>
                            <% if rsjidx<>"" then %><button class="btn btn-danger btn-small" type="button" onclick="del();">삭제</button><% end if %>
                            <%
                              if rsjidx<>"" then 
                                class_text="btn btn-secondary btn-small"
                              else
                                class_text="btn btn-outline-secondary btn-small"
                              end if
                            %>
                            <button class="<%=class_text%>" type="button"
                                <% If rsjidx<>"" Then %>
                                    <%
                                    Dim is_kyun_for_quick_btn
                                    is_kyun_for_quick_btn = False
                                    If rsuju_kyun_status = "1" Or suju_kyun_status = "1" Then
                                        is_kyun_for_quick_btn = True
                                    ElseIf rsuju_kyun_status <> "" And Not IsNull(rsuju_kyun_status) And IsNumeric(rsuju_kyun_status) Then
                                        If CInt(rsuju_kyun_status) = 1 Then
                                            is_kyun_for_quick_btn = True
                                        End If
                                    ElseIf suju_kyun_status <> "" And Not IsNull(suju_kyun_status) And IsNumeric(suju_kyun_status) Then
                                        If CInt(suju_kyun_status) = 1 Then
                                            is_kyun_for_quick_btn = True
                                        End If
                                    End If
                                    If is_kyun_for_quick_btn Then %>
                                    onclick="window.open(
                                        'TNG1_B_suju_quick.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>',
                                        '_blank',
                                        'width=' + screen.availWidth + ',height=' + screen.availHeight + ',left=0,top=0'
                                    );"
                                    >
                                신규견적등록
                            </button>
                                    <% Else %>
                                    onclick="window.open(
                                        'TNG1_B_suju_quick.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>',
                                        '_blank',
                                        'width=' + screen.availWidth + ',height=' + screen.availHeight + ',left=0,top=0'
                                    );" 
                                    > 
                                간단견적등록
                            </button>    
                                    <% End If %>        
                                <% End If %>
                            
                            <button class="<%=class_text%>" type="button" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_door_glass_pop.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&mode=all','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>>유리보기</button>
                            <button class="<%=class_text%>" type="button" <% if rsjidx<>"" then %>onclick="window.open('/documents/installationManual/allin.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>&mode=all','_blank','width=1500  , height=1000, top=200, left=900' );" <% end if %>>도면보기</button>
                      </div>
                    </div>
                  </div>
              </form> 
              </div>       
            </div>
            <div class="col-md-3" > <!---도면 보이는 라인 -->
              <div class="card card-body" >
                <div class="row">
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본이미지 등록
                    </button>
                  </div>
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_data.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본파일 등록
                    </button>
                  </div>
                  <div class="col-md-4">
                    <button class="<%=class_text%>" type="button" style="height:50px; width:100%;" <% if rsjidx<>"" then %>
                      onclick="window.open('TNG1_B_datalist.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>', '_blank', 'width=1500,height=1000,top=200,left=900');"
                    <% end if %>>
                      원본리스트
                    </button>
                  </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                            <button class="<%=class_text%>" type="button"
                                onclick="location.href='/TNG_WMS/TNG_WMS_Create.asp?sjidx=<%=rsjidx%>'">
                            🚚 WMS 생성 
                            </button>
                            <button class="<%=class_text%>" type="button"
                                onclick="location.href='/TNG_WMS/TNG_WMS_DASHBOARD.asp?sjidx=<%=rsjidx%>&sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&suju_kyun_status=1';">
                            🚚 대쉬보드
                            </button>
                            <button class="<%=class_text%>" type="button"
                                onclick="openSimpleEstimator();">
                                🧮 판풀이
                            </button>
                            <%
                            Dim is_suju_status
                            is_suju_status = False
                            If rsuju_kyun_status = "0" Then
                                is_suju_status = True
                            ElseIf rsuju_kyun_status <> "" And Not IsNull(rsuju_kyun_status) And IsNumeric(rsuju_kyun_status) Then
                                If CInt(rsuju_kyun_status) = 0 Then
                                    is_suju_status = True
                                End If
                            End If
                            If is_suju_status Then '수주일 때만
                            %>
                                <button class="<%=class_text%>" type="button" <% If rsjidx<>"" Then %>onclick="window.open('TNG1_B_baljuST.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>','_blank','width=1500,height=1000,top=200,left=900');"<% End If %>>절곡발주</button>

                                <button class="<%=class_text%>" type="button" <% If rsjidx<>"" Then %>onclick="window.open('TNG1_B_baljuST1.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>','_blank','width=1500,height=1000,top=200,left=900');"<% End If %>>샤링발주</button>

                                <button class="<%=class_text%>" type="button" <% If rsjidx<>"" Then %>onclick="window.open('TNG1_B_baljuAL.asp?cidx=<%=rsjcidx%>&sjidx=<%=rsjidx%>','_blank','width=1500,height=1000,top=200,left=900');"<% End If %>>AL 발주</button>
                            <%
                            End If
                            ' 견적이면서 move 값이 없는 경우에만 수주 발행 버튼 표시
                            Dim is_kyun_status
                            is_kyun_status = False
                            If rsuju_kyun_status = "1" Then
                                is_kyun_status = True
                            ElseIf rsuju_kyun_status <> "" And Not IsNull(rsuju_kyun_status) And IsNumeric(rsuju_kyun_status) Then
                                If CInt(rsuju_kyun_status) = 1 Then
                                    is_kyun_status = True
                                End If
                            End If
                            If is_kyun_status And (move = "" Or IsNull(move)) Then
                            %>
                                <button class="<%=class_text%>" type="button" onclick="issueSuju();">수주 발행</button>
                            <%
                            End If
                            
                            ' 🔁 견적/수주 상호 이동 버튼 (move 값이 있는 경우만)
                            If rsjidx <> "" And move <> "" Then
                              Dim is_kyun_for_move
                              is_kyun_for_move = False
                              If rsuju_kyun_status = "1" Then
                                  is_kyun_for_move = True
                              ElseIf rsuju_kyun_status <> "" And Not IsNull(rsuju_kyun_status) And IsNumeric(rsuju_kyun_status) Then
                                  If CInt(rsuju_kyun_status) = 1 Then
                                      is_kyun_for_move = True
                                  End If
                              End If
                              If is_kyun_for_move Then
                            %>
                                <button class="<%=class_text%>" type="button"
                                        onclick="location.href='TNG1_B.asp?sjidx=<%=move%>&suju_kyun_status=0';">
                                  수주로 이동
                                </button>
                            <%
                              End If
                              Dim is_suju_for_move
                              is_suju_for_move = False
                              If rsuju_kyun_status = "0" Then
                                  is_suju_for_move = True
                              ElseIf rsuju_kyun_status <> "" And Not IsNull(rsuju_kyun_status) And IsNumeric(rsuju_kyun_status) Then
                                  If CInt(rsuju_kyun_status) = 0 Then
                                      is_suju_for_move = True
                                  End If
                              End If
                              If is_suju_for_move Then
                            %>
                                <button class="<%=class_text%>" type="button"
                                        onclick="location.href='TNG1_B.asp?sjidx=<%=move%>&suju_kyun_status=1';">
                                  견적으로 이동
                                </button>
                            <%
                              End If
                            end if

                            if rsjidx <> "" Then

                            ' === 1) 견적 존재 여부 확인 ===
                            Dim hasEstimateCnt, sqlChk, RsChk

                            sqlChk = "SELECT COUNT(*) AS cnt FROM tng_sja WHERE sjidx=" & rsjidx & " AND move != ''"

                            Set RsChk = Dbcon.Execute(sqlChk)

                            If Not RsChk.EOF Then
                                hasEstimateCnt = CInt(RsChk("cnt"))   ' ← COUNT(*) 결과 값 저장
                            Else
                                hasEstimateCnt = 0
                            End If

                            RsChk.Close
                            Set RsChk = Nothing
                              ' === 2) 현재가 수주(0) + 견적이 없을 때만 버튼 표시 ===
                              If CInt(rsuju_kyun_status) = 0 then
                                
                                if hasEstimateCnt = 0 Then
                              %>
                                <button class="<%=class_text%>" type="button"
                                        onclick="if(confirm('수주를 제거하고 견적으로 생성하시겠습니까?')) location.href='TNG1_B.asp?action=suju_to_estimate&sjidx=<%=rsjidx%>';">
                                  수주 제거 후 견적 생성
                                </button>
                              <%
                                    End If
                                end if
                            end if
                            %>
                    </div>
                </div>
              </div>
            </div>
          </div>
        </div>
<!-- 수주정보 선택 끝  -->
            <div class="card card-body mb-1">       <!-- * 누적 품목 단가 데이터 불러오기 55555555555555555555-->   
                <div class="col-md-12">
                    <table id="datatablesSimple"  class="table table-hover">
                        <thead>
                            <tr>
                                <th class="text-center">순번</th>
                                <th class="text-center">기본품목</th>
                                <th class="text-center">검측가로</th>
                                <th class="text-center">검측세로</th>
                                <th class="text-center">재질</th>
                                <th class="text-center">도장</th>
                                <th class="text-center">프레임 원가</th>
                                <th class="text-center">수량</th>
                                <th class="text-center">할인금액</th>
                                <th class="text-center">공급가(프레임+옵션)</th>
                                <th class="text-center">공급가(도어)</th>
                                <!--
                                <th class="text-center">할인율</th>  
                                -->
                                <th class="text-center">(프레임+옵션+도어)</th>
                                <th class="text-center">세액</th>
                                <th class="text-center">최종가</th>
                                <!--
                                <th class="text-center">최종등록일</th>
                                -->
                            </tr>
                        </thead>
                        <tbody>
<%
' 합계 변수 초기화
sum_total_frame_price = 0
sum_total_door_price = 0
sum_disprice = 0
sum_total_door_frame_price = 0
i = 0
afprice = 0
asprice = 0
ataxrate = 0
aquan = 0
adisprice = 0
adisrate = 0

' 프레임 할인금액 합계 (tk_framek의 disprice 합계)
sum_frame_disprice = 0
' 도어 할인금액 합계 (cdlevel 기반)
sum_door_disprice = 0

' cdlevel 가져오기 (도어 할인 계산용)
cdlevel = 1 ' 기본값
If rsjidx <> "" Then
    SQL = "SELECT b.cdlevel FROM TNG_SJA a JOIN tk_customer b ON b.cidx = a.sjcidx WHERE a.sjidx = '" & rsjidx & "'"
    Set Rs3 = Server.CreateObject("ADODB.Recordset")
    Rs3.Open SQL, Dbcon
    If Not (Rs3.BOF Or Rs3.EOF) Then
        If Not IsNull(Rs3(0)) Then
            cdlevel = Rs3(0)
        End If
    End If
    Rs3.Close
    Set Rs3 = Nothing
End If

sjsprice=""
SQL="Select distinct A.sjsidx, a.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.qtyidx, g.qtyname, A.sjsprice, A.quan, a.disrate, a.disprice, A.taxrate, A.sprice, A.fprice "
SQL=SQL&" , A.midx, D.mname, A.mwdate, A.meidx, E.mname, A.mewdate, A.astatus ,f.sjb_type_no  , a.framename , i.pname "
SQL=SQL&" , a.door_price , a.frame_price , a.frame_option_price , j.sjcidx "
SQL=SQL&" From tng_sjaSub A "
SQL=SQL&" left outer Join tng_sjb B On a.sjb_idx=B.sjb_idx "
SQL=SQL&" left outer Join tk_qty C On a.qtyidx=C.qtyidx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no "
SQL=SQL&" Left Outer JOin tk_qtyco g On c.qtyno=g.qtyno "
'SQL=SQL&" Left Outer JOin tk_framek h On a.sjsidx=h.sjsidx " 
SQL=SQL&" Left Outer JOin tk_paint i On a.pidx=i.pidx "
SQL=SQL&" Left Outer JOin TNG_SJA j On a.sjidx=j.sjidx "
SQL=SQL&" Where A.sjidx<>'0' and A.sjidx='"&rsjidx&"' "
SQL=SQL&" and A.astatus='1' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    i=i+1               '순번

    sjsidx=Rs(0)        '주문품목키
    sjb_idx=Rs(1)       '기본품목키
    sjb_type_name=Rs(2)  '기본품목명
    mwidth=Rs(3)        '검측가로
    mheight=Rs(4)       '검측세로
    qtyidx=Rs(5)        '재질키
    qtyname=Rs(6)       '재질명
    sjsprice=Rs(7)      '단가
    quan=Rs(8)          '수량
    disrate=Rs(9)       '할인율
    disprice=Rs(10)     '할인금액
    taxrate=Rs(11)      '세율
    sprice=Rs(12)       '최종가
    fprice=Rs(13)       '공급가 (도어포함 이였는데 도어제외로 변경해야함)
    midx=Rs(14)         '최초작성자키
    mname=Rs(15)        '최초작성자명
    mwdate=Rs(16)       '최초작성일
    meidx=Rs(17)        '최종작성자키
    mename=Rs(18)       '최종작성자명
    mewdate=Rs(19)      '최종작성일
    astatus=Rs(20)      '1은 사용 0은 사용안함 수정/삭제 ㅋㅋㅋㅋ
    sjb_type_no=Rs(21)
    framename=Rs(22)    '프레임명
    pname=Rs(23)        '도장명
    door_price=Rs(24)   '도어가 _ 수량 곱했음
    frame_price=Rs(25)  '프레임가 _ 수량 곱했음
    frame_option_price=Rs(26)  '프레임가 + 옵션_ 수량 곱했음
    sjcidx=Rs(27)       '종합품목키
    'fkidx=Rs(24)        'framek

    ' ============================================
    ' 할인 적용된 실제 값 가져오기 (tk_framek, tk_framekSub에서)
    ' ============================================
    ' 1) 프레임 할인: tk_framek에서 SUM(disprice), SUM(fprice) 가져오기
    Dim frame_disprice_sum, frame_fprice_sum
    frame_disprice_sum = 0
    frame_fprice_sum = 0
    
    SQL = "SELECT SUM(disprice) AS sum_disprice, SUM(fprice) AS sum_fprice "
    SQL = SQL & "FROM tk_framek "
    SQL = SQL & "WHERE sjsidx='" & sjsidx & "'"
    Set Rs3 = Server.CreateObject("ADODB.Recordset")
    Rs3.Open SQL, Dbcon
    If Not (Rs3.BOF Or Rs3.EOF) Then
        If Not IsNull(Rs3("sum_disprice")) Then
            frame_disprice_sum = Rs3("sum_disprice")
        End If
        If Not IsNull(Rs3("sum_fprice")) Then
            frame_fprice_sum = Rs3("sum_fprice")
        End If
    End If
    Rs3.Close
    Set Rs3 = Nothing
    
    ' 2) 도어 할인: tk_framekSub에서 cdlevel 기반 할인 계산
    Dim door_disprice_sum, door_supply_price_sum
    door_disprice_sum = 0
    door_supply_price_sum = 0
    
    ' cdlevel_price 계산
    Dim cdlevel_price
    Select Case cdlevel
        Case 1
            cdlevel_price = 0
        Case 2
            cdlevel_price = -10000
        Case 3
            cdlevel_price = 10000
        Case 4
            cdlevel_price = 20000
        Case 5
            cdlevel_price = 30000
        Case 6
            cdlevel_price = -10000
        Case Else
            cdlevel_price = 0
    End Select
    
    ' tk_framekSub에서 도어 가격과 수량 가져와서 할인 계산
    SQL = "SELECT a.door_price, b.quan "
    SQL = SQL & "FROM tk_framekSub a "
    SQL = SQL & "JOIN tk_framek b ON a.fkidx = b.fkidx "
    SQL = SQL & "WHERE b.sjsidx='" & sjsidx & "' AND a.door_w > 0"
    Set Rs3 = Server.CreateObject("ADODB.Recordset")
    Rs3.Open SQL, Dbcon
    If Not (Rs3.BOF Or Rs3.EOF) Then
        Do While Not Rs3.EOF
            Dim kDOOR_PRICE_item, quan_item, door_supply_price_item, total_kDOOR_PRICE_item
            kDOOR_PRICE_item = Rs3("door_price")
            quan_item = Rs3("quan")
            
            If IsNull(kDOOR_PRICE_item) Then kDOOR_PRICE_item = 0
            If IsNull(quan_item) Or quan_item = 0 Then quan_item = 1
            
            ' 도어 할인금액 (cdlevel_price는 이미 door_price에 반영되어 있으므로 별도 차감 안 함)
            Dim door_disprice_item
            door_disprice_item = 0
            door_disprice_sum = door_disprice_sum + door_disprice_item

            ' 도어 공급가 계산 (cdlevel_price는 이미 door_price에 반영됨)
            If IsNumeric(kDOOR_PRICE_item) And CDbl(kDOOR_PRICE_item) > 0 Then
                door_supply_price_item = CDbl(kDOOR_PRICE_item)
                total_kDOOR_PRICE_item = door_supply_price_item * quan_item
                door_supply_price_sum = door_supply_price_sum + total_kDOOR_PRICE_item
            End If
            
            Rs3.MoveNext
        Loop
    End If
    Rs3.Close
    Set Rs3 = Nothing
    
    ' ============================================
    ' 할인 적용된 실제 값으로 계산
    ' ============================================
    ' 프레임 공급가 (할인 적용된 fprice)
    total_frame_price = frame_fprice_sum
    
    ' 도어 공급가 (할인 적용된 공급가)
    total_door_price = door_supply_price_sum
    
    ' 프레임+도어 합계
    total_door_frame_price = total_frame_price + total_door_price
    
    ' 전체 할인금액 (프레임 할인 + 도어 할인)
    Dim total_disprice_item
    total_disprice_item = frame_disprice_sum + door_disprice_sum 

        ' tk_framek에서 TOP 1  fkidx 가져오기
    SQL = "SELECT TOP 1 fkidx, sjb_idx "
    SQL = SQL & "FROM tk_frameK "
    SQL = SQL & "WHERE sjsidx='" & sjsidx & "'"
    Set Rs3 = Server.CreateObject("ADODB.Recordset")
    'response.write (SQL)&"<br>"
    Rs3.Open SQL, Dbcon
    If Not (Rs3.BOF Or Rs3.EOF) Then
        fkidx = Rs3("fkidx")
        sjb_idx = Rs3("sjb_idx")
    End If
    Rs3.Close
    Set Rs3 = Nothing
%> 

                            <tr>
                                <td class="text-center"><button type="button" class="btn btn-outline-danger" Onclick="udt1('<%=sjsidx%>');"><%=i%></button></td>
                                <td class="text-center"><button class="<%=class_text%>" type="submit" <% if rsjidx<>"" then %>onclick="window.open('TNG1_B_suju_quick.asp?sjcidx=<%=sjcidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=sjsidx%>&fkidx=<%=fkidx%>&sjb_idx=<%=sjb_idx%>','_blank' );"<% end if %>><%=framename%></button></td>
                                <td class="text-end">
                                <button 
                                    class="<%=class_text%>" 
                                    type="button" 
                                    onclick="toggleSubTable('<%=sjsidx%>', this)">
                                    <%=formatnumber(mwidth,0)%>mm
                                </button>
                                </td>
                                <td class="text-end"><%=formatnumber(mheight,0)%>mm</td>
                                <td class="text-center"><%=qtyname%></td>
                                <td class="text-center"><%=pname%></td>
                                <td class="text-end"><%=formatnumber(sjsprice,0)%>원</td> <!-- 프레임 원가 -->
                                <td class="text-end"><%=formatnumber(quan,0)%>EA</td>
                                <td class="text-end"><%=formatnumber(disprice,0)%>원</td>
                                <td class="text-end"><%=formatnumber(total_frame_price,0)%>원</td> <!--공급가(프레임) + 옵션-->
                                <td class="text-end"><%=formatnumber(total_door_price,0)%>원</td>
                                <!--
                                <td class="text-end"><%=disrate%>%</td> 
                                -->
                                <td class="text-end"><%=formatnumber(total_door_frame_price,0)%>원</td>
                                <td class="text-end"><%=formatnumber(taxrate,0)%>원</td>
                                <td class="text-end"><%=formatnumber(sprice,0)%>원</td>
                                <%
                                    '원본 표시
                                    sql = ""
                                    sql = sql & "SELECT TOP 1 sjsidx "
                                    sql = sql & "FROM tng_sjaSub "
                                    sql = sql & "WHERE sjidx = '" & rsjidx & "' "
                                    sql = sql & "And midx = '" & midx &"' "
                                    sql = sql & "And sprice =  '" & sprice & "' "
                                    sql = sql & "And framename =  '" & framename & "' "
                                    Rs2.Open sql, Dbcon
                                     If Not (Rs2.EOF) Then
                                        base_sjsidx = Rs2("sjsidx")
                                     End If
                                    Rs2.close
                                  if (base_sjsidx = sjsidx)  Then    
                                %>
                               
                                            <td class="text-end"><button type="button" class="btn btn-primary" 
                                                onclick="frame_copy(
                                                    '<%=sjsidx%>',
                                                    '<%=midx%>',
                                                    '<%=sprice%>',
                                                    '<%=framename%>'
                                                )">
                                                복사
                                            </button></td>
                                            <td class="text-end"><button type="button" class="btn btn-danger"
                                                onclick="frame_delete(
                                                    '<%=sjsidx%>',
                                                    '<%=midx%>',
                                                    '<%=sprice%>',
                                                    '<%=framename%>'
                                                )">
                                                제거
                                            </button></td>
                                    <% End if %>
                                        
                                <!--
                                <td class="text-center"><%=left(mewdate,10)%></td>
                                -->
                            </tr>
                            <tr class="sub-table-row" id="sub-<%=sjsidx%>" style="display: none;">
                                <td colspan="15">
                                    <div id="sub-table-content-<%=sjsidx%>">불러오는 중...</div>
                                </td>
                            </tr>
                            <!-- ASP → JS 변수로 전달 -->
                            <script>
                                const sjcidx = "<%=sjcidx%>";
                                const sjmidx = "<%=sjmidx%>";
                                const sjidx = "<%=rsjidx%>";
                                const sjsidx = "<%=sjsidx%>";
                            </script>
                            <script>
                            function toggleSubTable(sjsidx, btn) {
                            const row = document.getElementById(`sub-${sjsidx}`);
                            const content = document.getElementById(`sub-table-content-${sjsidx}`);

                            if (row.style.display === "none") {
                                // 다른 열린 행 모두 닫기
                                document.querySelectorAll(".sub-table-row").forEach(r => r.style.display = "none");

                                // 현재 행 열기
                                row.style.display = "table-row";

                                // Ajax 로드
                                fetch(`TNG1_B_table.asp?sjcidx=${sjcidx}&sjmidx=${sjmidx}&sjidx=${sjidx}&sjsidx=${sjsidx}`)
                                .then(res => res.text())
                                .then(html => content.innerHTML = html)
                                .catch(err => content.innerHTML = "불러오기 실패");
                            } else {
                                row.style.display = "none";
                            }
                            }
                            </script>


<%

' 할인 적용된 실제 값으로 합계 누적
sum_total_frame_price = total_frame_price + sum_total_frame_price                            
sum_total_door_price = total_door_price + sum_total_door_price
sum_disprice = total_disprice_item + sum_disprice
sum_total_door_frame_price = total_door_frame_price + sum_total_door_frame_price

' 프레임 할인금액과 도어 할인금액을 각각 누적 (TNG1_B_table_pop.asp와 TNG1_B_table_pop_door.asp의 값 합산)
sum_frame_disprice = frame_disprice_sum + sum_frame_disprice
sum_door_disprice = door_disprice_sum + sum_door_disprice

' 최종공급가합: 프레임 공급가 + 도어 공급가 (도어 단가가 아닌 도어 공급가 사용)
afprice = total_door_frame_price + afprice  '공급가의  합 (프레임 공급가 + 도어 공급가)
asprice=sprice+asprice  '최종공급가액의 합 (공급가+세액)
ataxrate=taxrate+ataxrate  '세액 의 합
aquan=quan+aquan    '수량 의 합
adisprice=disprice+adisprice  '할인액 의 합


adisrate=disrate+adisrate  '사용안함

'response.write "door_price"&"="& door_price &"<br>"
'response.write "total_door_price"&"="& total_door_price &"<br>"
'response.write "total_frame_price"&"="& total_frame_price &"<br>"
'response.write "total_door_frame_price"&"="& total_door_frame_price &"<br>"

'response.write "sum_total_frame_price"&"="& sum_total_frame_price &"<br>"
'response.write "sum_total_door_price"&"="& sum_total_door_price &"<br>"
'response.write "sum_disprice"&"="& sum_disprice &"<br>"
'response.write "sum_total_door_frame_price"&"="& sum_total_door_frame_price &"<br>"

Rs.movenext
Loop
End If
Rs.Close 

' ============================================
' 전체 할인금액 재계산: 모든 품목의 프레임 할인 + 도어 할인 합계
' TNG1_B_table_pop.asp의 disprice 합계 + TNG1_B_table_pop_door.asp의 kDOOR_DISPRICE 합계
' ============================================
Dim total_frame_disprice_all, total_door_disprice_all
total_frame_disprice_all = 0
total_door_disprice_all = 0

' 1) 모든 프레임 할인금액 합계 (tk_framek의 disprice 합계)
SQL = "SELECT SUM(disprice) AS total_frame_disprice "
SQL = SQL & "FROM tk_framek "
SQL = SQL & "WHERE EXISTS (SELECT 1 FROM tng_sjaSub WHERE tng_sjaSub.sjsidx = tk_framek.sjsidx AND tng_sjaSub.sjidx = '" & rsjidx & "' AND tng_sjaSub.astatus = '1')"
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Rs3.Open SQL, Dbcon
If Not (Rs3.BOF Or Rs3.EOF) Then
    If Not IsNull(Rs3("total_frame_disprice")) Then
        total_frame_disprice_all = CDbl(Rs3("total_frame_disprice"))
    End If
End If
Rs3.Close
Set Rs3 = Nothing

' 2) 모든 도어 할인금액 합계 (TNG1_B_table_pop_door.asp와 동일한 계산)
SQL = "SELECT a.door_price, b.quan "
SQL = SQL & "FROM tk_framekSub a "
SQL = SQL & "JOIN tk_framek b ON a.fkidx = b.fkidx "
SQL = SQL & "WHERE EXISTS (SELECT 1 FROM tng_sjaSub WHERE tng_sjaSub.sjsidx = b.sjsidx AND tng_sjaSub.sjidx = '" & rsjidx & "' AND tng_sjaSub.astatus = '1') "
SQL = SQL & "AND a.door_w > 0"
Set Rs3 = Server.CreateObject("ADODB.Recordset")
Rs3.Open SQL, Dbcon
If Not (Rs3.BOF Or Rs3.EOF) Then
    Do While Not Rs3.EOF
        Dim kDOOR_PRICE_all, quan_door_all
        kDOOR_PRICE_all = Rs3("door_price")
        quan_door_all = Rs3("quan")
        
        If IsNull(kDOOR_PRICE_all) Then kDOOR_PRICE_all = 0
        If IsNull(quan_door_all) Or quan_door_all = 0 Then quan_door_all = 1
        
        ' cdlevel_price는 이미 door_price에 반영되어 있으므로 별도 할인 계산 안 함
        If IsNumeric(kDOOR_PRICE_all) And CDbl(kDOOR_PRICE_all) > 0 Then
            total_door_disprice_all = total_door_disprice_all + 0
        End If
        
        Rs3.MoveNext
    Loop
End If
Rs3.Close
Set Rs3 = Nothing 


'====하부레일,로비폰박스,재분 추가 ====
' TNG1_B_table.asp와 동일하게 모든 품목의 옵션 공급가 합산
' 각 품목별로 (jaeryobunridae + robby_box + boyangjea + whaburail) * quan 계산 후 합산
option_total_price = 0

SQL = "SELECT sjsidx, quan FROM tng_sjaSub WHERE sjidx='" & rsjidx & "' AND astatus='1'"
Rs1.Open SQL, Dbcon
Do While Not Rs1.EOF
    Dim sjsidx_option, quan_option
    sjsidx_option = Rs1("sjsidx")
    quan_option = CLng(Rs1("quan"))
    If IsNull(quan_option) Or quan_option = 0 Then quan_option = 1

SQL = ""
SQL = SQL & "SELECT "
    SQL = SQL & "    ISNULL(SUM(jaeryobunridae), 0) AS sum_jae, "
    SQL = SQL & "    ISNULL(SUM(robby_box), 0) AS sum_robby, "
    SQL = SQL & "    ISNULL(SUM(boyangjea), 0) AS sum_boyang, "
    SQL = SQL & "    ISNULL(SUM(whaburail), 0) AS sum_habu "
SQL = SQL & "FROM tk_framek "
    SQL = SQL & "WHERE sjsidx='" & sjsidx_option & "'"
Rs2.Open SQL, Dbcon

    Dim opt_jae, opt_robby, opt_boyang, opt_habu
    opt_jae = 0
    opt_robby = 0
    opt_boyang = 0
    opt_habu = 0

If Not (Rs2.BOF Or Rs2.EOF) Then
        If Not IsNull(Rs2("sum_jae")) Then opt_jae = CDbl(Rs2("sum_jae"))
        If Not IsNull(Rs2("sum_robby")) Then opt_robby = CDbl(Rs2("sum_robby"))
        If Not IsNull(Rs2("sum_boyang")) Then opt_boyang = CDbl(Rs2("sum_boyang"))
        If Not IsNull(Rs2("sum_habu")) Then opt_habu = CDbl(Rs2("sum_habu"))
End If
Rs2.Close

    ' TNG1_B_table.asp와 동일: (옵션 단가 합계) * 수량
    option_total_price = option_total_price + (opt_jae + opt_robby + opt_boyang + opt_habu) * quan_option
    
    Rs1.MoveNext
Loop
Rs1.Close

total_afprice = afprice + option_total_price
total_asprice = asprice + option_total_price


  SQL="select sum( etc_price * etc_qty ) "
  SQL=SQL&" From tk_etc where sjidx='"&rsjidx&"' "
  'response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 

  etc_total_price=Rs(0)
  If IsNull(etc_total_price) Then etc_total_price = 0

  End if
  RS.Close

asprice_etc=total_asprice  + etc_total_price '최종_공급가합 + 기타자재금액  (공급가+세액)
afprice_etc=total_afprice + etc_total_price '최종공급가액의 합 
ataxrate_etc=afprice_etc * 0.1 '세액 10% 계산
adisprice_etc=disprice+adisprice  '할인액 의 합
adisrate_etc=disrate+adisrate  '사용안함

'atzprice = asprice_etc + (etc_total_price* 0.1)
atzprice = afprice_etc * 1.1

if money_status=1 then

else

  SQL="Update tng_sja set tsprice='"&afprice_etc&"', tfprice='"&afprice_etc&"', taxprice='"&ataxrate_etc&"', tzprice='"&atzprice&"' , money_status=0 Where sjidx='"&rsjidx&"' "
  'response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

end if

if money_reset = 0 then

  SQL="Update tng_sja set trate=0, tdisprice=0, tsprice='"&afprice_etc&"', tfprice='"&afprice_etc&"', taxprice='"&ataxrate_etc&"', tzprice='"&atzprice&"' , money_status=0 Where sjidx='"&rsjidx&"' "
  'response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)
  'response.write "money_reset"&"="& money_reset &"<br>"

end if

'response.write "money_status"&"="& money_status &"<br>"
'response.write "afprice"&"="& afprice &"<br>"
'response.write "asprice"&"="& asprice &"<br>"
'response.write "ataxrate"&"="& ataxrate &"<br>"
'response.write "aquan"&"="& aquan &"<br>"
'response.write "adisprice"&"="& adisprice &"<br>"
%>
            <tr>
              <td class="text-center">합계</td>
              <td class="text-center"></td>
              <td class="text-center"></td>
              <td class="text-end"></td>
              <td class="text-end"></td>
              <td class="text-center"></td>
              <td class="text-end"></td>
              <td class="text-end"><%=formatnumber(aquan,0)%>EA</td>
              <td class="text-end">  <!--할인금액: TNG1_B_table_pop.asp의 disprice 합계 + TNG1_B_table_pop_door.asp의 kDOOR_DISPRICE 합계-->
                  <%
                  ' TNG1_B_table_pop.asp: tk_framek의 disprice 합계
                  ' TNG1_B_table_pop_door.asp: cdlevel_price (1개당) * quan의 합계
                  Dim final_sum_disprice
                  final_sum_disprice = total_frame_disprice_all + total_door_disprice_all
                  %>
                  <input type="text" id="tax" name="tax" value="<%= FormatNumber(final_sum_disprice, 0) %>" 
                  style="text-align: right;background: #ccc;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" >원
              </td>
              <td class="text-end"> <!--프레임 공급가-->
                <input type="text" name="basePrice" value="<%= FormatNumber(sum_total_frame_price, 0) %>" 
                style="text-align: right;background: #ccc;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" >원
              <td class="text-end"> <!--도어 공급가-->
                <input type="text" id="discountedPrice" name="discountedPrice" value="<%= FormatNumber(sum_total_door_price, 0) %>" 
                style="text-align: right;background: #ccc;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" >원
              </td>
              <td class="text-end"> <!--도어+프레임-->
                <input type="text" id="finalPrice" name="finalPrice" value="<%= FormatNumber(sum_total_door_frame_price, 0) %>" 
                style="text-align: right;background: #ccc;border:1px solid #ccc; border-radius:6px; padding:6px; width:100px;" >원
              

                            </tbody>
                    </table>    
                </div>
            </div>
            <!-- 기타 자재 등록  -->
            <form method="post" name="etc_input" action="tng1_b.asp">
                <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
                <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
                <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                <input type="hidden" name="gubun" value="">
                <input type="hidden" name="etc_idx" value="">
                    <div class="card card-body mb-1">
                        <div class="row">     
                            <div class="col-md-8">
                                <table id="datatablesSimple"  class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th class="text-center">No</th>
                                            <th class="text-center">제품명</th>
                                            <th class="text-center">원가</th>
                                            <th class="text-center">수량</th>
                                            <th class="text-center">단가</th>
                                            <th class="text-center">부가세</th>
                                            <th class="text-center">총액</th>
                                            <th class="text-center"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        SQL="Select distinct A.etc_idx, A.etc_name, a.etc_qty, a.midx, A.mdate, A.etc_price, A.sjidx "
                                        SQL=SQL&" From tk_etc A "
                                        SQL=SQL&" left outer Join tng_sjaSub B On a.sjidx=B.sjidx "
                                        SQL=SQL&" Where A.sjidx='"&rsjidx&"' "
                                        'Response.write (SQL)&"<br>"
                                        Rs.open Sql,Dbcon
                                        if not (Rs.EOF or Rs.BOF ) then
                                        Do while not Rs.EOF
                                        d=d+1               '순번
                                        etc_idx=rs(0) ' 키
                                        etc_name=rs(1) ' 제품명
                                        etc_qty=rs(2) ' 수량
                                        midx=rs(3)
                                        mdate=rs(4)
                                        etc_price=rs(5) ' 원가
                                        sjidx=rs(6) ' 주문번호

                                        '단가
                                        etc_base_price=etc_price*etc_qty
                                        '부가세
                                        etc_tax_price=etc_price*etc_qty*0.1
                                        '총액
                                        etc_total_price=etc_price*etc_qty*1.1
                                    
                                        'Response.write "etc_idx"&"="& etc_idx &"<br>"
                                    
                                        %>
                                        <% if int(etc_idx)=int(retc_idx) then %>
                                        <tr>
                                            <td class="text-center"><button type="button" class="btn btn-outline-danger" Onclick="etc1('<%=etc_idx%>');"><%=d%></button></td>
                                            <td class="text-center">
                                                <input type="text" class="form-control" name="etc_name" value="<%=etc_name%>">
                                            </td>
                                            <!-- 원가 -->
                                            <td class="text-end">
                                                <input type="text" class="form-control text-end" name="etc_price" value="<%=formatnumber(etc_price,0)%>">
                                            </td>
                                            <!-- 수량 -->
                                            <td class="text-end">
                                                <input type="number" class="form-control text-end" name="etc_qty" value="<%=etc_qty%>">EA
                                            </td>
                                            <td class="text-end"><%=formatnumber(etc_base_price,0)%>원</td> <!-- 단가 -->
                                            <td class="text-end"><%=formatnumber(etc_tax_price,0)%>원</td> <!-- 부가세 -->
                                            <td class="text-end"><%=formatnumber(etc_total_price,0)%>원</td> <!-- 총액 -->
                                            <td>
                                                <button type="button" class="btn btn-primary" onclick="etc3('<%=etc_idx%>');">저장</button>
                                            </td>
                                          
                                        </tr>
                                        <% else %>
                                        <tr>
                                            <td class="text-center"><button type="button" class="btn btn-outline-danger" Onclick="etc1('<%=etc_idx%>');"><%=d%></button></td>
                                            <td class="text-center" 
                                                onclick="location.replace('TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&etc_idx=<%=etc_idx%>');" 
                                                style="cursor:pointer;">
                                                <%=etc_name%>
                                            </td>
                                            <!-- 원가 -->
                                            <td class="text-end"
                                                onclick="location.replace('TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&etc_idx=<%=etc_idx%>');" 
                                                style="cursor:pointer;">
                                                <%=formatnumber(etc_price,0)%>
                                            </td>
                                            <!-- 수량 -->
                                            <td class="text-end"
                                                onclick="location.replace('TNG1_B.asp?sjcidx=<%=sjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&etc_idx=<%=etc_idx%>');" 
                                                style="cursor:pointer;">
                                                <%=etc_qty%>EA
                                            </td>
                                            <td class="text-end"><%=formatnumber(etc_base_price,0)%>원</td> <!-- 단가 -->
                                            <td class="text-end"><%=formatnumber(etc_tax_price,0)%>원</td> <!-- 부가세 -->
                                            <td class="text-end"><%=formatnumber(etc_total_price,0)%>원</td> <!-- 총액 -->
                                        </tr>
                                        <% end if %>
                                        <%
                                        Rs.movenext
                                        Loop
                                        End If
                                        Rs.Close 
                                        %>
                                        
                                    </tbody>
                                </table>    
                            </div>
                            <div class="col-md-4">
                                <td class="text-center">
                                    <button type="button" class="btn btn-outline-success" onclick="etc2();">추가자재등록</button>
                                </td>
                                
                                <button type="button"
                                    style="padding:8px 12px; font-size:14px; border:1px solid #c0c0c0; background:#c0c0c0; color:#070707; border-radius:6px; cursor:pointer; position:relative;"
                                    onclick="
                                        // 팝업 오픈
                                        window.open(
                                        'tng1_b_meno_pop.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>',
                                        'menoPop',
                                        'top=80,left=80,width=560,height=480,resizable=yes,scrollbars=yes'
                                        );
                                    ">
                                    메모
                                </button>          
                                <button type="button"
                                        onclick="location.href='tng1_b.asp?sjcidx=<%=rsjcidx%>&sjmidx=<%=rsjmidx%>&sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&money_reset=0'"
                                        style="padding:8px 12px; font-size:14px; border:1px solid #c0c0c0; background:#c0c0c0; color:#070707; border-radius:6px; cursor:pointer;"
                                        data-bs-toggle="modal" data-bs-target="#quotationModal">
                                reset
                                </button>         
                                <button type="button"
                                        Onclick="submit();"
                                        style="padding:8px 12px; font-size:14px; border:1px solid #c0c0c0; background:#c0c0c0; color:#070707; border-radius:6px; cursor:pointer;"
                                        data-bs-toggle="modal" data-bs-target="#quotationModal">
                                저장
                                </button>
                                
                                    <!-- 견적서 출력 버튼 -->


                                <%
                                Dim is_suju_for_quotation_btn
                                is_suju_for_quotation_btn = False
                                If rsuju_kyun_status = "0" Then
                                    is_suju_for_quotation_btn = True
                                ElseIf rsuju_kyun_status <> "" And Not IsNull(rsuju_kyun_status) And IsNumeric(rsuju_kyun_status) Then
                                    If CInt(rsuju_kyun_status) = 0 Then
                                        is_suju_for_quotation_btn = True
                                    End If
                                End If
                                If is_suju_for_quotation_btn Then ' 수주일 때만
                                %>
                                                                <button type="button"
                                        style="padding:8px 12px; font-size:14px; border:1px solid #0d6efd; background:#0d6efd; color:#fff; border-radius:6px; cursor:pointer;"
                                        data-bs-toggle="modal" data-bs-target="#quotationModal">
                                수주서 출력
                                </button>
                                    <!-- 발주서 출력 버튼 -->
                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#poModal">
                                발주서 출력
                                </button>

                                <!-- 버튼: 클릭하면 모달 오픈 -->
                                <a class="btn btn-danger"
                                href="#"
                                data-bs-toggle="modal"
                                data-bs-target="#stickerSizeModal">
                                스티커 출력
                                </a>
                                <%
                                Else
                                  %>
                                  <button type="button"
                                        style="padding:8px 12px; font-size:14px; border:1px solid #0d6efd; background:#0d6efd; color:#fff; border-radius:6px; cursor:pointer;"
                                        data-bs-toggle="modal" data-bs-target="#quotationModal">
                                견적서 출력
                                </button>
                                  <%
                                End If
                                %>
                            </div>
                        </div>
                    </div>
            </form>
<form method="post" name="supriceinput" action="tng1_b.asp">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="gubun" value="supriceinput">
<input type="hidden" name="redirect_type" id="redirect_type" value="">
         <div class="row-card mb-1" style="display:flex; align-items:flex-start; gap:12px; width:100%;">
              <!-- 왼쪽: 필드 한 줄 정렬 -->
              <div class="col-12" style="flex:1 1 auto; display:flex; align-items:center; gap:12px; flex-wrap:nowrap; white-space:nowrap; overflow-x:auto;">
                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">최종_공급가합</span>
                  <input type="text"  name="tsprice" id="tsprice"
                        value="<%=FormatNumber(afprice_etc,0)%>" readonly
                        style="width:140px; text-align:right; padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#f8f9fa;">원
                </div>

                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">추가_할인율</span>
                  <input type="text" name="trate" id="trate"
                        value="<%=FormatNumber(trate,0)%>" 
                        oninput="calculateFromRate()"
                        style="width:100px; text-align:right; padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#f8f9fa;">%
                </div>

                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">추가_할인금액</span>
                  <input type="text" name="tdisprice" id="tdisprice"  
                        value="<%=FormatNumber(tdisprice,0)%>" 
                        oninput="calculateFromPrice()"
                        style="width:140px; text-align:right; padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#f8f9fa;">원
                </div>

                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">최종_공급가액</span>
                  <input type="text" name="tfprice" id="tfprice"  
                        value="<%=FormatNumber(tfprice,0)%>" readonly
                        style="width:140px; text-align:right; padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#f8f9fa;">원
                </div>

                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">최종_세액</span>
                  <input type="text" name="taxprice" id="taxprice"  
                        value="<%=FormatNumber(taxprice,0)%>" readonly
                        style="width:140px; text-align:right; padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#f8f9fa;">원
                </div>

                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">최종_금액</span>
                  <input type="text" name="tzprice" id="tzprice"  
                        value="<%=FormatNumber(tzprice,0)%>" readonly
                        style="width:160px; text-align:right; padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#f8f9fa;">원
                </div>
                <div class="field" style="display:inline-flex; align-items:center; gap:6px;">
                  <span style="min-width:100px; text-align:right; display:inline-block;">작성자:<%=mename%>님</span>
                </div>
                <div class="field" style="display:inline-flex; align-items:center; gap:6px; position:relative;">
                
                </div>
              </div>

              <!-- 오른쪽: 버튼 1줄 가로 배치 -->
              <div>
<script>
// 최종_공급가합을 기준으로 할인율/할인금액 자동 계산
function calculateFromRate() {
    var tsprice = parseFloat(document.getElementById('tsprice').value.replace(/,/g, '')) || 0;
    var trate = parseFloat(document.getElementById('trate').value.replace(/,/g, '')) || 0;
    
    if (tsprice > 0 && trate >= 0) {
        // 할인율로부터 할인금액 계산
        var tdisprice = Math.round(tsprice * (trate / 100));
        document.getElementById('tdisprice').value = tdisprice.toLocaleString();
        
        // 최종_공급가액 계산
        calculateFinalPrice();
    }
}

function calculateFromPrice() {
    var tsprice = parseFloat(document.getElementById('tsprice').value.replace(/,/g, '')) || 0;
    var tdisprice = parseFloat(document.getElementById('tdisprice').value.replace(/,/g, '')) || 0;
    
    if (tsprice > 0) {
        // 할인금액으로부터 할인율 계산
        var trate = 0;
        if (tsprice > 0) {
            trate = Math.round((tdisprice / tsprice) * 100 * 10) / 10; // 소수점 1자리
        }
        document.getElementById('trate').value = trate.toLocaleString();
        
        // 최종_공급가액 계산
        calculateFinalPrice();
    }
}

function calculateFinalPrice() {
    var tsprice = parseFloat(document.getElementById('tsprice').value.replace(/,/g, '')) || 0;
    var tdisprice = parseFloat(document.getElementById('tdisprice').value.replace(/,/g, '')) || 0;
    
    // 최종_공급가액 = 최종_공급가합 - 추가_할인금액
    var tfprice = Math.round(tsprice - tdisprice);
    document.getElementById('tfprice').value = tfprice.toLocaleString();
    
    // 최종_세액 = 최종_공급가액 * 0.1
    var taxprice = Math.round(tfprice * 0.1);
    document.getElementById('taxprice').value = taxprice.toLocaleString();
    
    // 최종_금액 = 최종_공급가액 + 최종_세액
    var tzprice = Math.round(tfprice + taxprice);
    document.getElementById('tzprice').value = tzprice.toLocaleString();
}

// 간이 견적서 출력: 추가 할인 반영 후 저장 + 간이 견적서 오픈
function openSimpleOrder() {
    try {
        // 화면 값 기준으로 한 번 더 계산
        calculateFinalPrice();

        var f = document.forms['supriceinput'];
        if (!f) {
            window.open('/documents/simpleOrder?sjidx=<%=rsjidx%>','_blank');
            return;
        }

        // 리다이렉트 플래그 설정
        var rt = document.getElementById('redirect_type');
        if (rt) {
            rt.value = 'simpleOrder';
        }

        // 수주금액 입력(gubun=supriceinput)으로 저장 후, 서버에서 간이 견적서 오픈
        f.submit();
    } catch (e) {
        console.error(e);
        window.open('/documents/simpleOrder?sjidx=<%=rsjidx%>','_blank');
    }
}

// 페이지 로드 시 초기 계산
document.addEventListener('DOMContentLoaded', function() {
    calculateFinalPrice();
});
</script>
                

<!-- 모달 -->
<div class="modal fade" id="poModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">발주서 품목 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <table class="table table-hover align-middle">
          <colgroup>
            <col style="width:80px"><col><col style="width:120px"><col style="width:140px">
          </colgroup>
          <thead class="table-light">
            <tr>
              <th class="text-center">순번</th>
              <th>품목</th>
              <th class="text-center">출력여부(0/1)</th>
              <th class="text-center">액션(출력)</th>
            </tr>
          </thead>
          <tbody id="itemTableBody">


          </tbody>
        </table>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<script>
(function () {
  const poModal       = document.getElementById('poModal');
  const itemTableBody = document.getElementById('itemTableBody');
  const listUrl       = '/TNG1/modal/print/index.asp?sjidx=<%=rsjidx%>';

  function loadPoTbody() {
    itemTableBody.innerHTML =
      '<tr><td colspan="4" class="text-center">불러오는 중...</td></tr>';
    fetch(listUrl + '&_=' + Date.now(), { cache: 'no-store' })
      .then(res => res.text())
      .then(html => itemTableBody.innerHTML = html)
      .catch(() => {
        itemTableBody.innerHTML =
          '<tr><td colspan="4" class="text-center text-danger">불러오기 실패</td></tr>';
      });
  }

  // 모달 열릴 때 목록 로드
  poModal.addEventListener('show.bs.modal', loadPoTbody);

  // 출력 버튼: 출력창 띄우고, UI상 printed=1로만 표시 (저장 X)
  document.addEventListener('click', (e) => {
    const btn = e.target.closest('.btnPrint');
    if (!btn) return;

    const tr = btn.closest('tr');
    const id = tr && tr.dataset.id;
    if (!id) return;

const cidx   = tr.querySelector('.hidCidx')?.value;
const sjidx  = tr.querySelector('.hidSjidx')?.value;
const sjsidx = tr.querySelector('.hidSjsidx')?.value;

if (!cidx || !sjidx || !sjsidx) {
  alert('파라미터 누락(cidx/sjidx/sjsidx)');
  return;
}

// ✅ 올바른 방식: 쿼리스트링은 전부 URL 하나에
const url = '/documents/insideOrder'
  + '?cidx='  + encodeURIComponent(cidx)
  + '&sjidx=' + encodeURIComponent(sjidx)
  + '&sjsidx='+ encodeURIComponent(sjsidx);

window.open(url, '_blank');         // 새 탭
// location.href = url;             // 같은 탭 이동을 원하면 이걸 사용

    // UI만 1로
    const cell = tr.querySelector('.cellPrinted');
    if (cell) cell.textContent = '1';

    // 원하면 버튼 상태 변경(선택)
    // btn.disabled = true;
    // btn.classList.remove('btn-outline-primary');
    // btn.classList.add('btn-secondary');
    // btn.textContent = '출력됨';
  });
})();
</script>
              </div>
            </div>
</form>

<!-- 용차 정보 불러오기 시작 -->
<%
SQL=" Select yidx, yname, ytel, yaddr, ydate, ymemo "
SQL=SQL&", ycarnum, ygisaname, ygisatel, ycostyn, yprepay, ystatus "
SQL=SQL&" , ymidx, ywdate, ymeidx, ywedate , yaddr1 "
SQL=SQL&" From tk_yongcha " 
SQL=SQL&" Where sjidx='"&rsjidx&"' and ystatus=1 "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      yidx=Rs(0)
      yname=Rs(1)
      ytel=Rs(2)
      yaddr=Rs(3)
      ydate=Rs(4)
      
      ymemo=Rs(5)
      ycarnum=Rs(6)
      ygisaname=Rs(7)
      ygisatel=Rs(8)
      ycostyn=Rs(9)
      yprepay=Rs(10)
      ystatus=Rs(11)
      ymidx=Rs(12)
      ywdate=Rs(13)
      ymeidx=Rs(14)
      ywedate=Rs(15)
      yaddr1=Rs(16)
    End if
    RS.Close

%>
<!-- 용차 정보 불러오기 끝 -->

            <div class="card card-body mb-1">  <!-- * 용차 선택 -->   
<form name="fyong" action="TNG1_B_dbyong.asp" method="post" enctype="multipart/form-data">
<input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
<input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<% if yidx<>"" then %>
<input type="hidden" name="yidx" value="<%=yidx%>">
<% end if%>
                <div class="row ">
                    <%
                    if yname="" then
                    yname=cceo
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">용차받는분</label><p>
                    <input type="text" class="form-control" id="yname" name="yname" placeholder="" value="<%=yname%>">
                    </div>
                    <%
                    if ytel="" then
                    ytel=ctel
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">용차받는전화</label><p>
                    <input type="tel" class="form-control" id="ytel" name="ytel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ytel%>">
                    </div>
                    <!-- !다음(Daum) 우편번호 서비스 -->
                    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
                    <script>
                      function openDaumPostcode() {
                        new daum.Postcode({
                          oncomplete: function(data) {
                            // 도로명 주소 기준
                            var fullAddr = data.roadAddress; 
                            if (fullAddr === '') {
                              fullAddr = data.jibunAddress; // 지번 주소 fallback
                            }

                            document.getElementById('yaddr').value = fullAddr;
                          }
                        }).open();
                      }
                    </script>
                    <div class="col-md-1">
                    <%
                    if yaddr="" then
                    yaddr=ccaddr1
                    end if
                    %>
                    <label for="name">하차지주소 1</label><p>
                    <input type="text" class="form-control" id="yaddr" name="yaddr" placeholder="주소를 입력하세요" onclick="openDaumPostcode();" value="<%=yaddr%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">하차지주소 2</label><p>
                    <input type="text" class="form-control" id="yaddr1" name="yaddr1" placeholder="상세주소를 입력하세요"  value="<%=yaddr1%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차도착일</label><p>
                    <input type="date" class="form-control" id="ydate" name="ydate" placeholder="" value="<%=Left(ydate,10)%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차도착시간</label><p>
                    <input type="time" class="form-control" id="ydateh" name="ydateh" placeholder="" value="<%=hour(ydate)%>:<%=minute(ydate)%>">
                    </div>
                  </div>
                  <div class="row ">
                    <div class="col-md-1">
                    <label for="name">용차당부사항</label><p>
                    <input type="text" class="form-control" id="ymemo" name="ymemo" placeholder="" value="<%=ymemo%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">용차차량번호</label><p>
                    <input type="tel" class="form-control" id="ycarnum" name="ycarnum"  placeholder="예: 127우9556" value="<%=ycarnum%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">운전자명</label><p>
                    <input type="text" class="form-control" id="ygisaname" name="ygisaname" placeholder="" value="<%=ygisaname%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">배차차량전번</label><p>
                    <input type="text" class="form-control" id="ygisatel" name="ygisatel" onkeyup="inputPhoneNumber(this);" maxlength="13" placeholder="" value="<%=ygisatel%>">
                    </div> 
                    <div class="col-md-1">
                    <label for="name">용차착불여부</label><p>
                        <select name="ycostyn" class="form-control" id="ycostyn" required>
                          <option value="0" <% If ycostyn = "0" Then Response.Write "selected" %>>해당없음</option>
                          <option value="1" <% If ycostyn = "1" Then Response.Write "selected" %>>착불</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                    <label for="name">선불금액</label><p>
                    <input type="text" class="form-control" id="yprepay" name="yprepay" placeholder="" value="<%=FormatNumber(yprepay,0)%>원" >
                    </div> 
                    <div class="col-md-1">
                    <% if rsjidx<>"" then %>
                        <label for="name">저장/삭제</label><p>
                        <% if yidx="" then %>
                        <button class="btn btn-success btn-small" type="button" Onclick="yong();">저장</button>
                        <% else %>
                        <button class="btn btn-success btn-small" type="button" Onclick="yong();">수정</button>
                        <button class="btn btn-danger btn-small" type="button" Onclick="delyong();">삭제</button>
                        
                        <% end if %>
                    <% end if %>
                    </div>
                </div>
</form>
            </div>
<!-- 대신화물 정보 정보 불러오기 시작 -->
<%
SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "  dsidx, "
SQL = SQL & "  ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
SQL = SQL & "  ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_addr1, "
SQL = SQL & "  ds_to_costyn, ds_to_prepay, "
SQL = SQL & "  dsmidx, dswdate, dsmeidx, dswedate, dsstatus, sjidx "
SQL = SQL & "FROM tk_daesin "
SQL = SQL & "WHERE sjidx = '" & rsjidx & "' AND dsstatus = 1"

'Response.Write(SQL & " ← tk_daesin <br>")

Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    dsidx         = (Rs("dsidx"))
    ds_daesinname = (Rs("ds_daesinname"))
    ds_daesintel  = (Rs("ds_daesintel"))
    ds_daesinaddr = (Rs("ds_daesinaddr"))
    dsdate        = (Rs("dsdate"))
    dsmemo        = (Rs("dsmemo"))

    ds_to_num     = (Rs("ds_to_num"))
    ds_to_name    = (Rs("ds_to_name"))
    ds_to_tel     = (Rs("ds_to_tel"))
    ds_to_addr    = (Rs("ds_to_addr"))
    ds_to_addr1   = (Rs("ds_to_addr1"))

    ds_to_costyn  = (Rs("ds_to_costyn"))
    ds_to_prepay  = (Rs("ds_to_prepay"))

    dsmidx        = (Rs("dsmidx"))
    dswdate       = (Rs("dswdate"))
    dsmeidx       = (Rs("dsmeidx"))
    dswedate      = (Rs("dswedate"))
    dsstatus      = (Rs("dsstatus"))
    dssjidx       = (Rs("sjidx"))
End If
Rs.Close

'Response.Write "▶ ds_to_addr1 : " & ds_to_addr1 & "<br>" 


%>
<!-- 대신화물 정보 불러오기 끝 -->            
            <div class="card card-body mb-1">  <!-- * 화물 선택 -->    
              <form name="fdaesin" action="TNG1_B_dbDaesin.asp" method="post" enctype="multipart/form-data">
              <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
              <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
              <input type="hidden" name="sjidx" value="<%=rsjidx%>">
              <% if dsidx<>"" then %>
              <input type="hidden" name="dsidx" value="<%=dsidx%>">
              <% end if%>            
                <div class="row ">
                    <div class="col-md-1"> 
                        <label for="name">대신화물지점 조회</label><p>
                        <button class="btn btn-primary btn-small" type="button"
                        onclick="window.open('https://www.ds3211.co.kr/freight/agencySearch.ht', '_blank', 'width=1500,height=1000,top=200,left=500');">조회</button>
                    </div>
                    <div class="col-md-1">
                    <label for="name">대신화물지점 전화번호</label><p>
                    <input type="text" class="form-control" id="ds_daesintel" name="ds_daesintel" placeholder="" value="<%=ds_daesintel%>">
                    </div> 
                    <div class="col-md-1">
                    <%
                    if ds_daesinaddr="" then
                    ds_daesinaddr=CBRAN
                    end if
                    %>
                    <label for="name">대신화물지점 주소</label><p>
                    <input type="text" class="form-control" id="ds_daesinaddr" name="ds_daesinaddr" placeholder="" value="<%=ds_daesinaddr%>">
                    </div> 
                    <%
                    if ds_to_name="" then
                    ds_to_name=cceo
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">받는이 이름</label><p>
                    <input type="text" class="form-control" id="ds_to_name" name="ds_to_name" placeholder="" value="<%=ds_to_name%>">
                    </div> 
                    <%
                    if ds_to_addr="" then
                    ds_to_addr=caddr1
                    end if
                    %>
                    <div class="col-md-3">
                    <label for="name">받는이 주소 1</label><p>
                    <input type="text" class="form-control" id="ds_to_addr" name="ds_to_addr" placeholder="택배 받는이 주소를 입력하세요" onclick="openDaumPostcode();" value="<%=ds_to_addr%>">
                    </div> 
                    <div class="col-md-2">
                    <label for="name">상세 주소 2</label><p>
                    <input type="text" class="form-control" id="ds_to_addr1" name="ds_to_addr1" placeholder="택배 받는이 상세주소를 입력하세요" value="<%=ds_to_addr1%>">
                    </div> 
                    <%
                    if ds_to_tel="" then
                    ds_to_tel=ctel
                    end if
                    %>
                    <div class="col-md-1">
                    <label for="name">받는이 전화번호</label><p>
                    <input type="tel" class="form-control" id="ds_to_tel" name="ds_to_tel"  placeholder="" value="<%=ds_to_tel%>">
                    </div>
                  </div>
                  <div class="row ">
                    <div class="col-md-1">
                    <label for="name">택배도착일</label><p>
                    <input type="date" class="form-control" id="dsdate" name="dsdate" placeholder="" value="<%=dsdate%>">
                    </div>
                    <div class="col-md-1">
                    <label for="name">택배착불여부</label><p>
                        <select name="ds_to_costyn" class="form-control" id="ds_to_costyn" required>
                          <option value="0" <% If ds_to_costyn = "0" Then Response.Write "selected" %>>해당없음</option>
                          <option value="1" <% If ds_to_costyn = "1" Then Response.Write "selected" %>>착불</option>
                        </select>
                        </select>
                    </div>
                    <div class="col-md-1">
                    <label for="name">선불금액</label><p>
                    <input type="text" class="form-control" id="ds_to_prepay" name="ds_to_prepay" placeholder="" value="<%=FormatNumber(ds_to_prepay,0)%>원" >
                    </div> 
                    <div class="col-md-1">
                    <label for="name">추가사항</label><p>
                    <input type="text" class="form-control" id="dsmemo" name="dsmemo" placeholder="" value="<%=dsmemo%>">
                    </div> 
                    <div class="col-md-1">
                    <% if rsjidx<>"" then %>
                        <label for="name">저장/삭제</label><p>
                        <% if dsidx="" then %>
                        <button class="btn btn-success btn-small" type="button" Onclick="daesin();">저장</button>
                        <% else %>
                        <button class="btn btn-success btn-small" type="button" Onclick="daesin();">수정</button>
                        <button class="btn btn-danger btn-small" type="button" Onclick="deldaesin();">삭제</button>
                        
                        <% end if %>
                    <% end if %>
                    </div>
                </div>
            </div>
            </form>
        </div>
        
    </div>

     
</main>   
</div>                       

</div>

<!-- 모달 -->
<div class="modal fade" id="quotationModal" tabindex="-1" aria-labelledby="quotationModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="quotationModalLabel">견적서 유형 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body d-grid gap-2">
        <button type="button" class="btn btn-outline-secondary"
        onclick="window.open('/documents/simpleOrder?sjidx=<%=rsjidx%>');"
        data-bs-dismiss="modal">
        간이 견적서
        </button>

        <button type="button" class="btn btn-outline-secondary"
        onclick="window.open('/documents/simpleOrder?sjidx=<%=rsjidx%>');"
        data-bs-dismiss="modal">
        직인 견적서
        </button>

        <button type="button" class="btn btn-outline-secondary"
        onclick="window.open('/documents/outsideOrder/preview?sjidx=<%=rsjidx%>');"
        data-bs-dismiss="modal">
        상세 견적서
        </button>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div>

<!-- 사이즈 선택 모달 -->
<div class="modal fade" id="stickerSizeModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">스티커 사이즈 선택</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted mb-3">출력할 스티커 규격을 선택하세요.</p>
        <div class="d-grid gap-2">
          <a class="btn btn-primary"
             href="/documents/sticker/25mm.asp?sjidx=<%= Server.URLEncode(CStr(rsjidx)) %>"
             target="_blank" rel="noopener">
            25mm
          </a>
          <a class="btn btn-outline-primary"
             href="/documents/sticker/35mm.asp?sjidx=<%= Server.URLEncode(CStr(rsjidx)) %>"
             target="_blank" rel="noopener">
            35mm
          </a>
          <a class="btn btn-outline-primary"
             href="/documents/sticker/45mm.asp?sjidx=<%= Server.URLEncode(CStr(rsjidx)) %>"
             target="_blank" rel="noopener">
            45mm
          </a>
        </div>
      </div>
      <div class="modal-footer">
        <small class="text-muted">선택 시 새 창에서 열립니다.</small>
      </div>
    </div>
  </div>
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
