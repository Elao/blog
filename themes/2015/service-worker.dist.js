/**
 * service-worker.js is a generated file.
 * Please edit service-worker.dist.js
 */

importScripts('/assets/js/workbox-sw.prod.js');

// Create Workbox service worker instance
const workboxSW = new WorkboxSW({ clientsClaim: true });

const networkTimeoutSeconds = 3;

// Placeholder array is populated automatically by workboxBuild.injectManifest()
workboxSW.precache([]);

workboxSW.router
  .registerRoute('/*', workboxSW.strategies.networkFirst({networkTimeoutSeconds: networkTimeoutSeconds}));

