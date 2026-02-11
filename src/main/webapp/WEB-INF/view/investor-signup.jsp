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

        /* Password Strength */
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
    </style>
</head>

<body>

<div class="signup-card">

    <h1>Create Your Investor Account</h1>
    <p class="subtitle">Join EcoTrack and discover high-potential startups.</p>

    <form action="/completeInvestorSignup" method="post" onsubmit="return validateForm()">

        <!-- ACCOUNT -->
        <div class="section">
            <div class="section-title">Account Credentials</div>
            <div class="grid">

                <div>
                    <label>Email</label>
                    <input type="email" name="email" placeholder="investor@firm.com" required>
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
                        <ul class="checklist">
                            <li id="ruleLength">✖ At least 10 characters</li>
                            <li id="ruleUpper">✖ One uppercase letter</li>
                            <li id="ruleLower">✖ One lowercase letter</li>
                            <li id="ruleNumber">✖ One number</li>
                            <li id="ruleSpace">✖ No spaces</li>
                        </ul>
                    </div>
                </div>

                <div>
                    <label>Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Re-enter your password" required>
                </div>

            </div>
        </div>

        <!-- INVESTOR DETAILS -->
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
                        <option>FinTech</option>
                        <option>HealthTech</option>
                        <option>EdTech</option>
                        <option>ClimateTech</option>
                        <option>SaaS</option>
                        <option>AI / ML</option>
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
                    <input type="text" name="website"
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
                    <input type="text" name="linkedin"
                           placeholder="https://linkedin.com/in/yourprofile" required>
                </div>

            </div>
        </div>

        <button type="submit" class="btn-submit">Create Account</button>
    </form>
</div>

<script>
    function togglePasswordVisibility(id, eye){
        const f=document.getElementById(id);
        const i=document.getElementById(eye);
        if(f.type==="password"){
            f.type="text";
            i.classList.replace("fa-eye-slash","fa-eye");
        } else {
            f.type="password";
            i.classList.replace("fa-eye","fa-eye-slash");
        }
    }

    const passwordInput = document.getElementById("password");
    const strengthText = document.getElementById("strengthText");
    const strengthBar = document.getElementById("strengthBar");

    passwordInput.addEventListener("input", function(){
        const value = passwordInput.value;
        let score = 0;

        if(value.length >= 10) score++;
        if(/[A-Z]/.test(value)) score++;
        if(/[a-z]/.test(value)) score++;
        if(/[0-9]/.test(value)) score++;
        if(!/\s/.test(value)) score++;

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

        return true;
    }
</script>

</body>
</html>
