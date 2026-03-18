
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
Set Rs1 = Server.CreateObject("ADODB.Recordset")


gubun=Request("gubun")
rsjidx=Request("sjidx")
rsjsidx=Request("sjsidx")
if rsjidx="" then rsjidx="21" end if
if rsjsidx="" then rsjsidx="67" end if

if gubun="reverse" and rsjidx<>"" and rsjsidx<>"" then 

'기존 값이 있다면 초기화 하기
  SQL="Select * From tk_reverse where revsjsidx='"&rsjsidx&"' "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 

    SQL="Delete From tk_reverse Where revsjsidx='"&rsjsidx&"' "
    Response.write (SQL)&"<br>"
    'response.end
    'dbCon.execute (SQL)

  End If
  Rs.Close

'가장 왼쪽의 바부터 tk_reverse TB에 넣기 시작
  SQL="Select B.fksidx, B.xi, B.yi, B.wi, B.hi "
  SQL=SQL&" from tk_framek A "
  SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
  SQL=SQL&" Where A.sjidx='"&rsjidx&"' and A.sjsidx='"&rsjsidx&"' "
  SQL=SQL&" order by B.xi asc, B.yi asc "
  Response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF

    fksidx=Rs(0)
    xi=Rs(1)
    yi=Rs(2)
    wi=Rs(3)
    hi=Rs(4)
    ody = ody + 1

    SQL=" Insert into tk_reverse (revsjidx, revsjsidx, revfksidx, revxi, revyi, revwi, revhi, revstatus, ody ) "
    SQL=SQL&" values ('"&rsjidx&"', '"&rsjsidx&"', '"&fksidx&"', '"&xi&"', '"&yi&"', '"&wi&"', '"&hi&"', '0', '"&ody&"' ) "
    'Response.write (SQL)&"<br>"
    'response.end
    'dbCon.execute (SQL)

  Rs.movenext
  Loop
  End if
  Rs.close
'가장 왼쪽의 바부터 tk_reverse TB에 넣기 끝

'반전 적용 시작

  '시작좌표 찾기 시작
  SQL="Select top 1 revxi, revyi From tk_reverse Where revsjidx='"&rsjidx&"' and revsjsidx='"&rsjsidx&"' Order by revxi asc,  revyi asc"
  Response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    stxi=Rs(0)
    styi=Rs(1)
  End if
  Rs.Close


  '시작좌표 찾기 끝
  SQL="Select revidx, revfksidx, revxi, revyi, revwi, revhi, revstatus, ody "
  SQL=SQL&" From tk_reverse "
  SQL=SQL&" Where revsjidx='"&rsjidx&"' and revsjsidx='"&rsjsidx&"' "
  SQL=SQL&" Order by ody desc "
  Response.write (SQL)&"<br><br>"
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
  Do while not Rs.EOF
    revidx=Rs(0)
    revfksidx=Rs(1)
    revxi=Rs(2)
    revyi=Rs(3)
    revwi=Rs(4)
    revhi=Rs(5)
    revstatus=Rs(6)
    ody=Rs(7)
    j=j+1
    pody=ody+1

response.write j&"/"&revxi&"/"&revyi&"/"&revwi&"/"&revhi&"<br>"
    if j="1" then '첫레코드라면
      revxi=stxi
      revyi=styi

      SQL="Update tk_framekSub set xi='"&revxi&"' Where fksidx='"&revfksidx&"' "
      Response.write (SQL)&"<br><br>"
      'response.end
      'dbCon.execute (SQL)

    else  '두번째 레코드부터
      SQL="Select A.xi, A.wi From tk_framekSub A Join tk_reverse B On A.fksidx=B.revfksidx where B.ody='"&pody&"' "
      Response.write (SQL)&"<br>"
      Rs1.open Sql,Dbcon
      If Not (Rs1.bof or Rs1.eof) Then 
        nrevxi=Rs1(0) '이번 바의 x좌표값
        nrevwi=Rs1(1) '이전 바의 w가로 길이값
        revxi=nrevxi+nrevwi '현재 바의 x좌표값

        SQL="Update tk_framekSub set xi='"&revxi&"' Where sjsidx='"&rsjsidx&"' and xi='"&revxi&"' "
        Response.write (SQL)&"<br><br>"
        'response.end
        'dbCon.execute (SQL)

      End If
      Rs1.Close


    end if


  Rs.movenext
  Loop
  End if
  Rs.close
'반전적용 끝
end if
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="icon" type="image/x-icon" href="http://devkevin.cafe24.com/wscorp/wslogo.png">
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
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">
<!-- 버튼 형식 시작--> 
        <div class="input-group mb-3">
            <button type="button" class="btn btn-outline-danger" Onclick="location.replace('freverse.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&gubun=reverse');">반전</button>      
        </div>
<!-- 버튼 형식 끝--> 
<!-- svg 나오는 부분 시작-->

            <div class="canvas-container" id="svgCanvas" style="width: 100%; height: 100%; padding: 10px;">
                <div class="svg-container">
                    <svg id="canvas" width="100%" height="100%" class="d-block">
                    <g id="viewport" transform="translate(0, 0) scale(1)">
                    <rect id="rectangle" fill="white" stroke="black" stroke-width="1" width="0" height="0"></rect>
                    <circle id="resize-handle" class="resize-handle" cx="0" cy="0"></circle>
                    <text id="width-label" class="dimension-label"></text>
                    <text id="height-label" class="dimension-label"></text>
                    
                        <%

                        SQL="Select A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi ,C.set_name_Fix, C.set_name_AUTO, A.sjb_idx, fstype"
                        SQL=SQL&" from tk_framek A "
                        SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
                        SQL=SQL&" Left OUter Join tk_barasiF C On B.bfidx=C.bfidx "
                        SQL=SQL&" Where A.sjidx='"&rsjidx&"' and A.sjsidx='"&rsjsidx&"' "
                        'Response.write (SQL)&"<br>"
                        Rs.open Sql,Dbcon
                        If Not (Rs.bof or Rs.eof) Then 
                        Do while not Rs.EOF
                            i=i+1
                            fkidx=Rs(0)
                            fksidx=Rs(1)
                            xi=Rs(2)
                            yi=Rs(3)
                            wi=Rs(4)
                            hi=Rs(5)
                            set_name_Fix=Rs(6)
                            set_name_AUTO=Rs(7)
                            sjb_idx=Rs(8)
                            fstype=Rs(9)

                            if rfksidx="" then rfksidx="0" end if
                            if cint(fksidx)=cint(rfksidx) then 
                              stroke_text="#696969"
                              fill_text="#BEBEBE"
                            else
                              if cint(fkidx)=cint(rfkidx) then 
                                if fstype="1" then '유리라면
                                    stroke_text="#779ECB"
                                    fill_text="#ADD8E6"
                                  else 
                                    stroke_text="#D3D3D3"
                                    fill_text="#EEEEEE"
                                  end if
                              else
                                if fstype="1" then '유리라면
                                  stroke_text="#779ECB"
                                  fill_text="#ADD8E6"
            
                                else 
                                    stroke_text="#A9A9A9"
                                    fill_text="white"
                                end if 
                              end if

                            end if

                        if Cint(hi) > Cint(wi) then 
                          text_direction="writing-mode: vertical-rl; glyph-orientation-vertical: 0;"
                        else
                          text_direction=""
                        end if 
                        %>
<% if fstype="2" then %>
    <defs>
      <pattern id="diagonalHatch" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
        <line x1="0" y1="0" x2="0" y2="8" stroke="black" stroke-width="2" />
      </pattern>
    </defs>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" onclick="location.replace('tng1b_suju2.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>&fksidx=<%=fksidx%>');"/>
<% else %>
                        <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" onclick="location.replace('tng1b_suju2.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&sjb_idx=<%=sjb_idx%>&fkidx=<%=fkidx%>&fksidx=<%=fksidx%>');"/>
<% end if %>
                        <text x="<%=xi+10%>" y="<%=yi+15%>" font-family="Arial" font-size="14" fill="#000000" style="<%=text_direction%>"><%=set_name_Fix%><%=set_name_AUTO%></text>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>   
                    </g>    
                    </svg>
                </div>
            </div>
<!-- svg 나오는 부분 끝-->

 
    </div>    

<!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>

<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>
