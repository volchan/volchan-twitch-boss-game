class Dashboard::DashboardsController < ApplicationController
  def index
    @bot = current_user.bot
  end
end
