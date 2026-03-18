<%@ Language="VBScript" CodePage="65001" %>
<%
Option Explicit
Response.Charset     = "utf-8"
Response.ContentType = "text/html; charset=utf-8"

' === 직접 DB 연결 ===
Public Dbcon
Const OLE_DB = "Provider=SQLOLEDB;Data Source=sql19-004.cafe24.com;Initial Catalog=tkd001;User ID=tkd001;Password=tkd2713!;"

Sub dbOpen()
  If Not IsObject(Dbcon) Then
    Set Dbcon = Server.CreateObject("ADODB.Connection")
    Dbcon.ConnectionTimeout = 30
    Dbcon.CommandTimeout    = 30
  End If
  If Dbcon.State = 0 Then Dbcon.Open OLE_DB
End Sub

Sub dbClose()
  On Error Resume Next
  If IsObject(Dbcon) Then
    If Dbcon.State <> 0 Then Dbcon.Close
    Set Dbcon = Nothing
  End If
End Sub

Dim sjidx : sjidx = Request("sjidx")
If Len(sjidx) = 0 Then
  Response.Write "<tr><td colspan='4' class='text-center'>sjidx가 없습니다.</td></tr>"
  Response.End
End If

Call dbOpen()

Dim sql, cmd, rs, i
sql = ""
sql = sql & "SELECT A.sjsidx AS id, A.framename AS name, "
sql = sql & "       0 AS printed,  "              ' 저장/불러오기 패스 → 항상 0
sql = sql & "       A.sjidx, S.sjcidx AS cidx "   ' 리다이렉트용 파라미터
sql = sql & "FROM tng_sjaSub A WITH (NOLOCK) "
sql = sql & "JOIN tng_sja S WITH (NOLOCK) ON S.sjidx = A.sjidx "
sql = sql & "WHERE A.sjidx = ? AND A.astatus = 1 "
sql = sql & "ORDER BY A.sjsidx"

Set cmd = Server.CreateObject("ADODB.Command")
Set cmd.ActiveConnection = Dbcon
cmd.CommandType = 1
cmd.CommandText = sql

' sjidx가 숫자 컬럼이면 아래를 adInteger(=3)로 교체하세요.
cmd.Parameters.Append cmd.CreateParameter("@p1", 200, 1, 50, sjidx) ' adVarChar

Set rs = cmd.Execute

i = 1
If rs.EOF Then
  Response.Write "<tr><td colspan='4' class='text-center'>데이터가 없습니다.</td></tr>"
Else
  Do Until rs.EOF
%>
  <tr data-id="<%=rs("id")%>">
    <td class="text-center"><%=i%></td>
    <td>
      <%=Server.HTMLEncode(rs("name"))%>
      <!-- 히든 파라미터(행마다 심어둠) -->
      <input type="hidden" class="hidCidx"  value="<%=rs("cidx")%>">
      <input type="hidden" class="hidSjidx" value="<%=rs("sjidx")%>">
      <input type="hidden" class="hidSjsidx" value="<%=rs("id")%>">
    </td>
    <td class="text-center cellPrinted"><%=rs("printed")%></td>
    <td class="text-center">
      <button type="button" class="btn btn-sm btn-outline-primary btnPrint">출력</button>
    </td>
  </tr>
<%
    i = i + 1
    rs.MoveNext
  Loop
End If

If Not rs Is Nothing Then If rs.State <> 0 Then rs.Close
Set rs = Nothing
Call dbClose()
%>
