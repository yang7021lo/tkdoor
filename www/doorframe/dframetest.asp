<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!-- 외도어기본 도면 시작 -->          
            <svg width="1000" height="600"  fill="none" stroke="#000000" stroke-width="1" xmlns="http://www.w3.org/2000/svg">
                <rect x="80" y="35" width="10" height="300" /><!-- 좌측자동홈바 -->
                <rect x="560" y="35" width="10" height="300" /><!-- 우측자동홈바 -->
                <rect x="320" y="75" width="15" height="265" /><!-- 중간소대 -->

                <rect x="90" y="35" width="470" height="40" /><!-- 상바 -->
                <rect x="90" y="250" width="210" height="40" /><!-- 걸레받이 -->    

                <line x1="80" y1="5" x2="80" y2="28" /></line>
                <line x1="80" y1="15" x2="230" y2="15" stroke-dasharray="5" /></line>
                <text x="320" y="20" fill="#000000" font-size="14" text-anchor="middle">가로외경 : <%=FormatNumber(oinsw,0)%>mm</text>   
                <line x1="570" y1="5" x2="570" y2="28"/></line>
                <line x1="400" y1="15" x2="570" y2="15" stroke-dasharray="5" /></line>

                <line x1="48" y1="35" x2="75" y2="35" /></line>
                <line x1="60" y1="35" x2="60" y2="140" stroke-dasharray="5" /></line>
                <text x="40" y="170" fill="#000000" font-size="14" text-anchor="middle">외경높이</text> 
                <text x="40" y="190" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(oinsh,0)%>mm</text> 
                <line x1="48" y1="335" x2="75" y2="335" /></line>
                <line x1="60" y1="200" x2="60" y2="335" stroke-dasharray="5" /></line>

                <line x1="575" y1="35" x2="603" y2="35" /></line>
                <text x="605" y="60" fill="#000000" font-size="14" text-anchor="middle">230박스</text> 
                <line x1="575" y1="75" x2="603" y2="75" /></line>
                <line x1="590" y1="75" x2="590" y2="170" stroke-dasharray="5" /></line>
                <text x="605" y="190" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(odinsh,0)%>mm</text> 
                <line x1="590" y1="200" x2="590" y2="315" stroke-dasharray="5" /></line>
                <line x1="575" y1="315" x2="603" y2="315" /></line>
                <text x="610" y="330" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(obitg,0)%>mm&nbsp;묻힘</text> 
                <line x1="575" y1="335" x2="603" y2="335" /></line>

                <text x="190" y="130" fill="#000000" font-size="14" text-anchor="middle">좌픽스유리</text> 
                <text x="190" y="150" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(ofixgw,0)%>mm &times<%=FormatNumber(ofixgh,0)%>mm</text> 

                <text x="190" y="270" fill="#000000" font-size="14" text-anchor="middle">걸레받이 치수</text> 
                <text x="190" y="285" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(baseboard,0)%>mm</text> 

                <text x="430" y="130" fill="#000000" font-size="14" text-anchor="middle">도어유리치수</text> 
                <text x="430" y="150" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(odoorgw,0)%>mm &times<%=FormatNumber(odoorgh,0)%>mm</text> 

                <text x="430" y="270" fill="#000000" font-size="14" text-anchor="middle">오픈사이즈</text> 
                <!-- (검측x-90-65)/2 -->
                <text x="430" y="285" fill="#000000" font-size="14" text-anchor="middle"><%=FormatNumber(opensize,0)%>mm</text> 


            </svg>
<!-- 외도어기본 도면 끝 -->
