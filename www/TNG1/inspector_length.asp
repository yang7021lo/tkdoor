<%@ codepage="65001" language="vbscript"%>
<%
' -------------------------------
' 안전 나눗셈 함수 정의 (페이지 최상위)
' -------------------------------
Function SafeDivide(numerator, denominator)
    If IsNumeric(denominator) And CDbl(denominator) <> 0 Then
        SafeDivide = CDbl(numerator) / CDbl(denominator)
    Else
        SafeDivide = 0
    End If 
End Function
%>
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

rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no")
rgreem_f_a=Request("greem_f_a")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")

SQL="Select A.fksidx, A.whichi_fix, A.alength, A.blength "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
response.write (SQL)&"<br><br><br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  fksidx=Rs(0)
  whichi_fix=Rs(1)
  alength=Rs(2)
  blength=Rs(3)

 
'1:수동도어 계열이라면(편개/양개)
  if whichi_fix="12" or whichi_fix="13" then 
'2:수동픽스유리 계열이라면
  elseif whichi_fix="14" or whichi_fix="15" or whichi_fix="16" or whichi_fix="17" or whichi_fix="18" or whichi_fix="19" or whichi_fix="23" then 
'3:가로바 계열이라면
'4:세로바 계열이라면
'5:세로통바 계열이라면
 end if

'그리고 같은 y좌표를 갖고 있는 자재에도 동일하게 반복 적용한다.

End If
Rs.Close


Response.end
Response.write "<script>alert('측정값이 자동 적용되었습니다.');opener.location.replace('inspector_v2.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"&fksidx="&rfksidx&"&sjb_type_no="&rsjb_type_no&"&greem_f_a="&rgreem_f_a&"');window.close();</script>"
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>