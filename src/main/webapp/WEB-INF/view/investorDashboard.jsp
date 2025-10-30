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
    <title>Investor Dashboard</title>
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
        .hamburger{font-size:1.25rem;color:var(--muted);cursor:pointer;display:inline-flex;align-items:center;justify-content:center;z-index:1410}
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
            box-shadow: 0 6px 20px rgba(12,17,38,0.06);
            z-index:1410;
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
            z-index: 1405;
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{display:block;padding:12px 14px;color:#0f172a;text-decoration:none;font-weight:600}
        .dropdown-content a:hover{background:linear-gradient(90deg, rgba(40,167,69,0.06), transparent)}

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

        /* controls */
        .controls{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:16px}
        .left-controls{display:flex;gap:12px;align-items:center}
        .filter-toggle-button{
            background: linear-gradient(180deg, var(--accent), var(--accent-600)); color:white; border:none;
            padding:10px 18px; font-weight:700; border-radius:999px; cursor:pointer; box-shadow: 0 10px 30px rgba(40,167,69,0.14)
        }
        .small-muted{color:var(--muted); font-weight:600; opacity:0.92}

        /* filter area */
        .collapsible-content{overflow:hidden;max-height:0;transition:max-height .42s cubic-bezier(.2,.9,.2,1);padding:0}
        .collapsible-content.open{max-height:420px;padding:14px 0}
        .filter-form{display:flex;flex-direction:column;gap:12px}
        .filter-row{display:flex;gap:10px;align-items:center}
        .filter-row input, .filter-row select{flex:1;padding:12px;border-radius:10px;border:1px solid rgba(12,17,38,0.06);background:rgba(255,255,255,0.92);outline:none;font-weight:600}
        .filter-actions{display:flex;gap:10px}

        /* apply/reset */
        .apply-button{background:var(--accent);color:white;border:none;padding:10px 16px;border-radius:999px;font-weight:700;cursor:pointer}
        .reset-button{background:#6c757d;color:white;border:none;padding:10px 14px;border-radius:999px;font-weight:700;cursor:pointer}

        /* =========================
           Startups grid & cards
           ========================= */
        .startup-card-container{
            display:grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap:18px;
            margin-top:12px;
        }

        .startup-card{
            display:block;text-decoration:none;border-radius:12px;overflow:hidden;
            background: linear-gradient(180deg, rgba(255,255,255,0.86), rgba(245,250,247,0.78));
            border: 1px solid rgba(12,17,38,0.04);
            box-shadow: 0 10px 30px rgba(12,17,38,0.06);
            transition: transform .36s cubic-bezier(.2,.9,.2,1), box-shadow .36s;
        }
        .startup-card:hover{transform: translateY(-10px); box-shadow: 0 30px 70px rgba(12,17,38,0.12)}
        .card-header{padding:14px 16px;background: linear-gradient(90deg, rgba(255,255,255,0.64), rgba(255,255,255,0.42));font-weight:700}
        .card-body{padding:14px 16px;color:var(--text)}
        .card-description{color:var(--muted); font-size:0.95rem; margin-bottom:8px}
        .card-body strong { color: var(--accent); }

        /* empty state */
        .empty-state{padding:24px;text-align:center;color:var(--muted)}

        /* =========================
           Responsive & overflow fixes
           ========================= */
        @media (max-width:1100px){
            .page-wrap{padding-left:12px;padding-right:12px}
            .navbar{left:8px;right:8px}
            .sidebar.open{width:260px}
            .sidebar .panel{width:260px}
        }
        @media (max-width:860px){
            .navbar{left:6px;right:6px}
            body{padding-top:86px}
            .container{padding:18px}
            .filter-row{flex-direction:column;align-items:stretch}
            .startup-card-container{grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:12px}
            .sidebar{left:8px}
        }
        @media (max-width:480px){
            .navbar{left:6px;right:6px;padding:8px 12px}
            .hamburger {font-size:1.05rem}
            .logo{font-size:0.98rem}
            .welcome-msg{display:none} /* save space on very small screens */
            .profile-icon{width:40px;height:40px}
            .page-wrap{padding-left:8px;padding-right:8px}
            /* Stack filter buttons vertically */
            .filter-actions { flex-direction: column; }
            .filter-actions button { width: 100%; margin-left: 0 !important; }
            .filter-row input, .filter-row select { padding: 10px; font-size: 0.9rem; }
        }

        /* =========================
           Dark theme overrides (toggle)
           ========================= */
        .dark-mode{
            --bg-1: linear-gradient(180deg,#071018,#071417);
            --glass: rgba(18,18,18,0.62);
            --glass-2: rgba(28,28,28,0.5);
            --muted: #9fb3c6;
            --text: #dbeafe;
            background: linear-gradient(180deg,#03050a,#071017);
            color: var(--text);
        }
        .dark-mode .navbar{
            background: linear-gradient(180deg, rgba(8,12,20,0.6), rgba(6,10,16,0.55)); border: 1px solid rgba(255,255,255,0.03)
        }
        .dark-mode .container{
            background: linear-gradient(180deg, rgba(10,14,18,0.55), rgba(8,12,16,0.45)); border:1px solid rgba(255,255,255,0.03)
        }
        .dark-mode .sidebar .panel{
            background: linear-gradient(180deg, rgba(10,14,18,0.55), rgba(8,12,16,0.4)); border:1px solid rgba(255,255,255,0.03)
        }
        .dark-mode .startup-card{
            background: linear-gradient(180deg, rgba(12,16,20,0.45), rgba(8,12,16,0.38));
            border: 1px solid rgba(255,255,255,0.03);
        }
        .dark-mode .profile-icon{ background: linear-gradient(180deg,#0a2f14,#0b3616); color: #bff2c7 }
        .dark-mode .theme-toggle{ background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.04) }

        /* Accessibility focus */
        a:focus, button:focus, input:focus { outline: 3px solid rgba(40,167,69,0.18); outline-offset: 2px; border-radius:8px }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar" aria-hidden="true">
    <div class="panel" role="navigation" aria-label="Sidebar">
        <span class="closebtn" onclick="closeNav()" style="position:absolute;top:18px;right:18px;font-size:20px;cursor:pointer">×</span>

        <a href="/investor/dashboard/${investor.id}" style="margin-top:10px"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="#"><i class="fas fa-rocket"></i> My Startups</a>
        <a href="/investor/profile"><i class="fas fa-user-circle"></i> Settings</a>
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
        <div class="logo" title="Project name">My Project</div>
    </div>

    <div class="navbar-right">
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn" aria-pressed="false" title="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>

        <div class="welcome-msg">Welcome, ${investor.investorName}</div>

        <div class="profile-dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()" aria-haspopup="true" aria-expanded="false">P</div>
            <nav id="myDropdown" class="dropdown-content" role="menu" aria-hidden="true">
                <a href="/investor/profile" role="menuitem">My Profile</a>
                <a href="/logout" role="menuitem">Logout</a>
            </nav>
        </div>
    </div>
</header>

<div class="page-wrap" role="main">
    <div class="container" id="mainContainer">
        <h1>Welcome to Your Dashboard!</h1>

        <div class="controls" aria-hidden="false">
            <div class="left-controls">
                <button class="filter-toggle-button" onclick="toggleFilter()" aria-expanded="false" aria-controls="filterCollapsible">
                    <i class="fas fa-filter" style="margin-right:8px"></i> Filter
                </button>
                <div class="small-muted" style="margin-left:6px">Find startups quickly — refined results.</div>
            </div>

            <div class="small-muted" style="text-align:right;font-weight:700">${investor.investorName} • Investor</div>
        </div>

        <div id="filterCollapsible" class="collapsible-content" aria-hidden="true">
            <form id="filterForm" action="/investor/dashboard" method="get" class="filter-form" role="search">
                <div class="filter-row">
                    <input type="text" name="search" placeholder="Search by name or industry..." value="${currentSearch}" aria-label="Search startups by name or industry">
                    <select name="industry" aria-label="Filter by industry">
                        <option value="" ${empty currentIndustry ? 'selected' : ''}>All Industries</option>
                        <c:forEach var="industry" items="${industries}">
                            <option value="${industry}" ${industry eq currentIndustry ? 'selected' : ''}>${industry}</option>
                        </c:forEach>
                    </select>

                    <div class="filter-actions">
                        <button type="submit" class="apply-button">Apply Filter</button>
                        <button type="button" class="reset-button" onclick="window.location.href='/investor/dashboard'">Reset</button>
                    </div>
                </div>
            </form>
        </div>

        <c:if test="${not empty startups}">
            <h2 style="margin-top:12px;font-weight:700">Available Startups:</h2>

            <div class="startup-card-container" id="startupGrid">
                <c:forEach var="startup" items="${startups}">
                    <a href="/investor/startup/${startup.id}" class="startup-card" aria-label="${startup.name}">
                        <div class="card-header">${startup.name}</div>
                        <div class="card-body">
                            <p class="card-description">${startup.description}</p>
                            <p><strong>Industry:</strong> ${startup.industry}</p>
                            <p><strong>Funding Ask:</strong> <strong>$${startup.fundingAsk}</strong></p>
                            <p><strong>Equity Offered:</strong> <strong>${startup.equityOffered}%</strong></p>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty startups}">
            <div class="empty-state"><p>No startups found at this time.</p></div>
        </c:if>
    </div>
</div>

<script>
    /* =========================
       Keep all original function names and logic
       ========================= */

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

    // Close dropdown on outside click (kept)
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

    // Theme handling (kept names; improved persistence & accessibility)
    function setTheme(theme) {
        if (theme === 'dark') {
            document.documentElement.classList.add('dark-mode');
            document.querySelector('.theme-toggle').innerHTML = '<i class="fas fa-sun"></i>';
            document.getElementById('themeToggleBtn').setAttribute('aria-pressed', 'true');
        } else {
            document.documentElement.classList.remove('dark-mode');
            document.querySelector('.theme-toggle').innerHTML = '<i class="fas fa-moon"></i>';
            document.getElementById('themeToggleBtn').setAttribute('aria-pressed', 'false');
        }
        try { localStorage.setItem('theme', theme); } catch(e){ /* ignore if storage blocked */ }
    }

    function toggleTheme() {
        if (document.documentElement.classList.contains('dark-mode')) {
            setTheme('light');
        } else {
            setTheme('dark');
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        // theme restore
        const savedTheme = (function(){
            try { return localStorage.getItem('theme'); } catch(e){ return null; }
        })() || 'light';
        setTheme(savedTheme);

        // dynamic profile icon (kept)
        const investorName = "${investor.investorName}";
        const profileIcon = document.getElementById("profileIcon");
        if (investorName && profileIcon) {
            profileIcon.textContent = investorName.charAt(0).toUpperCase();
            profileIcon.setAttribute('title', investorName);
        }

        // small UX: close filter when clicking outside
        document.addEventListener('click', function(e) {
            const filter = document.getElementById('filterCollapsible');
            const toggleBtn = document.querySelector('.filter-toggle-button');
            if (!e.target.closest('#filterCollapsible') && !e.target.closest('.filter-toggle-button')) {
                if (filter.classList.contains('open')) {
                    filter.classList.remove('open');
                    filter.setAttribute('aria-hidden', 'true');
                    if (toggleBtn) toggleBtn.setAttribute('aria-expanded', 'false');
                }
            }
        });

        // year for footer panel (sidebar)
        const yearSpan = document.getElementById('yearSpan');
        if (yearSpan) yearSpan.textContent = new Date().getFullYear();
    });

    // Collapsible filter (kept)
    function toggleFilter() {
        const content = document.getElementById("filterCollapsible");
        content.classList.toggle("open");
        const expanded = content.classList.contains("open");
        content.setAttribute('aria-hidden', expanded ? 'false' : 'true');
        const btn = document.querySelector('.filter-toggle-button');
        if (btn) btn.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    }

    /* =========================
       Fixes for content overflow / layout stability
       ========================= */
    (function layoutStabilityFixes(){
        // Force no horizontal overflow on small windows
        document.documentElement.style.overflowX = 'hidden';

        // Observe container width for dynamic adjustments (defensive)
        try {
            const grid = document.getElementById('startupGrid');
            if (grid) {
                const ensureCardMin = function(){
                    // Uses CSS Grid, but fallback or adjustments can be made here
                    if (window.innerWidth < 420) {
                        grid.style.gridTemplateColumns = 'repeat(1, minmax(0,1fr))';
                    } else if (window.innerWidth < 760) {
                        grid.style.gridTemplateColumns = 'repeat(2, minmax(0,1fr))';
                    } else {
                        grid.style.gridTemplateColumns = 'repeat(auto-fit, minmax(260px, 1fr))';
                    }
                };
                ensureCardMin();
                window.addEventListener('resize', ensureCardMin);
            }
        } catch(e){ /* no-op */ }
    })();

</script>

</body>
</html>