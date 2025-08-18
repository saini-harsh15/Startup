<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Success - Startup Ecosystem</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f0f8ff;
            font-family: 'Segoe UI', sans-serif;
            padding-top: 70px; /* for navbar spacing */
        }
        .success-container {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            font-size: 70px;
            color: #28a745;
            animation: pop 0.5s ease-out;
        }
        @keyframes pop {
            0% { transform: scale(0.5); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm fixed-top">
    <div class="container-fluid px-4">
        <a class="navbar-brand text-success fw-bold" href="/">Startup Ecosystem</a>
        <div class="d-flex ms-auto">
            <a class="btn btn-outline-secondary" href="/contact">Contact Us</a>
        </div>
    </div>
</nav>

<div class="success-container">
    <div class="success-icon">✅</div>
    <h1 class="mt-4">Account Created!</h1>
    <p class="lead">Your account has been successfully created and verified. You can now proceed to login or explore the dashboard.</p>
    <a href="/" class="btn btn-success mt-3">🏠 Go to Home</a>
    <a href="/login" class="btn btn-outline-primary mt-3 ms-2">🔐 Login Now</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
