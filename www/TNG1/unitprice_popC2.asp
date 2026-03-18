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
rqtyco_idx=Request("qtyco_idx")
rqtyidx=Request("qtyidx")
rsjb_idx=Request("sjb_idx")
rupaidx=REquest("upaidx")
ratype=Request("atype") '2차데이터 일괄처리 여부

SQL="select sdate, fdate from unitprice where upmidx='"&rupmidx&"' "
  Rs.Open sql, dbcon
  if not (Rs.EOF or Rs.BOF ) then
    sdate=Rs(0)
    fdate=Rs(1)

    SQL=" Insert into tng_unitprice ( bfwidx, bfidx, sjbtidx, qtyco_idx, price, sjb_idx, qtyidx, upmidx, upaidx, sdate, fdate, upstatus) "
    SQL=SQL&" Select  bfwidx, bfidx, sjbtidx, '"&rqtyco_idx&"', '0', sjb_idx, '"&rqtyidx&"', '"&rupmidx&"',upaidx, '"&sdate&"','"&fdate&"' ,'0' "
    SQL=SQL&" From unitpriceA  "
    SQL=SQL&" Where  upmidx='"&rupmidx&"' and sjb_idx='"&rsjb_idx&"' and upstatus='0' "
    Response.write (SQL)&"/"&i&"<br>"
    dbcon.Execute (SQL)

    'tk_qtyco TB upstatus column을 1로 업데이트
    SQL="update tk_qtyco set upstatus=1 where qtyco_idx='"&rqtyco_idx&"' "
    'Response.write (SQL)&"/"&i&"<br>"
    dbcon.Execute (SQL)

    response.write "<script>opener.location.replace('unitprice_popB.asp?atype="&ratype&"&sjb_idx="&rsjb_idx&"&upmidx="&rupmidx&"&qtyidx="&rqtyidx&"');window.close();</script>" 
 
  End If
  Rs.Close

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>