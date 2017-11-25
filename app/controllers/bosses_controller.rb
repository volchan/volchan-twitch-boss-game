class BossesController < ApplicationController
  before_action :set_boss
  before_action :authenticate_token

  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    BossGameJob.perform_later(
      script_bosses_params,
      @boss
    )
  end

  private

  def set_boss
    authorize @boss = Boss.find_boss(params[:id])
  end

  def authenticate_token
    return unless params[:token].nil? || @boss.token != params[:token]
    render :root
  end

  def script_bosses_params
    params.require(:event).permit(:event_type,
                                  :channel,
                                  :username,
                                  :gifted_to,
                                  :type,
                                  :plan,
                                  :amount,
                                  :month,
                                  :message).to_h
  end
end
