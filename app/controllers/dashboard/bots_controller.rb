class Dashboard::BotsController < ApplicationController
  before_action :set_bot, only: :update

  def new
    @bot = Bot.new
  end

  def create
    @bot = Bot.new(bot_params)
    @bot.user = current_user

    if @bot.save
      Boss.create!(
        bot: @bot,
        name: 'No boss yet!',
        current_hp: 0,
        max_hp: 0,
        current_shield: 0,
        max_shield: 0
      )
      redirect_to controller: :dashboards, action: :index
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @bot.update(bot_params)
        flash.now[:notice] = 'Successfully updated !'
        format.js { render 'dashboard/bots/update' }
      else
        format.json { render json: @bot.errors, status: :unprocessable_entity }
        format.js   { render layout: false, content_type: 'text/javascript' }
      end
    end
  end

  def delete; end

  private

  def set_bot
    @bot = Bot.find(params[:id])
  end

  def bot_params
    params.require(:bot).permit(:boss_max_hp, :boss_min_hp, :boss_hp_step, :channel , :sub_prime_modifier, :sub_five_modifier, :sub_ten_modifier, :sub_twenty_five_modifier, :bits_modifier)
  end
end
