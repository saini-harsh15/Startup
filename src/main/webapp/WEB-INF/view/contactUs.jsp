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
            height:100%;
            margin:0;
            font-family:'Poppins',sans-serif;
            background:var(--bg);
            color:var(--text);
        }

        /* NAVBAR */
        .navbar{
            position:fixed;
            top:0;left:0;right:0;
            height:70px;
            padding:0 28px;
            background:var(--card);
            border-bottom:var(--border);
            display:flex;
            align-items:center;
            justify-content:space-between;
            z-index:1000;
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

        .nav-right{display:flex;align-items:center;gap:16px}

        /* PROFILE */
        .profile-icon{
            width:40px;height:40px;
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
            right:0;top:52px;
            background:var(--card);
            border-radius:12px;
            box-shadow:var(--shadow);
            border:var(--border);
            overflow:hidden;
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{
            display:block;
            padding:12px 16px;
            font-weight:600;
            color:var(--text);
            text-decoration:none;
        }
        .dropdown-content a:hover{background:var(--green-soft)}

        /* SIDEBAR */
        .sidebar{
            position:fixed;
            top:0;left:0;
            height:100%;
            width:0;
            overflow:hidden;
            background:var(--card);
            border-right:var(--border);
            transition:.3s ease;
            z-index:1100;
        }
        .sidebar.open{width:260px}
        .sidebar a{
            display:flex;
            align-items:center;
            gap:12px;
            padding:14px 20px;
            font-weight:600;
            color:var(--text);
            text-decoration:none;
        }
        .sidebar a:hover{
            background:var(--green-soft);
            color:var(--green);
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
        .page-wrap{
            padding:110px 24px 40px;
            display:flex;
            justify-content:center;
        }
        .contact-card{
            width:100%;
            max-width:520px;
            background:var(--card);
            border-radius:22px;
            padding:40px;
            border:var(--border);
            box-shadow:var(--shadow);
        }
        .contact-card h1{
            text-align:center;
            font-weight:800;
            color:var(--green);
            margin-bottom:8px;
        }
        .contact-card p{
            text-align:center;
            color:var(--muted);
            margin-bottom:28px;
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
        textarea{min-height:140px;resize:vertical}

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
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div id="mySidebar" class="sidebar">
    <a href="/investor/dashboard/${investor.id}"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="/investor/profile"><i class="fas fa-user"></i> Profile</a>
    <a href="/contact"><i class="fas fa-envelope"></i> Contact</a>
    <a href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>
<div id="overlay" class="overlay" onclick="closeNav()"></div>

<!-- NAVBAR -->
<header class="navbar">
    <div class="nav-left">
        <div class="hamburger" onclick="openNav()">☰</div>
        <div class="logo">
            <i class="fas fa-leaf"></i>
            ECO<span>TRACK</span>
        </div>
    </div>

    <div class="nav-right">
        <c:if test="${not empty investor}">
            <div class="profile-dropdown">
                <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()">P</div>
                <div id="myDropdown" class="dropdown-content">
                    <a href="/investor/profile">My Profile</a>
                    <a href="/logout">Logout</a>
                </div>
            </div>
        </c:if>
    </div>
</header>

<!-- CONTENT -->
<div class="page-wrap">
    <div class="contact-card">
        <h1>Contact Us</h1>
        <p>Have a question or need support? We’ll get back to you shortly.</p>

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

            <button type="submit" class="btn-submit">Send Message</button>
        </form>
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

        const name="${investor.investorName}";
        const icon=document.getElementById("profileIcon");
        if(name && icon) icon.textContent=name.charAt(0).toUpperCase();
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

</body>
</html>
