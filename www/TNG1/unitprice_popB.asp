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

rqtyidx=Request("qtyidx")
rupmidx=Request("upmidx") '단가적용 날짜 기준키
rsjb_idx=Request("sjb_idx")
ratype=Request("atype") '2차데이터 일괄처리 여부

SQL="Select A.sjb_barlist, B.sjb_type_name , A.sjb_type_no"
SQL=SQL&" From tng_sjb  A "
SQL=SQL&" Join tng_sjbtype B On A.SJB_TYPE_NO=B.SJB_TYPE_NO "
SQL=SQL&" where A.sjb_idx='"&rsjb_idx&"' "
Rs.Open sql, dbcon
if not (Rs.EOF or Rs.BOF ) then
  sjb_barlist=Rs(0)
  sjb_type_name=Rs(1)
  sjb_type_no=Rs(2)
    Response.write "품목: "&sjb_type_name&"/품명 : "&sjb_barlist&"<br>"
end If
Rs.Close

SQL=" Select qtyco_idx, qtyname, qtyconame from tk_qtyco where qtyno='"&rqtyidx&"' and upstatus='0'" 
'Response.write (SQL)&"<br>"
Rs.Open sql, dbcon
if not (Rs.EOF or Rs.BOF ) then

    qtyco_idx=Rs(0)
    qtyname=Rs(1)
    qtyconame=Rs(2)
    if qtyconame="" then qtyconame="없음" end if
		jqtyco_idx="j"&qtyco_idx
    Response.write "재질 : "&qtyname&"/재질상세 : "&qtyconame&"<br>"
    response.write "<script>window.open('unitprice_popC2.asp?atype="&ratype&"&sjb_idx="&rsjb_idx&"&upmidx="&rupmidx&"&qtyidx="&rqtyidx&"&qtyco_idx="&qtyco_idx&"','"&jqtyco_idx&"','top=0, left=600, width=100, height=100');</script>"


else
  'tk_qty TB upstatus column을 1로 업데이트
  SQL="update tk_qty set upstatus=1 where qtyidx='"&rqtyidx&"' "
  Response.write (SQL)&"/"&i&"<br>"
  dbcon.Execute (SQL)
'



response.write "<script>opener.location.replace('unitprice2.asp?part=smake&atype="&ratype&"&sjb_type_no="&sjb_type_no&"&sjb_idx="&rsjb_idx&"&upmidx="&rupmidx&"');window.close();</script>" 

end if
Rs.Close



set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>