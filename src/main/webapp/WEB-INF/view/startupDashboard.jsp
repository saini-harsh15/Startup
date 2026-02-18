<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Startup Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap"
          rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --accent: #28a745;
            --accent-soft: rgba(40, 167, 69, .12);
            --bg: #f3f6f9;
            --card: #ffffff;
            --text: #0f172a;
            --muted: #64748b;
            --border: 1px solid rgba(15, 23, 42, .06);
            --shadow-sm: 0 6px 14px rgba(0, 0, 0, .06);
            --shadow-md: 0 22px 40px rgba(0, 0, 0, .10);
            --warning-soft: rgba(255, 193, 7, 0.15);
            --warning-text: #856404;
        }

        .dark-mode {
            --bg: #0b1220;
            --card: #111827;
            --text: #e5e7eb;
            --muted: #9ca3af;
            --border: 1px solid rgba(255, 255, 255, .08);
            --warning-soft: rgba(255, 193, 7, 0.1);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            color: var(--text);
            padding-top: 90px;
            scroll-behavior: smooth;
        }

        /* ================= NAVBAR ================= */
        .navbar {
            position: fixed;
            top: 14px;
            left: 14px;
            right: 14px;
            height: 68px;
            padding: 0 26px;
            background: rgba(255, 255, 255, .85);
            backdrop-filter: blur(14px);
            border: var(--border);
            border-radius: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000;
        }

        .dark-mode .navbar {
            background: rgba(17, 24, 39, .9)
        }

        .nav-left {
            display: flex;
            align-items: center;
            gap: 16px
        }

        .logo {
            font-weight: 800;
            font-size: 1.35rem;
            color: var(--accent)
        }

        .logo span {
            color: var(--text)
        }

        .hamburger {
            font-size: 1.2rem;
            cursor: pointer;
            color: var(--muted)
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 18px
        }

        .theme-toggle {
            background: none;
            border: none;
            font-size: 1.1rem;
            cursor: pointer;
            color: var(--muted);
            transition: transform .2s ease, color .2s ease, filter .2s ease;
            border-radius: 10px
        }

        .theme-toggle:hover {
            transform: translateY(-1px) scale(1.06);
            color: var(--accent);
            filter: drop-shadow(0 2px 6px rgba(40, 167, 69, .25))
        }

        .theme-toggle:active {
            transform: scale(0.92)
        }

        .theme-toggle i {
            transition: transform .25s ease
        }

        .theme-toggle:hover i {
            transform: rotate(-15deg) scale(1.08)
        }

        @keyframes pulsePop {
            0% {
                transform: scale(1)
            }
            40% {
                transform: scale(1.25)
            }
            100% {
                transform: scale(1)
            }
        }

        .icon-pulse {
            animation: pulsePop .35s ease
        }

        .profile-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--accent), #34d058);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            cursor: pointer;
        }

        /* ================= DROPDOWN ================= */
        .dropdown {
            position: relative
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 56px;
            min-width: 180px;
            background: var(--card);
            border: var(--border);
            border-radius: 14px;
            box-shadow: var(--shadow-md);
        }

        .dropdown-content.show {
            display: block
        }

        .dropdown-content a {
            display: block;
            padding: 14px 16px;
            color: var(--text);
            text-decoration: none;
            font-weight: 500;
        }

        .dropdown-content a:hover {
            background: var(--accent-soft);
            color: var(--accent);
        }

        /* ================= SIDEBAR ================= */
        .sidebar {
            position: fixed;
            top: 14px;
            left: 14px;
            height: calc(100% - 28px);
            width: 0;
            overflow: hidden;
            transition: .35s ease;
            z-index: 1100;
        }

        .sidebar.open {
            width: 300px
        }

        .sidebar .panel {
            width: 300px;
            height: 100%;
            padding: 26px 22px;
            background: linear-gradient(180deg, var(--card), rgba(255, 255, 255, .96));
            border: var(--border);
            border-radius: 18px;
            box-shadow: 12px 0 35px rgba(0, 0, 0, .12);
            position: relative;
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.45rem;
            font-weight: 800;
            color: var(--accent);
            margin-bottom: 28px;
        }

        .sidebar-logo i {
            background: var(--accent);
            color: white;
            width: 38px;
            height: 38px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sidebar-logo span {
            color: var(--text)
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 16px;
            margin-bottom: 8px;
            border-radius: 14px;
            text-decoration: none;
            color: var(--text);
            font-weight: 500;
            transition: .25s ease;
        }

        .sidebar a:hover {
            background: var(--accent-soft);
            color: var(--accent);
            padding-left: 22px;
        }

        .sidebar-footer {
            position: absolute;
            bottom: 22px;
            left: 22px;
            right: 22px;
            text-align: center;
            font-size: .8rem;
            color: var(--muted);
        }

        .overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, .35);
            z-index: 1000;
        }

        .overlay.show {
            display: block
        }

        /* ================= PAGE ================= */
        .page-wrap {
            max-width: 1400px;
            margin: auto;
            padding: 24px
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 32px;
        }

        .industry-tag {
            background: var(--accent-soft);
            color: var(--accent);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: .75rem;
            font-weight: 700;
        }

        /* ================= CONTROLS ================= */
        .controls-bar {
            background: var(--card);
            border: var(--border);
            border-radius: 18px;
            padding: 18px 24px;
            display: flex;
            gap: 14px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 40px;
        }

        .btn-primary {
            background: var(--accent);
            color: white;
            border: none;
            padding: 11px 22px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: opacity .2s;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        .btn-outline {
            background: transparent;
            border: 2px solid var(--accent);
            color: var(--accent);
            padding: 9px 20px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: .2s;
        }

        .btn-outline:hover {
            background: var(--accent-soft);
        }

        /* ================= SUMMARY ================= */
        .summary-grid {
            display: grid;
            grid-template-columns:repeat(auto-fit, minmax(240px, 1fr));
            gap: 26px;
            margin-bottom: 50px;
        }

        .summary-card {
            background: var(--card);
            border: var(--border);
            border-radius: 22px;
            padding: 28px;
            box-shadow: var(--shadow-sm);
            transition: .3s ease;
            text-decoration: none;
            color: inherit;
            cursor: pointer;
            display: block;
        }

        .summary-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-md);
            border-color: var(--accent);
        }

        .summary-card span {
            color: var(--muted);
            font-size: .85rem
        }

        .summary-card h2 {
            color: var(--accent);
            margin-top: 8px;
            font-size: 2rem
        }

        /* ================= INVESTMENT REQUESTS ================= */
        .investment-section {
            margin-bottom: 50px;
        }

        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .request-card {
            background: var(--card);
            border: var(--border);
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
            transition: .3s ease;
        }

        .request-card:hover {
            box-shadow: var(--shadow-md);
            border-color: var(--accent);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .investor-info h4 {
            font-size: 1.1rem;
            font-weight: 700;
        }

        .status-badge {
            background: var(--warning-soft);
            color: var(--warning-text);
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .request-details {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
        }

        .detail-item span:first-child {
            color: var(--muted);
        }

        .request-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        /* Refined Subtle Empty State Styling */
        .empty-state {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 0;
            color: var(--muted);
            font-size: 0.85rem;
            font-weight: 400;
        }

        .empty-state i {
            font-size: 0.9rem;
            opacity: 0.6;
        }

        /* ================= PROFILE ================= */
        .profile-section {
            background: var(--card);
            border: var(--border);
            border-radius: 22px;
            padding: 28px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 50px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        /* ================= NEWS ================= */
        .news-header {
            font-size: 1.5rem;
            margin-bottom: 20px;
            border-left: 5px solid var(--accent);
            padding-left: 14px;
        }

        .news-grid {
            display: grid;
            grid-template-columns:repeat(auto-fit, minmax(280px, 1fr));
            gap: 22px;
        }

        .news-card {
            background: var(--card);
            border: var(--border);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: .3s ease;
        }

        .news-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-md);
            border-color: var(--accent);
        }

        .news-img {
            width: 100%;
            height: 160px;
            object-fit: cover
        }

        .news-content {
            padding: 16px
        }

        .news-title {
            font-size: .95rem;
            font-weight: 600
        }

        @media (max-width: 768px) {
            .header-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 14px
            }

            .summary-grid, .news-grid, .request-grid {
                grid-template-columns:1fr
            }

            .controls-bar {
                flex-direction: column
            }

            .request-actions {
                grid-template-columns:1fr
            }
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.18);
            color: #856404;
            border: 1px solid rgba(255, 193, 7, 0.4);
        }

        .status-accepted {
            background: rgba(40, 167, 69, 0.18);
            color: #155724;
            border: 1px solid rgba(40, 167, 69, 0.4);
        }

        .status-rejected {
            background: rgba(220, 53, 69, 0.18);
            color: #721c24;
            border: 1px solid rgba(220, 53, 69, 0.4);
        }

        /* ===== USER IDENTITY CHIP ===== */
        .user-chip{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding:4px 10px 4px 8px;
            border-radius:999px;
            background:rgba(15,23,42,.05);
            border:var(--border);
            height:38px;
        }

        .dark-mode .user-chip{
            background:rgba(255,255,255,.06);
        }

        .user-chip:hover{
            background:var(--accent-soft);
        }

        .welcome-text{
            font-size:.88rem;
            color:var(--muted);
            font-weight:450;
            white-space:nowrap;
        }

        .welcome-text strong{
            color:var(--text);
            font-weight:600;
        }

        /* theme icon inside chip */
        .user-chip .theme-toggle{
            font-size:1rem;
            padding:6px;
        }

        /* mobile cleanup */
        @media(max-width:768px){
            .welcome-text{display:none}
            .user-chip{padding:6px 10px}
        }

        /* ================= INTERACTION SYSTEM ================= */

        /* clickable elements */
        button,
        .btn-save,
        .sidebar a,
        .dropdown-content a,
        .profile-icon,
        .user-chip,
        .theme-toggle{
            transition:
                    transform .18s ease,
                    box-shadow .18s ease,
                    background-color .18s ease,
                    color .18s ease,
                    border-color .18s ease;
        }

        /* lift effect */
        button:hover,
        .btn-save:hover,
        .profile-icon:hover{
            transform: translateY(-2px);
            box-shadow: 0 10px 22px rgba(0,0,0,.12);
        }

        /* press effect */
        button:active,
        .profile-icon:active{
            transform: translateY(0px) scale(.97);
            box-shadow: 0 4px 10px rgba(0,0,0,.08);
        }

        /* sidebar links feel clickable */
        .sidebar a:hover{
            transform: translateX(6px);
        }

        /* dropdown items feel selectable */
        .dropdown-content a:hover{
            padding-left: 20px;
        }

        /* theme toggle nicer */
        .theme-toggle:hover{
            transform: rotate(-12deg) scale(1.15);
        }

        /* primary save button emphasis */
        .btn-save:hover{
            filter: brightness(1.05);
        }

        /* dark mode adjustments */
        .dark-mode button:hover,
        .dark-mode .btn-save:hover,
        .dark-mode .profile-icon:hover{
            box-shadow: 0 12px 26px rgba(0,0,0,.45);
        }



    </style>
</head>

<body>

<div id="mySidebar" class="sidebar">
    <div class="panel">
        <div class="sidebar-logo">
            <i class="fas fa-leaf"></i> ECO<span>TRACK</span>
        </div>
        <a href="/startup/dashboard"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="/startup/profile"><i class="fas fa-user"></i> My Profile</a>
        <a href="/startup/messages"><i class="fas fa-comment-dots"></i> Messages</a>
        <a href="/contact"><i class="fas fa-headset"></i> Support</a>
        <div class="sidebar-footer"> © <span id="yearSpan"></span> EcoTrack</div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeNav()"></div>

<header class="navbar">
    <div class="nav-left">
        <i class="fas fa-bars hamburger" onclick="openNav()"></i>
        <div class="logo">ECO<span>TRACK</span></div>
    </div>
    <div class="nav-right">

        <div class="user-chip">

            <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn">
                <i class="fas fa-moon"></i>
            </button>

            <div class="welcome-text">
                Welcome, <strong>${startup.name}</strong>
            </div>

        </div>

        <div class="dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()">S</div>

            <div id="myDropdown" class="dropdown-content">
                <a href="/startup/profile">Profile</a>
                <a href="/logout" class="logout-link">Logout</a>
            </div>
        </div>

    </div>

</header>

<div class="page-wrap">
    <div class="header-section">
        <div>
            <p style="color:var(--muted)">Welcome back,</p>
            <h1>${startup.name}</h1>
        </div>
        <span class="industry-tag">${startup.industry}</span>
    </div>

    <div class="controls-bar">
        <a href="${pageContext.request.contextPath}/ml" target="_blank" class="btn-primary">
            <i class="fas fa-rocket" style="margin-right:8px"></i> Launch Pitch Analyzer
        </a>
    </div>

    <div class="summary-grid">
        <a href="/startup/messages" class="summary-card">
            <span>Investor Messages</span>
            <h2>0</h2>
        </a>
        <div class="summary-card">
            <span>Profile Views</span>
            <h2 id="profileViewsCount">${profileViews}</h2>
        </div>
        <div class="summary-card" onclick="window.location.href='/startup/investments'">
            <span>Pending Investment Requests</span>
            <h2>${pendingRequestCount}</h2>
        </div>
        <div class="summary-card">
            <span>Total Investment</span>
            <h2>${totalInvestment != null ? totalInvestment : 0}</h2>
        </div>
    </div>

    <div class="investment-section" id="investment-workflow">
        <h3 class="news-header">Investment Requests</h3>

        <c:choose>
            <c:when test="${not empty pendingRequests}">
            <div class="request-grid">
                <c:forEach var="req" items="${pendingRequests}">
                            <div class="request-card">
                                <div class="request-header">
                                    <div class="investor-info">
                                        <h4>${req.investor.investorName}</h4>
                                        <p style="font-size:0.8rem; color:var(--muted)">Received via EcoTrack</p>
                                    </div>
                                    <span class="status-badge
    ${req.status == 'PENDING' ? 'status-pending' :
      req.status == 'ACCEPTED' ? 'status-accepted' :
      'status-rejected'}">
                                            ${req.status}
                                    </span>

                                </div>
                                <div class="request-details">
                                    <div class="detail-item"><span>Amount:</span><span
                                            style="font-weight:600; color:var(--accent)">$${req.amount}</span></div>
                                    <div class="detail-item"><span>Funding Stage:</span><span>${req.fundingStage}</span>
                                    </div>
                                </div>
                                <div class="request-actions">
                                    <a href="/startup/chat?investorId=${req.investor.id}" class="btn-outline">
                                        <i class="fas fa-comment" style="margin-right:8px"></i> Chat</a>
                                    <a href="/startup/investment-requests/${req.id}" class="btn-primary">Review</a>
                                </div>
                            </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-circle-info"></i>
                    No investment requests yet.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="profile-section">
        <div class="section-header">
            <h2>Startup Overview</h2>
            <a href="/startup/profile" class="btn-primary" style="font-size:.85rem"><i class="fas fa-pen"
                                                                                       style="margin-right:6px"></i>
                Edit Profile</a>
        </div>
        <p><strong>Description:</strong> ${startup.description}</p>
        <p><strong>Email:</strong> ${startup.email}</p>
    </div>

    <div class="news-section">
        <h3 class="news-header">Market Insights</h3>
        <div class="news-grid">
            <c:forEach var="news" items="${newsList}" varStatus="status">
                <c:if test="${status.index < 4}">
                    <div class="news-card">
                        <img src="${news.imageUrl}" class="news-img"
                             onerror="this.src='https://via.placeholder.com/400x200'">
                        <div class="news-content">
                            <a href="${news.url}" target="_blank" style="text-decoration:none;color:inherit">
                                <div class="news-title">${news.title}</div>
                            </a>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        document.getElementById("yearSpan").textContent = new Date().getFullYear();
        const name = "${startup.name}";
        if (name) profileIcon.textContent = name.charAt(0).toUpperCase();
        const savedTheme = localStorage.getItem("theme");
        if (savedTheme === "dark") document.documentElement.classList.add("dark-mode");
        updateThemeIcon();
    });

    function openNav() {
        mySidebar.classList.add("open");
        overlay.classList.add("show")
    }

    function closeNav() {
        mySidebar.classList.remove("open");
        overlay.classList.remove("show")
    }

    function toggleDropdown() {
        myDropdown.classList.toggle("show")
    }

    function updateThemeIcon() {
        var iconEl = document.querySelector('.theme-toggle i');
        if (!iconEl) return;
        if (document.documentElement.classList.contains('dark-mode')) {
            iconEl.classList.remove('fa-moon');
            iconEl.classList.add('fa-sun');
        } else {
            iconEl.classList.remove('fa-sun');
            iconEl.classList.add('fa-moon');
        }
    }

    function toggleTheme() {
        document.documentElement.classList.toggle("dark-mode");
        localStorage.setItem("theme", document.documentElement.classList.contains("dark-mode") ? "dark" : "light");
        updateThemeIcon();
        var iconEl = document.querySelector('.theme-toggle i');
        if (iconEl) {
            iconEl.classList.remove('icon-pulse');
            void iconEl.offsetWidth;
            iconEl.classList.add('icon-pulse');
            setTimeout(function () {
                iconEl.classList.remove('icon-pulse');
            }, 400);
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    (function () {
        function attachLogoutConfirm() {
            var links = document.querySelectorAll('a.logout-link');
            links.forEach(function (link) {
                link.addEventListener('click', function (e) {
                    e.preventDefault();
                    var href = link.getAttribute('href') || '/logout';
                    Swal.fire({
                        title: 'Log out?',
                        text: 'You will need to log in again to access your dashboard.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#28a745',
                        cancelButtonColor: '#6c757d',
                        confirmButtonText: 'Yes, log me out',
                        cancelButtonText: 'Stay logged in'
                    }).then(function (result) {
                        if (result.isConfirmed) {
                            window.location.href = href;
                        }
                    });
                });
            });
        }

        attachLogoutConfirm();
    })();
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>
    (function () {
        const startupId = ${startup.id};
        let stompClient = null;

        function connectProfileViewSocket() {
            const socket = new SockJS('/ws-chat');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function () {
                stompClient.subscribe('/topic/startup/profile-views/' + startupId, function (message) {
                    const data = JSON.parse(message.body);
                    const el = document.getElementById('profileViewsCount');
                    if (el && data.totalViews !== undefined) el.textContent = data.totalViews;
                });
            });
        }

        document.addEventListener('DOMContentLoaded', connectProfileViewSocket);
    })();
</script>
</body>
</html>