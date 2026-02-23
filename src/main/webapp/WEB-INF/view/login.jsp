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

        .login-wrapper{display:flex;height:100vh;}

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

        .logo{display:flex;align-items:center;gap:16px;font-size:2rem;font-weight:800;margin-bottom:30px;}
        .logo i{width:60px;height:60px;border-radius:18px;background:rgba(255,255,255,.18);display:flex;align-items:center;justify-content:center;font-size:1.5rem;}

        .side-panel h1{font-size:3rem;font-weight:800;margin-bottom:16px;}
        .side-panel p{font-size:1.1rem;opacity:.95;max-width:480px;line-height:1.7;}

        .form-panel{width:42%;display:flex;align-items:center;justify-content:center;background:linear-gradient(180deg,#f7fafc,#eef3f6);}

        .login-card{
            width:100%;
            max-width:420px;
            padding:44px 42px;
            border-radius:28px;
            background:rgba(255,255,255,.65);
            backdrop-filter:blur(14px);
            box-shadow:0 20px 50px rgba(0,0,0,.12), inset 0 1px rgba(255,255,255,.6);
        }

        .login-card h2{text-align:center;color:#1f8f43;font-weight:800;margin-bottom:6px;}
        .login-card p{text-align:center;color:#64748b;margin-bottom:30px;}

        label{font-weight:600;font-size:.9rem;display:block;margin-bottom:6px;}

        input{
            width:100%;
            padding:13px 15px;
            border-radius:14px;
            border:1px solid rgba(0,0,0,.08);
            background:rgba(255,255,255,.85);
            font-size:.95rem;
            transition:.25s ease;
        }

        input:focus{outline:none;border-color:#28a745;box-shadow:0 0 0 3px rgba(40,167,69,.18);}

        .password-container{position:relative}
        .toggle-password{position:absolute;right:14px;top:50%;transform:translateY(-50%);cursor:pointer;color:#64748b;}

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

        .btn-custom:hover{transform:translateY(-2px);box-shadow:0 18px 42px rgba(40,167,69,.5);}
        .signup-link{text-align:center;margin-top:26px;font-size:.9rem;color:#64748b;}
        .signup-link a{color:#28a745;font-weight:600;text-decoration:none;}
        .signup-link a:hover{text-decoration:underline}

        @media(max-width:900px){
            .side-panel{display:none}
            .form-panel{width:100%}
        }

        .login-message{
            display:flex;
            align-items:flex-start;
            gap:12px;
            padding:14px 16px;
            border-radius:14px;
            font-size:.9rem;
            margin-bottom:18px;
            backdrop-filter:blur(6px);
            position:relative;
            overflow:hidden;
            animation:fadeSlide .35s ease;
        }

        .login-message i{font-size:1.2rem;margin-top:2px}

        .login-message.error{
            background:rgba(255,70,70,.10);
            color:#dc3545;
            border:1px solid rgba(220,53,69,.25);
        }

        .login-message.success{
            background:rgba(40,167,69,.12);
            color:#1e7e34;
            border:1px solid rgba(40,167,69,.35);
        }

        .login-message::after{
            content:"";
            position:absolute;
            left:0;
            bottom:0;
            height:3px;
            width:100%;
            background:currentColor;
            opacity:.25;
            animation:progressBar 4.5s linear forwards;
        }

        @keyframes progressBar{
            from{width:100%}
            to{width:0%}
        }

        @keyframes fadeSlide{
            from{opacity:0; transform:translateY(-6px)}
            to{opacity:1; transform:translateY(0)}
        }

        .forgot-link{
            position:relative;
            transition:color .25s ease;
        }

        .forgot-link i{
            transition:transform .25s ease, opacity .25s ease;
            opacity:.6;
        }

        .forgot-link::after{
            content:"";
            position:absolute;
            left:0;
            bottom:-2px;
            width:0%;
            height:2px;
            background:#28a745;
            transition:width .25s ease;
        }

        .forgot-link:hover{
            color:#28a745 !important;
        }

        .forgot-link:hover::after{
            width:100%;
        }

        .forgot-link:hover i{
            transform:translateX(4px);
            opacity:1;
        }

       .forgot-link{
            position:relative;
            transition:color .25s ease, letter-spacing .25s ease;
        }

        .forgot-link::after{
            content:"";
            position:absolute;
            left:0;
            bottom:-2px;
            width:0%;
            height:2px;
            background:#28a745;
            transition:width .25s ease;
        }

        .forgot-link:hover{
            color:#28a745 !important;
            letter-spacing:.2px;
        }

        .forgot-link:hover::after{
            width:100%;
        }

        .forgot-link:active{
            transform:scale(.97);
        }


    </style>
</head>

<body>

<div class="login-wrapper">

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

    <div class="form-panel">
        <div class="login-card">

            <h2>Secure Login</h2>
            <p>Enter your credentials to continue</p>

            <% String message = (String) request.getAttribute("message"); %>
            <% if (message != null) {
                boolean success = message.toLowerCase().contains("success");
            %>

            <div id="authAlert" class="login-message <%= success ? "success" : "error" %>">
                <i class="fas <%= success ? "fa-circle-check" : "fa-triangle-exclamation" %>"></i>

                <div style="display:flex;flex-direction:column;line-height:1.4">
                    <% if(success){ %>
                    <strong>You're in.</strong>
                    <span style="font-weight:500;opacity:.9">Redirecting to your workspace...</span>
                    <% } else { %>
                    <strong>We couldn’t sign you in</strong>
                    <span style="font-weight:500;opacity:.9">
                Check your email & password and try again. Caps Lock might be on.
            </span>
                    <% } %>
                </div>
            </div>

            <% } %>


            <form action="/login" method="post" id="loginForm">

                <div style="margin-bottom:18px;">
                    <label>Email</label>
                    <input type="email" name="email" id="email" required>
                </div>

                <div style="margin-bottom:6px;display:flex;justify-content:space-between;">
                    <label>Password</label>
                    <a href="/forgot-password" id="forgotLink" class="forgot-link" style="font-size:.8rem;color:#64748b;text-decoration:none;">Forgot Password?</a>

                    </a>

                </div>

                <div class="password-container">
                    <input type="password" name="password" id="password" required>
                    <span class="toggle-password" onclick="togglePasswordVisibility()">
                        <i id="eyeIcon" class="fas fa-eye-slash"></i>
                    </span>
                </div>

                <div id="capsWarning" style="display:none;color:#dc3545;font-size:.8rem;margin-top:6px;">
                    Caps Lock is ON
                </div>

                <button type="submit" class="btn-custom" id="loginBtn">Login</button>
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
        if(p.type==="password"){p.type="text";i.classList.replace("fa-eye-slash","fa-eye");}
        else{p.type="password";i.classList.replace("fa-eye","fa-eye-slash");}
    }

    const emailInput=document.getElementById("email");
    const savedEmail=localStorage.getItem("lastLoginEmail");
    if(savedEmail) emailInput.value=savedEmail;

    document.getElementById("loginForm").addEventListener("submit",()=>{
        localStorage.setItem("lastLoginEmail",emailInput.value);

        const btn=document.getElementById("loginBtn");
        btn.innerHTML='<i class="fas fa-spinner fa-spin"></i> Signing in...';
        btn.disabled=true;
    });

   const password=document.getElementById("password");
    const caps=document.getElementById("capsWarning");
    password.addEventListener("keyup",e=>{
        caps.style.display=e.getModifierState("CapsLock")?"block":"none";
    });

    window.addEventListener("load",()=>{
        if(!emailInput.value) emailInput.focus();
        else password.focus();
    });

    document.addEventListener("keydown",e=>{
        if(e.key==="Enter"){
            document.getElementById("loginForm").submit();
        }
    });

    const alertBox = document.getElementById("authAlert");
    if(alertBox){
        setTimeout(()=>{
            alertBox.style.opacity="0";
            alertBox.style.transform="translateY(-8px)";
            setTimeout(()=>alertBox.remove(),300);
        },4500);
    }

</script>
<script>

   const forgot = document.getElementById("forgotLink");

    forgot.addEventListener("click", function(e){

        this.style.pointerEvents="none";
        this.style.opacity=".7";
        this.innerHTML='<i class="fas fa-circle-notch fa-spin"></i> Opening...';

       setTimeout(()=>{
            window.location.href=this.href;
        },450);

        e.preventDefault();
    });
</script>


</body>
</html>
