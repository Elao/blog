/**
 * service-worker.js is a generated file.
 * Please edit /themes/2015/service-worker/service-worker.template.js
 */

importScripts('/assets/js/workbox-sw.prod.js');

// Create Workbox service worker instance
const workboxSW = new WorkboxSW({ clientsClaim: true });

const MAX_AGE_SECONDS = 86400;
const FALLBACK_URL = '/en/offline/offline/';

// Placeholder array is populated automatically by workboxBuild.injectManifest()
workboxSW.precache([]);

const router = workboxSW.router;

router.setDefaultHandler({
  handler: workboxSW.strategies.cacheFirst({
    cacheExpiration: {
      maxAgeSeconds: MAX_AGE_SECONDS,
    },
  }),
});

router.setCatchHandler({
  handler: () => caches.match(FALLBACK_URL),
});
