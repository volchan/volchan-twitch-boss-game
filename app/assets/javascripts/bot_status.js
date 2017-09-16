$.ajax({
  type: "GET",
  url: "http://tmi.twitch.tv/group/user/" + $('#bot-connected').data('channel') + "/chatters",
  success: function(data) {
    console.log(data);
  },
  error: function(jqXHR) {
    console.error(jqXHR.responseText);
  }
});
