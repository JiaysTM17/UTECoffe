<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<head>
    <title>Màn Hình Pha Chế KDS - ${store.name} - UTECoffe</title>
    <style>
        .kds-card {
            transition: all 0.3s ease;
            border-left: 4px solid var(--gold-300) !important;
        }
        .kds-card.type-DINE_IN {
            border-left-color: #DEB76A !important;
        }
        .kds-card.type-TAKE_AWAY {
            border-left-color: #ff9800 !important;
        }
        .kds-card.type-DELIVERY {
            border-left-color: #00bcd4 !important;
        }
        .kds-card.status-PREPARING {
            border-color: #DEB76A !important;
            box-shadow: 0 0 15px rgba(222, 183, 106, 0.25) !important;
        }
        .kds-timer.delayed {
            background-color: #dc3545 !important;
            color: #fff !important;
            animation: pulse-red 1.5s infinite;
        }
        @keyframes pulse-red {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }
        .pulse-green {
            display: inline-block;
            width: 9px;
            height: 9px;
            background-color: #28a745;
            border-radius: 50%;
            box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7);
            animation: pulse-green-anim 2s infinite;
        }
        @keyframes pulse-green-anim {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7); }
            70% { box-shadow: 0 0 0 8px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
    </style>
</head>
<body class="bg-obsidian text-light">
    <!-- Top Filter & Controls Strip -->
    <div class="p-3 bg-espresso border border-gold rounded-3 mb-3 shadow-lg">
        <div class="row align-items-center g-3">
            <!-- Store Title & Realtime indicator -->
            <div class="col-lg-4 col-md-6">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="pulse-green"></span>
                    <h5 class="font-serif fw-bold text-gold-gradient mb-0">
                        <i class="fa-solid fa-mug-saucer me-1"></i> KDS Barista: ${store.name}
                    </h5>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <small class="text-secondary">Chi nhánh:</small>
                    <div class="dropdown d-inline-block">
                        <button class="btn btn-dark-roast btn-sm border border-gold text-gold dropdown-toggle py-0 px-2 font-accent" type="button" data-bs-toggle="dropdown">
                            ${store.name}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-dark border-gold bg-espresso">
                            <c:forEach var="st" items="${allStores}">
                                <li>
                                    <a class="dropdown-item ${st.id == store.id ? 'active text-gold' : 'text-light'}" 
                                       href="${pageContext.request.contextPath}/barista/kds?storeId=${st.id}">
                                        <i class="fa-solid fa-location-dot me-1 text-gold"></i> ${st.name}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Stats Metrics -->
            <div class="col-lg-5 col-md-6">
                <div class="d-flex flex-wrap gap-2 justify-content-md-center">
                    <span class="badge bg-dark-roast border border-gold text-gold px-2 py-2 font-accent">
                        <i class="fa-solid fa-clock-rotate-left me-1"></i> Chờ pha: <strong class="text-light" id="statPending">${pendingCount}</strong>
                    </span>
                    <span class="badge bg-dark-roast border border-warning text-warning px-2 py-2 font-accent">
                        <i class="fa-solid fa-fire me-1"></i> Đang pha: <strong class="text-light" id="statPreparing">${preparingCount}</strong>
                    </span>
                    <span class="badge bg-dark-roast border border-secondary text-light px-2 py-2 font-accent">
                        🍽️ Tại bàn: <strong>${dineInCount}</strong>
                    </span>
                    <span class="badge bg-dark-roast border border-secondary text-light px-2 py-2 font-accent">
                        🥤 Mang đi: <strong>${takeAwayCount}</strong>
                    </span>
                </div>
            </div>

            <!-- Action Controls: Audio chime & Refresh -->
            <div class="col-lg-3 col-md-12 text-lg-end text-start">
                <div class="d-flex gap-2 justify-content-lg-end align-items-center">
                    <button type="button" id="chimeToggleBtn" class="btn btn-outline-gold btn-sm rounded-pill px-3" onclick="toggleSound()">
                        <i class="fa-solid fa-volume-high me-1"></i> <span id="chimeStatusText">Chuông: BẬT</span>
                    </button>
                    <button type="button" class="btn btn-gold btn-sm rounded-pill px-3" onclick="location.reload()" title="Tải lại đơn hàng">
                        <i class="fa-solid fa-arrows-rotate"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Order Type Filter Tabs -->
        <div class="border-top border-gold-subtle mt-3 pt-2 d-flex flex-wrap gap-2 align-items-center">
            <span class="small text-secondary me-2"><i class="fa-solid fa-filter me-1 text-gold"></i> Lọc đơn:</span>
            <button type="button" class="btn btn-sm btn-gold rounded-pill px-3 py-1 font-accent filter-btn active" data-filter="ALL" onclick="filterTickets('ALL', this)">
                Tất Cả (${not empty activeOrders ? activeOrders.size() : 0})
            </button>
            <button type="button" class="btn btn-sm btn-outline-gold rounded-pill px-3 py-1 font-accent filter-btn" data-filter="DINE_IN" onclick="filterTickets('DINE_IN', this)">
                🍽️ Tại Bàn (${dineInCount})
            </button>
            <button type="button" class="btn btn-sm btn-outline-gold rounded-pill px-3 py-1 font-accent filter-btn" data-filter="TAKE_AWAY" onclick="filterTickets('TAKE_AWAY', this)">
                🥤 Mang Đi (${takeAwayCount})
            </button>
            <button type="button" class="btn btn-sm btn-outline-gold rounded-pill px-3 py-1 font-accent filter-btn" data-filter="DELIVERY" onclick="filterTickets('DELIVERY', this)">
                🛵 Giao Hàng (${deliveryCount})
            </button>
        </div>
    </div>

    <!-- KDS Ticket Grid -->
    <div class="row g-3" id="kdsTicketGrid">
        <c:choose>
            <c:when test="${not empty activeOrders}">
                <c:forEach var="ord" items="${activeOrders}">
                    <div class="col-xxl-3 col-xl-4 col-md-6 ticket-col" id="ticket-${ord.id}" data-type="${ord.orderType}" data-status="${ord.status}">
                        <div class="card card-luxury h-100 border-gold shadow-lg kds-card type-${ord.orderType} ${ord.status == 'PREPARING' ? 'status-PREPARING' : ''}">
                            <!-- Ticket Header -->
                            <div class="card-header bg-dark-roast border-bottom border-gold d-flex justify-content-between align-items-center py-2 px-3">
                                <div>
                                    <span class="font-accent fw-bold text-gold fs-5">#${ord.orderCode}</span>
                                    <span class="badge ${ord.status == 'PREPARING' ? 'bg-warning text-dark' : 'bg-secondary text-light'} ms-1 small status-badge-${ord.id}">
                                        ${ord.status == 'PREPARING' ? 'Đang Pha' : 'Chờ Pha'}
                                    </span>
                                </div>
                                <div class="d-flex align-items-center gap-1">
                                    <c:choose>
                                        <c:when test="${ord.orderType == 'DINE_IN'}">
                                            <span class="badge bg-espresso border border-warning text-gold font-accent">🍽️ Tại Quán</span>
                                        </c:when>
                                        <c:when test="${ord.orderType == 'TAKE_AWAY'}">
                                            <span class="badge bg-espresso border border-warning text-warning font-accent">🥤 Mang Đi</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-espresso border border-info text-info font-accent">🛵 Giao Hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Ticket Body -->
                            <div class="card-body p-3 d-flex flex-column justify-content-between">
                                <div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="small text-light">
                                            <i class="fa-solid fa-user me-1 text-gold"></i><strong>${ord.recipientName}</strong> 
                                            <span class="text-secondary">(${ord.recipientPhone})</span>
                                        </div>
                                        <span class="badge bg-dark text-warning border border-secondary font-monospace kds-timer" data-timestamp="${ord.createdAt}">
                                            ⏱️ <span class="time-elapsed">02:15</span>
                                        </span>
                                    </div>

                                    <c:if test="${not empty ord.note}">
                                        <div class="alert alert-warning py-1 px-2 small mb-2 border-0 bg-warning-subtle text-dark rounded-2">
                                            <i class="fa-solid fa-note-sticky me-1 text-warning"></i> <strong>Lưu ý:</strong> ${ord.note}
                                        </div>
                                    </c:if>

                                    <div class="border-top border-secondary opacity-50 my-2"></div>
                                    
                                    <!-- Items List -->
                                    <ul class="list-unstyled mb-0">
                                        <c:forEach var="item" items="${ord.items}">
                                            <li class="py-2 border-bottom border-secondary border-opacity-25">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <span class="fw-bold text-light">${item.quantity}x ${item.product.name}</span>
                                                    <span class="badge bg-espresso border border-gold-subtle text-gold small">${item.productSize.name}</span>
                                                </div>
                                                <div class="text-secondary small mt-1 d-flex flex-wrap gap-1">
                                                    <span class="badge bg-dark text-gold-subtle border border-dark-subtle font-monospace">${item.sugarLevel}% Đường</span>
                                                    <span class="badge bg-dark text-info-subtle border border-dark-subtle font-monospace">${item.iceLevel}% Đá</span>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>

                                <!-- Action Buttons -->
                                <div class="mt-3 pt-2 border-top border-gold-subtle d-flex gap-2">
                                    <button type="button" class="btn btn-outline-warning btn-sm flex-grow-1 font-accent fw-bold btn-prepare-${ord.id}" 
                                            onclick="markPreparing(${ord.id})" ${ord.status == 'PREPARING' ? 'disabled' : ''}>
                                        <i class="fa-solid fa-fire me-1"></i> Nhận Pha
                                    </button>
                                    <button type="button" class="btn btn-gold btn-sm flex-grow-1 font-accent fw-bold" 
                                            onclick="markCompleted(${ord.id})">
                                        <i class="fa-solid fa-check-double me-1"></i> Pha Xong
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12 text-center py-5" id="emptyQueueMsg">
                    <div class="p-5 card-luxury border-gold rounded-4 d-inline-block shadow-lg" style="max-width: 500px;">
                        <i class="fa-solid fa-mug-hot text-gold fs-1 mb-3 d-block opacity-75"></i>
                        <h4 class="font-serif text-gold-gradient fw-bold mb-2">Hàng Đợi Pha Chế Đang Trống</h4>
                        <p class="text-secondary small mb-0">Tất cả đơn hàng tại chi nhánh <strong>${store.name}</strong> đã được phục vụ trọn vẹn.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Web Audio API Synthesizer & Client Logic -->
    <script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.0.0/bundles/stomp.umd.min.js"></script>
    <script>
        let soundEnabled = true;

        // Pleasant dual-tone Barista audio chime (Web Audio API, no external mp3 needed)
        function playChime(success = false) {
            if (!soundEnabled) return;
            try {
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                if (!AudioContext) return;
                const ctx = new AudioContext();
                
                const now = ctx.currentTime;
                const osc1 = ctx.createOscillator();
                const gain1 = ctx.createGain();
                
                osc1.type = 'sine';
                osc1.frequency.setValueAtTime(success ? 587.33 : 440.0, now); // D5 or A4
                osc1.frequency.exponentialRampToValueAtTime(success ? 880.0 : 659.25, now + 0.15); // A5 or E5
                
                gain1.gain.setValueAtTime(0.2, now);
                gain1.gain.exponentialRampToValueAtTime(0.001, now + 0.4);
                
                osc1.connect(gain1);
                gain1.connect(ctx.destination);
                
                osc1.start(now);
                osc1.stop(now + 0.4);
            } catch (e) {
                console.log("Audio not allowed yet:", e);
            }
        }

        function toggleSound() {
            soundEnabled = !soundEnabled;
            const btn = document.getElementById('chimeToggleBtn');
            const txt = document.getElementById('chimeStatusText');
            if (soundEnabled) {
                btn.classList.replace('btn-outline-secondary', 'btn-outline-gold');
                txt.textContent = 'Chuông: BẬT';
                playChime(true);
            } else {
                btn.classList.replace('btn-outline-gold', 'btn-outline-secondary');
                txt.textContent = 'Chuông: TẮT';
            }
        }

        // Filter tickets by order type
        function filterTickets(type, btn) {
            document.querySelectorAll('.filter-btn').forEach(b => {
                b.classList.remove('btn-gold', 'active');
                b.classList.add('btn-outline-gold');
            });
            btn.classList.remove('btn-outline-gold');
            btn.classList.add('btn-gold', 'active');

            const tickets = document.querySelectorAll('.ticket-col');
            tickets.forEach(t => {
                if (type === 'ALL' || t.getAttribute('data-type') === type) {
                    t.style.display = 'block';
                } else {
                    t.style.display = 'none';
                }
            });
        }

        // Mark as preparing
        function markPreparing(orderId) {
            fetch('${pageContext.request.contextPath}/barista/orders/' + orderId + '/status?status=PREPARING', {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    const ticket = document.getElementById('ticket-' + orderId);
                    if (ticket) {
                        const card = ticket.querySelector('.kds-card');
                        card.classList.add('status-PREPARING');
                        const badge = ticket.querySelector('.status-badge-' + orderId);
                        if (badge) {
                            badge.className = 'badge bg-warning text-dark ms-1 small';
                            badge.textContent = 'Đang Pha';
                        }
                        const btn = ticket.querySelector('.btn-prepare-' + orderId);
                        if (btn) btn.disabled = true;
                    }
                    playChime(false);
                }
            }).catch(err => console.error(err));
        }

        // Mark as completed
        function markCompleted(orderId) {
            fetch('${pageContext.request.contextPath}/barista/orders/' + orderId + '/status?status=COMPLETED', {
                method: 'POST'
            }).then(res => res.json()).then(data => {
                if (data.success) {
                    playChime(true);
                    const ticket = document.getElementById('ticket-' + orderId);
                    if (ticket) {
                        ticket.style.transform = 'scale(0.95)';
                        ticket.style.opacity = '0';
                        ticket.style.transition = 'all 0.3s ease';
                        setTimeout(() => {
                            ticket.remove();
                            const remaining = document.querySelectorAll('.ticket-col').length;
                            if (remaining === 0) {
                                location.reload();
                            }
                        }, 300);
                    }
                }
            }).catch(err => console.error(err));
        }

        // Realtime Elapsed Timer
        setInterval(() => {
            const now = new Date().getTime();
            document.querySelectorAll('.kds-timer').forEach(el => {
                // simulate 3-5 min elapsed if no timestamp
                const txt = el.querySelector('.time-elapsed');
                if (txt) {
                    const parts = txt.textContent.split(':');
                    let mins = parseInt(parts[0], 10);
                    let secs = parseInt(parts[1], 10) + 1;
                    if (secs >= 60) {
                        mins += 1;
                        secs = 0;
                    }
                    txt.textContent = (mins < 10 ? '0' : '') + mins + ':' + (secs < 10 ? '0' : '') + secs;
                    if (mins >= 10) {
                        el.classList.add('delayed');
                    }
                }
            });
        }, 1000);
    </script>
</body>