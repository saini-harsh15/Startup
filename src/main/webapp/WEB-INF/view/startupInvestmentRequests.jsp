<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Investment Requests</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --accent: #28a745;
            --bg: #f3f6f9;
            --card: #ffffff;
            --text: #0f172a;
            --muted: #6c757d;
            --border: 1px solid rgba(0,0,0,.06);
            --shadow: 0 10px 22px rgba(0,0,0,.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            padding: 40px;
            color: var(--text);
        }

        h1 {
            margin-bottom: 24px;
        }

        .filter-tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 28px;
        }

        .tab{
            padding:10px 18px;
            border-radius:12px;
            border:var(--border);
            background:var(--card);
            cursor:pointer;
            font-weight:600;
            color:var(--muted);
            transition:all .2s ease;
        }

        .tab:hover{
            transform:translateY(-2px);
            box-shadow:0 6px 14px rgba(0,0,0,.08);
            color:var(--text);
        }

        .tab.active{
            background:var(--accent);
            color:white;
            border-color:var(--accent);
            box-shadow:0 8px 18px rgba(40,167,69,.35);
        }

        .dark-mode .tab:hover{
            box-shadow:0 8px 22px rgba(0,0,0,.6);
        }


        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 22px;
        }

        .request-card {
            background: var(--card);
            border-radius: 18px;
            padding: 22px;
            box-shadow: var(--shadow);
            transition: .25s ease;
        }

        .request-card:hover{
            transform:translateY(-6px);
            box-shadow:0 18px 40px rgba(0,0,0,.18);
        }

        .dark-mode .request-card:hover{
            box-shadow:0 20px 50px rgba(0,0,0,.75);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .investor-name {
            font-weight: 600;
            font-size: 1.05rem;
        }


        .status-badge{
            padding:6px 14px;
            border-radius:999px;
            font-size:.72rem;
            font-weight:700;
            letter-spacing:.4px;
            display:inline-block;
            transition:.2s ease;
        }


        .status-pending{
            background:#fff4e6;
            color:#e8590c;
            box-shadow:0 2px 6px rgba(232,89,12,.15);
        }

        .status-accepted{
            background:#e6fcf5;
            color:#087f5b;
            box-shadow:0 2px 6px rgba(8,127,91,.15);
        }

        .status-rejected{
            background:#ffe3e3;
            color:#c92a2a;
            box-shadow:0 2px 6px rgba(201,42,42,.15);
        }


        .request-card:hover .status-badge{
            transform:scale(1.05);
        }


        .dark-mode .status-pending{
            background:rgba(255,169,77,.18);
            color:#ffa94d;
            box-shadow:0 0 10px rgba(255,169,77,.25);
        }

        .dark-mode .status-accepted{
            background:rgba(40,167,69,.18);
            color:#69db7c;
            box-shadow:0 0 10px rgba(40,167,69,.25);
        }

        .dark-mode .status-rejected{
            background:rgba(220,53,69,.18);
            color:#ff8787;
            box-shadow:0 0 10px rgba(220,53,69,.25);
        }

        .details {
            font-size: .9rem;
            margin: 14px 0 18px;
        }

        .details div {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
        }

        .actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
        }

        .btn-primary {
            background: var(--accent);
            color: white;
        }

        .btn-outline {
            border: 2px solid var(--accent);
            color: var(--accent);
        }

        .empty {
            text-align: center;
            color: var(--muted);
            margin-top: 80px;
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
            border:1px solid rgba(15,23,42,.06);
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
            color:#28a745;
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
            background:linear-gradient(135deg,#28a745,#34d058);
            color:white;
            display:flex;
            align-items:center;
            justify-content:center;
            font-weight:700;
            cursor:pointer;
        }

        .theme-toggle:hover{
            color:#28a745;
            transform:rotate(-12deg) scale(1.1);
        }

        .profile-icon:hover{
            transform:scale(1.08);
            box-shadow:0 6px 18px rgba(0,0,0,.25);
        }
        body{ padding-top:110px; }

        .dark-mode{
            --bg:#0f172a;
            --card:#111827;
            --text:#e5e7eb;
            --muted:#9ca3af;
        }

        .dark-mode body{
            background:var(--bg);
            color:var(--text);
        }

        .dark-mode .navbar{
            background:#111827;
            border-color:rgba(255,255,255,.08);
        }

        .dark-mode .request-card{
            background:#111827;
        }

        .dark-mode .tab{
            background:#1f2937;
            color:#9ca3af;
            border-color:#374151;
        }

        .dark-mode .tab.active{
            background:var(--accent);
            color:white;
        }

        .money{
            font-weight:700;
            letter-spacing:.4px;
        }

        .logo{
            transition:transform .2s ease, letter-spacing .2s ease;
        }
        .logo:hover{
            transform:translateY(-1px);
            letter-spacing:.5px;
        }

        .profile{
            padding:8px 14px;
            border-radius:10px;
            transition:.2s ease;
        }
        .profile:hover{
            background:rgba(0,0,0,.05);
        }

        .dark-mode .profile:hover{
            background:rgba(255,255,255,.08);
        }

        .theme-toggle{
            transition:transform .25s ease, color .25s ease;
        }
        .theme-toggle:hover{
            transform:rotate(-15deg) scale(1.15);
            color:var(--accent);
        }
        .theme-toggle:active{
            transform:scale(.9);
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

        <div class="profile-icon">
            ${startup.name.charAt(0)}
        </div>

    </div>
</header>

<h1>Investment Requests</h1>

<div class="filter-tabs">
    <button class="tab" data-status="ALL">All</button>
    <button class="tab active" data-status="PENDING">Pending</button>
    <button class="tab" data-status="ACCEPTED">Accepted</button>
    <button class="tab" data-status="REJECTED">Rejected</button>
</div>

<c:choose>
    <c:when test="${not empty allRequests}">
        <div class="request-grid">

            <c:forEach var="req" items="${allRequests}">
                <div class="request-card"
                     data-status="${req.status}">

                    <div class="request-header">
                        <div class="investor-name">
                                ${req.investor.investorName}
                        </div>

                        <span class="status-badge
                            ${req.status == 'PENDING' ? 'status-pending' :
                              req.status == 'ACCEPTED' ? 'status-accepted' :
                              'status-rejected'}">
                                ${req.status}
                        </span>
                    </div>

                    <div class="details">
                        <div>
                            <span>Amount</span>
                            <span class="money">
    $<fmt:formatNumber value="${req.amount}" type="number" groupingUsed="true"/>
</span>
                        </div>
                        <div>
                            <span>Funding Stage</span>
                            <span>${req.fundingStage}</span>
                        </div>
                    </div>

                    <c:if test="${req.status == 'PENDING'}">
                        <div class="actions">
                            <a href="/startup/investment-requests/${req.id}" class="btn btn-primary">
                                Review
                            </a>
                            <a href="/startup/chat?investorId=${req.investor.id}" class="btn btn-outline">
                                Chat
                            </a>
                        </div>
                    </c:if>

                </div>
            </c:forEach>

        </div>
    </c:when>

    <c:otherwise>
        <div class="empty">
            <i class="fas fa-inbox fa-2x"></i>
            <p>No investment requests found.</p>
        </div>
    </c:otherwise>
</c:choose>

<script>
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const selected = tab.dataset.status;

            document.querySelectorAll('.request-card').forEach(card => {
                const status = card.dataset.status;
                card.style.display =
                    (selected === 'ALL' || status === selected) ? 'block' : 'none';
            });
        });
    });

     document.querySelector('.tab[data-status="ALL"]').click();
</script>

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
