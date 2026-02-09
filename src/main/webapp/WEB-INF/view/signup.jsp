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
            padding:90px 20px 50px;
            display:flex;
            justify-content:center;
            align-items:flex-start;
        }

        .signup-card{
            width:100%;
            max-width:1000px;
            background:var(--card);
            border-radius:32px;
            padding:56px 60px;
            box-shadow:var(--shadow);
        }

        h1{
            text-align:center;
            font-weight:800;
            font-size:2.1rem;
            color:var(--accent);
            margin-bottom:6px;
        }

        .subtitle{
            text-align:center;
            color:var(--muted);
            font-weight:600;
            margin-bottom:44px;
        }

        .section{
            margin-top:48px;
        }

        .section-title{
            font-size:1.35rem;
            font-weight:800;
            color:var(--accent);
            display:flex;
            align-items:center;
            gap:12px;
            margin-bottom:26px;
        }

        .section-title::before{
            content:'';
            width:6px;
            height:26px;
            background:var(--accent);
            border-radius:6px;
        }

        .grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:22px 26px;
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
            padding:13px 16px;
            border-radius:14px;
            border:var(--border);
            font-size:.9rem;
            background:#fafafa;
            transition:.25s ease;
        }

        select{
            cursor:pointer;
        }

        textarea{
            resize:vertical;
            min-height:100px;
        }

        input:focus, textarea:focus, select:focus{
            outline:none;
            background:white;
            border-color:var(--accent);
            box-shadow:0 0 0 4px rgba(40,167,69,.18);
        }

        .password-wrap{position:relative}

        .toggle-password{
            position:absolute;
            right:16px;
            top:50%;
            transform:translateY(-50%);
            cursor:pointer;
            color:var(--muted);
        }

        .toggle-password:hover{color:var(--accent)}

        #password,#confirmPassword{padding-right:46px}

        .btn-submit{
            width:100%;
            margin-top:54px;
            padding:18px;
            border:none;
            border-radius:999px;
            background:linear-gradient(135deg,var(--accent),var(--accent-dark));
            color:white;
            font-size:1.1rem;
            font-weight:700;
            cursor:pointer;
            box-shadow:0 18px 40px rgba(40,167,69,.55);
        }

        .hidden{display:none!important}

        @media(max-width:768px){
            .grid{grid-template-columns:1fr}
            .signup-card{padding:38px 26px}
        }
    </style>
</head>

<body>

<div class="signup-card">

    <h1>Create Your Account</h1>
    <p class="subtitle">
        Registering as a <strong>${selectedRole}</strong> on EcoTrack
    </p>

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

        <!-- ACCOUNT -->
        <div class="section">
            <div class="section-title">Account Credentials</div>
            <div class="grid">
                <div>
                    <label>Email</label>
                    <input type="email" name="email" required>
                </div>
                <div></div>
                <div>
                    <label>Password</label>
                    <div class="password-wrap">
                        <input type="password" id="password" name="password" required>
                        <span class="toggle-password" onclick="togglePasswordVisibility('password','eye1')">
                            <i id="eye1" class="fas fa-eye-slash"></i>
                        </span>
                    </div>
                </div>
                <div>
                    <label>Confirm Password</label>
                    <div class="password-wrap">
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <span class="toggle-password" onclick="togglePasswordVisibility('confirmPassword','eye2')">
                            <i id="eye2" class="fas fa-eye-slash"></i>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- STARTUP -->
        <!-- STARTUP -->
        <div class="section ${startupClass}">
            <div class="section-title">Startup Details</div>

            <div class="grid">

                <!-- Company Name -->
                <div>
                    <label>Company Name</label>
                    <input type="text" name="companyName" placeholder="Registered startup name" required>
                </div>

                <!-- Industry -->
                <div>
                    <label>Industry</label>
                    <select name="industry" required>
                        <option value="">Select Industry</option>
                        <option>FinTech</option>
                        <option>HealthTech</option>
                        <option>EdTech</option>
                        <option>AgriTech</option>
                        <option>ClimateTech</option>
                        <option>SaaS</option>
                        <option>E-commerce</option>
                        <option>AI / ML</option>
                    </select>
                </div>

                <!-- Registration Number -->
                <div>
                    <label>Registration Number</label>
                    <input type="text" name="registrationNumber" placeholder="Govt. registration number" required>
                </div>

                <!-- Government ID -->
                <div>
                    <label>Government ID</label>
                    <input type="text" name="governmentId" placeholder="PAN / CIN / GST / other ID" required>
                </div>

                <!-- Founding Date -->
                <div>
                    <label>Founding Date</label>
                    <input type="date" name="foundingDate" required>
                </div>

                <div></div>

                <!-- Funding Ask -->
                <div>
                    <label>Funding Ask (USD)</label>
                    <input type="number"
                           name="fundingAsk"
                           placeholder="e.g. 500000"
                           min="0"
                           step="1000"
                           required>
                </div>

                <!-- Equity Offered -->
                <div>
                    <label>Equity Offered (%)</label>
                    <input type="number"
                           name="equityOffered"
                           placeholder="e.g. 10"
                           min="0"
                           max="100"
                           step="0.1"
                           required>
                </div>

                <!-- Description -->
                <div style="grid-column:1/-1">
                    <label>Startup Description</label>
                    <textarea name="description"
                              placeholder="Briefly describe what your startup does, problem solved, and traction (if any)"
                              required></textarea>
                </div>

            </div>
        </div>


        <!-- INVESTOR -->
        <div class="section ${investorClass}">
            <div class="section-title">Investor Details</div>
            <div class="grid">
                <div><label>Investor Name</label><input type="text" name="investorName"></div>
                <div><label>Investment Firm</label><input type="text" name="investmentFirm"></div>

                <div>
                    <label>Investor Type</label>
                    <select name="investorType">
                        <option value="">Select Type</option>
                        <option>Angel Investor</option>
                        <option>Venture Capital</option>
                        <option>Private Equity</option>
                        <option>Corporate Investor</option>
                    </select>
                </div>

                <div>
                    <label>Preferred Domains</label>
                    <select name="preferredDomains">
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
                    <select name="fundingStages">
                        <option value="">Select Stage</option>
                        <option>Pre-Seed</option>
                        <option>Seed</option>
                        <option>Series A</option>
                        <option>Series B+</option>
                    </select>
                </div>

                <div><label>Location</label><input type="text" name="location"></div>
                <div><label>Website</label><input type="text" name="website"></div>
                <div>
                    <label>Investment Range (USD)</label>
                    <select name="investmentRangeUsd">
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
                    <label>LinkedIn</label>
                    <input type="text" name="linkedin">
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
            f.type="text"; i.classList.replace("fa-eye-slash","fa-eye");
        } else {
            f.type="password"; i.classList.replace("fa-eye","fa-eye-slash");
        }
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
