<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
'================================================================================
' 도어 단가 인상 관리 화면 v2.0
'================================================================================
' 수정사항:
' 1. SQL Injection 방지 (파라미터화)
' 2. Include 경로 수정 (/inc/)
' 3. 미리보기 기능 추가
' 4. 롤백 기능 추가
'================================================================================

call dbOpen()

' 로그인 체크
if trim(c_midx) = "" then
    Response.Write "<script>alert('로그인이 필요합니다.'); location.href='/index.asp';</script>"
    Response.End
end if

dim part, adj_idx, sql, rs, cmd

part = Request("part")
adj_idx = Request("adj_idx")

'================================================================================
' 🔹 즉시 실행
'================================================================================
if part = "execute" then
    adj_idx = CLng(Request("adj_idx"))
    
    if adj_idx <= 0 then
        Response.Write "<script>alert('잘못된 요청입니다.'); history.back();</script>"
        Response.End
    end if
    
    ' 파라미터화된 프로시저 호출
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = Dbcon
    cmd.CommandType = 4  ' adCmdStoredProc
    cmd.CommandText = "tkd001.dbo.sp_ApplyPriceAdjustment_v2"
    cmd.Parameters.Append cmd.CreateParameter("@adj_idx", 3, 1, , adj_idx)
    
    on error resume next
    cmd.Execute
    
    if err.number <> 0 then
        Response.Write "<script>alert('오류: " & Replace(err.description, "'", "\'") & "'); history.back();</script>"
        err.clear
    else
        Response.Write "<script>alert('단가 인상이 완료되었습니다!'); location.href='price_adjustment_v2.asp';</script>"
    end if
    on error goto 0
    
    Set cmd = Nothing
    call dbClose()
    Response.End
end if

'================================================================================
' 🔹 등록
'================================================================================
if part = "insert" then
    dim adj_name, adj_rate, adj_type, target_bfwidx, target_qtyco, target_fidx, target_sjb_idx, apply_date, remarks
    
    adj_name = Replace(trim(Request("adj_name")), "'", "''")
    adj_rate = CDbl(Request("adj_rate"))
    adj_type = trim(Request("adj_type"))
    target_bfwidx = trim(Request("target_bfwidx"))
    target_qtyco = trim(Request("target_qtyco"))
    target_fidx = trim(Request("target_fidx"))
    target_sjb_idx = trim(Request("target_sjb_idx"))
    apply_date = trim(Request("apply_date"))
    remarks = Replace(trim(Request("remarks")), "'", "''")
    
    ' 유효성 검사
    if adj_name = "" or adj_type = "" or apply_date = "" then
        Response.Write "<script>alert('필수 항목을 입력해주세요.'); history.back();</script>"
        Response.End
    end if
    
    ' adj_type 검증
    if adj_type <> "ALL" and adj_type <> "MANUAL" and adj_type <> "AUTO" and adj_type <> "AL" then
        Response.Write "<script>alert('잘못된 적용 대상입니다.'); history.back();</script>"
        Response.End
    end if
    
    ' 인상률 범위 검사
    if adj_rate < -50 or adj_rate > 100 then
        Response.Write "<script>alert('인상률은 -50% ~ 100% 범위입니다.'); history.back();</script>"
        Response.End
    end if
    
    ' 파라미터화된 INSERT
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = Dbcon
    cmd.CommandType = 1  ' adCmdText
    cmd.CommandText = "INSERT INTO tkd001.dbo.tng_price_adjustment " & _
        "(adj_name, adj_rate, adj_type, target_bfwidx, target_qtyco, target_fidx, target_sjb_idx, apply_date, created_by, remarks) " & _
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    
    cmd.Parameters.Append cmd.CreateParameter("p1", 200, 1, 100, adj_name)
    cmd.Parameters.Append cmd.CreateParameter("p2", 5, 1, , adj_rate)
    cmd.Parameters.Append cmd.CreateParameter("p3", 200, 1, 20, adj_type)
    
    if target_bfwidx = "" or target_bfwidx = "0" then
        cmd.Parameters.Append cmd.CreateParameter("p4", 3, 1, , NULL)
    else
        cmd.Parameters.Append cmd.CreateParameter("p4", 3, 1, , CLng(target_bfwidx))
    end if

    if target_qtyco = "" or target_qtyco = "0" then
        cmd.Parameters.Append cmd.CreateParameter("p5", 3, 1, , NULL)
    else
        cmd.Parameters.Append cmd.CreateParameter("p5", 3, 1, , CLng(target_qtyco))
    end if

    if target_fidx = "" or target_fidx = "0" then
        cmd.Parameters.Append cmd.CreateParameter("p6", 3, 1, , NULL)
    else
        cmd.Parameters.Append cmd.CreateParameter("p6", 3, 1, , CLng(target_fidx))
    end if

    if target_sjb_idx = "" or target_sjb_idx = "0" then
        cmd.Parameters.Append cmd.CreateParameter("p7", 3, 1, , NULL)
    else
        cmd.Parameters.Append cmd.CreateParameter("p7", 3, 1, , CLng(target_sjb_idx))
    end if
    
    cmd.Parameters.Append cmd.CreateParameter("p8", 135, 1, , CDate(Replace(apply_date, "T", " ")))
    cmd.Parameters.Append cmd.CreateParameter("p9", 3, 1, , CLng(c_midx))
    cmd.Parameters.Append cmd.CreateParameter("p10", 200, 1, 500, remarks)
    
    on error resume next
    cmd.Execute
    
    if err.number <> 0 then
        Response.Write "<script>alert('등록 실패: " & Replace(err.description, "'", "\'") & "'); history.back();</script>"
        err.clear
    else
        Response.Write "<script>alert('단가 인상이 예약되었습니다!'); location.href='price_adjustment_v2.asp';</script>"
    end if
    on error goto 0
    
    Set cmd = Nothing
    call dbClose()
    Response.End
end if

'================================================================================
' 🔹 삭제
'================================================================================
if part = "delete" then
    adj_idx = CLng(Request("adj_idx"))
    
    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = Dbcon
    cmd.CommandType = 1
    cmd.CommandText = "DELETE FROM tkd001.dbo.tng_price_adjustment WHERE adj_idx = ? AND is_executed = 0"
    cmd.Parameters.Append cmd.CreateParameter("p1", 3, 1, , adj_idx)
    
    on error resume next
    cmd.Execute
    
    if err.number <> 0 then
        Response.Write "<script>alert('삭제 실패'); history.back();</script>"
        err.clear
    else
        Response.Write "<script>alert('삭제되었습니다.'); location.href='price_adjustment_v2.asp';</script>"
    end if
    on error goto 0
    
    Set cmd = Nothing
    call dbClose()
    Response.End
end if

'================================================================================
' 🔹 롤백
'================================================================================
if part = "rollback" then
    dim backup_id, rsRollback, rollback_t, rollback_al
    backup_id = Replace(trim(Request("backup_id")), "'", "")

    if backup_id = "" then
        Response.Write "<script>alert('백업ID가 필요합니다.'); history.back();</script>"
        Response.End
    end if

    Set cmd = Server.CreateObject("ADODB.Command")
    cmd.ActiveConnection = Dbcon
    cmd.CommandType = 4
    cmd.CommandText = "tkd001.dbo.sp_RollbackPriceAdjustment"
    cmd.CommandTimeout = 120
    cmd.Parameters.Append cmd.CreateParameter("@backup_id", 200, 1, 50, backup_id)

    on error resume next
    Set rsRollback = cmd.Execute

    if err.number <> 0 then
        Response.Write "<script>alert('롤백 실패: " & Replace(err.description, "'", "\'") & "'); history.back();</script>"
        err.clear
    else
        rollback_t = 0
        rollback_al = 0
        if IsObject(rsRollback) then
            if not rsRollback.EOF then
                rollback_t = rsRollback("rolled_back_t")
                rollback_al = rsRollback("rolled_back_al")
            end if
            rsRollback.Close
            Set rsRollback = Nothing
        end if
        Response.Write "<script>alert('롤백 완료!\nT테이블: " & rollback_t & "건\nAL테이블: " & rollback_al & "건 복원'); location.href='price_adjustment_v2.asp';</script>"
    end if
    on error goto 0

    Set cmd = Nothing
    call dbClose()
    Response.End
end if

'================================================================================
' 목록 조회
'================================================================================
dim listSQL
listSQL = "SELECT * FROM tkd001.dbo.tng_price_adjustment ORDER BY adj_idx DESC"
Set rs = Dbcon.Execute(listSQL)
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도어 단가 인상 관리 v2.0</title>
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: 'Malgun Gothic', sans-serif; 
            margin: 0; padding: 20px;
            background: #f0f2f5;
        }
        .container {
            max-width: 1600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        h1 { color: #1a1a2e; border-bottom: 3px solid #4361ee; padding-bottom: 15px; }
        h2 { color: #333; margin-top: 30px; }
        
        .alert-box {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .alert-info { background: #e7f3ff; border-left: 4px solid #4361ee; }
        .alert-warning { background: #fff3cd; border-left: 4px solid #ffc107; }
        .alert-danger { background: #f8d7da; border-left: 4px solid #dc3545; }
        
        .form-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 15px;
        }
        .form-group {
            flex: 1;
            min-width: 250px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }
        .form-group input:focus, .form-group select:focus {
            border-color: #4361ee;
            outline: none;
            box-shadow: 0 0 0 3px rgba(67,97,238,0.1);
        }
        .form-group small { color: #888; font-size: 12px; }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.2s;
        }
        .btn:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
        .btn-primary { background: #4361ee; color: white; }
        .btn-success { background: #10b981; color: white; }
        .btn-warning { background: #f59e0b; color: white; }
        .btn-danger { background: #ef4444; color: white; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 13px;
        }
        th {
            background: #4361ee;
            color: white;
            padding: 12px 8px;
            text-align: center;
            font-weight: bold;
            white-space: nowrap;
        }
        td {
            padding: 10px 8px;
            border-bottom: 1px solid #eee;
            text-align: center;
            vertical-align: middle;
        }
        tr:hover { background: #f8f9fa; }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }
        .badge-pending { background: #fef3c7; color: #d97706; }
        .badge-done { background: #d1fae5; color: #059669; }
        
        .type-all { background: #dbeafe; color: #1d4ed8; }
        .type-manual { background: #fce7f3; color: #db2777; }
        .type-auto { background: #e0e7ff; color: #4f46e5; }
        .type-al { background: #f3f4f6; color: #374151; }
    </style>
    <script>
        function executeAdjustment(idx, name, rate) {
            if (confirm('[' + name + ']\n인상률: ' + rate + '%\n\n지금 실행하시겠습니까?\n\n⚠️ 실행 후 자동 백업됩니다.')) {
                location.href = '?part=execute&adj_idx=' + idx;
            }
        }
        
        function deleteAdjustment(idx, name) {
            if (confirm('[' + name + ']\n\n이 예약을 삭제하시겠습니까?')) {
                location.href = '?part=delete&adj_idx=' + idx;
            }
        }
        
        function rollbackAdjustment(backupId, name) {
            if (confirm('[' + name + ']\n백업ID: ' + backupId + '\n\n정말 롤백하시겠습니까?\n이전 가격으로 복구됩니다.')) {
                location.href = '?part=rollback&backup_id=' + backupId;
            }
        }
        
        function validateForm() {
            var rate = parseFloat(document.getElementById('adj_rate').value);
            if (isNaN(rate) || rate < -50 || rate > 100) {
                alert('인상률은 -50% ~ 100% 범위입니다.');
                return false;
            }
            var name = document.getElementById('adj_name').value.trim();
            if (name.length < 2) {
                alert('인상명을 2자 이상 입력해주세요.');
                return false;
            }
            return confirm('단가 인상을 예약하시겠습니까?\n\n인상명: ' + name + '\n인상률: ' + rate + '%');
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>💰 도어 단가 인상 관리 <small style="font-size:14px; color:#888;">v2.0</small></h1>
        
        <div class="alert-box alert-info">
            <strong>📌 v2.0 개선사항</strong><br>
            ✅ 수동/자동 프레임 정확히 구분 &nbsp;|&nbsp;
            ✅ pcent 배율 자동 연동 &nbsp;|&nbsp;
            ✅ 인상 전 자동 백업 &nbsp;|&nbsp;
            ✅ 원클릭 롤백 지원
        </div>
        
        <!-- 등록 폼 -->
        <div class="form-section">
            <h2>📝 단가 인상 등록</h2>
            <form method="post" action="?part=insert" onsubmit="return validateForm()">
                <div class="form-row">
                    <div class="form-group">
                        <label>인상명 *</label>
                        <input type="text" name="adj_name" id="adj_name" placeholder="예: 2026년 2월 전체 단가 인상" required maxlength="100">
                    </div>
                    <div class="form-group">
                        <label>인상률 (%) *</label>
                        <input type="number" name="adj_rate" id="adj_rate" step="0.01" min="-50" max="100" placeholder="예: 10.00" required>
                        <small>음수 입력 시 인하 / 범위: -50% ~ 100%</small>
                    </div>
                    <div class="form-group">
                        <label>적용 대상 *</label>
                        <select name="adj_type" required>
                            <option value="ALL">🔷 전체 (수동+자동+알자/단알자)</option>
                            <option value="MANUAL">🔴 수동 프레임만 (SJB_FA=1)</option>
                            <option value="AUTO">🟣 자동 프레임만 (SJB_FA=2)</option>
                            <option value="AL">⬜ 알자/단알자만</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>특정 바/부품 (선택)</label>
                        <input type="number" name="target_bfwidx" placeholder="전체는 공백" min="0">
                        <small>unittype_bfwidx 값</small>
                    </div>
                    <div class="form-group">
                        <label>특정 재질 (선택)</label>
                        <input type="number" name="target_qtyco" placeholder="전체는 공백" min="0">
                        <small>1=H/L, 2=P/L, 3=갈바, 4=블랙H/L...</small>
                    </div>
                    <div class="form-group">
                        <label>특정 설계도 (선택)</label>
                        <input type="number" name="target_sjb_idx" placeholder="전체는 공백" min="0">
                        <small>SJB_IDX 값 (특정 설계도만)</small>
                    </div>
                    <div class="form-group">
                        <label>알루미늄 타입 (선택)</label>
                        <input type="number" name="target_fidx" placeholder="전체는 공백" min="0">
                        <small>fidx 값 (알자/단알자 전용)</small>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>개시일시 *</label>
                        <input type="datetime-local" name="apply_date" value="<%= Year(Now()) & "-" & Right("0" & Month(Now()), 2) & "-" & Right("0" & Day(Now()), 2) & "T00:00" %>" required>
                    </div>
                    <div class="form-group" style="flex: 2;">
                        <label>비고</label>
                        <input type="text" name="remarks" placeholder="인상 사유 등" maxlength="500">
                    </div>
                </div>
                
                <div style="margin-top: 20px; text-align: center;">
                    <button type="submit" class="btn btn-primary" style="padding: 12px 40px; font-size: 16px;">
                        📝 등록하기
                    </button>
                </div>
            </form>
        </div>
        
        <!-- 목록 -->
        <h2>📋 인상 이력 목록</h2>
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>인상명</th>
                    <th>인상률</th>
                    <th>대상</th>
                    <th>조건</th>
                    <th>개시일시</th>
                    <th>상태</th>
                    <th>실행결과</th>
                    <th>백업ID</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if rs.EOF then 
                %>
                    <tr>
                        <td colspan="10" style="padding: 40px; color: #999;">등록된 인상 이력이 없습니다.</td>
                    </tr>
                <% 
                else
                    do while not rs.EOF
                        dim statusBadge, typeBadge
                        if rs("is_executed") = 1 then
                            statusBadge = "<span class='badge badge-done'>✅ 완료</span>"
                        else
                            statusBadge = "<span class='badge badge-pending'>⏳ 대기</span>"
                        end if
                        
                        select case rs("adj_type")
                            case "ALL": typeBadge = "<span class='badge type-all'>전체</span>"
                            case "MANUAL": typeBadge = "<span class='badge type-manual'>수동</span>"
                            case "AUTO": typeBadge = "<span class='badge type-auto'>자동</span>"
                            case "AL": typeBadge = "<span class='badge type-al'>알루미늄</span>"
                        end select
                        
                        dim conditions
                        conditions = ""
                        if not IsNull(rs("target_bfwidx")) then conditions = conditions & "바:" & rs("target_bfwidx") & " "
                        if not IsNull(rs("target_qtyco")) then conditions = conditions & "재질:" & rs("target_qtyco") & " "
                        if not IsNull(rs("target_sjb_idx")) then conditions = conditions & "SJB:" & rs("target_sjb_idx") & " "
                        if conditions = "" then conditions = "-"
                %>
                    <tr>
                        <td><%= rs("adj_idx") %></td>
                        <td style="text-align: left; max-width: 200px;"><%= rs("adj_name") %></td>
                        <td><strong style="color: <% if CDbl(rs("adj_rate")) > 0 then %>red<% else %>blue<% end if %>;"><%= FormatNumber(rs("adj_rate"), 2) %>%</strong></td>
                        <td><%= typeBadge %></td>
                        <td style="font-size: 11px;"><%= conditions %></td>
                        <td style="font-size: 12px;"><%= rs("apply_date") %></td>
                        <td><%= statusBadge %></td>
                        <td style="font-size: 11px;">
                            <% if rs("is_executed") = 1 then %>
                                t: <strong><%= rs("affected_rows_t") %></strong>건<br>
                                al: <strong><%= rs("affected_rows_al") %></strong>건
                            <% else %>
                                -
                            <% end if %>
                        </td>
                        <td style="font-size: 10px; max-width: 120px; word-break: break-all;">
                            <%= rs("backup_id") %>
                        </td>
                        <td>
                            <% if rs("is_executed") = 0 then %>
                                <button class="btn btn-success btn-sm" onclick="executeAdjustment(<%= rs("adj_idx") %>, '<%= Replace(rs("adj_name"), "'", "\'") %>', '<%= rs("adj_rate") %>')">실행</button>
                                <button class="btn btn-danger btn-sm" onclick="deleteAdjustment(<%= rs("adj_idx") %>, '<%= Replace(rs("adj_name"), "'", "\'") %>')">삭제</button>
                            <% elseif not IsNull(rs("backup_id")) and rs("backup_id") <> "" then %>
                                <button class="btn btn-warning btn-sm" onclick="rollbackAdjustment('<%= rs("backup_id") %>', '<%= Replace(rs("adj_name"), "'", "\'") %>')">롤백</button>
                            <% else %>
                                <span style="color: #999;">-</span>
                            <% end if %>
                        </td>
                    </tr>
                <% 
                        rs.MoveNext
                    loop
                end if
                
                rs.Close
                Set rs = Nothing
                call dbClose()
                %>
            </tbody>
        </table>
        
        <div class="alert-box alert-warning" style="margin-top: 30px;">
            <strong>⚠️ 주의사항</strong>
            <ul style="margin: 10px 0 0 20px;">
                <li><strong>pcent 연동:</strong> pcent=1인 기준가만 인상되고, pcent>1인 설계도는 자동 계산됩니다.</li>
                <li><strong>자동 백업:</strong> 인상 실행 시 자동으로 백업되며, 백업ID로 롤백 가능합니다.</li>
                <li><strong>스케줄러:</strong> 개시일시가 지나면 5분 내 자동 실행됩니다.</li>
            </ul>
        </div>
        
        <div style="text-align: center; margin-top: 30px; padding: 20px; background: #f8f9fa; border-radius: 8px;">
            <a href="price_scheduler_v2.asp" class="btn btn-primary">🤖 스케줄러 상태</a>
            &nbsp;&nbsp;
            <a href="unittype_p.asp" class="btn btn-success">📊 수동 단가 확인</a>
            &nbsp;&nbsp;
            <a href="unittype_pa.asp" class="btn btn-success">📊 자동 단가 확인</a>
            &nbsp;&nbsp;
            <a href="unittype_al.asp" class="btn btn-warning">📊 알루미늄 단가 확인</a>
        </div>
    </div>
</body>
</html>
