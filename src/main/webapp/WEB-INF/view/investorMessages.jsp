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

        /* Enhanced message bubble + timestamp */
        .message{ max-width:72%; padding:10px 12px; border-radius:14px; position:relative; display:flex; flex-direction:column; gap:6px; box-shadow: 0 6px 18px rgba(12,17,38,0.06); }
        .message.sent{ align-self:flex-end; background: rgba(40,167,69,0.10); border: 1px solid rgba(40,167,69,0.25); }
        .message.received{ align-self:flex-start; background: rgba(255,255,255,0.75); border: 1px solid rgba(12,17,38,0.08); }
        .message .bubble{ white-space:pre-wrap; word-wrap:break-word; line-height:1.35; }
        .message .timestamp{ align-self:flex-end; font-size:0.72rem; color: var(--muted); }

        /* Date separators like WhatsApp */
        .date-separator{ align-self:center; margin:10px 0; padding:6px 10px; font-size:0.78rem; font-weight:600; color: var(--text);
            background: linear-gradient(180deg, rgba(255,255,255,0.72), rgba(255,255,255,0.62)); border:1px solid rgba(255,255,255,0.48);
            backdrop-filter: blur(6px); border-radius:999px; box-shadow: 0 6px 16px rgba(12,17,38,0.08); }

        /* Dark theme tweaks */
        [data-theme="dark"] .message.sent{ background: rgba(6,94,62,0.55); border-color: rgba(6,94,62,0.75); color:#d1fae5; box-shadow: 0 6px 18px rgba(0,0,0,0.5); }
        [data-theme="dark"] .message.received{ background: rgba(17,24,39,0.72); border-color: rgba(255,255,255,0.08); color:#e5e7eb; box-shadow: 0 6px 18px rgba(0,0,0,0.5); }
        [data-theme="dark"] .date-separator{ background: linear-gradient(180deg, rgba(17,24,39,0.72), rgba(17,24,39,0.64)); border-color: rgba(255,255,255,0.08); color:#e5e7eb; }

        .overlay{ position:fixed; top:0; left:0; right:0; bottom:0; background: rgba(15,23,42,0.3); display:none; z-index: 1300; }
        .overlay.show{ display:block; }
        
        /* Dark theme overrides */
        [data-theme="dark"]{
            --bg-1: linear-gradient(180deg,#0b1220 0%, #0e1526 50%, #0b1220 100%);
            --muted: #94a3b8;
            --text: #e5e7eb;
            --white: #0f172a;
        }
        [data-theme="dark"] .navbar{
            background: linear-gradient(180deg, rgba(17,24,39,0.72), rgba(17,24,39,0.64));
            border-color: rgba(255,255,255,0.08);
            box-shadow: 0 8px 28px rgba(0,0,0,0.45);
        }
        [data-theme="dark"] .theme-toggle{ background: rgba(17,24,39,0.72); border-color: rgba(255,255,255,0.08); color: var(--text); }
        [data-theme="dark"] .profile-icon{ background: linear-gradient(180deg, rgba(17,24,39,0.95), rgba(17,24,39,0.84)); color: var(--accent); border-color: rgba(255,255,255,0.08); box-shadow: 0 6px 20px rgba(0,0,0,0.5); }
        [data-theme="dark"] .dropdown-content{ background: linear-gradient(180deg,#0f172a,#111827); border-color: rgba(255,255,255,0.08); }
        [data-theme="dark"] .dropdown-content a{ color: var(--text); }
        [data-theme="dark"] .dropdown-content a:hover{ background: linear-gradient(90deg, rgba(40,167,69,0.18), transparent) }

        [data-theme="dark"] .chat-list, [data-theme="dark"] .chat-window{
            background: linear-gradient(180deg, rgba(17,24,39,0.72), rgba(17,24,39,0.64));
            border-color: rgba(255,255,255,0.08);
            box-shadow: 6px 12px 30px rgba(0,0,0,0.5);
        }
        [data-theme="dark"] .chat-item:hover{ background: linear-gradient(90deg, rgba(40,167,69,0.16), transparent) }
        [data-theme="dark"] .chat-item.active{ background: linear-gradient(90deg, rgba(40,167,69,0.20), transparent) }
        [data-theme="dark"] .search-container input{ background:#0b1220; color: var(--text); border-color: rgba(255,255,255,0.12); }
        [data-theme="dark"] .chat-input-area{ border-top-color: rgba(255,255,255,0.08); }
        [data-theme="dark"] .chat-input-area input{ background:#0b1220; color: var(--text); border-color: rgba(255,255,255,0.12); }

        [data-theme="dark"] .message.sent{ background:#064e3b; border-color:#065f46; color:#d1fae5; }
        [data-theme="dark"] .message.received{ background:#111827; border-color:#1f2937; color:#e5e7eb; }

        [data-theme="dark"] ::-webkit-scrollbar-thumb { background: rgba(148,163,184,0.35); }
        [data-theme="dark"] * { scrollbar-color: rgba(148,163,184,0.35) transparent; }
        /* Chat header and input/icon buttons */
        .chat-header{ display:flex; align-items:center; gap:12px; padding:8px 10px; border-bottom:1px solid rgba(12,17,38,0.08); position:sticky; top:0; z-index:2; }
        .back-btn{ display:none; align-items:center; justify-content:center; width:36px; height:36px; border-radius:10px; border:1px solid rgba(12,17,38,0.06); background: rgba(255,255,255,0.72); color:var(--text); cursor:pointer; }
        .partner-meta{ display:flex; flex-direction:column; }
        .partner-name{ font-weight:700; }
        .partner-sub{ font-size:0.8rem; color: var(--muted); }
        .icon-btn{ width:40px; height:40px; border:none; border-radius:12px; background: rgba(255,255,255,0.8); border:1px solid rgba(12,17,38,0.06); display:inline-flex; align-items:center; justify-content:center; color: var(--muted); cursor:pointer; }
        .icon-btn:hover{ color: var(--accent); border-color: rgba(40,167,69,0.25); }
        .chat-input-area{ display:flex; gap:8px; padding:8px; border-top:1px solid rgba(12,17,38,0.08); align-items:center; }
        .chat-input-area input{ flex:1; padding:12px 14px; border-radius:999px; border:1px solid rgba(12,17,38,0.08); outline:none; background: rgba(255,255,255,0.8); }
        .send-button[disabled]{ opacity:0.6; cursor:not-allowed; }
        /* Mobile layout */
        @media (max-width: 900px){
            .container{ grid-template-columns: 1fr; }
            .back-btn{ display:inline-flex; }
            body.mobile-chat-active .chat-list{ display:none; }
            body.mobile-chat-active .chat-window{ display:flex; }
        }
        /* Dark theme for header/input */
        [data-theme="dark"] .back-btn, [data-theme="dark"] .icon-btn{ background: rgba(17,24,39,0.72); border-color: rgba(255,255,255,0.08); color: var(--text); }
        [data-theme="dark"] .chat-header{ border-bottom-color: rgba(255,255,255,0.08); }
        [data-theme="dark"] .chat-input-area input{ background:#0b1220; border-color: rgba(255,255,255,0.12); color: var(--text); }
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
                    <input id="searchInput" type="search" name="search" placeholder="Search startup name or industry..."
                           value="<c:out value='${searchTerm}'/>" autocomplete="off" autocapitalize="none" spellcheck="false" inputmode="search">
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
            <div class="chat-header">
                <button class="back-btn" id="backBtn" onclick="showListOnMobile()" title="Back to chats" aria-label="Back to chats"><i class="fas fa-arrow-left"></i></button>
                <div class="partner-meta">
                    <div class="partner-name" id="partnerName">Select a conversation</div>
                    <div class="partner-sub">Secure chat • Online status <span id="typingIndicator" style="display:none;">· typing…</span></div>
                </div>
                <div class="header-actions"></div>
            </div>
            <div class="chat-history" id="chatHistory">
                <p id="initialPrompt" style="text-align: center; color: var(--muted); margin-top: 50px;">
                    Select a startup from the left panel to view history and start chatting.
                </p>
            </div>
            <div class="chat-input-area">
                <button class="icon-btn" id="emojiBtn" title="Emoji" aria-label="Emoji"><i class="far fa-smile"></i></button>
                <input type="text" id="messageInput" placeholder="Type your message...">
                <button class="icon-btn" id="attachBtn" title="Attach" aria-label="Attach"><i class="fas fa-paperclip"></i></button>
                <input type="file" id="fileInput" accept="image/*,application/pdf,text/plain" style="display:none" />
                <button class="send-button" id="sendBtn" onclick="sendMessage()" disabled><i class="fas fa-paper-plane"></i></button>
            </div>
            <div id="emojiPicker" style="display:none; position:absolute; bottom:110px; left:24px; background:rgba(255,255,255,0.95); border:1px solid rgba(12,17,38,0.08); border-radius:12px; padding:8px; box-shadow:0 8px 24px rgba(12,17,38,0.12); z-index:1000;"></div>
        </div>

    </div>
</div>

<script>
    var stompClient = null;
    var currentInvestorId = Number(${investor.id});
    var currentReceiverId = null; // selected startupId
    var lastRenderedDateKey = null; // tracks last date separator in current chat

    function scrollToBottom() {
        const historyDiv = document.getElementById('chatHistory');
        historyDiv.scrollTop = historyDiv.scrollHeight;
    }

    // --- Timestamp helpers ---
    function parseTimestamp(ts){
        if (!ts) return new Date();
        try{
            if (typeof ts === 'number') return new Date(ts);
            return new Date(ts);
        }catch(e){ return new Date(); }
    }
    function pad2(n){ return (n<10? '0':'') + n; }
    function getDateKey(d){ return d.getFullYear()+'-'+pad2(d.getMonth()+1)+'-'+pad2(d.getDate()); }
    function isSameDay(a,b){ return a.getFullYear()===b.getFullYear() && a.getMonth()===b.getMonth() && a.getDate()===b.getDate(); }
    function formatDateLabel(d){
        const today = new Date();
        const yest = new Date(); yest.setDate(today.getDate()-1);
        if (isSameDay(d, today)) return 'Today';
        if (isSameDay(d, yest)) return 'Yesterday';
        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        return pad2(d.getDate())+' '+months[d.getMonth()]+' '+d.getFullYear();
    }
    function formatTime(d){
        let hours = d.getHours();
        const minutes = pad2(d.getMinutes());
        const ampm = hours >= 12 ? 'PM':'AM';
        hours = hours % 12; if (hours === 0) hours = 12;
        return hours + ':' + minutes + ' ' + ampm;
    }

    function connect() {
        var socket = new SockJS('<c:url value="/ws-chat" />');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            console.log('Connected to WebSocket: ' + frame);
            stompClient.subscribe('/topic/messages/' + currentInvestorId, function (message) {
                showMessage(JSON.parse(message.body), currentInvestorId);
            });
            stompClient.subscribe('/topic/typing/' + currentInvestorId, function (message) {
                handleIncomingTyping(JSON.parse(message.body));
            });
            scrollToBottom();
        });
    }

    function loadChat(startupId, startupName, event) {
        const historyDiv = document.getElementById('chatHistory');
        // Mark active chat item in the list
        document.querySelectorAll('.chat-item').forEach(item => item.classList.remove('active'));
        if (event && event.currentTarget) {
            event.currentTarget.classList.add('active');
        } else {
            const el = document.getElementById('partner' + startupId);
            if (el) el.classList.add('active');
        }

        // Update active receiver AFTER UI selection but BEFORE fetch completion
        currentReceiverId = startupId;
        // Update chat header partner name and switch to chat view on mobile
        var pn = document.getElementById('partnerName');
        if (pn) { pn.textContent = startupName; }
        document.body.classList.add('mobile-chat-active');
        // Reset last date separator for this chat
        lastRenderedDateKey = null;

        // Show a simple loading indicator (not a fake conversation message)
        historyDiv.innerHTML = '<p style="text-align: center; color: var(--muted);">Loading chat history with ' + startupName + '...</p>';

        // Fetch chat history from backend REST API
        const url = '/api/chat/history?userId1=' + encodeURIComponent(currentInvestorId) + '&userId2=' + encodeURIComponent(startupId);
        fetch(url, { method: 'GET' })
            .then(resp => {
                if (!resp.ok) throw new Error('Failed to load chat history');
                return resp.json();
            })
            .then(messages => {
                // Only render if the selected partner hasn't changed during the fetch
                if (currentReceiverId !== startupId) {
                    return; // user switched partner; ignore this result
                }
                historyDiv.innerHTML = '';
                if (!messages || messages.length === 0) {
                    const p = document.createElement('p');
                    p.style.cssText = 'text-align:center;color:var(--muted);margin-top:50px;';
                    p.textContent = 'No messages yet. Start the conversation with ' + startupName + '.';
                    p.id = 'initialPrompt';
                    historyDiv.appendChild(p);
                } else {
                    let lastDateKey = null;
                    messages.forEach(m => {
                        // First, ensure the message belongs to the current conversation (bidirectional)
                        const inThisConversation = (m.senderId == currentInvestorId && m.receiverId == currentReceiverId) ||
                            (m.senderId == currentReceiverId && m.receiverId == currentInvestorId);
                        if (!inThisConversation) return;

                        // Insert date separator when the day changes
                        const ts = parseTimestamp(m.timestamp);
                        const dateKey = getDateKey(ts);
                        if (dateKey !== lastDateKey) {
                            const sep = document.createElement('div');
                            sep.className = 'date-separator';
                            sep.textContent = formatDateLabel(ts);
                            historyDiv.appendChild(sep);
                            lastDateKey = dateKey;
                        }

                        // Only after confirming membership, classify as sent/received based on current user id
                        const typeClass = (m.senderId == currentInvestorId) ? 'sent' : 'received';
                        const div = document.createElement('div');
                        div.className = 'message ' + typeClass;
                        renderMessageContent(div, m, ts);
                        historyDiv.appendChild(div);
                    });
                }
                scrollToBottom();
            })
            .catch(err => {
                console.error(err);
                historyDiv.innerHTML = '<p style="text-align:center;color:#ef4444;">Error loading history. Please try again.</p>';
            });
    }

    function showMessage(chatMessage, currentUserId) {
        const historyDiv = document.getElementById('chatHistory');
        const initialPrompt = document.getElementById('initialPrompt');
        if(initialPrompt) initialPrompt.remove();
        const isActiveChat = (chatMessage.senderId == currentUserId && chatMessage.receiverId == currentReceiverId) ||
            (chatMessage.senderId == currentReceiverId && chatMessage.receiverId == currentUserId);
        if (isActiveChat) {
            // Insert date separator if needed
            const ts = parseTimestamp(chatMessage.timestamp);
            const dateKey = getDateKey(ts);
            if (dateKey !== lastRenderedDateKey) {
                const sep = document.createElement('div');
                sep.className = 'date-separator';
                sep.textContent = formatDateLabel(ts);
                historyDiv.appendChild(sep);
                lastRenderedDateKey = dateKey;
            }

            const typeClass = (chatMessage.senderId == currentUserId) ? 'sent' : 'received';
            const messageElement = document.createElement('div');
            messageElement.className = 'message ' + typeClass;
            renderMessageContent(messageElement, chatMessage, ts);
            historyDiv.appendChild(messageElement);
            scrollToBottom();
        }
    }

    function sendMessage() {
        const input = document.getElementById('messageInput');
        const sendBtn = document.getElementById('sendBtn');
        const content = input.value.trim();
        if (content !== '' && stompClient && currentReceiverId) {
            var chatMessage = {
                senderId: currentInvestorId,
                receiverId: currentReceiverId,
                content: content,
            };
            stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
            try { sendTyping(false); } catch(e){}
            input.value = '';
            if (sendBtn) sendBtn.disabled = true;
            input.focus();
        } else if (!currentReceiverId) {
            alert('Please select a startup from the list to start chatting.');
        }
    }

    function toggleDropdown(){
        const d = document.getElementById('myDropdown');
        d.classList.toggle('show');
        d.setAttribute('aria-hidden', d.classList.contains('show') ? 'false' : 'true');
    }

    function showListOnMobile(){
        document.body.classList.remove('mobile-chat-active');
    }

    // Simple theme toggler to match other pages
    function setTheme(theme){
        document.documentElement.setAttribute('data-theme', theme);
        try { localStorage.setItem('theme', theme); } catch(e) {}
        const icon = document.querySelector('#themeToggleBtn i');
        if (icon) icon.className = (theme === 'dark') ? 'fas fa-sun' : 'fas fa-moon';
        const btn = document.getElementById('themeToggleBtn');
        if (btn) btn.setAttribute('aria-pressed', theme === 'dark' ? 'true' : 'false');
    }
    function toggleTheme(){
        const current = document.documentElement.getAttribute('data-theme') || 'light';
        setTheme(current === 'light' ? 'dark' : 'light');
    }

    // --- Attachment rendering, emoji picker, typing indicator helpers ---
    function renderMessageContent(container, msg, ts){
        const bubble = document.createElement('div');
        bubble.className = 'bubble';
        const content = (msg && typeof msg.content === 'string') ? msg.content : '';
        if (content.startsWith('FILE::')){
            try{
                const meta = JSON.parse(content.substring(6));
                if (meta && meta.type && String(meta.type).startsWith('image/')){
                    const img = new Image();
                    img.src = meta.url;
                    img.alt = meta.name || 'image';
                    img.loading = 'lazy';
                    img.style.maxWidth = '240px';
                    img.style.borderRadius = '10px';
                    img.referrerPolicy = 'no-referrer';
                    bubble.appendChild(img);
                    if (meta.name){
                        const cap = document.createElement('div');
                        cap.style.fontSize = '0.8rem';
                        cap.style.color = 'var(--muted)';
                        cap.textContent = meta.name;
                        bubble.appendChild(cap);
                    }
                } else {
                    const a = document.createElement('a');
                    a.href = meta.url;
                    a.target = '_blank';
                    a.rel = 'noopener';
                    a.textContent = meta.name || 'Download file';
                    bubble.appendChild(a);
                }
            }catch(e){
                bubble.textContent = content;
            }
        } else {
            bubble.textContent = content;
        }
        const timeEl = document.createElement('div');
        timeEl.className = 'timestamp';
        timeEl.textContent = formatTime(ts || new Date());
        container.appendChild(bubble);
        container.appendChild(timeEl);
    }

    const EMOJI_SET = ['😀','😁','😂','🤣','😊','😍','😘','😎','🤩','🙂','😉','😇','🥰','🤗','🤔','🤨','🙃','😴','🤤','😢','😭','😡','😤','👍','👎','👏','🙌','🙏','💪','🔥','✨','🎉','💯','✅','❌','💡','📎','📷','🖼️'];

    function insertAtCursor(input, text){
        if (!input) return;
        const start = input.selectionStart || 0;
        const end = input.selectionEnd || start;
        const before = input.value.substring(0, start);
        const after = input.value.substring(end);
        input.value = before + text + after;
        const pos = start + text.length;
        input.setSelectionRange(pos, pos);
        input.focus();
        input.dispatchEvent(new Event('input', { bubbles: true }));
    }

    function buildEmojiPicker(pickerEl, inputEl){
        if (!pickerEl || pickerEl.dataset.built) return;
        const wrap = document.createElement('div');
        wrap.style.display = 'grid';
        wrap.style.gridTemplateColumns = 'repeat(10, 24px)';
        wrap.style.gap = '6px';
        EMOJI_SET.forEach(e => {
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.textContent = e;
            btn.style.width = '24px';
            btn.style.height = '24px';
            btn.style.border = 'none';
            btn.style.background = 'transparent';
            btn.style.cursor = 'pointer';
            btn.addEventListener('click', () => insertAtCursor(inputEl, e));
            wrap.appendChild(btn);
        });
        pickerEl.appendChild(wrap);
        pickerEl.dataset.built = '1';
    }

    let typingHideTimer = null;
    function handleIncomingTyping(data){
        if (!data) return;
        if (data.from == currentReceiverId){
            const ind = document.getElementById('typingIndicator');
            if (!ind) return;
            if (data.typing){
                ind.style.display = 'inline';
                if (typingHideTimer) clearTimeout(typingHideTimer);
                typingHideTimer = setTimeout(()=>{ ind.style.display='none'; }, 2000);
            } else {
                ind.style.display = 'none';
            }
        }
    }

    function sendTyping(state){
        if (!stompClient || !currentReceiverId) return;
        const payload = { from: currentInvestorId, to: currentReceiverId, typing: !!state };
        try { stompClient.send('/app/typing', {}, JSON.stringify(payload)); } catch(e){}
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

        // Improve search UX: submit on Enter only
        const searchInput = document.getElementById('searchInput');
        const searchForm = document.getElementById('searchForm');
        if (searchInput && searchForm) {
            // If the field comes prefilled with only quotes, clear it
            if (searchInput.value && /^'+$/.test(searchInput.value)) {
                searchInput.value = '';
            }

            searchInput.addEventListener('keydown', function(e){
                if (e.key === 'Enter') {
                    e.preventDefault();
                    searchInput.value = searchInput.value.trim();
                    searchForm.submit();
                }
            });
        }

        // Message input behavior: enable/disable send and Enter to send + emoji/attach + typing
        const msgInput = document.getElementById('messageInput');
        const sendBtn = document.getElementById('sendBtn');
        const emojiBtn = document.getElementById('emojiBtn');
        const emojiPicker = document.getElementById('emojiPicker');
        const attachBtn = document.getElementById('attachBtn');
        const fileInput = document.getElementById('fileInput');
        if (emojiPicker && msgInput) buildEmojiPicker(emojiPicker, msgInput);

        if (msgInput && sendBtn){
            const syncState = () => {
                const hasText = msgInput.value.trim().length > 0;
                sendBtn.disabled = !hasText;
            };
            let typingTimer = null;
            const TYPING_IDLE = 1200;
            msgInput.addEventListener('input', function(){
                syncState();
                sendTyping(true);
                if (typingTimer) clearTimeout(typingTimer);
                typingTimer = setTimeout(()=> sendTyping(false), TYPING_IDLE);
            });
            msgInput.addEventListener('blur', function(){ sendTyping(false); });
            msgInput.addEventListener('keydown', function(e){
                if (e.key === 'Enter' && !e.shiftKey){
                    e.preventDefault();
                    if (!sendBtn.disabled) sendMessage();
                }
                if (e.key === 'Escape' && emojiPicker){ emojiPicker.style.display = 'none'; }
            });
            syncState();
        }

        if (emojiBtn && emojiPicker){
            emojiBtn.addEventListener('click', function(){
                emojiPicker.style.display = (emojiPicker.style.display === 'none' || !emojiPicker.style.display) ? 'block' : 'none';
            });
            document.addEventListener('click', function(e){
                if (!emojiPicker.contains(e.target) && e.target !== emojiBtn){
                    emojiPicker.style.display = 'none';
                }
            });
        }

        if (attachBtn && fileInput){
            attachBtn.addEventListener('click', function(){ fileInput.click(); });
            fileInput.addEventListener('change', async function(){
                if (!fileInput.files || fileInput.files.length === 0) return;
                if (!currentReceiverId){ alert('Please select a startup first.'); fileInput.value=''; return; }
                const file = fileInput.files[0];
                const fd = new FormData();
                fd.append('file', file);
                try{
                    const resp = await fetch('/api/chat/upload', { method: 'POST', body: fd });
                    if (!resp.ok){
                        const text = await resp.text();
                        alert('Upload failed: ' + text);
                    } else {
                        const meta = await resp.json();
                        const content = 'FILE::' + JSON.stringify(meta);
                        const chatMessage = { senderId: currentInvestorId, receiverId: currentReceiverId, content };
                        stompClient.send('/app/chat', {}, JSON.stringify(chatMessage));
                    }
                }catch(err){
                    console.error(err);
                    alert('Upload failed');
                } finally {
                    fileInput.value = '';
                }
            });
        }
    });
</script>

</body>
</html>