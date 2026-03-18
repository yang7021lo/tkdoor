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
Set Rs = Server.CreateObject("ADODB.Recordset")

raddbar = Request("addbar")
part=Request("part")

' 파일 및 폼 데이터 읽기
rTIDX         = Request("TIDX")
rT_QY         = Request("T_QY")
rT_YN         = Request("T_YN")
rT_GLASS_DOOR = Request("T_GLASS_DOOR")
rT_GLASS_FIX  = Request("T_GLASS_FIX")
rT_FW         = Request("T_FW")
rT_FH         = Request("T_FH")
rT_FL         = Request("T_FL")
rT_OP         = Request("T_OP")
rT_DFL        = Request("T_DFL")
rT_BOXFL      = Request("T_BOXFL")
rT_up         = Request("T_up")
rT_D_W        = Request("T_D_W")
rT_D_H        = Request("T_D_H")
rT_H_2        = Request("T_H_2")
rT_D_HD       = Request("T_D_HD")
rT_LR         = Request("T_LR")

rTf_YN        = Request("Tf_YN")
rTf_FW        = Request("Tf_FW")
rTf_FH        = Request("Tf_FH")
rTf_FL        = Request("Tf_FL")
rTf_OP        = Request("Tf_OP")
rTf_DFL       = Request("Tf_DFL")
rTf_BOXFL     = Request("Tf_BOXFL")
rTf_up        = Request("Tf_up")
rTf_D_W       = Request("Tf_D_W")
rTf_D_H       = Request("Tf_D_H")
rTf_H_2       = Request("Tf_H_2")
rTf_lc        = Request("Tf_lc")
rTf_LR        = Request("Tf_LR")

' 디버깅 출력
'Response.Write "rTIDX : " & rTIDX & "<br>"
'Response.Write "rT_QY : " & rT_QY & "<br>"
'Response.Write "rT_YN : " & rT_YN & "<br>"
'Response.Write "rT_GLASS_DOOR : " & rT_GLASS_DOOR & "<br>"
'Response.Write "rT_GLASS_FIX : " & rT_GLASS_FIX & "<br>"
'Response.Write "rT_FW : " & rT_FW & "<br>"
'Response.Write "rT_FH : " & rT_FH & "<br>"
'Response.Write "rT_FL : " & rT_FL & "<br>"
'Response.Write "rT_OP : " & rT_OP & "<br>"
'Response.Write "rT_DFL : " & rT_DFL & "<br>"
'Response.Write "rT_BOXFL : " & rT_BOXFL & "<br>"
'Response.Write "rT_up : " & rT_up & "<br>"
'Response.Write "rT_D_W : " & rT_D_W & "<br>"
'Response.Write "rT_D_H : " & rT_D_H & "<br>"
'Response.Write "rT_H_2 : " & rT_H_2 & "<br>"
'Response.Write "rT_D_HD : " & rT_D_HD & "<br>"
'Response.Write "rT_LR : " & rT_LR & "<br>"

'Response.Write "rTf_YN : " & rTf_YN & "<br>"
'Response.Write "rTf_FW : " & rTf_FW & "<br>"
'Response.Write "rTf_FH : " & rTf_FH & "<br>"
'Response.Write "rTf_FL : " & rTf_FL & "<br>"
'Response.Write "rTf_OP : " & rTf_OP & "<br>"
'Response.Write "rTf_DFL : " & rTf_DFL & "<br>"
'Response.Write "rTf_BOXFL : " & rTf_BOXFL & "<br>"
'Response.Write "rTf_up : " & rTf_up & "<br>"
'Response.Write "rTf_D_W : " & rTf_D_W & "<br>"
'Response.Write "rTf_D_H : " & rTf_D_H & "<br>"
'Response.Write "rTf_H_2 : " & rTf_H_2 & "<br>"
'Response.Write "rTf_lc : " & rTf_lc & "<br>"
'Response.Write "rTf_LR : " & rTf_LR & "<br>"

' 디버깅 시 사용
'Response.End

If part = "fmdel" Then
    fmdel = part


sql = "DELETE FROM TNG_T"
sql = sql & " WHERE TIDX = '" & TIDX & "' "
Response.write(SQL) & "<br>"
Dbcon.Execute(SQL)
response.write "<script>location.replace('TNG1_FRAME_A_BAJU.asp?part=fmdel&TIDX="&rTIDX&");</script>"

End If

sql = "INSERT INTO TNG_T (T_QY, T_YN, T_GLASS_DOOR, T_GLASS_FIX, T_FW"
sql = sql & ", T_FH, T_FL, T_OP, T_DFL, T_BOXFL"
sql = sql & ", T_up, T_D_W, T_D_H, T_H_2, T_D_HD, T_LR"
sql = sql & ", Tf_YN, Tf_FW, Tf_FH, Tf_FL, Tf_OP"
sql = sql & ", Tf_DFL, Tf_BOXFL, Tf_up, Tf_D_W, Tf_D_H"
sql = sql & ", Tf_H_2, Tf_lc, Tf_LR) "

sql = sql & "VALUES ('" & rT_QY & "'"
sql = sql & ", '" & rT_YN & "', '" & rT_GLASS_DOOR & "', '" & rT_GLASS_FIX & "', '" & rT_FW & "'"
sql = sql & ", '" & rT_FH & "', '" & rT_FL & "', '" & rT_OP & "', '" & rT_DFL & "', '" & rT_BOXFL & "'"
sql = sql & ", '" & rT_up & "', '" & rT_D_W & "', '" & rT_D_H & "', '" & rT_H_2 & "', '" & rT_D_HD & "', '" & rT_LR & "'"
sql = sql & ", '" & rTf_YN & "', '" & rTf_FW & "', '" & rTf_FH & "', '" & rTf_FL & "', '" & rTf_OP & "'"
sql = sql & ", '" & rTf_DFL & "', '" & rTf_BOXFL & "', '" & rTf_up & "', '" & rTf_D_W & "', '" & rTf_D_H & "'"
sql = sql & ", '" & rTf_H_2 & "', '" & rTf_lc & "', '" & rTf_LR & "')"
'Response.write(sql) & "<br>"
'Dbcon.Execute(sql)
response.write "<script>alert('입력이 완료되었습니다.');location.replace('TNG1_FRAME_A_BAJU.asp?part=balju&TIDX="&rTIDX&");</script>"


sql = "UPDATE TNG_T SET "
sql = sql & "T_QY='" & rT_QY & "', T_YN='" & rT_YN & "', T_GLASS_DOOR='" & rT_GLASS_DOOR & "', T_GLASS_FIX='" & rT_GLASS_FIX & "', "
sql = sql & "T_FW='" & rT_FW & "', T_FH='" & rT_FH & "', T_FL='" & rT_FL & "', T_OP='" & rT_OP & "', "
sql = sql & "T_DFL='" & rT_DFL & "', T_BOXFL='" & rT_BOXFL & "', T_up='" & rT_up & "', "
sql = sql & "T_D_W='" & rT_D_W & "', T_D_H='" & rT_D_H & "', T_H_2='" & rT_H_2 & "', "
sql = sql & "T_D_HD='" & rT_D_HD & "', T_LR='" & rT_LR & "', "
sql = sql & "Tf_YN='" & rTf_YN & "', Tf_FW='" & rTf_FW & "', Tf_FH='" & rTf_FH & "', Tf_FL='" & rTf_FL & "', Tf_OP='" & rTf_OP & "', "
sql = sql & "Tf_DFL='" & rTf_DFL & "', Tf_BOXFL='" & rTf_BOXFL & "', Tf_up='" & rTf_up & "', Tf_D_W='" & rTf_D_W & "', Tf_D_H='" & rTf_D_H & "', "
sql = sql & "Tf_H_2='" & rTf_H_2 & "', Tf_lc='" & rTf_lc & "', Tf_LR='" & rTf_LR & "' "
sql = sql & "WHERE TIDX=" & rTIDX & " "
'Response.write(sql) & "<br>"
'Dbcon.Execute(sql)
response.write "<script>alert('입력이 완료되었습니다.');location.replace('TNG1_FRAME_A_BAJU.asp?part=balju&TIDX="&rTIDX&");</script>"



set Rs = Nothing
call dbClose()
%>
