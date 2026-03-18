<%@ Codepage="65001" Language="VBScript" %>
<!--#include virtual="/inc/dbcon.asp"-->
<%
Session.CodePage = 65001
Response.Charset = "utf-8"
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Set Rs  = Server.CreateObject("ADODB.Recordset")

sjidx         = Request("sjidx")
sjsidx         = Request("sjsidx")
wms_type = Request("wms_type")
call dbOpen()
'response.write "sjsidx :" &sjsidx& "<br>"
'response.write "wms_type :" &wms_type& "<br>"
' ⭐ 저장버튼을 눌렀을 때 (POST로 들어옴)
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then


    recv_addr1   = Request("recv_addr1")    '받는 사람 주소
    recv_addr     = Request("recv_addr")    '받는 지점
    recv_name     = Request("recv_name")    '받는 사람 이름
    recv_tel      = Request("recv_tel")   '전화번호
    delivery_type = Request("delivery_type")


    'response.write "recv_addr1 :" &recv_addr1& "<br>"
    'response.write "recv_name :" &recv_name& "<br>"
    'response.write "recv_phone :" &recv_phone& "<br>"
    'response.write "delivery_type :" &delivery_type& "<br>"
    'response.end
    If wms_type = "1" Then  ' 🔵 화물
        SQL = "UPDATE tk_wms_meta SET "
        SQL = SQL & "recv_name='" & recv_name & "', "
        SQL = SQL & "recv_tel='" & recv_tel & "', "
        SQL = SQL & "recv_addr='" & recv_addr & "', "
        SQL = SQL & "recv_addr1='" & recv_addr1 & "' "
    Else                    ' 🟢 택배
        SQL = SQL & "recv_name='" & branch & "', "
        SQL = SQL & "recv_tel='" & phone & "', "
        SQL = SQL & "recv_addr='" & name & "', "
        SQL = SQL & "delivery_type='" & delivery_type & "' "
    End If
     
    SQL = SQL & "WHERE sjidx='" & sjidx & "'"

    Dbcon.Execute(SQL)
    call dbClose()

    Response.Write "<script>alert('저장되었습니다.');</script>"
    Response.Write "<script>window.opener.location.reload(); window.close();</script>"
    Response.End  ' 🔥 여기서 끝, HTML 안 나옴
End If

SQL = ""
SQL = SQL & "SELECT recv_name, recv_tel, recv_addr, recv_addr1 "
SQL = SQL & "FROM tk_wms_meta "
SQL = SQL & "WHERE sjidx = '" & sjidx & "'"

Rs.Open SQL, Dbcon

If Not (Rs.BOF Or Rs.EOF) Then
    recv_name  = Rs("recv_name")
    recv_tel   = Rs("recv_tel")
    recv_addr  = Rs("recv_addr")
    recv_addr1 = Rs("recv_addr1")
End If

Rs.Close
%>
<style>
* { box-sizing:border-box; font-family:"Pretendard","Segoe UI",sans-serif; }
body { padding:25px; background:#f7f9fc; }

.popup-wrap {
    background:white; padding:22px 25px;
    border-radius:12px; box-shadow:0 3px 12px rgba(0,0,0,0.08);
}

h3 {
    margin:0 0 15px 0; padding-bottom:10px;
    font-size:20px; color:#333; font-weight:700;
    border-bottom:2px solid #007bff22;
}

label {
    font-weight:600; color:#005bbb;
    margin-top:8px; display:block;
}

input, select {
    width:100%; margin-top:5px;
    padding:10px 12px;
    border:1.4px solid #d3dae4; border-radius:6px;
    font-size:15px; background:#ffffff;
    transition:all .2s;
}
input:focus, select:focus {
    border-color:#007aff; background:#f2f8ff;
    outline:none; box-shadow:0 0 6px rgba(0,122,255,.15);
}

.btn {
    margin-top:25px; width:100%; padding:12px;
    background:#007aff; color:#fff; border:none;
    border-radius:6px; cursor:pointer; font-size:16px; font-weight:600;
    box-shadow:0 3px 8px rgba(0,122,255,.3);
}
.btn:hover { background:#0063d6; }
</style>
</head>
<body>

<div class="popup-wrap">
<h3>🚚 배송 정보 입력</h3>

<form method="post" action="TNG_WMS_Type_popup.asp">

<%
' ========= 1 = 화물 =========
If wms_type = "1" Then
%>

    <label>📍 받는 지점</label>
    <input type="text" name="recv_addr" placeholder="예: 인천 물류센터" value="<%= recv_addr %>">
    
    <label>📦 받는 사람 주소</label>
    <input type="text" name="recv_addr1" placeholder="예: 경기도 수원시 장안구..." value="<%= recv_addr1 %>">

    <label>👤 받는 사람 이름</label>
    <input type="text" name="recv_name" placeholder="예: 홍길동" value="<%= recv_name %>">

    <label>📞 전화번호</label>
    <input type="text" id="recv_tel" name="recv_tel" placeholder="예: 010-1234-5678" value="<%= recv_tel %>">

<%
' ========= 2~5 = 택배 =========
Else
%>

    <label>📦 받는 사람 주소</label>
    <input type="text" name="recv_addr1" placeholder="예: 경기도 수원시 장안구...">

    <label>👤 받는 사람 이름</label>
    <input type="text" name="recv_name" placeholder="예: 홍길동">

    <label>📞 전화번호</label>
    <input type="text" name="recv_phone" id="recv_phone"
       placeholder="예: 010-1234-5678" maxlength="13"
       pattern="^01[0-9]-[0-9]{3,4}-[0-9]{4}$" required>

    <label>💰 택배 구분</label>
    <select name="delivery_type">
        <option value="0">선불</option>
        <option value="1">착불</option>
    </select>

<%
End If
%>

<input type="hidden" name="sjidx" value="<%=sjidx%>">
<input type="hidden" name="wms_type" value="<%=wms_type%>">
<button class="btn" type="submit">✔ 저장하기</button>

<script>
const phone = document.getElementById("recv_tel");
phone.addEventListener("input", function(e) {
    // 숫자만 남기기
    let value = e.target.value.replace(/[^0-9]/g, "");
    
    // 010-1234-5678 형태 자동 완성
    if (value.length > 3 && value.length <= 7) {
        value = value.slice(0, 3) + "-" + value.slice(3);
    } else if (value.length > 7) {
        value = value.slice(0, 3) + "-" + value.slice(3, 7) + "-" + value.slice(7, 11);
    }
    e.target.value = value;
});
</script>
</form>
</div>

</body>
</html>
