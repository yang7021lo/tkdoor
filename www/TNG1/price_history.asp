<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage = 65001
Response.CharSet = "utf-8"
%>
<!--#include virtual="/inc/dbcon.asp"-->
<!--#include virtual="/inc/cookies.asp"-->
<%
'================================================================================
' 가격 변동 이력 조회 화면
'================================================================================

call dbOpen()

' 로그인 체크
if trim(c_midx) = "" then
    Response.Write "<script>alert('로그인이 필요합니다.'); location.href='/index.asp';</script>"
    Response.End
end if

' 필터 파라미터
dim filterSJB, filterDays, filterType, filterAdj
filterSJB = trim(Request("sjb_idx"))
filterDays = trim(Request("days"))
filterType = trim(Request("table_type"))
filterAdj = trim(Request("adj_idx"))

if filterDays = "" then filterDays = "90"

' 이력 조회
dim sql, rs
sql = "SELECT TOP 500 " & _
      "h.history_idx, h.changed_at, h.adj_idx, h.adj_name, " & _
      "h.table_type, h.record_idx, h.SJB_IDX, " & _
      "h.unittype_bfwidx, h.unittype_qtyco_idx, h.fidx, " & _
      "h.price_field, h.price_before, h.price_after, " & _
      "h.change_amount, h.change_rate, h.change_type, " & _
      "s.SJB_barlist, t.SJB_TYPE_NAME " & _
      "FROM tkd001.dbo.tng_price_history h " & _
      "LEFT JOIN tkd001.dbo.TNG_SJB s ON h.SJB_IDX = s.SJB_IDX " & _
      "LEFT JOIN tkd001.dbo.tng_sjbtype t ON s.SJB_TYPE_NO = t.SJB_TYPE_NO AND t.sjbtstatus = 1 " & _
      "WHERE h.changed_at >= DATEADD(DAY, -" & CLng(filterDays) & ", GETDATE()) "

if filterSJB <> "" then
    sql = sql & "AND h.SJB_IDX = " & CLng(filterSJB) & " "
end if
if filterType <> "" then
    sql = sql & "AND h.table_type = '" & filterType & "' "
end if
if filterAdj <> "" then
    sql = sql & "AND h.adj_idx = " & CLng(filterAdj) & " "
end if

sql = sql & "ORDER BY h.changed_at DESC, h.history_idx DESC"

Set rs = Dbcon.Execute(sql)

' 통계 조회
dim statSQL, rsStat
statSQL = "SELECT " & _
          "COUNT(*) as total_cnt, " & _
          "COUNT(DISTINCT adj_idx) as adj_cnt, " & _
          "COUNT(DISTINCT SJB_IDX) as sjb_cnt, " & _
          "SUM(CASE WHEN change_type = 'AUTO_ADJUST' THEN 1 ELSE 0 END) as adjust_cnt, " & _
          "SUM(CASE WHEN change_type = 'ROLLBACK' THEN 1 ELSE 0 END) as rollback_cnt " & _
          "FROM tkd001.dbo.tng_price_history " & _
          "WHERE changed_at >= DATEADD(DAY, -" & CLng(filterDays) & ", GETDATE())"
Set rsStat = Dbcon.Execute(statSQL)

dim totalCnt, adjCnt, sjbCnt, adjustCnt, rollbackCnt
if not rsStat.EOF then
    totalCnt = rsStat("total_cnt")
    adjCnt = rsStat("adj_cnt")
    sjbCnt = rsStat("sjb_cnt")
    adjustCnt = rsStat("adjust_cnt")
    rollbackCnt = rsStat("rollback_cnt")
end if
rsStat.Close

' 인상 건 목록 (필터용)
dim adjListSQL, rsAdj
adjListSQL = "SELECT DISTINCT adj_idx, adj_name FROM tkd001.dbo.tng_price_history ORDER BY adj_idx DESC"
Set rsAdj = Dbcon.Execute(adjListSQL)
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>가격 변동 이력</title>
    <style>
        * { box-sizing: border-box; }
        body { 
            font-family: 'Malgun Gothic', sans-serif; 
            margin: 0; padding: 20px;
            background: #f0f2f5;
        }
        .container {
            max-width: 1800px;
            margin: 0 auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        h1 { 
            color: #1a1a2e; 
            border-bottom: 3px solid #10b981; 
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        
        /* 통계 카드 */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            border-left: 4px solid #10b981;
        }
        .stat-card .value {
            font-size: 28px;
            font-weight: bold;
            color: #1a1a2e;
        }
        .stat-card .label {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        /* 필터 */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: flex-end;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .filter-group label {
            font-size: 12px;
            color: #666;
            font-weight: bold;
        }
        .filter-group input, .filter-group select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 13px;
        }
        .filter-group input:focus, .filter-group select:focus {
            border-color: #10b981;
            outline: none;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
        }
        .btn-primary { background: #10b981; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn:hover { opacity: 0.9; }
        
        /* 테이블 */
        .table-wrapper {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
            min-width: 1200px;
        }
        th {
            background: #1a1a2e;
            color: white;
            padding: 10px 6px;
            text-align: center;
            font-weight: bold;
            white-space: nowrap;
            position: sticky;
            top: 0;
        }
        td {
            padding: 8px 6px;
            border-bottom: 1px solid #eee;
            text-align: center;
            vertical-align: middle;
        }
        tr:hover { background: #f8f9fa; }
        tr:nth-child(even) { background: #fafbfc; }
        tr:nth-child(even):hover { background: #f0f1f2; }
        
        /* 뱃지 */
        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 10px;
            font-weight: bold;
        }
        .badge-t { background: #dbeafe; color: #1d4ed8; }
        .badge-a { background: #f3e8ff; color: #7c3aed; }
        .badge-adjust { background: #d1fae5; color: #059669; }
        .badge-rollback { background: #fee2e2; color: #dc2626; }
        .badge-manual { background: #fef3c7; color: #d97706; }
        
        /* 가격 표시 */
        .price-up { color: #dc2626; }
        .price-down { color: #2563eb; }
        .price-cell { font-family: 'Consolas', monospace; }
        
        /* 링크 */
        .link-sjb {
            color: #2563eb;
            text-decoration: none;
            cursor: pointer;
        }
        .link-sjb:hover { text-decoration: underline; }
        
        /* 페이지네이션 안내 */
        .info-text {
            color: #666;
            font-size: 12px;
            margin-top: 15px;
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 가격 변동 이력</h1>
        
        <!-- 통계 카드 -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="value"><%= totalCnt %></div>
                <div class="label">총 변경 건수</div>
            </div>
            <div class="stat-card" style="border-color: #4361ee;">
                <div class="value"><%= adjCnt %></div>
                <div class="label">인상 건수</div>
            </div>
            <div class="stat-card" style="border-color: #f59e0b;">
                <div class="value"><%= sjbCnt %></div>
                <div class="label">영향 설계도</div>
            </div>
            <div class="stat-card" style="border-color: #10b981;">
                <div class="value"><%= adjustCnt %></div>
                <div class="label">인상 적용</div>
            </div>
            <div class="stat-card" style="border-color: #ef4444;">
                <div class="value"><%= rollbackCnt %></div>
                <div class="label">롤백</div>
            </div>
        </div>
        
        <!-- 필터 -->
        <form method="get" class="filter-bar">
            <div class="filter-group">
                <label>조회 기간</label>
                <select name="days">
                    <option value="7" <%= IIf(filterDays="7", "selected", "") %>>최근 7일</option>
                    <option value="30" <%= IIf(filterDays="30", "selected", "") %>>최근 30일</option>
                    <option value="90" <%= IIf(filterDays="90", "selected", "") %>>최근 90일</option>
                    <option value="180" <%= IIf(filterDays="180", "selected", "") %>>최근 180일</option>
                    <option value="365" <%= IIf(filterDays="365", "selected", "") %>>최근 1년</option>
                </select>
            </div>
            <div class="filter-group">
                <label>설계도 번호</label>
                <input type="number" name="sjb_idx" value="<%= filterSJB %>" placeholder="SJB_IDX" style="width: 100px;">
            </div>
            <div class="filter-group">
                <label>테이블</label>
                <select name="table_type">
                    <option value="">전체</option>
                    <option value="T" <%= IIf(filterType="T", "selected", "") %>>수동/자동 (T)</option>
                    <option value="A" <%= IIf(filterType="A", "selected", "") %>>알루미늄 (A)</option>
                </select>
            </div>
            <div class="filter-group">
                <label>인상 건</label>
                <select name="adj_idx">
                    <option value="">전체</option>
                    <% 
                    do while not rsAdj.EOF 
                    %>
                    <option value="<%= rsAdj("adj_idx") %>" <%= IIf(CStr(filterAdj)=CStr(rsAdj("adj_idx")), "selected", "") %>>[<%= rsAdj("adj_idx") %>] <%= rsAdj("adj_name") %></option>
                    <% 
                        rsAdj.MoveNext
                    loop 
                    rsAdj.Close
                    %>
                </select>
            </div>
            <div class="filter-group">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary">🔍 조회</button>
            </div>
            <div class="filter-group">
                <label>&nbsp;</label>
                <a href="price_history.asp" class="btn btn-secondary">초기화</a>
            </div>
        </form>
        
        <!-- 테이블 -->
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>변경일시</th>
                        <th>인상명</th>
                        <th>유형</th>
                        <th>테이블</th>
                        <th>SJB_IDX</th>
                        <th>규격</th>
                        <th>품명</th>
                        <th>바타입</th>
                        <th>재질</th>
                        <th>필드</th>
                        <th>변경 전</th>
                        <th>변경 후</th>
                        <th>변동액</th>
                        <th>변동률</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    if rs.EOF then 
                    %>
                    <tr>
                        <td colspan="15" style="padding: 50px; color: #999;">
                            조회된 이력이 없습니다.
                        </td>
                    </tr>
                    <% 
                    else
                        dim rowNum
                        rowNum = 0
                        do while not rs.EOF
                            rowNum = rowNum + 1
                            
                            dim typeBadge, changeBadge, changeClass
                            if rs("table_type") = "T" then
                                typeBadge = "<span class='badge badge-t'>수동/자동</span>"
                            else
                                typeBadge = "<span class='badge badge-a'>알루미늄</span>"
                            end if
                            
                            select case rs("change_type")
                                case "AUTO_ADJUST": changeBadge = "<span class='badge badge-adjust'>인상</span>"
                                case "ROLLBACK": changeBadge = "<span class='badge badge-rollback'>롤백</span>"
                                case "MANUAL": changeBadge = "<span class='badge badge-manual'>수동</span>"
                                case else: changeBadge = rs("change_type")
                            end select
                            
                            if rs("change_amount") > 0 then
                                changeClass = "price-up"
                            elseif rs("change_amount") < 0 then
                                changeClass = "price-down"
                            else
                                changeClass = ""
                            end if
                    %>
                    <tr>
                        <td><%= rs("history_idx") %></td>
                        <td style="font-size: 11px; white-space: nowrap;"><%= rs("changed_at") %></td>
                        <td style="text-align: left; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="<%= rs("adj_name") %>">
                            <%= rs("adj_name") %>
                        </td>
                        <td><%= changeBadge %></td>
                        <td><%= typeBadge %></td>
                        <td>
                            <a class="link-sjb" href="?sjb_idx=<%= rs("SJB_IDX") %>&days=<%= filterDays %>"><%= rs("SJB_IDX") %></a>
                        </td>
                        <td><%= rs("SJB_barlist") %></td>
                        <td style="text-align: left; max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                            <%= rs("SJB_TYPE_NAME") %>
                        </td>
                        <td><%= rs("unittype_bfwidx") %></td>
                        <td><%= rs("unittype_qtyco_idx") %></td>
                        <td><%= rs("price_field") %></td>
                        <td class="price-cell"><%= FormatNumber(rs("price_before"), 0) %></td>
                        <td class="price-cell"><%= FormatNumber(rs("price_after"), 0) %></td>
                        <td class="price-cell <%= changeClass %>">
                            <%= IIf(rs("change_amount") > 0, "+", "") %><%= FormatNumber(rs("change_amount"), 0) %>
                        </td>
                        <td class="<%= changeClass %>">
                            <%= IIf(rs("change_rate") > 0, "+", "") %><%= FormatNumber(rs("change_rate"), 2) %>%
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
        </div>
        
        <p class="info-text">
            * 최대 500건까지 표시됩니다. 더 많은 데이터는 필터를 사용하세요.
        </p>
        
        <div style="margin-top: 25px; text-align: center; padding: 15px; background: #f8f9fa; border-radius: 8px;">
            <a href="price_adjustment_v2.asp" class="btn btn-primary" style="padding: 10px 25px;">📝 단가 인상 관리</a>
            &nbsp;&nbsp;
            <a href="unittype_p.asp" class="btn btn-secondary" style="padding: 10px 25px;">📊 수동 단가</a>
            &nbsp;&nbsp;
            <a href="unittype_pa.asp" class="btn btn-secondary" style="padding: 10px 25px;">📊 자동 단가</a>
        </div>
    </div>
</body>
</html>
