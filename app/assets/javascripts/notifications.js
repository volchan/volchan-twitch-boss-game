function animateNotifications(animationName) {
  var animationEnd = "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend";
  var flash = $('.notification-container').children().first();
  flash.removeClass("hidden");
  flash.addClass("animated " + animationName).one(animationEnd, function () {
    flash.removeClass("animated " + animationName);
  });
  setTimeout( function () {
    flash.addClass("animated slideOutRight").one(animationEnd, function () {
      flash.remove();
    });
  }, 5000);
};

function checkNotifications() {
  if ($(".notification").length > 0) {
    animateNotifications("slideInRight");
  }
};

// $('.site').click(function (event) {
//   var targetDataDismiss = event.target.dataset.dismiss;
//   if (targetDataDismiss == "notification") {
//     $(event.target).closest(".notification").remove();
//   }
// });
//

function closeNotification() {
  $('.close[data-dismiss="notification"]').click(function () {
    $(this).closest(".notification").remove();
  });
};