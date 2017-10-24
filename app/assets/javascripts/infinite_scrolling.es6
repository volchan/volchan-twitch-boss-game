if ($("#logs-container").length > 0) {
  $("#logs").on("scroll", () => {
    var elem = $("#logs");
    var moreLogsUrl = $(".next-page").attr("href");
    var doneScrolling = elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight();
    if (moreLogsUrl && doneScrolling) {
      $("#logs-container").append("<div class='waiting-log'></div>\
        <div class='waiting-log'></div>\
        <div class='waiting-log'></div>\
        <div class='waiting-log'></div>\
        <div class='waiting-log'></div>\
      ");
      $(".pagination").html("Loading...");
      $.getScript(moreLogsUrl);
    }
  });
}
