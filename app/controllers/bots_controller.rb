class BotsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  before_action :set_bot, only: %i[show destroy check_token]
  before_action :check_token, only: %i[show]

  def index
    @bots = Bot.all
    unless current_user.admin?
      flash[:alert] = 'You don\'t have access to this page !'
      redirect_to :root
    end
  end

  def show; end

  def new
    @bot = Bot.new
  end

  def create
    @bot = Bot.new(
      channel: bot_params[:channel],
      boss_max_hp: bot_params[:boss_max_hp],
      boss_min_hp: bot_params[:boss_min_hp],
      boss_hp_step: bot_params[:boss_hp_step],
      user: current_user
    )

    if @bot.save
      Boss.create!(
        bot: @bot,
        name: 'No boss yet!',
        current_hp: 0,
        max_hp: 0,
        current_shield: 0,
        max_shield: 0
      )
      redirect_to controller: :bots, action: :show, id: @bot.id, token: @bot.token
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy
    @bot.destroy
    flash[:notice] = 'Succèssfully deleted !'
    redirect_to :root
  end

  private

  def bot_params
    params.require(:bot).permit(:boss_max_hp, :boss_min_hp, :boss_hp_step, :channel)
  end

  def set_bot
    @bot = Bot.find(params[:id])
  end

  def check_token
    return unless params[:token].blank? || @bot.token != params[:token]
    flash[:alert] = "You don't have access to this boss game !"
    redirect_to :root
  end
end
