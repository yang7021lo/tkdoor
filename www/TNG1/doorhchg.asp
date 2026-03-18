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

rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
rfkidx=Request("fkidx")
rsjb_idx=Request("sjb_idx")
gubun=Request("gubun")

SQL="SELECT a.door_w, a.door_h FROM tk_framekSub a WHERE a.fkidx='" &rfkidx& "' AND (gls=1 or gls=2)"
'Response.write (SQL)&"<br>"
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
  door_w = Rs(0)
  door_h = Rs(1)
End If
Rs.Close


if gubun="" then 
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="/taekwang_logo.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <style>
        a:link {
            color: #070707;
            text-decoration: none;
        }
        a:visited {
            color: #070707;
            text-decoration: none;
        }
        a:hover {
            color: #070707;
            text-decoration: none;
        }
    </style>
    <script>
        
        function validateForm(obj){
            if(document.frmMain.door_h.value ==""){
                alert("도어의 높이를 입력해 주세요.");
            return
            }             
            else{
                document.frmMain.submit();
            }
        }
        function validateForm2(fksidx){
          document.getElementById('fksidx').value = fksidx;
          document.getElementById('frmMain2').submit();
        }
    </script>
</head>
<body>

<!--화면시작-->

    <div class="py-3 container text-center">

<!-- 도어 높이변경 시작-->
      <div class="input-group mb-2s">
          <h3>도어높이변경</h3>
      </div>
<form name="frmMain" action="doorhchg.asp" method="post">
<input type="hidden" name="sjidx" value="<%=rsjidx%>">
<input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
<input type="hidden" name="fkidx" value="<%=rfkidx%>">
<input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
<input type="hidden" name="gubun" value="update">
      <div class="input-group mb-2">
          <span class="input-group-text">도어높이</span>
          <input type="text" class="form-control" name="door_h" value="<%=door_h%>">
          <button type="button" class="btn btn-outline-danger" Onclick="validateForm();">적용</button>    
      </div>
<!-- 도어 높이변경 끝--> 
</form>
      <div class="d-flex gap-3">
        <button type="button" class="btn btn-primary" Onclick="location.replace('boonhal.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>');">하바분할 중간소대 추가</button>
        <button type="button" class="btn btn-success" Onclick="location.replace('boonhal.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>');">하바1 중간소개추가</button>
        <button type="button" class="btn btn-warning" Onclick="location.replace('boonhal.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>');">로비폰 추가</button>

      </div>
      </div>    

    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%
elseif gubun="update" then 

rdoor_h=Request("door_h")
SQL="Update tk_framekSub set door_h='"&rdoor_h&"' where fkidx='"&rfkidx&"' "
'Response.write (SQL)&"<br>"
Dbcon.Execute (SQL)

response.write "<script>opener.location.replace('/tng1/TNG1_B_suju.asp?sjidx="&rsjidx&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&sjb_idx="&rsjb_idx&"');window.close();</script>"


end if
%>
<%
set Rs=Nothing
call dbClose()
%>
