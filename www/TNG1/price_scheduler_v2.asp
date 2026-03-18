<%@ codepage="65001" language="vbscript"%>
<%
'================================================================================
' 도어 단가 자동 인상 스케줄러 v2.0
'================================================================================
' 용도: 예약된 단가 인상을 자동 실행
' 실행 방법:
'   1) Windows 작업 스케줄러: curl http://서버/admin/price_scheduler.asp
'   2) 브라우저 직접 접속
'   3) SQL Server Agent Job
'
' 권장: 5분 간격
'================================================================================

Session.CodePage = 65001
Response.CharSet = "utf-8"
Response.ContentType = "text/html"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<%
call dbOpen()

dim cmd, errorMsg, successMsg, rsScheduler, execCount, failCount
errorMsg = ""
successMsg = ""
execCount = 0
failCount = 0

' 프로시저 실행
Set cmd = Server.CreateObject("ADODB.Command")
cmd.ActiveConnection = Dbcon
cmd.CommandType = 4  ' adCmdStoredProc
cmd.CommandText = "tkd001.dbo.sp_ExecuteScheduledAdjustments_v2"
cmd.CommandTimeout = 300  ' 5분

on error resume next
Set rsScheduler = cmd.Execute

if err.number <> 0 then
    errorMsg = err.description
    err.clear
else
    if IsObject(rsScheduler) then
        if not rsScheduler.EOF then
            execCount = rsScheduler("executed_count")
            failCount = rsScheduler("fail_count")
            successMsg = rsScheduler("message") & ""
        else
            successMsg = "정상 실행 완료"
        end if
        rsScheduler.Close
        Set rsScheduler = Nothing
    else
        successMsg = "정상 실행 완료"
    end if
end if
on error goto 0

Set cmd = Nothing

' 대기 중인 예약 조회
dim rsPending, pendingCount
pendingCount = 0
Set rsPending = Dbcon.Execute("SELECT COUNT(*) FROM tkd001.dbo.tng_price_adjustment WHERE is_executed = 0 AND apply_date <= GETDATE()")
if not rsPending.EOF then
    pendingCount = rsPending(0)
end if
rsPending.Close

' 최근 실행 내역 조회
dim rsRecent
Set rsRecent = Dbcon.Execute("SELECT TOP 5 adj_idx, adj_name, adj_rate, adj_type, executed_at, affected_rows_t, affected_rows_al FROM tkd001.dbo.tng_price_adjustment WHERE is_executed = 1 ORDER BY executed_at DESC")

' 로그 기록
dim fso, logFile, ts, logPath
logPath = Server.MapPath("/logs/")

Set fso = Server.CreateObject("Scripting.FileSystemObject")

' 로그 폴더 생성
if not fso.FolderExists(logPath) then
    on error resume next
    fso.CreateFolder(logPath)
    on error goto 0
end if

logFile = logPath & "price_scheduler.log"

on error resume next
Set ts = fso.OpenTextFile(logFile, 8, True)  ' ForAppending
if err.number = 0 then
    dim logMsg
    if errorMsg = "" then logMsg = "SUCCESS: " & successMsg else logMsg = "ERROR: " & errorMsg
    ts.WriteLine "[" & Now() & "] " & logMsg
    ts.Close
end if
on error goto 0

Set ts = Nothing
Set fso = Nothing
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="300">
    <title>단가 인상 스케줄러 v2.0</title>
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: 'Malgun Gothic', sans-serif; 
            margin: 0; padding: 20px;
            background: #f0f2f5;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        h1 { color: #1a1a2e; margin-bottom: 20px; }
        
        .status-card {
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .status-success { 
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            border-left: 5px solid #10b981;
        }
        .status-error { 
            background: linear-gradient(135deg, #fee2e2, #fecaca);
            border-left: 5px solid #ef4444;
        }
        .status-icon { font-size: 40px; margin-right: 15px; }
        .status-text { font-size: 18px; font-weight: bold; }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        .info-item .label { color: #666; font-size: 12px; }
        .info-item .value { font-size: 24px; font-weight: bold; color: #333; margin-top: 5px; }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-top: 15px;
        }
        th { background: #4361ee; color: white; padding: 10px; text-align: center; }
        td { padding: 10px; border-bottom: 1px solid #eee; text-align: center; }
        
        .badge { 
            display: inline-block; 
            padding: 3px 8px; 
            border-radius: 12px; 
            font-size: 11px; 
            font-weight: bold; 
        }
        .badge-pending { background: #fef3c7; color: #d97706; }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #4361ee;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
        }
        .btn:hover { background: #3730a3; }
        
        .auto-refresh {
            position: fixed;
            top: 10px;
            right: 10px;
            background: #333;
            color: #fff;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 11px;
        }
        
        pre {
            background: #1a1a2e;
            color: #a5f3fc;
            padding: 15px;
            border-radius: 8px;
            font-size: 12px;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="auto-refresh">🔄 5분마다 자동 새로고침</div>
    
    <div class="container">
        <h1>🤖 단가 인상 스케줄러 <small style="color:#888; font-size:14px;">v2.0</small></h1>
        
        <% if errorMsg <> "" then %>
        <div class="status-card status-error" style="display: flex; align-items: center;">
            <span class="status-icon">❌</span>
            <div>
                <div class="status-text">실행 오류 발생</div>
                <div style="color: #dc2626; margin-top: 5px;"><%= errorMsg %></div>
            </div>
        </div>
        <% elseif CInt(execCount) > 0 then %>
        <div class="status-card status-success" style="display: flex; align-items: center;">
            <span class="status-icon">✅</span>
            <div>
                <div class="status-text"><%= successMsg %></div>
                <div style="color: #059669; margin-top: 5px;">실행 시각: <%= Now() %></div>
            </div>
        </div>
        <% elseif CInt(failCount) > 0 then %>
        <div class="status-card status-error" style="display: flex; align-items: center;">
            <span class="status-icon">⚠️</span>
            <div>
                <div class="status-text"><%= successMsg %></div>
                <div style="color: #dc2626; margin-top: 5px;">실행 시각: <%= Now() %></div>
            </div>
        </div>
        <% else %>
        <div class="status-card status-success" style="display: flex; align-items: center;">
            <span class="status-icon">💤</span>
            <div>
                <div class="status-text"><%= successMsg %></div>
                <div style="color: #059669; margin-top: 5px;">실행 시각: <%= Now() %> (대기 중인 예약 없음)</div>
            </div>
        </div>
        <% end if %>
        
        <div class="info-grid">
            <div class="info-item">
                <div class="label">실행 대기 중</div>
                <div class="value" style="color: <% if pendingCount > 0 then %>orange<% else %>green<% end if %>;">
                    <%= pendingCount %>건
                </div>
            </div>
            <div class="info-item">
                <div class="label">서버 시간</div>
                <div class="value" style="font-size: 16px;"><%= Now() %></div>
            </div>
            <div class="info-item">
                <div class="label">서버명</div>
                <div class="value" style="font-size: 14px;"><%= Request.ServerVariables("SERVER_NAME") %></div>
            </div>
        </div>
        
        <%
        ' 대기 중인 예약 상세 조회
        dim rsPendingList
        Set rsPendingList = Dbcon.Execute("SELECT adj_idx, adj_name, adj_rate, adj_type, apply_date, created_at FROM tkd001.dbo.tng_price_adjustment WHERE is_executed = 0 ORDER BY apply_date")
        %>
        <% if not rsPendingList.EOF then %>
        <h3>⏳ 대기 중인 예약</h3>
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>인상명</th>
                    <th>인상률</th>
                    <th>대상</th>
                    <th>개시일시</th>
                    <th>등록일시</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <% do while not rsPendingList.EOF %>
                <tr>
                    <td><%= rsPendingList("adj_idx") %></td>
                    <td style="text-align: left;"><%= rsPendingList("adj_name") %></td>
                    <td><strong><%= FormatNumber(rsPendingList("adj_rate"), 2) %>%</strong></td>
                    <td><%= rsPendingList("adj_type") %></td>
                    <td><%= rsPendingList("apply_date") %></td>
                    <td style="font-size:11px;"><%= rsPendingList("created_at") %></td>
                    <td>
                        <% if CDate(rsPendingList("apply_date")) <= Now() then %>
                            <span style="color:red; font-weight:bold;">실행 대기</span>
                        <% else %>
                            <span style="color:orange;">예약됨</span>
                        <% end if %>
                    </td>
                </tr>
                <%
                    rsPendingList.MoveNext
                loop
                %>
            </tbody>
        </table>
        <% end if %>
        <%
        rsPendingList.Close
        Set rsPendingList = Nothing
        %>

        <h3>📋 최근 실행 내역</h3>
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>인상명</th>
                    <th>인상률</th>
                    <th>대상</th>
                    <th>실행일시</th>
                    <th>결과</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if rsRecent.EOF then 
                %>
                <tr><td colspan="6" style="color: #999; padding: 30px;">실행 내역이 없습니다.</td></tr>
                <% 
                else
                    do while not rsRecent.EOF
                %>
                <tr>
                    <td><%= rsRecent("adj_idx") %></td>
                    <td style="text-align: left;"><%= rsRecent("adj_name") %></td>
                    <td><strong><%= FormatNumber(rsRecent("adj_rate"), 2) %>%</strong></td>
                    <td><%= rsRecent("adj_type") %></td>
                    <td><%= rsRecent("executed_at") %></td>
                    <td>t:<%= rsRecent("affected_rows_t") %> / al:<%= rsRecent("affected_rows_al") %></td>
                </tr>
                <%
                        rsRecent.MoveNext
                    loop
                end if
                rsRecent.Close
                Set rsRecent = Nothing
                %>
            </tbody>
        </table>
        
        <h3 style="margin-top: 30px;">📌 Windows 작업 스케줄러 설정</h3>
        <pre>
작업 이름: 도어_단가_자동_인상
트리거: 매 5분마다 반복
동작: 프로그램 시작
  프로그램: C:\Windows\System32\curl.exe
  인수: "<%= "http://" & Request.ServerVariables("SERVER_NAME") & Request.ServerVariables("SCRIPT_NAME") %>"
        </pre>
        
        <div style="text-align: center; margin-top: 30px;">
            <a href="price_adjustment_v2.asp" class="btn">📝 단가 인상 등록</a>
            &nbsp;&nbsp;
            <a href="<%= Request.ServerVariables("SCRIPT_NAME") %>" class="btn" style="background: #10b981;">🔄 새로고침</a>
        </div>
    </div>
</body>
</html>
<%
call dbClose()
%>
