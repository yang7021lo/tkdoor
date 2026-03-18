<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
' <%
' Session.CodePage="65001"
' Option Explicit
' Response.CharSet="utf-8"
' %>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->

<%
call dbOpen()

Set Rs2=Server.CreateObject("ADODB.Recordset")
Set Rs3=Server.CreateObject("ADODB.Recordset")
Set RsH=Server.CreateObject("ADODB.Recordset")


'---------------------------------
' DB 연결 (직접 연결)
'---------------------------------
Dim cn : Set cn = Server.CreateObject("ADODB.Connection")
cn.Open "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;User ID=tkd001;Password=tkd2713!;"
' cn.Open "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com; Initial Catalog=tkdoor2010;user ID=tkdoor2010;password=tkd2614@!"



%>



<%
'---------------------------------
' 파라미터 변수
'---------------------------------
Dim sjidx : sjidx = Trim(Request("sjidx"))
%>


<%
'---------------------------------
' 기본 정보 조회 A-1 SQL 구문 (제품 정보 제외 -> 하단에 위치함)
'---------------------------------
Dim rsH, sqlH
sqlH = ""
sqlH = sqlH & "SELECT "
sqlH = sqlH & "  A.sjdate, "
sqlH = sqlH & "  A.sjnum, "
sqlH = sqlH & "  CONVERT(VARCHAR(10), A.cgdate,121) AS cgdate, "
sqlH = sqlH & "  A.cgaddr, "
sqlH = sqlH & "  A.memo, "
sqlH = sqlH & "  A.tsprice, "
sqlH = sqlH & "  A.trate, "
sqlH = sqlH & "  A.tdisprice, "
sqlH = sqlH & "  A.tfprice, "
sqlH = sqlH & "  A.taxprice, "
sqlH = sqlH & "  A.tzprice, "
sqlH = sqlH & "  C.cname, "
sqlH = sqlH & "  C.cnumber, "
sqlH = sqlH & "  C.ctel, "
sqlH = sqlH & "  C.cfax, "
sqlH = sqlH & "  C.cceo, "
sqlH = sqlH & "  C.ctkidx, "
sqlH = sqlH & "  T.cname AS ctkname, "
sqlH = sqlH & "  T.cnumber AS ctkbizNo, "
sqlH = sqlH & "  T.ctel AS ctktel, "
sqlH = sqlH & "  T.accnumb AS ctkaccnumb, "
sqlH = sqlH & "  T.bankname AS ctkaccbankname, "
sqlH = sqlH & "  T.accname AS ctkaccname, "
sqlH = sqlH & "  ISNULL(T.caddr1,'') + ' ' + ISNULL(T.caddr2,'') AS ctkadr, "
sqlH = sqlH & "  ISNULL(C.caddr1,'') + ' ' + ISNULL(C.caddr2,'') AS caddress, "
sqlH = sqlH & "  A.meidx, "
sqlH = sqlH & "  M.mname "
sqlH = sqlH & "FROM tng_sja A "
sqlH = sqlH & "LEFT JOIN tk_customer C ON A.sjcidx = C.cidx "
sqlH = sqlH & "LEFT JOIN tk_customer T ON C.ctkidx = T.cidx "
sqlH = sqlH & "LEFT JOIN tk_member M ON A.meidx = M.midx "
sqlH = sqlH & "WHERE A.sjidx = '" & Replace(sjidx, "'", "''") & "'"
' response.write(sqlH)&"<br>"
RsH.open sqlH, dbcon 

' Set rsH = cn.Execute(sqlH)
' If (rsH.BOF And rsH.EOF) Then
'   Response.Write "{""success"":false,""error"":""not found""}"
'   rsH.Close: cn.Close
'   Response.End
' End If

Dim h_sjdate, h_sjnum, h_cgdate, h_cgaddr, h_memo, h_tsprice, h_trate, h_tdisprice, h_tfprice, h_taxprice, h_tzprice
Dim h_cname, h_cnumber, h_ctel, h_cfax, h_cceo, h_caddress, h_mname
Dim h_ctkidx, h_ctkname, h_ctkadr, h_ctkbizNo, h_ctktel, h_ctkaccbankname, h_ctkaccname, h_ctkaccnumb

h_sjdate    = rsH("sjdate") 
h_sjnum     = rsH("sjnum")
h_cgdate    = rsH("cgdate")
h_cgaddr    = rsH("cgaddr")
h_memo = rsH("memo")



h_tsprice  = rsH("tsprice") 
h_trate    = rsH("trate")
h_tdisprice = rsH("tdisprice")
h_tfprice  = rsH("tfprice")
h_taxprice = rsH("taxprice")
h_tzprice = Int( (rsH("tzprice") + 999) / 1000 ) * 1000


' NULL 처리
If IsNull(h_tsprice) Then h_tsprice = 0
If IsNull(h_trate) Then h_trate = 0
If IsNull(h_tdisprice) Then h_tdisprice = 0
If IsNull(h_tfprice) Then h_tfprice = 0
If IsNull(h_taxprice) Then h_taxprice = 0
If IsNull(h_tzprice) Then h_tzprice = 0

h_cname     = rsH("cname")
h_cnumber   = rsH("cnumber")
h_ctel      = rsH("ctel")
h_cfax      = rsH("cfax")
h_cceo      = rsH("cceo")
h_caddress  = rsH("caddress")

h_ctkidx = rsH("ctkidx")
h_ctkname = rsH("ctkname")
h_ctkadr = rsH("ctkadr")
h_ctkbizNo = rsH("ctkbizNo")
h_ctktel = rsH("ctktel")

h_ctkaccbankname = rsH("ctkaccbankname")
h_ctkaccname = rsH("ctkaccname")
h_ctkaccnumb = rsH("ctkaccnumb")

h_mname  = rsH("mname")
If h_ctkidx="1" then 
    ctkidx_text="태광도어"
Elseif h_ctkidx="2" then 
    ctkidx_text="티엔지단열프레임"
Elseif h_ctkidx="3" then
    ctkidx_text="태광인텍"
End If 
rsH.Close
%>


<!doctype html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <title>간이견적서</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="/documents/simpleOrder/assets/css/index.css" rel="stylesheet">

</head>

<body class="d-block">
    <input type="hidden" id="sjidx" value="<%=sjidx%>">
    <div class="print-sheet">

        <div class="container invoice">
            <div class="header">
                <div class="logo">견적서</div>
                <div class="logo">
                    <img src="/documents/outsideOrder/logo.svg" alt="{issuer.name} 로고" style="height:40px;">
                </div>
            </div>

<!-- 기본정보란 A-1 SQL 구문 사용 구간 -->
   <div class="details mt-2">
                <div class="company-info">
                    <img src="/documents/outsideOrder/assets/tk_seal.png" alt="회사 직인" class="stamp">
                    <strong><%=ctkidx_text%></strong><br>
                    <%=h_ctkadr%><br>
                    사업자번호: <%=h_ctkbizNo%><br>
                    대표: 김희일
                </div>
                <div></div>
                <div class="company-contact">
                    <strong><%=h_cname%></strong><br>
                    <%=h_caddress%><br>
                    <%=h_cnumber%>
                </div>
            </div>

            <div class="line"></div>
            <div class="details">
                <div style="width:15%;"><strong>견적번호</strong><br><%=h_sjnum%></div>
                <div style="width:15%;"><strong>견적일</strong><br><%=h_cgdate%></div>
                <div><strong>시공장소</strong><br><%=h_cgaddr%></div>
            </div>
            <div class="line"></div>

<!-- 제품정보란 B-1 코드 - 제품명 중복 시, 축약 기능 수행 구간 -->            
<%
' ============== 간단 축약 함수 ==============
Function CollapseTokens(raw)
    Dim s, parts, uniq(), fold(), i, j, n, t, found, r

    s = raw & ""              ' Null 방지 + 문자열 강제
    s = Replace(s, " ", "")   ' 공백 제거

    If InStr(s, "+") = 0 Then
        CollapseTokens = s
        Exit Function
    End If

    parts = Split(s, "+")
    ReDim uniq(-1)
    ReDim fold(-1)

    For i = 0 To UBound(parts)
        t = CStr(parts(i))
        If t <> "" Then
            found = -1
            For j = 0 To UBound(uniq)
                If uniq(j) = t Then
                    found = j
                    Exit For
                End If
            Next
            If found >= 0 Then
                fold(found) = True      ' 앞의 첫 항목에만 .. 표시하도록 마킹
            Else
                n = UBound(uniq) + 1
                ReDim Preserve uniq(n)
                ReDim Preserve fold(n)
                uniq(n)  = t
                fold(n)  = False
            End If
        End If
    Next

    r = ""
    For i = 0 To UBound(uniq)
        t = uniq(i)
        If fold(i) Then t = t & ".."
        If i = 0 Then r = t Else r = r & "+" & t
    Next

    CollapseTokens = r
End Function
%>

<table class="tbl dense mono my-2 w-100" style="border-collapse:collapse; table-layout:fixed;">
    <colgroup>
        <col class="c-no">
        <col class="c-name">
        <col class="c-measure">
        <col class="c-loc">
        <col class="c-mat">
        <col class="c-unit">
        <col class="c-qty">
        <col class="c-supply">
    </colgroup>
    <thead>
        <tr>
            <th>#</th>
            <th>제품명</th>
            <th>검측</th>
            <th>위치</th>
            <th>재질 및 도장</th>
            <th>단가</th>
            <th>수량</th>
            <th>할인금액</th>
            <th>공급가</th>
        </tr>
    </thead>
    <tbody>


<%
'---------------------------------
' 제품정보 조회 B-2 SQL 구문 (제품정보 LOOP 구간)
'---------------------------------
' cdlevel 가져오기 (도어 할인 계산용)
Dim cdlevel
cdlevel = 1 ' 기본값
Dim rsCdlevel
Set rsCdlevel = cn.Execute("SELECT b.cdlevel FROM TNG_SJA a JOIN tk_customer b ON b.cidx = a.sjcidx WHERE a.sjidx = '" & Replace(sjidx, "'", "''") & "'")
If Not (rsCdlevel.BOF Or rsCdlevel.EOF) Then
    If Not IsNull(rsCdlevel(0)) Then
        cdlevel = rsCdlevel(0)
    End If
End If
rsCdlevel.Close
Set rsCdlevel = Nothing

Dim cmdI, rsI, sqlI, seq_pro
Set cmdI = Server.CreateObject("ADODB.Command")
Set cmdI.ActiveConnection = cn
cmdI.CommandType = 1

sqlI = _
"SELECT DISTINCT " & _
"  A.sjsidx AS idx, " & _
"  A.framename AS name, " & _
"  ISNULL(A.asub_wichi1,'') AS loc1, " & _
"  ISNULL(A.asub_wichi2,'') AS loc2, " & _
"  ISNULL(A.mwidth,0) AS measuredSizeW, " & _
"  ISNULL(A.mheight,0) AS measuredSizeH, " & _
"  ISNULL(G.qtyname,'') AS material, " & _
"  ISNULL(I.pname,'') AS coating, " & _
"  ISNULL(A.quan,0) AS quantity, " & _
"  ISNULL(A.fprice,0) AS fprice, " & _
"  ISNULL(A.sprice,0) AS sprice, " & _
"  ISNULL(A.taxrate,0) AS taxrate, " & _
"  ISNULL(A.disprice,0) AS disprice, " & _
"  ISNULL(FK.doors,'[]') AS doors, " & _
"  ISNULL(FRAME_DIS.frame_fprice_sum, 0) AS frame_fprice_sum, " & _
"  ISNULL(FRAME_DIS.frame_sjsprice_sum, 0) AS frame_sjsprice_sum " & _
"FROM tng_sjaSub A " & _
"LEFT JOIN tk_qty   C ON C.qtyidx = A.qtyidx " & _
"LEFT JOIN tk_qtyco G ON G.qtyno  = C.qtyno " & _
"LEFT JOIN tk_paint I ON I.pidx   = A.pidx " & _
"OUTER APPLY ( " & _
"  SELECT SUM(fprice) AS frame_fprice_sum, SUM(sjsprice) AS frame_sjsprice_sum " & _
"  FROM tk_framek " & _
"  WHERE sjsidx = A.sjsidx " & _
") FRAME_DIS " & _
"OUTER APPLY ( " & _
"  SELECT ( " & _
"    SELECT s.fksidx AS fksidx, s.door_w AS doorW, s.door_h AS doorH, " & _
"           s.doorsizechuga_price AS doorSizeChugaPrice, s.door_price AS doorPrice, " & _
"           s.goname AS goName, s.barNAME AS barName, s.doortype AS doorType, " & _
"           A.quan AS doorQuantity, " & _
"       ISNULL(s.door_disprice,0) AS doorDisprice, " & _
"       ISNULL(s.door_disrate,0)  AS doorDisrate, "  & _
"           CASE s.doortype WHEN 1 THEN N'좌도어' WHEN 2 THEN N'우도어' ELSE N'없음' END AS doorTypeText, " & _
"           k.doorchoice AS doorChoice, " & _
"           CASE k.doorchoice WHEN 1 THEN N'도어 포함가' WHEN 2 THEN N'도어 별도가' WHEN 3 THEN N'도어 제외가' ELSE N'선택되지 않음' END AS doorChoiceText " & _
"    FROM tk_framekSub s JOIN tk_framek k ON s.fkidx = k.fkidx " & _
"    WHERE k.sjsidx = A.sjsidx AND s.DOOR_W > 0 " & _
"    ORDER BY s.fksidx FOR JSON PATH " & _
"  ) AS doors " & _
") FK " & _
"WHERE A.astatus = '1' AND A.sjidx = ? " & _
"ORDER BY A.sjsidx;"



cmdI.CommandText = sqlI
cmdI.Parameters.Append cmdI.CreateParameter("@sjidx", 200, 1, 100, sjidx)
Set rsI = cmdI.Execute
Set Rs = cmdI.Execute
seq_pro = 1

' 총액 변수 초기화 (표시용 변수만 유지)

Do Until rsI.EOF

'---------------------------------
' SJA_SUB 당 LOOP 순회, 할인 적용된 가격 계산
'---------------------------------
Dim frame_fprice_sum, frame_sjsprice_sum, total_frame_price,disprice_item
Dim sjsidx_item, quan_item
Dim cdlevel_price
Dim  sqls, Rs2

sqls = _
"SELECT DISTINCT " & _
" A.sjsidx, a.sjb_idx, " & _
" F.sjb_type_name, " & _
" A.mwidth, A.mheight, " & _
" A.qtyidx, g.qtyname, " & _
" A.sjsprice, A.quan, " & _
" a.disrate, a.disprice, A.taxrate, A.sprice, A.fprice, A.midx, " & _
" D.mname, A.mwdate, A.meidx, E.mname AS me_name, A.mewdate, A.astatus, " & _
" F.sjb_type_no, a.framename, i.pname, a.door_price, " & _
" a.frame_price, a.frame_option_price, " & _
" j.sjcidx " & _
" FROM tng_sjaSub A " & _
" LEFT OUTER JOIN tng_sjb B ON A.sjb_idx = B.sjb_idx " & _
" LEFT OUTER JOIN tk_qty C ON A.qtyidx = C.qtyidx " & _
" JOIN tk_member D ON A.midx = D.midx " & _
" JOIN tk_member E ON A.meidx = E.midx " & _
" LEFT OUTER JOIN tng_sjbtype F ON B.sjb_type_no = F.sjb_type_no " & _
" LEFT OUTER JOIN tk_qtyco g ON C.qtyno = g.qtyno " & _
" LEFT OUTER JOIN tk_paint i ON A.pidx = i.pidx " & _
" LEFT OUTER JOIN TNG_SJA j ON A.sjidx = j.sjidx " & _
" WHERE A.sjidx <> '0' " & _
"   AND A.sjidx = '" & sjidx &"' " & _
"   AND A.astatus = '1' "
  Rs2.open sqls, dbcon ,1,1
  If Not (Rs2.BOF or Rs.EOF) Then
    Do while not Rs2.EOF
        sjsidx_item = Rs2("sjsidx")
        disprice_item = Rs2("disprice")
        frame_fprice_sum = Round(Rs2("fprice") / 1000, 0) * 1000

' response.write("disprice_item '"& disprice_item & "'")   

seq_pro = 1

' 총액 변수 초기화 (표시용 변수만 유지)    

' frame_fprice_sum = rsI("frame_fprice_sum")
frame_sjsprice_sum = rsI("frame_sjsprice_sum")
sjsidx_item = rsI("idx")
quan_item = rsI("quantity")
' disprice_item = rsI("disprice")


' NULL 처리
If IsNull(disprice_item) Then disprice_item = 0

' cdlevel_price 계산
Select Case cdlevel
    Case 1
        cdlevel_price = 0
    Case 2
        cdlevel_price = 10000
    Case 3
        cdlevel_price = -10000
    Case 4
        cdlevel_price = -20000
    Case 5
        cdlevel_price = -30000
    Case 6
        cdlevel_price = 10000
    Case Else
        cdlevel_price = 0
End Select

' 프레임 공급가 (할인 적용된 fprice)
total_frame_price = frame_fprice_sum
' response.write("total_frame_price = '" & total_frame_price & "' ")
' response.end
' 도어 공급가 계산 (tk_framekSub에서)
Dim door_supply_price_sum
door_supply_price_sum = 0

Dim rsDoor
Set rsDoor = cn.Execute("SELECT a.door_price, b.quan FROM tk_framekSub a JOIN tk_framek b ON a.fkidx = b.fkidx WHERE b.sjsidx='" & Replace(sjsidx_item, "'", "''") & "' AND a.door_w > 0")
Do While Not rsDoor.EOF
    Dim kDOOR_PRICE_item, quan_door_item, door_supply_price_item, total_kDOOR_PRICE_item
    kDOOR_PRICE_item = rsDoor("door_price")
    quan_door_item = rsDoor("quan")
    
    If IsNull(kDOOR_PRICE_item) Then kDOOR_PRICE_item = 0
    If IsNull(quan_door_item) Or quan_door_item = 0 Then quan_door_item = 1
    
    ' 도어 공급가 계산 (cdlevel_price는 이미 door_price에 반영되어 있으므로 별도 차감 안 함)
    If IsNumeric(kDOOR_PRICE_item) And CDbl(kDOOR_PRICE_item) > 0 Then
        door_supply_price_item = CDbl(kDOOR_PRICE_item)
        total_kDOOR_PRICE_item = door_supply_price_item * quan_door_item
        door_supply_price_sum = door_supply_price_sum + total_kDOOR_PRICE_item
    End If
    
    rsDoor.MoveNext
Loop
rsDoor.Close
Set rsDoor = Nothing






' 도어 공급가 (할인 적용된 공급가)
Dim total_door_price
total_door_price = door_supply_price_sum

' 프레임+도어 합계
Dim total_door_frame_price
total_door_frame_price = total_frame_price + total_door_price 

' 할인금액: TNG1_B.asp와 동일하게 tng_sjaSub의 disprice 사용
Dim total_disprice_item
total_disprice_item = disprice_item

' 단가 계산: tk_framek의 sjsprice 합계를 그대로 표시
Dim unitPrice
If Not IsNull(frame_sjsprice_sum) Then
    unitPrice = CLng(frame_sjsprice_sum)
Else
    unitPrice = 0
End If

' 프레임 단가 - 할인금액
sqlfprice = ""
sqlfprice = sqlfprice & "SELECT "
sqlfprice = sqlfprice & "  SUM(disprice) AS total_frame_disprice, "
sqlfprice = sqlfprice & "  SUM(sjsprice)   AS total_frame_sjsprice "
sqlfprice = sqlfprice & "FROM tk_framek "
sqlfprice = sqlfprice & "WHERE sjsidx = '" & Replace(sjsidx_item, "'", "''") & "'"

Set rsTotalDisprice = cn.Execute(sqlfprice)
If Not (rsTotalDisprice.BOF Or rsTotalDisprice.EOF) Then
    If Not IsNull(rsTotalDisprice("total_frame_disprice")) Then
        sum_frame_disprice_all = CDbl(rsTotalDisprice("total_frame_disprice"))
    End If
    If Not IsNull(rsTotalDisprice("total_frame_sjsprice")) Then
        total_frame_fprice_all = CDbl(rsTotalDisprice("total_frame_sjsprice"))
    End If
End If

total_frame_fprice_all = (total_frame_fprice_all  * quan_item ) - sum_frame_disprice_all

total_frame_disprice_all = total_frame_disprice_all + sum_frame_disprice_all

frame_sjsprice_sum  = frame_sjsprice_sum + kDOOR_PRICE_item 






rsTotalDisprice.Close
Set rsTotalDisprice = Nothing
%>
        <tr class="table-body" 
            data-doors='<%=Server.HTMLEncode(rsI("doors"))%>'
            data-frame-price="<%=total_frame_price%>"
            data-door-price="<%=total_door_price%>"
            data-total-price="<%=total_door_frame_price%>"
            data-disprice="<%=total_disprice_item%>"
            data-cdlevel="<%=cdlevel%>"
            data-cdlevel-price="<%=cdlevel_price%>">
            <td><%=seq_pro%></td>
            <td><%=CollapseTokens(rsI("name"))%></td>
            <td><%=rsI("measuredSizeW")%> × <%=rsI("measuredSizeH")%></td>
            <td><%=rsI("loc1")%><%=rsI("loc2")%></td>
            <td><%=rsI("material")%> \ <%=rsI("coating")%></td>
            <td><%=FormatNumber(unitPrice,0)%></td>
            <td><%=rsI("quantity")%>개</td>
            <td class="text-end"><%=FormatNumber(sum_frame_disprice_all,0)%></td>
            <td class="text-end"><%=FormatNumber(total_frame_fprice_all,0)%></td>
        </tr>
<%
    rsI.MoveNext
    seq_pro = seq_pro + 1   
    Rs2.MoveNext 
  Loop
    END IF
  rs2.close
Loop

' Rs2.close : SET Rs2 = Nothing
rsI.Close : Set rsI = Nothing
Set cmdI = Nothing

' ============================================
' 전체 할인금액 계산: TNG1_B.asp와 동일하게 프레임 할인 + 도어 할인 합계
' TNG1_B_table_pop.asp의 disprice 합계 + TNG1_B_table_pop_door.asp의 kDOOR_DISPRICE 합계
' ============================================



' 2) 모든 도어 할인금액 합계 (TNG1_B_table_pop_door.asp와 동일한 계산)
sqlTotalDisprice = "SELECT a.door_price, b.quan, a.door_disprice, a.door_disrate "
sqlTotalDisprice = sqlTotalDisprice & "FROM tk_framekSub a "
sqlTotalDisprice = sqlTotalDisprice & "JOIN tk_framek b ON a.fkidx = b.fkidx "
sqlTotalDisprice = sqlTotalDisprice & "WHERE EXISTS (SELECT 1 FROM tng_sjaSub WHERE tng_sjaSub.sjsidx = b.sjsidx AND tng_sjaSub.sjidx = '" & Replace(sjidx, "'", "''") & "' AND tng_sjaSub.astatus = '1') "
sqlTotalDisprice = sqlTotalDisprice & "AND a.door_w > 0"
Set rsTotalDisprice = cn.Execute(sqlTotalDisprice)
If Not (rsTotalDisprice.BOF Or rsTotalDisprice.EOF) Then
    Do While Not rsTotalDisprice.EOF
        Dim kDOOR_PRICE_all, quan_door_all
        kDOOR_PRICE_all = rsTotalDisprice("door_price")
        quan_door_all = rsTotalDisprice("quan")
        door_disprice_all = rsTotalDisprice("door_disprice")
        door_disrate_all = rsTotalDisprice("door_disrate")



        If IsNull(kDOOR_PRICE_all) Then kDOOR_PRICE_all = 0
        If IsNull(quan_door_all) Or quan_door_all = 0 Then quan_door_all = 1
        
        ' cdlevel_price는 이미 door_price에 반영되어 있으므로 별도 할인 계산 안 함
        
        rsTotalDisprice.MoveNext

        
    Loop
End If
rsTotalDisprice.Close

Set rsTotalDisprice = Nothing

' 최종 할인금액 (프레임 할인만 — cdlevel은 도어가에 이미 반영됨)
Dim final_total_disprice

final_total_disprice = total_frame_disprice_all

If final_total_disprice = 0 Then

final_total_disprice = 0
End If
%>
    </tbody>
</table>

<script>
/* ==============================
 * 숫자 파싱 유틸
 * ============================== */
function num(v){
    if (v === null || v === undefined || v === '') return 0;
    return +String(v).replace(/,/g,'').trim() || 0;
}

/* ==============================
 * 프레임 행 기준 → 도어 서브행 생성
 * ============================== */
document.querySelectorAll('tr.table-body').forEach(function(frameRow){

    /* ---- 도어 JSON 파싱 ---- */
    var doors = [];
    try {
        doors = JSON.parse(frameRow.dataset.doors || '[]');
    } catch(e){
        doors = [];
    }

    if (!doors.length) return; // 도어 없으면 종료

    /* ---- cdlevel (fallback 용) ---- */
    var cdlevel_price = num(frameRow.dataset.cdlevelPrice);

    var insertAfter = frameRow;

    /* ==============================
     * 도어 1개씩 출력
     * ============================== */
    doors.forEach(function(d){

        /* ---- 기본 값 ---- */
        var door_unit_price = num(d.doorPrice);        // 도어 단가 (할인 전)
        var qty             = num(d.doorQuantity) || 1;

        /* ---- 도어 할인금액: cdlevel은 이미 도어가에 반영됨, DB 별도 할인만 표시 ---- */
        var door_disprice_item = num(d.doorDisprice);
        if (door_disprice_item < 0) {
            door_disprice_item = 0;
        }

        /* ---- 도어 공급가 계산 (1장 기준, cdlevel 차감 없이 그대로) ---- */
        var door_supply_price_one = 0;
        if (door_unit_price > 0) {
            door_supply_price_one = door_unit_price - door_disprice_item;
            if (door_supply_price_one < 0) door_supply_price_one = 0;
        }

        /* ---- 도어 공급가 합계 ---- */
        var door_supply_total = door_supply_price_one * qty;

        /* ==============================
         * 도어 서브 행 생성
         * ============================== */
        var tr = document.createElement('tr');
        tr.className = 'table-subrow small';

        tr.innerHTML =
            '<td>도어</td>' +
            '<td>' +
                [(d.goName || ''), (d.barName || '')].filter(Boolean).join(' ') +
            '</td>' +
            '<td>' + (d.doorW || 0) + ' × ' + (d.doorH || 0) + '</td>' +
            '<td>' + (d.doorTypeText || '') + '</td>' +
            '<td>' + (d.doorChoiceText || '') + '</td>' +
            '<td class="text-end">' + door_unit_price.toLocaleString() + '</td>' +
            '<td class="text-end">' + qty + '장</td>' +
            '<td class="text-end">' + Math.abs(door_disprice_item).toLocaleString() + '</td>' +
            '<td class="text-end fw-semibold">' + door_supply_total.toLocaleString() + '</td>';

        insertAfter.parentNode.insertBefore(tr, insertAfter.nextSibling);
        insertAfter = tr;
    });
});
</script>
<!--
    <table id="table-options" class="tbl dense mono my-2" style="border-collapse:collapse; table-layout:fixed;">
        <thead>
            <tr>
                <th style="width:5%;">#</th>
                <th class="txt-left">옵션명</th>
                <th>단가</th>
                <th style="width:7%;">수량</th>
                <th>총액</th>
            </tr>
        </thead>   
        <tbody>
                <%
                Dim jaeryobunridae, robby_box, boyangjea, ufkidx, whaburail, i
                SQL="Select distinct a.jaeryobunridae,a.robby_box,a.boyangjea,a.fkidx,a.whaburail "
                SQL=SQL&" from tk_framek a  "
                SQL=SQL&" JOIN tk_framekSub b ON a.fkidx = b.fkidx "
                SQL=SQL&" JOIN tng_sjaSub c ON a.sjidx = c.sjidx "
                SQL=SQL&" Where a.sjidx='"&sjidx&"' "
                ' Response.write (SQL)&"<br>"
                Set rs = cn.Execute(sql)
                If Not (Rs.bof or Rs.eof) Then 
                Do while not Rs.EOF
            
                    jaeryobunridae=Rs(0)
                    robby_box=Rs(1)
                    boyangjea=Rs(2)
                    ufkidx=Rs(3)
                    whaburail=Rs(4)
                    i=i+1               
                %>
            <tr class="table-body-option">
                <td><%=i%></td> 

                <td>
                <% If IsNumeric(jaeryobunridae) Then %>
                    <%=FormatNumber(jaeryobunridae, 0, -1, -1, -1)%>
                <% Else %>
                    -
                <% End If %>
                </td>

                <td class="text-center">
                <% If IsNumeric(robby_box) Then %>
                    <%=FormatNumber(robby_box, 0, -1, -1, -1)%>
                <% Else %>
                    -
                <% End If %>
                </td>

                <td class="text-center">
                <% If IsNumeric(boyangjea) Then %>
                    <%=FormatNumber(boyangjea, 0, -1, -1, -1)%>
                <% Else %>
                    -
                <% End If %>
                </td>

                <td class="text-center">
                <% If IsNumeric(whaburail) Then %>
                    <%=FormatNumber(whaburail, 0, -1, -1, -1)%>
                <% Else %>
                    -
                <% End If %>
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
-->
            <table id="table-options" class="tbl dense mono my-2" style="border-collapse:collapse; table-layout:fixed;">
                <thead>
                    <tr>
                        <th style="width:5%;">#</th>
                        <th class="txt-left">옵션명</th>
                        <th>단가</th>
                        <th style="width:7%;">수량</th>
                        <th>총액</th>
                    </tr>
                </thead>
                <tbody>
                    <%
'---------------------------------
' 옵션정보 조회 C-1 SQL 구문 (옵션정보 LOOP 구간)
'---------------------------------
Dim rs, sql, seq
sql = ""
sql = sql & "SELECT 'robby_box' AS kind, " 
sql = sql & "       CONVERT(varchar(10), b.xsize) + N'×' + CONVERT(varchar(10), b.ysize) + N' ' + " 
sql = sql & "       CASE " 
sql = sql & "         WHEN b.whichi_auto = 23 THEN N'자동_로비폰박스' " 
sql = sql & "         WHEN b.whichi_fix  = 25 THEN N'수동_로비폰박스' " 
sql = sql & "         ELSE N'로비박스' END AS label, " 
sql = sql & "       SUM(a.quan) AS quantity, " 
sql = sql & "       SUM(a.quan * a.robby_box) AS total, " 
sql = sql & "       SUM(a.quan * a.robby_box)/SUM(a.quan) AS unitPrice " 
sql = sql & "FROM tk_framek a " 
sql = sql & "LEFT JOIN tk_framekSub b ON a.fkidx = b.fkidx " 
sql = sql & "    AND (b.whichi_auto IN (23) OR b.whichi_fix IN (25)) " 
sql = sql & "WHERE EXISTS (SELECT 1 FROM tng_sjasub ss " 
sql = sql & "              WHERE ss.sjsidx=a.sjsidx AND ss.sjidx=" & sjidx & ") " 
sql = sql & "  AND ISNULL(a.robby_box,0)<>0 " 
sql = sql & "GROUP BY b.xsize, b.ysize, " 
sql = sql & "         CASE " 
sql = sql & "           WHEN b.whichi_auto = 23 THEN N'자동_로비폰박스' " 
sql = sql & "           WHEN b.whichi_fix  = 25 THEN N'수동_로비폰박스' " 
sql = sql & "           ELSE N'로비박스' END " 
sql = sql & "UNION ALL "

sql = sql & "SELECT 'jaeryobunridae', N'재료분리대', "
sql = sql & "       SUM(a.quan), "
sql = sql & "       SUM(a.quan * a.jaeryobunridae), "
sql = sql & "       SUM(a.quan * 0 )" 'SUM(a.quan * a.jaeryobunridae)/SUM(a.quan)
sql = sql & "FROM tk_framek a "
sql = sql & "WHERE EXISTS (SELECT 1 FROM tng_sjasub ss WHERE ss.sjsidx=a.sjsidx AND ss.sjidx=" & sjidx & ") "
sql = sql & "  AND ISNULL(a.jaeryobunridae,0)<>0 "
sql = sql & "UNION ALL "
sql = sql & "SELECT 'boyangjea', N'보양재', "
sql = sql & "       SUM(a.quan), "
sql = sql & "       SUM(a.quan * a.boyangjea), "
sql = sql & "       SUM(a.quan * a.boyangjea)/SUM(a.quan) "
sql = sql & "FROM tk_framek a "
sql = sql & "WHERE EXISTS (SELECT 1 FROM tng_sjasub ss WHERE ss.sjsidx=a.sjsidx AND ss.sjidx=" & sjidx & ") "
sql = sql & "  AND ISNULL(a.boyangjea,0)<>0 "
sql = sql & "UNION ALL "
sql = sql & "SELECT 'whaburail', N'하부레일', "
sql = sql & "       SUM(a.quan), "
sql = sql & "       SUM(a.quan * a.whaburail), "
sql = sql & "       SUM(a.quan * a.whaburail)/SUM(a.quan) "
sql = sql & "FROM tk_framek a "
sql = sql & "WHERE EXISTS (SELECT 1 FROM tng_sjasub ss WHERE ss.sjsidx=a.sjsidx AND ss.sjidx=" & sjidx & ") "
sql = sql & "  AND ISNULL(a.whaburail,0)<>0 "
sql = sql & "ORDER BY label;"

' 표시용 옵션 목록 조회
Set rs = cn.Execute(sql)
seq = 1
Do Until rs.EOF
 If Not (IsNull(rs("unitPrice")) Or IsNull(rs("quantity")) Or IsNull(rs("total"))) Then
%>
<tr class="table-body-option">
  <td><%=seq%></td>
  <td><%=rs("label")%></td>
    <%if rs("unitPrice") = 0 Then%>
        <td class="text-end"></td>
    <%else%>
        <td class="text-end"><%= FormatNumber(rs("unitPrice"), 0) %>원</td>
    <%end if%>
  <td class="text-end"><%=rs("quantity")%>개</td>
  <td class="text-end"><%= FormatNumber(rs("total"), 0) %>원</td>
</tr>
<%
    seq = seq + 1
  End If
  rs.MoveNext
Loop
rs.Close : Set rs = Nothing
%>
                </tbody>
            </table>
            <!--기타자재-->
            <table id="table-options" class="tbl dense mono my-2" style="border-collapse:collapse; table-layout:fixed;">
                <thead>
                    <tr>
                        <th style="width:5%;">#</th>
                        <th class="txt-left">추가자재명</th>
                        <th>단가</th>
                        <th style="width:7%;">수량</th>
                        <th>총액</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    Dim d, etc_idx, etc_name, etc_qty, etc_price, etc_base_price
                    d = 0
                    SQL="Select distinct A.etc_idx, A.etc_name, a.etc_qty, A.etc_price, A.sjidx "
                    SQL=SQL&" From tk_etc A "
                    SQL=SQL&" left outer Join tng_sjaSub B On a.sjidx=B.sjidx "
                    SQL=SQL&" Where A.sjidx='"&sjidx&"' "
                    'Response.write (SQL)&"<br>"
                    Set rs = cn.Execute(sql)
                    if not (Rs.EOF or Rs.BOF ) then
                    Do while not Rs.EOF
                    d=d+1               '순번
                    etc_idx=rs(0) ' 키
                    etc_name=rs(1) ' 제품명
                    etc_qty=rs(2) ' 수량
                    etc_price=rs(3) ' 원가
                    sjidx=rs(4) ' 주문번호

                    '단가
                    etc_base_price = etc_price * etc_qty
                
                    'Response.write "etc_idx"&"="& etc_idx &"<br>"
                
                    %>
                    <tr>
                        <td class="text"><%=d%></td>
                        <td class="text"><%=etc_name%></td>
                        
                        <td class="text-end"><%=formatnumber(etc_price,0)%></td><!-- 원가 -->
                        <td class="text-end"><%=etc_qty%>EA</td><!-- 수량 -->
                        <td class="text-end"><%=formatnumber(etc_base_price,0)%>원</td> <!-- 단가 -->
                    </tr>
                    <%
                    Rs.movenext
                    Loop
                    End If
                    Rs.Close 
                    %>
                    
                </tbody>
            </table>  

            <div id="items-container">
                <div class="payment-section">
                    <div class="in-words">
                        <strong>메모</strong><br>
                        <% 
                            If IsNull(h_memo) Or Trim(h_memo) = "" Or Trim(h_memo) = "0" Then
                        %>
                            <span style="color:#ff0000; font-weight:bold;">-</span>
                        <% Else %>
                            <span style="color:#ff0000; font-weight:bold;"><%=h_memo%></span>
                        <% End If %>
                            <span style="color:#ff0000; font-weight:bold; margin-top:5px;">원자재 가격의 상승으로 인하여 제품가격이 변동될 수 있습니다. 유효기간은 견적일로부터 15일 입니다.</span>
                    </div>
                        <table class="summary w-100">
                            <tbody>
                                <tr>
                                <td>할인금액</td>
                                <td class="text-end" data-unit="원"><%=FormatNumber(final_total_disprice, 0)%></td>
                                </tr>
                                <tr>
                                <td>공급가</td>
                                <td class="text-end" data-unit="원"><%=FormatNumber(h_tfprice, 0)%></td>

                                <td>부가세</td>
                                <td class="text-end" data-unit="원"><%=FormatNumber(h_taxprice, 0)%></td>

                                <td><strong>총액</strong></td>
                                <td class="text-end" data-unit="원"><strong><%=FormatNumber(h_tzprice, 0)%></strong></td>
                                </tr>
                            </tbody>
                        </table>
                </div>
            </div>
        </div>

        <style>
            .no-capture {
                display: none !important;
            }
        </style>


        <div class="print-fab">
            <button type="button" class="btn btn-dark" onclick="window.print()">인쇄</button>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                data-bs-target="#downloadModal">다운로드</button>
            <button type="button" class="btn btn-outline-secondary" onclick="window.close()">닫기</button>
        </div>

        <!-- 내보내기 모달 -->
        <div class="modal fade" id="downloadModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">내보내기</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                    </div>
                    <div class="modal-body">
                        <div class="small text-muted mb-3">
                            A4용지 전용 CSS(폭·높이 mm, 여백 0) 기준으로 그대로 내보냅니다.
                        </div>

                        <!-- 여러 페이지일 때 이미지 복사용 페이지 선택 -->
                        <div id="pagePickerWrap" class="mb-3 d-none">
                            <label class="form-label">대상 페이지(이미지 복사 전용)</label>
                            <select id="pagePicker" class="form-select"></select>
                        </div>

                        <div class="d-grid gap-2">
                            <!-- 파일 다운로드명 지정 -->
                            <input id="downloadFileName" type="hidden" value="<%=h_cname%>_견적서_<%=h_sjnum%>">
                            
                            <button id="btnDownloadImages" class="btn btn-outline-dark">이미지 다운로드</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS (모달용) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- 캡처/내보내기 라이브러리 -->
        <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jszip@3.10.1/dist/jszip.min.js"></script>
        <script src="/documents/outsideOrder/assets/js/export.js"></script>




</body>

</html>


<%
Set Rs2=Nothing
call dbClose()
%>