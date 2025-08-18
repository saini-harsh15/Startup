<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background-color: #f4f7f6;
            font-family: 'Segoe UI', sans-serif;
        }

        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 40px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            animation: fadeInUp 0.6s ease-in-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-label {
            font-weight: 600;
        }

        .form-control:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .btn-primary {
            background-color: #28a745;
            border: none;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #218838;
        }

        .navbar-custom {
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .navbar-brand {
            font-weight: bold;
            color: #28a745 !important;
        }

        .success-message {
            color: green;
            font-weight: bold;
        }

        .error-message {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<!-- Reusable Navbar -->
<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="/">StartupEcosystem</a>
    </div>
</nav>

<!-- Login Form -->
<div class="login-container">
    <h2 class="text-center mb-4">Welcome Back!</h2>

    <% String message = (String) request.getAttribute("message"); %>
    <% if (message != null) { %>
    <div class="alert <%= message.contains("successfully") ? "alert-success" : "alert-danger" %>" role="alert">
        <%= message %>
    </div>
    <% } %>

    <form action="/login" method="post">
        <div class="mb-3">
            <label for="email" class="form-label">Email address</label>
            <input type="email" name="email" class="form-control" id="email" required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" name="password" class="form-control" id="password" required>
        </div>

        <button type="submit" class="btn btn-primary w-100">Login</button>
    </form>

    <p class="text-center mt-3">Don't have an account? <a href="/">Sign Up</a></p>
</div>

</body>
</html>
