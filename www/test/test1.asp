
<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")

SQL=" select b.sidx, c.baridx, c.barNAME,  a.goidx, a.goname "
SQL=SQL&"  from tk_goods A "
SQL=SQL&" join tk_stand B on a.goidx=b.goidx "
SQL=SQL&" join tk_barlist c on b.baridx=c.baridx "
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF

rsidx=Rs(0)
baridx=Rs(1)
barNAME=Rs(2)
rgoidx=Rs(3)
goname=Rs(4)
sbarNAME=split(barNAME,"*")
barNAME1=sbarNAME(0)
barNAME2=sbarNAME(1)

    SQL="  select BUIDX from tk_BUSOK "
    Rs1.open Sql,Dbcon,1,1,1
    if not (Rs1.EOF or Rs1.BOF ) then
    Do while not Rs1.EOF
        rbuidx=Rs1(0)


            barNAME 



        SQL="Insert into tk_material (sidx, buidx, baridx, barNAME, rgoidx, goname, smtype, smproc, smal, smalqu, smst, smstqu "
        SQL=SQL&" , smglass, smgrid, tagongfok, tagonghigh, smnote, smcomb, smmidx, smwdate, smemidx, smewdate) "
        SQL=SQL&" Values ('"&rsidx&"', '"&rbuidx&"', '"&baridx&"', '"&barNAME&"', '"&rgoidx&"', '"&goname&"', '"&smtype&"', '"&smproc&"', '"&smal&"', '"&smalqu&"', '"&smst&"', '"&smstqu&"', '"&smglass&"', '"&smgrid&"', '"&tagongfok&"', '"&tagonghigh&"', '"&smnote&"', '"&smcomb&"', '"&C_midx&"', getdate(), '"&smemidx&"', '"&smewdate&"') "
        response.write (SQL) &"<br>"
        'Dbcon.Execute (SQL) 

    Rs1.movenext
    Loop
    End If 
    Rs1.Close   

Rs.movenext
Loop
End If 
Rs.Close   




set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>
