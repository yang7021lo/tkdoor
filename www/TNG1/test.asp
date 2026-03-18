<div class="row" style="width: 100%;border: 1px solid black;">
  <!-- 왼쪽 칸 -->
  <div style="width: 300px;">
ㄴㄴㄴㄴ
  </div>
  <div class="col-6" >
<!-- 부속품 선택하기 시작 -->
    <div class="card-container" style="display: flex; justify-content: flex-start;">
      <!-- 반복문으로 이 블럭을 생성 -->
<%
SQL="select A.fksidx, A.xi, A.yi, A.wi, A.hi, A.WHICHI_AUTO, A.WHICHI_FIX "
SQL=SQL&" , A.bfidx, B.set_name_Fix, B.set_name_AUTO "
SQL=SQL&" From tk_framekSub A "
SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
SQL=SQL&" Where A.fksidx='"&rfksidx&"' "
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 

i=i+1
fksidx=Rs(0)
xi=Rs(1)
yi=Rs(2)
wi=Rs(3)
hi=Rs(4)
WHICHI_AUTO=Rs(5)
WHICHI_FIX=Rs(6)
bfidx=Rs(7)
set_name_Fix=Rs(8)
set_name_AUTO=Rs(9)

If bfidx="0" or isnull(bfidx) then 
  set_name_AUTO="없음"
  set_name_Fix="없음"
end if 
%>
<%

  End if
  Rs.close
%> 
<%
SQL=" Select top 6 bfidx, set_name_Fix, set_name_AUTO, whichi_auto, whichi_fix, xsize, ysize, bfimg1, bfimg2, bfimg3 "
SQL=SQL&" , tng_busok_idx, tng_busok_idx2 "
SQL=SQL&" From tk_barasiF "
SQL=SQL&" Where sjb_idx='"&rsjb_idx&"' "
If WHICHI_AUTO <> "0" Then 
SQL = SQL & " AND whichi_auto = '" & WHICHI_AUTO & "' "
End if
If WHICHI_FIX <> "0" Then 
SQL = SQL & " AND whichi_fix = '" & WHICHI_FIX & "' "
End If
'Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
Do while not Rs.EOF
  bfidx=Rs(0)
  set_name_Fix=Rs(1)
  set_name_AUTO=Rs(2)
  whichi_auto=Rs(3)
  whichi_fix=Rs(4)
  xsize=Rs(5)
  ysize=Rs(6)
  bfimg1=Rs(7)
  bfimg2=Rs(8)
  bfimg3=Rs(9)
  tng_busok_idx=Rs(10)
  tng_busok_idx2=Rs(11)
%>


      <div class="card custom-card">
        <div class="card-header"><%=set_name_AUTO%><%=set_name_Fix%></div>
        <div class="card-body">
        <% if bfimg3<>"" then %>
          <img src="/img/frame/bfimg/<%=bfimg3%>" loading="lazy" width="180" height="100"  border="0">
        <% elseif bfimg1<>"" then %>
          <img src="/img/frame/bfimg/<%=bfimg1%>" loading="lazy" width="180" height="100"  border="0">
        <% end if %>
        </div>
      </div>
     
     
<%
  Rs.movenext
  Loop
  End if
  Rs.close
%> 
    </div>

  </div>
</div>