/**
 * picker.js — 페인트 피커 팝업 v1.0
 * 기능: 텍스트검색, 초성검색, 색상그룹, 비슷한색, 페이지네이션
 */
(function() {
    'use strict';
    console.log('[PaintPicker] v1.0 init');

    var API = '/paint_color/picker_api.asp';
    var state = {
        mode: 'search',      // search | color_group | similar
        q: '',
        page: 1,
        brand: 0,
        coat: -1,
        group: '',
        similarHex: '',
        data: [],
        total: 0,
        pages: 1
    };

    // === 초성 감지 ===
    var CHOSUNG_RE = /^[\u3131-\u314E]+$/;
    function isChosung(s) { return CHOSUNG_RE.test(s); }

    // === DOM 참조 ===
    var elSearch = document.getElementById('pkSearch');
    var elBadge = document.getElementById('pkBadgeChosung');
    var elBrand = document.getElementById('pkBrand');
    var elCoat = document.getElementById('pkCoat');
    var elColorPicker = document.getElementById('pkColorPicker');
    var elHexInput = document.getElementById('pkHexInput');
    var elResultInfo = document.getElementById('pkResultInfo');
    var elResultList = document.getElementById('pkResultList');
    var elPager = document.getElementById('pkPager');

    // === 코트 라벨 (레거시 동일) ===
    var COAT_LABELS = ['❌', '기본(2코트)', '필수(3코트)'];
    var COAT_MAP = {0: '❌', 1: '기본(2코트)', 2: '필수(3코트)'};
    var brandCoatsMap = {}; // {pbidx: [0,1,2], ...}

    // === API 호출 ===
    function fetchAPI(params, cb) {
        var qs = [];
        for (var k in params) {
            if (params[k] !== '' && params[k] !== null && params[k] !== undefined) {
                qs.push(encodeURIComponent(k) + '=' + encodeURIComponent(params[k]));
            }
        }
        var url = API + '?' + qs.join('&');
        console.log('[PaintPicker] fetch:', url);

        var xhr = new XMLHttpRequest();
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var json = JSON.parse(xhr.responseText);
                        cb(null, json);
                    } catch(e) {
                        console.error('[PaintPicker] JSON parse error:', e, xhr.responseText.substring(0, 200));
                        cb(e, null);
                    }
                } else {
                    cb(new Error('HTTP ' + xhr.status), null);
                }
            }
        };
        xhr.send();
    }

    // === 브랜드 로드 ===
    function loadBrands() {
        fetchAPI({ mode: 'brands' }, function(err, res) {
            if (err || !res || !res.ok) return;
            var html = '<option value="0">전체 브랜드</option>';
            res.data.forEach(function(b) {
                html += '<option value="' + b.pbidx + '">' + escHtml(b.name) + '</option>';
                brandCoatsMap[b.pbidx] = b.coats || [];
            });
            elBrand.innerHTML = html;
            console.log('[PaintPicker] brands loaded:', res.data.length, 'coatsMap:', brandCoatsMap);
        });
    }

    // === 브랜드 변경 시 코트 드롭다운 필터링 ===
    function updateCoatOptions() {
        var brandId = parseInt(elBrand.value) || 0;
        var prevCoat = elCoat.value;
        var html = '<option value="-1">전체</option>';

        if (brandId > 0 && brandCoatsMap[brandId]) {
            // 해당 브랜드에 존재하는 coat만 표시
            var coats = brandCoatsMap[brandId];
            coats.forEach(function(c) {
                var label = COAT_MAP[c] || ('코트' + c);
                html += '<option value="' + c + '">' + label + '</option>';
            });
            console.log('[PaintPicker] brand', brandId, 'coats:', coats);
        } else {
            // 전체 브랜드 → 전체 코트
            html += '<option value="0">❌</option>';
            html += '<option value="1">기본(2코트)</option>';
            html += '<option value="2">필수(3코트)</option>';
        }

        elCoat.innerHTML = html;
        // 이전 선택값 복원 시도
        if (elCoat.querySelector('option[value="' + prevCoat + '"]')) {
            elCoat.value = prevCoat;
        } else {
            elCoat.value = '-1';
        }
    }

    // === 검색 실행 ===
    function doSearch(page) {
        state.mode = 'search';
        state.page = page || 1;
        state.q = (elSearch.value || '').trim();
        state.brand = parseInt(elBrand.value) || 0;
        state.coat = parseInt(elCoat.value);

        // 초성 뱃지
        if (state.q && isChosung(state.q)) {
            elBadge.className = 'pk-badge-chosung show';
            elBadge.textContent = '초성검색';
        } else {
            elBadge.className = 'pk-badge-chosung';
        }

        clearGroupActive();
        showLoading();

        fetchAPI({
            mode: 'search',
            q: state.q,
            page: state.page,
            size: 50,
            brand: state.brand,
            coat: state.coat
        }, function(err, res) {
            if (err || !res || !res.ok) { showError('검색 실패'); return; }
            state.data = res.data;
            state.total = res.total;
            state.pages = res.pages;
            state.page = res.page;

            var modeText = '검색';
            if (res.chosung) modeText = '초성검색';
            renderResults(modeText);
            renderPager();
        });
    }

    // === 색상그룹 검색 ===
    function doColorGroup(group, page) {
        state.mode = 'color_group';
        state.group = group;
        state.page = page || 1;
        state.brand = parseInt(elBrand.value) || 0;
        state.coat = parseInt(elCoat.value);

        setGroupActive(group);
        showLoading();

        fetchAPI({
            mode: 'color_group',
            group: group,
            page: state.page,
            size: 50,
            brand: state.brand,
            coat: state.coat
        }, function(err, res) {
            if (err || !res || !res.ok) { showError('색상그룹 실패'); return; }
            state.data = res.data;
            state.total = res.total;
            state.pages = res.pages;
            state.page = res.page;
            renderResults('색상그룹: ' + group);
            renderPager();
        });
    }

    // === 비슷한색 검색 ===
    function doSimilar() {
        var hex = elHexInput.value.trim();
        if (!hex.match(/^#?[0-9A-Fa-f]{6}$/)) {
            alert('올바른 HEX 색상을 입력하세요 (예: #FF5500)');
            return;
        }
        if (!hex.startsWith('#')) hex = '#' + hex;
        state.mode = 'similar';
        state.similarHex = hex;

        clearGroupActive();
        showLoading();

        fetchAPI({
            mode: 'similar',
            hex: hex,
            limit: 100
        }, function(err, res) {
            if (err || !res || !res.ok) { showError('비슷한색 실패'); return; }
            state.data = res.data;
            state.total = res.data.length;
            state.pages = 1;
            state.page = 1;
            renderResults('비슷한색: ' + hex);
            renderPager();
        });
    }

    // === 결과 렌더링 ===
    function renderResults(modeLabel) {
        // 상단 정보
        elResultInfo.innerHTML = '<span class="pk-result-count">' + state.total + '건</span>' +
            (state.pages > 1 ? ' (' + state.page + '/' + state.pages + ' 페이지)' : '') +
            ' <span class="pk-mode-badge">' + escHtml(modeLabel) + '</span>';

        // 행 렌더
        if (state.data.length === 0) {
            elResultList.innerHTML = '<div class="pk-loading">검색 결과가 없습니다</div>';
            return;
        }

        var html = '';
        state.data.forEach(function(item) {
            var hexStyle = item.hex ? 'background:' + escHtml(item.hex) : '';
            var swatchClass = item.hex ? 'pk-swatch' : 'pk-swatch no-color';
            var coatLabel = COAT_MAP[item.coat] || '-';
            var coatClass = 'pk-coat-badge pk-coat-' + (item.coat || 0);

            html += '<div class="pk-row" data-pidx="' + item.pidx + '" data-pcode="' + escAttr(item.pcode || '') + '" data-pname="' + escAttr(item.pname) + '" data-coat="' + (item.coat || 0) + '">';
            html += '<div class="' + swatchClass + '" style="' + hexStyle + '"></div>';
            html += '<span class="pk-row-code">' + escHtml(item.pcode || '') + '</span>';
            html += '<span class="pk-row-name">' + escHtml(item.pname || '') + '</span>';
            html += '<span class="pk-row-brand">' + escHtml(item.brand || '') + '</span>';
            html += '<span class="' + coatClass + '">' + coatLabel + '</span>';
            if (item.dist !== undefined) {
                html += '<span class="pk-dist-badge">d=' + Math.round(Math.sqrt(item.dist)) + '</span>';
            }
            html += '<button class="pk-row-pick" onclick="event.stopPropagation()">선택</button>';
            html += '</div>';
        });
        elResultList.innerHTML = html;

        // 행 클릭 이벤트
        var rows = elResultList.querySelectorAll('.pk-row');
        for (var i = 0; i < rows.length; i++) {
            rows[i].addEventListener('click', onRowClick);
            rows[i].querySelector('.pk-row-pick').addEventListener('click', onRowClick);
        }
    }

    // === 행 클릭 → 콜백 ===
    function onRowClick(e) {
        var row = e.target.closest('.pk-row');
        if (!row) return;
        var pidx = row.getAttribute('data-pidx');
        var pname = row.getAttribute('data-pname');
        var coat = row.getAttribute('data-coat');
        console.log('[PaintPicker] pick:', pidx, pname, coat);

        if (window.opener && typeof window.opener.setPaint === 'function') {
            window.opener.setPaint(pidx, pname, coat);
            window.close();
        } else {
            alert('호출 창이 없습니다. pidx=' + pidx + ', pname=' + pname);
        }
    }

    // === 페이지네이션 ===
    function renderPager() {
        if (state.pages <= 1) { elPager.innerHTML = ''; return; }

        var html = '';
        html += '<button ' + (state.page <= 1 ? 'disabled' : '') + ' data-page="' + (state.page - 1) + '">&laquo; 이전</button>';

        var start = Math.max(1, state.page - 3);
        var end = Math.min(state.pages, state.page + 3);
        if (start > 1) html += '<button data-page="1">1</button><button disabled>...</button>';

        for (var p = start; p <= end; p++) {
            html += '<button data-page="' + p + '"' + (p === state.page ? ' class="active"' : '') + '>' + p + '</button>';
        }
        if (end < state.pages) html += '<button disabled>...</button><button data-page="' + state.pages + '">' + state.pages + '</button>';

        html += '<button ' + (state.page >= state.pages ? 'disabled' : '') + ' data-page="' + (state.page + 1) + '">다음 &raquo;</button>';
        elPager.innerHTML = html;

        // 페이저 클릭
        var btns = elPager.querySelectorAll('button[data-page]');
        for (var i = 0; i < btns.length; i++) {
            btns[i].addEventListener('click', function() {
                var pg = parseInt(this.getAttribute('data-page'));
                if (isNaN(pg) || pg < 1) return;
                if (state.mode === 'search') doSearch(pg);
                else if (state.mode === 'color_group') doColorGroup(state.group, pg);
            });
        }
    }

    // === 색상그룹 버튼 활성 ===
    function setGroupActive(group) {
        var btns = document.querySelectorAll('.pk-cg-btn');
        for (var i = 0; i < btns.length; i++) {
            btns[i].classList.toggle('active', btns[i].getAttribute('data-group') === group);
        }
    }
    function clearGroupActive() {
        var btns = document.querySelectorAll('.pk-cg-btn');
        for (var i = 0; i < btns.length; i++) btns[i].classList.remove('active');
    }

    // === 유틸 ===
    function escHtml(s) { var d = document.createElement('div'); d.textContent = s; return d.innerHTML; }
    function escAttr(s) { return (s || '').replace(/"/g, '&quot;').replace(/'/g, '&#39;'); }
    function showLoading() { elResultList.innerHTML = '<div class="pk-loading">검색중...</div>'; elPager.innerHTML = ''; }
    function showError(msg) { elResultList.innerHTML = '<div class="pk-loading" style="color:#E53935">' + escHtml(msg) + '</div>'; }

    // === 디바운스 ===
    var searchTimer = null;
    function debounceSearch() {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(function() { doSearch(1); }, 300);
    }

    // === 이벤트 바인딩 ===
    elSearch.addEventListener('input', debounceSearch);
    elSearch.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') { clearTimeout(searchTimer); doSearch(1); }
    });
    elBrand.addEventListener('change', function() { updateCoatOptions(); doSearch(1); });
    elCoat.addEventListener('change', function() { doSearch(1); });

    // 색상그룹 버튼
    var cgBtns = document.querySelectorAll('.pk-cg-btn');
    for (var i = 0; i < cgBtns.length; i++) {
        cgBtns[i].addEventListener('click', function() {
            var g = this.getAttribute('data-group');
            if (this.classList.contains('active')) {
                // 토글 off → 전체 검색
                clearGroupActive();
                doSearch(1);
            } else {
                doColorGroup(g, 1);
            }
        });
    }

    // 컬러피커 ↔ hex 입력 동기화
    elColorPicker.addEventListener('input', function() {
        elHexInput.value = this.value.toUpperCase();
    });
    elHexInput.addEventListener('input', function() {
        var v = this.value.trim();
        if (v.match(/^#?[0-9A-Fa-f]{6}$/)) {
            elColorPicker.value = v.startsWith('#') ? v : '#' + v;
        }
    });

    // 비슷한색 검색
    document.getElementById('pkBtnSimilar').addEventListener('click', doSimilar);

    // 리셋
    document.getElementById('pkBtnReset').addEventListener('click', function() {
        elSearch.value = '';
        elBrand.value = '0';
        elCoat.value = '-1';
        elHexInput.value = '#000000';
        elColorPicker.value = '#000000';
        elBadge.className = 'pk-badge-chosung';
        clearGroupActive();
        doSearch(1);
    });

    // 닫기
    document.getElementById('pkClose').addEventListener('click', function() { window.close(); });

    // === 초기 로드 ===
    loadBrands();
    doSearch(1);

    console.log('[PaintPicker] ready');
})();
