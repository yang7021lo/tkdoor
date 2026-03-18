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
barIDX = encodestr(Request("barIDX"))          ' 인덱스 또는 고유 ID
barSELECT = encodestr(Request("barSELECT"))    ' 선택 값
barCODE = encodestr(Request("barCODE"))        ' 코드 값
barshorten = encodestr(Request("barshorten"))  ' 축약된 이름 또는 코드
barNAME = encodestr(Request("barNAME"))        ' 항목의 이름
barQTY = encodestr(Request("barQTY"))          ' 수량
barSTATUS = encodestr(Request("barSTATUS"))    ' 항목의 상태
barmidx = encodestr(Request("barmidx"))        ' 중간 인덱스 (외래 키 또는 참조 가능성 있음)
barwdate = encodestr(Request("barwdate"))      ' 작성 날짜 또는 생성 날짜
baremidx = encodestr(Request("baremidx"))      ' 수정한 사용자 또는 참조하는 인덱스
barewdate = encodestr(Request("barewdate"))    ' 수정된 날짜
qtype = encodestr(Request("qtype"))            ' 쿼리 유형 또는 추가 유형
atype = encodestr(Request("atype"))            ' 작업 유형 또는 다른 유형
barlistprice = encodestr(Request("barlistprice")) ' 항목의 목록 가격


' Response.write barIDX & "<br>"          ' barIDX 출력
' Response.write barSELECT & "<br>"       ' barSELECT 출력
' Response.write barCODE & "<br>"         ' barCODE 출력
' Response.write barshorten & "<br>"      ' barshorten 출력
' Response.write barNAME & "<br>"         ' barNAME 출력
' Response.write barQTY & "<br>"          ' barQTY 출력
' Response.write barSTATUS & "<br>"       ' barSTATUS 출력
' Response.write barmidx & "<br>"         ' barmidx 출력
' Response.write barwdate & "<br>"        ' barwdate 출력
' Response.write baremidx & "<br>"        ' baremidx 출력
' Response.write barewdate & "<br>"       ' barewdate 출력
' Response.write qtype & "<br>"           ' qtype 출력
' Response.write atype & "<br>"           ' atype 출력
' Response.write barlistprice & "<br>"    ' barlistprice 출력


SQL="INSERT INTO tk_barlist (barIDX, barSELECT, barCODE, barshorten, barNAME, barQTY, barSTATUS, barmidx "
SQL=SQL&"  , barwdate, baremidx, barewdate, qtype, atype, barlistprice,barNAME1 ,barNAME2 "
SQL=SQL&" VALUES ('"&barIDX&"', '"&barSELECT&"', '"&barCODE&"', '"&barshorten&"', '"&barNAME&"', '"&barQTY&"' "
SQL=SQL&" , "&1&"', '"&barmidx&"', GETDATE(), '"&baremidx&"', GETDATE(), '"&qtype&"', '"&atype&"', '"&barlistprice&"', '"&barNAME1&"', '"&barNAME2&"') "
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('barlist_itemin.asp');</script>"

%>


<%
set Rs=Nothing
call dbClose()
%>