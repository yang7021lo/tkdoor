<%@ Language=VBScript %>
<% Response.CodePage = 65001 %> <!-- UTF-8 인코딩 설정 -->
<!--#include virtual="/tkdoor/n_inc/dbcon1.asp"-->
<!--#include virtual="/tkdoor/n_inc/cookies.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")
listgubun="two"
subgubun="two2"
 
%>
<%
Response.Charset = "UTF-8" 

' 파일 경로 설정
Dim filePath
filePath = Server.MapPath("unitprice.csv")

' ADODB.Stream 객체 생성
Dim stream
Set stream = CreateObject("ADODB.Stream")
stream.Type = 2 ' Text data
stream.Charset = "UTF-8" ' UTF-8 인코딩 설정
stream.Open
stream.LoadFromFile(filePath)

' 파일 내용 읽기
Dim fileContent
fileContent = stream.ReadText

' 스트림 객체 닫기
stream.Close
Set stream = Nothing

' 줄 단위로 분리
Dim lines
lines = Split(fileContent, vbCrLf)

' 테이블 출력 시작

' 첫 줄 처리 (헤더)


' 나머지 줄 처리 (데이터 행)
Dim i
For i = 0 To UBound(lines)
    If Trim(lines(i)) <> "" Then
        Dim line
        line = lines(i)

 masplit=split(line,",")

    SQL=" Insert into tk_FrmBra (gtype, btitle, bdepth, bwidth, bheight, bstatus, bwidx, bwdate, aidx, buprice )"
    SQL=SQL&" Values ('"&masplit(0)&"','"&masplit(1)&"', '"&masplit(2)&"', '"&masplit(3)&"', '0', '1', '1', getdate(), '"&masplit(4)&"', '"&masplit(5)&"')"
    Response.write (SQL)&"<br>"
    'Dbcon.Execute (SQL)	


    End If
Next

' 테이블 출력 종료

%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
