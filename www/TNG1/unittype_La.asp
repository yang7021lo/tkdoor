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
%>
<%
if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
end if 

' 🔹 tng_unitprice_t 테이블 기준 변수

rSJB_IDX = Request("SJB_IDX")
rSJB_TYPE_NO = Request("SJB_TYPE_NO")
rSJB_barlist = Request("SJB_barlist")
rpcent = Request("pcent")
rbar = Request("bar")

    SQL = "SELECT  SJB_IDX,  SJB_TYPE_NO, SJB_TYPE_NAME,  SJB_barlist ,pcent "
    SQL = SQL & " FROM TNG_SJB  "
    SQL = SQL & " WHERE  SJB_IDX<>'"&rSJB_IDX&"' and SJB_TYPE_NO = '"&rSJB_TYPE_NO&"' and  right(SJB_barlist,3) = '"&rbar&"' "
    response.write (Sql)&"<br>"
    Rs.open Sql,Dbcon
        if not (Rs.EOF or Rs.BOF ) then
        Do while not Rs.EOF

        SJB_IDX        = Rs(0)
        SJB_TYPE_NO    = Rs(1)
        SJB_TYPE_NAME  = Rs(2)   
        SJB_barlist    = Rs(3)
        pcent          = Rs(4)
        i=i+1 
            sql = "INSERT INTO tng_unitprice_t ( price, upstatus, SJB_IDX,  unittype_bfwidx, unittype_qtyco_idx ) "
            sql = sql & "SELECT price*"&pcent&" , upstatus,'"&SJB_IDX&"', unittype_bfwidx, unittype_qtyco_idx "
            sql = sql & " FROM tng_unitprice_t"
            sql = sql & " WHERE SJB_IDX = " & rSJB_IDX & " "
        Response.write (SQL)&"/"&i&"<br>"
        dbcon.Execute (SQL)


        Rs.movenext
        Loop
        End If
        
    'Rs.Close     


    response.write "<script>opener.location.replace('unittype_pa.asp');window.close();</script>" 
 

  Rs.Close

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>