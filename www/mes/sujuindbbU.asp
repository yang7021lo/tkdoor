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
sujuinmoneyidx=encodestr(Request("sujuinmoneyidx"))
sjbpummyoung=Request("sjbpummyoung")
goidx=Request("goidx")
sjaidx=Request("sjaidx")
goprice=Request("goprice")
goname=encodestr(Request("goname"))
sjbkukyuk=Request("sjbkukyuk")
baridx=encodestr(Request("baridx"))
barlistprice=encodestr(Request("barlistprice"))
barNAME=encodestr(Request("barNAME"))
sjbjaejil=Request("sjbjaejil")
QTYIDX=Request("QTYIDX")
QTYprice=Request("QTYprice")
QTYNAME=Request("QTYNAME")
sjbqty=encodestr(Request("sjbqty"))
sjbwide=encodestr(Request("sjbwide"))
sjbwidePRICE=encodestr(Request("sjbwidePRICE"))
sjbhigh=encodestr(Request("sjbhigh"))
sjbhighPRICE=encodestr(Request("sjbhighPRICE"))
sjbbanghyang=encodestr(Request("sjbbanghyang"))
sjbwitch=encodestr(Request("sjbwitch"))
sjbbigo=encodestr(Request("sjbbigo"))
sjwondanga=encodestr(Request("sjwondanga"))
sjchugageum=encodestr(Request("sjchugageum"))
sjgonggeumgaaek=encodestr(Request("sjgonggeumgaaek"))
sjDCdanga=encodestr(Request("sjDCdanga"))
sjseaek=encodestr(Request("sjseaek"))
sjdanga=encodestr(Request("sjdanga"))
sjgeumaek=encodestr(Request("sjgeumaek"))
sjbglass=encodestr(Request("sjbglass"))
glidx=encodestr(Request("glidx"))
glprice=encodestr(Request("glprice"))
gldepth=encodestr(Request("gldepth"))
sjbsangbar=encodestr(Request("sjbsangbar"))
SANGBUIDX=encodestr(Request("SANGBUIDX"))
SANGbuprice=encodestr(Request("SANGbuprice"))
SANGbuname=encodestr(Request("SANGbuname"))
sjbpaint=encodestr(Request("sjbpaint"))
pidx=encodestr(Request("pidx"))
pprice=encodestr(Request("pprice"))
sjbhabar=encodestr(Request("sjbhabar"))
pname=encodestr(Request("pname"))
rHABUIDX=encodestr(Request("rHABUIDX"))
rHAbuprice=encodestr(Request("rHAbuprice"))
rHAbuname=encodestr(Request("rHAbuname"))
sjbkey1=encodestr(Request("sjbkey1"))
kyidx1=encodestr(Request("kyidx1"))
kyprice1=encodestr(Request("kyprice1"))
kyname1=encodestr(Request("kyname1"))
sjbkey2=encodestr(Request("sjbkey2"))
kyidx2=encodestr(Request("kyidx2"))
kyprice2=encodestr(Request("kyprice2"))
kyname2=encodestr(Request("kyname2"))
sjbkey3=encodestr(Request("sjbkey3"))
sjbkey4=encodestr(Request("sjbkey4"))
sjbkey5=encodestr(Request("sjbkey5"))
kyidx3=encodestr(Request("kyidx3"))
kyprice3=encodestr(Request("kyprice3"))
kyname3=encodestr(Request("kyname3"))
sjbkey6=encodestr(Request("sjbkey6"))
kyidx4=encodestr(Request("kyidx4"))
kyprice4=encodestr(Request("kyprice4"))
kyname4=encodestr(Request("kyname4"))
sjbkey7=encodestr(Request("sjbkey7"))
sjbkey8=encodestr(Request("sjbkey8"))
sjbtagong1=encodestr(Request("sjbtagong1"))
tagongidx1=encodestr(Request("tagongidx1"))
tagongprice1=encodestr(Request("tagongprice1"))
tagongname1=encodestr(Request("tagongname1"))
sjbtagong2=encodestr(Request("tagongprice"))
sjbtagong3=encodestr(Request("sjbtagong3"))
sjbtagong4=encodestr(Request("sjbtagong4"))
sjbtagong5=encodestr(Request("sjbtagong5"))
sjbtagong6=encodestr(Request("sjbtagong6"))
tagongidx2=encodestr(Request("tagongidx2"))
tagongprice2=encodestr(Request("tagongprice2"))
tagongname2=encodestr(Request("tagongname2"))
sjbtagong7=encodestr(Request("sjbtagong7"))
sjbtagong8=encodestr(Request("sjbtagong8"))
sjbtagong9=encodestr(Request("sjbtagong9"))
sjbtagong10=encodestr(Request("sjbtagong10"))
sjbtagong11=encodestr(Request("sjbtagong11"))
sjbhingedown=encodestr(Request("sjbhingedown"))
hingeidx=encodestr(Request("hingeidx"))
hingeprice=encodestr(Request("hingeprice"))
hingename1=encodestr(Request("hingename1"))
sjbhingedown1=encodestr(Request("sjbhingedown1"))
hingeidx1=encodestr(Request("hingeidx1"))
hingeprice1=encodestr(Request("hingeprice1"))
hingecenter1=encodestr(Request("hingecenter1"))
sjbhingedown2=encodestr(Request("sjbhingedown2"))
sjbhingedown3=encodestr(Request("sjbhingedown3"))
sjbhingeup=encodestr(Request("sjbhingeup"))
hingeidx3=encodestr(Request("hingeidx3"))
hingeprice3=encodestr(Request("hingeprice3"))
hingename2=encodestr(Request("hingename2"))
sjbhingeup1=encodestr(Request("sjbhingeup1"))
hingeidx4=encodestr(Request("hingeidx4"))
hingeprice4=encodestr(Request("hingeprice4"))
hingecenter2=encodestr(Request("hingecenter2"))
sjbhingeup2=encodestr(Request("sjbhingeup2"))
sjbhingeup3=encodestr(Request("sjbhingeup3"))
sjbkyukja1=encodestr(Request("sjbkyukja1"))
kyukjaprice=encodestr(Request("kyukjaprice"))
kyukjaname=encodestr(Request("kyukjaname"))
sjbkyukja2=encodestr(Request("sjbkyukja2"))
sjbkyukja3=encodestr(Request("sjbkyukja3"))
sjbkyukja4=encodestr(Request("sjbkyukja4"))
sjbkyukja5=encodestr(Request("sjbkyukja5"))
sjbkyukja6=encodestr(Request("sjbkyukja6"))
sjbkyukja7=encodestr(Request("sjbkyukja7"))
sjbkyukja8=encodestr(Request("sjbkyukja8"))

rsplit1=split(sjbkukyuk,"_")
baridx=rsplit1(0)
barlistprice=rsplit1(1)
barNAME=rsplit1(2)

rsplit2=split(sjbjaejil,"_")
QTYIDX=rsplit2(0)
QTYprice=rsplit2(1)
QTYNAME=rsplit2(2)

rsplit3=split(sjbglass,"_")
glidx=rsplit3(0)
glprice=rsplit3(1)
gldepth=rsplit3(2)

rsplit4=split(sjbsangbar,"_")
SANGBUIDX=rsplit4(0)
SANGbuprice=rsplit4(1)
SANGbuname=rsplit4(2)

rsplit5=split(sjbpaint,"_")
pidx=rsplit5(0)
pprice=rsplit5(1)
pname=rsplit5(2)

rsplit6=split(sjbhabar,"_")
rHABUIDX=rsplit6(0)
rHAbuprice=rsplit6(1)
rHAbuname=rsplit6(2)

rsplit7=split(sjbkey1,"_")
kyidx1=rsplit7(0)
kyprice1=rsplit7(1)
kyname1=rsplit7(2)

rsplit8=split(sjbkey2,"_")
kyidx2=rsplit8(0)
kyprice2=rsplit8(1)
kyname2=rsplit8(2)

rsplit9=split(sjbkey5,"_")
kyidx3=rsplit9(0)
kyprice3=rsplit9(1)
kyname3=rsplit9(2)

rsplit10=split(sjbkey6,"_")
kyidx4=rsplit10(0)
kyprice4=rsplit10(1)
kyname4=rsplit10(2)

rsplit11=split(sjbtagong1,"_")
tagongidx1=rsplit11(0)
tagongprice1=rsplit11(1)
tagongname1=rsplit11(2)

rsplit12=split(sjbtagong6,"_")
tagongidx2=rsplit12(0)
tagongprice2=rsplit12(1)
tagongname2=rsplit12(2)

rsplit13=split(sjbhingedown,"_")
hingeidx=rsplit13(0)
hingeprice=rsplit13(1)
hingename1=rsplit13(2)

rsplit14=split(sjbhingedown1,"_")
hingeidx1=rsplit14(0)
hingeprice1=rsplit14(1)
hingecenter1=rsplit14(2)

rsplit15=split(sjbhingeup,"_")
hingeidx3=rsplit15(0)
hingeprice3=rsplit15(1)
hingename2=rsplit15(2)

rsplit16=split(sjbhingeup1,"_")
hingeidx4=rsplit16(0)
hingeprice4=rsplit16(1)
hingecenter2=rsplit16(2)


response.write "goidx;"&goidx&"<br>"
response.write "goprice;"&goprice&"<br>"
response.write "baridx:"&baridx&"<br>"
response.write "barlistprice;"&barlistprice&"<br>"
response.write "QTYIDX:"&QTYIDX&"<br>"
response.write "QTYprice;"&QTYprice&"<br>"
response.write "glidx;"&glidx&"<br>"
response.write "glprice;"&glprice&"<br>"
response.write "sangBUIDX;"&sangBUIDX&"<br>"
response.write "sangbuprice;"&sangbuprice&"<br>"
response.write "pidx;"&pidx&"<br>"
response.write "pprice;"&pprice&"<br>"
response.write "rHABUIDX;"&rHABUIDX&"<br>"
response.write "rHAbuprice;"&rHAbuprice&"<br>"
response.write "kyidx1;"&kyidx1&"<br>"
response.write "kyprice1;"&kyprice1&"<br>"
response.write "kyidx2;"&kyidx2&"<br>"
response.write "kyprice2;"&kyprice2&"<br>"
response.write "sjbkey3;"&sjbkey3&"<br>"
response.write "sjbkey4;"&sjbkey4&"<br>"
response.write "kyidx3;"&kyidx3&"<br>"
response.write "kyprice3;"&kyprice3&"<br>"
response.write "kyidx4;"&kyidx4&"<br>"
response.write "kyprice4;"&kyprice4&"<br>"
response.write "sjbkey7;"&sjbkey7&"<br>"
response.write "sjbkey8;"&sjbkey8&"<br>"
response.write "tagongidx1;"&tagongidx1&"<br>"
response.write "tagongprice1;"&tagongprice1&"<br>"
response.write "sjbtagong2;"&sjbtagong2&"<br>"
response.write "sjbtagong3;"&sjbtagong3&"<br>"
response.write "sjbtagong4;"&sjbtagong4&"<br>"
response.write "sjbtagong5;"&sjbtagong5&"<br>"
response.write "tagongidx2;"&tagongidx2&"<br>"
response.write "tagongprice2;"&tagongprice2&"<br>"
response.write "sjbtagong7;"&sjbtagong7&"<br>"
response.write "sjbtagong8;"&sjbtagong8&"<br>"
response.write "sjbtagong9;"&sjbtagong9&"<br>"
response.write "sjbtagong10;"&sjbtagong10&"<br>"
response.write "sjbtagong11;"&sjbtagong11&"<br>"
response.write "hingeidx;"&hingeidx&"<br>"
response.write "hingeprice;"&hingeprice&"<br>"
response.write "hingeidx1;"&hingeidx1&"<br>"
response.write "hingeprice1;"&hingeprice1&"<br>"
response.write "sjbhingedown2;"&sjbhingedown2&"<br>"
response.write "sjbhingedown3;"&sjbhingedown3&"<br>"
response.write "hingeidx3;"&hingeidx3&"<br>"
response.write "hingeprice3;"&hingeprice3&"<br>"
response.write "hingeidx4;"&hingeidx4&"<br>"
response.write "hingeprice4;"&hingeprice4&"<br>"
response.write "sjbhingeup2;"&sjbhingeup2&"<br>"
response.write "sjbhingeup3;"&sjbhingeup3&"<br>"
response.write "sangbuname;"&sangbuname&"<br>"
response.write "pname;"&pname&"<br>"
response.write "rHAbuname;"&rHAbuname&"<br>"
response.write "kyname1;"&kyname1&"<br>"
response.write "kyname2;"&kyname2&"<br>"
response.write "kyname3;"&kyname3&"<br>"
response.write "kyname4;"&kyname4&"<br>"
response.write "tagongname1;"&tagongname1&"<br>"
response.write "tagongname2;"&tagongname2&"<br>"
response.write "hingename1;"&hingename1&"<br>"
response.write "hingecenter1;"&hingecenter1&"<br>"
response.write "hingename2;"&hingename2&"<br>"
response.write "hingecenter2;"&hingecenter2&"<br>"
response.write "kyukjaname;"&kyukjaname&"<br>"
response.write "sangbuprice;"&sangbuprice&"<br>"
response.write "sjbhighPRICE;"&sjbhighPRICE&"<br>"
'response.end

SQL = "UPDATE tk_sujub SET  QTYIDX = '" & QTYIDX & "', QTYprice = '" & QTYprice & "', "
SQL = SQL & "sjbqty = '" & sjbqty & "', sjbwide = '" & sjbwide & "', sjbwidePRICE = '" & sjbwidePRICE & "', sjbhigh = '" & sjbhigh & "', sjbhighPRICE = '" & sjbhighPRICE & "', sjbbanghyang = '" & sjbbanghyang & "', sjbwitch = '" & sjbwitch & "', sjbbigo = '" & sjbbigo & "', "
SQL = SQL & "glidx = '" & glidx & "', glprice = '" & glprice & "', sangBUIDX = '" & sangBUIDX & "', sangbuprice = '" & sangbuprice & "', pidx = '" & pidx & "', pprice = '" & pprice & "', rHABUIDX = '" & rHABUIDX & "', rHAbuprice = '" & rHAbuprice & "', "
SQL = SQL & "kyidx1 = '" & kyidx1 & "', kyprice1 = '" & kyprice1 & "', kyidx2 = '" & kyidx2 & "', kyprice2 = '" & kyprice2 & "', sjbkey3 = '" & sjbkey3 & "', sjbkey4 = '" & sjbkey4 & "', kyidx3 = '" & kyidx3 & "', kyprice3 = '" & kyprice3 & "', kyidx4 = '" & kyidx4 & "', kyprice4 = '" & kyprice4 & "', sjbkey7 = '" & sjbkey7 & "', sjbkey8 = '" & sjbkey8 & "', "
SQL = SQL & "tagongidx1 = '" & tagongidx1 & "', tagongprice1 = '" & tagongprice1 & "', sjbtagong2 = '" & sjbtagong2 & "', sjbtagong3 = '" & sjbtagong3 & "', sjbtagong4 = '" & sjbtagong4 & "', sjbtagong5 = '" & sjbtagong5 & "', tagongidx2 = '" & tagongidx2 & "', tagongprice2 = '" & tagongprice2 & "', sjbtagong7 = '" & sjbtagong7 & "', sjbtagong8 = '" & sjbtagong8 & "', sjbtagong9 = '" & sjbtagong9 & "', sjbtagong10 = '" & sjbtagong10 & "', "
SQL = SQL & "hingeidx = '" & hingeidx & "', hingeprice = '" & hingeprice & "', hingeidx1 = '" & hingeidx1 & "', hingeprice1 = '" & hingeprice1 & "', sjbhingedown2 = '" & sjbhingedown2 & "', sjbhingedown3 = '" & sjbhingedown3 & "', hingeidx3 = '" & hingeidx3 & "', hingeprice3 = '" & hingeprice3 & "', hingeidx4 = '" & hingeidx4 & "', hingeprice4 = '" & hingeprice4 & "', sjbhingeup2 = '" & sjbhingeup2 & "', sjbhingeup3 = '" & sjbhingeup3 & "', "
SQL = SQL & "sjbkyukja1 = '" & sjbkyukja1 & "', kyukjaprice = '" & kyukjaprice & "', sjbkyukja2 = '" & sjbkyukja2 & "', sjbkyukja3 = '" & sjbkyukja3 & "', sjbkyukja4 = '" & sjbkyukja4 & "', sjbkyukja5 = '" & sjbkyukja5 & "', sjbkyukja6 = '" & sjbkyukja6 & "', sjbkyukja7 = '" & sjbkyukja7 & "', sjbkyukja8 = '" & sjbkyukja8 & "', sjaidx = '" & sjaidx & "', sujuinmoneyidx = '" & sujuinmoneyidx & "', "
SQL = SQL & "sjwondanga = '" & sjwondanga & "', sjchugageum = '" & sjchugageum & "', sjgonggeumgaaek = '" & sjgonggeumgaaek & "', sjDCdanga = '" & sjDCdanga & "', sjseaek = '" & sjseaek & "', sjdanga = '" & sjdanga & "', sjgeumaek = '" & sjgeumaek & "', goname = '" & goname & "', barNAME = '" & barNAME & "', QTYNAME = '" & QTYNAME & "', gldepth = '" & gldepth & "', sangbuname = '" & sangbuname & "', pname = '" & pname & "', "
SQL = SQL & "rHAbuname = '" & rHAbuname & "', kyname1 = '" & kyname1 & "', kyname2 = '" & kyname2 & "', kyname3 = '" & kyname3 & "', kyname4 = '" & kyname4 & "', tagongname1 = '" & tagongname1 & "', tagongname2 = '" & tagongname2 & "', hingename1 = '" & hingename1 & "', hingecenter1 = '" & hingecenter1 & "', hingename2 = '" & hingename2 & "', hingecenter2 = '" & hingecenter2 & "', kyukjaname = '" & kyukjaname & "', sjbtagong11 = '" & sjbtagong11 & "' "
SQL = SQL & "WHERE sjbidx = '" & sjbidx & "'"
Response.write (SQL)&"<br>"
'response.end
Dbcon.Execute (SQL)

response.write "<script>alert('입력이 완료되었습니다.');location.replace('sujuin.asp?cidx="&rcidx&"&sjaidx="&sjaidx&"&sjbidx="&sjbidx&"&goidx="&goidx&"&baridx="&baridx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>