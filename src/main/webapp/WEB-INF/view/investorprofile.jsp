<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Prevent caching of this page to fix the back button issue
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reusing styles from dashboard for consistency */
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
        .dark-mode .profile-container,
        .dark-mode .dropdown-content {
            background-color: #1e1e1e;
            box-shadow: 0 2px 8px rgba(255, 255, 255, 0.1);
        }
        .dark-mode .navbar,
        .dark-mode .sidebar,
        .dark-mode .dropdown-content,
        .dark-mode .profile-container {
            border-color: #333;
        }
        .dark-mode .sidebar a {
            color: #e0e0e0;
        }
        .dark-mode .sidebar a:hover {
            background-color: #333;
            color: #28a745;
        }
        .dark-mode .profile-container h1,
        .dark-mode .form-group label {
            color: #e0e0e0;
        }
        .dark-mode .form-group input,
        .dark-mode .form-group textarea {
            background-color: #333;
            color: #e0e0e0;
            border-color: #555;
        }
        .dark-mode .logo {
            color: #5cb85c;
        }
        .dark-mode .profile-icon {
            background-color: #5cb85c;
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

        /* Theme toggle button styles */
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
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
        }

        .profile-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: left;
        }

        .profile-container h1 {
            color: #28a745;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .profile-container h1 i {
            margin-right: 15px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box; /* Ensures padding doesn't affect total width */
        }
        .form-group textarea {
            resize: vertical;
            height: 100px;
        }

        .save-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1.1em;
            border-radius: 50px; /* Made the button rounded */
            cursor: pointer;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .save-button:hover {
            background-color: #218838;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .alert-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar">
    <span class="closebtn" onclick="closeNav()">×</span>
    <a href="/investor/dashboard/${investor.id}"><span><i class="fas fa-tachometer-alt"></i> Dashboard</span></a>
    <a href="#"><span><i class="fas fa-rocket"></i> My Startups</span></a>
    <a href="/investor/profile"><span><i class="fas fa-user-circle"></i> Settings</span></a>
    <a href="/contact"><span><i class="fas fa-envelope"></i> Contact Us</span></a>
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
    <div class="profile-container">
        <h1><i class="fas fa-user-edit"></i> Edit Profile</h1>

        <c:if test="${not empty message}">
            <div class="alert-message alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert-message alert-danger">${error}</div>
        </c:if>

        <form action="/investor/profile/save" method="post">
            <div class="form-group">
                <label for="investorName">Name:</label>
                <input type="text" id="investorName" name="investorName" value="${investor.investorName}" required>
            </div>
            <div class="form-group">
                <label for="bio">Bio:</label>
                <textarea id="bio" name="bio" required>${investor.bio}</textarea>
            </div>
            <div class="form-group">
                <label for="investmentPreferences">Investment Preferences:</label>
                <textarea id="investmentPreferences" name="investmentPreferences" required>${investor.investmentPreferences}</textarea>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${investor.email}" disabled>
            </div>
            <button type="submit" class="save-button">Save Changes</button>
        </form>
    </div>
</div>

<script>
    // Redirect to login if the session is gone
    if ("${investor.email}" === "") {
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

    // Theme Toggle Functions
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