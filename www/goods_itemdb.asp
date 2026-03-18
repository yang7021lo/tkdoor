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
goinx = encodestr(Request("goinx"))  ' 고유 번호
gotype = encodestr(Request("gotype"))  ' 유형
gocode = encodestr(Request("gocode"))  ' 코드
gocword = encodestr(Request("gocword"))  ' 검색어
goname = encodestr(Request("goname"))  ' 이름
gopaint = encodestr(Request("gopaint"))  ' 도장 여부
gosecfloor = encodestr(Request("gosecfloor"))  ' 보안 층수
gomidkey = encodestr(Request("gomidkey"))  ' 중간 키
gounit = encodestr(Request("gounit"))  ' 단위
gostatus = encodestr(Request("gostatus"))  ' 상태
gomidx = encodestr(Request("gomidx"))  ' 수정 인덱스
gowdate = encodestr(Request("gowdate"))  ' 작성 날짜
goemidx = encodestr(Request("goemidx"))  ' 수정자 인덱스
goewdate = encodestr(Request("goewdate"))  ' 수정 날짜
goprice = encodestr(Request("goprice"))  ' 가격
goname1 = encodestr(Request("goname1"))  ' 추가 이름 1
goname2 = encodestr(Request("goname2"))  ' 추가 이름 2
goname3 = encodestr(Request("goname3"))  ' 추가 이름 3
goname4 = encodestr(Request("goname4"))  ' 추가 이름 4
goname5 = encodestr(Request("goname5"))  ' 추가 이름 5
goname6 = encodestr(Request("goname6"))  ' 추가 이름 6
goname7 = encodestr(Request("goname7"))  ' 추가 이름 7
goname8 = encodestr(Request("goname8"))  ' 추가 이름 8
goname9 = encodestr(Request("goname9"))  ' 추가 이름 9
goname10 = encodestr(Request("goname10")) ' 추가 이름 10
goname11 = encodestr(Request("goname11")) ' 추가 이름 11
goname12 = encodestr(Request("goname12")) ' 추가 이름 12
goname13 = encodestr(Request("goname13")) ' 추가 이름 13
goprice1 = encodestr(Request("goprice1")) ' 가격1
goprice2 = encodestr(Request("goprice2")) ' 가격2
goprice3 = encodestr(Request("goprice3")) ' 가격3

'Response.write goinx & "<br>"  ' 고유 번호 출력
'Response.write gotype & "<br>"  ' 유형 출력
'Response.write gocode & "<br>"  ' 코드 출력
'Response.write gocword & "<br>"  ' 검색어 출력
'Response.write goname & "<br>"  ' 이름 출력
'Response.write gopaint & "<br>"  ' 도장 여부 출력
'Response.write gosecfloor & "<br>"  ' 보안 층수 출력
'Response.write gomidkey & "<br>"  ' 중간 키 출력
'Response.write gounit & "<br>"  ' 단위 출력
'Response.write gostatus & "<br>"  ' 상태 출력
'Response.write gomidx & "<br>"  ' 수정 인덱스 출력
'Response.write gowdate & "<br>"  ' 작성 날짜 출력
'Response.write goemidx & "<br>"  ' 수정자 인덱스 출력
'Response.write goewdate & "<br>"  ' 수정 날짜 출력
'Response.write goprice & "<br>"  ' 가격 출력
'Response.write goname1 & "<br>"  ' 안전
'Response.write goname2 & "<br>"  ' 복층안전
'Response.write goname3 & "<br>"  ' 단열안전
'Response.write goname4 & "<br>"  ' 삼중_단열안전
'Response.write goname5 & "<br>"  ' 매립자동
'Response.write goname6 & "<br>"  ' 매립단열자동
'Response.write goname7 & "<br>"  ' 34자동
'Response.write goname8 & "<br>"  ' 비매립힌지 안전
'Response.write goname9 & "<br>"  ' 비매립힌지 복층안전
'Response.write goname10 & "<br>"  ' 비매립힌지 단열안전
'Response.write goname11 & "<br>"  ' 통도장
'Response.write goname12 & "<br>"  ' 다대무홈
'Response.write goname13 & "<br>"  ' 중간키
'Response.write goprice1 & "<br>"  ' 중간키 단가
'Response.write goprice2 & "<br>"  ' 다대무홈 단가
'Response.write goprice3 & "<br>"  ' 중간키+다대무홈 단가 출력

'Response.end

SQL = "INSERT INTO tk_goods (  gotype, gocode, gocword, goname, gopaint, gosecfloor, gomidkey"
SQL = SQL & ", gounit, gostatus, gomidx, gowdate, goemidx, goewdate, goprice, goname1"
SQL = SQL & ", goname2, goname3, goname4, goname5, goname6, goname7, goname8, goname9"
SQL = SQL & ", goname10, goname11, goname12, goname13, goprice1, goprice2, goprice3)"
SQL = SQL & "VALUES (  '" & gotype & "', '" & gocode & "', '" & gocword & "', '" & goname & "', '" & gopaint & "', '" & gosecfloor & "', '" & gomidkey & "'"
SQL = SQL & ", '" & gounit & "', '" & gostatus & "', '" & gomidx & "', '" & gowdate & "', '" & goemidx & "', '" & goewdate & "', '" & goprice & "', '" & goname1 & "'"
SQL = SQL & ", '" & goname2 & "', '" & goname3 & "', '" & goname4 & "', '" & goname5 & "', '" & goname6 & "', '" & goname7 & "', '" & goname8 & "', '" & goname9 & "'"
SQL = SQL & ", '" & goname10 & "', '" & goname11 & "', '" & goname12 & "', '" & goname13 & "', '" & goprice1 & "', '" & goprice2 & "', '" & goprice3 & "')"
Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('goods_item.asp');</script>"

%>


<%
set Rs=Nothing
call dbClose()
%>