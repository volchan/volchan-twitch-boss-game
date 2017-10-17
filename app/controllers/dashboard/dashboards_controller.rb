module Dashboard
  class DashboardsController < ApplicationController
    def index
      return if current_user.bot.nil?
      @bot = policy_scope(Bot.find_with_user(current_user))
    end
  end
end
