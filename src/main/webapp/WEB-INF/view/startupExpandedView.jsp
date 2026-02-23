<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>${startup.name} | EcoTrack</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

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
            background: linear-gradient(180deg,#f4fbf6 0%, #eef6f2 50%, #f7fafb 100%);
            color:var(--text);
            padding-top:96px;
        }
        .dark-mode body{
            background: linear-gradient(180deg,#071018 0%, #071417 100%);
        }


        .navbar{
            position:fixed;
            top:10px;
            left:10px;
            right:10px;
            height:64px;
            padding:0 22px;
            border-radius:16px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            z-index:1400;

            background:linear-gradient(180deg, rgba(255,255,255,0.70), rgba(255,255,255,0.62));
            backdrop-filter:blur(10px) saturate(120%);
            border:1px solid rgba(255,255,255,0.48);
            box-shadow:0 8px 28px rgba(12,17,38,0.06);
        }

        .dark-mode .navbar{
            background:linear-gradient(180deg, rgba(18,25,38,0.60), rgba(16,22,34,0.52));
            border:1px solid rgba(255,255,255,0.04);
        }


        .nav-left{display:flex;align-items:center;gap:16px}
        .logo{font-weight:800;font-size:1.35rem;color:var(--accent)}
        .logo span{color:var(--text)}
        .hamburger{font-size:1.2rem;cursor:pointer;color:var(--muted)}

        .nav-right{display:flex;align-items:center;gap:18px}
        .profile-icon{
            width:42px;height:42px;border-radius:12px;
            background:linear-gradient(135deg,var(--accent),#34d058);
            color:white;display:flex;align-items:center;justify-content:center;
            font-weight:700;
        }

        .sidebar{
            position:fixed;top:14px;left:14px;
            height:calc(100% - 28px);
            width:0;overflow:hidden;
            transition:.35s ease;
            z-index:1100;
        }
        .sidebar.open{width:300px}

        .sidebar .panel{
            width:300px;height:100%;
            padding:22px;
            position:relative;

            background:linear-gradient(180deg, rgba(255,255,255,0.72), rgba(255,255,255,0.55));
            backdrop-filter:blur(10px);
            border:1px solid rgba(255,255,255,0.45);
            border-radius:18px;
            box-shadow:6px 14px 32px rgba(12,17,38,0.12);
        }

        .dark-mode .sidebar .panel{
            background:linear-gradient(180deg, rgba(18,25,38,0.90), rgba(16,22,34,0.75));
            border:1px solid rgba(255,255,255,0.06);
        }


        .sidebar-logo{
            display:flex;align-items:center;gap:10px;
            font-size:1.45rem;font-weight:800;
            color:var(--accent);margin-bottom:28px;
        }
        .sidebar-logo i{
            background:var(--accent);color:white;
            width:38px;height:38px;border-radius:12px;
            display:flex;align-items:center;justify-content:center;
        }
        .sidebar-logo span{color:var(--text)}

        .sidebar a{
            display:flex;align-items:center;gap:14px;
            padding:14px 16px;margin-bottom:8px;
            border-radius:14px;text-decoration:none;
            color:var(--text);font-weight:500;
            transition:.25s ease;
        }
        .sidebar a:hover{
            background:var(--accent-soft);
            color:var(--accent);
            padding-left:22px;
        }

        .sidebar-footer{
            position:absolute;bottom:22px;left:22px;right:22px;
            text-align:center;font-size:.8rem;color:var(--muted);
        }

        .overlay{
            display:none;position:fixed;inset:0;
            background:rgba(0,0,0,.35);
            z-index:1000;
        }
        .overlay.show{display:block}

        .page-wrap{
            max-width:1300px;
            margin:0 auto;
            padding:18px;
            border-radius:24px;
            background:linear-gradient(180deg,#e9f5ee 0%, #f7fafb 70%);
        }

        .dark-mode .page-wrap{
            background:linear-gradient(180deg,#0d1f18 0%, #071417 70%);
        }


        .detail-header{
            display:flex;justify-content:space-between;align-items:flex-start;
            margin-bottom:28px;
        }

        .detail-header h1{font-size:2.2rem;font-weight:800}

        .industry-tag{
            background:var(--accent-soft);
            color:var(--accent);
            padding:8px 18px;
            border-radius:999px;
            font-size:.8rem;font-weight:700;
        }

        .card{
            background:linear-gradient(180deg, rgba(255,255,255,0.92), rgba(255,255,255,0.85));
            border:1px solid rgba(255,255,255,0.6);
            border-radius:24px;
            padding:42px;
            backdrop-filter:blur(6px);
            box-shadow:0 18px 50px rgba(12,17,38,0.08);
        }

        .dark-mode .card{
            background:rgba(18,25,38,0.88);
            border:1px solid rgba(255,255,255,0.08);
        }


        .action-bar{
            display:flex;gap:14px;margin-bottom:30px;
        }

        .btn{
            padding:12px 22px;
            border-radius:12px;
            font-weight:600;
            cursor:pointer;
            text-decoration:none;
            display:inline-flex;
            align-items:center;
            gap:8px;
        }

        .btn-muted{background:#e5e7eb;color:#111827}
        .btn-primary{
            background:var(--accent);
            color:white;
            box-shadow:0 8px 20px rgba(40,167,69,.35);
        }

        .section{margin-bottom:36px}
        .section h3{font-size:1.2rem;font-weight:800;margin-bottom:12px}
        .description{line-height:1.75;opacity:.9}

        .stats-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
            gap:22px;
        }

        .stat-card{
            background:linear-gradient(180deg, rgba(255,255,255,0.85), rgba(255,255,255,0.75));
            border:1px solid rgba(255,255,255,0.55);
            border-radius:18px;
            padding:22px;
            backdrop-filter:blur(4px);
            box-shadow:0 10px 22px rgba(12,17,38,0.06);
        }

        .dark-mode .stat-card{
            background:rgba(17,24,39,0.65);
            border:1px solid rgba(255,255,255,0.08);
        }

        .stat-card span{
            display:block;font-size:.75rem;color:var(--muted);
            text-transform:uppercase;font-weight:700;margin-bottom:6px;
        }
        .stat-card strong{
            font-size:1.25rem;font-weight:800;color:var(--accent);
        }

        .btn{
            transition:all .18s cubic-bezier(.2,.8,.2,1);
        }
        .btn:hover{
            transform:translateY(-2px);
        }
        .btn-primary:hover{
            box-shadow:0 14px 28px rgba(40,167,69,.35);
        }
        .btn-muted:hover{
            background:#dfe3e8;
        }

        .theme-toggle{
            cursor:pointer;
            border-radius:12px;
            padding:8px 12px;
            font-size:0.95rem;
            background:linear-gradient(180deg, rgba(255,255,255,.85), rgba(255,255,255,.65));
            border:1px solid rgba(255,255,255,.5);
            display:inline-flex;
            align-items:center;
            justify-content:center;
            box-shadow:0 6px 18px rgba(12,17,38,.08);
            backdrop-filter:blur(8px) saturate(120%);
            color:var(--muted);
            transition:
                    transform .18s cubic-bezier(.2,.8,.2,1),
                    box-shadow .18s ease,
                    color .18s ease,
                    background .18s ease;
        }


        .theme-toggle:hover{
            transform:translateY(-2px) scale(1.08);
            color:var(--accent);
            box-shadow:0 10px 26px rgba(40,167,69,.28);
        }


        .theme-toggle:active{
            transform:scale(.92);
            box-shadow:0 4px 12px rgba(0,0,0,.18);
        }

        .theme-toggle i{
            transition:transform .35s ease;
        }

        .theme-toggle:hover i{
            transform:rotate(-18deg) scale(1.1);
        }

        .dark-mode .theme-toggle{
            background:linear-gradient(180deg, rgba(17,24,39,.85), rgba(17,24,39,.65));
            border:1px solid rgba(255,255,255,.08);
            color:#d1d5db;
            box-shadow:0 6px 18px rgba(0,0,0,.45);
        }

        .dark-mode .theme-toggle:hover{
            color:#34d058;
            box-shadow:0 12px 28px rgba(0,0,0,.55);
        }

        @keyframes iconPulse{
            0%{transform:scale(1)}
            40%{transform:scale(1.35)}
            100%{transform:scale(1)}
        }

        .icon-pulse{
            animation:iconPulse .35s ease;
        }


    </style>
</head>

<body>

<div id="mySidebar" class="sidebar">
    <div class="panel">
        <div class="sidebar-logo">
            <i class="fas fa-leaf"></i>
            ECO<span>TRACK</span>
        </div>

        <a href="/investor/dashboard">
            <i class="fas fa-th-large"></i> Dashboard
        </a>
        <a href="#"><i class="fas fa-chart-line"></i> Portfolio</a>
        <a href="/investor/profile"><i class="fas fa-cog"></i> Settings</a>
        <a href="/contact"><i class="fas fa-headset"></i> Support</a>

        <div class="sidebar-footer">
            © EcoTrack
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

        <button class="theme-toggle" id="themeToggleBtn" onclick="toggleTheme()" aria-pressed="false">
            <i class="fas fa-moon"></i>
        </button>

        <div class="profile-icon">I</div>
    </div>

</header>


<div class="page-wrap">

    <div class="detail-header">
        <div>
            <h1>${startup.name}</h1>
            <p style="color:var(--muted)">Startup investment overview</p>
        </div>
        <span class="industry-tag">${startup.industry}</span>
    </div>

    <div class="card">

        <div class="action-bar">
            <a href="/investor/dashboard" class="btn btn-muted">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <a href="/investor/apply?startupId=${startup.id}" class="btn btn-primary">
                <i class="fas fa-hand-holding-usd"></i> Apply for Investment
            </a>
        </div>

        <div class="section">
            <h3>About the Startup</h3>
            <p class="description">${startup.description}</p>
        </div>

        <div class="section">
            <h3>Key Investment Metrics</h3>
            <div class="stats-grid">
                <div class="stat-card">
                    <span>Funding Ask</span>
                    <strong>$${startup.fundingAsk}</strong>
                </div>
                <div class="stat-card">
                    <span>Equity Offered</span>
                    <strong>${startup.equityOffered}%</strong>
                </div>
                <div class="stat-card">
                    <span>Industry</span>
                    <strong>${startup.industry}</strong>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    function openNav(){
        document.getElementById("mySidebar").classList.add("open");
        document.getElementById("overlay").classList.add("show");
    }
    function closeNav(){
        document.getElementById("mySidebar").classList.remove("open");
        document.getElementById("overlay").classList.remove("show");
    }
</script>

<script>
    function setTheme(theme){
        const html = document.documentElement;
        const btn = document.getElementById("themeToggleBtn");
        const icon = btn ? btn.querySelector("i") : null;

        if(theme === "dark"){
            html.classList.add("dark-mode");
            if(icon) icon.className = "fas fa-sun";
            if(btn) btn.setAttribute("aria-pressed","true");
        }else{
            html.classList.remove("dark-mode");
            if(icon) icon.className = "fas fa-moon";
            if(btn) btn.setAttribute("aria-pressed","false");
        }

        try{ localStorage.setItem("theme", theme); }catch(e){}
    }

    function toggleTheme(){
        const isDark = document.documentElement.classList.contains("dark-mode");
        setTheme(isDark ? "light" : "dark");

        const icon = document.querySelector("#themeToggleBtn i");
        if(icon){
            icon.classList.remove("icon-pulse");
            void icon.offsetWidth;
            icon.classList.add("icon-pulse");
            setTimeout(()=>icon.classList.remove("icon-pulse"),400);
        }
    }

    document.addEventListener("DOMContentLoaded", function(){
        const saved = (function(){
            try{return localStorage.getItem("theme");}
            catch(e){return null;}
        })() || "light";

        setTheme(saved);
    });
</script>


</body>
</html>
