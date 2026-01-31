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
    <title>Investor Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* ================= THEME ================= */
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
            transition:.3s ease;
        }

        /* ================= NAVBAR ================= */
        .navbar{
            position:fixed;
            top:14px;left:14px;right:14px;
            height:68px;
            padding:0 26px;
            background:rgba(255,255,255,.85);
            backdrop-filter:blur(14px);
            border:var(--border);
            border-radius:18px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            z-index:1000;
        }
        .dark-mode .navbar{background:rgba(17,24,39,.9)}

        .nav-left{display:flex;align-items:center;gap:16px}
        .logo{font-weight:800;font-size:1.35rem;color:var(--accent)}
        .logo span{color:var(--text)}
        .hamburger{font-size:1.2rem;cursor:pointer;color:var(--muted)}

        .nav-right{display:flex;align-items:center;gap:18px}
        .theme-toggle{background:none;border:none;font-size:1.1rem;cursor:pointer;color:var(--muted);transition:transform .2s ease,color .2s ease,filter .2s ease;border-radius:10px}
        .theme-toggle:hover{transform:translateY(-1px) scale(1.06);color:var(--accent);filter:drop-shadow(0 2px 6px rgba(40,167,69,.25))}
        .theme-toggle:active{transform:scale(0.92)}
        .theme-toggle i{transition:transform .25s ease}
        .theme-toggle:hover i{transform:rotate(-15deg) scale(1.08)}
        @keyframes pulsePop{0%{transform:scale(1)}40%{transform:scale(1.25)}100%{transform:scale(1)}}
        .icon-pulse{animation:pulsePop .35s ease}
        @media (prefers-reduced-motion: reduce){.theme-toggle,.theme-toggle i{transition:none !important}.theme-toggle:hover,.theme-toggle:active{transform:none !important;filter:none !important}.icon-pulse{animation:none !important}}

        .profile-icon{
            width:42px;height:42px;border-radius:12px;
            background:linear-gradient(135deg,var(--accent),#34d058);
            color:white;display:flex;align-items:center;justify-content:center;
            font-weight:700;cursor:pointer;
        }

        /* ================= DROPDOWN ================= */
        .dropdown{position:relative}
        .dropdown-content{
            display:none;position:absolute;right:0;top:56px;
            min-width:180px;background:var(--card);
            border:var(--border);border-radius:14px;
            box-shadow:var(--shadow-md);overflow:hidden;
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{
            display:block;padding:14px 16px;text-decoration:none;
            color:var(--text);font-weight:500;
        }
        .dropdown-content a:hover{
            background:var(--accent-soft);color:var(--accent);
        }

        /* ================= SIDEBAR ================= */
        .sidebar{
            position:fixed;top:14px;left:14px;
            height:calc(100% - 28px);
            width:0;overflow:hidden;
            transition:.35s cubic-bezier(.4,0,.2,1);
            z-index:1100;
        }
        .sidebar.open{width:300px}

        .sidebar .panel{
            width:300px;height:100%;
            padding:26px 22px;
            background:linear-gradient(180deg,var(--card),rgba(255,255,255,.96));
            border:var(--border);border-radius:18px;
            box-shadow:12px 0 35px rgba(0,0,0,.12);
            position:relative;
        }
        .dark-mode .sidebar .panel{
            background:linear-gradient(180deg,var(--card),rgba(17,24,39,.95));
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
            position:relative;transition:.25s ease;
        }
        .sidebar a::before{
            content:"";position:absolute;left:0;top:50%;
            transform:translateY(-50%);
            width:4px;height:0;background:var(--accent);
            border-radius:4px;transition:.25s ease;
        }
        .sidebar a:hover::before{height:60%}
        .sidebar a:hover{
            background:var(--accent-soft);color:var(--accent);
            padding-left:22px;
        }

        .sidebar-footer{
            position:absolute;bottom:22px;left:22px;right:22px;
            text-align:center;font-size:.8rem;color:var(--muted);
        }

        /* ================= OVERLAY ================= */
        .overlay{
            display:none;position:fixed;inset:0;
            background:rgba(0,0,0,.35);z-index:1000;
        }
        .overlay.show{display:block}

        /* ================= PAGE ================= */
        .page-wrap{max-width:1400px;margin:auto;padding:24px}

        .header-section{
            display:flex;justify-content:space-between;
            align-items:flex-end;margin-bottom:32px;
        }
        .header-section h1{font-size:2rem}

        .controls-bar{
            background:var(--card);border:var(--border);
            border-radius:18px;padding:18px 24px;
            display:flex;gap:14px;box-shadow:var(--shadow-sm);
            margin-bottom:26px;
        }
        .btn-primary{
            background:var(--accent);color:white;
            border:none;padding:11px 22px;
            border-radius:10px;font-weight:600;
            cursor:pointer;text-decoration:none;
        }

        .filter-panel{
            background:var(--card);border:var(--border);
            border-radius:18px;overflow:hidden;
            max-height:0;transition:.4s ease;
            margin-bottom:26px;
        }
        .filter-panel.open{max-height:240px;padding:22px}

        /* Startup cards */
        .grid-container{
            display:grid;
            grid-template-columns:repeat(auto-fill,minmax(320px,1fr));
            gap:26px;
        }
        .startup-card{
            background:var(--card);border:var(--border);
            border-radius:22px;padding:26px;
            text-decoration:none;color:inherit;
            box-shadow:var(--shadow-sm);transition:.3s ease;
        }
        .startup-card:hover{
            transform:translateY(-12px);
            box-shadow:var(--shadow-md);
            border-color:var(--accent);
        }
        .industry-tag{
            background:var(--accent-soft);color:var(--accent);
            padding:6px 14px;border-radius:20px;
            font-size:.75rem;font-weight:700;
        }
        .startup-name{font-size:1.25rem;font-weight:700;margin:14px 0 8px}
        .startup-desc{color:var(--muted);font-size:.9rem;margin-bottom:18px}
        .stats-grid{
            display:grid;grid-template-columns:1fr 1fr;
            border-top:var(--border);padding-top:14px;
        }
        .stat-item span{font-size:.75rem;color:var(--muted)}
        .stat-item strong{color:var(--accent)}

        .dark-mode .startup-card{
            box-shadow:
                    0 0 0 1px rgba(255,255,255,.06),
                    0 22px 55px rgba(255,255,255,.10);
        }

        /* ================= NEWS ================= */
        .news-section{margin-top:60px}
        .news-header{
            font-size:1.5rem;margin-bottom:20px;
            border-left:5px solid var(--accent);
            padding-left:14px;
        }
        .news-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
            gap:22px;
        }
        .news-card{
            background:var(--card);
            border:var(--border);
            border-radius:18px;
            overflow:hidden;
            box-shadow:var(--shadow-sm);
            transition:.3s ease;
        }
        .news-card:hover{
            transform:translateY(-8px);
            box-shadow:var(--shadow-md);
            border-color:var(--accent);
        }
        .news-img{width:100%;height:160px;object-fit:cover}
        .news-content{padding:16px}
        .news-title{font-size:.95rem;font-weight:600}

        /* ================= RESPONSIVE ================= */
        @media(max-width:768px){
            .header-section{flex-direction:column;align-items:flex-start;gap:14px}
            .grid-container,.news-grid{grid-template-columns:1fr}
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div id="mySidebar" class="sidebar">
    <div class="panel">
        <div class="sidebar-logo">
            <i class="fas fa-leaf"></i>
            ECO<span>TRACK</span>
        </div>

        <a href="/investor/dashboard/${investor.id}">
            <i class="fas fa-th-large"></i> Dashboard
        </a>
        <a href="#"><i class="fas fa-chart-line"></i> Portfolio</a>
        <a href="/investor/profile"><i class="fas fa-cog"></i> Settings</a>
        <a href="/contact"><i class="fas fa-headset"></i> Support</a>

        <div class="sidebar-footer">
            © <span id="yearSpan"></span> EcoTrack
        </div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeNav()"></div>

<!-- NAVBAR -->
<header class="navbar">
    <div class="nav-left">
        <i class="fas fa-bars hamburger" onclick="openNav()"></i>
        <div class="logo">ECO<span>TRACK</span></div>
    </div>

    <div class="nav-right">
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn">
            <i class="fas fa-moon"></i>
        </button>
        <div class="dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()">P</div>
            <div id="myDropdown" class="dropdown-content">
                <a href="/investor/profile">Profile</a>
                <a href="/logout" class="logout-link">Logout</a>
            </div>
        </div>
    </div>
</header>

<!-- CONTENT -->
<div class="page-wrap">

    <div class="header-section">
        <div>
            <p style="color:var(--muted)">Welcome back,</p>
            <h1>${investor.investorName}</h1>
        </div>
        <span class="industry-tag">Verified Investor</span>
    </div>

    <div class="controls-bar">
        <a href="/investor/messages" class="btn-primary">
            <i class="fas fa-comment-dots" style="margin-right:8px"></i> Messages
        </a>
        <button class="btn-primary" style="background:#e2e8f0;color:#475569" onclick="toggleFilter()">
            <i class="fas fa-sliders-h" style="margin-right:8px"></i> Filters
        </button>
    </div>

    <div id="filterPanel" class="filter-panel">
        <form action="/investor/dashboard" method="get" style="display:flex;gap:14px;align-items:center">
            <input type="text" name="search" placeholder="Search startups..." value="${currentSearch}"
                   style="flex:2;padding:10px;border-radius:10px;border:var(--border)">
            <select name="industry" style="flex:1;padding:10px;border-radius:10px;border:var(--border)">
                <option value="">All Industries</option>
                <c:forEach var="ind" items="${industries}">
                    <option value="${ind}" ${ind eq currentIndustry ? 'selected' : ''}>${ind}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn-primary">Apply</button>
            <button type="button" class="btn-primary" style="background:#6c757d"
                    onclick="window.location.href='/investor/dashboard'">Reset</button>
        </form>
    </div>

    <c:if test="${not empty startups}">
        <div class="grid-container">
            <c:forEach var="startup" items="${startups}">
                <a href="/investor/startup/${startup.id}" class="startup-card">
                    <span class="industry-tag">${startup.industry}</span>
                    <h3 class="startup-name">${startup.name}</h3>
                    <p class="startup-desc">${startup.description}</p>
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span>Funding Ask</span>
                            <strong>$${startup.fundingAsk}</strong>
                        </div>
                        <div class="stat-item">
                            <span>Equity</span>
                            <strong>${startup.equityOffered}%</strong>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </c:if>

    <!-- NEWS SECTION -->
    <div class="news-section">
        <h3 class="news-header">Market Insights: ${newsTopic}</h3>

        <div class="news-grid">
            <c:forEach var="news" items="${newsList}" varStatus="status">
                <c:if test="${status.index < 4}">
                    <div class="news-card">
                        <img src="${news.imageUrl}" class="news-img"
                             onerror="this.src='https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=400&q=80'">
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
    document.addEventListener('DOMContentLoaded',()=>{
        document.getElementById("yearSpan").textContent=new Date().getFullYear();
        const name="${investor.investorName}";
        if(name)profileIcon.textContent=name.charAt(0).toUpperCase();
        // Apply saved theme on load
        const savedTheme = localStorage.getItem("theme");
        if(savedTheme === "dark"){
            document.documentElement.classList.add("dark-mode");
        }
        updateThemeIcon();
    });
    function openNav(){mySidebar.classList.add("open");overlay.classList.add("show")}
    function closeNav(){mySidebar.classList.remove("open");overlay.classList.remove("show")}
    function toggleDropdown(){myDropdown.classList.toggle("show")}
    function toggleFilter(){filterPanel.classList.toggle("open")}
    function updateThemeIcon(){
        var iconEl = document.querySelector('.theme-toggle i');
        if(!iconEl) return;
        if(document.documentElement.classList.contains('dark-mode')){
            iconEl.classList.remove('fa-moon');
            iconEl.classList.add('fa-sun');
        } else {
            iconEl.classList.remove('fa-sun');
            iconEl.classList.add('fa-moon');
        }
    }
    function toggleTheme(){
        document.documentElement.classList.toggle("dark-mode");
        localStorage.setItem("theme",
            document.documentElement.classList.contains("dark-mode")?"dark":"light");
        updateThemeIcon();
        // click pulse animation on icon
        var iconEl = document.querySelector('.theme-toggle i');
        if(iconEl){
            iconEl.classList.remove('icon-pulse');
            void iconEl.offsetWidth; // restart animation
            iconEl.classList.add('icon-pulse');
            setTimeout(function(){ iconEl.classList.remove('icon-pulse'); }, 400);
        }
    }
</script>

</body>
</html>
