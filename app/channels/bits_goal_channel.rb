class BitsGoalChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bits_goal_#{params[:user_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
