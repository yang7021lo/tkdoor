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

rcidx=request("cidx")
rsjidx=request("sjidx") '수주키 TB TNG_SJA
rsjsidx=request("sjsidx") '견적 키
rsjb_type_no=request("sjb_type_no") '품목키

gubun=request("gubun")
SQL=" select mwidth, mheight from tng_sjaSub where sjsidx='"&rsjsidx&"'"
Rs.Open sql, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then 
  mwidth=Rs(0)
  mheight=Rs(1)
Else
  mwidth="0"
  mheight="0"
End If
Rs.Close

if gubun="" then 
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>크기 입력</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

  <div class="container" style="margin-top: 10px;">
    <div class="card shadow-sm p-4">
      <h4 class="mb-4 text-center">전체 가로/세로 입력</h4>

      <form id="sizeForm" action="totalsize.asp" method="post">
        <input type="hidden" name="cidx" value="<%=rcidx%>">
        <input type="hidden" name="sjidx" value="<%=rsjidx%>">
        <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
        
        <% if rsjsidx<>"" then %>
        <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
        <input type="hidden" name="gubun" value="up1date">
        <% else %>
        <input type="hidden" name="gubun" value="in1sert">
        <% end if %>
        <div class="d-flex align-items-end gap-3 mb-3">
          <div>
            <label for="width" class="form-label">가로값 (px)</label>
            <input type="number" class="form-control" id="mwidth" name="mwidth" value="<%=mwidth%>" placeholder="예: 800" required>
          </div>
          <div>
            <label for="height" class="form-label">세로값 (px)</label>
            <input type="number" class="form-control" id="mheight" name="mheight" value="<%=mheight%>" placeholder="예: 600" required>
          </div>
        </div>

        <div class="d-grid">
          <button type="submit" class="btn btn-primary">저장</button>
        </div>
      </form>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<%
elseif gubun="in1sert" then 
  rmwidth=Request("mwidth")
  rmheight=Request("mheight")

  'response.write rmwidth&"<br>"
  'response.write rmheight&"<br>"

  SQL="Insert into tng_sjaSub (sjidx, midx, mwdate, meidx, mewdate, mwidth, mheight, qtyidx, sjsprice, disrate, disprice, fprice) "
  SQL=SQL&" values ('"&rsjidx&"', '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '"&rmwidth&"', '"&rmheight&"', '0', '0', '0', '0', '0')"
  'Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  SQL="Select max(sjsidx) from tng_sjaSub "
  'Response.write (SQL)&"<br>"
  Rs.open Sql,Dbcon
    rsjsidx=Rs(0)
  Rs.Close
  response.write "<script>opener.location.replace('TNG1_B_suju.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"');window.close();</script>"

elseif  gubun="up1date" then 
  rmwidth=Request("mwidth")
  rmheight=Request("mheight")

  'response.write rmwidth&"<br>"
  'response.write rmheight&"<br>"
  SQL="Update tng_sjaSub set mwidth='"&rmwidth&"', mheight='"&rmheight&"' Where sjsidx='"&rsjsidx&"' "
  Response.write (SQL)&"<br>"
  Dbcon.Execute (SQL)

  response.write "<script>opener.location.replace('TNG1_B_suju.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"');window.close();</script>"

end if 
%>
<%
set RsC=Nothing
set Rs=Nothing
call dbClose()
%>
