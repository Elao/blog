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
