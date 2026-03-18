<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- DB -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<%
call dbOpen()

' ===============================
' 파라미터 수신
' ===============================
Dim mode
Dim stock_sub_idx, stock_idx
Dim amount, status, in_date
Dim midx, meidx

mode          = LCase(Trim(Request("mode")))
stock_sub_idx = Trim(Request("stock_sub_idx"))
stock_idx     = Trim(Request("stock_idx"))
amount        = Trim(Request("amount"))
status        = Trim(Request("status"))   ' 0=입고, 1=반품
in_date       = Trim(Request("in_date"))

' response.Write "('mode: " & mode & "')"
' response.Write "('stock_sub_idx: " & stock_sub_idx & "')" 
' response.Write "('stock_idx: " & stock_idx & "')"
' response.Write "('amount: " & amount & "')"
' response.Write "('status: " & status & "')"
' response.Write "('in_date: " & in_date & "')"
' response.end

midx  = c_midx
meidx = c_midx

' ===============================
' 기본 검증
' ===============================
If mode = "" Then
    mode = "insert"
End If

If mode <> "delete" Then
    If stock_idx = "" Or amount = "" Or status = "" Then
        Response.Write "<script>alert('필수 값이 누락되었습니다.');history.back();</script>"
        Response.End
    End If
End If

' ===============================
' 숫자 캐스팅
' ===============================
If stock_sub_idx <> "" Then stock_sub_idx = CLng(stock_sub_idx)
If stock_idx <> "" Then stock_idx = CLng(stock_idx)
If amount <> "" Then amount = CLng(amount)
If status <> "" Then status = CInt(status)

' 날짜 처리
If in_date = "" Then
    in_date = "NULL"
Else
    in_date = "'" & Replace(in_date,"'","") & "'"
End If

Dim SQL, Rs
Set Rs = Server.CreateObject("ADODB.Recordset")

' ===============================
' 가용 수량 체크 (반품일 경우만)
' ===============================
If mode = "insert" Or mode = "update" Then

    Dim origin_amount, total_in, total_return

    ' 원본 입고 수량
    SQL = "SELECT amount FROM tk_wms_stock WHERE stock_idx = " & stock_idx
    Rs.Open SQL, DbCon
    If Rs.EOF Then
        Response.Write "<script>alert('원본 입고 정보가 없습니다.');history.back();</script>"
        Response.End
    End If
    origin_amount = Rs("amount")
    Rs.Close

    ' 입고 합계
    SQL = ""
    SQL = SQL & "SELECT "
    SQL = SQL & " SUM(CASE WHEN status = 0 THEN amount ELSE 0 END) AS in_qty, "
    SQL = SQL & " SUM(CASE WHEN status = 1 THEN amount ELSE 0 END) AS return_qty "
    SQL = SQL & "FROM tk_wms_stock_sub "
    SQL = SQL & "WHERE stock_idx = " & stock_idx
    SQL = SQL & " AND is_active = 1 "

    If mode = "update" Then
        SQL = SQL & " AND stock_sub_idx <> " & stock_sub_idx
    End If

    Rs.Open SQL, DbCon
    total_in     = Rs("in_qty")
    total_return = Rs("return_qty")
    Rs.Close

    ' 반품 수량 초과 방지
    If status = 1 Then
        If (total_return + amount) > (origin_amount + total_in) Then
            Response.Write "<script>alert('반품 수량이 가용 수량을 초과할 수 없습니다.');history.back();</script>"
            Response.End
        End If
    End If

End If

' ===============================
' DB 처리
' ===============================
Select Case mode

    ' ---------------------------
    ' INSERT
    ' ---------------------------
    Case "insert"

        SQL = ""
        SQL = SQL & "INSERT INTO tk_wms_stock_sub ( "
        SQL = SQL & " stock_idx, amount, in_date, status, "
        SQL = SQL & " midx, meidx, wdate, udate, is_active "
        SQL = SQL & ") VALUES ( "
        SQL = SQL & stock_idx & ", "
        SQL = SQL & amount & ", "
        SQL = SQL & in_date & ", "
        SQL = SQL & status & ", "
        SQL = SQL & "'" & midx & "', "
        SQL = SQL & "'" & meidx & "', "
        SQL = SQL & "GETDATE(), "
        SQL = SQL & "GETDATE(), "
        SQL = SQL & "1 "
        SQL = SQL & ")"

        DbCon.Execute SQL

    ' ---------------------------
    ' UPDATE
    ' ---------------------------
    Case "update"

        If stock_sub_idx = "" Then
            Response.Write "<script>alert('수정 대상이 없습니다.');history.back();</script>"
            Response.End
        End If

        SQL = ""
        SQL = SQL & "UPDATE tk_wms_stock_sub SET "
        SQL = SQL & " amount = " & amount & ", "
        SQL = SQL & " in_date = " & in_date & ", "
        SQL = SQL & " status = " & status & ", "
        SQL = SQL & " meidx = '" & meidx & "', "
        SQL = SQL & " udate = GETDATE() "
        SQL = SQL & "WHERE stock_sub_idx = " & stock_sub_idx

        DbCon.Execute SQL

    ' ---------------------------
    ' DELETE (soft delete)
    ' ---------------------------
    Case "delete"

        If stock_sub_idx = "" Then
            Response.Write "<script>alert('삭제 대상이 없습니다.');history.back();</script>"
            Response.End
        End If

        SQL = ""
        SQL = SQL & "UPDATE tk_wms_stock_sub SET "
        SQL = SQL & " is_active = 0, "
        SQL = SQL & " meidx = '" & meidx & "', "
        SQL = SQL & " udate = GETDATE() "
        SQL = SQL & "WHERE stock_sub_idx = " & stock_sub_idx

        DbCon.Execute SQL

    Case Else
        Response.Write "<script>alert('잘못된 처리 요청입니다.');history.back();</script>"
        Response.End
End Select
%>

<script>

    alert('정상 처리되었습니다.');

    if (window.opener && !window.opener.closed) {
        window.opener.location.replace(window.opener.location.href);
    }

    window.close();
</script>


