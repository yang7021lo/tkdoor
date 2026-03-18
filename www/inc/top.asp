<%

' 현재 접속 URL 프로토콜 구성
'Dim sProtocol, sHost, sPort, sPath, sQuery, sFullUrl

If Request.ServerVariables("HTTPS") = "on" Then
    sProtocol = "https://"
Else
    sProtocol = "http://"
End If

' 호스트 및 포트
sHost = Request.ServerVariables("HTTP_HOST")
sPort = Request.ServerVariables("SERVER_PORT")

' 포트번호가 기본값이 아니라면 포트 포함
If (sProtocol = "http://" And sPort <> "80") Or (sProtocol = "https://" And sPort <> "443") Then
    sHost = sHost & ":" & sPort
End If

' 경로 및 쿼리스트링
sPath = Request.ServerVariables("SCRIPT_NAME")
sQuery = Request.ServerVariables("QUERY_STRING")

' 최종 URL 조합
If sQuery <> "" Then
    sFullUrl = sProtocol & sHost & sPath & "?" & sQuery
Else
    sFullUrl = sProtocol & sHost & sPath
End If

' 변수에 저장 (필요 시 Session 또는 DB 저장 가능)
'Dim currentUrl
currentUrl = sFullUrl

' 최근 10개 접속주소 이전 리스트 삭제
SQL=" Delete From tk_url Where urlmidx='"&c_midx&"' "
SQL=SQL&" and urlidx not in (Select top 10 urlidx FRom tk_url where urlmidx='"&c_midx&"' order by urlidx desc) "
'Response.Write sql & "<br>"
'Response.End
Dbcon.Execute(SQL)

rmaxurlidx=Request("maxurlidx")

if rmaxurlidx="" then 
SQL="Insert into tk_url (urlmidx, urllink, urlstatus, urlwdate) values ('"&c_midx&"', '"&currentUrl&"', '1', getdate())"
'Response.Write sql & "<br>"
'Response.End
Dbcon.Execute(SQL)
end if 


if rmaxurlidx="" then 
  SQL="Select max(urlidx) From tk_url Where urlmidx='"&c_midx&"' "
  Rs.Open sql, dbcon
  if not (Rs.EOF or Rs.BOF ) then
    rmaxurlidx=Rs(0)
  end if
  Rs.Close
end if 

'REsponse.write "<br><br><br><br>"
SQL="Select top 1 urlidx, urllink From tk_url Where urlmidx='"&c_midx&"' and urlidx<'"&rmaxurlidx&"' order by urlidx desc"
'Response.write (SQL)&"<br>"
Rs.Open sql, dbcon
if not (Rs.EOF or Rs.BOF ) then
  urlidx=Rs(0)
  urllink=Rs(1)
  count = 0
  For i = 1 To Len(urllink)
      If Mid(urllink, i, 1) = "?" Then
          count = count + 1
      End If
  Next

  if count="0" then 
    urllink=urllink&"?maxurlidx="&urlidx
  Else
    urllink=urllink&"&maxurlidx="&urlidx
  end if  

end if
Rs.Close


'REsponse.write count&"<br>"
'REsponse.write urllink&"<br>"

%>    
        <nav class="sb-topnav navbar navbar-expand navbar-light bg-light">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href=""><%=projectname%></a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
<!-- 
<button type="button" class="btn btn-secondary " onClick="location.replace('/mes/mes1.asp');">도어</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/mes/mes2.asp');">보호대</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/mes/mes2.asp');">자동문</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/mes/pummok_door.asp');">품목등록</button>&nbsp;
 <button type="button" class="btn btn-secondary" onClick="location.replace('/erp/erp1.asp');">ERP1</button>&nbsp; -->
<!-- <button type="button" class="btn btn-secondary" onClick="location.replace('/erp/erp2.asp');">ERP2</button>&nbsp; -->
<!-- <button type="button" class="btn btn-secondary" onClick="location.replace('/doc/doc1.asp');">DOC1</button>&nbsp; -->
<!-- <button type="button" class="btn btn-secondary" onClick="location.replace('/doc/doc2.asp');">DOC2</button>&nbsp; -->
<button type="button" class="btn btn-secondary" onClick="location.replace('/TNG1/TNG1_sujulist.asp');">프레임</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/report/totalreport.ASP');">성적서</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/cyj/corplist.ASP');">기초정보</button>&nbsp; 
<button type="button" class="btn btn-secondary" onClick="location.replace('http://tkd001.cafe24.com/TNG_WMS/DASHBOARD/TNG_WMS_DASHBOARD.asp?ymd=&sjcidx=&sjmidx=');">WMS</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/TNG_bom/bom3/bom3_main.asp');">BOM</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/TNG2/gaebal/door_load_calculator.asp');">R&D</button>&nbsp;
<button type="button" class="btn btn-secondary" onClick="location.replace('/TNG1/dev_architecture.asp');">시스템설계</button>&nbsp;
<button type="button" class="btn btn-dark" onClick="location.replace('<%=urllink%>');">뒤로가기</button>&nbsp; 




 
         
            <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0" method="post" action="/cyj/corplist.asp?listgubun=<%=listgubun%>&subgubun=<%=subgubun%>" name="searchForm1">
                <div class="input-group">
                                    <div class="input-group">
                                        <input class="form-control" type="text" placeholder="거래처조회" aria-label="거래처조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
                                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm1.submit();"><i class="fas fa-search"></i></button>
                                    </div>
                </div>
            </form>
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#!">MES</a></li>
                        <li><a class="dropdown-item" href="#!">ERP</a></li>
                        <li><a class="dropdown-item" href="#!">문서</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item" href="/inc/logOut.asp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
        </nav>