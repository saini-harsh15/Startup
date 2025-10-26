<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Startup Ecosystem</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #1d7b37;
            --white: #ffffff;
            --light-bg: #f4f7f6;
            --dark-text: #333;
        }

        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background-color: var(--light-bg);
        }

        .login-wrapper {
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- Side Panel with Animated Gradient --- */
        .side-panel {
            width: 40%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: var(--white);
            background-image: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            background-size: 400% 400%;
            animation: gradientMove 15s ease infinite;
            box-shadow: 5px 0 15px rgba(0, 0, 0, 0.3);
            padding: 40px;
            text-align: center;
        }

        @keyframes gradientMove {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .side-panel h1 {
            font-weight: 800; /* Extra bold */
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.2);
        }

        .side-panel p {
            font-weight: 400;
            opacity: 0.9;
        }

        .side-panel i {
            font-size: 4rem;
            margin-bottom: 20px;
        }

        /* --- Form Panel --- */
        .form-panel {
            width: 60%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--white);
            padding: 40px;
        }

        .login-container {
            max-width: 450px;
            width: 100%;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15); /* Sharper shadow */
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-label {
            font-weight: 600;
            color: var(--dark-text);
        }

        /* Password Toggle Styling */
        .password-container {
            position: relative;
        }
        .form-control {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #ddd;
            transition: border-color 0.3s ease;
            padding-right: 40px; /* Space for the icon */
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.25);
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

        .btn-custom {
            background-color: var(--primary-color);
            border: none;
            padding: 12px 0;
            border-radius: 50px; /* Pill shape */
            font-weight: 600;
            color: var(--white);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .btn-custom:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(40, 167, 69, 0.5); /* Stronger hover shadow */
        }

        /* Message Alerts */
        .alert {
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .side-panel {
                display: none;
            }
            .form-panel {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div class="side-panel">
        <i class="fas fa-lock"></i>
        <h1>Startup Ecosystem</h1>
        <p class="lead">Connect, Fund, Grow.</p>
        <p>Your centralized platform for innovative ventures and smart investments.</p>

    </div>

    <div class="form-panel">
        <div class="login-container">
            <h2 class="text-center mb-4" style="color: var(--primary-color); font-weight: 700;">Secure Login</h2>
            <p class="text-center mb-4 text-muted">Enter your credentials to access your dashboard.</p>

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

                <div class="mb-4">
                    <label for="password" class="form-label">Password</label>
                    <div class="password-container">
                        <input type="password" name="password" class="form-control" id="password" required>
                        <span class="toggle-password" onclick="togglePasswordVisibility()">
                            <i id="eyeIcon" class="fas fa-eye-slash"></i>
                        </span>
                    </div>
                </div>

                <button type="submit" class="btn btn-custom w-100 mb-3">Login</button>
            </form>

            <p class="text-center mt-4">Don't have an account?
                <a href="/" style="color: var(--primary-color); text-decoration: none; font-weight: 600;">Sign Up</a>
            </p>
        </div>
    </div>
</div>

<script>
    function togglePasswordVisibility() {
        const passwordField = document.getElementById('password');
        const eyeIcon = document.getElementById('eyeIcon');

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
</script>

</body>
</html>