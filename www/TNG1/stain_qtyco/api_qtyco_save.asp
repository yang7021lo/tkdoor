<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
call dbOpen()

' JSON 읽기
json = Request.BinaryRead(Request.TotalBytes)
json = StrConv(json, vbUnicode)

Function J(key)
  pos = InStr(1, json, """" & key & """", 1)
  If pos = 0 Then J = "" : Exit Function
  pos = InStr(pos + Len(key) + 2, json, ":")
  If pos = 0 Then J = "" : Exit Function
  tmp = Trim(Mid(json, pos + 1))
  If Left(tmp,1) = """" Then
    tmp = Mid(tmp,2)
    If InStr(tmp, """") > 0 Then tmp = Left(tmp, InStr(tmp, """")-1)
  Else
    For i = 1 To Len(tmp)
      c = Mid(tmp, i, 1)
      If c = "," Or c = "}" Then
        tmp = Left(tmp, i - 1)
        Exit For
      End If
    Next
    tmp = Trim(tmp)
  End If
  J = tmp
End Function

qtyco_idx = J("qtyco_idx")

QTYNo     = J("QTYNo")
QTYNAME   = J("QTYNAME")
QTYcoNAME = J("QTYcoNAME")
unittype  = J("unittype_qtyco_idx")
status    = J("QTYcostatus")
kg        = J("kg")
sheet_w   = J("sheet_w")
sheet_h   = J("sheet_h")
sheet_t   = J("sheet_t")
coil_cut  = J("coil_cut")

QTYNAME_safe = Replace(QTYNAME, "'", "''")
QTYcoNAME_safe = Replace(QTYcoNAME, "'", "''")

If qtyco_idx = "" Or qtyco_idx = "0" Then

  ' 신규 PK 생성
  Set Rs = Dbcon.Execute("SELECT ISNULL(MAX(qtyco_idx),0)+1 FROM tk_qtyco")
  qtyco_idx = Rs(0)
  Rs.Close

  sql = ""
  sql = sql & "INSERT INTO tk_qtyco ("
  sql = sql & "qtyco_idx,QTYNo,QTYNAME,QTYcoNAME,"
  sql = sql & "unittype_qtyco_idx,QTYcostatus,kg,"
  sql = sql & "sheet_w,sheet_h,sheet_t,coil_cut,"
  sql = sql & "QTYcomidx,QTYcowdate,QTYcoemidx,QTYcoewdate"
  sql = sql & ") VALUES ("
  sql = sql & "'" & qtyco_idx & "','" & QTYNo & "','" & QTYNAME_safe & "','" & QTYcoNAME_safe & "',"
  sql = sql & "'" & unittype & "','" & status & "','" & kg & "',"
  sql = sql & "'" & sheet_w & "','" & sheet_h & "','" & sheet_t & "','" & coil_cut & "',"
  sql = sql & "'" & C_midx & "',GETDATE(),'" & C_midx & "',GETDATE()"
  sql = sql & ")"

Else

  sql = ""
  sql = sql & "UPDATE tk_qtyco SET "
  sql = sql & "QTYNo='" & QTYNo & "',"
  sql = sql & "QTYNAME='" & QTYNAME_safe & "',"
  sql = sql & "QTYcoNAME='" & QTYcoNAME_safe & "',"
  sql = sql & "unittype_qtyco_idx='" & unittype & "',"
  sql = sql & "QTYcostatus='" & status & "',"
  sql = sql & "kg='" & kg & "',"
  sql = sql & "sheet_w='" & sheet_w & "',"
  sql = sql & "sheet_h='" & sheet_h & "',"
  sql = sql & "sheet_t='" & sheet_t & "',"
  sql = sql & "coil_cut='" & coil_cut & "',"
  sql = sql & "QTYcoemidx='" & C_midx & "',"
  sql = sql & "QTYcoewdate=GETDATE() "
  sql = sql & "WHERE qtyco_idx='" & qtyco_idx & "'"

End If

'Response.Write sql
Dbcon.Execute sql

Response.Write "{""result"":""ok"",""qtyco_idx"":""" & qtyco_idx & """}"

call dbClose()
%>
