<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Investment Requests</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --accent: #28a745;
            --bg: #f3f6f9;
            --card: #ffffff;
            --text: #0f172a;
            --muted: #6c757d;
            --border: 1px solid rgba(0,0,0,.06);
            --shadow: 0 10px 22px rgba(0,0,0,.08);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--bg);
            padding: 40px;
            color: var(--text);
        }

        h1 {
            margin-bottom: 24px;
        }

        /* ================= FILTER TABS ================= */
        .filter-tabs {
            display: flex;
            gap: 12px;
            margin-bottom: 28px;
        }

        .tab {
            padding: 10px 18px;
            border-radius: 12px;
            border: var(--border);
            background: var(--card);
            cursor: pointer;
            font-weight: 600;
            color: var(--muted);
            transition: .2s ease;
        }

        .tab.active {
            background: var(--accent);
            color: white;
            border-color: var(--accent);
        }

        /* ================= REQUEST GRID ================= */
        .request-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 22px;
        }

        .request-card {
            background: var(--card);
            border-radius: 18px;
            padding: 22px;
            box-shadow: var(--shadow);
            transition: .25s ease;
        }

        .request-card:hover {
            transform: translateY(-6px);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .investor-name {
            font-weight: 600;
            font-size: 1.05rem;
        }

        /* ================= STATUS BADGES ================= */
        .status-badge {
            padding: 4px 12px;
            border-radius: 8px;
            font-size: .7rem;
            font-weight: 700;
            text-transform: uppercase;
        }

        .status-pending {
            background: rgba(255,193,7,.18);
            color: #856404;
            border: 1px solid rgba(255,193,7,.4);
        }

        .status-accepted {
            background: rgba(40,167,69,.18);
            color: #155724;
            border: 1px solid rgba(40,167,69,.4);
        }

        .status-rejected {
            background: rgba(220,53,69,.18);
            color: #721c24;
            border: 1px solid rgba(220,53,69,.4);
        }

        .details {
            font-size: .9rem;
            margin: 14px 0 18px;
        }

        .details div {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
        }

        .actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
        }

        .btn-primary {
            background: var(--accent);
            color: white;
        }

        .btn-outline {
            border: 2px solid var(--accent);
            color: var(--accent);
        }

        .empty {
            text-align: center;
            color: var(--muted);
            margin-top: 80px;
        }
    </style>
</head>

<body>

<h1>Investment Requests</h1>

<!-- FILTER TABS -->
<div class="filter-tabs">
    <button class="tab" data-status="ALL">All</button>
    <button class="tab active" data-status="PENDING">Pending</button>
    <button class="tab" data-status="ACCEPTED">Accepted</button>
    <button class="tab" data-status="REJECTED">Rejected</button>
</div>

<c:choose>
    <c:when test="${not empty allRequests}">
        <div class="request-grid">

            <c:forEach var="req" items="${allRequests}">
                <div class="request-card"
                     data-status="${req.status}">

                    <div class="request-header">
                        <div class="investor-name">
                                ${req.investor.investorName}
                        </div>

                        <span class="status-badge
                            ${req.status == 'PENDING' ? 'status-pending' :
                              req.status == 'ACCEPTED' ? 'status-accepted' :
                              'status-rejected'}">
                                ${req.status}
                        </span>
                    </div>

                    <div class="details">
                        <div>
                            <span>Amount</span>
                            <span>$${req.amount}</span>
                        </div>
                        <div>
                            <span>Funding Stage</span>
                            <span>${req.fundingStage}</span>
                        </div>
                    </div>

                    <c:if test="${req.status == 'PENDING'}">
                        <div class="actions">
                            <a href="/startup/investment-requests/${req.id}" class="btn btn-primary">
                                Review
                            </a>
                            <a href="/startup/chat?investorId=${req.investor.id}" class="btn btn-outline">
                                Chat
                            </a>
                        </div>
                    </c:if>

                </div>
            </c:forEach>

        </div>
    </c:when>

    <c:otherwise>
        <div class="empty">
            <i class="fas fa-inbox fa-2x"></i>
            <p>No investment requests found.</p>
        </div>
    </c:otherwise>
</c:choose>

<!-- FILTER SCRIPT -->
<script>
    document.querySelectorAll('.tab').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            const selected = tab.dataset.status;

            document.querySelectorAll('.request-card').forEach(card => {
                const status = card.dataset.status;
                card.style.display =
                    (selected === 'ALL' || status === selected) ? 'block' : 'none';
            });
        });
    });

    // Default = Pending
    document.querySelector('.tab[data-status="ALL"]').click();
</script>

</body>
</html>
