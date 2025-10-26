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
    <title>Contact Us</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet"/>
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
           Contact Form Container (FIXED STYLING)
           ========================= */
        .page-wrap{
            width:100%;
            max-width:var(--max-page-width);
            margin:0 auto;
            padding:14px 22px;
            /* Flex properties to center the contact form vertically and horizontally */
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 78px); /* Height of the viewport minus padding */
        }
        .container{
            max-width: 600px;
            width:100%;
            border-radius:16px;
            padding:40px;
            /* margin:auto; (Removed, replaced by page-wrap flex centering) */
            background: linear-gradient(180deg, rgba(255,255,255,0.70), rgba(255,255,255,0.60));
            border: 1px solid rgba(255,255,255,0.48);
            backdrop-filter: blur(6px);
            box-shadow: 0 14px 50px rgba(12,17,38,0.06);
            text-align: left; /* Aligns text inputs left */
        }

        h1{color:var(--accent); margin:0 0 16px; font-size:2rem; font-weight:700; text-align: center;}

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--text);
            font-size: 0.95rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid rgba(12,17,38,0.1);
            border-radius: 10px;
            box-sizing: border-box;
            font-size: 1rem;
            background: rgba(255,255,255,0.85);
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--accent);
            outline: none;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 150px;
        }

        .submit-button {
            background: linear-gradient(180deg, var(--accent), var(--accent-600));
            color: white;
            padding: 14px 25px;
            border: none;
            border-radius: 50px; /* Pill shape */
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.2);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            width: 100%;
            margin-top: 20px;
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
        }

        /* Alert styling */
        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
            text-align: left;
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
        .dark-mode .container,
        .dark-mode .sidebar .panel {
            background: rgba(18,25,38,0.85);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 14px 50px rgba(0,0,0,0.5);
        }
        .dark-mode .form-group label {
            color: var(--text);
        }
        .dark-mode .form-group input,
        .dark-mode .form-group textarea {
            background: rgba(255,255,255,0.05);
            border-color: rgba(255,255,255,0.2);
            color: var(--text);
        }
        .dark-mode .submit-button {
            background: linear-gradient(180deg, #2b9d49, #1a642e);
        }
        .dark-mode .submit-button:hover {
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.5);
        }

        /* Accessibility focus */
        a:focus, button:focus, input:focus { outline: 3px solid rgba(40,167,69,0.18); outline-offset: 2px; border-radius:8px }

        /* Responsive */
        @media (max-width:768px){
            .navbar{left:6px;right:6px}
            body{padding-top:86px}
            .container{padding:20px}
        }
    </style>
</head>
<body>
<div id="mySidebar" class="sidebar" aria-hidden="true">
    <div class="panel" role="navigation" aria-label="Sidebar">
        <span class="closebtn" onclick="closeNav()" style="position:absolute;top:18px;right:18px;font-size:20px;cursor:pointer">×</span>

        <c:if test="${not empty investor}">
            <a href="/investor/dashboard/${investor.id}"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            <a href="#"><i class="fas fa-rocket"></i> My Startups</a>
            <a href="/investor/profile"><i class="fas fa-user-circle"></i> Settings</a>
            <a href="/contact"><i class="fas fa-envelope"></i> Contact Us</a>
        </c:if>
        <c:if test="${empty investor}">
            <a href="/"><i class="fas fa-home"></i> Home</a>
        </c:if>

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

        <c:if test="${not empty investor}">
            <div class="welcome-msg">Welcome, ${investor.investorName}</div>
            <div class="profile-dropdown">
                <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()" aria-haspopup="true" aria-expanded="false">P</div>
                <nav id="myDropdown" class="dropdown-content" role="menu" aria-hidden="true">
                    <a href="/investor/profile" role="menuitem">My Profile</a>
                    <a href="/logout" role="menuitem">Logout</a>
                </nav>
            </div>
        </c:if>
    </div>
</header>

<div class="page-wrap">
    <div class="container">
        <h1>Contact Us</h1>
        <p style="color:var(--muted); margin-bottom: 25px; font-size:1rem;">We are here to help. Fill out the form below and we will get back to your team.</p>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                    ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                    ${errorMessage}
            </div>
        </c:if>

        <form action="/contact" method="post">
            <div class="form-group">
                <label for="name">Your Name</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="email">Your Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="message">Your Message</label>
                <textarea id="message" name="message" required></textarea>
            </div>
            <button type="submit" class="submit-button">Send Message</button>
        </form>
    </div>
</div>

<script>
    /* =========================
       Keep all original function names and logic
       ========================= */
    document.addEventListener('DOMContentLoaded', () => {
        // Year for sidebar footer
        const yearSpan = document.getElementById('yearSpan');
        if (yearSpan) yearSpan.textContent = new Date().getFullYear();

        // Theme restore
        const savedTheme = (function(){
            try { return localStorage.getItem('theme'); } catch(e){ return null; }
        })() || 'light';
        setTheme(savedTheme);

        // Dynamic Profile Icon (Only if investor is logged in)
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
        const profileIcon = document.getElementById("profileIcon");

        if(profileIcon) {
            profileIcon.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        }
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