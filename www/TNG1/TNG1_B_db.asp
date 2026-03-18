<!DOCTYPE html>
<html lang="en">
<head>
<%@codepage="65001" Language="vbscript"%>
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
Set Rs=Server.CreateObject("ADODB.Recordset")
Set Rs1=Server.CreateObject("ADODB.Recordset")
Set Rs2=Server.CreateObject("ADODB.Recordset")


'삭제 요청 처리 시작
'====================
gubun=Request("gubun")
' rsuju_kyun_status는 QueryString에서 읽지 않는다.
' (QueryString + Form 둘 다 있을 경우 "1, 0"처럼 합쳐지는 문제 방지)
rsuju_kyun_status = ""
if gubun="delete" then

rsjidx=Request("sjidx")

    sql = "DELETE FROM tk_framekSub WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE sjidx='" & rsjidx & "')"
    Response.write (SQL)&"<br>"
    dbCon.execute (SQL)

    

    

    SQL="Delete from tk_framek Where sjidx='"&rsjidx&"' "
    Response.write (SQL)&"<br>"
    dbCon.execute (SQL)

    SQL="Delete from tng_sjaSub Where sjidx='"&rsjidx&"' "
    Response.write (SQL)&"<br>"
    dbCon.execute (SQL)

    SQL="Delete from TNG_SJA Where sjidx='"&rsjidx&"' "
    Response.write (SQL)&"<br>"
    dbCon.execute (SQL)
    
    'response.end

    response.write "<script>location.replace('tng1_b.asp');</script>"

end if
'====================
'삭제 요청 처리 끝
%>


<%
'=========================
'수량만큼 tng_sjaSub 복사하기'
  If gubun = "copys" Then
    
      copyQty = CInt(Request.Form("copyQty"))
      rsjsidx  = Request.Form("sjsidx")
      rsjidx  = Request.Form("sjidx")
      rmidx  = Request.Form("midx")
      rsprice  = Request.Form("sprice")
      rframename = Request.Form("framename")
      ' response.write("sjidx = '"& sjidx &"'")
      ' response.end

      ' 원본 tng_sjaSub 데이터 기준 sjsidx 1개 확보
      sql = ""
      sql = sql & "SELECT TOP 1 sjsidx "
      sql = sql & "FROM tng_sjaSub "
      sql = sql & "WHERE sjidx = '" & rsjidx & "' "
      sql = sql & "And midx = '" & rmidx &"' "
      sql = sql & "And sprice =  '" & rsprice & "' "
      sql = sql & "And framename =  '" & rframename & "' "
      Rs.Open sql, Dbcon, 1, 1

      If Not (Rs.BOF Or Rs.EOF) Then
          base_sjsidx = Rs("sjsidx")
      End If
      Rs.close


        '복제 하기'
        For i = 1 To  copyQty 
                  SQL = ""
                  SQL = SQL & "INSERT INTO tng_sjaSub ("
                  SQL = SQL & " sjidx, midx, mwdate, meidx, mewdate, mwidth,"
                  SQL = SQL & " mheight, qtyidx, sjsprice, disrate, disprice, fprice,"
                  SQL = SQL & " sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2,"
                  SQL = SQL & " asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2,"
                  SQL = SQL & " astatus, py_chuga, door_price, whaburail, robby_box,"
                  SQL = SQL & " jaeryobunridae, boyangjea, pidx, framename,"
                  SQL = SQL & " frame_price, frame_option_price"
                  SQL = SQL & " ) "
                  SQL = SQL & "SELECT "
                  SQL = SQL & " '" & rsjidx & "' AS sjidx, midx, mwdate, meidx, mewdate, mwidth,"
                  SQL = SQL & " mheight, qtyidx, sjsprice, disrate, disprice, fprice,"
                  SQL = SQL & " sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2,"
                  SQL = SQL & " asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2,"
                  SQL = SQL & " astatus, py_chuga, door_price, whaburail, robby_box,"
                  SQL = SQL & " jaeryobunridae, boyangjea, pidx, framename,"
                  SQL = SQL & " frame_price, frame_option_price "
                  SQL = SQL & "FROM tng_sjaSub "
                  SQL = SQL & "WHERE sjsidx='" & rsjsidx & "'"
                  ' response.write("SQL='" & SQL &"'")&"<br>"
                  ' response.end
                  Dbcon.Execute sql
            Next 
                ' === tng 복제 끝 === 
                  'tk_framek 복사 하기'
              '여러개 복사된 tng_sub를 조회해서 tk_framek , tk_framke_sub 복사'
            sql_check = ""
            sql_check = sql_check & "SELECT TOP " & copyQty & " sjsidx, sjidx "
            sql_check = sql_check & "FROM tng_sjaSub "
            sql_check = sql_check & "WHERE sjidx = '" & rsjidx & "' "
            sql_check = sql_check & "AND midx = '" & rmidx & "' "
            sql_check = sql_check & "And sprice =  '" & rsprice & "' "
            sql_Chk = sql_check & "And framename =  '" & rframename & "' "
            sql_check = sql_check & "ORDER BY sjsidx DESC "
            Rs.Open sql_check, Dbcon, 1, 1

              If Not (Rs.EOF Or Rs.BOF) Then
                  Rs1.Open "SELECT ISNULL(MAX(fkidx),0) FROM tk_framek", Dbcon
                  new_fkidx = Rs1(0)
                  Rs1.close        
                  Do While Not Rs.EOF
                      new_sjsidx = Rs("sjsidx")
                  ' 원본은 제외
                  If new_sjsidx <>  base_sjsidx  Then
                          SQL = "SELECT fkidx FROM tk_framek WHERE sjidx='" & rsjidx & "' AND sjsidx='" & rsjsidx & "'"
                          Rs2.Open SQL, Dbcon
                          if Not (Rs2.BOF OR Rs2.EOF) Then
                          Do While Not Rs2.EOF
                              old_fkidx = Rs2("fkidx")
                              new_fkidx = new_fkidx  + 1
                              
                              'tk_framek 복사 (TNG1_B_suju_quick.asp 패턴 활용)
                              SQL = ""
                              SQL = SQL & "INSERT INTO tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, fmidx, fwdate, fstatus, "
                              SQL = SQL & "GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, "
                              SQL = SQL & "fmeidx, fewdate, GREEM_MBAR_TYPE, sjidx, sjb_type_no, setstd, sjsidx, ow, oh, tw, th, bcnt, FL, "
                              SQL = SQL & "qtyidx, pidx, ow_m, framek_price, sjsprice, disrate, disprice, fprice, quan, taxrate, sprice, "
                              SQL = SQL & "py_chuga, robby_box, jaeryobunridae, boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, "
                              SQL = SQL & "whaburail, jaeryobunridae_type, door_price) "
                              
                              SQL = SQL & "SELECT '" & new_fkidx & "', fknickname, fidx, sjb_idx, fname, fmidx, getdate(), fstatus, "
                              SQL = SQL & "GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, "
                              SQL = SQL & "fmeidx, fewdate, GREEM_MBAR_TYPE, '" & rsjidx & "', sjb_type_no, setstd, '" &  new_sjsidx & "', ow, oh, tw, th, bcnt, FL, "
                              SQL = SQL & "qtyidx, pidx, ow_m, framek_price, sjsprice, disrate, disprice, fprice, quan, taxrate, sprice, "
                              SQL = SQL & "py_chuga, robby_box, jaeryobunridae, boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, "
                              SQL = SQL & "whaburail, jaeryobunridae_type, door_price "
                              SQL = SQL & "FROM tk_framek WHERE fkidx='" & old_fkidx & "'"
                              ' Response.write ("SQL = "SQL)&"<br>"
                              DbCon.Execute SQL

                             ' tk_framekSub 복사
                              SQL = ""
                              SQL = SQL & "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, "
                              SQL = SQL & "WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, glasstype, "
                              SQL = SQL & "blength, unitprice, pcent, sprice, xsize, ysize, gls, OPT, FL, "
                              SQL = SQL & "door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t, fixglass_t, doortype, "
                              SQL = SQL & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength, chuga_jajae, "
                              SQL = SQL & "rstatus, rstatus2, garo_sero, sunstatus) "
                              SQL = SQL & "SELECT '" & new_fkidx & "', fsidx, fidx, xi, yi, wi, hi, fmidx, getdate(), imsi, "
                              SQL = SQL & "WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, glasstype, "
                              SQL = SQL & "blength, unitprice, pcent, sprice, xsize, ysize, gls, OPT, FL, "
                              SQL = SQL & "door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t, fixglass_t, doortype, "
                              SQL = SQL & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength, chuga_jajae, "
                              SQL = SQL & "rstatus, rstatus2, garo_sero, sunstatus "
                              SQL = SQL & "FROM tk_framekSub WHERE fkidx='" & old_fkidx & "'"
                              Response.write ("SQL= '" & SQL &"'")&"<br>"
                              DbCon.Execute SQL
                              Rs2.MoveNext
                            Loop
                            End IF
                            Rs2.Close
                        End If
                        Rs.MoveNext
                      Loop
                  End If

              Rs.Close
            
          
          
   
          
      Response.Write "OK"
      Response.End
  END IF
' ============복사 끝 ========================
%>

<%
'============삭제 시작 ========================
  If gubun = "frame_delete" Then
      deleteQty = CInt(Request.Form("deleteQty"))
      rsjsidx  = Request.Form("sjsidx")
      rsjidx  = Request.Form("sjidx")
      rmidx  = Request.Form("midx")
      rsprice  = Request.Form("sprice")
      rframename = Request.Form("framename")


    ' 원본 tng_sjaSub 데이터 기준 sjsidx 1개 확보 (원본 제거 방지)
    sql = ""
    sql = sql & "SELECT TOP 1 sjsidx "
    sql = sql & "FROM tng_sjaSub "
    sql = sql & "WHERE sjidx = '" & rsjidx & "' "
    sql = sql & "And midx = '" & rmidx &"' "
    sql = sql & "And sprice =  '" & rsprice & "' "
    sql = sql & "And framename =  '" & rframename & "' "
    Rs.Open sql, Dbcon, 1, 1

    If Not (Rs.BOF Or Rs.EOF) Then
        base_sjsidx = Rs("sjsidx")
    End If
    Rs.close
      
      sql_check = ""
      sql_check = sql_check & "    SELECT TOP " & deleteQty  & " sjsidx "
      sql_check = sql_check & "    FROM tng_sjaSub "
      sql_check = sql_check & "    WHERE sjidx = '" & rsjidx & "' "
      sql_check = sql_check & "      AND midx = '" & rmidx & "' "
      sql_check = sql_check & "      AND sprice = '" & rsprice & "' "
      sql_check = sql_check & "      AND framename = '" & rframename & "' "
      sql_check = sql_check & "      AND sjsidx <> '" & base_sjsidx & "' " '원본 제거 방지
      sql_check = sql_check & "    ORDER BY sjsidx DESC "
      Rs2.open sql_check ,dbcon,1,1
      if not(Rs2.BOF OR Rs2.EOF) Then 
        Do  while not Rs2.EOF
          sjsidx = Rs2("sjsidx")
          
          '======== tk_frmaekSub 삭제 ========
            sql_delete = ""
            sql_delete = sql_delete & "DELETE FROM tk_framekSub "
            sql_delete = sql_delete & "WHERE fkidx IN ( "
            sql_delete = sql_delete & "    SELECT fkidx"
            sql_delete = sql_delete & "    FROM tk_framek "
            sql_delete = sql_delete & "    where sjsidx = '" & sjsidx &"'               "
            sql_delete = sql_delete & ")"
            Dbcon.Execute sql_delete
          '======== tk_frmaekSub 삭제  끝========
            
          '======== tk_frmaek 삭제 ========
          sql_delete = ""
          sql_delete = sql_delete & "DELETE FROM tk_framek "
          sql_delete = sql_delete & "WHERE sjsidx = '" & sjsidx & "' "
          Dbcon.Execute sql_delete
        '======== tk_frmaek 삭제  끝========
        
        '======== tng_sjaSub 삭제  시작========
          sql_delete = ""
          sql_delete = sql_delete & "DELETE FROM tng_sjaSub "
          sql_delete = sql_delete & "WHERE sjsidx = '" & sjsidx & "' "
          Dbcon.Execute sql_delete
        '======== tk_frmaek 삭제  끝========
          Rs2.MoveNext
        Loop
      Rs2.close()
      End if  



   Response.Write "OK"
   Response.End
  End if
'============삭제 끝 ========================
%>



<%
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_bfimg

' POST로 넘어온 gubun/suju_kyun_status 우선 적용
If gubun = "" Then
  gubun = encodesTR(uploadform("gubun"))
End If
' suju_kyun_status는 항상 폼 값만 사용 (중복 입력 방지)
rsuju_kyun_status = encodesTR(uploadform("suju_kyun_status"))

sjdate = encodesTR(uploadform("sjdate"))
sjnum = encodesTR(uploadform("sjnum"))
cgdate = encodesTR(uploadform("cgdate"))
djcgdate = encodesTR(uploadform("djcgdate"))
cgtype = encodesTR(uploadform("cgtype"))
cgaddr = encodesTR(uploadform("cgaddr"))
cgset = encodesTR(uploadform("cgset"))
sjmidx = encodesTR(uploadform("sjmidx"))
sjcidx = encodesTR(uploadform("sjcidx"))
midx = encodesTR(uploadform("midx"))
sjidx = encodesTR(uploadform("sjidx"))
original_sjidx = sjidx '원본 견적의 sjidx 저장
'bfimg = uploadform("bfimg")
'uploadform.AutoMakeFolder = True
'uploadform.DefaultPath=DefaultPath_bfimg
'bfimg = uploadform("bfimg").Save( ,false)   '실질적인 파일 저장
'board_file_name1 = uploadform("bfimg").LastSavedFileName '파일저장 경로에서 파일명과 확장자만 board_file_name1변수에 저장한다.
'Response.write buidx&"<br>"
'Response.write board_file_name1&"<br>"
'if bfimg<>"" then 
'    splcyj=split(board_file_name1,".")
'    afilename=splcyj(0) 'aaaa'
'    bfilename=splcyj(1) 'pdf/jpg/hwp'
'    board_file_name1=ymdhns&"."&bfilename
'    board_file_name0 = uploadform.SaveAs(board_file_name1, False)        
'end if 
'uploadform.DeleteFile bfimg 

' 견적에서 수주로 발행하는 경우 (원본 sjidx가 있고, gubun = issue_suju 인 경우)
' 버튼은 견적 화면( suju_kyun_status = 1 )에서만 노출된다.
If gubun = "issue_suju" And original_sjidx <> "" Then
  ' 새로운 수주 생성 (sjidx는 자동 생성)
  SQL=" Insert into TNG_SJA (sjdate, sjnum, cgdate, djcgdate, cgtype, cgaddr, cgset, sjmidx, sjcidx, midx, wdate, meidx, mewdate, suju_kyun_status, move) "
  SQL=SQL&" Values ('"&sjdate&"', '"&sjnum&"', '"&cgdate&"', '"&djcgdate&"', '"&cgtype&"', '"&cgaddr&"', '"&cgset&"', '"&sjmidx&"' "
  SQL=SQL&" , '"&sjcidx&"', '"&C_midx&"', getdate(), '"&C_midx&"', getdate(), '0', '"&original_sjidx&"') "
  Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)
  
  ' 새로 생성된 수주의 sjidx 가져오기
  SQL="Select max(sjidx) From TNG_SJA "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    sjidx=Rs(0)
  End If
  Rs.Close
  
  '==============================
  ' 연관 테이블 데이터 복사 시작
  ' 1) 품목 tng_sjaSub
  '==============================
  SQL = ""
  SQL = SQL & "INSERT INTO tng_sjaSub ("
  SQL = SQL & " sjidx, midx, mwdate, meidx, mewdate, mwidth,"
  SQL = SQL & " mheight, qtyidx, sjsprice, disrate, disprice, fprice,"
  SQL = SQL & " sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2,"
  SQL = SQL & " asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2,"
  SQL = SQL & " astatus, py_chuga, door_price, whaburail, robby_box,"
  SQL = SQL & " jaeryobunridae, boyangjea, pidx, framename,"
  SQL = SQL & " frame_price, frame_option_price"
  SQL = SQL & " ) "
  SQL = SQL & "SELECT "
  SQL = SQL & " '" & sjidx & "' AS sjidx, midx, mwdate, meidx, mewdate, mwidth,"
  SQL = SQL & " mheight, qtyidx, sjsprice, disrate, disprice, fprice,"
  SQL = SQL & " sjb_idx, quan, taxrate, sprice, asub_wichi1, asub_wichi2,"
  SQL = SQL & " asub_bigo1, asub_bigo2, asub_bigo3, asub_meno1, asub_meno2,"
  SQL = SQL & " astatus, py_chuga, door_price, whaburail, robby_box,"
  SQL = SQL & " jaeryobunridae, boyangjea, pidx, framename,"
  SQL = SQL & " frame_price, frame_option_price "
  SQL = SQL & "FROM tng_sjaSub "
  SQL = SQL & "WHERE sjidx='" & original_sjidx & "'"
  Response.write (SQL)&"<br>"
  dbCon.execute (SQL)
  
  '==============================
  ' 2) 기타 자재 tk_etc
  '==============================
  SQL = ""
  SQL = SQL & "INSERT INTO tk_etc (etc_name, etc_qty, midx, mdate, etc_price, sjidx) "
  SQL = SQL & "SELECT etc_name, etc_qty, midx, mdate, etc_price, '" & sjidx & "' "
  SQL = SQL & "FROM tk_etc WHERE sjidx='" & original_sjidx & "'"
  Response.write (SQL)&"<br>"
  dbCon.execute (SQL)
  
  '==============================
  ' 3) 용차 tk_yongcha
  '==============================
  SQL = ""
  SQL = SQL & "INSERT INTO tk_yongcha ("
  SQL = SQL & " yname, ytel, yaddr, ydate, ymemo, "
  SQL = SQL & " ycarnum, ygisaname, ygisatel, ycostyn, yprepay, "
  SQL = SQL & " ystatus, ymidx, ywdate, ymeidx, ywedate, yaddr1, sjidx"
  SQL = SQL & " ) "
  SQL = SQL & "SELECT "
  SQL = SQL & " yname, ytel, yaddr, ydate, ymemo, "
  SQL = SQL & " ycarnum, ygisaname, ygisatel, ycostyn, yprepay, "
  SQL = SQL & " ystatus, ymidx, ywdate, ymeidx, ywedate, yaddr1, '" & sjidx & "' "
  SQL = SQL & "FROM tk_yongcha "
  SQL = SQL & "WHERE sjidx='" & original_sjidx & "' AND ystatus=1"
  Response.write (SQL)&"<br>"
  dbCon.execute (SQL)
  
  '==============================
  ' 4) 대신화물 tk_daesin
  '==============================
  SQL = ""
  SQL = SQL & "INSERT INTO tk_daesin ("
  SQL = SQL & " ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
  SQL = SQL & " ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_addr1, "
  SQL = SQL & " ds_to_costyn, ds_to_prepay, "
  SQL = SQL & " dsmidx, dswdate, dsmeidx, dswedate, dsstatus, sjidx"
  SQL = SQL & " ) "
  SQL = SQL & "SELECT "
  SQL = SQL & " ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
  SQL = SQL & " ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_addr1, "
  SQL = SQL & " ds_to_costyn, ds_to_prepay, "
  SQL = SQL & " dsmidx, dswdate, dsmeidx, dswedate, dsstatus, '" & sjidx & "' "
  SQL = SQL & "FROM tk_daesin "
  SQL = SQL & "WHERE sjidx='" & original_sjidx & "' AND dsstatus=1"
  Response.write (SQL)&"<br>"
  dbCon.execute (SQL)
  
  '==============================
  ' 5) 프레임/도면 tk_framek, tk_framekSub
  '==============================
  Dim origSjs(), newSjs()
  Dim cnt, idx
  Dim old_sjs, new_sjs
  Dim old_fkidx, new_fkidx
  
  ' 원본 견적의 sjsidx 목록
  SQL = "SELECT sjsidx FROM tng_sjaSub WHERE sjidx='" & original_sjidx & "' ORDER BY sjsidx"
  Rs.open SQL, Dbcon
  cnt = 0
  If Not (Rs.BOF Or Rs.EOF) Then
    ReDim origSjs(0)
    idx = 0
    Do While Not Rs.EOF
      If idx > 0 Then
        ReDim Preserve origSjs(idx)
      End If
      origSjs(idx) = Rs("sjsidx")
      idx = idx + 1
      Rs.MoveNext
    Loop
    cnt = idx
  End If
  Rs.Close
  
  If cnt > 0 Then
    ' 새로 생성된 수주의 sjsidx 목록
    SQL = "SELECT sjsidx FROM tng_sjaSub WHERE sjidx='" & sjidx & "' ORDER BY sjsidx"
    Rs.open SQL, Dbcon
    ReDim newSjs(cnt-1)
    idx = 0
    Do While Not Rs.EOF And idx < cnt
      newSjs(idx) = Rs("sjsidx")
      idx = idx + 1
      Rs.MoveNext
    Loop
    Rs.Close
    
    ' 두 쪽 개수가 같은 경우에만 프레임 복사
    If idx = cnt Then
      For idx = 0 To cnt-1
        old_sjs = origSjs(idx)
        new_sjs = newSjs(idx)
        
        ' 이 sjsidx에 연결된 프레임들 복사
        SQL = "SELECT fkidx FROM tk_framek WHERE sjidx='" & original_sjidx & "' AND sjsidx='" & old_sjs & "'"
        Rs.open SQL, Dbcon
        Do While Not (Rs.BOF Or Rs.EOF)
          old_fkidx = Rs("fkidx")
          
          ' 새 fkidx 생성
          SQL = "SELECT ISNULL(MAX(fkidx),0)+1 FROM tk_framek"
          Rs1.open SQL, Dbcon
          If Not (Rs1.BOF Or Rs1.EOF) Then
            new_fkidx = Rs1(0)
          End If
          Rs1.Close
          
          ' tk_framek 복사 (TNG1_B_suju_quick.asp 패턴 활용)
          SQL = ""
          SQL = SQL & "INSERT INTO tk_framek (fkidx, fknickname, fidx, sjb_idx, fname, fmidx, fwdate, fstatus, "
          SQL = SQL & "GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, "
          SQL = SQL & "fmeidx, fewdate, GREEM_MBAR_TYPE, sjidx, sjb_type_no, setstd, sjsidx, ow, oh, tw, th, bcnt, FL, "
          SQL = SQL & "qtyidx, pidx, ow_m, framek_price, sjsprice, disrate, disprice, fprice, quan, taxrate, sprice, "
          SQL = SQL & "py_chuga, robby_box, jaeryobunridae, boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, "
          SQL = SQL & "whaburail, jaeryobunridae_type, door_price) "
          
          SQL = SQL & "SELECT '" & new_fkidx & "', fknickname, fidx, sjb_idx, fname, fmidx, getdate(), fstatus, "
          SQL = SQL & "GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE, GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, "
          SQL = SQL & "fmeidx, fewdate, GREEM_MBAR_TYPE, '" & sjidx & "', sjb_type_no, setstd, '" & new_sjs & "', ow, oh, tw, th, bcnt, FL, "
          SQL = SQL & "qtyidx, pidx, ow_m, framek_price, sjsprice, disrate, disprice, fprice, quan, taxrate, sprice, "
          SQL = SQL & "py_chuga, robby_box, jaeryobunridae, boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, "
          SQL = SQL & "whaburail, jaeryobunridae_type, door_price "
          SQL = SQL & "FROM tk_framek WHERE fkidx='" & old_fkidx & "'"
          Response.write (SQL)&"<br>"
          DbCon.Execute SQL
          
          ' tk_framekSub 복사
          SQL = ""
          SQL = SQL & "INSERT INTO tk_framekSub (fkidx, fsidx, fidx, xi, yi, wi, hi, fmidx, fwdate, imsi, "
          SQL = SQL & "WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, glasstype, "
          SQL = SQL & "blength, unitprice, pcent, sprice, xsize, ysize, gls, OPT, FL, "
          SQL = SQL & "door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t, fixglass_t, doortype, "
          SQL = SQL & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength, chuga_jajae, "
          SQL = SQL & "rstatus, rstatus2, garo_sero, sunstatus) "
          
          SQL = SQL & "SELECT '" & new_fkidx & "', fsidx, fidx, xi, yi, wi, hi, fmidx, getdate(), imsi, "
          SQL = SQL & "WHICHI_FIX, WHICHI_AUTO, bfidx, bwsize, bhsize, gwsize, ghsize, fstype, glasstype, "
          SQL = SQL & "blength, unitprice, pcent, sprice, xsize, ysize, gls, OPT, FL, "
          SQL = SQL & "door_w, door_h, glass_w, glass_h, busok, busoktype, doorglass_t, fixglass_t, doortype, "
          SQL = SQL & "doorglass_w, doorglass_h, doorsizechuga_price, door_price, goname, barNAME, alength, chuga_jajae, "
          SQL = SQL & "rstatus, rstatus2, garo_sero, sunstatus "
          SQL = SQL & "FROM tk_framekSub WHERE fkidx='" & old_fkidx & "'"
          Response.write (SQL)&"<br>"
          DbCon.Execute SQL
          
          Rs.MoveNext
        Loop
        Rs.Close
      Next
    End If
  End If
  '==============================
  ' 연관 테이블 데이터 복사 끝
  '==============================
  
  '==============================
  ' 수주 발행 후 cflevel 할인 재계산
  '==============================
  ' cflevel 가져오기
  Dim cflevel
  cflevel = 0 ' 기본값
  SQL = "SELECT b.cflevel FROM TNG_SJA a JOIN tk_customer b ON b.cidx = a.sjcidx WHERE a.sjidx = '" & sjidx & "'"
  Rs.open SQL, Dbcon
  If Not (Rs.bof or Rs.eof) Then
    If Not IsNull(Rs(0)) Then
      cflevel = Rs(0)
    End If
  End If
  Rs.Close
  
  ' 새로 생성된 수주의 모든 tk_framek 레코드에 대해 cflevel 할인 재계산
  SQL = "SELECT fkidx, sjb_type_no, sjsprice, quan FROM tk_framek WHERE sjidx='" & sjidx & "'"
  Rs.open SQL, Dbcon
  If Not (Rs.bof or Rs.eof) Then
    Do While Not Rs.EOF
      Dim rfkidx, rsjb_type_no, rsjsprice, rquan
      Dim rdisrate, rdisprice, rfprice, rtaxrate, rsprice
      Dim rsjsprice_total, rsjsprice_update
      
      rfkidx = Rs("fkidx")
      rsjb_type_no = Rs("sjb_type_no")
      rsjsprice = Rs("sjsprice")
      rquan = Rs("quan")
      
      If IsNull(rsjsprice) Or rsjsprice = "" Then
        rsjsprice = 0
      End If
      If IsNull(rquan) Or rquan = "" Or rquan = 0 Then
        rquan = 1
      End If
      
      ' sjsprice_total 계산 (천 단위 올림)
      rsjsprice_total = -Int(-rsjsprice / 1000) * 1000
      
      ' cflevel에 따른 disrate 계산 (수주일 때만 적용)
      rdisrate = 0
      Select Case cflevel
        Case 0
          rdisrate = 0  ' 할인 없음
        Case 1
          rdisrate = 10 ' 무조건 10% 할인
        Case 2
          If rsjb_type_no = 11 Or rsjb_type_no = 12 Then
            rdisrate = 10 ' 수동 스텐 보급만 10% 할인
          End If
        Case 3
          If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 4 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Then
            rdisrate = 10 ' 자동만 10% 할인 이중하고 포켓 슬림 제외
          End If
        Case 4
          rdisrate = -10 ' 10% 증가 (업)
      End Select
      
      ' 할인금액 및 공급가 계산
      rsjsprice_update = rsjsprice_total * rquan '총 원가 (수량 반영)
      
      If rdisrate > 0 Then
        '할인
        rdisprice = rsjsprice_total * (rdisrate / 100)
        rdisprice = ( Int(rdisprice / 1000) * 1000 ) * rquan
        rfprice = rsjsprice_update - rdisprice
      ElseIf rdisrate < 0 Then
        '업 (disrate는 음수라서 절대값으로 변환)
        rdisprice = rsjsprice_total * (Abs(rdisrate) / 100)
        rdisprice = ( Int(rdisprice / 1000) * 1000 ) * rquan
        rfprice = rsjsprice_update + rdisprice
      Else
        '변동 없음
        rdisprice = 0
        rfprice = rsjsprice_update
      End If
      
      ' 부가세 계산
      rtaxrate = rfprice * 0.1
      If rtaxrate < 0 Then
        rtaxrate = Round(rtaxrate)
      End If
      
      ' 최종 합계
      rsprice = rfprice + rtaxrate
      If rsprice = 0 Or IsNull(rsprice) Then
        rsprice = 0
      End If
      
      ' tk_framek 업데이트
      SQL = "UPDATE tk_framek SET "
      SQL = SQL & " disrate='" & rdisrate & "', disprice='" & rdisprice & "', fprice='" & rfprice & "' "
      SQL = SQL & " , taxrate='" & rtaxrate & "', sprice='" & rsprice & "' "
      SQL = SQL & " WHERE fkidx='" & rfkidx & "'"
      Response.write (SQL)&"<br>"
      dbCon.execute (SQL)
      
      Rs.MoveNext
    Loop
  End If
  Rs.Close
  '==============================
  ' cflevel 할인 재계산 끝
  '==============================
  
  ' 원본 견적의 move에 새 수주의 sjidx 저장
  SQL=" Update TNG_SJA set move='"&sjidx&"' Where sjidx='"&original_sjidx&"' "
  Response.write (SQL)&"<br>"
  dbCon.execute (SQL)
  
  response.write "<script>location.replace('tng1_b.asp?sjcidx="&sjcidx&"&sjmidx="&sjmidx&"&sjidx="&sjidx&"&suju_kyun_status=0');</script>"
ElseIf sjidx="" Then 
  ' 신규 생성
  ' suju_kyun_status 값이 비어 있으면 기본을 0(수주)로, 1이면 그대로 견적으로 저장
  If rsuju_kyun_status = "" Then
    rsuju_kyun_status = "0"
  End If
  SQL=" Insert into TNG_SJA (sjdate, sjnum, cgdate, djcgdate, cgtype, cgaddr, cgset, sjmidx, sjcidx, midx, wdate, meidx, mewdate , suju_kyun_status ) "
  SQL=SQL&" Values ('"&sjdate&"', '"&sjnum&"', '"&cgdate&"', '"&djcgdate&"', '"&cgtype&"', '"&cgaddr&"', '"&cgset&"', '"&sjmidx&"' "
  SQL=SQL&" , '"&sjcidx&"', '"&C_midx&"', getdate(), '"&C_midx&"', getdate() , '"&rsuju_kyun_status&"' ) "
  Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)

  SQL="Select max(sjidx) From TNG_SJA "
  Rs.open Sql,Dbcon
  If Not (Rs.bof or Rs.eof) Then 
    sjidx=Rs(0)
  End If
  Rs.Close
  response.write "<script>location.replace('tng1_b.asp?sjcidx="&sjcidx&"&sjmidx="&sjmidx&"&sjidx="&sjidx&"');</script>"
Else
  ' 일반 UPDATE
  SQL=" Update TNG_SJA set sjdate='"&sjdate&"', sjnum='"&sjnum&"', cgdate='"&cgdate&"', djcgdate='"&djcgdate&"', cgtype='"&cgtype&"' "
  SQL=SQL&" , cgaddr='"&cgaddr&"', cgset='"&cgset&"', sjmidx='"&sjmidx&"', sjcidx='"&sjcidx&"', meidx='"&C_midx&"', mewdate=getdate() , suju_kyun_status='"&rsuju_kyun_status&"' "
  SQL=SQL&" Where sjidx='"&sjidx&"' "
  response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)
end if
response.write "<script>location.replace('tng1_b.asp?sjcidx="&sjcidx&"&sjmidx="&sjmidx&"&sjidx="&sjidx&"');</script>"

%>
<%
Set Rs=Nothing
Set Rs1=Nothing
Set Rs2=Nothing
call dbClose()
%>




