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
    <title>Investor Profile | EcoTrack</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
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
        }

        .dark-mode {
            --bg: #0b1220;
            --card: #111827;
            --text: #e5e7eb;
            --muted: #9ca3af;
            --border: 1px solid rgba(255, 255, 255, .08);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            color: var(--text);
            padding-top: 108px;
            scroll-behavior: smooth;
            transition: background 0.3s ease;
        }

        @keyframes pulsePop {
            0% { transform: scale(1); }
            40% { transform: scale(1.25); }
            100% { transform: scale(1); }
        }
        .icon-pulse { animation: pulsePop .35s ease; }

       .navbar {
            position: fixed; top: 14px; left: 14px; right: 14px; height: 68px; padding: 0 22px 0 26px;
            background: rgba(255, 255, 255, .85); backdrop-filter: blur(14px);
            border: var(--border); border-radius: 18px; display: flex;
            justify-content: space-between; align-items: center; z-index: 1000;
        }
        .dark-mode .navbar { background: rgba(17, 24, 39, .9); }

        .nav-left { display: flex; align-items: center; gap: 16px; }
        .hamburger { font-size: 1.2rem; cursor: pointer; color: var(--muted); transition: color 0.2s; }
        .hamburger:hover { color: var(--accent); }

        .logo { font-weight: 800; font-size: 1.35rem; color: var(--accent); cursor: pointer; }
        .logo span { color: var(--text); }

        .sidebar { position: fixed; top: 14px; left: 14px; height: calc(100% - 28px); width: 0; overflow: hidden; transition: .35s ease; z-index: 1100; }
        .sidebar.open { width: 300px; }
        .sidebar .panel {
            width: 300px; height: 100%; padding: 26px 22px; background: var(--card);
            border: var(--border); border-radius: 18px; box-shadow: 12px 0 35px rgba(0, 0, 0, .12); position: relative;
        }
        .sidebar a {
            display: flex; align-items: center; gap: 14px; padding: 14px 16px; margin-bottom: 8px;
            border-radius: 14px; text-decoration: none; color: var(--text); font-weight: 500; transition: .25s ease;
        }
        .sidebar a:hover{
            background:var(--accent-soft);
            color:var(--accent);
            padding-left:22px;
            transform:translateX(4px);
        }

        .overlay { display: none; position: fixed; inset: 0; background: rgba(0, 0, 0, .35); z-index: 1050; }
        .overlay.show { display: block; }

        .page-wrap { max-width: 1200px; margin: auto; padding: 18px 24px 50px; }

        .profile-header-card {
            background: linear-gradient(135deg, var(--accent), #1e7e34);
            border-radius: 22px 22px 0 0;
            padding: 26px 34px;
            color: white;
            position: relative;
        }

        .main-content {
            background: var(--card);
            border: var(--border);
            border-top: none;
            border-radius: 0 0 22px 22px;
            padding: 40px;
            box-shadow: var(--shadow-sm);
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 40px;
        }

        .identity-col { text-align: center; border-right: var(--border); padding-right: 40px; }
        .profile-avatar-large {
            width: 96px; height: 96px; border-radius: 22px;
            background: var(--bg); margin: 0 auto 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.3rem; font-weight: 800; color: var(--accent); border: var(--border);
        }

        .form-group { margin-bottom: 24px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; font-size: 0.85rem; color: var(--muted); text-transform: uppercase; }
        .form-group input, .form-group textarea {
            width: 100%; padding: 14px; border: var(--border); border-radius: 14px;
            background: var(--bg); color: var(--text); font-family: inherit; font-size: 1rem;
            transition: all 0.3s ease;
        }
        .form-group input:focus, .form-group textarea:focus {
            outline: none; border-color: var(--accent); background: var(--card);
            box-shadow: 0 0 0 4px var(--accent-soft);
        }

        .btn-save {
            background: var(--accent); color: white; border: none; padding: 16px;
            border-radius: 14px; font-weight: 700; cursor: pointer; transition: all .3s ease;
            width: 100%; font-size: 1.1rem; display: flex; align-items: center; justify-content: center; gap: 10px;
        }

       .user-chip {
            display: inline-flex; align-items: center; gap: 8px; padding: 4px 10px 4px 8px;
            border-radius: 999px; background: rgba(15,23,42,.05); border: var(--border); height: 38px;
        }
        .dark-mode .user-chip { background: rgba(255,255,255,.06); }

        .profile-icon {
            width: 42px; height: 42px; border-radius: 12px;
            background: linear-gradient(135deg, #28a745, #34d058);
            color: white; display: flex; align-items: center; justify-content: center;
            font-weight: 700; cursor: pointer;
        }

        .dropdown-content {
            display: none; position: absolute; right: 0; top: 56px; min-width: 180px;
            background: var(--card); border: var(--border); border-radius: 14px; box-shadow: var(--shadow-md);
        }
        .dropdown-content.show { display: block; }
        .dropdown-content a { display: block; padding: 14px 16px; color: var(--text); text-decoration: none; font-weight: 500; }
        .dropdown-content a:hover { background: var(--accent-soft); color: var(--accent); padding-left: 20px; }

        button, .btn-save, .profile-icon, .user-chip, .theme-toggle {
            transition: transform .18s ease, box-shadow .18s ease, filter .18s ease;
        }
        button:hover, .btn-save:hover, .profile-icon:hover { transform: translateY(-2px); box-shadow: 0 10px 22px rgba(0,0,0,.12); }
        button:active, .profile-icon:active { transform: translateY(0px) scale(.97); }

        @media (max-width: 850px) {
            .main-content { grid-template-columns: 1fr; }
            .identity-col { border-right: none; border-bottom: var(--border); padding-bottom: 30px; }
        }
    </style>
</head>

<body>

<div id="mySidebar" class="sidebar">
    <div class="panel">
        <div class="logo" style="margin-bottom: 30px; display: flex; align-items: center; gap: 12px;">
            <i class="fas fa-leaf" style="background: var(--accent); color: white; padding: 10px; border-radius: 12px;"></i>
            <span>ECO<strong>TRACK</strong></span>
        </div>
        <a href="/investor/dashboard"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="#"><i class="fas fa-rocket"></i> My Startups</a>
        <a href="/investor/profile" style="background: var(--accent-soft); color: var(--accent);"><i class="fas fa-user"></i> Settings</a>
        <a href="/contact"><i class="fas fa-comment-dots"></i> Support</a>
        <div style="position: absolute; bottom: 30px; left: 22px; color: var(--muted); font-size: 0.8rem;">
            © <span id="year"></span> EcoTrack
        </div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeNav()"></div>

<header class="navbar">
    <div class="nav-left">
        <i class="fas fa-bars hamburger" onclick="openNav()"></i>
        <div class="logo" onclick="location.href='/investor/dashboard'">ECO<span>TRACK</span></div>
    </div>
    <div class="nav-right" style="display:flex; align-items:center; gap:16px;">
        <div class="user-chip">
            <button class="theme-toggle" onclick="toggleTheme()" style="background:none; border:none; color:var(--muted); cursor:pointer;">
                <i class="fas fa-moon" id="themeIcon"></i>
            </button>
            <div style="font-size:.88rem; color:var(--muted); font-weight:450; white-space:nowrap;">
                Welcome, <strong>${investor.investorName}</strong>
            </div>
        </div>
        <div class="dropdown" style="position:relative;">
            <div id="navAvatar" class="profile-icon" onclick="toggleDropdown()">I</div>
            <div id="myDropdown" class="dropdown-content">
                <a href="/investor/profile">Profile</a>
                <a href="/logout">Logout</a>
            </div>
        </div>
    </div>
</header>

<div class="page-wrap">
    <div class="profile-header-card">
        <h2 style="font-size: 1.8rem; font-weight: 800;">Investor Settings</h2>
        <p style="opacity: 0.9;">Manage your investment profile and preferences</p>
    </div>

    <div class="main-content">
        <div class="identity-col">
            <div class="profile-avatar-large" id="bigAvatar">I</div>
            <h3>${investor.investorName}</h3>
            <span style="background: var(--accent-soft); color: var(--accent); padding: 5px 15px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">
                INVESTOR ACCOUNT
            </span>
            <div style="margin-top: 25px; text-align: left;">
                <p style="font-size: 0.85rem; margin-bottom: 8px;"><i class="fas fa-envelope" style="margin-right:8px; color:var(--accent)"></i> ${investor.email}</p>
                <p style="font-size: 0.85rem;"><i class="fas fa-check-circle" style="margin-right:8px; color:var(--accent)"></i> Status: Active</p>
            </div>
        </div>

        <div class="form-col">
            <c:if test="${not empty message}"><div style="padding:14px; border-radius:12px; background:#d4edda; color:#155724; margin-bottom:20px; font-weight:600;">${message}</div></c:if>

            <form action="/investor/profile/save" method="post">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="investorName" value="${investor.investorName}" required>
                </div>
                <div class="form-group">
                    <label>Professional Bio</label>
                    <textarea name="bio" rows="3" required>${investor.bio}</textarea>
                </div>
                <div class="form-group">
                    <label>Investment Preferences</label>
                    <textarea name="investmentPreferences" rows="5" required>${investor.investmentPreferences}</textarea>
                </div>
                <button type="submit" class="btn-save">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    function openNav() { document.getElementById("mySidebar").classList.add("open"); document.getElementById("overlay").classList.add("show"); }
    function closeNav() { document.getElementById("mySidebar").classList.remove("open"); document.getElementById("overlay").classList.remove("show"); }
    function toggleDropdown() { document.getElementById("myDropdown").classList.toggle("show"); }

    window.addEventListener("click", (e) => { if(!e.target.closest(".dropdown")) document.getElementById("myDropdown").classList.remove("show"); });

    function toggleTheme() {
        const icon = document.getElementById("themeIcon");
        icon.classList.add('icon-pulse');
        setTimeout(() => icon.classList.remove('icon-pulse'), 400);
        const isDark = document.documentElement.classList.toggle("dark-mode");
        localStorage.setItem("theme", isDark ? "dark" : "light");
        updateThemeUI();
    }

    function updateThemeUI() {
        const isDark = document.documentElement.classList.contains("dark-mode");
        document.getElementById("themeIcon").className = isDark ? "fas fa-sun" : "fas fa-moon";
    }

    document.addEventListener('DOMContentLoaded', () => {
        document.getElementById("year").textContent = new Date().getFullYear();
        if (localStorage.getItem("theme") === "dark") document.documentElement.classList.add("dark-mode");
        updateThemeUI();

        const name = "${investor.investorName}";
        if(name && name.trim().length > 0) {
            const initial = name.trim().charAt(0).toUpperCase();
            document.getElementById("navAvatar").textContent = initial;
            document.getElementById("bigAvatar").textContent = initial;
        }
    });
</script>
</body>
</html>