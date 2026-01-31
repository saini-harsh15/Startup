<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Your Role | EcoTrack</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* ================= THEME ================= */
        :root {
            --accent: #28a745;
            --accent-soft: rgba(40,167,69,0.15);

            --bg: #f3f6f9;
            --card: #ffffff;
            --text: #0f172a;
            --muted: #64748b;

            --border: 1px solid rgba(15,23,42,0.06);
            --shadow-sm: 0 6px 18px rgba(0,0,0,0.08);
            --shadow-md: 0 24px 48px rgba(0,0,0,0.14);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            background:
                    radial-gradient(1200px 600px at top left, rgba(40,167,69,0.12), transparent),
                    radial-gradient(1000px 500px at bottom right, rgba(40,167,69,0.08), transparent),
                    var(--bg);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        /* ================= CONTAINER ================= */
        .signup-container {
            width: 100%;
            max-width: 560px;
            background: var(--card);
            border-radius: 26px;
            padding: 42px 38px;
            border: var(--border);
            box-shadow: var(--shadow-md);
            animation: fadeUp .8s ease;
            text-align: center;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* ================= BRAND ================= */
        .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 24px;
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--accent);
        }

        .brand i {
            width: 42px;
            height: 42px;
            border-radius: 14px;
            background: var(--accent);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }

        .brand span {
            color: var(--text);
        }

        /* ================= HEADINGS ================= */
        h1 {
            font-size: 2.1rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .sub-heading {
            color: var(--muted);
            font-size: 1rem;
            margin-bottom: 36px;
        }

        /* ================= ROLE CARDS ================= */
        .role-card-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 22px;
            margin-bottom: 36px;
        }

        .role-card {
            padding: 32px 22px;
            border-radius: 22px;
            border: 2px solid transparent;
            background: #f9fbfa;
            cursor: pointer;
            transition: .3s ease;
            position: relative;
            text-align: center;
        }

        .role-card::before {
            content: "";
            position: absolute;
            inset: 0;
            border-radius: 22px;
            background: linear-gradient(135deg, var(--accent), #1f7f3a);
            opacity: 0;
            transition: .3s ease;
            z-index: 0;
        }

        .role-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-sm);
        }

        .role-card.selected::before {
            opacity: 0.08;
        }

        .role-card.selected {
            border-color: var(--accent);
            box-shadow: 0 18px 40px rgba(40,167,69,0.35);
        }

        .role-card * {
            position: relative;
            z-index: 1;
        }

        .role-card i {
            font-size: 2.6rem;
            color: var(--accent);
            margin-bottom: 14px;
        }

        .role-card h3 {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .role-card p {
            font-size: 0.9rem;
            color: var(--muted);
            line-height: 1.5;
        }

        .role-card input {
            display: none;
        }

        /* ================= BUTTON ================= */
        .btn-custom {
            width: 100%;
            background: linear-gradient(135deg, var(--accent), #1f7f3a);
            color: white;
            border: none;
            padding: 14px 0;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 999px;
            cursor: pointer;
            transition: .3s ease;
            box-shadow: 0 10px 26px rgba(40,167,69,0.45);
        }

        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 36px rgba(40,167,69,0.55);
        }

        /* ================= LOGIN LINK ================= */
        .login-link {
            margin-top: 32px;
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

        /* ================= RESPONSIVE ================= */
        @media (max-width: 600px) {
            .role-card-group {
                grid-template-columns: 1fr;
            }

            .signup-container {
                padding: 34px 26px;
            }

            h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>

<body>

<div class="signup-container">

    <div class="brand">
        <i class="fas fa-leaf"></i>
        ECO<span>TRACK</span>
    </div>

    <h1>Select Your Role</h1>
    <p class="sub-heading">Tell us who you are to get started.</p>

    <form id="roleForm" action="/selectRole" method="POST">

        <div class="role-card-group">

            <label class="role-card" for="startupRole">
                <i class="fas fa-rocket"></i>
                <h3>Startup</h3>
                <p>Looking for funding, growth, and investor connections.</p>
                <input type="radio" id="startupRole" name="role" value="Startup"
                       onclick="selectRole(this)"
                       <c:if test="${param.role == 'Startup' || empty param.role}">checked</c:if>>
            </label>

            <label class="role-card" for="investorRole">
                <i class="fas fa-hand-holding-usd"></i>
                <h3>Investor</h3>
                <p>Discover, evaluate, and invest in promising startups.</p>
                <input type="radio" id="investorRole" name="role" value="Investor"
                       onclick="selectRole(this)"
                       <c:if test="${param.role == 'Investor'}">checked</c:if>>
            </label>

        </div>

        <button type="submit" class="btn-custom">Continue</button>
    </form>

    <p class="login-link">
        Already have an account? <a href="/login">Login here</a>
    </p>

</div>

<script>
    const roleCards = document.querySelectorAll('.role-card');

    function selectRole(radio) {
        roleCards.forEach(card => card.classList.remove('selected'));
        radio.closest('.role-card').classList.add('selected');
    }

    document.addEventListener('DOMContentLoaded', () => {
        const checked = document.querySelector('input[name="role"]:checked');
        if (checked) selectRole(checked);
    });
</script>

<!-- SweetAlert2 for toast notifications -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<c:if test="${not empty message}">
    <script>
        (function(){
            function showLogoutToast(){
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        toast: true,
                        position: 'top-end',
                        icon: 'success',
                        title: 'You have been logged out successfully.',
                        showConfirmButton: false,
                        timer: 3500,
                        timerProgressBar: true
                    });
                } else {
                    // Fallback if CDN didn't load
                    try { alert('You have been logged out successfully.'); } catch(e) {}
                }
            }
            if (document.readyState === 'loading') {
                document.addEventListener('DOMContentLoaded', showLogoutToast);
            } else {
                showLogoutToast();
            }
        })();
    </script>
</c:if>

</body>
</html>
