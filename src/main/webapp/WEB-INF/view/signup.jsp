<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Signup</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #34c759;
            --secondary-color: #2e8b57;
            --background-color: #f0f2f5;
            --card-bg: #ffffff;
            --text-color: #333;
            --subtle-text: #666;
            --border-color: #e0e0e0;
        }

        body {
            font-family: 'Inter', 'Segoe UI', sans-serif;
            background: var(--background-color);
            margin: 0;
            padding-top: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            max-width: 550px;
            background: var(--card-bg);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1), 0 4px 8px rgba(0, 0, 0, 0.08);
            animation: fadeIn 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            margin-top: 20px;
            margin-bottom: 20px;
            overflow-y: auto;
            max-height: 85vh;
        }

        h1 {
            color: var(--primary-color);
            text-align: center;
            margin-bottom: 5px;
            font-weight: 700;
            font-size: 2rem;
            letter-spacing: 1px;
        }

        p.sub {
            color: var(--subtle-text);
            text-align: center;
            margin-bottom: 25px;
            font-size: 0.9rem;
        }

        label {
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 5px;
            display: block;
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
            box-shadow: 0 0 0 3px rgba(52, 199, 89, 0.2);
        }

        .btn-green {
            width: 100%;
            padding: 14px;
            font-size: 1.1rem;
            font-weight: 600;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            border-radius: 10px;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 10px;
        }

        .btn-green:hover {
            background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hidden {
            display: none;
        }

        /* Navbar */
        .navbar {
            background-color: var(--card-bg) !important;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 0.5rem 1.5rem; /* Decreased padding to reduce vertical size */
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
            font-size: 1.2rem; /* Decreased font size for a smaller look */
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .navbar .btn-outline-secondary {
            color: var(--primary-color);
            border-color: var(--primary-color);
            transition: all 0.2s ease-in-out;
        }

        .navbar .btn-outline-secondary:hover {
            background-color: var(--primary-color);
            color: white;
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

<div class="container">
    <h1 class="mb-4">Create Your Account</h1>
    <p class="sub">Join the ecosystem and unlock new opportunities!</p>

    <c:if test="${not empty error}">
        <div class="alert alert-danger" role="alert">${error}</div>
    </c:if>

    <form action="/completeSignup" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="userType" value="${selectedRole}">

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required class="form-control">

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required class="form-control">

        <label for="confirmPassword">Confirm Password:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required class="form-control">

        <div id="startupFields" class="${selectedRole == 'Startup' ? '' : 'hidden'}">
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

        <div id="investorFields" class="${selectedRole == 'Investor' ? '' : 'hidden'}">
            <label for="investorName">Investor Name:</label>
            <input type="text" id="investorName" name="investorName" class="form-control">

            <label for="investmentFirm">Investment Firm:</label>
            <input type="text" id="investmentFirm" name="investmentFirm" class="form-control">
        </div>

        <button type="submit" class="btn-green mt-3 shadow">Sign Up</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
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
        toggleRequiredAttributes(userTypeInput.value);
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