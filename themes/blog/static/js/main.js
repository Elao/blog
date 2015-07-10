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


    if ($('#read-progress').length > 0) {
        var documentHeight = $(document).height();
        var windowHeight = $(window).height();
        var scrollTop = $(window).scrollTop();

        $('#read-progress').width($(window).width() - 100);

        scrollTop = $(window).scrollTop();
        var scrollPercent = (scrollTop) / (documentHeight - windowHeight);
        var pct = scrollPercent * 100;
        $('#read-progress div').css('width', pct + "%");

        $(window).resize(function(){
            documentHeight = $(document).height();
            windowHeight = $(window).height();
            scrollTop = $(window).scrollTop();

            $('#read-progress').width($(window).width() - 100);

            var scrollPercent = (scrollTop) / (documentHeight - windowHeight);
            var pct = scrollPercent * 100;
            $('#read-progress div').css('width', pct + "%");
        });

        $(window).on("scroll", function() {
            scrollTop = $(window).scrollTop();
            var scrollPercent = (scrollTop) / (documentHeight - windowHeight);
            var pct = scrollPercent * 100;
            $('#read-progress div').css('width', pct + "%");
        });
    }
});
