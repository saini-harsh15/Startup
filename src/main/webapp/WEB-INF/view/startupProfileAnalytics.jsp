<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Investor Interest Insights</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>

        *{
            transition:
                    background .25s ease,
                    color .25s ease,
                    border-color .25s ease,
                    box-shadow .25s ease,
                    transform .18s ease;
        }
        :root{
            --accent:#28a745;
            --accent-soft:rgba(40,167,69,.12);
            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:1px solid rgba(15,23,42,.06);
        }

        .dark-mode{
            --bg:#0b1220;
            --card:#111827;
            --card-soft:#1f2937;
            --text:#e5e7eb;
            --muted:#9ca3af;
            --accent:#34d058;
            --accent-soft:rgba(52,208,88,.18);
            --border:1px solid rgba(255,255,255,.08);
        }
        body{
            font-family:"Segoe UI", Arial;
            background:var(--bg);
            color:var(--text);
            padding-top:100px;
            padding-left:40px;
            padding-right:40px;
        }

        h2{
            margin-bottom:30px;
            font-size:28px;
            font-weight:700;
        }

        /* CARD */
        .card{
            background:var(--card);
            border-radius:18px;
            padding:22px 28px;
            margin-bottom:18px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            border:var(--border);
            box-shadow:0 8px 22px rgba(0,0,0,.06);
        }

        .dark-mode .card{
            box-shadow:0 8px 30px rgba(0,0,0,.45);
        }

        .card:hover{
            transform:translateY(-6px);
            box-shadow:0 18px 40px rgba(0,0,0,.18);
        }

        .dark-mode .card:hover{
            box-shadow:0 20px 50px rgba(0,0,0,.7);
        }

        .metric .value{
            color:var(--text);
        }

        .metric .label{
            color:var(--muted);
        }

        /* LEFT */
        .identity{
            width:260px;
        }

        .name{
            font-weight:700;
            font-size:18px;
        }

        .type{
            color:#7a7a7a;
            font-size:13px;
        }

        /* CENTER METRICS */
        .metrics{
            display:flex;
            gap:60px;
        }

        .metric{
            text-align:center;
        }

        .metric .value{
            font-size:24px;
            font-weight:700;
        }

        .metric .label{
            font-size:12px;
            color:#888;
        }

        /* RIGHT */
        .right{
            text-align:right;
            min-width:220px;
        }

        /* temperature badges */
        .badge{
            display:inline-block;
            padding:6px 14px;
            border-radius:30px;
            font-weight:700;
            font-size:12px;
            margin-bottom:6px;
        }

        /* LIGHT THEME — stronger readable badges */
        .hot{
            background:#ffe3e3;
            color:#c92a2a;
            border:1px solid #ffc9c9;
        }

        .warm{
            background:#fff4e6;
            color:#e8590c;
            border:1px solid #ffd8a8;
        }

        .cold{
            background:#e7f5ff;
            color:#1864ab;
            border:1px solid #a5d8ff;
        }

        /* DARK THEME — keep soft glow */
        .dark-mode .hot{
            background:rgba(255,77,79,.18);
            color:#ff8787;
            border:1px solid rgba(255,77,79,.35);
        }

        .dark-mode .warm{
            background:rgba(255,169,77,.18);
            color:#ffa94d;
            border:1px solid rgba(255,169,77,.35);
        }

        .dark-mode .cold{
            background:rgba(77,171,247,.18);
            color:#74c0fc;
            border:1px solid rgba(77,171,247,.35);
        }

        /* hint text */
        .hint{
            font-size:13px;
            margin-bottom:12px;
            color:#666;
        }

        /* button */
        .btn{
            background:linear-gradient(135deg,var(--accent),#1f8f3d);
            color:white;
            padding:12px 20px;
            border-radius:10px;
            text-decoration:none;
            font-weight:600;
            display:inline-block;
            box-shadow:0 10px 25px rgba(0,0,0,.18);
        }

        .btn:hover{
            transform:translateY(-2px) scale(1.02);
            box-shadow:0 14px 32px rgba(0,0,0,.28);
        }

        .btn:active{
            transform:scale(.96);
        }

        .empty{
            background:white;
            padding:50px;
            border-radius:16px;
            color:#777;
        }

        /* ===== NAVBAR ===== */

        .navbar{
            position:fixed;
            top:14px;
            left:14px;
            right:14px;
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

        .dark-mode .navbar{
            background:rgba(17,24,39,.9);
        }

        .logo{
            font-weight:800;
            font-size:1.35rem;
            color:var(--accent);
        }

        .logo span{color:var(--text)}

        .nav-right{
            display:flex;
            align-items:center;
            gap:16px;
        }

        .theme-toggle{
            background:none;
            border:none;
            font-size:1.1rem;
            cursor:pointer;
            color:var(--muted);
        }

        .profile-icon{
            width:40px;
            height:40px;
            border-radius:12px;
            background:linear-gradient(135deg,var(--accent),#34d058);
            color:white;
            display:flex;
            align-items:center;
            justify-content:center;
            font-weight:700;
            cursor:pointer;
        }

        .theme-toggle:hover{
            color:var(--accent);
            transform:rotate(-12deg) scale(1.1);
        }

        .profile-icon:hover{
            transform:scale(1.08);
            box-shadow:0 6px 18px rgba(0,0,0,.25);
        }

    </style>
</head>

<body>

<header class="navbar">
    <div class="logo">ECO<span>TRACK</span></div>

    <div class="nav-right">

        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn">
            <i class="fas fa-moon"></i>
        </button>

        <div class="profile-icon" id="profileIcon">S</div>

    </div>
</header>

<h2>Investor Interest Insights</h2>

<c:choose>

    <c:when test="${empty analytics}">
        <div class="empty">
            No investors have viewed your startup yet.
        </div>
    </c:when>

    <c:otherwise>

        <!-- SORTING PRIORITY: HOT FIRST -->
        <c:forEach var="v" items="${analytics}">

            <div class="card">

                <!-- LEFT -->
                <div class="identity">
                    <div class="name">${v.investorName}</div>
                    <div class="type">${v.investorType}</div>
                </div>

                <!-- CENTER METRICS -->
                <div class="metrics">

                    <div class="metric">
                        <div class="value">${v.totalVisits}</div>
                        <div class="label">Visits</div>
                    </div>

                    <div class="metric">
                        <div class="value">${v.score}</div>
                        <div class="label">Interest</div>
                    </div>

                </div>

                <!-- RIGHT ACTION -->
                <div class="right">

                    <c:choose>

                        <c:when test="${v.temperature == 'HOT'}">
                            <div class="badge hot">HOT LEAD</div>
                            <div class="hint">Contact immediately — high conversion chance</div>
                        </c:when>

                        <c:when test="${v.temperature == 'WARM'}">
                            <div class="badge warm">WARM LEAD</div>
                            <div class="hint">Follow up soon — interested investor</div>
                        </c:when>

                        <c:otherwise>
                            <div class="badge cold">COLD LEAD</div>
                            <div class="hint">Low engagement — nurture later</div>
                        </c:otherwise>

                    </c:choose>

                    <a class="btn" href="/startup/chat?investorId=${v.investorId}">
                        Start Conversation
                    </a>

                </div>

            </div>

        </c:forEach>

    </c:otherwise>
</c:choose>

<script>
    document.addEventListener("DOMContentLoaded",()=>{
        const savedTheme = localStorage.getItem("theme");
        if(savedTheme==="dark"){
            document.documentElement.classList.add("dark-mode");
        }
        updateThemeIcon();
    });

    function toggleTheme(){
        document.documentElement.classList.toggle("dark-mode");
        localStorage.setItem("theme",
            document.documentElement.classList.contains("dark-mode")?"dark":"light"
        );
        updateThemeIcon();
    }

    function updateThemeIcon(){
        const icon=document.querySelector("#themeToggleBtn i");
        if(!icon) return;

        if(document.documentElement.classList.contains("dark-mode")){
            icon.classList.remove("fa-moon");
            icon.classList.add("fa-sun");
        }else{
            icon.classList.remove("fa-sun");
            icon.classList.add("fa-moon");
        }
    }
</script>

</body>
</html>
