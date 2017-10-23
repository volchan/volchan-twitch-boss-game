module Dashboard
  class DashboardsController < ApplicationController
    def index
      return if current_user.bot.nil?
      @bot = policy_scope(Bot.find_with_user(current_user))
      @logs = policy_scope(Log.find_with_bot(@bot).page(params[:page]).per(30))
    end
  end
end
