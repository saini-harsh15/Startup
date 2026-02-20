<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Forgot Password | EcoTrack</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root{
            --accent:#28a745;
            --accent-dark:#1d7b37;
            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
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

        .brand span{color:var(--text);opacity:.85;}

        h2{text-align:center;font-weight:800;margin-bottom:10px;color:var(--text);}
        .subtitle{text-align:center;color:var(--muted);font-size:.95rem;margin-bottom:28px;}

        label{font-size:.85rem;font-weight:600;margin-bottom:6px;display:block;}

        input{
            width:100%;
            padding:13px 14px;
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

        button{
            width:100%;
            margin-top:22px;
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

        .message{
            margin-top:18px;
            text-align:center;
            font-weight:600;
            font-size:.9rem;
            color:var(--accent);
        }

        .back-link{margin-top:26px;text-align:center;font-size:.85rem;}
        .back-link a{color:var(--accent);text-decoration:none;font-weight:600;}
        .back-link a:hover{text-decoration:underline;}
    </style>
</head>

<body>

<div class="auth-card">

    <div class="brand">ECO<span>TRACK</span></div>

    <h2>Forgot Password</h2>
    <p class="subtitle">
        Enter your registered email address and we’ll send you a secure reset link.
    </p>

    <form action="/forgot-password" method="post" id="resetForm">
        <label for="email">Email address</label>
        <input id="email" type="email" name="email" placeholder="you@example.com" required>

        <button type="submit" id="resetBtn">Send Reset Link</button>
    </form>

    <c:if test="${not empty message}">
        <div id="serverMessage" class="message">${message}</div>
    </c:if>

    <!-- AFTER SUCCESS STATE -->
    <div id="afterSubmit" style="display:none;text-align:center;margin-top:10px;">

        <div class="message" id="maskedEmailMsg"></div>

        <div style="margin-top:10px;font-size:.85rem;color:#64748b;">
            Check spam or promotions folder if you don’t see the email.
        </div>

        <button id="resendBtn" style="margin-top:18px;">Resend Email</button>

        <div id="timerText" style="font-size:.8rem;margin-top:8px;color:#64748b;"></div>

    </div>

    <div class="back-link">
        Remembered your password?
        <a href="/login">Back to login</a>
    </div>

</div>

<script>
    const form = document.getElementById("resetForm");
    const btn = document.getElementById("resetBtn");
    const emailInput = document.getElementById("email");
    const afterBox = document.getElementById("afterSubmit");
    const resendBtn = document.getElementById("resendBtn");
    const timerText = document.getElementById("timerText");
    const serverMsg = document.getElementById("serverMessage");

    /* Loading State */
    form.addEventListener("submit",()=>{
        btn.innerHTML = "Sending...";
        btn.disabled = true;
        btn.style.opacity=".8";
    });

    /* After Server Response */
    window.addEventListener("load",()=>{
        if(serverMsg){

            const email = emailInput.value || "";
            const parts = email.split("@");

            let masked = "your email";
            if(parts.length === 2){
                masked = parts[0][0] + "***@" + parts[1];
            }

            document.getElementById("maskedEmailMsg").innerHTML =
                "If an account exists, reset instructions were sent to <b>" + masked + "</b>";

            form.style.display="none";
            afterBox.style.display="block";

            startCooldown();
        }
    });

    /* Cooldown Timer */
    let cooldown = 60;
    function startCooldown(){
        resendBtn.disabled = true;
        timerText.innerHTML = "You can request another email in " + cooldown + "s";

        const interval = setInterval(()=>{
            cooldown--;
            timerText.innerHTML = "You can request another email in " + cooldown + "s";

            if(cooldown<=0){
                clearInterval(interval);
                resendBtn.disabled = false;
                timerText.innerHTML = "";
            }
        },1000);
    }

    /* Resend */
    resendBtn.addEventListener("click",()=>{
        form.submit();
    });
</script>

</body>
</html>
