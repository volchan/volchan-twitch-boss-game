module Dashboard
  class DashboardsController < ApplicationController
    def index
      @bot = current_user.bot
    end
  end
end
