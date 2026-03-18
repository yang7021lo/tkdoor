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
    projectname="sujuin"
    gubun=Request("gubun")
    rgoidx=Request("goidx")
    rcidx=Request("cidx")
    roidx=Request("oidx")
    serdate=Request("serdate")
    rsjaidx=Request("sjaidx")
    rsjbidx=Request("sjbidx")
    rsjmoneyidx=Request("sjmoneyidx")

    if serdate="" then 
        serdate=date()
    end if

    if rgoidx<>"" then 
    SQL=" Select gotype, gocode, gocword, goname, gopaint, gosecfloor ,gomidkey ,gounit,gostatus , gomidx, gowdate, goemidx, goprice"
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
        goprice=rs(12)

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

    SQL=" select sjwondanga, sjchugageum, sjgonggeumgaaek, sjDCdanga, sjseaek, sjdanga, sjgeumaek, sjaidx, sjbidx,sjcidx, sjdidx,sjeidx, sjfidx  "
    SQL=SQL&" ,sujumoneymidx,Convert(varchar(10),sujumoneymdate,121),sujumoneymeidx,Convert(varchar(10),sujumoneymedate,121) "    
    SQL=SQL&" from tk_sujumoney "
    SQL=SQL&" where sjmoneyidx='"&rsjmoneyidx&"' "
    Rs.open SQL,Dbcon
    if not (Rs.EOF or Rs.BOF ) then
    sjwondanga=Rs(0)
    sjchugageum=Rs(1)
    sjgonggeumgaaek=Rs(2)
    sjDCdanga=Rs(3)
    sjseaek=Rs(4)
    sjdanga=Rs(5)
    sjgeumaek=Rs(6)
    sjaidx=Rs(7)
    sjbidx=Rs(8)
    sjcidx=Rs(9)
    sjdidx=Rs(10)
    sjeidx=Rs(11)
    sjfidx=Rs(12)
    sujumoneymidx=Rs(9)
    sujumoneymdate=Rs(10)
    sujumoneymeidx=Rs(11)
    sujumoneymedate=Rs(12)    

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
    <title>jQuery Multi Input and Select Example</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 

    <script>
        function validateForm(){
                document.frmMain.submit();
            }
    </script>
    <script>// SUJUINDBB.asp 와 SUJUINDBBU.asp
    function setupFormHandler(formId, inputIds, selectIds) {
        const form = document.getElementById(formId);
        const inputs = inputIds.map((id) => document.getElementById(id));
        const selects = selectIds.map((id) => document.getElementById(id));

        form.addEventListener('keydown', (event) => {
            if (event.key === 'Enter') {
                event.preventDefault();
                const allFilled = inputs.every((input) => input.value.trim() !== '');
                if (allFilled) {
                    form.submit();
                }
            }
        });
        selects.forEach((select) => {
            select.addEventListener('change', () => {
                const allFilled = inputs.every((input) => input.value.trim() !== '');
                if (allFilled) {
                    form.submit();
                }
            });
        });
    }
    document.addEventListener('DOMContentLoaded', () => {
        // 첫 번째 폼 설정
        setupFormHandler('myForm', ['goidx', 'sjaidx','goprice','goname','rsplit','baridx','barlistprice','barNAME'], ['rsplit1']);
        // 두 번째 폼 설정
        setupFormHandler('myForm1', ['QTYIDX', 'QTYprice', 'QTYNAME', 'sjbqty', 'sjbwide', 'sjbwidePRICE', 'sjbhigh', 'sjbhighPRICE', 'sjbwitch', 'sjbbigo'
                        , 'sjgonggeumgaaek', 'sjwondanga', 'sjchugageum', 'sjDCdanga', 'sjgeumaek', 'sjdanga', 'sjseaek', 'glidx', 'glprice', 'gldepth'
                        , 'SANGBUIDX', 'SANGbuprice', 'SANGbuname', 'pidx', 'pprice', 'pname', 'rHABUIDX', 'rHAbuprice', 'rHAbuname'
                        , 'kyidx1', 'kyprice1', 'kyname1', 'kyidx2', 'kyprice2', 'kyname2', 'sjbkey3', 'sjbkey4', 'kyidx3', 'kyprice3', 'kyname3'
                        , 'kyidx4', 'kyprice4', 'kyname4', 'sjbkey7', 'sjbkey8', 'tagongidx1', 'tagongprice1', 'tagongname1', 'sjbtagong4', 'sjbtagong5'
                        , 'tagongidx2', 'tagongprice2', 'tagongname2', 'sjbtagong7', 'sjbtagong8', 'sjbtagong9', 'sjbtagong10', 'sjbtagong11'
                        , 'hingeidx', 'hingeprice', 'hingename1', 'hingeidx1', 'hingeprice1', 'hingecenter1', 'sjbhingedown2', 'sjbhingedown3'
                        , 'hingeidx3', 'hingeprice3', 'hingename2', 'hingeidx4', 'hingeprice4', 'hingecenter2', 'sjbhingeup2', 'sjbhingeup3'
                        , 'sjbkyukja1', 'kyukjaprice', 'kyukjaname', 'sjbkyukja2', 'sjbkyukja3', 'sjbkyukja4', 'sjbkyukja5', 'sjbkyukja6'
                        , 'sjbkyukja7', 'sjbkyukja8']
                        , ['sjbjaejil', 'sjbbanghyang', 'sjbglass', 'sjbsangbar', 'sjbpaint', 'sjbhabar', 'sjbkey1', 'sjbkey2'
                        , 'sjbkey5', 'sjbkey6', 'sjbtagong1', 'sjbtagong2', 'sjbtagong3', 'sjbtagong6', 'sjbhingedown', 'sjbhingedown1', 'sjbhingeup', 'sjbhingeup1']);
    });
    </script>
    <script>
        $(document).ready(function() {
            function updateResults() {
                // Get the input value
                const inputVal1 = parseFloat($('#goprice').val()) || 0;
                // Get the select value and split it
                const selectVal1 = $('#rsplit1').val();
                const parts1 = selectVal1.split('_'); // Split the value into parts
                const selectVal2 = $('#rsplit2').val();
                const parts2 = selectVal2.split('_'); // Split the value into parts


                const baridx = parseFloat(parts1[0]) || 0; // Get the first number
                const barlistprice = parseFloat(parts1[1]) || 0; // Get the second number
                const barNAME = parts1[2] || ''; // Get the third text
                const QTYIDX = parseFloat(parts2[0]) || 0; // Get the first number
                const QTYprice = parseFloat(parts2[1]) || 0; // Get the second number
                const QTYNAME = parts2[2] || ''; // Get the third text

          

                // Calculate the sum
                const sum = inputVal1 + barlistprice + QTYprice;

                // Update the result fields
                $('#baridx').val(baridx); // Display the first value
                $('#barNAME').val(barNAME); // Display the third text
                $('#QTYIDX').val(QTYIDX); // Display the first value
                $('#QTYNAME').val(QTYNAME); // Display the third text  

                $('#sjwondanga').val(sum); // Display the sum

                let   sjwondanga = parseFloat($('#sjwondanga').val()) || 0;  
                let   sjchugageum = parseFloat($('#sjchugageum').val()) || 0;
                let   sjDCdanga = parseFloat($('#sjDCdanga').val()) || 0;
                let   sjbqty = parseFloat($('#sjbqty').val()) || 0;

                const   sjgonggeumgaaek = sjwondanga + sjchugageum  - sjDCdanga;
                const   sjseaek =  sjgonggeumgaaek * 0.1;
                const   sjdanga = sjwondanga + sjchugageum; 
                const   sjgeumaek = (sjgonggeumgaaek) * sjbqty;

                const roundedSjseaek = Math.round(sjseaek / 1) * 1


                $('#sjgonggeumgaaek').val(sjgonggeumgaaek); 
                $('#sjseaek').val(roundedSjseaek); 
                $('#sjdanga').val(sjdanga); 
                $('#sjgeumaek').val(sjgeumaek); 

            }

            // Bind event listeners
            $('#goprice, #rsplit1, #rsplit2 ').on('input change', updateResults);
            $('#sjwondanga, #sjchugageum, #sjDCdanga , #sjbqty').on('input change', updateResults);
        });
    </script>   
    <script>
        $(document).ready(function() {
            function updateResults1() {

                // Get the select value and split it
                const selectVal3 = $('#rsplit3').val();
                const parts3 = selectVal3.split('_'); // Split the value into parts
                const selectVal4 = $('#rsplit4').val();
                const parts4 = selectVal4.split('_'); // Split the value into parts
                const selectVal5 = $('#rsplit5').val();
                const parts5 = selectVal5.split('_'); // Split the value into parts
                const selectVal6 = $('#rsplit6').val();
                const parts6 = selectVal6.split('_'); // Split the value into parts
                const selectVal7 = $('#rsplit7').val();
                const parts7 = selectVal7.split('_'); // Split the value into parts
                const selectVal8 = $('#rsplit8').val();
                const parts8 = selectVal8.split('_'); // Split the value into parts
                const selectVal9 = $('#rsplit9').val();
                const parts9 = selectVal9.split('_'); // Split the value into parts
                const selectVal10 = $('#rsplit10').val();
                const parts10 = selectVal10.split('_'); // Split the value into parts
                const selectVal11 = $('#rsplit11').val();
                const parts11 = selectVal11.split('_'); // Split the value into parts
                const selectVal12 = $('#rsplit12').val();
                const parts12 = selectVal12.split('_'); // Split the value into parts
                const selectVal13 = $('#rsplit13').val();
                const parts13 = selectVal13.split('_'); // Split the value into parts
                const selectVal14 = $('#rsplit14').val();
                const parts14 = selectVal14.split('_'); // Split the value into parts
                const selectVal15 = $('#rsplit15').val();
                const parts15 = selectVal15.split('_'); // Split the value into parts
                const selectVal16 = $('#rsplit16').val();
                const parts16 = selectVal16.split('_'); // Split the value into parts

                const glidx = parseFloat(parts3[0]) || 0; // Get the first number
                const glprice = parseFloat(parts3[1]) || 0; // Get the second number
                const gldepth = parts3[2] || ''; // Get the third text
                const SANGBUIDX = parseFloat(parts4[0]) || 0; // Get the first number
                const SANGbuprice = parseFloat(parts4[1]) || 0; // Get the second number
                const SANGbuname = parts4[2] || ''; // Get the third text
                const pidx = parseFloat(parts5[0]) || 0; // Get the first number
                const pprice = parseFloat(parts5[1]) || 0; // Get the second number
                const pname = parts5[2] || ''; // Get the third text
                const rHABUIDX = parseFloat(parts6[0]) || 0; // Get the first number
                const rHAbuprice = parseFloat(parts6[1]) || 0; // Get the second number
                const rHAbuname = parts6[2] || ''; // Get the third text
                const kyidx1 = parseFloat(parts7[0]) || 0; // Get the first number
                const kyprice1 = parseFloat(parts7[1]) || 0; // Get the second number
                const kyname1 = parts7[2] || ''; // Get the third text
                const kyidx2 = parseFloat(parts8[0]) || 0; // Get the first number
                const kyprice2 = parseFloat(parts8[1]) || 0; // Get the second number
                const kyname2 = parts8[2] || ''; // Get the third text
                const kyidx3 = parseFloat(parts9[0]) || 0; // Get the first number
                const kyprice3 = parseFloat(parts9[1]) || 0; // Get the second number
                const kyname3 = parts9[2] || ''; // Get the third text
                const kyidx4 = parseFloat(parts10[0]) || 0; // Get the first number
                const kyprice4 = parseFloat(parts10[1]) || 0; // Get the second number
                const kyname4 = parts10[2] || ''; // Get the third text
                const tagongidx1 = parseFloat(parts11[0]) || 0; // Get the first number
                const tagongprice1 = parseFloat(parts11[1]) || 0; // Get the second number
                const tagongname1 = parts11[2] || ''; // Get the third text
                const tagongidx2 = parseFloat(parts12[0]) || 0; // Get the first number
                const tagongprice2 = parseFloat(parts12[1]) || 0; // Get the second number
                const tagongname2 = parts12[2] || ''; // Get the third text
                const hingeidx = parseFloat(parts13[0]) || 0; // Get the first number
                const hingeprice = parseFloat(parts13[1]) || 0; // Get the second number
                const hingename1 = parts13[2] || ''; // Get the third text
                const hingeidx1 = parseFloat(parts14[0]) || 0; // Get the first number
                const hingeprice1 = parseFloat(parts14[1]) || 0; // Get the second number
                const hingecenter1 = parts14[2] || ''; // Get the third text
                const hingeidx3 = parseFloat(parts15[0]) || 0; // Get the first number
                const hingeprice3 = parseFloat(parts15[1]) || 0; // Get the second number
                const hingename2 = parts15[2] || ''; // Get the third text
                const hingeidx4 = parseFloat(parts16[0]) || 0; // Get the first number
                const hingeprice4 = parseFloat(parts16[1]) || 0; // Get the second number
                const hingecenter2 = parts16[2] || ''; // Get the third text

                // Calculate the sum
                const sum1 = glprice + SANGbuprice + pprice + rHAbuprice + kyprice1 + kyprice2 + kyprice3 + tagongprice1 + tagongprice2 
                + hingeprice+ hingeprice1 + hingeprice3 + hingeprice4 ;

                // Update the result fields
                $('#glidx').val(glidx);
                $('#gldepth').val(gldepth); 
                $('#SANGBUIDX').val(SANGBUIDX);
                $('#SANGbuname').val(SANGbuname); 
                $('#pidx').val(pidx);
                $('#pname').val(pname); 
                $('#rHABUIDX').val(rHABUIDX);
                $('#rHAbuname').val(rHAbuname); 
                $('#kyidx1').val(kyidx1);
                $('#kyname1').val(kyname1); 
                $('#kyidx2').val(kyidx2);
                $('#kyname2').val(kyname2); 
                $('#kyidx3').val(kyidx3);
                $('#kyname3').val(kyname3); 
                $('#kyidx4').val(kyidx4);
                $('#kyname4').val(kyname4); 
                $('#tagongidx1').val(tagongidx1);
                $('#tagongname1').val(tagongname1); 
                $('#tagongidx2').val(tagongidx2);
                $('#tagongname2').val(tagongname2); 
                $('#hingeidx').val(hingeidx);
                $('#hingename1').val(hingename1); 
                $('#hingeidx1').val(hingeidx1);
                $('#hingecenter1').val(hingecenter1); 
                $('#hingeidx3').val(hingeidx3);
                $('#hingename2').val(hingename2); 
                $('#hingeidx4').val(hingeidx4);
                $('#hingecenter2').val(hingecenter2); 

                $('#sjchugageum').val(sum1); // Display the sum

                let   sjwondanga = parseFloat($('#sjwondanga').val()) || 0;  
                let   sjchugageum = parseFloat($('#sjchugageum').val()) || 0;
                let   sjDCdanga = parseFloat($('#sjDCdanga').val()) || 0;
                let   sjbqty = parseFloat($('#sjbqty').val()) || 0;

                const   sjgonggeumgaaek = sjwondanga + sjchugageum  - sjDCdanga;
                const   sjseaek =  sjgonggeumgaaek * 0.1;
                const   sjdanga = sjwondanga + sjchugageum; 
                const   sjgeumaek = (sjgonggeumgaaek) * sjbqty;

                const roundedSjseaek = Math.round(sjseaek / 100) * 100

                $('#sjgonggeumgaaek').val(sjgonggeumgaaek); 
                $('#sjseaek').val(roundedSjseaek); 
                $('#sjdanga').val(sjdanga); 
                $('#sjgeumaek').val(sjgeumaek); 

            }

            // Bind event listeners
            $('#rsplit3, #rsplit4, #rsplit5, #rsplit6, #rsplit7, #rsplit8, #rsplit9, #rsplit10, #rsplit11, #rsplit12, #rsplit13, #rsplit14, #rsplit15, #rsplit16').on('input change', updateResults1);
            $('#sjwondanga, #sjchugageum, #sjDCdanga , #sjbqty').on('input change', updateResults1);
        });
    </script> 

    <title>텍스트 방향 설정 예제</title> 
    <style> 
    .horizontal-text { 
      writing-mode: horizontal-tb; /* 텍스트를 가로로 설정 */ 
      transform: rotate(0deg); /* 기본적으로 0도 회전 */ 
      font-size: 12px; /* 폰트 크기를 10px로 설정 */
    } 
    </style>
  </head>
  <body class="sb-nav-fixed">
<!--#include virtual="/inc/top.asp"-->
<!--#include virtual="/inc/left1.asp"-->


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
              <input type="text" class="form-control" id="" name="" placeholder="" value="<%=cname%>" onclick="location.replace('/mem/corplist.asp');">
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
            <button type="button" class="btn btn-info" onClick="location.replace('/mes/sujuin.asp?cidx=<%=rcidx%>&gubun=new')">수주등록</button>
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
<!--품명 시작 -->
<form id="myForm" name="myForm" action="sujuindbb.asp" method="post"> 
    <input type="hidden" id="goidx" name="goidx" value="<%=rgoidx%>" >
    <input type="hidden" id="sjaidx" name="sjaidx" value="<%=rsjaidx%>" >
    <input type="hidden" id="goprice" name="goprice" value="<%=goprice%>"  >  <!-- inputVal -->    
    <div class="row">
      <div class="col-md-4">
        <div class="card card-body mb-1">
          <div class="row mb-1">
            <div class="col-1"><label for="name">품명</label></div>
            <div class="col-6">
                <input type="text" class="form-control" id="rsplit" name="sjbpummyoung" placeholder="선택" value="<%=goname%>"
                onclick="window.open('goodch.asp?cidx=<%=rcidx%>&sjaidx=<%=rsjaidx%>','_blank','width=500, height=400, top=200, left=500' );">
            </div>
            <div class="col-5">
            <select name="sjbkukyuk" class="form-control" id="rsplit1"  required>
              <%
              SQL=" select A.sidx, A.baridx, B.barNAME,B.barlistprice "
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
                  barlistprice=Rs(3)
              %>  
              <option value="<%=baridx%>_<%=barlistprice%>_<%=barNAME%>" selected><%=barNAME%></option>
              <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select>
            <!--<input type="hidden" name="baridx" id="baridx" value="<%=baridx%>" >  
            <input type="hidden" name="barlistprice" id="barlistprice" value="<%=barlistprice%>" >                         
            <input type="hidden" name="barNAME" id="barNAME" value="<%=barNAME%>" > -->
            </div>
          </div>
          </form>
          <form id="myForm1" name="myForm1" action="sujuindbbU.asp" method="post"> 
<!--품명 끝 -->
<!--재질 시작 -->
          <div class="row mb-1">
            <div class="col-1"><label for="name">재질</label></div>
            <div class="col-4">
              <select name="sjbjaejil" class="form-control" id="rsplit2" required>
                <%
                SQL=" Select QTYIDX, QTYCODE, QTYNAME, QTYSTATUS, QTYPAINT, QTYINS, QTYLABEL ,QTYPAINTW ,QTYmidx,QTYwdate , qtype, taidx, ATYPE,QTYprice"
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
                QTYprice=Rs(13)
                %>                
                <option value="<%=QTYIDX%>_<%=QTYprice%>" selected><%=QTYNAME%></option>
                <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select>
                <input type="hidden" name="QTYIDX" id="QTYIDX" value="<%=QTYIDX%>" > 
                <input type="hidden" name="QTYprice" id="QTYprice" value="<%=QTYprice%>" > 
                <input type="hidden" name="QTYNAME" id="QTYNAME" value="<%=QTYNAME%>" >                                 
            </div>
            <div class="col-1"><label for="name" >수량</label></div>
            <div class="col-2">
            <input type="number" class="form-control" id="sjbqty" name="sjbqty" placeholder="" value="<%=sjbqty%>"  >
            </div>
        </div>
<!--재질 끝 -->
<!--규격,방향 시작 -->

          <div class="row mb-1">
          <div class="col-1"><label for="name">규격</label></div> 
          <div class="col-3">
              <input type="number" class="form-control" id="sjbwide" name="sjbwide" placeholder="가로" value="<%=sjbwide%>" required>
              <input type="number" name="sjbwidePRICE"  id="sjbwidePRICE" value="<%=sjbwidePRICE%>">
          </div>     
              <div class="col-1">X</div>
          <div class="col-3">    
              <input type="number" class="form-control" id="sjbhigh" name="sjbhigh" placeholder="세로" value="<%=sjbhigh%>" >
              <input type="number" name="sjbhighPRICE" id="sjbhighPRICE" value="<%=sjbhighPRICE%>" >
          </div>    
          
            <script>
    document.addEventListener("DOMContentLoaded", function () {
        const baseSelector = document.getElementById('baseSelector');
        const sjbwideInput = document.getElementById('sjbwide');
        const sjbwidePriceInput = document.getElementById('sjbwidePRICE');
        const sjbhighInput = document.getElementById('sjbhigh');
        const sjbhighPriceInput = document.getElementById('sjbhighPRICE');

        // 기준점 값 설정 함수
        function getBaseValues(option) {
            switch (option) {
                case '1':
                    return { wide: 910, high: 2115, wideMax: 2460, highMax: 3565 };
                case '2':
                    return { wide: 1010, high: 2215, wideMax: 2460, highMax: 3565 };
                case '3':
                    return { wide: 1010, high: 2415, wideMax: 2460, highMax: 3565 };
                default:
                    return { wide: 910, high: 2115, wideMax: 2460, highMax: 3565 }; // 기본값
            }
        }

        // 범위에 따른 가격 계산 함수
        function calculatePrice(value, baseValue, maxValue) {
            if (value > maxValue) value = maxValue; // 입력값이 최대값을 초과하지 않게 제한
            if (value <= baseValue) return 0;
            for (let i = baseValue + 50, price = 1; i <= maxValue; i += 50, price++) {
                if (value <= i) return price;
            }
            return Math.ceil((value - baseValue) / 50);
        }

        // 입력 필드 스타일 업데이트 함수
        function updateInputStyle(inputField, value, maxValue) {
            if (value >= maxValue) {
                inputField.style.color = "red";
                inputField.style.fontWeight = "bold";
            } else {
                inputField.style.color = "";
                inputField.style.fontWeight = "";
            }
        }

        // 가격 업데이트 함수
        function updatePrices() {
            const selectedOption = baseSelector.value;
            const { wide: baseWideValue, high: baseHighValue, wideMax: baseWideMax, highMax: baseHighMax } = getBaseValues(selectedOption);

            let sjbwideValue = parseInt(sjbwideInput.value, 10) || 0;
            let sjbhighValue = parseInt(sjbhighInput.value, 10) || 0;

            // 입력값 제한
            if (sjbwideValue > baseWideMax) {
                sjbwideValue = baseWideMax;
                sjbwideInput.value = baseWideMax; // 입력값 수정
            }
            if (sjbhighValue > baseHighMax) {
                sjbhighValue = baseHighMax;
                sjbhighInput.value = baseHighMax; // 입력값 수정
            }

            // 스타일 업데이트
            updateInputStyle(sjbwideInput, sjbwideValue, baseWideMax);
            updateInputStyle(sjbhighInput, sjbhighValue, baseHighMax);

            // 가격 계산
            const widePrice = calculatePrice(sjbwideValue, baseWideValue, baseWideMax);
            const highPrice = calculatePrice(sjbhighValue, baseHighValue, baseHighMax);

            // 가격 업데이트
            sjbwidePriceInput.value = widePrice;
            sjbhighPriceInput.value = highPrice;
        }

        // 이벤트 리스너 등록
        baseSelector.addEventListener('change', updatePrices);
        sjbwideInput.addEventListener('input', updatePrices);
        sjbhighInput.addEventListener('input', updatePrices);

        // 초기값 설정
        updatePrices();
    });
</script>
            
            <div class="col-2"><label for="name">방향</label></div>
            <div class="col-2">
           <select name="sjbbanghyang" class="form-control" id="sjbbanghyang" required >
              <option value="1" <% if sjbbanghyang="1" then %> selected <% end if %>>좌</option>
              <option value="2" <% if sjbbanghyang="2" then %> selected <% end if %>>우 </option>
              <option value="3" <% if sjbbanghyang="3" then %> selected <% end if %>>양개(좌)</option>
              <option value="4" <% if sjbbanghyang="4" then %> selected <% end if %>>양개(우)</option>
              <option value="5" <% if sjbbanghyang="5" then %> selected <% end if %>>양개</option>              
            </select>
            </div>
            </div>
<!--규격,방향 끝 -->
<!--위치,비고 시작 -->

          <div class="row mb-1">
            <div class="col-2"><label for="name">위치</label></div>
            <div class="col-10">
              <input type="text" class="form-control" id="sjbwitch" name="sjbwitch" placeholder="" value="<%=sjbwitch%>" >
            </div>
          </div>

          <div class="row mb-1">
            <div class="col-2"><label for="name">비고</label></div>
            <div class="col-10">
              <input type="text" class="form-control" id="sjbbigo" name="sjbbigo" placeholder="" value="<%=sjbbigo%>" >
            </div>
          </div>
<!--위치,비고 끝 -->
<!--합계 시작 -->
            <div class="row mb-1">
                <div class="row"><label for="name">합계</label>
                <div class="row">
                    <div class="col-md-3">
                        <label for="name" >사이즈할인</label>
                        <select id="baseSelector" class="form-control" name="SizeDC">
                        <option value="1">SIZE 1</option>
                        <option value="2">SIZE 2</option>
                        <option value="3">SIZE 3</option>
                        </select>
                    </div> 
                    <div class="col-md-3">
                        <label for="name">등급별할인</label>
                        <input type="number" class="form-control" id="levelDC" name="levelDC" placeholder="" value="<%=sjgeumaek%>"  >
                    </div> 
                    <div class="col-md-3">
                        <label for="name">%할인</label>
                        <input type="number" class="form-control" id="proTGDC" name="proTGDC" placeholder="" value="<%=sjdanga%>"  >
                    </div>
                    <div class="col-md-3">
                        <label for="name">타공/키할인</label>
                        <input type="number" class="form-control" id="tgkeyDC" name="tgkeyDC" placeholder="" value="<%=sjseaek%>"  >
                    </div> 
                </div>
                    <div class="col-md-3">
                        <label for="name">공급가액</label>
                        <input type="number" class="form-control" id="sjgonggeumgaaek" name="sjgonggeumgaaek" placeholder="" value="<%=sjgonggeumgaaek%>"  >
                    </div>
                    <div class="col-md-3">
                        <label for="name">기본단가</label>
                        <input type="number" class="form-control" id="sjwondanga" name="sjwondanga" placeholder="" value="<%=sjwondanga%>" >
                    </div>
                    <div class="col-md-3">
                        <label for="name">추가금</label>
                        <input type="number" class="form-control" id="sjchugageum" name="sjchugageum" placeholder="" value="<%=sjchugageum%>"  >
                    </div>  
                    <div class="col-md-3">
                        <label for="name">할인단가</label>
                        <input type="number" class="form-control" id="sjDCdanga" name="sjDCdanga" placeholder="" value="<%=sjDCdanga%>"  >
                    </div>  
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label for="name">총금액</label>
                        <input type="number" class="form-control" id="sjgeumaek" name="sjgeumaek" placeholder="" value="<%=sjgeumaek%>"  >
                    </div> 
                    <div class="col-md-3">
                        <label for="name">단가</label>
                        <input type="number" class="form-control" id="sjdanga" name="sjdanga" placeholder="" value="<%=sjdanga%>"  >
                    </div>
                    <div class="col-md-3">
                        <label for="name">세액</label>
                        <input type="number" class="form-control" id="sjseaek" name="sjseaek" placeholder="" value="<%=sjseaek%>"  >
                    </div> 
                    <div class="col-md-3">
                        <label for="name">..</label>
                        <input type="number" class="form-control" id="" name="" placeholder="" value=""  >
                    </div>
                </div>
                
            </div>
<!--합계 끝 -->
<!--유리 시작 -->        

        </div>
      </div>
      <div class="col-md-4">
        <div class="card card-body mb-1">

          <div class="row mb-1">
            <div class="col-2"><label for="name">유리</label></div>
            <div class="col-4">
                <select name="sjbglass" class="form-control" id="rsplit3" required>
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
                        <option value="<%=glidx%>_<%=glprice%>_<%=gldepth%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=gldepth%>mm</option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="glidx" id="glidx" value="<%=glidx%>" > 
                <input type="hidden" name="glprice" id="glprice" value="<%=glprice%>" > 
                <input type="hidden" name="gldepth" id="gldepth" value="<%=gldepth%>" >   
            </div>
<!--유리 끝 -->
<!--상바 시작 -->               
          <div class="col-2"><label for="name">상바</label></div>
            <div class="col-4">
                <select name="sjbsangbar" class="form-control" id="rsplit4" required>
                    <%
                    SQL=" Select BUIDX, buname, bustatus, bumidx, atype,buprice "
                    SQL=SQL&" From tk_busok "
                    SQL=SQL&" Where atype=1 "
                    'Response.write (SQL)	
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    SANGBUIDX=Rs(0)
                    SANGbuname=Rs(1)
                    bustatus=Rs(2)
                    bumidx=Rs(3)
                    atype=rs(4)
                    SANGbuprice=rs(5)
                    %>                
                        <option value="<%=SANGBUIDX%>_<%=SANGbuprice%>_<%=SANGbuname%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=SANGbuname%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="SANGBUIDX" id="SANGBUIDX" value="<%=SANGBUIDX%>" > 
                <input type="hidden" name="SANGbuprice" id="SANGbuprice" value="<%=SANGbuprice%>" > 
                <input type="hidden" name="SANGbuname" id="SANGbuname" value="<%=SANGbuname%>" >
            </div>
          </div>
<!--상바 끝 -->
<!--도장 시작 -->    
        <div class="row mb-1">
            <div class="col-2"><label for="name">도장</label></div>
            <div class="col-4">
                <select name="sjbpaint" class="form-control" id="rsplit5" required>
                    <%
                    SQL=" Select pidx, pcode, pshorten, pname, pprice, pmidx, pwdate ,pemidx, pewdate"
                    SQL=SQL&" From tk_paint"
                    SQL=SQL&" Where pstatus=1 "
                    RESPONSE.WRITE SQL 
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    pidx=Rs(0)
                    pcode=Rs(1)
                    pshorten=Rs(2)
                    pname=Rs(3)
                    pprice=Rs(4)
                    pmidx=Rs(5)
                    pwdate=Rs(6)
                    pemidx=Rs(7)
                    pewdate=Rs(8)
                    %>                
                        <option value="<%=pidx%>_<%=pprice%>_<%=pname%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=pname%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="pidx" id="pidx" value="<%=pidx%>" > 
                <input type="hidden" name="pprice" id="pprice" value="<%=pprice%>" > 
                <input type="hidden" name="pname" id="pname" value="<%=pname%>" >
            </div>
<!--도장 끝 -->
<!--하바 시작 -->              
            <div class="col-2"><label for="name">하바</label></div>
            <div class="col-4">
                <select name="sjbhabar" class="form-control" id="rsplit6" required>
                    <%
                    SQL=" Select BUIDX, buname, bustatus, bumidx, atype,buprice "
                    SQL=SQL&" From tk_busok "
                    SQL=SQL&" Where atype=1 "
                    'Response.write (SQL)	
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    rHABUIDX=Rs(0)
                    rHAbuname=Rs(1)
                    bustatus=Rs(2)
                    bumidx=Rs(3)
                    atype=rs(4)
                    rHAbuprice=rs(5)
                    %>                
                        <option value="<%=rHABUIDX%>_<%=rHAbuprice%>_<%=rHAbuname%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=rHAbuname%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="rHABUIDX" id="rHABUIDX" value="<%=rHABUIDX%>" > 
                <input type="hidden" name="rHAbuprice" id="rHAbuprice" value="<%=rHAbuprice%>" > 
                <input type="hidden" name="rHAbuname" id="rHAbuname" value="<%=rHAbuname%>" >
            </div>
        </div>
<!--하바 끝 -->
<!--키 시작 -->   
        <div class="row mb-1">
            <div class="col-2"><label for="name">키</label></div>
            <div class="col-2">
                <select name="sjbkey1" class="form-control" id="rsplit7" required>
                    <%
                    SQL=" Select kyidx, kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate,kywitch"
                    SQL=SQL&" From tk_key "
                    SQL=SQL&" Where kystatus=2 or kystatus=3 "
                    RESPONSE.WRITE SQL 
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    kyidx1=Rs(0)
                    kycode=Rs(1)
                    kyshorten=Rs(2)
                    kyname1=Rs(3)
                    kyprice1=Rs(4)
                    kymidx=Rs(5)
                    kywdate=Rs(6)
                    kyemidx=Rs(7)
                    kyewdate=Rs(8)
                    kywitch=Rs(9)
                    %>                
                        <option value="<%=kyidx1%>_<%=kyprice1%>_<%=kyname1%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=kyname1%></option>
                        
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="kyidx1" id="kyidx1" value="<%=kyidx1%>" > 
                <input type="hidden" name="kyprice1" id="kyprice1" value="<%=kyprice1%>" > 
                <input type="hidden" name="kyname1" id="kyname1" value="<%=kyname1%>" >
            </div>
            <div class="col-3">
             <select name="sjbkey2" class="form-control" id="rsplit8" required>
                    <%
                    SQL=" Select kyidx, kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate,kywitch"
                    SQL=SQL&" From tk_key "
                    SQL=SQL&" Where kystatus=1  "
                    RESPONSE.WRITE SQL 
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    kyidx2=Rs(0)
                    kycode=Rs(1)
                    kyshorten=Rs(2)
                    kyname2=Rs(3)
                    kyprice2=Rs(4)
                    kymidx=Rs(5)
                    kywdate=Rs(6)
                    kyemidx=Rs(7)
                    kyewdate=Rs(8)
                    kywitch=Rs(9)
                    %>                
                        <option value="<%=kyidx2%>_<%=kyprice2%>_<%=kyname2%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=kyname2%></option>
                        
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="kyidx2" id="kyidx2" value="<%=kyidx2%>" > 
                <input type="hidden" name="kyprice2" id="kyprice2" value="<%=kyprice2%>" > 
                <input type="hidden" name="kyname2" id="kyname2" value="<%=kyname2%>" >
            </div>
            <div class="col-3">
                <input type="text" class="form-control" id="sjbkey3" name="sjbkey3" placeholder="중키높이지정" value="<%=sjbkey3%>" >
            </div>
            <div class="col-2">
                <input type="text" class="form-control" id="sjbkey4" name="sjbkey4" placeholder="수기단가입력" value="<%=sjbkey4%>" >
            </div>
        </div>
        <div class="row mb-1">   
            <div class="col-2"><label for="name">&nbsp;</label></div>
            <div class="col-2">
            <select name="sjbkey5" class="form-control" id="rsplit9" required>
                <%
                SQL=" Select kyidx, kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate"
                SQL=SQL&" From tk_key "
                SQL=SQL&" Where kystatus=3 or kystatus=4 "
                RESPONSE.WRITE SQL 
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do until Rs.EOF
                kyidx3=Rs(0)
                kycode=Rs(1)
                kyshorten=Rs(2)
                kyname3=Rs(3)
                kyprice3=Rs(4)
                kymidx=Rs(5)
                kywdate=Rs(6)
                kyemidx=Rs(7)
                kyewdate=Rs(8)
                %>                
                    <option value="<%=kyidx3%>_<%=kyprice3%>_<%=kyname3%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=kyname3%></option>
                <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select>
                <input type="hidden" name="kyidx3" id="kyidx3" value="<%=kyidx3%>" > 
                <input type="hidden" name="kyprice3" id="kyprice3" value="<%=kyprice3%>" > 
                <input type="hidden" name="kyname3" id="kyname3" value="<%=kyname3%>" >
            </div>
            <div class="col-3">
                <select name="sjbkey6" class="form-control" id="rsplit10" required>
                <%
                SQL=" Select kyidx, kycode, kyshorten, kyname, kyprice, kymidx, kywdate ,kyemidx, kyewdate"
                SQL=SQL&" From tk_key "
                SQL=SQL&" Where kystatus=1 "
                RESPONSE.WRITE SQL 
                Rs.open Sql,Dbcon
                If Not (Rs.bof or Rs.eof) Then 
                Do until Rs.EOF
                kyidx4=Rs(0)
                kycode=Rs(1)
                kyshorten=Rs(2)
                kyname4=Rs(3)
                kyprice4=Rs(4)
                kymidx=Rs(5)
                kywdate=Rs(6)
                kyemidx=Rs(7)
                kyewdate=Rs(8)
                %>                
                    <option value="<%=kyidx4%>_<%=kyprice4%>_<%=kyname4%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=kyname4%></option>
                <%
                Rs.MoveNext
                Loop
                End If
                Rs.close
                %>
            </select> 
            <input type="hidden" name="kyidx4" id="kyidx4" value="<%=kyidx4%>" > 
            <input type="hidden" name="kyprice4" id="kyprice4" value="<%=kyprice4%>" > 
            <input type="hidden" name="kyname4" id="kyname4" value="<%=kyname4%>" >        
            </div>
            <div class="col-3">
                <input type="text" class="form-control" id="sjbkey7" name="sjbkey7" placeholder="중키높이지정" value="<%=sjbkey7%>" >          
            </div>
            <div class="col-2">
                <input type="text" class="form-control" id="sjbkey8" name="sjbkey8" placeholder="수기단가입력" value="<%=sjbkey8%>" >          
            </div>

        </div>
<!--키 끝 -->
<!--손잡이 1시작 -->   

            <div class="row mb-1">
                <div class="col-1"><label for="name"  class="horizontal-text" >핸들</label></div>
                <div class="col-3"><label for="name" class="horizontal-text" >타공</label>

                <select name="sjbtagong1" class="form-control" id="rsplit11" required>
                    <%
                    SQL=" Select tagongidx, tagongcode, tagongshorten, tagongname, tagongpunch, tagongprice, tagongmidx, tagongwdate ,tagongemidx, tagongewdate"
                    SQL=SQL&" From tk_tagong "
                    SQL=SQL&" Where tagongstatus=1 "
                    'RESPONSE.WRITE (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    tagongidx1=Rs(0)
                    tagongcode=Rs(1)
                    tagongshorten=Rs(2)
                    tagongname1=Rs(3)
                    tagongunch=Rs(4)                        
                    tagongprice1=Rs(5)
                    tagongmidx=Rs(6)
                    tagongwdate=Rs(7)
                    tagongemidx=Rs(8)
                    tagongewdate=Rs(9)
                    %>                
                        <option value="<%=tagongidx1%>_<%=tagongprice1%>_<%=tagongname1%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=tagongname1%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select>
                <input type="hidden" name="tagongidx1" id="tagongidx1" value="<%=tagongidx1%>" > 
                <input type="hidden" name="tagongprice1" id="tagongprice1" value="<%=tagongprice1%>" > 
                <input type="hidden" name="tagongname1" id="tagongname1" value="<%=tagongname1%>" >  
                </div>
                <div class="col-3"><label for="name" class="horizontal-text" >타공거리</label>
                    <select class="form-select" name="sjbtagong2" id="sjbtagong2">
                        <option value="1" <% if sjbtagong2="1" then  %>selected<% end if %>>900-340</option>
                        <option value="2" <% if sjbtagong2="2" then  %>selected<% end if %>>800-600</option>
                        <option value="3" <% if sjbtagong2="3" then  %>selected<% end if %>>600-800</option>
                        <option value="4" <% if sjbtagong2="4" then  %>selected<% end if %>>600-1000</option>
                        <option value="5" <% if sjbtagong2="4" then  %>selected<% end if %>>C1200</option> 
                    </select>   

                </div>
                <div class="col-1"><label for="name" class="horizontal-text" >폭</label>
                    <select name="sjbtagong3" class="form-control" id="sjbtagong3" required>
                    <%
                    SQL=" Select B.smidx, B.tagongfok"
                    SQL=SQL&" From tk_stand A "
                    SQL=SQL&" Join tk_material  B On  A.sidx=B.sidx AND B.tagongfok > 0 "
                    SQL=SQL&" Where A.sidx='"&sidx&"'  "
                    RESPONSE.WRITE (SQL)
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    smidx=Rs(0) '기본키
                    tagongfok=Rs(1)
                    %>                
                        <option value="<%=tagongfok%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=tagongfok%></option>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %>
                </select> 
                </div>
                <div class="col-2"><label for="name" class="horizontal-text" >높이</label>
                    <input type="text" class="form-control" id="sjbtagong4" name="sjbtagong4" placeholder="" value="<%=sjbtagong4%>" >           
                </div>
                <div class="col-2"><label for="name" class="horizontal-text" >추가금</label>
                    <input type="text" class="form-control" id="sjbtagong5" name="sjbtagong5" placeholder="" value="<%=sjbtagong5%>" >           
                </div>                             
            </div>
<!--손잡이 1끝 -->
<!--타공위치 시작 -->   

            <div class="row mb-1">
            <div class="col-2">
                <div class="col-4"><label for="name" class="horizontal-text">위치</label></div>
                <select name="sjbtagong6" class="form-control" id="rsplit12" required>
                  <%
                  SQL=" Select tagongidx, tagongcode, tagongshorten, tagongname, tagongpunch, tagongprice, tagongmidx, tagongwdate ,tagongemidx, tagongewdate"
                  SQL=SQL&" From tk_tagong "
                  SQL=SQL&" Where tagongstatus=1 "
                  'RESPONSE.WRITE (SQL)
                  Rs.open Sql,Dbcon
                  If Not (Rs.bof or Rs.eof) Then 
                  Do until Rs.EOF
                  tagongidx2=Rs(0)
                  tagongcode=Rs(1)
                  tagongshorten=Rs(2)
                  tagongname2=Rs(3)
                  tagongunch=Rs(4)                        
                  tagongprice2=Rs(5)
                  tagongmidx=Rs(6)
                  tagongwdate=Rs(7)
                  tagongemidx=Rs(8)
                  tagongewdate=Rs(9)
                  %>                
                      <option value="<%=tagongidx2%>_<%=tagongprice2%>_<%=tagongname2%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=tagongname2%>mm</option>
                  <%
                  Rs.MoveNext
                  Loop
                  End If
                  Rs.close
                  %>
              </select>
                <input type="hidden" name="tagongidx2" id="tagongidx2" value="<%=tagongidx2%>" > 
                <input type="hidden" name="tagongprice2" id="tagongprice2" value="<%=tagongprice2%>" > 
                <input type="hidden" name="tagongname2" id="tagongname2" value="<%=tagongname2%>" >  
              </div>
              <div class="col-2"><label for="name" class="horizontal-text" >1홀</label>
                  <input type="text" class="form-control" id="sjbtagong7" name="sjbtagong7" placeholder="" value="<%=sjbtagong7%>" >  

              </div>
              <div class="col-2"><label for="name" class="horizontal-text" >2홀</label>
                  <input type="text" class="form-control" id="sjbtagong8" name="sjbtagong8" placeholder="" value="<%=sjbtagong8%>" > 
              </div>
              <div class="col-2"><label for="name" class="horizontal-text" >3홀</label>
                  <input type="text" class="form-control" id="sjbtagong9" name="sjbtagong9" placeholder="" value="<%=sjbtagong9%>" >           
              </div>
              <div class="col-2"><label for="name" class="horizontal-text" >4홀</label>
                <input type="text" class="form-control" id="sjbtagong10" name="sjbtagong10" placeholder="" value="<%=sjbtagong10%>" >           
            </div>    
              <div class="col-2"><label for="name" class="horizontal-text" >홀수</label> <!--미입력 -->
                <input type="text" class="form-control" id="sjbtagong11" name="sjbtagong11" placeholder="" value="<%=sjbtagong11%>" >           
            </div>                                        
            </div>
<!--타공위치 끝 -->
<!--하롯트 시작 -->   
            <div class="row mb-1">
                <div class="col-2"><label for="name">하롯트</label></div>
                <div class="col-3">
                  <select name="sjbhingedown" id="rsplit13" class="form-control" placeholder="힌지선택">
                  <%
                  SQL=" Select hingeidx, hingecode, hingeshorten, hingename, hingecenter, hingePi, hingeprice, hingestatus ,hingemidx, hingewdate,hingeemidx,hingeewdate,qtype,atype"
                  SQL=SQL&" From tk_hinge "
                  SQL=SQL&" Where qtype=0 "
                  'RESPONSE.WRITE (SQL)
                  Rs.open Sql,Dbcon
                  If Not (Rs.bof or Rs.eof) Then 
                  Do until Rs.EOF
                  hingeidx=Rs(0)
                  hingecode=Rs(1)
                  hingeshorten=Rs(2)
                  hingename1=Rs(3)
                  hingecenter=Rs(4)                        
                  hingePi=Rs(5)
                  hingeprice=Rs(6)
                  hingestatus=Rs(7)
                  hingemidx=Rs(8)
                  hingewdate=Rs(9)
                  hingeemidxe=Rs(10)
                  hingeewdatee=Rs(11)
                  qtype=Rs(12)
                  atype=Rs(13)
                  %>                
                      <option value="<%=hingeidx%>_<%=hingeprice%>_<%=hingename1%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=hingename1%></option>
                  <%
                  Rs.MoveNext
                  Loop
                  End If
                  Rs.close
                  %>
                  </select>
                    <input type="hidden" name="hingeidx" id="hingeidx" value="<%=hingeidx%>" > 
                    <input type="hidden" name="hingeprice" id="hingeprice" value="<%=hingeprice%>" > 
                    <input type="hidden" name="hingename1" id="hingename1" value="<%=hingename1%>" >  
                </div>
                <div class="col-2">
                  <select name="sjbhingedown1" id="rsplit14" class="form-control">
                    <%
                  SQL=" Select hingeidx, hingecode, hingeshorten, hingename, hingecenter, hingePi, hingeprice, hingestatus ,hingemidx, hingewdate,hingeemidx,hingeewdate,qtype,atype"
                  SQL=SQL&" From tk_hinge "
                  SQL=SQL&" Where qtype=0 "
                  'RESPONSE.WRITE (SQL)
                  Rs.open Sql,Dbcon
                  If Not (Rs.bof or Rs.eof) Then 
                  Do until Rs.EOF
                  hingeidx1=Rs(0)
                  hingecode=Rs(1)
                  hingeshorten=Rs(2)
                  hingename=Rs(3)
                  hingecenter1=Rs(4)                        
                  hingePi=Rs(5)
                  hingeprice1=Rs(6)
                  hingestatus=Rs(7)
                  hingemidx=Rs(8)
                  hingewdate=Rs(9)
                  hingeemidxe=Rs(10)
                  hingeewdatee=Rs(11)
                  qtype=Rs(12)
                  atype=Rs(13)
                  %>                
                      <option value="<%=hingeidx1%>_<%=hingeprice1%>_<%=hingecenter1%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=hingecenter1%>mm</option>
                  <%
                  Rs.MoveNext
                  Loop
                  End If
                  Rs.close
                  %>                   
                  </select>
                  <input type="hidden" name="hingeidx1" id="hingeidx1" value="<%=hingeidx1%>" > 
                    <input type="hidden" name="hingeprice1" id="hingeprice1" value="<%=hingeprice1%>" > 
                    <input type="hidden" name="hingecenter1" id="hingecenter1" value="<%=hingecenter1%>" >  
                </div>
                <div class="col-3">
                  <input type="text" class="form-control" id="sjbhingedown2" name="sjbhingedown2" placeholder="" value="<%=sjbhingedown2%>" >          
                </div>
                <div class="col-2">
                  <input type="text" class="form-control" id="sjbhingedown3" name="sjbhingedown3" placeholder="" value="<%=sjbhingedown3%>" >          
                </div> 
<!--하롯트 끝 -->
<!--상롯트 시작 -->                                
                <div class="col-2"><label for="name">상롯트</label></div>                
                <div class="col-3">
                  <select name="sjbhingeup" id="rsplit15" class="form-control">
                    <%
                  SQL=" Select hingeidx, hingecode, hingeshorten, hingename, hingecenter, hingePi, hingeprice, hingestatus ,hingemidx, hingewdate,hingeemidx,hingeewdate,qtype,atype"
                  SQL=SQL&" From tk_hinge "
                  SQL=SQL&" Where qtype=1 "
                  'RESPONSE.WRITE (SQL)
                  Rs.open Sql,Dbcon
                  If Not (Rs.bof or Rs.eof) Then 
                  Do until Rs.EOF
                  hingeidx3=Rs(0)
                  hingecode=Rs(1)
                  hingeshorten=Rs(2)
                  hingename2=Rs(3)
                  hingecenter=Rs(4)                        
                  hingePi=Rs(5)
                  hingeprice3=Rs(6)
                  hingestatus=Rs(7)
                  hingemidx=Rs(8)
                  hingewdate=Rs(9)
                  hingeemidxe=Rs(10)
                  hingeewdatee=Rs(11)
                  qtype=Rs(12)
                  atype=Rs(13)
                  %>                
                      <option value="<%=hingeidx3%>_<%=hingeprice3%>_<%=hingename2%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=hingename2%></option>
                  <%
                  Rs.MoveNext
                  Loop
                  End If
                  Rs.close
                  %>                   
                  </select>
                   <input type="hidden" name="hingeidx3" id="hingeidx3" value="<%=hingeidx3%>" > 
                    <input type="hidden" name="hingeprice3" id="hingeprice3" value="<%=hingeprice3%>" > 
                    <input type="hidden" name="hingename2" id="hingename2" value="<%=hingename2%>" >  
                </div>
                <div class="col-2">
                    <select name="sjbhingeup1" id="rsplit16" class="form-control">
                      <%
                  SQL=" Select hingeidx, hingecode, hingeshorten, hingename, hingecenter, hingePi, hingeprice, hingestatus ,hingemidx, hingewdate,hingeemidx,hingeewdate,qtype,atype"
                  SQL=SQL&" From tk_hinge "
                  SQL=SQL&" Where qtype=1 "
                  'RESPONSE.WRITE (SQL)
                  Rs.open Sql,Dbcon
                  If Not (Rs.bof or Rs.eof) Then 
                  Do until Rs.EOF
                  hingeidx4=Rs(0)
                  hingecode=Rs(1)
                  hingeshorten=Rs(2)
                  hingename=Rs(3)
                  hingecenter2=Rs(4)                        
                  hingePi=Rs(5)
                  hingeprice4=Rs(6)
                  hingestatus=Rs(7)
                  hingemidx=Rs(8)
                  hingewdate=Rs(9)
                  hingeemidxe=Rs(10)
                  hingeewdatee=Rs(11)
                  qtype=Rs(12)
                  atype=Rs(13)
                  %>                
                      <option value="<%=hingeidx4%>_<%=hingeprice4%>_<%=hingecenter2%>" <% if Cint(aidx)=Cint(raidx) Then %>selected <% end if %>><%=hingecenter2%>mm</option>
                  <%
                  Rs.MoveNext
                  Loop
                  End If
                  Rs.close
                  %>                    
                    </select>
                    <input type="hidden" name="hingeidx4" id="hingeidx4" value="<%=hingeidx4%>" > 
                    <input type="hidden" name="hingeprice4" id="hingeprice4" value="<%=hingeprice4%>" > 
                    <input type="hidden" name="hingecenter2" id="hingecenter2" value="<%=hingecenter2%>" >      
                </div> 
                <div class="col-3">
                <input type="text" class="form-control" id="sjbhingeup2" name="sjbhingeup2" placeholder="" value="<%=sjbhingeup2%>" > 
                </div>
                <div class="col-2">
                <input type="text" class="form-control" id="sjbhingeup3" name="sjbhingeup3" placeholder="" value="<%=sjbhingeup3%>" > 
                </div>                             
            </div>
<!--상롯트 끝 -->
<!--격자 시작 -->              
            <div class="row mb-1">
                <div class="col-2"><label for="name">격자</label></div>
                <div class="col-3">
                <input type="text" class="form-control" id="sjbkyukja1" name="sjbkyukja1" placeholder="" value="<%=sjbkyukja1%>" > 
                <input type="hidden" class="form-control" id="kyukjaprice" name="kyukjaprice" placeholder="" value="<%=kyukjaprice%>" > 
                <input type="hidden" class="form-control" id="kyukjaname" name="kyukjaname" placeholder="" value="<%=kyukjaname%>" > 
                </div>
                <div class="col-3">
                <input type="text" class="form-control" id="sjbkyukja2" name="sjbkyukja2" placeholder="" value="<%=sjbkyukja2%>" > 
                </div>
                <div class="col-2">
                <input type="text" class="form-control" id="sjbkyukja3" name="sjbkyukja3" placeholder="" value="<%=sjbkyukja3%>" >                  
                </div>
                <div class="col-2">
                <input type="text" class="form-control" id="sjbkyukja4" name="sjbkyukja4" placeholder="" value="<%=sjbkyukja4%>" >        
                </div>                  
            </div>
            <div class="row mb-1">
                <div class="col-2"><label for="name">입력</label></div>
                 <div class="col-2">
                    <input type="text" class="form-control" id="sjbkyukja5" name="sjbkyukja5" placeholder="" value="<%=sjbkyukja5%>" >           
                </div>  
                 <div class="col-2">
                    <input type="text" class="form-control" id="sjbkyukja6" name="sjbkyukja6" placeholder="" value="<%=sjbkyukja6%>" >           
                </div>  
                 <div class="col-2">
                    <input type="text" class="form-control" id="sjbkyukja7" name="sjbkyukja7" placeholder="" value="<%=sjbkyukja7%>" >           
                </div>
                 <div class="col-2">
                    <input type="text" class="form-control" id="sjbkyukja8" name="sjbkyukja8" placeholder="" value="<%=sjbkyukja8%>" >           
                </div>                
            </div>
        <div class="col-md-4">
            <button type="submit" class="btn btn-outline-primary" >저장</button>
        </div>

        </div>
      </div>
<!--sujumaterial 시작 -->      
      <div class="col-md-4">
                <div class="row card mb-2" style="height:300px;">
                    <iframe name="sujumaterial" width="100%" height="100%" src="sujumaterial.asp?<%=rgoidx%>&rsidx=<%=rsidx%>&rbuidx=<%=rbuidx%>&smidx=<%=smidx%>" border="0" scrolling="none"></iframe>
                </div>
      </div>     
<!--sujumaterial 끝 -->      
      

</form>  
        

   

<!--품명 끝 -->
<!--수주내역 시작 -->
    <div class="card card-body mb-1"><label for="name">수주내역</label>
      <div class="row">
            <table id="datatablesSimple"  class="table table-hover">
                <thead>
                    <tr>
                        <th align="center"></th>
                        <th align="center">품번</th>
                        <th align="center">품목구분</th>
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
                    SQL="SELECT A.sjbidx,A.goidx,A.goprice,A.baridx,A.barlistprice,A.QTYIDX,A.QTYprice "
                    SQL=SQL&" , A.sjbqty,A.sjbwide,A.sjbwidePRICE,A.sjbhigh,A.sjbhighPRICE,A.sjbbanghyang,A.sjbwitch ,A.sjbbigo "
                    SQL=SQL&" , A.glidx,A.glprice,A.sangBUIDX,A.sangbuprice,A.pidx,A.pprice,A.rhaBUIDX,A.rHAbuprice "
                    SQL=SQL&" , A.kyidx1,A.kyprice1,A.kyidx2,A.kyprice2,A.sjbkey3,A.sjbkey4,A.kyidx3,A.kyprice3,A.kyidx4,A.kyprice4,A.sjbkey7, A.sjbkey8"
                    SQL=SQL&" , A.tagongidx1,A.tagongprice1,A.sjbtagong2,A.sjbtagong3,A.sjbtagong4,A.sjbtagong5 "
                    SQL=SQL&" , A.tagongidx2,A.tagongprice2,A.sjbtagong7,A.sjbtagong8,A.sjbtagong9,A.sjbtagong10 "
                    SQL=SQL&" , A.hingeidx,A.hingeprice,A.hingeidx1,A.hingeprice1,A.sjbhingedown2,A.sjbhingedown3 "
                    SQL=SQL&" , A.hingeidx3,A.hingeprice3,A.hingeidx4,A.hingeprice4,A.sjbhingeup2,A.sjbhingeup3 "
                    SQL=SQL&" , A.sjbkyukja1,A.kyukjaprice,A.sjbkyukja2,A.sjbkyukja3,A.sjbkyukja4,A.sjbkyukja5, A.sjbkyukja6,A.sjbkyukja7,A.sjbkyukja8 "
                    SQL=SQL&" , A.sjaidx,A.sujuinmoneyidx "
                    SQL=SQL&" , A.sjwondanga,A.sjchugageum,A.sjgonggeumgaaek,A.sjDCdanga "
                    SQL=SQL&" , A.sjseaek,A.sjdanga,A.sjgeumaek "
                    SQL=SQL&"  ,A.goname ,A.barNAME ,A.QTYNAME ,A.gldepth  "
                    SQL=SQL&"  ,A.sangbuname ,A.pname ,A.rhabuname ,A.kyname1,A.kyname2,A.kyname3,A.kyname4 "
                    SQL=SQL&"  ,A.tagongname1 ,A.tagongname2 ,A.hingename1 ,A.hingecenter1,A.hingename2 ,A.hingecenter2,A.kyukjaname  "                  
                    SQL=SQL&" from tk_sujub A "
                    'SQL=SQL&" JOIN tk_goods B on A.goidx=B.goidx "
                    'SQL=SQL&" JOIN tk_sujumoney C on A.sjbidx=C.sjmoneyidx "
                    SQL=SQL&" where A.sjaidx='"&sjaidx&"' "
                    'RESPONSE.WRITE (SQL)        
                    Rs.open Sql,Dbcon
                    If Not (Rs.bof or Rs.eof) Then 
                    Do until Rs.EOF
                    rsjbidx=Rs(0)
                    goidx=Rs(1)
                    goprice=Rs(2)
                    baridx=Rs(3)
                    barlistprice=Rs(4)
                    QTYIDX=Rs(5)
                    QTYprice=Rs(6)
                    sjbqty=Rs(7)
                    sjbwide=Rs(8)
                    sjbwidePRICE=Rs(9)
                    sjbhigh=Rs(10)
                    sjbhighPRICE=Rs(11)
                    sjbbanghyang=Rs(12)
                    sjbwitch=Rs(13)
                    sjbbigo=Rs(14)
                    glidx=Rs(15)
                    glprice=Rs(16)
                    sangBUIDX=Rs(17)
                    sangbuprice=Rs(18)
                    pidx=Rs(19)
                    pprice=Rs(20)
                    rHABUIDX=Rs(21)
                    rHAbuprice=Rs(22)
                    kyidx1=Rs(23)
                    kyprice1=Rs(24)
                    kyidx2=Rs(25)
                    kyprice2=Rs(26)
                    sjbkey3=Rs(27)
                    sjbkey4=Rs(28)
                    kyidx3=Rs(29)
                    kyprice3=Rs(30)
                    kyidx4=Rs(31)
                    kyprice4=Rs(32)
                    sjbkey7=Rs(33)
                    sjbkey8=Rs(34)                    
                    tagongidx1=Rs(35)
                    tagongprice1=Rs(36)
                    sjbtagong2=Rs(37)
                    sjbtagong3=Rs(38)
                    sjbtagong4=Rs(39)
                    sjbtagong5=Rs(40)
                    tagongidx2=Rs(41)
                    tagongprice2=Rs(42)
                    sjbtagong7=Rs(43)
                    sjbtagong8=Rs(44)
                    sjbtagong9=Rs(45)
                    sjbtagong10=Rs(46)
                    hingeidx=Rs(47)
                    hingeprice=Rs(48)
                    hingeidx1=Rs(49)
                    hingeprice1=Rs(50)
                    sjbhingedown2=Rs(51)
                    sjbhingedown3=Rs(52)
                    hingeidx3=Rs(53)
                    hingeprice3=Rs(54)
                    hingeidx4=Rs(55)
                    hingeprice4=Rs(56)
                    sjbhingeup2=Rs(57)
                    sjbhingeup3=Rs(58)
                    sjbkyukja1=Rs(59)
                    kyukjaprice=Rs(60)
                    sjbkyukja2=Rs(61)
                    sjbkyukja3=Rs(62)
                    sjbkyukja4=Rs(63)
                    sjbkyukja5=Rs(64)
                    sjbkyukja6=Rs(65)
                    sjbkyukja7=Rs(66)
                    sjbkyukja8=Rs(67)
                    sjaidx=Rs(68)
                    sujuinmoneyidx=Rs(69)
                    sjwondanga=Rs(70)
                    sjchugageum=Rs(71)
                    sjgonggeumgaaek=Rs(72)
                    sjDCdanga=Rs(73)
                    sjseaek=Rs(74)
                    sjdanga=Rs(75)
                    sjgeumaek=Rs(76)
                    goname=Rs(77)
                    barNAME=Rs(78)
                    QTYNAME=Rs(79)
                    gldepth=Rs(80)
                    sangbuname=Rs(81)
                    pname=Rs(82)
                    rHAbuname=Rs(83)
                    kyname1=Rs(84)
                    kyname2=Rs(85)
                    kyname3=Rs(86)
                    kyname4=Rs(87)                    
                    tagongname1=Rs(88)
                    tagongname2=Rs(89)
                    hingename1=Rs(90)
                    hingecenter1=Rs(91)
                    hingename2=Rs(92)
                    hingecenter2=Rs(93)
                    kyukjaname=Rs(94)

                    %>                 
                    <tr>
                        <td>
                          <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="flexCheckDefault">
                            <label class="form-check-label" for="flexCheckDefault">
                            </label>
                          </div>
                        </td>
                        <td><%=rsjbidx%></td>
                        <td>
                        <% if rsjqty="1" or rsjqty="" then  %>도어<% end if %>
                        <% if rsjqty="2" then  %>프레임<% end if %>                        
                        <% if rsjqty="3" then  %>보호대<% end if %>
                        <% if rsjqty="4" then  %>자동문<% end if %>
                        </td>
                        <td><%=goname%>&nbsp<%=barNAME%></td>
                        <td><%=sjbwide%>X<%=sjbhigh%></td>
                        <td><%=sjbqty%></td>
                        <td><%=QTYNAME%>&nbsp<%=gldepth%>&nbsp<%=pname%>&nbsp<%=kyname1%>&nbsp<%=kyname2%>&nbsp<%=tagongname1%>&nbsp<%=tagongname2%>&nbsp<%=hingename1%>&nbsp<%=hingecenter1%>&nbsp<%=hingename2%>&nbsp<%=hingecenter2%>&nbsp<%=kyukjaname%> </td>
                        <td><%=sjbwitch%></td>
                        <td><%=sjwondanga%></td>
                        <td><%=sjchugageum%></td>
                        <td><%=sjDCdanga%></td>
                        <td><%=sjgonggeumgaaek%></td>                        
                        <td><%=sjseaek%></td>
                        <td><%=sjgeumaek%></td>
                        <td><%=sjbbigo%></td>
                        <td><%=rcidx%></td>
                    
                    </tr>
                    <%
                    Rs.MoveNext
                    Loop
                    End If
                    Rs.close
                    %> 
                    </tbody>
            </table>         
      </div>
    </div>
<!-- 수주내역 끝 -->
<!-- 기타자재 시작 -->
    <div class="card card-body mb-1">
        <div class="row">
        <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0" method="post" action="order.asp?listgubun=<%=listgubun%>&subgubun=<%=subgubun%>" name="searchForm1">
                <div class="row">
                    <table id="datatablesSimple"  class="table table-hover">
                    <thead>
                        <tr>
                            <th align="center"></th>
                            <th align="center">품번</th>
                            <th align="center">품명</th>
                            <th align="center">규격</th>
                            <th align="center">수량</th>
                            <th align="center">단가</th>
                            <th align="center">공급가액</th>
                            <th align="center">세액</th>
                            <th align="center">금액</th>
                            <th align="center">비고</th>
                            <th align="center">작성자</th>
                            <th align="center">작성일시</th>
                            <th align="center">수정자</th>
                            <th align="center">수정일시</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td>
                            <input class="form-control" type="text" placeholder="발주조회" aria-label="발주조회" aria-describedby="btnNavbarSearch" name="SearchWord" />
                            <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="searchForm.submit();"><i class="fas fa-search"></i></button>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>1</td>
                        </tr>
                    </tbody>
                    </table>         
                </div>
            </form>
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
