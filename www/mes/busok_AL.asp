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

	Set Rs = Server.CreateObject ("ADODB.Recordset")

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 

    gubun=Request("gubun")
    rgoidx=Request("rgoidx")    '품목 키
    rsidx=Request("rsidx")  '규격키
    rbuidx=Request("rbuidx")  '부속 키



If gubun="insert" and rgoidx<>"" and rsidx<>"" and rbuidx<>"" Then 

    Sql="select goname from tk_goods where goidx='"&rgoidx&"' "
     Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    goname=rs(0)
    end if 
    rs.close

    SQL="Insert into tk_material (sidx, buidx, smmidx, smwdate,rgoidx,goname ) "
    SQL=SQL&" Values  ('"&rsidx&"', '"&rbuidx&"', '"&C_midx&"', getdate(),'"&rgoidx&"','"&goname&"' ) "
    Dbcon.Execute (SQL)
    Response.write "<script>window.parent.location.replace('pummok_door.asp?rgoidx="&rgoidx&"&rsidx="&rsidx&"&rbuidx="&rbuidx&"');</script>"
    response.end
else
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
        <script>
        </script>
    </head>
    <body class="sb-nav-fixed">
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <div class="row justify-content-between">
                        <div class="card card-body mb-4">
                            <table id="datatablesSimple"  class="table table-hover">
                                <thead>
                                    <tr>
                                        <th align="center">No</th>
                                        <th align="center">품명</th>
                                        <!--<th align="center">구분</th>-->
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                Response.write rsidx&"/"
                                If rsidx<>"" then  
                                sQL=" Select A.BUIDX, A.buname, A.atype, A.BUSELECT, A.bumidx, Convert(Varchar(10),A.buwdate,121), B.mname , Convert(Varchar(10),A.buewdate,121), C.mname , Buprice "
                                SQL=SQL&" From tk_busok A "
                                SQL=SQL&" Join tk_member B On A.bumidx=B.midx "
                                SQL=SQL&" left outer join tk_member C on A.buemidx=C.midx "
                                SQL=SQL&" Where A.buidx<>''  AND (A.BUSELECT='AL_에치바' OR A.BUSELECT='AL_다대바') "
                                'SQL=SQL&" Where A.buidx not in (Select D.buidx From tk_material D where D.sidx='"&rsidx&"' )  " 중복 등록도 할 경우가 있으므로 일단 제외
                                SQL=SQL&"Order By A.BUIDX asc "
                                'Response.write (SQL)	
                                Rs.open Sql,Dbcon,1,1,1
                                if not (Rs.EOF or Rs.BOF ) then
                                Do while not Rs.EOF

                                    yyy=yyy+1
                                    buidx=Rs(0)
                                    buname=Rs(1)
                                    atype=Rs(2)
                                    bustatus=Rs(3)
                                    bumidx=Rs(4)
                                    buwdate=Rs(5)
                                    mname=Rs(6)
                                    buewdate=rs(7)
                                    emname=rs(8)                                    
                                    Buprice=rs(9)                                    

                                    if bustatus="0" then 
                                        bustatus_text="중지"
                                    elseif bustatus="1" then 
                                        bustatus_text="사용"
                                    end if
                                %> 
                                <tr>
                                    <td><%=yyy%></td>
                                    <td><a href="busok_AL.asp?gubun=insert&rgoidx=<%=rgoidx%>&rsidx=<%=rsidx%>&rbuidx=<%=buidx%>"><%=buname%></a></td>
                                </tr>
                                <%
                                Rs.movenext
                                Loop
                                End If 
                                Rs.Close   
                                %>
                                <%
                                end if
                                %>


                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div  class="col-12 py-3"> 

                        </div>
                    </div>
                </div>
            </main>
<!-- footer 시작 -->                
<!-- footer 끝 --> 
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/scripts.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    </body>
</html>
<% end if %>
<%
set Rs=Nothing
call dbClose()
%>

<!-- 표 부속자재 형식 끝--> 