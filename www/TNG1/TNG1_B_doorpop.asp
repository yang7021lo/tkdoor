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
Set Rs2 = Server.CreateObject("ADODB.Recordset")

rsjidx=Request("sjidx")
    SQL = "SELECT a.sjcidx, b.cname,b.cgubun, b.cdlevel, b.cflevel "
    SQL = SQL & "FROM TNG_SJA a "
    SQL = SQL & "JOIN tk_customer b ON b.cidx = a.sjcidx "
    SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "'"
    'Response.Write SQL & "<br>" 
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
        sjcidx    = Rs1(0)
        cname     = Rs1(1)
        cgubun   = Rs1(2)
        cdlevel   = Rs1(3) ' 1=10만(기본), 2=-10000, 3= +10000, 4= +20000, 5= +30000 , 6= 9만에 1000*2400
        cflevel   = Rs1(4) ' 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=E
    End If
    Rs1.Close
rsjsidx=Request("sjsidx")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rsjb_idx=Request("sjb_idx")
rsjb_type_no=Request("sjb_type_no") '제품타입

gubun=Request("gubun")
rSearchWord=Request("SearchWord")
rjunggankey=Request("junggankey")
rdademuhom=Request("dademuhom")
rtagong=Request("tagong")

rnf=Request("nf")
rafksidx=Request("afksidx") '복제할 바의 키값
rdoortype=Request("doortype")
rsidx=Request("sidx")

rjaebun=Request("jaebun")
rboyang=Request("boyang")




mode=Request("mode")
mode_choice=Request("mode_choice")
'Response.Write "rsjb_type_no : " & rsjb_type_no & "<br>"
'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"
'Response.Write "rdoortype : " & rdoortype & "<br>"
'Response.Write "rnf : " & rnf & "<br>"
'Response.Write "rsidx : " & rsidx & "<br>"
'Response.Write "rjunggankey : " & rjunggankey & "<br>"
'Response.Write "rdademuhom : " & rdademuhom & "<br>"
'Response.Write "rtagong : " & rtagong & "<br>"

SQL = " select doorglass_t "
SQL = SQL & " FROM tk_framek "
SQL = SQL & " WHERE fkidx = '" & rfkidx & "' "
'Response.write (SQL)&"<br> 도어 조회하기 <br>"
Rs.open SQL, Dbcon
If Not (Rs.bof or Rs.eof) Then 

    wdoorglass_t  = Rs(0)

    if wdoorglass_t = "" or wdoorglass_t = 0 then

        response.write "<script>alert('도어의 유리 두께를 입력해주세요.');opener.location.replace('/tng1/TNG1_B_suju_quick.asp?sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & "&fksidx=" & rfksidx & "');window.close();</script>"
        Response.End  

    end if

end if
rs.close
        
if gubun="" then 

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
    <script>
        
        function validateForm(obj){
            if(document.frmMain.door_h.value ==""){
                alert("도어의 높이를 입력해 주세요.");
            return
            }             
            else{
                document.frmMain.submit();
            }
        }
    </script>
      <script>
    function pummoksub(yfksidx,size_gubun) {
     const message = prompt("변경된 치수를 입력해주세요!");
     if (message !== null && message.trim() !== "") {
       const encodedMessage = encodeURIComponent(message.trim());
       window.location.href = "TNG1_B_doorpop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&sjb_type_no=<%=rsjb_type_no%>&qtyidx=<%=zqtyidx%>&pidx=<%=pidx%>&gubun=update&fksidx="+yfksidx+"&size_gubun="+size_gubun+"&sizechange="+encodedMessage;
   }
    }

  </script>
</head>
<body>

<!--화면시작-->

    <div class="py-5 container text-center">
        
    <div>
        <div class="row">
            <div class="input-group mb-2s">
            <h3>도어높이변경</h3>
            </div>
        </div>
    </div>
<!-- 제목 나오는 부분 시작-->

            <div class="row">
                <div class="col-6" style="border:1px solid #000;">
                    <div class="input-group mb-2">
                        <table class="table">
                            <thead>
                                <th class="text-center"></th>
                                <th class="text-center"></th>
                                <th class="text-center">재질</th>
                                <th class="text-center">도장</th>
                                <th class="text-center">편개/양개</th>
                                <th class="text-center">도어가로</th>
                                <th class="text-center">도어세로</th>
                            </thead>
                            <tbody  class="table-group-divider">
                                <%
                                SQL = "select distinct a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
                                SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
                                SQL = SQL & " ,c.dwsize1, c.dhsize1, c.dwsize2, c.dhsize2, c.dwsize3, c.dhsize3"
                                SQL = SQL & " ,c.dwsize4, c.dhsize4, c.dwsize5, c.dhsize5, c.gwsize1, c.ghsize1"
                                SQL = SQL & " ,c.gwsize2, c.ghsize2, c.gwsize3, c.ghsize3, c.gwsize4, c.ghsize4"
                                SQL = SQL & " ,c.gwsize5, c.ghsize5, c.gwsize6, c.ghsize6"
                                SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
                                SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A,d.QTYNAME,f.pname "
                                SQL = SQL & " ,a.doorsizechuga_price,a.door_price,a.fksidx,a.doortype ,e.doorbase_price "
                                SQL = SQL & " from tk_framekSub a"
                                SQL = SQL & "  join tk_framek b on a.fkidx = b.fkidx"
                                SQL = SQL & "  LEFT OUTER JOIN tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO"
                                SQL = SQL & " LEFT OUTER JOIN tk_qty e ON b.qtyidx = e.qtyidx "
                                SQL = SQL & " LEFT OUTER JOIN tk_qtyco d ON e.QTYNo = d.QTYNo "
                                SQL = SQL & " LEFT OUTER JOIN tk_paint f ON f.pidx = b.pidx "
                                SQL = SQL & " Where a.fkidx='"&rfkidx&"'  "
                                SQL = SQL & " AND a.gls in (1,2) "
                                'Response.Write SQL & "<br>"  
                                Rs.open SQL, Dbcon
                                If Not (Rs.bof or Rs.eof) Then 
                                Do While Not Rs.EOF
                                    zWHICHI_AUTO  = rs(0) ' 자동 도어/유리 타입
                                    zWHICHI_FIX   = rs(1)
                                    zdoor_w       = rs(2)
                                    zdoor_h       = rs(3)
                                    zdoorglass_w      = rs(4)
                                    zdoorglass_h      = rs(5)
                                    zgls          = rs(6)
                                    zsjb_idx      = rs(7)
                                    zsjb_type_no  = rs(8)  ' 제품 타입 번호 (10이면 슬라이딩)
                                    zdwsize1      = rs(9)  ' 외도어제작 가로 whichi_auto = 12 whichi_fix = 12 
                                    zdhsize1      = rs(10) ' 외도어제작 세로 whichi_auto = 12 whichi_fix = 12
                                    zdwsize2      = rs(11) ' 양개도어제작 가로 whichi_auto = 13 whichi_fix = 13
                                    zdhsize2      = rs(12) ' 양개도어제작 세로 whichi_auto = 13 whichi_fix = 13
                                    zdwsize3      = rs(13)
                                    zdhsize3      = rs(14)
                                    zdwsize4      = rs(15)
                                    zdhsize4      = rs(16)
                                    zdwsize5      = rs(17)
                                    zdhsize5      = rs(18)
                                    zgwsize1      = rs(19) ' 하부픽스유리 가로 whichi_auto = 14,15
                                    zghsize1      = rs(20) ' 하부픽스유리 세로 whichi_auto = 14,15
                                    zgwsize2      = rs(21) ' 박스라인일 경우 하부픽스유리 가로
                                    zghsize2      = rs(22) ' 박스라인일 경우 하부픽스유리 세로
                                    zgwsize3      = rs(23) ' 상부남마 픽스 가로 whichi_auto = 16,17,18
                                    zghsize3      = rs(24) ' 상부남마 픽스 세로 whichi_auto = 16,17,18
                                    zgwsize4      = rs(25)
                                    zghsize4      = rs(26)
                                    zgwsize5      = rs(27)
                                    zghsize5      = rs(28)
                                    zgwsize6      = rs(29)
                                    zghsize6      = rs(30)
                                    zfksidx        = rs(31)
                                    zgreem_o_type  = rs(32) ' 1,2,3 자동편개 나머지 양개
                                    zGREEM_BASIC_TYPE  = rs(33) ' 홈 유무 (1~4)
                                    zgreem_fix_type = rs(34) ' 수동도어 타입 (9~15)
                                    zqtyidx        = rs(35) ' 재질
                                    zpidx          = rs(36) ' 도장칼라
                                    zdoorglass_t   = rs(37) ' 도어유리타입
                                    zfixglass_t    = rs(38) ' 픽스유리타입
                                    zdooryn        = rs(39) ' 도어유무 (0:도어나중, 1:있음, 2:도어안함)
                                    zGREEM_F_A     = rs(40) ' 자동 수동  여부  GREEM_F_A=2(자동) , GREEM_F_A=1(수동)
                                    zQTYNAME       = rs(41) ' 재질 이름
                                    zpname         = rs(42) ' 도장 이름
                                    zdoorsizechuga_price = rs(43) ' 도어 사이즈 추가 가격
                                    zdoor_price     = rs(44) ' 도어 가격
                                    zfksidx        = rs(45) ' 프레임키값
                                    zdoortype      = rs(46) ' 도어 타입 (1:편개, 2:양개)
                                    zdoorbase_price = rs(47) ' 도어 기본 가격

                                    i=i+1

                                        'Response.Write "zdoorbase_price : " & zdoorbase_price & "<br>"   
                                        'Response.Write "zsjb_type_no : " & zsjb_type_no & "<br>"   
                                        'Response.Write "zfksidx : " & zfksidx & "<br>"    
                                        'Response.Write "zQTYNAME : " & zqtyidx & "_" & zQTYNAME & "<br>"
                                        'Response.Write "zpname : " & zpidx & "_" & zpname & "<br>"
                                        'Response.Write "zdoor_h : " & zdoor_h & "<br>"
                                        'Response.Write "zglass_w : " & zglass_w & "<br>"
                                        'Response.Write "zdoorglass_h : " & zdoorglass_h & "<br>"
                                        'Response.Write "zdoorglass_w : " & zdoorglass_w & "<br>"
                                
                                    if zdoorglass_t =< 12 then
                                        glass = 0 '강화유리
                                    end if  
                                    if zdoorglass_t > 12 and zdoorglass_t =< 28 then
                                        glass = 1 '복층유리
                                    end if   
                                    if zdoorglass_t > 28 then
                                        glass = 2 '삼중유리
                                    end if   
                                    select case rdoortype
                                        case 0 
                                            rdoortype_text = "없음"
                                        case 1 
                                            rdoortype_text = "좌도어"
                                        case 2  
                                            rdoortype_text = "우도어"
                                        case else  
                                            rdoortype_text = "미정"    
                                    end select

                                %> 
                            <tr>
                                <tr <% if clng(zfksidx)=clng(rfksidx) then %>class="table-warning" <% end if %>>
                                <td class="text-center">
                                <input type="checkbox" class="form-check-input" name="fksidx" value="<%=zfksidx%>" 
                                <% If clng(zfksidx)=clng(rfksidx) Then Response.Write "checked" %> 
                                onclick="location.replace('TNG1_B_doorpop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&sjb_type_no=<%=zsjb_type_no%>&qtyidx=<%=zqtyidx%>&pidx=<%=zpidx%>&fksidx=<%=zfksidx%>');">
                                </td> 
                                <td class="text-center"><%=i%></td> 
                                <td class="text-center"><%=zQTYNAME%></td>      
                                <td class="text-center"><%=zpname%></td>
                                <td class="text-center"><%=rdoortype_text%></td>
                                <td class="text-center">
                                    <input type="number" name="door_w" value="<%=zdoor_w%>" class="form-control form-control-sm text-center" onclick="pummoksub('<%=zfksidx%>','w');">
                                </td>
                                <td class="text-center">
                                    <input type="number" name="door_h" value="<%=zdoor_h%>" class="form-control form-control-sm text-center" onclick="pummoksub('<%=zfksidx%>','h');">
                                </td>
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
                <!--
                <div class="input-group mb-2">
                    <button type="button" class="btn btn-outline-danger" Onclick="validateForm();">적용</button>    
                </div>         
                -->
    <!-- 왼쪽 영역 (600px) -->
    
        <% if rfksidx<>0 then %>
        
        <div class="col-6" style="border: 1px solid #000;"> 
                <form class="form-inline ms-auto me-0 -3 my-2 my-md-0" method="post" action="TNG1_B_doorpop.asp" name="form1">   
                    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
                    <input type="hidden" name="fksidx" value="<%=rfksidx%>">
                <div class="row" style="border: 1px solid #000;">
                    <div style="display: flex; align-items: center; gap: 8px;"> 
                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; width: 100%;">
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="doortype" value="1"
                                    <% If rdoortype  = "1" Then Response.Write "checked" %> > 좌도어
                                </label>
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="doortype" value="2"
                                    <% If rdoortype = "2" Then Response.Write "checked" %> >  우도어
                                </label>
                            </div>
                        </div>
                        <label for="cdlevel"  style="width: 50%;"><b>도어등급</b></label>
                        <div class="form-control bg-light" style="width: 50%;" >
                            <% 
                                Select Case cdlevel
                                    Case "1": Response.Write "10만(기본)"
                                    Case "2": Response.Write "9만"
                                    Case "3": Response.Write "11만"
                                    Case "4": Response.Write "12만"
                                    Case "5": Response.Write "소비자"
                                    Case "6": Response.Write "1000*2400"
                                    Case Else: Response.Write "-"
                                End Select
                            %>
                        </div>
                    </div>
                </div> 
                <div class="row" style="border: 1px solid #000;">    
                    <div style="display: flex; align-items: center; gap: 8px;"> 
                    <% if zWHICHI_auto <> 0 then %>
                    <%
                    if rjunggankey="" then
                        rjunggankey = "0" ' 기본값 중간키
                    end if
                    if rtagong="" then
                        rtagong = "0" 
                    end if
                    %>

                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px;">
                            <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                                중간키
                            </div>
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <!-- O 버튼 -->
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="1"
                                    <% If rjunggankey  = "1" Then Response.Write "checked" %> > ✔
                                </label>
                                <!-- X 버튼 -->
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="0"
                                    <% If rjunggankey = "0" Then Response.Write "checked" %> > ❌
                                </label>
                            </div>
                        </div>
                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; margin-right: 10px;">
                            <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                                다대타공
                            </div>
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="1"
                                    <% If rtagong = "1" Then Response.Write "checked" %> >  ✔
                                </label>
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="0"
                                    <% If rtagong = "0" Then Response.Write "checked" %> > ❌
                                </label>
                            </div>
                        </div>
                    <% else %> 
                    <%
                    if rjunggankey="" then
                        rjunggankey = "1" ' 기본값 중간키
                    end if
                    if rtagong="" then
                        rtagong = "1" 
                    end if
                    if rnf="" then
                        rnf = "0" 
                    end if
                    %>
                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px;">
                            <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                                중간키
                            </div>
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <!-- O 버튼 -->
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="1"
                                    <% If rjunggankey  = "1" Then Response.Write "checked" %> > ✔
                                </label> 
                                <!-- X 버튼 -->
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;" name="junggankey" value="0"
                                    <% If rjunggankey = "0" Then Response.Write "checked" %> > ❌
                                </label>
                            </div>
                        </div>
                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; margin-right: 10px;">
                            <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                                다대타공
                            </div>
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="1"
                                    <% If rtagong = "1"  Then Response.Write "checked" %> >  ✔
                                </label>
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="tagong" value="0"
                                    <% If rtagong = "0"  Then Response.Write "checked" %> > ❌
                                </label>
                            </div>
                        </div>
                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px; margin-right: 10px;">
                            <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                                nf/하나로
                            </div>
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="nf" value="1"
                                    <% If rnf = "1"  Then Response.Write "checked" %> >  ✔
                                </label>
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="nf" value="0"
                                    <% If rnf = "0"  Then Response.Write "checked" %> > ❌
                                </label>
                            </div>
                        </div>
                    <% end if %>
                    <%
                    if rdademuhom="" then
                        rjunggankey = "0" 
                    end if
                    %>
                        <!-- 다대무홈 -->
                        <div style="display: inline-block; text-align: center; border: 1px solid #000; padding: 4px;">
                            <div style="font-weight: bold; border-bottom: 1px solid #000; padding-bottom: 2px; margin-bottom: 4px;">
                                다대무홈
                            </div>
                            <div style="display: flex; justify-content: center; gap: 16px;">
                                <label>
                                <input type="radio" style="transform: scale(1.5); margin-right: 6px;"  name="dademuhom" value="1"
                                    <% If rdademuhom = "1" Then Response.Write "checked" %> > ✔
                                </label>
                                <label>
                                <input type="radio"  style="transform: scale(1.5); margin-right: 6px;" name="dademuhom" value="0"
                                    <% If rdademuhom <> "1" Then Response.Write "checked" %> > ❌
                                </label>
                            </div>
                        </div>
                        <!-- 도어방향 -->
                        <button class="btn btn-primary" id="btnNavbarSearch" type="button" onclick="submit();">적용</button>
                    </div>
                </form> 
            </div>
            <div class="row" style="border: 1px solid #000;">
                <div>
                        <%
                        SQL = "SELECT sidx, goidx, goname, baridx, barNAME, smidx, swdate, semidx, sewdate "
                        SQL = SQL & ",standprice, barlistprice, barNAME1, barNAME2, barNAME3, barNAME4, barNAME5 "
                        SQL = SQL & ",tongdojang, jadong, culmolbar,danyul,g_w,g_h,price_level"
                        SQL = SQL & " FROM tk_stand "
                        if rsidx <> 0 then 
                            SQL = SQL & " WHERE sidx ='"&rsidx&"' "
                        else
                            SQL = SQL & " WHERE sidx <>0 "
                        end if 
                            If rjunggankey <>"" Then 
                            SQL=SQL&" AND  junggankey = '"&rjunggankey&"' "
                            End If 
                            If rdademuhom <>"" Then 
                            SQL=SQL&" AND  dademuhom = '"&rdademuhom&"' "
                            End If 
                            If rnf <>"" Then 
                            SQL=SQL&" AND  nf = '"&rnf&"' "
                            End If 
                            If glass <>"" Then 
                            SQL=SQL&" AND  glass = '"&glass&"' "
                            End If 
                            If zGREEM_F_A = 1 Then 
                            SQL=SQL&" AND  jadong = 0 "
                            else
                            SQL=SQL&" AND  jadong = 1 "
                            End If 
                            'If zqtyidx =5 or  zqtyidx =15 or  zqtyidx =30 Then  'zqtyidx 알미늄블랙 5 실버15 기타도장30  헤어도장(  zqtyidx = 1 ) or ( 갈바도장 zqtyidx = 3  )  
                            'SQL=SQL&" AND  tongdojang = 1 "
                            'else
                            'SQL=SQL&" AND  tongdojang = 0 "
                            'End If 
                            'glass=0 강화 1 복층 2 삼중
                            '
                            If zsjb_type_no = 1  Then  ' 알자
                            SQL=SQL&" AND  danyul = 0   AND tongdojang = 1 AND goname LIKE '%일반%'  "
                            End If 
                            If zsjb_type_no = 2  Then  ' 복층알자
                            SQL=SQL&" AND  danyul = 0   AND tongdojang = 1 AND goname LIKE '%일반%'  "
                            End If 
                            If zsjb_type_no = 3 or  zsjb_type_no = 4 or zsjb_type_no = 8 or zsjb_type_no = 9 or zsjb_type_no = 10 or zsjb_type_no = 15   Then  ' 단열알자3 삼중알자4 단자8 삼중단자9 이중슬라이딩10 포켓15
                            SQL=SQL&" AND danyul = 1  AND goname LIKE '%매립단열자동%'  " 
                            End If 
                            If zsjb_type_no = 5  Then  ' 단열알자
                            SQL=SQL&" AND  danyul = 0  AND tongdojang = 1 AND goname LIKE '%인테%'   " 
                            End If 
                            If zsjb_type_no = 6  Then  ' 통도장 수동 일반
                            SQL=SQL&" and danyul = 0  AND tongdojang = 1 and goname  LIKE '%안전%'   and  goname NOT LIKE '%한쪽안전%' " 
                            End If 
                            If zsjb_type_no = 7  Then  ' 통도장 수동 단열
                            SQL=SQL&" and danyul = 1  AND tongdojang = 1 and goname  LIKE '%안전%'   and  goname NOT LIKE '%한쪽안전%' " 
                            End If 
                            If zsjb_type_no = 11  Then  ' 수동 단열
                            SQL=SQL&" and danyul = 1 AND tongdojang = 0 and goname  LIKE '%안전%'   and  goname NOT LIKE '%한쪽안전%' " 
                            End If 
                            If zsjb_type_no = 11 or zsjb_type_no = 12 Then  ' 수동 단열
                            SQL=SQL&" and danyul = 1  AND tongdojang = 0 and goname  LIKE '%안전%'   and  goname NOT LIKE '%한쪽안전%' " 
                            End If 

                        'Response.Write SQL & "<br>"

                            Rs1.Open SQL, Dbcon
                            If Not (Rs1.BOF Or Rs1.EOF) Then
                            Do While Not Rs1.EOF

                                sidx         = Rs1(0)
                                goidx        = Rs1(1)
                                goname       = Rs1(2)
                                baridx       = Rs1(3)
                                barNAME      = Rs1(4)
                                smidx        = Rs1(5)
                                swdate       = Rs1(6)
                                semidx       = Rs1(7)
                                sewdate      = Rs1(8)
                                standprice   = Rs1(9)
                                barlistprice = Rs1(10)
                                barNAME1     = Rs1(11)
                                barNAME2     = Rs1(12)
                                barNAME3     = Rs1(13)
                                barNAME4     = Rs1(14)
                                barNAME5     = Rs1(15)
                                tongdojang   = Rs1(16)
                                jadong       = Rs1(17)
                                culmolbar    = Rs1(18)
                                danyul       = Rs1(19)
                                g_w          = Rs1(20)
                                g_h          = Rs1(21)
                                price_level  = Rs1(22)

                                i = i + 1

                                doorsizechuga_price = 0   

                                if rjunggankey = "1" then
                                    junggankey_price = 25000
                                end if
                                if rdademuhom = "1" then
                                    dademuhom_price = 5000
                                end if
                                if rtagong = "1" then
                                    tagong_price = 3000
                                end if
                                If (zqtyidx =1 or  zqtyidx =3) and (zpidx<>0) Then  '헤어도장(  zqtyidx = 1 ) or ( 갈바도장 zqtyidx = 3  )  
                                    dojang_price=55000
                                elseif ( zqtyidx =15 or  zqtyidx =30)  Then '알미늄블랙 5 실버15 기타도장30
                                    if danyul = 1 and tongdojang = 1 then
                                        dojang_price=30000
                                    elseif  tongdojang = 1 then
                                        dojang_price=20000  
                                    end if
                                else
                                    dojang_price=0
                                End If 
                                    SQL = "select door_w, door_h"
                                    SQL = SQL & " from tk_framekSub "
                                    SQL = SQL & " where fksidx='" & rfksidx & "' and door_w<>0 "
                                    Rs2.open SQL, Dbcon
                                    If Not (Rs2.bof or Rs2.eof) Then 
                                    'response.write (Sql)&"<br>"
                                        wdoor_w = Rs2(0)
                                        wdoor_h = Rs2(1)
                                    End if
                                    Rs2.close
                                ' 도어 사이즈 추가 계산
                                Select Case cdlevel
                                    Case 6
                                        base_start_w = 1010  ' 폭 시작점
                                        base_start_h = 2415  ' 높이 시작점
                                    Case Else
                                        base_start_w = 910   ' 기본 폭 시작점
                                        base_start_h = 2115  ' 기본 높이 시작점
                                End Select
                                ' size_price_w 계산 (50mm 단위 등급)
                                If wdoor_w > base_start_w Then
                                    size_price_w = Int((wdoor_w - base_start_w + 49) / 50)
                                Else
                                    size_price_w = 0
                                End If
                                ' size_price_h 계산 (50mm 단위 등급)
                                If wdoor_h > base_start_h Then
                                    size_price_h = Int((wdoor_h - base_start_h + 49) / 50)
                                Else
                                    size_price_h = 0
                                End If

                                'Response.Write "size_price_w : " & size_price_w & "<br>"
                                '스텐재질별 추가단가
                                Select Case zqtyidx
                                    Case 3, 7, 12, 13, 14, 17
                                        price_level = -10000
                                    Case 8, 9, 10, 11, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 31, 32, 33, 34, 35, 36
                                        price_level = -20000
                                    Case Else
                                        price_level = 0
                                End Select

                                ' 도어 사이즈 추가 가격 계산
                                if (zqtyidx >= 1 and zqtyidx <= 7) or (zqtyidx >= 12 and zqtyidx <= 15) or zqtyidx = 30 or zqtyidx = 37 then
                                    doorsizechuga_price = size_price_w * 3000 + size_price_h * 3000
                                else 
                                    doorsizechuga_price = size_price_w * 4000 + size_price_h * 4000
                                end if
                                
                                total_standprice=standprice+junggankey_price+dademuhom_price+tagong_price+dojang_price+doorsizechuga_price+zdoorbase_price+price_level
                                
                                ' 1=10만(기본), 2=-10000, 3= +10000, 4= +20000, 5= +30000 , 6= 9만에 1000*2400

                                Select Case cdlevel
                                    Case 1
                                        cdlevel_price = 0
                                    Case 2
                                        IF danyul <> 0 THEN
                                            cdlevel_price = 0
                                        ELSE
                                            cdlevel_price = -10000
                                        END IF
                                    Case 3
                                        cdlevel_price = 10000
                                    Case 4
                                        cdlevel_price = 20000
                                    Case 5
                                        cdlevel_price = 30000
                                    Case 6
                                        IF danyul <> 0 THEN
                                            cdlevel_price = 0
                                        ELSE
                                            cdlevel_price = -10000
                                        END IF
                                            cdlevel_price = -10000
                                    Case Else
                                        cdlevel_price = 0
                                End Select

                                door_price=total_standprice + cdlevel_price

                                'Response.Write "zqtyidx : " & zqtyidx & "<br>"
                                'Response.Write "cdlevel : " & cdlevel & "<br>"
                                'Response.Write "cdlevel_price : " & cdlevel_price & "<br>"
                                'Response.Write "wdoor_w : " & wdoor_w & "<br>"
                                'Response.Write "wdoor_h : " & wdoor_h & "<br>"
                                'Response.Write "barname : " & barname & "<br>"
                                'Response.Write "rfksidx : " & rfksidx & "<br>"
                                'Response.Write "sidx : " & sidx & "<br>"
                                'Response.Write "rsidx : " & rsidx & "<br>"
                                'Response.Write "standprice : " & standprice & "<br>"
                                'Response.Write "junggankey_price : " & junggankey_price & "<br>"
                                'Response.Write "dademuhom_price : " & dademuhom_price & "<br>"
                                'Response.Write "tagong_price : " & tagong_price & "<br>"
                                'Response.Write "dojang_price : " & dojang_price & "<br>"
                                'Response.Write "size_price_w : " & size_price_w & "<br>"
                                'Response.Write "size_price_h : " & size_price_h & "<br>"
                                'Response.Write "doorsizechuga_price : " & doorsizechuga_price & "<br>"
                                'Response.Write "total_standprice : " & total_standprice & "<br>"
                                
                                ' 도어 유리 계산
                                if wdoor_w > 0 and wdoor_h > 0 then

                                    kdoorglass_w = wdoor_w - g_w
                                    kdoorglass_h = wdoor_h - g_h

                                SQL="Update tk_framekSub  "
                                SQL=SQL&" Set  doorglass_w='"& kdoorglass_w &"' , doorglass_h='"& kdoorglass_h &"' "
                                SQL=SQL&" Where fksidx='"&rfksidx&"' "
                                'response.write (SQL)&"<br>"
                                Dbcon.Execute (SQL)
                                end if
                        %>
                <table class="table table-bordered table-sm align-middle mb-2" style="width:100%; table-layout:fixed;">
                    <tr <% if clng(sidx)=clng(rsidx) then %>class="table-warning" <% end if %>>
                        <td colspan="5" <% %>>선택
                            <input type="checkbox" class="form-check-input" name="sidx" value="<%=rsidx%>" 
                            <% If clng(sidx)=clng(rsidx) Then Response.Write "checked" %> 
                            onclick="location.replace('TNG1_B_doorpop.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&sjb_type_no=<%=rsjb_type_no%>&qtyidx=<%=zqtyidx%>&pidx=<%=zpidx%>&fksidx=<%=rfksidx%>&sidx=<%=sidx%>&junggankey=<%=rjunggankey%>&dademuhom=<%=rdademuhom%>&tagong=<%=rtagong%>&nf=<%=rnf%>&doortype=<%=rdoortype%>&mode=doorupdate');">
                        </td>
                    </tr>
                    <tr>
                        <th class="text-center" colspan="3">품명</th>
                        <th class="text-center">규격</th>
                        <th class="text-center">유리T</th>
                    </tr>
                    <tr>
                        <td class="text-center"colspan="3"><input type="text" name="goname" value="<%=goname%>" class="form-control form-control-sm"></td>
                        <td class="text-center"><input type="text" name="barNAME" value="<%=barNAME%>" class="form-control form-control-sm"></td>
                        <td class="text-center"><input type="number" name="zdoorglass_t_<%=zdoorglass_t%>" value="<%=zdoorglass_t%>" class="form-control form-control-sm"></td>
                    </tr>
                </table>
                        <%
                        Rs1.MoveNext
                        Loop
                        End if
                        Rs1.close
                        %>
                </div>
            </div>
        </div>
       
    </div>    
    <% if mode="doorupdate" then %>
        <% if rsjb_type_no >= 1 and rsjb_type_no <= 5 then %>
            
            <div class="container text-center mt-5">
                <h3 class="mb-4">📦 도어포함 셋트판매 상품입니다.도어 포함 여부를 선택해주세요 </h3>
                <form method="post" action="TNG1_B_doorpop.asp" name="form2">
                    <input type="hidden" name="sjidx" value="<%=rsjidx%>">
                    <input type="hidden" name="sjsidx" value="<%=rsjsidx%>">
                    <input type="hidden" name="fkidx" value="<%=rfkidx%>">
                    <input type="hidden" name="sjb_idx" value="<%=rsjb_idx%>">
                    <input type="hidden" name="sjb_type_no" value="<%=rsjb_type_no%>">
                    <input type="hidden" name="qtyidx" value="<%=zqtyidx%>">
                    <input type="hidden" name="pidx" value="<%=zpidx%>">
                    <input type="hidden" name="fksidx" value="<%=rfksidx%>"> 
                    <input type="hidden" name="sidx" value="<%=sidx%>"> 
                    <input type="hidden" name="junggankey" value="<%=rjunggankey%>"> 
                    <input type="hidden" name="dademuhom" value="<%=rdademuhom%>"> 
                    <input type="hidden" name="tagong" value="<%=rtagong%>"> 
                    <input type="hidden" name="nf" value="<%=rnf%>"> 
                    <input type="hidden" name="doortype" value="<%=rdoortype%>"> 
                    <input type="hidden" name="mode" value="doorupdate_final">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="mode_choice" id="1" value="1" required>
                        <label class="form-check-label" for="1">도어 포함 </label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="mode_choice" id="2" value="2">
                        <label class="form-check-label" for="2">도어 별도 </label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="mode_choice" id="3" value="3">
                        <label class="form-check-label" for="3">도어 제외 </label>
                    </div>
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">선택 완료</button>
                    </div>
                </form>
            </div>

        <% else %>    
        <% 
            response.write "<script>location.replace('TNG1_B_doorpop.asp?sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & "&sjb_type_no=" & rsjb_type_no & "&qtyidx=" & zqtyidx & "&pidx=" & zpidx & "&fksidx=" & rfksidx & "&sidx=" & sidx & "&junggankey=" & rjunggankey & "&dademuhom=" & rdademuhom & "&tagong=" & rtagong & "&nf=" & rnf & "&doortype=" & rdoortype & "&mode=doorupdate_final&mode_choice=2');</script>"
        %>  
        <% end if %>

    <% end if %>

</div>
<% 
if mode = "doorupdate_final" then 

    if rDOORTYPE="" then
    rDOORTYPE=0
    end if

    if mode_choice="1" then '도어 포함 견적
    
        door_price=0
        doorsizechuga_price=0
        
    elseif mode_choice="2" then '도어 별도 견적

        if rsjb_type_no=1 or rsjb_type_no=2 or rsjb_type_no=5 then '알자, 복층알자 ,일반 100바  AL자동
            door_price=100000
            doorsizechuga_price=0
        elseif rsjb_type_no=3 or rsjb_type_no=4  then '단열알자 삼중알자 
            door_price=200000
            doorsizechuga_price=0
        end if 

    elseif mode_choice="3" then '도어 제외 견적

        if rsjb_type_no=1 or rsjb_type_no=2 or rsjb_type_no=5 then '알자, 복층알자 ,일반 100바  AL자동
            door_price=-80000
            doorsizechuga_price=0
        elseif rsjb_type_no=3 or rsjb_type_no=4  then '단열알자 삼중알자 
            door_price=-160000
            doorsizechuga_price=0
        end if 

    end if 
'Response.Write "rsjb_type_no: " & rsjb_type_no & "<br>"
'Response.Write "mode_choice: " & mode_choice & "<br>"
'Response.Write "door_price: " & door_price & "<br>"
'Response.Write "doorsizechuga_price: " & doorsizechuga_price & "<br>"

'---------------------롯트바 업데이트 
'1. 좌표 찾기 . 같은 xi를 가지고 있는 롯트바를 찾기 
'2.  4 도면참조 경우 - 롯트바의 너비와 도어의 너비가 다를 경우  
'3 rDOORTYPE 1 좌도어 2 우도어 . 양개를 추출하여라 좌표상 도어의 너비*2가 롯트바넓이와 동일하면 양개 
'4.업데이트 하기 (WHICHI_FIX = 4 or  WHICHI_FIX = 22 ) 롯트바 rot_type 1 좌 2 우 3 양개 4 도면참조 

    SQL = ""
    SQL = SQL & "SELECT " 
    SQL = SQL & "  xi, yi, wi, hi , DOORTYPE " 
    SQL = SQL & "FROM tk_framekSub "
    SQL = SQL & "Where fksidx in ("&rfksidx&") "        ' 🔹 롯트바(도면참조) 대상
    SQL = SQL & "  AND ISNULL(xi, '') <> '' "                       ' 🔹 xi 좌표 존재
    'response.write (SQL)&"1. 좌표 찾기 <br>"
    Rs.open SQL, Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        d_xi = Rs(0)
        d_yi = Rs(1)
        d_wi = Rs(2)
        d_hi = Rs(3) 
        d_DOORTYPE = Rs(4)  '3 rDOORTYPE 1 좌도어 2 우도어 . 양개를 추출하여라 좌표상 도어의 너비*2가 롯트바넓이와 동일하면 양개 
        'response.write ("xi : " & d_xi & "<br>")
        'response.write ("yi : " & d_yi & "<br>")
        'response.write ("wi : " & d_wi & "<br>")
        'response.write ("hi : " & hi & "<br>")
        'response.write ("DOORTYPE : " & d_DOORTYPE & "<br>")
    end if
    rs.close

    SQL = ""
    SQL = SQL & "SELECT " 
    SQL = SQL & " fkidx, fksidx,WHICHI_FIX, xi, yi, wi, hi " 
    SQL = SQL & "FROM tk_framekSub "
    SQL = SQL & "WHERE xi IN (" & d_xi & ") "    
    SQL = SQL & "  AND WHICHI_FIX IN (4,22) "   
    SQL = SQL & "  AND fkidx IN (" & rfkidx & ") "                
    'response.write (SQL)&"2.롯트바 찾기 4 도면참조 경우 - 롯트바의 너비와 도어의 너비가 다를 경우  <br>"
    Rs.open SQL, Dbcon
    If Not (Rs.bof or Rs.eof) Then 
        rot_fkidx = Rs(0)
        rot_fksidx = Rs(1)
        rot_WHICHI_FIX = Rs(2)
        rot_xi = Rs(3)
        rot_yi = Rs(4)
        rot_wi = Rs(5)
        rot_hi = Rs(6)

        'response.write ("rot_fkidx : " & rot_fkidx & "<br>")
        'response.write ("rot_fksidx : " & rot_fksidx & "<br>")
        'response.write ("rot_WHICHI_FIX : " & rot_WHICHI_FIX & "<br>")
        'response.write ("rot_xi : " & rot_xi & "<br>")
        'response.write ("rot_yi : " & rot_yi & "<br>")
        'response.write ("rot_wi : " & rot_wi & "<br>")
        'response.write ("rot_hi : " & rot_hi & "<br>")

        if d_DOORTYPE = 1 then
            rot_type = 1
            rot_type_text = "좌도어"
        elseif d_DOORTYPE = 2 then
            rot_type = 2
            rot_type_text = "우도어"
        end if

        if rot_wi = d_wi * 2 then
            rot_type = 3
            rot_type_text = "양개"
        end if
        if rot_wi <> d_wi * 2  and rot_wi > d_wi then
            rot_type = 4
            rot_type_text = "도면참조"
        end if

    end if
    rs.close

    'response.write ("rot_type : " & rot_type_text & "<br>")
'------------------------------------
    SQL="Update tk_framek "  
    SQL=SQL&" Set doorchoice='"& mode_choice &"'  "
    SQL=SQL&" Where fkidx in ("&rfkidx&") "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

    SQL="Update tk_framekSub  "  
    SQL=SQL&" Set door_price='"& door_price &"' , doorsizechuga_price='"& doorsizechuga_price &"' "
    SQL=SQL&" Where fksidx in ("&rfksidx&") "
    'response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)

        SQL="Update tk_framekSub  "
        SQL=SQL&" Set  goname='" & goname & "', barNAME='" & barNAME & "' "
        SQL=SQL&" , doorglass_w='"& kdoorglass_w &"' , doorglass_h='"& kdoorglass_h &"' , DOORTYPE='"& rDOORTYPE &"'"
        SQL=SQL&" Where fksidx='"&rfksidx&"' "
        'response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)

     if rsjb_type_no>=1 or rsjb_type_no<=5 or rsjb_type_no=8 or rsjb_type_no=9 or rsjb_type_no=10 or rsjb_type_no=15 then

    Else
        SQL="Update tk_framekSub  "  
        SQL=SQL&" Set rot_type='"& rot_type &"'  "
        SQL=SQL&" Where fksidx in ("&rot_fksidx&") "
        ' response.write (SQL)&"<br>"
        Dbcon.Execute (SQL)
    end if
        

    SQL = "select a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.doorglass_w, a.doorglass_h, a.gls"
    SQL = SQL & " ,b.sjb_idx, b.sjb_type_no"
    SQL = SQL & " ,a.fksidx ,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type "
    SQL = SQL & " ,b.qtyidx ,b.pidx ,b.doorglass_t ,b.fixglass_t ,b.dooryn , b.GREEM_F_A "
    SQL = SQL & " ,a.doorsizechuga_price,a.door_price ,a.goname,a.barNAME ,a.doortype , b.doorchoice "
    SQL = SQL & " from tk_framekSub a"
    SQL = SQL & " join tk_framek b on a.fkidx = b.fkidx "
    SQL=SQL&" Where a.fkidx = '"&rfkidx&"' and a.doortype>0 "
    Rs2.open SQL, Dbcon
    If Not (Rs2.bof or Rs2.eof) Then 
    Do While Not Rs2.EOF
    'response.write (Sql)&"<br>"
        kWHICHI_AUTO          = rs2(0)
        kWHICHI_FIX           = rs2(1)
        kDOOR_W               = rs2(2)
        kDOOR_H               = rs2(3)
        kDOORGLASS_W          = rs2(4)
        kDOORGLASS_H          = rs2(5)
        kGLS                  = rs2(6)
        kSJB_IDX              = rs2(7)
        kSJB_TYPE_NO          = rs2(8)
        kFKSIDX               = rs2(9)
        kGREEM_O_TYPE         = rs2(10)
        kGREEM_BASIC_TYPE     = rs2(11)
        kGREEM_FIX_TYPE       = rs2(12)
        kQTYIDX               = rs2(13)
        kPIDX                 = rs2(14)
        kDOORGLASS_T          = rs2(15)
        kFIXGLASS_T           = rs2(16)
        kDOORYN               = rs2(17)
        kGREEM_F_A            = rs2(18)
        kDOORSIZECHUGA_PRICE  = rs2(19)
        kDOOR_PRICE           = rs2(20)
        kGONAME               = rs2(21)
        kBARNAME              = rs2(22)
        kDOORTYPE             = rs2(23)
        kDOORCHOICE           = rs2(24)

            select case kDOORTYPE
                case 0 
                    kdoortype_text = "없음"
                case 1 
                    kdoortype_text = "좌도어"
                case 2  
                    kdoortype_text = "우도어"
            end select

            Select Case kDOORCHOICE
                Case 1
                    kDOORCHOICE_text = "도어 포함가"
                Case 2
                    kDOORCHOICE_text = "도어 별도가"
                Case 3
                    kDOORCHOICE_text = "도어 제외가"
                Case Else
                    kDOORCHOICE_text = "선택되지 않음"
            End Select

    k=k+1

%>
<div class="row">
    <div class="col-12" style="border:1px solid #000;">
        <div class="input-group mb-2">
            <table class="table">
                <thead>
                    <tr>
                        <th colspan="12" class="text-center"><%=kDOORCHOICE_text%></th>
                    </tr> 
                    <th>no</th>
                    <th>품명</th>
                    <th>규격</th>
                    <th>재질</th>
                    <th>도장</th>
                    <th>편개/양개</th>
                    <th>도어W</th>
                    <th>도어H</th>
                    <th>도어유리W</th>
                    <th>도어유리H</th>
                    <th class="text-center">도어 사이즈 추가 가격</th>
                    <th class="text-center">도어 가격</th>
                    
                        
                </thead>
                <tbody  class="table-group-divider">
                    <tr>
                        <td class="text-center"><%=k%></td>
                        <td class="text-center"><%=kgoname%></td>
                        <td class="text-center"><%=kbarNAME%></td>
                        <td class="text-center"><%=zQTYNAME%></td>      
                        <td class="text-center"><%=zpname%></td>
                        <td class="text-center"><%=kDOORTYPE_text%></td>
                        <td class="text-center"><%=kdoor_w%></td>
                        <td class="text-center"><%=kdoor_h%></td>
                        <td class="text-center"><%=kdoorglass_w%></td>
                        <td class="text-center"><%=kdoorglass_h%></td>
                        <td class="text-center"><%=FormatNumber(kdoorsizechuga_price, 0, -1, -1, -1) & " 원"%></td>
                        <td class="text-center"><%=FormatNumber(kdoor_price, 0, -1, -1, -1) & " 원"%></td>
                    </tr>
                </tbody>
            </table>
        </div> 

    </div> 
</div> 

    <%
    Rs2.MoveNext
    Loop
    End if
    Rs2.close
    %>

<%End if %>

    <button type="button" class="btn btn-outline-success w-25" style="margin-right:5px;" 
    onclick="opener.location.replace('/tng1/TNG1_B_suju_quick.asp?sjidx=<%=rsjidx%>&sjsidx=<%=rsjsidx%>&fkidx=<%=rfkidx%>&sjb_idx=<%=rsjb_idx%>&sjb_type_no=<%=rsjb_type_no%>&qtyidx=<%=zqtyidx%>&pidx=<%=kpidx%>');window.close();">종료</button>
 
<% end if %>


    <!--화면 끝-->

<!--Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!--Core theme JS-->    
</body>
</html>
<%

'도어 업데이트 시작
'===================

elseif gubun="update" then 
rsize_gubun=Request("size_gubun")
rsizechange=Request("sizechange")
    if rsize_gubun="w" then
    SQL="Update tk_framekSub set door_w='"&rsizechange&"' where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    elseif  rsize_gubun="h" then
    SQL="Update tk_framekSub set door_h='"&rsizechange&"' where fksidx='"&rfksidx&"' "
    'Response.write (SQL)&"<br>"
    Dbcon.Execute (SQL)
    end if

response.write "<script>location.replace('/tng1/TNG1_B_doorpop.asp?sjidx=" & rsjidx & "&sjsidx=" & rsjsidx & "&fkidx=" & rfkidx & "&sjb_idx=" & rsjb_idx & "&sjb_type_no=" & rsjb_type_no & "&qtyidx=" & zqtyidx & "&pidx=" & zpidx & "&fksidx=" & rfksidx & "');</script>"

end if

%>

<%
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
call dbClose()
%>
