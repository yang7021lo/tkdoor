<%@ codepage="65001" language="vbscript"%>
<!-- #include virtual="/inc/dbcon.asp" -->
<!-- #include virtual="/inc/cookies.asp" -->
<%
Response.CharSet = "utf-8"
call DbOpen()

' ===============================
' 변수 선언
' ===============================
Dim item_no, item_name, origin_type_no, active
Dim midx, meidx

item_no        = Trim(Request("item_no"))
item_name      = Trim(Request("item_name"))
origin_type_no = Trim(Request("origin_type_no"))
active         = Trim(Request("is_active"))

' ===============================
' 로그인 사용자
' ===============================
If IsNumeric(Session("user_id")) Then
    midx  = CLng(Session("user_id"))
    meidx = CLng(Session("user_id"))
Else
    Response.Write "NO_USER"
    Response.End
End If

' ===============================
' 유효성 검사
' ===============================
If item_no = "" _
   Or item_name = "" _
   Or Not IsNumeric(origin_type_no) _
   Or Not IsNumeric(active) Then

    Response.Write "INVALID"
    Response.End
End If

' ===============================
' item_no 중복 체크
' ===============================
Dim RsChk, sqlChk
Set RsChk = Server.CreateObject("ADODB.Recordset")

sqlChk = "SELECT master_id, item_name, is_active " & _
         "FROM bom3_master " & _
         "WHERE item_no = '" & Replace(item_no,"'","''") & "'"

RsChk.Open sqlChk, Dbcon

If Not RsChk.EOF Then
    Dim statusText
    If CInt(RsChk("is_active")) = 1 Then
        statusText = "사용"
    Else
        statusText = "중지"
    End If

    Response.Write "DUPLICATE|" & _
                   RsChk("master_id") & "|" & _
                   RsChk("item_name") & "|" & _
                   statusText
    RsChk.Close
    Set RsChk = Nothing
    Response.End
End If

RsChk.Close
Set RsChk = Nothing


' ===============================
' INSERT (VBScript 방식)
' ===============================
Dim sql
sql = "INSERT INTO bom3_master (" & _
      "item_no, item_name, origin_type_no, is_active, midx, meidx, cdate, udate" & _
      ") VALUES (" & _
      "N'" & Replace(item_no,"'","''") & "', " & _
      "N'" & Replace(item_name,"'","''") & "', " & _
      CLng(origin_type_no) & ", " & _
      CLng(active) & ", " & _
      midx & ", " & _
      meidx & ", " & _
      "GETDATE(), GETDATE()" & _
      ")"
Dbcon.Execute sql



Dim RsId, newMasterId
Set RsId = Server.CreateObject("ADODB.Recordset")

RsId.Open "SELECT SCOPE_IDENTITY() AS new_id", Dbcon
newMasterId = CLng(RsId("new_id"))

RsId.Close
Set RsId = Nothing

Response.Write "OK"
call DbClose()
%>
