<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Apply for Investment</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root{
            --accent:#28a745;
            --accent-soft:rgba(40,167,69,.12);
            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:1px solid rgba(15,23,42,.08);
            --shadow:0 22px 40px rgba(0,0,0,.12);
        }

        .dark-mode{
            --bg:#0b1220;
            --card:#111827;
            --text:#e5e7eb;
            --muted:#9ca3af;
            --border:1px solid rgba(255,255,255,.08);
            --accent:#22c55e;
            --accent-soft:rgba(34,197,94,.15);
        }

        .dark-mode .navbar{
            background:rgba(17,24,39,.85);
        }

        .dark-mode .back-btn{
            background:rgba(255,255,255,.06);
        }

        .dark-mode .back-btn:hover{
            background:rgba(40,167,69,.18);
        }

        .dark-mode label{
            color:#d1d5db;
        }

        .dark-mode input,
        .dark-mode select,
        .dark-mode textarea{
            background:#1f2937;
            color:#e5e7eb;
            border:1px solid rgba(255,255,255,.08);
        }

        .dark-mode input::placeholder,
        .dark-mode textarea::placeholder{
            color:#6b7280;
        }

        .dark-mode input:focus,
        .dark-mode select:focus,
        .dark-mode textarea:focus{
            border-color:#22c55e;
            box-shadow:0 0 0 3px rgba(34,197,94,.25);
        }

        .dark-mode .btn{
            background:#22c55e;
        }

        .dark-mode .btn:hover{
            background:#16a34a;
        }

        .dark-mode body{
            background:radial-gradient(circle at top, #0f172a, #0b1220);
        }

        *{box-sizing:border-box}

        body{
            font-family:'Poppins',sans-serif;
            background:var(--bg);
            margin:0;
            padding-top:96px;
        }

        .page-wrap{
            max-width:900px;
            margin:auto;
            padding:0 24px 60px;
        }

        .summary-card{
            background:var(--card);
            border:var(--border);
            border-radius:24px;
            padding:36px;
            box-shadow:0 10px 30px rgba(0,0,0,.25);
            transition:.25s ease;
        }

        .summary-card:hover{
            box-shadow:0 20px 40px rgba(0,0,0,.12);
        }

        @keyframes fadeUp{
            from{opacity:0;transform:translateY(20px)}
            to{opacity:1;transform:translateY(0)}
        }

        .header{
            margin-bottom:28px;
        }

        .header h2{
            font-weight:800;
            color:var(--accent);
            margin-bottom:6px;
        }

        .header p{
            color:var(--muted);
            font-size:.95rem;
        }

        .startup-chip{
            display:inline-block;
            margin-top:10px;
            padding:8px 16px;
            border-radius:999px;
            background:var(--accent-soft);
            color:var(--accent);
            font-weight:600;
            font-size:.8rem;
        }

        .form-group{
            margin-bottom:18px;
        }

        label{
            font-weight:600;
            font-size:.85rem;
        }

        input, select, textarea{
            width:100%;
            margin-top:6px;
            padding:12px 14px;
            border-radius:12px;
            border:var(--border);
            font-size:.9rem;
            transition:.25s ease;
        }

        input:focus, select:focus, textarea:focus{
            outline:none;
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(40,167,69,.2);
        }

        textarea{resize:none}

        .grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:16px;
        }

        .btn{
            width:100%;
            margin-top:24px;
            padding:14px;
            border:none;
            border-radius:14px;
            background:var(--accent);
            color:white;
            font-weight:700;
            font-size:1rem;
            cursor:pointer;
            transition:all .25s ease;
            box-shadow:0 6px 14px rgba(0,0,0,.12);
        }

        .btn:hover{
            transform:translateY(-2px) scale(1.01);
            box-shadow:0 14px 30px rgba(0,0,0,.18);
        }

        .btn:active{
            transform:translateY(0) scale(0.99);
            box-shadow:0 4px 10px rgba(0,0,0,.12);
        }


        .toast{
            position:fixed;
            bottom:24px;
            right:24px;
            background:#0f172a;
            color:white;
            padding:14px 18px;
            border-radius:14px;
            display:flex;
            align-items:center;
            gap:10px;
            font-weight:600;
            box-shadow:0 20px 40px rgba(0,0,0,.3);
            z-index:999;
        }

        .navbar{
            position:fixed;
            top:14px;
            left:14px;
            right:14px;
            height:68px;
            padding:0 26px;
            background:rgba(255,255,255,.85);
            backdrop-filter:blur(14px);
            border:1px solid rgba(0,0,0,.06);
            border-radius:18px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            z-index:1000;
        }

        .navbar-left{
            display:flex;
            align-items:center;
            gap:22px;
        }

        .logo{
            font-weight:800;
            font-size:1.35rem;
            color:var(--accent);
        }

        .logo span{
            color:var(--text);
        }

        .back-btn{
            display:flex;
            align-items:center;
            gap:8px;
            padding:8px 14px;
            border-radius:10px;
            font-weight:600;
            font-size:.85rem;
            text-decoration:none;
            color:var(--text);
            background:rgba(0,0,0,.05);
            transition:.2s ease;
        }

        .back-btn:hover{
            background:var(--accent-soft);
            color:var(--accent);
            transform:translateY(-2px);
        }

        .navbar-right{
            display:flex;
            align-items:center;
            gap:16px;
        }

        .profile-icon{
            width:42px;
            height:42px;
            border-radius:12px;
            background:linear-gradient(135deg,var(--accent),#34d058);
            color:white;
            display:flex;
            align-items:center;
            justify-content:center;
            font-weight:700;
        }

        .theme-toggle{
            width:40px;
            height:40px;
            border-radius:10px;
            border:none;
            background:transparent;
            font-size:1.1rem;
            cursor:pointer;
            color:var(--muted);
            display:flex;
            align-items:center;
            justify-content:center;
            transition:.25s ease;
        }

        .theme-toggle:hover{
            transform:rotate(-12deg) scale(1.1);
            color:var(--accent);
        }
    </style>
</head>

<body>

<header class="navbar">
    <div class="navbar-left">
        <div class="logo">
            ECO <span>TRACK</span>
        </div>

        <a href="/investor/dashboard/${investor.id}" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Dashboard
        </a>
    </div>

    <div class="navbar-right">

        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn">
            <i class="fas fa-moon"></i>
        </button>

        <div class="profile-icon">
            ${investor.investorName.charAt(0)}
        </div>

    </div>
</header>

  <div class="page-wrap">
    <div class="summary-card">

    <div class="header">
        <h2>Apply for Investment</h2>
        <p>You’re applying to invest in a startup. Clear intent improves response chances.</p>
        <span class="startup-chip">${startup.name}</span>
    </div>


    <form action="/investor/submit-investment-request" method="post">


        <input type="hidden" name="startupId" value="${startup.id}">
        <input type="hidden" name="investorId" value="${investor.id}">

        <div class="grid">
            <div class="form-group">
                <label>Investment Amount <span style="color:#dc2626">*</span></label>
                <input type="number" name="amount" required step="1000" min="1000" placeholder="e.g. 50000">
            </div>

            <div class="form-group">
                <label>Funding Stage</label>
                <select name="fundingStage" required>
                    <option value="">Select stage</option>
                    <option value="Seed">Seed</option>
                    <option value="Pre-Series A">Pre-Series A</option>
                    <option value="Series A">Series A</option>
                    <option value="Growth">Growth</option>
                </select>
            </div>
        </div>

        <div class="grid">
            <div class="form-group">
                <label>Expected ROI (%) <span style="color:#dc2626">*</span></label>
                <input type="number" name="expectedRoi" required placeholder="e.g. 20">
            </div>

            <div class="form-group">
                <label>Investment Horizon (years) <span style="color:var(--muted)">(optional)</span></label>
                <input type="number" name="horizon" placeholder="e.g. 5">
            </div>
        </div>

        <div class="form-group">
            <label>Message to Startup <span style="color:#dc2626">*</span></label>
            <textarea name="message" rows="4" required
                      placeholder="Add a short note, expectations, or strategic value you bring"></textarea>
        </div>

        <p style="font-size:.8rem;color:var(--muted);margin-top:8px">
            <span style="color:#dc2626">*</span> Required fields — helps startups evaluate serious investment intent.
        </p>

        <button type="submit" class="btn">
            <i class="fas fa-paper-plane"></i> Submit Application
        </button>

    </form>
    </div>
</div>


<c:if test="${investmentSuccess}">
    <div class="toast">
        <i class="fas fa-check-circle" style="color:#22c55e"></i>
        Investment request sent successfully
    </div>

    <script>
        setTimeout(() => {
            window.location.href = "/investor/dashboard";
        }, 1000);
    </script>
</c:if>

<script>
    function setTheme(theme){
        document.documentElement.classList.toggle('dark-mode', theme === 'dark');
        localStorage.setItem('theme', theme);

        const icon = document.querySelector('#themeToggleBtn i');
        if(icon){
            icon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
        }
    }

    function toggleTheme(){
        const isDark = document.documentElement.classList.contains('dark-mode');
        setTheme(isDark ? 'light' : 'dark');
    }

    (function(){
        const saved = localStorage.getItem('theme') || 'light';
        setTheme(saved);
    })();
</script>

</body>
</html>
