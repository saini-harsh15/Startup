<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Investor Account | EcoTrack</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root{
            --accent:#28a745;
            --accent-dark:#1e7e34;
            --bg:#f4f7fb;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#6b7280;
            --border:1px solid rgba(15,23,42,.1);
            --shadow:0 30px 70px rgba(0,0,0,.18);
        }

        *{box-sizing:border-box}

        body{
            margin:0;
            font-family:'Poppins',sans-serif;
            background:
                    radial-gradient(1000px 500px at top left, rgba(40,167,69,.12), transparent),
                    radial-gradient(900px 600px at bottom right, rgba(40,167,69,.08), transparent),
                    var(--bg);
            min-height:100vh;
            padding:40px 20px;
            display:flex;
            justify-content:center;
            align-items:center;
        }


        .signup-card{
            width:100%;
            max-width:1000px;
            background:var(--card);
            border-radius:32px;
            padding:50px 60px;
            box-shadow:var(--shadow);
        }

        h1{
            text-align:center;
            font-weight:800;
            font-size:2rem;
            color:var(--accent);
            margin-bottom:6px;
        }

        .subtitle{
            text-align:center;
            color:var(--muted);
            font-weight:600;
            margin-bottom:40px;
        }

        .section{ margin-top:40px; }

        .section-title{
            font-size:1.25rem;
            font-weight:800;
            color:var(--accent);
            display:flex;
            align-items:center;
            gap:12px;
            margin-bottom:22px;
        }

        .section-title::before{
            content:'';
            width:6px;
            height:24px;
            background:var(--accent);
            border-radius:6px;
        }

        .grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:20px 24px;
        }

        label{
            font-size:.8rem;
            font-weight:600;
            color:var(--text);
            margin-bottom:6px;
            display:block;
        }

        input, textarea, select{
            width:100%;
            padding:12px 14px;
            border-radius:12px;
            border:var(--border);
            font-size:.9rem;
            background:#fafafa;
            transition:.25s ease;
        }

        textarea{
            resize:vertical;
            min-height:100px;
        }

        input:focus, textarea:focus, select:focus{
            outline:none;
            background:white;
            border-color:var(--accent);
            box-shadow:0 0 0 4px rgba(40,167,69,.15);
        }

        .password-wrap{position:relative}

        .toggle-password{
            position:absolute;
            right:14px;
            top:50%;
            transform:translateY(-50%);
            cursor:pointer;
            color:var(--muted);
        }


        .strength-container{
            margin-top:10px;
        }

        .strength-text{
            font-size:.85rem;
            font-weight:600;
            margin-bottom:6px;
        }

        .strength-bar-bg{
            width:100%;
            height:6px;
            background:#e5e7eb;
            border-radius:4px;
            overflow:hidden;
        }

        .strength-bar{
            height:100%;
            width:0%;
            background:#dc3545;
            transition:width .3s ease;
        }

        .checklist{
            list-style:none;
            padding-left:0;
            margin-top:8px;
            font-size:.8rem;
            color:var(--muted);
        }

        .btn-submit{
            width:100%;
            margin-top:45px;
            padding:16px;
            border:none;
            border-radius:999px;
            background:linear-gradient(135deg,var(--accent),var(--accent-dark));
            color:white;
            font-size:1rem;
            font-weight:700;
            cursor:pointer;
            box-shadow:0 16px 35px rgba(40,167,69,.45);
        }

        @media(max-width:768px){
            .grid{grid-template-columns:1fr}
            .signup-card{padding:32px 24px}
        }

        .criteria-row{
            display:flex;
            flex-wrap:wrap;
            gap:8px;
            margin-top:12px;
        }

        .criteria{
            font-size:.75rem;
            padding:6px 12px;
            border-radius:999px;
            background:#f1f5f9;
            color:#64748b;
            font-weight:600;
            transition:all .25s ease;
        }

        .criteria.valid{
            background:rgba(40,167,69,.12);
            color:#28a745;
        }

        .criteria.invalid{
            background:rgba(220,53,69,.1);
            color:#dc3545;
        }

        .toggle-password:hover{
            color:var(--accent);
        }

        .password-wrap input{
            transition: opacity .18s ease, transform .18s ease;
        }

        .password-wrap input.revealing{
            opacity: 0;
            transform: scale(0.98);
        }

        select[multiple] {
            min-height: 120px;
        }

    </style>
</head>

<body>

<div class="signup-card">

    <h1>Create Your Investor Account</h1>
    <p class="subtitle">Join EcoTrack and discover high-potential startups.</p>

    <form action="/completeInvestorSignup" method="post" onsubmit="return validateForm()">


        <div class="section">
            <div class="section-title">Account Credentials</div>
            <div class="grid">

                <div>
                    <label>Email</label>
                    <input type="email" id="email" name="email" placeholder="investor@firm.com" required>
                    <div id="emailStatus" style="font-size:.8rem;margin-top:6px;font-weight:600;"></div>
                </div>

                <div></div>

                <div>
                    <label>Password</label>
                    <div class="password-wrap">
                        <input type="password" id="password" name="password"
                               placeholder="Create a secure password" required>
                        <span class="toggle-password" onclick="togglePasswordVisibility('password','eye1')">
                            <i id="eye1" class="fas fa-eye-slash"></i>
                        </span>
                    </div>

                    <div class="strength-container">
                        <div id="strengthText" class="strength-text"></div>
                        <div class="strength-bar-bg">
                            <div id="strengthBar" class="strength-bar"></div>
                        </div>
                        <div class="criteria-row">
                            <span id="cLength" class="criteria">10+ chars</span>
                            <span id="cUpper" class="criteria">Uppercase</span>
                            <span id="cLower" class="criteria">Lowercase</span>
                            <span id="cNumber" class="criteria">Number</span>
                            <span id="cSpace" class="criteria">No spaces</span>
                        </div>
                    </div>
                </div>

                <div>
                    <label>Confirm Password</label>
                    <div class="password-wrap">
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Re-enter your password" required>
                        <span class="toggle-password"
                              onclick="togglePasswordVisibility('confirmPassword','eye2')">
            <i id="eye2" class="fas fa-eye-slash"></i>
        </span>
                    </div>
                </div>

            </div>
        </div>


        <div class="section">
            <div class="section-title">Investor Details</div>

            <div class="grid">

                <div>
                    <label>Investor Name</label>
                    <input type="text" name="investorName"
                           placeholder="John Doe" required>
                </div>

                <div>
                    <label>Investment Firm</label>
                    <input type="text" name="investmentFirm"
                           placeholder="Alpha Ventures Capital" required>
                </div>

                <div>
                    <label>Investor Type</label>
                    <select name="investorType" required>
                        <option value="">Select Type</option>
                        <option>Angel Investor</option>
                        <option>Venture Capital</option>
                        <option>Private Equity</option>
                        <option>Corporate Investor</option>
                    </select>
                </div>

                <div>
                    <label>Preferred Domains</label>
                    <select name="preferredDomains" required>
                        <option value="">Select Domain</option>

                        <option value="ai">AI</option>
                        <option value="fintech">FinTech</option>
                        <option value="healthcare">HealthTech</option>
                        <option value="edtech">EdTech</option>
                        <option value="saas">SaaS</option>
                        <option value="blockchain">Blockchain / Web3</option>
                        <option value="ecommerce">E-Commerce / D2C</option>
                        <option value="cybersecurity">Cybersecurity</option>
                        <option value="agritech">AgriTech</option>
                        <option value="cleantech">ClimateTech / CleanTech</option>
                        <option value="logistics">Logistics / Supply Chain</option>
                        <option value="gaming">Gaming / Esports</option>
                        <option value="biotech">Biotech</option>
                        <option value="realestate">PropTech / Real Estate Tech</option>

                    </select>
                </div>

                <div>
                    <label>Funding Stages</label>
                    <select name="fundingStages" required>
                        <option value="">Select Stage</option>
                        <option>Pre-Seed</option>
                        <option>Seed</option>
                        <option>Series A</option>
                        <option>Series B+</option>
                    </select>
                </div>

                <div>
                    <label>Location</label>
                    <input type="text" name="location"
                           placeholder="New York, USA" required>
                </div>

                <div>
                    <label>Website</label>
                    <input type="url" name="website"
                           placeholder="https://yourfirm.com" required>
                </div>

                <div>
                    <label>Investment Range (USD)</label>
                    <select name="investmentRangeUsd" required>
                        <option value="">Select Range</option>
                        <option value="10000-50000">$10k – $50k</option>
                        <option value="50000-250000">$50k – $250k</option>
                        <option value="250000-1000000">$250k – $1M</option>
                        <option value="1000000-5000000">$1M – $5M</option>
                        <option value="5000000-10000000">$5M – $10M</option>
                        <option value="10000000+">$10M+</option>
                    </select>
                </div>

                <div style="grid-column:1/-1">
                    <label>LinkedIn Profile</label>
                    <input type="url" name="linkedin"
                           placeholder="https://linkedin.com/in/yourprofile" required>
                </div>

            </div>
        </div>

        <button type="submit" id="submitBtn" class="btn-submit">Create Account</button>
    </form>
</div>

<script>
    function togglePasswordVisibility(id, eye){
        const input = document.getElementById(id);
        const icon = document.getElementById(eye);

        input.classList.add("revealing");

        setTimeout(() => {
            if(input.type === "password"){
                input.type = "text";
                icon.classList.replace("fa-eye-slash","fa-eye");
            } else {
                input.type = "password";
                icon.classList.replace("fa-eye","fa-eye-slash");
            }

            input.classList.remove("revealing");
        }, 120);
    }

    const passwordInput = document.getElementById("password");
    const strengthText = document.getElementById("strengthText");
    const strengthBar = document.getElementById("strengthBar");

    passwordInput.addEventListener("input", function(){
        const value = passwordInput.value;
        let score = 0;

        const lengthValid = value.length >= 10;
        const upperValid = /[A-Z]/.test(value);
        const lowerValid = /[a-z]/.test(value);
        const numberValid = /[0-9]/.test(value);
        const spaceValid = !/\s/.test(value);

        toggleCriteria("cLength", lengthValid);
        toggleCriteria("cUpper", upperValid);
        toggleCriteria("cLower", lowerValid);
        toggleCriteria("cNumber", numberValid);
        toggleCriteria("cSpace", spaceValid);

        if(lengthValid) score++;
        if(upperValid) score++;
        if(lowerValid) score++;
        if(numberValid) score++;
        if(spaceValid) score++;

        if(score <= 2){
            strengthText.innerText = "Weak Password";
            strengthText.style.color = "#dc3545";
            strengthBar.style.width = "30%";
            strengthBar.style.background = "#dc3545";
        }
        else if(score <= 4){
            strengthText.innerText = "Moderate Password";
            strengthText.style.color = "#ffc107";
            strengthBar.style.width = "65%";
            strengthBar.style.background = "#ffc107";
        }
        else{
            strengthText.innerText = "Strong Password";
            strengthText.style.color = "#28a745";
            strengthBar.style.width = "100%";
            strengthBar.style.background = "#28a745";
        }
    });

    function toggleCriteria(id, isValid){
        const el = document.getElementById(id);
        el.classList.remove("valid", "invalid");
        el.classList.add(isValid ? "valid" : "invalid");
    }
    function validateForm(){
        const password = document.getElementById("password").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();
        const pattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{10,}$/;

        if(!pattern.test(password)){
            alert("Password must meet all requirements.");
            return false;
        }

        if(password !== confirmPassword){
            alert("Passwords do not match.");
            return false;
        }

        if(!emailValid){
            alert("Please use a different email address.");
            return false;
        }

        return true;

    }

    const emailInput = document.getElementById("email");
    const emailStatus = document.getElementById("emailStatus");
    const submitBtn = document.getElementById("submitBtn");

    let emailTimer = null;
    let emailValid = false;

    emailInput.addEventListener("input", function(){

        clearTimeout(emailTimer);

        const email = emailInput.value.trim();

        if(email.length < 5){
            emailStatus.innerText = "";
            submitBtn.disabled = false;
            return;
        }

        emailStatus.style.color = "#6b7280";
        emailStatus.innerText = "Checking availability...";
        submitBtn.disabled = true;

        emailTimer = setTimeout(() => {

            fetch("/check-email?email=" + encodeURIComponent(email))
                .then(res => res.text())
                .then(result => {

                    if(result === "EXISTS"){
                        emailStatus.style.color = "#dc3545";
                        emailStatus.innerText = "Email already registered";
                        submitBtn.disabled = true;
                        emailValid = false;
                    }
                    else{
                        emailStatus.style.color = "#28a745";
                        emailStatus.innerText = "Email available ✓";
                        submitBtn.disabled = false;
                        emailValid = true;
                    }
                })
                .catch(() => {
                    emailStatus.style.color = "#dc3545";
                    emailStatus.innerText = "Unable to verify email";
                    submitBtn.disabled = false;
                });

        }, 600);
    });

</script>

</body>
</html>
