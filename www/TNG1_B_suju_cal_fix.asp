<!DOCTYPE html>
<html lang="en">
<head>
<%@codepage="65001" Language="vbscript"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
Session.CodePage="65001"
Response.CharSet="utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<!--#include virtual="/inc/md5.asp"-->
<%
call dbOpen()
Set RsC = Server.CreateObject ("ADODB.Recordset")
Set Rs = Server.CreateObject ("ADODB.Recordset")
Set Rs1 = Server.CreateObject ("ADODB.Recordset")
Set Rs2 = Server.CreateObject ("ADODB.Recordset")
Set Rs3 = Server.CreateObject ("ADODB.Recordset")


  if c_midx="" then 
    response.write "<script>alert('login 먼저해주세요');location.replace('/index.asp');</script>"
    response.end
  end if

rsjcidx=request("cidx")
rsjcidx=request("sjcidx")
rsjidx=request("sjidx") '수주키 TB TNG_SJA



    SQL = "SELECT a.sjcidx, b.cname,b.cgubun, b.cdlevel, b.cflevel "
    SQL = SQL & "FROM TNG_SJA a "
    SQL = SQL & "JOIN tk_customer b ON b.cidx = a.sjcidx "
    SQL = SQL & "WHERE a.sjidx = '" & rsjidx & "'"
    'Response.Write SQL & "<br>" 
    Rs1.Open SQL, Dbcon
    If Not (Rs1.BOF Or Rs1.EOF) Then
        sjcidx    = Rs1(0)
        cname     = Rs1(1)
        cgubun   = Rs1(2)
        cdlevel   = Rs1(3) ' 1=10만(기본), 2=9만, 3=11만, 4=12만, 5=소비자, 6=1000*2400
        cflevel   = Rs1(4) ' 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D, 5=10% 업
    End If
    Rs1.Close

rsjb_idx=request("sjb_idx") '수주 제품키 TB TNG_SJB
rsjb_type_no=Request("sjb_type_no") '제품타입
rsjbsub_Idx=Request("sjbsub_Idx")
rfkidx=Request("fkidx")
rfksidx=Request("fksidx")
rsjsidx=Request("sjsidx") '수주주문품목키

coat = request("coat") '코트
if coat = "" then
    coat = "0"
end if
' -------------**

rtw=Request("tw") '검측가로
rth=Request("th") '검측세로
row=Request("ow") '오픈 가로 치수
roh = Request("oh")  ' 오픈 세로 치수
rfl = Request("fl")  ' 묻힘 치수
dh_th =Request("dh_th") '도어높이_외경구하기
rmwidth=Request("mwidth") '검측가로
rmheight=Request("mheight") '검측세로
rblength=Request("blength") '바의 길이
rafksidx=Request("afksidx") '복제할 바의 키값

' -------------**

'Response.Write (rtw)&"검측가로<br>"
'Response.Write (rth)&"검측세로<br>"
'Response.Write (row)&"도어가로<br>"
'Response.Write (roh)&"도어높이<br>"
'Response.Write (rfl)&"묻힘 치수<br>"

Dim temp
temp = Trim(rtw & "")



'일괄 적용을 한 프레임이 있다면 단가만 계산하기
sql_check = ""
sql_check = sql_check & " SELECT count(*) FROM tk_framekSub "
sql_check = sql_check & " where  fkidx = '" & rfkidx & "' "
sql_check = sql_check & " and  rstatus = 1 "
Rs.open sql_check ,dbcon
hasData = False
If Not Rs.EOF Then
    If Rs(0) > 0 Then
        hasData = True
    End If
End If
Rs.Close

If IsNumeric(temp) Then

    If CLng(temp) <> 0 Then
        
        if  rtw > 0 then  '가로
            sql="update tk_framek set tw='"&rtw&"' "
            sql=sql&" where fkidx='"&rfkidx&"'  "
            ' response.write (SQL)&"<br>"
            Dbcon.Execute (SQL) 
        end if
        if  rth > 0 then  '세로
            sql="update tk_framek set th='"&rth&"' "
            sql=sql&" where fkidx='"&rfkidx&"'  "
            ' response.write (SQL)&"<br>"
            Dbcon.Execute (SQL) 
        end if
    
        if roh <> "" Then     '오픈세로
            sql="update tk_framek set oh='"&roh&"' "
            sql=sql&" where fkidx='"&rfkidx&"' "
            ' response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)  
        end if
        if rfl <> "" Then   '묻힘
            sql="update tk_framek set fl='"&rfl&"' "
            sql=sql&" where fkidx='"&rfkidx&"' "
            ' response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)  
        end if

        total_tw = 0
        total_framename = ""
        total_mheight = 0   ' 초기화
        SQL = "SELECT a.tw, a.th ,b. sjb_barlist, c.sjb_type_name  " '전체 가로 세로 합계 sja_sub 업데이트
        SQL = SQL & " FROM tk_framek  a "
        SQL = SQL & " left outer join TNG_SJB b on a.sjb_idx= b.sjb_idx "
        SQL = SQL & " left outer join tng_sjbtype c on a.sjb_type_no= c.sjb_type_no "
        SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "'"
        Response.write (SQL)&"222222<br>"
        'response.end
        Rs.open SQL, Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            Do While Not Rs.EOF

               ltw=rs(0) ' 가로
                lth=rs(1) ' 세로
                lsjb_barlist=rs(2) '바리스트
                lsjb_type_name=rs(3) '제품타입명
                'response.write "ltw + "&ltw&""
                'response.write "lth + "&lth&""
                'response.write "lsjb_barlist + "&lsjb_barlist&""
                'response.write "lsjb_type_name + "&lsjb_type_name&""
                'response.end

                If IsNumeric(ltw) Then 
                    total_tw = total_tw + ltw
                end if    

                ' 가장 큰 세로값 찾기
                If IsNumeric(lth) Then
                    If lth > total_mheight Then
                        total_mheight = lth
                    End If
                End If

                If total_framename = "" Then
                    total_framename = lsjb_type_name & "|" & lsjb_barlist
                Else
                    total_framename = total_framename & "+" & lsjb_type_name & "|" & lsjb_barlist
                End If
                
                Rs.MoveNext
            Loop
        End If
    Rs.Close
           
    sql="update tng_sjaSub set mwidth='"&total_tw&"' , mheight='"&total_mheight&"' , framename='"&total_framename&"'  "
    SQL=SQL&" Where sjsidx='"&rsjsidx&"' " 
    'Response.write (SQL)&"<br>"
    'response.end
    Dbcon.Execute (SQL)



' ---------------**
    ' 세로바의 x,y size
    SQL = "SELECT xi, ysize, xsize, whichi_fix " _
    &"FROM tk_framekSub " _
    & "WHERE fkidx = '"&rfkidx&"' AND garo_sero = 1 AND whichi_fix = 6"

        Rs1.Open SQL, Dbcon, 1, 1

        If Not (Rs1.BOF Or Rs1.EOF) Then
        
            Do While Not Rs1.EOF
                col_xi_val  = Rs1("xi")
                colBarXSize = Rs1("xsize")
                colBarYSize = Rs1("ysize")

                'Response.Write "(colysize : " & colBarYSize & ",xsize : " & colBarXSize & ")"
                'response.end
                Rs1.MoveNext
            Loop

        End If
            Rs1.Close

    ' 가로바의 길이


sql = "SELECT ysize, COUNT(ysize) AS count_y_size " & _
      "FROM tk_framekSub " & _
      "WHERE fkidx = '" & rfkidx & "' AND garo_sero = 0 AND whichi_fix = 1 " & _
      "GROUP BY ysize"

Rs1.Open sql, Dbcon, 1, 1

If Not (Rs1.BOF Or Rs1.EOF) Then
    Do While Not Rs1.EOF
        
        rowYsize        = Rs1("ysize")
        countRowBar = Rs1("count_y_size")

        'Response.Write "ysize=" & rowYsize & ", count=" & countRowBar & "<br>"
        'response.end
        Rs1.MoveNext
    Loop
End If

Rs1.Close

    ' 중간바의 길이


sql = "SELECT ysize, COUNT(ysize) AS count_y_size " & _
      "FROM tk_framekSub " & _
      "WHERE fkidx = '" & rfkidx & "' AND garo_sero = 0 AND whichi_fix = 3 " & _
      "GROUP BY ysize"

Rs1.Open sql, Dbcon, 1, 1

If Not (Rs1.BOF Or Rs1.EOF) Then
    Do While Not Rs1.EOF
        
        middleYsize        = Rs1("ysize")
        countMiddleBar = Rs1("count_y_size")

        'Response.Write "ysize=" & middleYsize & ", count=" & countMiddleBar & "<br>"

        Rs1.MoveNext
    Loop
End If

Rs1.Close


   ' 하단 유리 크기 구하기
    SQL = "SELECT xi, ysize, xsize, whichi_fix " _
    &"FROM tk_framekSub " _
    & "WHERE fkidx = '"&rfkidx&"' AND garo_sero = 0 AND whichi_fix = 5"

    Rs1.Open SQL, Dbcon, 1, 1

        If Not (Rs1.BOF Or Rs1.EOF) Then
        
            Do While Not Rs1.EOF
                glassSize = 0

                xi_val        = Rs1("xi")
                underBarXSizeForGlass = Rs1("xsize")
                underBarYSizeForGlass = Rs1("ysize")

                'Response.Write "(ysize : " & underBarYSizeForGlass & ",xsize : " & underBarXSizeForGlass & ")"

                glassBlength = (roh - underBarYSizeForGlass - rfl)
                'Response.Write glassBlength & " 유리 사이즈 blength<br>"

                Rs1.MoveNext
            Loop

        End If

    Rs1.Close

' ---------------**상부전체유리의 갯수

    SQL = "SELECT COUNT(*) AS cntGlass " _
    & "FROM tk_framekSub " _
    & "WHERE fkidx = '" & rfkidx & "' AND (gls = 4 or gls = 3)"
    response.write (SQL)&"<br>"
    'Set Rs = Server.CreateObject("ADODB.Recordset")
    Rs.Open SQL, Dbcon, 1, 1

        If Not (Rs.EOF Or Rs.BOF) Then
            fullUpCountGlass = Rs("cntGlass")
            'Response.Write(fullUpCountGlass)&" 상부전체유리갯수<br>"
        Else
            countGlass = 0
        End If

    Rs.Close

' ---------------가로바 갯수 & 상단 유리 크기 계산

    SQL = "SELECT COUNT(*) " _
    & "FROM tk_framekSub " _
    & "WHERE fkidx = '" & rfkidx & "' " _
    & "AND garo_sero = 0 " _
    & "AND yi = (SELECT MIN(yi) FROM tk_framekSub " _
    & "WHERE fkidx = '" & rfkidx & "' AND whichi_fix = 1)"
    
    

    'Set Rs = Server.CreateObject("ADODB.Recordset")
    Rs.Open SQL, Dbcon, 1, 1

        If Not (Rs.EOF Or Rs.BOF) Then
            countRow = Rs(0)
            Response.Write(countRow)&"가로바 갯수<br>"
        Else
            countRow = 0
        End If
        'response.end

        calGlassBLength1 = ((countRowBar * rowYsize) + (countMiddleBar*middleYsize) )/countRow     
        calGlassBLength2 = rth - roh - calGlassBLength1
        upCountGlass = fullUpCountGlass/countRow
        calGlassBLength = calGlassBLength2/upCountGlass

        'Response.Write(rth)&"<br>"
        'Response.Write(roh)&"<br>"
        'Response.Write(((countRowBar * rowYsize) + (countMiddleBar*middleYsize) )/countRow   )&"<br>"
        'Response.Write(fullUpCountGlass)&"상단 유리 크기<br>"
        'response.end


    Rs.Close

' ---------------세로바 갯수 & 가로바의 길이

    SQL = "SELECT COUNT(*) " _
    & "FROM tk_framekSub " _
    & "WHERE fkidx = '" & rfkidx & "' " _
    & "AND garo_sero = 1 " _
    & "AND yi = (SELECT MIN(yi) FROM tk_framekSub " _
    & "WHERE fkidx = '" & rfkidx & "' AND whichi_fix = 1)"

    
    Rs.Open SQL, Dbcon, 1, 1

        If Not (Rs.EOF Or Rs.BOF) Then
            countHight = Rs(0)
            'Response.Write(countHight)&"세로바 갯수<br>"
            'Response.Write(rtw)&"rtw<br>"
            'Response.Write(colBarYSize)&"colBarYSize<br>"
            'Response.Write(countRow)&"countRow<br>"
            'response.end
            calBarLength = (rtw - (countHight * colBarYSize)) / countRow
            'Response.Write(calBarLength)&"하나당 가로바 길이<br>"
            'Response.Write(barLength) &" 바 마다 길이 <br>"
             

        Else
            countHight = 0
        End If

    Rs.Close


'도어높이 계산 시작
'=======================================

        SQL="Select A.greem_o_type , A.th, B.whichi_fix, B.whichi_auto, C.xsize, C.ysize, A.oh, a.ow, A.fl , A.greem_fix_type "
        SQL=SQL&" From tk_framek A "
        SQL=SQL&" Left Outer Join tk_framekSub B On A.fkidx = B.fkidx  "
        SQL=SQL&" Left Outer Join tk_barasiF C On B.bfidx = C.bfidx "
        SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"1111<br>"
        Rs.open SQL, Dbcon
        If Not (Rs.bof or Rs.eof) Then 
            Do while not Rs.EOF

            qgreem_o_type = Rs(0)
            qth = Rs(1)
            qwhichi_fix = Rs(2)
            qwhichi_auto = Rs(3)
            qxsize = Rs(4)
            qysize = Rs(5) '박스높이 ' 롯트바 높이
            qoh = Rs(6) 
            qow = Rs(7)
            qfl = Rs(8)
            qgreem_fix_type = Rs(9)
                ' 자동 기준 계산 (whichi_auto)
                If qwhichi_auto = 1 Then
                    If qgreem_o_type = 1 Or qgreem_o_type = 4 Then  ' 편개 양개
                        If Not IsNull(qth) And Not IsNull(qysize) Then
                            box_ysize=qysize
                            door_high = qth - box_ysize - qfl

                            '========================================================
                            ' 도어높이 역산 (수동입력 dh_th → th 구하기)
                            '========================================================
                            If Not IsNull(Request("dh_th")) And Trim(Request("dh_th")) <> "" Then

                                roh = CLng(Request("dh_th"))   ' 사용자가 입력한 도어높이
                                th  = 0

                                ' 박스높이, 묻힘값(fl)은 정방향 계산에서 이미 얻은 값 사용
                                ' (qysize = box_ysize, qfl = fl)
                                th = roh + box_ysize + qfl

                                ' DB 업데이트
                                sql = "UPDATE tk_framek SET th='" & th & "', oh='" & roh & "' WHERE fkidx='" & rfkidx & "'"
                                Dbcon.Execute(sql)

                                'Response.Write "수동 roh=" & roh & " → th=" & th & "<br>"
                            End If
                            '========================================================

                        End If
                    Else ' 남마타입들
                        door_high = qoh
                    End If
                End If

                If (qgreem_o_type = 1 Or qgreem_o_type = 2 Or qgreem_o_type = 3) Then   ' 편개 
                    qow_single = qow
                Else '  양개
                    qow_double = qow /2 
                    qow_double = Int(qow_double)'반내림
                End If
            Rs.MoveNext
        Loop
        End If
        Rs.close

        if door_high > 0 then
            sql="update tk_framek set oh='"&door_high&"' "
            sql=sql&" where fkidx='"&rfkidx&"' "
            'response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)  
        roh=door_high   
        end if

'=======================================
'도어높이 계산 끝
'=======================================

' 일괄 적용이 된 경우 단가만 계산
 if not (hasData) Then  
    ' ---------------** update
    calBarLength = fix(calBarLength)
    rth = fix(rth)
    glassBlength = fix(glassBlength)
    calGlassBLength = fix(calGlassBLength)

    SQL = "UPDATE tk_framekSub SET blength = " & calBarLength _
    & " WHERE fkidx = '" & rfkidx & "' AND gls = 0 and garo_sero = 0"
    response.write (SQL)&"<br>"
    Dbcon.Execute(SQL)

    SQL = "UPDATE tk_framekSub SET blength = " & rth _
    & " WHERE fkidx = '" & rfkidx & "' AND gls = 0 and garo_sero = 1"
    response.write (SQL)&"<br>"
    Dbcon.Execute(SQL)

    '   SQL = "UPDATE tk_framekSub SET alength = " & calBarLength _
    '   & " WHERE fkidx = '" & rfkidx & "' AND gls != 0"
    '   response.write (SQL)&"<br>"
    '   Dbcon.Execute(SQL)

    '   SQL = "UPDATE tk_framekSub SET blength = " & calGlassBLength _
    '   & " WHERE fkidx = '" & rfkidx & "' AND gls = 3"
    '   response.write (SQL)&"<br>"
    '   Dbcon.Execute(SQL)

    '   SQL = "UPDATE tk_framekSub SET blength = " & calGlassBLength _
    '   & " WHERE fkidx = '" & rfkidx & "' AND gls = 4"
    '   response.write (SQL)&"<br>"
    '   Dbcon.Execute(SQL)

    end if
    response.write "roh : "&roh&""
    'response.end
    ' ---------------수동 도어 계산값
End if

'---------------세로바 사이마다 있는 자재들 가로길이 값 구하기
 ' ===============================
'   가로 & 세로 계산 최종 통합본
' ===============================

    Set RsL = Server.CreateObject("ADODB.Recordset")

    Function IsBottomPart(v)
        IsBottomPart = (v = 5 OR v = 12 OR v = 13 OR v = 14 OR v = 15 OR v = 19)
    End Function

    ' ===== 긴 가로바 길이 =====
    SQL = "SELECT TOP 1 blength FROM tk_framekSub WHERE fkidx='" & rfkidx & "' AND whichi_fix=1 ORDER BY blength DESC"
    RsL.Open SQL, Dbcon, 1, 1
    longBarLength = CLng("" & RsL("blength"))
    RsL.Close

    Response.Write "<b>긴 가로바 blength : " & longBarLength & "</b><br><br>"

    ' ===== 전체 데이터 로딩 =====
    SQL = "SELECT fksidx, whichi_fix, xi, yi, ysize, blength, alength FROM tk_framekSub WHERE fkidx='" & rfkidx & "' ORDER BY xi ASC"
    Rs.Open SQL, Dbcon, 1, 1
    'response.write (SQL)&"<br>"
    cnt = 0
    Do While Not Rs.EOF
        ReDim Preserve allArr(cnt)
        Set allArr(cnt) = CreateObject("Scripting.Dictionary")

        allArr(cnt)("fksidx")     = CLng("" & Rs("fksidx"))
        allArr(cnt)("whichi_fix") = CLng("" & Rs("whichi_fix"))
        allArr(cnt)("xi")         = CLng("" & Rs("xi"))
        allArr(cnt)("yi")         = CLng("" & Rs("yi"))
        allArr(cnt)("ysize")      = CLng("" & Rs("ysize"))
        allArr(cnt)("blength")    = CLng("" & Rs("blength"))
        cnt = cnt + 1
        '   Response.Write "DEBUG yi=" & Rs("yi") & "<br>"
        Rs.MoveNext
    Loop
    Rs.Close


    ' ===== 긴 세로바 추출 =====
    xiCount = 0
    For i = 0 To cnt - 1
        If allArr(i)("whichi_fix") = 6 AND allArr(i)("blength") = rth Then
            ReDim Preserve xiArr(xiCount)
            xiArr(xiCount) = allArr(i)("xi")
            xiCount = xiCount + 1
        End If
    Next
    '   Response.Write "<b>긴 세로바 개수 : " & xiCount & "</b><br><br>"

    If xiCount < 2 Then 
    else
    prevXi = xiArr(0)

    For i = 1 To xiCount - 1
        nextXi = xiArr(i)
        '   Response.Write "<b>1차 구간 : " & prevXi & " ~ " & nextXi & "</b><br>"

        splitCnt = 0
        ReDim splitArr(splitCnt)
        splitArr(splitCnt) = prevXi
        splitCnt = splitCnt + 1

        For j = 0 To cnt - 1
            If allArr(j)("whichi_fix") = 6 AND allArr(j)("blength") < rth Then
                If allArr(j)("xi") > prevXi AND allArr(j)("xi") < nextXi Then
                    ReDim Preserve splitArr(splitCnt)
                    splitArr(splitCnt) = allArr(j)("xi")
                    splitCnt = splitCnt + 1
                End If
            End If
        Next

        ReDim Preserve splitArr(splitCnt)
        splitArr(splitCnt) = nextXi
        splitCnt = splitCnt + 1

    
        ' ===== 긴구간에 도어 유리(12,13) 존재 여부 체크 =====
        hasDoor = False
        For p = 0 To cnt - 1
            If allArr(p)("xi") > prevXi AND allArr(p)("xi") < nextXi Then
            Response.Write "whichi_fix : "&allArr(p)("whichi_fix")&"<br>"
                If allArr(p)("whichi_fix") = 12 OR allArr(p)("whichi_fix") = 13 Then   
                    hasDoor = True
                    Exit For
                End If
            End If
        Next

        ' ====== 세부구간 계산 ======
        For j = 0 To splitCnt - 2
            subPrevXi = splitArr(j)
            subNextXi = splitArr(j+1)

            ' 작은 세로바 ysize 합산
            seroYsizeSum = 0
            For p = 0 To cnt - 1
                If allArr(p)("whichi_fix") = 6 AND allArr(p)("blength") < rth Then
                    If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then
                        seroYsizeSum = seroYsizeSum + allArr(p)("ysize")
                    End If
                End If
            Next

            ' ===== calcLength 계산 =====
            calcLength = (CDbl(longBarLength) - CDbl(seroYsizeSum)) * CDbl(subNextXi - subPrevXi) / CDbl(nextXi - prevXi)
            If calcLength < 0 Then calcLength = 0

            

            segWidth = subNextXi - subPrevXi
            bayWidth = nextXi - prevXi

            panelCount = 0
            For p = 0 To cnt - 1
                If IsBottomPart(allArr(p)("whichi_fix")) Then
                    If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then
                        panelCount = panelCount + 1
                    End If
                End If
            Next

            ' ===== 작은 세로바 개수 =====
            smallCount = 0
            For p = 0 To cnt - 1
                If allArr(p)("whichi_fix") = 6 AND allArr(p)("blength") < rth Then
                    If allArr(p)("xi") >= subPrevXi AND allArr(p)("xi") <= subNextXi Then
                        smallCount = smallCount + 1
                    End If
                End If
            'response.write "-- 위치픽스:" & allArr(p)("whichi_fix") & _
               '            " / 총길이:" & rth & _
              '             " / xi좌표:" & allArr(p)("xi") & _
               '               " / subPrevXi:" & subPrevXi & _
               '               " / subNextXi:" & subNextXi & _
               '               " / 작은 세로바 개수:" & smallCount & _
               '               " / 길이:" & allArr(p)("blength") &  "<br>"  
            Next

            'Response.Write "-- 세부구간:" & subPrevXi & "~" & subNextXi & _
             '          " / 작은세로바합:" & seroYsizeSum & _
              '          " / 작은 세로바 개수:" & smallCount & _
               '         " / calcLength:" & Fix(calcLength) & "<br>"
                        
            ' ===== 가로 perLen 계산 =====
            If smallCount > 0 Then
                perLen = Fix((calBarLength - (smallCount * 45)) / 2)
            Else
                perLen = Fix(calBarLength / 2)
            End If
            
            'response.write "-- perLen:" & perLen & "<br>"


            ' ================
            ' ★ blength 계산
            ' ================
            hbarYsize = 0
            For p = 0 To cnt - 1
                If allArr(p)("whichi_fix") = 5 Then
                    If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then
                        hbarYsize = hbarYsize + CLng(allArr(p)("ysize"))
                    End If
                End If
                '도어 높이 가로바 사이즈 뺴기
                If allArr(p)("whichi_fix") = 1 Then
                    If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then
                        hbarYsize = hbarYsize + CLng(allArr(p)("ysize"))
                    End If
                End If
            Next
        
            If hasDoor Then
                ' 도어가 있는 구간 → 도어 높이 방식 적용
                doorHeight = CLng(roh) - hbarYsize - rfl
            Else
                ' 도어 없는 구간 → 전체 높이 rth 기준
                doorHeight = CLng(rth) - hbarYsize - rfl
            End If
           
            If doorHeight < 0 Then doorHeight = 0

            panelBreakY = 0
            panelCount = 0

            For p = 0 To cnt - 1
                partType = allArr(p)("whichi_fix")

                If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then
                    If (partType = 1 OR partType = 4 OR partType = 22 OR partType = 14 OR partType = 3) Then
                        panelBreakY = panelBreakY + CLng(allArr(p)("ysize"))
                        
                    End If
                    If (partType = 16 OR partType = 23) Then
                        panelCount = panelCount + 1
                    End If
                End If
                'Response.Write "-- panelBreakY:" & panelBreakY  & _
                 '               "-- 위치픽스:" & allArr(p)("whichi_fix") & _
                  '               " / ysize:" & CLng(allArr(p)("ysize")) & "<br>"
            Next

            availableHeight = CLng(rth) - CLng(roh) - panelBreakY - CLng(rfl)  'rfl는 묻힘       
            If availableHeight < 0 Then availableHeight = 0

            If panelCount > 0 Then
                panelHeight = Fix(availableHeight / panelCount)
            Else
                panelHeight = 0
            End If

            '   Response.Write "-- 패널계산: panelBreakY=" & panelBreakY & _
            '                   " / availableHeight=" & availableHeight & _
            '                   " / panelCount=" & panelCount & _
            '                   " / panelHeight=" & panelHeight & "<br>"


            ' ===== UPDATE blength =====
            For p = 0 To cnt - 1
                partType = allArr(p)("whichi_fix")
                fksidx = allArr(p)("fksidx")

                If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then

                    If (partType = 12 OR partType = 13 OR partType = 14 OR partType = 19) Then
                        SQL = "UPDATE tk_framekSub SET blength=" & doorHeight & " WHERE fksidx=" & fksidx
                        Dbcon.Execute SQL

                    ElseIf (partType = 16 OR partType = 23) Then
                        SQL = "UPDATE tk_framekSub SET blength=" & panelHeight & " WHERE fksidx=" & fksidx
                        Dbcon.Execute SQL

                    End If
                End If
            Next


            ' ========================
            ' segYi 계산 (층 구분)
            ' ========================
            segYi = -999999
            For p = 0 To cnt - 1
                If allArr(p)("whichi_fix") = 6 and allArr(p)("blength") <> rth Then
                    If allArr(p)("xi") >= subPrevXi AND allArr(p)("xi") <= subNextXi Then
                        If CLng(allArr(p)("yi")) > segYi Then segYi = CLng(allArr(p)("yi"))
                    End If
                End If
                // response.write "Xi : " &allArr(p)("xi")& "<br>"
                // response.write "subPrevXi : " &subPrevXi& "<br>"
                // response.write "subNextXi : " &subNextXi& "<br>"
                // response.write "segYi : " &segYi& "<br>"
            Next
            If segYi = -999999 Then segYi = 0
            // Response.Write "-- 기준세로 segYi=" & segYi & "<br>"


            ' ========================
            ' ALength 업데이트
            ' ========================
            For p = 0 To cnt - 1
                partType = allArr(p)("whichi_fix")
                fksidx = allArr(p)("fksidx")
                SQL = ""

                If allArr(p)("xi") > subPrevXi AND allArr(p)("xi") < subNextXi Then
                    'response.write "partType1 : " &partType& "<br>"
                    If partType = 1 Then ' 일반 가로바
                        yiVal = CLng(allArr(p)("yi"))
                         'response.write "yiVal : " &yiVal& "<br>"
                         'response.write "segYi : " &segYi& "<br>"
                        If yiVal < segYi or segYi = 0 Then
                            SQL = "UPDATE tk_framekSub SET blength=" & calBarLength & " WHERE fksidx=" & fksidx
                            'response.write "calBarLength : " &calBarLength& "<br>"
                        Else
                            SQL = "UPDATE tk_framekSub SET blength=" & perLen & " WHERE fksidx=" & fksidx
                            'response.write "perLen : " &perLen& "<br>"
                        End If

                    ElseIf (partType = 4 OR partType = 21 OR partType = 22 OR partType = 16 OR partType = 23) Then
                        SQL = "UPDATE tk_framekSub SET alength=" & calBarLength & " WHERE fksidx=" & fksidx
                        response.write "partType2 : " &partType& "<br>"
                        response.write "calBarLength : " &calBarLength& "<br>"

                    ElseIf partType = 5 Then
                        yiVal = CLng(allArr(p)("yi"))
                        If yiVal < segYi or segYi = 0 Then
                            SQL = "UPDATE tk_framekSub SET blength=" & calBarLength & " WHERE fksidx=" & fksidx
                            'response.write "calBarLength5 : " &calBarLength& "<br>"
                        Else
                            SQL = "UPDATE tk_framekSub SET blength=" & perLen & " WHERE fksidx=" & fksidx
                            'response.write "perLen5 : " &perLen& "<br>"
                        End If

                    '수동 픽스유리 가로 길이와 높이가 알맞게 들어갈수 있게 업데이트'
                    ElseIf partType = 14 Then
                       
                       if not (roh = 0) Then 
                            '도어높이 - 가로바 세로길이 1개'
                            '가로바 세로길이 가져오기'
                            SQL_xi = "SELECT Top 1 ysize from tk_framekSub where fkidx='"&rfkidx&"' and whichi_fix = 5 "
                            Rs2.open SQL_xi, Dbcon    
                            If Not (Rs2.EOF) Then 
                                xi_ysize=Rs2(0)
                            End if
                            Rs2.close
                            yoh = roh - xi_ysize
                            SQL = "UPDATE tk_framekSub SET alength=" & calBarLength & ", blength = '" & yoh &"' WHERE fksidx=" & fksidx 
                       Else 
                            '도어 높이 구하기
                            
                            SQL = "UPDATE tk_framekSub SET alength=" & calBarLength & " WHERE fksidx=" & fksidx 
                       
                       
                       End if
                       
                      

                    ElseIf partType <> 6 Then
                        SQL = "UPDATE tk_framekSub SET alength=" & perLen & " WHERE fksidx=" & fksidx
                        response.write "partType3 : " &partType& "<br>"
                        response.write "perLen : " &perLen& "<br>"
                    End If

                    If SQL <> "" Then Dbcon.Execute SQL
                End If
            Next

        Next

        prevXi = nextXi
    Next
    end If
    ' -----------------------------
'response.end
end if
        
'=========================================
' 스텐 미터당단가계산 시작

    SQL = "SELECT qtyidx, quan , pidx "
    SQL = SQL & " FROM tng_sjaSub  "
    SQL = SQL & " WHERE sjidx = '" & rsjidx & "' AND sjsidx = '" & rsjsidx & "'"
    // response.write (SQL)&"<br>"
    'response.end
    Rs.open Sql,Dbcon
    If Not (Rs.EOF Or Rs.BOF) Then

        rqtyidx        = Rs(0)   ' 재질
        rquan       = Rs(1)   ' 수량
        rpidx        = Rs(2)   ' 페인트 pidx

    End If
    Rs.Close

    If rqtyidx = 5 Then 
        'rpidx = 0
    end if

    If rqtyidx = 7 Then 
        rqtyidx = 3
    end if

    '=================수량 가져오기
    SQL = "SELECT a.quan FROM tng_sjasub a JOIN tk_framek b ON a.sjsidx = b.sjsidx where fkidx = '" & rfkidx & "' "
    'Response.write (SQL)&"<br>"
    'response.end
    Rs1.open Sql,Dbcon
    If Not (Rs1.bof or Rs1.eof) Then
     
        yquan=rs1(0) '수량

    End If
    Rs1.Close '2

    SQL="select A.fksidx "
    SQL=SQL&" , A.bfidx, B.pcent "
    SQL=SQL&" , A.blength, A.unitprice, A.sprice, A.whichi_fix, A.whichi_auto "
    SQL=SQL&" , A.door_price, A.doorsizechuga_price "
    SQL=SQL&" From tk_framekSub A "
    SQL=SQL&" Join tk_barasiF B On A.bfidx=B.bfidx "
    SQL=SQL&" Where A.fkidx='"&rfkidx&"' "
    SQL=SQL&" and A.whichi_auto not in (11,20) " '11번 기타 20번 하부레일
    SQL=SQL&" and A.sunstatus not in (1,5,6) "

    'sunstatus=1 은 픽스하부유리 위에 상부픽스 
    'sunstatus=2 은 도어위에 상부남마 에 , 그리고 양개 좌우에 
    'sunstatus=3 은 하부픽스위에 상부남마 에
    'sunstatus=4 은 양개 중앙에
    'sunstatus=5 은 t형_자동홈바
    'sunstatus=6 은 박스커버
    'sunstatus=7 은 마구리
    'Response.write (SQL)&"<br>"
    'response.end
    Rs.open Sql,Dbcon
    If Not (Rs.bof or Rs.eof) Then 
    Do while not Rs.EOF

    bfksidx=Rs(0)
    bbfidx=Rs(1)
    bpcent=Rs(2)
    bblength=Rs(3)
    bunitprice=Rs(4)
    bsprice=Rs(5)
    bwhichi_fix=Rs(6)
    bwhichi_auto=Rs(7)
    bdoor_price=Rs(8)
    bdoorsizechuga_price=Rs(9)

        If bwhichi_fix > 0 Then
            SQL1="Select unittype_bfwidx from tng_whichitype where whichi_fix='"&bwhichi_fix&"'" 
        ElseIf bwhichi_auto > 0 Then
            SQL1="Select unittype_bfwidx from tng_whichitype where whichi_auto='"&bwhichi_auto&"'" 
        End If    
            'Response.write (SQL)&"<br>" 
            Rs1.open Sql1,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                unittype_bfwidx=Rs1(0)
            End If
        Rs1.Close
        'Response.Write "rqtyidx : " & rqtyidx & "<br>"   
        SQL = "SELECT TOP 1 B.qtyco_idx , b.unittype_qtyco_idx " 
        SQL = SQL & "FROM tk_qty A "
        SQL = SQL & "JOIN tk_qtyco B ON A.QTYNo = B.QTYNo "
        SQL = SQL & "WHERE A.qtyidx = '" & rqtyidx & "' "
        'SQL = SQL & "AND (B.sheet_t = 0 OR B.sheet_h >= " & bblength & ") "
        'SQL = SQL & "ORDER BY B.sheet_h ASC "
        'Response.write (SQL)&"<br><br>"
        'response.end
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            qtyco_idx=Rs1(0)
            unittype_qtyco_idx=Rs1(1)
        End If
        Rs1.Close
        'Response.Write "rsjb_idx : " & rsjb_idx & "<br>"    
            original_rqtyidx = rqtyidx  ' rqtyidx가 15일 경우, 임시로 30으로 변경
            if rqtyidx = 15 then
            rqtyidx=30
            end if  
                'SQL="Select price From tng_unitprice_F Where sjb_idx='"&rsjb_idx&"' and qtyidx='"&rqtyidx&"' and bfwidx='"&bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                SQL="Select price From tng_unitprice_t Where sjb_idx='"&rsjb_idx&"' and unittype_qtyco_idx='"&unittype_qtyco_idx&"' and unittype_bfwidx='"&unittype_bfwidx&"'  " '알미늄블랙 5 실버15 기타도장30
                'Response.write (SQL)&"<br>"
                'response.end
                Rs1.open Sql,Dbcon
                If Not (Rs1.bof or Rs1.eof) Then 
                    unitprice=Rs1(0)
                    'response.write "단가:"&unitprice&"<br>"
                End If
                Rs1.Close '2
            rqtyidx = original_rqtyidx ' rqtyidx 원래 값으로 복원
            'Response.Write "bwhichi_auto : " & bwhichi_auto & "<br>"
            'Response.Write "bfksidx : " & bfksidx & "<br>"
            'Response.Write "unitprice : " & unitprice & "<br>"
            'Response.Write "bpcent : " & bpcent & "<br>"  
            'Response.Write "bblength : " & bblength & "<br>"  
            'Response.Write "rpidx : " & rpidx & "<br>"  
            'Response.Write "rqtyidx : " & rqtyidx & "<br>"  
            
            If IsNumeric(rpidx) Then
                if rpidx > 0 and ( rqtyidx = 1 or rqtyidx = 3 or rqtyidx = 37  )then '도장비 추가 ' 추후 3코딩 추가해야함 rpidx로 구분
                    if coat=0 or coat = 1 then '기본 2코딩
                        sprice = unitprice * bpcent * bblength / 1000 * 1.3 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    else coat=2  '3코딩
                        sprice = unitprice * bpcent * bblength / 1000 * 1.5 '할증적용 가격 blength
                        sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                    end if  
                elseif rpidx > 0 and ( rqtyidx = 15 or rqtyidx = 30  ) and coat = 2 then ''3코트일 경우( 알미늄에 )

                    sprice = unitprice * bpcent * bblength / 1000 * 1.2 '할증적용 가격 blength
                    sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                   
                else
                    sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                    sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
                end if
            Else
                sprice = unitprice * bpcent * bblength / 1000 '할증적용 가격 blength
                sprice = -Int(-sprice / 1000) * 1000 '무조건 천 단위로 올림
            End If
            '====롯트바 8000원 추가비용 받기
            if zsjb_type_no=6 or zsjb_type_no=7 then '6=일반 al프레임 , 7=단열 al프레임 
                if bwhichi_fix=4 then '4=롯트바 22번 박스라인은 롯트바 가공안됨
                    sprice=sprice+8000
                end if
            end if

            SQL="Update tk_framekSub  "
            SQL=SQL&" Set unitprice='"&unitprice&"', pcent='"&bpcent&"', sprice='"&sprice&"' "
            SQL=SQL&" Where fksidx='"&bfksidx&"' "  'bfksidx<---------------
            'Response.write (SQL)&"<br>"
            Dbcon.Execute (SQL)
                    
    Rs.MoveNext
    Loop
    End If
    Rs.close
    

       ' 설정 품목 가격 등록 --------------------tk_framekSub 합계금액인데 부속자재는 뺴고
        SQL = "SELECT SUM(sprice) "
        SQL = SQL & "FROM tk_framekSub "
        SQL = SQL & "WHERE fkidx IN (SELECT fkidx FROM tk_framek WHERE fkidx='" & rfkidx & "') "
        SQL = SQL & "AND busok = 0 "
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
            If Not (Rs1.bof or Rs1.eof) Then 
                sjsprice=Rs1(0)
            End If
            Rs1.Close'1

        sql="select SUM(door_price) from tk_frameksub "
        sql=sql&" where fkidx='"&rfkidx&"' "
        sql=sql&" and doortype in (1,2) " '도어 타입 (1:편개, 2:양개) 
        'Response.write (SQL)&"<br>"
        Rs1.open Sql,Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
            bdoor_price=Rs1(0)
            If IsNull(bdoor_price) Then
                'Response.Write "<script>alert('❗ 도어 단가를 설정해주세요.'); history.back();</script>"
                'Response.End
            End If
        End If
        Rs1.Close 

        sjsprice_total = -Int(-sjsprice / 1000) * 1000 '무조건 천 단위로 올림

        



        'Response.Write "sjsprice_total : " & sjsprice_total & "<br>"   
        'Response.Write "py_chuga : " & py_chuga & "<br>"   
        'Response.Write "bdoor_price : " & bdoor_price & "<br>"
        '======= 0=기본 1=A (수동,자동 전체 10% 디씨), 2=B(수동만 10% 디씨), 3=C(자동만 10% 디씨), 4=D 10% 업 , 5=E=======
        '======= cflevel 분기 =======
        disrate = 0  '할인율 초기화 (기본값: 100% 즉, 할인 없음)

        Select Case cflevel
            Case 0
                disrate = 0  ' 할인 없음

            Case 1
                disrate = 10 ' 무조건 10% 할인

            Case 2
                If rsjb_type_no = 11 Or rsjb_type_no = 12 Then
                    disrate = 10 ' 수동 스텐 보급만 10% 할인
                End If

            Case 3
                If rsjb_type_no = 1 Or rsjb_type_no = 2 Or rsjb_type_no = 3 Or rsjb_type_no = 4 Or rsjb_type_no = 8 Or rsjb_type_no = 9 Then
                    disrate = 10 ' 자동만 10% 할인 이중하고 포켓 슬림 제외
                End If

            Case 4
                disrate = -10 ' 10% 증가 (업)
        End Select

        '--- 기본 금액 계산 ---
        sjsprice_update = sjsprice_total * yquan '총 원가 (수량 반영)

        If disrate > 0 Then
            '할인
            disprice = sjsprice_total * (disrate / 100)
            disprice_update = ( Int(disprice / 1000) * 1000 ) * yquan
            fprice = sjsprice_update - disprice_update

        ElseIf disrate < 0 Then
            '업 (disrate는 음수라서 절대값으로 변환)
            disprice = sjsprice_total * (Abs(disrate) / 100)
            disprice_update = ( -Int(-disprice / 1000) * 1000 ) * yquan
            fprice = sjsprice_update + disprice_update

        Else
            '변동 없음
            disprice = 0
            disprice_update = 0
            fprice = sjsprice_update
        End If    

        '--- 부가세 ---
        taxrate = fprice * 0.1
        if taxrate < 0 then
            taxrate = Round(taxrate)
        end if

        '--- 최종 합계 ---
        sprice = fprice + taxrate
        If sprice = 0 Or IsNull(sprice) Then
            sprice = 0
        End If
        
        'Response.Write "cflevel : " & cflevel & "<br>"  
        'Response.Write "disrate : " & disrate & "<br>"  
        'Response.Write "sjsprice : " & sjsprice & "<br>"   
        'Response.Write "sprice : " & sprice & "<br>"   
        'Response.Write "taxrate : " & taxrate & "<br>"  
        'sjsprice = 원가 수량 곱하기 전
        'disprice 수량 곱한 할인금액
        'fprice 수량 곱한 프레임 금액(할인적용된것)
        SQL="Update tk_framek set sjsprice='"&sjsprice_total&"', disrate='"&disrate&"',disprice='"&disprice_update&"', fprice='"&fprice&"', quan='"&yquan&"' "
        SQL=SQL&" , taxrate='"&taxrate&"', sprice='"&sprice&"', py_chuga='"&py_chuga&"' "
        SQL=SQL&" Where fkidx='"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL) 

' 스텐 미터당단가계산  끝
'=========================================



'==============마지막 계산 final_cal
if rfkidx<>"" then  

    '=================tk_framek 도어업데이트 시작
        SQL = "" ' ✅ 반드시 초기화!!
        SQL = SQL & " select doorsizechuga_price,door_price "
        SQL = SQL & " from tk_framekSub "
        SQL=SQL&" Where fkidx = '"&rfkidx&"' and doortype>0 "
        'Response.write (SQL)&"<br>"
        Rs1.open SQL, Dbcon
        If Not (Rs1.bof or Rs1.eof) Then 
        Do While Not Rs1.EOF

            doorsizechuga_price = rs1(0)
            door_price = rs1(1)

            total_doorsizechuga_price         = total_doorsizechuga_price         + doorsizechuga_price '총 도어 추가금(별도 분리되서 계산)
            total_door_price          = total_door_price          + door_price '총 도어(도어추가금 포함되어있음) 단가

        rs1.MoveNext
        Loop
        End If
        Rs1.Close 

        SQL = "UPDATE tk_framek SET "
        SQL = SQL & " door_price = '" & total_door_price & "' "
        SQL = SQL & " WHERE fkidx = '"&rfkidx&"' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
    '=================tk_framek 도어업데이트 끝


sjsprice = 0
disrate = 0
disprice = 0
fprice = 0
py_chuga= 0
robby_box= 0
jaeryobunridae= 0
boyangjea= 0
whaburail= 0
total_sjsprice         = 0
total_disrate          = 0
total_disprice         = 0
total_fprice           = 0
total_py_chuga         = 0
total_robby_box        = 0
total_jaeryobunridae   = 0
total_boyangjea        = 0
total_whaburail        = 0
total_door_price       = 0

    sql = "SELECT fkidx, fknickname, fidx, sjb_idx, fname, fmidx"
    sql = sql & ", fwdate, fstatus, GREEM_F_A, GREEM_BASIC_TYPE, GREEM_FIX_TYPE, GREEM_HABAR_TYPE"
    sql = sql & ", GREEM_LB_TYPE, GREEM_O_TYPE, GREEM_FIX_name, fmeidx, fewdate, GREEM_MBAR_TYPE"
    sql = sql & ", sjidx, sjb_type_no, setstd, sjsidx, ow, oh"
    sql = sql & ", tw, th, bcnt, FL, qtyidx, pidx"
    sql = sql & ", ow_m, framek_price, sjsprice, disrate, disprice, fprice"
    sql = sql & ", quan, taxrate, sprice, py_chuga, robby_box, jaeryobunridae"
    sql = sql & ", boyangjea, dooryn, doorglass_t, fixglass_t, doorchoice, whaburail"
    sql = sql & ", jaeryobunridae_type, door_price "
    sql = sql & " FROM tk_framek"
    sql = sql & " WHERE sjsidx = '" & rsjsidx & "'"
    'Response.write (SQL)&"<br>"
    rs.Open sql, Dbcon
    If Not (rs.BOF Or rs.EOF) Then
    Do While Not rs.EOF

        fkidx = rs(0)
        fknickname = rs(1)
        fidx = rs(2)
        sjb_idx = rs(3)
        fname = rs(4)
        fmidx = rs(5)
        fwdate = rs(6)
        fstatus = rs(7)
        GREEM_F_A = rs(8)
        GREEM_BASIC_TYPE = rs(9)
        GREEM_FIX_TYPE = rs(10)
        GREEM_HABAR_TYPE = rs(11)
        GREEM_LB_TYPE = rs(12)
        GREEM_O_TYPE = rs(13)
        GREEM_FIX_name = rs(14)
        fmeidx = rs(15)
        fewdate = rs(16)
        GREEM_MBAR_TYPE = rs(17)
        sjidx = rs(18)
        sjb_type_no = rs(19)
        setstd = rs(20)
        sjsidx = rs(21)
        ow = rs(22)
        oh = rs(23)
        tw = rs(24)
        th = rs(25)
        bcnt = rs(26)
        FL = rs(27)
        qtyidx = rs(28)
        pidx = rs(29)
        ow_m = rs(30)
        framek_price = rs(31)
        sjsprice = rs(32)  ' 프레임 원가 (도어  빼고 수량도 없고 할인 전 가격)
        disrate = rs(33)
        disprice = rs(34)
        fprice = rs(35)
        quan = rs(36)
        taxrate = rs(37)
        sprice = rs(38)
        py_chuga = rs(39)
        robby_box = rs(40)
        jaeryobunridae = rs(41)
        boyangjea = rs(42)
        dooryn = rs(43)
        doorglass_t = rs(44)
        fixglass_t = rs(45)
        doorchoice = rs(46)
        whaburail = rs(47)
        jaeryobunridae_type = rs(48)
        door_price = rs(49)

            total_sjsprice         = total_sjsprice         + sjsprice  '단가
            total_disrate          = disrate '할인율
            total_disprice         = total_disprice         + disprice '할인금액
            total_fprice           = total_fprice           + fprice '공급가 (tk_frmaek에서 단가에서 할인을 뺴서 계산되어 있음 . 수량도 곱해져 있음)
            'total_quan             = total_quan             + quan '수량
            'total_taxrate          = total_taxrate          + taxrate '세율
            'total_sprice           = total_sprice           + sprice '최종가
            total_py_chuga         = total_py_chuga         + py_chuga
            total_robby_box        = total_robby_box        + robby_box
            total_jaeryobunridae   = total_jaeryobunridae   + jaeryobunridae
            total_boyangjea        = total_boyangjea        + boyangjea
            total_whaburail        = total_whaburail        + whaburail
        
        'response.write "fkidx : " & fkidx & "<br>"
        'response.write "fprice : " & fprice & "<br>"
        'response.write "total_fprice : " & total_fprice & "<br>"

        total_door_price = total_door_price + door_price

        rs.MoveNext
        Loop
        End If
        Rs.Close 
        
        'total_robby_box
        'response.write "total_robby_box : " & total_robby_box & "<br>"
        'response.write "total_jaeryobunridae : " & total_jaeryobunridae & "<br>"
        'response.write "total_boyangjea : " & total_boyangjea & "<br>"
        'response.write "total_whaburail : " & total_whaburail & "<br>"
        'response.write "total_door_price : " & total_door_price & "<br>"
        'response.write "total_sjsprice : " & total_sjsprice & "<br>"
        'response.write "total_disprice : " & total_disprice & "<br>"
        'response.write "total_fprice : " & total_fprice & "<br>"
        'response.write "total_py_chuga : " & total_py_chuga & "<br>"
        'response.write "total_disrate : " & total_disrate & "<br>"
        'response.end
        '1. 프레임 개당 원가
        '2. 프레임 공급가 (할인된가격) * 수량 + 옵션들 추가 가격
        '추가 . 프레임 공급가 (할인된가격) * 수량 - 옵션제외 가격
        '3. 도어 공급가 * 수량
        '4. fprice_update 전체가 = (옵션 전체액 * 수량) + 프레임 공급가 * 수량 + 도어 공급가* 수량 
        '5  total_taxrate 세액
        '6  total_sprice 최종가 = 전체가 + 세액 
        frame_option_price =  total_fprice +  ((total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail ) * quan )'2번
        frame_price_update  = total_fprice
        'sjsprice_update =  total_sjsprice + total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail + total_door_price
        sjsprice_update=total_sjsprice '1번
        'total_door_price 3번
        fprice_update =  total_fprice + ((total_robby_box + total_jaeryobunridae + total_boyangjea + total_whaburail + total_door_price) * quan ) '4번
        total_taxrate=(fprice_update * 0.1)  '5번
        total_sprice=(fprice_update+total_taxrate)   '6번

'response.write "sjsprice_update : " & sjsprice_update & "<br>"
'response.write "fprice_update : " & fprice_update & "<br>"
'response.write "total_taxrate : " & total_taxrate & "<br>"
'response.write "total_sprice : " & total_sprice & "<br>"
'response.write "frame_price_update : " & frame_price_update & "<br>"
'response.end
        '=================sjasub 업데이트 시작

        if quan = 0 then
            quan = 1
        end if
        SQL = "UPDATE tng_sjaSub SET "
        SQL = SQL & " sjsprice = '" & sjsprice_update & "' , disprice = '" & total_disprice & "' , fprice = '" & fprice_update & "' "
        SQL = SQL & " , taxrate = '" & total_taxrate & "' , sprice = '" & total_sprice & "', py_chuga = '" & total_py_chuga & "' "
        SQL = SQL & " , robby_box = '" & total_robby_box & "' , jaeryobunridae = '" & total_jaeryobunridae & "', boyangjea = '" & total_boyangjea & "' "
        SQL = SQL & " , whaburail = '" & total_whaburail & "' , door_price = '" & total_door_price & "' ,quan='"&quan&"',frame_price='"&frame_price_update&"' "
        SQL = SQL & " , frame_option_price='"&frame_option_price&"' "
        SQL = SQL & " WHERE sjsidx = '" & rsjsidx & "' "
        'Response.write (SQL)&"<br>"
        'response.end
        Dbcon.Execute (SQL)
        '=================sjasub 업데이트 끝

end if 'if rfkidx<>"" then  


'response.end





response.write"<script>location.replace('tng1_b_suju_quick.asp?cidx="&rcidx&"&sjidx="&rsjidx&"&sjb_idx="&rsjb_idx&"&sjb_type_no="&rsjb_type_no&"&sjsidx="&rsjsidx&"&fkidx="&rfkidx&"&qtyidx="&rqtyidx&"&pidx="&rpidx&"');</script>"

%>


<%
set RsC=Nothing
set Rs=Nothing
set Rs1=Nothing
set Rs2=Nothing
set Rs3=Nothing
call dbClose()
%>