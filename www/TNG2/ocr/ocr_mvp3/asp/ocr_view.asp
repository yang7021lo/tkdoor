<%@ Language="VBScript" CodePage="65001" %>
<%
Response.Charset = "utf-8"
Response.ContentType = "text/html"

Dim currentFile, jsonFile
currentFile = Request.QueryString("file")
jsonFile = Request.QueryString("json")
If currentFile = "" Then currentFile = "sample.png"

If jsonFile = "" Then
    jsonFile = Replace(currentFile, ".png", "_ocr.json")
    jsonFile = Replace(jsonFile, ".jpg", "_ocr.json")
    jsonFile = Replace(jsonFile, ".jpeg", "_ocr.json")
End If
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCR 검측 입력</title>
    <link rel="stylesheet" href="/TNG2/ocr/ocr_mvp3/asp/css/ocr.css">
</head>
<body>
    <div id="ocr-container">
        <!-- 이미지 뷰어 -->
        <div class="ocr-viewer" id="ocrViewer">
            <!-- 줌 컨트롤 -->
            <div class="zoom-controls" id="zoomControls">
                <button class="zoom-btn" id="btnZoomOut" title="축소">-</button>
                <span class="zoom-label" id="zoomLabel">100%</span>
                <button class="zoom-btn" id="btnZoomIn" title="확대">+</button>
                <button class="zoom-btn" id="btnZoomFit" title="화면 맞춤">맞춤</button>
                <button class="zoom-btn" id="btnZoomReset" title="원본 크기">1:1</button>
                <span class="zoom-hint">휠:확대축소 | 우클릭드래그:줌</span>
            </div>
            <div class="ocr-image-wrap" id="imageWrap">
                <img id="ocrImage" src="/img/door/<%= currentFile %>" alt="OCR 이미지">
                <div class="line-highlight" id="lineHighlight"></div>
            </div>
        </div>

        <!-- 스플릿바 -->
        <div class="split-bar" id="splitBar">
            <div class="split-handle"></div>
        </div>

        <!-- 입력 패널 -->
        <div class="ocr-panel" id="ocrPanel">
            <div class="panel-header">검측 입력</div>

            <!-- 입력 영역 -->
            <div class="panel-input">
                <div class="current-line">
                    <h3>Line <span id="currentLineNum">1</span> / <span id="totalLines">0</span></h3>

                    <div class="field-row">
                        <div class="field">
                            <label>가로 (W)</label>
                            <input type="text" id="inputWidth" class="active" readonly>
                        </div>
                        <div class="field">
                            <label>세로 (H)</label>
                            <input type="text" id="inputHeight" readonly>
                        </div>
                        <div class="field">
                            <label>수량</label>
                            <input type="text" id="inputQty" placeholder="직접입력">
                        </div>
                    </div>

                    <div class="btn-row">
                        <button class="btn btn-success" id="btnConfirm">확정 (Enter)</button>
                        <button class="btn btn-secondary" id="btnSkip">건너뛰기</button>
                        <button class="btn btn-secondary" id="btnClear">초기화</button>
                    </div>
                </div>
            </div>

            <!-- 결과 테이블 (하단 고정) -->
            <div class="panel-results">
                <div class="result-header">
                    <span>입력 결과</span>
                    <span class="result-count"><span id="doneCount">0</span>건</span>
                </div>
                <div class="result-table-wrap" id="resultTableWrap">
                    <table class="result-table" id="resultTable">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>가로</th>
                                <th>세로</th>
                                <th>수량</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="resultBody"></tbody>
                    </table>
                </div>
            </div>

            <div class="panel-footer">
                <span><%= currentFile %></span>
                <span>Line <span id="footerLine">1</span>/<span id="footerTotal">0</span></span>
            </div>
        </div>
    </div>

    <script>
        var CONFIG = {
            jsonPath: '/TNG2/ocr/ocr_mvp3/asp/results/<%= jsonFile %>',
            imagePath: '/img/door/<%= currentFile %>',
            sourceFile: '<%= currentFile %>'
        };
    </script>
    <script src="/TNG2/ocr/ocr_mvp3/asp/js/ocr.js"></script>
</body>
</html>
