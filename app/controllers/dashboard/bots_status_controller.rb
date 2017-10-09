module Dashboard
  class BotsStatusController < ApplicationController
    def index
      bot = policy_scope(Bot.find_bot(params[:bot_id]))
      BotStatusJob.perform_later(bot)
    end
  end
end
