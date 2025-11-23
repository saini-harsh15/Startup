<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Prevent caching of this page
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.
%>
<!DOCTYPE html>
<html>
<head>
    <title>${investor.investorName} - Messages</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet"/>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <style>
        :root{
            --accent: #28a745;
            --accent-600: #218838;
            --bg-1: linear-gradient(180deg,#f4fbf6 0%, #eef6f2 50%, #f7fafb 100%);
            --muted: #6b7280;
            --text: #0f172a;
            --card-radius: 14px;
            --white: #ffffff;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        html,body{height:100%;font-family:'Poppins',sans-serif; -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale}
        body{background: var(--bg-1); color: var(--text); padding-top:78px; min-height:100vh;}
        ::-webkit-scrollbar { height:10px; width:10px; }
        ::-webkit-scrollbar-thumb { background: rgba(12,17,38,0.12); border-radius:999px; }
        ::-webkit-scrollbar-track { background: transparent; }
        * { scrollbar-width: thin; scrollbar-color: rgba(12,17,38,0.12) transparent; }

        .navbar{
            position:fixed; top:10px; left:10px; right:10px; height:64px; z-index:1400;
            display:flex; align-items:center; justify-content:space-between; gap:12px; padding:10px 18px; border-radius:14px;
            background: linear-gradient(180deg, rgba(255,255,255,0.70), rgba(255,255,255,0.62));
            backdrop-filter: blur(8px) saturate(120%); border: 1px solid rgba(255,255,255,0.48);
            box-shadow: 0 8px 28px rgba(12,17,38,0.06);
        }
        .navbar-left{display:flex;gap:14px;align-items:center}
        .hamburger{font-size:1.25rem;color:var(--muted);cursor:pointer;display:inline-flex;align-items:center;justify-content:center;z-index:1410}
        .logo{font-weight:700;color:var(--accent);font-size:1.05rem;letter-spacing:0.2px}
        .navbar-right{display:flex;gap:12px;align-items:center}
        .welcome-msg{font-weight:600;color:var(--text);opacity:0.92}
        .profile-dropdown{position:relative}
        .profile-icon{ width:44px;height:44px;border-radius:12px; display:flex;align-items:center;justify-content:center;font-weight:700;
            background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(250,250,250,0.84)); color:var(--accent); cursor:pointer; border:1px solid rgba(12,17,38,0.04);
            box-shadow: 0 6px 20px rgba(12,17,38,0.06); z-index:1410; }
        .theme-toggle{ cursor:pointer;border-radius:10px;padding:8px 10px;font-size:0.95rem; background: rgba(255,255,255,0.72);border:1px solid rgba(255,255,255,0.5);
            display:inline-flex;align-items:center;justify-content:center;box-shadow: 0 4px 12px rgba(12,17,38,0.04) }
        .dropdown-content{ display:none; position:absolute; right:0; top:58px; min-width:170px; background: linear-gradient(180deg,#ffffff,#fbffff);
            border-radius:10px; overflow:hidden; box-shadow:0 12px 36px rgba(12,17,38,0.08); border:1px solid rgba(12,17,38,0.04); z-index: 1405; }
        .dropdown-content.show{display:block}
        .dropdown-content a{display:block;padding:12px 14px;color:#0f172a;text-decoration:none;font-weight:600}
        .dropdown-content a:hover{background: linear-gradient(90deg, rgba(40,167,69,0.06), transparent)}

        .container{ max-width:1200px;margin:0 auto; padding:18px; display:grid; grid-template-columns: 320px 1fr; gap:18px; }
        .chat-list{ background: linear-gradient(180deg, rgba(255,255,255,0.66), rgba(255,255,255,0.52));
            border:1px solid rgba(255,255,255,0.45); backdrop-filter: blur(6px); box-shadow: 6px 12px 30px rgba(12,17,38,0.06);
            border-radius:14px; padding:12px; height: calc(100vh - 140px); overflow: hidden; display:flex; flex-direction:column; }
        .chat-list-header{ font-weight:700; font-size:1rem; color:var(--text); padding:8px 10px; }
        .search-container{ padding:10px; }
        .search-container input{ width:100%; padding:10px 12px; border:1px solid rgba(12,17,38,0.08); border-radius:10px; outline:none; font-size:0.95rem; }
        .chat-item{ padding:12px; border-radius:10px; cursor:pointer; display:flex; flex-direction:column; gap:6px; }
        .chat-item:hover{ background: linear-gradient(90deg, rgba(40,167,69,0.06), transparent) }
        .chat-item.active{ background: linear-gradient(90deg, rgba(40,167,69,0.10), transparent) }
        .chat-name{ font-weight:700 }
        .text-muted{ color:var(--muted) }

        .chat-window{ background: linear-gradient(180deg, rgba(255,255,255,0.66), rgba(255,255,255,0.52));
            border:1px solid rgba(255,255,255,0.45); backdrop-filter: blur(6px); box-shadow: 6px 12px 30px rgba(12,17,38,0.06);
            border-radius:14px; padding:12px; height: calc(100vh - 140px); display:flex; flex-direction:column; }
        .chat-history{ flex:1; overflow:auto; padding:12px; display:flex; flex-direction:column; gap:8px; }
        .message{ max-width:70%; padding:10px 12px; border-radius:12px; }
        .message.sent{ align-self:flex-end; background: #dcfce7; border: 1px solid #bbf7d0; }
        .message.received{ align-self:flex-start; background: #f1f5f9; border: 1px solid #e2e8f0; }
        .chat-input-area{ display:flex; gap:8px; padding:8px; border-top:1px solid rgba(12,17,38,0.08); }
        .chat-input-area input{ flex:1; padding:12px; border-radius:10px; border:1px solid rgba(12,17,38,0.08); outline:none; }
        .send-button{ padding:10px 14px; border:none; border-radius:10px; background: var(--accent); color:#fff; font-weight:700; cursor:pointer; }
        .send-button:hover{ background: var(--accent-600); }

        .overlay{ position:fixed; top:0; left:0; right:0; bottom:0; background: rgba(15,23,42,0.3); display:none; z-index: 1300; }
        .overlay.show{ display:block; }
    </style>
</head>
<body>

<header class="navbar" role="banner">
    <div class="navbar-left">
        <div class="hamburger" onclick="window.location.href='/investor/dashboard'" aria-label="Back to dashboard" title="Back to dashboard">&#8592;</div>
        <div class="logo" title="Project name">Startup Ecosystem</div>
    </div>

    <div class="navbar-right">
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn" aria-pressed="false" title="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>

        <div class="welcome-msg">Welcome, ${investor.investorName}</div>

        <div class="profile-dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()" aria-haspopup="true" aria-expanded="false">I</div>
            <nav id="myDropdown" class="dropdown-content" role="menu" aria-hidden="true">
                <a href="/investor/profile" role="menuitem">My Profile</a>
                <a href="/logout" role="menuitem">Logout</a>
            </nav>
        </div>
    </div>
</header>

<div class="page-wrap">
    <div class="container">

        <div class="chat-list">
            <div class="chat-list-header">Startup Conversations</div>

            <div class="search-container">
                <form id="searchForm" action="/investor/messages" method="GET">
                    <input type="search" name="search" placeholder="Search startup name or industry..."
                           value="${searchTerm}" onchange="this.form.submit()">
                </form>
            </div>

            <div id="startupList">
                <c:choose>
                    <c:when test="${not empty startupsList}">
                        <c:forEach var="startup" items="${startupsList}">
                            <div id="partner${startup.id}"
                                 class="chat-item"
                                 onclick="loadChat(${startup.id}, '${startup.name}', event)">
                                <div class="chat-name">${startup.name}</div>
                                <div class="chat-time text-sm text-muted">Industry: ${startup.industry}</div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:when test="${not empty searchTerm}">
                        <p style="padding: 15px; color: var(--muted);">No startups found matching "${searchTerm}".</p>
                    </c:when>
                    <c:otherwise>
                        <p style="padding: 15px; color: var(--muted);">Select a startup to start chatting.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="chat-window">
            <div class="chat-history" id="chatHistory">
                <c:forEach var="msg" items="${chatHistory}">
                    <div class="message <c:out value='${msg.senderId == investorId ? "sent" : "received"}' />">
                        <c:out value="${msg.content}" />
                    </div>
                </c:forEach>

                <p id="initialPrompt" style="text-align: center; color: var(--muted); margin-top: 50px;">
                    Select a startup from the left panel to view history and start chatting.
                </p>
            </div>
            <div class="chat-input-area">
                <input type="text" id="messageInput" placeholder="Type your message..." onkeypress="if(event.keyCode === 13) sendMessage()">
                <button class="send-button" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
            </div>
        </div>

    </div>
</div>

<script>
    var stompClient = null;
    var currentInvestorId = ${investor.id};
    var currentReceiverId = null; // selected startupId

    function scrollToBottom() {
        const historyDiv = document.getElementById('chatHistory');
        historyDiv.scrollTop = historyDiv.scrollHeight;
    }

    function connect() {
        var socket = new SockJS('<c:url value="/ws-chat" />');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            console.log('Connected to WebSocket: ' + frame);
            stompClient.subscribe('/topic/messages/' + currentInvestorId, function (message) {
                showMessage(JSON.parse(message.body), currentInvestorId);
            });
            scrollToBottom();
        });
    }

    function loadChat(startupId, startupName, event) {
        currentReceiverId = startupId;
        const historyDiv = document.getElementById('chatHistory');
        document.querySelectorAll('.chat-item').forEach(item => item.classList.remove('active'));
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('active');
        } else {
            const el = document.getElementById('partner' + startupId);
            if (el) el.classList.add('active');
        }
        historyDiv.innerHTML = '<p style="text-align: center; color: var(--muted);">Loading chat history with ' + startupName + '...</p>';
        setTimeout(() => {
            historyDiv.innerHTML = '<p style="text-align: center; color: var(--muted);">Conversation started. You can now chat!</p>';
            scrollToBottom();
        }, 800);
    }

    function showMessage(chatMessage, currentUserId) {
        const historyDiv = document.getElementById('chatHistory');
        const initialPrompt = document.getElementById('initialPrompt');
        if(initialPrompt) initialPrompt.remove();
        const isActiveChat = (chatMessage.senderId == currentUserId && chatMessage.receiverId == currentReceiverId) ||
            (chatMessage.senderId == currentReceiverId && chatMessage.receiverId == currentUserId);
        if (isActiveChat) {
            const typeClass = (chatMessage.senderId == currentUserId) ? 'sent' : 'received';
            const messageElement = document.createElement('div');
            messageElement.className = 'message ' + typeClass;
            messageElement.textContent = chatMessage.content;
            historyDiv.appendChild(messageElement);
            scrollToBottom();
        }
    }

    function sendMessage() {
        const input = document.getElementById('messageInput');
        const content = input.value.trim();
        if (content !== '' && stompClient && currentReceiverId) {
            var chatMessage = {
                senderId: currentInvestorId,
                receiverId: currentReceiverId,
                content: content,
            };
            stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
            input.value = '';
        } else if (!currentReceiverId) {
            alert('Please select a startup from the list to start chatting.');
        }
    }

    function toggleDropdown(){
        const d = document.getElementById('myDropdown');
        d.classList.toggle('show');
        d.setAttribute('aria-hidden', d.classList.contains('show') ? 'false' : 'true');
    }

    // Simple theme toggler to match other pages
    function setTheme(theme){
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        const icon = document.querySelector('#themeToggleBtn i');
        if (icon) icon.className = (theme === 'dark') ? 'fas fa-sun' : 'fas fa-moon';
    }
    function toggleTheme(){
        const current = document.documentElement.getAttribute('data-theme') || 'light';
        setTheme(current === 'light' ? 'dark' : 'light');
    }

    document.addEventListener('DOMContentLoaded', () => {
        if ("${investor.email}" === "") {
            window.location.href = "/login?message=You have been logged out.";
        }
        const savedTheme = (function(){ try { return localStorage.getItem('theme'); } catch(e){ return null; } })() || 'light';
        setTheme(savedTheme);
        const investorName = "${investor.investorName}";
        const profileIcon = document.getElementById("profileIcon");
        if (investorName && profileIcon) {
            profileIcon.textContent = investorName.charAt(0).toUpperCase();
            profileIcon.setAttribute('title', investorName);
        }
        connect();
    });
</script>

</body>
</html>