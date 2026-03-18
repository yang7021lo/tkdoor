<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
Response.ContentType = "application/json"

Function JsonSafe(val)
    Dim s
    s = val & ""
    s = Replace(s, "\", "\\")
    s = Replace(s, """", "\""")
    s = Replace(s, vbCrLf, "\n")
    s = Replace(s, vbCr, "\n")
    s = Replace(s, vbLf, "\n")
    s = Replace(s, vbTab, "\t")
    s = Replace(s, Chr(8), "")
    s = Replace(s, Chr(12), "")
    JsonSafe = s
End Function

Function SafeNum(val)
    If IsNull(val) Or val = "" Then
        SafeNum = 0
    Else
        SafeNum = val
    End If
End Function
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()
Set Rs = Server.CreateObject("ADODB.Recordset")
Set RsSub = Server.CreateObject("ADODB.Recordset")

' 1) 메인 리스트
SQL = "SELECT "
SQL = SQL & "ba.baidx, ba.baname, ba.bastatus, ba.bachannel, ba.bfidx, "
SQL = SQL & "ba.sharing_size, "
SQL = SQL & "CASE WHEN bf.set_name_FIX IS NOT NULL AND bf.set_name_FIX <> '' THEN bf.set_name_FIX ELSE ISNULL(bf.set_name_AUTO,'') END AS pummok, "
SQL = SQL & "CAST(ISNULL(bf.xsize,'') AS varchar) + ' X ' + CAST(ISNULL(bf.ysize,'') AS varchar) AS gyugyuk, "
SQL = SQL & "COALESCE(bf.bfimg1, bf.bfimg2, bf.bfimg3, '') AS image, "
SQL = SQL & "ISNULL(bf.sjb_idx,'') AS sjb_idx, "
SQL = SQL & "sub.final_shearing "
SQL = SQL & "FROM tk_barasi ba "
SQL = SQL & "LEFT JOIN tk_barasiF bf ON ba.bfidx = bf.bfidx "
SQL = SQL & "LEFT JOIN ("
SQL = SQL & "  SELECT baidx, MAX(accsize) AS final_shearing "
SQL = SQL & "  FROM tk_barasisub "
SQL = SQL & "  GROUP BY baidx"
SQL = SQL & ") sub ON ba.baidx = sub.baidx "
SQL = SQL & "ORDER BY ba.baidx"

Rs.Open SQL, Dbcon, 1, 1

' 2) 서브 데이터 전체 (한 번에)
SQL2 = "SELECT baidx, basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv, final "
SQL2 = SQL2 & "FROM tk_barasisub ORDER BY baidx, basidx ASC"

RsSub.Open SQL2, Dbcon, 1, 1

' 서브 데이터를 baidx별 Dictionary에 저장
Dim subData
Set subData = Server.CreateObject("Scripting.Dictionary")

Dim subBaidx, subJson, subCount, subG
subG = 0

If Not (RsSub.EOF Or RsSub.BOF) Then
    Dim curBaidx
    curBaidx = ""

    Do While Not RsSub.EOF
        subBaidx = RsSub("baidx") & ""

        If subBaidx <> curBaidx Then
            ' 이전 baidx 마무리
            If curBaidx <> "" Then
                subData(curBaidx) = subJson & "]"
            End If
            curBaidx = subBaidx
            subJson = "["
            subG = 0
        End If

        subG = subG + 1

        Dim bs_val, bd_val, x1v, y1v, x2v, y2v, ac_val, id_val, fn_val
        bs_val = SafeNum(RsSub("bassize"))
        bd_val = RsSub("basdirection") & ""
        x1v = SafeNum(RsSub("x1"))
        y1v = SafeNum(RsSub("y1"))
        x2v = SafeNum(RsSub("x2"))
        y2v = SafeNum(RsSub("y2"))
        ac_val = RsSub("accsize") & ""
        id_val = RsSub("idv") & ""
        fn_val = RsSub("final") & ""

        ' 버튼 스타일
        Dim bc
        bc = "primary"
        If id_val = "0" Then
            If subG > 1 Then bc = "primary"
        Else
            bc = "light"
        End If
        If fn_val = "0" Then bc = "danger"

        ' 텍스트 위치
        Dim txv, tyv, bjv
        bjv = 0
        If CDbl(bs_val) > 30 Then bjv = -10

        If bd_val = "1" Then
            txv = CDbl(x1v) + (CDbl(bs_val) / 2)
            tyv = CDbl(y1v) - 1
        ElseIf bd_val = "2" Then
            txv = CDbl(x1v) - 5
            tyv = CDbl(y1v) + (CDbl(bs_val) / 2) + bjv + 10
        ElseIf bd_val = "3" Then
            txv = CDbl(x1v) - (CDbl(bs_val) / 2)
            tyv = CDbl(y1v) + 5
        ElseIf bd_val = "4" Then
            txv = CDbl(x1v) + 5
            tyv = CDbl(y1v) - (CDbl(bs_val) / 2) + bjv + 10
        Else
            txv = x1v
            tyv = y1v
        End If

        ' bassize 표시
        Dim bsd
        If CDbl(bs_val) = Int(CDbl(bs_val)) Then
            bsd = FormatNumber(bs_val, 0)
        Else
            bsd = FormatNumber(bs_val, 1)
        End If

        If subG > 1 Then subJson = subJson & ","
        subJson = subJson & "{"
        subJson = subJson & """ac"":""" & JsonSafe(ac_val) & ""","
        subJson = subJson & """bc"":""" & bc & ""","
        subJson = subJson & """x1"":" & x1v & ",""y1"":" & y1v & ","
        subJson = subJson & """x2"":" & x2v & ",""y2"":" & y2v & ","
        subJson = subJson & """tx"":" & txv & ",""ty"":" & tyv & ","
        subJson = subJson & """t"":""" & JsonSafe(bsd) & """}"

        RsSub.MoveNext
    Loop

    ' 마지막 baidx 마무리
    If curBaidx <> "" Then
        subData(curBaidx) = subJson & "]"
    End If
End If

RsSub.Close

' 3) JSON 출력
Response.Write "["

Dim isFirst
isFirst = True

Do While Not Rs.EOF
    If Not isFirst Then Response.Write ","
    isFirst = False

    Dim thisBa
    thisBa = Rs("baidx") & ""

    ' sharing_size 값 결정: 0이면 final_shearing 사용
    Dim sharingVal
    sharingVal = Rs("sharing_size")
    If IsNull(sharingVal) Or sharingVal = 0 Then
        If Not IsNull(Rs("final_shearing")) And Rs("final_shearing") <> "" And Rs("final_shearing") <> 0 Then
            sharingVal = Rs("final_shearing")
        Else
            sharingVal = 0
        End If
    End If

    Response.Write "{"
    Response.Write """baidx"": " & Rs("baidx") & ", "
    Response.Write """baname"": """ & JsonSafe(Rs("baname")) & """, "
    Response.Write """bastatus"": " & Rs("bastatus") & ", "
    Response.Write """bachannel"": """ & JsonSafe(Rs("bachannel")) & """, "
    Response.Write """bfidx"": " & Rs("bfidx") & ", "
    Response.Write """pummok"": """ & JsonSafe(Rs("pummok")) & """, "
    Response.Write """gyugyuk"": """ & JsonSafe(Rs("gyugyuk")) & """, "
    Response.Write """image"": """ & JsonSafe(Rs("image")) & """, "
    Response.Write """sjb_idx"": """ & JsonSafe(Rs("sjb_idx")) & """, "
    Response.Write """sharing_size"": " & sharingVal & ", "

    ' 서브 데이터 포함
    If subData.Exists(thisBa) Then
        Response.Write """subs"": " & subData(thisBa)
    Else
        Response.Write """subs"": []"
    End If

    Response.Write "}"

    Rs.MoveNext
Loop

Response.Write "]"

Rs.Close
Set Rs = Nothing
Set RsSub = Nothing
Set subData = Nothing
call dbClose()
%>
