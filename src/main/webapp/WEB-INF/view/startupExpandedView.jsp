<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Prevent caching of this page to fix the back button issue
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${startup.name} - Detailed View</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root{
            --accent:#28a745;
            --accent-soft:rgba(40,167,69,.12);
            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:1px solid rgba(15,23,42,.06);
            --shadow-sm:0 6px 14px rgba(0,0,0,.06);
            --shadow-md:0 22px 40px rgba(0,0,0,.10);
        }

        .dark-mode{
            --bg:#0b1220;
            --card:#111827;
            --text:#e5e7eb;
            --muted:#9ca3af;
            --border:1px solid rgba(255,255,255,.08);
        }

        *{box-sizing:border-box;margin:0;padding:0}
        body{
            font-family:'Poppins',sans-serif;
            background:var(--bg);
            color:var(--text);
            padding-top:90px;
            transition: background 0.3s ease;
        }

        /* ================= NAVBAR ================= */
        .navbar{
            position:fixed; top:14px; left:14px; right:14px;
            height:68px; padding:0 26px;
            background:rgba(255,255,255,.85);
            backdrop-filter:blur(14px);
            border:var(--border); border-radius:18px;
            display:flex; justify-content:space-between; align-items:center;
            z-index:1000;
        }
        .dark-mode .navbar{background:rgba(17,24,39,.9)}

        .nav-left{display:flex;align-items:center;gap:16px}
        .logo{font-weight:800;font-size:1.35rem;color:var(--accent)}
        .logo span{color:var(--text)}
        .hamburger{font-size:1.2rem;cursor:pointer;color:var(--muted)}

        .nav-right{display:flex;align-items:center;gap:18px}
        .theme-toggle{
            background:none; border:none; font-size:1.1rem; cursor:pointer;
            color:var(--muted); transition:0.2s; border-radius:10px;
        }
        .theme-toggle:hover{color:var(--accent); transform:scale(1.1)}

        .profile-icon{
            width:42px; height:42px; border-radius:12px;
            background:linear-gradient(135deg,var(--accent),#34d058);
            color:white; display:flex; align-items:center; justify-content:center;
            font-weight:700; cursor:pointer;
        }

        /* ================= SIDEBAR ================= */
        .sidebar{
            position:fixed; top:14px; left:14px; height:calc(100% - 28px);
            width:0; overflow:hidden; transition:.35s ease; z-index:1100;
        }
        .sidebar.open{width:300px}
        .sidebar .panel{
            width:300px; height:100%; padding:26px 22px;
            background:var(--card); border:var(--border); border-radius:18px;
            box-shadow:12px 0 35px rgba(0,0,0,.12);
        }
        .sidebar a{
            display:flex; align-items:center; gap:14px; padding:14px 16px;
            margin-bottom:8px; border-radius:14px; text-decoration:none;
            color:var(--text); font-weight:500; transition:.25s ease;
        }
        .sidebar a:hover{background:var(--accent-soft); color:var(--accent); padding-left:22px}

        .overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.35);z-index:1000}
        .overlay.show{display:block}

        /* ================= PAGE CONTENT ================= */
        .page-wrap{max-width:1000px; margin:auto; padding:24px}

        .header-section{
            display:flex; justify-content:space-between; align-items:center;
            margin-bottom:32px;
        }

        .industry-tag{
            background:var(--accent-soft); color:var(--accent);
            padding:6px 14px; border-radius:20px; font-size:.75rem; font-weight:700;
        }

        .card{
            background:var(--card); border:var(--border);
            border-radius:22px; padding:40px;
            box-shadow:var(--shadow-sm); transition:0.3s;
        }

        .action-bar{
            display:flex; gap:12px; margin-bottom:24px;
        }

        /* ================= BUTTONS ================= */
        .btn{
            padding:12px 24px; border-radius:12px; font-weight:600;
            cursor:pointer; text-decoration:none; display:inline-flex;
            align-items:center; transition:0.2s; border:none; gap:8px;
        }
        .btn-primary{
            background:var(--accent); color:white;
            box-shadow: 0 6px 16px rgba(40, 167, 69, 0.2);
        }
        .btn-primary:hover{opacity:0.9; transform:translateY(-2px)}

        .btn-muted{
            background:var(--accent-soft); color:var(--accent);
        }
        .btn-muted:hover{background:rgba(40,167,69,0.2)}

        /* ================= DETAILS ================= */
        .details-grid{
            display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap:24px; margin-top:30px;
        }
        .detail-box{
            padding:20px; border-radius:16px; background:var(--bg); border:var(--border);
        }
        .detail-box label{
            display:block; font-size:0.75rem; color:var(--muted);
            text-transform:uppercase; font-weight:700; margin-bottom:6px;
        }
        .detail-box span{ font-size:1.1rem; font-weight:600; }

        .description-box{ margin-top:30px; line-height:1.7; color:var(--text); opacity:0.9; }

        /* ================= ALERTS ================= */
        .alert{
            padding:16px; border-radius:14px; margin-bottom:24px; font-weight:600;
        }
        .alert-success{ background:#dcfce7; color:#166534; border:1px solid #bbf7d0; }
        .alert-danger{ background:#fee2e2; color:#991b1b; border:1px solid #fecaca; }

        .dropdown-content{
            display:none; position:absolute; right:0; top:56px;
            min-width:180px; background:var(--card);
            border:var(--border); border-radius:14px; box-shadow:var(--shadow-md);
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{ display:block; padding:14px 16px; color:var(--text); text-decoration:none; font-weight:500; }
        .dropdown-content a:hover{ background:var(--accent-soft); color:var(--accent); }

        @media(max-width:600px){
            .header-section{ flex-direction:column; align-items:flex-start; gap:16px; }
            .action-bar{ width:100%; flex-direction:column; }
            .btn{ width:100%; justify-content:center; }
        }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar">
    <div class="panel">
        <div class="logo" style="margin-bottom:30px">
            <i class="fas fa-leaf"></i> ECO<span>TRACK</span>
        </div>
        <a href="/investor/dashboard/${investor.id}"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="#"><i class="fas fa-rocket"></i> My Startups</a>
        <a href="/investor/profile"><i class="fas fa-user-circle"></i> Settings</a>
        <a href="/contact"><i class="fas fa-headset"></i> Support</a>

        <div style="position:absolute; bottom:24px; left:24px; color:var(--muted); font-size:0.8rem">
            © <span id="yearSpan"></span> EcoTrack
        </div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeNav()"></div>

<header class="navbar">
    <div class="nav-left">
        <i class="fas fa-bars hamburger" onclick="openNav()"></i>
        <div class="logo">ECO<span>TRACK</span></div>
    </div>

    <div class="nav-right">
        <button class="theme-toggle" onclick="toggleTheme()">
            <i class="fas fa-moon"></i>
        </button>
        <div class="welcome-msg" style="margin: 0 10px; font-weight:600; font-size:0.9rem">Hello, ${investor.investorName}</div>
        <div class="profile-dropdown" style="position:relative">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()">P</div>
            <div id="myDropdown" class="dropdown-content">
                <a href="/investor/profile">My Profile</a>
                <a href="/logout">Logout</a>
            </div>
        </div>
    </div>
</header>

<div class="page-wrap">

    <c:if test="${not empty message}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <div class="header-section">
        <div>
            <h1 style="font-size:2.2rem; font-weight:800">${startup.name}</h1>
            <p style="color:var(--muted)">Explore startup potential and funding details</p>
        </div>
        <span class="industry-tag">${startup.industry}</span>
    </div>

    <div class="card">
        <div class="action-bar">
            <a href="/investor/dashboard" class="btn btn-muted">
                <i class="fas fa-arrow-left"></i> Back to Feed
            </a>
            <form action="/investor/apply-for-investment" method="post" style="display:inline">
                <input type="hidden" name="startupId" value="${startup.id}">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-hand-holding-usd"></i> Apply for Investment
                </button>
            </form>
        </div>

        <div class="description-box">
            <h3 style="margin-bottom:12px">About the Venture</h3>
            <p>${startup.description}</p>
        </div>

        <div class="details-grid">
            <div class="detail-box">
                <label>Funding Goal</label>
                <span>${startup.fundingAsk}</span>
            </div>
            <div class="detail-box">
                <label>Equity Offered</label>
                <span>${startup.equityOffered}%</span>
            </div>
            <div class="detail-box">
                <label>Industry Segment</label>
                <span>${startup.industry}</span>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        if ("${investor.email}" === "") {
            window.location.href = "/login?message=You have been logged out.";
        }

        const yearSpan = document.getElementById('yearSpan');
        if (yearSpan) yearSpan.textContent = new Date().getFullYear();

        const name = "${investor.investorName}";
        if (name) document.getElementById("profileIcon").textContent = name.charAt(0).toUpperCase();

        const savedTheme = localStorage.getItem("theme") || 'light';
        if(savedTheme === "dark") document.documentElement.classList.add("dark-mode");
        updateThemeIcon();
    });

    function openNav(){
        document.getElementById("mySidebar").classList.add("open");
        document.getElementById("overlay").classList.add("show");
    }
    function closeNav(){
        document.getElementById("mySidebar").classList.remove("open");
        document.getElementById("overlay").classList.remove("show");
    }
    function toggleDropdown(){ document.getElementById("myDropdown").classList.toggle("show"); }

    window.onclick = function(event) {
        if (!event.target.matches('.profile-icon')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                if (dropdowns[i].classList.contains('show')) dropdowns[i].classList.remove('show');
            }
        }
    }

    function toggleTheme(){
        document.documentElement.classList.toggle("dark-mode");
        const isDark = document.documentElement.classList.contains("dark-mode");
        localStorage.setItem("theme", isDark ? "dark" : "light");
        updateThemeIcon();
    }

    function updateThemeIcon(){
        const icon = document.querySelector('.theme-toggle i');
        if(document.documentElement.classList.contains("dark-mode")){
            icon.className = 'fas fa-sun';
        } else {
            icon.className = 'fas fa-moon';
        }
    }
</script>

</body>
</html>