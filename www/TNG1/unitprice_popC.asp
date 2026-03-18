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


  SQL="Select sjb_idx, sjb_type_no, sjbtidx, sjb_fa, bfwidx, whichi_fix, whichi_auto, bfidx, status, upaidx, sdate, fdate"
  SQL=SQL&" From unitpriceA "
  SQL=SQL&" Where upmidx='"&rupmidx&"' and sjb_idx='"&rsjb_idx&"' and upstatus='0' "
    Response.write (SQL)&"<br>"
  Rs1.Open sql, dbcon
  if not (Rs1.EOF or Rs1.BOF ) then
 
      sjb_idx=Rs1(0)
      sjb_type_no=Rs1(1)
      sjbtidx=Rs1(2)
      sjb_fa=Rs1(3)
      bfwidx=Rs1(4)
      whichi_fix=Rs1(5)
      whichi_auto=Rs1(6)
      bfidx=Rs1(7)
      status=Rs1(8)
      upaidx=Rs1(9)
      sdate=Rs1(10)
      fdate=Rs1(11)
    SQL="select max(upidx)+1 From tng_unitprice "
    Response.write (SQL)&"<br>"
    Rs2.Open SQL,dbcon
    if not (Rs2.EOF or Rs2.BOF ) then
        upidx=Rs2(0)
        if isnull(upidx) then 
          upidx="1"
        end if

    i=i+1
    SQL=" Insert into tng_unitprice (upidx, bfwidx, bfidx, sjbtidx, qtyco_idx, price, sjb_idx, qtyidx, upmidx, upaidx, sdate, fdate, upstatus) "
    SQL=SQL&" Values ('"&upidx&"', '"&bfwidx&"', '"&bfidx&"', '"&sjbtidx&"', '"&rqtyco_idx&"', 0, '"&sjb_idx&"', '"&rqtyidx&"', '"&rupmidx&"', '"&upaidx&"', '"&sdate&"','"&fdate&"',0)"
    Response.write (SQL)&"<br>"
    dbcon.Execute (SQL)

    SQL=" Insert into tng_unitprice (upidx, bfwidx, bfidx, sjbtidx, qtyco_idx, price, sjb_idx, qtyidx, upmidx, upaidx, sdate, fdate, upstatus) "
    SQL=SQL&" Select '"&upidx&"', bfwidx, bfidx, sjbtidx, '"&rqtyco_idx&"', '', sjb_idx, '"&rqtyidx&"', '"&upmidx&"',upaidx, '"&sdate&"','"&fdate&"' ,'0' "
    SQL=SQL&" From unitpriceA  "
    SQL=SQL&" Where  upmidx='"&rupmidx&"' and sjb_idx='"&rsjb_idx&"' and upstatus='0' "


    SQL=" update unitpriceA set upstatus='1' where upaidx='"&upaidx&"' "
    Response.write (SQL)&"/"&i&"<br>"
    dbcon.Execute (SQL)

    end if
    Rs2.Close

    response.write "<script>location.replace('unitprice_popC.asp?sjb_idx="&rsjb_idx&"&upmidx="&rupmidx&"&qtyidx="&rqtyidx&"&qtyco_idx="&rqtyco_idx&"&upaidx="&upaidx&"');</script>" 
  else

    SQL=" update unitpriceA set upstatus='0' where upmidx="&rupmidx&" and sjb_idx='"&rsjb_idx&"' "
    Response.write (SQL)&"/"&i&"<br>"
    dbcon.Execute (SQL)

    'tk_qtyco TB upstatus column을 1로 업데이트
    SQL="update tk_qtyco set upstatus=1 where qtyno='"&rqtyidx&"' "
    Response.write (SQL)&"/"&i&"<br>"
    dbcon.Execute (SQL)

    response.write "<script>opener.location.replace('unitprice_popB.asp?sjb_idx="&rsjb_idx&"&upmidx="&rupmidx&"&qtyidx="&rqtyidx&"');window.close();</script>" 
  end if
  Rs1.Close


set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>