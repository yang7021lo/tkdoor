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
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")

rksearchword=Request("ksearchword")
rSearchWord=Request("SearchWord")
kgotopage=Request("kgotopage")
gotopage=Request("gotopage")
rbfidx=Request("bfidx")
rsjb_idx=Request("sjb_idx")
rSJB_TYPE_NO=Request("SJB_TYPE_NO")
SQL="Select bfimg1, bfimg2 , bfimg3 from tk_barasiF where bfidx='"&rbfidx&"' "
Rs.open Sql,Dbcon
If Not (Rs.bof or Rs.eof) Then 
  bfimg1=Rs(0)
  bfimg2=Rs(1)
  bfimg3=Rs(2)
End If
Rs.close
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap 기본 템플릿</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

    <div class="container">
        <div class="row">
            <div class="col-md-4">

              <% if bfimg3<>""   then %>
                <a href="TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>#<%=rbfidx%>" target="_parent">
                <img src="/img/frame/bfimg/<%=bfimg3%>" width="200" height="200"  border="0" loading="lazy"></a>
              <% elseif bfimg1<>"" then %>
                <a href="TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>#<%=rbfidx%>" target="_parent">
                <img src="/img/frame/bfimg/<%=bfimg1%>" width="200" height="200"  border="0" loading="lazy"></a>
   
              <% else %>
              <div class="card card-body text-start"><!-- *SVG 코드 시작 -->
                    <a href="TNG1_JULGOK_PUMMOK_LIST1.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&sjb_idx=<%=rsjb_idx%>&bfidx=<%=rbfidx%>#<%=rbfidx%>" id="svgLink" target="_parent">
                        <svg id="mySVG" viewbox="0 0 250 250"  fill="none" stroke="#000000" stroke-width="1" >
                            <%
                            SQL="select baidx from tk_barasi A where bfidx='"&rbfidx&"' "
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                                rbaidx=Rs(0)
                            End If
                            Rs.close


                            SQL="Select basidx, bassize, basdirection, x1, y1, x2, y2, accsize,idv from tk_barasisub where baidx='"&rbaidx&"' order by basidx asc "
                            ''response.write (SQL)&"<br>"
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                            Do while not Rs.EOF
                            basidx=Rs(0)
                            bassize=Rs(1)
                            basdirection=Rs(2)
                            x1=Rs(3)
                            y1=Rs(4)
                            x2=Rs(5)
                            y2=Rs(6)
                            accsiz=Rs(7)
                            idv=Rs(8)
                        
                            textv=bassize+idv

                            'response.write  bassize&"/"&basdirection&"<br>"
                            if bassize>30 then 
                                bojngv=-10
                            end if  

                            if basdirection="1" then 
                                tx1=x1+(bassize/2)
                                ty1=y1-1
                            elseif basdirection="2" then 
                                tx1=x1-5
                                ty1=y1+(bassize/2)+bojngv+10
                            elseif basdirection="3" then 
                                tx1=x1-(bassize/2)
                                ty1=y1+5
                            elseif basdirection="4" then 
                                tx1=x1+5
                                ty1=y1-(bassize/2)+bojngv+10
                            end if
                            %>
                            <line x1="<%=x1%>" y1="<%=y1%>" x2="<%=x2%>" y2="<%=y2%>" />
                            <%
                            if bassize=int(bassize) then
                            bassize_int=FormatNumber(bassize,0)
                            else 
                            bassize_int=FormatNumber(bassize,1)
                            end if
                            %>
                            <text x="<%=tx1%>" y="<%=ty1%>" fill="#000000" font-size="12" text-anchor="middle"><%=bassize_int%></text>   
                            <%
                            Rs.movenext
                            Loop
                            End if
                            Rs.close
                            %> 
                        </svg>
                    </a>
              <% end if %>
            </div>
        </div>
    </div>

 
    <!-- Bootstrap JS (Popper 포함) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!--[svg-pan-zoom.js](https://github.com/ariutta/svg-pan-zoom)는 SVG 요소에 드래그 이동과 마우스 휠 확대/축소 기능을 쉽게 붙일 수 있는 라이브러리입니다. -->
<script src="https://cdn.jsdelivr.net/npm/svg-pan-zoom@3.6.1/dist/svg-pan-zoom.min.js"></script>
<script>
  // svg-pan-zoom 초기화
  svgPanZoom('#mySVG', {
    zoomEnabled: true,
    controlIconsEnabled: true,
    fit: true,
    center: true
  });
</script>
<script>
  document.querySelectorAll('a').forEach(function(link) {
    // 휠 클릭 막기: 마우스 눌렀을 때
    link.addEventListener('mousedown', function(e) {
      if (e.button === 1) {
        e.preventDefault();
      }
    });

    // 휠 클릭 막기: 마우스 뗄 때
    link.addEventListener('mouseup', function(e) {
      if (e.button === 1) {
        e.preventDefault();
      }
    });

    // 휠 클릭 막기: 브라우저 전용 이벤트
    link.addEventListener('auxclick', function(e) {
      if (e.button === 1) {
        e.preventDefault();
      }
    });
  });
</script>
</body>
</html>


<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>