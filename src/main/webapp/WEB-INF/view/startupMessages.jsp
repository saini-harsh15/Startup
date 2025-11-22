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
    <title>${startup.name} - Messages</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet"/>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <style>
        /* Inherit all dashboard styling variables */
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

        /* Thin scrollbar (modern) */
        ::-webkit-scrollbar { height:10px; width:10px; }
        ::-webkit-scrollbar-thumb { background: rgba(12,17,38,0.12); border-radius:999px; }
        ::-webkit-scrollbar-track { background: transparent; }
        * { scrollbar-width: thin; scrollbar-color: rgba(12,17,38,0.12) transparent; }

        /* =========================
           Navbar (glass)
           ========================= */
        .navbar{
            position:fixed;
            top:10px;
            left:10px;
            right:10px;
            height:64px;
            z-index:1400;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap:12px;
            padding:10px 18px;
            border-radius:14px;
            background: linear-gradient(180deg, rgba(255,255,255,0.70), rgba(255,255,255,0.62));
            backdrop-filter: blur(8px) saturate(120%);
            border: 1px solid rgba(255,255,255,0.48);
            box-shadow: 0 8px 28px rgba(12,17,38,0.06);
        }
        .navbar-left{display:flex;gap:14px;align-items:center}
        .hamburger{font-size:1.25rem;color:var(--muted);cursor:pointer;display:inline-flex;align-items:center;justify-content:center;z-index:1410}
        .logo{font-weight:700;color:var(--accent);font-size:1.05rem;letter-spacing:0.2px}
        .navbar-right{display:flex;gap:12px;align-items:center}

        .welcome-msg{font-weight:600;color:var(--text);opacity:0.92}
        .profile-dropdown{position:relative}

        /* Profile icon */
        .profile-icon{
            width:44px;height:44px;border-radius:12px;
            display:flex;align-items:center;justify-content:center;font-weight:700;
            background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(250,250,250,0.84));
            color:var(--accent); cursor:pointer; border:1px solid rgba(12,17,38,0.04);
            box-shadow: 0 6px 20px rgba(12,17,38,0.06);
            z-index:1410;
        }

        /* Theme toggle */
        .theme-toggle{
            cursor:pointer;border-radius:10px;padding:8px 10px;font-size:0.95rem;
            background: rgba(255,255,255,0.72);border:1px solid rgba(255,255,255,0.5);
            display:inline-flex;align-items:center;justify-content:center;box-shadow: 0 4px 12px rgba(12,17,38,0.04)
        }

        .dropdown-content{
            display:none; position:absolute; right:0; top:58px; min-width:170px;
            background: linear-gradient(180deg,#ffffff,#fbffff);
            border-radius:10px; overflow:hidden; box-shadow:0 12px 36px rgba(12,17,38,0.08); border:1px solid rgba(12,17,38,0.04);
            z-index: 1405;
        }
        .dropdown-content.show{display:block}
        .dropdown-content a{display:block;padding:12px 14px;color:#0f172a;text-decoration:none;font-weight:600}
        .dropdown-content a:hover{background: linear-gradient(90deg, rgba(40,167,69,0.06), transparent)}

        /* =========================
           Sidebar (collapsible)
           ========================= */
        .sidebar{
            position:fixed;top:10px;left:10px;height:calc(100% - 20px);width:0;z-index:1350;padding-top:88px;
            overflow:hidden;transition:width 320ms cubic-bezier(.2,.9,.2,1);
        }
        .sidebar .panel{
            height:100%; width:280px; padding:18px; border-radius:14px;
            background: linear-gradient(180deg, rgba(255,255,255,0.66), rgba(255,255,255,0.52));
            border:1px solid rgba(255,255,255,0.45); backdrop-filter: blur(6px);
            box-shadow: 6px 12px 30px rgba(12,17,38,0.06);
            transform-origin:left center;
        }
        .sidebar.open{width:300px}
        .sidebar.open .panel{width:300px}
        .sidebar a{display:flex;align-items:center;padding:14px 12px;border-radius:10px;text-decoration:none;color:var(--text);font-weight:600}
        .sidebar a i{margin-right:12px;color:var(--muted)}
        .sidebar a:hover{background: rgba(40,167,69,0.06); color: var(--accent)}
        .sidebar .closebtn{z-index:1400}

        /* overlay when sidebar open on small screens */
        .overlay{display:none;position:fixed;top:0;left:0;width:100%;height:100%;z-index:1340;background:rgba(9,11,14,0.28);transition:opacity .2s}
        .overlay.show{display:block}

        /* =========================
           Chat Window Styles
           ========================= */
        .page-wrap{width:100%;max-width:1600px;margin:0 auto;padding:14px 22px}
        .container{
            width: 100%;
            max-width: 1200px;
            height: calc(100vh - 120px); /* Fill most of the screen height */
            min-height: 500px;
            margin: 20px auto;
            border-radius: 16px;
            background: linear-gradient(180deg, rgba(255,255,255,0.90), rgba(255,255,255,0.80));
            box-shadow: 0 14px 50px rgba(12,17,38,0.08);
            display: flex;
            overflow: hidden;
            border: 1px solid rgba(12,17,38,0.04);
        }

        .chat-list {
            width: 300px;
            border-right: 1px solid #eee;
            padding: 0;
            overflow-y: auto;
            background: #fafafa;
            flex-shrink: 0;
        }

        .search-container {
            padding: 15px 15px 10px;
            border-bottom: 1px solid #eee;
        }
        .search-container input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ccc;
            border-radius: 50px; /* Rounded search bar */
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .search-container input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
            outline: none;
        }

        .chat-list-header {
            padding: 10px 15px;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--accent);
            border-bottom: 2px solid var(--accent);
            margin-bottom: 10px;
        }

        .chat-item {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #f1f1f1;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .chat-item:hover {
            background: #e6f5e6;
        }
        .chat-item.active {
            background: var(--accent);
            color: var(--white);
            font-weight: 600;
        }
        .chat-item.active .chat-name,
        .chat-item.active .chat-time {
            color: var(--white) !important;
        }
        .chat-item .chat-name {
            font-weight: 600;
            color: var(--text);
        }

        .chat-window {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .chat-history {
            flex-grow: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .message {
            max-width: 65%;
            padding: 10px 15px;
            border-radius: 15px;
            font-size: 0.95rem;
            line-height: 1.4;
            word-wrap: break-word;
        }

        .message.sent {
            background-color: var(--accent);
            color: var(--white);
            align-self: flex-end;
            border-bottom-right-radius: 2px;
        }

        .message.received {
            background-color: #f0f0f0;
            color: var(--text);
            align-self: flex-start;
            border-bottom-left-radius: 2px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .chat-input-area {
            padding: 15px;
            display: flex;
            border-top: 1px solid #eee;
        }

        .chat-input-area input {
            flex-grow: 1;
            padding: 10px 15px;
            border: 1px solid #ccc;
            border-radius: 50px;
            margin-right: 10px;
            font-size: 1rem;
            background: var(--white);
        }

        .send-button {
            background: var(--accent);
            color: var(--white);
            border: none;
            border-radius: 50px;
            width: 45px;
            height: 45px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .send-button:hover {
            background: var(--accent-600);
            transform: translateY(-1px);
        }

        /* =========================
           Responsive adjustments (FIXED)
           ========================= */
        @media (max-width: 768px) {
            .navbar{left:6px;right:6px}
            body{padding-top:86px}
            .container {
                flex-direction: column;
                height: 90vh; /* Better fit on mobile screens */
                margin-top: 5px;
            }
            .chat-list {
                width: 100%;
                max-height: 180px; /* Limit list height */
                border-right: none;
                border-bottom: 1px solid #eee;
            }
            .chat-window {
                flex-grow: 1;
            }
        }

        /* Dark Mode Overrides for Chat */
        .dark-mode{
            --bg-1: linear-gradient(180deg,#071018 0%,#071417 100%);
            --muted: #9fb3c6;
            --text: #dbeafe;
            color: var(--text);
        }
        .dark-mode .navbar{
            background: linear-gradient(180deg, rgba(18,25,38,0.60), rgba(16,22,34,0.52));
            border: 1px solid rgba(255,255,255,0.03);
        }
        .dark-mode .container {
            background: rgba(18,25,38,0.95);
            box-shadow: 0 14px 50px rgba(0,0,0,0.5);
        }
        .dark-mode .chat-list {
            background: #1a2230;
            border-right-color: #333;
        }
        .dark-mode .chat-item {
            border-bottom-color: #333;
            color: var(--text);
        }
        .dark-mode .chat-item:hover {
            background: #1f3531;
        }
        .dark-mode .chat-name {
            color: var(--text);
        }
        .dark-mode .chat-input-area input {
            background: #333;
            border-color: #444;
            color: var(--text);
        }
        .dark-mode .message.received {
            background-color: #333;
            color: var(--text);
        }
        .dark-mode .message.sent {
            background-color: #1a642e;
        }

        /* Accessibility focus */
        a:focus, button:focus, input:focus { outline: 3px solid rgba(40,167,69,0.18); outline-offset: 2px; border-radius:8px }
    </style>
</head>
<body>

<div id="mySidebar" class="sidebar" aria-hidden="true">
    <div class="panel" role="navigation" aria-label="Sidebar">
        <span class="closebtn" onclick="closeNav()" style="position:absolute;top:18px;right:18px;font-size:20px;cursor:pointer">×</span>

        <a href="#"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="/startup/profile"><i class="fas fa-user-circle"></i> My Profile</a>
        <a href="#"><i class="fas fa-chart-line"></i> Analytics</a>
        <a href="/contact"><i class="fas fa-envelope"></i> Contact Us</a>

        <div style="position:absolute;bottom:18px;left:18px;right:18px;color:var(--muted);font-weight:600;font-size:0.95rem">
            <div>Startup Ecosystem</div>
            <div style="font-size:0.85rem;margin-top:6px;color:var(--muted)">© <span id="yearSpan"></span></div>
        </div>
    </div>
</div>

<div id="overlay" class="overlay" onclick="closeNav()" aria-hidden="true"></div>

<header class="navbar" role="banner">
    <div class="navbar-left">
        <div class="hamburger" onclick="openNav()" aria-label="Open menu" title="Open menu">&#9776;</div>
        <div class="logo" title="Project name">Startup Ecosystem</div>
    </div>

    <div class="navbar-right">
        <button class="theme-toggle" onclick="toggleTheme()" id="themeToggleBtn" aria-pressed="false" title="Toggle dark mode">
            <i class="fas fa-moon"></i>
        </button>

        <div class="welcome-msg">Welcome, ${startup.name}</div>

        <div class="profile-dropdown">
            <div id="profileIcon" class="profile-icon" onclick="toggleDropdown()" aria-haspopup="true" aria-expanded="false">S</div>
            <nav id="myDropdown" class="dropdown-content" role="menu" aria-hidden="true">
                <a href="/startup/profile" role="menuitem">My Profile</a>
                <a href="/logout" role="menuitem">Logout</a>
            </nav>
        </div>
    </div>
</header>

<div class="page-wrap">
    <div class="container">

        <div class="chat-list">
            <div class="chat-list-header">Investor Conversations</div>

            <div class="search-container">
                <form id="searchForm" action="/startup/messages" method="GET">
                    <input type="search" name="search" placeholder="Search investor name or domain..."
                           value="${searchTerm}" onchange="this.form.submit()">
                </form>
            </div>

            <div id="investorList">
                <c:choose>
                    <c:when test="${not empty investorsList}">
                        <c:forEach var="investor" items="${investorsList}">
                            <div id="partner${investor.id}"
                                 class="chat-item"
                                 onclick="loadChat(${investor.id}, '${investor.investorName}', event)">
                                <div class="chat-name">${investor.investorName}</div>
                                <div class="chat-time text-sm text-muted">Firm: ${investor.investmentFirm}</div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:when test="${not empty searchTerm}">
                        <p style="padding: 15px; color: var(--muted);">No investors found matching "${searchTerm}".</p>
                    </c:when>
                    <c:otherwise>
                        <p style="padding: 15px; color: var(--muted);">Select an investor to start chatting.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="chat-window">
            <div class="chat-history" id="chatHistory">
                <c:forEach var="msg" items="${chatHistory}">
                    <div class="message <c:out value='${msg.senderId == startupId ? "sent" : "received"}' />">
                        <c:out value="${msg.content}" />
                    </div>
                </c:forEach>

                <p id="initialPrompt" style="text-align: center; color: var(--muted); margin-top: 50px;">
                    Select an investor from the left panel to view history and start chatting.
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
    /* Global STOMP client variable */
    var stompClient = null;
    var currentStartupId = ${startup.id}; // Logged in user ID
    var currentReceiverId = null; // Will be set by loadChat()

    // Helper to scroll chat history to the bottom
    function scrollToBottom() {
        const historyDiv = document.getElementById('chatHistory');
        historyDiv.scrollTop = historyDiv.scrollHeight;
    }

    function connect() {
        var socket = new SockJS('/ws-chat');
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function (frame) {
            console.log('Connected to WebSocket: ' + frame);

            // 1. Subscribe to our own channel for incoming messages
            stompClient.subscribe('/topic/messages/' + currentStartupId, function (message) {
                showMessage(JSON.parse(message.body), currentStartupId);
            });

            scrollToBottom();
        });
    }

    function loadChat(investorId, investorName, event) {
        currentReceiverId = investorId;
        const historyDiv = document.getElementById('chatHistory');

        // ** 1. Update UI and Active State **
        document.querySelectorAll('.chat-item').forEach(item => item.classList.remove('active'));
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('active');
        } else {
            // Fallback for non-event based calls if needed
            document.getElementById('partner' + investorId).classList.add('active');
        }

        // Clear previous content and show loading state
        historyDiv.innerHTML = '<p style="text-align: center; color: var(--muted);">Loading chat history with ' + investorName + '...</p>';

        // --- 2. AJAX Call to Load History ---
        // NOTE: In a complete implementation, an AJAX call to load history would go here
        // The most critical part missing here is the server-side REST endpoint to fetch history.

        // Simulate rendering history:
        setTimeout(() => {
            historyDiv.innerHTML = ''; // Clear loading message

            // This is where we should fetch history. Since we don't have AJAX, we'll only show the prompt.
            historyDiv.innerHTML = '<p style="text-align: center; color: var(--muted);">Conversation started. You can now chat!</p>';
            scrollToBottom();
        }, 800);
    }

    function showMessage(chatMessage, currentUserId) {
        const historyDiv = document.getElementById('chatHistory');

        // Remove initial prompt if it exists
        const initialPrompt = document.getElementById('initialPrompt');
        if(initialPrompt) initialPrompt.remove();

        // Only append the message if it is for the currently active chat partner
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
                senderId: currentStartupId,
                receiverId: currentReceiverId,
                content: content,
            };

            // Send message to the server's routing endpoint
            stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));

            // Clear input after sending
            input.value = '';
        } else if (!currentReceiverId) {
            alert('Please select an investor from the list to start chatting.');
        }
    }

    // --- Initial Setup and Dashboard Functions (Required) ---
    document.addEventListener('DOMContentLoaded', () => {
        // Redirect to login if the session is gone
        if ("${startup.email}" === "") {
            window.location.href = "/login?message=You have been logged out.";
        }

        // Year for sidebar footer
        const yearSpan = document.getElementById('yearSpan');
        if (yearSpan) yearSpan.textContent = new Date().getFullYear();

        // Theme restore
        const savedTheme = (function(){
            try { return localStorage.getItem('theme'); } catch(e){ return null; }
        })() || 'light';
        setTheme(savedTheme);

        // Dynamic Profile Icon
        const startupName = "${startup.name}";
        const profileIcon = document.getElementById("profileIcon");
        if (startupName && profileIcon) {
            profileIcon.textContent = startupName.charAt(0).toUpperCase();
            profileIcon.setAttribute('title', startupName);
        }

        // Initiate WebSocket connection
        connect();

        // Initial state: If history is pre-loaded by server (not dynamic click)
        const chatHistoryDiv = document.getElementById('chatHistory');
        const initialPrompt = document.getElementById('initialPrompt');
        if (chatHistoryDiv.children.length > 1) { // More than 1 child means history exists + the placeholder
            if (initialPrompt) initialPrompt.remove();
        }
    });

    function openNav() {
        document.getElementById("mySidebar").classList.add("open");
        document.getElementById("overlay").classList.add("show");
        document.getElementById("mySidebar").setAttribute('aria-hidden', 'false');
        document.getElementById("overlay").setAttribute('aria-hidden', 'false');
    }

    function closeNav() {
        document.getElementById("mySidebar").classList.remove("open");
        document.getElementById("overlay").classList.remove("show");
        document.getElementById("mySidebar").setAttribute('aria-hidden', 'true');
        document.getElementById("overlay").setAttribute('aria-hidden', 'true');
    }

    function toggleDropdown() {
        const dd = document.getElementById("myDropdown");
        dd.classList.toggle("show");
        const expanded = dd.classList.contains("show");
        document.getElementById("profileIcon").setAttribute('aria-expanded', expanded ? 'true' : 'false');
        dd.setAttribute('aria-hidden', expanded ? 'false' : 'true');
    }

    window.addEventListener('click', function(event) {
        if (!event.target.closest('.profile-dropdown') && !event.target.closest('.hamburger')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                    openDropdown.setAttribute('aria-hidden', 'true');
                    var icon = document.getElementById("profileIcon");
                    if (icon) icon.setAttribute('aria-expanded', 'false');
                }
            }
        }
    });

    function setTheme(theme) {
        const html = document.documentElement;
        const toggleBtn = document.querySelector('.theme-toggle');

        if (theme === 'dark') {
            html.classList.add('dark-mode');
            if (toggleBtn) {
                toggleBtn.innerHTML = '<i class="fas fa-sun"></i>';
                toggleBtn.setAttribute('aria-pressed', 'true');
            }
        } else {
            html.classList.remove('dark-mode');
            if (toggleBtn) {
                toggleBtn.innerHTML = '<i class="fas fa-moon"></i>';
                toggleBtn.setAttribute('aria-pressed', 'false');
            }
        }
        try { localStorage.setItem('theme', theme); } catch(e){ /* ignore if storage blocked */ }
    }

    function toggleTheme() {
        const html = document.documentElement;
        if (html.classList.contains('dark-mode')) {
            setTheme('light');
        } else {
            setTheme('dark');
        }
    }
</script>

</body>
</html>