<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Reset Password | EcoTrack</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root{
            --accent:#28a745;
            --accent-dark:#1d7b37;

            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --danger:#dc2626;

            --border:1px solid rgba(15,23,42,.08);
            --shadow-md:0 28px 60px rgba(0,0,0,.18);
        }

        *{box-sizing:border-box}

        html,body{
            height:100%;
            margin:0;
            font-family:'Poppins',sans-serif;
        }

        body{
            background:
                    radial-gradient(900px 500px at top left, rgba(40,167,69,.12), transparent),
                    radial-gradient(700px 400px at bottom right, rgba(40,167,69,.08), transparent),
                    var(--bg);
            display:flex;
            align-items:center;
            justify-content:center;
            padding:20px;
        }

        /* ================= CARD ================= */
        .auth-card{
            width:100%;
            max-width:420px;
            background:var(--card);
            border-radius:26px;
            padding:44px 40px;
            border:var(--border);
            box-shadow:var(--shadow-md);
            animation:fadeUp .8s ease;
        }

        @keyframes fadeUp{
            from{opacity:0;transform:translateY(20px)}
            to{opacity:1;transform:translateY(0)}
        }

        /* ================= BRAND ================= */
        .brand{
            display:flex;
            align-items:center;
            justify-content:center;
            gap:10px;
            font-weight:800;
            color:var(--accent);
            margin-bottom:18px;
            letter-spacing:.3px;
        }

        .brand span{
            color:var(--text);
            opacity:.85;
        }

        /* ================= TEXT ================= */
        h2{
            text-align:center;
            font-weight:800;
            margin-bottom:10px;
            color:var(--text);
        }

        .subtitle{
            text-align:center;
            color:var(--muted);
            font-size:.95rem;
            margin-bottom:28px;
        }

        /* ================= FORM ================= */
        label{
            font-size:.85rem;
            font-weight:600;
            margin-bottom:6px;
            display:block;
        }

        .password-wrapper{
            position:relative;
            margin-bottom:16px;
        }

        input{
            width:100%;
            padding:13px 42px 13px 14px;
            border-radius:12px;
            border:var(--border);
            font-size:.95rem;
            outline:none;
            transition:.25s ease;
        }

        input:focus{
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(40,167,69,.25);
        }

        .toggle-eye{
            position:absolute;
            right:14px;
            top:50%;
            transform:translateY(-50%);
            cursor:pointer;
            color:var(--muted);
            font-size:.95rem;
        }

        .toggle-eye:hover{
            color:var(--accent);
        }

        /* ================= BUTTON ================= */
        button{
            width:100%;
            margin-top:8px;
            padding:14px;
            border:none;
            border-radius:999px;
            background:linear-gradient(135deg,var(--accent),var(--accent-dark));
            color:white;
            font-size:1rem;
            font-weight:700;
            cursor:pointer;
            box-shadow:0 14px 32px rgba(40,167,69,.45);
            transition:.3s ease;
        }

        button:hover{
            transform:translateY(-2px);
            box-shadow:0 20px 42px rgba(40,167,69,.6);
        }

        /* ================= ERROR ================= */
        .error{
            margin-top:18px;
            text-align:center;
            font-weight:600;
            font-size:.9rem;
            color:var(--danger);
        }

        /* ================= FOOTER ================= */
        .helper-text{
            margin-top:22px;
            text-align:center;
            font-size:.8rem;
            color:var(--muted);
        }
    </style>
</head>

<body>

<div class="auth-card">

    <div class="brand">
        ECO<span>TRACK</span>
    </div>

    <h2>Reset Password</h2>
    <p class="subtitle">
        Choose a strong new password to secure your account.
    </p>

    <form action="/reset-password" method="post">
        <input type="hidden" name="token" value="${token}">

        <label for="password">New password</label>
        <div class="password-wrapper">
            <input id="password" type="password" name="password" placeholder="Enter new password" required>
            <span class="toggle-eye" onclick="togglePassword('password','eye1')">
                <i id="eye1" class="fas fa-eye-slash"></i>
            </span>
        </div>

        <label for="confirmPassword">Confirm password</label>
        <div class="password-wrapper">
            <input id="confirmPassword" type="password" name="confirmPassword" placeholder="Re-enter new password" required>
            <span class="toggle-eye" onclick="togglePassword('confirmPassword','eye2')">
                <i id="eye2" class="fas fa-eye-slash"></i>
            </span>
        </div>

        <button type="submit">Reset Password</button>
    </form>

    <c:if test="${not empty error}">
        <div class="error">${error}</div>
    </c:if>

    <div class="helper-text">
        For your security, this link will expire shortly.
    </div>

</div>

<script>
    function togglePassword(inputId, eyeId){
        const input = document.getElementById(inputId);
        const eye = document.getElementById(eyeId);

        if(input.type === "password"){
            input.type = "text";
            eye.classList.replace("fa-eye-slash","fa-eye");
        }else{
            input.type = "password";
            eye.classList.replace("fa-eye","fa-eye-slash");
        }
    }
</script>

</body>
</html>
