/**
 * UTECoffe Luxury Experience & Interaction Engine
 * Features:
 *  1. Dual Luxury Theme Switcher (Obsidian Espresso & Alabaster Cream)
 *  2. Bilingual i18n Switcher (Vietnamese & English)
 *  3. Dynamic Active Navigation Link Highlighter
 *  4. High-Precision Artisanal Number Counter Animation (IntersectionObserver)
 *  5. Glassmorphism Sticky Navbar Scroll Effect
 */

(function () {
    'use strict';

    // -------------------------------------------------------------------------
    // 1. Bilingual i18n Dictionary
    // -------------------------------------------------------------------------
    const I18N_DICTIONARY = {
        vi: {
            // Top Announcement Bar
            'topbar.location': 'Flagship: 01 Võ Văn Ngân, TP. Thủ Đức, TP.HCM',
            'topbar.promo': 'ƯU ĐÃI 20% ĐƠN ĐẦU TIÊN • FREESHIP TOÀN QUỐC TỪ 150.000₫',
            'topbar.hours': '07:00 - 22:30',
            'topbar.hotline': 'Hotline: 1900 2026',

            // Navigation Menu
            'nav.home': 'Trang Chủ',
            'nav.menu': 'Thực Đơn',
            'nav.story': 'Câu Chuyện',
            'nav.reservation': 'Đặt Bàn',
            'nav.stores': 'Chi Nhánh',
            'nav.cart': 'Giỏ Hàng',
            'nav.login': 'Đăng Nhập',
            'nav.profile': 'Hồ Sơ & UTEClub',
            'nav.admin': 'Trang Quản Trị',
            'nav.kds': 'Quầy Pha Chế KDS',
            'nav.logout': 'Đăng Xuất',

            // Hero Section
            'hero.tag': 'DI SẢN CÀ PHÊ & TRÀ ĐẶC SẢN NGUYÊN BẢN',
            'hero.title': 'Nghệ Thuật Rang Mộc & Tách Cà Phê Hoàn Hảo',
            'hero.desc': 'Tận hưởng tinh hoa từ độ cao 1.600m cao nguyên Cầu Đất. Mỗi hạt cà phê tại UTECoffe được tuyển chọn kỹ lưỡng, rang mộc thủ công từng mẻ nhỏ để lưu giữ trọn vẹn dải hương hoa quả phong phú và hậu vị ngọt sâu.',
            'hero.btn_menu': 'Khám Phá Thực Đơn',
            'hero.btn_reserve': 'Đặt Bàn Thưởng Thức',
            'hero.stat1_label': 'Điểm Cupping Đặc Sản',
            'hero.stat2_label': 'Độ Cao Cầu Đất Terroir',
            'hero.stat3_label': 'Cửa Hàng Flagship',
            'hero.badge_artisan': 'ARTISANAL ROASTERS',

            // Categories Section
            'cat.subtitle': 'BỘ SƯU TẬP TUYỂN CHỌN',
            'cat.title': 'Dòng Thức Uống Đặc Trưng',
            'cat.tea': 'Trà Thượng Hạng',
            'cat.coffee': 'Cà Phê Đặc Sản',
            'cat.pastry': 'Bánh Nghệ Nhân',

            // Featured Products Section
            'feat.subtitle': 'SIGNATURE SELECTION',
            'feat.title': 'Bộ Sưu Tập Mùa Thu Hoạch',
            'feat.view_all': 'Xem Toàn Bộ Thực Đơn',
            'feat.add_cart': 'Thêm Giỏ Hàng',

            // Footer
            'footer.desc': 'Thương hiệu chuỗi bán lẻ trà và cà phê đặc sản nguyên bản kết hợp mô hình thương mại đa kênh OMO hiện đại.',
            'footer.explore': 'Khám Phá',
            'footer.policy': 'Chính Sách & Hỗ Trợ',
            'footer.newsletter': 'Bản Tin Nghệ Nhân',
            'footer.newsletter_desc': 'Đăng ký nhận thông tin mẻ rang mới và ưu đãi hội viên:',
            'footer.subscribe': 'Đăng Ký',
            'footer.rights': 'Bản quyền thuộc về UTECoffe Roastery. Thiết kế & phát triển cho đồ án F&B Thương mại điện tử 2026.',

            // Menu & Products
            'menu.title': 'Thực Đơn Nghệ Nhân',
            'menu.subtitle': 'BỘ SƯU TẬP HƯƠNG VỊ 2026',
            'menu.filter_all': 'Tất Cả Món',
            'menu.original_price': 'Giá nguyên bản:',
            'menu.customize': 'Tùy Chỉnh',
            'terroir.coffee': 'Cao Nguyên Cầu Đất 1.600m',
            'terroir.tea': 'Trà Cổ Thụ & Sen Tây Hồ',
            'terroir.pastry': 'Bơ Pháp Elle & Vire 100%',

            // Customizer & Detail
            'detail.price_label': 'Giá Thưởng Thức:',
            'customizer.title': 'Tùy Chỉnh Khẩu Vị Barista',
            'customizer.badge': 'Chuẩn Vị Nghệ Nhân',
            'customizer.step1': 'Chọn Kích Cỡ Ly:',
            'customizer.step2': 'Mức Đá & Nhiệt Độ:',
            'customizer.step3': 'Mức Đường / Ngọt:',
            'customizer.step4': 'Tùy Chọn Sữa:',
            'customizer.step5': 'Thêm Topping Thượng Hạng:',
            'customizer.pastry_title': 'Tùy Chọn Thưởng Thức Bánh Nghệ Nhân',
            'customizer.pastry_badge': '100% Bơ Pháp Elle & Vire',
            'customizer.pastry_step1': 'Quy Cách Đóng Gói:',
            'customizer.pastry_step2': 'Cách Thức Phục Vụ:',
            'customizer.pastry_step3': 'Sốt & Topping Ăn Kèm:',
            'customizer.tea_title': 'Tùy Chỉnh Hương Vị Trà Đạo',
            'customizer.tea_badge': 'Trà Cổ Thụ & Sen Tây Hồ',
            'customizer.tea_step4': 'Lớp Foam & Sữa:',
            'customizer.tea_step5': 'Topping Trà Thượng Hạng:',
            'customizer.topping_hint': 'Chọn nhiều tùy thích',
            'customizer.add_to_cart': 'Thêm Vào Giỏ Hàng',
            'customizer.view_cart': 'Xem Giỏ Hàng'
        },
        en: {
            // Top Announcement Bar
            'topbar.location': 'Flagship: 01 Vo Van Ngan, Thu Duc City, HCMC',
            'topbar.promo': '20% OFF FIRST ORDER • FREE SHIPPING NATIONWIDE OVER 150,000₫',
            'topbar.hours': '07:00 AM - 10:30 PM',
            'topbar.hotline': 'Hotline: 1900 2026',

            // Navigation Menu
            'nav.home': 'Home',
            'nav.menu': 'Menu',
            'nav.story': 'Our Story',
            'nav.reservation': 'Reservations',
            'nav.stores': 'Roasteries',
            'nav.cart': 'Cart',
            'nav.login': 'Sign In',
            'nav.profile': 'Profile & UTEClub',
            'nav.admin': 'Admin Suite',
            'nav.kds': 'Barista KDS',
            'nav.logout': 'Sign Out',

            // Hero Section
            'hero.tag': 'AUTHENTIC SPECIALTY COFFEE & CAMELLIA TEA HERITAGE',
            'hero.title': 'The Art of Artisanal Roasting & The Perfect Cup',
            'hero.desc': 'Savoring perfection from 1,600m Cau Dat highlands. Each coffee bean is ethically harvested, small-batch micro-roasted to preserve exquisite floral aromas, vibrant fruit notes, and a velvety lingering sweetness.',
            'hero.btn_menu': 'Explore Menu',
            'hero.btn_reserve': 'Reserve a Table',
            'hero.stat1_label': 'SCA Cupping Score',
            'hero.stat2_label': 'Highland Terroir Altitude',
            'hero.stat3_label': 'Flagship Roasteries',
            'hero.badge_artisan': 'ARTISANAL ROASTERS',

            // Categories Section
            'cat.subtitle': 'CURATED COLLECTIONS',
            'cat.title': 'Signature Beverage Craft',
            'cat.tea': 'Premier Teas',
            'cat.coffee': 'Specialty Coffees',
            'cat.pastry': 'Artisan Pastries',

            // Featured Products Section
            'feat.subtitle': 'SIGNATURE SELECTION',
            'feat.title': 'Harvest Micro-Lot Series',
            'feat.view_all': 'View Full Menu',
            'feat.add_cart': 'Add to Cart',

            // Footer
            'footer.desc': 'Artisanal specialty coffee & tea roastery with integrated Online-Merge-Offline (OMO) omnichannel experience.',
            'footer.explore': 'Explore',
            'footer.policy': 'Policies & Support',
            'footer.newsletter': 'Roaster Digest',
            'footer.newsletter_desc': 'Subscribe for exclusive fresh batch releases and member privileges:',
            'footer.subscribe': 'Subscribe',
            'footer.rights': 'All rights reserved © UTECoffe Roastery. Designed & developed for 2026 F&B Ecommerce Platform.',

            // Menu & Products
            'menu.title': 'Artisan Menu',
            'menu.subtitle': '2026 FLAVOR SELECTION',
            'menu.filter_all': 'All Items',
            'menu.original_price': 'Original Price:',
            'menu.customize': 'Customize',
            'terroir.coffee': 'Cau Dat Highlands 1,600m',
            'terroir.tea': 'Ancient Camellia & Tay Ho Lotus',
            'terroir.pastry': '100% French Elle & Vire Butter',

            // Customizer & Detail
            'detail.price_label': 'Crafted Price:',
            'customizer.title': 'Barista Taste Customizer',
            'customizer.badge': 'Artisan Precision',
            'customizer.step1': 'Choose Cup Size:',
            'customizer.step2': 'Ice & Temperature:',
            'customizer.step3': 'Sweetness Level:',
            'customizer.step4': 'Milk Selection:',
            'customizer.step5': 'Artisan Toppings:',
            'customizer.pastry_title': 'Artisan Pastry Serving Options',
            'customizer.pastry_badge': '100% French Elle & Vire Butter',
            'customizer.pastry_step1': 'Packaging & Portion:',
            'customizer.pastry_step2': 'Serving Method:',
            'customizer.pastry_step3': 'Sauce & Accompaniment:',
            'customizer.tea_title': 'Artisanal Tea Customizer',
            'customizer.tea_badge': 'Ancient Camellia & Tay Ho Lotus',
            'customizer.tea_step4': 'Foam & Milk Options:',
            'customizer.tea_step5': 'Artisanal Tea Toppings:',
            'customizer.topping_hint': 'Select multiple toppings',
            'customizer.add_to_cart': 'Add to Cart',
            'customizer.view_cart': 'View Cart'
        }
    };

    // -------------------------------------------------------------------------
    // 2. Theme Management (Dark / Light)
    // -------------------------------------------------------------------------
    function initTheme() {
        const savedTheme = localStorage.getItem('utecoffe_theme') || 'dark';
        applyTheme(savedTheme, false);

        const themeToggleBtn = document.getElementById('themeToggleBtn');
        if (themeToggleBtn) {
            themeToggleBtn.addEventListener('click', function () {
                const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
                const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
                applyTheme(nextTheme, true);
            });
        }
    }

    function applyTheme(theme, animate) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('utecoffe_theme', theme);

        // Update Logo Image
        const logoImgs = document.querySelectorAll('#navbarLogo, .brand-logo-img');
        const contextPath = window.UTECOFFE_CONTEXT_PATH || '';
        const darkLogoSrc = contextPath + '/assets/images/logo_dark.svg';
        const lightLogoSrc = contextPath + '/assets/images/logo_light.svg';

        logoImgs.forEach(img => {
            img.src = (theme === 'light') ? lightLogoSrc : darkLogoSrc;
        });

        // Update Theme Button Title
        const themeBtn = document.getElementById('themeToggleBtn');
        if (themeBtn) {
            themeBtn.setAttribute('title', theme === 'dark' ? 'Chuyển sang giao diện Sáng (Alabaster Cream)' : 'Chuyển sang giao diện Tối (Obsidian Espresso)');
        }
    }

    // -------------------------------------------------------------------------
    // 3. Bilingual i18n Management (VN / EN)
    // -------------------------------------------------------------------------
    function initLanguage() {
        const savedLang = localStorage.getItem('utecoffe_lang') || 'vi';
        applyLanguage(savedLang);

        const langButtons = document.querySelectorAll('.btn-lang-toggle');
        langButtons.forEach(btn => {
            btn.addEventListener('click', function () {
                const lang = this.getAttribute('data-lang');
                if (lang) {
                    applyLanguage(lang);
                }
            });
        });
    }

    function applyLanguage(lang) {
        localStorage.setItem('utecoffe_lang', lang);

        // Update Toggle Buttons
        document.querySelectorAll('.btn-lang-toggle').forEach(btn => {
            if (btn.getAttribute('data-lang') === lang) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });

        // Translate data-i18n elements
        const dict = I18N_DICTIONARY[lang] || I18N_DICTIONARY.vi;
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            if (dict[key]) {
                el.textContent = dict[key];
            }
        });

        // Update raw prices uniformly
        document.querySelectorAll('[data-raw-price]').forEach(el => {
            const raw = parseFloat(el.getAttribute('data-raw-price'));
            if (!isNaN(raw) && raw > 0) {
                if (lang === 'en') {
                    el.textContent = Math.round(raw).toLocaleString('en-US') + ' VND';
                } else {
                    el.textContent = Math.round(raw).toLocaleString('vi-VN') + ' VNĐ';
                }
            }
        });

        // Update document lang attribute
        document.documentElement.setAttribute('lang', lang);

        // Notify page-specific listeners
        window.dispatchEvent(new CustomEvent('utecoffe:langchange', { detail: { lang } }));
    }

    // -------------------------------------------------------------------------
    // 4. Dynamic Active Navigation Link Highlighter
    // -------------------------------------------------------------------------
    function initActiveNavLinks() {
        const currentPath = window.location.pathname.replace(/\/$/, '') || '/';
        const navLinks = document.querySelectorAll('.nav-link-luxury');

        navLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (!href) return;

            try {
                const url = new URL(href, window.location.origin);
                const linkPath = url.pathname.replace(/\/$/, '') || '/';

                // Exact match or sub-route match
                if (linkPath === currentPath) {
                    link.classList.add('active');
                } else if (linkPath !== '/' && currentPath.startsWith(linkPath)) {
                    link.classList.add('active');
                } else {
                    link.classList.remove('active');
                }
            } catch (e) {
                // Ignore parse errors for anchors
            }
        });
    }

    // -------------------------------------------------------------------------
    // 5. Artisanal Number Counter Animation
    // -------------------------------------------------------------------------
    function initCounterAnimation() {
        const counters = document.querySelectorAll('[data-counter]');
        if (!counters.length) return;

        const observerOptions = {
            threshold: 0.25,
            rootMargin: '0px 0px -40px 0px'
        };

        const counterObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const el = entry.target;
                    animateCounter(el);
                    observer.unobserve(el);
                }
            });
        }, observerOptions);

        counters.forEach(counter => counterObserver.observe(counter));
    }

    function animateCounter(el) {
        const targetValue = parseFloat(el.getAttribute('data-counter')) || 0;
        const prefix = el.getAttribute('data-counter-prefix') || '';
        const suffix = el.getAttribute('data-counter-suffix') || '';
        const isDecimal = targetValue % 1 !== 0;
        const hasCommaFormat = el.getAttribute('data-counter-format') === 'comma';
        const duration = parseInt(el.getAttribute('data-counter-duration')) || 1800; // ms

        const startTime = performance.now();

        function updateCounter(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);

            // Ease Out Cubic function: 1 - pow(1 - x, 3)
            const easeProgress = 1 - Math.pow(1 - progress, 3);
            const currentValue = targetValue * easeProgress;

            let formattedValue;
            if (isDecimal) {
                formattedValue = currentValue.toFixed(1);
            } else {
                formattedValue = Math.floor(currentValue);
            }

            if (hasCommaFormat) {
                // e.g. 1,600 or 1.600
                formattedValue = formattedValue.toLocaleString('vi-VN');
            }

            el.textContent = prefix + formattedValue + suffix;

            if (progress < 1) {
                requestAnimationFrame(updateCounter);
            } else {
                let finalFormatted = isDecimal ? targetValue.toFixed(1) : targetValue;
                if (hasCommaFormat) {
                    finalFormatted = finalFormatted.toLocaleString('vi-VN');
                }
                el.textContent = prefix + finalFormatted + suffix;
            }
        }

        requestAnimationFrame(updateCounter);
    }

    // -------------------------------------------------------------------------
    // 6. Sticky Navbar Scrolled Effect
    // -------------------------------------------------------------------------
    function initNavbarScroll() {
        const navbar = document.querySelector('.navbar-luxury');
        if (!navbar) return;

        window.addEventListener('scroll', function () {
            if (window.scrollY > 30) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        }, { passive: true });
    }

    // -------------------------------------------------------------------------
    // Initialize All Features on DOMContentLoaded
    // -------------------------------------------------------------------------
    document.addEventListener('DOMContentLoaded', function () {
        initTheme();
        initLanguage();
        initActiveNavLinks();
        initCounterAnimation();
        initNavbarScroll();
    });

})();
