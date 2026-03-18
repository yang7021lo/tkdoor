<%@ LANGUAGE="VBScript" %>
<%
' Include the database connection file
%>
<!DOCTYPE html>
<html>
<head>
    <title>Jedo Management</title>
</head>
<body>
    <h1>Update Reasons for Suggestions</h1>
    <form method="post" action="jedodb.asp">
        <label for="sjbidx">Suggestion ID:</label><br>
        <input type="text" id="sjbidx" name="sjbidx" required><br><br>
        
        <label for="reason">Reason for Update:</label><br>
        <textarea id="reason" name="reason" rows="5" cols="50" required></textarea><br><br>
        
        <input type="submit" value="Update">
    </form>
    
    <h2>View Suggestions</h2>
    <table border="1">
        <tr>
            <th>Suggestion ID</th>
            <th>Name</th>
            <th>Suggestion Content</th>
            <th>Update Reason</th>
        </tr>
        <%
        ' Fetch existing suggestions from the database
        SQL = "SELECT sjbidx, name, suggestion, reason FROM tk_sujub"
        Set Rs = Dbcon.Execute(SQL)
        If Not (Rs.BOF Or Rs.EOF) Then
            Do While Not Rs.EOF
        %>
        <tr>
            <td><%= Rs("sjbidx") %></td>
            <td><%= Rs("name") %></td>
            <td><%= Rs("suggestion") %></td>
            <td><%= Rs("reason") %></td>
        </tr>
        <%
            Rs.MoveNext
            Loop
        End If
        Rs.Close
        %>
    </table>
</body>
</html>
