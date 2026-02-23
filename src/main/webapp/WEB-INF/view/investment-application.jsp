<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Apply for Investment</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root{
            --accent:#28a745;
            --accent-soft:rgba(40,167,69,.12);
            --bg:#f3f6f9;
            --card:#ffffff;
            --text:#0f172a;
            --muted:#64748b;
            --border:1px solid rgba(15,23,42,.08);
            --shadow:0 22px 40px rgba(0,0,0,.12);
        }

        *{box-sizing:border-box}

        body{
            font-family:'Poppins',sans-serif;
            background:var(--bg);
            min-height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            padding:40px 20px;
        }

        .card{
            width:100%;
            max-width:640px;
            background:var(--card);
            border-radius:24px;
            padding:40px;
            border:var(--border);
            box-shadow:var(--shadow);
            animation:fadeUp .6s ease;
        }

        @keyframes fadeUp{
            from{opacity:0;transform:translateY(20px)}
            to{opacity:1;transform:translateY(0)}
        }

        .header{
            margin-bottom:28px;
        }

        .header h2{
            font-weight:800;
            color:var(--accent);
            margin-bottom:6px;
        }

        .header p{
            color:var(--muted);
            font-size:.95rem;
        }

        .startup-chip{
            display:inline-block;
            margin-top:10px;
            padding:6px 14px;
            border-radius:999px;
            background:var(--accent-soft);
            color:var(--accent);
            font-weight:600;
            font-size:.75rem;
        }

        .form-group{
            margin-bottom:18px;
        }

        label{
            font-weight:600;
            font-size:.85rem;
        }

        input, select, textarea{
            width:100%;
            margin-top:6px;
            padding:12px 14px;
            border-radius:12px;
            border:var(--border);
            font-size:.9rem;
            transition:.25s ease;
        }

        input:focus, select:focus, textarea:focus{
            outline:none;
            border-color:var(--accent);
            box-shadow:0 0 0 3px rgba(40,167,69,.2);
        }

        textarea{resize:none}

        .grid{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:16px;
        }

        .btn{
            width:100%;
            margin-top:24px;
            padding:14px;
            border:none;
            border-radius:999px;
            background:linear-gradient(135deg,var(--accent),#1d7b37);
            color:white;
            font-weight:700;
            font-size:1rem;
            cursor:pointer;
            box-shadow:0 14px 32px rgba(40,167,69,.45);
            transition:.3s ease;
        }

        .btn:hover{
            transform:translateY(-2px);
            box-shadow:0 18px 42px rgba(40,167,69,.6);
        }


        .toast{
            position:fixed;
            bottom:24px;
            right:24px;
            background:#0f172a;
            color:white;
            padding:14px 18px;
            border-radius:14px;
            display:flex;
            align-items:center;
            gap:10px;
            font-weight:600;
            box-shadow:0 20px 40px rgba(0,0,0,.3);
            z-index:999;
        }
    </style>
</head>

<body>

<div class="card">

    <div class="header">
        <h2>Apply for Investment</h2>
        <p>You’re applying to invest in a startup. Clear intent improves response chances.</p>
        <span class="startup-chip">${startup.name}</span>
    </div>

    <form action="/investor/submit-investment-request" method="post">


        <input type="hidden" name="startupId" value="${startup.id}">
        <input type="hidden" name="investorId" value="${investor.id}">

        <div class="grid">
            <div class="form-group">
                <label>Investment Amount <span style="color:#dc2626">*</span></label>
                <input type="number" name="amount" required step="1000" min="1000" placeholder="e.g. 50000">
            </div>

            <div class="form-group">
                <label>Funding Stage</label>
                <select name="fundingStage" required>
                    <option value="">Select stage</option>
                    <option value="Seed">Seed</option>
                    <option value="Pre-Series A">Pre-Series A</option>
                    <option value="Series A">Series A</option>
                    <option value="Growth">Growth</option>
                </select>
            </div>
        </div>

        <div class="grid">
            <div class="form-group">
                <label>Expected ROI (%) <span style="color:#dc2626">*</span></label>
                <input type="number" name="expectedRoi" required placeholder="e.g. 20">
            </div>

            <div class="form-group">
                <label>Investment Horizon (years) <span style="color:var(--muted)">(optional)</span></label>
                <input type="number" name="horizon" placeholder="e.g. 5">
            </div>
        </div>

        <div class="form-group">
            <label>Message to Startup <span style="color:#dc2626">*</span></label>
            <textarea name="message" rows="4" required
                      placeholder="Add a short note, expectations, or strategic value you bring"></textarea>
        </div>

        <p style="font-size:.8rem;color:var(--muted);margin-top:8px">
            <span style="color:#dc2626">*</span> Required fields — helps startups evaluate serious investment intent.
        </p>

        <button type="submit" class="btn">
            <i class="fas fa-paper-plane"></i> Submit Application
        </button>

    </form>
</div>


<c:if test="${investmentSuccess}">
    <div class="toast">
        <i class="fas fa-check-circle" style="color:#22c55e"></i>
        Investment request sent successfully
    </div>

    <script>
        setTimeout(() => {
            window.location.href = "/investor/dashboard";
        }, 1000);
    </script>
</c:if>

</body>
</html>
