class BotsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  before_action :set_bot, only: %i[show]
  before_action :check_token, only: %i[show]

  def show
    render layout: 'on_stream'
  end

  private

  def set_bot
    authorize @bot = Bot.find_bot(params[:id])
  end

  def check_token
    return unless params[:token].blank? || @bot.token != params[:token]
    flash[:alert] = "You don't have access to this boss game !"
    redirect_to :root
  end
end
