module ApplicationHelper
  def connected_in_chat?(channel)
    link = "http://tmi.twitch.tv/group/user/#{channel}/chatters"
    twitch_api_call = api_call(link)
    parsed_twitch_api_call = parse_call(twitch_api_call)
    moderator?(parsed_twitch_api_call) || viewer?(parsed_twitch_api_call)
  end

  def moderator_in_chat?(channel)
    link = "http://tmi.twitch.tv/group/user/#{channel}/chatters"
    twitch_api_call = api_call(link)
    parsed_twitch_api_call = parse_call(twitch_api_call)
    moderator?(parsed_twitch_api_call)
  end
  
  def api_call(link)
    RestClient.get(link)
  end
  
  def parse_call(call)
    JSON.parse(call, object_class: OpenStruct)
  end
  
  def moderator?(parsed_call)
    parsed_call.chatters.moderators.include?(ENV['TWITCH_BOT_NAME'])
  end
  
  def viewer?(parsed_call)
    parsed_call.chatters.viewers.include?(ENV['TWITCH_BOT_NAME'])
  end
end
