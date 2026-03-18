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

    projectname="절곡 발주서"
%>
<%
    function encodestr(str)
        if str = "" then exit function
        str = replace(str,chr(34),"&#34")
        str = replace(str,"'","''")
        encodestr = str
    end Function

' ===== 함수 정의 영역 =====
Function SafeStr(val)
    On Error Resume Next
    If IsNull(val) Or IsEmpty(val) Then
        SafeStr = ""
    Else
        SafeStr = Trim(CStr(val))
    End If
    On Error GoTo 0
End Function
' ==========================

    page_name="TNG1_B_baljuST.asp?"


    rsjcidx=request("cidx") '발주처idx
    rsjcidx=request("sjcidx") '발주처idx 
    rsjmidx=request("sjmidx") '거래처담당자idx
    rsjidx=request("sjidx") '수주idx
    rsjsidx=request("sjsidx") '품목idx

SQL_DEL = ""
SQL_DEL = SQL_DEL & "DELETE FROM tk_balju_st "
SQL_DEL = SQL_DEL & "WHERE sjidx='" & rsjidx & "' "
Response.Write(SQL_DEL & " → 기존데이터 삭제<br>")
Dbcon.Execute(SQL_DEL)

SQL = "SELECT dsidx, ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
SQL = SQL & "ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_costyn, ds_to_prepay, "
SQL = SQL & "dsmidx, dswdate, dsmeidx, dswedate, dsstatus, sjidx "
SQL = SQL & "FROM tk_daesin "
SQL = SQL & "WHERE sjidx = '" & rsjidx & "' AND dsstatus = 1"
Response.write (SQL)&"화물정보<br><br>"
'response.end
Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then

    dsidx         = Rs(0)
    ds_daesinname = Rs(1)
    ds_daesintel  = Rs(2)
    ds_daesinaddr = Rs(3) '화물지점
    dsdate        = Rs(4)
    dsmemo        = Rs(5)

    ds_to_num     = Rs(6)
    ds_to_name    = Rs(7) 
    ds_to_tel     = Rs(8)
    ds_to_addr    = Rs(9) 
    ds_to_costyn  = Rs(10)
    ds_to_prepay  = Rs(11)

    dsmidx        = Rs(12)
    dswdate       = Rs(13)
    dsmeidx       = Rs(14)
    dswedate      = Rs(15)
    dsstatus      = Rs(16)
    dssjidx       = Rs(17)
End If
Rs.Close

'==== 용차 정보 불러오기 시작 

SQL=" Select yidx, yname, ytel, yaddr, ydate, ymemo "
SQL=SQL&", ycarnum, ygisaname, ygisatel, ycostyn, yprepay, ystatus "
SQL=SQL&" , ymidx, ywdate, ymeidx, ywedate ,yaddr1 "
SQL=SQL&" From tk_yongcha " 
SQL=SQL&" Where sjidx='"&rsjidx&"' and ystatus=1 "
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    yidx=Rs(0)
    yname=Rs(1)
    ytel=Rs(2)
    yaddr=Rs(3) '하자지주소
    ydate=Rs(4)
    
    ymemo=Rs(5)
    ycarnum=Rs(6)
    ygisaname=Rs(7)
    ygisatel=Rs(8)
    ycostyn=Rs(9)
    yprepay=Rs(10)
    ystatus=Rs(11)
    ymidx=Rs(12)
    ywdate=Rs(13)
    ymeidx=Rs(14)
    ywedate=Rs(15)
    yaddr1=Rs(16)

End if
RS.Close

'==============================================================
' 🧩 tk_balju_st 자동 동기화 (INSERT / UPDATE / DELETE)
'==============================================================

'-----------------------------
' ① 신규 INSERT
'-----------------------------
SQL =  "SELECT A.fkidx, A.sjsidx "
SQL = SQL & "FROM tk_framek A "
SQL = SQL & "INNER JOIN tng_sjasub B ON A.sjsidx = B.sjsidx "
SQL = SQL & "WHERE A.sjidx='" & rsjidx & "'"
Response.write (SQL)&" 선별작업 <br> "
Rs3.open SQL,Dbcon


sql = "update TNG_SJA set meidx ='"&c_midx&"' where sjidx ='"&rsjidx&"'"
    Dbcon.Execute(sql)

If Not (Rs3.BOF Or Rs3.EOF) Then
    Do While Not Rs3.EOF

        cur_fkidx = Rs3("fkidx")
        cur_sjsidx = Rs3("sjsidx")

        ' ✅ sjb_type_no 조회 (스텐/알루미늄 구분용)
        SQL0 = "SELECT TOP 1 sjb_type_no FROM tk_framek WHERE sjsidx='" & cur_sjsidx & "'"
        Response.write (SQL0)&" sjb_type_no 조회 (스텐/알루미늄 구분용) <br>"
        RsC.open SQL0,Dbcon
        If Not (RsC.bof or RsC.eof) Then 
            sjb_type_no = RsC("sjb_type_no")
        Else
            sjb_type_no = 0
        End if
        RsC.Close

        SQL1 = ""
        SQL1 = SQL1 & "SELECT COUNT(*) FROM tk_balju_st  "
        SQL1 = SQL1 & "WHERE sjidx='" & rsjidx & "' "
        SQL1 = SQL1 & "  AND fkidx='" & cur_fkidx & "' "
        SQL1 = SQL1 & "  AND sjsidx='" & cur_sjsidx & "' "
        SQL1 = SQL1 & "  AND insert_flag=1"
        Response.write (SQL1)&" 신규리스트 찾기 <br> "

        Set Rs2 = Dbcon.Execute(SQL1)

            COUNT_insert   = Rs2(0)   ' 발주 고유번호 (PK)

        If COUNT_insert = 0 Then

            ' 신규 데이터 자동 인서트
            '----------------------------------------------
            ' 1차 바라시 조회 SQL (정확한 문법 + 주석 포함)
            '----------------------------------------------
            SQL = "SELECT distinct A.fkidx, a.GREEM_F_A , a.sjb_idx , B.fksidx , B.WHICHI_FIX, B.WHICHI_AUTO "
            SQL = SQL & ", b.bfidx , b.blength " 
            SQL = SQL & ",h.baname,h.bastatus,h.xsize,h.ysize,h.sx1,h.sx2,h.sy1,h.sy2,h.bachannel,h.g_bogang,h.g_busok,h.g_autorf,h.baidx " 
            SQL = SQL & ", C.set_name_FIX, C.set_name_AUTO ,c.bfimg1,c.bfimg2,c.bfimg3 ,c.bfimg4 , A.sjsidx "
            SQL = SQL & " FROM tk_framek A "
            SQL = SQL & "  JOIN tk_framekSub B ON A.fkidx = B.fkidx "
            SQL = SQL & "  JOIN tk_barasiF C ON B.bfidx = C.bfidx "
            SQL = SQL & "  LEFT JOIN tk_barasi H ON C.bfidx = H.bfidx "   ' 💡 스텐/알루미늄 공통 사용 (LEFT JOIN으로)  
            SQL = SQL & " WHERE a.sjidx = '" & rsjidx & "' and a.sjsidx='" & cur_sjsidx & "' and a.fkidx='" & cur_fkidx & "'  "
            SQL = SQL & " and b.gls = 0 "    ' 자재만
            SQL = SQL & " and b.bfidx <> 0 " ' 절곡발주만.
            ' ✅ 조건 분기: 스텐 or 알루미늄
            If sjb_type_no >= 8 Then
                ' 🔹 스텐: 전체 허용
                Response.Write "👉 스텐 (모든 baidx 사용)<br>"
            Else
                ' 🔹 알루미늄: baidx 있는 항목만 인서트
                SQL = SQL & "  AND H.baidx IS NOT NULL AND H.baidx <> 0 "
                Response.Write "⚙️ 알루미늄 (baidx 있는 것만 인서트)<br>"
            End If
            Response.write (SQL)&"  1차 인서트 <br>"

            Rs1.open Sql,Dbcon

            If Not (Rs1.bof or Rs1.eof) Then 
                Do while not Rs1.EOF

                    '------------------------------------------
                    ' 기본 정보 (tk_framek, tk_framekSub)
                    '------------------------------------------
                    fkidx          = Rs1(0)   ' 품목별 고유키
                    GREEM_F_A      = Rs1(1)   ' 1=수동, 2=자동
                    sjb_idx        = Rs1(2)   ' tk_framek.sjb_idx
                    fksidx         = Rs1(3)   ' tk_framekSub.fksidx
                    WHICHI_FIX     = Rs1(4)   ' 수동자재 구분
                    WHICHI_AUTO    = Rs1(5)   ' 자동자재 구분
                    bfidx          = Rs1(6)   ' 자재코드 (barasiF 참조)
                    blength        = Rs1(7)   ' 길이값 (barasi 길이)

                    '------------------------------------------
                    ' 바라시 정보 (tk_barasi)
                    '------------------------------------------
                    baname         = Rs1(8)   ' 바라시명
                    bastatus       = Rs1(9)   ' 바라시 상태 (1=사용)
                    xsize_h        = Rs1(10)  ' 바라시 xsize
                    ysize_h        = Rs1(11)  ' 바라시 ysize
                    sx1            = Rs1(12)  ' 좌표 X1
                    sx2            = Rs1(13)  ' 좌표 X2
                    sy1            = Rs1(14)  ' 좌표 Y1
                    sy2            = Rs1(15)  ' 좌표 Y2
                    bachannel      = Rs1(16)  ' 채널 코드
                    g_bogang       = Rs1(17)  ' 갈바보강
                    g_busok        = Rs1(18)  ' 갈바부속
                    g_autorf       = Rs1(19)  ' 반자동보강
                    baidx          = Rs1(20)  ' 바라시 고유키

                    set_name_FIX   = Rs1(21)  ' 
                    set_name_AUTO  = Rs1(22)  ' 
                    bfimg1         = Rs1(23)  ' 이미지1
                    bfimg2         = Rs1(24)  ' 이미지2
                    bfimg3         = Rs1(25)  ' 이미지3
                    bfimg4         = Rs1(26)  ' 이미지4
                    sjsidx         = Rs1(27)  ' 바라시 고유키

                p=p+1 

                If g_bogang = 1 Then
                    baname = baname & "_갈바보강"
                ElseIf g_busok = 1 Then
                    baname = baname & "_갈바부속"
                ElseIf g_autorf = 1 Then
                    baname = baname & "_반자동보강"
                End If

                if bfimg4<>"" then 
                    bfimg = bfimg4
                elseif bfimg3<>"" then 
                    bfimg =  bfimg3
                elseif bfimg1<>"" then 
                    bfimg = bfimg1
                elseif bfimg2<>"" then 
                    bfimg = bfimg2
                else
                    bfimg = ""
                end if

                    sql = "INSERT INTO tk_balju_st (" & _
                    "sjidx, fkidx, GREEM_F_A,  fksidx, WHICHI_FIX, WHICHI_AUTO, " & _
                    "bfidx, blength, baname, xsize, ysize, sx1, sx2, sy1, sy2, bachannel, midx, " & _
                    "mdate, sjdate, cgdate, djcgdate, " & _    
                    "g_bogang, g_busok,g_autorf, baidx  , bfimg ,sjsidx, set_name_FIX , set_name_AUTO,  insert_flag ) " & _
                    "VALUES (" & _
                    "'" & rsjidx & "', " & _ 
                    "'" & fkidx & "', " & _
                    "'" & GREEM_F_A & "', " & _
                    "'" & fksidx & "', " & _
                    "'" & WHICHI_FIX & "', " & _
                    "'" & WHICHI_AUTO & "', " & _
                    "'" & bfidx & "', " & _
                    "'" & blength & "', " & _
                    "'" & baname & "', " & _
                    "'" & xsize_h & "', " & _
                    "'" & ysize_h & "', " & _
                    "'" & sx1 & "', " & _
                    "'" & sx2 & "', " & _
                    "'" & sy1 & "', " & _
                    "'" & sy2 & "', " & _
                    "'" & bachannel & "', " & _
                    "'" & c_midx & "', " & _
                    "GETDATE(), GETDATE(), GETDATE(), GETDATE(), " & _   
                    "'" & g_bogang & "', " & _
                    "'" & g_busok & "', " & _
                    "'" & g_autorf & "', " & _
                    "'" & baidx & "', " & _
                    "'" & bfimg & "', " & _
                    "'" & sjsidx & "', " & _
                    "'" & set_name_FIX & "', " & _
                    "'" & set_name_AUTO & "', " & _
                    "1 )"                   

                    Response.write(sql) & "<br>"
                    // response.end
                    Dbcon.Execute(sql)

                    
            sql ="update TNG_SJA set meidx='"&c_midx&"' where sjidx='"&rsjidx&"'"
            Dbcon.Execute(sql)

            Rs1.movenext
            Loop
            End if
            Rs1.close

            '-----------------------------
            ' ③ 기존 데이터 UPDATE
            '-----------------------------

            SQL="Select distinct k.cname, j.sjdate, j.sjnum, j.cgaddr, j.cgdate, j.djcgdate , j.cgtype "
            SQL=SQL&" , a.quan, g.qtyname, h.dooryn, h.tw, h.th, h.ow, h.oh, i.pname, b.SJB_barlist,  f.SJB_TYPE_NAME "
            SQL=SQL&" , l.fname, i.p_image ,h.fkidx , c.qtyno , a.asub_wichi1 , a.asub_wichi2 "
            SQL=SQL&" , a.asub_bigo1, a.asub_bigo2, a.asub_bigo3, a.asub_meno1, a.asub_meno2 "
            SQL=SQL&" , a.sjidx, a.sjsidx , j.sjmidx , j.sjcidx "
            SQL=SQL&" From tng_sjaSub A "
            SQL=SQL&" left outer Join tng_sjb B On a.sjb_idx=B.sjb_idx "
            SQL=SQL&" left outer Join tk_qty C On a.qtyidx=C.qtyidx "
            SQL=SQL&" Join tk_member D On A.midx=D.midx "
            SQL=SQL&" Join tk_member E On A.meidx=E.midx "
            SQL=SQL&" Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no "
            '재질명 쿼리(다른것도 바꿔줘요.)
            SQL = SQL & "LEFT JOIN ("
            SQL = SQL & "    SELECT a.qtyno, a.qtyname "
            SQL = SQL & "    FROM tk_qtyco a "
            SQL = SQL & "    JOIN (SELECT MIN(qtyco_idx) AS min_idx FROM tk_qtyco WHERE QTYcostatus='1' GROUP BY qtyno) b "
            SQL = SQL & "    ON a.qtyco_idx = b.min_idx"
            SQL = SQL & ") g ON c.qtyno = g.qtyno "
            '재질명 쿼리 
            SQL=SQL&" Left Outer JOin tk_framek h On a.sjsidx=h.sjsidx " 
            SQL=SQL&" Left Outer JOin tk_paint i On h.pidx=i.pidx "
            SQL=SQL&" Left Outer JOin TNG_SJA j On a.sjidx=j.sjidx "
            SQL=SQL&" Left Outer JOin tk_customer k On k.cidx  =j.sjcidx "
            SQL=SQL&" Left Outer JOin tk_frame l On h.fidx  =l.fidx "
            SQL=SQL & " WHERE a.sjidx = '" & rsjidx & "' and a.sjsidx='" & cur_sjsidx & "' and h.fkidx='" & cur_fkidx & "'  "
            SQL=SQL&" and A.astatus='1' "
            Response.write (SQL)&"2차 업데이트 <br> "
            'response.end
            Rs.open Sql,Dbcon
            if not (Rs.EOF or Rs.BOF ) then
            Do while not Rs.EOF

                cname   =Rs(0) '발주처
                sjdate  =Rs(1) '수주일자
                sjnum   =Rs(2) '수주번호
                cgaddr  =Rs(3) '현장명
                cgdate  =Rs(4) '출고일자
                djcgdate =Rs(5) '도장출고일자
                cgtype  =Rs(6) '출고방식
                quan = Rs(7) '수량
                qtyname = Rs(8) '재질명
                dooryn = Rs(9) '도어
                tw = Rs(10) '검측가로
                th = Rs(11) '검측세로
                ow = Rs(12) '오픈가로
                oh = Rs(13) '오픈세로
                p_name = Rs(14) '도장재질명
                SJB_barlist = Rs(15) '규격
                SJB_TYPE_NAME = Rs(16) '프레임타입
                f_name = Rs(17) '프레임이름
                p_image = Rs(18) '도장재질이미지
                fkidx = Rs(19) '프레임키
                qtyno = Rs(20) '재질키
                sja_sub_wichi1    = Rs(21)  ' 위치1
                sja_sub_wichi2    = Rs(22)  ' 위치2
                sja_sub_bigo1     = Rs(23)  ' 비고1
                sja_sub_bigo2     = Rs(24)  ' 비고2
                sja_sub_bigo3     = Rs(25)  ' 비고3
                sja_sub_meno1     = Rs(26)  ' 추가사항1
                sja_sub_meno2     = Rs(27)  ' 추가사항2
                sjidx = Rs(28) '
                sjsidx     = Rs(29)  ' 수주키
                sjmidx     = Rs(30)  ' 
                sjcidx     = Rs(31)  ' 

                    Select Case cgtype
                        Case "1"
                            cgtype_text = "화물"
                        Case "2"
                            cgtype_text = "낮1배달_신두영(인천,고양)"
                        Case "3"
                            cgtype_text = "낮2배달_최민성(경기)"
                        Case "4"
                            cgtype_text = "밤1배달_윤성호(수원,천안,능력)"
                        Case "5"
                            cgtype_text = "밤2배달_김정호(하남)"
                        Case "6"
                            cgtype_text = "대구창고"
                        Case "7"
                            cgtype_text = "대전창고"
                        Case "8"
                            cgtype_text = "부산창고"
                        Case "9"
                            cgtype_text = "양산창고"
                        Case "10"
                            cgtype_text = "익산창고"
                        Case "11"
                            cgtype_text = "원주창고"
                        Case "12"
                            cgtype_text = "제주창고"
                        Case "13"
                            cgtype_text = "용차"
                        Case "14"
                            cgtype_text = "방문"
                        Case "15"
                            cgtype_text = "1공장"
                        Case "16"
                            cgtype_text = "인천항"
                        Case Else
                            cgtype_text = ""
                    End Select
                    Select Case dooryn
                        Case "0"
                            dooryn_text = "도어나중"
                        Case "1"
                            dooryn_text = "도어같이"
                        Case "2"
                            dooryn_text = "도어안함"
                        Case Else
                            dooryn_text = ""
                    End Select

                    ' ---- 주소 문자열 후처리 ----
                    ds_daesinaddr = Trim(ds_daesinaddr)   ' 앞뒤 공백 제거

                    If InStr(ds_daesinaddr, "대신") = 0 And InStr(ds_daesinaddr, "지점") = 0 Then
                        ' 마지막이 공백으로 끝나지 않게 조정 후 " 지점" 붙이기
                        If Right(ds_daesinaddr, 1) = " " Then
                            ds_daesinaddr = ds_daesinaddr & "지점"
                        Else
                            ds_daesinaddr = ds_daesinaddr & " 지점"
                        End If
                    End If
                    ' ----------------------------
                    bigo = SafeStr(sja_sub_wichi1) & " " & _
                            SafeStr(sja_sub_wichi2) & " " & _
                            SafeStr(sja_sub_bigo1) & " " & _
                            SafeStr(sja_sub_bigo2) & " " & _
                            SafeStr(sja_sub_bigo3) & " " & _
                            SafeStr(sja_sub_meno1) & " " & _
                            SafeStr(sja_sub_meno2)

                    If memo_text = "" Or IsNull(memo_text) Then memo_text = "0"

                    sql = "UPDATE tk_balju_st SET " & _
                    "quan = '" & quan & "', " & _
                    "mdate = GETDATE(), " & _
                    "cname = '" & cname & "', " & _
                    "sjdate = '" & sjdate & "', " & _
                    "sjnum = '" & sjnum & "', " & _
                    "cgaddr = '" & cgaddr & "', " & _
                    "cgdate = '" & cgdate & "', " & _
                    "djcgdate = '" & djcgdate & "', " & _
                    "cgtype_text = '" & cgtype_text & "', " & _
                    "qtyname = '" & qtyname & "', " & _
                    "p_image = '" & p_image & "', " & _
                    "tw = '" & tw & "', " & _
                    "th = '" & th & "', " & _
                    "ow = '" & ow & "', " & _
                    "oh = '" & oh & "', " & _
                    "p_name = '" & p_name & "', " & _
                    "SJB_TYPE_NAME = '" & SJB_TYPE_NAME & "', " & _
                    "SJB_barlist = '" & SJB_barlist & "', " & _
                    "dooryn_text = '" & dooryn_text & "', " & _
                    "f_name = '" & f_name & "', " & _
                    "st_quan = '" & st_quan & "', " & _
                    "ds_daesinaddr = '" & ds_daesinaddr & "', " & _
                    "yaddr = '" & yaddr & "', " & _
                    "yaddr1 = '" & yaddr1 & "', " & _
                    "sjsidx = '" & sjsidx & "', " & _
                    "cidx = '" & sjcidx & "', " & _
                    "sjmidx = '" & sjmidx & "', " & _
                    "memo_text = '" & memo_text & "', " & _
                    "bigo = '" & bigo & "' " & _
                    "WHERE sjidx = '" & sjidx & "' AND sjsidx = '" & cur_sjsidx & "' AND fkidx='" & cur_fkidx & "' AND insert_flag = 1 "

                    Response.Write(sql & "<br>")
                    Dbcon.Execute(sql)

                
                Rs.movenext
                Loop
                End if
                Rs.close

            SQL = "SELECT  A.fkidx, A.GREEM_F_A, A.sjb_idx, B.fksidx, B.WHICHI_FIX, B.WHICHI_AUTO, "
            SQL = SQL & "B.bfidx, B.blength, "
            SQL = SQL & "H.baname, H.bastatus, H.xsize, H.ysize, H.sx1, H.sx2, H.sy1, H.sy2, H.bachannel, "
            SQL = SQL & "H.g_bogang, H.g_busok, H.g_autorf, H.baidx, "
            SQL = SQL & "C.set_name_FIX, C.set_name_AUTO, C.bfimg1, C.bfimg2, C.bfimg3, C.bfimg4, A.sjsidx, "
            SQL = SQL & "D.T_Busok_name_f, D.TNG_Busok_images, D.TNG_Busok_idx, "   ' 🔹 추가 조인 결과
            SQL = SQL & "E.T_Busok_name_f AS T_Busok_name_f2, E.TNG_Busok_images AS TNG_Busok_images2, E.TNG_Busok_idx AS TNG_Busok_idx2, " ' 🔹 부속2
            SQL = SQL & "I.T_Busok_name_f AS T_Busok_name_f3, I.TNG_Busok_images AS TNG_Busok_images3, I.TNG_Busok_idx AS TNG_Busok_idx3, " ' 🔹 부속3
            SQL = SQL & "B.rot_type AS rot_type " ' 🔹 롯트
            SQL = SQL & "FROM tk_framek A "
            SQL = SQL & "JOIN tk_framekSub B ON A.fkidx = B.fkidx "
            SQL = SQL & "JOIN tk_barasiF C ON B.bfidx = C.bfidx "
            SQL = SQL & "JOIN tk_barasi H ON C.bfidx = H.bfidx "
            SQL = SQL & "LEFT OUTER JOIN TNG_Busok D ON C.TNG_Busok_idx = D.TNG_Busok_idx "
            SQL = SQL & "LEFT OUTER JOIN TNG_Busok E ON C.TNG_Busok_idx2 = E.TNG_Busok_idx "
            SQL = SQL & "LEFT OUTER JOIN TNG_Busok I ON C.TNG_Busok_idx3 = I.TNG_Busok_idx "
            SQL = SQL & " WHERE a.sjidx = '" & rsjidx & "' and a.sjsidx='" & cur_sjsidx & "' and a.fkidx='" & cur_fkidx & "'  "
            SQL = SQL & "AND B.gls = 0 AND B.bfidx <> 0"

            Response.Write(SQL & " 2차 업데이트 조회<br>")
            Rs1.Open SQL, Dbcon

            If Not (Rs1.BOF Or Rs1.EOF) Then
                Do While Not Rs1.EOF

                    fkidx        = Rs1(0)
                    GREEM_F_A    = Rs1(1)
                    sjb_idx      = Rs1(2)
                    fksidx       = Rs1(3)
                    WHICHI_FIX   = Rs1(4)
                    WHICHI_AUTO  = Rs1(5)
                    bfidx        = Rs1(6)
                    blength      = Rs1(7)
                    baname       = Rs1(8)
                    bastatus     = Rs1(9)
                    xsize_h      = Rs1(10)
                    ysize_h      = Rs1(11)
                    sx1          = Rs1(12)
                    sx2          = Rs1(13)
                    sy1          = Rs1(14)
                    sy2          = Rs1(15)
                    bachannel    = Rs1(16)
                    g_bogang     = Rs1(17)
                    g_autorf     = Rs1(18)   
                    g_busok      = Rs1(19)   
                    baidx        = Rs1(20)   
                    set_name_FIX = Rs1(21)
                    set_name_AUTO= Rs1(22)
                    bfimg1       = Rs1(23)
                    bfimg2       = Rs1(24)
                    bfimg3       = Rs1(25)
                    bfimg4       = Rs1(26)
                    sjsidx       = Rs1(27)

                    ' 🔹 추가된 Busok 1~3 세트
                    T_Busok_name      = Rs1(28)
                    TNG_Busok_images  = Rs1(29)
                    TNG_Busok_idx     = Rs1(30)

                    T_Busok_name2     = Rs1(31)
                    TNG_Busok_images2 = Rs1(32)
                    TNG_Busok_idx2    = Rs1(33)

                    T_Busok_name3     = Rs1(34)
                    TNG_Busok_images3 = Rs1(35)
                    TNG_Busok_idx3    = Rs1(36)

                    rot_type          = Rs1(37)


                    If g_bogang = 1 Then
                        baname = baname & "_갈바보강"
                    ElseIf g_busok = 1 Then
                        baname = baname & "_갈바부속"
                    ElseIf g_autorf = 1 Then
                        baname = baname & "_반자동보강"
                    End If

                    If bfimg4 <> "" Then
                        bfimg = bfimg4
                    ElseIf bfimg3 <> "" Then
                        bfimg = bfimg3
                    ElseIf bfimg1 <> "" Then
                        bfimg = bfimg1
                    ElseIf bfimg2 <> "" Then
                        bfimg = bfimg2
                    Else
                        bfimg = ""
                    End If

                    select case rot_type
                        case 1
                            rot_type_text = "좌 편개"
                        case "2"
                            rot_type_text = "우 편개"
                        case "3"
                            rot_type_text = "양개"
                        case "4"
                            rot_type_text = "도면참조"
                    end select

                    '----------------------------------------------
                    ' 업데이트 쿼리 (기존 레코드 덮어쓰기)
                    '----------------------------------------------
                    SQL = ""
                    SQL = SQL & "UPDATE tk_balju_st SET "
                    SQL = SQL & "  fkidx='" & fkidx & "', "
                    SQL = SQL & "  GREEM_F_A='" & GREEM_F_A & "', "
                    'SQL = SQL & "  fksidx='" & fksidx & "', "
                    SQL = SQL & "  WHICHI_FIX='" & WHICHI_FIX & "', "
                    SQL = SQL & "  WHICHI_AUTO='" & WHICHI_AUTO & "', "
                    SQL = SQL & "  bfidx='" & bfidx & "', "
                    SQL = SQL & "  blength='" & blength & "', "
                    SQL = SQL & "  baname='" & baname & "', "
                    SQL = SQL & "  xsize='" & xsize_h & "', "
                    SQL = SQL & "  ysize='" & ysize_h & "', "
                    SQL = SQL & "  sx1='" & sx1 & "', "
                    SQL = SQL & "  sx2='" & sx2 & "', "
                    SQL = SQL & "  sy1='" & sy1 & "', "
                    SQL = SQL & "  sy2='" & sy2 & "', "
                    SQL = SQL & "  bachannel='" & bachannel & "', "
                    SQL = SQL & "  g_bogang='" & g_bogang & "', "
                    SQL = SQL & "  g_busok='" & g_busok & "', "
                    SQL = SQL & "  g_autorf='" & g_autorf & "', "
                    SQL = SQL & "  baidx='" & baidx & "', "
                    SQL = SQL & "  bfimg='" & bfimg & "', "
                    SQL = SQL & "  mdate=GETDATE(), "
                    SQL = SQL & "  insert_flag=1 "

                    SQL = SQL & ", T_Busok_name='" & T_Busok_name & "'"
                    SQL = SQL & ", TNG_Busok_images='" & TNG_Busok_images & "'"
                    SQL = SQL & ", TNG_Busok_idx='" & TNG_Busok_idx & "'"

                    SQL = SQL & ", T_Busok_name2='" & T_Busok_name2 & "'"
                    SQL = SQL & ", TNG_Busok_images2='" & TNG_Busok_images2 & "'"
                    SQL = SQL & ", TNG_Busok_idx2='" & TNG_Busok_idx2 & "'"

                    SQL = SQL & ", T_Busok_name3='" & T_Busok_name3 & "'"
                    SQL = SQL & ", TNG_Busok_images3='" & TNG_Busok_images3 & "'"
                    SQL = SQL & ", TNG_Busok_idx3='" & TNG_Busok_idx3 & "'"

                    SQL = SQL & ", rot_type='" & rot_type_text & "'"
                    
                    SQL = SQL & "WHERE sjidx='" & rsjidx & "' "
                    SQL = SQL & "  AND sjsidx='" & cur_sjsidx & "' "
                    SQL = SQL & "  AND fkidx='" & cur_fkidx & "' "
                    SQL = SQL & "  AND bfidx='" & bfidx & "'"
                    SQL = SQL & "  AND baidx='" & baidx & "'"

                    Response.Write(SQL & "<br>")
                    Dbcon.Execute(SQL)

                    Rs1.MoveNext
                Loop
            End If
            Rs1.Close

        Else
            Response.Write "이미 존재 fkidx=" & cur_fkidx & ", sjsidx=" & cur_sjsidx & "<br>"

            '-----------------------------
            ' ③ 기존 데이터 UPDATE
            '-----------------------------

            SQL="Select distinct k.cname, j.sjdate, j.sjnum, j.cgaddr, j.cgdate, j.djcgdate , j.cgtype "
            SQL=SQL&" , a.quan, g.qtyname, h.dooryn, h.tw, h.th, h.ow, h.oh, i.pname, b.SJB_barlist,  f.SJB_TYPE_NAME "
            SQL=SQL&" , l.fname, i.p_image ,h.fkidx , c.qtyno , a.asub_wichi1 , a.asub_wichi2 "
            SQL=SQL&" , a.asub_bigo1, a.asub_bigo2, a.asub_bigo3, a.asub_meno1, a.asub_meno2 "
            SQL=SQL&" , a.sjidx, a.sjsidx , j.sjmidx , j.sjcidx "
            SQL=SQL&" From tng_sjaSub A "
            SQL=SQL&" left outer Join tng_sjb B On a.sjb_idx=B.sjb_idx "
            SQL=SQL&" left outer Join tk_qty C On a.qtyidx=C.qtyidx "
            SQL=SQL&" Join tk_member D On A.midx=D.midx "
            SQL=SQL&" Join tk_member E On A.meidx=E.midx "
            SQL=SQL&" Left Outer JOin tng_sjbtype F On B.sjb_type_no=F.sjb_type_no "
            '재질명 쿼리(다른것도 바꿔줘요.)
            SQL = SQL & "LEFT JOIN ("
            SQL = SQL & "    SELECT a.qtyno, a.qtyname "
            SQL = SQL & "    FROM tk_qtyco a "
            SQL = SQL & "    JOIN (SELECT MIN(qtyco_idx) AS min_idx FROM tk_qtyco WHERE QTYcostatus='1' GROUP BY qtyno) b "
            SQL = SQL & "    ON a.qtyco_idx = b.min_idx"
            SQL = SQL & ") g ON c.qtyno = g.qtyno "
            '재질명 쿼리 
            SQL=SQL&" Left Outer JOin tk_framek h On a.sjsidx=h.sjsidx " 
            SQL=SQL&" Left Outer JOin tk_paint i On h.pidx=i.pidx "
            SQL=SQL&" Left Outer JOin TNG_SJA j On a.sjidx=j.sjidx "
            SQL=SQL&" Left Outer JOin tk_customer k On k.cidx  =j.sjcidx "
            SQL=SQL&" Left Outer JOin tk_frame l On h.fidx  =l.fidx "
            SQL=SQL & " WHERE a.sjidx = '" & rsjidx & "' and a.sjsidx='" & cur_sjsidx & "' and h.fkidx='" & cur_fkidx & "'  "
            SQL=SQL&" and A.astatus='1' "
            Response.write (SQL)&"2차 업데이트 <br> "
            Rs.open Sql,Dbcon
            if not (Rs.EOF or Rs.BOF ) then
            Do while not Rs.EOF

                cname   =Rs(0) '발주처
                sjdate  =Rs(1) '수주일자
                sjnum   =Rs(2) '수주번호
                cgaddr  =Rs(3) '현장명
                cgdate  =Rs(4) '출고일자
                djcgdate =Rs(5) '도장출고일자
                cgtype  =Rs(6) '출고방식
                quan = Rs(7) '수량
                qtyname = Rs(8) '재질명
                dooryn = Rs(9) '도어
                tw = Rs(10) '검측가로
                th = Rs(11) '검측세로
                ow = Rs(12) '오픈가로
                oh = Rs(13) '오픈세로
                p_name = Rs(14) '도장재질명
                SJB_barlist = Rs(15) '규격
                SJB_TYPE_NAME = Rs(16) '프레임타입
                f_name = Rs(17) '프레임이름
                p_image = Rs(18) '도장재질이미지
                fkidx = Rs(19) '프레임키
                qtyno = Rs(20) '재질키
                sja_sub_wichi1    = Rs(21)  ' 위치1
                sja_sub_wichi2    = Rs(22)  ' 위치2
                sja_sub_bigo1     = Rs(23)  ' 비고1
                sja_sub_bigo2     = Rs(24)  ' 비고2
                sja_sub_bigo3     = Rs(25)  ' 비고3
                sja_sub_meno1     = Rs(26)  ' 추가사항1
                sja_sub_meno2     = Rs(27)  ' 추가사항2
                sjidx = Rs(28) '
                sjsidx     = Rs(29)  ' 수주키
                sjmidx     = Rs(30)  ' 
                sjcidx     = Rs(31)  ' 

                    Select Case cgtype
                        Case "1"
                            cgtype_text = "화물"
                        Case "2"
                            cgtype_text = "낮1배달_신두영(인천,고양)"
                        Case "3"
                            cgtype_text = "낮2배달_최민성(경기)"
                        Case "4"
                            cgtype_text = "밤1배달_윤성호(수원,천안,능력)"
                        Case "5"
                            cgtype_text = "밤2배달_김정호(하남)"
                        Case "6"
                            cgtype_text = "대구창고"
                        Case "7"
                            cgtype_text = "대전창고"
                        Case "8"
                            cgtype_text = "부산창고"
                        Case "9"
                            cgtype_text = "양산창고"
                        Case "10"
                            cgtype_text = "익산창고"
                        Case "11"
                            cgtype_text = "원주창고"
                        Case "12"
                            cgtype_text = "제주창고"
                        Case "13"
                            cgtype_text = "용차"
                        Case "14"
                            cgtype_text = "방문"
                        Case "15"
                            cgtype_text = "1공장"
                        Case "16"
                            cgtype_text = "인천항"
                        Case Else
                            cgtype_text = ""
                    End Select
                    Select Case dooryn
                        Case "0"
                            dooryn_text = "도어나중"
                        Case "1"
                            dooryn_text = "도어같이"
                        Case "2"
                            dooryn_text = "도어안함"
                        Case Else
                            dooryn_text = ""
                    End Select

                    ' ---- 주소 문자열 후처리 ----
                    ds_daesinaddr = Trim(ds_daesinaddr)   ' 앞뒤 공백 제거

                    If InStr(ds_daesinaddr, "대신") = 0 And InStr(ds_daesinaddr, "지점") = 0 Then
                        ' 마지막이 공백으로 끝나지 않게 조정 후 " 지점" 붙이기
                        If Right(ds_daesinaddr, 1) = " " Then
                            ds_daesinaddr = ds_daesinaddr & "지점"
                        Else
                            ds_daesinaddr = ds_daesinaddr & " 지점"
                        End If
                    End If
                    ' ----------------------------
                    bigo = SafeStr(sja_sub_wichi1) & " " & _
                            SafeStr(sja_sub_wichi2) & " " & _
                            SafeStr(sja_sub_bigo1) & " " & _
                            SafeStr(sja_sub_bigo2) & " " & _
                            SafeStr(sja_sub_bigo3) & " " & _
                            SafeStr(sja_sub_meno1) & " " & _
                            SafeStr(sja_sub_meno2)

                    If memo_text = "" Or IsNull(memo_text) Then memo_text = "0"

                    sql = "UPDATE tk_balju_st SET " & _
                    "quan = '" & quan & "', " & _
                    "mdate = GETDATE(), " & _
                    "cname = '" & cname & "', " & _
                    "sjdate = '" & sjdate & "', " & _
                    "sjnum = '" & sjnum & "', " & _
                    "cgaddr = '" & cgaddr & "', " & _
                    "cgdate = '" & cgdate & "', " & _
                    "djcgdate = '" & djcgdate & "', " & _
                    "cgtype_text = '" & cgtype_text & "', " & _
                    "qtyname = '" & qtyname & "', " & _
                    "p_image = '" & p_image & "', " & _
                    "tw = '" & tw & "', " & _
                    "th = '" & th & "', " & _
                    "ow = '" & ow & "', " & _
                    "oh = '" & oh & "', " & _
                    "p_name = '" & p_name & "', " & _
                    "SJB_TYPE_NAME = '" & SJB_TYPE_NAME & "', " & _
                    "SJB_barlist = '" & SJB_barlist & "', " & _
                    "dooryn_text = '" & dooryn_text & "', " & _
                    "f_name = '" & f_name & "', " & _
                    "st_quan = '" & st_quan & "', " & _
                    "ds_daesinaddr = '" & ds_daesinaddr & "', " & _
                    "yaddr = '" & yaddr & "', " & _
                    "yaddr1 = '" & yaddr1 & "', " & _
                    "sjsidx = '" & sjsidx & "', " & _
                    "cidx = '" & sjcidx & "', " & _
                    "sjmidx = '" & sjmidx & "', " & _
                    "memo_text = '" & memo_text & "', " & _
                    "bigo = '" & bigo & "' " & _
                    "WHERE sjidx = '" & sjidx & "' AND sjsidx = '" & cur_sjsidx & "' AND fkidx='" & cur_fkidx & "' AND insert_flag = 1 "

                    Response.Write(sql & "<br>")
                    Dbcon.Execute(sql)

                
                Rs.movenext
                Loop
                End if
                Rs.close

            SQL = "SELECT  A.fkidx, A.GREEM_F_A, A.sjb_idx, B.fksidx, B.WHICHI_FIX, B.WHICHI_AUTO, "
            SQL = SQL & "B.bfidx, B.blength, "
            SQL = SQL & "H.baname, H.bastatus, H.xsize, H.ysize, H.sx1, H.sx2, H.sy1, H.sy2, H.bachannel, "
            SQL = SQL & "H.g_bogang, H.g_busok, H.g_autorf, H.baidx, "
            SQL = SQL & "C.set_name_FIX, C.set_name_AUTO, C.bfimg1, C.bfimg2, C.bfimg3, C.bfimg4, A.sjsidx, "
            SQL = SQL & "D.T_Busok_name_f, D.TNG_Busok_images, D.TNG_Busok_idx, "   ' 🔹 추가 조인 결과
            SQL = SQL & "E.T_Busok_name_f AS T_Busok_name_f2, E.TNG_Busok_images AS TNG_Busok_images2, E.TNG_Busok_idx AS TNG_Busok_idx2, " ' 🔹 부속2
            SQL = SQL & "I.T_Busok_name_f AS T_Busok_name_f3, I.TNG_Busok_images AS TNG_Busok_images3, I.TNG_Busok_idx AS TNG_Busok_idx3, " ' 🔹 부속3
            SQL = SQL & "B.rot_type AS rot_type " ' 🔹 롯트
            SQL = SQL & "FROM tk_framek A "
            SQL = SQL & "JOIN tk_framekSub B ON A.fkidx = B.fkidx "
            SQL = SQL & "JOIN tk_barasiF C ON B.bfidx = C.bfidx "
            SQL = SQL & "JOIN tk_barasi H ON C.bfidx = H.bfidx "
            SQL = SQL & "LEFT OUTER JOIN TNG_Busok D ON C.TNG_Busok_idx = D.TNG_Busok_idx "
            SQL = SQL & "LEFT OUTER JOIN TNG_Busok E ON C.TNG_Busok_idx2 = E.TNG_Busok_idx "
            SQL = SQL & "LEFT OUTER JOIN TNG_Busok I ON C.TNG_Busok_idx3 = I.TNG_Busok_idx "
            SQL = SQL & " WHERE a.sjidx = '" & rsjidx & "' and a.sjsidx='" & cur_sjsidx & "' and a.fkidx='" & cur_fkidx & "'  "
            SQL = SQL & "AND B.gls = 0 AND B.bfidx <> 0"

            Response.Write(SQL & " 1차 업데이트 조회<br>")
            Rs1.Open SQL, Dbcon

            If Not (Rs1.BOF Or Rs1.EOF) Then
                Do While Not Rs1.EOF

                    fkidx        = Rs1(0)
                    GREEM_F_A    = Rs1(1)
                    sjb_idx      = Rs1(2)
                    fksidx       = Rs1(3)
                    WHICHI_FIX   = Rs1(4)
                    WHICHI_AUTO  = Rs1(5)
                    bfidx        = Rs1(6)
                    blength      = Rs1(7)
                    baname       = Rs1(8)
                    bastatus     = Rs1(9)
                    xsize_h      = Rs1(10)
                    ysize_h      = Rs1(11)
                    sx1          = Rs1(12)
                    sx2          = Rs1(13)
                    sy1          = Rs1(14)
                    sy2          = Rs1(15)
                    bachannel    = Rs1(16)
                    g_bogang     = Rs1(17)
                    g_autorf     = Rs1(18)
                    g_busok      = Rs1(19)
                    baidx        = Rs1(20)
                    set_name_FIX = Rs1(21)
                    set_name_AUTO= Rs1(22)
                    bfimg1       = Rs1(23)
                    bfimg2       = Rs1(24)
                    bfimg3       = Rs1(25)
                    bfimg4       = Rs1(26)
                    sjsidx       = Rs1(27)

                    ' 🔹 추가된 Busok 1~3 세트
                    T_Busok_name      = Rs1(28)
                    TNG_Busok_images  = Rs1(29)
                    TNG_Busok_idx     = Rs1(30)

                    T_Busok_name2     = Rs1(31)
                    TNG_Busok_images2 = Rs1(32)
                    TNG_Busok_idx2    = Rs1(33)

                    T_Busok_name3     = Rs1(34)
                    TNG_Busok_images3 = Rs1(35)
                    TNG_Busok_idx3    = Rs1(36)

                    rot_type          = Rs1(37)


                    If g_bogang = 1 Then
                        baname = baname & "_갈바보강"
                    ElseIf g_busok = 1 Then
                        baname = baname & "_갈바부속"
                    ElseIf g_autorf = 1 Then
                        baname = baname & "_반자동보강"
                    End If

                    If bfimg4 <> "" Then
                        bfimg = bfimg4
                    ElseIf bfimg3 <> "" Then
                        bfimg = bfimg3
                    ElseIf bfimg1 <> "" Then
                        bfimg = bfimg1
                    ElseIf bfimg2 <> "" Then
                        bfimg = bfimg2
                    Else
                        bfimg = ""
                    End If

                    select case rot_type
                        case 1
                            rot_type_text = "좌 편개"
                        case "2"
                            rot_type_text = "우 편개"
                        case "3"
                            rot_type_text = "양개"
                        case "4"
                            rot_type_text = "도면참조"
                    end select

                    '----------------------------------------------
                    ' 업데이트 쿼리 (기존 레코드 덮어쓰기)
                    '----------------------------------------------
                    SQL = ""
                    SQL = SQL & "UPDATE tk_balju_st SET "
                    SQL = SQL & "  fkidx='" & fkidx & "', "
                    SQL = SQL & "  GREEM_F_A='" & GREEM_F_A & "', "
                    'SQL = SQL & "  fksidx='" & fksidx & "', "
                    SQL = SQL & "  WHICHI_FIX='" & WHICHI_FIX & "', "
                    SQL = SQL & "  WHICHI_AUTO='" & WHICHI_AUTO & "', "
                    SQL = SQL & "  bfidx='" & bfidx & "', "
                    SQL = SQL & "  blength='" & blength & "', "
                    SQL = SQL & "  baname='" & baname & "', "
                    SQL = SQL & "  xsize='" & xsize_h & "', "
                    SQL = SQL & "  ysize='" & ysize_h & "', "
                    SQL = SQL & "  sx1='" & sx1 & "', "
                    SQL = SQL & "  sx2='" & sx2 & "', "
                    SQL = SQL & "  sy1='" & sy1 & "', "
                    SQL = SQL & "  sy2='" & sy2 & "', "
                    SQL = SQL & "  bachannel='" & bachannel & "', "
                    SQL = SQL & "  g_bogang='" & g_bogang & "', "
                    SQL = SQL & "  g_busok='" & g_busok & "', "
                    SQL = SQL & "  g_autorf='" & g_autorf & "', "
                    SQL = SQL & "  baidx='" & baidx & "', "
                    SQL = SQL & "  bfimg='" & bfimg & "', "
                    SQL = SQL & "  mdate=GETDATE(), "
                    SQL = SQL & "  insert_flag=1 "

                    SQL = SQL & ", T_Busok_name='" & T_Busok_name & "'"
                    SQL = SQL & ", TNG_Busok_images='" & TNG_Busok_images & "'"
                    SQL = SQL & ", TNG_Busok_idx='" & TNG_Busok_idx & "'"

                    SQL = SQL & ", T_Busok_name2='" & T_Busok_name2 & "'"
                    SQL = SQL & ", TNG_Busok_images2='" & TNG_Busok_images2 & "'"
                    SQL = SQL & ", TNG_Busok_idx2='" & TNG_Busok_idx2 & "'"

                    SQL = SQL & ", T_Busok_name3='" & T_Busok_name3 & "'"
                    SQL = SQL & ", TNG_Busok_images3='" & TNG_Busok_images3 & "'"
                    SQL = SQL & ", TNG_Busok_idx3='" & TNG_Busok_idx3 & "'"

                    SQL = SQL & ", rot_type='" & rot_type_text & "'"

                    SQL = SQL & "WHERE sjidx='" & rsjidx & "' "
                    SQL = SQL & "  AND sjsidx='" & cur_sjsidx & "' "
                    SQL = SQL & "  AND fkidx='" & cur_fkidx & "' "
                    SQL = SQL & "  AND bfidx='" & bfidx & "'"
                    SQL = SQL & "  AND baidx='" & baidx & "'"

                    Response.Write(SQL & "<br>")
                    Dbcon.Execute(SQL)

                    Rs1.MoveNext
                Loop
            End If
            Rs1.Close
                
        End If
            

        Rs2.Close

Rs3.MoveNext
Loop
End If
Rs3.Close


'Response.end


'-----------------------------
' ② 불필요한 데이터 DELETE
'-----------------------------
'SQL = ""
'SQL = SQL & "DELETE FROM tk_balju_st "
'SQL = SQL & "WHERE sjidx='" & rsjidx & "' "
'SQL = SQL & "  AND insert_flag=1 "
'SQL = SQL & "  AND (fkidx NOT IN (SELECT fkidx FROM tk_framek WHERE sjidx='" & rsjidx & "')) "
'SQL = SQL & "   OR (sjsidx NOT IN (SELECT sjsidx FROM tng_sjasub WHERE sjidx='" & rsjidx & "'))"
'Response.Write(SQL & " → 기존데이터 삭제111 <br>")
'Dbcon.Execute(SQL)




set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()


' ... INSERT / UPDATE 처리
Response.Write "OK - DB 저장 완료"
Response.End



%>