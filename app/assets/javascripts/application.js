//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require jquery-animatenumber
//= require jquery-circle-progress
//= require clipboard
//= require_tree .

$.fn.extend({
    animateCss: function (animationName) {
        var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
        this.addClass('animated ' + animationName).one(animationEnd, function() {
            $(this).removeClass('animated ' + animationName)
            $('#strike-anim').remove()
        });
        return this
    }
});

$(".tab-link").on("click", function(e){
  var tab_id = $(this).attr('data-tab');
  $(".tab-link").removeClass('active');
  $(this).addClass('active');
  $('.tab-content').removeClass('active');
  $("#" + tab_id).addClass('active');
  if (tab_id == 'logs') {
    $('#new-logs').addClass('hidden').html('0');
    logHiddenCounter = 0;
  }
});

$(document).ready(function(){
  var clipboard = new Clipboard('.clipboard-btn');

  $('.clipboard-btn').popover().click(function () {
    setTimeout(function () {
        $('.clipboard-btn').popover('hide');
    }, 2000);
  });
});
