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
    var animationEnd = "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend";
    this.addClass("animated" + animationName).one(animationEnd, function() {
        $(this).removeClass("animated" + animationName);
        $("#strike-anim").remove();
    });
    return this
  },
  animateFlashes: function (animationName) {
    var animationEnd = "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend";
    var flash = this;
    flash.addClass("animated" + animationName);
    setTimeout( function () {
      flash.addClass("animated slideOutRight").one(animationEnd, function () {
        flash.remove();
      });
    }, 5000);
  }
});

$(".tab-link").on("click", function(e){
  var tabId = $(this).attr("data-tab");
  $(".tab-link").removeClass("active");
  $(this).addClass("active");
  $(".tab-content").removeClass("active");
  $("#" + tabId).addClass("active");
  if (tabId == "logs") {
    $("#new-logs").addClass("hidden").html("0");
    logHiddenCounter = 0;
  }
});

function checkFlashes() {
  if ($(".alert").length > 0) {
    $(".alert").animateFlashes("slideInRight");
  }
}

$(document).ready(function(){
  var clipboard = new Clipboard(".clipboard-btn");

  $(".clipboard-btn").popover().click(function () {
    setTimeout(function () {
        $(".clipboard-btn").popover("hide");
    }, 2000);
  });

  checkFlashes();
});
