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
    <title>Contact | EcoTrack</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- SweetAlert -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root{
            --green:#28a745;
            --green-soft:rgba(40,167,69,.15);
            --bg:#f6f9f7;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:1px solid rgba(0,0,0,.06);
            --shadow:0 10px 30px rgba(0,0,0,.08);
        }

        *{box-sizing:border-box}
        html,body{
            margin:0;
            font-family:'Poppins',sans-serif;
            background:var(--bg);
            color:var(--text);
        }


        /* NAVBAR */
        .navbar {
            position: fixed;
            top: 14px;
            left: 14px;
            right: 14px;
            height: 68px;
            padding: 0 26px;
            background: rgba(255,255,255,.85);
            backdrop-filter: blur(14px);
            border: var(--border);
            border-radius: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000;
        }
        .dark-mode .navbar {
            background: rgba(17,24,39,.9);
        }
        .nav-left{display:flex;align-items:center;gap:14px}
        .hamburger{cursor:pointer;font-size:1.2rem;color:var(--muted)}
        .logo{
            display:flex;
            align-items:center;
            gap:10px;
            font-weight:800;
            color:var(--green);
        }
        .logo i{
            width:36px;height:36px;
            border-radius:10px;
            background:var(--green);
            color:#fff;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:.9rem;
        }
        .logo span{color:var(--text)}

        .nav-right{
            display:flex;
            align-items:center;
            gap:18px;
        }


        /* PROFILE */
        .profile-icon{
            width:42px;height:42px;
            border-radius:12px;
            background:var(--green);
            color:white;
            display:flex;
            align-items:center;
            justify-content:center;
            font-weight:700;
            cursor:pointer;
        }
        .profile-dropdown{position:relative}
        .dropdown-content{
            display:none;
            position:absolute;
            right:0;
            top:58px;

            min-width:180px;
            padding:6px;

            background:rgba(255,255,255,.85);
            backdrop-filter:blur(14px);

            border:var(--border);
            border-radius:16px;

            box-shadow:0 18px 40px rgba(0,0,0,.18);
        }

        .dark-mode .dropdown-content{
            background:rgba(17,24,39,.9);
        }

        .dropdown-content.show{
            display:block;
            animation:dropdownFade .18s ease;
        }

        .dropdown-content a{
            display:block;
            padding:11px 14px;
            border-radius:10px;
            font-weight:500;
            color:var(--text);
            text-decoration:none;
            transition:.18s ease;
        }

        .dropdown-content a:hover{
            background:var(--green-soft);
            color:var(--green);
            transform:translateX(3px);
        }

        @keyframes dropdownFade{
            from{opacity:0; transform:translateY(-6px) scale(.97);}
            to{opacity:1; transform:translateY(0) scale(1);}
        }


        /* SIDEBAR */
        /* ================= SIDEBAR ================= */

        .sidebar{
            position:fixed;
            top:14px;
            left:14px;
            height:calc(100% - 28px);
            width:0;
            overflow:hidden;
            transition:.35s cubic-bezier(.4,0,.2,1);
            z-index:1100;
        }

        .sidebar.open{
            width:300px;
        }

        .sidebar .panel{
            width:300px;
            height:100%;
            padding:26px 22px;

            background:linear-gradient(180deg,var(--card),rgba(255,255,255,.96));
            border:var(--border);
            border-radius:18px;
            box-shadow:12px 0 35px rgba(0,0,0,.12);
        }

        .dark-mode .sidebar .panel{
            background:linear-gradient(180deg,var(--card),rgba(17,24,39,.95));
        }

        .sidebar a{
            display:flex;
            align-items:center;
            gap:14px;
            padding:14px 16px;
            margin-bottom:8px;
            border-radius:14px;
            text-decoration:none;
            color:var(--text);
            font-weight:500;
            position:relative;
            transition:.25s ease;
        }

        .sidebar a::before{
            content:"";
            position:absolute;
            left:0;
            top:50%;
            transform:translateY(-50%);
            width:4px;
            height:0;
            background:var(--green);
            border-radius:4px;
            transition:.25s ease;
        }

        .sidebar a:hover::before{
            height:60%;
        }

        .sidebar a:hover{
            background:var(--green-soft);
            color:var(--green);
            padding-left:22px;
        }

        .overlay{
            display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,.35);
            z-index:1050;
        }
        .overlay.show{display:block}

        /* PAGE */
        body{
            padding-top:72px;
        }

        .page-wrap{
            max-width:1400px;
            margin:auto;
            padding:12px 24px 24px 24px;
        }

        .contact-card{
            background:var(--card);
            border:var(--border);
            border-radius:22px;
            padding:28px;
            box-shadow:var(--shadow);
        }

        /* FORM */
        .form-group{margin-bottom:20px}
        label{font-weight:600;font-size:.9rem}
        input,textarea{
            width:100%;
            padding:12px 14px;
            border-radius:12px;
            border:var(--border);
            font-size:.95rem;
        }
        input:focus,textarea:focus{
            border-color:var(--green);
            outline:none;
            box-shadow:0 0 0 3px var(--green-soft);
        }
        textarea{min-height:110px;resize:vertical}

        .btn-submit{
            width:100%;
            margin-top:12px;
            padding:14px;
            border:none;
            border-radius:999px;
            background:var(--green);
            color:white;
            font-weight:700;
            font-size:1rem;
            cursor:pointer;
            transition:.25s ease;
        }
        .btn-submit:hover{
            transform:translateY(-1px);
            box-shadow:0 8px 20px rgba(40,167,69,.35);
        }

        @media(max-width:600px){
            .contact-card{padding:28px}
        }

        @keyframes pulsePop {
            0%{transform:scale(1)}
            40%{transform:scale(1.25)}
            100%{transform:scale(1)}
        }
        .icon-pulse{animation:pulsePop .35s ease}


        /* ===== DASHBOARD SUPPORT PAGE ===== */

        .header-section{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:10px;
        }

        .industry-tag{
            background:var(--green-soft);
            color:var(--green);
            padding:6px 14px;
            border-radius:20px;
            font-size:.75rem;
            font-weight:700;
        }

        .support-info-card,
        .contact-card{
            transition:.25s ease;
        }

        .support-info-card:hover,
        .contact-card:hover{
            transform:translateY(-4px);
            box-shadow:0 18px 34px rgba(0,0,0,.12);
        }


        /* identity chip */
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
            background:transparent;
        }

        .welcome-text{
            font-size:.88rem;
            color:var(--muted);
            font-weight:450;
            white-space:nowrap;
        }

        .user-chip .theme-toggle{
            font-size:1rem;
            padding:6px;
            border-radius:10px;
            transition:.2s ease;
        }

        /* layout */
        .support-layout{
            display:grid;
            grid-template-columns:320px 1fr;
            gap:28px;
        }


        .support-info-card{
            background:var(--card);
            border:var(--border);
            border-radius:22px;
            padding:26px;
            box-shadow:var(--shadow);
        }

        .support-info-card ul{
            margin-top:18px;
            list-style:none;
            padding:0;
        }

        .support-info-card li{
            display:flex;
            align-items:center;
            gap:10px;
            padding:8px 0;
            color:var(--muted);
        }

        .support-info-card i{color:var(--green);}

        .contact-card{
            padding:28px;
            border-radius:22px;
        }

        .btn-primary{
            background:var(--green);
            color:white;
            border:none;
            padding:12px 20px;
            border-radius:10px;
            font-weight:600;
            cursor:pointer;
        }

        @media(max-width:900px){
            .support-layout{grid-template-columns:1fr}
        }

        .theme-toggle{
            background:none;
            border:none;
            font-size:1.05rem;
            cursor:pointer;
            color:var(--muted);
            transition:.2s ease;
            padding:6px 8px;
            border-radius:10px;
        }

        .theme-toggle:hover{
            color:var(--green);
            transform:translateY(-1px) scale(1.06);
            filter:drop-shadow(0 2px 6px rgba(40,167,69,.25));
        }


        .theme-toggle:active{
            transform:scale(.92);
        }

        .theme-toggle i{
            transition:.25s ease;
        }

        .theme-toggle:hover i{
            transform:rotate(-15deg) scale(1.08);
        }

        .dark-mode{
            --bg:#0b1220;
            --card:#111827;
            --text:#e5e7eb;
            --muted:#9ca3af;
            --border:1px solid rgba(255,255,255,.08);
        }


    </style>
</head>

<body>

<!-- SIDEBAR -->
<div id="mySidebar" class="sidebar">
    <div class="panel">

        <div class="sidebar-logo">
            <i class="fas fa-leaf"></i> ECO<span>TRACK</span>
        </div>

        <a href="/investor/dashboard/${investor.id}">
            <i class="fas fa-th-large"></i> Dashboard
        </a>
        <a href="/investor/profile">
            <i class="fas fa-user"></i> Profile
        </a>
        <a href="/contact">
            <i class="fas fa-headset"></i> Support
        </a>
        <a href="/logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>

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

        <div class="user-chip">
            <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn">
                <i class="fas fa-moon"></i>
            </button>
            <div class="welcome-text">Support Center</div>
        </div>

        <div class="profile-dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()">P</div>
            <div id="myDropdown" class="dropdown-content">
                <a href="/investor/profile">My Profile</a>
                <a href="/logout">Logout</a>
            </div>
        </div>
    </div>
</header>


<!-- CONTENT -->
<div class="page-wrap">

    <div class="header-section">
        <div>
            <p style="color:var(--muted)">Need help?</p>
            <h1>Contact Support</h1>
        </div>
        <span class="industry-tag">24h Response</span>
    </div>

    <div class="support-layout">

        <div class="support-info-card">
            <h3><i class="fas fa-headset"></i> We’re here to help</h3>
            <p>Facing an issue with investments, chats, or verification?</p>

            <ul>
                <li><i class="fas fa-check-circle"></i> Platform usage help</li>
                <li><i class="fas fa-check-circle"></i> Account verification</li>
                <li><i class="fas fa-check-circle"></i> Report a startup/investor</li>
                <li><i class="fas fa-check-circle"></i> Technical problems</li>
            </ul>
        </div>

        <div class="contact-card">
            <form action="/contact" method="post">

                <div class="form-group">
                    <label>Your Name</label>
                    <input type="text" name="name" required>
                </div>

                <div class="form-group">
                    <label>Your Email</label>
                    <input type="email" name="email" required>
                </div>

                <div class="form-group">
                    <label>Your Message</label>
                    <textarea name="message" required></textarea>
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-paper-plane"></i> Send Message
                </button>

            </form>
        </div>

    </div>
</div>

<!-- SCRIPTS -->
<script>
    document.addEventListener("DOMContentLoaded", function () {

        <% if (request.getAttribute("successMessage") != null) { %>
        Swal.fire({
            icon: 'success',
            title: 'Message Sent',
            text: '<%= request.getAttribute("successMessage") %>',
            confirmButtonColor: '#28a745',
            timer: 3000,
            timerProgressBar: true
        });
        <% } %>

        <% if (request.getAttribute("errorMessage") != null) { %>
        Swal.fire({
            icon: 'error',
            title: 'Failed',
            text: '<%= request.getAttribute("errorMessage") %>',
            confirmButtonColor: '#dc3545'
        });
        <% } %>

        const investorName = "${investor != null ? investor.investorName : ''}";
        const startupName  = "${startup != null ? startup.name : ''}";
        const name = investorName || startupName;

        const icon = document.getElementById("profileIcon");
        if(name && icon){
            icon.textContent = name.trim().charAt(0).toUpperCase();
        }

    });

    function openNav(){
        document.getElementById("mySidebar").classList.add("open");
        document.getElementById("overlay").classList.add("show");
    }
    function closeNav(){
        document.getElementById("mySidebar").classList.remove("open");
        document.getElementById("overlay").classList.remove("show");
    }
    function toggleDropdown(){
        document.getElementById("myDropdown").classList.toggle("show");
    }
</script>

<script>
    function updateThemeIcon(){
        const icon=document.querySelector('.theme-toggle i');
        if(!icon) return;

        if(document.documentElement.classList.contains('dark-mode')){
            icon.classList.remove('fa-moon');
            icon.classList.add('fa-sun');
        }else{
            icon.classList.remove('fa-sun');
            icon.classList.add('fa-moon');
        }
    }

    function toggleTheme(){
        document.documentElement.classList.toggle("dark-mode");
        localStorage.setItem("theme",
            document.documentElement.classList.contains("dark-mode")?"dark":"light");
        updateThemeIcon();

        const icon=document.querySelector('.theme-toggle i');
        if(icon){
            icon.classList.remove('icon-pulse');
            void icon.offsetWidth;
            icon.classList.add('icon-pulse');
            setTimeout(()=>icon.classList.remove('icon-pulse'),400);
        }
    }


    document.addEventListener("DOMContentLoaded",()=>{
        const saved=localStorage.getItem("theme");
        if(saved==="dark") document.documentElement.classList.add("dark-mode");
        updateThemeIcon();
    });
</script>


</body>
</html>
