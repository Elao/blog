const CopyWebpackPlugin = require('copy-webpack-plugin');
const WorkboxBuildWebpackPlugin = require('workbox-webpack-plugin');

let mix = require('laravel-mix');
mix
    .setResourceRoot('/assets/')
    .setPublicPath('static/assets')
    .sourceMaps(false)
    .options({
        clearConsole: false
    })
    .js('assets/js/app.js', 'js')
    .sass('assets/sass/app.scss', 'css')
;

if (mix.inProduction()) {
  mix
    .webpackConfig({
      plugins: [
        new WorkboxBuildWebpackPlugin({
          // preload assets
          globDirectory: 'static',
          globPatterns: ['**\/*.{js,css,jpg,svg,png,gif}'],
          // preload offline page
          templatedUrls: {
            '/en/offline/offline/': [
              '../../../content/offline/offline.en.md',
              '../layouts/offline/single.html'
            ]
          },
          // build service worker
          swDest: 'static/service-worker.js',
          swSrc: 'assets/service-worker.template.js'
        }),
        new CopyWebpackPlugin([
          // copy WorkboxSW production build file to assets/js/workbox-sw.prod.js, needed by service worker
          {
            from: require.resolve('workbox-sw'),
            to: 'js/workbox-sw.prod.js'
          }
        ]),
      ]
    })
  ;
}
