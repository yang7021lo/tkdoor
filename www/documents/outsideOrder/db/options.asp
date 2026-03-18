<%@ CodePage="65001" Language="VBScript" %>
<%
Response.ContentType = "application/json; charset=utf-8"

Const OLE_DB = "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;User ID=tkd001;Password=tkd2713!;"

Dim sjidx : sjidx = Request("sjidx")

Dim cn : Set cn = Server.CreateObject("ADODB.Connection")
cn.Open OLE_DB

Dim sql
sql = ""
sql = sql & "SELECT a.sjsidx, a.fkidx, a.fidx, a.fname, a.sjidx, a.quan, "
sql = sql & "       a.robby_box, a.jaeryobunridae, a.boyangjea, a.whaburail "
sql = sql & "FROM tk_framek a "
sql = sql & "WHERE EXISTS (SELECT 1 FROM tng_sjasub ss WHERE ss.sjsidx=a.sjsidx AND ss.sjidx=" & sjidx & ") "
sql = sql & "AND (ISNULL(a.robby_box,0)<>0 OR ISNULL(a.whaburail,0)<>0 OR ISNULL(a.boyangjea,0)<>0 OR ISNULL(a.jaeryobunridae,0)<>0) "
sql = sql & "ORDER BY a.fidx, a.sjsidx"

Dim rs : Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, cn

Dim first, seq : first = True : seq = 0
Response.Write "{""options"":["

Do Until rs.EOF
  seq = seq + 1

  Dim sjsidxVal, nameVal, qty
  sjsidxVal = rs("sjsidx")
  nameVal   = rs("fname")
  qty = 0 : If Not IsNull(rs("quan")) Then qty = CLng(rs("quan"))

  ' 각 옵션 컬럼 = 개당 가격
  Dim uLobby, uRediv, uProtect, uBottom
  uLobby  = 0 : If Not IsNull(rs("robby_box"))      Then uLobby  = CDbl(rs("robby_box"))
  uRediv  = 0 : If Not IsNull(rs("jaeryobunridae")) Then uRediv  = CDbl(rs("jaeryobunridae"))
  uProtect= 0 : If Not IsNull(rs("boyangjea"))      Then uProtect= CDbl(rs("boyangjea"))
  uBottom = 0 : If Not IsNull(rs("whaburail"))      Then uBottom = CDbl(rs("whaburail"))

  ' enabled & 수량
  Dim hasRediv, hasLobby, hasProtect, hasBottom
  hasRediv  = (uRediv  > 0)
  hasLobby  = (uLobby  > 0)
  hasProtect= (uProtect> 0)
  hasBottom = (uBottom > 0)

  Dim qRediv, qLobby, qProtect, qBottom
  If hasRediv  Then qRediv  = qty Else qRediv  = 0 End If
  If hasLobby  Then qLobby  = qty Else qLobby  = 0 End If
  If hasProtect Then qProtect= qty Else qProtect= 0 End If
  If hasBottom Then qBottom = qty Else qBottom = 0 End If

  ' 총액 = 단가 × 수량
  Dim tLobby, tRediv, tProtect, tBottom, finalAmt
  tLobby  = uLobby  * qLobby
  tRediv  = uRediv  * qRediv
  tProtect= uProtect* qProtect
  tBottom = uBottom * qBottom
  finalAmt= tLobby + tRediv + tProtect + tBottom

  If Not first Then Response.Write "," Else first = False

  Response.Write "{"
  Response.Write """seq"":" & seq & ","
  Response.Write """sjsidx"":" & sjsidxVal & ","
  Response.Write """name"":""" & nameVal & ""","
  Response.Write """redivision"":{""enabled"":" & LCase(CStr(hasRediv))  & ",""unitPrice"":" & uRediv  & ",""quantity"":" & qRediv  & ",""total"":" & tRediv  & "},"
  Response.Write """lobbyPhone"":{""enabled"":"  & LCase(CStr(hasLobby))  & ",""unitPrice"":" & uLobby  & ",""quantity"":" & qLobby  & ",""total"":" & tLobby  & "},"
  Response.Write """protectiveMaterial"":{""enabled"":" & LCase(CStr(hasProtect))& ",""unitPrice"":" & uProtect& ",""quantity"":" & qProtect& ",""total"":" & tProtect& "},"
  Response.Write """bottomRail"":{""enabled"":" & LCase(CStr(hasBottom)) & ",""unitPrice"":" & uBottom & ",""quantity"":" & qBottom & ",""total"":" & tBottom & "},"
  Response.Write """finalAmount"":" & finalAmt
  Response.Write "}"

  rs.MoveNext
Loop

Response.Write "]}"
If rs.State<>0 Then rs.Close : Set rs = Nothing
If cn.State<>0 Then cn.Close : Set cn = Nothing
%>
