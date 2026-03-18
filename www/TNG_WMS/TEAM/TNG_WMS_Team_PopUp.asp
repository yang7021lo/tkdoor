<%@ Language="VBScript" CodePage="65001" %>
<%
Session.CodePage = "65001"
Response.Charset  = "utf-8"
%>

<!-- 공통 -->
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/css/styles.css" rel="stylesheet" />
<script src="https://use.fontawesome.com/releases/v6.1.0/js/all.js" crossorigin="anonymous"></script>

<%
' =========================
' DB OPEN
' =========================
Call dbOpen()

%>

<%
' =========================
' 파라미터
' =========================
Dim role_team_idx
role_team_idx = Trim(Request("role_team_idx"))

' =========================
' 페이지 모드 텍스트 
' =========================
Dim pageModeText
If role_team_idx <> "" Then
    pageModeText = "수정"
Else
    pageModeText = "등록"
End If

' =========================
' Recordset
' =========================
Dim Rs, sql, RsTeam
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsTeam = Server.CreateObject("ADODB.Recordset")

' =========================
' 기본값
' =========================
Dim role_team_name, company_idx, company_name, is_active
role_team_name = ""
company_idx    = ""
company_name   = ""
is_active      = 1

' =========================
' 수정 모드 데이터 로드
' =========================
If role_team_idx <> "" And IsNumeric(role_team_idx) Then

    sql = ""
    sql = sql & " SELECT role_team_name, company_idx, is_active "
    sql = sql & " FROM tk_wms_role_team "
    sql = sql & " WHERE role_team_idx = " & CLng(role_team_idx)

    RsTeam.Open sql, DbCon

    If Not RsTeam.EOF Then
        role_team_name = RsTeam("role_team_name")
        company_idx    = RsTeam("company_idx")
        is_active      = RsTeam("is_active")
        
        %>
        <!--회사 캐시 (dbOpen 이후!)-->
<!--#include virtual="/TNG_WMS/Cache/Cache_customer.asp"-->

        <%
        ' 회사명은 캐시에서만 조회
        If company_idx <> "" Then
            If dictCustomerOne.Exists(CStr(company_idx)) Then
                company_name = dictCustomerOne(CStr(company_idx))
            Else
                company_name = ""
            End If
        End If
    End If
    RsTeam.Close
End If
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>팀 <%=pageModeText%></title>

<script>
function openCompanyPopup() {
    window.open(
        '/TNG_WMS/company/TNG_WMS_Company_Popup.asp',
        'companyPopup',
        'width=900,height=700,scrollbars=yes'
    );
}
function openCustomerPopup() {
    window.open(
        '/TNG_WMS/STOCK/customer/customer_popup.asp',
        'customerPopup',
        'width=900,height=700,scrollbars=yes'
    );
}
</script>
</head>

<body class="bg-light">

<div class="container-fluid p-4">

    <!-- 헤더 -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">👥 팀 <%=pageModeText%></h5>
        <button type="button"
                class="btn btn-outline-secondary btn-sm"
                onclick="window.close();">
            닫기
        </button>
    </div>

    <!-- 폼 -->
    <form method="post" action="TNG_WMS_Team_DB.asp">

        <input type="hidden" name="role_team_idx" value="<%=role_team_idx%>">
        <input type="hidden" name="is_popup" value="1">

        <!-- 팀명 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">팀명</label>
            <input type="text"
                   name="role_team_name"
                   class="form-control"
                   required
                   value="<%=role_team_name%>">
        </div>

        <!-- 회사 (캐시 + 팝업 선택) -->
        <div class="mb-3">
            <label class="form-label fw-semibold">회사</label>

            <input type="hidden"
                   name="company_idx"
                   id="company_idx"
                   value="<%=company_idx%>">

            <div class="d-flex gap-2">
                <input type="text"
                       id="company_name"
                       class="form-control"
                       value="<%=company_name%>"
                       placeholder="회사를 선택하세요"
                       readonly>

                <button type="button"
                        class="btn btn-outline-secondary"
                        onclick="openCustomerPopup();">
                    선택
                </button>
            </div>
        </div>



        <!-- 버튼 -->
        <div class="d-flex justify-content-end gap-2">
            <button type="submit" class="btn btn-primary">
                저장
            </button>
            <button type="button"
                    class="btn btn-secondary"
                    onclick="window.close();">
                취소
            </button>
        </div>

    </form>

</div>

</body>
</html>

<%
Set Rs = Nothing
Call dbClose()
%>
