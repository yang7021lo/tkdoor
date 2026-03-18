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
Set Rs = Server.CreateObject("ADODB.Recordset")
Set Rs1 = Server.CreateObject("ADODB.Recordset")




SQL="Select distinct A.sjsidx, a.sjb_idx, F.sjb_type_name, A.mwidth, A.mheight, A.qtyidx, g.qtyname, A.sjsprice, A.quan, a.disrate, a.disprice, A.taxrate, A.sprice, A.fprice "
SQL=SQL&" , A.midx, D.mname, A.mwdate, A.meidx, E.mname, A.mewdate, A.astatus ,f.sjb_type_no  , a.framename , i.pname "
SQL=SQL&" , a.door_price , a.frame_price , a.frame_option_price , j.sjcidx , h.fkidx , h.sjb_type_no "
SQL=SQL&" From tng_sjaSub A "
SQL=SQL&" left outer Join tng_sjb B On a.sjb_idx=B.sjb_idx "
SQL=SQL&" left outer Join tk_qty C On a.qtyidx=C.qtyidx "
SQL=SQL&" Join tk_member D On A.midx=D.midx "
SQL=SQL&" Join tk_member E On A.meidx=E.midx "
SQL=SQL&" Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no "
SQL=SQL&" Left Outer JOin tk_qtyco g On c.qtyno=g.qtyno "
SQL=SQL&" Left Outer JOin tk_framek h On a.sjsidx=h.sjsidx " 
SQL=SQL&" Left Outer JOin tk_paint i On a.pidx=i.pidx "
SQL=SQL&" Left Outer JOin TNG_SJA j On a.sjidx=j.sjidx "
SQL=SQL&" Where A.sjidx<>'0' and A.sjidx=348 "
SQL=SQL&" and A.astatus='1' "
Response.write (SQL)&"<br>"
Rs.open Sql,Dbcon
if not (Rs.EOF or Rs.BOF ) then
Do while not Rs.EOF
    i=i+1               '순번

    sjsidx=Rs(0)        '주문품목키
    sjb_idx=Rs(1)       '기본품목키
    sjb_type_name=Rs(2)  '기본품목명
    mwidth=Rs(3)        '검측가로
    mheight=Rs(4)       '검측세로
    qtyidx=Rs(5)        '재질키
    qtyname=Rs(6)       '재질명
    sjsprice=Rs(7)      '단가
    quan=Rs(8)          '수량
    disrate=Rs(9)       '할인율
    disprice=Rs(10)     '할인금액
    taxrate=Rs(11)      '세율
    sprice=Rs(12)       '최종가
    fprice=Rs(13)       '공급가 (도어포함 이였는데 도어제외로 변경해야함)
    midx=Rs(14)         '최초작성자키
    mname=Rs(15)        '최초작성자명
    mwdate=Rs(16)       '최초작성일
    meidx=Rs(17)        '최종작성자키
    mename=Rs(18)       '최종작성자명
    mewdate=Rs(19)      '최종작성일
    astatus=Rs(20)      '1은 사용 0은 사용안함 수정/삭제 ㅋㅋㅋㅋ
    sjb_type_no=Rs(21)
    framename=Rs(22)    '프레임명
    pname=Rs(23)        '도장명
    door_price=Rs(24)   '도어가 _ 수량 곱했음
    frame_price=Rs(25)  '프레임가 _ 수량 곱했음
    frame_option_price=Rs(26)  '프레임가 + 옵션_ 수량 곱했음
    sjcidx=Rs(27)       '종합품목키
    sun_fkidx=Rs(28)        'framek
    sun_sjb_type_no=Rs(29)  'sun_sjb_type_no 1,2,3,4,5 는 whichi_auto 9,24번 카운트 하지 말것
  

        sql=" select  a.fksidx , a.WHICHI_AUTO, a.WHICHI_FIX, a.door_w, a.door_h, a.glass_w, a.glass_h, a.gls "
        sql=sql&" ,b.sjb_idx, b.sjb_type_no,b.greem_o_type ,b.GREEM_BASIC_TYPE ,b.greem_fix_type  "
        sql=sql&" ,b.tw,b.th,b.ow,b.oh,b.fl,b.ow_m "
        sql=sql&" ,c.dwsize1, c.dhsize1, c.dwsize2, c.dhsize2, c.dwsize3, c.dhsize3 "
        sql=sql&" ,c.dwsize4, c.dhsize4, c.dwsize5, c.dhsize5, c.gwsize1, c.ghsize1 "
        sql=sql&" ,c.gwsize2, c.ghsize2, c.gwsize3, c.ghsize3, c.gwsize4, c.ghsize4 "
        sql=sql&" ,c.gwsize5, c.ghsize5, c.gwsize6, c.ghsize6 "
        sql=sql&" , d.xsize, d.ysize " 
        sql=sql&" ,e.opa,e.opb,e.opc,e.opd "
        sql=sql&" ,f.glassselect, g.glassselect ,a.sunstatus , a.busoktype , a.xi "
        sql=sql&" ,d.set_name_FIX,d.set_name_AUTO "
        sql=sql&" from tk_framekSub a "
        sql=sql&" join tk_framek b on a.fkidx = b.fkidx "
        sql=sql&" join tng_sjbtype c on b.sjb_type_no = c.SJB_TYPE_NO "
        sql=sql&" Join tk_barasiF d On a.bfidx = d.bfidx "
        sql=sql&" join tk_frame e on  b.fidx = e.fidx "
        SQL = SQL & " JOIN tng_whichitype f ON a.WHICHI_FIX = f.WHICHI_FIX "
        SQL = SQL & " JOIN tng_whichitype g ON a.WHICHI_AUTO = g.WHICHI_AUTO"
        sql=sql&" Where a.fkidx='"&sun_fkidx&"' "
        sql=sql&" and  a.gls=0 " ' 자재  검색조건
        sql=sql&" and  a.sunstatus in (0,5,6) " ' 자재  0은 일반 자재 5는 t형홈바 6은 박스커버
        if sun_sjb_type_no >= 1 and sun_sjb_type_no <= 5 then 'sun_sjb_type_no 1,2,3,4,5 는 whichi_auto 9,24번 카운트 하지 말것
            sql=sql&" and  a.WHICHI_AUTO not in (9,24) "
        end if
        

        response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or rs1.eof) Then 
        Do while not Rs1.EOF

            zfksidx = rs1(0)
            zWHICHI_AUTO = rs1(1)
            zWHICHI_FIX = rs1(2)
            zdoor_w = rs1(3)
            zdoor_h = rs1(4)
            zglass_w = rs1(5)
            zglass_h = rs1(6)
            zgls = rs1(7)
            zsjb_idx = rs1(8)
            zsjb_type_no = rs1(9)
            zgreem_o_type = rs1(10)
            zGREEM_BASIC_TYPE = rs1(11)
            zgreem_fix_type = rs1(12)
            ztw = rs1(13)
            zth = rs1(14)
            zow = rs1(15)
            zoh = rs1(16)
            zfl = rs1(17)
            zow_m = rs1(18)
            zdwsize1 = rs1(19) '외도어 가로 치수
            zdhsize1 = rs1(20) '외도어 세로 치수
            zdwsize2 = rs1(21) '양개도어 가로 치수
            zdhsize2 = rs1(22)  '양개도어 가로 치수
            zdwsize3 = rs1(23) 'x
            zdhsize3 = rs1(24) 'x
            zdwsize4 = rs1(25) 'x
            zdhsize4 = rs1(26) 'x
            zdwsize5 = rs1(27) 'x
            zdhsize5 = rs1(28) 'x
            zgwsize1 = rs1(29) '하부픽스유리 가로 치수
            zghsize1 = rs1(30) '하부픽스유리 세로 치수
            zgwsize2 = rs1(31) '상부남마픽스유리 1 가로 치수
            zghsize2 = rs1(32) '상부남마픽스유리 1 세로 치수
            zgwsize3 = rs1(33) '상부남마픽스유리 2 가로 치수
            zghsize3 = rs1(34) '상부남마픽스유리 2 세로 치수
            zgwsize4 = rs1(35)
            zghsize4 = rs1(36)
            zgwsize5 = rs1(37)
            zghsize5 = rs1(38)
            zgwsize6 = rs1(39)
            zghsize6 = rs1(40)
            zxsize = rs1(41)
            zysize = rs1(42)
            zopa = rs1(43)
            zopb = rs1(44)
            zopc = rs1(45)
            zopd = rs1(46)
            zglassselect_fix   = Rs1(47) '1= 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리 , 5 = 박스라인하부픽스유리 , 6 = 박스라인상부픽스유리
            zglassselect_auto   = Rs1(48)  '1 = 외도어 , 2 = 양개도어 , 3 = 유리 , 4 = 상부남마유리
            zsunstatus = rs1(49)
            zbusoktype = rs1(50) ' zbusoktype = 1 이면 로비폰 등에서 가공된 유리치수. 재계산 하면 안됨. 
            zxi= rs1(51) ' 언발란스 하바의 비교를 위해. min_xi  max_xi 
            set_name_FIX = rs1(52)
            set_name_AUTO = rs1(53)
            cnt = cnt + 1
            if cnt = 1 then
            sun_fkidx_1 = sun_fkidx
            end if 
            sunno = sun_fkidx - sun_fkidx_1 + 1

            Response.Write "zfksidx: " & zfksidx & "<br>"
            Response.Write "cnt: " & cnt & "<br>"
            Response.Write "sunno: " & sunno & "<br>"
        Rs1.movenext
        Loop
        End If
        Rs1.Close 



    Rs.movenext
Loop
End If
Rs.Close 

 Response.Write "cnt1: " & cnt & "<br>"







Set Rs = Nothing
Set Rs1 = Nothing
call dbClose()
%>
