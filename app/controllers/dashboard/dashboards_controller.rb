module Dashboard
  class DashboardsController < ApplicationController
    def index
      @logs = policy_scope(Log)
      return if current_user.bot.nil?
      @bot = policy_scope(Bot.find_by_user(current_user))
    end
  end
end
