<%@ CodePage="65001" Language="VBScript" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage = "65001"
Response.CharSet = "utf-8"
%>

<!-- DB / 쿠키 --> 
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
' ====================================================================================================
'  [TNG_WMS_Create.asp]
'  - WMS 출하 생성 전용 파일
'  - sjidx 1건 기준으로 META/DETAIL 생성
'  - 기존 출하가 있으면 자동 삭제 후 재생성 (항상 최신 상태 유지)
'  - RULE_CORE → wms_type 결정
'  - 도장출고일(paint_ship_dt), 출고일(actual_ship_dt) 자동 반영
'
' ====================================================================================================

' -----------------------------------------------------------------------------
' 0. DB OPEN
' -----------------------------------------------------------------------------
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")

rsjidx = Request("sjidx")

SQL = "select COUNT(sjidx) as cnt from tk_wms_meta where sjidx ='" & rsjidx & "'"
Response.Write "-- CHECK OLD META SQL<br>" & SQL & "<br><br>"
Rs.Open SQL, Dbcon

cnt = ""
If Not (Rs.BOF Or Rs.EOF) Then sjidxcnt = Rs(0)


Rs.Close

SQL = "select qtyidx from tng_sjaSub where sjidx='" & rsjidx & "'"
Response.Write "-- CHECK OLD META SQL<br>" & SQL & "<br><br>"
Rs.Open SQL, Dbcon

qtyidx = ""
If Not (Rs.BOF Or Rs.EOF) Then qtyidx = Rs(0)
Rs.Close

'response.write "qtyidx : " &qtyidx& "<br>"
'response.end
' -----------------------------------------------------------------------------
' 1. 필수 파라미터 sjidx 체크
' -----------------------------------------------------------------------------
sjidx = Trim(Request("sjidx"))

If sjidx = "" Then
    Response.Write "ERR: sjidx 없음"
    Response.End
End If

'Response.Write "▶ PARAM sjidx = " & sjidx & "<br><br>"

'response.end
' -----------------------------------------------------------------------------
' 2. 기존 WMS 출하 삭제 (중복 방지)
'    - 같은 sjidx로 여러 번 생성하지 않도록 최신 1건만 남기고 제거
'    - 출하 수정 개념이 없기 때문에 “삭제 후 재생성”이 가장 안전함
' -----------------------------------------------------------------------------
SQL = "SELECT TOP 1 wms_idx FROM tk_wms_meta WHERE company_id=1 AND sjidx='" & sjidx & "' ORDER BY wms_idx DESC"
Response.Write "-- CHECK OLD META SQL<br>" & SQL & "<br><br>"
Rs.Open SQL, Dbcon

existing_wms_idx = ""
If Not (Rs.BOF Or Rs.EOF) Then existing_wms_idx = Rs(0)
Rs.Close

If existing_wms_idx <> "" Then

    ' DETAIL 삭제
    SQL = "DELETE FROM tk_wms_detail WHERE wms_idx='" & existing_wms_idx & "'"
    Response.Write "-- DELETE OLD DETAIL SQL<br>" & SQL & "<br><br>"
    Dbcon.Execute(SQL)

    ' META 삭제
    SQL = "DELETE FROM tk_wms_meta WHERE wms_idx='" & existing_wms_idx & "'"
    Response.Write "-- DELETE OLD META SQL<br>" & SQL & "<br><br>"
    Dbcon.Execute(SQL)

End If

' -----------------------------------------------------------------------------
' 3. 수주헤더 + 고객정보 로드
'    - WMS META 필드 대부분 이 값으로 구성됨
' -----------------------------------------------------------------------------
SQL = ""
SQL = SQL & "SELECT A.sjidx, A.sjcidx, A.cgtype, A.cgaddr,A.cgset, "
SQL = SQL & "       A.cgdate, A.djcgdate, A.suju_kyun_status, "
SQL = SQL & "       C.cname, C.ctel, C.caddr1 "
SQL = SQL & "FROM TNG_SJA A "
SQL = SQL & "JOIN tk_customer C ON A.sjcidx = C.cidx "
SQL = SQL & "WHERE A.sjidx='" & sjidx & "'"

Response.Write "-- SJA + CUSTOMER SQL<br>" & SQL & "<br><br>"

Rs.Open SQL, Dbcon
If Rs.EOF Then
    Response.Write "ERR: 수주 없음"
    Response.End
End If

sjcidx      = Rs("sjcidx")          ' 출하 META.cidx
cgtype      = Rs("cgtype")          ' RULE_CORE 판단값
cgaddr      = Rs("cgaddr")          ' 사업장 주소
cgset       = Rs("cgset")           ' 입금후출고 0: O 1: X
cgdate      = Rs("cgdate")          ' 출고 예정/실제 출고일
djcgdate    = Rs("djcgdate")        ' 도장 출고일
suju_status = Rs("suju_kyun_status")' 0: 정식수주 / 1: 견적
recv_name   = Rs("cname")
recv_tel    = Rs("ctel")
recv_addr1  = Rs("caddr1")

Rs.Close

Response.Write "-- LOADED HEAD: cgtype=" & cgtype & ", suju_status=" & suju_status & "<br><br>"

' 견적(임시) 상태는 WMS 생성 불가
If suju_status <> 0 Then
    Response.Write "견적은 WMS 생성 안함"
    Response.End
End If

' -----------------------------------------------------------------------------
' 4. RULE_CORE → wms_type 자동 결정
'    - cgtype = RULE_CORE.priority 매칭
'    - 해당 row 의 rule_id 를 가져와 wms_type 에 저장
' -----------------------------------------------------------------------------

SQL = ""
SQL = SQL & "SELECT TOP 1 rule_id, rule_name "
SQL = SQL & "FROM tk_rule_core "
SQL = SQL & "WHERE rule_group='WMS_TYPE' "
SQL = SQL & "  AND active=1 "
SQL = SQL & "  AND priority = " & cgtype     ' ★ 핵심! cgtype = priority 매칭 ★ "
SQL = SQL & "ORDER BY priority ASC"

Response.Write "-- RULE SQL<br>" & SQL & "<br><br>"

Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
    wms_type = Rs("rule_id")    ' ★ rule_id 를 WMS_TYPE 으로 저장 ★
    rule_name = Rs("rule_name")
End If

Rs.Close

Response.Write "-- RESULT wms_type(rule_id) = " & wms_type & " / " & rule_name & "<br><br>"


' -----------------------------------------------------------------------------
' 5. 출발지(sender_id=2) 고정 로드
' -----------------------------------------------------------------------------
SQL = "SELECT sender_name, sender_tel, sender_addr, sender_addr1 FROM tk_wms_sender WHERE sender_id=2"
Response.Write "-- SENDER SQL<br>" & SQL & "<br><br>"

Rs.Open SQL, Dbcon
If Rs.EOF Then
    sender_name  = "태광도어 2공장"
    sender_tel   = ""
    sender_addr  = ""
    sender_addr1 = ""
Else
    sender_name  = Rs("sender_name")
    sender_tel   = Rs("sender_tel")
    sender_addr  = Rs("sender_addr")
    sender_addr1 = Rs("sender_addr1")
End If
Rs.Close

' -----------------------------------------------------------------------------
' 6. WMS NO 생성 (오늘날짜 + 4자리 일련번호)
' -----------------------------------------------------------------------------
ymd = Replace(Date(), "-", "")
prefix = "WMS" & ymd & "-"

SQL = "SELECT MAX(wms_no) FROM tk_wms_meta WHERE company_id=1 AND wms_no LIKE '" & prefix & "%'"
Response.Write "-- WMS NO GEN SQL<br>" & SQL & "<br><br>"

Rs.Open SQL, Dbcon
last_no = ""
If Not Rs.EOF Then If Not IsNull(Rs(0)) Then last_no = Rs(0)
Rs.Close

seq = 1
If last_no <> "" Then
    num = Mid(last_no, Len(prefix) + 1)
    seq = CInt(num) + 1
End If

seq_str = Right("0000" & seq, 4)
wms_no  = prefix & seq_str

Response.Write "-- NEW wms_no = " & wms_no & "<br><br>"
if wms_type="" then
    wms_type=1
end if
' -----------------------------------------------------------------------------
' 7. META INSERT
'    - 출하 문서 헤더 생성
'    - 테이블 구조(tk_wms_meta) 1:1 그대로 맞춤
' -----------------------------------------------------------------------------
SQL = ""
SQL = SQL & "INSERT INTO tk_wms_meta ( "
SQL = SQL & " company_id, wms_no, cidx, sjidx, wms_type, "
SQL = SQL & " planned_ship_dt, actual_ship_dt, paint_ship_dt, "
SQL = SQL & " sender_name, sender_tel, sender_addr, sender_addr1, "
SQL = SQL & " recv_name, recv_tel, recv_addr, recv_addr1, "
SQL = SQL & " cost_yn, prepay_yn, status, reg_user, upd_user "
SQL = SQL & ") VALUES ( "
SQL = SQL & " 1, "
SQL = SQL & " '" & wms_no & "', "
SQL = SQL & " '" & sjcidx & "', "
SQL = SQL & " '" & sjidx & "', "
SQL = SQL & " '" & wms_type & "', "
SQL = SQL & " '" & cgdate & "', "
SQL = SQL & " '" & cgdate & "', "
SQL = SQL & " '" & djcgdate & "', "
SQL = SQL & " '" & sender_name & "', "
SQL = SQL & " '" & sender_tel & "', "
SQL = SQL & " '" & sender_addr & "', "
SQL = SQL & " '" & sender_addr1 & "', "
SQL = SQL & " '" & recv_name & "', "
SQL = SQL & " '" & recv_tel & "', "
SQL = SQL & " '" & cgaddr & "', "
SQL = SQL & " '" & recv_addr1 & "', "
SQL = SQL & " 0, 1, 0, "
SQL = SQL & " '" & C_midx & "', '" & C_midx & "' "
SQL = SQL & ")"

Response.Write "-- META INSERT SQL<br>" & SQL & "<br><br>"
Dbcon.Execute(SQL)

' -----------------------------------------------------------------------------
' 8. wms_idx 재조회
' -----------------------------------------------------------------------------
SQL = "SELECT MAX(wms_idx) FROM tk_wms_meta WHERE company_id=1 AND wms_no='" & wms_no & "'"
Response.Write "-- FETCH wms_idx SQL<br>" & SQL & "<br><br>"

Rs.Open SQL, Dbcon
If Not Rs.EOF Then wms_idx = Rs(0)
Rs.Close

Response.Write "-- NEW wms_idx = " & wms_idx & "<br><br>"

' -----------------------------------------------------------------------------
' 9. DETAIL INSERT
'    - tk_framekSub = 바, 보강, 프레임 구성 단위
'    - gls=0 만 추출 → 도어/유리는 제외
'
'    확장필드:
'     - fixauto_type  : 1=FIX, 2=AUTO
'     - is_door       : gls=1/2 → 도어(1), 나머지(0)
'     - bfgroup       : 나중에 "세트그룹 자동분류" 여기 넣음
' -----------------------------------------------------------------------------
SQL = ""
SQL = SQL & "INSERT INTO tk_wms_detail ( "
SQL = SQL & " wms_idx, company_id, sjidx, sjsidx, fkidx, fksidx, bfidx, "
SQL = SQL & " baname, blength, quan, "
SQL = SQL & " xsize, ysize, status, bfimg, "
SQL = SQL & " material_color, glass_type, fixauto_type, paint_yn, protect_type, is_door, bfgroup "
SQL = SQL & ") "
SQL = SQL & "SELECT "
SQL = SQL & wms_idx & ", "
SQL = SQL & "1, "
SQL = SQL & "F.sjidx, "
SQL = SQL & "F.sjsidx, "
SQL = SQL & "F.fkidx, "
SQL = SQL & "S.fksidx, "
SQL = SQL & "S.bfidx, "
SQL = SQL & "CASE WHEN B.set_name_FIX<>'' THEN B.set_name_FIX "
SQL = SQL & "     WHEN B.set_name_AUTO<>'' THEN B.set_name_AUTO ELSE '자재없음' END, "
SQL = SQL & "S.blength, "
SQL = SQL & "ISNULL(A.quan,1), "
SQL = SQL & "ISNULL(B.xsize,0), "
SQL = SQL & "ISNULL(B.ysize,0), "
SQL = SQL & "1, "
SQL = SQL & "CASE WHEN B.bfimg1<>'' THEN B.bfimg1 WHEN B.bfimg2<>'' THEN B.bfimg2 ELSE B.bfimg3 END, "
SQL = SQL & "NULL, "                              ' material_color (추후)
SQL = SQL & "NULL, "                              ' glass_type (추후)
SQL = SQL & "ISNULL(S.WHICHI_AUTO, S.WHICHI_FIX), "     ' fixauto_type
SQL = SQL & "CASE WHEN ISNULL(A.pidx,0) IN (306,1017,1095,1193) THEN 0 ELSE 1 END, "  ' ★ paint_yn ★
SQL = SQL & "NULL, "                              ' protect_type
SQL = SQL & "CASE WHEN S.gls IN(1,2) THEN 1 ELSE 0 END, "  ' is_door (항상 0 나옴)
SQL = SQL & "CASE "
SQL = SQL & "    WHEN S.WHICHI_AUTO IN (1,2) THEN N'박스세트' "
SQL = SQL & "    WHEN S.WHICHI_AUTO IN (8,9,24) THEN N'픽스하바세트' "
SQL = SQL & "    ELSE NULL "
SQL = SQL & "END "
SQL = SQL & "FROM tk_framekSub S "
SQL = SQL & "JOIN tk_framek F ON S.fkidx = F.fkidx "
SQL = SQL & "JOIN tng_sjaSub A ON F.sjsidx = A.sjsidx "
SQL = SQL & "LEFT JOIN tk_barasiF B ON S.bfidx = B.bfidx "
SQL = SQL & "WHERE S.gls=0 AND F.sjidx='" & sjidx & "'"

Response.Write "-- DETAIL INSERT SQL<br>" & SQL & "<br><br>"
Dbcon.Execute(SQL)

' -----------------------------------------------------------------------------
' 10. 도장번호 업데이트
' -----------------------------------------------------------------------------
If qtyidx <> 5 Then
    Dim SQL, Rs, djDate, prefix

    ' === 1) 해당 sjidx의 도장일자 + sjsidx 목록 조회 ===
    SQL = "SELECT A.djcgdate, B.sjsidx, C.pidx " & _
        "FROM TNG_SJA A " & _
        "LEFT JOIN tng_sjasub B ON A.sjidx = B.sjidx " & _
        "LEFT JOIN tk_paint AS C ON B.pidx = C.pidx " & _
        "WHERE A.sjidx=" & CLng(sjidx) & " AND (B.qtyidx <> 5 OR (C.pidx IS NULL or C.pidx=0))"

    'response.write "SQL : " &SQL& "<br>"
    'response.end
    Rs.Open SQL, Dbcon, 1, 1

    If Rs.EOF Then 
        Response.Write "<script>alert('도장 생성 대상이 없습니다.'); history.back();</script>"
        Response.End
    End If   ' 상세가 없으면 종료

    ' === 2) 날짜 prefix 추출 ===
    djDate = Rs("djcgdate")
    If IsNull(djDate) Then 
        Response.Write "<script>alert('도장일자가 없습니다. 날짜를 먼저 저장하세요.'); history.back();</script>"
        Response.End
    End If
    prefix = Right("0" & Day(CDate(djDate)), 2)

    ' === 3) sjsidx 반복하면서 도장번호 생성 ===
    Do Until Rs.EOF

        sjs = CLng(Rs("sjsidx"))
        pidx = Rs("pidx")

        'response.write "pidx : " &pidx& "<br>"
        
      
        if Not IsNull(pidx) And pidx <> 0 Then
          'response.write "들어옴 : " &pidx& "<br>"
            ' seq 조회
            ' === ★ 수정된 seq 조회 (날짜 prefix 조건 추가) ===
            Dim Rs2, nextSeq, djnum
            Set Rs2 = Server.CreateObject("ADODB.Recordset")
            SQL2 = "SELECT MAX(CAST(SUBSTRING(djnum, CHARINDEX('-', djnum) + 1, 10) AS INT)) AS maxSeq " & _
            "FROM tk_wms_djnum WHERE djnum LIKE '" & prefix & "-%'"
            Rs2.Open SQL2, Dbcon, 1, 1

            If Not IsNull(Rs2("maxSeq")) Then nextSeq = CLng(Rs2("maxSeq")) + 1 Else nextSeq = 1
            Rs2.Close : Set Rs2 = Nothing

            djnum = prefix & "-" & Right("00" & nextSeq, 2)

            ' === INSERT 실행 ===
            SQL3 = "INSERT INTO tk_wms_djnum (sjidx, sjsidx, djnum) VALUES (" & CLng(sjidx) & ", " & sjs & ", '" & djnum & "')"
            Dbcon.Execute SQL3
        End If
        Rs.MoveNext
    Loop
    Rs.Close : Set Rs = Nothing
End If

'response.end
' -----------------------------------------------------------------------------
' 11. 완료 알림
' -----------------------------------------------------------------------------
Response.Write "<script>alert('WMS 생성 완료'); history.back();</script>"

call dbClose()
%>
</head>
<body>
</body>
</html>
