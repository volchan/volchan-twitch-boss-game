class BossesController < ApplicationController
  before_action :set_boss
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:update]

  before_action :authenticate_token

  def update
    BossGameJob.perform_later(
      event: bosses_params,
      boss: @boss
    )
  end

  private

  def set_boss
    @boss = Boss.find(params[:id])
  end

  def authenticate_token
    bot = Bot.find(params[:bot_id])
    return unless params[:token].nil? || bot.token != params[:token]
    render :root
  end

  def bosses_params
    params.require(:event).permit(:event_type, :channel, :username, :type, :plan, :amount, :month, :message).to_h
  end
end
