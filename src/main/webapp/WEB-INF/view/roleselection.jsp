<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Your Role - Startup Ecosystem</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-green: #28a745;
            --secondary-green: #218838;
            --white: #ffffff;
            --light-bg: #f4f7f6;
            --dark-text: #333;
        }

        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--light-bg), #e0e0e0);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .signup-container {
            max-width: 550px;
            width: 100%;
            background: var(--white);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h1 {
            color: var(--primary-green);
            font-weight: 700;
            margin-bottom: 5px;
            font-size: 2.2rem;
        }

        .sub-heading {
            color: var(--subtle-text);
            margin-bottom: 30px;
            font-size: 1rem;
        }

        /* --- Role Card Styles --- */
        .role-card-group {
            display: flex;
            gap: 20px;
            margin: 30px 0;
        }

        .role-card {
            flex-basis: 50%;
            padding: 30px 20px;
            border: 2px solid #ddd;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            background-color: #f9f9f9;
        }

        .role-card:hover {
            border-color: var(--primary-green);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.2);
            transform: translateY(-5px);
        }

        .role-card.selected {
            border-color: var(--primary-green);
            background-color: #e6f5e6;
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }

        .role-card i {
            font-size: 2.5rem;
            color: var(--primary-green);
            margin-bottom: 10px;
        }

        .role-card h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-text);
        }

        /* Hide default radio button */
        .role-card input[type="radio"] {
            display: none;
        }

        /* --- Button Styles --- */
        .btn-custom {
            background-color: var(--primary-green);
            border: none;
            padding: 12px 0;
            border-radius: 50px; /* Pill shape */
            font-weight: 600;
            color: var(--white);
            width: 100%;
            transition: background-color 0.3s ease, transform 0.2s ease;
            cursor: pointer;
        }

        .btn-custom:hover {
            background-color: var(--secondary-green);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.4);
        }

        .btn-custom:disabled {
            background-color: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .login-link {
            margin-top: 30px;
            font-size: 0.9em;
            color: var(--subtle-text);
        }

        .login-link a {
            color: var(--primary-green);
            font-weight: 600;
            text-decoration: none;
            transition: text-decoration 0.2s ease;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="signup-container">
    <h1>Select Your Role</h1>
    <p class="sub-heading">Get started by telling us who you are.</p>

    <form id="roleForm" action="/selectRole" method="POST">

        <div class="role-card-group">

            <label class="role-card" for="startupRole">
                <i class="fas fa-rocket"></i>
                <h3>I am a Startup</h3>
                <p class="text-sm text-gray-500 mt-2">I am looking for funding and growth opportunities.</p>
                <input type="radio" id="startupRole" name="role" value="Startup" onclick="selectRole(this)" <c:if test="${param.role == 'Startup' || empty param.role}">checked</c:if>>
            </label>

            <label class="role-card" for="investorRole">
                <i class="fas fa-hand-holding-usd"></i>
                <h3>I am an Investor</h3>
                <p class="text-sm text-gray-500 mt-2">I am looking to discover and invest in ventures.</p>
                <input type="radio" id="investorRole" name="role" value="Investor" onclick="selectRole(this)" <c:if test="${param.role == 'Investor'}">checked</c:if>>
            </label>
        </div>

        <button type="submit" id="continueButton" class="btn-custom">
            Continue
        </button>
    </form>

    <p class="login-link">
        Already Signed Up? <a href="/login">Here's the login page.</a>
    </p>

</div>

<script>
    const continueButton = document.getElementById('continueButton');
    const roleCards = document.querySelectorAll('.role-card');
    const startupRadio = document.getElementById('startupRole');
    const investorRadio = document.getElementById('investorRole');

    function selectRole(radio) {
        // Remove 'selected' class from all cards
        roleCards.forEach(card => card.classList.remove('selected'));

        // Add 'selected' class to the clicked card
        radio.parentElement.classList.add('selected');

        // The button is always enabled in your original simple design,
        // so we don't need to disable it unless you want to add that logic back.
        // continueButton.disabled = false;
    }

    // Initialize state on page load based on current selection (or default)
    document.addEventListener('DOMContentLoaded', () => {
        let checkedRadio = document.querySelector('input[name="role"]:checked');

        if (!checkedRadio) {
            // Default to Startup if none is checked (based on your original JSP logic)
            startupRadio.checked = true;
            checkedRadio = startupRadio;
        }

        if (checkedRadio) {
            selectRole(checkedRadio);
        }
    });
</script>

</body>
</html>