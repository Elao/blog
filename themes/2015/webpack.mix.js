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
