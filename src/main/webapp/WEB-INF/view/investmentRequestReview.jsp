<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Investment Request</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet"/>

    <style>
        body{
            font-family:'Poppins',sans-serif;
            background:#f3f6f9;
            padding:40px;
            color:#0f172a;
        }

        .container{
            max-width:900px;
            margin:auto;
        }

        .card{
            background:#fff;
            border-radius:18px;
            padding:30px;
            box-shadow:0 12px 30px rgba(0,0,0,.08);
            margin-bottom:24px;
        }

        h1{margin-bottom:8px}
        h3{margin-top:26px;margin-bottom:14px}

        .row{
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:22px;
        }

        .item{
            display:flex;
            flex-direction:column;
            gap:4px;
        }

        /* LABEL STYLE */
        .item span{
            color:#64748b;
            font-size:.75rem;
            font-weight:600;
            letter-spacing:.4px;
            text-transform:uppercase;
        }

        /* VALUE STYLE */
        .value{
            font-weight:600;
            font-size:.98rem;
            color:#0f172a;
        }

        .money{
            font-weight:700;
            letter-spacing:.3px;
        }

        .message-box{
            background:#f8fafc;
            padding:16px;
            border-radius:12px;
            font-size:.95rem;
            line-height:1.5;
        }

        .status-badge{
            display:inline-block;
            padding:6px 14px;
            border-radius:10px;
            font-size:.75rem;
            font-weight:700;
            letter-spacing:.5px;
        }

        .status-PENDING{
            background:rgba(255,193,7,.18);
            color:#856404;
            border:1px solid rgba(255,193,7,.4);
        }

        .status-ACCEPTED{
            background:rgba(40,167,69,.18);
            color:#155724;
            border:1px solid rgba(40,167,69,.4);
        }

        .status-REJECTED{
            background:rgba(220,53,69,.18);
            color:#721c24;
            border:1px solid rgba(220,53,69,.4);
        }

        .footer-actions{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-top:30px;
        }

        .actions{display:flex;gap:14px}

        .btn{
            padding:12px 22px;
            border-radius:10px;
            font-weight:600;
            cursor:pointer;
            border:none;
            font-size:.9rem;
        }

        .btn-accept{background:#28a745;color:white}
        .btn-reject{background:#dc3545;color:white}

        .btn-back{
            background:#e2e8f0;
            color:#0f172a;
            text-decoration:none;
            display:inline-block;
            padding:12px 22px;
            border-radius:10px;
            font-weight:600;
        }

        .btn:hover{opacity:.9}
    </style>
</head>

<body>

<div class="container">

    <h1>Investment Request Review</h1>
    <p style="color:#64748b;">Carefully review the details before making a decision.</p>

    <div class="card">

        <h3>Investor Information</h3>
        <div class="row">
            <div class="item">
                <span>Name</span>
                <div class="value">${request.investor.investorName}</div>
            </div>
            <div class="item">
                <span>Email</span>
                <div class="value">${request.investor.email}</div>
            </div>
        </div>

        <h3>Investment Details</h3>
        <div class="row">
            <div class="item">
                <span>Amount</span>
                <div class="value money">
                    $<fmt:formatNumber value="${request.amount}" type="number" groupingUsed="true"/>
                </div>
            </div>

            <div class="item">
                <span>Funding Stage</span>
                <div class="value">${request.fundingStage}</div>
            </div>

            <div class="item">
                <span>Expected ROI</span>
                <div class="value">
                    <c:choose>
                        <c:when test="${request.expectedRoi != null}">
                            ${request.expectedRoi}%
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="item">
                <span>Investment Horizon</span>
                <div class="value">
                    <c:choose>
                        <c:when test="${request.horizon != null}">
                            ${request.horizon} years
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <h3>Message from Investor</h3>
        <div class="message-box">
            <c:choose>
                <c:when test="${not empty request.message}">
                    ${request.message}
                </c:when>
                <c:otherwise>
                    No message provided.
                </c:otherwise>
            </c:choose>
        </div>

        <h3>Status</h3>
        <span class="status-badge status-${request.status}">
            ${request.status}
        </span>

        <div class="footer-actions">

            <a href="/startup/investment-requests" class="btn-back">
                ← Back to all requests
            </a>

            <c:if test="${request.status == 'PENDING'}">
                <div class="actions">
                    <form method="post" action="/startup/investment-requests/${request.id}/accept">
                        <button type="submit" class="btn btn-accept">Accept</button>
                    </form>

                    <form method="post" action="/startup/investment-requests/${request.id}/reject">
                        <button type="submit" class="btn btn-reject">Reject</button>
                    </form>
                </div>
            </c:if>

        </div>

    </div>

</div>

</body>
</html>
