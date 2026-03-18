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

Dim stock_idx
rstock_idx = Request("stock_idx")
rstock_sub_idx = Request("stock_sub_idx")
rstatus = Request("status")
ramount = Request("amount")
rin_date = Request("in_date")
rmode = Request("mode")
rmaxAmount = Request("maxAmount")


If rstock_idx = "" Then
    Response.Write "<script>alert('잘못된 접근입니다.');history.back();</script>"
    Response.End
End If

Dim Rs, SQL
Set Rs = Server.CreateObject("ADODB.Recordset")

' ===============================
' 원본 입고 정보 조회 (읽기 전용)
' ===============================
Dim material_id, amount, status, wdate

SQL = ""
SQL = SQL & "SELECT "
SQL = SQL & "    S.stock_idx, "
SQL = SQL & "    S.material_id, "
SQL = SQL & "    B.material_name, "
SQL = SQL & "    S.amount, "
SQL = SQL & "    S.status, "
SQL = SQL & "    S.wdate "
SQL = SQL & "FROM tk_wms_stock S "
SQL = SQL & "LEFT JOIN bom2_material B "
SQL = SQL & "    ON S.material_id = B.material_id "
SQL = SQL & "WHERE S.stock_idx = " & rstock_idx

Rs.Open SQL, DbCon

If Rs.EOF Then
    Response.Write "<script>alert('입고 정보가 존재하지 않습니다.');history.back();</script>"
    Response.End
End If

material_id = Rs("material_id")
material_name = Rs("material_name")
amount      = Rs("amount")
status      = Rs("status")
wdate       = Rs("wdate")

Rs.Close
Set Rs = Nothing

Dim inputAmountValue
inputAmountValue = ""

If rmode = "update" Then
    inputAmountValue = ramount
    amount = rmaxAmount
End If


%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>입고 수량 분기 처리</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body {
    background:#f4f6f9;
}
.card {
    border-radius:12px;
}
.form-label {
    font-weight:600;
}
.readonly-box {
    background:#f1f3f5;
}
</style>
</head>

<body>

<div class="container mt-4">
    <div class="card shadow-sm">
        <div class="card-header bg-white">
            <h5 class="mb-0">입고 수량 분기 처리</h5>
        </div>

        <div class="card-body">

            <!-- 원본 입고 정보 -->
            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">자재 이름</label>
                    <input type="text" class="form-control readonly-box"
                           value="<%=material_name%>" readonly>
                </div>

                <div class="col-md-4">
                    <label class="form-label">입고 수량</label>
                    <input type="text" class="form-control readonly-box"
                           value="<%=amount%>" readonly>
                </div>

                <div class="col-md-4">
                    <label class="form-label">입고일</label>
                    <input type="text" class="form-control readonly-box"
                           value="<%=Left(CStr(wdate),10)%>" readonly>
                </div>
            </div>

            <hr>

            <!-- 분기 입력 -->
            <form method="post" action="TNG_WMS_Stock_Sub_DB.asp">

                <input type="hidden" name="mode" value="<%=rmode%>">
                <input type="hidden" name="stock_idx" value="<%=rstock_idx%>">
                <input type="hidden" name="stock_sub_idx" value="<%=rstock_sub_idx%>">
                <input type="hidden" name="max_amount" value="<%=amount%>">

                <div class="mb-3">
                    <label class="form-label">처리 유형</label>
                    <select name="status" class="form-select" required>
                        <option value="0" <% If CStr(rstatus) = "0" Then Response.Write "selected" %>>입고</option>
                        <option value="1" <% If CStr(rstatus) = "1" Then Response.Write "selected" %>>반품</option>
                    </select>
                </div>

                
                <div class="mb-3">
                    <label class="form-label">실제 입고일자</label>
                    <input type="date" name="in_date" class="form-control" value="<%=rin_date%>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">처리 수량</label>
                    <input type="number"
                        name="amount"
                        class="form-control"
                        min="1"
                        max="<%=amount%>"
                        value="<%=inputAmountValue%>"
                        required>
                    <div class="form-text">
                        입고 수량(<%=amount%>)을 초과할 수 없습니다.
                    </div>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-danger">
                        분기 처리
                    </button>
                    <a href="javascript:history.back();" class="btn btn-secondary">
                        취소
                    </a>
                </div>

            </form>

        </div>
    </div>
</div>

</body>
</html>
