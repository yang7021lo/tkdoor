<%
'===========================================
'  WMS MODULE — 메타/디테일/집계 통합 모듈
'  작성자: 태광 MES/WMS
'===========================================

'-------------------------------------------
' 🔹 Function 1: CreateWMSMeta
'    WMS 메타 생성 (출하서 헤더)
'
'   반환값: 새로 생성된 wms_idx
'-------------------------------------------
Function CreateWMSMeta(sjidx, rdsdate, sender_name, sender_tel, sender_addr, recv_name, recv_tel, recv_addr, cost_yn, prepay, C_midx)

    Dim SQL, prepay_flag, new_wms_idx, Rs

    If prepay > 0 Then
        prepay_flag = "1"
    Else
        prepay_flag = "0"
    End If

    ' INSERT
    SQL = ""
    SQL = SQL & "INSERT INTO tk_wms_meta ("
    SQL = SQL & "  company_id, sjidx, sjsidx, wms_type, carrier_id, driver_id, warehouse_idx, "
    SQL = SQL & "  planned_ship_dt, actual_ship_dt, "
    SQL = SQL & "  sender_name, sender_tel, sender_addr, "
    SQL = SQL & "  recv_name, recv_tel, recv_addr, "
    SQL = SQL & "  cost_yn, prepay_yn, total_quan, total_weight, status, reg_user"
    SQL = SQL & ") VALUES ("
    SQL = SQL & " '1',"                                 ' company_id
    SQL = SQL & " '" & sjidx & "',"                     ' sjidx
    SQL = SQL & " NULL,"                                ' sjsidx
    SQL = SQL & " '1',"                                 ' wms_type 기본값(택배=1)
    SQL = SQL & " NULL, NULL, NULL,"                    ' carrier_id, driver_id, warehouse_idx
    SQL = SQL & " '" & rdsdate & "',"                   ' planned_ship
    SQL = SQL & " '" & rdsdate & "',"                   ' actual_ship
    SQL = SQL & " '" & sender_name & "',"               ' sender_name
    SQL = SQL & " '" & sender_tel  & "',"               ' sender_tel
    SQL = SQL & " '" & sender_addr & "',"               ' sender_addr
    SQL = SQL & " '" & recv_name  & "',"                ' recv_name
    SQL = SQL & " '" & recv_tel   & "',"                ' recv_tel
    SQL = SQL & " '" & recv_addr  & "',"                ' recv_addr
    SQL = SQL & " '" & cost_yn    & "',"                ' cost_yn
    SQL = SQL & " '" & prepay_flag & "',"               ' prepay_yn
    SQL = SQL & " '0',"                                 ' total_quan (추후 업데이트)
    SQL = SQL & " NULL,"                                ' total_weight
    SQL = SQL & " '0',"                                 ' status=대기
    SQL = SQL & " '" & C_midx & "'"                     ' reg_user
    SQL = SQL & ")"

    Dbcon.Execute SQL

    ' 최근 생성된 wms_idx 반환
    SQL = "SELECT TOP 1 wms_idx FROM tk_wms_meta WHERE sjidx='" & sjidx & "' ORDER BY wms_idx DESC"

    Set Rs = Dbcon.Execute(SQL)
    If Not (Rs.EOF Or Rs.BOF) Then
        new_wms_idx = Rs("wms_idx")
    End If
    Rs.Close
    Set Rs = Nothing

    CreateWMSMeta = new_wms_idx

End Function



'-------------------------------------------
' 🔹 Function 2: InsertWMSDetail
'    프레임 자재 → WMS 디테일 삽입
'
'   (기본: gls=0 자재만 처리)
'-------------------------------------------
Function InsertWMSDetail(sjidx, wms_idx)

    Dim SQL
    SQL = ""
    SQL = SQL & "INSERT INTO tk_wms_detail ("
    SQL = SQL & "  company_id, wms_idx, sjidx, sjsidx, fkidx, fksidx, "
    SQL = SQL & "  bfidx, baname, blength, xsize, ysize, quan, status, memo"
    SQL = SQL & ") "
    SQL = SQL & "SELECT "
    SQL = SQL & "  '1',"
    SQL = SQL & "  '" & wms_idx & "',"
    SQL = SQL & "  A.sjidx,"
    SQL = SQL & "  A.sjsidx,"
    SQL = SQL & "  B.fkidx,"
    SQL = SQL & "  B.fksidx,"
    SQL = SQL & "  B.bfidx,"

    SQL = SQL & "  CASE "
    SQL = SQL & "      WHEN B.WHICHI_AUTO <> 0 THEN C.set_name_AUTO "
    SQL = SQL & "      WHEN B.WHICHI_FIX  <> 0 THEN C.set_name_FIX  "
    SQL = SQL & "  END AS baname,"

    SQL = SQL & "  B.blength,"
    SQL = SQL & "  B.xsize,"
    SQL = SQL & "  B.ysize,"
    SQL = SQL & "  '1' AS quan,"
    SQL = SQL & "  '1' AS status,"

    SQL = SQL & "  CONCAT(ISNULL(C.bfimg1,''),'|',ISNULL(C.bfimg2,''),'|',ISNULL(C.bfimg3,''),'|',ISNULL(C.bfimg4,'')) AS memo "

    SQL = SQL & "FROM tk_framek A "
    SQL = SQL & "JOIN tk_framekSub B ON A.fkidx = B.fkidx "
    SQL = SQL & "LEFT JOIN tk_barasiF C ON B.bfidx = C.bfidx "
    SQL = SQL & "WHERE A.sjidx='" & sjidx & "' "
    SQL = SQL & "  AND B.gls='0' "
    SQL = SQL & "  AND B.bfidx <> '0' "

    Dbcon.Execute SQL

End Function



'-------------------------------------------
' 🔹 Function 3: UpdateWMSMetaSummary
'    WMS 메타 → 수량/중량 집계
'-------------------------------------------
Function UpdateWMSMetaSummary(wms_idx, C_midx)

    Dim SQL

    SQL = ""
    SQL = SQL & "UPDATE M "
    SQL = SQL & "SET M.total_quan = X.cnt, "
    SQL = SQL & "    M.total_weight = NULL, "
    SQL = SQL & "    M.upd_user = '" & C_midx & "', "
    SQL = SQL & "    M.upd_date = GETDATE() "
    SQL = SQL & "FROM tk_wms_meta M "
    SQL = SQL & "JOIN ("
    SQL = SQL & "  SELECT company_id, wms_idx, COUNT(*) AS cnt "
    SQL = SQL & "  FROM tk_wms_detail "
    SQL = SQL & "  WHERE company_id='1' AND wms_idx='" & wms_idx & "' "
    SQL = SQL & "  GROUP BY company_id, wms_idx"
    SQL = SQL & ") X ON X.company_id=M.company_id AND X.wms_idx=M.wms_idx"

    Dbcon.Execute SQL

End Function

%>
