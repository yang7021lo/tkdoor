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
    Set Rs = Server.CreateObject ("ADODB.Recordset")

snidx=request("snidx")
'Response.write snidx&"<br>"
'Response.end
%>

            <%
            SQL=" Select A.rfile "
            SQL=SQL&" From tk_report A "
            SQL=SQL&" Join tk_reportsendsub B on B.ridx=A.ridx where B.snidx='"&snidx&"' "
            Rs.open Sql,Dbcon

            If Not (Rs.bof or Rs.eof) Then
            Do while not Rs.EOF
            rfile=Rs(0)
            %>

            <a href="/report/rfile/<%=rfile%>" download></a>

            <%
            Rs.movenext
            Loop
            End If
            Rs.close
            %>

            <%
            SQL="select C.rfile "
            SQL=SQL&" From tk_reportsendgSub A "
            SQL=SQL&" Join tk_reportgsub B On B.rgidx=A.rgidx "
            SQL=SQL&" Join tk_report C On B.ridx=C.ridx "
            SQL=SQL&" where A.snidx='"&snidx&"' and B.ridx not in (Select C.ridx From tk_report C Join tk_reportsendsub D on D.ridx=C.ridx where D.snidx='"&snidx&"')"
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then
            Do while not Rs.EOF
            rfile=Rs(0)
            %>

            <a href="/report/rfile/<%=rfile%>" download></a>

            <%
            Rs.movenext
            Loop
            End If
            Rs.close
            %>

            <%
            SQL=" Select efname from tk_emailatfile Where snidx='"&snidx&"' "
            Rs.open Sql,Dbcon
            If Not (Rs.bof or Rs.eof) Then
            Do while not Rs.EOF
            efname=Rs(0)
            %>

            <a href="/report/rfile/<%=efname%>" download></a>

            <%
            Rs.movenext
            Loop
            End If
            Rs.close
            %>

<%


'Response.write (SQL)&"<br>"
'Response.end

Response.Write "<script>opener.location.replace('sendmaildownload.asp?snidx="&snidx&"');</script>"
%>

<%
set Rs=Nothing
call dbClose()
%>



