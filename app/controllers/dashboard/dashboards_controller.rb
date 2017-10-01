module Dashboard
  class DashboardsController < ApplicationController
    def index
      @bot = policy_scope(Bot.find_by(user: current_user))
      @logs = policy_scope(Log)
    end
  end
end
