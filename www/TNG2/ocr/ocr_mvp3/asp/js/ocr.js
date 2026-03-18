/**
 * OCR 검측 입력 JS
 * - 행(line) 단위 입력
 * - 클릭 → 가로 → 세로, 수량은 직접입력
 */
(function() {
    // ========================================
    // 상태
    // ========================================
    var state = {
        data: null,
        lines: [],
        currentLineIndex: 0,
        currentFieldIndex: 0,  // 0=가로, 1=세로 (수량은 직접입력)
        fields: ['width', 'height'],
        results: [],
        imageScale: { x: 1, y: 1 },
        zoomLevel: 1,
        zoomDrag: { active: false, startY: 0, startZoom: 1 },
        resultSeq: 0  // DB 순번용
    };

    // ========================================
    // 초기화
    // ========================================
    function init() {
        loadOCRData();
    }

    function loadOCRData() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', CONFIG.jsonPath, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    state.data = JSON.parse(xhr.responseText);
                    state.lines = groupByLines(state.data.boxes);
                    waitForImage(function() {
                        autoFitZoom();
                        render();
                        bindEvents();
                    });
                } else {
                    alert('OCR 데이터 로드 실패');
                }
            }
        };
        xhr.send();
    }

    // ========================================
    // 박스를 라인별로 그룹화
    // ========================================
    function groupByLines(boxes) {
        if (!boxes || boxes.length === 0) return [];

        var sorted = boxes.slice().sort(function(a, b) {
            return a.y - b.y;
        });

        var lines = [];
        var currentLine = [];
        var lastY = -9999;
        var threshold = 40;

        for (var i = 0; i < sorted.length; i++) {
            var box = sorted[i];

            if (box.y - lastY > threshold && currentLine.length > 0) {
                currentLine.sort(function(a, b) { return a.x - b.x; });
                lines.push({
                    id: lines.length + 1,
                    tokens: currentLine,
                    minY: currentLine[0].y,
                    maxY: Math.max.apply(null, currentLine.map(function(t) { return t.y + t.h; }))
                });
                currentLine = [];
            }

            currentLine.push(box);
            lastY = box.y;
        }

        if (currentLine.length > 0) {
            currentLine.sort(function(a, b) { return a.x - b.x; });
            lines.push({
                id: lines.length + 1,
                tokens: currentLine,
                minY: currentLine[0].y,
                maxY: Math.max.apply(null, currentLine.map(function(t) { return t.y + t.h; }))
            });
        }

        return lines;
    }

    // ========================================
    // 이미지 로드 대기
    // ========================================
    function waitForImage(callback) {
        var img = document.getElementById('ocrImage');
        if (img.complete) {
            calculateScale();
            callback();
        } else {
            img.onload = function() {
                calculateScale();
                callback();
            };
        }
    }

    function calculateScale() {
        var img = document.getElementById('ocrImage');
        state.imageScale = {
            x: img.clientWidth / state.data.image.width,
            y: img.clientHeight / state.data.image.height
        };
        console.log('이미지 표시크기:', img.clientWidth, 'x', img.clientHeight);
        console.log('이미지 원본크기:', state.data.image.width, 'x', state.data.image.height);
        console.log('스케일:', state.imageScale.x, state.imageScale.y);
        console.log('라인 수:', state.lines.length);
        for (var li = 0; li < state.lines.length; li++) {
            var texts = [];
            for (var ti = 0; ti < state.lines[li].tokens.length; ti++) {
                texts.push(state.lines[li].tokens[ti].text);
            }
            console.log('Line ' + (li+1) + ' (' + state.lines[li].tokens.length + '개):', texts.join(', '));
        }
    }

    // ========================================
    // 줌 기능
    // ========================================
    function autoFitZoom() {
        var viewer = document.getElementById('ocrViewer');
        var img = document.getElementById('ocrImage');
        var viewerW = viewer.clientWidth - 40;
        var viewerH = viewer.clientHeight - 80;
        var imgW = img.clientWidth;
        var imgH = img.clientHeight;

        if (imgW < viewerW && imgH < viewerH) {
            var scaleW = viewerW / imgW;
            var scaleH = viewerH / imgH;
            var fitScale = Math.min(scaleW, scaleH);
            fitScale = Math.max(1, Math.min(5, fitScale));
            setZoom(fitScale);
        }
    }

    function setZoom(level) {
        level = Math.max(0.3, Math.min(8, level));
        level = Math.round(level * 100) / 100;
        state.zoomLevel = level;
        var wrap = document.getElementById('imageWrap');
        wrap.style.transform = 'scale(' + level + ')';
        document.getElementById('zoomLabel').textContent = Math.round(level * 100) + '%';
    }

    function resetZoom() {
        setZoom(1);
    }

    // ========================================
    // 스플릿바
    // ========================================
    function initSplitBar() {
        var splitBar = document.getElementById('splitBar');
        var viewer = document.getElementById('ocrViewer');
        var panel = document.getElementById('ocrPanel');
        var container = document.getElementById('ocr-container');
        var dragging = false;

        splitBar.addEventListener('mousedown', function(e) {
            e.preventDefault();
            dragging = true;
            splitBar.classList.add('active');
            document.body.classList.add('split-dragging');
        });

        document.addEventListener('mousemove', function(e) {
            if (!dragging) return;
            var containerRect = container.getBoundingClientRect();
            var splitWidth = splitBar.offsetWidth;
            var mouseX = e.clientX - containerRect.left;
            var totalWidth = containerRect.width;

            var viewerWidth = mouseX - splitWidth / 2;
            var panelWidth = totalWidth - mouseX - splitWidth / 2;

            if (viewerWidth < 200 || panelWidth < 280) return;

            viewer.style.flex = 'none';
            viewer.style.width = viewerWidth + 'px';
            panel.style.width = panelWidth + 'px';
        });

        document.addEventListener('mouseup', function() {
            if (dragging) {
                dragging = false;
                splitBar.classList.remove('active');
                document.body.classList.remove('split-dragging');
            }
        });
    }

    // ========================================
    // 숫자 추출
    // ========================================
    function extractNumbers(text) {
        var nums = [];
        var re = /\d{1,4}/g;
        var m;
        while ((m = re.exec(text)) !== null) {
            nums.push(m[0]);
        }
        return nums;
    }

    // ========================================
    // 렌더링
    // ========================================
    function render() {
        renderTokens();
        renderLineHighlight();
        updateLineInfo();
        updateFieldHighlight();
        renderResults();
    }

    function renderTokens() {
        var wrap = document.getElementById('imageWrap');

        var oldTokens = wrap.querySelectorAll('.ocr-token');
        for (var i = 0; i < oldTokens.length; i++) {
            oldTokens[i].remove();
        }

        for (var li = 0; li < state.lines.length; li++) {
            var line = state.lines[li];

            for (var ti = 0; ti < line.tokens.length; ti++) {
                var token = line.tokens[ti];
                var el = document.createElement('div');
                el.className = 'ocr-token';

                el.dataset.lineIndex = li;
                el.dataset.tokenIndex = ti;
                el.dataset.text = token.text;

                el.style.left = (token.x * state.imageScale.x) + 'px';
                el.style.top = (token.y * state.imageScale.y) + 'px';
                el.style.width = (token.w * state.imageScale.x) + 'px';
                el.style.height = (token.h * state.imageScale.y) + 'px';

                el.textContent = token.text;

                wrap.appendChild(el);
            }
        }
    }

    function renderLineHighlight() {
        var highlight = document.getElementById('lineHighlight');
        var line = state.lines[state.currentLineIndex];

        if (!line) {
            highlight.style.display = 'none';
            return;
        }

        highlight.style.display = 'block';
        highlight.style.top = (line.minY * state.imageScale.y - 5) + 'px';
        highlight.style.height = ((line.maxY - line.minY) * state.imageScale.y + 10) + 'px';
    }

    function updateLineInfo() {
        var lineNum = state.currentLineIndex + 1;
        var total = state.lines.length;
        document.getElementById('currentLineNum').textContent = lineNum;
        document.getElementById('totalLines').textContent = total;
        document.getElementById('footerLine').textContent = lineNum;
        document.getElementById('footerTotal').textContent = total;
    }

    function updateFieldHighlight() {
        var fields = ['inputWidth', 'inputHeight'];

        for (var i = 0; i < fields.length; i++) {
            var input = document.getElementById(fields[i]);
            input.classList.remove('active');

            if (input.value) {
                input.classList.add('filled');
            } else {
                input.classList.remove('filled');
            }
        }

        // 수량은 별도 처리 (직접입력 필드)
        var qtyInput = document.getElementById('inputQty');
        qtyInput.classList.remove('active');
        if (qtyInput.value) {
            qtyInput.classList.add('filled');
        } else {
            qtyInput.classList.remove('filled');
        }

        // 가로/세로 중 현재 활성 필드
        if (state.currentFieldIndex < fields.length) {
            var currentInput = document.getElementById(fields[state.currentFieldIndex]);
            if (currentInput) {
                currentInput.classList.add('active');
            }
        }
    }

    function renderResults() {
        var tbody = document.getElementById('resultBody');
        var html = '';

        for (var i = 0; i < state.results.length; i++) {
            var r = state.results[i];
            html += '<tr>';
            html += '<td class="col-no">' + r.seq + '</td>';
            html += '<td>' + r.width + '</td>';
            html += '<td>' + r.height + '</td>';
            html += '<td>' + r.qty + '</td>';
            html += '<td class="col-del"><button class="delete-btn" data-index="' + i + '">✕</button></td>';
            html += '</tr>';
        }

        tbody.innerHTML = html;
        document.getElementById('doneCount').textContent = state.results.length;

        // 삭제 버튼
        var deleteBtns = tbody.querySelectorAll('.delete-btn');
        for (var j = 0; j < deleteBtns.length; j++) {
            deleteBtns[j].addEventListener('click', function(e) {
                var idx = parseInt(e.target.dataset.index);
                state.results.splice(idx, 1);
                renderResults();
            });
        }

        // 자동 스크롤 (최신 결과 보이게)
        var wrap = document.getElementById('resultTableWrap');
        wrap.scrollTop = wrap.scrollHeight;
    }

    // ========================================
    // 이벤트
    // ========================================
    function bindEvents() {
        // 토큰 클릭
        document.getElementById('imageWrap').addEventListener('click', function(e) {
            if (e.target.classList.contains('ocr-token')) {
                if (!e.target.classList.contains('inactive')) {
                    onTokenClick(e.target);
                }
            }
        });

        // 버튼
        document.getElementById('btnConfirm').addEventListener('click', onConfirm);
        document.getElementById('btnSkip').addEventListener('click', onSkip);
        document.getElementById('btnClear').addEventListener('click', onClear);

        // 키보드
        document.addEventListener('keydown', function(e) {
            // 수량 입력 중이면 Enter만 처리
            if (document.activeElement === document.getElementById('inputQty')) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    onConfirm();
                } else if (e.key === 'Escape') {
                    e.preventDefault();
                    document.getElementById('inputQty').blur();
                    onClear();
                }
                return;
            }

            if (e.key === 'Enter') {
                onConfirm();
            } else if (e.key === 'Escape') {
                onClear();
            } else if (e.key === 'Tab') {
                e.preventDefault();
                onSkip();
            }
        });

        // 줌: 마우스 휠
        var viewer = document.getElementById('ocrViewer');
        viewer.addEventListener('wheel', function(e) {
            e.preventDefault();
            var delta = e.deltaY > 0 ? -0.15 : 0.15;
            setZoom(state.zoomLevel + delta);
        }, { passive: false });

        // 줌: 우클릭 드래그
        viewer.addEventListener('mousedown', function(e) {
            if (e.button === 2) {
                e.preventDefault();
                state.zoomDrag.active = true;
                state.zoomDrag.startY = e.clientY;
                state.zoomDrag.startZoom = state.zoomLevel;
                document.body.style.cursor = 'ns-resize';
            }
        });

        viewer.addEventListener('contextmenu', function(e) {
            e.preventDefault();
        });

        document.addEventListener('mousemove', function(e) {
            if (!state.zoomDrag.active) return;
            var diffY = state.zoomDrag.startY - e.clientY;
            var newZoom = state.zoomDrag.startZoom + (diffY * 0.005);
            setZoom(newZoom);
        });

        document.addEventListener('mouseup', function(e) {
            if (state.zoomDrag.active) {
                state.zoomDrag.active = false;
                document.body.style.cursor = '';
            }
        });

        // 줌 버튼
        document.getElementById('btnZoomIn').addEventListener('click', function() {
            setZoom(state.zoomLevel + 0.25);
        });
        document.getElementById('btnZoomOut').addEventListener('click', function() {
            setZoom(state.zoomLevel - 0.25);
        });
        document.getElementById('btnZoomFit').addEventListener('click', function() {
            autoFitZoom();
        });
        document.getElementById('btnZoomReset').addEventListener('click', resetZoom);

        // 스플릿바
        initSplitBar();
    }

    function onTokenClick(el) {
        var text = el.dataset.text;
        var nums = extractNumbers(text);

        // 가로/세로만 토큰 클릭으로 입력 (수량은 직접입력)
        var fieldIds = ['inputWidth', 'inputHeight'];

        if (state.currentFieldIndex >= fieldIds.length) {
            // 가로/세로 다 채워진 상태면 가로부터 다시
            state.currentFieldIndex = 0;
        }

        var input = document.getElementById(fieldIds[state.currentFieldIndex]);

        if (state.currentFieldIndex === 0) {
            input.value = nums.length > 0 ? nums[0] : text;
        } else if (state.currentFieldIndex === 1) {
            input.value = nums.length > 1 ? nums[1] : (nums.length > 0 ? nums[0] : text);
        }

        console.log('필드:', state.currentFieldIndex, '추출숫자들:', nums, '입력값:', input.value);

        el.classList.add('selected');

        // 다음 필드로 (가로→세로만)
        state.currentFieldIndex++;
        if (state.currentFieldIndex >= fieldIds.length) {
            // 가로/세로 완료 → 수량 입력으로 포커스
            document.getElementById('inputQty').focus();
        }

        updateFieldHighlight();
    }

    function onConfirm() {
        var w = document.getElementById('inputWidth').value.trim();
        var h = document.getElementById('inputHeight').value.trim();
        var q = document.getElementById('inputQty').value.trim();

        if (!w && !h && !q) {
            alert('최소 1개 이상 값을 입력하세요');
            return;
        }

        state.resultSeq++;

        // DB 연동 대비 데이터 구조
        var now = new Date();
        var record = {
            seq: state.resultSeq,
            line: state.currentLineIndex + 1,
            width: w || '-',
            height: h || '-',
            qty: q || '-',
            source_file: CONFIG.sourceFile || '',
            created_at: now.toISOString(),
            created_date: now.getFullYear() + '-' +
                String(now.getMonth() + 1).padStart(2, '0') + '-' +
                String(now.getDate()).padStart(2, '0'),
            status: 'confirmed'
        };

        state.results.push(record);
        console.log('확정:', JSON.stringify(record));

        nextLine();
    }

    function onSkip() {
        nextLine();
    }

    function onClear() {
        document.getElementById('inputWidth').value = '';
        document.getElementById('inputHeight').value = '';
        document.getElementById('inputQty').value = '';
        state.currentFieldIndex = 0;
        updateFieldHighlight();

        var selected = document.querySelectorAll('.ocr-token.selected');
        for (var i = 0; i < selected.length; i++) {
            selected[i].classList.remove('selected');
        }
    }

    function nextLine() {
        document.getElementById('inputWidth').value = '';
        document.getElementById('inputHeight').value = '';
        document.getElementById('inputQty').value = '';
        state.currentFieldIndex = 0;

        state.currentLineIndex++;

        if (state.currentLineIndex >= state.lines.length) {
            alert('모든 라인 입력 완료!\n총 ' + state.results.length + '개 품목');
            console.log('=== OCR 최종 결과 (DB 전송용) ===');
            console.log(JSON.stringify(state.results, null, 2));
            return;
        }

        render();
    }

    // ========================================
    // 시작
    // ========================================
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
