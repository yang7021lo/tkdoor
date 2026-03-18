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
                        sjsidx="65"

                        SQL="Select A.fkidx, B.fksidx, B.xi, B.yi, B.wi, B.hi ,C.set_name_Fix, C.set_name_AUTO, A.sjb_idx, fstype"
                        SQL=SQL&" from tk_framek A "
                        SQL=SQL&" Join tk_framekSub B On A.fkidx=B.fkidx "
                        SQL=SQL&" Left OUter Join tk_barasiF C On B.bfidx=C.bfidx "
                        SQL=SQL&" Where A.sjsidx='"&sjsidx&"' "
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
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="url(#diagonalHatch)" stroke="black" stroke-width="2" />
                        <% else %>
                            <rect x="<%=xi%>" y="<%=yi%>" width="<%=wi%>" height="<%=hi%>" fill="<%=fill_text%>" stroke="<%=stroke_text%>" stroke-width="1" />
                        <% end if %>
                            <text x="<%=xi+10%>" y="<%=yi+15%>" font-family="Arial" font-size="14" fill="#000000" style="<%=text_direction%>"><%=set_name_Fix%><%=set_name_AUTO%></text>
                            <line x1="<%=100%>" y1="<%=100%>" x2="<%=100%>" y2="<%=23%>"></line>
                            <line x1="<%=xi+100%>" y1="15" x2="<%=xi+wi+100%>" y2="15" stroke-dasharray="5"></line>
                            <line x1="<%=xi+100%>" y1="<%=yi+100%>" x2="<%=xi+100%>" y2="<%=yi+23%>"></line>
                        <%
                        Rs.movenext
                        Loop
                        End if
                        Rs.close
                        %>   
                    <line x1="1000" y1="250" x2="1000" y2="24"></line>                    
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
call dbClose()
%>
