
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

SQL="SELECT SJB_IDX, SJB_TYPE_NO, SJB_TYPE_NAME, SJB_barlist, SJB_midx, "
SQL=SQL&" Convert(varchar(10), SJB_mdate, 121), SJB_meidx, Convert(varchar(10), SJB_medate, 121) "
SQL=SQL&" FROM TNG_SJB "
Rs.open Sql,Dbcon,1,1,1
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF

SJB_IDX = Rs(0)
SJB_TYPE_NO = Rs(1)
SJB_TYPE_NAME = Rs(2)
SJB_barlist = Rs(3)
SJB_midx = Rs(4)
SJB_mdate = Rs(5)
SJB_meidx = Rs(6)
SJB_medate = Rs(7)

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
