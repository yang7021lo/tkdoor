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


rsjcidx  = Request("sjcidx")
rsjmidx  = Request("sjmidx")
rsjidx   = Request("sjidx")
rsjsidx  = Request("sjsidx")
memo = Request("memo")
mode  = Request("mode")

if mode = "save"  then

    SQL=" update tng_sja set memo='"&memo&"' where sjidx='"&rsjidx&"' "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

' 저장 후 부모창 새로고침 + 팝업 닫기
    Response.Write "<script>"
    Response.Write "if(window.opener && !window.opener.closed){window.opener.location.reload();}"
    Response.Write "window.close();"
    Response.Write "</script>"
    call dbClose()
    Response.End

end if

%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title><%=projectname%></title>
    <link rel="icon" sizes="image/x-icon" href="/taekwang_logo.svg">
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
    <style>
  body { margin:16px; font-family:system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR", Arial, sans-serif; }
  .wrap { display:flex; flex-direction:column; gap:12px; }
  .title { font-size:16px; font-weight:600; }
  textarea {
    width:100%; height:280px; padding:10px; box-sizing:border-box;
    border:1px solid #ccc; border-radius:8px; font-size:14px; line-height:1.5;
  }
  .row { display:flex; align-items:center; justify-content:space-between; }
  .btns { display:flex; gap:8px; }
  button {
    padding:8px 14px; border-radius:8px; border:1px solid #c0c0c0; cursor:pointer; font-size:14px;
  }
  .btn-primary { background:#222; color:#fff; border-color:#222; }
  .muted { color:#888; font-size:12px; }
</style>
    
</head>
<body>
 <div class="wrap">
    <div class="title">메모 입력</div>
<%
'=============
    memo = ""
    SQL="select memo  "
    SQL=SQL&" From tng_sja where sjidx='"&rsjidx&"' "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
      memo=Rs(0)
    End if
    RS.Close

%>
    <form method="post" action="tng1_b_meno_pop.asp">
      <input type="hidden" name="mode"   value="save">
      <input type="hidden" name="sjcidx" value="<%=rsjcidx%>">
      <input type="hidden" name="sjmidx" value="<%=rsjmidx%>">
      <input type="hidden" name="sjidx"  value="<%=rsjidx%>">
      <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">

     <textarea name="memo" id="memo"><%=memo%></textarea>
      <div class="btns">
        <button type="submit" class="btn-primary">저장</button>
        <button type="button" onclick="window.close()">닫기</button>
      </div>
    </form>
  </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
</body>
</html>

<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
