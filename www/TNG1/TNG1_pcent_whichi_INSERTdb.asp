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

part=Request("part")
mode=Request("mode")
rpidx=Request("pidx")
' 파일 및 폼 데이터 읽기
gotopage = Request("gotopage")
rWHICHI_FIX       = Request("WHICHI_FIX") '이건 이제 필요가 없음
rWHICHI_FIXname   = Request("WHICHI_FIXname")
rWHICHI_AUTO      = Request("WHICHI_AUTO") '이건 이제 필요가 없음
rWHICHI_AUTOname  = Request("WHICHI_AUTOname")
rmin_ysize        = Request("min_ysize")
rmax_ysize        = Request("max_ysize")
rpcent            = Request("pcent")
rpstatus         = Request("pstatus")

rSearchWord       = Request("SearchWord")


'Response.Write "rmin_ysize=" & rmin_ysize & "<br>"
'Response.Write "rmax_ysize=" & rmax_ysize & "<br>"
'Response.Write "rpcent=" & rpcent & "<br>"
'Response.Write "part : " & part & "<br>"
'Response.Write "rpidx : " & rpidx & "<br>"
'Response.Write "gotopage : " & gotopage & "<br>"
'Response.Write "rWHICHI_FIX : " & rWHICHI_FIX & "<br>"
'Response.Write "rWHICHI_FIXname : " & rWHICHI_FIXname & "<br>"
'Response.Write "rWHICHI_AUTO : " & rWHICHI_AUTO & "<br>"
'Response.Write "rWHICHI_AUTOname : " & rWHICHI_AUTOname & "<br>"
'Response.Write "rpstatus : " & rpstatus & "<br>"
'Response.Write "rglassselect : " & rglassselect & "<br>"
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
    </style>
    <style>
    /* 왼쪽 여백 제거 */
    body, html {
        zoom: 1;
        margin: 0; /* 기본 여백 제거 */
        padding: 0;
    }
     /* 부모 컨테이너를 꽉 채우기 */
    .container-full {
        width: 100%;
        margin: 0;
        padding: 0;
    }

    /* 테이블을 화면 전체로 늘리기 */
    table.full-width-table {
        width: 100%;
        border-collapse: collapse;
    }

    /* 필요하면 테이블 안쪽 패딩도 제거 */
    table.full-width-table th, table.full-width-table td {
        padding: 8px; /* 여백 조절 가능 */
        text-align: center; /* 텍스트 중앙 정렬 등 */
    }
    /* 🔹 버튼 크기 조정 */
    .btn-small {
        font-size: 12px; /* 글씨 크기 */
        padding: 2px 4px; /* 버튼 내부 여백 */
        height: 22px; /* 버튼 높이를 자동으로 */
        line-height: 1; /* 버튼 텍스트 정렬 */
        border-radius: 3px; /* 모서리를 조금 둥글게 */
    }
    </style>
        <style>
        /* 스타일 정의 */
        .input-field {
            width: 100%; /* 너비를 100%로 설정 */
            //padding: 10px; /* 안쪽 여백 */
            //margin-bottom: 15px; /* 아래 여백 */
            border: none; /* 테두리 제거 */
            //border-bottom: 2px solid #ccc; /* 하단 경계선만 추가 */
            //font-size: 16px; /* 글꼴 크기 */
            outline: none; /* 포커스 시 아웃라인 제거 */
        }

        .input-field:focus {
         //   border-bottom: 2px solid #007bff; /* 포커스 시 하단 경계선 강조 */
        }
    </style>
    <style>
        .custom-bg {
            background-color: #f8f8f8; /* Bootstrap danger background color */
            'padding: 20px;
            border-radius: 5px;
        }
    </style>
<style>
    table {
      border-collapse: collapse;
      width: 80%;
      margin: 20px auto;
    }

    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: left;
      position: relative;
    }

    .hover-image {
      display: none;
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateY(-100%);
      width: 250px;
      border: 1px solid #aaa;
      background-color: #fff;
      z-index: 100;
      box-shadow: 0px 0px 5px rgba(0,0,0,0.2);
    }

    .title-cell:hover .hover-image {
      display: block;
    }

    .title-cell {
      cursor: pointer;
    }
  </style>
    <script>
        // 공통 키프레스 핸들러
        function handleKeyPress(event, elementId1, elementId2) {
            if (event.key === "Enter") {
                event.preventDefault();
                console.log(`Enter 눌림: ${elementId1}, ${elementId2}`);
                document.getElementById("hiddenSubmit").click();
            }
        }

        // Select 박스 변경(마우스 클릭/선택) 이벤트 핸들러
        function handleSelectChange(event, elementId1, elementId2) {
            console.log(`선택 변경됨: ${elementId1}, ${elementId2}`);
            document.getElementById("hiddenSubmit").click();
        }

        function handleChange(selectElement) {
            const selectedValue = selectElement.value;
            document.getElementById("hiddenSubmit").click();
        }

        // 폼 전체 Enter 이벤트 감지 (기본 방지 + 숨겨진 버튼 클릭)
        document.getElementById("dataForm").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault(); // 기본 Enter 동작 방지
                console.log("폼 전체에서 Enter 감지");
                document.getElementById("hiddenSubmit").click();
            }
        });
        function del(str){
            if (confirm("삭제 하시겠습니까11?"))
            {
                location.href="TNG1_JULGOK_PUMMOK_LIST_DB.asp?gotopage=<%=gotopage%>&kgotopage=<%=kgotopage%>&searchword=<%=rsearchword%>&ksearchword=<%=rksearchword%>&SJB_IDX=<%=rSJB_IDX%>&part=delete&bfidx="+str;
            }
        }
    </script>
    <script>
        function validateForm() {
            {
                document.frmMain.submit();
            }
        }
    </script>

</head>
<body>
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left_TNG1.asp"-->
<div id="layoutSidenav_content">            
<main>
    <div class="container-fluid px-4">

        <div class="row justify-content-between">
            <div class="py-5 container text-center  card card-body">
<%

if rWHICHI_FIXname<>"" and rWHICHI_AUTOname<>"" then 

    response.write "alert('수동과 자동을 동시에 입력할 수 없습니다!');history.back();"
    response.end

end if
'if rWHICHI_FIXname<>"" then 
' 🔹 새로운 rWHICHI_FIXname 번호 구하기 .번호를 직접 수정하면 안됨으로 하는것
'        SQL = "SELECT ISNULL(MAX(WHICHI_FIX), 0) + 1 FROM tng_whichipcent "
'        Rs.Open SQL, Dbcon
'        If Not (Rs.EOF Or Rs.BOF) Then
'            rWHICHI_FIX = Rs(0) 
'            rWHICHI_AUTO = 0
'        End if
'        Rs.Close
'end if
'if rWHICHI_AUTOname<>"" then 
' 🔹 새로운 rWHICHI_FIXname 번호 구하기 .번호를 직접 수정하면 안됨으로 하는것
'        SQL = "SELECT ISNULL(MAX(WHICHI_AUTO), 0) + 1 FROM tng_whichipcent "
'        Rs.Open SQL, Dbcon
'        If Not (Rs.EOF Or Rs.BOF) Then
'            rWHICHI_AUTO = Rs(0) 
'            rWHICHI_FIX = 0
'        End If
'        Rs.Close
'end if

'Response.Write "unittype_pidx=" & unittype_pidx & "<br>"
'Response.Write "part : " & part & "<br>"
'Response.Write "rpidx : " & rpidx & "<br>"
'Response.Write "gotopage : " & gotopage & "<br>"
'Response.Write "rWHICHI_FIX : " & rWHICHI_FIX & "<br>"
'Response.Write "rWHICHI_FIXname : " & rWHICHI_FIXname & "<br>"
'Response.Write "rWHICHI_AUTO : " & rWHICHI_AUTO & "<br>"
'Response.Write "rWHICHI_AUTOname : " & rWHICHI_AUTOname & "<br>"
'Response.Write "rpstatus : " & rpstatus & "<br>"
'Response.Write "rglassselect : " & rglassselect & "<br>"
'Response.Write "rSearchWord : " & rSearchWord & "<br>"
'Response.end


if part="delete" and mode="sudong" then 
    sql = "DELETE FROM tng_whichipcent  WHERE pidx = " & rpidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    'response.write "<script>window.close();</script>"
    response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"&mode=sudong');</script>"
    
elseif part="delete" and mode="auto" then 
    sql = "DELETE FROM tng_whichipcent  WHERE pidx = " & rpidx & " "

    'Response.Write sql & "<br>"
    'Response.End

    Dbcon.Execute (SQL)
    'response.write "<script>window.close();</script>"
    response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&SearchWord="&rSearchWord&"&mode=auto');</script>"

elseif  mode="sudong" then 

    if rpidx="0" then 
    
    ' 🔹 새로운 pidx 번호 구하기
        SQL = "SELECT ISNULL(MAX(pidx), 0) + 1 FROM tng_whichipcent "
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rpidx = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tng_whichipcent (pidx, WHICHI_FIX, WHICHI_FIXname,  min_ysize, max_ysize, pcent, pstatus) "
        sql = sql & "VALUES (" & rpidx & ", " & rWHICHI_FIX & ", '" & rWHICHI_FIXname & "', '" & rmin_ysize & "', '" & rmax_ysize & "', '" & rpcent & "', '" & rpstatus & "' )"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&pidx="&rpidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rpidx&"');</script>"
    else

        sql = "UPDATE tng_whichipcent  SET "
        sql = sql & "WHICHI_FIX = '" & rWHICHI_FIX & "', WHICHI_FIXname = '" & rWHICHI_FIXname & "' "
        sql = sql & ", min_ysize = '" & rmin_ysize & "', max_ysize = '" & rmax_ysize & "', pcent = '" & rpcent & "', pstatus = '" & rpstatus & "' "
        sql = sql & "WHERE pidx = '" & rpidx & "'"
    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&pidx="&rpidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rpidx&"');</script>"

    end if

elseif  mode="auto" then 

    if rpidx="0" then 
    
    ' 🔹 새로운 pidx 번호 구하기
        SQL = "SELECT ISNULL(MAX(pidx), 0) + 1 FROM tng_whichipcent "
        Rs.Open SQL, Dbcon
        If Not (Rs.EOF Or Rs.BOF) Then
            rpidx = Rs(0)
        End If
        Rs.Close

        ' 🔹 INSERT 실행
        sql = "INSERT INTO tng_whichipcent (pidx, WHICHI_AUTO, WHICHI_AUTOname,  min_ysize, max_ysize, pcent, pstatus) "
        sql = sql & "VALUES (" & rpidx & ", " & rWHICHI_AUTO & ", '" & rWHICHI_AUTOname & "', '" & rmin_ysize & "', '" & rmax_ysize & "', '" & rpcent & "', '" & rpstatus & "' )"

        'Response.write sql & "<br>"
        'Response.End

        Dbcon.Execute(sql)
        response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&pidx="&rpidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rpidx&"');</script>"
    else

        sql = "UPDATE tng_whichipcent  SET "
        sql = sql & "WHICHI_AUTO = '" & rWHICHI_AUTO & "', WHICHI_AUTOname = '" & rWHICHI_AUTOname & "' "
        sql = sql & ", min_ysize = '" & rmin_ysize & "', max_ysize = '" & rmax_ysize & "', pcent = '" & rpcent & "', pstatus = '" & rpstatus & "' "
        sql = sql & "WHERE pidx = '" & rpidx & "'"

    'Response.Write sql & "<br>"
    'Response.End

     Dbcon.Execute (SQL)
    response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&pidx="&rpidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rpidx&"');</script>"

    end if
%>
<%
    elseif  mode="slt" then 
%>

<table class="table table-bordered table-hover">
    <thead class="table-light">
        <tr>
            <th>번호/bfidx</th>
            <th>수동자재명</th>
            <th>수동사용위치</th>
            <th>자동자재명</th>
            <th>자동사용위치</th>
            <th>정면폭</th>
            <th>자재찾기</th>
            <th>현재 할증값<br>(tk_barasiF)</th>
            <th>테이블 할증값<br>(tng_whichipcent)</th>
            <th>불일치 값<br>(tng_whichipcent<br><>tk_barasiF)</th>
            <th>
                <button type="submit" class="btn btn-success btn-sm float-end">
                    업데이트 일괄 실행
                </button>
            </th>
        </tr>
    </thead>
    <tbody>
<%
sql = "SELECT A.bfidx "
sql = sql & " , A.set_name_FIX , A.WHICHI_FIX , A.set_name_AUTO , A.WHICHI_AUTO , A.ysize , A.pcent "
sql = sql & " , D.WHICHI_FIXname , E.WHICHI_AUTOname , A.SJB_IDX "
sql = sql & " , ("
sql = sql & "     SELECT TOP 1 pcent FROM ("
sql = sql & "         SELECT B.pcent "
sql = sql & "         FROM tng_whichipcent B "
sql = sql & "         WHERE B.WHICHI_FIX = A.WHICHI_FIX "
sql = sql & "           AND A.ysize BETWEEN B.min_ysize AND B.max_ysize "
sql = sql & "         UNION "
sql = sql & "         SELECT B.pcent "
sql = sql & "         FROM tng_whichipcent B "
sql = sql & "         WHERE B.WHICHI_AUTO = A.WHICHI_AUTO "
sql = sql & "           AND A.ysize BETWEEN B.min_ysize AND B.max_ysize "
sql = sql & "     ) AS unioned "
sql = sql & "     ORDER BY pcent ASC "
sql = sql & " ) AS matched_pcent "
sql = sql & " , F.pcent "
sql = sql & " FROM tk_barasiF A"
sql = sql & " LEFT JOIN tng_whichitype D ON A.WHICHI_FIX = D.WHICHI_FIX"
sql = sql & " LEFT JOIN tng_whichitype E ON A.WHICHI_AUTO = E.WHICHI_AUTO"
sql = sql & " LEFT JOIN tng_whichipcent F ON (F.WHICHI_FIX = A.WHICHI_FIX OR F.WHICHI_AUTO = A.WHICHI_AUTO)"
sql = sql & " WHERE A.pcent > 1"
sql = sql & "   AND EXISTS ("
sql = sql & "     SELECT 1"
sql = sql & "     FROM tng_whichipcent C"
sql = sql & "     WHERE (C.WHICHI_FIX = A.WHICHI_FIX OR C.WHICHI_AUTO = A.WHICHI_AUTO) "
sql = sql & "       AND A.ysize BETWEEN C.min_ysize AND C.max_ysize"
sql = sql & " )"
sql = sql & " ORDER BY A.WHICHI_FIX ASC, A.WHICHI_AUTO ASC, A.bfidx ASC"

    'Response.Write sql & "<br>"
    'Response.End
    Rs.Open sql, Dbcon, 1, 1

    If Not (Rs.EOF Or Rs.BOF) Then
        Do Until Rs.EOF
            bfidx           = Rs(0)
            set_name_FIX    = Rs(1)
            WHICHI_FIX      = Rs(2)
            set_name_AUTO   = Rs(3)
            WHICHI_AUTO     = Rs(4)
            ysize           = Rs(5)
            pcent           = Rs(6) 'tk_barasiF
            WHICHI_FIXname   = Rs(7)
            WHICHI_AUTOname   = Rs(8)
            SJB_IDX   = Rs(9)
            matched_pcent   = Rs(10)
            pcent1  = Rs(11) 'tng_whichipcent
            
            %>
                    <tr>
                    <td><%=bfidx%></td>
                    <td><%=set_name_FIX%></td>
                    <td><%=WHICHI_FIXname%></td>
                    <td><%=set_name_AUTO%></td>
                    <td><%=WHICHI_AUTOname%></td>
                    <td><%=ysize%></td>
                    <td>
                        <button class="btn btn-secondary" type="button"
                            onclick="window.open('TNG1_JULGOK_PUMMOK_LIST1.asp?bfidx=<%=bfidx%>&SJB_IDX=<%=SJB_IDX%>#<%=bfidx%>', '_blank', 'width=1200,height=800,scrollbars=yes');">
                            선택자재 보기
                        </button>
                    </td>
                    
                    <td class='text-success'><%=pcent%></td>
                    <td class='text-danger '>
                    <%=matched_pcent%>
                    
                <%     
                    ' 🔸 UPDATE SQL 프리뷰도 출력
                    sql = "UPDATE tk_barasiF SET "
                    sql = sql & " pcent = '" & matched_pcent & "' "
                    sql = sql & " WHERE bfidx = '" & bfidx & "' "
                    'Response.Write "<b>→ 실행 SQL:</b> " & sql & "<hr>"

                    ' Dbcon.Execute(sql) ' 
                %>

                </td>
                <td colspan="2" >
                <% if matched_pcent <> pcent then %>
                <span style='color:blue;'>불일치</span>
                <% end if %>
                <% if matched_pcent = pcent then %>
                일치
                <% end if %>
                </td>
                
                
            </tr>
<%
Rs.MoveNext
Loop
End If
Rs.close
%>
    </tbody>
</table>
<%
elseif  mode="udt" then 

sql = "UPDATE tk_barasiF SET "
sql = sql & " pcent = ("
sql = sql & "     SELECT TOP 1 pcent "
sql = sql & "     FROM tng_whichipcent "
sql = sql & "     WHERE tng_whichipcent.WHICHI_FIX = tk_barasiF.WHICHI_FIX "
sql = sql & "       AND tk_barasiF.ysize BETWEEN tng_whichipcent.min_ysize AND tng_whichipcent.max_ysize "
sql = sql & "     ORDER BY tng_whichipcent.min_ysize ASC "
sql = sql & " ) "
sql = sql & "WHERE EXISTS ("
sql = sql & "     SELECT 1 "
sql = sql & "     FROM tng_whichipcent "
sql = sql & "     WHERE tng_whichipcent.WHICHI_FIX = tk_barasiF.WHICHI_FIX "
sql = sql & "       AND tk_barasiF.ysize BETWEEN tng_whichipcent.min_ysize AND tng_whichipcent.max_ysize "
sql = sql & ")"
    Response.Write sql & "<br>"
    Response.End

     'Dbcon.Execute (SQL)
    'response.write "<script>location.replace('TNG1_pcent_whichi_INSERT.asp?gotopage=" & gotopage & "&pidx="&rpidx&"&SearchWord="&rSearchWord&"&mode="&mode&"#"&rpidx&"');</script>"




end if
%>

 </div>    

    <!--화면 끝-->
        
</div>
</div>
</main>                          
                <!-- footer 시작 -->    
                Coded By 양양
                <!-- footer 끝 --> 
</div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
</body>
</html>
<%
set Rs=Nothing
set Rs1=Nothing
call dbClose()
%>


<!--
sql = "SELECT A.bfidx "
    sql = sql & " , A.set_name_FIX , A.WHICHI_FIX , A.set_name_AUTO , A.WHICHI_AUTO , A.ysize , A.pcent ,D.WHICHI_FIXname , E.WHICHI_AUTOname ,A.SJB_IDX "    
    sql = sql & " , ("
    sql = sql & "     SELECT TOP 1 B.pcent"
    sql = sql & "     FROM tng_whichipcent B"
    sql = sql & "     WHERE (B.WHICHI_FIX = A.WHICHI_FIX OR B.WHICHI_AUTO = A.WHICHI_AUTO) "
    sql = sql & "       AND A.ysize BETWEEN B.min_ysize AND B.max_ysize"
    sql = sql & "     ORDER BY B.min_ysize ASC"
    sql = sql & "   ) AS matched_pcent "
    sql = sql & " , F.pcent "  
    sql = sql & " FROM tk_barasiF A"
    sql = sql & " LEFT JOIN tng_whichitype D ON A.WHICHI_FIX = D.WHICHI_FIX"
    sql = sql & " LEFT JOIN tng_whichitype E ON A.WHICHI_AUTO = E.WHICHI_AUTO"
    sql = sql & " LEFT JOIN tng_whichipcent F ON (F.WHICHI_FIX = A.WHICHI_FIX OR F.WHICHI_AUTO = A.WHICHI_AUTO)"
    sql = sql & " WHERE A.pcent <> 1"
    sql = sql & "   AND EXISTS ("
    sql = sql & "     SELECT 1"
    sql = sql & "     FROM tng_whichipcent C"
    sql = sql & "     WHERE (C.WHICHI_FIX = A.WHICHI_FIX OR C.WHICHI_AUTO = A.WHICHI_AUTO) "
    sql = sql & "       AND A.ysize BETWEEN C.min_ysize AND C.max_ysize"
    sql = sql & "   )"
    sql = sql & " ORDER BY A.WHICHI_FIX ASC, A.WHICHI_AUTO ASC, A.bfidx ASC"
    'Response.Write sql & "<br>"
    'Response.End
    Rs.Open sql, Dbcon, 1, 1


     
                    sql = "SELECT pcent FROM tk_barasiF "
                    sql = sql & " WHERE bfidx='" & bfidx & "' "
                    Rs1.Open sql, Dbcon
                    If Not (Rs1.EOF Or Rs1.BOF) Then
                        ypcent = Rs1(0)
                    End If
                    Rs1.Close
          -->          