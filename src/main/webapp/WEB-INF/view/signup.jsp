<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Signup - Startup Ecosystem</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-color: #28a745; /* Consistent Green */
            --secondary-color: #1d7b37;
            --white: #ffffff;
            --light-bg: #f4f7f6;
            --dark-text: #333;
            --border-color: #ddd;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f4f8, #e4e7eb);
            margin: 0;
            padding-top: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        /* --- Registration Card (Same as Login container style) --- */
        .card-custom {
            max-width: 600px;
            width: 90%;
            background: var(--white);
            padding: 40px;
            border-radius: 18px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.8s ease-in-out;
            margin-top: 30px;
            margin-bottom: 30px;
            overflow-y: auto;
            max-height: 90vh;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            color: var(--primary-color);
            text-align: center;
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 5px;
        }

        .role-message {
            color: var(--dark-text);
            font-weight: 600;
            display: block;
            text-align: center;
            margin-bottom: 20px;
            font-size: 1rem;
        }

        .role-message .role-accent {
            color: var(--dark-text) !important;
            background-color: transparent !important;
            padding: 0;
            border-radius: 0;
            font-weight: 700 !important;
            font-size: 1em;
            display: inline;
            box-shadow: none !important;
        }

        /* --- Form Elements --- */
        label {
            font-weight: 600;
            color: var(--dark-text);
            margin-bottom: 5px;
            display: block;
            font-size: 0.95rem;
            margin-top: 15px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"],
        textarea {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 15px;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            transition: border-color 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            font-size: 1rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        input:focus,
        textarea:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
        }

        /* Password Toggle Styling */
        .password-container {
            position: relative;
        }
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #666;
            transition: color 0.2s ease;
            z-index: 10;
        }
        .toggle-password:hover {
            color: var(--primary-color);
        }

        #password, #confirmPassword {
            padding-right: 40px;
        }

        /* --- Button Style (Pill-shaped) --- */
        .btn-custom {
            width: 100%;
            padding: 14px;
            font-size: 1.1rem;
            font-weight: 600;
            background: var(--primary-color);
            border: none;
            color: var(--white);
            border-radius: 50px; /* Pill shape */
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease;
            box-shadow: 0 6px 12px rgba(40, 167, 69, 0.4);
            margin-top: 30px;
        }

        .btn-custom:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(40, 167, 69, 0.6);
        }

        .hidden {
            display: none !important;
        }

        /* Navbar */
        .navbar {
            background-color: var(--white) !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 0.5rem 1.5rem;
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Detail Headers for Startup/Investor sections - FIXED */
        .detail-header {
            background-color: transparent; /* Changed to transparent */
            color: var(--primary-color); /* Changed text color to primary green */
            padding: 10px 0; /* Adjusted padding */
            border-radius: 0; /* Removed border-radius */
            margin-top: 30px;
            margin-bottom: 15px;
            font-weight: 700; /* Made it bolder for a heading look */
            font-size: 1.5rem; /* Increased font size */
            text-align: center;
            border-bottom: 2px solid var(--primary-color); /* Added a subtle line */
        }

    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="/">
            Startup Ecosystem
        </a>
    </div>
</nav>

<div class="card-custom">
    <div class="card-header-custom">
        <h1>Create Your Account</h1>

        <p class="role-message">You are registering as a
            <span class="role-accent">${selectedRole}</span>. Complete the form below.
        </p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>

    <c:choose>
        <c:when test="${selectedRole == 'Startup'}">
            <c:set var="startupClass" value="" />
            <c:set var="investorClass" value="hidden" />
        </c:when>
        <c:when test="${selectedRole == 'Investor'}">
            <c:set var="startupClass" value="hidden" />
            <c:set var="investorClass" value="" />
        </c:when>
        <c:otherwise>
            <c:set var="startupClass" value="hidden" />
            <c:set var="investorClass" value="hidden" />
        </c:otherwise>
    </c:choose>

    <form action="/completeSignup" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="userType" value="${selectedRole}">

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required class="form-control">

        <label for="password">Password:</label>
        <div class="password-container">
            <input type="password" id="password" name="password" required class="form-control">
            <span class="toggle-password" onclick="togglePasswordVisibility('password', 'eyeIcon1')">
                <i id="eyeIcon1" class="fas fa-eye-slash"></i>
            </span>
        </div>

        <label for="confirmPassword">Confirm Password:</label>
        <div class="password-container">
            <input type="password" id="confirmPassword" name="confirmPassword" required class="form-control">
            <span class="toggle-password" onclick="togglePasswordVisibility('confirmPassword', 'eyeIcon2')">
                <i id="eyeIcon2" class="fas fa-eye-slash"></i>
            </span>
        </div>

        <div id="startupFields" class="${startupClass}">
            <div class="detail-header">Startup Details</div>
            <label for="industry">Industry:</label>
            <input type="text" id="industry" name="industry" class="form-control">

            <label for="companyName">Company Name (for verification):</label>
            <input type="text" id="companyName" name="companyName" class="form-control">

            <label for="description">Description:</label>
            <textarea id="description" name="description" class="form-control"></textarea>

            <label for="registrationNumber">Registration Number:</label>
            <input type="text" id="registrationNumber" name="registrationNumber" class="form-control">

            <label for="governmentId">Government ID:</label>
            <input type="text" id="governmentId" name="governmentId" class="form-control">

            <label for="foundingDate">Founding Date:</label>
            <input type="date" id="foundingDate" name="foundingDate" class="form-control">
        </div>

        <div id="investorFields" class="${investorClass}">
            <div class="detail-header">Investor Details</div>
            <label for="investorName">Investor Name:</label>
            <input type="text" id="investorName" name="investorName" class="form-control">

            <label for="investmentFirm">Investment Firm:</label>
            <input type="text" id="investmentFirm" name="investmentFirm" class="form-control">

            <label for="investorType">Investor Type:</label>
            <input type="text" id="investorType" name="investorType" class="form-control">

            <label for="preferredDomains">Preferred Domains (comma-separated):</label>
            <input type="text" id="preferredDomains" name="preferredDomains" class="form-control">

            <label for="fundingStages">Funding Stages (comma-separated):</label>
            <input type="text" id="fundingStages" name="fundingStages" class="form-control">

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" class="form-control">

            <label for="website">Website:</label>
            <input type="text" id="website" name="website" class="form-control">

            <label for="investmentRangeUsd">Investment Range (USD):</label>
            <input type="text" id="investmentRangeUsd" name="investmentRangeUsd" class="form-control">

            <label for="linkedin">LinkedIn Profile URL:</label>
            <input type="text" id="linkedin" name="linkedin" class="form-control">
        </div>

        <button type="submit" class="btn-custom">Sign Up</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function togglePasswordVisibility(fieldId, iconId) {
        const passwordField = document.getElementById(fieldId);
        const eyeIcon = document.getElementById(iconId);

        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            eyeIcon.classList.remove('fa-eye-slash');
            eyeIcon.classList.add('fa-eye');
        } else {
            passwordField.type = 'password';
            eyeIcon.classList.remove('fa-eye');
            eyeIcon.classList.add('fa-eye-slash');
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const startupFields = document.getElementById('startupFields');
        const investorFields = document.getElementById('investorFields');
        const userTypeInput = document.querySelector('input[name="userType"]');

        function toggleRequiredAttributes(role) {
            const isStartup = (role === 'Startup');

            // Apply 'required' only to the visible fields
            startupFields.querySelectorAll('input, textarea').forEach(field => {
                field.required = isStartup;
            });
            investorFields.querySelectorAll('input, textarea').forEach(field => {
                field.required = !isStartup;
            });
        }

        // Initial setup on page load
        const roleValue = userTypeInput ? userTypeInput.value : '';
        if (roleValue) {
            toggleRequiredAttributes(roleValue);
        }
    });

    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            alert("Passwords do not match. Please try again.");
            return false;
        }

        return true;
    }
</script>
</body>
</html>