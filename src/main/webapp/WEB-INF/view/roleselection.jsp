<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Join EcoTrack</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --accent: #28a745;
            --accent-dark: #1e7e34;
            --bg-dark: #e9eef3;
            --card-bg: #ffffff;
            --card-soft: #f4f7fa;
            --text: #0f172a;
            --muted: #5f6f81;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            height: 100vh;
            overflow: hidden;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #dde6ed, #f0f4f8);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 720px;
            background: linear-gradient(145deg, #ffffff, #f4f7fa);
            border-radius: 28px;
            padding: 50px 45px;
            box-shadow:
                    0 25px 60px rgba(0,0,0,0.15),
                    inset 0 1px 0 rgba(255,255,255,0.6);
            text-align: center;
        }

        h1 {
            font-size: 2.3rem;
            font-weight: 800;
            margin-bottom: 12px;
            color: var(--text);
        }

        .sub-heading {
            color: var(--muted);
            margin-bottom: 45px;
            font-size: 0.95rem;
        }

        .role-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 26px;
        }

        .role-card {
            padding: 42px 26px;
            border-radius: 22px;
            background: var(--card-soft);
            text-decoration: none;
            color: var(--text);
            transition: all .35s ease;
            box-shadow: 0 12px 28px rgba(0,0,0,0.08);
            border: 2px solid transparent;
        }

        .role-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 55px rgba(40,167,69,0.35);
            border-color: var(--accent);
            background: white;
        }

        .icon-wrapper {
            width: 68px;
            height: 68px;
            margin: 0 auto 18px auto;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 15px 35px rgba(40,167,69,0.45);
            transition: .3s ease;
        }

        .icon-wrapper i {
            font-size: 1.8rem;
            color: white;
        }

        .role-card:hover .icon-wrapper {
            transform: scale(1.08);
        }

        .role-card h3 {
            font-size: 1.3rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .role-card p {
            font-size: 0.9rem;
            color: var(--muted);
            line-height: 1.5;
        }

        .login-link {
            margin-top: 40px;
            font-size: 0.9rem;
            color: var(--muted);
        }

        .login-link a {
            color: var(--accent);
            font-weight: 600;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 700px) {
            body {
                overflow: auto;
                height: auto;
                padding: 30px 20px;
            }
            .role-group {
                grid-template-columns: 1fr;
            }
            .container {
                padding: 40px 25px;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <h1>Join EcoTrack</h1>
    <p class="sub-heading">Choose your role and start building meaningful connections.</p>

    <div class="role-group">

        <a href="/signup/startup" class="role-card">
            <div class="icon-wrapper">
                <i class="fas fa-lightbulb"></i>
            </div>
            <h3>Startup Founder</h3>
            <p>Present your innovation, attract capital, and scale your vision.</p>
        </a>

        <a href="/signup/investor" class="role-card">
            <div class="icon-wrapper">
                <i class="fas fa-chart-line"></i>
            </div>
            <h3>Investor</h3>
            <p>Discover high-growth startups and expand your investment portfolio.</p>
        </a>

    </div>

    <p class="login-link">
        Already registered? <a href="/login">Login here</a>
    </p>

</div>

</body>
</html>
