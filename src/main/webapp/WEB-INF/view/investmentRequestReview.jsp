<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Investment Request</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet"/>

    <style>



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

            transition:none !important;
            transform:none !important;
        }

        .logo{
            font-weight:800;
            font-size:1.35rem;
            color:#28a745;
        }
        .logo span{color:#0f172a;}

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
            color:#64748b;
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

        body{
            font-family:'Poppins',sans-serif;
            background:#f3f6f9;
            padding:40px;
            padding-top:95px;
            color:#0f172a;
        }

        .container{
            max-width:1050px;
            margin:auto;
        }

        .card{
            background:#ffffff;
            border-radius:18px;
            padding:30px;
            box-shadow:0 18px 45px rgba(15,23,42,.08);
            border:1px solid rgba(15,23,42,.06);
            margin-bottom:24px;
        }

        h1{margin-bottom:8px}
        h3{margin-top:26px;margin-bottom:14px}

        .row{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:22px;
        }

        .item{
            display:flex;
            flex-direction:column;
            gap:4px;
        }


        .item span{
            color:#64748b;
            font-size:.75rem;
            font-weight:600;
            letter-spacing:.4px;
            text-transform:uppercase;
        }


        .value{
            font-weight:600;
            font-size:.98rem;
            color:#0f172a;
        }

        .money{
            font-weight:700;
            letter-spacing:.3px;
        }

        .message-box{
            background:#f1f5f9;
            padding:16px;
            border-radius:12px;
            font-size:.95rem;
            line-height:1.5;
            border:1px solid rgba(15,23,42,.08);
        }

        .status-badge{
            display:inline-block;
            padding:6px 14px;
            margin-top: 6px;
            border-radius:10px;
            font-size:.75rem;
            font-weight:700;
            letter-spacing:.5px;
        }

        .status-PENDING{
            background:rgba(255,193,7,.18);
            color:#856404;
            border:1px solid rgba(255,193,7,.4);
        }

        .status-ACCEPTED{
            background:rgba(40,167,69,.18);
            color:#155724;
            border:1px solid rgba(40,167,69,.4);
        }

        .status-REJECTED{
            background:rgba(220,53,69,.18);
            color:#721c24;
            border:1px solid rgba(220,53,69,.4);
        }

        .footer-actions{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-top:30px;
        }

        .actions{display:flex;gap:14px}

        .btn{
            padding:12px 22px;
            border-radius:10px;
            font-weight:600;
            cursor:pointer;
            border:none;
            font-size:.9rem;
        }

        .btn-accept{
            background:linear-gradient(135deg,#28a745,#1f8f3d);
            color:white;
            box-shadow:0 10px 22px rgba(40,167,69,.35);
        }

        .btn-reject{
            background:linear-gradient(135deg,#dc3545,#b02a37);
            color:white;
            box-shadow:0 10px 22px rgba(220,53,69,.35);
        }

        .btn:hover{
            transform:translateY(-2px);
            box-shadow:0 14px 28px rgba(0,0,0,.25);
        }

        .btn-back{
            display:inline-flex;
            align-items:center;
            gap:8px;

            background:#eef2f7;
            color:#0f172a;
            text-decoration:none;

            padding:12px 20px;
            border-radius:12px;
            font-weight:600;

            border:1px solid rgba(15,23,42,.08);
            transition:all .18s ease;
        }

        .btn-back:hover{
            background:#e2e8f0;
            transform:translateX(-3px);
            box-shadow:0 8px 20px rgba(0,0,0,.12);
        }

        .btn-back:active{
            transform:translateX(-1px) scale(.98);
        }

        .btn:hover{opacity:.9}



        .dark-mode body{
            background:#0f172a;
            color:#e5e7eb;
        }


        .dark-mode .navbar{
            background:rgba(17,24,39,.9);
            border-color:rgba(255,255,255,.08);
        }

        .dark-mode .logo span{
            color:#e5e7eb;
        }


        .dark-mode .card{
            background:#111827;
            border:1px solid rgba(255,255,255,.06);
            box-shadow:0 20px 55px rgba(0,0,0,.6);
        }


        .dark-mode .item span{
            color:#9ca3af;
        }

        .dark-mode .value{
            color:#e5e7eb;
        }


        .dark-mode .message-box{
            background:#0b1220;
            border:1px solid rgba(255,255,255,.08);
        }


        .dark-mode .btn-back{
            background:#1f2937;
            color:#e5e7eb;
        }


        .dark-mode .status-PENDING{
            background:rgba(255,169,77,.18);
            color:#ffa94d;
            border:1px solid rgba(255,169,77,.35);
        }

        .dark-mode .status-ACCEPTED{
            background:rgba(40,167,69,.18);
            color:#69db7c;
            border:1px solid rgba(40,167,69,.35);
        }

        .dark-mode .status-REJECTED{
            background:rgba(220,53,69,.18);
            color:#ff8787;
            border:1px solid rgba(220,53,69,.35);
        }

        .dark-mode .btn-back{
            background:#1f2937;
            color:#e5e7eb;
            border:1px solid rgba(255,255,255,.08);
        }

        .dark-mode .btn-back:hover{
            background:#273244;
            box-shadow:0 10px 25px rgba(0,0,0,.6);
        }

        .investor-links{
            margin-top:10px;
            display:flex;
            gap:10px;
        }

        .investor-links a{
            display:inline-flex;
            align-items:center;
            gap:6px;
            padding:6px 12px;
            border-radius:8px;
            font-size:.8rem;
            font-weight:600;
            text-decoration:none;
            background:#eef2f7;
            color:#0f172a;
            border:1px solid rgba(15,23,42,.08);
            transition:all .18s ease;
        }

        .investor-links a:hover{
            background:#e2e8f0;
            transform:translateY(-2px);
            box-shadow:0 6px 16px rgba(0,0,0,.12);
        }

        .dark-mode .investor-links a{
            background:#1f2937;
            color:#e5e7eb;
            border:1px solid rgba(255,255,255,.08);
        }

        .dark-mode .investor-links a:hover{
            background:#273244;
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
            <c:choose>
                <c:when test="${not empty startup and not empty startup.name}">
                    ${startup.name.substring(0,1)}
                </c:when>
                <c:otherwise>S</c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<div class="container">

    <h1>Investment Request Review</h1>
    <p style="color:#64748b;">Carefully review the details before making a decision.</p>

    <div class="card">

        <h3>Investor Information</h3>
        <div class="row">
            <div class="item">
                <span>Name</span>
                <div class="value">${request.investor.investorName}</div>
            </div>
            <div class="item">
                <span>Email</span>
                <div class="value">${request.investor.email}</div>
            </div>
        </div>

        <div class="investor-links">

            <c:if test="${not empty request.investor.linkedin}">
                <a href="${request.investor.linkedin}" target="_blank" rel="noopener noreferrer">
                    <i class="fab fa-linkedin"></i> View LinkedIn
                </a>
            </c:if>

            <c:if test="${not empty request.investor.website}">
                <a href="${request.investor.website}" target="_blank" rel="noopener noreferrer">
                    <i class="fas fa-globe"></i> View Website
                </a>
            </c:if>

        </div>

        <h3>Investment Details</h3>
        <div class="row">
            <div class="item">
                <span>Amount</span>
                <div class="value money">
                    $<fmt:formatNumber value="${request.amount}" type="number" groupingUsed="true"/>
                </div>
            </div>

            <div class="item">
                <span>Funding Stage</span>
                <div class="value">${request.fundingStage}</div>
            </div>

            <div class="item">
                <span>Expected ROI</span>
                <div class="value">
                    <c:choose>
                        <c:when test="${request.expectedRoi != null}">
                            ${request.expectedRoi}%
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="item">
                <span>Investment Horizon</span>
                <div class="value">
                    <c:choose>
                        <c:when test="${request.horizon != null}">
                            ${request.horizon} years
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <h3>Message from Investor</h3>
        <div class="message-box">
            <c:choose>
                <c:when test="${not empty request.message}">
                    ${request.message}
                </c:when>
                <c:otherwise>
                    No message provided.
                </c:otherwise>
            </c:choose>
        </div>

        <h3>Status</h3>
        <span class="status-badge status-${request.status}">
            ${request.status}
        </span>

        <div class="footer-actions">

            <a href="<c:url value='/startup/investments'/>" class="btn-back">
                <i class="fas fa-arrow-left"></i>
                Back to requests
            </a>

            <c:if test="${request.status == 'PENDING'}">
                <div class="actions">
                    <form method="post" action="/startup/investment-requests/${request.id}/accept">
                        <button type="submit" class="btn btn-accept">Accept</button>
                    </form>

                    <form method="post" action="/startup/investment-requests/${request.id}/reject">
                        <button type="submit" class="btn btn-reject">Reject</button>
                    </form>
                </div>
            </c:if>

        </div>

    </div>

</div>


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
