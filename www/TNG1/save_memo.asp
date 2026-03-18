
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"--> 
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

sjidx=Request("sjidx")
pumemo=Request("pumemo")
cidx=Request("cidx")
    
if pumemo<>"" then pumemo=replace(pumemo,chr(13) & chr(10),"<br>") end if

'response.write snidx
'response.end

  SQL=" Delete tk_picmemo where sjidx='"&sjidx&"' "
  DbCon.Execute(SQL)


  SQL=" Insert into tk_picmemo (sjidx, pmemo, pmmidx, pmdate) Values('"&sjidx&"', '"&pumemo&"', '"&c_midx&"', getdate() ) "
  DbCon.Execute(SQL)



response.write "<script>location.replace('TNG1_B_data.asp?cidx="&cidx&"&sjidx="&sjidx&"');</script>"

set Rs=Nothing
call dbClose()

%>


