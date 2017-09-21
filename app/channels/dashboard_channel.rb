class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard_#{params[:bot_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
