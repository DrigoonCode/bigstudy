const CACHE_NAME = 'bigstudy-v1';
const ASSETS_TO_CACHE = [
  '/',
  '/index.html',
  '/public/css/styles.css',
  '/public/js/utils.js',
  '/public/js/supabase-client.js',
  '/manifest.json'
];

// Install event: cache core assets
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      // We don't fail immediately if some assets are missing
      return cache.addAll(ASSETS_TO_CACHE).catch(err => console.warn('SW Cache error', err));
    })
  );
  self.skipWaiting();
});

// Activate event: clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.filter(name => name !== CACHE_NAME).map(name => caches.delete(name))
      );
    })
  );
  self.clients.claim();
});

// Fetch event: network first, fallback to cache for HTML, cache first for static assets
self.addEventListener('fetch', event => {
  // Only handle GET requests
  if (event.request.method !== 'GET') return;
  // Ignore Supabase API calls from caching
  if (event.request.url.includes('supabase.co')) return;

  event.respondWith(
    caches.match(event.request).then(cachedResponse => {
      // If it's a static asset (css, js, images), return from cache if present, otherwise fetch
      if (cachedResponse && (event.request.url.includes('/public/') || event.request.url.includes('manifest'))) {
        return cachedResponse;
      }
      
      // For navigation (HTML), try network first, then cache
      return fetch(event.request).then(response => {
        // Cache the dynamically fetched resources too if they are static
        if (response.ok && event.request.url.startsWith(self.location.origin)) {
          const clone = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, clone).catch(e => {});
          });
        }
        return response;
      }).catch(() => {
        // Fallback to cache if network fails
        return cachedResponse || caches.match('/index.html');
      });
    })
  );
});
