class BotStatusJob < ApplicationJob
  queue_as :default

  def perform(bot)
    twitch_api_call = RestClient.get("http://tmi.twitch.tv/group/user/#{bot.channel}/chatters")
    parsed_twitch_api_call = JSON.parse(twitch_api_call, object_class: OpenStruct)
    moderator = parsed_twitch_api_call.chatters.moderators.include?(ENV['TWITCH_BOT_NAME'])
    viewer = parsed_twitch_api_call.chatters.viewers.include?(ENV['TWITCH_BOT_NAME'])
    connected = moderator || viewer ? '<i class="fa fa-check-circle text-success" aria-hidden="true"></i>' : '<i class="fa fa-times-circle text-danger" aria-hidden="true"></i>'
    mod = moderator ? '<i class="fa fa-check-circle text-success" aria-hidden="true"></i>' : '<i class="fa fa-times-circle text-danger" aria-hidden="true"></i>'
    ActionCable.server.broadcast("dashboard_#{bot.id}",
                                 connected: connected,
                                 moderator: mod)
  end
end
