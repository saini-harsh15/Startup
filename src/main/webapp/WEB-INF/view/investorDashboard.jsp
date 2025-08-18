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
    <title>Investor Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding-top: 60px;
            text-align: center;
        }

        /* --- Dark Mode Styles --- */
        .dark-mode {
            background-color: #121212;
            color: #e0e0e0;
        }
        .dark-mode .navbar,
        .dark-mode .sidebar,
        .dark-mode .profile-container,
        .dark-mode .dropdown-content,
        .dark-mode .startup-card-container,
        .dark-mode .startup-card,
        .dark-mode .container {
            background-color: #1e1e1e;
        }
        .dark-mode .navbar,
        .dark-mode .sidebar,
        .dark-mode .dropdown-content,
        .dark-mode .profile-container,
        .dark-mode .startup-card {
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
        .dark-mode h1,
        .dark-mode h2 {
            color: #e0e0e0;
        }
        .dark-mode .startup-card {
            background-color: #2a2a2a;
            color: #e0e0e0;
        }
        .dark-mode .startup-card:hover {
            box-shadow: 0 6px 12px rgba(255, 255, 255, 0.1);
        }
        .dark-mode .card-header {
            background-color: #333;
            border-bottom: 1px solid #444;
        }
        .dark-mode .card-description {
            color: #ccc;
        }
        .dark-mode .logo {
            color: #5cb85c;
        }
        .dark-mode .profile-icon {
            background-color: #5cb85c;
        }
        .dark-mode .dropdown-content a {
            color: #e0e0e0;
        }
        .dark-mode .dropdown-content a:hover {
            background-color: #333;
        }
        .theme-toggle {
            cursor: pointer;
            font-size: 1.5em;
            margin-right: 15px;
        }

        /* --- Existing Styles (unchanged) --- */
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
        .sidebar a .icon {
            margin-right: 18px;
            font-size: 1.3em;
        }
        .sidebar .closebtn {
            position: absolute;
            top: 12px;
            right: 20px;
            font-size: 32px;
            color: #888;
            cursor: pointer;
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
            background-color: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 900px;
            margin: 20px auto;
        }

        h1 {
            color: #28a745;
            margin-bottom: 20px;
        }

        .startup-card-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 30px;
            text-align: left;
        }

        .startup-card {
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s;
            overflow: hidden;
            text-decoration: none;
            color: #333;
        }

        .startup-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background-color: #f8f9fa;
            padding: 15px;
            font-size: 1.2em;
            font-weight: bold;
            border-bottom: 1px solid #e0e0e0;
        }

        .card-body {
            padding: 15px;
        }

        .card-description {
            color: #666;
            font-size: 0.9em;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar">
    <span class="closebtn" onclick="closeNav()">×</span>
    <a href="/investor/dashboard/${investor.id}"><span class="icon">🏠</span> Dashboard</a>
    <a href="#"><span class="icon">🚀</span> My Startups</a>
    <a href="/investor/profile"><span class="icon">⚙️</span> Settings</a>
    <a href="/contact"><span class="icon">📞</span> Contact Us</a>
</div>

<div id="overlay" class="overlay" onclick="closeNav()"></div>

<div class="navbar">
    <div class="navbar-left">
        <div class="hamburger" onclick="openNav()">&#9776;</div>
        <div class="logo">My Project</div>
    </div>
    <div class="navbar-right">
        <span class="theme-toggle" onclick="toggleTheme()">🌙</span>
        <span class="welcome-msg">Welcome, ${investor.investorName}</span>
        <div class="profile-dropdown">
            <div class="profile-icon" onclick="toggleDropdown()">P</div>
            <div id="myDropdown" class="dropdown-content">
                <a href="/investor/profile">My Profile</a>
                <a href="/logout">Logout</a>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <h1>Welcome to Your Dashboard!</h1>

    <c:if test="${not empty startups}">
        <h2>Available Startups:</h2>
        <div class="startup-card-container">
            <c:forEach var="startup" items="${startups}">
                <a href="/investor/startup/${startup.id}" class="startup-card">
                    <div class="card-header">${startup.name}</div>
                    <div class="card-body">
                        <p class="card-description">${startup.description}</p>
                        <p><strong>Industry:</strong> ${startup.industry}</p>
                        <p><strong>Funding Ask:</strong> ${startup.fundingAsk}</p>
                        <p><strong>Equity Offered:</strong> ${startup.equityOffered}%</p>
                    </div>
                </a>
            </c:forEach>
        </div>
    </c:if>

    <c:if test="${empty startups}">
        <p>No startups found at this time.</p>
    </c:if>
</div>

<script>
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
            document.querySelector('.theme-toggle').textContent = '☀️';
        } else {
            document.body.classList.remove('dark-mode');
            document.querySelector('.theme-toggle').textContent = '🌙';
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