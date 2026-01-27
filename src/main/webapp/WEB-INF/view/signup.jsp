<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Account | EcoTrack</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

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
            --shadow-sm:0 6px 18px rgba(0,0,0,.08);
            --shadow-md:0 24px 50px rgba(0,0,0,.18);
        }

        *{box-sizing:border-box}

        body{
            font-family:'Poppins',sans-serif;
            background:
                    radial-gradient(1200px 600px at top left, rgba(40,167,69,.12), transparent),
                    radial-gradient(900px 500px at bottom right, rgba(40,167,69,.08), transparent),
                    var(--bg);
            min-height:100vh;
            padding-top:72px;
            display:flex;
            justify-content:center;
            align-items:flex-start;
        }

        /* ================= NAVBAR ================= */
        .navbar{
            background:rgba(255,255,255,.9)!important;
            backdrop-filter:blur(12px);
            border-bottom:var(--border);
        }
        .navbar-brand{
            font-weight:800;
            color:var(--accent)!important;
            font-size:1.25rem;
            letter-spacing:-.4px;
        }

        /* ================= CARD ================= */
        .card-custom{
            width:100%;
            max-width:680px;
            background:var(--card);
            border-radius:26px;
            padding:44px 42px;
            margin:28px 16px;
            border:var(--border);
            box-shadow:var(--shadow-md);
            animation:fadeUp .8s ease;
        }

        @keyframes fadeUp{
            from{opacity:0;transform:translateY(20px)}
            to{opacity:1;transform:translateY(0)}
        }

        h1{
            text-align:center;
            font-weight:800;
            font-size:2.3rem;
            color:var(--accent);
            margin-bottom:8px;
        }

        .role-message{
            text-align:center;
            font-weight:600;
            color:var(--muted);
            margin-bottom:32px;
        }

        /* ================= FORM ================= */
        label{
            font-weight:600;
            font-size:.9rem;
            margin-top:18px;
            color:var(--text);
        }

        input,textarea{
            width:100%;
            padding:12px 14px;
            border-radius:12px;
            border:var(--border);
            font-size:.95rem;
            transition:.25s ease;
        }

        textarea{min-height:90px;resize:vertical}

        input:focus,textarea:focus{
            outline:none;
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(40,167,69,.2);
        }

        /* ================= PASSWORD ================= */
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

        #password,#confirmPassword{padding-right:42px}

        /* ================= SECTION HEADERS ================= */
        .detail-header{
            margin-top:40px;
            margin-bottom:18px;
            font-size:1.35rem;
            font-weight:800;
            color:var(--accent);
            border-bottom:2px solid var(--accent);
            padding-bottom:8px;
            text-align:center;
        }

        /* ================= BUTTON ================= */
        .btn-custom{
            width:100%;
            margin-top:36px;
            padding:14px;
            border:none;
            border-radius:999px;
            font-size:1.05rem;
            font-weight:700;
            background:linear-gradient(135deg,var(--accent),var(--accent-dark));
            color:white;
            cursor:pointer;
            box-shadow:0 12px 28px rgba(40,167,69,.45);
            transition:.3s ease;
        }

        .btn-custom:hover{
            transform:translateY(-2px);
            box-shadow:0 18px 40px rgba(40,167,69,.6);
        }

        .hidden{display:none!important}

        /* ================= RESPONSIVE ================= */
        @media(max-width:600px){
            .card-custom{padding:34px 26px}
            h1{font-size:1.9rem}
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="/">
            ECO<span style="color:#0f172a">TRACK</span>
        </a>
    </div>
</nav>

<div class="card-custom">

    <h1>Create Your Account</h1>
    <p class="role-message">
        You are registering as a <strong>${selectedRole}</strong>. Complete the form below.
    </p>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${selectedRole == 'Startup'}">
            <c:set var="startupClass" value=""/>
            <c:set var="investorClass" value="hidden"/>
        </c:when>
        <c:when test="${selectedRole == 'Investor'}">
            <c:set var="startupClass" value="hidden"/>
            <c:set var="investorClass" value=""/>
        </c:when>
        <c:otherwise>
            <c:set var="startupClass" value="hidden"/>
            <c:set var="investorClass" value="hidden"/>
        </c:otherwise>
    </c:choose>

    <form action="/completeSignup" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="userType" value="${selectedRole}">

        <label>Email</label>
        <input type="email" name="email" required>

        <label>Password</label>
        <div class="password-container">
            <input type="password" id="password" name="password" required>
            <span class="toggle-password" onclick="togglePasswordVisibility('password','eye1')">
                <i id="eye1" class="fas fa-eye-slash"></i>
            </span>
        </div>

        <label>Confirm Password</label>
        <div class="password-container">
            <input type="password" id="confirmPassword" name="confirmPassword" required>
            <span class="toggle-password" onclick="togglePasswordVisibility('confirmPassword','eye2')">
                <i id="eye2" class="fas fa-eye-slash"></i>
            </span>
        </div>

        <!-- Startup -->
        <div id="startupFields" class="${startupClass}">
            <div class="detail-header">Startup Details</div>
            <label>Industry</label>
            <input type="text" name="industry">

            <label>Company Name</label>
            <input type="text" name="companyName">

            <label>Description</label>
            <textarea name="description"></textarea>

            <label>Registration Number</label>
            <input type="text" name="registrationNumber">

            <label>Government ID</label>
            <input type="text" name="governmentId">

            <label>Founding Date</label>
            <input type="date" name="foundingDate">
        </div>

        <!-- Investor -->
        <div id="investorFields" class="${investorClass}">
            <div class="detail-header">Investor Details</div>
            <label>Investor Name</label>
            <input type="text" name="investorName">

            <label>Investment Firm</label>
            <input type="text" name="investmentFirm">

            <label>Investor Type</label>
            <input type="text" name="investorType">

            <label>Preferred Domains</label>
            <input type="text" name="preferredDomains">

            <label>Funding Stages</label>
            <input type="text" name="fundingStages">

            <label>Location</label>
            <input type="text" name="location">

            <label>Website</label>
            <input type="text" name="website">

            <label>Investment Range (USD)</label>
            <input type="text" name="investmentRangeUsd">

            <label>LinkedIn</label>
            <input type="text" name="linkedin">
        </div>

        <button type="submit" class="btn-custom">Create Account</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePasswordVisibility(id,eye){
        const f=document.getElementById(id);
        const i=document.getElementById(eye);
        if(f.type==="password"){f.type="text";i.classList.replace("fa-eye-slash","fa-eye")}
        else{f.type="password";i.classList.replace("fa-eye","fa-eye-slash")}
    }

    function validateForm(){
        if(password.value!==confirmPassword.value){
            alert("Passwords do not match");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
