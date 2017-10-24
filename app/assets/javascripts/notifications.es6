const animateNotifications = (animationName) => {
  let animationEnd = "webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend";
  let flash = $(".notification-container").children().first();
  flash.removeClass("hidden");
  flash.addClass("animated " + animationName).one(animationEnd, () => {
    flash.removeClass("animated " + animationName);
  });
  setTimeout( () => {
    flash.addClass("animated slideOutRight").one(animationEnd, () => {
      flash.remove();
    });
  }, 5000);
}

const checkNotifications = () => {
  if ($(".notification").length > 0) {
    animateNotifications("slideInRight");
  }
}

const closeNotification = () => {
  $(".close[data-dismiss='notification']").click((e) => {
    $(e.target).closest(".notification").remove();
  });
}
