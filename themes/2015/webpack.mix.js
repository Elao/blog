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
    .webpackConfig({
        plugins: [
            new WorkboxBuildWebpackPlugin({
                globDirectory: 'static',
                globPatterns: ['**\/*.{js,css,jpg,svg,png,gif}'],
                swDest: 'static/service-worker.js',
                swSrc: 'service-worker.dist.js'
            }),
            new CopyWebpackPlugin([
                // copy WorkboxSW production build file to assets/js/workbox-sw.prod.js
                {
                  from: require.resolve('workbox-sw'),
                  to: 'js/workbox-sw.prod.js'
                }
            ]),
        ]
    })
;
