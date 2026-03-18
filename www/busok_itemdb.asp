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
%>
<%
Set uploadform = Server.CreateObject("DEXT.FileUpload")
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=imagepath

' 파일 및 폼 데이터 읽기
BUIMAGES = uploadform("BUIMAGES")  ' 이미지 파일
BUCADFILES = uploadform("BUCADFILES")  ' 캐드 파일
BUSELECT = uploadform("BUSELECT")
BUCODE = uploadform("BUCODE")
BUshorten = uploadform("BUshorten")
BUNAME = uploadform("BUNAME")
BUQTY = uploadform("BUQTY")
BUSTATUS = uploadform("BUSTATUS")
Buprice = uploadform("Buprice")
BUGEMHYUNG = uploadform("BUGEMHYUNG")
BUBIJUNG = uploadform("BUBIJUNG")
BUDUKKE = uploadform("BUDUKKE")
BUHIGH = uploadform("BUHIGH")
BU_BOGANG_LENGTH = uploadform("BU_BOGANG_LENGTH")
BUsangbarTYPE = uploadform("BUsangbarTYPE")
BUhabarTYPE = uploadform("BUhabarTYPE")
BUchulmolbarTYPE = uploadform("BUchulmolbarTYPE")
BUpainttype = uploadform("BUpainttype")
BUgrouptype = uploadform("BUgrouptype")
BUST_GLASS = uploadform("BUST_GLASS")
BUST_N_CUT_STATUS = uploadform("BUST_N_CUT_STATUS")
BUST_HL_COIL = uploadform("BUST_HL_COIL")
BUST_NUCUT_ShRing = uploadform("BUST_NUCUT_ShRing")
BUST_NUCUT_1 = uploadform("BUST_NUCUT_1")
BUST_NUCUT_2 = uploadform("BUST_NUCUT_2")
BUST_VCUT_ShRing = uploadform("BUST_VCUT_ShRing")
BUST_VCUT_1 = uploadform("BUST_VCUT_1")
BUST_VCUT_2 = uploadform("BUST_VCUT_2")
BUST_VCUT_CH = uploadform("BUST_VCUT_CH")
BUmidx = uploadform("BUmidx")
BUemidx = uploadform("BUemidx")
qtype = uploadform("qtype")
atype = uploadform("atype")

' SQL 삽입문 생성
SQL = "INSERT INTO tk_BUSOK (BUSELECT, BUCODE, BUshorten, BUNAME, BUQTY, BUSTATUS, Buprice, BUGEMHYUNG, BUBIJUNG, BUDUKKE, BUHIGH, "
SQL = SQL & "BU_BOGANG_LENGTH, BUIMAGES, BUCADFILES, BUsangbarTYPE, BUhabarTYPE, BUchulmolbarTYPE, BUpainttype, BUgrouptype, "
SQL = SQL & "BUST_GLASS, BUST_N_CUT_STATUS, BUST_HL_COIL, BUST_NUCUT_ShRing, BUST_NUCUT_1, BUST_NUCUT_2, BUST_VCUT_ShRing, "
SQL = SQL & "BUST_VCUT_1, BUST_VCUT_2, BUST_VCUT_CH, BUmidx, BUwdate, BUemidx, BUewdate, qtype, atype) VALUES ("
SQL = SQL & "'" & BUSELECT & "', '" & BUCODE & "', '" & BUshorten & "', '" & BUNAME & "', '" & BUQTY & "', '" & BUSTATUS & "', "
SQL = SQL & "'" & Buprice & "', '" & BUGEMHYUNG & "', '" & BUBIJUNG & "', '" & BUDUKKE & "', '" & BUHIGH & "', '" & BU_BOGANG_LENGTH & "', "
SQL = SQL & "'" & BUIMAGES & "', '" & BUCADFILES & "', '" & BUsangbarTYPE & "', '" & BUhabarTYPE & "', '" & BUchulmolbarTYPE & "', '" & BUpainttype & "', "
SQL = SQL & "'" & BUgrouptype & "', '" & BUST_GLASS & "', '" & BUST_N_CUT_STATUS & "', '" & BUST_HL_COIL & "', '" & BUST_NUCUT_ShRing & "', '" & BUST_NUCUT_1 & "', "
SQL = SQL & "'" & BUST_NUCUT_2 & "', '" & BUST_VCUT_ShRing & "', '" & BUST_VCUT_1 & "', '" & BUST_VCUT_2 & "', '" & BUST_VCUT_CH & "', '" & BUmidx & "', "
SQL = SQL & "GETDATE(), '" & BUemidx & "', GETDATE(), '" & qtype & "', '" & atype & "')"

' SQL 실행
Dbcon.Execute(SQL)

' 성공 메시지
response.write "<script>alert('입력이 완료되었습니다.');location.replace('tk_BUSOK.asp');</script>"

' 리소스 정리
set uploadform = Nothing
set Rs = Nothing
call dbClose()
%>
