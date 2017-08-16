class BotsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_bot, only: %i[show destroy check_token]
  before_action :check_token, only: %i[show]

  def index; end

  def show; end

  def new
    @bot = Bot.new
  end

  def create
    @bot = Bot.new(
      name: bot_params[:name],
      channel: bot_params[:channel],
      twitch_token: bot_params[:twitch_token],
      user: current_user
    )

    if @bot.save
      redirect_to @bot
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy
    @bot.destroy
    flash.now[:notice] = 'Succèssfully deleted !'
    redirect_to :root
  end

  private

  def bot_params
    params.require(:bot).permit(:name, :channel, :twitch_token)
  end

  def set_bot
    @bot = Bot.find(params[:id])
  end

  def check_token
    return unless params[:token].nil? || @bot.token != params[:token]
    flash.now[:atlert] = "You don't have access to this boss game !"
    redirect_to :root
  end
end
