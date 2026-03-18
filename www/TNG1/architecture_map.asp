<%@ Language="VBScript" CodePage=65001 %><%
Option Explicit
Response.CharSet = "utf-8"

Dim mode
mode = Request.QueryString("mode")

'================================================================
' MODE: scan - Return JSON list of all code files under www/
'================================================================
If mode = "scan" Then
    Response.ContentType = "application/json; charset=utf-8"

    Dim fso, rootPath, first
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    rootPath = Server.MapPath("../")

    Dim skipDirs
    skipDirs = "|img|uploads|upload|tfile|assets|.vscode|.claude|python|dist|__pycache__|node_modules|.git|"

    Dim codeExts
    codeExts = "|asp|html|htm|js|css|sql|json|aspx|py|"

    Response.Write "["
    first = True
    Call ScanDir(fso, rootPath, "", skipDirs, codeExts, first)
    Response.Write "]"

    Set fso = Nothing
    Response.End
End If

'================================================================
' MODE: parse - Parse a specific file for connections
'================================================================
If mode = "parse" Then
    Response.ContentType = "application/json; charset=utf-8"

    Dim parseFile
    parseFile = Request.QueryString("file")

    If InStr(parseFile, "..") > 0 Or InStr(parseFile, "~") > 0 Then
        Response.Write "{""error"":""invalid path""}"
        Response.End
    End If

    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    Dim fullPath
    fullPath = Server.MapPath("../" & parseFile)

    If fso.FileExists(fullPath) Then
        Response.Write ParseFileConn(fso, fullPath, parseFile)
    Else
        Response.Write "{""error"":""not found""}"
    End If

    Set fso = Nothing
    Response.End
End If

'================================================================
' SUB: Recursive directory scanner
'================================================================
Sub ScanDir(fso, basePath, relPath, skipDirs, codeExts, ByRef first)
    Dim dirFullPath
    If relPath = "" Then
        dirFullPath = basePath
    Else
        dirFullPath = basePath & "\" & relPath
    End If

    If Not fso.FolderExists(dirFullPath) Then Exit Sub

    Dim folder, file, ext, filePath, topFolder, parts
    Set folder = fso.GetFolder(dirFullPath)

    On Error Resume Next
    For Each file In folder.Files
        If Err.Number <> 0 Then
            Err.Clear
        Else
            ext = LCase(fso.GetExtensionName(file.Name))
            If InStr(codeExts, "|" & ext & "|") > 0 Then
                If relPath = "" Then
                    filePath = file.Name
                Else
                    filePath = Replace(relPath, "\", "/") & "/" & file.Name
                End If

                parts = Split(filePath, "/")
                If UBound(parts) > 0 Then
                    topFolder = parts(0)
                Else
                    topFolder = ""
                End If

                If Not first Then Response.Write ","
                first = False

                Response.Write "{""n"":""" & JE(file.Name) & """"
                Response.Write ",""p"":""" & JE(filePath) & """"
                Response.Write ",""f"":""" & JE(Replace(relPath, "\", "/")) & """"
                Response.Write ",""t"":""" & JE(topFolder) & """"
                Response.Write ",""e"":""" & ext & """"
                Response.Write ",""s"":" & file.Size
                Response.Write "}"
            End If
        End If
    Next
    On Error GoTo 0

    Dim subFolder, folderName, newRel
    On Error Resume Next
    For Each subFolder In folder.SubFolders
        If Err.Number <> 0 Then
            Err.Clear
        Else
            folderName = LCase(subFolder.Name)
            If InStr(skipDirs, "|" & folderName & "|") = 0 Then
                If relPath = "" Then
                    newRel = subFolder.Name
                Else
                    newRel = relPath & "\" & subFolder.Name
                End If
                Call ScanDir(fso, basePath, newRel, skipDirs, codeExts, first)
            End If
        End If
    Next
    On Error GoTo 0
End Sub

'================================================================
' FUNCTION: Parse file for connections
'================================================================
Function ParseFileConn(fso, fullPath, relPath)
    Dim ts, content, json

    On Error Resume Next
    Set ts = fso.OpenTextFile(fullPath, 1, False, 0)
    If Err.Number <> 0 Then
        ParseFileConn = "{""error"":""cannot read""}"
        Err.Clear
        Exit Function
    End If
    If Not ts.AtEndOfStream Then
        content = ts.ReadAll
    Else
        content = ""
    End If
    ts.Close
    On Error GoTo 0

    Dim re
    Set re = New RegExp
    re.IgnoreCase = True
    re.Global = True

    json = "{""file"":""" & JE(relPath) & """"

    re.Pattern = "#include\s+(file|virtual)\s*=\s*""([^""]+)"""
    json = json & ",""inc"":" & MatchJSON(re, content, 1)

    re.Pattern = "action\s*=\s*[""']([^""']+\.asp[^""']*)[""']"
    json = json & ",""form"":" & MatchJSON(re, content, 0)

    re.Pattern = "Response\.Redirect\s+""([^""]+)"""
    json = json & ",""redir"":" & MatchJSON(re, content, 0)

    re.Pattern = "window\.open\s*\([^)]*[""']([^""']+\.asp[^""']*)[""']"
    json = json & ",""popup"":" & MatchJSON(re, content, 0)

    re.Pattern = "location\.href\s*=\s*[""']([^""']+\.asp[^""']*)[""']"
    json = json & ",""link"":" & MatchJSON(re, content, 0)

    re.Pattern = "<iframe[^>]+src\s*=\s*[""']([^""']+\.asp[^""']*)[""']"
    json = json & ",""iframe"":" & MatchJSON(re, content, 0)

    re.Pattern = "(fetch\s*\(\s*[""']|\.open\s*\(\s*[""'][A-Z]+[""']\s*,\s*[""'])([^""']+\.asp[^""']*)[""']"
    json = json & ",""ajax"":" & MatchJSON(re, content, 1)

    ' === DB Table Detection ===
    ' FROM / JOIN / INTO / UPDATE / DELETE FROM 패턴으로 테이블명 추출
    ' VBScript RegExp: (?:...) 미지원 → 캡처그룹 사용, subIdx=1
    re.Pattern = "(FROM|JOIN|INTO|UPDATE)\s+\[?([A-Za-z_][A-Za-z0-9_]*)\]?"
    json = json & ",""tables"":" & MatchJSON(re, content, 1)

    ' === SQL Query Type Detection (SELECT/INSERT/UPDATE/DELETE) ===
    ' VBScript RegExp: \b 미지원 → 공백/따옴표 경계로 대체
    Dim hasSelect, hasInsert, hasUpdate, hasDelete
    Dim reCheck
    Set reCheck = New RegExp
    reCheck.IgnoreCase = True
    reCheck.Global = False

    reCheck.Pattern = "SELECT\s+.+FROM\s+"
    hasSelect = reCheck.Test(content)
    reCheck.Pattern = "INSERT\s+INTO\s+"
    hasInsert = reCheck.Test(content)
    reCheck.Pattern = "UPDATE\s+.+SET\s+"
    hasUpdate = reCheck.Test(content)
    reCheck.Pattern = "DELETE\s+FROM\s+"
    hasDelete = reCheck.Test(content)

    json = json & ",""crud"":["
    Dim crudFirst
    crudFirst = True
    If hasSelect Then json = json & """SELECT""" : crudFirst = False
    If hasInsert Then
        If Not crudFirst Then json = json & ","
        json = json & """INSERT""" : crudFirst = False
    End If
    If hasUpdate Then
        If Not crudFirst Then json = json & ","
        json = json & """UPDATE""" : crudFirst = False
    End If
    If hasDelete Then
        If Not crudFirst Then json = json & ","
        json = json & """DELETE"""
    End If
    json = json & "]"

    Set reCheck = Nothing

    ' === Connection String / DB Source Detection ===
    re.Pattern = "(Server|Data Source|Initial Catalog|Database)\s*=\s*([^;""]+)"
    json = json & ",""dbconn"":" & MatchJSON(re, content, 1)

    json = json & "}"

    Set re = Nothing
    ParseFileConn = json
End Function

'================================================================
' FUNCTION: RegExp matches to JSON array (deduplicated)
'================================================================
Function MatchJSON(re, content, subIdx)
    Dim matches, match, result, seen, val
    Set matches = re.Execute(content)
    result = "["
    seen = "|"
    Dim isFirst
    isFirst = True
    For Each match In matches
        val = match.SubMatches(subIdx)
        If InStr(seen, "|" & val & "|") = 0 Then
            seen = seen & val & "|"
            If Not isFirst Then result = result & ","
            isFirst = False
            result = result & """" & JE(val) & """"
        End If
    Next
    result = result & "]"
    MatchJSON = result
End Function

'================================================================
' FUNCTION: JSON string escape
'================================================================
Function JE(s)
    Dim r
    r = Replace(s, "\", "\\")
    r = Replace(r, """", "\""")
    r = Replace(r, vbCr, "")
    r = Replace(r, vbLf, "")
    r = Replace(r, vbTab, " ")
    JE = r
End Function
%><!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>www 아키텍처 맵</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Malgun Gothic','Segoe UI',sans-serif;background:#0d1117;color:#c9d1d9;overflow:hidden;height:100vh}
#app{display:flex;flex-direction:column;height:100vh}

/* === Toolbar === */
#toolbar{
  background:#161b22;border-bottom:1px solid #30363d;
  padding:8px 16px;display:flex;align-items:center;gap:10px;
  flex-shrink:0;z-index:100;
}
#toolbar h1{font-size:15px;color:#58a6ff;white-space:nowrap}
.sep{width:1px;height:24px;background:#30363d;flex-shrink:0}
#toolbar button{
  background:#21262d;color:#c9d1d9;border:1px solid #30363d;
  padding:4px 12px;border-radius:6px;cursor:pointer;font-size:12px;white-space:nowrap;
}
#toolbar button:hover{background:#30363d}
#toolbar button.active{background:#1f6feb;border-color:#1f6feb;color:#fff}
#searchBox{
  background:#0d1117;border:1px solid #30363d;color:#c9d1d9;
  padding:5px 10px;border-radius:6px;font-size:12px;width:220px;
}
#searchBox::placeholder{color:#484f58}
#searchBox:focus{outline:none;border-color:#58a6ff}
.toolbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}
#scanInfo{font-size:11px;color:#484f58}

/* === Main Layout === */
#main{display:flex;flex:1;overflow:hidden}

/* === Sidebar === */
#sidebar{
  width:220px;background:#0d1117;border-right:1px solid #30363d;
  overflow-y:auto;flex-shrink:0;padding:8px 0;
}
.tree-item{
  display:flex;align-items:center;padding:5px 12px;cursor:pointer;
  font-size:12px;color:#8b949e;gap:6px;border-left:2px solid transparent;
}
.tree-item:hover{background:#161b22;color:#c9d1d9}
.tree-item.active{background:#1f6feb15;color:#58a6ff;border-left-color:#58a6ff}
.tree-item .dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.tree-item .name{flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.tree-item .count{font-size:10px;color:#484f58;background:#21262d;padding:1px 6px;border-radius:8px}
.tree-section{font-size:10px;color:#484f58;padding:10px 12px 4px;text-transform:uppercase;letter-spacing:1px}

/* === Content Area === */
#content{flex:1;overflow-y:auto;padding:20px}
.breadcrumb{font-size:12px;color:#8b949e;margin-bottom:16px;display:flex;align-items:center;gap:4px}
.breadcrumb a{color:#58a6ff;cursor:pointer;text-decoration:none}
.breadcrumb a:hover{text-decoration:underline}

/* Folder Cards Grid */
.folder-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:12px}
.folder-card{
  background:#161b22;border:1px solid #30363d;border-radius:10px;
  padding:16px;cursor:pointer;transition:all 0.2s;position:relative;overflow:hidden;
}
.folder-card:hover{border-color:#58a6ff;transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,0.3)}
.folder-card .card-stripe{position:absolute;top:0;left:0;right:0;height:3px}
.folder-card .card-name{font-size:14px;font-weight:600;color:#c9d1d9;margin-bottom:2px}
.folder-card .card-desc{font-size:11px;color:#8b949e;margin-bottom:10px}
.folder-card .card-stats{display:flex;gap:6px;flex-wrap:wrap}
.folder-card .stat-badge{
  font-size:10px;padding:2px 8px;border-radius:10px;
  background:#21262d;color:#8b949e;
}
.folder-card .stat-badge.asp{color:#58a6ff;background:#58a6ff15}
.folder-card .stat-badge.js{color:#e3b341;background:#e3b34115}
.folder-card .stat-badge.html{color:#f0883e;background:#f0883e15}
.folder-card .stat-badge.css{color:#bc8cff;background:#bc8cff15}
.folder-card .stat-badge.sql{color:#3fb950;background:#3fb95015}
.folder-card .stat-badge.total{color:#c9d1d9;background:#30363d}

/* File Table */
.file-table{width:100%;border-collapse:collapse}
.file-table th{
  text-align:left;font-size:11px;color:#484f58;font-weight:500;
  padding:6px 10px;border-bottom:1px solid #21262d;position:sticky;top:0;
  background:#0d1117;cursor:pointer;user-select:none;
}
.file-table th:hover{color:#c9d1d9}
.file-table th .sort-arrow{margin-left:4px;font-size:9px}
.file-table td{padding:6px 10px;font-size:12px;border-bottom:1px solid #161b22}
.file-table tr{cursor:pointer;transition:background 0.15s}
.file-table tr:hover{background:#161b22}
.file-table tr.selected{background:#1f6feb15}
.ext-badge{
  display:inline-block;font-size:10px;padding:1px 6px;border-radius:3px;
  font-weight:600;text-transform:uppercase;min-width:32px;text-align:center;
}
.ext-asp{background:#58a6ff20;color:#58a6ff}
.ext-html,.ext-htm{background:#f0883e20;color:#f0883e}
.ext-js{background:#e3b34120;color:#e3b341}
.ext-css{background:#bc8cff20;color:#bc8cff}
.ext-sql{background:#3fb95020;color:#3fb950}
.ext-json{background:#8b949e20;color:#8b949e}
.ext-py{background:#3fb95020;color:#3fb950}
.file-size{color:#484f58;font-size:11px}
.file-folder{color:#484f58;font-size:11px}

/* === Detail Panel === */
#detail{
  width:0;background:#161b22;border-left:1px solid #30363d;
  overflow-y:auto;flex-shrink:0;transition:width 0.3s;
}
#detail.open{width:360px}
#detail-inner{padding:16px;min-width:360px}
.detail-close{
  position:sticky;top:0;background:#161b22;padding:8px 0;
  display:flex;justify-content:space-between;align-items:center;z-index:1;
}
.detail-close h2{font-size:14px;color:#58a6ff}
.detail-close button{background:none;border:none;color:#8b949e;font-size:18px;cursor:pointer}
.detail-close button:hover{color:#c9d1d9}
.detail-section{margin-top:14px}
.detail-section h3{font-size:12px;color:#f0883e;margin-bottom:6px;display:flex;align-items:center;gap:6px}
.detail-row{display:flex;justify-content:space-between;font-size:12px;padding:3px 0;color:#8b949e}
.detail-row .val{color:#c9d1d9}
.conn-btn{
  width:100%;padding:8px;margin-top:12px;
  background:#238636;color:#fff;border:1px solid #2ea043;
  border-radius:6px;cursor:pointer;font-size:12px;font-weight:600;
}
.conn-btn:hover{background:#2ea043}
.conn-btn:disabled{background:#21262d;color:#484f58;border-color:#30363d;cursor:default}
.conn-list{list-style:none;padding:0}
.conn-list li{
  font-size:12px;padding:4px 8px;margin:2px 0;border-radius:4px;
  cursor:pointer;display:flex;align-items:center;gap:6px;
}
.conn-list li:hover{background:#21262d}
.conn-list .conn-type{
  font-size:9px;padding:1px 5px;border-radius:3px;
  font-weight:600;text-transform:uppercase;flex-shrink:0;
}
.conn-type-inc{background:#7ee78720;color:#7ee787}
.conn-type-form{background:#3fb95020;color:#3fb950}
.conn-type-redir{background:#f0883e20;color:#f0883e}
.conn-type-popup{background:#bc8cff20;color:#bc8cff}
.conn-type-link{background:#58a6ff20;color:#58a6ff}
.conn-type-iframe{background:#f8514920;color:#f85149}
.conn-type-ajax{background:#e3b34120;color:#e3b341}
.conn-type-tables{background:#ff7b7220;color:#ff7b72}
.conn-type-dbconn{background:#ffa65720;color:#ffa657}

/* DB Tables */
.db-section{margin-top:14px}
.db-tables{display:flex;flex-wrap:wrap;gap:4px;margin-top:6px}
.db-tag{
  font-size:11px;padding:3px 8px;border-radius:4px;
  background:#ff7b7215;color:#ff7b72;border:1px solid #ff7b7230;
  cursor:default;
}
.db-tag:hover{background:#ff7b7225}
.crud-badges{display:flex;gap:4px;margin-top:6px}
.crud-badge{
  font-size:10px;padding:2px 8px;border-radius:3px;font-weight:700;
}
.crud-S{background:#58a6ff20;color:#58a6ff}
.crud-I{background:#3fb95020;color:#3fb950}
.crud-U{background:#e3b34120;color:#e3b341}
.crud-D{background:#f8514920;color:#f85149}
.dbconn-info{font-size:11px;color:#ffa657;margin-top:6px;word-break:break-all}

/* Mini graph */
#miniGraph{
  width:100%;height:200px;background:#0d1117;border:1px solid #30363d;
  border-radius:8px;margin-top:12px;overflow:hidden;
}
#miniGraph svg{width:100%;height:100%}
.mg-node{cursor:pointer}
.mg-node rect{rx:4;ry:4}
.mg-node text{font-size:9px;fill:#c9d1d9;text-anchor:middle;pointer-events:none}
.mg-edge{fill:none;stroke-width:1.2;opacity:0.6}
.mg-edge:hover{opacity:1;stroke-width:2}

/* === Status Bar === */
#statusbar{
  background:#161b22;border-top:1px solid #30363d;
  padding:4px 16px;font-size:11px;color:#484f58;
  display:flex;align-items:center;gap:16px;flex-shrink:0;
}

/* Loading */
.loading-overlay{
  position:fixed;inset:0;background:rgba(13,17,23,0.85);
  display:flex;align-items:center;justify-content:center;z-index:999;
}
.loading-spinner{text-align:center;color:#58a6ff}
.loading-spinner .spin{
  width:32px;height:32px;border:3px solid #30363d;border-top-color:#58a6ff;
  border-radius:50%;animation:spin 0.8s linear infinite;margin:0 auto 10px;
}
@keyframes spin{to{transform:rotate(360deg)}}

/* Search Results */
.search-results{margin-top:8px}
.search-highlight{background:#e3b34140;color:#e3b341;border-radius:2px;padding:0 2px}

/* Empty state */
.empty-state{text-align:center;padding:60px 20px;color:#484f58}
.empty-state .icon{font-size:40px;margin-bottom:12px}

/* Scrollbar */
::-webkit-scrollbar{width:8px}
::-webkit-scrollbar-track{background:#0d1117}
::-webkit-scrollbar-thumb{background:#30363d;border-radius:4px}
::-webkit-scrollbar-thumb:hover{background:#484f58}
</style>
</head>
<body>
<div id="app">
  <!-- Toolbar -->
  <div id="toolbar">
    <h1>www 아키텍처 맵</h1>
    <div class="sep"></div>
    <input id="searchBox" type="text" placeholder="파일 검색... (Ctrl+K)" autocomplete="off">
    <div class="sep"></div>
    <button class="active" data-filter="all">전체</button>
    <button data-filter="asp">ASP</button>
    <button data-filter="js">JS</button>
    <button data-filter="html">HTML</button>
    <button data-filter="css">CSS</button>
    <button data-filter="sql">SQL</button>
    <div class="toolbar-right">
      <span id="scanInfo"></span>
      <button onclick="rescan()">새로고침</button>
    </div>
  </div>

  <!-- Main -->
  <div id="main">
    <!-- Sidebar -->
    <div id="sidebar"></div>
    <!-- Content -->
    <div id="content"></div>
    <!-- Detail Panel -->
    <div id="detail"><div id="detail-inner"></div></div>
  </div>

  <!-- Status Bar -->
  <div id="statusbar">
    <span id="statFiles">파일: -</span>
    <span id="statFolders">폴더: -</span>
    <span id="statTypes"></span>
  </div>
</div>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loading">
  <div class="loading-spinner">
    <div class="spin"></div>
    <div>www 디렉토리 스캔 중...</div>
  </div>
</div>

<script>
// ===================================================================
// DATA & STATE
// ===================================================================
let allFiles = [];
let folderGroups = {};
let folderStats = {};
let currentView = 'overview';
let currentFolder = null;
let selectedFile = null;
let activeFilter = 'all';
let connCache = {};
let sortCol = 'n';
let sortAsc = true;

const FOLDER_META = {
  '':            { label: '(루트)', color: '#8b949e', desc: '최상위 파일' },
  'TNG1':        { label: 'TNG1 수주/견적', color: '#58a6ff', desc: '수주/견적 메인 시스템, 단가, 도면, 절곡' },
  'TNG2':        { label: 'TNG2 네스팅', color: '#3fb950', desc: '판재 네스팅(판풀이), OCR' },
  'TNG3':        { label: 'TNG3 경영관리', color: '#d29922', desc: '재고, 배송, 청구, 보고' },
  'TNG4':        { label: 'TNG4', color: '#6e7681', desc: '' },
  'TNG_DOOR':    { label: '도어 설계', color: '#bc8cff', desc: '도어 설계/사양 시스템 (모듈형)' },
  'TNG_WMS':     { label: 'WMS 창고', color: '#f85149', desc: '창고관리 대시보드' },
  'TNG_bom':     { label: 'BOM 관리', color: '#e3b341', desc: '자재명세서 (알루미늄, 마스터, 몰드)' },
  'mes':         { label: 'MES 생산', color: '#ff7b72', desc: '생산실행, 수주입력, 품목관리' },
  'documents':   { label: '문서 출력', color: '#79c0ff', desc: '주문서, 매뉴얼, 스티커, 절곡' },
  'report':      { label: '리포트', color: '#d2a8ff', desc: '이메일, 보고서, 잔여관리' },
  'inc':         { label: '공통 모듈', color: '#7ee787', desc: 'DB연결, 레이아웃, 인증, 페이징' },
  'balju':       { label: '발주서', color: '#ffa657', desc: '발주서 생성 (철재, AL, 멀티)' },
  'dk_material': { label: '자재 사양', color: '#a5d6ff', desc: '유리, 핸들, 힌지, 홀, 키' },
  'Door':        { label: '도어 엔진', color: '#d2a8ff', desc: '도어 계산, 프로파일 관리' },
  'orders':      { label: '주문 관리', color: '#79c0ff', desc: '주문 대시보드 (모던 UI)' },
  'wizard':      { label: '빠른 주문', color: '#ffa657', desc: '간편 주문 위저드' },
  'schema':      { label: '도면 도구', color: '#a5d6ff', desc: '도면, 기하 계산, 내보내기' },
  'nappoom':     { label: '납품/배송', color: '#7ee787', desc: '납품 목록, 배송 정보' },
  'datacenter':  { label: '데이터센터', color: '#8b949e', desc: '고객/회원 데이터' },
  'erp':         { label: 'ERP', color: '#d29922', desc: 'ERP 시스템' },
  'sso':         { label: 'SSO 인증', color: '#8b949e', desc: '통합 인증' },
  'n_inc':       { label: '신규 공통', color: '#7ee787', desc: '새 공통 모듈' },
  'doorframe':   { label: '도어 프레임', color: '#d2a8ff', desc: '도어 프레임 테스트' },
  'LYH':         { label: 'LYH 개발', color: '#6e7681', desc: '개발자 작업 파일' },
  'mem':         { label: '회원', color: '#8b949e', desc: '회원/기업 목록' },
  'collapsehome':{ label: '홈', color: '#8b949e', desc: '' },
  'sample':      { label: '샘플', color: '#6e7681', desc: '테스트/샘플' },
  'test':        { label: '테스트', color: '#6e7681', desc: '테스트 파일' },
  'doc':         { label: '문서', color: '#8b949e', desc: '' },
  'css':         { label: '전역 CSS', color: '#bc8cff', desc: '' },
  'js':          { label: '전역 JS', color: '#e3b341', desc: '' },
};

const EXT_COLORS = {
  asp:'#58a6ff', html:'#f0883e', htm:'#f0883e', js:'#e3b341',
  css:'#bc8cff', sql:'#3fb950', json:'#8b949e', py:'#3fb950', aspx:'#58a6ff'
};

const CONN_LABELS = {
  inc:'include', form:'form', redir:'redirect', popup:'popup',
  link:'link', iframe:'iframe', ajax:'ajax', tables:'DB table', dbconn:'DB연결'
};
const CONN_COLORS = {
  inc:'#7ee787', form:'#3fb950', redir:'#f0883e', popup:'#bc8cff',
  link:'#58a6ff', iframe:'#f85149', ajax:'#e3b341', tables:'#ff7b72', dbconn:'#ffa657'
};

// ===================================================================
// INIT
// ===================================================================
document.addEventListener('DOMContentLoaded', () => {
  bindToolbar();
  loadData();
});

async function loadData() {
  showLoading(true);
  try {
    const res = await fetch('architecture_map.asp?mode=scan');
    allFiles = await res.json();
    processFiles();
    renderSidebar();
    renderOverview();
    updateStatus();
  } catch(e) {
    document.getElementById('content').innerHTML =
      '<div class="empty-state"><div class="icon">!</div><div>스캔 실패: ' + e.message + '</div></div>';
  }
  showLoading(false);
}

function rescan() {
  connCache = {};
  loadData();
}

function processFiles() {
  folderGroups = {};
  allFiles.forEach(f => {
    const key = f.t || '';
    if (!folderGroups[key]) folderGroups[key] = [];
    folderGroups[key].push(f);
  });
  folderStats = {};
  Object.keys(folderGroups).forEach(k => {
    const files = folderGroups[k];
    const types = {};
    files.forEach(f => { types[f.e] = (types[f.e]||0) + 1; });
    folderStats[k] = {
      count: files.length,
      types: types,
      size: files.reduce((s,f) => s + f.s, 0)
    };
  });
}

// ===================================================================
// TOOLBAR
// ===================================================================
function bindToolbar() {
  document.querySelectorAll('#toolbar button[data-filter]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('#toolbar button[data-filter]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      activeFilter = btn.dataset.filter;
      if (currentView === 'overview') renderOverview();
      else if (currentView === 'folder') renderFolder(currentFolder);
    });
  });

  const search = document.getElementById('searchBox');
  search.addEventListener('input', () => {
    const q = search.value.trim();
    if (q.length >= 2) {
      renderSearchResults(q);
    } else if (currentView === 'search') {
      if (currentFolder) renderFolder(currentFolder);
      else renderOverview();
    }
  });

  document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
      e.preventDefault();
      search.focus();
      search.select();
    }
    if (e.key === 'Escape') {
      search.value = '';
      closeDetail();
      if (currentFolder) renderFolder(currentFolder);
      else renderOverview();
    }
  });
}

// ===================================================================
// SIDEBAR
// ===================================================================
function renderSidebar() {
  const sb = document.getElementById('sidebar');
  const sorted = Object.keys(folderGroups).sort((a,b) => {
    if (a === '') return -1;
    if (b === '') return 1;
    return a.localeCompare(b);
  });

  let html = '<div class="tree-section">폴더</div>';
  html += '<div class="tree-item' + (currentView==='overview'?' active':'') + '" data-folder="__overview__">';
  html += '<div class="dot" style="background:#58a6ff"></div>';
  html += '<span class="name">전체 개요</span>';
  html += '<span class="count">' + allFiles.length + '</span>';
  html += '</div>';

  sorted.forEach(k => {
    const meta = FOLDER_META[k] || { label: k || '(루트)', color: '#8b949e' };
    const stats = folderStats[k];
    const isActive = currentView === 'folder' && currentFolder === k;
    html += '<div class="tree-item' + (isActive?' active':'') + '" data-folder="' + escH(k) + '">';
    html += '<div class="dot" style="background:' + meta.color + '"></div>';
    html += '<span class="name">' + escH(meta.label) + '</span>';
    html += '<span class="count">' + stats.count + '</span>';
    html += '</div>';
  });

  sb.innerHTML = html;

  sb.querySelectorAll('.tree-item').forEach(el => {
    el.addEventListener('click', () => {
      const f = el.dataset.folder;
      document.getElementById('searchBox').value = '';
      if (f === '__overview__') {
        currentFolder = null;
        renderOverview();
      } else {
        currentFolder = f;
        renderFolder(f);
      }
      sb.querySelectorAll('.tree-item').forEach(e => e.classList.remove('active'));
      el.classList.add('active');
    });
  });
}

// ===================================================================
// OVERVIEW - Folder Cards
// ===================================================================
function renderOverview() {
  currentView = 'overview';
  const content = document.getElementById('content');
  const sorted = Object.keys(folderGroups).sort((a,b) => {
    if (a === '') return -1;
    if (b === '') return 1;
    const sa = folderStats[a].count, sb2 = folderStats[b].count;
    return sb2 - sa;
  });

  let html = '<div class="breadcrumb"><a onclick="renderOverview()">www</a></div>';
  html += '<div class="folder-grid">';

  sorted.forEach(k => {
    const meta = FOLDER_META[k] || { label: k || '(루트)', color: '#8b949e', desc: '' };
    const stats = folderStats[k];
    const filtered = filterFiles(folderGroups[k]);

    if (activeFilter !== 'all' && filtered.length === 0) return;

    html += '<div class="folder-card" data-folder="' + escH(k) + '">';
    html += '<div class="card-stripe" style="background:' + meta.color + '"></div>';
    html += '<div class="card-name">' + escH(meta.label) + '</div>';
    html += '<div class="card-desc">' + escH(meta.desc || k) + '</div>';
    html += '<div class="card-stats">';
    html += '<span class="stat-badge total">' + (activeFilter==='all'? stats.count : filtered.length) + '개</span>';
    if (stats.types.asp) html += '<span class="stat-badge asp">ASP ' + stats.types.asp + '</span>';
    if (stats.types.js) html += '<span class="stat-badge js">JS ' + stats.types.js + '</span>';
    if (stats.types.html || stats.types.htm) html += '<span class="stat-badge html">HTML ' + ((stats.types.html||0)+(stats.types.htm||0)) + '</span>';
    if (stats.types.css) html += '<span class="stat-badge css">CSS ' + stats.types.css + '</span>';
    if (stats.types.sql) html += '<span class="stat-badge sql">SQL ' + stats.types.sql + '</span>';
    html += '</div></div>';
  });

  html += '</div>';
  content.innerHTML = html;

  content.querySelectorAll('.folder-card').forEach(el => {
    el.addEventListener('click', () => {
      currentFolder = el.dataset.folder;
      renderFolder(currentFolder);
      updateSidebarActive(currentFolder);
    });
  });
}

// ===================================================================
// FOLDER VIEW - File Table
// ===================================================================
function renderFolder(folder) {
  currentView = 'folder';
  currentFolder = folder;
  const content = document.getElementById('content');
  const meta = FOLDER_META[folder] || { label: folder || '(루트)', color: '#8b949e' };
  const files = filterFiles(folderGroups[folder] || []);

  const subFolders = {};
  files.forEach(f => {
    const rel = f.f;
    const base = folder === '' ? '' : folder;
    if (rel !== base && rel.startsWith(base)) {
      const sub = rel.slice(base.length ? base.length + 1 : 0).split('/')[0];
      if (sub) { subFolders[sub] = (subFolders[sub]||0) + 1; }
    }
  });

  let sorted = [...files];
  sorted.sort((a,b) => {
    let va, vb;
    if (sortCol === 'n') { va = a.n.toLowerCase(); vb = b.n.toLowerCase(); }
    else if (sortCol === 's') { va = a.s; vb = b.s; }
    else if (sortCol === 'e') { va = a.e; vb = b.e; }
    else if (sortCol === 'f') { va = a.f; vb = b.f; }
    else { va = a.n; vb = b.n; }
    if (va < vb) return sortAsc ? -1 : 1;
    if (va > vb) return sortAsc ? 1 : -1;
    return 0;
  });

  let html = '<div class="breadcrumb">';
  html += '<a onclick="renderOverview();updateSidebarActive(\'__overview__\')">www</a>';
  html += ' / <span style="color:' + meta.color + '">' + escH(meta.label) + '</span>';
  html += ' <span style="color:#484f58;margin-left:8px">' + files.length + '개 파일</span>';
  html += '</div>';

  if (Object.keys(subFolders).length > 0) {
    html += '<div style="margin-bottom:12px;display:flex;gap:6px;flex-wrap:wrap">';
    Object.keys(subFolders).sort().forEach(sf => {
      html += '<span class="stat-badge" style="cursor:pointer;color:#58a6ff" title="' + sf + '/">' + sf + '/ (' + subFolders[sf] + ')</span>';
    });
    html += '</div>';
  }

  if (files.length === 0) {
    html += '<div class="empty-state"><div class="icon">-</div><div>파일 없음</div></div>';
  } else {
    html += '<table class="file-table"><thead><tr>';
    html += thSortable('n', '파일명');
    html += thSortable('e', '타입');
    html += thSortable('f', '경로');
    html += thSortable('s', '크기');
    html += '</tr></thead><tbody>';

    sorted.forEach(f => {
      const sel = selectedFile && selectedFile.p === f.p ? ' selected' : '';
      html += '<tr class="file-row' + sel + '" data-path="' + escH(f.p) + '">';
      html += '<td><span class="ext-badge ext-' + f.e + '">' + f.e + '</span> ' + escH(f.n) + '</td>';
      html += '<td><span class="ext-badge ext-' + f.e + '">' + f.e.toUpperCase() + '</span></td>';
      html += '<td class="file-folder">' + escH(f.f) + '</td>';
      html += '<td class="file-size">' + fmtSize(f.s) + '</td>';
      html += '</tr>';
    });

    html += '</tbody></table>';
  }

  content.innerHTML = html;

  content.querySelectorAll('.file-row').forEach(el => {
    el.addEventListener('click', () => {
      content.querySelectorAll('.file-row').forEach(r => r.classList.remove('selected'));
      el.classList.add('selected');
      const file = allFiles.find(f => f.p === el.dataset.path);
      if (file) showFileDetail(file);
    });
  });

  content.querySelectorAll('.file-table th[data-col]').forEach(el => {
    el.addEventListener('click', () => {
      const col = el.dataset.col;
      if (sortCol === col) sortAsc = !sortAsc;
      else { sortCol = col; sortAsc = true; }
      renderFolder(folder);
    });
  });
}

function thSortable(col, label) {
  const arrow = sortCol === col ? (sortAsc ? ' &#9650;' : ' &#9660;') : '';
  return '<th data-col="' + col + '">' + label + '<span class="sort-arrow">' + arrow + '</span></th>';
}

// ===================================================================
// SEARCH
// ===================================================================
function renderSearchResults(query) {
  currentView = 'search';
  const content = document.getElementById('content');
  const q = query.toLowerCase();
  let results = allFiles.filter(f => f.n.toLowerCase().includes(q) || f.p.toLowerCase().includes(q));
  results = filterFiles(results);

  let html = '<div class="breadcrumb"><a onclick="renderOverview();updateSidebarActive(\'__overview__\')">www</a>';
  html += ' / 검색: "' + escH(query) + '" <span style="color:#484f58">' + results.length + '개 결과</span></div>';

  if (results.length === 0) {
    html += '<div class="empty-state"><div class="icon">?</div><div>검색 결과 없음</div></div>';
  } else {
    html += '<table class="file-table"><thead><tr>';
    html += '<th>파일명</th><th>타입</th><th>경로</th><th>크기</th>';
    html += '</tr></thead><tbody>';

    results.slice(0, 200).forEach(f => {
      html += '<tr class="file-row" data-path="' + escH(f.p) + '">';
      html += '<td><span class="ext-badge ext-' + f.e + '">' + f.e + '</span> ' + highlightMatch(f.n, query) + '</td>';
      html += '<td><span class="ext-badge ext-' + f.e + '">' + f.e.toUpperCase() + '</span></td>';
      html += '<td class="file-folder">' + highlightMatch(f.p, query) + '</td>';
      html += '<td class="file-size">' + fmtSize(f.s) + '</td>';
      html += '</tr>';
    });
    html += '</tbody></table>';
    if (results.length > 200) {
      html += '<div style="text-align:center;padding:12px;color:#484f58;font-size:12px">... 외 ' + (results.length-200) + '개</div>';
    }
  }

  content.innerHTML = html;
  content.querySelectorAll('.file-row').forEach(el => {
    el.addEventListener('click', () => {
      const file = allFiles.find(f => f.p === el.dataset.path);
      if (file) showFileDetail(file);
    });
  });
}

function highlightMatch(text, query) {
  const idx = text.toLowerCase().indexOf(query.toLowerCase());
  if (idx === -1) return escH(text);
  return escH(text.slice(0, idx))
    + '<span class="search-highlight">' + escH(text.slice(idx, idx + query.length)) + '</span>'
    + escH(text.slice(idx + query.length));
}

// ===================================================================
// DETAIL PANEL
// ===================================================================
function showFileDetail(file) {
  selectedFile = file;
  const panel = document.getElementById('detail');
  const inner = document.getElementById('detail-inner');
  const meta = FOLDER_META[file.t] || { color: '#8b949e' };

  let html = '<div class="detail-close">';
  html += '<h2>' + escH(file.n) + '</h2>';
  html += '<button onclick="closeDetail()">&times;</button>';
  html += '</div>';

  html += '<div class="detail-section">';
  html += '<h3>파일 정보</h3>';
  html += '<div class="detail-row"><span>경로</span><span class="val">' + escH(file.p) + '</span></div>';
  html += '<div class="detail-row"><span>폴더</span><span class="val" style="color:' + meta.color + '">' + escH(file.t || '(루트)') + '</span></div>';
  html += '<div class="detail-row"><span>타입</span><span class="val"><span class="ext-badge ext-' + file.e + '">' + file.e.toUpperCase() + '</span></span></div>';
  html += '<div class="detail-row"><span>크기</span><span class="val">' + fmtSize(file.s) + '</span></div>';
  html += '</div>';

  html += '<button class="conn-btn" id="connBtn" onclick="analyzeConnections(\'' + escH(file.p).replace(/'/g,"\\'") + '\')">연결 + DB 분석</button>';
  html += '<div id="connResult"></div>';
  html += '<div id="miniGraph"></div>';

  inner.innerHTML = html;
  panel.classList.add('open');

  if (connCache[file.p]) {
    renderConnections(connCache[file.p]);
  }
}

function closeDetail() {
  document.getElementById('detail').classList.remove('open');
  selectedFile = null;
}

async function analyzeConnections(filePath) {
  const btn = document.getElementById('connBtn');
  btn.disabled = true;
  btn.textContent = '분석 중...';

  try {
    if (connCache[filePath]) {
      renderConnections(connCache[filePath]);
    } else {
      const res = await fetch('architecture_map.asp?mode=parse&file=' + encodeURIComponent(filePath));
      const data = await res.json();
      if (data.error) {
        document.getElementById('connResult').innerHTML =
          '<div style="color:#f85149;font-size:12px;margin-top:8px">' + data.error + '</div>';
      } else {
        connCache[filePath] = data;
        renderConnections(data);
      }
    }
  } catch(e) {
    document.getElementById('connResult').innerHTML =
      '<div style="color:#f85149;font-size:12px;margin-top:8px">오류: ' + e.message + '</div>';
  }

  btn.disabled = false;
  btn.textContent = '연결 분석';
}

function renderConnections(data) {
  const el = document.getElementById('connResult');
  const types = ['inc','form','redir','popup','link','iframe','ajax'];
  let total = 0;
  let html = '';

  // === DB Tables Section (always first) ===
  if (data.tables && data.tables.length > 0) {
    html += '<div class="db-section"><h3 style="font-size:12px;color:#ff7b72;margin-bottom:6px;display:flex;align-items:center;gap:6px">';
    html += '<span class="conn-type conn-type-tables">DB</span> ';
    html += '테이블 ' + data.tables.length + '개</h3>';

    // CRUD badges
    if (data.crud && data.crud.length > 0) {
      html += '<div class="crud-badges">';
      data.crud.forEach(op => {
        const cls = 'crud-' + op.charAt(0);
        html += '<span class="crud-badge ' + cls + '">' + op + '</span>';
      });
      html += '</div>';
    }

    // Table tags
    html += '<div class="db-tables">';
    data.tables.forEach(tbl => {
      html += '<span class="db-tag">' + escH(tbl) + '</span>';
    });
    html += '</div></div>';
  }

  // === DB Connection Info ===
  if (data.dbconn && data.dbconn.length > 0) {
    html += '<div class="detail-section"><h3>';
    html += '<span class="conn-type conn-type-dbconn">DB연결</span></h3>';
    html += '<div class="dbconn-info">';
    data.dbconn.forEach(c => { html += escH(c) + '<br>'; });
    html += '</div></div>';
  }

  // === File Connections ===
  types.forEach(type => {
    const arr = data[type];
    if (!arr || arr.length === 0) return;
    total += arr.length;
    html += '<div class="detail-section"><h3>';
    html += '<span class="conn-type conn-type-' + type + '">' + CONN_LABELS[type] + '</span> ';
    html += arr.length + '개</h3>';
    html += '<ul class="conn-list">';
    arr.forEach(target => {
      const resolved = resolvePath(data.file, target);
      const exists = allFiles.find(f => f.p === resolved || f.p.endsWith('/' + target) || f.n === target.split('/').pop());
      html += '<li onclick="navigateToFile(\'' + escH(target).replace(/'/g,"\\'") + '\',\'' + escH(data.file).replace(/'/g,"\\'") + '\')">';
      html += '<span class="conn-type conn-type-' + type + '">' + CONN_LABELS[type] + '</span>';
      html += '<span style="color:' + (exists ? '#c9d1d9' : '#484f58') + '">' + escH(target) + '</span>';
      if (!exists) html += ' <span style="color:#484f58;font-size:10px">(외부)</span>';
      html += '</li>';
    });
    html += '</ul></div>';
  });

  const hasDB = (data.tables && data.tables.length > 0);
  if (total === 0 && !hasDB) {
    html = '<div style="color:#484f58;font-size:12px;margin-top:12px;text-align:center">연결 없음</div>';
  }

  el.innerHTML = html;

  if (total > 0) renderMiniGraph(data);
}

// ===================================================================
// MINI CONNECTION GRAPH (SVG)
// ===================================================================
function renderMiniGraph(data) {
  const container = document.getElementById('miniGraph');
  const W = 328, H = 200;
  const types = ['inc','form','redir','popup','link','iframe','ajax'];
  const targets = [];

  types.forEach(type => {
    (data[type] || []).forEach(t => {
      targets.push({ name: t, type: type });
    });
  });

  if (targets.length === 0) { container.innerHTML = ''; return; }

  const centerX = W / 2, centerY = H / 2;
  const centerFile = data.file.split('/').pop();

  let svg = '<svg viewBox="0 0 ' + W + ' ' + H + '" xmlns="http://www.w3.org/2000/svg">';

  const radius = Math.min(W, H) * 0.35;
  const angleStep = (2 * Math.PI) / Math.max(targets.length, 1);

  targets.forEach((t, i) => {
    const angle = angleStep * i - Math.PI / 2;
    const tx = centerX + Math.cos(angle) * radius;
    const ty = centerY + Math.sin(angle) * radius;
    const color = CONN_COLORS[t.type] || '#8b949e';
    const shortName = t.name.split('/').pop();
    const truncName = shortName.length > 18 ? shortName.slice(0,16) + '..' : shortName;

    svg += '<line x1="' + centerX + '" y1="' + centerY + '" x2="' + tx + '" y2="' + ty
        + '" stroke="' + color + '" stroke-width="1.2" opacity="0.5" class="mg-edge"/>';

    svg += '<g class="mg-node" transform="translate(' + tx + ',' + ty + ')">';
    svg += '<rect x="-40" y="-10" width="80" height="20" fill="' + color + '22" stroke="' + color + '" stroke-width="1" rx="4"/>';
    svg += '<text y="4" font-size="8" fill="' + color + '" text-anchor="middle">' + escH(truncName) + '</text>';
    svg += '</g>';
  });

  svg += '<g class="mg-node" transform="translate(' + centerX + ',' + centerY + ')">';
  svg += '<rect x="-50" y="-12" width="100" height="24" fill="#1f6feb" stroke="#58a6ff" stroke-width="2" rx="5"/>';
  const truncCenter = centerFile.length > 16 ? centerFile.slice(0,14) + '..' : centerFile;
  svg += '<text y="4" font-size="9" fill="#fff" text-anchor="middle" font-weight="600">' + escH(truncCenter) + '</text>';
  svg += '</g>';

  svg += '</svg>';
  container.innerHTML = svg;
}

// ===================================================================
// NAVIGATION HELPERS
// ===================================================================
function navigateToFile(target, fromFile) {
  const resolved = resolvePath(fromFile, target);
  const file = allFiles.find(f => f.p === resolved)
    || allFiles.find(f => f.p.endsWith('/' + target))
    || allFiles.find(f => f.n === target.split('/').pop());
  if (file) {
    currentFolder = file.t;
    renderFolder(file.t);
    updateSidebarActive(file.t);
    showFileDetail(file);
    setTimeout(() => {
      const row = document.querySelector('.file-row[data-path="' + file.p + '"]');
      if (row) {
        row.classList.add('selected');
        row.scrollIntoView({ behavior:'smooth', block:'center' });
      }
    }, 100);
  }
}

function resolvePath(basePath, ref) {
  if (ref.startsWith('/')) return ref.slice(1);
  const baseDir = basePath.substring(0, basePath.lastIndexOf('/') + 1);
  const parts = (baseDir + ref).split('/');
  const resolved = [];
  parts.forEach(p => {
    if (p === '..') resolved.pop();
    else if (p !== '.' && p !== '') resolved.push(p);
  });
  return resolved.join('/');
}

function updateSidebarActive(folder) {
  document.querySelectorAll('#sidebar .tree-item').forEach(el => {
    el.classList.toggle('active',
      (folder === '__overview__' && el.dataset.folder === '__overview__') ||
      el.dataset.folder === folder
    );
  });
}

// ===================================================================
// FILTER & UTILITY
// ===================================================================
function filterFiles(files) {
  if (activeFilter === 'all') return files;
  return files.filter(f => f.e === activeFilter || (activeFilter === 'html' && f.e === 'htm'));
}

function fmtSize(bytes) {
  if (bytes < 1024) return bytes + ' B';
  if (bytes < 1024*1024) return (bytes/1024).toFixed(1) + ' KB';
  return (bytes/1024/1024).toFixed(1) + ' MB';
}

function escH(s) {
  if (!s) return '';
  return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function showLoading(show) {
  document.getElementById('loading').style.display = show ? 'flex' : 'none';
}

function updateStatus() {
  const types = {};
  allFiles.forEach(f => { types[f.e] = (types[f.e]||0) + 1; });
  document.getElementById('statFiles').textContent = '파일: ' + allFiles.length + '개';
  document.getElementById('statFolders').textContent = '폴더: ' + Object.keys(folderGroups).length + '개';

  let typeStr = '';
  Object.keys(types).sort((a,b) => types[b]-types[a]).forEach(ext => {
    typeStr += ext.toUpperCase() + ':' + types[ext] + ' ';
  });
  document.getElementById('statTypes').textContent = typeStr.trim();
  document.getElementById('scanInfo').textContent = '스캔: ' + new Date().toLocaleTimeString('ko-KR');
}
</script>
</body>
</html>