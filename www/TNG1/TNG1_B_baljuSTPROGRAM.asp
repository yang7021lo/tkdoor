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
    Set RsC = Server.CreateObject ("ADODB.Recordset")
    Set Rs = Server.CreateObject ("ADODB.Recordset")
    Set Rs1 = Server.CreateObject ("ADODB.Recordset")
    Set Rs2 = Server.CreateObject ("ADODB.Recordset")
    Set Rs3 = Server.CreateObject ("ADODB.Recordset")

    projectname="절곡 발주서"

' ===== 절곡 tx, ty 업데이트 전용 프로그램 입니다. (업데이트: 2025-12-08) =====

%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>전체좌표 업데이트 프로그램</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    body { padding: 15px; font-size: 14px; }
  </style>
</head>
<body>
<%
    Response.Write "<div class='container mt-3'>"
    Response.Write "<h3 class='mb-3'><i class='fas fa-cogs'></i> 전체좌표 업데이트 프로그램</h3>"
    Response.Flush()
    
    ' 전체 테이블에서 tx 또는 ty가 NULL인 모든 baidx 목록 가져오기
    SQL_baidx = "SELECT DISTINCT baidx FROM tk_barasisub WHERE (tx IS NULL OR ty IS NULL) ORDER BY baidx"
    Set Rs_baidx = Dbcon.Execute(SQL_baidx)
    
    updateCount = 0
    baidxCount = 0
    
    ' 업데이트할 데이터가 있는지 먼저 확인
    If Rs_baidx.EOF Then
        Response.Write "<div class='alert alert-success'><h4><i class='fas fa-check-circle'></i> 더이상 업데이트 할 좌표가 없습니다.</h4></div>"
        Response.Write "</div></body></html>"
        Response.End()
    Else
        Response.Write "<div class='alert alert-info'><h4><i class='fas fa-spinner fa-spin'></i> 전체좌표 업데이트중...</h4></div>"
        Response.Flush()
    End If
    
    If Not (Rs_baidx.BOF Or Rs_baidx.EOF) Then
        Do While Not Rs_baidx.EOF
            current_baidx = Rs_baidx(0)
            baidxCount = baidxCount + 1
            
            ' 각 baidx별로 처리되지 않은 레코드만 가져오기
            SQL = "SELECT basidx, bassize, basdirection, x1, y1, x2, y2, accsize, idv FROM tk_barasisub WHERE baidx='" & current_baidx & "' AND (tx IS NULL OR ty IS NULL) ORDER BY basidx ASC"
            Set Rs2 = Dbcon.Execute(SQL)
            
            If Not (Rs2.BOF Or Rs2.EOF) Then
                arr = Rs2.GetRows()
                Rs2.Close
                recCount = UBound(arr,2)+1

                ' 중심점 계산
                sumMidX=0:sumMidY=0
                For i=0 To recCount-1
                    x1=CDbl(arr(3,i)):y1=CDbl(arr(4,i)):x2=CDbl(arr(5,i)):y2=CDbl(arr(6,i))
                    sumMidX=sumMidX+(x1+x2)/2:sumMidY=sumMidY+(y1+y2)/2
                Next
                cx=sumMidX/recCount:cy=sumMidY/recCount
                pre_dir=0

                ' 좌표 계산 및 업데이트
                For i=0 To recCount-1
                    basidx=arr(0,i):bassize=arr(1,i):basdirection=arr(2,i)
                    x1=CDbl(arr(3,i)):y1=CDbl(arr(4,i)):x2=CDbl(arr(5,i)):y2=CDbl(arr(6,i))
                    midX=(x1+x2)/2:midY=(y1+y2)/2

                    Select Case basdirection
                        Case 1:nx=0:ny=1
                        Case 2:nx=-1:ny=0
                        Case 3:nx=0:ny=-1
                        Case 4:nx=1:ny=0
                        Case Else:nx=0:ny=1
                    End Select

                    If pre_dir>0 Then
                        prev_idx=pre_dir-1:curr_idx=basdirection-1
                        delta=((curr_idx-prev_idx)+4) Mod 4
                        If delta=2 Then nx=-nx:ny=-ny
                    End If

                    offset=20
                    tx1=midX+(nx*offset):ty1=midY+(ny*offset)

                    ' DB 업데이트
                    On Error Resume Next
                    Dbcon.Execute("IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tk_barasisub' AND COLUMN_NAME = 'tx') ALTER TABLE tk_barasisub ADD tx INT")
                    Dbcon.Execute("IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'tk_barasisub' AND COLUMN_NAME = 'ty') ALTER TABLE tk_barasisub ADD ty INT")
                    
                    updateSQL = "UPDATE tk_barasisub SET tx=" & Replace(CStr(tx1), ",", ".") & ", ty=" & Replace(CStr(ty1), ",", ".") & " WHERE basidx=" & basidx
                    Dbcon.Execute(updateSQL)
                    On Error GoTo 0

                    updateCount = updateCount + 1
                    pre_dir=basdirection
                Next
            End If
            
            ' 진행 상황 출력
            If recCount > 0 Then
                Response.Write "<div class='alert alert-secondary'>baidx " & current_baidx & " 처리 완료 - " & recCount & "개 업데이트 (누적: " & updateCount & "개)</div>"
            Else
                Response.Write "<div class='alert alert-light'>baidx " & current_baidx & " 건너뜀 (이미 처리됨)</div>"
            End If
            Response.Flush()
            
            Rs_baidx.MoveNext
        Loop
    End If
    Rs_baidx.Close
    
    ' 진행 중 메시지 제거를 위한 JavaScript
    Response.Write "<script>"
    Response.Write "document.querySelectorAll('.alert-info').forEach(function(el) {"
    Response.Write "if (el.textContent.includes('전체좌표 업데이트중')) el.remove();"
    Response.Write "});"
    Response.Write "</script>"
    
    If updateCount > 0 Then
        Response.Write "<div class='alert alert-success'><h4><i class='fas fa-check-circle'></i> 업데이트 완료</h4>"
        Response.Write "<p><strong>처리 결과:</strong></p>"
        Response.Write "<ul class='mb-0'>"
        Response.Write "<li>업데이트된 절곡 그룹: " & baidxCount & "개</li>"
        Response.Write "<li>업데이트된 좌표 레코드: " & updateCount & "개</li>"
        Response.Write "</ul></div>"
    Else
        Response.Write "<div class='alert alert-info'><h4><i class='fas fa-info-circle'></i> 업데이트 완료</h4>"
        Response.Write "<p>처리할 좌표가 없었습니다. 모든 좌표가 이미 설정되어 있습니다.</p></div>"
    End If
    Response.Write "</div>"
%>
</body>
</html>