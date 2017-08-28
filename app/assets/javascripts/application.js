//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require jquery-animatenumber
//= require jquery-circle-progress
//= require_tree .

$.fn.extend({
    animateCss: function (animationName) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        this.addClass('animated ' + animationName).one(animationEnd, function() {
            $(this).removeClass('animated ' + animationName);
            $('#strike-anim').remove();
        });
        return this;
    }
});
