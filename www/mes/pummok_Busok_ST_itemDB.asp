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

part=Request("part")
buidx=Request("buidx")

' 파일 및 폼 데이터 읽기
BUSELECT = Request("BUSELECT")
BUSTATUS = Request("BUSTATUS")
BUIMAGES = Request("BUIMAGES")  ' 이미지 파일
BUCADFILES = Request("BUCADFILES")  ' 캐드 파일

BUCODE = Request("BUCODE")
BUshorten = Request("BUshorten")
BUNAME = Request("BUNAME")
BUQTY = Request("BUQTY")

Buprice = Request("Buprice")
BUGEMHYUNG = Request("BUGEMHYUNG")
BUBIJUNG = Request("BUBIJUNG")
BUDUKKE = Request("BUDUKKE")
BUHIGH = Request("BUHIGH")
BU_BOGANG_LENGTH = Request("BU_BOGANG_LENGTH")
BUsangbarTYPE = Request("BUsangbarTYPE")
BUhabarTYPE = Request("BUhabarTYPE")
BUchulmolbarTYPE = Request("BUchulmolbarTYPE")
BUpainttype = Request("BUpainttype")
BUgrouptype = Request("BUgrouptype")
BUST_GLASS = Request("BUST_GLASS")


BUST_NUCUT_ShRing = Request("BUST_NUCUT_ShRing")
BUST_NUCUT_1 = Request("BUST_NUCUT_1")
BUST_NUCUT_2 = Request("BUST_NUCUT_2")
BUST_VCUT_ShRing = Request("BUST_VCUT_ShRing")
BUST_VCUT_1 = Request("BUST_VCUT_1")
BUST_VCUT_2 = Request("BUST_VCUT_2")
BUST_VCUT_CH = Request("BUST_VCUT_CH")
BUmidx = Request("BUmidx")
BUemidx = Request("BUemidx")
qtype = Request("qtype")
atype = Request("atype")

'Response.write "buidx : " & buidx & "<br>"
'Response.write "BUSELECT : " & BUSELECT & "<br>"
'Response.write "BUCODE : " & BUCODE & "<br>"
'Response.write "BUshorten : " & BUshorten & "<br>"
'Response.write "BUNAME : " & BUNAME & "<br>"
'Response.write "BUQTY : " & BUQTY & "<br>"
'Response.write "BUSTATUS : " & BUSTATUS & "<br>"
'Response.write "Buprice : " & Buprice & "<br>"
'Response.write "BUGEMHYUNG : " & BUGEMHYUNG & "<br>"
'Response.write "BUBIJUNG : " & BUBIJUNG & "<br>"
'Response.write "BUDUKKE : " & BUDUKKE & "<br>"
'Response.write "BUHIGH : " & BUHIGH & "<br>"
'Response.write "BU_BOGANG_LENGTH : " & BU_BOGANG_LENGTH & "<br>"
'Response.write "BUIMAGES : " & BUIMAGES & "<br>"
'Response.write "BUCADFILES : " & BUCADFILES & "<br>"
'Response.write "BUsangbarTYPE : " & BUsangbarTYPE & "<br>"
'Response.write "BUhabarTYPE : " & BUhabarTYPE & "<br>"
'Response.write "BUchulmolbarTYPE : " & BUchulmolbarTYPE & "<br>"
'Response.write "BUpainttype : " & BUpainttype & "<br>"
'Response.write "BUgrouptype : " & BUgrouptype & "<br>"
'Response.write "BUST_GLASS : " & BUST_GLASS & "<br>"
'Response.write "BUST_N_CUT_STATUS : " & BUST_N_CUT_STATUS & "<br>"
'Response.write "BUST_HL_COIL : " & BUST_HL_COIL & "<br>"
'Response.write "BUST_NUCUT_ShRing : " & BUST_NUCUT_ShRing & "<br>"
'Response.write "BUST_NUCUT_1 : " & BUST_NUCUT_1 & "<br>"
'Response.write "BUST_NUCUT_2 : " & BUST_NUCUT_2 & "<br>"
'Response.write "BUST_VCUT_ShRing : " & BUST_VCUT_ShRing & "<br>"
'Response.write "BUST_VCUT_1 : " & BUST_VCUT_1 & "<br>"
'Response.write "BUST_VCUT_2 : " & BUST_VCUT_2 & "<br>"
'Response.write "BUST_VCUT_CH : " & BUST_VCUT_CH & "<br>"
'Response.write "BUmidx : " & BUmidx & "<br>"
'Response.write "BUemidx : " & BUemidx & "<br>"
'Response.write "qtype : " & qtype & "<br>"
'Response.write "atype : " & atype & "<br>"
'Response.end

if part="delete" then 
    SQL="Delete From tk_BUSOK Where buidx='"&buidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    response.write "<script>location.replace('pummok_Busok_ST_item.asp');</script>"
else 
    if buidx="0" then 
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
        'Response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
        response.write "<script>alert('입력이 완료되었습니다.');location.replace('pummok_Busok_ST_item.asp');</script>"
    else
        SQL = "UPDATE tk_BUSOK SET "
        SQL = SQL & "BUSELECT='" & BUSELECT & "', BUCODE='" & BUCODE & "', BUshorten='" & BUshorten & "', BUNAME='" & BUNAME & "', BUQTY='" & BUQTY & "', BUSTATUS='" & BUSTATUS & "', "
        SQL = SQL & "Buprice='" & Buprice & "', BUGEMHYUNG='" & BUGEMHYUNG & "', BUBIJUNG='" & BUBIJUNG & "', BUDUKKE='" & BUDUKKE & "', BUHIGH='" & BUHIGH & "', BU_BOGANG_LENGTH='" & BU_BOGANG_LENGTH & "', "
        SQL = SQL & "BUIMAGES='" & BUIMAGES & "', BUCADFILES='" & BUCADFILES & "', BUsangbarTYPE='" & BUsangbarTYPE & "', BUhabarTYPE='" & BUhabarTYPE & "', BUchulmolbarTYPE='" & BUchulmolbarTYPE & "', BUpainttype='" & BUpainttype & "', "
        SQL = SQL & "BUgrouptype='" & BUgrouptype & "', BUST_GLASS='" & BUST_GLASS & "', BUST_N_CUT_STATUS='" & BUST_N_CUT_STATUS & "', BUST_HL_COIL='" & BUST_HL_COIL & "', BUST_NUCUT_ShRing='" & BUST_NUCUT_ShRing & "', BUST_NUCUT_1='" & BUST_NUCUT_1 & "', "
        SQL = SQL & "BUST_NUCUT_2='" & BUST_NUCUT_2 & "', BUST_VCUT_ShRing='" & BUST_VCUT_ShRing & "', BUST_VCUT_1='" & BUST_VCUT_1 & "', BUST_VCUT_2='" & BUST_VCUT_2 & "', BUST_VCUT_CH='" & BUST_VCUT_CH & "', "
        SQL = SQL & "BUmidx='" & BUmidx & "', BUwdate=GETDATE(), BUemidx='" & BUemidx & "', BUewdate=GETDATE(), qtype='" & qtype & "', atype='" & atype & "' "
        SQL = SQL & "WHERE BUidx='" & BUidx & "'"
        'Response.write(SQL) & "<br>"
        Dbcon.Execute(SQL)
        response.write "<script>location.replace('pummok_Busok_ST_item.asp?rbuidx="&buidx&"');</script>"
    end if
end if

set Rs = Nothing
call dbClose()
%>
