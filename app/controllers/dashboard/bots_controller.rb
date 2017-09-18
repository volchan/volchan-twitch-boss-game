class Dashboard::BotsController < ApplicationController
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
  def update; end
  def delete; end
end
