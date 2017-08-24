class BossGamesController < ApplicationController

  skip_before_action :authenticate_user!

  before_action :authenticate_token

  def create_boss
    BossGame.create(boss_game_params)
  end

  def update_boss
    boss_game = BossGame.find(params[:id])
    boss_game.update(boss_game_params)
  end

  def current_hp
    boss_game = BossGame.find(params[:id])
    boss_game.update(params[:current_hp])
  end

  def shield
    boss_game = BossGame.find(params[:id])
    boss_game.update(params[:shield])
  end


  private

  def authenticate_token
    bot = Bot.find(params[:bot_id].to_i)
    return unless params[:token].nil? || bot.token != params[:token]
    render :root
  end

  def boss_game_params
    {
      bot: Bot.find(params[:bot_id]),
      name: params[:name],
      max_hp: params[:max_hp],
      current_hp: params[:current_hp],
      shield: params[:shield],
      avatar: params[:avatar]
    }
  end
end
