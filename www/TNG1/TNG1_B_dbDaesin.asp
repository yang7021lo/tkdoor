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



'삭제 요청 처리 시작
'====================
gubun=Request("gubun")


if gubun="delete" then
  rsjcidx=Request("sjcidx")
  rsjmidx=Request("sjmidx")
  rsjidx=Request("sjidx")

  SQL=" Update tk_daesin set dsstatus='0' where sjidx='"&rsjidx&"' "
  'Response.write (SQL)&"<br>"
  'response.end
  dbCon.execute (SQL)
  response.write "<script>location.replace('tng1_b.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"');</script>"

end if
'====================
'삭제 요청 처리 끝
%>
<%
' DextUpload 시작
'==============================
Set uploadform = Server.CreateObject("DEXT.FileUpload") 
uploadform.AutoMakeFolder = True
uploadform.DefaultPath=DefaultPath_bfimg

rsjcidx = encodesTR(uploadform("sjcidx"))
rsjmidx = encodesTR(uploadform("sjmidx"))
rsjidx = encodesTR(uploadform("sjidx"))
rdsidx = encodesTR(uploadform("dsidx"))
rds_daesinname = encodesTR(uploadform("ds_daesinname"))
rds_daesintel = encodesTR(uploadform("ds_daesintel"))
rds_daesinaddr = encodesTR(uploadform("ds_daesinaddr"))
rdsdate = encodesTR(uploadform("dsdate"))
rdsmemo = encodesTR(uploadform("dsmemo"))
rds_to_num = encodesTR(uploadform("ds_to_num"))
rds_to_name = encodesTR(uploadform("ds_to_name"))
rds_to_tel = encodesTR(uploadform("ds_to_tel"))
rds_to_addr = encodesTR(uploadform("ds_to_addr"))
rds_to_addr1 = encodesTR(uploadform("ds_to_addr1"))
rds_to_costyn = encodesTR(uploadform("ds_to_costyn"))
rds_to_prepay = encodesTR(uploadform("ds_to_prepay"))  ' → "4,000원" 같은 문자열
    clean_prepay = Replace(rds_to_prepay, ",", "") ' → "4000원"
    clean_prepay = Replace(clean_prepay, "원", "") ' → "4000"
    clean_prepay = Trim(clean_prepay)

    ' 숫자형으로 변환
    If IsNumeric(clean_prepay) Then
        clean_prepay = CLng(clean_prepay)  
    Else
        clean_prepay = 0
    End If

rdsstatus = encodesTR(uploadform("dsstatus"))

'Response.write rds_to_addr1&"<br>"


'기존 용차 정보가 있다면 dsstatus를 0으로 변경하고 수정자와 수정일시 등록하고 새로 등록한다.
if rdsidx<>"" then 
  SQL=" Update tk_daesin set dsstatus='0', dsmeidx='"&C_midx&"', dswedate=getdate() Where dsidx='"&rdsidx&"' "
  dbCon.execute (SQL)
end if
    SQL = ""
    SQL = SQL & "INSERT INTO tk_daesin ("
    SQL = SQL & "  sjidx, ds_daesinname, ds_daesintel, ds_daesinaddr, dsdate, dsmemo, "
    SQL = SQL & "  ds_to_num, ds_to_name, ds_to_tel, ds_to_addr, ds_to_addr1, "
    SQL = SQL & "  ds_to_costyn, ds_to_prepay, dsstatus, dsmidx, dswdate, dsmeidx, dswedate "
    SQL = SQL & ") VALUES ("
    SQL = SQL & " '" & rsjidx & "', "
    SQL = SQL & " '" & rds_daesinname & "', "
    SQL = SQL & " '" & rds_daesintel & "', "
    SQL = SQL & " '" & rds_daesinaddr & "', "
    SQL = SQL & " '" & rdsdate & "', "
    SQL = SQL & " '" & rdsmemo & "', "
    SQL = SQL & " '" & rds_to_num & "', "
    SQL = SQL & " '" & rds_to_name & "', "
    SQL = SQL & " '" & rds_to_tel & "', "
    SQL = SQL & " '" & rds_to_addr & "', "
    SQL = SQL & " '" & rds_to_addr1 & "', "
    SQL = SQL & " '" & rds_to_costyn & "', "
    SQL = SQL & " '" & clean_prepay & "', "
    SQL = SQL & " '1', "                     ' dsstatus
    SQL = SQL & " '" & C_midx & "', "        ' dsmidx
    SQL = SQL & " getdate(), "               ' dswdate
    SQL = SQL & " '" & C_midx & "', "        ' dsmeidx
    SQL = SQL & " getdate() "                ' dswedate
    SQL = SQL & ")"
    Response.Write(SQL) & " tk_daesin <br>"
    Dbcon.Execute(SQL)


'=========================================
' 🚚 WMS 출하 메타 + 디테일 자동 인서트
'=========================================

' 전제: rsjidx, rdsdate, rds_daesinname, rds_daesintel, rds_daesinaddr,
'       rds_to_name, rds_to_tel, rds_to_addr, rds_to_costyn, clean_prepay, C_midx

'-----------------------------------------
' 🔹 1단계: 최근 등록된 대신화물 dsidx 조회
'-----------------------------------------
SQL = ""
SQL = SQL & "SELECT TOP 1 dsidx FROM tk_daesin "
SQL = SQL & "WHERE sjidx='" & rsjidx & "' "
SQL = SQL & "ORDER BY dsidx DESC"
Response.write (SQL) & " 🔍 dsidx 조회<br>"

Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    last_dsidx = Rs("dsidx")
End If
Rs.Close

'=========================================
' 🚚 2단계: tk_wms_meta 인서트 (컬럼별 주석 상세)
'=========================================

'-----------------------------------------
' 🧾 회사 마스터 자동 보정 (tk_company)
'   - company_id=1 없으면 태광AL 기본 등록
'   - SaaS 멀티테넌트 루트 (절대 변경 금지)
'-----------------------------------------
SQL = ""
SQL = SQL & "IF NOT EXISTS (SELECT 1 FROM tk_company WHERE company_id = 1) "
SQL = SQL & "BEGIN "
SQL = SQL & "SET IDENTITY_INSERT tk_company ON; "
SQL = SQL & "INSERT INTO tk_company (company_id, company_code, company_name, use_yn, reg_date) "
SQL = SQL & "VALUES (1, N'TK001', N'태광도어', 1, SYSDATETIME()); "
SQL = SQL & "SET IDENTITY_INSERT tk_company OFF; "
SQL = SQL & "END"
Response.Write(SQL) & " 🧾 company_id 기본 보정 (tk_company에 1이 없으면 자동 생성)<br>"
Dbcon.Execute(SQL)

'-----------------------------------------
' 🧠 룰 엔진: rule_group별 result_value 반환
'-----------------------------------------
Function GetRuleValue(rule_group, cgtype, wms_type)

    SQLr = ""
    SQLr = SQLr & "SELECT rule_id, condition_sql, result_value "
    SQLr = SQLr & "FROM tk_rule_core "
    SQLr = SQLr & "WHERE company_id='1' AND rule_group='" & rule_group & "' AND active='1' "
    SQLr = SQLr & "ORDER BY priority ASC"

    Set Rr = Server.CreateObject("ADODB.Recordset")
    Rr.Open SQLr, Dbcon

    Do While Not Rr.EOF

        cond = Rr("condition_sql")

        ' 🔍 조건식 내부 변수 실값 치환
        cond = Replace(cond, "cgtype", cgtype)
        cond = Replace(cond, "wms_type", wms_type)

        ' 🔥 조건식 평가 → TRUE면 결과 반환
        If Eval(cond) = True Then
            GetRuleValue = Rr("result_value")
            Rr.Close
            Set Rr = Nothing
            Exit Function
        End If

        Rr.MoveNext
    Loop

    Rr.Close
    Set Rr = Nothing

    GetRuleValue = ""   ' 룰 미적용 시 NULL 반환
End Function


'-----------------------------------------
' 🚚 WMS_TYPE 자동 결정 (cgtype 기반)
'-----------------------------------------
wms_type = GetRuleValue("WMS_TYPE", cgtype, 0)

If wms_type = "" Then
    wms_type = 1     ' 기본값: 화물
End If

'-----------------------------------------
' 🏭 출고지(sender) 자동 결정
'-----------------------------------------
sender_code = GetRuleValue("SENDER_RULE", cgtype, wms_type)

If sender_code = "" Then
    sender_code = "CARGO_DAESIN"
End If

'-----------------------------------------
' 🏭 tk_wms_sender에서 실제 정보 조회
'-----------------------------------------
SQL = "SELECT sender_name, sender_tel, sender_addr, sender_addr1 " & _
      "FROM tk_wms_sender WHERE sender_code='" & sender_code & "'"

Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    sender_name  = Rs("sender_name")
    sender_tel   = Rs("sender_tel")
    sender_addr  = Rs("sender_addr")
    sender_addr1 = Rs("sender_addr1")
End If
Rs.Close

'-----------------------------------------
' 🏬 창고 인덱스 자동 매핑
'-----------------------------------------
warehouse_idx = GetRuleValue("WAREHOUSE_RULE", cgtype, wms_type)

If warehouse_idx = "cmove" Then
    warehouse_idx = cgtype
End If

If warehouse_idx = "" Then
    warehouse_idx = "NULL"
End If

'-----------------------------------------
' 🚛 carrier_id 자동 매핑
'-----------------------------------------
carrier_id = GetRuleValue("CARRIER_RULE", cgtype, wms_type)

If carrier_id = "dsidx" Then
    carrier_id = last_dsidx
End If

If carrier_id = "" Then
    carrier_id = "NULL"
End If


SQL = ""
SQL = SQL & "INSERT INTO tk_wms_meta ("
SQL = SQL & "  company_id,"
SQL = SQL & "  wms_no,"              ' 출하 문서번호(자동생성 전임시 NULL)
SQL = SQL & "  cidx,"                ' 거래처키(sjcidx 동일)
SQL = SQL & "  sjidx,"               ' 수주 헤더
SQL = SQL & "  sjsidx,"              ' 수주 상세(세트)
SQL = SQL & "  wms_type,"            ' 출하유형 1=택배
SQL = SQL & "  carrier_id,"
SQL = SQL & "  driver_id,"
SQL = SQL & "  warehouse_idx,"
SQL = SQL & "  planned_ship_dt,"
SQL = SQL & "  actual_ship_dt,"
SQL = SQL & "  sender_name,"
SQL = SQL & "  sender_tel,"
SQL = SQL & "  sender_addr,"
SQL = SQL & "  sender_addr1,"        ' Sender 상세주소
SQL = SQL & "  recv_name,"
SQL = SQL & "  recv_tel,"
SQL = SQL & "  recv_addr,"
SQL = SQL & "  recv_addr1,"          ' Receiver 상세주소
SQL = SQL & "  cost_yn,"
SQL = SQL & "  prepay_yn,"
SQL = SQL & "  total_quan,"
SQL = SQL & "  total_weight,"
SQL = SQL & "  status,"
SQL = SQL & "  reg_user,"
SQL = SQL & "  reg_date,"
SQL = SQL & "  upd_user,"
SQL = SQL & "  upd_date,"
SQL = SQL & "  memo"
SQL = SQL & ") VALUES ("
SQL = SQL & " '1',"                        ' company_id
SQL = SQL & " NULL,"                       ' wms_no
SQL = SQL & " '" & rsjcidx & "',"          ' cidx
SQL = SQL & " '" & rsjidx & "',"           ' sjidx
SQL = SQL & " NULL,"                       ' sjsidx
SQL = SQL & " '" & wms_type & "',"         ' wms_type
SQL = SQL & " "  & carrier_id & ","        ' carrier_id
SQL = SQL & " NULL,"                       ' driver_id
SQL = SQL & " " & warehouse_idx & ","                        ' warehouse_idx
SQL = SQL & " '" & rdsdate & "',"          ' planned_ship_dt
SQL = SQL & " '" & rdsdate & "',"          ' actual_ship_dt
SQL = SQL & " '" & sender_name  & "',"   ' sender_name
SQL = SQL & " '" & sender_tel & "',"    ' sender_tel
SQL = SQL & " '" & sender_addr  & "',"   ' sender_addr
SQL = SQL & " '" & sender_addr1  & "',"     ' sender_addr1
SQL = SQL & " '" & rds_to_name & "',"      ' recv_name
SQL = SQL & " '" & rds_to_tel & "',"       ' recv_tel
SQL = SQL & " '" & rds_to_addr & "',"      ' recv_addr
SQL = SQL & " '" & rds_to_addr1 & "',"      ' recv_addr1
SQL = SQL & " '" & rds_to_costyn & "',"    ' cost_yn
If clean_prepay > 0 Then
    prepay_flag = "1"
Else
    prepay_flag = "0"
End If
SQL = SQL & " '" & prepay_flag & "',"      ' prepay_yn
SQL = SQL & " '0',"                        ' total_quan
SQL = SQL & " NULL,"                       ' total_weight
SQL = SQL & " '0',"                        ' status
SQL = SQL & " '" & C_midx & "',"           ' reg_user
SQL = SQL & " GETDATE(),"                  ' reg_date
SQL = SQL & " '" & C_midx & "',"           ' upd_user
SQL = SQL & " GETDATE(),"                  ' upd_date
SQL = SQL & " NULL"                        ' memo
SQL = SQL & ")"

Response.Write(SQL) & " 🧾 tk_wms_meta 인서트<br>"
Dbcon.Execute(SQL)

'-----------------------------------------
' 🔹 3단계: 방금 생성한 wms_idx 조회
'-----------------------------------------
SQL = ""
SQL = SQL & "SELECT TOP 1 wms_idx FROM tk_wms_meta "
SQL = SQL & "WHERE sjidx='" & rsjidx & "' "
SQL = SQL & "ORDER BY wms_idx DESC"
Response.write (SQL) & "  🔍 wms_idx 조회<br>"

Rs.Open SQL, Dbcon
If Not (Rs.BOF Or Rs.EOF) Then
    new_wms_idx = Rs("wms_idx")
End If
Rs.Close

'-----------------------------------------
' 🔹 4단계: tk_wms_detail 자동 인서트 (한 컬럼씩 주석)
'   - gls=0(자재), bfidx<>0(실자재만)
'   - baname: FIX/AUTO 중 활성 쪽 set_name_* 스냅샷
'   - memo: bfimg1~4 파이프(|)로 합쳐서 보관
'-----------------------------------------
SQL = ""
SQL = SQL & "INSERT INTO tk_wms_detail ("
SQL = SQL & "  company_id,"          ' 멀티테넌트 구분 — 현재 1 고정
SQL = SQL & "  wms_idx,"             ' 상위 문서 키(FK: tk_wms_meta.wms_idx)
SQL = SQL & "  sjidx,"               ' 수주 헤더 키
SQL = SQL & "  sjsidx,"              ' 수주 세트 키
SQL = SQL & "  fkidx,"               ' 프레임 헤더 키
SQL = SQL & "  fksidx,"              ' 프레임 상세(라인)
SQL = SQL & "  bfidx,"               ' 자재 마스터 키(tk_barasiF.bfidx)
SQL = SQL & "  baname,"              ' 자재명 스냅샷(FIX/AUTO 중 활성 set_name)
SQL = SQL & "  blength,"             ' 절단 길이(mm)
SQL = SQL & "  unit,"                ' 단위(mm, EA 등)
SQL = SQL & "  quan,"                ' 수량(기본 1)
SQL = SQL & "  weight,"              ' 중량(kg 단위, 미확정 시 NULL)
SQL = SQL & "  warehouse_idx,"       ' 창고 FK (tk_wms_warehouse)
SQL = SQL & "  stock_loc_idx,"       ' 로케이션 FK (tk_wms_stock_loc)
SQL = SQL & "  lot_idx,"             ' LOT FK (tk_wms_lot)
SQL = SQL & "  serial_no,"           ' 시리얼 번호(없으면 NULL)
SQL = SQL & "  status,"              ' 라인 상태(1=대기,2=출하중 등)
SQL = SQL & "  memo,"                ' 이미지 스냅샷(bfimg1~4)
SQL = SQL & "  xsize,"               ' 도면 기준 가로(mm)
SQL = SQL & "  ysize"                ' 도면 기준 세로(mm)
SQL = SQL & ") SELECT "
SQL = SQL & "  '1' AS company_id,"                     ' 회사 ID
SQL = SQL & "  '" & new_wms_idx & "' AS wms_idx,"      ' 상위 문서
SQL = SQL & "  A.sjidx,"                               ' 수주 헤더
SQL = SQL & "  A.sjsidx,"                              ' 수주 세트
SQL = SQL & "  B.fkidx,"                               ' 프레임 헤더
SQL = SQL & "  B.fksidx,"                              ' 프레임 상세
SQL = SQL & "  B.bfidx,"                               ' 자재 마스터 키
SQL = SQL & "  CASE WHEN B.WHICHI_AUTO <> 0 THEN C.set_name_AUTO WHEN B.WHICHI_FIX <> 0 THEN C.set_name_FIX END AS baname,"  ' 자재명 스냅샷
SQL = SQL & "  B.blength,"                             ' 절단 길이
SQL = SQL & "  'mm' AS unit,"                          ' 단위 기본값 mm
SQL = SQL & "  '1' AS quan,"                           ' 수량 기본값
SQL = SQL & "  NULL AS weight,"                        ' 중량 NULL
SQL = SQL & "  NULL AS warehouse_idx,"                 ' 창고 미지정
SQL = SQL & "  NULL AS stock_loc_idx,"                 ' 로케이션 미지정
SQL = SQL & "  NULL AS lot_idx,"                       ' LOT 없음
SQL = SQL & "  NULL AS serial_no,"                     ' 시리얼 없음
SQL = SQL & "  '1' AS status,"                         ' 1=대기
SQL = SQL & "  CONCAT(ISNULL(C.bfimg1,''),'|',ISNULL(C.bfimg2,''),'|',ISNULL(C.bfimg3,''),'|',ISNULL(C.bfimg4,'')) AS memo,"  ' 이미지 경로 합침
SQL = SQL & "  B.xsize,"                               ' 가로(mm)
SQL = SQL & "  B.ysize"                                ' 세로(mm)
SQL = SQL & " FROM tk_framek A "
SQL = SQL & " JOIN tk_framekSub B ON A.fkidx = B.fkidx "  ' 수주→프레임 상세
SQL = SQL & " LEFT JOIN tk_barasiF C ON B.bfidx = C.bfidx " ' 자재 마스터
SQL = SQL & " WHERE A.sjidx='" & rsjidx & "' "
SQL = SQL & " AND B.gls='0' "
SQL = SQL & " AND B.bfidx<>'0' "
SQL = SQL & " AND (B.WHICHI_FIX <> 0 OR B.WHICHI_AUTO <> 0)"
SQL = SQL & "  AND (B.WHICHI_FIX <> 0 OR B.WHICHI_AUTO <> 0) " ' (선택) FIX/AUTO 표시된 것만

Response.Write(SQL) & "  📦 tk_wms_detail 인서트(FIX/AUTO, 기타 포함)<br>"
Dbcon.Execute(SQL)

'-----------------------------------------
' 🔹 5단계(옵션): 메타 집계 업데이트 (총수량/중량 등)
'   — 지금은 quan 전부 1로 넣었으니 라인수=총수량으로 갱신 예시
'-----------------------------------------
SQL = ""
SQL = SQL & "UPDATE M "
SQL = SQL & "SET M.total_quan = X.cnt, "
SQL = SQL & "    M.total_weight = NULL, "        ' 중량 집계 룰 생기면 계산 반영
SQL = SQL & "    M.upd_user = '" & C_midx & "', "
SQL = SQL & "    M.upd_date = GETDATE() "
SQL = SQL & "FROM tk_wms_meta M "
SQL = SQL & "JOIN ("
SQL = SQL & "  SELECT company_id, wms_idx, COUNT(*) AS cnt "
SQL = SQL & "  FROM tk_wms_detail "
SQL = SQL & "  WHERE company_id='1' AND wms_idx='" & new_wms_idx & "' "
SQL = SQL & "  GROUP BY company_id, wms_idx"
SQL = SQL & ") X ON X.company_id=M.company_id AND X.wms_idx=M.wms_idx"

Response.write (SQL) & "  🧮 메타 집계 갱신<br>"
Dbcon.Execute(SQL)

'-----------------------------------------
' 🔹 6단계🧾 wms_no 자동 생성 (출하번호 포맷)
'   - 형식: WMS-YYYYMMDD-XXX
'   - wms_idx 기준으로 3자리 시퀀스
'-----------------------------------------
SQL = ""
SQL = SQL & "UPDATE tk_wms_meta "
SQL = SQL & "SET wms_no = 'WMS-' + CONVERT(char(8), GETDATE(), 112) + '-' + "
SQL = SQL & "RIGHT('000' + CAST(wms_idx AS varchar(3)), 3) "
SQL = SQL & "WHERE wms_idx = '" & new_wms_idx & "'"

Response.Write(SQL) & "  🔢 wms_no 자동 생성<br>"
Dbcon.Execute(SQL)


response.write "<script>location.replace('tng1_b.asp?sjcidx="&rsjcidx&"&sjmidx="&rsjmidx&"&sjidx="&rsjidx&"');</script>"

%>
<%
Set Rs=Nothing
call dbClose()
%>




