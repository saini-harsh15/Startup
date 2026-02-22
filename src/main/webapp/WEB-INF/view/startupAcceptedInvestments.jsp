<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Accepted Investments</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root{
            --accent:#28a745;
            --accent-soft:rgba(40,167,69,.12);
            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:1px solid rgba(0,0,0,.06);
            --shadow-sm:0 6px 16px rgba(0,0,0,.06);
            --shadow-md:0 18px 40px rgba(0,0,0,.12);
        }

        *{box-sizing:border-box}

        body{
            font-family:'Poppins',sans-serif;
            background:var(--bg);
            color:var(--text);
            margin:0;
            padding-top:96px;
            transition:.25s ease;
        }

        /* ================= NAVBAR ================= */

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
            font-weight:800;
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
            cursor:pointer;
            transition:.2s ease;
        }

        .profile-icon:hover{
            transform:scale(1.08);
            box-shadow:0 8px 20px rgba(40,167,69,.4);
        }

        /* ================= PAGE WRAP ================= */

        .page-wrap{
            max-width:1200px;
            margin:auto;
            padding:0 24px 50px;
        }

        h2{
            font-size:1.6rem;
            margin-bottom:20px;
        }

        /* ================= SUMMARY ================= */

        .summary-card{
            background:var(--card);
            border:var(--border);
            border-radius:22px;
            padding:28px;
            box-shadow:var(--shadow-sm);
            margin-bottom:32px;
            transition:.25s ease;
        }

        .summary-card:hover{
            box-shadow:var(--shadow-md);
            transform:translateY(-4px);
        }

        .summary-label{
            font-size:.8rem;
            text-transform:uppercase;
            letter-spacing:.5px;
            font-weight:600;
            color:var(--muted);
        }

        .total-amount{
            font-size:2.3rem;
            font-weight:700;
            margin-top:6px;
            color:var(--accent);
        }

        /* ================= CARDS ================= */

        .investment-grid{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(320px,1fr));
            gap:24px;
        }

        .investment-card{
            background:var(--card);
            border:var(--border);
            border-radius:20px;
            padding:24px;
            box-shadow:var(--shadow-sm);
            transition:.25s ease;
        }

        .investment-card:hover{
            transform:translateY(-6px);
            box-shadow:var(--shadow-md);
        }

        .label{
            font-size:.72rem;
            text-transform:uppercase;
            letter-spacing:.4px;
            color:var(--muted);
            font-weight:600;
            margin-bottom:4px;
        }

        .value{
            font-weight:600;
            margin-bottom:14px;
        }

        .money{
            font-weight:700;
            letter-spacing:.3px;
            color:var(--accent);
        }

        .empty{
            background:var(--card);
            border:var(--border);
            border-radius:22px;
            padding:40px;
            text-align:center;
            color:var(--muted);
            box-shadow:var(--shadow-sm);
        }

        .chart-container {
            position: relative;
            height: 420px;
            max-width: 800px;   /* slightly smaller for perfect balance */
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .chart-center {
            position: absolute;
            inset: 0;                 /* THIS is the key */
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            pointer-events: none;
        }

        .center-label {
            font-size: 0.75rem;
            letter-spacing: 2px;
            color: var(--muted);
            margin-bottom: 6px;
        }

        .center-value {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--accent);
            line-height: 1.2;
        }

        /* ================= DARK MODE ================= */

        .dark-mode{
            --bg:#0f172a;
            --card:#111827;
            --text:#e5e7eb;
            --muted:#9ca3af;
            --border:1px solid rgba(255,255,255,.08);
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


        .overview-grid{
            display:grid;
            grid-template-columns: 1fr 2fr;
            gap:28px;
            margin-bottom:32px;
        }

        .overview-card{
            background:var(--card);
            border:var(--border);
            border-radius:24px;
            padding:32px;
            box-shadow:var(--shadow-sm);
            transition:.25s ease;
        }

        .overview-card:hover{
            transform:translateY(-4px);
            box-shadow:var(--shadow-md);
        }

        .big-amount{
            font-size:3rem;
            font-weight:800;
            color:var(--accent);
            margin-top:8px;
        }

        .verified{
            margin-top:12px;
            font-weight:500;
            color:var(--muted);
        }

        .verified i{
            color:var(--accent);
            margin-right:6px;
        }

        @media(max-width: 900px){
            .overview-grid{
                grid-template-columns:1fr;
            }
        }

        .capital-card{
            background: var(--card);
            border: 1px solid rgba(0,0,0,.06);

            display:flex;
            flex-direction:column;
            justify-content:center;
            align-items:center;      /* center horizontally */
            text-align:center;       /* center text */
            min-height:260px;
        }

        .summary-label{
            font-size:.78rem;
            text-transform:uppercase;
            letter-spacing:1px;
            font-weight:600;
            color:#94a3b8;   /* softer muted */
            margin-bottom: 6px;
        }

        .big-amount{
            font-size:3.2rem;
            font-weight:800;
            margin-top:10px;
            color:#16a34a;   /* deeper, richer green */
            letter-spacing:1px;
            margin-bottom: 6px 0;
        }

        .capital-card::after{
            content:"";
            display:block;
            height:1px;
            margin-top:22px;
            background:rgba(0,0,0,.05);
        }

        .verified{
            margin-top:18px;
            font-size:.95rem;
            font-weight:500;
            color:#64748b;  /* lighter muted */
            display:flex;
            align-items:center;
            gap:8px;
            margin-bottom: 10px;
        }

        .verified i{
            color:#22c55e;
        }

    </style>
</head>

<body>

<header class="navbar">
    <div class="navbar-left">
        <div class="logo">
            ECO <span>TRACK</span>
        </div>

        <a href="/startup/dashboard/${startup.id}" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Dashboard
        </a>
    </div>

    <div class="navbar-right">
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn">
            <i class="fas fa-moon"></i>
        </button>

        <div class="profile-icon">
            ${startup.name.charAt(0)}
        </div>
    </div>
</header>

<div class="page-wrap">

    <h2>Accepted Investments</h2>

    <div class="overview-grid">

        <!-- Capital Card -->
        <div class="overview-card capital-card">

            <div class="summary-label">Capital Raised</div>

            <div class="big-amount" id="capitalCounter">
                $0
            </div>

            <div class="verified">
                <i class="fas fa-check-circle"></i>
                Verified Funding
            </div>

        </div>

        <!-- Monthly Chart Card -->
        <div class="overview-card">
            <div class="summary-label">Monthly Inflow</div>
            <canvas id="monthlyChart" height="130"></canvas>
        </div>

    </div>


    <div class="summary-card">
        <div class="summary-label">Funding by Stage</div>

        <div class="chart-container">
            <canvas id="stageChart"></canvas>
            <div class="chart-center">
                <div class="center-label">Total</div>
                <div class="center-value" id="centerTotal">$0</div>
            </div>
        </div>
    </div>

    <c:if test="${empty acceptedRequests}">
        <div class="empty">
            <i class="fas fa-chart-line fa-2x"></i>
            <p style="margin-top:12px;">No accepted investments yet.</p>
        </div>
    </c:if>

    <div class="investment-grid">
        <c:forEach var="req" items="${acceptedRequests}">
            <div class="investment-card">

                <div class="label">Investor</div>
                <div class="value">${req.investorName}</div>

                <div class="label">Amount</div>
                <div class="value money">
                    $<fmt:formatNumber value="${req.amount}"
                                       type="number"
                                       groupingUsed="true"
                                       maxFractionDigits="0"/>
                </div>

                <div class="label">Date Accepted</div>
                <div class="value">${req.formattedDate}</div>

            </div>
        </c:forEach>
    </div>

</div>

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

<script>

    const months = ${chartMonthsJson};
    const totals = ${chartTotalsJson};
    const stageLabels = ${stageLabelsJson};
    const stageTotals = ${stageTotalsJson};

    // ===== Monthly Line Chart =====
    new Chart(document.getElementById('monthlyChart'), {
        type: 'line',
        data: {
            labels: months,
            datasets: [{
                label: 'Investment Growth',
                data: totals,
                borderColor: '#28a745',
                backgroundColor: 'rgba(40,167,69,0.15)',
                tension: 0.3,
                fill: true
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            responsive: true
        }
    });

    // ===== Funding Stage Pie Chart =====
    const stageChart = new Chart(document.getElementById('stageChart'), {
        type: 'doughnut',
        data: {
            labels: stageLabels,
            datasets: [{
                data: stageTotals,
                backgroundColor: [
                    '#28a745',
                    '#17a2b8',
                    '#ffc107',
                    '#dc3545',
                    '#6f42c1'
                ],
                borderWidth: 2,
                borderColor: '#0f172a'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '65%',
            plugins: {
                legend: {
                    position: 'right',
                    align: 'center',
                    labels: {
                        boxWidth: 18,
                        boxHeight: 18,
                        padding: 22,
                        usePointStyle: true,
                        pointStyle: 'rectRounded',
                        font: {
                            size: 14,
                            weight: '500'
                        }
                    }
                }
            },
            animation: {
                onComplete: function() {
                    const chart = this;
                    const center = chart.getDatasetMeta(0).data[0];

                    const x = center.x;
                    const y = center.y;

                    const centerDiv = document.querySelector('.chart-center');
                    centerDiv.style.left = x + 'px';
                    centerDiv.style.top = y + 'px';
                    centerDiv.style.transform = 'translate(-50%, -50%)';
                }
            }
        }
    });

    // ===== Animated Center Total =====

    const totalFunding = totals.reduce((a, b) => a + b, 0);
    const centerElement = document.getElementById("centerTotal");

    let current = 0;
    const duration = 1000;
    const increment = totalFunding / (duration / 16);

    function animateCounter() {
        current += increment;
        if (current >= totalFunding) {
            current = totalFunding;
        }

        centerElement.innerText =
            "$" + Math.floor(current).toLocaleString();

        if (current < totalFunding) {
            requestAnimationFrame(animateCounter);
        }
    }

    animateCounter();

</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const totalInvestment = Number('${totalInvestment}');
        const capitalElement = document.getElementById("capitalCounter");

        if (!capitalElement || isNaN(totalInvestment)) return;

        let currentValue = 0;
        const duration = 1200;
        const stepTime = 16;
        const increment = totalInvestment / (duration / stepTime);

        function animateCapital() {
            currentValue += increment;

            if (currentValue >= totalInvestment) {
                currentValue = totalInvestment;
            }

            capitalElement.innerText =
                "$" + Math.floor(currentValue).toLocaleString();

            if (currentValue < totalInvestment) {
                requestAnimationFrame(animateCapital);
            }
        }

        animateCapital();
    });
</script>

</body>
</html>
