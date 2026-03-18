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
sqlH = sqlH & "  ISNULL(C.caddr1,'') + ' ' + ISNULL(C.caddr2,'') AS caddress "
sqlH = sqlH & "FROM tng_sja A "
sqlH = sqlH & "LEFT JOIN tk_customer C ON A.sjcidx = C.cidx "
sqlH = sqlH & "WHERE A.sjidx = '" & Replace(sjidx, "'", "''") & "'"

Set rsH = cn.Execute(sqlH)
If (rsH.BOF And rsH.EOF) Then
  Response.Write "{""success"":false,""error"":""not found""}"
  rsH.Close: cn.Close
  Response.End
End If

Dim h_sjdate, h_sjnum, h_cgdate, h_cgaddr, h_memo, h_tfprice, h_taxprice, h_tzprice
Dim h_cname, h_cnumber, h_ctel, h_cfax, h_cceo, h_caddress

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

rsH.Close


'---------------------------------
' (2) items 조회
'---------------------------------
Dim rsI, sqlI
sqlI = _
"SELECT " & _
"  A.framename                          AS name, " & _
"  ISNULL(A.asub_wichi1,'')             AS loc1, " & _
"  ISNULL(A.asub_wichi2,'')             AS loc2, " & _
"  ''                                   AS remark, " & _
"  ISNULL(A.mwidth,0)                   AS measuredSizeW, " & _
"  ISNULL(A.mheight,0)                  AS measuredSizeH, " & _
"  ISNULL(G.qtyname,'')                 AS material, " & _
"  ISNULL(I.pname,'')                   AS coating, " & _
"  ISNULL(A.sjsprice,0)                 AS unitPrice, " & _
"  ISNULL(A.quan,0)                     AS quantity, " & _
"  ISNULL(A.sjsprice,0)*ISNULL(A.quan,0) AS lineAmount " & _
"FROM tng_sjaSub A " & _
"LEFT JOIN tk_qty   C ON C.qtyidx = A.qtyidx " & _
"LEFT JOIN tk_qtyco G ON G.qtyno  = C.qtyno " & _
"LEFT JOIN tk_paint I ON I.pidx   = A.pidx " & _
"WHERE A.astatus = '1' AND A.sjidx = '" & Replace(sjidx,"'","''") & "' " & _
"ORDER BY A.sjsidx;"

Set rsI = cn.Execute(sqlI)

'---------------------------------
' (3) JSON 출력
'---------------------------------
Response.Write "{""success"":true,""data"":{"

Response.Write """quoteNo"":"""   & J(h_sjnum) & ""","
Response.Write """quoteDate"":""" & J(Ymd(h_sjdate)) & ""","
Response.Write """location"":"""  & J(h_cgaddr) & ""","
Response.Write """currency"":""KRW"","
Response.Write """paymentStatus"":""UNPAID"","
Response.Write """notes"":"""    & J(h_memo) & ""","

Response.Write """client"":{"
Response.Write """name"":"""      & J(h_cname) & ""","
Response.Write """address"":"""   & J(h_caddress) & ""","
Response.Write """bizNo"":"""     & J(h_cnumber) & ""","
Response.Write """tel"":"""       & J(h_ctel) & ""","
Response.Write """fax"":"""       & J(h_cfax) & ""","
Response.Write """requester"":""" & J(h_cceo) & ""","
Response.Write """manager"":"""   & J(h_cceo) & """"
Response.Write "},"

' items
Response.Write """items"":["
Dim first : first = True
Do Until rsI.EOF
  If Not first Then Response.Write ","
  first = False
  Response.Write "{"
  Response.Write """name"":"""            & J(rsI("name")) & ""","
  Response.Write """loc1"":"""            & J(rsI("loc1")) & ""","
  Response.Write """loc2"":"""            & J(rsI("loc2")) & ""","
  Response.Write """remark"":"""          & J(rsI("remark")) & ""","
  Response.Write """measuredSizeW"":"     & JN(rsI("measuredSizeW")) & ","
  Response.Write """measuredSizeH"":"     & JN(rsI("measuredSizeH")) & ","
  Response.Write """material"":"""        & J(rsI("material")) & ""","
  Response.Write """coating"":"""         & J(rsI("coating")) & ""","
  Response.Write """unitPrice"":"         & JN(rsI("unitPrice")) & ","
  Response.Write """quantity"":"          & JN(rsI("quantity")) & ","
  Response.Write """lineAmount"":"        & JN(rsI("lineAmount"))
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
Response.Write """name"":""태광도어"","
Response.Write """logoUrl"":""/logo.svg"","
Response.Write """sealPayload"":""https://d2v80xjmx68n4w.cloudfront.net/gigs/rate/qglbM1714385345.png"","
Response.Write """address"":""경기 안산시 단원구 번영2로 25"","
Response.Write """bizNo"":""123456789"","
Response.Write """representative"":""홍길동"","
Response.Write """website"":""www.tkdoor.kr"","
Response.Write """supportEmail"":""supports@tkdoor.kr"","
Response.Write """supportTel"":""031-493-0516"","
Response.Write """department"":""전산팀 (SUN)"""
Response.Write "},"

Response.Write """payment"":{"
Response.Write """bank"":""국민은행"","
Response.Write """accountNo"":""78910123456789"","
Response.Write """accountName"":""태광도어법인(주)"","
Response.Write """contact"":""박민수"""
Response.Write "}"

Response.Write "}}"

' 정리
If rsI.State=1 Then rsI.Close
Set rsI = Nothing
cn.Close : Set cn = Nothing
%>
