const CopyWebpackPlugin = require('copy-webpack-plugin');
const WorkboxBuildWebpackPlugin = require('workbox-webpack-plugin');

let mix = require('laravel-mix');

mix
    .options({
        clearConsole: false
    })
    .sourceMaps(false)
    .setResourceRoot('/assets/')
    .setPublicPath('static/assets')
    .js('assets/js/app.js', 'js')
    .sass('assets/sass/app.scss', 'css')
;

if (mix.inProduction()) {
  mix
    .webpackConfig({
      plugins: [
        new WorkboxBuildWebpackPlugin({
          // Preload assets
          globDirectory: 'static',
          globPatterns: ['**\/*.{js,css,jpg,svg,png,gif}'],
          // Preload offline page
          templatedUrls: {
            '/en/offline/offline/': [
              '../../../content/offline/offline.en.md',
              '../layouts/offline/single.html'
            ]
          },
          // Build service worker
          swDest: 'static/service-worker.js',
          swSrc: 'assets/service-worker.template.js'
        }),
        new CopyWebpackPlugin([
          // Copy WorkboxSW production build file to assets/js/workbox-sw.prod.js, needed by service worker
          {
            from: require.resolve('workbox-sw'),
            to: 'js/workbox-sw.prod.js'
          }
        ]),
      ]
    })
  ;
}
