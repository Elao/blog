let mix = require('laravel-mix');
var SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');

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
            new SWPrecacheWebpackPlugin(
                {
                    cacheId: 'elaoblog',
                    filepath: 'static/service-worker.js',
                    maximumFileSizeToCacheInBytes: 1048576,
                    minify: true,
                    runtimeCaching: [{
                        urlPattern: '/(.*)',
                        handler: 'cacheFirst',
                    }],
                    staticFileGlobs: [
                        'static/**/*.{js,css,png,jpg,gif,svg,eot,ttf,woff,woff2,otf}',
                        'static/favicon-16x16.png',
                    ],
                    stripPrefix: 'static/',
                }
            ),
        ]
    })
;
