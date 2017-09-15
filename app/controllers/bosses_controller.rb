class BossesController < ApplicationController
  before_action :set_boss
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:update]

  before_action :authenticate_token

  def update
    if params[:authenticity_token].present?
      BossGameJob.perform_later(
        {
          event_type: 'update from dashboard',
          name: bosses_params[:name],
          current_hp: bosses_params[:current_hp],
          max_hp: bosses_params[:max_hp],
          current_shield: bosses_params[:current_shield],
          max_shield: bosses_params[:max_shield]
        },
        @boss
      )
    else
      BossGameJob.perform_later(
        script_bosses_params,
        @boss
      )
    end
  end

  private

  def set_boss
    @boss = Boss.find(params[:id])
  end

  def authenticate_token
    return if params[:authenticity_token].present? && :verify_authenticity_token
    return unless params[:token].nil? || @boss.token != params[:token]
    render :root
  end

  def bosses_params
    params.require(:boss).permit(:name, :current_hp, :max_hp, :current_shield, :max_shield)
  end

  def script_bosses_params
    params.require(:event).permit(:event_type, :channel, :username, :type, :plan, :amount, :month, :message).to_h
  end
end
