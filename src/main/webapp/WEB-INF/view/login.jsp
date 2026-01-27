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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* ================= THEME ================= */
        :root{
            --accent:#28a745;
            --accent-dark:#1d7b37;

            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;

            --border:1px solid rgba(15,23,42,.08);
            --shadow-sm:0 8px 20px rgba(0,0,0,.08);
            --shadow-md:0 28px 60px rgba(0,0,0,.18);
        }

        *{box-sizing:border-box}

        body,html{
            height:100%;
            margin:0;
            font-family:'Poppins',sans-serif;
            background:
                    radial-gradient(1200px 600px at top left, rgba(40,167,69,.12), transparent),
                    radial-gradient(900px 500px at bottom right, rgba(40,167,69,.08), transparent),
                    var(--bg);
        }

        /* ================= LAYOUT ================= */
        .login-wrapper{
            display:flex;
            height:100vh;
        }

        /* ================= BRAND PANEL ================= */
        .side-panel{
            width:42%;
            display:flex;
            flex-direction:column;
            justify-content:center;
            align-items:center;
            padding:50px;
            background:linear-gradient(135deg,var(--accent),var(--accent-dark));
            color:white;
            text-align:center;
        }

        .side-panel .logo{
            display:flex;
            align-items:center;
            gap:12px;
            font-size:1.8rem;
            font-weight:800;
            margin-bottom:24px;
        }

        .side-panel .logo i{
            width:52px;
            height:52px;
            border-radius:16px;
            background:rgba(255,255,255,.2);
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .side-panel h1{
            font-size:2.4rem;
            font-weight:800;
            margin-bottom:12px;
        }

        .side-panel p{
            font-size:1rem;
            opacity:.9;
            max-width:420px;
        }

        /* ================= FORM PANEL ================= */
        .form-panel{
            width:58%;
            display:flex;
            align-items:center;
            justify-content:center;
            padding:40px;
        }

        .login-card{
            width:100%;
            max-width:440px;
            background:var(--card);
            border-radius:26px;
            padding:42px 40px;
            border:var(--border);
            box-shadow:var(--shadow-md);
            animation:fadeUp .8s ease;
        }

        @keyframes fadeUp{
            from{opacity:0;transform:translateY(20px)}
            to{opacity:1;transform:translateY(0)}
        }

        .login-card h2{
            text-align:center;
            font-weight:800;
            color:var(--accent);
            margin-bottom:8px;
        }

        .login-card p{
            text-align:center;
            color:var(--muted);
            margin-bottom:28px;
        }

        /* ================= FORM ================= */
        .form-label{
            font-weight:600;
            font-size:.9rem;
        }

        .form-control{
            border-radius:12px;
            padding:12px 14px;
            font-size:.95rem;
            border:var(--border);
            transition:.25s ease;
        }

        .form-control:focus{
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(40,167,69,.25);
        }

        /* Password */
        .password-container{position:relative}

        .toggle-password{
            position:absolute;
            right:14px;
            top:50%;
            transform:translateY(-50%);
            cursor:pointer;
            color:var(--muted);
        }

        .toggle-password:hover{color:var(--accent)}

        #password{padding-right:42px}

        /* Forgot password link */
        .forgot-link{
            font-size:.8rem;
            font-weight:600;
            color:var(--muted);
            text-decoration:none;
            transition:.2s ease;
        }

        .forgot-link:hover{
            color:var(--accent);
            text-decoration:underline;
        }

        /* ================= BUTTON ================= */
        .btn-custom{
            width:100%;
            padding:14px;
            border:none;
            border-radius:999px;
            background:linear-gradient(135deg,var(--accent),var(--accent-dark));
            color:white;
            font-size:1rem;
            font-weight:700;
            cursor:pointer;
            box-shadow:0 12px 28px rgba(40,167,69,.45);
            transition:.3s ease;
        }

        .btn-custom:hover{
            transform:translateY(-2px);
            box-shadow:0 18px 42px rgba(40,167,69,.6);
        }

        /* Alerts */
        .alert{
            border-radius:12px;
            font-weight:600;
        }

        /* ================= FOOTER LINK ================= */
        .signup-link{
            text-align:center;
            margin-top:28px;
            font-size:.9rem;
            color:var(--muted);
        }

        .signup-link a{
            color:var(--accent);
            font-weight:600;
            text-decoration:none;
        }

        .signup-link a:hover{text-decoration:underline}

        /* ================= RESPONSIVE ================= */
        @media(max-width:992px){
            .side-panel{display:none}
            .form-panel{width:100%}
        }
    </style>
</head>

<body>

<div class="login-wrapper">

    <!-- LEFT BRAND PANEL -->
    <div class="side-panel">
        <div class="logo">
            <i class="fas fa-leaf"></i>
            ECO<span style="opacity:.9">TRACK</span>
        </div>
        <h1>Welcome Back</h1>
        <p>
            Access your personalized dashboard to connect with startups,
            investors, and insights — all in one ecosystem.
        </p>
    </div>

    <!-- RIGHT FORM PANEL -->
    <div class="form-panel">
        <div class="login-card">

            <h2>Secure Login</h2>
            <p>Enter your credentials to continue</p>

            <% String message = (String) request.getAttribute("message"); %>
            <% if (message != null) { %>
            <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-danger" %>">
                <%= message %>
            </div>
            <% } %>

            <form action="/login" method="post">

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <!-- PASSWORD WITH FORGOT LINK -->
                <div class="mb-4">

                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label class="form-label mb-0">Password</label>
                        <a href="/forgot-password" class="forgot-link">
                            Forgot password?
                        </a>
                    </div>

                    <div class="password-container">
                        <input type="password" name="password" id="password" class="form-control" required>
                        <span class="toggle-password" onclick="togglePasswordVisibility()">
                            <i id="eyeIcon" class="fas fa-eye-slash"></i>
                        </span>
                    </div>

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
        const p = document.getElementById("password");
        const i = document.getElementById("eyeIcon");

        if(p.type === "password"){
            p.type = "text";
            i.classList.replace("fa-eye-slash","fa-eye");
        }else{
            p.type = "password";
            i.classList.replace("fa-eye","fa-eye-slash");
        }
    }
</script>

</body>
</html>
