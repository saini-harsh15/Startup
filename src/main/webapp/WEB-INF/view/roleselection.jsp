<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Role Selection - Startup Ecosystem</title>
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
            background-color: var(--background-color);
            margin: 0;
            padding-top: 60px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            max-width: 500px;
            background-color: var(--card-bg);
            padding: 50px;
            margin: auto;
            border-radius: 16px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
            text-align: center;
            animation: fadeIn 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            max-height: 90vh;
            overflow-y: auto;
        }

        h1 {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 700;
            letter-spacing: 1px;
            font-size: 2.2rem;
        }

        .sub-heading {
            color: var(--subtle-text);
            margin-bottom: 30px;
            font-size: 1rem;
        }

        .form-check {
            text-align: left;
            font-size: 1.1em;
            margin-bottom: 1.5rem;
            padding-left: 2.5rem;
        }

        .form-check-label {
            font-weight: 500;
            color: var(--text-color);
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-green {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            width: 100%;
            padding: 14px;
            font-size: 1.1rem;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .btn-green:hover {
            background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .login-link {
            margin-top: 30px;
            font-size: 0.9em;
            color: var(--subtle-text);
        }

        .login-link a {
            color: var(--primary-color);
            font-weight: bold;
            text-decoration: none;
            transition: text-decoration 0.2s ease;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Navbar */
        .navbar {
            background-color: var(--card-bg) !important;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 0.75rem 1.5rem;
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--primary-color) !important;
            font-size: 1.3rem;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="/">Startup Ecosystem</a>
    </div>
</nav>

<div class="container">
    <h1>Select Your Role</h1>
    <p class="sub-heading">Get started by telling us who you are.</p>
    <form action="/selectRole" method="post">
        <div class="form-check">
            <input class="form-check-input" type="radio" name="role" id="startupRole" value="Startup" checked>
            <label class="form-check-label" for="startupRole">Startup</label>
        </div>
        <div class="form-check">
            <input class="form-check-input" type="radio" name="role" id="investorRole" value="Investor">
            <label class="form-check-label" for="investorRole">Investor</label>
        </div>
        <button type="submit" class="btn-green mt-3">Continue</button>
    </form>
    <p class="login-link">
        Already Signed Up? <a href="/login">Here's the login page.</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>