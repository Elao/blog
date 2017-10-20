var $ = window.jQuery = require('jquery');

require('./owl.carousel.min');

$(document).ready(function(){
    $('.nav-button').on('click', function(){
        $(this).toggleClass('opened');
        $('#nav-overlay').toggleClass('visible');
        $('body').toggleClass('nav-opened');
    });

    $('.owl-carousel').owlCarousel({
        items: 1
    });

    var $block = $('.articles-list > article');

    $block.each(function(){
        if($(this).offset().top > $(window).scrollTop()+$(window).height()*0.90) {
            $(this).addClass('is-hidden');
        }
    });

    $(window).on('scroll', function(){
        $block.each(function(){
            if( $(this).offset().top <= $(window).scrollTop()+$(window).height()*0.90 && $(this).hasClass('is-hidden') ) {
                $(this).removeClass('is-hidden').addClass('is-animated');
            }
        });
    });

    var cpt = 0;
    $('.articles-list.compact').children('article').each(function(){
        cpt = cpt + 1;
        $('.articles-list.compact').find('.col-' + cpt).append($(this));
        if (cpt == 3) {
            cpt = 0;
        }
    });

});

$(window).load(function(){
    if ($('#read-progress').length > 0) {
        var documentHeight = $('#disqus_thread').offset().top;
        var windowHeight = $(window).height();
        var scrollTop = $(window).scrollTop();
        var offset = ($(window).width() > 767) ? 100 : 60;

        $('#read-progress').width($(window).width() - offset);

        scrollTop = $(window).scrollTop();
        var scrollPercent = (scrollTop) / (documentHeight - windowHeight);
        var pct = (scrollPercent < 1) ? scrollPercent * 100 : 100;
        $('#read-progress').find('div').css('width', pct + "%");

        $(window).resize(function(){
            documentHeight = $('#disqus_thread').offset().top;
            windowHeight = $(window).height();
            scrollTop = $(window).scrollTop();
            offset = ($(window).width() > 767) ? 100 : 60;

            $('#read-progress').width($(window).width() - offset);

            var scrollPercent = (scrollTop) / (documentHeight - windowHeight);
            var pct = (scrollPercent < 1) ? scrollPercent * 100 : 100;
            $('#read-progress').find('div').css('width', pct + "%");
        });

        $(window).on("scroll", function() {
            scrollTop = $(window).scrollTop();
            var scrollPercent = (scrollTop) / (documentHeight - windowHeight);
            var pct = (scrollPercent < 1) ? scrollPercent * 100 : 100;
            $('#read-progress').find('div').css('width', pct + "%");
        });
    }
});

(function() {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('/service-worker.js');
  }
})();
