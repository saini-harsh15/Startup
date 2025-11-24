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
    <title>${startup.name} - Expanded View</title>
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
            --bg-1: linear-gradient(180deg,#f8fbfd 0%, #eef6f9 100%);
            --muted: #6b7280;
            --text: #0f172a;
            --card-radius: 14px;
            --max-page-width: 1600px;
            --white: #ffffff;
        }

        *{box-sizing:border-box;margin:0;padding:0}
        html,body{height:100%;font-family:'Poppins',sans-serif;-webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale}
        body{
            background: var(--bg-1);
            color: var(--text);
            min-height:100vh;
            padding-top:78px; /* Space for fixed navbar */
            transition: background 0.28s ease, color 0.28s ease;
            text-align: center;
        }

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
            background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(255,255,255,0.85)); /* Glass effect */
            backdrop-filter: blur(10px) saturate(150%);
            border: 1px solid rgba(255,255,255,0.8);
            box-shadow: 0 8px 30px rgba(12,17,38,0.1);
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
            background: linear-gradient(180deg, var(--accent), var(--accent-600));
            color:var(--white); cursor:pointer;
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.3);
            transition: transform 0.2s ease;
            z-index:1410;
        }

        /* Theme toggle */
        .theme-toggle{
            cursor:pointer;border-radius:10px;padding:8px 10px;font-size:0.95rem;
            background: rgba(0,0,0,0.05);
            border:1px solid rgba(0,0,0,0.05);
            display:inline-flex;align-items:center;justify-content:center;
            transition: all 0.2s ease;
        }

        .dropdown-content{
            display:none; position:absolute; right:0; top:58px; min-width:170px;
            background: var(--white);
            border-radius:10px; overflow:hidden; box-shadow:0 12px 36px rgba(12,17,38,0.12);
            border:1px solid rgba(12,17,38,0.04);
            z-index: 1405;
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{display:block;padding:12px 14px;color:var(--text);text-decoration:none;font-weight:500}
        .dropdown-content a:hover{background: rgba(40,167,69,0.08); color: var(--accent); font-weight:600}

        /* =========================
           Sidebar (collapsible)
           ========================= */
        .sidebar{
            position:fixed;top:10px;left:10px;height:calc(100% - 20px);width:0;z-index:1350;padding-top:88px;
            overflow:hidden;transition:width 320ms cubic-bezier(.2,.9,.2,1);
        }
        .sidebar .panel{
            height:100%; width:280px; padding:18px; border-radius:14px;
            background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(255,255,255,0.85));
            border:1px solid rgba(255,255,255,0.7); backdrop-filter: blur(10px);
            box-shadow: 6px 12px 30px rgba(12,17,38,0.1);
            transform-origin:left center;
        }
        .sidebar.open{width:300px}
        .sidebar.open .panel{width:300px}
        .sidebar a{display:flex;align-items:center;padding:14px 12px;border-radius:10px;text-decoration:none;color:var(--text);font-weight:500}
        .sidebar a i{margin-right:12px;color:var(--accent)}
        .sidebar a:hover{background: rgba(40,167,69,0.08); color: var(--accent); font-weight:600;}

        /* overlay when sidebar open on small screens */
        .overlay{display:none;position:fixed;top:0;left:0;width:100%;height:100%;z-index:1340;background:rgba(9,11,14,0.28);transition:opacity .2s}
        .overlay.show{display:block}

        /* =========================
           Profile Container (Page content)
           ========================= */
        .page-wrap{width:100%;max-width:var(--max-page-width);margin:0 auto;padding:14px 22px}
        .container{
            max-width: 900px; /* Increased max width for content */
            width:100%; border-radius:16px; padding:40px; margin: 20px auto;
            background: var(--white);
            border: 1px solid rgba(12,17,38,0.04);
            box-shadow: 0 14px 50px rgba(12,17,38,0.06);
            text-align: left;
        }

        h1{color:var(--accent); margin:0 0 16px; font-size:1.8rem; font-weight:700; display: flex; align-items: center;}
        h1 i { margin-right: 15px; }

        .profile-header {
            display: flex;
            align-items: center;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .profile-header h1 {
            flex-grow: 1;
            margin: 0;
        }

        .profile-details p {
            font-size: 1.1rem;
            margin: 10px 0;
            color: var(--text);
        }
        .profile-details p strong {
            color: var(--text);
        }

        /* --- Button Styling --- */
        .back-button, .apply-button {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 0.95rem;
            font-weight: 600;
            border-radius: 50px;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        .back-button {
            background: var(--muted);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-right: 10px;
        }
        .back-button:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        .apply-button {
            background: var(--accent);
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.3);
        }
        .apply-button:hover {
            background: var(--accent-600);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.5);
        }
        .apply-form {
            display: inline-block;
        }

        /* --- Alerts --- */
        .alert-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
        }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

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
            background: linear-gradient(180deg, rgba(18,25,38,0.60), rgba(16,22,34,0.52));
            border: 1px solid rgba(255,255,255,0.03);
        }
        .dark-mode .container{
            background: rgba(18,25,38,0.85);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 14px 50px rgba(0,0,0,0.5);
        }
        .dark-mode .sidebar .panel{
            background: linear-gradient(180deg, rgba(18,25,38,0.85), rgba(16,22,34,0.7));
            border:1px solid rgba(255,255,255,0.08);
        }
        .dark-mode .profile-details p {
            color: var(--text);
        }
        .dark-mode .profile-details p strong {
            color: var(--text);
        }
        .dark-mode .apply-button {
            background: linear-gradient(180deg, #2b9d49, #1a642e);
        }
        .dark-mode .back-button {
            background: #4a5568;
        }

        /* Accessibility focus */
        a:focus, button:focus, input:focus { outline: 3px solid rgba(40,167,69,0.18); outline-offset: 2px; border-radius:8px }

        /* Responsive */
        @media (max-width:860px){
            .navbar{left:6px;right:6px}
            body{padding-top:86px}
            .page-wrap{padding:14px 12px}
        }
        @media (max-width:480px){
            .container { padding: 25px 15px; }
            h1 { font-size: 1.5rem; }
            .profile-header { flex-direction: column; align-items: stretch; }
            .profile-header div { display: flex; justify-content: space-between; gap: 10px; margin-top: 15px; }
            .back-button, .apply-button { flex: 1; margin-right: 0; }
        }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar" aria-hidden="true">
    <div class="panel" role="navigation" aria-label="Sidebar">
        <span class="closebtn" onclick="closeNav()" style="position:absolute;top:18px;right:18px;font-size:20px;cursor:pointer">×</span>

        <a href="/investor/dashboard/${investor.id}"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
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
        <div class="logo" title="Project name">Startup Ecosystem</div>
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

<div class="page-wrap">
    <div class="container">
        <h1><i class="fas fa-building"></i> ${startup.name}</h1>

        <c:if test="${not empty message}">
            <div class="alert-message alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-message alert-danger">${error}</div>
        </c:if>

        <div class="profile-header">
            <div style="flex-grow: 1; display: none;"></div>
            <div>
                <a href="/investor/dashboard" class="back-button">Back to Dashboard</a>
                <form action="/investor/apply-for-investment" method="post" class="apply-form">
                    <input type="hidden" name="startupId" value="${startup.id}">
                    <button type="submit" class="apply-button">Apply for Investment</button>
                </form>
            </div>
        </div>

        <div class="profile-details">
            <p><strong>Description:</strong> ${startup.description}</p>
            <p><strong>Industry:</strong> ${startup.industry}</p>
            <p><strong>Funding Ask:</strong> ${startup.fundingAsk}</p>
            <p><strong>Equity Offered:</strong> ${startup.equityOffered}%</p>
        </div>
    </div>
</div>

<script>
    /* =========================
       Keep all original function names and logic
       ========================= */
    document.addEventListener('DOMContentLoaded', () => {
        // Redirect to login if the session is gone
        if ("${investor.email}" === "") {
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
        const investorName = "${investor.investorName}";
        const profileIcon = document.getElementById("profileIcon");
        if (investorName && profileIcon) {
            profileIcon.textContent = investorName.charAt(0).toUpperCase();
            profileIcon.setAttribute('title', investorName);
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
        if (document.documentElement.classList.contains('dark-mode')) {
            setTheme('light');
        } else {
            setTheme('dark');
        }
    }
</script>

</body>
</html>