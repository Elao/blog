console.log('%c Init project ', 'background: #4CAf50; color: #FFF;');

$(document).ready(function(){
    $('.nav-button').on('click', function(){
        $(this).toggleClass('opened');
        $('#nav-overlay').toggleClass('visible');
        $('body').toggleClass('nav-opened');
    });

    $('.owl-carousel').owlCarousel({
        items: 1
    });
});
