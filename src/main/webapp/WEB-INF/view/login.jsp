<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login | EcoTrack</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root{
            --accent:#28a745;
            --accent-dark:#145c2a;
            --bg:#eef3f6;
            --text:#0f172a;
            --muted:#64748b;
        }

        *{box-sizing:border-box}

        body,html{
            height:100%;
            margin:0;
            font-family:'Poppins',sans-serif;
            background:#eef3f6;
        }

        /* Layout */
        .login-wrapper{
            display:flex;
            height:100vh;
        }

        /* ===== HERO SIDE ===== */
        .side-panel{
            width:58%;
            position:relative;
            display:flex;
            flex-direction:column;
            justify-content:center;
            align-items:flex-start;
            padding:80px;
            color:white;
            background:
                    radial-gradient(800px 400px at 20% 20%, rgba(255,255,255,.18), transparent),
                    radial-gradient(600px 300px at 80% 80%, rgba(255,255,255,.12), transparent),
                    linear-gradient(135deg,#1f8f43,#0e4d23);
        }

        .logo{
            display:flex;
            align-items:center;
            gap:16px;
            font-size:2rem;
            font-weight:800;
            margin-bottom:30px;
        }

        .logo i{
            width:60px;
            height:60px;
            border-radius:18px;
            background:rgba(255,255,255,.18);
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:1.5rem;
            backdrop-filter:blur(6px);
        }

        .side-panel h1{
            font-size:3rem;
            font-weight:800;
            margin-bottom:16px;
        }

        .side-panel p{
            font-size:1.1rem;
            opacity:.95;
            max-width:480px;
            line-height:1.7;
        }

        /* ===== FORM SIDE ===== */
        .form-panel{
            width:42%;
            display:flex;
            align-items:center;
            justify-content:center;
            background:linear-gradient(180deg,#f7fafc,#eef3f6);
        }

        /* Glass Card */
        .login-card{
            width:100%;
            max-width:420px;
            padding:44px 42px;
            border-radius:28px;

            background:rgba(255,255,255,.65);
            backdrop-filter:blur(14px);

            box-shadow:
                    0 20px 50px rgba(0,0,0,.12),
                    inset 0 1px rgba(255,255,255,.6);
        }

        .login-card h2{
            text-align:center;
            color:#1f8f43;
            font-weight:800;
            margin-bottom:6px;
        }

        .login-card p{
            text-align:center;
            color:#64748b;
            margin-bottom:30px;
        }

        /* Inputs */
        label{
            font-weight:600;
            font-size:.9rem;
            display:block;
            margin-bottom:6px;
        }

        input{
            width:100%;
            padding:13px 15px;
            border-radius:14px;
            border:1px solid rgba(0,0,0,.08);
            background:rgba(255,255,255,.85);
            font-size:.95rem;
            transition:.25s ease;
        }

        input:focus{
            outline:none;
            border-color:#28a745;
            box-shadow:0 0 0 3px rgba(40,167,69,.18);
        }

        .password-container{position:relative}

        .toggle-password{
            position:absolute;
            right:14px;
            top:50%;
            transform:translateY(-50%);
            cursor:pointer;
            color:#64748b;
        }

        /* Button */
        .btn-custom{
            width:100%;
            padding:14px;
            border:none;
            border-radius:999px;
            background:linear-gradient(135deg,#28a745,#145c2a);
            color:white;
            font-weight:700;
            margin-top:18px;
            box-shadow:0 12px 28px rgba(40,167,69,.35);
            transition:.25s ease;
        }

        .btn-custom:hover{
            transform:translateY(-2px);
            box-shadow:0 18px 42px rgba(40,167,69,.5);
        }

        /* Footer */
        .signup-link{
            text-align:center;
            margin-top:26px;
            font-size:.9rem;
            color:#64748b;
        }

        .signup-link a{
            color:#28a745;
            font-weight:600;
            text-decoration:none;
        }

        .signup-link a:hover{text-decoration:underline}

        /* Mobile */
        @media(max-width:900px){
            .side-panel{display:none}
            .form-panel{width:100%}
        }

        /* LOGIN MESSAGE (PREMIUM ALERT) */
        .login-message{
            display:flex;
            align-items:center;
            gap:10px;
            padding:12px 14px;
            border-radius:14px;
            font-size:.9rem;
            font-weight:600;
            margin-bottom:18px;
            animation:fadeSlide .35s ease;
            backdrop-filter:blur(6px);
        }

        .login-message i{
            font-size:1.1rem;
        }

        /* Error */
        .login-message.error{
            background:rgba(255,70,70,.10);
            color:#dc3545;
            border:1px solid rgba(220,53,69,.25);
        }

        /* Success */
        .login-message.success{
            background:rgba(40,167,69,.12);
            color:#1e7e34;
            border:1px solid rgba(40,167,69,.35);
        }

        @keyframes fadeSlide{
            from{opacity:0; transform:translateY(-6px)}
            to{opacity:1; transform:translateY(0)}
        }

    </style>
</head>

<body>

<div class="login-wrapper">

    <!-- LEFT HERO PANEL -->
    <div class="side-panel">
        <div class="logo">
            <i class="fas fa-leaf"></i>
            ECO<span style="opacity:.9">TRACK</span>
        </div>
        <h1>Welcome Back</h1>
        <p>
            Access your dashboard to connect startups and investors,
            track opportunities, and grow your ecosystem.
        </p>
    </div>

    <!-- RIGHT FORM PANEL -->
    <div class="form-panel">
        <div class="login-card">

            <h2>Secure Login</h2>
            <p>Enter your credentials to continue</p>

            <% String message = (String) request.getAttribute("message"); %>
            <% if (message != null) { %>
            <div class="login-message <%= message.toLowerCase().contains("success") ? "success" : "error" %>">
                <i class="fas <%= message.toLowerCase().contains("success") ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                <span><%= message %></span>
            </div>
            <% } %>


            <form action="/login" method="post">

                <div style="margin-bottom:18px;">
                    <label>Email</label>
                    <input type="email" name="email" required>
                </div>

                <div style="margin-bottom:6px;display:flex;justify-content:space-between;">
                    <label>Password</label>
                    <a href="/forgot-password" style="font-size:.8rem;color:#64748b;text-decoration:none;">Forgot Password?</a>
                </div>

                <div class="password-container">
                    <input type="password" name="password" id="password" required>
                    <span class="toggle-password" onclick="togglePasswordVisibility()">
                        <i id="eyeIcon" class="fas fa-eye-slash"></i>
                    </span>
                </div>

                <button type="submit" class="btn-custom">Login</button>
            </form>

            <div class="signup-link">
                Don’t have an account?
                <a href="/">Create one</a>
            </div>

        </div>
    </div>

</div>

<script>
    function togglePasswordVisibility(){
        const p=document.getElementById("password");
        const i=document.getElementById("eyeIcon");
        if(p.type==="password"){
            p.type="text";
            i.classList.replace("fa-eye-slash","fa-eye");
        }else{
            p.type="password";
            i.classList.replace("fa-eye","fa-eye-slash");
        }
    }
</script>

</body>
</html>
