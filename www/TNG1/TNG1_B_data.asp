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

    listgubun="one"
    projectname=""
%>
 
<%
    sjidx=request("sjidx")
    cidx=Request("cidx")
 
	page_name="TNG1_B_data.asp?"

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
    <link rel="icon" type="image/x-icon" href="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png/v1/fill/w_32%2Ch_32%2Clg_1%2Cusm_0.66_1.00_0.01/76309f_8e7375b143214fe6aacc29b2d266d396%7Emv2.png" />
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>
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
      #text {
        color: #070707;
      }
      #mmaintext {
        height: 200px;
      }      
      #download {
        width: 100px;
      }
      .container {
      display: flex;
      flex-direction: row; /* side by side */
      flex-wrap: wrap; /* allows wrapping if too narrow */
      gap: 10px;
    }
    </style>
    <script>
        function confirmDelete(puidx, cidx, pufile) {
        if (confirm("사진을 삭제하시겠습니까?")) {
            location.replace("picdelete.asp?puidx=<%=puidx%>&cidx=<%=cidx%>&pufile=<%=pufile%>&sjidx=<%=sjidx%>");
        }
        }
    </script>
  </head>
<body class="sb-nav-fixed">

    <div id="layoutSidenav_content">
        <main>
            <div class="container-fluid px-4">
                <div class="row justify-content-between">
                <!--내용입력시작-->
                    <div class=" py-5 text-center card-body">

                            <div class="input-group mb-3">
                                <h6>견적서 기초 자료</h6>
                            </div>
                            <div class="input-group mb-2">
                                <div class="card form-control">
                                    <table id="datatablesSimple" class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th align="center">첨부된 파일</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                            SQL="SELECT pfname from tk_picfiles Where sjidx='"&sjidx&"' and pfstatus='1' "
                                            Set Rs=dbcon.execute (SQL)
                                            If not (Rs.BOF or Rs.EOF) then
                                            Do while not Rs.EOF
                                                pfname=RS(0)
                                            %>
                                                <tr>
                                                    <td><%=pfname%></td>
                                                </tr>
                                            <%
                                            Rs.movenext
                                            Loop
                                            End if
                                            Rs.close
                                            %>
                                        </tbody>  
                                        </table> 
                                    </div>
                            </div>
                            <div class="input-group mb-2">
                                <div class="card form-control border-0">
                                    <form name="sendfile" action="save_file.asp" method="post" ENCTYPE="multipart/form-data">
                                        <div class="input-group mb-2">
                                            <input type="hidden" name="sjidx" value="<%=sjidx%>">
                                            <input type="hidden" name="cidx" value="<%=cidx%>">
                                            <input type="file" class="form-control" name="pfname" multiple>
                                            <button type="button" class="btn btn-outline-primary" Onclick="submit();">파일저장</button>
                                        </div>
                                    </form> 
                                </div>
                            </div>
                            <%
                            SQL=" Select pmemo from tk_picmemo "
                            SQL=SQL&" Where sjidx='"&sjidx&"' "

                            'response.write (SQL)
                            Rs.open Sql,Dbcon
                            If Not (Rs.bof or Rs.eof) Then 
                                pmemo=Rs(0)
                            End if
                            Rs.close

                            if pmemo<>"" then pmemo=replace(pmemo,"<br>",chr(13)) end if
                            %> 
                            <form name="sendmemo" action="save_memo.asp" method="post">
                                <input type="hidden" class="form-control" name="sjidx" value="<%=sjidx%>">
                                <input type="hidden" class="form-control" name="cidx" value="<%=cidx%>">

                                <div class="input-group mb-2 d-flex justify-content-center">
                                    <div class="input-group mb-2">
                                        <span class="input-group-text">메모</span>
                                        <textarea id="pumemo" class="form-control" name="pumemo" rows="4"><%=pmemo%></textarea>
                                    </div>
                                    <div class="d-flex justify-content-center input-group mb-2">
                                        <button type="button" class="btn btn-outline-success mb-3" Onclick="submit();">📝 메모 저장</button>
                                    </div>
                                </div>
                            </form>

                            <div class="d-flex">
                                    <%
                                    SQL=" Select pufile, puidx from tk_picupload "
                                    SQL=SQL&" Where sjidx='"&sjidx&"' and pustatus='1' "

                                    'response.write (SQL)
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do while not Rs.EOF
                                        pufile=Rs(0)
                                        puidx=Rs(1)

                                    %>
                                    <div class="container">
                                        <img src="/img/frame/pufile/<%=sjidx%>/<%=pufile%>" width="20%">                                    
                                    </div>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End if
                                    Rs.close
                                    %> 
                                    <%
                                    SQL=" Select pfname, pfidx from tk_picfiles "
                                    SQL=SQL&" Where pffiletype='0' and sjidx='"&sjidx&"' and pfstatus='1' "

                                    'response.write (SQL)
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do while not Rs.EOF
                                        pfname=Rs(0)
                                        pfidx=Rs(1)

                                    %>
                                    <div class="container">
                                        <img src="/img/frame/pufile/<%=sjidx%>/<%=pfname%>" width="20%">                                    
                                    </div>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End if
                                    Rs.close
                                    %> 
                                    <%
                                    SQL=" Select pfname, pfidx from tk_picfiles "
                                    SQL=SQL&" Where pffiletype='1' and sjidx='"&sjidx&"' and pfstatus='1' "

                                    'response.write (SQL)
                                    Rs.open Sql,Dbcon
                                    If Not (Rs.bof or Rs.eof) Then 
                                    Do while not Rs.EOF
                                        pfname=Rs(0)
                                        pfidx=Rs(1)

                                    %>
                                    <div class="container">
                                        <iframe src="/img/frame/pufile/<%=sjidx%>/<%=pfname%>" width="20%"></iframe>                                   
                                    </div>
                                    <%
                                    Rs.movenext
                                    Loop
                                    End if
                                    Rs.close
                                    %> 
                            </div>                                                     
                            <div>

                                <div id="imageList"></div>
                                <p id="status"></p>

                                <form id="hiddenForm" enctype="multipart/form-data" method="post" style="display:none;">
                                    <input type="file" id="uploadFile" name="pufile" accept="image/*">
                                </form>

                                <div id="imageList" style="display: flex; flex-wrap: wrap; gap: 10px;"></div>
                                    <script>
                                    document.addEventListener('paste', function (event) {
                                        const items = (event.clipboardData || window.clipboardData).items;
                                        const imageList = document.getElementById('imageList');

                                        for (let i = 0; i < items.length; i++) {
                                        if (items[i].type.indexOf('image') !== -1) {
                                            const file = items[i].getAsFile();
                                            const reader = new FileReader();

                                            // Preview multiple images
                                            reader.onload = function (e) {
                                            const img = document.createElement('img');
                                            img.src = e.target.result;
                                            img.style.width = '150px';
                                            img.style.height = 'auto';
                                            img.style.border = '1px solid #ccc';
                                            img.style.padding = '4px';
                                            imageList.appendChild(img);
                                            };
                                            reader.readAsDataURL(file);

                                            // Upload each file
                                            const formData = new FormData();
                                            formData.append('pufile', file);

                                            fetch('upload_paste_data.asp?sjidx=<%=sjidx%>', {
                                            method: 'POST',
                                            body: formData
                                            })
                                            .then(res => res.text())
                                            .then(text => {
                                            document.getElementById('status').innerText = '✅ 업로드 완료: ' + text;
                                            })
                                            .catch(err => {
                                            document.getElementById('status').innerText = '❌ 업로드 실패: ' + err;
                                            });
                                        }
                                        }
                                    });
                                    </script>
                            </div>
                    </div>

                    <div class="row justify-content-center">
                        <div class="col-auto text-center">
                            <h2>Ctrl + V로 이미지를 붙여넣으세요</h2>
                            <p>붙여넣은 이미지를 서버에 자동 업로드합니다.</p>
                        </div>
                    </div>
                    <!--입력종료-->
                </div>
            </div>
        </main>

        <!--Footer 시작-->
        Coded By 원준 
        <!--Footer 끝-->

    </div>
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
