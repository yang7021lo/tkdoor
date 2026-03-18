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
Set Rs  = Server.CreateObject ("ADODB.Recordset")
Set RsForm = Server.CreateObject ("ADODB.Recordset")

mode = Request("mode")
' === Request 값 받기 (r 접두어) ===

rstkidx   = Request("stkidx")
rmidx   = Request("midx")
rstk1   = Request("stk1")
rstk2   = Request("stk2")
rstk3   = Request("stk3")
rstk4   = Request("stk4")
rstk5   = Request("stk5")
rstk6   = Request("stk6")
rstk7   = Request("stk7")
rstk8   = Request("stk8")
rstk9   = Request("stk9")
rstk10  = Request("stk10")
rqty   = Request("qty")

Response.Write "mode : " & mode & "<br>"   
Response.Write "rstkidx : " & rstkidx & "<br>"   

' 신규 저장
If mode = "insert" Then
    qty = CLng(Request("qty"))
    For i = 1 To qty
        SQL = "INSERT INTO STK (midx, stk1, stk2, stk3, stk4, stk5, stk6, stk7, stk8, stk9, stk10, qty,stkdate) "
        SQL = SQL & "VALUES ('" & rmidx & "', '" & rstk1 & "', '" & rstk2 & "', '" & rstk3 & "', '" & rstk4 & "' "
        SQL = SQL & ", '" & rstk5 & "', '" & rstk6 & "', '" & rstk7 & "', '" & rstk8 & "', '" & rstk9 & "', '" & rstk10 & "', '" & rqty & "',getdate())"
        Response.write (SQL)&"<br>"

        Dbcon.Execute SQL


    Next
    ' 마지막 저장 midx
   ' Set RsLast = Dbcon.Execute("SELECT TOP 1 midx FROM STK ORDER BY midx DESC")
   ' lastmidx = RsLast("midx")
   ' RsLast.Close
   ' Response.Redirect "label_print.asp?midx=" & lastmidx
End If

' 수정
If mode = "update" Then
    midx = CLng(Request("midx"))
        SQL = "UPDATE STK SET midx = '" & rmidx & "'"
        SQL = SQL & ", stk1 = '" & rstk1 & "'"
        SQL = SQL & ", stk2 = '" & rstk2 & "'"
        SQL = SQL & ", stk3 = '" & rstk3 & "'"
        SQL = SQL & ", stk4 = '" & rstk4 & "'"
        SQL = SQL & ", stk5 = '" & rstk5 & "'"
        SQL = SQL & ", stk6 = '" & rstk6 & "'"
        SQL = SQL & ", stk7 = '" & rstk7 & "'"
        SQL = SQL & ", stk8 = '" & rstk8 & "'"
        SQL = SQL & ", stk9 = '" & rstk9 & "'"
        SQL = SQL & ", stk10 = '" & rstk10 & "'"
        SQL = SQL & ", qty = '" & rqty & "'"
        SQL = SQL & ", stkdateup = getdate() "
        SQL = SQL & " WHERE stkidx = '" & rstkidx & "' "
        Response.write (SQL)&"<br>"
    Dbcon.Execute SQL
    Response.Redirect "label_print.asp?stkidx=" & rstkidx & ""
End If

' 삭제
If mode = "delete" Then
    midx = CLng(Request("midx"))
    Dbcon.Execute "DELETE FROM STK WHERE stkidx = '" & rstkidx & "' "
    Response.Redirect "label_stk.asp"
End If

' 최근 데이터 1건 불러오기 (폼 채우기용)
SQL = "SELECT TOP 1 * FROM STK ORDER BY stkidx DESC"
Rs.Open SQL, Dbcon
Response.write (SQL)&"<br>"
If Not (Rs.BOF Or Rs.EOF) Then
    last_stkidx   = Rs(0)
End If
Rs.close

SQL = "SELECT midx, stk1, stk2, stk3, stk4, stk5, stk6, stk7, stk8, stk9, stk10, stkidx ,qty "
SQL = SQL & " FROM STK "
SQL = SQL & " WHERE stkidx = '" & last_stkidx & "' "
Response.write (SQL)&"<br>"
Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
    midx   = Rs(0)
    stk1   = Rs(1)
    stk2   = Rs(2)
    stk3   = Rs(3)
    stk4   = Rs(4)
    stk5   = Rs(5)
    stk6   = Rs(6)
    stk7   = Rs(7)
    stk8   = Rs(8)
    stk9   = Rs(9)
    stk10  = Rs(10)
    stkidx = Rs(11)
    qty    = Rs(12)
End If
Rs.close

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>레이블 프린터 전용 출력</title>
<link rel="stylesheet" href="/css/styles.css">
        <style>
        @page {
            size: 100mm 45mm;  /* 기본 페이지 크기를 도어라벨로 설정 */
            margin: 0;          /* 여백 제거 */
        }

        @media print {
            body {
            margin: 0;
            padding: 0;
            }
            .print-btn { display: none; } /* 프린트 시 버튼 숨기기 */    
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .label {
            width: 100mm;
            height: 45mm;
            box-sizing: border-box;
            padding: 0mm;
            border: 0.3mm solid #000;
        }

        table {
            width: 100%;
            height: 100%;
            font-size: 3mm;
            table-layout: fixed;
            border-collapse: collapse;
        }

        th, td {
            border: 0.1mm solid #000;
            padding: 2mm;
            text-align: left;
            vertical-align: middle;
        }

        th {
    font-weight: bold;
    background-color: #f9f9f9;
}
input {
    width: 100%;
    height: 100%;
    border: none;
    font-size: 3mm;
    padding: 0.5mm;
    box-sizing: border-box;
}
.center {
    text-align: center;
}
</style>
</head>
<body>

<form method="post" action="label_stk.asp">
    <% if rstkidx = "" Then %>
    <input type="hidden" name="mode" value="insert">
    <% else %>
    <input type="hidden" name="mode" value="update">
    <% end if %>
    <input type="hidden" name="midx" value="<%=midx%>">
    <input type="hidden" name="stkidx" value="<%=stkidx%>">

    <div class="row ">
        <div class="container mt-1 TEXT-CENTER">
            <button class="print-btn" onclick="window.print()">🖨️[제품라벨 : 100x45] 레이블 프린터 전용 출력하기</button>
        </div>
    </div>
    <div class="row ">
        <div class="label-box"  style="width: 400px; border-collapse: collapse;">
            <table>
                <tbody>
                    <tr> 
                        <th style="width: 15%;">거래처</th>
                        <td colspan="9"><input type="text" name="stk1" value="<%=stk1%>" ></td>
                    </tr>
                    <tr> 
                        <th style="width: 15%;">현장명</th>
                        <td colspan="9"><input type="text" name="stk2" value="<%=stk2%>"></td>
                    </tr>
                    <tr> 
                        <th style="width: 15%;">검측</th>
                        <td colspan="9" class="center">
                            <input type="text" name="stk3" value="<%=stk3%>" style="width:25mm; text-align:center;">
                            <span style="display:inline-block; width:5mm; text-align:center;">x</span>
                            <input type="text" name="stk4" value="<%=stk4%>" style="width:25mm; text-align:center;">
                        </td>
                    </tr>
                    <tr> 
                        <th style="width: 15%;">위치</th>
                        <td colspan="9"><input type="text" name="stk5" value="<%=stk5%>"></td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td colspan="9"><input type="text" name="stk6" value="<%=stk6%>"></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="form-footer" style="margin-top:5px; display:flex; align-items:center; gap:10px;">
    <label for="qty">수량:</label>
    <input type="number" id="qty" name="qty" value="<%=qty%>" min="1" style="width:60px;">

    <button type="submit" style="padding:5px 15px; font-size:14px; background:#007bff; color:#fff; border:none; border-radius:4px; cursor:pointer;">
        저장
    </button>
</div>
    </div>

</form>
<div class="label-box"  style="width: 400px; border-collapse: collapse;">
<table>
                <tbody>
<%
SQL = "SELECT midx, stk1, stk2, stk3, stk4, stk5, stk6, stk7, stk8, stk9, stk10, stkidx , qty "
SQL = SQL & "FROM STK "
SQL = SQL & "WHERE stkidx <> 0 "
 SQL = SQL & " ORDER BY stkidx DESC "
Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
Do while not Rs.EOF
    midx   = Rs(0)
    stk1   = Rs(1)
    stk2   = Rs(2)
    stk3   = Rs(3)
    stk4   = Rs(4)
    stk5   = Rs(5)
    stk6   = Rs(6)
    stk7   = Rs(7)
    stk8   = Rs(8)
    stk9   = Rs(9)
    stk10  = Rs(10)
    stkidx = Rs(11)
    qty    = Rs(12)
%>

<tr>
    <td><%=midx%></td>
    <td><%=stk1%></td>
    <td><%=stk2%></td>
    <td><%=stk3%></td>
    <td><%=stk4%></td>
    <td><%=stk5%></td>
    <td><%=stk6%></td>
    <td><%=stk7%></td>
    <td><%=stk8%></td>
    <td><%=stk9%></td>
    <td><%=stk10%></td>
</tr>

<%
Rs.movenext
Loop
End If
Rs.close
%>
   </tbody>
            </table>
            </div>
</body>
</html>
