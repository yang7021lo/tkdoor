<%@ CodePage="65001" Language="VBScript" %>
<%
Option Explicit
Response.ContentType = "application/json; charset=utf-8"
Response.CharSet     = "utf-8"

'---------------------------------
' DB 연결 (직접 연결)
'---------------------------------
Dim cn : Set cn = Server.CreateObject("ADODB.Connection")
cn.Open "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;User ID=tkd001;Password=tkd2713!;"

'---------------------------------
' 유틸
'---------------------------------
Function J(s) ' JSON-safe string
  If IsNull(s) Then s = "" Else s = CStr(s)
  s = Replace(s, "\", "\\")
  s = Replace(s, """", "\""")
  s = Replace(s, vbCrLf, "\n")
  s = Replace(s, vbCr,   "\n")
  s = Replace(s, vbLf,   "\n")
  J = s
End Function

Function JN(v) ' number or null
  If IsNull(v) Or Trim(CStr(v)) = "" Then
    JN = "null"
  Else
    JN = CStr(v)
  End If
End Function

Function Ymd(dv)
  If IsDate(dv) Then
    Ymd = Year(dv) & "-" & Right("0"&Month(dv),2) & "-" & Right("0"&Day(dv),2)
  Else
    Ymd = CStr(dv)
  End If
End Function

' 빈/Null 이면 "해당 없음" 반환
Function K(s)
  Dim t
  If IsNull(s) Then
    K = "해당 없음"
  Else
    t = Trim(CStr(s))
    If t = "" Then K = "해당 없음" Else K = t
  End If
End Function

'---------------------------------
' 파라미터
'---------------------------------
Dim sjidx : sjidx = Trim(Request("sjidx"))
If sjidx = "" Then
  Response.Write "{""success"":false,""error"":""missing sjidx""}"
  cn.Close : Set cn = Nothing
  Response.End
End If

'---------------------------------
' (1) 헤더 + 고객명 조회
'---------------------------------
Dim rsH, sqlH
sqlH = ""
sqlH = sqlH & "SELECT "
sqlH = sqlH & "  A.sjdate, "
sqlH = sqlH & "  A.sjnum, "
sqlH = sqlH & "  CONVERT(VARCHAR(10), A.cgdate,121) AS cgdate, "
sqlH = sqlH & "  A.cgaddr, "
sqlH = sqlH & "  A.memo, "
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

Set rsH = cn.Execute(sqlH)
If (rsH.BOF And rsH.EOF) Then
  Response.Write "{""success"":false,""error"":""not found""}"
  rsH.Close: cn.Close
  Response.End
End If

Dim h_sjdate, h_sjnum, h_cgdate, h_cgaddr, h_memo, h_tfprice, h_taxprice, h_tzprice
Dim h_cname, h_cnumber, h_ctel, h_cfax, h_cceo, h_caddress, h_mname
Dim h_ctkidx, h_ctkname, h_ctkadr, h_ctkbizNo, h_ctktel, h_ctkaccbankname, h_ctkaccname, h_ctkaccnumb

h_sjdate    = rsH("sjdate")
h_sjnum     = rsH("sjnum")
h_cgdate    = rsH("cgdate")
h_cgaddr    = rsH("cgaddr")
h_memo      = rsH("memo")
h_tfprice   = rsH("tfprice")
h_taxprice  = rsH("taxprice")
h_tzprice   = rsH("tzprice")

h_cname     = rsH("cname")
h_cnumber   = rsH("cnumber")
h_ctel      = rsH("ctel")
h_cfax      = rsH("cfax")
h_cceo      = rsH("cceo")
h_caddress  = rsH("caddress")

h_ctkname = rsH("ctkidx")
h_ctkname = rsH("ctkname")
h_ctkadr = rsH("ctkadr")
h_ctkbizNo = rsH("ctkbizNo")
h_ctktel = rsH("ctktel")

h_ctkaccbankname = rsH("ctkaccbankname")
h_ctkaccname = rsH("ctkaccname")
h_ctkaccnumb = rsH("ctkaccnumb")

h_mname  = rsH("mname")

rsH.Close


'---------------------------------
' (2) items 조회
'---------------------------------
'---------------------------------
' (2) items 조회 + OUTER APPLY
'---------------------------------
Dim rsI, cmdI, sqlI
Set cmdI = Server.CreateObject("ADODB.Command")
Set cmdI.ActiveConnection = cn
cmdI.CommandType = 1   ' adCmdText

sqlI = _
"SELECT DISTINCT " & _
"  A.sjsidx                                    AS idx, " & _
"  A.framename                                 AS name, " & _
"  ISNULL(A.asub_wichi1,'')                    AS loc1, " & _
"  ISNULL(A.asub_wichi2,'')                    AS loc2, " & _
"  ''                                          AS remark, " & _
"  ISNULL(A.mwidth,0)                          AS measuredSizeW, " & _
"  ISNULL(A.mheight,0)                         AS measuredSizeH, " & _
"  ISNULL(G.qtyname,'')                        AS material, " & _
"  ISNULL(I.pname,'')                          AS coating, " & _
"  ISNULL(A.sjsprice,0)                        AS unitPrice, " & _
"  ISNULL(A.quan,0)                            AS quantity, " & _
"  ISNULL(A.disprice,0)                        AS discount, " & _
"  (ISNULL(A.sjsprice,0)*ISNULL(A.quan,0)) - ISNULL(A.disprice,0) AS lineAmount, " & _
"  ISNULL(FK.doors,'[]')                       AS doors " & _
"FROM tng_sjaSub A " & _
"LEFT JOIN tk_qty   C ON C.qtyidx = A.qtyidx " & _
"LEFT JOIN tk_qtyco G ON G.qtyno  = C.qtyno " & _
"LEFT JOIN tk_paint I ON I.pidx   = A.pidx " & _
"OUTER APPLY ( " & _
"  SELECT ( " & _
"    SELECT " & _
"      s.fksidx               AS fksidx, " & _
"      s.door_w               AS doorW, " & _
"      s.door_h               AS doorH, " & _
"      s.doorsizechuga_price  AS doorSizeChugaPrice, " & _
"      s.door_price           AS doorPrice, " & _
"      s.goname               AS goName, " & _
"      s.barNAME              AS barName, " & _
"      s.doortype             AS doorType, " & _
"      CASE s.doortype " & _
"        WHEN 1 THEN N'좌도어' " & _
"        WHEN 2 THEN N'우도어' " & _
"        ELSE N'없음' END      AS doorTypeText, " & _
"      k.doorchoice           AS doorChoice, " & _
"      CASE k.doorchoice " & _
"        WHEN 1 THEN N'도어 포함가' " & _
"        WHEN 2 THEN N'도어 별도가' " & _
"        WHEN 3 THEN N'도어 제외가' " & _
"        ELSE N'선택되지 않음' END AS doorChoiceText " & _
"    FROM tk_framekSub s " & _
"    JOIN tk_framek   k ON s.fkidx = k.fkidx " & _
"    WHERE k.sjsidx = A.sjsidx " & _
"      AND s.DOOR_W > 0 " & _
"    ORDER BY s.fksidx " & _
"    FOR JSON PATH " & _
"  ) AS doors " & _
") FK " & _
"WHERE A.astatus = '1' " & _
"  AND A.sjidx = ? " & _
"ORDER BY A.sjsidx;"

cmdI.CommandText = sqlI
cmdI.Parameters.Append cmdI.CreateParameter("@sjidx", 200, 1, 100, sjidx)
Set rsI = cmdI.Execute



'---------------------------------
' (3) JSON 출력
'---------------------------------
Response.Write "{""success"":true,""data"":{"

'--- 헤더/메모 ---
Response.Write """quoteNo"":"""   & J(h_sjnum) & ""","
Response.Write """quoteDate"":""" & J(Ymd(h_sjdate)) & ""","
Response.Write """location"":"""  & J(h_cgaddr) & ""","  ' 필요시 K(h_cgaddr)로 바꿔도 됨
Response.Write """currency"":""KRW"","
Response.Write """paymentStatus"":""UNPAID"","
Response.Write """notes"":"""    & J(K(h_memo)) & ""","   ' << 여기만 K 적용

' --- client ---
Response.Write """client"":{"
Response.Write """name"":"""      & J(K(h_cname))    & ""","
Response.Write """address"":"""   & J(K(h_caddress)) & ""","
Response.Write """bizNo"":"""     & J(K(h_cnumber))  & ""","
Response.Write """tel"":"""       & J(K(h_ctel))     & ""","
Response.Write """fax"":"""       & J(K(h_cfax))     & ""","
Response.Write """requester"":""" & J(K(h_cceo))     & ""","
Response.Write """manager"":"""   & J(K(h_cceo))     & """"
Response.Write "},"
'--- items ---
Response.Write """items"":["
Dim first : first = True

Do Until rsI.EOF
  ' loc1/loc2 규칙 처리
  Dim l1, l2
  l1 = "" : l2 = ""
  If Not IsNull(rsI("loc1")) Then l1 = Trim(CStr(rsI("loc1")))
  If Not IsNull(rsI("loc2")) Then l2 = Trim(CStr(rsI("loc2")))
  If l1 = "" And l2 = "" Then l1 = "해당 없음"

  ' 문자열 필드 기본값 처리
  Dim nm, rk, mat, coat
  nm   = K(rsI("name"))
  rk   = K(rsI("remark"))
  mat  = K(rsI("material"))
  coat = K(rsI("coating"))

  ' doors JSON 문자열 준비 (FOR JSON PATH 결과)
  Dim doorsJson
  doorsJson = "[]"
  If Not IsNull(rsI("doors")) Then doorsJson = CStr(rsI("doors"))

  If Not first Then Response.Write ","
  first = False

  Response.Write "{"

  ' 상위(아이템) 필드
  Response.Write """idx"":"              & JN(rsI("idx")) & ","
  Response.Write """name"":"""           & J(nm)   & ""","
  Response.Write """loc1"":"""           & J(l1)   & ""","
  Response.Write """loc2"":"""           & J(l2)   & ""","
  Response.Write """remark"":"""         & J(rk)   & ""","
  Response.Write """measuredSizeW"":"    & JN(rsI("measuredSizeW")) & ","
  Response.Write """measuredSizeH"":"    & JN(rsI("measuredSizeH")) & ","
  Response.Write """material"":"""       & J(mat)  & ""","
  Response.Write """coating"":"""        & J(coat) & ""","
  Response.Write """unitPrice"":"        & JN(rsI("unitPrice")) & ","
  Response.Write """quantity"":"         & JN(rsI("quantity")) & ","
  Response.Write """discountPrice"":"    & JN(rsI("discount")) & ","
  Response.Write """lineAmount"":"       & JN(rsI("lineAmount")) & ","

  ' 하위 도어 배열 (따옴표 없이 그대로 출력)
  Response.Write """doors"":" & doorsJson

  Response.Write "}"
  rsI.MoveNext
Loop

Response.Write "],"


Response.Write """subtotal"":" & JN(h_tfprice) & ","
Response.Write """vat"":"      & JN(h_taxprice) & ","
Response.Write """total"":"    & JN(h_tzprice)  & ","

Response.Write """verificationNo"":""" & J(h_sjnum) & ""","
Response.Write """qrPayload"":"""      & J(h_sjnum) & ""","

Response.Write """issuer"":{"
Response.Write """name"":""" & J(h_ctkname) & ""","
Response.Write """logoUrl"":""/logo.svg"","
Response.Write """sealPayload"":""http://tkd001.cafe24.com/documents/outsideOrder/assets/tk_seal.png"","
Response.Write """address"":""" & J(h_ctkadr) & ""","
Response.Write """bizNo"":""" & J(h_ctkbizNo) & ""","
Response.Write """representative"":""김희일"","
Response.Write """website"":""www.tkdoor.kr"","
Response.Write """supportEmail"":""supports@tkdoor.kr"","
Response.Write """supportTel"":""" & J(h_ctktel) & ""","
Response.Write """department"":""전산팀 (SUN)"""
Response.Write "},"

Response.Write """payment"":{"
Response.Write """bank"":""" & J(h_ctkaccbankname) & ""","
Response.Write """accountNo"":""" & J(h_ctkaccnumb) & ""","
Response.Write """accountName"":""" & J(h_ctkaccname) & ""","
Response.Write """contact"":"""      & J(h_mname) & """"
Response.Write "}"

Response.Write "}}"

' 정리
If rsI.State=1 Then rsI.Close
Set rsI = Nothing
cn.Close : Set cn = Nothing
%>
