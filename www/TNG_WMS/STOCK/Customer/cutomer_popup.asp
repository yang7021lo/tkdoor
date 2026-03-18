<%@ codepage="65001" language="vbscript"%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

keyword = Trim(Request("keyword"))

sql = "SELECT TOP 50 cidx, cname FROM tk_customer WHERE is_active=1 "
If keyword <> "" Then
    sql = sql & " AND cname LIKE '%" & keyword & "%' "
End If
sql = sql & " ORDER BY cname"

Set Rs = DbCon.Execute(sql)
%>
<form>
<input type="text" name="keyword" value="<%=keyword%>">
<button>검색</button>
</form>

<table>
<%
Do Until Rs.EOF
%>
<tr onclick="selectCustomer('<%=Rs("cidx")%>','<%=Rs("cname")%>')">
    <td><%=Rs("cname")%></td>
</tr>
<%
Rs.MoveNext
Loop
%>
</table>

<script>
function selectCustomer(cidx, cname) {
    opener.document.getElementById('cidx').value = cidx;
    opener.document.getElementById('cname').value = cname;
    window.close();
}
</script>
