 <style>
    /* =========================================================
   사이드바 스타일 보강 (기존 구조 유지)
   ========================================================= */

/* ---------- 사이드바 기본 ---------- */
.mp-sidebar {
    background: #f4f6f9;
    color: var(--text-main);
}

/* ---------- 로고 영역 ---------- */
.mp-logo {
    height: 60px;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px;
    background: var(--bg-card);
    border-bottom: 1px solid var(--border);
    font-weight: 800;
}

.logo-icon img {
    width: 28px;
    height: 28px;
    object-fit: contain;
}

.logo-text {
    font-size: 16px;
    font-weight: 800;
    color: var(--text-main);
}

/* ---------- 토글 버튼 ---------- */
.mp-toggle {
    background: none;
    border: none;
    font-size: 20px;
    color: var(--primary);
    cursor: pointer;
    padding: 4px;
}

/* ---------- 메뉴 영역 ---------- */
.mp-menu {
    padding: 10px 0;
}

/* 섹션 타이틀 */
.menu-section {
    font-size: 11px;
    font-weight: 700;
    color: var(--text-soft);
    padding: 14px 20px 6px;
    text-transform: uppercase;
}

/* ---------- 메뉴 아이템 ---------- */
.menu-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 10px 16px;
    margin: 4px 12px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    color: var(--text-main);
    text-decoration: none;
    cursor: pointer;
    transition: background .15s ease, color .15s ease;
}

.menu-item i {
    font-size: 16px;
    width: 20px;
    text-align: center;
    color: var(--text-soft);
}

/* Hover */
.menu-item:hover {
    background: #e7f1ff;
    color: var(--primary);
}

.menu-item:hover i {
    color: var(--primary);
}

/* Active */
.menu-item.active {
    background: #e7f1ff;
    color: var(--primary);
    font-weight: 700;
}

.menu-item.active i {
    color: var(--primary);
}

/* ---------- 접힘 상태 보강 ---------- */
.mp-sidebar.collapsed .menu-item {
    justify-content: center;
    padding: 12px 0;
}

.mp-sidebar.collapsed .menu-item i {
    margin: 0;
}

.mp-sidebar.collapsed .mp-logo {
    justify-content: center;
    padding: 0;
}
 </style>   
    <!-- ================= Sidebar ================= -->
    <aside class="mp-sidebar" id="mpSidebar">

        <!-- Logo -->
        <div class="mp-logo">
            <button class="mp-toggle" onclick="toggleSidebar()">☰</button>

            <span class="logo-icon">
                <img 
                    src="https://static.wixstatic.com/media/76309f_8e7375b143214fe6aacc29b2d266d396~mv2.png"
                    alt="태광 로고"
                >
            </span>

            <span class="logo-text">태광도어</span>
        </div>

        <!-- Menu -->
        <nav class="mp-menu">

            <div class="menu-section">ROLE</div>

            <a class="menu-item active">
                <i class="bi bi-speedometer2"></i>
                <span>스팟</span>
            </a>

            <a class="menu-item">
                <i class="bi bi-grid"></i>
                <span>App</span>
            </a>

            <a class="menu-item">
                <i class="bi bi-envelope"></i>
                <span>Mailbox</span>
            </a>

            <a class="menu-item">
                <i class="bi bi-layout-text-window"></i>
                <span>UI Elements</span>
            </a>

        </nav>

    </aside>