class BotsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  before_action :set_bot, only: %i[show edit update destroy check_token]
  before_action :check_token, only: %i[show]

  def index
    @bots = Bot.all
    unless current_user.admin?
      flash[:alert] = 'You don\'t have access to this page !'
      redirect_to :root
    end
  end

  def show
    render layout: 'on_stream'
  end

  def new
    @bot = Bot.new
  end

  def create
    @bot = Bot.new(
      channel: bot_params[:channel],
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

  def update
    if @bot.update(bot_params)
      redirect_to controller: :bots, action: :show, id: @bot.id, token: @bot.token
    else
      render :edit
    end
  end

  def destroy
    @bot.destroy
    flash[:notice] = 'Succèssfully deleted !'
    redirect_to :root
  end

  private

  def bot_params
    params.require(:bot).permit(:boss_max_hp, :boss_min_hp, :boss_hp_step, :channel , :sub_prime_modifier, :sub_five_modifier, :sub_ten_modifier, :sub_twenty_five_modifier, :bits_modifier)
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
