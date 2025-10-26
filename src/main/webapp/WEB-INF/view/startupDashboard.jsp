<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Prevent caching of this page to fix the back button issue
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.
%>
<!DOCTYPE html>
<html>
<head>
    <title>Startup Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* =========================
           Variables & base reset
           ========================= */
        :root{
            --accent: #28a745;
            --accent-600: #218838;
            --bg-1: linear-gradient(180deg,#f4fbf6 0%, #eef6f2 50%, #f7fafb 100%);
            --muted: #6b7280;
            --text: #0f172a;
            --card-radius: 14px;
            --max-page-width: 1600px;
        }

        *{box-sizing:border-box;margin:0;padding:0}
        html,body{height:100%;font-family:'Poppins',sans-serif;-webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale}
        body{
            background: var(--bg-1);
            color: var(--text);
            min-height:100vh;
            padding-top:78px;
            transition: background 0.28s ease, color 0.28s ease;
        }

        /* Thin scrollbar (modern) */
        ::-webkit-scrollbar { height:10px; width:10px; }
        ::-webkit-scrollbar-thumb { background: rgba(12,17,38,0.12); border-radius:999px; }
        ::-webkit-scrollbar-track { background: transparent; }
        * { scrollbar-width: thin; scrollbar-color: rgba(12,17,38,0.12) transparent; }

        /* =========================
           Navbar (glass)
           ========================= */
        .navbar{
            position:fixed;
            top:10px;
            left:10px;
            right:10px;
            height:64px;
            z-index:1400;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            padding:10px 18px;
            border-radius:14px;
            background: linear-gradient(180deg, rgba(255,255,255,0.70), rgba(255,255,255,0.62));
            backdrop-filter: blur(8px) saturate(120%);
            border: 1px solid rgba(255,255,255,0.48);
            box-shadow: 0 8px 28px rgba(12,17,38,0.06);
        }
        .navbar-left{display:flex;gap:14px;align-items:center}
        .hamburger{font-size:1.25rem;color:var(--muted);cursor:pointer;display:inline-flex;align-items:center;justify-content:center}
        .logo{font-weight:700;color:var(--accent);font-size:1.05rem;letter-spacing:0.2px}
        .navbar-right{display:flex;gap:12px;align-items:center}

        .welcome-msg{font-weight:600;color:var(--text);opacity:0.92}
        .profile-dropdown{position:relative}

        /* Profile icon */
        .profile-icon{
            width:44px;height:44px;border-radius:12px;
            display:flex;align-items:center;justify-content:center;font-weight:700;
            background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(250,250,250,0.84));
            color:var(--accent); cursor:pointer; border:1px solid rgba(12,17,38,0.04);
            box-shadow: 0 6px 20px rgba(12,17,38,0.06)
        }

        /* Theme toggle */
        .theme-toggle{
            cursor:pointer;border-radius:10px;padding:8px 10px;font-size:0.95rem;
            background: rgba(255,255,255,0.72);border:1px solid rgba(255,255,255,0.5);
            display:inline-flex;align-items:center;justify-content:center;box-shadow: 0 4px 12px rgba(12,17,38,0.04)
        }

        .dropdown-content{
            display:none; position:absolute; right:0; top:58px; min-width:170px;
            background: linear-gradient(180deg,#ffffff,#fbffff);
            border-radius:10px; overflow:hidden; box-shadow:0 12px 36px rgba(12,17,38,0.08); border:1px solid rgba(12,17,38,0.04);
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{display:block;padding:12px 14px;color:#0f172a;text-decoration:none;font-weight:600}
        .dropdown-content a:hover{background: linear-gradient(90deg, rgba(40,167,69,0.06), transparent)}

        /* =========================
           Sidebar (collapsible)
           ========================= */
        .sidebar{
            position:fixed;top:10px;left:10px;height:calc(100% - 20px);width:0;z-index:1350;padding-top:88px;
            overflow:hidden;transition:width 320ms cubic-bezier(.2,.9,.2,1);
        }
        .sidebar .panel{
            height:100%; width:280px; padding:18px; border-radius:14px;
            background: linear-gradient(180deg, rgba(255,255,255,0.66), rgba(255,255,255,0.52));
            border:1px solid rgba(255,255,255,0.45); backdrop-filter: blur(6px);
            box-shadow: 6px 12px 30px rgba(12,17,38,0.06);
            transform-origin:left center;
        }
        .sidebar.open{width:300px}
        .sidebar.open .panel{width:300px}
        .sidebar a{display:flex;align-items:center;padding:14px 12px;border-radius:10px;text-decoration:none;color:var(--text);font-weight:600}
        .sidebar a i{margin-right:12px;color:var(--muted)}
        .sidebar a:hover{background: rgba(40,167,69,0.06); color: var(--accent)}

        /* overlay when sidebar open on small screens */
        .overlay{display:none;position:fixed;top:0;left:0;width:100%;height:100%;z-index:1340;background:rgba(9,11,14,0.28);transition:opacity .2s}
        .overlay.show{display:block}

        /* =========================
           Page wrapper + container
           ========================= */
        .page-wrap{width:100%;max-width:var(--max-page-width);margin:0 auto;padding:14px 22px}
        .container{
            width:100%; border-radius:16px; padding:28px; margin-top:6px;
            background: linear-gradient(180deg, rgba(255,255,255,0.70), rgba(255,255,255,0.60));
            border: 1px solid rgba(255,255,255,0.48); backdrop-filter: blur(6px);
            box-shadow: 0 14px 50px rgba(12,17,38,0.06);
        }

        h1{color:var(--accent); margin:0 0 16px; font-size:1.5rem; font-weight:700;}

        /* --- Welcome Banner --- */
        .welcome-banner {
            background-image: linear-gradient(135deg, var(--accent), var(--accent-600));
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            text-align: center;
        }
        .welcome-banner h1 {
            color: white;
            margin: 0 0 10px 0;
            font-size: 2.5rem;
            letter-spacing: 1px;
            font-weight: 700;
        }
        .welcome-banner p {
            font-size: 1.1rem;
            margin: 0;
            opacity: 0.9;
            font-weight: 400;
        }

        /* --- Summary Cards --- */
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background-color: var(--white);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: center;
            border: 1px solid rgba(12,17,38,0.04);
        }
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        .card h4 {
            margin: 0 0 10px 0;
            color: var(--muted);
            font-size: 1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card p {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--accent);
            margin: 0;
        }
        .section-icon {
            font-size: 1.3rem;
            margin-right: 10px;
            color: var(--accent);
        }

        /* --- Main Profile Section --- */
        .main-content-section {
            background: var(--white);
            padding: 28px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            text-align: left;
            border: 1px solid rgba(12,17,38,0.04);
            margin-bottom: 20px;
        }
        .section-header {
            color: var(--text);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 12px;
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .section-header h2 {
            margin: 0;
            font-size: 1.3rem;
            font-weight: 700;
            display: flex;
            align-items: center;
        }
        .section-header a {
            text-decoration: none;
        }
        .profile-info p {
            font-size: 1rem;
            margin: 10px 0;
        }

        /* --- Button Styling --- */
        .edit-button {
            background: linear-gradient(180deg, var(--accent), var(--accent-600));
            color: white;
            border: none;
            padding: 10px 18px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 50px; /* Pill shape */
            cursor: pointer;
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.2);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .edit-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
        }

        /* --- ML Analyzer/Pitch Section --- */
        .ml-link-container {
            text-align: center;
            margin: 30px 0;
        }
        .pitch-analyzer-button {
            background: linear-gradient(135deg, #4caf50, #2b823e);
            color: var(--white);
            font-size: 1rem;
            font-weight: 700;
            padding: 12px 30px;
            border-radius: 50px;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 8px 20px rgba(76, 175, 80, 0.3);
            transition: all 0.3s ease;
        }
        .pitch-analyzer-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(76, 175, 80, 0.4);
            background: linear-gradient(135deg, #38d65a, #28a745);
        }
        .ml-text {
            margin-top: 10px;
            font-size: 0.9rem;
            color: var(--muted);
            font-weight: 400;
        }

        /* --- News Section --- */
        .news-header {
            color: var(--text);
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--accent);
        }
        .news-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 15px;
        }
        .news-card {
            display:block;
            text-decoration:none;
            border-radius:12px;
            background: linear-gradient(180deg, rgba(255,255,255,0.9), rgba(245,250,247,0.85));
            border: 1px solid rgba(12,17,38,0.04);
            box-shadow: 0 6px 18px rgba(12,17,38,0.06);
            transition: transform .3s cubic-bezier(.2,.9,.2,1), box-shadow .3s;
            overflow: hidden;
            height: 100%;
        }
        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(12,17,38,0.12);
            border-color: var(--accent);
        }
        .news-image-container {
            width: 100%;
            height: 160px;
            overflow: hidden;
            background: #f8f9fa;
        }
        .news-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .news-card:hover .news-img {
            transform: scale(1.05);
        }
        .news-content {
            padding: 15px;
        }
        .news-title {
            font-size: 0.95rem;
            font-weight: 600;
            line-height: 1.3;
            color: var(--text);
            margin: 0;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .news-empty{padding:40px;text-align:center;color:var(--muted)}

        /* Loading animation for images */
        .news-img[src=""] {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        /* =========================
           Dark theme overrides
           ========================= */
        .dark-mode{
            --bg-1: linear-gradient(180deg,#071018 0%,#071417 100%);
            --muted: #9fb3c6;
            --text: #dbeafe;
            color: var(--text);
        }
        .dark-mode .navbar{
            background: linear-gradient(180deg, rgba(18,25,38,0.60), rgba(16,22,34,0.52)); /* Dark glass effect */
            border: 1px solid rgba(255,255,255,0.03);
        }
        .dark-mode .container,
        .dark-mode .main-content-section,
        .dark-mode .card,
        .dark-mode .welcome-banner,
        .dark-mode .news-card {
            background: rgba(18,25,38,0.85);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 14px 50px rgba(0,0,0,0.5);
        }
        .dark-mode .sidebar .panel{
            background: linear-gradient(180deg, rgba(18,25,38,0.85), rgba(16,22,34,0.7)); /* Dark sidebar panel */
            border:1px solid rgba(255,255,255,0.08);
        }
        .dark-mode .card:hover {
            box-shadow: 0 12px 25px rgba(0,0,0,0.6);
        }
        .dark-mode .card h4,
        .dark-mode .card p {
            color: var(--text);
        }
        .dark-mode .card p {
            color: var(--accent);
        }
        .dark-mode .welcome-banner {
            background-image: linear-gradient(135deg, #2b9d49, #1a642e);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.5);
        }
        .dark-mode .edit-button,
        .dark-mode .pitch-analyzer-button {
            background: linear-gradient(180deg, #2b9d49, #1a642e);
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.3);
            color: var(--white);
        }
        .dark-mode .profile-info p {
            color: var(--text);
        }
        .dark-mode .profile-info p strong {
            color: var(--text);
        }
        .dark-mode .news-header {
            color: var(--text);
            border-bottom-color: var(--accent);
        }
        .dark-mode .theme-toggle{ background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.15) }
        .dark-mode .profile-icon{ background: #1a642e; color: #bff2c7 }


        /* Accessibility focus */
        a:focus, button:focus, input:focus { outline: 3px solid rgba(40,167,69,0.18); outline-offset: 2px; border-radius:8px }

        /* =========================
           Responsive overrides
           ========================= */
        @media (max-width:860px){
            .navbar{left:6px;right:6px}
            body{padding-top:86px}
            .page-wrap{padding:14px 12px}
            .container{padding:18px}
            .welcome-banner h1{font-size:2rem}
            .summary-cards{grid-template-columns:1fr;gap:15px}
            .sidebar{left:8px}
        }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar" aria-hidden="true">
    <div class="panel" role="navigation" aria-label="Sidebar">
        <span class="closebtn" onclick="closeNav()" style="position:absolute;top:18px;right:18px;font-size:20px;cursor:pointer">×</span>

        <a href="#"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="#"><i class="fas fa-user-circle"></i> My Profile</a>
        <a href="#"><i class="fas fa-chart-line"></i> Analytics</a>
        <a href="/contact"><i class="fas fa-envelope"></i> Contact Us</a>

        <div style="position:absolute;bottom:18px;left:18px;right:18px;color:var(--muted);font-weight:600;font-size:0.95rem">
            <div>Startup Ecosystem</div>
            <div style="font-size:0.85rem;margin-top:6px;color:var(--muted)">© <span id="yearSpan"></span></div>
        </div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeNav()" aria-hidden="true"></div>

<header class="navbar" role="banner">
    <div class="navbar-left">
        <div class="hamburger" onclick="openNav()" aria-label="Open menu" title="Open menu">&#9776;</div>
        <div class="logo" title="Project name">Startup Ecosystem</div>
    </div>

    <div class="navbar-right">
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn" aria-pressed="false" title="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>

        <div class="welcome-msg">Welcome, ${startup.name}</div>

        <div class="profile-dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()" aria-haspopup="true" aria-expanded="false">P</div>
            <nav id="myDropdown" class="dropdown-content" role="menu" aria-hidden="true">
                <a href="/startup/profile" role="menuitem">My Profile</a>
                <a href="/logout" role="menuitem">Logout</a>
            </nav>
        </div>
    </div>
</header>

<div class="page-wrap">
    <div class="container">

        <div class="welcome-banner">
            <h1>Hello, ${startup.name}!</h1>
            <p>Welcome to your startup's command center.</p>
        </div>

        <div class="summary-cards">
            <div class="card">
                <h4><span class="section-icon"><i class="fas fa-chart-line"></i></span>Total Investments</h4>
                <p>$0</p>
            </div>
            <div class="card">
                <h4><span class="section-icon"><i class="fas fa-envelope"></i></span>Messages</h4>
                <p>0</p>
            </div>
            <div class="card">
                <h4><span class="section-icon"><i class="fas fa-eye"></i></span>Profile Views</h4>
                <p>0</p>
            </div>
        </div>

        <div class="main-content-section">
            <div class="section-header">
                <h2><span class="section-icon"><i class="fas fa-rocket"></i></span>My Profile</h2>
                <a href="/startup/profile" class="edit-button">Edit Profile</a>
            </div>
            <div class="profile-info">
                <p><strong>Description:</strong> ${startup.description}</p>
                <p><strong>Industry:</strong> ${startup.industry}</p>
                <p><strong>Email:</strong> ${startup.email}</p>
            </div>
        </div>

        <div class="ml-link-container">
            <a href="${pageContext.request.contextPath}/ml"
               target="_blank"
               class="pitch-analyzer-button">
                Launch Pitch Analyzer
            </a>
            <p class="ml-text">
                Analyze your pitch and get investor recommendations powered by AI.
            </p>
        </div>

        <div class="news-section">
            <h3 class="news-header">
                <i class="fas fa-bullhorn"></i>Latest in ${startup.industry}
            </h3>

            <c:if test="${not empty newsList}">
                <div class="news-grid startup-card-container">
                    <c:forEach var="news" items="${newsList}" varStatus="status">
                        <c:if test="${status.index < 6}">
                            <article class="news-card" style="padding:0; box-shadow: 0 4px 12px rgba(12,17,38,0.06);">
                                <a href="${news.url}" target="_blank" class="news-link" style="display:block; color:inherit;">
                                    <div class="news-image-container">
                                        <img src="${news.imageUrl}"
                                             alt="${news.title}"
                                             class="news-img"
                                             onerror="this.src='https://via.placeholder.com/300x200/f0f0f0/999999?text=No+Image'">

                                        <div class="news-overlay"></div>
                                    </div>
                                    <div class="news-content" style="padding:15px; min-height:80px">
                                        <h4 class="news-title">${news.title}</h4>
                                    </div>
                                </a>
                            </article>
                        </c:if>
                    </c:forEach>
                </div>
            </c:if>
            <c:if test="${empty newsList}">
                <div class="empty-state">
                    <p>No news articles available at the moment.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    /* =========================
       Keep all original function names and logic
       ========================= */
    document.addEventListener('DOMContentLoaded', () => {
        // Redirect to login if the session is gone
        if ("${startup.email}" === "") {
            window.location.href = "/login?message=You have been logged out.";
        }

        // Year for sidebar footer
        const yearSpan = document.getElementById('yearSpan');
        if (yearSpan) yearSpan.textContent = new Date().getFullYear();

        // Theme restore
        const savedTheme = (function(){
            try { return localStorage.getItem('theme'); } catch(e){ return null; }
        })() || 'light';
        setTheme(savedTheme);

        // Dynamic Profile Icon
        const startupName = "${startup.name}";
        const profileIcon = document.getElementById("profileIcon");
        if (startupName && profileIcon) {
            profileIcon.textContent = startupName.charAt(0).toUpperCase();
            profileIcon.setAttribute('title', startupName);
        }
    });

    function openNav() {
        document.getElementById("mySidebar").classList.add("open");
        document.getElementById("overlay").classList.add("show");
        document.getElementById("mySidebar").setAttribute('aria-hidden', 'false');
        document.getElementById("overlay").setAttribute('aria-hidden', 'false');
    }

    function closeNav() {
        document.getElementById("mySidebar").classList.remove("open");
        document.getElementById("overlay").classList.remove("show");
        document.getElementById("mySidebar").setAttribute('aria-hidden', 'true');
        document.getElementById("overlay").setAttribute('aria-hidden', 'true');
    }

    function toggleDropdown() {
        const dd = document.getElementById("myDropdown");
        dd.classList.toggle("show");
        const expanded = dd.classList.contains("show");
        document.getElementById("profileIcon").setAttribute('aria-expanded', expanded ? 'true' : 'false');
        dd.setAttribute('aria-hidden', expanded ? 'false' : 'true');
    }

    window.addEventListener('click', function(event) {
        if (!event.target.closest('.profile-dropdown') && !event.target.closest('.hamburger')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                    openDropdown.setAttribute('aria-hidden', 'true');
                    var icon = document.getElementById("profileIcon");
                    if (icon) icon.setAttribute('aria-expanded', 'false');
                }
            }
        }
    });

    function setTheme(theme) {
        const html = document.documentElement;
        const toggleBtn = document.querySelector('.theme-toggle');

        if (theme === 'dark') {
            html.classList.add('dark-mode');
            if (toggleBtn) {
                toggleBtn.innerHTML = '<i class="fas fa-sun"></i>';
                toggleBtn.setAttribute('aria-pressed', 'true');
            }
        } else {
            html.classList.remove('dark-mode');
            if (toggleBtn) {
                toggleBtn.innerHTML = '<i class="fas fa-moon"></i>';
                toggleBtn.setAttribute('aria-pressed', 'false');
            }
        }
        try { localStorage.setItem('theme', theme); } catch(e){ /* ignore if storage blocked */ }
    }

    function toggleTheme() {
        const html = document.documentElement;
        if (html.classList.contains('dark-mode')) {
            setTheme('light');
        } else {
            setTheme('dark');
        }
    }

</script>

</body>
</html>