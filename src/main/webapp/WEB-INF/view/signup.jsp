<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="jakarta.tags.core" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html lang="en">--%>
<%--<head>--%>
<%--    <title>Create Account | EcoTrack</title>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1">--%>

<%--    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">--%>
<%--    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">--%>

<%--    <style>--%>
<%--        :root{--%>
<%--            --accent:#28a745;--%>
<%--            --accent-dark:#1e7e34;--%>
<%--            --bg:#f4f7fb;--%>
<%--            --card:#ffffff;--%>
<%--            --text:#0f172a;--%>
<%--            --muted:#6b7280;--%>
<%--            --border:1px solid rgba(15,23,42,.1);--%>
<%--            --shadow:0 30px 70px rgba(0,0,0,.18);--%>
<%--        }--%>

<%--        *{box-sizing:border-box}--%>

<%--        body{--%>
<%--            margin:0;--%>
<%--            font-family:'Poppins',sans-serif;--%>
<%--            background:--%>
<%--                    radial-gradient(1000px 500px at top left, rgba(40,167,69,.12), transparent),--%>
<%--                    radial-gradient(900px 600px at bottom right, rgba(40,167,69,.08), transparent),--%>
<%--                    var(--bg);--%>
<%--            min-height:100vh;--%>
<%--            padding:90px 20px 50px;--%>
<%--            display:flex;--%>
<%--            justify-content:center;--%>
<%--            align-items:flex-start;--%>
<%--        }--%>

<%--        .signup-card{--%>
<%--            width:100%;--%>
<%--            max-width:1000px;--%>
<%--            background:var(--card);--%>
<%--            border-radius:32px;--%>
<%--            padding:56px 60px;--%>
<%--            box-shadow:var(--shadow);--%>
<%--        }--%>

<%--        h1{--%>
<%--            text-align:center;--%>
<%--            font-weight:800;--%>
<%--            font-size:2.1rem;--%>
<%--            color:var(--accent);--%>
<%--            margin-bottom:6px;--%>
<%--        }--%>

<%--        .subtitle{--%>
<%--            text-align:center;--%>
<%--            color:var(--muted);--%>
<%--            font-weight:600;--%>
<%--            margin-bottom:44px;--%>
<%--        }--%>

<%--        .section{--%>
<%--            margin-top:48px;--%>
<%--        }--%>

<%--        .section-title{--%>
<%--            font-size:1.35rem;--%>
<%--            font-weight:800;--%>
<%--            color:var(--accent);--%>
<%--            display:flex;--%>
<%--            align-items:center;--%>
<%--            gap:12px;--%>
<%--            margin-bottom:26px;--%>
<%--        }--%>

<%--        .section-title::before{--%>
<%--            content:'';--%>
<%--            width:6px;--%>
<%--            height:26px;--%>
<%--            background:var(--accent);--%>
<%--            border-radius:6px;--%>
<%--        }--%>

<%--        .grid{--%>
<%--            display:grid;--%>
<%--            grid-template-columns:1fr 1fr;--%>
<%--            gap:22px 26px;--%>
<%--        }--%>

<%--        label{--%>
<%--            font-size:.8rem;--%>
<%--            font-weight:600;--%>
<%--            color:var(--text);--%>
<%--            margin-bottom:6px;--%>
<%--            display:block;--%>
<%--        }--%>

<%--        input, textarea, select{--%>
<%--            width:100%;--%>
<%--            padding:13px 16px;--%>
<%--            border-radius:14px;--%>
<%--            border:var(--border);--%>
<%--            font-size:.9rem;--%>
<%--            background:#fafafa;--%>
<%--            transition:.25s ease;--%>
<%--        }--%>

<%--        select{--%>
<%--            cursor:pointer;--%>
<%--        }--%>

<%--        textarea{--%>
<%--            resize:vertical;--%>
<%--            min-height:100px;--%>
<%--        }--%>

<%--        input:focus, textarea:focus, select:focus{--%>
<%--            outline:none;--%>
<%--            background:white;--%>
<%--            border-color:var(--accent);--%>
<%--            box-shadow:0 0 0 4px rgba(40,167,69,.18);--%>
<%--        }--%>

<%--        .password-wrap{position:relative}--%>

<%--        .toggle-password{--%>
<%--            position:absolute;--%>
<%--            right:16px;--%>
<%--            top:50%;--%>
<%--            transform:translateY(-50%);--%>
<%--            cursor:pointer;--%>
<%--            color:var(--muted);--%>
<%--        }--%>

<%--        .toggle-password:hover{color:var(--accent)}--%>

<%--        #password,#confirmPassword{padding-right:46px}--%>

<%--        #passwordStrength {--%>
<%--            margin-top: 8px;--%>
<%--        }--%>


<%--        .btn-submit{--%>
<%--            width:100%;--%>
<%--            margin-top:54px;--%>
<%--            padding:18px;--%>
<%--            border:none;--%>
<%--            border-radius:999px;--%>
<%--            background:linear-gradient(135deg,var(--accent),var(--accent-dark));--%>
<%--            color:white;--%>
<%--            font-size:1.1rem;--%>
<%--            font-weight:700;--%>
<%--            cursor:pointer;--%>
<%--            box-shadow:0 18px 40px rgba(40,167,69,.55);--%>
<%--        }--%>

<%--        .hidden{display:none!important}--%>

<%--        @media(max-width:768px){--%>
<%--            .grid{grid-template-columns:1fr}--%>
<%--            .signup-card{padding:38px 26px}--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>

<%--<body>--%>

<%--<div class="signup-card">--%>

<%--    <h1>Create Your Account</h1>--%>
<%--    <p class="subtitle">--%>
<%--        Registering as a <strong>${selectedRole}</strong> on EcoTrack--%>
<%--    </p>--%>

<%--    <c:choose>--%>
<%--        <c:when test="${selectedRole == 'Startup'}">--%>
<%--            <c:set var="startupClass" value=""/>--%>
<%--            <c:set var="investorClass" value="hidden"/>--%>
<%--        </c:when>--%>
<%--        <c:when test="${selectedRole == 'Investor'}">--%>
<%--            <c:set var="startupClass" value="hidden"/>--%>
<%--            <c:set var="investorClass" value=""/>--%>
<%--        </c:when>--%>
<%--        <c:otherwise>--%>
<%--            <c:set var="startupClass" value="hidden"/>--%>
<%--            <c:set var="investorClass" value="hidden"/>--%>
<%--        </c:otherwise>--%>
<%--    </c:choose>--%>

<%--    <c:set var="isStartup" value="${selectedRole == 'Startup'}"/>--%>
<%--    <c:set var="isInvestor" value="${selectedRole == 'Investor'}"/>--%>


<%--    <form action="/completeSignup" method="post" onsubmit="return validateForm()">--%>
<%--        <input type="hidden" name="userType" value="${selectedRole}">--%>

<%--        <!-- ACCOUNT -->--%>
<%--        <div class="section">--%>
<%--            <div class="section-title">Account Credentials</div>--%>
<%--            <div class="grid">--%>
<%--                <div>--%>
<%--                    <label>Email</label>--%>
<%--                    <input type="email" name="email" required>--%>
<%--                </div>--%>
<%--                <div></div>--%>
<%--                <div>--%>
<%--                    <label>Password</label>--%>
<%--                    <div class="password-wrap">--%>
<%--                        <input type="password" id="password" name="password" required>--%>
<%--                        <span class="toggle-password" onclick="togglePasswordVisibility('password','eye1')">--%>
<%--                            <i id="eye1" class="fas fa-eye-slash"></i>--%>
<%--                        </span>--%>
<%--                    </div>--%>
<%--                    <div style="grid-column:1/-1; margin-top:10px;">--%>

<%--                        <!-- Strength Text -->--%>
<%--                        <div id="passwordStrength" style="font-weight:600; margin-bottom:6px;"></div>--%>

<%--                        <!-- Strength Bar -->--%>
<%--                        <div style="height:6px; background:#e5e7eb; border-radius:4px; margin-bottom:10px;">--%>
<%--                            <div id="strengthBar" style="--%>
<%--            height:100%;--%>
<%--            width:0%;--%>
<%--            background:#dc3545;--%>
<%--            border-radius:4px;--%>
<%--            transition:width .3s ease;--%>
<%--        "></div>--%>
<%--                        </div>--%>

<%--                        <!-- Checklist -->--%>
<%--                        <ul id="passwordChecklist" style="--%>
<%--        list-style:none;--%>
<%--        padding-left:0;--%>
<%--        margin:0;--%>
<%--        font-size:.85rem;--%>
<%--        color:#6b7280;--%>
<%--    ">--%>
<%--                            <li id="ruleLength">✖ At least 10 characters</li>--%>
<%--                            <li id="ruleUpper">✖ One uppercase letter</li>--%>
<%--                            <li id="ruleLower">✖ One lowercase letter</li>--%>
<%--                            <li id="ruleNumber">✖ One number</li>--%>
<%--                            <li id="ruleSpace">✖ No spaces</li>--%>
<%--                        </ul>--%>

<%--                    </div>--%>

<%--                </div>--%>
<%--                <div>--%>
<%--                    <label>Confirm Password</label>--%>
<%--                    <div class="password-wrap">--%>
<%--                        <input type="password" id="confirmPassword" name="confirmPassword" required>--%>
<%--                        <span class="toggle-password" onclick="togglePasswordVisibility('confirmPassword','eye2')">--%>
<%--                            <i id="eye2" class="fas fa-eye-slash"></i>--%>
<%--                        </span>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <div id="passwordError" style="--%>
<%--                color:#dc3545;--%>
<%--                font-size:.85rem;--%>
<%--                font-weight:600;--%>
<%--                margin-top:8px;--%>
<%--                display:none;--%>
<%--            ">--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <!-- STARTUP -->--%>
<%--        <!-- STARTUP -->--%>
<%--        <div class="section ${startupClass}">--%>
<%--            <div class="section-title">Startup Details</div>--%>

<%--            <div class="grid">--%>

<%--                <!-- Company Name -->--%>
<%--                <div>--%>
<%--                    <label>Company Name</label>--%>
<%--                    <input type="text" name="companyName" placeholder="Registered startup name" ${isStartup ? "required" : ""}>--%>

<%--                </div>--%>

<%--                <!-- Industry -->--%>
<%--                <div>--%>
<%--                    <label>Industry</label>--%>
<%--                    <select name="industry" ${isStartup ? "required" : ""}>--%>
<%--                        <option value="">Select Industry</option>--%>
<%--                        <option>FinTech</option>--%>
<%--                        <option>HealthTech</option>--%>
<%--                        <option>EdTech</option>--%>
<%--                        <option>AgriTech</option>--%>
<%--                        <option>ClimateTech</option>--%>
<%--                        <option>SaaS</option>--%>
<%--                        <option>E-commerce</option>--%>
<%--                        <option>AI / ML</option>--%>
<%--                    </select>--%>
<%--                </div>--%>

<%--                <!-- Registration Number -->--%>
<%--                <div>--%>
<%--                    <label>Registration Number</label>--%>
<%--                    <input type="text" name="registrationNumber" placeholder="Govt. registration number" ${isStartup ? "required" : ""}>--%>
<%--                </div>--%>

<%--                <!-- Government ID -->--%>
<%--                <div>--%>
<%--                    <label>Government ID</label>--%>
<%--                    <input type="text" name="governmentId" placeholder="PAN / CIN / GST / other ID" ${isStartup ? "required" : ""}>--%>
<%--                </div>--%>

<%--                <!-- Founding Date -->--%>
<%--                <div>--%>
<%--                    <label>Founding Date</label>--%>
<%--                    <input type="date" name="foundingDate" ${isStartup ? "required" : ""}>--%>
<%--                </div>--%>

<%--                <div></div>--%>

<%--                <!-- Funding Ask -->--%>
<%--                <div>--%>
<%--                    <label>Funding Ask (USD)</label>--%>
<%--                    <input type="number"--%>
<%--                           name="fundingAsk"--%>
<%--                           placeholder="e.g. 500000"--%>
<%--                           min="0"--%>
<%--                           step="1000"--%>
<%--                            ${isStartup ? "required" : ""}>--%>
<%--                </div>--%>

<%--                <!-- Equity Offered -->--%>
<%--                <div>--%>
<%--                    <label>Equity Offered (%)</label>--%>
<%--                    <input type="number"--%>
<%--                           name="equityOffered"--%>
<%--                           placeholder="e.g. 10"--%>
<%--                           min="0"--%>
<%--                           max="100"--%>
<%--                           step="0.1"--%>
<%--                            ${isStartup ? "required" : ""}>--%>
<%--                </div>--%>

<%--                <!-- Description -->--%>
<%--                <div style="grid-column:1/-1">--%>
<%--                    <label>Startup Description</label>--%>
<%--                    <textarea name="description"--%>
<%--                        placeholder="Briefly describe your startup, its mission, and the problem it solves."--%>
<%--                                ${isStartup ? "required" : ""}></textarea>--%>
<%--                    </textarea>--%>
<%--                </div>--%>

<%--            </div>--%>
<%--        </div>--%>


<%--        <!-- INVESTOR -->--%>
<%--        <div class="section ${investorClass}">--%>
<%--            <div class="section-title">Investor Details</div>--%>
<%--            <div class="grid">--%>
<%--                <div><label>Investor Name</label><input type="text" name="investorName"></div>--%>
<%--                <div><label>Investment Firm</label><input type="text" name="investmentFirm"></div>--%>

<%--                <div>--%>
<%--                    <label>Investor Type</label>--%>
<%--                    <select name="investorType">--%>
<%--                        <option value="">Select Type</option>--%>
<%--                        <option>Angel Investor</option>--%>
<%--                        <option>Venture Capital</option>--%>
<%--                        <option>Private Equity</option>--%>
<%--                        <option>Corporate Investor</option>--%>
<%--                    </select>--%>
<%--                </div>--%>

<%--                <div>--%>
<%--                    <label>Preferred Domains</label>--%>
<%--                    <select name="preferredDomains">--%>
<%--                        <option value="">Select Domain</option>--%>
<%--                        <option>FinTech</option>--%>
<%--                        <option>HealthTech</option>--%>
<%--                        <option>EdTech</option>--%>
<%--                        <option>ClimateTech</option>--%>
<%--                        <option>SaaS</option>--%>
<%--                        <option>AI / ML</option>--%>
<%--                    </select>--%>
<%--                </div>--%>

<%--                <div>--%>
<%--                    <label>Funding Stages</label>--%>
<%--                    <select name="fundingStages">--%>
<%--                        <option value="">Select Stage</option>--%>
<%--                        <option>Pre-Seed</option>--%>
<%--                        <option>Seed</option>--%>
<%--                        <option>Series A</option>--%>
<%--                        <option>Series B+</option>--%>
<%--                    </select>--%>
<%--                </div>--%>

<%--                <div><label>Location</label><input type="text" name="location"></div>--%>
<%--                <div><label>Website</label><input type="text" name="website"></div>--%>
<%--                <div>--%>
<%--                    <label>Investment Range (USD)</label>--%>
<%--                    <select name="investmentRangeUsd">--%>
<%--                        <option value="">Select Range</option>--%>
<%--                        <option value="10000-50000">$10k – $50k</option>--%>
<%--                        <option value="50000-250000">$50k – $250k</option>--%>
<%--                        <option value="250000-1000000">$250k – $1M</option>--%>
<%--                        <option value="1000000-5000000">$1M – $5M</option>--%>
<%--                        <option value="5000000-10000000">$5M – $10M</option>--%>
<%--                        <option value="10000000+">$10M+</option>--%>
<%--                    </select>--%>
<%--                </div>--%>


<%--                <div style="grid-column:1/-1">--%>
<%--                    <label>LinkedIn</label>--%>
<%--                    <input type="text" name="linkedin">--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>

<%--        <button type="submit" class="btn-submit">Create Account</button>--%>
<%--    </form>--%>
<%--</div>--%>

<%--<script>--%>
<%--    function togglePasswordVisibility(id, eye){--%>
<%--        const f=document.getElementById(id);--%>
<%--        const i=document.getElementById(eye);--%>
<%--        if(f.type==="password"){--%>
<%--            f.type="text";--%>
<%--            i.classList.replace("fa-eye-slash","fa-eye");--%>
<%--        } else {--%>
<%--            f.type="password";--%>
<%--            i.classList.replace("fa-eye","fa-eye-slash");--%>
<%--        }--%>
<%--    }--%>

<%--    const passwordInput = document.getElementById("password");--%>
<%--    const confirmInput = document.getElementById("confirmPassword");--%>
<%--    const strengthText = document.getElementById("passwordStrength");--%>
<%--    const strengthBar = document.getElementById("strengthBar");--%>
<%--    const ruleLength = document.getElementById("ruleLength");--%>
<%--    const ruleUpper = document.getElementById("ruleUpper");--%>
<%--    const ruleLower = document.getElementById("ruleLower");--%>
<%--    const ruleNumber = document.getElementById("ruleNumber");--%>
<%--    const ruleSpace = document.getElementById("ruleSpace");--%>

<%--    function checkRule(condition, element){--%>
<%--        if(condition){--%>
<%--            element.innerHTML = element.innerHTML.replace("✖","✔");--%>
<%--            element.style.color = "#28a745";--%>
<%--            return 1;--%>
<%--        } else {--%>
<%--            element.innerHTML = element.innerHTML.replace("✔","✖");--%>
<%--            element.style.color = "#dc3545";--%>
<%--            return 0;--%>
<%--        }--%>
<%--    }--%>

<%--    passwordInput.addEventListener("input", function(){--%>
<%--        const value = passwordInput.value;--%>

<%--        let score = 0;--%>

<%--        score += checkRule(value.length >= 10, ruleLength);--%>
<%--        score += checkRule(/[A-Z]/.test(value), ruleUpper);--%>
<%--        score += checkRule(/[a-z]/.test(value), ruleLower);--%>
<%--        score += checkRule(/[0-9]/.test(value), ruleNumber);--%>
<%--        score += checkRule(!/\s/.test(value), ruleSpace);--%>

<%--        if(score <= 2){--%>
<%--            strengthText.innerText = "Weak Password";--%>
<%--            strengthText.style.color = "#dc3545";--%>
<%--            strengthBar.style.width = "30%";--%>
<%--            strengthBar.style.background = "#dc3545";--%>
<%--        }--%>
<%--        else if(score === 3 || score === 4){--%>
<%--            strengthText.innerText = "Moderate Password";--%>
<%--            strengthText.style.color = "#ffc107";--%>
<%--            strengthBar.style.width = "65%";--%>
<%--            strengthBar.style.background = "#ffc107";--%>
<%--        }--%>
<%--        else{--%>
<%--            strengthText.innerText = "Strong Password";--%>
<%--            strengthText.style.color = "#28a745";--%>
<%--            strengthBar.style.width = "100%";--%>
<%--            strengthBar.style.background = "#28a745";--%>
<%--        }--%>
<%--        if(score === 5){--%>
<%--            document.getElementById("passwordChecklist").style.opacity = "0.6";--%>
<%--        } else {--%>
<%--            document.getElementById("passwordChecklist").style.opacity = "1";--%>
<%--        }--%>


<%--    });--%>

<%--    function validateForm(){--%>
<%--        const password = passwordInput.value.trim();--%>
<%--        const confirmPassword = confirmInput.value.trim();--%>

<%--        const pattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{10,}$/;--%>

<%--        if(!pattern.test(password)){--%>
<%--            alert("Please meet all password requirements before submitting.");--%>
<%--            return false;--%>
<%--        }--%>

<%--        if(password !== confirmPassword){--%>
<%--            alert("Passwords do not match.");--%>
<%--            return false;--%>
<%--        }--%>

<%--        return true;--%>
<%--    }--%>
<%--</script>--%>


<%--</body>--%>
<%--</html>--%>
