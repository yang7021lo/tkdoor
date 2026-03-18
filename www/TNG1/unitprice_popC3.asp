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

rupmidx=Request("upmidx")

    SQL = "SELECT A.price , A.SJB_IDX, B.bfwidx, C.qtyco_idx "
    sql = sql & " FROM tng_unitprice_t A"
    sql = sql & " JOIN tng_whichitype B ON A.unittype_bfwidx = B.unittype_bfwidx "
    sql = sql & " JOIN tk_qtyco C ON A.unittype_qtyco_idx = C.unittype_qtyco_idx "
    'SQL = SQL & " WHERE  A.SJB_IDX<>'"&rSJB_IDX&"' and B.unittype_bfwidx = '"&unittype_bfwidx&"' and C.unittype_qtyco_idx = '"&unittype_qtyco_idx&"' "
    response.write (Sql)&"<br>"
    Rs.open Sql,Dbcon
        if not (Rs.EOF or Rs.BOF ) then
        Do while not Rs.EOF

        price        = Rs(0)
        SJB_IDX    = Rs(1)
        bfwidx  = Rs(2)   
        qtyco_idx    = Rs(3)

        i=i+1 
            sql = "UPDATE tng_unitprice SET "
            sql = sql & "price = '" & price & "' "
            SQL = SQL & " WHERE  SJB_IDX='"&SJB_IDX&"' and bfwidx = '"&bfwidx&"' and qtyco_idx = '"&qtyco_idx&"' "

        Response.write (SQL)&"/"&i&"<br>"
        'dbcon.Execute (SQL)

    
    Rs.movenext
    Loop
    End If
    Rs.Close

    'response.write "<script>opener.location.replace('unitprice2.asp?upmidx="&rupmidx&"');window.close();</script>" 

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>