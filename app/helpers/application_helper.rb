module ApplicationHelper
  def connected_in_chat?(channel)
    twitch_api_call = RestClient.get("http://tmi.twitch.tv/group/user/#{channel}/chatters")
    parsed_twitch_api_call = JSON.parse(twitch_api_call, object_class: OpenStruct)
    moderator = parsed_twitch_api_call.chatters.moderators.include?(ENV['TWITCH_BOT_NAME'])
    viewer = parsed_twitch_api_call.chatters.viewers.include?(ENV['TWITCH_BOT_NAME'])
    moderator || viewer
  end

  def moderator_in_chat?(channel)
    twitch_api_call = RestClient.get("http://tmi.twitch.tv/group/user/#{channel}/chatters")
    parsed_twitch_api_call = JSON.parse(twitch_api_call, object_class: OpenStruct)
    parsed_twitch_api_call.chatters.moderators.include?(ENV['TWITCH_BOT_NAME'])
  end
end
