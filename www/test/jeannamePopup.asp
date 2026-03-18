<%@ codepage="65001" language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
	call dbOpen()
	Set RsC = Server.CreateObject ("ADODB.Recordset")
	Set Rs = Server.CreateObject ("ADODB.Recordset")
	Set Rs1 = Server.CreateObject ("ADODB.Recordset")
	Set Rs2 = Server.CreateObject ("ADODB.Recordset")
	Set Rs3 = Server.CreateObject ("ADODB.Recordset")

'listgubun="three"
projectname="제안제도"
    developername="양양"

    if c_midx="" then 
        response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
        response.end
    end if 

	function encodestr(str)
		if str = "" then exit function
		str = replace(str,chr(34),"&#34")
		str = replace(str,"'","''")
		encodestr = str
	end Function


SearchWord=Request("SearchWord")
gubun=Request("gubun")
 

	if request("gotopage")="" then
	gotopage=1
	else
	gotopage=request("gotopage")
	end if
	page_name="jean.asp?"

SQL = "SELECT midx, mname FROM tk_member ORDER BY mname"
Rs.Open SQL, dbCon
%>
<html>
<head>
    <title>공동 제안자 검색</title>
    <script>
        function selectMember(midx, mname) {
            if (!window.opener.selectedMembers) {
                window.opener.selectedMembers = [];
            }
            window.opener.selectedMembers.push({ midx, mname });
            alert(mname + " 님이 추가되었습니다.");
        }

        function closePopup() {
            window.close();
        }
    </script>
</head>
<body>
    <h3>공동 제안자 검색</h3>
    <table border="1">
        <tr>
            <th>회원 번호</th>
            <th>회원 이름</th>
            <th>선택</th>
        </tr>
        <% While Not Rs.EOF %>
        <tr>
            <td><%=Rs("midx")%></td>
            <td><%=Rs("mname")%></td>
            <td>
                <button onclick="selectMember('<%=Rs("midx")%>', '<%=Rs("mname")%>')">선택</button>
            </td>
        </tr>
        <%
            Rs.MoveNext
        Wend
        %>
    </table>
    <button onclick="closePopup()">닫기</button>
</body>
</html>
<%
Rs.Close()
Set Rs = Nothing
call dbClose()
%>
