<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Prevent caching of this page to fix the back button issue
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.
%>
<!DOCTYPE html>
<html>
<head>
    <title>Startup Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding-top: 60px;
            text-align: center;
        }
        /* Dark mode styles */
        .dark-mode {
            background-color: #121212;
            color: #e0e0e0;
        }
        .dark-mode .navbar,
        .dark-mode .sidebar,
        .dark-mode .main-content-section {
            background-color: #1e1e1e;
            box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
        }
        .dark-mode .navbar,
        .dark-mode .sidebar,
        .dark-mode .main-content-section {
            border-color: #333;
        }
        .dark-mode .sidebar a {
            color: #e0e0e0;
        }
        .dark-mode .sidebar a:hover {
            background-color: #333;
            color: #28a745;
        }
        .dark-mode .welcome-msg,
        .dark-mode .section-header h2,
        .dark-mode .profile-info p {
            color: #e0e0e0;
        }
        .dark-mode .form-group input,
        .dark-mode .form-group textarea {
            background-color: #333;
            color: #e0e0e0;
            border-color: #555;
        }

        .theme-toggle {
            cursor: pointer;
            font-size: 1.2em;
            margin-right: 15px;
            background-color: #e0e0e0;
            color: #333;
            border-radius: 5px;
            padding: 5px 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .theme-toggle:hover {
            background-color: #d4d4d4;
            transform: translateY(-1px);
        }
        .dark-mode .theme-toggle {
            background-color: #333;
            color: #e0e0e0;
        }
        .dark-mode .theme-toggle:hover {
            background-color: #444;
        }

        .dark-mode .logo {
            color: #5cb85c;
        }

        /* Dropdown specific dark mode fix */
        .dark-mode .dropdown-content {
            background-color: #2a2a2a;
            box-shadow: 0px 8px 16px 0px rgba(255, 255, 255, 0.1);
        }
        .dark-mode .dropdown-content a {
            color: #e0e0e0;
        }
        .dark-mode .dropdown-content a:hover {
            background-color: #3d3d3d;
        }
        /* End of fix */

        /* --- Immersive UI enhancements --- */
        .welcome-banner {
            background-image: linear-gradient(135deg, #28a745, #1d7b37);
            color: white;
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            text-align: center;
        }
        .welcome-banner h1 {
            color: white;
            margin: 0 0 10px 0;
            font-size: 2.8em;
            letter-spacing: 1px;
            font-weight: 700;
        }
        .welcome-banner p {
            font-size: 1.3em;
            margin: 0;
            opacity: 0.9;
        }
        .section-icon i {
            transition: transform 0.3s ease, color 0.3s ease;
        }
        .summary-cards .card:hover .section-icon i {
            transform: scale(1.2);
            color: #1a642e;
        }
        /* --- End of Immersive UI enhancements --- */

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #ffffff;
            padding: 10px 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            box-sizing: border-box;
            z-index: 1000;
        }
        .navbar-left {
            display: flex;
            align-items: center;
        }
        .hamburger {
            cursor: pointer;
            font-size: 1.5em;
            color: #555;
            margin-right: 20px;
        }
        .logo {
            font-size: 1.5em;
            font-weight: bold;
            color: #28a745;
            cursor: pointer;
        }

        .navbar-right {
            display: flex;
            align-items: center;
        }
        .welcome-msg {
            margin-right: 15px;
            font-weight: 500;
            color: #333;
        }
        .profile-dropdown {
            position: relative;
        }
        .profile-icon {
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #28a745;
            color: white;
            font-size: 1.2em;
            font-weight: bold;
            user-select: none;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 150px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            top: 50px;
            right: 0;
            border-radius: 5px;
        }
        .dropdown-content.show {
            display: block;
        }
        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
        }
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .sidebar {
            height: 100%;
            width: 0;
            position: fixed;
            z-index: 1001;
            top: 0;
            left: 0;
            background-color: #ffffff;
            overflow-x: hidden;
            transition: 0.4s ease;
            padding-top: 60px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
        }
        .sidebar.open {
            width: 280px;
        }
        .sidebar a {
            padding: 18px 36px;
            text-decoration: none;
            font-size: 18px;
            font-weight: 500;
            color: #333;
            display: flex;
            align-items: center;
            transition: background 0.3s ease;
        }
        .sidebar a:hover {
            background-color: #f1f1f1;
            color: #28a745;
        }
        .sidebar a i {
            margin-right: 15px;
        }

        .overlay {
            display: none;
            position: fixed;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            background-color: rgba(0, 0, 0, 0.4);
            z-index: 1000;
        }

        @media screen and (max-width: 768px) {
            .sidebar.open {
                width: 250px;
            }
            .overlay {
                display: block;
            }
        }

        .container {
            max-width: 900px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .section-icon {
            font-size: 1.5em;
            margin-right: 15px;
            color: #28a745;
        }
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background-color: #ffffff;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            text-align: center;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }
        .dark-mode .card {
            background-color: #2a2a2a;
        }
        .dark-mode .card h4,
        .dark-mode .card p {
            color: #e0e0e0;
        }
        .card h4 {
            margin: 0 0 10px 0;
            color: #666;
            font-size: 1.1em;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card p {
            font-size: 2em;
            font-weight: bold;
            color: #28a745;
            margin: 0;
        }

        .main-content-section {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: left;
        }
        .section-header {
            color: #333;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .section-header h2 {
            margin: 0;
            font-size: 1.5em;
            display: flex;
            align-items: center;
        }
        .profile-info p {
            font-size: 1.1em;
            margin: 10px 0;
        }

        /* --- Button Styling --- */
        .edit-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1em;
            border-radius: 50px;
            cursor: pointer;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .edit-button:hover {
            background-color: #218838;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .welcome-banner {
            background-image: linear-gradient(135deg, #28a745, #1d7b37);
            color: white;
            padding: 40px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            text-align: center;
        }
        .welcome-banner h1 {
            color: white;
            margin: 0 0 10px 0;
            font-size: 2.8em;
            letter-spacing: 1px;
            font-weight: 700;
        }
        .welcome-banner p {
            font-size: 1.3em;
            margin: 0;
            opacity: 0.9;
        }
.news-section {
    margin: 30px 0;
    padding: 0 20px;
}

.news-header {
    color: #2c3e50;
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 25px;
    display: flex;
    align-items: center;
    gap: 10px;
    padding-bottom: 10px;
    border-bottom: 3px solid #4caf50;
}

.news-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 25px;
    max-width: 1200px;
    margin: 0 auto;
}

.news-card {
    background: #ffffff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border: 1px solid #e8e8e8;
    position: relative;
}

.news-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.15);
    border-color: #4caf50;
}

.news-link {
    text-decoration: none;
    color: inherit;
    display: block;
    height: 100%;
}

.news-image-container {
    position: relative;
    width: 100%;
    height: 180px;
    overflow: hidden;
    background: #f8f9fa;
}

.news-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
    transition: transform 0.3s ease;
}

.news-card:hover .news-img {
    transform: scale(1.05);
}

.news-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.1) 100%);
    opacity: 0;
    transition: opacity 0.3s ease;
}

.news-card:hover .news-overlay {
    opacity: 1;
}

.news-content {
    padding: 20px;
    height: 100px;
    display: flex;
    align-items: flex-start;
}

.news-title {
    font-size: 16px;
    font-weight: 600;
    line-height: 1.4;
    color: #2c3e50;
    margin: 0;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
    transition: color 0.3s ease;
}

.news-card:hover .news-title {
    color: #4caf50;
}

.news-empty {
    text-align: center;
    padding: 60px 20px;
    background: #f8f9fa;
    border-radius: 12px;
    border: 2px dashed #ddd;
}

.news-empty p {
    color: #6c757d;
    font-size: 16px;
    margin: 0;
}

/* Responsive Design */
@media (max-width: 1024px) {
    .news-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
    }
    
    .news-header {
        font-size: 22px;
    }
}

@media (max-width: 768px) {
    .news-section {
        padding: 0 15px;
    }
    
    .news-grid {
        grid-template-columns: 1fr;
        gap: 20px;
    }
    
    .news-header {
        font-size: 20px;
        margin-bottom: 20px;
    }
    
    .news-image-container {
        height: 200px;
    }
    
    .news-content {
        padding: 16px;
        height: 90px;
    }
    
    .news-title {
        font-size: 15px;
    }
}

@media (max-width: 480px) {
    .news-image-container {
        height: 180px;
    }
    
    .news-content {
        padding: 14px;
        height: 80px;
    }
    
    .news-title {
        font-size: 14px;
        -webkit-line-clamp: 2;
    }
}

/* Loading animation for images */
.news-img[src=""] {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
}

@keyframes loading {
    0% {
        background-position: 200% 0;
    }
    100% {
        background-position: -200% 0;
    }
}

    </style>
</head>
<body>

<div id="mySidebar" class="sidebar">
    <span class="closebtn" onclick="closeNav()">×</span>
    <a href="#"><span class="icon"><i class="fas fa-tachometer-alt"></i></span> Dashboard</a>
    <a href="#"><span class="icon"><i class="fas fa-user-circle"></i></span> My Profile</a>
    <a href="#"><span class="icon"><i class="fas fa-chart-line"></i></span> Analytics</a>
    <a href="/contact"><span><i class="fas fa-envelope"></i></span> Contact Us</a>
</div>

<div id="overlay" class="overlay" onclick="closeNav()"></div>

<div class="navbar">
    <div class="navbar-left">
        <div class="hamburger" onclick="openNav()">&#9776;</div>
        <div class="logo">Startup Ecosystem</div>
    </div>
    <div class="navbar-right">
        <span class="theme-toggle" onclick="toggleTheme()">
            <i class="fas fa-moon"></i>
        </span>
        <span class="welcome-msg">Welcome, ${startup.name}</span>
        <div class="profile-dropdown">
            <div class="profile-icon" onclick="toggleDropdown()">P</div>
            <div id="myDropdown" class="dropdown-content">
                <a href="/startup/profile">My Profile</a>
                <a href="/logout">Logout</a>
            </div>
        </div>
    </div>
</div>

<div style="margin-top: 30px; text-align: center;">
    <a href="${pageContext.request.contextPath}/ml"
       target="_blank"
       style="
           display: inline-block;
           background: linear-gradient(135deg, #28a745, #218838);
           color: #fff;
           font-size: 16px;
           font-weight: bold;
           padding: 12px 25px;
           border-radius: 30px;
           text-decoration: none;
           box-shadow: 0 4px 8px rgba(0,0,0,0.15);
           transition: all 0.3s ease;
       "
       onmouseover="this.style.background='linear-gradient(135deg,#34d058,#28a745)'"
       onmouseout="this.style.background='linear-gradient(135deg, #28a745, #218838)'">
       Launch Pitch Analyzer
    </a>
    <p style="margin-top: 10px; font-size: 14px; color: #6c757d;">
        Analyze your pitch and get investor recommendations powered by AI.
    </p>
</div>



<div class="container">
    <div class="welcome-banner">
        <h1>Hello, ${startup.name}!</h1>
        <p>Welcome to your startup's command center.</p>
    </div>

    <div class="summary-cards">
        <div class="card">
            <h4><span class="section-icon"><i class="fas fa-chart-line"></i></span>Total Investments</h4>
            <p>$0</p>
        </div>
        <div class="card">
            <h4><span class="section-icon"><i class="fas fa-envelope"></i></span>Messages</h4>
            <p>0</p>
        </div>
        <div class="card">
            <h4><span class="section-icon"><i class="fas fa-eye"></i></span>Profile Views</h4>
            <p>0</p>
        </div>
    </div>

    <div class="main-content-section">
        <div class="section-header">
            <h2><span class="section-icon"><i class="fas fa-rocket"></i></span>My Profile</h2>
            <button class="edit-button">Edit Profile</button>
        </div>
        <div class="profile-info">
            <p><strong>Description:</strong> ${startup.description}</p>
            <p><strong>Industry:</strong> ${startup.industry}</p>
            <p><strong>Email:</strong> ${startup.email}</p>
        </div>
    </div>
</div>

<div class="news-section">
    <h3 class="news-header">📢 Latest in ${startup.industry}</h3>
    <c:if test="${not empty newsList}">
        <div class="news-grid">
            <c:forEach var="news" items="${newsList}" varStatus="status">
                <c:if test="${status.index < 6}"> <!-- limit to 6 articles -->
                    <article class="news-card">
                        <a href="${news.url}" target="_blank" class="news-link">
                            <div class="news-image-container">
                                <img src="${news.imageUrl}" 
                                     alt="${news.title}" 
                                     class="news-img"
                                    onerror="this.src='https://via.placeholder.com/300x200/f0f0f0/999999?text=No+Image'">
                                    
                                <div class="news-overlay"></div>
                            </div>
                            <div class="news-content">
                                <h4 class="news-title">${news.title}</h4>

                            </div>
                        </a>
                    </article>
                </c:if>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${empty newsList}">
        <div class="news-empty">
            <p>No news articles available at the moment.</p>
        </div>
    </c:if>
</div>

<script>
    // Redirect to login if the session is gone
    if ("${startup.email}" === "") {
        window.location.href = "/login?message=You have been logged out.";
    }

    function openNav() {
        document.getElementById("mySidebar").classList.add("open");
        document.getElementById("overlay").style.display = "block";
    }

    function closeNav() {
        document.getElementById("mySidebar").classList.remove("open");
        document.getElementById("overlay").style.display = "none";
    }

    function toggleDropdown() {
        document.getElementById("myDropdown").classList.toggle("show");
    }

    window.onclick = function(event) {
        if (!event.target.closest('.profile-dropdown') && !event.target.closest('.hamburger')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
    }
    // New Theme Toggle Functions
    function setTheme(theme) {
        if (theme === 'dark') {
            document.body.classList.add('dark-mode');
            document.querySelector('.theme-toggle').innerHTML = '<i class="fas fa-sun"></i>';
        } else {
            document.body.classList.remove('dark-mode');
            document.querySelector('.theme-toggle').innerHTML = '<i class="fas fa-moon"></i>';
        }
        localStorage.setItem('theme', theme);
    }

    function toggleTheme() {
        if (document.body.classList.contains('dark-mode')) {
            setTheme('light');
        } else {
            setTheme('dark');
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme') || 'light';
        setTheme(savedTheme);
    });
</script>

</body>
</html>