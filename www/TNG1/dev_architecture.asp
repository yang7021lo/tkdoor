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
    re.Pattern = "(FROM|JOIN|INTO|UPDATE)\s+\[?([A-Za-z_][A-Za-z0-9_]*)\]?"
    json = json & ",""tables"":" & MatchJSON(re, content, 1)

    ' === CRUD Detection ===
    Dim hasSelect, hasInsert, hasUpdate, hasDelete
    Dim reC
    Set reC = New RegExp
    reC.IgnoreCase = True
    reC.Global = False
    reC.Pattern = "SELECT\s+.+FROM\s+"
    hasSelect = reC.Test(content)
    reC.Pattern = "INSERT\s+INTO\s+"
    hasInsert = reC.Test(content)
    reC.Pattern = "UPDATE\s+.+SET\s+"
    hasUpdate = reC.Test(content)
    reC.Pattern = "DELETE\s+FROM\s+"
    hasDelete = reC.Test(content)
    json = json & ",""crud"":["
    Dim cf : cf = True
    If hasSelect Then json = json & """SELECT""" : cf = False
    If hasInsert Then
        If Not cf Then json = json & ","
        json = json & """INSERT""" : cf = False
    End If
    If hasUpdate Then
        If Not cf Then json = json & ","
        json = json & """UPDATE""" : cf = False
    End If
    If hasDelete Then
        If Not cf Then json = json & ","
        json = json & """DELETE"""
    End If
    json = json & "]"
    Set reC = Nothing

    ' === DB Connection Info ===
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
<title>개발 아키텍처 맵 + DDL 자동완성</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Malgun Gothic','Segoe UI',sans-serif;background:#0d1117;color:#c9d1d9;overflow:hidden;height:100vh}
#app{display:flex;flex-direction:column;height:100vh}

/* === Top Nav Tabs === */
#topnav{background:#010409;border-bottom:1px solid #30363d;display:flex;align-items:center;padding:0 16px;gap:0;flex-shrink:0}
.nav-tab{padding:10px 18px;font-size:13px;color:#8b949e;cursor:pointer;border-bottom:2px solid transparent;transition:all 0.2s;font-weight:500}
.nav-tab:hover{color:#c9d1d9;background:#161b22}
.nav-tab.active{color:#58a6ff;border-bottom-color:#58a6ff}
.nav-tab .badge{font-size:10px;padding:1px 6px;border-radius:8px;background:#21262d;color:#8b949e;margin-left:6px}
.nav-sep{width:1px;height:20px;background:#30363d;margin:0 4px}

/* === DDL Search Panel (always visible) === */
#ddl-panel{
  position:fixed;right:0;top:0;bottom:0;width:0;
  background:#161b22;border-left:1px solid #30363d;
  z-index:200;transition:width 0.3s;overflow:hidden;
}
#ddl-panel.open{width:420px}
#ddl-inner{min-width:420px;padding:12px 16px;height:100%;display:flex;flex-direction:column}
#ddl-searchbox{
  width:100%;padding:8px 12px;background:#0d1117;border:1px solid #30363d;
  color:#c9d1d9;border-radius:6px;font-size:13px;margin-bottom:8px;
}
#ddl-searchbox:focus{outline:none;border-color:#58a6ff}
#ddl-searchbox::placeholder{color:#484f58}
#ddl-stats{font-size:11px;color:#484f58;margin-bottom:8px;display:flex;justify-content:space-between}
#ddl-results{flex:1;overflow-y:auto}
.ddl-table{margin-bottom:8px;border:1px solid #21262d;border-radius:6px;overflow:hidden}
.ddl-table-header{
  padding:6px 10px;background:#21262d;font-size:12px;font-weight:600;
  cursor:pointer;display:flex;justify-content:space-between;align-items:center;
}
.ddl-table-header:hover{background:#30363d}
.ddl-table-header .tname{color:#f0883e}
.ddl-table-header .tcnt{color:#484f58;font-size:10px}
.ddl-table-cols{padding:4px 0;display:none;background:#0d1117}
.ddl-table-cols.open{display:block}
.ddl-col{padding:2px 10px 2px 20px;font-size:11px;color:#8b949e;cursor:pointer;display:flex;justify-content:space-between}
.ddl-col:hover{background:#161b22;color:#c9d1d9}
.ddl-col .col-name{color:#c9d1d9}
.ddl-col .col-copy{color:#484f58;font-size:10px;visibility:hidden}
.ddl-col:hover .col-copy{visibility:visible;color:#58a6ff}
.ddl-highlight{background:#e3b34140;color:#e3b341;border-radius:2px;padding:0 1px}
#ddl-toggle{
  position:fixed;right:12px;bottom:12px;z-index:300;
  background:#238636;color:#fff;border:none;padding:8px 16px;border-radius:20px;
  cursor:pointer;font-size:12px;font-weight:600;box-shadow:0 4px 12px rgba(0,0,0,0.4);
}
#ddl-toggle:hover{background:#2ea043}
#ddl-toggle.shifted{right:432px}
.ddl-copied{position:fixed;bottom:60px;right:20px;z-index:400;background:#238636;color:#fff;padding:6px 12px;border-radius:6px;font-size:12px;display:none}

/* === Tab Content === */
.tab-content{display:none;flex:1;overflow:hidden}
.tab-content.active{display:flex;flex-direction:column}

/* =============== TAB1: www 아키텍처 (from architecture_map) =============== */
#tab1-toolbar{
  background:#161b22;border-bottom:1px solid #30363d;
  padding:8px 16px;display:flex;align-items:center;gap:10px;flex-shrink:0;
}
#tab1-toolbar button{
  background:#21262d;color:#c9d1d9;border:1px solid #30363d;
  padding:4px 12px;border-radius:6px;cursor:pointer;font-size:12px;white-space:nowrap;
}
#tab1-toolbar button:hover{background:#30363d}
#tab1-toolbar button.active{background:#1f6feb;border-color:#1f6feb;color:#fff}
#tab1-search{
  background:#0d1117;border:1px solid #30363d;color:#c9d1d9;
  padding:5px 10px;border-radius:6px;font-size:12px;width:220px;
}
#tab1-search::placeholder{color:#484f58}
#tab1-search:focus{outline:none;border-color:#58a6ff}
.sep{width:1px;height:24px;background:#30363d;flex-shrink:0}
.toolbar-right{margin-left:auto;display:flex;align-items:center;gap:8px}

#tab1-main{display:flex;flex:1;overflow:hidden}
#tab1-sidebar{width:220px;background:#0d1117;border-right:1px solid #30363d;overflow-y:auto;flex-shrink:0;padding:8px 0}
.tree-item{display:flex;align-items:center;padding:5px 12px;cursor:pointer;font-size:12px;color:#8b949e;gap:6px;border-left:2px solid transparent}
.tree-item:hover{background:#161b22;color:#c9d1d9}
.tree-item.active{background:#1f6feb15;color:#58a6ff;border-left-color:#58a6ff}
.tree-item .dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.tree-item .name{flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.tree-item .count{font-size:10px;color:#484f58;background:#21262d;padding:1px 6px;border-radius:8px}
.tree-section{font-size:10px;color:#484f58;padding:10px 12px 4px;text-transform:uppercase;letter-spacing:1px}

#tab1-content{flex:1;overflow-y:auto;padding:20px}
.breadcrumb{font-size:12px;color:#8b949e;margin-bottom:16px;display:flex;align-items:center;gap:4px}
.breadcrumb a{color:#58a6ff;cursor:pointer;text-decoration:none}
.breadcrumb a:hover{text-decoration:underline}
.folder-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:12px}
.folder-card{background:#161b22;border:1px solid #30363d;border-radius:10px;padding:16px;cursor:pointer;transition:all 0.2s;position:relative;overflow:hidden}
.folder-card:hover{border-color:#58a6ff;transform:translateY(-2px);box-shadow:0 4px 12px rgba(0,0,0,0.3)}
.folder-card .card-stripe{position:absolute;top:0;left:0;right:0;height:3px}
.folder-card .card-name{font-size:14px;font-weight:600;color:#c9d1d9;margin-bottom:2px}
.folder-card .card-desc{font-size:11px;color:#8b949e;margin-bottom:10px}
.folder-card .card-stats{display:flex;gap:6px;flex-wrap:wrap}
.stat-badge{font-size:10px;padding:2px 8px;border-radius:10px;background:#21262d;color:#8b949e}
.stat-badge.asp{color:#58a6ff;background:#58a6ff15}
.stat-badge.js{color:#e3b341;background:#e3b34115}
.stat-badge.html{color:#f0883e;background:#f0883e15}
.stat-badge.css{color:#bc8cff;background:#bc8cff15}
.stat-badge.sql{color:#3fb950;background:#3fb95015}
.stat-badge.total{color:#c9d1d9;background:#30363d}

.file-table{width:100%;border-collapse:collapse}
.file-table th{text-align:left;font-size:11px;color:#484f58;font-weight:500;padding:6px 10px;border-bottom:1px solid #21262d;position:sticky;top:0;background:#0d1117;cursor:pointer;user-select:none}
.file-table th:hover{color:#c9d1d9}
.file-table td{padding:6px 10px;font-size:12px;border-bottom:1px solid #161b22}
.file-table tr{cursor:pointer;transition:background 0.15s}
.file-table tr:hover{background:#161b22}
.file-table tr.selected{background:#1f6feb15}
.ext-badge{display:inline-block;font-size:10px;padding:1px 6px;border-radius:3px;font-weight:600;text-transform:uppercase;min-width:32px;text-align:center}
.ext-asp{background:#58a6ff20;color:#58a6ff}
.ext-html,.ext-htm{background:#f0883e20;color:#f0883e}
.ext-js{background:#e3b34120;color:#e3b341}
.ext-css{background:#bc8cff20;color:#bc8cff}
.ext-sql{background:#3fb95020;color:#3fb950}
.ext-json{background:#8b949e20;color:#8b949e}
.ext-py{background:#3fb95020;color:#3fb950}
.file-size{color:#484f58;font-size:11px}
.file-folder{color:#484f58;font-size:11px}

#tab1-detail{width:0;background:#161b22;border-left:1px solid #30363d;overflow-y:auto;flex-shrink:0;transition:width 0.3s}
#tab1-detail.open{width:360px}
#tab1-detail-inner{padding:16px;min-width:360px}
.detail-close{position:sticky;top:0;background:#161b22;padding:8px 0;display:flex;justify-content:space-between;align-items:center;z-index:1}
.detail-close h2{font-size:14px;color:#58a6ff}
.detail-close button{background:none;border:none;color:#8b949e;font-size:18px;cursor:pointer}
.detail-close button:hover{color:#c9d1d9}
.detail-section{margin-top:14px}
.detail-section h3{font-size:12px;color:#f0883e;margin-bottom:6px;display:flex;align-items:center;gap:6px}
.detail-row{display:flex;justify-content:space-between;font-size:12px;padding:3px 0;color:#8b949e}
.detail-row .val{color:#c9d1d9}
.conn-btn{width:100%;padding:8px;margin-top:12px;background:#238636;color:#fff;border:1px solid #2ea043;border-radius:6px;cursor:pointer;font-size:12px;font-weight:600}
.conn-btn:hover{background:#2ea043}
.conn-btn:disabled{background:#21262d;color:#484f58;border-color:#30363d;cursor:default}
.conn-list{list-style:none;padding:0}
.conn-list li{font-size:12px;padding:4px 8px;margin:2px 0;border-radius:4px;cursor:pointer;display:flex;align-items:center;gap:6px}
.conn-list li:hover{background:#21262d}
.conn-list .conn-type{font-size:9px;padding:1px 5px;border-radius:3px;font-weight:600;text-transform:uppercase;flex-shrink:0}
.conn-type-inc{background:#7ee78720;color:#7ee787}
.conn-type-form{background:#3fb95020;color:#3fb950}
.conn-type-redir{background:#f0883e20;color:#f0883e}
.conn-type-popup{background:#bc8cff20;color:#bc8cff}
.conn-type-link{background:#58a6ff20;color:#58a6ff}
.conn-type-iframe{background:#f8514920;color:#f85149}
.conn-type-ajax{background:#e3b34120;color:#e3b341}
.conn-type-tables{background:#ff7b7220;color:#ff7b72}
.conn-type-dbconn{background:#ffa65720;color:#ffa657}
.db-section{margin-top:14px}
.db-tables{display:flex;flex-wrap:wrap;gap:4px;margin-top:6px}
.db-tag{font-size:11px;padding:3px 8px;border-radius:4px;background:#ff7b7215;color:#ff7b72;border:1px solid #ff7b7230;cursor:pointer}
.db-tag:hover{background:#ff7b7225}
.crud-badges{display:flex;gap:4px;margin-top:6px}
.crud-badge{font-size:10px;padding:2px 8px;border-radius:3px;font-weight:700}
.crud-S{background:#58a6ff20;color:#58a6ff}
.crud-I{background:#3fb95020;color:#3fb950}
.crud-U{background:#e3b34120;color:#e3b341}
.crud-D{background:#f8514920;color:#f85149}
.dbconn-info{font-size:11px;color:#ffa657;margin-top:6px;word-break:break-all}

#miniGraph{width:100%;height:200px;background:#0d1117;border:1px solid #30363d;border-radius:8px;margin-top:12px;overflow:hidden}
#miniGraph svg{width:100%;height:100%}

/* === Status Bar === */
#statusbar{background:#161b22;border-top:1px solid #30363d;padding:4px 16px;font-size:11px;color:#484f58;display:flex;align-items:center;gap:16px;flex-shrink:0}

/* Loading */
.loading-overlay{position:fixed;inset:0;background:rgba(13,17,23,0.85);display:flex;align-items:center;justify-content:center;z-index:999}
.loading-spinner{text-align:center;color:#58a6ff}
.loading-spinner .spin{width:32px;height:32px;border:3px solid #30363d;border-top-color:#58a6ff;border-radius:50%;animation:spin 0.8s linear infinite;margin:0 auto 10px}
@keyframes spin{to{transform:rotate(360deg)}}
.search-highlight{background:#e3b34140;color:#e3b341;border-radius:2px;padding:0 2px}
.empty-state{text-align:center;padding:60px 20px;color:#484f58}
.empty-state .icon{font-size:40px;margin-bottom:12px}

/* =============== TAB2: TNG1 시스템 (from TNG1_architecture) =============== */
#tab2-toolbar{
  background:#161b22;border-bottom:1px solid #30363d;
  padding:8px 16px;display:flex;align-items:center;gap:12px;flex-shrink:0;
}
#tab2-toolbar button{background:#21262d;color:#c9d1d9;border:1px solid #30363d;padding:4px 12px;border-radius:6px;cursor:pointer;font-size:12px}
#tab2-toolbar button:hover{background:#30363d}
#tab2-toolbar button.active{background:#1f6feb;border-color:#1f6feb;color:#fff}
.center-btn.active{background:#da3633!important;border-color:#f85149!important;color:#fff!important}
.legend{display:flex;gap:12px;margin-left:auto;font-size:11px}
.legend-item{display:flex;align-items:center;gap:4px}
.legend-dot{width:10px;height:10px;border-radius:50%}
#tab2-canvas{flex:1;position:relative}
#tab2-canvas svg{width:100%;height:100%}

#tab2-detail{
  position:fixed;right:-400px;top:40px;bottom:0;width:400px;
  background:#161b22;border-left:1px solid #30363d;
  transition:right 0.3s;z-index:50;overflow-y:auto;padding:16px;
}
#tab2-detail.open{right:0}
#tab2-detail h2{color:#58a6ff;font-size:16px;margin-bottom:12px}
#tab2-detail .close-btn{position:absolute;top:8px;right:12px;background:none;border:none;color:#8b949e;font-size:20px;cursor:pointer}
#tab2-detail h3{color:#f0883e;font-size:13px;margin:12px 0 4px}
#tab2-detail ul{padding-left:16px;font-size:12px;line-height:1.8}
#tab2-detail li{color:#8b949e}
.tag{display:inline-block;background:#1f6feb22;color:#58a6ff;padding:1px 6px;border-radius:3px;font-size:11px;margin:1px}
.tag-db{background:#f0883e22;color:#f0883e}

.node-group{cursor:pointer}
.node-group:hover .node-rect{filter:brightness(1.3)}
.node-rect{rx:8;ry:8;stroke-width:1.5}
.node-label{font-size:11px;fill:#fff;text-anchor:middle;pointer-events:none;font-weight:600}
.node-sublabel{font-size:9px;fill:#8b949e;text-anchor:middle;pointer-events:none}
.edge{fill:none;stroke-width:1.2;opacity:0.5}
.edge:hover{opacity:1;stroke-width:2.5}
.edge-label{font-size:8px;fill:#484f58}
marker path{stroke:none}

/* Scrollbar */
::-webkit-scrollbar{width:8px}
::-webkit-scrollbar-track{background:#0d1117}
::-webkit-scrollbar-thumb{background:#30363d;border-radius:4px}
::-webkit-scrollbar-thumb:hover{background:#484f58}
</style>
</head>
<body>
<div id="app">
  <!-- Top Navigation -->
  <div id="topnav">
    <div class="nav-tab active" data-tab="tab1">📁 www 전체 아키텍처</div>
    <div class="nav-tab" data-tab="tab2">🔗 TNG1 수주/견적</div>
    <div class="nav-sep"></div>
    <div class="nav-tab" onclick="toggleDDL()" style="color:#3fb950">🗄 DDL 자동완성 <span class="badge" id="ddl-badge">198</span></div>
  </div>

  <!-- TAB1: www Architecture Map -->
  <div id="tab1" class="tab-content active">
    <div id="tab1-toolbar">
      <input id="tab1-search" type="text" placeholder="파일 검색... (Ctrl+K)" autocomplete="off">
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
    <div id="tab1-main">
      <div id="tab1-sidebar"></div>
      <div id="tab1-content"></div>
      <div id="tab1-detail"><div id="tab1-detail-inner"></div></div>
    </div>
  </div>

  <!-- TAB2: TNG1 System Architecture -->
  <div id="tab2" class="tab-content">
    <div id="tab2-toolbar">
      <button class="active" onclick="t2SetFilter('all')">전체</button>
      <button onclick="t2SetFilter('core')">핵심</button>
      <button onclick="t2SetFilter('suju')">수주입력</button>
      <button onclick="t2SetFilter('door')">도어</button>
      <button onclick="t2SetFilter('greem')">도면</button>
      <button onclick="t2SetFilter('julgok')">절곡</button>
      <button onclick="t2SetFilter('price')">단가</button>
      <button onclick="t2SetFilter('stain')">품목</button>
      <button onclick="t2SetFilter('balju')">발주서</button>
      <button onclick="t2SetFilter('print')">출력</button>
      <button onclick="t2SetFilter('data')">첨부</button>
      <button onclick="t2SetFilter('external')">외부</button>
      <div class="sep"></div>
      <span style="color:#8b949e;font-size:11px">중심:</span>
      <button class="center-btn active" data-center="TNG1_B" onclick="t2SetCenter('TNG1_B')">TNG1_B</button>
      <button class="center-btn" data-center="suju_quick" onclick="t2SetCenter('suju_quick')">빠른수주</button>
      <div class="sep"></div>
      <button onclick="t2ResetView()">리셋</button>
      <div class="legend">
        <div class="legend-item"><div class="legend-dot" style="background:#58a6ff"></div>메인</div>
        <div class="legend-item"><div class="legend-dot" style="background:#3fb950"></div>DB</div>
        <div class="legend-item"><div class="legend-dot" style="background:#f0883e"></div>팝업</div>
        <div class="legend-item"><div class="legend-dot" style="background:#bc8cff"></div>외부</div>
        <div class="legend-item"><div class="legend-dot" style="background:#f85149"></div>출력</div>
        <div class="legend-item"><div class="legend-dot" style="background:#e3b341"></div>AJAX</div>
      </div>
    </div>
    <div id="tab2-canvas"></div>
    <div id="tab2-detail"><button class="close-btn" onclick="t2ClosePanel()">&times;</button><div id="tab2-detail-content"></div></div>
  </div>

  <!-- Status Bar -->
  <div id="statusbar">
    <span id="statFiles">파일: -</span>
    <span id="statFolders">폴더: -</span>
    <span id="statTypes"></span>
    <span style="margin-left:auto" id="statDDL">DDL: 198 테이블</span>
  </div>
</div>

<!-- DDL Panel -->
<div id="ddl-panel">
  <div id="ddl-inner">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
      <span style="font-size:14px;font-weight:600;color:#3fb950">🗄 DDL 자동완성</span>
      <button onclick="toggleDDL()" style="background:none;border:none;color:#8b949e;font-size:18px;cursor:pointer">&times;</button>
    </div>
    <input id="ddl-searchbox" type="text" placeholder="테이블/컬럼명 검색... (예: sja, sjidx, customer)" autocomplete="off">
    <div id="ddl-stats">
      <span id="ddl-stat-text">198 테이블 · 2864 컬럼</span>
      <span id="ddl-stat-filter"></span>
    </div>
    <div id="ddl-results"></div>
  </div>
</div>
<button id="ddl-toggle" onclick="toggleDDL()">🗄 DDL</button>
<div class="ddl-copied" id="ddl-copied">📋 복사됨!</div>

<!-- Loading -->
<div class="loading-overlay" id="loading" style="display:none">
  <div class="loading-spinner"><div class="spin"></div><div>www 디렉토리 스캔 중...</div></div>
</div>

<script>
const DDL_SCHEMA = {"A_Category":["CategoryID","CategoryName"],"A_RequestItemFile":["FileID","ItemID","FileName","FilePath","UploadedAt","UploadedBy","RequestID"],"A_Supplier":["SupplierID","SupplierName","Address","ContactName","ContactPhone","ContactEmail","Notes"],"BUSOK1":["BUIDX","BUNAME","BUSELECT","BUCODE","BUshorten","barNAME1","barNAME2","barNAME3","barNAME4","Kuidx","KUNAME","BUPAINT","SM_GLASSTYPE_1","SM_GLASSTYPE_2","SM_GLASSTYPE_3","SM_GLASSTYPE_4","SM_GLASSTYPE_5","BU_GLASSTYPE_1","BU_GLASSTYPE_2","BU_GLASSTYPE_3","BU_GLASSTYPE_4","BU_GLASSTYPE_5","BUQTY","BUSTATUS","BUmidx","BUwdate","BUemidx","BUewdate","qtype","atype","Buprice","BUBIJUNG","BUDUKKE","BUHIGH","BU_BOGANG_LENGTH","BUIMAGES","BUCADFILES","BUsangbarTYPE","BUhabarTYPE","BUchulmolbarTYPE","BUpainttype","BUgrouptype","BUST_GLASS","BUST_GLASStype1","BUST_GLASStype2","BUST_GLASStype3","BUST_GLASStype4","BUST_GLASStype5","BUST_N_CUT_STATUS","BUST_HL_COIL","BUST_NUCUT_ShRing","BUST_NUCUT_1","BUST_NUCUT_2","BUST_VCUT_ShRing","BUST_VCUT_1","BUST_VCUT_2","BUST_VCUT_CH","BUST_GLASStype6","BUST_GLASStype7","BUST_GLASStype8","BUST_GLASStype9","BUGEMHYUNG","barNAME5"],"EditLocks":["ResourceKey","LockedBy","LockedAt"],"OrderManifest":["ManifestId","Date","Customer","ReleaseType","Address","Manager","Contact","IsPaid","ShippingInfo","Size","Item","Option","ShipmentDate","OrderDate"],"STK":["stkidx","midx","stk1","stk2","stk3","stk4","stk5","stk6","stk7","stk8","stk9","stk10","stkdate","stkdateup","qty"],"TNG_Busok":["TNG_Busok_idx","T_Busok_name_f","TNG_Busok_comb_st","TNG_Busok_name1_Number","SJB_TYPE_NO","TNG_Busok_name_KR","TNG_Busok_name1","TNG_Busok_name2","TNG_Busok_comb_al1","TNG_Busok_comb_alBJ1","TNG_Busok_comb_al2","TNG_Busok_comb_alBJ2","TNG_Busok_comb_pa1","TNG_Busok_comb_pa2","TNG_Busok_length1","TNG_Busok_length2","TNG_Busok_BLACK","TNG_Busok_PAINT","TNG_Busok_comb_al3","TNG_Busok_comb_alBJ3","TNG_Busok_comb_pa3","TNG_Busok_images","TNG_Busok_CAD","WHICHI_FIX","WHICHI_AUTO","SJB_FA","midx","wdate","emidx","ewdate","SJB_TYPE_NAME","master_id"],"TNG_GREEM":["GREEM_IDX","GREEM_F_A","GREEM_BASIC_TYPE","GREEM_FIX_TYPE","GREEM_HABAR_TYPE","GREEM_MBAR_TYPE","GREEM_LB_TYPE","GREEM_midx","GREEM_mdate","GREEM_meidx","GREEM_medate","GREEM_BASIC_name","GREEM_O_TYPE","GREEM_FIX_name"],"TNG_GREEM_A_SUB":["GREEM_A_SUB_IDX","GREEM_A_SUB_HABAR_TYPE","GREEMSUB_MBAR_TYPE","GREEM_A_SUB_LB_TYPE","GREEM_A_SUB_midx","GREEM_A_SUB_mdate","GREEM_A_SUB_meidx","GREEM_A_SUB_medate"],"TNG_SJA":["sjidx","sjdate","sjnum","cgdate","djcgdate","cgtype","cgaddr","cgset","sjmidx","sjcidx","midx","wdate","mewdate","meidx","su_kjtype","astatus","tsprice","trate","tdisprice","tfprice","taxprice","tzprice","money_status","memo","suju_kyun_status","move","balju_status","sticker_status"],"TNG_SJB":["SJB_IDX","SJB_TYPE_NO","SJB_TYPE_NAME","SJB_barlist","SJB_Paint","SJB_St","SJB_Al","SJB_midx","SJB_mdate","SJB_meidx","SJB_medate","SJB_FA","upstatus","pcent","unitpriceCnt","sjb_depth","sjb_width"],"TNG_SJB_AUTO":["SJB_AUTO_IDX","SJB_AUTO_NO","SJB_AUTO_NAME","SJB_AUTO_midx","SJB_AUTO_mdate","SJB_AUTO_meidx","SJB_AUTO_medate","SJB_IDX"],"TNG_SJBsub":["SJBsub_IDX","SJBsub_TYPE_NO","SJBsub_TYPE_NAME2","SJBsub_midx","SJBsub_mdate","SJBsub_meidx","SJBsub_medate","SJB_IDX","SJBsub_status"],"TNG_SJst2":["SJst2_IDX","SJst_vc_last","SJst_wc_1","SJst_r","SJst_l","SJst_vc_1","stepSize","x1","y1","x2","y2","direction","id","lastDirection","isComplete","id_1"],"TNG_SJst2_rect":["idx","id","id_1","x","y","width","height","a_value","b_value"],"VQuarantine":["didx","useridx","a1","a2","a3","a4","a5","a6","wdate"],"Vmember":["idx","username","telno","scode","wdate","gubun","jstatus"],"Vvister":["vidx","idx","intime","outtime","ftemp","stemp"],"bom2_origin_type":["origin_type_no","origin_name"],"bom2_title_type":["type_id","type_name"],"bom3_origin_type":["origin_type_no","origin_name"],"bom3_title_type":["type_id","type_name"],"bom_master":["master_id","item_type","origin_type","status","midx","meidx","memo","cdate","udate","item_name","origin_name"],"bom_mold":["mold_id","mold_no","vendor_id","location_mold","cad_path","img_path","status","midx","meidx","memo","cdate","udate","mold_name"],"bom_surface":["surface_id","surface_name","surface_code","status","midx","meidx","memo","cdate","udate"],"doorA":["doorA_id","doorA_name","sort_no","show_first","is_active","mname","mename","mdate","medate"],"door_entity":["door_entity_no","door_entity_name","mname","mename","mdate","medate","is_active"],"door_face":["door_face_id","door_face_code","door_face_name","direction","mname","mename","mdate","medate","is_active"],"door_size":["door_size_id","size_value","mname","mename","mdate","medate","is_active"],"factory_map":["map_id","map_name","width_mm","height_mm","tile_mm","reg_date"],"factory_object":["obj_id","map_id","obj_type","x_mm","y_mm","w_mm","h_mm","rotate"],"factory_zone":["zone_id","map_id","zone_type","x_mm","y_mm","w_mm","h_mm"],"jean":["jeanidx","c_midx","c_cidx","c_mname","c_cname","jean_c_mname","jean_c_mnames","jean_jemok","jean_sahang","jean_uploadFile1","jeandate","jeanupdate"],"mail_attachment":["id","session_bucket","file_name","file_path","file_url","file_size","created_at"],"mdata":["midx","mname","mpos","mtel","mhp","mfax","memail","mwdate","miid","cidx"],"profile_master":["profile_id","profile_name","source_file","version_no","memo","cdate","status","area_mm2","weight"],"reportlink":["rlisx","sjbidx","ridx","midx","rldate"],"tab_1":["cidx","cname","clevel","cody","cstatus","cdate"],"tab_a1":["idx","head_name","acontents","wdate","status","atype"],"table_name":["id","create_time","update_time","content"],"tk_BUSOK":["BUIDX","BUSELECT","BUCODE","BUshorten","BUNAME","BUQTY","BUSTATUS","BUmidx","BUwdate","BUemidx","BUewdate","qtype","atype","Buprice","BUBIJUNG","BUDUKKE","BUHIGH","BU_BOGANG_LENGTH","BUIMAGES","BUCADFILES","BUsangbarTYPE","BUhabarTYPE","BUchulmolbarTYPE","BUpainttype","BUgrouptype","BUST_GLASS","BUST_GLASStype1","BUST_GLASStype2","BUST_GLASStype3","BUST_GLASStype4","BUST_GLASStype5","BUST_N_CUT_STATUS","BUST_HL_COIL","BUST_NUCUT_ShRing","BUST_NUCUT_1","BUST_NUCUT_2","BUST_VCUT_ShRing","BUST_VCUT_1","BUST_VCUT_2","BUST_VCUT_CH","BUST_GLASStype6","BUST_GLASStype7","BUST_GLASStype8","BUST_GLASStype9","BUGEMHYUNG","barNAME5"],"tk_Frm":["tidx","tname","ttype","tprice","tstatus","timg","tsvg","twidx","twdate","gtype","aidx"],"tk_FrmBra":["bidx","aidx","btitle","bdepth","bwidth","bheight","bstatus","bwidx","bwdate","buprice","gtype"],"tk_FrmMat":["aidx","tidx","atitle","atype","astatus","awidx","awdate","mtype"],"tk_FrmSub":["sidx","tidx","bidx","fswdate","midx","hsize"],"tk_Odr":["oidx","cidx","otitle","ocode","osprice","ostatus","owidx","owdate","ooidx","oodate","oeidx","oedate","odidx","oddate","okidx","okdate"],"tk_OdrF":["fidx","ftitle","tidx","aidx","finsw","finsh","fbitg","finstype","fquan","fprice","fdprice","fstatus","fwidx","fwdate"],"tk_OdrFrmSub":["sidx","bidx","sdepth","swidth","sheight","sstatus","swidx","swdate","suprice","fidx"],"tk_advice":["aidx","acidx","acheorigubun","aform","agubun","aclaim","aname","adate","adetails","acheoriname","acheoridate","acheorimemo","astatus"],"tk_advicefile":["afidx","aidx","afname","afmidx","afdate"],"tk_balju_st":["balju_st_idx","sjidx","fkidx","bfidx","baidx","baname","blength","quan","xsize","ysize","sx1","sx2","sy1","sy2","bachannel","bfimg","midx","mdate","cname","sjdate","sjnum","cgaddr","cgdate","djcgdate","cgtype_text","qtyname","p_image","tw","th","ow","oh","p_name","SJB_TYPE_NAME","f_name","st_quan","ds_daesinaddr","yaddr","sjsidx","cidx","sjmidx","g_bogang","g_busok","basidx","bassize","basdirection","accsize","idv","final","GREEM_F_A","WHICHI_FIX","WHICHI_AUTO","T_Busok_name","TNG_Busok_images","TNG_Busok_idx","memo_text","bigo","fksidx","insert_flag","yaddr1","SJB_barlist","dooryn_text","T_Busok_name2","TNG_Busok_images2","TNG_Busok_idx2","T_Busok_name3","TNG_Busok_images3","TNG_Busok_idx3","set_name_FIX","set_name_AUTO","rot_type","g_autorf"],"tk_barasi":["baidx","baname","bamidx","bawdate","bastatus","xsize","ysize","sx1","sx2","sy1","sy2","bachannel","bfidx","g_bogang","g_busok","g_autorf","sharing_size"],"tk_barasiF":["bfidx","set_name_FIX","set_name_AUTO","WHICHI_FIX","xsize","ysize","bfimg1","bfimg2","sjb_idx","bfmidx","bfwdate","bfemidx","bfewdate","WHICHI_AUTO","TNG_Busok_idx","TNG_Busok_idx2","bfimg3","gwsize","gysize","dwsize","dysize","gwsize1","gwsize2","gwsize3","gwsize4","gwsize5","gysize1","gysize2","gysize3","gysize4","gysize5","dwsize1","dysize1","pcent","TNG_Busok_idx3","bfimg4","boyang","boyangname","boyangtype"],"tk_barasiFSub":["bfsidx","bfidx","TNG_Busok_idx","bfsstatus","contract_type","contract_memo","sort_no","wdate","emidx","ewdate"],"tk_barasisub":["basidx","bfidx","baidx","bassize","basdirection","basmidx","baswdate","x1","y1","x2","y2","accsize","idv","final","basp2","ysr2","ysr1","ody","kak","tx","ty"],"tk_barlist":["barIDX","barSELECT","barCODE","barshorten","barNAME","barQTY","barSTATUS","barmidx","barwdate","baremidx","barewdate","qtype","atype","barlistprice","barNAME1","barNAME2","barNAME3","barNAME4","barNAME5"],"tk_company":["company_id","company_code","company_name","use_yn","reg_date"],"tk_customer":["cidx","cname","caddr1","caddr2","cpost","cmidx","cdidx","cwdate","cnumber","cnick","ctkidx","cstatus","cbuy","csales","cceo","ctype","citem","cemail1","cgubun","cmove","cbran","cdlevel","cflevel","calevel","cslevel","csylevel","cmemo","cfile","ctel","cfax","ctel2","pcidx","cridx","cudtidx","cudtdate","accnumb","bankname","accname","cgetmoney"],"tk_daesin":["dsidx","ds_daesinname","ds_daesintel","ds_daesinaddr","dsdate","dsmemo","ds_to_num","ds_to_name","ds_to_tel","ds_to_addr","ds_to_costyn","ds_to_prepay","dsmidx","dswdate","dsmeidx","dswedate","dsstatus","sjidx","ds_to_addr1"],"tk_devcomment":["dcidx","dcmidx","dcdate","dctext","dcstatus"],"tk_devnote":["dnidx","dnmidx","dndate","dnnote","dnstatus"],"tk_emailatfile":["efidx","snidx","efname"],"tk_emailselect":["esidx","snidx","cidx","memail","midx","mname"],"tk_etc":["etc_idx","etc_name","etc_qty","midx","mdate","etc_price","sjidx"],"tk_frame":["fidx","fname","fmidx","fwdate","fstatus","GREEM_F_A","GREEM_BASIC_TYPE","GREEM_FIX_TYPE","GREEM_HABAR_TYPE","GREEM_LB_TYPE","GREEM_O_TYPE","GREEM_FIX_name","fmeidx","fewdate","GREEM_MBAR_TYPE","opa","opb","opc","opd","al_type"],"tk_frameSub":["fsidx","fidx","xi","yi","wi","hi","fmidx","fwdate","imsi","WHICHI_FIX","WHICHI_AUTO","sunstatus"],"tk_framek":["fkidx","fknickname","fidx","sjb_idx","fname","fmidx","fwdate","fstatus","GREEM_F_A","GREEM_BASIC_TYPE","GREEM_FIX_TYPE","GREEM_HABAR_TYPE","GREEM_LB_TYPE","GREEM_O_TYPE","GREEM_FIX_name","fmeidx","fewdate","GREEM_MBAR_TYPE","sjidx","sjb_type_no","setstd","sjsidx","ow","oh","tw","th","bcnt","FL","qtyidx","pidx","ow_m","framek_price","sjsprice","disrate","disprice","fprice","quan","taxrate","sprice","py_chuga","robby_box","jaeryobunridae","boyangjea","dooryn","doorglass_t","fixglass_t","doorchoice","whaburail","jaeryobunridae_type","door_price","sunstatus","chuga_jajae","coat"],"tk_framekSub":["fksidx","fkidx","fsidx","fidx","xi","yi","wi","hi","fmidx","fwdate","imsi","WHICHI_FIX","WHICHI_AUTO","bfidx","bwsize","bhsize","gwsize","ghsize","fstype","glasstype","blength","unitprice","pcent","sprice","xsize","ysize","gls","OPT","FL","door_W","door_h","glass_w","glass_h","busok","busoktype","doorglass_t","fixglass_t","doortype","doorglass_w","doorglass_h","doorsizechuga_price","door_price","goname","barNAME","alength","chuga_jajae","rstatus","rstatus2","garo_sero","groupcode","sunstatus","bokgu_wi","bokgu_hi","bokgu_alength","bokgu_blength","bokgu_xi","bokgu_yi","rot_type","entity_type","parent_fksidx","door_no","sub_type","arch_r1","arch_r2","hole_diameter","hole_depth","is_virtual","calc_done","door_disrate","door_disprice"],"tk_framekSub_geom":["fksidx","fkidx","entity_type","groupcode","parent_fksidx","xi","yi","wi","hi","rot_type","garo_sero","status","cdate"],"tk_frametype":["ftidx","GREEM_BASIC_TYPE","GREEM_BASIC_TYPEname","GREEM_FIX_TYPE","GREEM_FIX_TYPEname","greem_o_type","greem_o_typename","GREEM_HABAR_TYPE","GREEM_HABAR_TYPEname","GREEM_MBAR_TYPE","GREEM_MBAR_TYPEname","GREEM_LB_TYPE","GREEM_LB_TYPEname","midx","mdate"],"tk_glass":["glidx","glcode","glstatus","glvariety","glsort","glcolor","glwidth","gldepth","glheight","glprice","glmidx","glwdate","glemidx","glewdate","qtype","atype","taidx"],"tk_goods":["goidx","gotype","gocode","gocword","goname","goprice","gopaint","gosecfloor","gomidkey","gounit","gostatus","gomidx","gowdate","goemidx","goewdate","goname1","goname2","goname3","goname4","goname5","goname6","goname7","goname8","goname9","goname10","goname11","goname12","goname13","goprice1","goprice2","goprice3"],"tk_hinge":["hingeidx","hingecode","hingeshorten","hingename","hingecenter","hingePi","hingeprice","hingestatus","hingemidx","hingewdate","hingeemidx","hingeewdate","qtype","atype"],"tk_inquiry":["iqidx","iqmidx","iqdate","iqtype","iqnote","iqstatus"],"tk_key":["kyidx","kycode","kyshorten","kyname","kyselect","kystatus","kymidx","kywdate","kyemidx","kyewdate","kyprice","qtype","atype","kywitch"],"tk_khyorder":["order_idx","order_name","order_length","order_type","order_date","order_status","order_fdate","order_dept","kg_m"],"tk_korder":["kidx","kcidx","kmidx","kwdate","kidate","krdate","midx","kstatus","imidx","rmidx","olidx"],"tk_korderSub":["ksidx","kidx","odrdate","odrstatus","midx","odrkkg","odridx","cmidx","cdate","odrea","filedet"],"tk_kyukja":["kyukjaidx","kyukjacode","kyukjashorten","kyukjaname","kyukjawide","kyukjahigh","kyukjadepth","kyukjaPok","kyukjaprice","kyukjastatus","kyukjamidx","kyukjawdate","kyukjaemidx","kyukjaewdate","qtype","atype"],"tk_mUnit":["uidx","utitle","ustatus","udate"],"tk_mUnitSub":["usidx","uidx","bidx","usdate","usstatus"],"tk_material":["smidx","sidx","baridx","barNAME","rgoidx","goname","buidx","BUNAME","FULL_NAME","smtype","smproc","smal","smalqu","smst","smstqu","smglass","smgrid","tagongfok","tagonghigh","smnote","smcomb","smmidx","smwdate","smemidx","smewdate","barNAME1","barNAME2","barNAME3","barNAME4","barNAME5","BUSELECT","BUPAINT","BUST_GLASS","BUST_GLASStype1","BUST_GLASStype2","BUST_GLASStype3","BUST_GLASStype4","BUST_GLASStype5","BUST_N_CUT_STATUS","BUST_HL_COIL","BUST_NUCUT_ShRing","BUST_NUCUT_1","BUST_NUCUT_2","BUST_VCUT_ShRing","BUST_VCUT_1","BUST_VCUT_2","BUST_VCUT_CH","BUST_GLASStype6","BUST_GLASStype7","BUST_GLASStype8","BUST_GLASStype9","SM_GLASSTYPE_1","SM_GLASSTYPE_2","SM_GLASSTYPE_3","SM_GLASSTYPE_4","SM_GLASSTYPE_5"],"tk_material1":["smidx","sidx","baridx","barNAME","rgoidx","goname","buidx","BUNAME","FULL_NAME","smtype","smproc","smal","smalqu","smst","smstqu","smglass","smgrid","tagongfok","tagonghigh","smnote","smcomb","smmidx","smwdate","smemidx","smewdate","barNAME1","barNAME2","barNAME3","barNAME4","barNAME5","BUSELECT","BUPAINT","BUST_GLASS","BUST_GLASStype1","BUST_GLASStype2","BUST_GLASStype3","BUST_GLASStype4","BUST_GLASStype5","BUST_N_CUT_STATUS","BUST_HL_COIL","BUST_NUCUT_ShRing","BUST_NUCUT_1","BUST_NUCUT_2","BUST_VCUT_ShRing","BUST_VCUT_1","BUST_VCUT_2","BUST_VCUT_CH","BUST_GLASStype6","BUST_GLASStype7","BUST_GLASStype8","BUST_GLASStype9","SM_GLASSTYPE_1","SM_GLASSTYPE_2","SM_GLASSTYPE_3","SM_GLASSTYPE_4","SM_GLASSTYPE_5"],"tk_material_original":["smidx","sidx","baridx","barNAME","rgoidx","goname","buidx","BUNAME","FULL_NAME","smtype","smproc","smal","smalqu","smst","smstqu","smglass","smgrid","tagongfok","tagonghigh","smnote","smcomb","smmidx","smwdate","smemidx","smewdate","barNAME1","barNAME2","barNAME3","barNAME4","barNAME5","BUSELECT","BUPAINT","BUST_GLASS","BUST_GLASStype1","BUST_GLASStype2","BUST_GLASStype3","BUST_GLASStype4","BUST_GLASStype5","BUST_N_CUT_STATUS","BUST_HL_COIL","BUST_NUCUT_ShRing","BUST_NUCUT_1","BUST_NUCUT_2","BUST_VCUT_ShRing","BUST_VCUT_1","BUST_VCUT_2","BUST_VCUT_CH","BUST_GLASStype6","BUST_GLASStype7","BUST_GLASStype8","BUST_GLASStype9","SM_GLASSTYPE_1","SM_GLASSTYPE_2","SM_GLASSTYPE_3","SM_GLASSTYPE_4","SM_GLASSTYPE_5"],"tk_member":["midx","mname","mpos","mtel","mhp","mfax","memail","mwdate","cidx","mpw","mkakao","umidx","udate","orderring","pmidx"],"tk_meta_column":["col_id","table_name","column_name","column_title","data_type","width","required_yn","readonly_yn","hidden_yn","input_type","default_value","list_order","detail_yn","search_yn","memo","reg_date"],"tk_notification":["nidx","ntext","nmidx","ndate","nfile","nstatus"],"tk_oitemlist":["olidx","timestamp","json","midx","kidx","memo"],"tk_order":["oidx","otitle","cidx","oquan","ocolor","oftype","oinsw","oinsh","odoorw","odoorh","odoorgw","odoorgh","ofixgw","ofixgh","onamma","obitg","onglass1w","onglass1h","onglass2w","onglass2h","odoormsg","odday","odinsh","ouprice","oeprice","oboxtop","oboxtopq","oboxfront","oboxfrontq","oboxbottom","oboxbottomq","otopwnam","otopwnamq","oboxabs","oboxabsq","oboxcap","oboxcapq","oautohome1","oautohome1q","oautohome2","oautohome2q","ojgsd","ojgsdq","otopjgsd","otopjgsdq","ohomedead","ohomedeadq","ofixtopbar","ofixtopbarq","ofixbottomebar","ofixbottomebarq","ofixosi","ofixosiq","owdate","omidx","ostatus","odidx","oodate","opensize","mopensize"],"tk_paint":["pidx","pcode","pshorten","pname","pprice","pstatus","pmidx","pwdate","pemidx","pewdate","pname_brand","p_percent","p_image","p_sample_image","p_sample_name","cidx","sjidx","in_gallon","out_gallon","remain_gallon","paint_type","coat"],"tk_paint_brand":["pbidx","pidx","pname_brand","midx","wdate"],"tk_picfiles":["pfidx","sjidx","pfname","pfmidx","pfdate","pffiletype","pfstatus","extension"],"tk_picmemo":["pmidx","sjidx","pmemo","pmmidx","pmdate"],"tk_picupload":["puidx","sjidx","pufile","pumemo","pumidx","pudate","pustatus"],"tk_qty":["QTYIDX","QTYNo","QTYNAME","QTYSTATUS","QTYPAINT","QTYINS","QTYLABEL","QTYPAINTW","QTYmidx","QTYwdate","QTYemidx","QTYewdate","qtype","taidx","ATYPE","qtyprice","kg","sheet_t","upstatus","robbyprice1","robbyprice2","doorbase_price"],"tk_qtyco":["qtyco_idx","QTYNo","QTYNAME","QTYcoNAME","QTYcostatus","QTYcomidx","QTYcowdate","QTYcoemidx","QTYcoewdate","sheet_w","sheet_h","sheet_t","coil_cut","coil_t","kg","unittype_qtyco_idx","upstatus","is_special"],"tk_qtycosub":["qtycosub_idx","qtyco_idx","qtycosubstatus","qtycosubmidx","qtycosubwdate","qtycosubemidx","qtycosubewdate","sheet_w","sheet_h","sheet_t","coil_cut","coil_t"],"tk_report":["ridx","ron","rname","ruse","rtdate","rotype","rwtype","rwidth","rftexture","rbtexture","rgthickness","rginfo","rinsp","rherp","rwatp","rpa","roc","rsizelabel","rverticalw","rtorsion","rimpactr","rsafe","rwdate","rmidx","rstatus","rfile","remidx","rewdate","kname","reportnote","nfile","rfixtop","depth","width","sjb_type_no","rtype"],"tk_reportg":["rgidx","rgname","rgmidx","rgdate","rgemidx","rgedate","rgtype","rgfile","gstatus"],"tk_reportgSub":["rgsidx","rgidx","ridx","rgsmidx","rgsdate"],"tk_reportm":["fidx","fname","fstatus","ftype","fmidx","fdate"],"tk_reportsend":["snidx","sndate","snreadstatus","sndownloadstatus","sndownloadcount","snrgidx","snridx","sncidx","snmidx","mtitle","mmaintext","sncemail1","snmemail","filename","report","reportg","snsendstatus"],"tk_reportsendcorpSub":["snsidx","snidx","cidx","cname"],"tk_reportsendgsub":["snsidx","snidx","ridx","rgidx"],"tk_reportsendsub":["snsidx","snidx","ridx","rgidx","rfixtop"],"tk_reportsub":["rsidx","ridx","rftype","rfidx"],"tk_reverse":["revidx","revsjidx","revsjsidx","revfksidx","revxi","revyi","revwi","revhi","revstatus","revwdate","ody"],"tk_rule_core":["rule_id","company_id","rule_group","rule_name","result_value","priority","active","reg_user","reg_date","upd_user","upd_date","memo","cond_key","cond_op","cond_val"],"tk_stand":["sidx","goidx","goname","baridx","barNAME","smidx","swdate","semidx","sewdate","standprice","barlistprice","barNAME1","barNAME2","barNAME3","barNAME4","barNAME5","tongdojang","jadong","culmolbar","danyul","junggankey","dademuhom","glass","nf","g_w","g_h","price_level"],"tk_sujua":["sjaidx","cidx","sjaddress","sjnumber","sjtatus","sjqty","sujudate","sjchulgo","sjchulgodate","sjamidx","sjamdate","sjameidx","sjamedate","sujunum"],"tk_sujub":["sjbidx","goidx","goprice","sidx","barlistprice","QTYIDX","QTYprice","sjbqty","sjbwide","sjbwidePRICE","sjbhigh","sjbhighPRICE","sjbbanghyang","sjbwitch","sjbbigo","sjbglass","glidx","glprice","sangBUIDX","sangbuprice","pidx","pprice","rhaBUIDX","rhabuprice","kyidx1","kyprice1","sjbkey2","sjbkey3","sjbkey4","kyidx2","kyprice2","sjbkey6","sjbkey7","sjbkey8","tagongidx1","tagongprice1","sjbtagong2","sjbtagong3","sjbtagong4","sjbtagong5","sjbtagong6","sjbtagong7","sjbtagong8","sjbtagong9","sjbtagong10","hingeidx","hingeprice","hingeidx1","hingeprice1","sjbhingedown2","sjbhingedown3","hingeidx3","hingeprice3","hingeidx4","hingeprice4","sjbhingeup2","sjbhingeup3","sjbkyukja1","kyukjaprice","sjbkyukja2","sjbkyukja3","sjbkyukja4","sjbkyukja5","sjbkyukja6","sjbkyukja7","sjbkyukja8","sjaidx","sujuinmoneyidx","sjwondanga","sjchugageum","sjgonggeumgaaek","sjDCdanga","sjseaek","sjdanga","sjgeumaek","goname","barNAME","QTYNAME","gldepth","sangbuname","pname","rhabuname","kyname1","kyname2","tagongname1","tagongname2","hingename1","hingecenter1","hingename2","hingecenter2","kyukjaname","tagongidx2","tagongprice2","kyidx3","kyprice3","kyidx4","kyprice4","kyname3","kyname4","sjbtagong11","sjbpummyoung","sjbjaejil","sjbsangbar","sjbpaint","sjbhabar","sjbkey1","sjbkey5","sjbtagong1","sjbhingedown","sjbhingedown1","sjbhingeup","sjbhingeup1","cidx"],"tk_sujubSub":["sjbSubidx","sjbidx","gubunkey","busokkey","sjbSubstatus","sjbSubqty","pummokGubun","sjbSubmidx","sjbSubwdate","sjbSubemidx","sjbSubewdate","sjaidx","sujuinmoneyidx"],"tk_sujumoney":["sjmoneyidx","sjwondanga","sjchugageum","sjgonggeumgaaek","sjDCdanga","sjseaek","sjdanga","sjgeumaek","sjbpummyoungPRICE","sjbkukyukPRICE","sjbjaejilPRICE","sjbwidePRICE","sjbhighPRICE","sjbglassPRICE","sjbpaintPRICE","sjbkeyPRICE","sjbtagongPRICE","sjbhingeupPRICE","sjbhingedownPRICE","sjbkyukjaPRICE1","sjbkyukjaPRICE2","sjbkyukjaPRICE3","sjbkyukjaPRICE4","sjbkyukjaPRICE5","sjaidx","sjbidx","sjcidx","sjdidx","sjeidx","sjfidx","sujumoneymidx","sujumoneymdate","sujumoneymeidx","sujumoneymedate"],"tk_tagong":["tagongidx","tagongcode","tagongshorten","tagongname","tagongpunch","tagongprice","tagongstatus","tagongmidx","tagongwdate","tagongemidx","tagongewdate","qtype","atype"],"tk_url":["urlidx","urlmidx","urllink","urlstatus","urlwdate"],"tk_wms_dashboard_manual":["manual_idx","company_id","ymd","wms_type","customer_name","recv_name","recv_tel","dest_text","item_name","material_text","paint_no","spec_text","remark","is_active","reg_user","reg_date","upd_user","upd_date","meas_name"],"tk_wms_dj_dashboard_manual":["djmanual_idx","ymd","cname","item_name","meas_name","qtyname","pname","coat","djnum","totalquan","spec_text","djmemo","is_active","reg_dt","upd_dt","actual_ship_dt","sjaquan"],"tk_wms_sender":["sender_id","company_id","sender_code","sender_type","sender_name","sender_tel","sender_addr","sender_addr1","use_yn","reg_user","reg_date","upd_user","upd_date","memo"],"tk_wms_sticker_snapshot":["wms_idx","sjsidx","ymd","payload","sum_qty","updated_at"],"tk_ydriver":["didx","dname","dnum","dtel","dloc","dcod","dstatus","ddate","dmem"],"tk_yongcha":["yidx","yname","ytel","yaddr","ydate","ymemo","ycarnum","ygisaname","ygisatel","ycostyn","yprepay","ymidx","ywdate","ymeidx","ywedate","ystatus","sjidx","yaddr1"],"tng_arch":["fksidx","fkidx","arch_type","r1","r2","is_internal"],"tng_bottom_panel":["fksidx","fkidx","bfidx","panel_type","width","height","price"],"tng_divider_bar":["fksidx","fkidx","bfidx","alength","bar_type","unitprice","sprice"],"tng_door_glass":["fksidx","fkidx","bfidx","glass_type","glass_t","area","price","memo"],"tng_fix_glass":["fksidx","fkidx","bfidx","glass_type","glass_t","memo"],"tng_grid_bar":["fksidx","fkidx","bfidx","alength","unitprice","sprice"],"tng_handle":["fksidx","fkidx","bfidx","handle_type","position_height","price"],"tng_hole":["fksidx","fkidx","parent_fksidx","diameter","depth","price"],"tng_price_adjustment":["adj_idx","adj_name","adj_rate","adj_type","target_bfwidx","target_qtyco","target_fidx","target_sjb_idx","apply_date","created_by","created_at","remarks","is_executed","executed_at","executed_by","affected_rows_t","affected_rows_al","backup_id"],"tng_price_backup_al":["backup_idx","backup_id","backup_date","adj_idx","ualidx","SJB_IDX","fidx","price_bk","price_etl"],"tng_price_backup_t":["backup_idx","backup_id","backup_date","adj_idx","uptidx","SJB_IDX","unittype_bfwidx","unittype_qtyco_idx","price"],"tng_price_history":["history_idx","adj_idx","adj_name","table_type","record_idx","SJB_IDX","unittype_bfwidx","unittype_qtyco_idx","fidx","price_field","price_before","price_after","change_amount","change_rate","changed_at","changed_by","change_type"],"tng_sjaSub":["sjsidx","sjidx","midx","mwdate","meidx","mewdate","mwidth","mheight","qtyidx","sjsprice","disrate","disprice","fprice","sjb_idx","quan","taxrate","sprice","asub_wichi1","asub_wichi2","asub_bigo1","asub_bigo2","asub_bigo3","asub_meno1","asub_meno2","astatus","py_chuga","door_price","whaburail","robby_box","jaeryobunridae","boyangjea","pidx","framename","frame_price","frame_option_price","coat"],"tng_sjb_cnt":["tsc_idx","upmidx","sjb_idx","sjb_type_no","tsc_wdate","f_cnt","s_cnt"],"tng_sjbtype":["sjbtidx","SJB_TYPE_NO","SJB_TYPE_NAME","sjbtstatus","dwsize1","dhsize1","dwsize2","dhsize2","dwsize3","dhsize3","dwsize5","dhsize5","gwsize1","ghsize1","gwsize2","ghsize2","gwsize3","ghsize3","gwsize4","ghsize4","gwsize5","ghsize5","gwsize6","ghsize6","dwsize4","dhsize4","SJB_FA"],"tng_unitprice":["upidx","bfwidx","bfidx","sjbtidx","qtyco_idx","price","upstatus","sdate","fdate","SJB_IDX","QTYIDX","upmidx","upaidx"],"tng_unitprice_al":["ualidx","SJB_IDX","sjbtidx","QTYIDX","qtyco_idx","fidx","price_bk","price_etl","upstatus"],"tng_unitprice_f":["upidx","bfwidx","bfidx","sjbtidx","qtyco_idx","price","upstatus","sdate","fdate","SJB_IDX","QTYIDX","upmidx","upaidx","unittype_bfwidx","unittype_qtyco_idx"],"tng_unitprice_t":["uptidx","bfwidx","bfidx","sjbtidx","qtyco_idx","price","upstatus","sdate","fdate","SJB_IDX","QTYIDX","unittype_bfwidx","unittype_qtyco_idx"],"tng_whichipcent":["pidx","WHICHI_FIX","WHICHI_FIXname","WHICHI_AUTO","WHICHI_AUTOname","min_ysize","max_ysize","pcent","pstatus"],"tng_whichitype":["bfwidx","WHICHI_FIX","WHICHI_FIXname","WHICHI_AUTO","WHICHI_AUTOname","bfwstatus","glassselect","unittype_bfwidx","upstatus"],"unitprice":["upmidx","sdate","fdate","midx","wdate","meidx","wedate"],"unitpriceA":["upaidx","sjb_idx","bfwidx","whichi_fix","whichi_auto","bfidx","status","wdate","sjb_type_no","sjb_fa","sjbtidx","upmidx","upstatus","sdate","fdate"],"wj_pboard":["idx","corp_name","duty_name","tel_number","qtype","qcontent","wdate","status","email"],"A_MaterialMaster":["MaterialID","ItemName","CategoryID","PartNumber","Specification","Unit","DefaultPrice"],"A_MaterialRequest":["RequestID","RequestDate","Requester","Department","SupervisorID","SupplierID","Purpose","Status","RequiredBy","OrderDate","ApprovalDate","ReceivedDate","PaymentMethod","PaymentDetail","Notes"],"A_MaterialRequestItem":["ItemID","RequestID","LineNo","MaterialID","ItemName","CategoryID","Specification","Quantity","Unit","UnitPrice","Remark"],"TNG_Busok_sub":["sub_id","busok_id","master_id","material_id","status","midx","mdate","meidx","medate","memo"],"bom2_master":["master_id","item_name","origin_type_no","item_no","is_active","midx","meidx","cdate","udate"],"bom2_mold":["mold_id","master_id","mold_no","mold_name","vender_id","cad_path","img_path","memo","is_active","midx","meidx","cdate","udate"],"bom2_surface":["surface_id","master_id","surface_name","surface_code","vender_id","memo","is_active","midx","meidx","cdate","udate"],"bom3_master":["master_id","item_name","origin_type_no","item_no","is_active","midx","meidx","cdate","udate"],"bom3_material":["material_id","master_id","material_name","is_active","midx","meidx","cdate","udate"],"bom_aluminum":["aluminum_id","master_id","mold_no","width_mm","height_mm","density","unit_type","status","midx","meidx","memo","cdate","udate","mold_id"],"bom_aluminum_length":["length_id","master_id","aluminum_id","length_mm","unit_type","status","midx","meidx","memo","cdate","udate"],"bom_aluminum_surface":["alum_surf_id","master_id","aluminum_id","surface_id","status","midx","meidx","memo","cdate","udate"],"doorB":["doorB_id","doorA_id","doorB_name","door_move_type","paint_type","stainless_type","is_active","mname","mename","mdate","medate"],"door_spec":["door_spec_id","left_size_id","right_size_id","top_size_id","bottom_size_id","spec_code","door_face_id_L","door_face_id_R","door_face_id_U","door_face_id_D","mname","mename","mdate","medate","is_active"],"item_group":["item_group_id","door_entity_no","item_group_no","item_group_name","mname","mename","mdate","medate","is_active"],"key_group":["key_group_id","key_group_no","item_group_id","door_entity_no","cname","cdate","uname","udate","is_active"],"profile_dco":["dco_id","profile_id","side_type","side_name","axis_type","axis_name","chain_index","p1","p2","distance","cdate"],"profile_dco_raw":["raw_id","profile_id","side_type","side_name","axis_type","axis_name","chain_index","p1","p2","distance","cdate"],"profile_dim_seed":["seed_id","profile_id","axis_type","axis_name","pos_value","source_type","is_outer","priority","cdate"],"profile_geom":["geom_id","profile_id","entity_type","layer_name","x1","y1","x2","y2","cx","cy","r","ang_start","ang_end","bbox_min_x","bbox_min_y","bbox_max_x","bbox_max_y","cdate"],"profile_overall_dim":["overall_id","profile_id","side_type","side_name","axis_type","axis_name","p1","p2","distance","cdate"],"tk_wms_djnum":["wdjnidx","sjidx","djnum","sjsidx","memo"],"tk_wms_eventlog":["log_idx","company_id","ref_type","ref_table","ref_id","action","qty","memo","operator","action_time"],"tk_wms_lot":["lot_idx","company_id","bfidx","lot_no","mfg_date","exp_date","status","reg_date"],"tk_wms_warehouse":["warehouse_idx","company_id","wh_code","wh_name","wh_addr","wh_manager","wh_tel","wh_type","use_yn","reg_date"],"bom2_length":["length_id","master_id","bom_length","is_active","midx","meidx","cdate","udate"],"bom2_list_title":["list_title_id","master_id","title_name","density","cidx","is_active","midx","meidx","cdate","udate","type_id"],"bom2_material":["material_id","master_id","material_name","unity_type","mold_id","length_id","surface_id","set_yn","is_active","midx","meidx","cdate","udate"],"bom2_material_img":["img_id","material_id","img_name","is_active","cdate","udate","sort_no","is_main"],"bom2_table_value":["table_value_id","material_id","list_title_id","value","is_active","cdate","udate"],"bom3_list_title":["list_title_id","master_id","title_name","is_sub","is_common","is_active","midx","meidx","cdate","udate","type_id","density"],"bom3_list_title_sub":["title_sub_id","list_title_id","sub_name","is_active","midx","meidx","wdate","udate","is_show","is_select"],"bom3_table_value":["table_value_id","material_id","list_title_id","value","is_active","cdate","udate","title_sub_id","title_sub_value_id","midx","meidx"],"bom3_title_sub_value":["sub_value_id","title_sub_id","sub_value","is_active","master_id","row_id"],"dk_glass":["glass_idx","glass_name","glass_variety","glass_sort","glass_color","glass_depth","glass_price","item_group_no","bom_material_id","sample_img","glass_midx","glass_cdate","glass_meidx","glass_udate","cidx","is_active","sort_yn","glass_xi","glass_yi","glass_wi","glass_hi"],"dk_handle":["handle_idx","handle_name","handle_type","handle_position_height","handle_price","handle_midx","handle_cdate","handle_meidx","handle_udate","item_group_no","bom_material_id","sample_img","cidx","is_active","sort_yn","handle_xi","handle_yi","handle_wi","handle_hi"],"dk_hinge":["a_hinge_idx","a_hinge_name","a_hinge_center","a_hinge_Pi","a_hinge_price","a_hinge_position","a_hinge_position_name","item_group_no","bom_material_id","sample_img","a_hinge_midx","a_hinge_cdate","a_hinge_meidx","a_hinge_udate","cidx","is_active","sort_yn","hinge_xi","hinge_yi","hinge_wi","hinge_hi"],"dk_hole":["hole_idx","hole_name","hole_fkidx","hole_parent_idx","hole_diameter","hole_depth","hole_price","hole_midx","hole_cdate","hole_meidx","hole_udate","item_group_no","bom_material_id","sample_img","cidx","is_active","sort_yn","hole_xi","hole_yi","hole_wi","hole_hi"],"dk_key":["key_idx","key_name","key_select","key_price","qtype","atype","key_witch","item_group_no","bom_material_id","sample_img","key_midx","key_cdate","key_meidx","key_udate","cidx","is_active","sort_yn","key_xi","key_yi","key_wi","key_hi"],"doorC":["doorC_id","doorB_id","door_spec_id","is_active","mname","mename","mdate","medate"],"doorE":["doorE_id","door_entity_no","item_group_id","doorA_id","doorB_id","door_spec_id","is_active","mname","mename","mdate","medate"],"doorM":["doorM_id","doorA_id","doorB_id","doorC_id","is_active","mname","mename","mdate","medate","doortype","doordirection"],"glass_group":["glass_group_id","glass_group_no","item_group_id","door_entity_no","cname","cdate","uname","udate","is_active"],"handle_group":["handle_group_id","handle_group_no","item_group_id","door_entity_no","cname","cdate","uname","udate","is_active"],"hinge_group":["hinge_group_id","hinge_group_no","item_group_id","door_entity_no","cname","cdate","uname","udate","is_active"],"hole_group":["hole_group_id","hole_group_no","item_group_id","door_entity_no","cname","cdate","uname","udate","is_active"],"tk_wms_meta":["wms_idx","company_id","wms_no","cidx","sjidx","sjsidx","wms_type","carrier_id","driver_id","warehouse_idx","planned_ship_dt","actual_ship_dt","sender_name","sender_tel","sender_addr","recv_name","recv_tel","recv_addr","cost_yn","prepay_yn","total_quan","total_weight","status","reg_user","reg_date","upd_user","upd_date","memo","sender_addr1","recv_addr1","paint_ship_dt","is_active","dash_note"],"tk_wms_stock_loc":["stock_loc_idx","company_id","warehouse_idx","loc_code","zone","rack","shelf","bin","loc_desc","use_yn"],"doorK":["doorK_id","door_name","width","height","quantity","is_active","cname","uname","cdate","udate","doorM_id","door_price","pcent","dcprice","sprice","door_total_price"],"doorK_sub":["doorK_sub_id","xi","yi","wi","hi","is_active","cname","uname","cdate","udate","doorK_id","item_group_id","entity_name","bfidx","door_spec_id","blength","xsize","ysize","zsize","pcent","dcprice","sprice","unitprice"],"tk_wms_detail":["wmsd_idx","company_id","wms_idx","sjidx","sjsidx","fkidx","fksidx","bfidx","baname","blength","unit","quan","weight","warehouse_idx","stock_loc_idx","lot_idx","serial_no","status","memo","xsize","ysize","bfimg","material_color","glass_type","fixauto_type","paint_yn","protect_type","is_door","bfgroup"],"tk_wms_stock":["stock_idx","company_id","warehouse_idx","stock_loc_idx","bfidx","baname","blength","lot_idx","qty_total","qty_allocated","qty_available","weight_total","status","in_date","out_date","last_txn_type","last_txn_ref","upd_date"]};


// ===================================================================
// TAB NAVIGATION
// ===================================================================
let currentTab = 'tab1';
document.querySelectorAll('#topnav .nav-tab[data-tab]').forEach(tab => {
  tab.addEventListener('click', () => {
    document.querySelectorAll('#topnav .nav-tab[data-tab]').forEach(t => t.classList.remove('active'));
    tab.classList.add('active');
    document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
    currentTab = tab.dataset.tab;
    document.getElementById(currentTab).classList.add('active');
    if (currentTab === 'tab2' && !t2Initialized) { t2Init(); t2Initialized = true; }
  });
});

// ===================================================================
// DDL AUTOCOMPLETE
// ===================================================================
let ddlOpen = false;
const DDL_TABLES = Object.keys(DDL_SCHEMA);
let ddlTotalCols = 0;
DDL_TABLES.forEach(t => ddlTotalCols += DDL_SCHEMA[t].length);

function toggleDDL() {
  ddlOpen = !ddlOpen;
  document.getElementById('ddl-panel').classList.toggle('open', ddlOpen);
  document.getElementById('ddl-toggle').classList.toggle('shifted', ddlOpen);
  if (ddlOpen) {
    renderDDL('');
    setTimeout(() => document.getElementById('ddl-searchbox').focus(), 300);
  }
}

document.getElementById('ddl-searchbox').addEventListener('input', (e) => {
  renderDDL(e.target.value.trim());
});

function renderDDL(query) {
  const container = document.getElementById('ddl-results');
  const q = query.toLowerCase();
  let html = '';
  let matchTables = 0;
  let matchCols = 0;

  DDL_TABLES.forEach(tbl => {
    const cols = DDL_SCHEMA[tbl];
    const tblMatch = !q || tbl.toLowerCase().includes(q);
    const colMatches = q ? cols.filter(c => c.toLowerCase().includes(q)) : [];

    if (!q || tblMatch || colMatches.length > 0) {
      matchTables++;
      const showCols = tblMatch ? cols : colMatches;
      const isOpen = q && (colMatches.length > 0 || tblMatch);

      html += '<div class="ddl-table">';
      html += '<div class="ddl-table-header" onclick="this.nextElementSibling.classList.toggle(\'open\')">';
      html += '<span class="tname">' + highlightDDL(tbl, q) + '</span>';
      html += '<span class="tcnt">' + cols.length + '컬럼</span>';
      html += '</div>';
      html += '<div class="ddl-table-cols' + (isOpen ? ' open' : '') + '">';

      const displayCols = q && !tblMatch ? colMatches : cols;
      displayCols.forEach(col => {
        matchCols++;
        html += '<div class="ddl-col" onclick="copyDDL(\'' + tbl + '.' + col + '\')" title="클릭: 복사">';
        html += '<span class="col-name">' + highlightDDL(col, q) + '</span>';
        html += '<span class="col-copy">복사</span>';
        html += '</div>';
      });

      html += '</div></div>';
    }
  });

  if (!html) {
    html = '<div class="empty-state" style="padding:30px"><div style="font-size:24px">🔍</div><div>검색 결과 없음</div></div>';
  }

  container.innerHTML = html;
  document.getElementById('ddl-stat-filter').textContent = q ? matchTables + '개 테이블' : '';
}

function highlightDDL(text, query) {
  if (!query) return escH(text);
  const idx = text.toLowerCase().indexOf(query.toLowerCase());
  if (idx === -1) return escH(text);
  return escH(text.slice(0, idx)) + '<span class="ddl-highlight">' + escH(text.slice(idx, idx + query.length)) + '</span>' + escH(text.slice(idx + query.length));
}

function copyDDL(text) {
  navigator.clipboard.writeText(text).then(() => {
    const el = document.getElementById('ddl-copied');
    el.textContent = '📋 ' + text + ' 복사됨!';
    el.style.display = 'block';
    setTimeout(() => el.style.display = 'none', 1500);
  });
}

// ===================================================================
// TAB1: www ARCHITECTURE MAP (from architecture_map.asp)
// ===================================================================
let allFiles = [];
let folderGroups = {};
let folderStats = {};
let t1View = 'overview';
let t1Folder = null;
let t1Selected = null;
let t1Filter = 'all';
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

const CONN_LABELS = { inc:'include', form:'form', redir:'redirect', popup:'popup', link:'link', iframe:'iframe', ajax:'ajax' };
const CONN_COLORS = { inc:'#7ee787', form:'#3fb950', redir:'#f0883e', popup:'#bc8cff', link:'#58a6ff', iframe:'#f85149', ajax:'#e3b341' };

document.addEventListener('DOMContentLoaded', () => {
  t1BindToolbar();
  t1LoadData();
});

async function t1LoadData() {
  showLoading(true);
  try {
    const res = await fetch('dev_architecture.asp?mode=scan');
    allFiles = await res.json();
    t1Process();
    t1RenderSidebar();
    t1RenderOverview();
    t1UpdateStatus();
  } catch(e) {
    document.getElementById('tab1-content').innerHTML = '<div class="empty-state"><div class="icon">!</div><div>스캔 실패: ' + e.message + '</div></div>';
  }
  showLoading(false);
}

function rescan() { connCache = {}; t1LoadData(); }

function t1Process() {
  folderGroups = {};
  allFiles.forEach(f => { const k = f.t || ''; if (!folderGroups[k]) folderGroups[k] = []; folderGroups[k].push(f); });
  folderStats = {};
  Object.keys(folderGroups).forEach(k => {
    const files = folderGroups[k]; const types = {};
    files.forEach(f => { types[f.e] = (types[f.e]||0) + 1; });
    folderStats[k] = { count: files.length, types, size: files.reduce((s,f) => s + f.s, 0) };
  });
}

function t1BindToolbar() {
  document.querySelectorAll('#tab1-toolbar button[data-filter]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('#tab1-toolbar button[data-filter]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      t1Filter = btn.dataset.filter;
      if (t1View === 'overview') t1RenderOverview(); else if (t1View === 'folder') t1RenderFolder(t1Folder);
    });
  });
  const search = document.getElementById('tab1-search');
  search.addEventListener('input', () => {
    const q = search.value.trim();
    if (q.length >= 2) t1RenderSearch(q);
    else if (t1View === 'search') { if (t1Folder) t1RenderFolder(t1Folder); else t1RenderOverview(); }
  });
  document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') { e.preventDefault(); search.focus(); search.select(); }
    if (e.key === 'Escape') { search.value = ''; t1CloseDetail(); if (t1Folder) t1RenderFolder(t1Folder); else t1RenderOverview(); }
  });
}

function t1RenderSidebar() {
  const sb = document.getElementById('tab1-sidebar');
  const sorted = Object.keys(folderGroups).sort((a,b) => { if(a==='')return -1; if(b==='')return 1; return a.localeCompare(b); });
  let html = '<div class="tree-section">폴더</div>';
  html += '<div class="tree-item' + (t1View==='overview'?' active':'') + '" data-folder="__overview__"><div class="dot" style="background:#58a6ff"></div><span class="name">전체 개요</span><span class="count">' + allFiles.length + '</span></div>';
  sorted.forEach(k => {
    const meta = FOLDER_META[k] || { label: k || '(루트)', color: '#8b949e' };
    html += '<div class="tree-item" data-folder="' + escH(k) + '"><div class="dot" style="background:' + meta.color + '"></div><span class="name">' + escH(meta.label) + '</span><span class="count">' + folderStats[k].count + '</span></div>';
  });
  sb.innerHTML = html;
  sb.querySelectorAll('.tree-item').forEach(el => {
    el.addEventListener('click', () => {
      const f = el.dataset.folder;
      document.getElementById('tab1-search').value = '';
      if (f === '__overview__') { t1Folder = null; t1RenderOverview(); }
      else { t1Folder = f; t1RenderFolder(f); }
      sb.querySelectorAll('.tree-item').forEach(e => e.classList.remove('active'));
      el.classList.add('active');
    });
  });
}

function t1RenderOverview() {
  t1View = 'overview';
  const content = document.getElementById('tab1-content');
  const sorted = Object.keys(folderGroups).sort((a,b) => { if(a==='')return -1; if(b==='')return 1; return folderStats[b].count-folderStats[a].count; });
  let html = '<div class="breadcrumb"><a onclick="t1RenderOverview()">www</a></div><div class="folder-grid">';
  sorted.forEach(k => {
    const meta = FOLDER_META[k] || { label: k || '(루트)', color: '#8b949e', desc: '' };
    const stats = folderStats[k]; const filtered = t1FilterFiles(folderGroups[k]);
    if (t1Filter !== 'all' && filtered.length === 0) return;
    html += '<div class="folder-card" data-folder="' + escH(k) + '"><div class="card-stripe" style="background:' + meta.color + '"></div>';
    html += '<div class="card-name">' + escH(meta.label) + '</div><div class="card-desc">' + escH(meta.desc || k) + '</div>';
    html += '<div class="card-stats"><span class="stat-badge total">' + (t1Filter==='all'?stats.count:filtered.length) + '개</span>';
    if (stats.types.asp) html += '<span class="stat-badge asp">ASP ' + stats.types.asp + '</span>';
    if (stats.types.js) html += '<span class="stat-badge js">JS ' + stats.types.js + '</span>';
    if (stats.types.html||stats.types.htm) html += '<span class="stat-badge html">HTML ' + ((stats.types.html||0)+(stats.types.htm||0)) + '</span>';
    if (stats.types.css) html += '<span class="stat-badge css">CSS ' + stats.types.css + '</span>';
    if (stats.types.sql) html += '<span class="stat-badge sql">SQL ' + stats.types.sql + '</span>';
    html += '</div></div>';
  });
  html += '</div>';
  content.innerHTML = html;
  content.querySelectorAll('.folder-card').forEach(el => { el.addEventListener('click', () => { t1Folder = el.dataset.folder; t1RenderFolder(t1Folder); t1UpdateSidebar(t1Folder); }); });
}

function t1RenderFolder(folder) {
  t1View = 'folder'; t1Folder = folder;
  const content = document.getElementById('tab1-content');
  const meta = FOLDER_META[folder] || { label: folder || '(루트)', color: '#8b949e' };
  const files = t1FilterFiles(folderGroups[folder] || []);
  let sorted = [...files];
  sorted.sort((a,b) => { let va,vb; if(sortCol==='n'){va=a.n.toLowerCase();vb=b.n.toLowerCase();}else if(sortCol==='s'){va=a.s;vb=b.s;}else if(sortCol==='e'){va=a.e;vb=b.e;}else{va=a.f;vb=b.f;} if(va<vb)return sortAsc?-1:1; if(va>vb)return sortAsc?1:-1; return 0; });
  let html = '<div class="breadcrumb"><a onclick="t1RenderOverview();t1UpdateSidebar(\'__overview__\')">www</a> / <span style="color:'+meta.color+'">'+escH(meta.label)+'</span> <span style="color:#484f58;margin-left:8px">'+files.length+'개</span></div>';
  if (files.length === 0) { html += '<div class="empty-state"><div class="icon">-</div><div>파일 없음</div></div>'; }
  else {
    html += '<table class="file-table"><thead><tr>';
    html += t1ThSort('n','파일명') + t1ThSort('e','타입') + t1ThSort('f','경로') + t1ThSort('s','크기');
    html += '</tr></thead><tbody>';
    sorted.forEach(f => {
      html += '<tr class="file-row" data-path="'+escH(f.p)+'"><td><span class="ext-badge ext-'+f.e+'">'+f.e+'</span> '+escH(f.n)+'</td>';
      html += '<td><span class="ext-badge ext-'+f.e+'">'+f.e.toUpperCase()+'</span></td>';
      html += '<td class="file-folder">'+escH(f.f)+'</td><td class="file-size">'+fmtSize(f.s)+'</td></tr>';
    });
    html += '</tbody></table>';
  }
  content.innerHTML = html;
  content.querySelectorAll('.file-row').forEach(el => {
    el.addEventListener('click', () => { content.querySelectorAll('.file-row').forEach(r => r.classList.remove('selected')); el.classList.add('selected'); const file = allFiles.find(f => f.p === el.dataset.path); if(file) t1ShowDetail(file); });
  });
  content.querySelectorAll('.file-table th[data-col]').forEach(el => {
    el.addEventListener('click', () => { const col = el.dataset.col; if(sortCol===col) sortAsc=!sortAsc; else{sortCol=col;sortAsc=true;} t1RenderFolder(folder); });
  });
}

function t1ThSort(col,label) {
  const arrow = sortCol===col?(sortAsc?' ▲':' ▼'):'';
  return '<th data-col="'+col+'">'+label+'<span style="font-size:9px">'+arrow+'</span></th>';
}

function t1RenderSearch(query) {
  t1View = 'search';
  const content = document.getElementById('tab1-content');
  const q = query.toLowerCase();
  let results = allFiles.filter(f => f.n.toLowerCase().includes(q) || f.p.toLowerCase().includes(q));
  results = t1FilterFiles(results);
  let html = '<div class="breadcrumb"><a onclick="t1RenderOverview();t1UpdateSidebar(\'__overview__\')">www</a> / 검색: "'+escH(query)+'" <span style="color:#484f58">'+results.length+'개</span></div>';
  if (results.length === 0) { html += '<div class="empty-state"><div class="icon">?</div><div>검색 결과 없음</div></div>'; }
  else {
    html += '<table class="file-table"><thead><tr><th>파일명</th><th>타입</th><th>경로</th><th>크기</th></tr></thead><tbody>';
    results.slice(0,200).forEach(f => {
      html += '<tr class="file-row" data-path="'+escH(f.p)+'"><td><span class="ext-badge ext-'+f.e+'">'+f.e+'</span> '+hlMatch(f.n,query)+'</td>';
      html += '<td><span class="ext-badge ext-'+f.e+'">'+f.e.toUpperCase()+'</span></td>';
      html += '<td class="file-folder">'+hlMatch(f.p,query)+'</td><td class="file-size">'+fmtSize(f.s)+'</td></tr>';
    });
    html += '</tbody></table>';
  }
  content.innerHTML = html;
  content.querySelectorAll('.file-row').forEach(el => { el.addEventListener('click', () => { const file = allFiles.find(f => f.p === el.dataset.path); if(file) t1ShowDetail(file); }); });
}

function t1ShowDetail(file) {
  t1Selected = file;
  const panel = document.getElementById('tab1-detail');
  const inner = document.getElementById('tab1-detail-inner');
  const meta = FOLDER_META[file.t] || { color: '#8b949e' };
  let html = '<div class="detail-close"><h2>'+escH(file.n)+'</h2><button onclick="t1CloseDetail()">&times;</button></div>';
  html += '<div class="detail-section"><h3>파일 정보</h3>';
  html += '<div class="detail-row"><span>경로</span><span class="val">'+escH(file.p)+'</span></div>';
  html += '<div class="detail-row"><span>폴더</span><span class="val" style="color:'+meta.color+'">'+escH(file.t||'(루트)')+'</span></div>';
  html += '<div class="detail-row"><span>타입</span><span class="val"><span class="ext-badge ext-'+file.e+'">'+file.e.toUpperCase()+'</span></span></div>';
  html += '<div class="detail-row"><span>크기</span><span class="val">'+fmtSize(file.s)+'</span></div></div>';
  html += '<button class="conn-btn" id="connBtn" onclick="t1Analyze(\''+escH(file.p).replace(/'/g,"\\'")+'\')">연결 + DB 분석</button>';
  html += '<div id="connResult"></div><div id="miniGraph"></div>';
  inner.innerHTML = html;
  panel.classList.add('open');
  if (connCache[file.p]) t1RenderConn(connCache[file.p]);
}

function t1CloseDetail() { document.getElementById('tab1-detail').classList.remove('open'); t1Selected = null; }

async function t1Analyze(filePath) {
  const btn = document.getElementById('connBtn'); btn.disabled = true; btn.textContent = '분석 중...';
  try {
    if (connCache[filePath]) { t1RenderConn(connCache[filePath]); }
    else {
      const res = await fetch('dev_architecture.asp?mode=parse&file=' + encodeURIComponent(filePath));
      const data = await res.json();
      if (data.error) { document.getElementById('connResult').innerHTML = '<div style="color:#f85149;font-size:12px;margin-top:8px">'+data.error+'</div>'; }
      else { connCache[filePath] = data; t1RenderConn(data); }
    }
  } catch(e) { document.getElementById('connResult').innerHTML = '<div style="color:#f85149;font-size:12px;margin-top:8px">오류: '+e.message+'</div>'; }
  btn.disabled = false; btn.textContent = '연결 분석';
}

function t1RenderConn(data) {
  const el = document.getElementById('connResult');
  const types = ['inc','form','redir','popup','link','iframe','ajax'];
  let total = 0, html = '';

  // === DB Tables (first) ===
  if (data.tables && data.tables.length > 0) {
    html += '<div class="db-section"><h3 style="font-size:12px;color:#ff7b72;margin-bottom:6px;display:flex;align-items:center;gap:6px">';
    html += '<span class="conn-type conn-type-tables">DB</span> 테이블 '+data.tables.length+'개</h3>';
    if (data.crud && data.crud.length > 0) {
      html += '<div class="crud-badges">';
      data.crud.forEach(op => { html += '<span class="crud-badge crud-'+op.charAt(0)+'">'+op+'</span>'; });
      html += '</div>';
    }
    html += '<div class="db-tables">';
    data.tables.forEach(tbl => {
      html += '<span class="db-tag" onclick="ddlSearchTable(\''+escH(tbl)+'\')">'+escH(tbl)+'</span>';
    });
    html += '</div></div>';
  }

  // === DB Connection ===
  if (data.dbconn && data.dbconn.length > 0) {
    html += '<div class="detail-section"><h3><span class="conn-type conn-type-dbconn">DB연결</span></h3>';
    html += '<div class="dbconn-info">';
    data.dbconn.forEach(c => { html += escH(c)+'<br>'; });
    html += '</div></div>';
  }

  // === File Connections ===
  types.forEach(type => {
    const arr = data[type]; if (!arr || arr.length === 0) return; total += arr.length;
    html += '<div class="detail-section"><h3><span class="conn-type conn-type-'+type+'">'+CONN_LABELS[type]+'</span> '+arr.length+'개</h3>';
    html += '<ul class="conn-list">';
    arr.forEach(target => {
      const resolved = t1Resolve(data.file, target);
      const exists = allFiles.find(f => f.p===resolved || f.p.endsWith('/'+target) || f.n===target.split('/').pop());
      html += '<li onclick="t1NavTo(\''+escH(target).replace(/'/g,"\\'")+'\',\''+escH(data.file).replace(/'/g,"\\'")+'\')">';
      html += '<span class="conn-type conn-type-'+type+'">'+CONN_LABELS[type]+'</span>';
      html += '<span style="color:'+(exists?'#c9d1d9':'#484f58')+'">'+escH(target)+'</span>';
      if (!exists) html += ' <span style="color:#484f58;font-size:10px">(외부)</span>';
      html += '</li>';
    });
    html += '</ul></div>';
  });
  const hasDB = data.tables && data.tables.length > 0;
  if (total === 0 && !hasDB) html = '<div style="color:#484f58;font-size:12px;margin-top:12px;text-align:center">연결 없음</div>';
  el.innerHTML = html;
  if (total > 0) t1RenderMiniGraph(data);
}

function t1RenderMiniGraph(data) {
  const container = document.getElementById('miniGraph');
  const W = 328, H = 200, types = ['inc','form','redir','popup','link','iframe','ajax'];
  const targets = [];
  types.forEach(type => { (data[type]||[]).forEach(t => { targets.push({name:t,type}); }); });
  if (targets.length === 0) { container.innerHTML = ''; return; }
  const cx = W/2, cy = H/2, centerFile = data.file.split('/').pop();
  let svg = '<svg viewBox="0 0 '+W+' '+H+'" xmlns="http://www.w3.org/2000/svg">';
  const radius = Math.min(W,H)*0.35;
  targets.forEach((t,i) => {
    const angle = (2*Math.PI/Math.max(targets.length,1))*i - Math.PI/2;
    const tx = cx+Math.cos(angle)*radius, ty = cy+Math.sin(angle)*radius;
    const color = CONN_COLORS[t.type] || '#8b949e';
    const sn = t.name.split('/').pop(); const tn = sn.length>18?sn.slice(0,16)+'..':sn;
    svg += '<line x1="'+cx+'" y1="'+cy+'" x2="'+tx+'" y2="'+ty+'" stroke="'+color+'" stroke-width="1.2" opacity="0.5"/>';
    svg += '<g transform="translate('+tx+','+ty+')"><rect x="-40" y="-10" width="80" height="20" fill="'+color+'22" stroke="'+color+'" stroke-width="1" rx="4"/>';
    svg += '<text y="4" font-size="8" fill="'+color+'" text-anchor="middle">'+escH(tn)+'</text></g>';
  });
  const tc = centerFile.length>16?centerFile.slice(0,14)+'..':centerFile;
  svg += '<g transform="translate('+cx+','+cy+')"><rect x="-50" y="-12" width="100" height="24" fill="#1f6feb" stroke="#58a6ff" stroke-width="2" rx="5"/>';
  svg += '<text y="4" font-size="9" fill="#fff" text-anchor="middle" font-weight="600">'+escH(tc)+'</text></g></svg>';
  container.innerHTML = svg;
}

function t1NavTo(target, fromFile) {
  const resolved = t1Resolve(fromFile, target);
  const file = allFiles.find(f => f.p===resolved) || allFiles.find(f => f.p.endsWith('/'+target)) || allFiles.find(f => f.n===target.split('/').pop());
  if (file) { t1Folder = file.t; t1RenderFolder(file.t); t1UpdateSidebar(file.t); t1ShowDetail(file); }
}

function t1Resolve(basePath, ref) {
  if (ref.startsWith('/')) return ref.slice(1);
  const baseDir = basePath.substring(0, basePath.lastIndexOf('/')+1);
  const parts = (baseDir+ref).split('/'); const resolved = [];
  parts.forEach(p => { if(p==='..') resolved.pop(); else if(p!=='.'&&p!=='') resolved.push(p); });
  return resolved.join('/');
}

function t1UpdateSidebar(folder) {
  document.querySelectorAll('#tab1-sidebar .tree-item').forEach(el => {
    el.classList.toggle('active', (folder==='__overview__'&&el.dataset.folder==='__overview__') || el.dataset.folder===folder);
  });
}

function t1FilterFiles(files) { if(t1Filter==='all') return files; return files.filter(f => f.e===t1Filter || (t1Filter==='html'&&f.e==='htm')); }

// ===================================================================
// TAB2: TNG1 SYSTEM ARCHITECTURE (from TNG1_architecture.html)
// ===================================================================
let t2Initialized = false;

const t2Nodes = [
  // === core: 중앙 허브 ===
  {id:'TNG1_B',label:'TNG1_B.asp',sub:'수주/견적 메인 허브',type:'main',group:'core',x:600,y:400,detail:{desc:'수주/견적 중심 허브 (2500줄, 70+파일 연결)',tables:['tng_sja','tng_sjaSub','tk_frameK','tk_framekSub','tk_etc','tk_wms_detail','tk_customer','tk_daesin','tng_sjb','tng_sjbtype','tk_qty','tk_yongcha']}},
  {id:'TNG1_B_db',label:'TNG1_B_db.asp',sub:'DB처리(수주저장)',type:'db',group:'core',x:350,y:300,detail:{desc:'수주/견적 메인 폼 INSERT/UPDATE/DELETE',tables:['tng_sja','tng_sjaSub','tk_frameK','tk_framekSub']}},
  {id:'TNG1_B_dbyong',label:'TNG1_B_dbyong.asp',sub:'DB처리(용차)',type:'db',group:'core',x:350,y:500,detail:{desc:'용차(배송차량) 정보 저장/삭제',tables:['tk_yongcha']}},
  {id:'TNG1_B_dbDaesin',label:'TNG1_B_dbDaesin.asp',sub:'DB처리(대신)',type:'db',group:'core',x:350,y:600,detail:{desc:'대신(배송대행) 정보 저장/삭제',tables:['tk_daesin']}},
  {id:'choicecorp',label:'choicecorp.asp',sub:'거래처 선택 팝업',type:'popup',group:'core',x:280,y:400,detail:{desc:'거래처 검색/선택 팝업',tables:['tk_customer']}},
  {id:'baljulist',label:'baljulist.asp',sub:'수주 목록',type:'popup',group:'core',x:450,y:250,detail:{desc:'수주/견적 목록 검색',tables:['tng_sja','tk_customer']}},
  {id:'B_table',label:'TNG1_B_table.asp',sub:'품목테이블(AJAX)',type:'db',group:'core',x:750,y:250,detail:{desc:'AJAX 품목 테이블 로드',tables:['tng_sjaSub','tng_sjb']}},
  {id:'TNG1_Tdb',label:'TNG1_Tdb.asp',sub:'DB처리(프레임타입)',type:'db',group:'core',x:800,y:350,detail:{desc:'프레임타입 INSERT/UPDATE/DELETE',tables:['tk_frame','tk_frameK','tk_framekSub','tng_sja']}},
  // === suju: 수주/견적 입력 ===
  {id:'suju_quick',label:'TNG1_B_suju_quick.asp',sub:'빠른 수주 입력',type:'popup',group:'suju',x:950,y:400,detail:{desc:'품목별 빠른 수주 입력 (1500줄+)',tables:['tng_sja','tng_sjaSub','tng_sjb','tk_frameK','tk_framekSub','tk_qty','tk_barasi']}},
  {id:'suju2_pop',label:'TNG1_B_suju2_pop_quick.asp',sub:'절곡자재 선택',type:'popup',group:'suju',x:1200,y:300,detail:{desc:'절곡자재(바라시) 선택/변경 팝업',tables:['tk_barasi','tk_barasisub','tk_framekSub']}},
  {id:'choiceframe_quick',label:'TNG1_B_choiceframe_quick.asp',sub:'프레임 선택(빠른)',type:'popup',group:'suju',x:1200,y:400,detail:{desc:'프레임 도면 선택 팝업',tables:['tk_frame','tk_frameK']}},
  {id:'choiceframe_fix',label:'TNG1_b_choiceframe_fix.asp',sub:'프레임 선택(고정)',type:'popup',group:'suju',x:1200,y:480,detail:{desc:'프레임 도면 선택(고정형)',tables:['tk_frame','tk_frameK']}},
  {id:'suju_cal',label:'TNG1_B_suju_cal_quick.asp',sub:'수주 계산',type:'db',group:'suju',x:1200,y:560,detail:{desc:'수주 가격 자동 계산',tables:['tng_sjaSub','tk_qty','tng_unitprice_t']}},
  {id:'suju_alprice',label:'TNG1_B_suju_alprice.asp',sub:'AL 가격 계산',type:'db',group:'suju',x:1350,y:460,detail:{desc:'알루미늄 가격 계산',tables:['tng_unitprice_al','tk_framekSub']}},
  {id:'suju_stprice',label:'TNG1_B_suju_stprice.asp',sub:'ST 가격 계산',type:'db',group:'suju',x:1350,y:540,detail:{desc:'철재 가격 계산',tables:['tng_unitprice_t','tk_framekSub']}},
  {id:'jaebun',label:'TNG1_B_jaebun.asp',sub:'자재 분배',type:'db',group:'suju',x:1350,y:620,detail:{desc:'수주 자재 재분배',tables:['tng_sjaSub','tk_framekSub']}},
  {id:'boyang',label:'TNG1_B_boyang.asp',sub:'보양 처리',type:'db',group:'suju',x:1350,y:700,detail:{desc:'보양(마감재) 처리',tables:['tng_sjaSub']}},
  {id:'baljuDB',label:'TNG1_B_baljuDB.asp',sub:'발주 DB처리',type:'db',group:'suju',x:1200,y:220,detail:{desc:'발주 DB 전환 처리',tables:['tk_balju_st','tng_sja']}},
  // === door: 도어 ===
  {id:'doorpop',label:'TNG1_B_doorpop.asp',sub:'도어 수정 팝업',type:'popup',group:'door',x:1100,y:650,detail:{desc:'도어 사양 수정 팝업 (1000줄+)',tables:['tng_sjb','tk_qty','tk_framekSub']}},
  {id:'doorhchg',label:'TNG1_B_doorhchg.asp',sub:'도어 기타옵션',type:'popup',group:'door',x:1100,y:750,detail:{desc:'로비폰/중간소대/하부레일 옵션',tables:['tk_framekSub']}},
  {id:'door_glass_pop',label:'TNG1_B_door_glass_pop.asp',sub:'유리 정보 보기',type:'popup',group:'door',x:900,y:550,detail:{desc:'도어 유리 사양 조회',tables:['tng_sjb','tk_qty']}},
  {id:'lobbyphone',label:'TNG1_B_lobbyphone.asp',sub:'로비폰 추가',type:'db',group:'door',x:1300,y:700,detail:{desc:'로비폰 옵션 추가',tables:['tk_framekSub']}},
  {id:'boonhal',label:'TNG1_B_boonhal.asp',sub:'중간소대 추가',type:'db',group:'door',x:1300,y:770,detail:{desc:'중간소대(분할) 추가',tables:['tk_framekSub']}},
  {id:'haburail',label:'TNG1_B_haburail.asp',sub:'하부레일 추가',type:'db',group:'door',x:1300,y:840,detail:{desc:'하부레일 옵션 추가',tables:['tk_framekSub']}},
  // === greem: 도면/프레임 ===
  {id:'GREEMLIST',label:'TNG1_GREEMLIST.asp',sub:'프레임 도면 목록',type:'popup',group:'greem',x:500,y:650,detail:{desc:'프레임 도면 목록 뷰어',tables:['tk_frame','tk_frameK','tk_framekSub','tng_sjb','tk_qty']}},
  {id:'GREEMLIST3',label:'TNG1_GREEMLIST3.asp',sub:'확장 도면 목록',type:'popup',group:'greem',x:700,y:650,detail:{desc:'확장 도면 + 입면도',tables:['tk_frame','tk_frameK','tk_framekSub','tng_sjb','tk_qty']}},
  {id:'greemlist3_frame',label:'tng1_greemlist3_frame.asp',sub:'프레임 상세(iframe)',type:'popup',group:'greem',x:850,y:730,detail:{desc:'GREEMLIST3 내부 iframe'}},
  {id:'FRAME_A_BAJU',label:'TNG1_FRAME_A_BAJU.asp',sub:'SVG 프레임 조립도',type:'popup',group:'greem',x:350,y:730,detail:{desc:'SVG 캔버스 프레임 조립도',tables:['tng_sja','tng_sjb','tk_frame','tk_frameK']}},
  {id:'FRAME_A_BAJUdb',label:'TNG1_FRAME_A_BAJUdb.asp',sub:'DB처리(조립도)',type:'db',group:'greem',x:200,y:730,detail:{desc:'조립도 저장/삭제',tables:['tk_frameK','tk_framekSub']}},
  {id:'TNG1_FRAME',label:'TNG1_FRAME.asp',sub:'프레임 상세 뷰어',type:'popup',group:'greem',x:500,y:750,detail:{desc:'개별 프레임 상세',tables:['tk_frame','tk_frameK']}},
  {id:'order_asp',label:'order.asp',sub:'주문 처리',type:'db',group:'greem',x:200,y:820,detail:{desc:'조립도에서 주문 처리',tables:['tng_sja','tng_sjb']}},
  // === julgok: 절곡 ===
  {id:'JULGOK_IN',label:'TNG1_JULGOK_IN.asp',sub:'절곡 자재 입력',type:'popup',group:'julgok',x:200,y:100,detail:{desc:'절곡 자재 선택/입력',tables:['tk_barasi','tk_barasisub','tng_sja','tk_barasi_type']}},
  {id:'JULGOK_IN_DB',label:'TNG1_JULGOK_IN_DB.asp',sub:'DB처리(절곡입력)',type:'db',group:'julgok',x:50,y:40,detail:{desc:'절곡 INSERT/UPDATE/DELETE',tables:['tk_barasi','tk_barasisub']}},
  {id:'JULGOK_IN_SUB',label:'TNG1_JULGOK_IN_SUB.asp',sub:'절곡 서브(iframe)',type:'popup',group:'julgok',x:350,y:30,detail:{desc:'절곡 세부 입력 iframe',tables:['tk_barasisub']}},
  {id:'JULGOK_BALJU',label:'TNG1_JULGOK_BALJU.asp',sub:'절곡 설정/시각화',type:'popup',group:'julgok',x:200,y:200,detail:{desc:'절곡 SVG 시각화 + 벤드값',tables:['tk_barasi','tng_sja','tng_sjb']}},
  {id:'JULGOK_BALJU_DB',label:'TNG1_JULGOK_BALJU_DB.asp',sub:'DB처리(절곡설정)',type:'db',group:'julgok',x:50,y:200,detail:{desc:'절곡 설정 저장',tables:['tk_barasi','tk_barasisub']}},
  {id:'JULGOK_PUMMOK',label:'TNG1_JULGOK_PUMMOK.asp',sub:'절곡 품목 관리',type:'popup',group:'julgok',x:200,y:0,detail:{desc:'절곡 품목 등록/관리',tables:['tk_qty','tk_barasi']}},
  {id:'julgok_movexy',label:'julgok_movexy.asp',sub:'절곡 위치 이동',type:'popup',group:'julgok',x:50,y:100,detail:{desc:'절곡 좌표 이동 팝업',tables:['tk_barasi']}},
  // === price: 단가 ===
  {id:'unitprice_t',label:'unitprice_t.asp',sub:'단가 관리(수동/자동)',type:'popup',group:'price',x:1000,y:100,detail:{desc:'단가 테이블 관리',tables:['tng_unitprice_t']}},
  {id:'unittype_p',label:'unittype_p.asp',sub:'단가 타입 관리',type:'popup',group:'price',x:1150,y:100,detail:{desc:'단가 타입 관리',tables:['tng_unitprice_t']}},
  {id:'unittype_al',label:'unittype_pa.asp',sub:'알루미늄 단가',type:'popup',group:'price',x:1150,y:180,detail:{desc:'알루미늄 단가 관리',tables:['tng_unitprice_al']}},
  {id:'unitprice_tdb',label:'unitprice_tdb.asp',sub:'DB처리(단가)',type:'db',group:'price',x:1000,y:20,detail:{desc:'단가 INSERT/UPDATE/DELETE',tables:['tng_unitprice_t']}},
  // === stain: 도장/품목 ===
  {id:'stain_Item',label:'TNG1_stain_Item.asp',sub:'품목 아이템 목록',type:'popup',group:'stain',x:900,y:450,detail:{desc:'품목 아이템 CRUD',tables:['tng_sjbtype','tk_qty']}},
  {id:'STAIN_Itemdb',label:'TNG1_STAIN_Itemdb.asp',sub:'DB처리(품목)',type:'db',group:'stain',x:1050,y:500,detail:{desc:'품목 INSERT/UPDATE/DELETE',tables:['tng_sjbtype','tk_qty']}},
  {id:'pummok_item',label:'tng1_pummok_item.asp',sub:'품목 검색',type:'popup',group:'stain',x:1050,y:570,detail:{desc:'품목 검색 화면',tables:['tng_sjbtype','tk_qty']}},
  {id:'PUMMOK_LIST1',label:'TNG1_JULGOK_PUMMOK_LIST1.asp',sub:'품목 자재 목록',type:'popup',group:'stain',x:1050,y:640,detail:{desc:'품목별 자재 목록',tables:['tk_qty','tk_barasi']}},
  {id:'SJB_TYPE_INSERT',label:'TNG1_SJB_TYPE_INSERT.asp',sub:'상품타입 관리',type:'popup',group:'stain',x:850,y:170,detail:{desc:'상품타입 CRUD',tables:['tng_sjbtype']}},
  {id:'SJB_TYPE_INSERTdb',label:'TNG1_SJB_TYPE_INSERTdb.asp',sub:'DB처리(상품타입)',type:'db',group:'stain',x:1000,y:230,detail:{desc:'상품타입 저장',tables:['tng_sjbtype']}},
  {id:'SJB_TYPE_INSERT_open',label:'SJB_TYPE_INSERT_open.asp',sub:'상품타입(팝업)',type:'popup',group:'stain',x:1000,y:170,detail:{desc:'상품타입 팝업 버전',tables:['tng_sjbtype']}},
  {id:'paint_item_pop',label:'paint_item_pop.asp',sub:'도장 아이템',type:'popup',group:'stain',x:1200,y:140,detail:{desc:'도장 아이템 선택 팝업',tables:['tk_qty']}},
  // === balju: 발주서 ===
  {id:'baljuST',label:'TNG1_B_baljuST.asp',sub:'발주서(절곡)',type:'print',group:'balju',x:400,y:80,detail:{desc:'절곡 발주서 인쇄/PDF',tables:['tk_balju_st','tng_sja','tng_sjb','tk_qty']}},
  {id:'baljuST1',label:'TNG1_B_baljuST1.asp',sub:'발주서(샤링)',type:'print',group:'balju',x:500,y:0,detail:{desc:'샤링 발주서',tables:['tk_balju_st','tng_sja']}},
  {id:'baljuAL',label:'TNG1_B_baljuAL.asp',sub:'발주서(알루미늄)',type:'print',group:'balju',x:620,y:0,detail:{desc:'알루미늄 발주서',tables:['tk_balju_st','tng_sja']}},
  // === data: 첨부/문서 ===
  {id:'B_data',label:'TNG1_B_data.asp',sub:'첨부파일 관리',type:'popup',group:'data',x:750,y:500,detail:{desc:'파일 업로드/메모/클립보드',tables:['tk_picupload','tk_picfiles','tk_picmemo']}},
  {id:'B_datalist',label:'TNG1_B_datalist.asp',sub:'첨부파일 목록',type:'popup',group:'data',x:750,y:580,detail:{desc:'첨부파일 조회/미리보기',tables:['tk_picupload','tk_picfiles']}},
  {id:'save_file',label:'save_file.asp',sub:'파일 업로드',type:'db',group:'data',x:900,y:500,detail:{desc:'파일 서버 저장',tables:['tk_picfiles']}},
  {id:'save_memo',label:'save_memo.asp',sub:'메모 저장',type:'db',group:'data',x:900,y:560,detail:{desc:'메모 INSERT/UPDATE',tables:['tk_picmemo']}},
  {id:'upload_paste',label:'upload_paste_data.asp',sub:'클립보드 업로드',type:'db',group:'data',x:900,y:620,detail:{desc:'클립보드 이미지 저장',tables:['tk_picfiles']}},
  {id:'picdelete',label:'picdelete.asp',sub:'파일 삭제',type:'db',group:'data',x:900,y:680,detail:{desc:'첨부파일 DELETE',tables:['tk_picupload','tk_picfiles']}},
  {id:'meno_pop',label:'tng1_b_meno_pop.asp',sub:'메모 팝업',type:'popup',group:'data',x:850,y:400,detail:{desc:'수주별 메모 CRUD',tables:['tk_picmemo']}},
  // === print: 출력 ===
  {id:'simpleOrder',label:'/documents/simpleOrder',sub:'간편 주문서',type:'external',group:'print',x:550,y:80,detail:{desc:'간편/직인 견적서 PDF'}},
  {id:'outsideOrder',label:'/documents/outsideOrder',sub:'외부 발주서',type:'external',group:'print',x:650,y:80,detail:{desc:'상세 견적서 미리보기'}},
  {id:'insideOrder',label:'/documents/insideOrder',sub:'내부 발주서',type:'external',group:'print',x:650,y:160,detail:{desc:'내부 발주서 인쇄'}},
  {id:'print_modal',label:'modal/print/index.asp',sub:'인쇄모달(AJAX)',type:'print',group:'print',x:550,y:160,detail:{desc:'인쇄 목록 모달',tables:['tng_sja']}},
  {id:'quotation',label:'quotation/index.asp',sub:'견적서 출력',type:'print',group:'print',x:300,y:0,detail:{desc:'견적서 카드형 출력',tables:['tng_sja','tng_sjaSub','tng_sjb','tng_sjbtype','tk_customer']}},
  {id:'installManual',label:'/documents/installationManual',sub:'도면/도어유리 뷰어',type:'external',group:'print',x:750,y:160,detail:{desc:'시공 도면 뷰어'}},
  // === external: 외부 모듈 ===
  {id:'WMS_Create',label:'TNG_WMS_Create.asp',sub:'WMS 생성',type:'external',group:'external',x:100,y:350,detail:{desc:'WMS 데이터 생성'}},
  {id:'WMS_DASHBOARD',label:'TNG_WMS_DASHBOARD.asp',sub:'WMS 대시보드',type:'external',group:'external',x:100,y:430,detail:{desc:'WMS 현황 대시보드'}},
  {id:'nesting_v3',label:'nesting_v3/nesting_main.asp',sub:'판풀이(네스팅)',type:'external',group:'external',x:100,y:270,detail:{desc:'TNG2 네스팅 모듈'}},
  {id:'ds3211',label:'ds3211.co.kr',sub:'대신화물 조회',type:'external',group:'external',x:100,y:510,detail:{desc:'외부: 대신화물 검색'}},
  {id:'corpudt',label:'/cyj/corpudt.asp',sub:'거래처 정보 수정',type:'external',group:'external',x:100,y:590,detail:{desc:'거래처 상세 수정'}},
  // === inspector: 검수/편집 체인 (suju_quick 파생) ===
  {id:'inspector_v5',label:'inspector_v5.asp',sub:'검수/편집 팝업',type:'popup',group:'suju',x:1500,y:400,detail:{desc:'SVG 부재 클릭→검수/편집 (6000줄+)',tables:['tk_framekSub','tk_qty','tng_sjb','tk_barasisub']}},
  {id:'inspector_cal',label:'inspector_cal.asp',sub:'계산기 팝업',type:'popup',group:'suju',x:1650,y:340,detail:{desc:'검수 계산값 적용'}},
  {id:'inspector_length',label:'inspector_length.asp',sub:'길이 설정',type:'popup',group:'suju',x:1650,y:400,detail:{desc:'부재 길이 수동 설정'}},
  {id:'lengthc',label:'lengthc.asp',sub:'자동길이적용',type:'popup',group:'suju',x:1650,y:460,detail:{desc:'부재 길이 자동 적용'}},
  // === suju2: 수주입력 일반모드 ===
  {id:'suju2',label:'tng1_b_suju2.asp',sub:'수주 입력(일반)',type:'popup',group:'suju',x:1500,y:200,detail:{desc:'수주 입력 일반모드',tables:['tng_sja','tng_sjaSub','tng_sjb','tk_frameK','tk_framekSub','tk_qty']}},
  {id:'suju2_pop_n',label:'TNG1_B_suju2_pop.asp',sub:'절곡자재(일반)',type:'popup',group:'suju',x:1650,y:140,detail:{desc:'suju2 절곡자재 팝업',tables:['tk_barasi','tk_barasisub']}},
  {id:'choiceframe',label:'TNG1_B_choiceframe.asp',sub:'프레임 선택(일반)',type:'popup',group:'suju',x:1650,y:200,detail:{desc:'프레임 선택 (일반모드)',tables:['tk_frame','tk_frameK']}},
  {id:'suju_sjasub',label:'TNG1_B_suju_sjasub.asp',sub:'품목 저장',type:'db',group:'suju',x:1650,y:260,detail:{desc:'품목 INSERT/UPDATE',tables:['tng_sjaSub']}},
  {id:'suju_cal_n',label:'TNG1_B_suju_cal.asp',sub:'수주계산(일반)',type:'db',group:'suju',x:1500,y:140,detail:{desc:'일반 가격 계산',tables:['tng_sjaSub','tk_qty','tng_unitprice_t']}},
  {id:'suju_finish',label:'TNG1_B_suju_finish_cal.asp',sub:'견적 완료',type:'db',group:'suju',x:1650,y:80,detail:{desc:'견적 최종 완료',tables:['tng_sjaSub','tk_framekSub']}},
  // === suju_cal 분기 ===
  {id:'suju_cal_fix',label:'TNG1_B_suju_cal_fix.asp',sub:'수주계산(고정)',type:'db',group:'suju',x:1350,y:140,detail:{desc:'고정형 가격계산 (1300줄)',tables:['tng_sjaSub','tk_qty','tng_unitprice_t']}},
  {id:'suju_cal_st',label:'TNG1_B_suju_cal_quick_st.asp',sub:'ST 수주계산',type:'db',group:'suju',x:1500,y:80,detail:{desc:'철재 전용 가격계산',tables:['tng_unitprice_t','tk_framekSub']}},
  {id:'choiceframeb',label:'TNG1_b_choiceframeb.asp',sub:'프레임 선택B',type:'popup',group:'suju',x:1500,y:300,detail:{desc:'프레임 선택 B타입',tables:['tk_frame','tk_frameK']}},
];

const t2Edges = [
  // === TNG1_B → core ===
  {from:'TNG1_B',to:'TNG1_B_db',label:'form:frmMain',type:'form'},
  {from:'TNG1_B_db',to:'TNG1_B',label:'redirect:저장후',type:'redirect'},
  {from:'TNG1_B',to:'TNG1_B_db',label:'fetch:복사/삭제',type:'fetch'},
  {from:'TNG1_B',to:'TNG1_B_dbyong',label:'form:fyong',type:'form'},
  {from:'TNG1_B',to:'TNG1_B_dbyong',label:'link:용차삭제',type:'link'},
  {from:'TNG1_B',to:'TNG1_B_dbDaesin',label:'form:fdaesin',type:'form'},
  {from:'TNG1_B',to:'TNG1_B_dbDaesin',label:'link:대신삭제',type:'link'},
  {from:'TNG1_B',to:'TNG1_Tdb',label:'link:프레임타입',type:'link'},
  {from:'TNG1_B',to:'choicecorp',label:'popup:거래처선택',type:'popup'},
  {from:'choicecorp',to:'TNG1_B',label:'opener.replace',type:'redirect'},
  {from:'TNG1_B',to:'baljulist',label:'link:수주목록',type:'link'},
  {from:'baljulist',to:'TNG1_B',label:'link:상세이동',type:'link'},
  {from:'TNG1_B',to:'B_table',label:'fetch:품목로드',type:'fetch'},
  // === TNG1_B → suju ===
  {from:'TNG1_B',to:'suju_quick',label:'popup:빠른입력',type:'popup'},
  {from:'suju_quick',to:'suju2_pop',label:'popup:절곡자재',type:'popup'},
  {from:'suju2_pop',to:'suju_quick',label:'opener:완료',type:'redirect'},
  {from:'suju_quick',to:'choiceframe_quick',label:'popup:프레임선택',type:'popup'},
  {from:'choiceframe_quick',to:'suju_quick',label:'opener:선택후',type:'redirect'},
  {from:'suju_quick',to:'choiceframe_fix',label:'popup:프레임고정',type:'popup'},
  {from:'suju_quick',to:'suju_cal',label:'form:가격계산',type:'form'},
  {from:'suju_quick',to:'suju_alprice',label:'form:AL가격',type:'form'},
  {from:'suju_quick',to:'suju_stprice',label:'form:ST가격',type:'form'},
  {from:'suju_quick',to:'jaebun',label:'form:자재분배',type:'form'},
  {from:'jaebun',to:'suju_quick',label:'redirect:완료',type:'redirect'},
  {from:'suju_quick',to:'boyang',label:'form:보양처리',type:'form'},
  {from:'suju_quick',to:'baljuDB',label:'popup:발주DB',type:'popup'},
  {from:'suju_quick',to:'paint_item_pop',label:'popup:도장선택',type:'popup'},
  {from:'suju_quick',to:'corpudt',label:'popup:거래처수정',type:'popup'},
  {from:'suju_quick',to:'installManual',label:'popup:도어유리',type:'popup'},
  // === TNG1_B → door ===
  {from:'TNG1_B',to:'door_glass_pop',label:'popup:유리보기',type:'popup'},
  {from:'suju_quick',to:'doorpop',label:'popup:도어수정',type:'popup'},
  {from:'doorpop',to:'suju_quick',label:'opener:종료',type:'redirect'},
  {from:'suju_quick',to:'doorhchg',label:'popup:기타옵션',type:'popup'},
  {from:'doorhchg',to:'lobbyphone',label:'link:로비폰',type:'link'},
  {from:'doorhchg',to:'boonhal',label:'link:중간소대',type:'link'},
  {from:'doorhchg',to:'haburail',label:'link:하부레일',type:'link'},
  // === TNG1_B → greem ===
  {from:'TNG1_B',to:'GREEMLIST',label:'link:도면목록',type:'link'},
  {from:'TNG1_B',to:'GREEMLIST3',label:'link:확장도면',type:'link'},
  {from:'GREEMLIST3',to:'greemlist3_frame',label:'iframe',type:'iframe'},
  {from:'GREEMLIST',to:'TNG1_FRAME',label:'popup:프레임상세',type:'popup'},
  {from:'TNG1_B',to:'FRAME_A_BAJU',label:'link:조립도',type:'link'},
  {from:'FRAME_A_BAJU',to:'FRAME_A_BAJUdb',label:'link:조립도삭제',type:'link'},
  {from:'FRAME_A_BAJU',to:'order_asp',label:'form:주문처리',type:'form'},
  // === TNG1_B → julgok ===
  {from:'TNG1_B',to:'JULGOK_IN',label:'link:절곡입력',type:'link'},
  {from:'JULGOK_IN',to:'JULGOK_IN_DB',label:'form:절곡저장',type:'form'},
  {from:'JULGOK_IN',to:'JULGOK_IN_SUB',label:'iframe:절곡서브',type:'iframe'},
  {from:'JULGOK_IN',to:'JULGOK_PUMMOK',label:'link:절곡품목',type:'link'},
  {from:'TNG1_B',to:'JULGOK_BALJU',label:'link:절곡설정',type:'link'},
  {from:'JULGOK_BALJU',to:'JULGOK_BALJU_DB',label:'form:설정저장',type:'form'},
  // === TNG1_B → price ===
  {from:'TNG1_B',to:'unitprice_t',label:'link:단가관리',type:'link'},
  {from:'unitprice_t',to:'unitprice_tdb',label:'form:단가저장',type:'form'},
  {from:'TNG1_B',to:'unittype_p',label:'link:단가타입',type:'link'},
  {from:'TNG1_B',to:'unittype_al',label:'link:AL단가',type:'link'},
  // === TNG1_B → stain ===
  {from:'TNG1_B',to:'stain_Item',label:'link:품목아이템',type:'link'},
  {from:'stain_Item',to:'STAIN_Itemdb',label:'form:품목저장',type:'form'},
  {from:'stain_Item',to:'pummok_item',label:'form:품목검색',type:'form'},
  {from:'stain_Item',to:'PUMMOK_LIST1',label:'link:자재목록',type:'link'},
  {from:'TNG1_B',to:'SJB_TYPE_INSERT',label:'link:상품타입',type:'link'},
  {from:'SJB_TYPE_INSERT',to:'SJB_TYPE_INSERTdb',label:'form',type:'form'},
  {from:'SJB_TYPE_INSERTdb',to:'SJB_TYPE_INSERT',label:'redirect',type:'redirect'},
  {from:'SJB_TYPE_INSERT_open',to:'SJB_TYPE_INSERTdb',label:'form',type:'form'},
  // === TNG1_B → balju ===
  {from:'TNG1_B',to:'baljuST',label:'popup:절곡발주',type:'popup'},
  {from:'TNG1_B',to:'baljuST1',label:'popup:샤링발주',type:'popup'},
  {from:'TNG1_B',to:'baljuAL',label:'popup:AL발주',type:'popup'},
  {from:'baljuST',to:'julgok_movexy',label:'popup:위치이동',type:'popup'},
  // === TNG1_B → data ===
  {from:'TNG1_B',to:'B_data',label:'popup:첨부관리',type:'popup'},
  {from:'B_data',to:'save_file',label:'form:파일업로드',type:'form'},
  {from:'B_data',to:'save_memo',label:'form:메모저장',type:'form'},
  {from:'B_data',to:'upload_paste',label:'fetch:붙여넣기',type:'fetch'},
  {from:'B_data',to:'picdelete',label:'link:파일삭제',type:'link'},
  {from:'TNG1_B',to:'B_datalist',label:'popup:첨부목록',type:'popup'},
  {from:'B_datalist',to:'picdelete',label:'link:파일삭제',type:'link'},
  {from:'TNG1_B',to:'meno_pop',label:'popup:메모',type:'popup'},
  // === TNG1_B → print ===
  {from:'TNG1_B',to:'simpleOrder',label:'popup:주문서',type:'popup'},
  {from:'TNG1_B',to:'outsideOrder',label:'popup:상세견적서',type:'popup'},
  {from:'TNG1_B',to:'print_modal',label:'fetch:인쇄모달',type:'fetch'},
  {from:'print_modal',to:'insideOrder',label:'popup:내부발주서',type:'popup'},
  {from:'TNG1_B',to:'installManual',label:'popup:도면보기',type:'popup'},
  // === TNG1_B → external ===
  {from:'TNG1_B',to:'WMS_Create',label:'link:WMS생성',type:'link'},
  {from:'TNG1_B',to:'WMS_DASHBOARD',label:'link:대시보드',type:'link'},
  {from:'TNG1_B',to:'nesting_v3',label:'popup:판풀이',type:'popup'},
  {from:'TNG1_B',to:'ds3211',label:'popup:화물조회',type:'popup'},
  // === suju_quick → inspector 체인 ===
  {from:'suju_quick',to:'inspector_v5',label:'popup:검수편집',type:'popup'},
  {from:'inspector_v5',to:'inspector_cal',label:'popup:계산기',type:'popup'},
  {from:'inspector_v5',to:'inspector_length',label:'popup:길이설정',type:'popup'},
  {from:'inspector_v5',to:'lengthc',label:'popup:자동길이',type:'popup'},
  {from:'inspector_v5',to:'suju2_pop',label:'popup:절곡변경',type:'popup'},
  {from:'inspector_v5',to:'suju_quick',label:'opener:완료',type:'redirect'},
  // === suju_cal 분기 ===
  {from:'suju_cal',to:'suju_cal_fix',label:'redirect:고정형',type:'redirect'},
  {from:'suju_cal',to:'suju_cal_st',label:'redirect:ST계산',type:'redirect'},
  {from:'suju_cal',to:'choiceframeb',label:'redirect:프레임B',type:'redirect'},
  {from:'suju_cal',to:'suju_quick',label:'redirect:완료',type:'redirect'},
  {from:'suju_cal_fix',to:'suju_quick',label:'redirect:완료',type:'redirect'},
  {from:'suju_cal_st',to:'suju_cal_fix',label:'redirect:고정형',type:'redirect'},
  {from:'suju_cal_st',to:'suju_quick',label:'redirect:완료',type:'redirect'},
  {from:'choiceframeb',to:'suju2',label:'opener:선택후',type:'redirect'},
  // === suju2 일반모드 체인 ===
  {from:'suju2',to:'suju2_pop_n',label:'popup:절곡자재',type:'popup'},
  {from:'suju2',to:'choiceframe',label:'popup:프레임선택',type:'popup'},
  {from:'suju2',to:'choiceframe_fix',label:'popup:프레임고정',type:'popup'},
  {from:'suju2',to:'doorhchg',label:'popup:기타옵션',type:'popup'},
  {from:'suju2',to:'doorpop',label:'popup:도어견적',type:'popup'},
  {from:'suju2',to:'paint_item_pop',label:'popup:도장선택',type:'popup'},
  {from:'suju2',to:'suju_sjasub',label:'form:품목저장',type:'form'},
  {from:'suju2',to:'suju_cal_n',label:'form:가격계산',type:'form'},
  {from:'suju2',to:'suju_alprice',label:'form:AL가격',type:'form'},
  {from:'suju2',to:'suju_stprice',label:'form:ST가격',type:'form'},
  {from:'suju2',to:'jaebun',label:'form:자재분배',type:'form'},
  {from:'suju2',to:'boyang',label:'form:보양',type:'form'},
  {from:'suju2',to:'suju_finish',label:'link:견적완료',type:'link'},
  {from:'suju_cal_n',to:'suju2',label:'redirect:완료',type:'redirect'},
  {from:'lengthc',to:'choiceframeb',label:'redirect',type:'redirect'},
];

const t2TypeColors = { main:{fill:'#1f6feb',stroke:'#58a6ff'}, db:{fill:'#238636',stroke:'#3fb950'}, popup:{fill:'#9e6a03',stroke:'#f0883e'}, external:{fill:'#8957e5',stroke:'#bc8cff'}, print:{fill:'#da3633',stroke:'#f85149'} };
const t2EdgeColors = { form:'#3fb950', redirect:'#f0883e', popup:'#bc8cff', link:'#58a6ff', iframe:'#f85149', fetch:'#e3b341' };

let t2Filter = 'all';
let t2Transform = { x: 200, y: 100, k: 1.1 };
let t2Dragging = null, t2DragOff = {x:0,y:0}, t2Panning = false, t2PanStart = {x:0,y:0};
const NS = 'http://www.w3.org/2000/svg';

function t2Init() {
  const canvas = document.getElementById('tab2-canvas');
  const svg = document.createElementNS(NS,'svg'); svg.setAttribute('id','t2-svg');
  const defs = document.createElementNS(NS,'defs');
  Object.entries(t2EdgeColors).forEach(([type,color]) => {
    const marker = document.createElementNS(NS,'marker');
    marker.setAttribute('id','arrow-'+type); marker.setAttribute('viewBox','0 0 10 6');
    marker.setAttribute('refX','10'); marker.setAttribute('refY','3');
    marker.setAttribute('markerWidth','10'); marker.setAttribute('markerHeight','6');
    marker.setAttribute('orient','auto');
    const path = document.createElementNS(NS,'path');
    path.setAttribute('d','M0,0 L10,3 L0,6 Z'); path.setAttribute('fill',color);
    marker.appendChild(path); defs.appendChild(marker);
  });
  svg.appendChild(defs);
  const g = document.createElementNS(NS,'g'); g.setAttribute('id','t2-group'); svg.appendChild(g);
  canvas.appendChild(svg);

  svg.addEventListener('mousedown', e => {
    if (!e.target.closest('.node-group')) { t2Panning = true; t2PanStart = {x:e.clientX-t2Transform.x,y:e.clientY-t2Transform.y}; }
  });
  svg.addEventListener('mousemove', e => {
    if (t2Panning) { t2Transform.x = e.clientX-t2PanStart.x; t2Transform.y = e.clientY-t2PanStart.y; t2Apply(); }
    if (t2Dragging) {
      const node = t2Nodes.find(n => n.id===t2Dragging);
      node.x = (e.clientX-t2Transform.x-t2DragOff.x)/t2Transform.k;
      node.y = (e.clientY-80-t2Transform.y-t2DragOff.y)/t2Transform.k;
      t2Render();
    }
  });
  svg.addEventListener('mouseup', () => { t2Panning=false; t2Dragging=null; });
  svg.addEventListener('mouseleave', () => { t2Panning=false; t2Dragging=null; });
  svg.addEventListener('wheel', e => {
    e.preventDefault();
    const rect = svg.getBoundingClientRect();
    const mx = e.clientX-rect.left, my = e.clientY-rect.top;
    const delta = e.deltaY>0?0.9:1.1;
    const newK = Math.max(0.2,Math.min(3,t2Transform.k*delta));
    t2Transform.x = mx-(mx-t2Transform.x)*(newK/t2Transform.k);
    t2Transform.y = my-(my-t2Transform.y)*(newK/t2Transform.k);
    t2Transform.k = newK;
    t2Apply();
  }, {passive:false});

  t2Render();
}

function t2Apply() { document.getElementById('t2-group').setAttribute('transform',`translate(${t2Transform.x},${t2Transform.y}) scale(${t2Transform.k})`); }

function t2Render() {
  const g = document.getElementById('t2-group'); g.innerHTML = '';
  const vNodes = t2Filter==='all'?t2Nodes:t2Nodes.filter(n => n.group===t2Filter || n.id==='TNG1_B');
  const vIds = new Set(vNodes.map(n=>n.id));
  const vEdges = t2Edges.filter(e => vIds.has(e.from)&&vIds.has(e.to));

  vEdges.forEach(e => {
    const fn = t2Nodes.find(n=>n.id===e.from), tn = t2Nodes.find(n=>n.id===e.to);
    if(!fn||!tn) return;
    const nw = e.from==='TNG1_B'?80:70;
    const dx=tn.x-fn.x, dy=tn.y-fn.y, dist=Math.sqrt(dx*dx+dy*dy)||1;
    const sx=fn.x+(dx/dist)*nw, sy=fn.y+(dy/dist)*18, ex=tn.x-(dx/dist)*70, ey=tn.y-(dy/dist)*18;
    const cx1=sx+(ex-sx)*0.3+(sy-ey)*0.15, cy1=sy+(ey-sy)*0.3-(sx-ex)*0.15;
    const cx2=sx+(ex-sx)*0.7+(sy-ey)*0.15, cy2=sy+(ey-sy)*0.7-(sx-ex)*0.15;
    const path = document.createElementNS(NS,'path');
    path.setAttribute('d',`M${sx},${sy} C${cx1},${cy1} ${cx2},${cy2} ${ex},${ey}`);
    path.setAttribute('class','edge'); path.setAttribute('stroke',t2EdgeColors[e.type]||'#484f58');
    path.setAttribute('marker-end',`url(#arrow-${e.type})`);
    g.appendChild(path);
    const midX=(sx+ex)/2+(sy-ey)*0.08, midY=(sy+ey)/2-(sx-ex)*0.08;
    const text = document.createElementNS(NS,'text');
    text.setAttribute('x',midX); text.setAttribute('y',midY); text.setAttribute('class','edge-label');
    text.textContent = e.label; g.appendChild(text);
  });

  vNodes.forEach(n => {
    const group = document.createElementNS(NS,'g');
    group.setAttribute('class','node-group'); group.setAttribute('transform',`translate(${n.x},${n.y})`);
    const isMain = n.id==='TNG1_B'; const w=isMain?170:150, h=isMain?44:38;
    const colors = t2TypeColors[n.type] || t2TypeColors.popup;
    const rect = document.createElementNS(NS,'rect');
    rect.setAttribute('x',-w/2); rect.setAttribute('y',-h/2); rect.setAttribute('width',w); rect.setAttribute('height',h);
    rect.setAttribute('fill',colors.fill); rect.setAttribute('stroke',colors.stroke); rect.setAttribute('class','node-rect');
    if(isMain){rect.setAttribute('stroke-width','3');rect.setAttribute('filter','drop-shadow(0 0 8px rgba(88,166,255,0.5))');}
    group.appendChild(rect);
    const label = document.createElementNS(NS,'text'); label.setAttribute('y',-3); label.setAttribute('class','node-label'); label.textContent=n.label; group.appendChild(label);
    const sub = document.createElementNS(NS,'text'); sub.setAttribute('y',12); sub.setAttribute('class','node-sublabel'); sub.textContent=n.sub; group.appendChild(sub);
    group.addEventListener('mousedown', e => { e.stopPropagation(); t2Dragging=n.id; t2DragOff={x:e.clientX-t2Transform.x-n.x*t2Transform.k,y:e.clientY-80-t2Transform.y-n.y*t2Transform.k}; });
    group.addEventListener('dblclick', () => t2ShowDetail(n));
    group.addEventListener('click', e => { if(!t2Dragging) t2ShowDetail(n); });
    g.appendChild(group);
  });
}

function t2ShowDetail(node) {
  const panel = document.getElementById('tab2-detail');
  const content = document.getElementById('tab2-detail-content');
  let html = `<h2>${node.label}</h2><p style="color:#8b949e;font-size:13px;margin-bottom:8px">${node.sub}</p>`;
  if (node.detail) {
    if(node.detail.desc) html += `<p style="font-size:12px;line-height:1.6;margin-bottom:8px">${node.detail.desc}</p>`;
    if(node.detail.params) { html += '<h3>파라미터</h3><div>'; node.detail.params.forEach(p => html += `<span class="tag">${p}</span> `); html += '</div>'; }
    if(node.detail.tables) { html += '<h3>DB 테이블</h3><div>'; node.detail.tables.forEach(t => html += `<span class="tag tag-db" style="cursor:pointer" onclick="ddlSearchTable('${t}')">${t}</span> `); html += '</div>'; }
    if(node.detail.forms) { html += '<h3>폼 전송</h3><ul>'; node.detail.forms.forEach(f => html += `<li>${f}</li>`); html += '</ul>'; }
  }
  const incoming = t2Edges.filter(e=>e.to===node.id), outgoing = t2Edges.filter(e=>e.from===node.id);
  if(incoming.length) { html += '<h3>들어오는 연결</h3><ul>'; incoming.forEach(e => html += `<li><span style="color:${t2EdgeColors[e.type]}">${e.label}</span> ← ${e.from}</li>`); html += '</ul>'; }
  if(outgoing.length) { html += '<h3>나가는 연결</h3><ul>'; outgoing.forEach(e => html += `<li><span style="color:${t2EdgeColors[e.type]}">${e.label}</span> → ${e.to}</li>`); html += '</ul>'; }
  content.innerHTML = html; panel.classList.add('open');
}

function t2ClosePanel() { document.getElementById('tab2-detail').classList.remove('open'); }

function t2SetFilter(filter) {
  t2Filter = filter;
  document.querySelectorAll('#tab2-toolbar button').forEach(b => b.classList.remove('active'));
  event.target.classList.add('active');
  t2Render();
}

function t2ResetView() { t2Transform={x:200,y:100,k:1.1}; t2Apply(); }

// === 중심 노드 전환 (BFS 방사형 레이아웃) ===
const t2OrigPos = {};
t2Nodes.forEach(n => { t2OrigPos[n.id] = {x:n.x, y:n.y}; });
let t2CurCenter = 'TNG1_B';

function t2SetCenter(centerId) {
  t2CurCenter = centerId;
  if (centerId === 'TNG1_B') {
    t2Nodes.forEach(n => { n.x = t2OrigPos[n.id].x; n.y = t2OrigPos[n.id].y; });
  } else {
    const visited = new Set(); const levels = [];
    let queue = [centerId]; visited.add(centerId);
    while (queue.length > 0) {
      levels.push([...queue]);
      const next = [];
      queue.forEach(id => {
        t2Edges.forEach(e => {
          let other = null;
          if (e.from === id) other = e.to;
          else if (e.to === id) other = e.from;
          if (other && !visited.has(other)) { visited.add(other); next.push(other); }
        });
      });
      queue = next;
    }
    const unvisited = t2Nodes.filter(n => !visited.has(n.id)).map(n => n.id);
    if (unvisited.length) levels.push(unvisited);
    const cx = 600, cy = 400;
    levels.forEach((ids, lvl) => {
      if (lvl === 0) { const n = t2Nodes.find(n => n.id === ids[0]); if(n){n.x=cx;n.y=cy;} }
      else {
        const radius = Math.min(lvl * 220, 800);
        ids.forEach((id, i) => {
          const angle = (2*Math.PI/ids.length)*i - Math.PI/2;
          const n = t2Nodes.find(n => n.id === id);
          if(n){n.x=cx+Math.cos(angle)*radius; n.y=cy+Math.sin(angle)*radius;}
        });
      }
    });
  }
  document.querySelectorAll('.center-btn').forEach(b => b.classList.toggle('active', b.dataset.center===centerId));
  t2Transform = centerId==='TNG1_B' ? {x:200,y:100,k:1.1} : {x:50,y:20,k:0.7};
  t2Apply(); t2Render();
}

// DDL 테이블 클릭 → DDL 패널 열기
function ddlSearchTable(tableName) {
  if (!ddlOpen) toggleDDL();
  document.getElementById('ddl-searchbox').value = tableName;
  renderDDL(tableName);
}

// ===================================================================
// UTILITY
// ===================================================================
function fmtSize(bytes) { if(bytes<1024)return bytes+' B'; if(bytes<1024*1024)return(bytes/1024).toFixed(1)+' KB'; return(bytes/1024/1024).toFixed(1)+' MB'; }
function escH(s) { if(!s)return''; return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
function showLoading(show) { document.getElementById('loading').style.display = show?'flex':'none'; }
function hlMatch(text,query) {
  const idx = text.toLowerCase().indexOf(query.toLowerCase());
  if(idx===-1) return escH(text);
  return escH(text.slice(0,idx))+'<span class="search-highlight">'+escH(text.slice(idx,idx+query.length))+'</span>'+escH(text.slice(idx+query.length));
}
function t1UpdateStatus() {
  const types = {}; allFiles.forEach(f => { types[f.e]=(types[f.e]||0)+1; });
  document.getElementById('statFiles').textContent = '파일: '+allFiles.length+'개';
  document.getElementById('statFolders').textContent = '폴더: '+Object.keys(folderGroups).length+'개';
  let ts=''; Object.keys(types).sort((a,b)=>types[b]-types[a]).forEach(ext => { ts+=ext.toUpperCase()+':'+types[ext]+' '; });
  document.getElementById('statTypes').textContent = ts.trim();
  document.getElementById('scanInfo').textContent = '스캔: '+new Date().toLocaleTimeString('ko-KR');
}
</script>
</body>
</html>