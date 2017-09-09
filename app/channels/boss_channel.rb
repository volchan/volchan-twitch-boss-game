class BossChannel < ApplicationCable::Channel
  def subscribed
    stream_from "boss_#{params[:bot_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
