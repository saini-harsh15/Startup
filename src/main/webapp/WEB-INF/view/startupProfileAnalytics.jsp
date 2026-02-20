<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Investor Interest Insights</title>

    <style>

        body{
            font-family: "Segoe UI", Arial;
            background:#f4f7fb;
            padding:50px;
            color:#1a1a1a;
        }

        h2{
            margin-bottom:30px;
            font-size:28px;
            font-weight:700;
        }

        /* CARD */
        .card{
            background:white;
            border-radius:18px;
            padding:22px 28px;
            margin-bottom:18px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            box-shadow:0 8px 22px rgba(0,0,0,.06);
            transition:.2s;
        }

        .card:hover{
            transform:translateY(-3px);
            box-shadow:0 14px 28px rgba(0,0,0,.09);
        }

        /* LEFT */
        .identity{
            width:260px;
        }

        .name{
            font-weight:700;
            font-size:18px;
        }

        .type{
            color:#7a7a7a;
            font-size:13px;
        }

        /* CENTER METRICS */
        .metrics{
            display:flex;
            gap:60px;
        }

        .metric{
            text-align:center;
        }

        .metric .value{
            font-size:24px;
            font-weight:700;
        }

        .metric .label{
            font-size:12px;
            color:#888;
        }

        /* RIGHT */
        .right{
            text-align:right;
            min-width:220px;
        }

        /* temperature badges */
        .badge{
            display:inline-block;
            padding:6px 14px;
            border-radius:30px;
            font-weight:700;
            font-size:12px;
            margin-bottom:6px;
        }

        .hot{ background:#ff4d4f20; color:#e03131; }
        .warm{ background:#ffa94d25; color:#f76707; }
        .cold{ background:#4dabf720; color:#1c7ed6; }

        /* hint text */
        .hint{
            font-size:13px;
            margin-bottom:12px;
            color:#666;
        }

        /* button */
        .btn{
            background:#2b8a3e;
            color:white;
            padding:12px 20px;
            border-radius:10px;
            text-decoration:none;
            font-weight:600;
            display:inline-block;
        }

        .btn:hover{
            background:#237032;
        }

        .empty{
            background:white;
            padding:50px;
            border-radius:16px;
            color:#777;
        }

    </style>
</head>

<body>

<h2>Investor Interest Insights</h2>

<c:choose>

    <c:when test="${empty analytics}">
        <div class="empty">
            No investors have viewed your startup yet.
        </div>
    </c:when>

    <c:otherwise>

        <!-- SORTING PRIORITY: HOT FIRST -->
        <c:forEach var="v" items="${analytics}">

            <div class="card">

                <!-- LEFT -->
                <div class="identity">
                    <div class="name">${v.investorName}</div>
                    <div class="type">${v.investorType}</div>
                </div>

                <!-- CENTER METRICS -->
                <div class="metrics">

                    <div class="metric">
                        <div class="value">${v.totalVisits}</div>
                        <div class="label">Visits</div>
                    </div>

                    <div class="metric">
                        <div class="value">${v.score}</div>
                        <div class="label">Interest</div>
                    </div>

                </div>

                <!-- RIGHT ACTION -->
                <div class="right">

                    <c:choose>

                        <c:when test="${v.temperature == 'HOT'}">
                            <div class="badge hot">HOT LEAD</div>
                            <div class="hint">Contact immediately — high conversion chance</div>
                        </c:when>

                        <c:when test="${v.temperature == 'WARM'}">
                            <div class="badge warm">WARM LEAD</div>
                            <div class="hint">Follow up soon — interested investor</div>
                        </c:when>

                        <c:otherwise>
                            <div class="badge cold">COLD LEAD</div>
                            <div class="hint">Low engagement — nurture later</div>
                        </c:otherwise>

                    </c:choose>

                    <a class="btn" href="/startup/chat?investorId=${v.investorId}">
                        Start Conversation
                    </a>

                </div>

            </div>

        </c:forEach>

    </c:otherwise>
</c:choose>

</body>
</html>
