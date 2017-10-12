class BotStatusJob < ApplicationJob
  queue_as :default

  def perform(bot)
    parsed_twitch_api_call = call_api(bot)
    moderator = moderator?(parsed_twitch_api_call)
    viewer = viewer?(parsed_twitch_api_call)
    connected = moderator || viewer ? success : danger
    mod = moderator ? success : danger
    alert = render_alert(moderator, viewer) unless moderator || viewer
    send_to_dashboard(bot, connected, mod, alert)
  end

  def call_api(bot)
    twitch_api_call = RestClient.get(
      "http://tmi.twitch.tv/group/user/#{bot.channel}/chatters"
    )
    JSON.parse(twitch_api_call, object_class: OpenStruct)
  end

  def moderator?(parsed_twitch_api_call)
    parsed_twitch_api_call.chatters.moderators.include?(ENV['TWITCH_BOT_NAME'])
  end

  def viewer?(parsed_twitch_api_call)
    parsed_twitch_api_call.chatters.viewers.include?(ENV['TWITCH_BOT_NAME'])
  end

  def success
    '<i class="fa fa-check-circle text-success" aria-hidden="true"></i>'
  end

  def danger
    '<i class="fa fa-times-circle text-danger" aria-hidden="true"></i>'
  end

  def render_alert(moderator, viewer)
    alert = alert_string(moderator, viewer)
    ApplicationController.new.render_to_string(
      partial: 'flashes/alert',
      locals: { alert: alert },
      layout: false
    )
  end

  def alert_string(moderator, viewer)
    return "#{ENV['TWITCH_BOT_NAME']} is not connected !" unless viewer
    "Please mod #{ENV['TWITCH_BOT_NAME']} in your chat !" unless moderator
  end

  def send_to_dashboard(bot, connected, mod, alert)
    ActionCable.server.broadcast("dashboard_#{bot.id}",
                                 connected: connected,
                                 moderator: mod,
                                 alert: alert)
  end
end
