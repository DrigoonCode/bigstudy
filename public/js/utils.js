// BigStudy Utility Functions

// DOM Utilities
function getElement(selector) {
  return document.querySelector(selector);
}

function getElements(selector) {
  return document.querySelectorAll(selector);
}

function createElement(tag, className = '', html = '') {
  const element = document.createElement(tag);
  if (className) element.className = className;
  if (html) element.innerHTML = html;
  return element;
}

function showElement(selector) {
  const el = typeof selector === 'string' ? getElement(selector) : selector;
  if (el) el.classList.remove('hidden');
}

function hideElement(selector) {
  const el = typeof selector === 'string' ? getElement(selector) : selector;
  if (el) el.classList.add('hidden');
}

function toggleElement(selector) {
  const el = typeof selector === 'string' ? getElement(selector) : selector;
  if (el) el.classList.toggle('hidden');
}

function addClass(selector, className) {
  const el = typeof selector === 'string' ? getElement(selector) : selector;
  if (el) el.classList.add(className);
}

function removeClass(selector, className) {
  const el = typeof selector === 'string' ? getElement(selector) : selector;
  if (el) el.classList.remove(className);
}

function hasClass(selector, className) {
  const el = typeof selector === 'string' ? getElement(selector) : selector;
  return el ? el.classList.contains(className) : false;
}

// Modal Functions
function openModal(modalId) {
  const modal = getElement(modalId);
  if (modal) addClass(modal, 'active');
}

function closeModal(modalId) {
  const modal = getElement(modalId);
  if (modal) removeClass(modal, 'active');
}

function closeAllModals() {
  const modals = getElements('.modal');
  modals.forEach(modal => removeClass(modal, 'active'));
}

// Form Utilities
function getFormData(formSelector) {
  const form = typeof formSelector === 'string' ? getElement(formSelector) : formSelector;
  if (!form) return null;

  const formData = new FormData(form);
  const data = {};
  for (let [key, value] of formData.entries()) {
    data[key] = value;
  }
  return data;
}

function setFormData(formSelector, data) {
  const form = typeof formSelector === 'string' ? getElement(formSelector) : formSelector;
  if (!form) return;

  Object.entries(data).forEach(([key, value]) => {
    const input = form.querySelector(`[name="${key}"]`);
    if (input) {
      if (input.type === 'checkbox') {
        input.checked = value;
      } else if (input.type === 'radio') {
        form.querySelector(`[name="${key}"][value="${value}"]`).checked = true;
      } else {
        input.value = value;
      }
    }
  });
}

function clearForm(formSelector) {
  const form = typeof formSelector === 'string' ? getElement(formSelector) : formSelector;
  if (form) form.reset();
}

function validateEmail(email) {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return regex.test(email);
}

function validatePassword(password) {
  return password.length >= 8;
}

// Notification/Alert Functions
function showNotification(message, type = 'info', duration = 5000) {
  const alertClass = `alert alert-${type}`;
  const alert = createElement('div', alertClass, `
    <span>${message}</span>
  `);
  
  const container = getElement('body');
  container.insertBefore(alert, container.firstChild);
  
  if (duration > 0) {
    setTimeout(() => alert.remove(), duration);
  }
  
  return alert;
}

function showError(message) {
  return showNotification(message, 'error', 5000);
}

function showSuccess(message) {
  return showNotification(message, 'success', 5000);
}

function showWarning(message) {
  return showNotification(message, 'warning', 5000);
}

// Loading Utilities
function showLoading(containerSelector) {
  const container = typeof containerSelector === 'string' ? getElement(containerSelector) : containerSelector;
  if (!container) return;
  
  addClass(container, 'loading');
  container.innerHTML = '<div class="spinner"></div>';
}

function hideLoading(containerSelector) {
  const container = typeof containerSelector === 'string' ? getElement(containerSelector) : containerSelector;
  if (container) removeClass(container, 'loading');
}

// Navigation
function updateActiveNav(selector) {
  const links = getElements('.navbar-menu a');
  links.forEach(link => removeClass(link, 'active'));
  
  const activeLink = getElement(selector);
  if (activeLink) addClass(activeLink, 'active');
}

function navigateTo(path) {
  window.location.href = path;
}

// Local Storage
function saveToStorage(key, value) {
  try {
    localStorage.setItem(key, JSON.stringify(value));
    return true;
  } catch (error) {
    console.error('[Storage] Error saving:', error);
    return false;
  }
}

function getFromStorage(key) {
  try {
    const item = localStorage.getItem(key);
    return item ? JSON.parse(item) : null;
  } catch (error) {
    console.error('[Storage] Error reading:', error);
    return null;
  }
}

function removeFromStorage(key) {
  try {
    localStorage.removeItem(key);
    return true;
  } catch (error) {
    console.error('[Storage] Error removing:', error);
    return false;
  }
}

// Date Utilities
function formatDate(date) {
  const d = new Date(date);
  return d.toLocaleDateString('en-IN', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
}

function formatDateTime(date) {
  const d = new Date(date);
  return d.toLocaleDateString('en-IN') + ' ' + d.toLocaleTimeString('en-IN');
}

function getDaysUntil(targetDate) {
  const today = new Date();
  const target = new Date(targetDate);
  const diff = target - today;
  return Math.ceil(diff / (1000 * 60 * 60 * 24));
}

// String Utilities
function truncate(str, length = 100) {
  if (!str) return '';
  return str.length > length ? str.substring(0, length) + '...' : str;
}

function capitalize(str) {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1);
}

function slugify(str) {
  return str
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-');
}

// Array Utilities
function chunk(arr, size) {
  const chunks = [];
  for (let i = 0; i < arr.length; i += size) {
    chunks.push(arr.slice(i, i + size));
  }
  return chunks;
}

function unique(arr) {
  return [...new Set(arr)];
}

function sortBy(arr, key) {
  return arr.sort((a, b) => {
    if (a[key] < b[key]) return -1;
    if (a[key] > b[key]) return 1;
    return 0;
  });
}

// Rating/Star Rendering
function renderStars(rating, maxRating = 5) {
  const fullStars = Math.floor(rating);
  const hasHalfStar = rating % 1 !== 0;
  let stars = '★'.repeat(fullStars);
  if (hasHalfStar) stars += '✦';
  return stars + '☆'.repeat(maxRating - Math.ceil(rating));
}

// Format Currency
function formatCurrency(amount) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    minimumFractionDigits: 0
  }).format(amount);
}

// Format Number with separators
function formatNumber(num) {
  return new Intl.NumberFormat('en-IN').format(num);
}

// Debounce function
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Throttle function
function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// API call wrapper
async function apiCall(url, options = {}) {
  try {
    const response = await fetch(url, options);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    console.error('[API] Error:', error);
    throw error;
  }
}

// Check Authentication
function isLoggedIn() {
  return supabase.isAuthenticated();
}

function getCurrentUser() {
  const session = supabase.getSession();
  return session ? session.user : null;
}

function requireLogin() {
  if (!isLoggedIn()) {
    showError('Please sign in to continue');
    navigateTo('/pages/auth/signin.html');
    return false;
  }
  return true;
}

// Automatically update navbar if user is logged in
function updateNavbarAuth() {
  if (!isLoggedIn()) return;

  const actions = getElement('.navbar-actions');
  if (!actions) return;

  const user = getCurrentUser();
  const name = user?.user_metadata?.full_name || user?.email || 'User';
  const initials = name.split(' ').map(w => w[0]).join('').substring(0, 2).toUpperCase();

  // Remove existing auth links (Sign In / Get Started)
  actions.querySelectorAll('a[href*="/auth/"]').forEach(l => l.remove());

  // Skip if already injected
  if (actions.querySelector('.auth-menu')) return;

  const navToggle = actions.querySelector('.nav-toggle');

  const menu = document.createElement('div');
  menu.className = 'auth-menu';
  menu.style.cssText = 'position:relative; display:inline-block;';
  menu.innerHTML = `
    <button class="auth-avatar-btn" style="
      width:36px; height:36px; border-radius:50%;
      background:linear-gradient(135deg,var(--primary),#0f3028);
      color:white; font-size:0.85rem; font-weight:700;
      border:none; cursor:pointer;
      display:flex; align-items:center; justify-content:center;
    " onclick="toggleAuthMenu(event)">${initials}</button>
    <div id="authDropdown" style="
      display:none; position:absolute; right:0; top:44px;
      background:white; border-radius:10px; min-width:200px;
      box-shadow:0 8px 30px rgba(0,0,0,0.15); z-index:999;
      border:1px solid #eee; overflow:hidden;
    ">
      <div style="padding:0.85rem 1rem; border-bottom:1px solid #f0f0f0;">
        <div style="font-weight:700; font-size:0.9rem;">${name.split(' ')[0]}</div>
        <div style="color:#888; font-size:0.78rem;">${user?.email || ''}</div>
      </div>
      <a href="/pages/dashboard/index.html"         style="display:flex;align-items:center;gap:0.6rem;padding:0.7rem 1rem;color:#333;font-size:0.88rem;text-decoration:none;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background=''">🏠 Dashboard</a>
      <a href="/pages/dashboard/applications.html"  style="display:flex;align-items:center;gap:0.6rem;padding:0.7rem 1rem;color:#333;font-size:0.88rem;text-decoration:none;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background=''">📝 My Applications</a>
      <a href="/pages/dashboard/favorites.html"     style="display:flex;align-items:center;gap:0.6rem;padding:0.7rem 1rem;color:#333;font-size:0.88rem;text-decoration:none;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background=''">❤️ Saved Colleges</a>
      <a href="/pages/dashboard/profile.html"       style="display:flex;align-items:center;gap:0.6rem;padding:0.7rem 1rem;color:#333;font-size:0.88rem;text-decoration:none;" onmouseover="this.style.background='#f5f5f5'" onmouseout="this.style.background=''">👤 Edit Profile</a>
      <div style="border-top:1px solid #f0f0f0;">
        <a href="javascript:void(0)" onclick="supabase.signOut()" style="display:flex;align-items:center;gap:0.6rem;padding:0.7rem 1rem;color:#e53935;font-size:0.88rem;text-decoration:none;" onmouseover="this.style.background='#fff5f5'" onmouseout="this.style.background=''">🚪 Logout</a>
      </div>
    </div>
  `;

  if (navToggle) {
    actions.insertBefore(menu, navToggle);
  } else {
    actions.appendChild(menu);
  }

  // Close dropdown when click outside
  document.addEventListener('click', function(e) {
    const dd = document.getElementById('authDropdown');
    if (dd && !menu.contains(e.target)) dd.style.display = 'none';
  });
}

function toggleAuthMenu(e) {
  e.stopPropagation();
  const dd = document.getElementById('authDropdown');
  if (dd) dd.style.display = dd.style.display === 'none' ? 'block' : 'none';
}

document.addEventListener('DOMContentLoaded', updateNavbarAuth);

// Export for use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    getElement, getElements, createElement,
    showElement, hideElement, toggleElement,
    addClass, removeClass, hasClass,
    openModal, closeModal, closeAllModals,
    getFormData, setFormData, clearForm,
    validateEmail, validatePassword,
    showNotification, showError, showSuccess, showWarning,
    showLoading, hideLoading,
    updateActiveNav, navigateTo,
    saveToStorage, getFromStorage, removeFromStorage,
    formatDate, formatDateTime, getDaysUntil,
    truncate, capitalize, slugify,
    chunk, unique, sortBy,
    renderStars, formatCurrency, formatNumber,
    debounce, throttle, apiCall,
    isLoggedIn, getCurrentUser, requireLogin
  };
}

// ==========================================
// PWA & Service Worker
// ==========================================
let deferredPrompt;

if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then(reg => console.log('[PWA] Service Worker registered with scope:', reg.scope))
      .catch(err => console.log('[PWA] Service Worker registration failed:', err));
  });
}

window.addEventListener('beforeinstallprompt', (e) => {
  // Prevent the mini-infobar from appearing on mobile
  e.preventDefault();
  deferredPrompt = e;

  // Show installation prompt
  showInstallBanner();
});

function showInstallBanner() {
  if (document.getElementById('pwa-install-banner')) return;

  const banner = document.createElement('div');
  banner.id = 'pwa-install-banner';
  banner.style.cssText = `
    position: fixed;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    background: white;
    padding: 1rem;
    border-radius: 12px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.2);
    z-index: 10000;
    display: flex;
    align-items: center;
    gap: 1rem;
    width: 90%;
    max-width: 350px;
    font-family: 'Inter', sans-serif;
    animation: slideUp 0.4s ease;
  `;

  banner.innerHTML = `
    <style>@keyframes slideUp { from { bottom: -100px; opacity: 0; } to { bottom: 20px; opacity: 1; } }</style>
    <div style="flex:1;">
      <h4 style="margin:0 0 0.2rem; font-size:0.95rem; font-weight:700; color:#333;">Install BigStudy App</h4>
      <p style="margin:0; font-size:0.8rem; color:#666;">Add to your home screen for quick access.</p>
    </div>
    <div style="display:flex; flex-direction:column; gap:0.4rem;">
      <button id="pwa-install-btn" style="background:var(--primary); color:white; border:none; padding:0.4rem 0.8rem; border-radius:6px; font-weight:600; font-size:0.8rem; cursor:pointer;">Install</button>
      <button id="pwa-dismiss-btn" style="background:transparent; color:#888; border:none; padding:0.2rem; font-size:0.75rem; cursor:pointer;">Not now</button>
    </div>
  `;

  document.body.appendChild(banner);

  document.getElementById('pwa-install-btn').addEventListener('click', async () => {
    banner.remove();
    if (deferredPrompt) {
      deferredPrompt.prompt();
      const { outcome } = await deferredPrompt.userChoice;
      console.log(`[PWA] User response to install prompt: ${outcome}`);
      deferredPrompt = null;
    }
  });

  document.getElementById('pwa-dismiss-btn').addEventListener('click', () => {
    banner.remove();
  });
}
