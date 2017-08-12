class BossGameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "boss_game_#{params[:bot_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
