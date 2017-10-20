//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require jquery-animatenumber
//= require jquery-circle-progress
//= require clipboard
//= require_tree .

const animateCss = (animationName) => {
  let animationEnd = "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend";
  $(".boss").addClass("animated " + animationName).one(animationEnd, () => {
      $(".boss").removeClass("animated " + animationName);
      $("#strike-anim").remove();
  });
  return this;
}

$(".tab-link").on("click", (e) => {
  let tabId = $(e.target).attr("data-tab");
  $(".tab-link").removeClass("active");
  $(e.target).addClass("active");
  $(".tab-content").removeClass("active");
  $("#" + tabId).addClass("active");
  if (tabId === "logs") {
    $("#new-logs").addClass("hidden").html("0");
    logHiddenCounter = 0;
  }
});

$(document).ready(function(){
  let clipboard = new Clipboard(".clipboard-btn");

  $(".clipboard-btn").popover().click(() => {
    setTimeout(() => {
        $(".clipboard-btn").popover("hide");
    }, 2000);
  });

  checkNotifications();
  closeNotification();
});
