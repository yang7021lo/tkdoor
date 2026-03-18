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

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 
    listgubun="one"
    projectname="수주관리"

    gubun=Request("gubun")
    rgoidx=Request("goidx")
    rcidx=Request("cidx")
    roidx=Request("oidx")
    serdate=Request("serdate")
    rsjaidx=Request("sjaidx")




    if serdate="" then 
        serdate=date()
    end if


    if rgoidx<>"" then 
    SQL=" Select gotype, gocode, gocword, goname, gopaint, gosecfloor ,gomidkey ,gounit,gostatus , gomidx, gowdate, goemidx"
    SQL=SQL&" From tk_goods "
    SQL=SQL&" Where gotype=1 and goidx='"&rgoidx&"' "
    'RESPONSE.WRITE (SQL)
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 

        gotype=rs(0)
        gocode=rs(1)
        gocword=rs(2)
        goname=rs(3)
        gopaint=rs(4)
        gosecfloor=rs(5)
        gomidkey=rs(6)
        gounit=rs(7)
        gostatus=rs(8)
        gomidx=rs(9)
        gowdate=rs(10)
        goemidx=rs(11)

    end if 
    rs.close    
    end if 


    SQL=" Select A.cstatus, A.cname, A.cceo,  A.ctkidx, A.caddr1, A.cmemo,  A.cwdate, A.ctel, A.cfax, A.cnick"
    SQL=SQL&" From tk_customer A "
    SQL=SQL&" Where cidx='"&rcidx&"' "
    Rs.open SQL,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
        cstatus=Rs(0)
        cname=Rs(1)
        cceo=Rs(2)
        ctkidx=Rs(3)
        caddr1=Rs(4)
        cmemo=Rs(5)
        cwdate=Rs(6)
        ctel=Rs(7)
        cfax=Rs(8)
        cnick=Rs(9)
    End If
    Rs.Close


    SQL=" select sjaddress, sjnumber, sjtatus, sjqty, Convert(varchar(10),sujudate,121), sjchulgo, Convert(varchar(10),sjchulgodate,121), sjamidx, Convert(varchar(10),sjamdate,121), sjameidx, Convert(varchar(10),sjamedate,121) "
    SQL=SQL&" from tk_sujua "
    SQL=SQL&" where sjaidx='"&rsjaidx&"'"
    Rs.open SQL,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
        rsjaddress=Rs(0)
        rsjnumber=Rs(1)
        rsjtatus=Rs(2)
        rsjqty=Rs(3)
        rsujudate=Rs(4)
        rsjchulgo=Rs(5)
        rsjchulgodate=Rs(6)
        rsjamidx=Rs(7)
        rsjamdate=Rs(8)
        rsjameidx=Rs(9)
        rsjamedate=Rs(10)
    End If
    Rs.Close

'if gubun="new" then     '신규 수주등록
 '   otitle=cnick&"_"&ymdhns
'    ocode=ymdhns

'    SQL="Select max(oidx) From tk_odr where cidx='"&rcidx&"' "
'    Rs.open SQL,Dbcon
'    if not (Rs.EOF or Rs.BOF ) then
 '       oidx=Rs(0)+1
 '   End if
 '   Rs.Close


 '   SQL="Insert into tk_odr (oidx, cidx, otitle, ocode, ostatus, owidx, owdate)"
'    SQL=SQL&" Values('"&oidx&"','"&rcidx&"', '"&otitle&"', '"&ocode&"', 0, '"&c_midx&"', getdate())"
'    Response.write (SQL)&"<br>"
'    Dbcon.execute (SQL)
 '   response.write "<script>location.replace('sujuin.asp?cidx="&rcidx&"&oidx="&oidx&"');</script>"

'End if
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
        function validateForm(){
                document.frmMain.submit();
            }
        function validateFormb(){
                document.frmMainb.submit();
            }            
    </script>
 
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left.asp"-->


<div id="layoutSidenav_content">            
  <main>
    <div class="container-fluid px-4">
      <div class="row justify-content-between  mt-2">
<!-- 내용 입력 시작 -->  
<!--거래처 시작 -->
        <div class="card card-body mb-1">

          <div class="row ">

            <div class="col-md-2">
              <label for="name">거래처</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=cname%>" onclick="location.replace('/user/corplist.asp');">
            </div>
            <div class="col-md-6">
              <label for="name">사업장</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=caddr1%>" readonly>
            </div> 
            <div class="col-md-2">
              <label for="name">TEL</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=ctel%>" readonly>
            </div> 
            <div class="col-md-2">
              <label for="name">FAX</label><p>
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=cfax%>" readonly>
            </div> 

          </div>

        <div class="row ">
      
          <div class="col-md-4">
            <label for="name">비고</label><p>
            <input type="text" class="form-control" id="" name="" placeholder="" value="" readonly>
          </div>
          <div class="col-md-4">
            <label for="name">참고사항</label><p>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-2">
            <label for="name">관리등급</label><p>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
     
          <div class="col-md-2">
<%
if rcidx<>"" then 
%>   
            <button type="button" class="btn btn-info" onClick="location.replace('sujuin.asp?cidx=<%=rcidx%>&gubun=new')">수주등록</button>
<%
end If
%>
          </div> 
        </div>
      </div>
<!--거래처 끝 -->
<!--수주일자 시작 -->
<% if rsjaidx="" then  %>
<form name="frmMain" action="sujuindbA.asp" method="post">
<% else %>
<form name="frmMain" action="sujuindbAU.asp" method="post">
<input type="hidden" name="sjaidx" value="<%=rsjaidx%>">
<% end if%>


<input type="hidden" name="cidx" value="<%=rcidx%>">
    <div class="card card-body mb-1">
      <div class="row ">

        <div class="col-md-2">
          <label for="name">수주일자</label>
          <input type="date" class="form-control" id="" name="sujudate" placeholder="" value="<%=rsujudate%>" >
        </div>
        <div class="col-md-2">
          <label for="name">수주번호</label><p>
            <%
            SQL="Select max(sjnumber) From tk_sujua where Convert(Varchar(10),sujudate,121)='"&serdate&"' "
            'response.write (SQL)
            Rs.open SQL,Dbcon
            if not (Rs.EOF or Rs.BOF ) then
                sjnumber=Rs(0)

                if isnull(sjnumber) then 
                    nsjnumber="1"
                else
                    nsjnumber=sjnumber+1
                end if  
                vsjnmber=yy&mm&dd&"-"&nsjnumber
            End if
            Rs.Close


            %>
          <input type="hidden" class="form-control" id="" name="sjnumber" placeholder="" value="<%=nsjnumber%>" >
          <input type="text" class="form-control" id="" name="" placeholder="" value="<%=vsjnmber%>" <% if rsjaidx<>"" then response.write "readonly" end if %>>


        </div> 
        <div class="col-md-1">
          <label for="name">&nbsp;</label><p>
          <i class="fa-solid fa-plus fa-lg"></i>
          <i class="fa-solid fa-minus  fa-lg"></i>
          <i class="fa-solid fa-calendar-days fa-lg"></i>
          <i class="fa-solid fa-building fa-lg fa-beat-fade"></i>
        </div> 
        <div class="col-md-2">
          <label for="name">현장</label><p>
          <input type="text" class="form-control" id="" name="sjaddress" placeholder="" value="<%=rsjaddress%>" >
        </div> 
        <div class="col-md-2">
          <label for="name">출고구분</label><p>
          <select class="form-select" name="sjchulgo">
            <option value="1" <% if rsjchulgo="1" or rsjchulgo="" then  %>selected<% end if %>>배달</option>
            <option value="2" <% if rsjchulgo="2" then  %>selected<% end if %>>화물</option>
            <option value="3" <% if rsjchulgo="3" then  %>selected<% end if %>>용차</option>
            <option value="4" <% if rsjchulgo="4" then  %>selected<% end if %>>도장</option>
        </select>          
        </div> 
        <div class="col-md-2">
          <label for="name">출고일자</label><p>
          <input type="date" class="form-control" id="" name="sjchulgodate" placeholder="" value="<%=rsjchulgodate%>" >
        </div> 
        <div class="col-md-1">
          <label for="name">세율</label><p>
          <input type="text" class="form-control" id="" name="" placeholder="" value="" >
        </div> 

      </div>
      <div class="row ">
      
        <div class="col-md-2">
          <label for="name">품목</label><p>
            <select class="form-select" name="sjqty">
                <option value="1" <% if rsjqty="1" or rsjqty="" then  %>selected<% end if %>>도어</option>
                <option value="2" <% if rsjqty="2" then  %>selected<% end if %>>프레임</option>
                <option value="3" <% if rsjqty="3" then  %>selected<% end if %>>보호대</option>
                <option value="4" <% if rsjqty="4" then  %>selected<% end if %>>자동문</option>
            </select>
        </div>
        <div class="col-md-4">
          <div class="input-group mb-3">
          <% if rsjaidx="" then  %>
            <button type="button" class="btn btn-outline-primary" onclick="validateForm();">저장</button>
        <% else %>
            <button type="button" class="btn btn-outline-secondary" onclick="validateForm();">수정</button>
        <% end if %>
        </div>     

          <button class="btn btn-primary"  type="submit" >외주발주</button>
          <button class="btn btn-success"  type="submit" >문자전송</button>
          <button class="btn btn-danger"  type="submit" >복사</button>
          <button class="btn btn-warning"  type="submit" >견적읽기</button>
        </div> 
        <div class="col-md-6 card card-body mb-1  ">
        <div class="row">
          <div class="col-md-1 text-end">
          <label for="name">합계</label>
          </div>
          <div class="col-md-4">
            <label for="name">공급가액</label>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-3">
            <label for="name">세액</label>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
          <div class="col-md-4">
            <label for="name">금액</label>
            <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
          </div> 
        </div>
        </div>

      </div>
    </div>
</form>
<!--수주일자 끝 -->
<!--품명 시작 form b 시작 -->
<form name="frmMainb" action="sujuindbb.asp" method="post"> 
    <input type="hidden" name="goidx" value="<%=rgoidx%>" >
    <input type="hidden" name="sjaidx" value="<%=rsjaidx%>" >    

    <div class="row">
      <div class="col-md-4">
        <div class="card card-body mb-1">
          <div class="row mb-1">
            <div class="col-2"><label for="name">품명</label></div>
            <div class="col-5">
                <input type="text" class="form-control" id="goname" name="sjbpummyoung" placeholder="선택" value="<%=goname%>" onclick="window.open('goodch.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=500, height=400, top=200, left=500');" >
            </div>
            <div class="col-5">
            <select name="sjbkukyuk" class="form-control" id="barNAME" required>
              <%
              SQL=" select A.sidx, A.baridx, B.barNAME "
              SQL=SQL&" from tk_stand A "
              SQL=SQL&" Join tk_barlist  B On  A.baridx=B.baridx "
              SQL=SQL&" Where A.goidx='"&rgoidx&"' "
              'Response.write (SQL)	
              Rs.open Sql,Dbcon
              If Not (Rs.bof or Rs.eof) Then 
              Do until Rs.EOF
                  sidx=Rs(0)
                  baridx=Rs(1)
                  barNAME=Rs(2)
              %>  
              <option value="" selected><%=barNAME%></option>
              <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select>
            </div>
          </div>

          <div class="row mb-1">
            <div class="col-2"><label for="name">재질</label></div>
            <div class="col-4">
              <select name="sjbjaejil" class="form-control" id="QTYIDX" required>
                <%
                SQL=" Select QTYIDX, QTYCODE, QTYNAME, QTYSTATUS, QTYPAINT, QTYINS, QTYLABEL ,QTYPAINTW ,QTYmidx,QTYwdate , qtype, taidx, ATYPE"
                SQL=SQL&" From tk_qty "
                SQL=SQL&" Where QTYSTATUS=1 "
                'RESPONSE.WRITE (SQL)
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do until Rs.EOF
                QTYIDX=Rs(0)
                QTYCODE=Rs(1)
                QTYNAME=Rs(2)
                QTYSTATUS=Rs(3)
                QTYPAINT=Rs(4)
                QTYINS=Rs(5)
                QTYLABEL=Rs(6)
                QTYPAINTW=Rs(7)
                QTYmidx=Rs(8)
                QTYwdate=Rs(9)
                qtype=Rs(10)
                taidx=Rs(11)
                ATYPE=Rs(12)
                %>                
                    <option value="<%=QTYIDX%>" selected><%=QTYNAME%>mm</option>
                <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select>
            </div>
            <div class="col-2"><label for="name">수량</label></div>
            <div class="col-4">
              <input type="text" class="form-control" id="" name="sjbqty" placeholder="" value=""  >
            </div>
          </div>


          <div class="row mb-1">
            <div class="col-2"><label for="name">규격</label></div>
            <div class="col-2">
              <input type="text" class="form-control" id="" name="sjbwide" placeholder="" value="가로" >
            </div>
              <div class="col-1">
              X
            </div>
            <div class="col-2">
              <input type="text" class="form-control" id="" name="sjbhigh" placeholder="" value="세로" >
            </div>
            <div class="col-2"><label for="name">방향</label></div>
            <div class="col-3">
           <select name="sjbbanghyang" class="form-control" id="" required>
              <option value="1">좌</option>
              <option value="2">우</option>
              <option value="3">양개(좌)</option>
              <option value="4">양개(우)</option>
              <option value="5">양개</option>              
            </select>
            </div>
          </div>


          <div class="row mb-1">
            <div class="col-2"><label for="name">위치</label></div>
            <div class="col-10">
              <input type="text" class="form-control" id="" name="sjbwitch" placeholder="" value="" >
            </div>
          </div>

          <div class="row mb-1">
            <div class="col-2"><label for="name">비고</label></div>
            <div class="col-10">
              <input type="text" class="form-control" id="" name="sjbbigo" placeholder="" value="" >
            </div>
          </div>

          <div class="row mb-1">
            <div class="col-md-6 card card-body mb-1  ">
                <div class="row">
                    <div class="col-md-1 text-end">
                        <label for="name">합계</label>
                    </div>
                    <div class="col-md-5">
                        <label for="name">원단가</label>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  radonly>
                    </div> 
                    <div class="col-md-6">
                        <label for="name">공급가액</label>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div> 
                </div>
                 <div class="row">
                    <div class="col-md-1 text-end">
                        
                    </div>
                    <div class="col-md-5">
                        <label for="name">추가금</label>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div> 
                    <div class="col-md-6">
                        <label for="name">세액</label>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div> 
                </div>
                 <div class="row">
                    <div class="col-md-1 text-end">
                        
                    </div>
                    <div class="col-md-5">
                        <label for="name">단가</label>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div> 
                    <div class="col-md-6">
                        <label for="name">금액</label>
                        <input type="text" class="form-control" id="" name="" placeholder="" value=""  readonly>
                    </div> 
                </div>
            </div>           
          </div>
        

        </div>
      </div>
      <div class="col-md-4">
        <div class="card card-body mb-1">

          <div class="row mb-1">
            <div class="col-2"><label for="name">유리</label></div>
            <div class="col-4">
                <select name="sjbglass" class="form-control" id="glidx" required>
                    <%
                    SQL=" Select glidx, glcode, glsort, glvariety, gldepth, glprice, glwdate ,glstatus ,qtype "
                    SQL=SQL&" From tk_glass "
                    SQL=SQL&" Where glstatus=1 "
                    'RESPONSE.WRITE (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    glidx=Rs(0)
                    glcode=Rs(1)
                    glsort=Rs(2)
                    glvariety=Rs(3)
                    gldepth=Rs(4)
                    glprice=Rs(5)
                    glwdate=Rs(6)
                    
                    %>                
                        <option value="<%=glidx%>" <% if Cint(aidx)=Cint(raidx) Then %>selected<% end if %>><%=gldepth%>mm</option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
            </div>
           <div class="col-2"><label for="name">상바</label></div>
            <div class="col-4">
             <select name="" class="form-control" id="" required>
              <option value=""></option>
              <option value=""></option>
            </select>
            </div>
          </div>

          <div class="row mb-1">
            <div class="col-2"><label for="name">도장</label></div>
            <div class="col-4">
                <select name="sjbpaint" class="form-control" id="pidx" required>
                    <%
                    SQL=" Select pidx, pname, pmidx, pwdate ,pemidx, pewdate"
                    SQL=SQL&" From tk_paint"
                    SQL=SQL&" Where pstatus=1 "
                    'RESPONSE.WRITE SQL 
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                        pidx=Rs(0)
                        pname=Rs(1)
                        pmidx=Rs(2)
                        pwdate=Rs(3)
                        pemidx=Rs(4)
                        pewdate=Rs(5)
                    %>                
                        <option value="<%=pidx%>" <% if Cint(aidx)=Cint(raidx) Then %>selected<% end if %>><%=pname%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
            </div>
           <div class="col-2"><label for="name">하바</label></div>
            <div class="col-4">
             <select name="" class="form-control" id="" required>
              <option value=""></option>
              <option value=""></option>
            </select>
            </div>
          </div>

        <div class="row mb-1">
            <div class="col-2"><label for="name">키</label></div>
            <div class="col-3">
                <select name="sjbkey1" class="form-control" id="kyidx" required>
                    <%
                    SQL=" Select kyidx, kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate"
                    SQL=SQL&" From tk_key "
                    SQL=SQL&" Where kystatus=1 "
                    RESPONSE.WRITE SQL 
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    kyidx=Rs(0)
                    kycode=Rs(1)
                    kyshorten=Rs(2)
                    kyname=Rs(3)
                    kyprice=Rs(4)
                    kymidx=Rs(5)
                    kywdate=Rs(6)
                    kyemidx=Rs(7)
                    kyewdate=Rs(8)
                    %>                
                        <option value="<%=kyidx%>" <% if Cint(aidx)=Cint(raidx) Then %>selected<% end if %>><%=kyname%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
            </div>
            <div class="col-3">
             <select name="sjbkey2" class="form-control" id="" required>
              <option value=""></option>
              <option value=""></option>
            </select>
            </div>
            <div class="col-2">
                <input type="text" class="form-control" id="" name="" placeholder="" value="" >
            </div>
            <div class="col-2">
                <select name="" class="form-control" id="" required>
                <option value=""></option>
                <option value=""></option>
                </select>          
            </div>
        </div>
        <div class="row mb-1">   
            <div class="col-2"><label for="name">&nbsp;</label></div>
            <div class="col-3">
              <select name="sjbkey3" class="form-control" id="kyidx" required>
                <%
                SQL=" Select kyidx, kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate"
                SQL=SQL&" From tk_key "
                SQL=SQL&" Where kystatus=1 "
                RESPONSE.WRITE SQL 
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do until Rs.EOF
                kyidx=Rs(0)
                kycode=Rs(1)
                kyshorten=Rs(2)
                kyname=Rs(3)
                kyprice=Rs(4)
                kymidx=Rs(5)
                kywdate=Rs(6)
                kyemidx=Rs(7)
                kyewdate=Rs(8)
                %>                
                    <option value="<%=kyidx%>" <% if Cint(aidx)=Cint(raidx) Then %>selected<% end if %>><%=kyname%></option>
                <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select>           
            </div>
            <div class="col-3">
                <input type="text" class="form-control" id="" name="sjbkey4" placeholder="" value="" >          
            </div>
            <div class="col-4">
                <input type="text" class="form-control" id="" name="" placeholder="" value="" >          
            </div>

          </div>


            <div class="row mb-1">
                <div class="col-2"><label for="name">손잡이</label></div>
                <div class="col-3">
  

                  <select name="sjbtagong1" class="form-control" id="hdidx" required>
                    <%
                    SQL=" Select tagongidx, tagongcode, tagongshorten, tagongname, tagongpunch, tagongprice, tagongmidx, tagongwdate ,tagongemidx, tagongewdate"
                    SQL=SQL&" From tk_tagong "
                    SQL=SQL&" Where tagongstatus=1 "
'                    RESPONSE.WRITE (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    tagongidx=Rs(0)
                    tagongcode=Rs(1)
                    tagongshorten=Rs(2)
                    tagongname=Rs(3)
                    tagongunch=Rs(4)                        
                    tagongprice=Rs(5)
                    tagongmidx=Rs(6)
                    tagongwdate=Rs(7)
                    tagongemidx=Rs(8)
                    tagongewdate=Rs(9)
                    %>                
                        <option value="<%=tagongidx%>" <% if Cint(aidx)=Cint(raidx) Then %>selected<% end if %>><%=tagongname%>mm</option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                </div>
                <div class="col-3">
                    <input type="text" class="form-control" id="" name="sjbtagong2" placeholder="" value="" >  

                </div>
                <div class="col-2">
                    <input type="text" class="form-control" id="" name="sjbtagong3" placeholder="" value="" > 
                </div>
                <div class="col-2">
                    <input type="text" class="form-control" id="" name="sjbtagong4" placeholder="" value="" >           
                </div>            
            </div>
                 
   <!-- <script>
function doChange(srcE, targetId){
    var val = srcE.options[srcE.selectedIndex].value;
    var targetE = document.getElementById(targetId);
 //   alert(val);
    removeAll(targetE);

    if(val == 'aaaa'){
        addOption('C++', targetE);
        addOption('Java', targetE);
        addOption('Scheme', targetE);
    }
    else if(val == 'bbbb'){
        addOption('Visual Studio', targetE);
        addOption('Netbeans', targetE);
        addOption('Eclipse', targetE);
    }
}

function addOption(value, e){
    var o = new Option(value);
    try{
        e.add(o);
    }catch(ee){
        e.add(o, null);
    }
}

function removeAll(e){
    for(var i = 0, limit = e.options.length; i < limit - 1; ++i){
        e.remove(1);
    }
}
      

    </script> -->
            <div class="row mb-1">
                <div class="col-2"><label for="name">하롯트</label></div>
                <div class="col-5">
                  <select name="sjbhingedown" id="selOne" class="form-control">
                      <option value="1" selected>3k</option>
                      <option value="2">king</option>
                      <option value="3">good</option>
                  </select>
                </div>
                <div class="col-5">
                  <select name="sjbhingedown1" id="selTwo" class="form-control">
                    <option value="1" selected>센터65</option>
                    <option value="2">센터55</option>
                    <option value="3">센터70</option>
                    <option value="4">센터80</option>                    
                  </select>
                </div>
                <div class="col-2"><label for="name">상롯트</label></div>                
                <div class="col-5">
                  <select name="sjbhingeup" id="selTwo" class="form-control">
                    <option value="상12파이" selected>상12파이</option>
                    <option value="상14파이">상14파이</option>
                    <option value="상15파이">상15파이</option>
                    <option value="상19파이">상19파이</option>                    
                  </select>               
                </div>
                <div class="col-5">
                    <select name="sjbhingeup1" id="selTwo" class="form-control">
                      <option value="1" selected>센터65</option>
                      <option value="2">센터55</option>
                      <option value="3">센터70</option>
                      <option value="4">센터80</option>                    
                    </select>                             
                </div>             
            </div>
            <div class="row mb-1">
                <div class="col-2"><label for="name">격자</label></div>
                <div class="col-3">
                <select name="sjbkyukja1" class="form-control" id="" required>
                <option value=""></option>
                <option value=""></option>
                </select>
                </div>
                <div class="col-3">
                 <select name="sjbkyukja2" class="form-control" id="" required>
                <option value=""></option>
                <option value=""></option>
                </select>  
                </div>
                <div class="col-2">
                <select name="sjbkyukja3" class="form-control" id="" required>
                <option value=""></option>
                <option value=""></option>
                </select>                   
                </div>
                <div class="col-2">
                    <input type="text" class="form-control" id="" name="sjbkyukja4" placeholder="" value="" >           
                </div>                  
            </div>
            <div class="row mb-1">
                <div class="col-2"><label for="name">입력</label></div>
                 <div class="col-2">
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" >           
                </div>  
                 <div class="col-2">
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" >           
                </div>  
                 <div class="col-2">
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" >           
                </div>
                 <div class="col-2">
                    <input type="text" class="form-control" id="" name="" placeholder="" value="" >           
                </div>                
            </div>


        </div>
      </div>
      
        <div class="col-md-4">
            <button type="button" class="btn btn-outline-primary" onclick="validateFormb();">저장</button>
        </div>
</form>  
        

   

<!--품명 끝 -->
<!--수주내역 시작 -->
    <div class="card card-body mb-1">
      <div class="row">
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center">품목</th>
                        <th align="center">구분</th>
                        <th align="center">품명</th>
                        <th align="center">규격</th>
                        <th align="center">수량</th>
                        <th align="center">세부정보</th>
                        <th align="center">위치</th>
                        <th align="center">원단가</th>
                        <th align="center">추가금</th>
                        <th align="center">단가</th>
                        <th align="center">공급가액</th>
                        <th align="center">세액</th>
                        <th align="center">금액</th>
                        <th align="center">비고</th>
                        <th align="center">작성자</th>


                    </tr>
                </thead>

                <tbody>
            <%

            %> 
                    <tr>
                        <td><%=no-i%></td>
                        <td><%=tname%></td>
                        <td><%=gtype_text%></td>
                        <td><%=ttype_text%></td>
                        <td><%=atitle%></td>
                        <td><%=tstatus_text%></td>
                        <td><%=tname%></td>
                        <td><%=gtype_text%></td>
                        <td><%=ttype_text%></td>
                        <td><%=atitle%></td>
                        <td><%=tstatus_text%></td>                        
                        <td><%=tname%></td>
                        <td><%=gtype_text%></td>
                        <td><%=ttype_text%></td>
                        <td><%=atitle%></td>
                    
                    </tr>
            <%


            %>
                    </tbody>
            </table>         
      </div>
    </div>
<!-- 수주내역 끝 -->
<!-- 기타자재 시작 -->
    <div class="card card-body mb-1">
      <div class="row">
      
      </div>
    </div>
<!--  -->
<!-- 내용입력 끝 -->
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
 
%>
<%

set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>
