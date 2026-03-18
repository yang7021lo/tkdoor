<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage="65001"
Response.Charset="utf-8"
%>

<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
call dbOpen()

Dim Rs, sql
Set Rs = Server.CreateObject("ADODB.Recordset")

Dim bw_idx, mode
bw_idx = Request("bw_idx")

If bw_idx = "" Or Not IsNumeric(bw_idx) Then
    mode = "insert"
    bw_idx = ""
Else
    mode = "update"
    bw_idx = CInt(bw_idx)
End If

' =========================
' 기본 변수
' =========================
Dim bw_no, material_id, stock_idx, bw_price
bw_no = ""
material_id = ""
stock_idx = ""
bw_price = ""

' =========================
' 수정 모드 데이터 조회
' =========================
If mode = "update" Then
    sql = ""
    sql = sql & " SELECT bw_no, material_id, stock_idx, bw_price "
    sql = sql & " FROM tk_bom_wms "
    sql = sql & " WHERE bw_idx = " & bw_idx

    Rs.Open sql, DbCon, 1, 1

    If Not Rs.EOF Then
        bw_no       = Rs("bw_no")
        material_id = Rs("material_id")
        stock_idx   = Rs("stock_idx")
        bw_price    = Rs("bw_price")
    End If

    Rs.Close
End If

Dim pageTitle
If mode = "insert" Then
    pageTitle = "기계 등록"
Else
    pageTitle = "기계 수정"
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title><%=pageTitle%></title>
</head>

<body>

<div class="container-fluid p-4">

    <h5 class="fw-bold mb-3">🛠 <%=pageTitle%></h5>

    <form method="post" action="TNG_WMS_BOM_DB.asp">

        <input type="hidden" name="mode" value="<%=mode%>">
        <input type="hidden" name="bw_idx" value="<%=bw_idx%>">
        <input type="hidden" name="is_popup" value="1">

        <!-- 기계 번호 -->
        <div class="mb-3">
            <label class="form-label">기계 번호</label>
            <input type="text" name="bw_no" class="form-control"
                   value="<%=bw_no%>" required>
        </div>

        <!-- 자재 선택 -->
        <div class="mb-3">
            <label class="form-label">자재</label>
            <select name="material_id" class="form-select" required>
                <option value="">자재 선택</option>
                <%
                    sql = ""
                    sql = sql & " SELECT M.material_id, M.material_name "
                    sql = sql & " FROM bom2_material M "
                    sql = sql & " INNER JOIN bom2_master BM "
                    sql = sql & "   ON M.master_id = BM.master_id "
                    sql = sql & " WHERE M.is_active = 1 "
                    sql = sql & "   AND BM.master_id = 19 "   ' 기계만
                    sql = sql & " ORDER BY M.material_name "

                    Rs.Open sql, DbCon, 1, 1

                    Do Until Rs.EOF

                        Dim selMaterial
                        selMaterial = ""

                        If CStr(Rs("material_id")) = CStr(material_id) Then
                            selMaterial = "selected"
                        End If
                    %>
                        <option value="<%=Rs("material_id")%>" <%=selMaterial%>>
                            <%=Rs("material_name")%>
                        </option>
                    <%
                        Rs.MoveNext
                    Loop

                    Rs.Close
                %>
            </select>
        </div>
        <!-- 재고 선택 -->
        <div class="mb-3">
            <label class="form-label">재고 번호</label>
            <select name="stock_idx" class="form-select" required>
                <option value="">재고 선택</option>
                <%
                sql = ""
                sql = sql & " SELECT stock_idx "
                sql = sql & " FROM tk_wms_stock "
                sql = sql & " WHERE is_active = 1 "
                sql = sql & " ORDER BY stock_idx DESC "

                Rs.Open sql, DbCon, 1, 1

                Do Until Rs.EOF
                    Dim selStock
                    selStock = ""

                    If CStr(Rs("stock_idx")) = CStr(stock_idx) Then
                        selStock = "selected"
                    End If
                %>
                    <option value="<%=Rs("stock_idx")%>" <%=selStock%>>
                        재고 #<%=Rs("stock_idx")%>
                    </option>
                <%
                    Rs.MoveNext
                Loop
                Rs.Close
                %>
            </select>
        </div>
     

        <!-- 기계 금액 -->
        <div class="mb-4">
            <label class="form-label">기계 금액</label>
            <input type="number" name="bw_price" class="form-control"
                   step="1"
                   value="<%=bw_price%>" required>
        </div>

        <!-- 버튼 -->
        <div class="text-end">
            <button type="submit" class="btn btn-primary">저장</button>
            <button type="button" class="btn btn-secondary"
                    onclick="window.close();">
                닫기
            </button>
        </div>

    </form>

</div>

</body>
</html>

<%
Set Rs = Nothing
call dbClose()
%>
